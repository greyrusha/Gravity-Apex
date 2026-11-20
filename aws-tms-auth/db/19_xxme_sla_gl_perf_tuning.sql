-- Wave 2: SQL performance tuning for XXME_GL_SUMMARY_PKG, XXME_AP_AR_DETAIL_PKG,
--         XXME_AP_AR_KPI_PKG, and XXME_SLA_SUMMARY_PKG.
-- Goals:
--   1. Achieve full @ADG remote pushdown (SELECT STATEMENT REMOTE) by removing local
--      MATERIALIZE CTEs, local DUAL/SYSDATE references, and parameters CTEs.
--   2. Replace heavy org_organization_definitions@ADG with hr_all_organization_units_tl@ADG.
--   3. Short-circuit future periods (where LEAST(end_date, TRUNC(SYSDATE)) + 1 <= start_date).
--   4. Delegate XXME_AP_AR_KPI_PKG.get_cards to XXME_AP_AR_DETAIL_PKG.get_summary.

set define off

CREATE OR REPLACE PACKAGE BODY xxme_gl_summary_pkg
AS
    FUNCTION get_summary (
        p_period_name IN VARCHAR2,
        p_db_link     IN VARCHAR2
    ) RETURN xxme_gl_summary_row_nt PIPELINED
    IS
        l_db_link                    VARCHAR2(30) := xxme_db_source_pkg.normalize_db_link(p_db_link);
        l_period_name                VARCHAR2(15);
        l_period_literal             VARCHAR2(40);
        l_period_count               PLS_INTEGER;
        l_refresh_ts                 DATE := SYSDATE;
        l_sql                        CLOB;
        l_rc                         SYS_REFCURSOR;
        l_cursor_open                BOOLEAN := FALSE;

        c_fetch_limit                CONSTANT PLS_INTEGER := 500;

        TYPE t_number_tab IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
        TYPE t_date_tab IS TABLE OF DATE INDEX BY PLS_INTEGER;
        TYPE t_varchar1_tab IS TABLE OF VARCHAR2(1) INDEX BY PLS_INTEGER;
        TYPE t_varchar10_tab IS TABLE OF VARCHAR2(10) INDEX BY PLS_INTEGER;
        TYPE t_varchar15_tab IS TABLE OF VARCHAR2(15) INDEX BY PLS_INTEGER;
        TYPE t_varchar40_tab IS TABLE OF VARCHAR2(40) INDEX BY PLS_INTEGER;
        TYPE t_varchar240_tab IS TABLE OF VARCHAR2(240) INDEX BY PLS_INTEGER;

        l_ledger_ids                 t_number_tab;
        l_ledger_names               t_varchar240_tab;
        l_result_period_names        t_varchar15_tab;
        l_closing_statuses           t_varchar1_tab;
        l_period_status_descriptions t_varchar40_tab;
        l_unposted_due_headers       t_number_tab;
        l_future_unposted_headers    t_number_tab;
        l_error_status_headers       t_number_tab;
        l_unverified_due_batches     t_number_tab;
        l_unbalanced_due_batches     t_number_tab;
        l_interface_row_counts       t_number_tab;
        l_interface_group_counts     t_number_tab;
        l_earliest_unposted_dates    t_date_tab;
        l_latest_unposted_dates      t_date_tab;
        l_readiness_statuses         t_varchar10_tab;
        l_period_last_update_dates   t_date_tab;
    BEGIN
        l_period_name := UPPER(TRIM(p_period_name));

        IF l_period_name IS NULL
           OR NOT REGEXP_LIKE(l_period_name, '^[A-Z]{3}-[0-9]{4}$')
        THEN
            RAISE_APPLICATION_ERROR(
                -20001,
                'Invalid accounting period format. Expected MON-YYYY.'
            );
        END IF;

        l_period_count := xxme_db_source_pkg.period_count(
            p_db_link     => l_db_link,
            p_period_name => l_period_name
        );

        IF l_period_count = 0 THEN
            RAISE_APPLICATION_ERROR(
                -20002,
                'Accounting period is not available in the approved ledger scope.'
            );
        END IF;

        l_period_literal := DBMS_ASSERT.ENQUOTE_LITERAL(l_period_name);

        l_sql := REPLACE(
            q'~SELECT /*+ DRIVING_SITE(gps) */
       gps.ledger_id,
       gl.name AS ledger_name,
       gps.period_name,
       gps.closing_status,
       CASE gps.closing_status
           WHEN 'O' THEN 'OPEN'
           WHEN 'C' THEN 'CLOSED'
           WHEN 'F' THEN 'FUTURE-ENTRY'
           WHEN 'N' THEN 'NEVER OPENED'
           WHEN 'P' THEN 'PERMANENTLY CLOSED'
           ELSE 'UNKNOWN (' || gps.closing_status || ')'
       END AS period_status_description,
       NVL(js.unposted_due_headers, 0) AS unposted_due_headers,
       0 AS future_unposted_headers,
       NVL(js.error_status_headers, 0) AS error_status_headers,
       0 AS unverified_due_batches,
       NVL(js.unbalanced_due_batches, 0) AS unbalanced_due_batches,
       NVL(isum.interface_row_count, 0) AS interface_row_count,
       0 AS interface_group_count,
       js.earliest_unposted_due_date,
       js.latest_unposted_due_date,
       CASE
           WHEN NVL(js.error_status_headers, 0) > 0
             OR NVL(js.unbalanced_due_batches, 0) > 0
           THEN 'RED'
           WHEN NVL(js.unposted_due_headers, 0) > 0
             OR NVL(isum.interface_row_count, 0) > 0
           THEN 'AMBER'
           ELSE 'GREEN'
       END AS readiness_status,
       gps.last_update_date AS period_last_update_date
FROM   apps.gl_period_statuses@ADG gps
       JOIN apps.gl_ledgers@ADG gl
         ON gl.ledger_id = gps.ledger_id
       LEFT JOIN (
           SELECT gjh.ledger_id,
                  COUNT(DISTINCT CASE
                      WHEN gjh.status = 'U'
                      THEN gjh.je_header_id END) AS unposted_due_headers,
                  COUNT(DISTINCT CASE
                      WHEN gjh.status NOT IN ('P', 'U')
                      THEN gjh.je_header_id END) AS error_status_headers,
                  COUNT(DISTINCT CASE
                      WHEN ABS(NVL(gjb.running_total_accounted_dr, 0)
                             - NVL(gjb.running_total_accounted_cr, 0)) > 0.01
                      THEN gjh.je_batch_id END) AS unbalanced_due_batches,
                  MIN(CASE
                      WHEN gjh.status = 'U'
                      THEN gjh.default_effective_date END)
                    AS earliest_unposted_due_date,
                  MAX(CASE
                      WHEN gjh.status = 'U'
                      THEN gjh.default_effective_date END)
                    AS latest_unposted_due_date
           FROM   apps.gl_je_headers@ADG gjh
                  JOIN apps.gl_je_batches@ADG gjb
                    ON gjb.je_batch_id = gjh.je_batch_id
           WHERE  gjh.ledger_id IN (1003, 5001, 10001)
           AND    gjh.period_name = __PERIOD_LITERAL__
           GROUP BY gjh.ledger_id
       ) js
         ON js.ledger_id = gps.ledger_id
       LEFT JOIN (
           SELECT gps2.ledger_id,
                  COUNT(gi.status) AS interface_row_count
           FROM   apps.gl_period_statuses@ADG gps2
                  JOIN apps.gl_interface@ADG gi
                    ON NVL(gi.ledger_id, gi.set_of_books_id) = gps2.ledger_id
                   AND gi.accounting_date >= gps2.start_date
                   AND gi.accounting_date < gps2.end_date + 1
           WHERE  gps2.application_id = 101
           AND    gps2.ledger_id IN (1003, 5001, 10001)
           AND    gps2.period_name = __PERIOD_LITERAL__
           GROUP BY gps2.ledger_id
       ) isum
         ON isum.ledger_id = gps.ledger_id
WHERE  gps.application_id = 101
AND    gps.ledger_id IN (1003, 5001, 10001)
AND    gps.period_name = __PERIOD_LITERAL__
ORDER BY gps.ledger_id~',
            '__PERIOD_LITERAL__',
            l_period_literal
        );

        l_sql := REPLACE(l_sql, '@ADG', '@' || l_db_link);

        OPEN l_rc FOR l_sql;
        l_cursor_open := TRUE;

        LOOP
            FETCH l_rc BULK COLLECT INTO
                l_ledger_ids,
                l_ledger_names,
                l_result_period_names,
                l_closing_statuses,
                l_period_status_descriptions,
                l_unposted_due_headers,
                l_future_unposted_headers,
                l_error_status_headers,
                l_unverified_due_batches,
                l_unbalanced_due_batches,
                l_interface_row_counts,
                l_interface_group_counts,
                l_earliest_unposted_dates,
                l_latest_unposted_dates,
                l_readiness_statuses,
                l_period_last_update_dates
            LIMIT c_fetch_limit;

            EXIT WHEN l_ledger_ids.COUNT = 0;

            FOR i IN 1 .. l_ledger_ids.COUNT LOOP
                PIPE ROW (
                    xxme_gl_summary_row_ot(
                        l_ledger_ids(i),
                        l_ledger_names(i),
                        l_result_period_names(i),
                        l_closing_statuses(i),
                        l_period_status_descriptions(i),
                        l_unposted_due_headers(i),
                        l_future_unposted_headers(i),
                        l_error_status_headers(i),
                        l_unverified_due_batches(i),
                        l_unbalanced_due_batches(i),
                        l_interface_row_counts(i),
                        l_interface_group_counts(i),
                        l_earliest_unposted_dates(i),
                        l_latest_unposted_dates(i),
                        l_readiness_statuses(i),
                        l_period_last_update_dates(i),
                        l_refresh_ts
                    )
                );
            END LOOP;
        END LOOP;

        CLOSE l_rc;
        l_cursor_open := FALSE;
        RETURN;
    EXCEPTION
        WHEN NO_DATA_NEEDED THEN
            IF l_cursor_open THEN
                CLOSE l_rc;
            END IF;
            RETURN;
        WHEN OTHERS THEN
            IF l_cursor_open THEN
                CLOSE l_rc;
            END IF;
            RAISE;
    END get_summary;
END xxme_gl_summary_pkg;
/

CREATE OR REPLACE PACKAGE BODY xxme_ap_ar_detail_pkg
AS
    FUNCTION get_summary (
        p_application_id IN NUMBER,
        p_period_name    IN VARCHAR2,
        p_db_link        IN VARCHAR2
    ) RETURN xxme_ap_ar_detail_row_nt PIPELINED
    IS
        l_db_link            VARCHAR2(30) := xxme_db_source_pkg.normalize_db_link(p_db_link);
        l_period_name        VARCHAR2(15) := UPPER(TRIM(p_period_name));
        l_application_text   VARCHAR2(3);
        l_period_count       PLS_INTEGER;
        l_start_date         DATE;
        l_end_date           DATE;
        l_today              DATE := TRUNC(SYSDATE);
        l_refresh_ts         DATE := SYSDATE;
        l_end_excl           DATE;
        l_start_literal      VARCHAR2(30);
        l_end_excl_literal   VARCHAR2(30);
        l_today_literal      VARCHAR2(30);
        l_sql                CLOB;
        l_rc                 SYS_REFCURSOR;
        l_open               BOOLEAN := FALSE;

        c_fetch_limit        CONSTANT PLS_INTEGER := 500;

        TYPE t_number_tab IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
        TYPE t_date_tab IS TABLE OF DATE INDEX BY PLS_INTEGER;
        TYPE t_varchar20_tab IS TABLE OF VARCHAR2(20) INDEX BY PLS_INTEGER;
        TYPE t_varchar30_tab IS TABLE OF VARCHAR2(30) INDEX BY PLS_INTEGER;
        TYPE t_varchar40_tab IS TABLE OF VARCHAR2(40) INDEX BY PLS_INTEGER;
        TYPE t_varchar240_tab IS TABLE OF VARCHAR2(240) INDEX BY PLS_INTEGER;

        l_ledger_ids         t_number_tab;
        l_ledger_names       t_varchar240_tab;
        l_org_ids            t_number_tab;
        l_operating_units    t_varchar240_tab;
        l_entity_codes       t_varchar30_tab;
        l_exception_types    t_varchar40_tab;
        l_event_counts       t_number_tab;
        l_transaction_counts t_number_tab;
        l_earliest_dates     t_date_tab;
        l_latest_dates       t_date_tab;
        l_age_days_tab       t_number_tab;
        l_severities         t_varchar20_tab;
    BEGIN
        IF p_application_id NOT IN (200, 222) THEN
            RAISE_APPLICATION_ERROR(-20001, 'Application must be 200 (AP) or 222 (AR).');
        END IF;

        IF l_period_name IS NULL
           OR NOT REGEXP_LIKE(l_period_name, '^[A-Z]{3}-[0-9]{4}$')
        THEN
            RAISE_APPLICATION_ERROR(-20002, 'Invalid period. Expected MON-YYYY.');
        END IF;

        l_period_count := xxme_db_source_pkg.period_count(
            p_db_link     => l_db_link,
            p_period_name => l_period_name
        );

        IF l_period_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20003, 'Period is outside the approved ledger scope.');
        END IF;

        EXECUTE IMMEDIATE
            'SELECT MIN(gps.start_date), MAX(gps.end_date) ' ||
            'FROM   apps.gl_period_statuses@' || l_db_link || ' gps ' ||
            'WHERE  gps.application_id = :1 ' ||
            'AND    gps.ledger_id IN (1003, 5001, 10001) ' ||
            'AND    gps.period_name = :2'
        INTO l_start_date, l_end_date
        USING p_application_id, l_period_name;

        IF l_start_date IS NULL OR l_end_date IS NULL THEN
            RETURN;
        END IF;

        l_end_excl := LEAST(TRUNC(l_end_date), l_today) + 1;
        IF l_end_excl <= TRUNC(l_start_date) THEN
            RETURN;
        END IF;

        l_application_text := TO_CHAR(p_application_id);
        l_start_literal    := 'DATE ' || DBMS_ASSERT.ENQUOTE_LITERAL(TO_CHAR(TRUNC(l_start_date), 'YYYY-MM-DD'));
        l_end_excl_literal := 'DATE ' || DBMS_ASSERT.ENQUOTE_LITERAL(TO_CHAR(l_end_excl, 'YYYY-MM-DD'));
        l_today_literal    := 'DATE ' || DBMS_ASSERT.ENQUOTE_LITERAL(TO_CHAR(l_today, 'YYYY-MM-DD'));

        l_sql := q'~WITH
candidate_events_raw AS
(
    SELECT /*+ INDEX(xe XLA_EVENTS_N3) */
           xe.event_id
    FROM   apps.xla_events@ADG xe
    WHERE  xe.application_id = __APP_ID__
    AND    xe.event_date >= __START_DATE__
    AND    xe.event_date <  __END_EXCL__
    AND   (__APP_ID__ <> 200 OR xe.event_status_code <> 'N')
    AND    xe.process_status_code IN ('U', 'I', 'R', 'D', 'E', 'Z')
    UNION ALL
    SELECT /*+ INDEX(xah XLA_AE_HEADERS_N5) */
           xah.event_id
    FROM   apps.xla_ae_headers@ADG xah
    WHERE  xah.application_id = __APP_ID__
    AND    xah.ledger_id IN (1003, 5001, 10001)
    AND    xah.accounting_date >= __START_DATE__
    AND    xah.accounting_date <  __END_EXCL__
    AND   (NVL(xah.accounting_entry_status_code, '?') <> 'F'
           OR NVL(xah.gl_transfer_status_code, '?') <> 'Y')
    AND    xah.event_id IS NOT NULL
),
candidate_events AS
(
    SELECT DISTINCT event_id FROM candidate_events_raw
),
event_evaluation AS
(
    SELECT /*+ LEADING(ce xe xte xah)
               USE_NL(xe xte xah)
               INDEX(xe XLA_EVENTS_U1)
               INDEX(xte XLA_TRANSACTION_ENTITIES_U1) */
           xte.ledger_id,
           xte.security_id_int_1 org_id,
           xte.entity_code,
           xte.source_id_int_1 transaction_id,
           xe.event_id,
           xe.event_date,
           xe.event_status_code,
           xe.process_status_code,
           MAX(xah.accounting_date) accounting_date,
           SUM(CASE WHEN xah.accounting_entry_status_code IN
                    ('I', 'RELATED_EVENT_ERROR') THEN 1 ELSE 0 END)
               error_header_count,
           SUM(CASE WHEN xah.ae_header_id IS NOT NULL
                     AND NVL(xah.accounting_entry_status_code, '?') NOT IN
                         ('F', 'D', 'I', 'RELATED_EVENT_ERROR')
                    THEN 1 ELSE 0 END) other_nonfinal_header_count,
           SUM(CASE WHEN xah.accounting_entry_status_code = 'D'
                    THEN 1 ELSE 0 END) draft_header_count,
           SUM(CASE WHEN xah.accounting_entry_status_code = 'F'
                     AND NVL(xah.gl_transfer_status_code, '?') <> 'Y'
                    THEN 1 ELSE 0 END) final_untransferred_count,
           SUM(CASE WHEN xah.accounting_entry_status_code = 'F'
                     AND xah.gl_transfer_status_code = 'Y'
                    THEN 1 ELSE 0 END) successful_header_count
    FROM   candidate_events ce
           JOIN apps.xla_events@ADG xe
             ON xe.application_id = __APP_ID__
            AND xe.event_id = ce.event_id
           JOIN xla.xla_transaction_entities@ADG xte
             ON xte.application_id = xe.application_id
            AND xte.entity_id = xe.entity_id
           LEFT JOIN apps.xla_ae_headers@ADG xah
             ON xah.application_id = xe.application_id
            AND xah.event_id = xe.event_id
            AND xah.ledger_id = xte.ledger_id
    WHERE  xte.ledger_id IN (1003, 5001, 10001)
    GROUP BY xte.ledger_id, xte.security_id_int_1, xte.entity_code,
             xte.source_id_int_1, xe.event_id, xe.event_date,
             xe.event_status_code, xe.process_status_code
),
classified AS
(
    SELECT e.*,
           CASE
             WHEN successful_header_count > 0 THEN NULL
             WHEN error_header_count > 0 OR process_status_code IN ('I','R')
               THEN 'PROCESSING/ACCOUNTING ERROR'
             WHEN draft_header_count > 0 OR other_nonfinal_header_count > 0
               THEN 'ACCOUNTING NOT FINAL'
             WHEN final_untransferred_count > 0 THEN 'NOT TRANSFERRED TO GL'
             WHEN process_status_code <> 'P'
               THEN 'UNPROCESSED EVENT'
           END exception_type,
           CASE
             WHEN error_header_count > 0 OR draft_header_count > 0
               OR other_nonfinal_header_count > 0
               OR final_untransferred_count > 0
             THEN accounting_date ELSE event_date
           END exception_date
    FROM event_evaluation e
),
summary AS
(
    SELECT c.ledger_id, c.org_id, c.entity_code, c.exception_type,
           COUNT(DISTINCT c.event_id) event_count,
           COUNT(DISTINCT c.transaction_id) transaction_count,
           MIN(c.exception_date) earliest_exception_date,
           MAX(c.exception_date) latest_exception_date
    FROM classified c
    WHERE c.exception_type IS NOT NULL
    GROUP BY c.ledger_id, c.org_id, c.entity_code, c.exception_type
)
SELECT /*+ DRIVING_SITE(gl) */
       s.ledger_id,
       gl.name,
       s.org_id,
       TRIM(haou.name) AS operating_unit,
       s.entity_code,
       s.exception_type,
       s.event_count,
       s.transaction_count,
       s.earliest_exception_date,
       s.latest_exception_date,
       __TODAY__ - TRUNC(s.earliest_exception_date) age_days,
       CASE
         WHEN s.exception_type IN
              ('PROCESSING/ACCOUNTING ERROR','NOT TRANSFERRED TO GL') THEN 'RED'
         WHEN __TODAY__ - TRUNC(s.earliest_exception_date) >= 5 THEN 'RED'
         WHEN s.exception_type = 'ACCOUNTING NOT FINAL'
           OR __TODAY__ - TRUNC(s.earliest_exception_date) >= 2 THEN 'AMBER'
         ELSE 'INFORMATIONAL'
       END severity
FROM summary s
     JOIN apps.gl_ledgers@ADG gl
       ON gl.ledger_id = s.ledger_id
     LEFT JOIN apps.hr_all_organization_units_tl@ADG haou
       ON haou.organization_id = s.org_id
      AND haou.language = 'US'
ORDER BY s.ledger_id, s.org_id, s.entity_code, s.exception_type~';

        l_sql := REPLACE(l_sql, '__APP_ID__', l_application_text);
        l_sql := REPLACE(l_sql, '__START_DATE__', l_start_literal);
        l_sql := REPLACE(l_sql, '__END_EXCL__', l_end_excl_literal);
        l_sql := REPLACE(l_sql, '__TODAY__', l_today_literal);
        l_sql := REPLACE(l_sql, '@ADG', '@' || l_db_link);

        OPEN l_rc FOR l_sql;
        l_open := TRUE;
        LOOP
            FETCH l_rc BULK COLLECT INTO
                l_ledger_ids,
                l_ledger_names,
                l_org_ids,
                l_operating_units,
                l_entity_codes,
                l_exception_types,
                l_event_counts,
                l_transaction_counts,
                l_earliest_dates,
                l_latest_dates,
                l_age_days_tab,
                l_severities
            LIMIT c_fetch_limit;

            EXIT WHEN l_ledger_ids.COUNT = 0;

            FOR i IN 1 .. l_ledger_ids.COUNT LOOP
                PIPE ROW (xxme_ap_ar_detail_row_ot(
                    l_ledger_ids(i),
                    l_ledger_names(i),
                    l_org_ids(i),
                    l_operating_units(i),
                    l_entity_codes(i),
                    l_exception_types(i),
                    l_event_counts(i),
                    l_transaction_counts(i),
                    l_earliest_dates(i),
                    l_latest_dates(i),
                    l_age_days_tab(i),
                    l_severities(i),
                    l_refresh_ts
                ));
            END LOOP;
        END LOOP;
        CLOSE l_rc;
        l_open := FALSE;
        RETURN;
    EXCEPTION
        WHEN NO_DATA_NEEDED THEN
            IF l_open THEN CLOSE l_rc; END IF;
            RETURN;
        WHEN OTHERS THEN
            IF l_open THEN CLOSE l_rc; END IF;
            RAISE;
    END get_summary;
END xxme_ap_ar_detail_pkg;
/

CREATE OR REPLACE PACKAGE BODY xxme_ap_ar_kpi_pkg
AS
    FUNCTION get_cards (
        p_period_name IN VARCHAR2,
        p_db_link     IN VARCHAR2
    ) RETURN xxme_module_kpi_row_nt PIPELINED
    IS
        l_db_link           VARCHAR2(30) := xxme_db_source_pkg.normalize_db_link(p_db_link);
        l_period_name       VARCHAR2(15);
        l_period_count      PLS_INTEGER;
        l_refresh_ts        DATE := SYSDATE;
        l_application_id    NUMBER;
        l_module_name       VARCHAR2(30);
        l_actionable_count  NUMBER;
        l_red_count         NUMBER;
        l_amber_count       NUMBER;
        l_information_count NUMBER;
        l_us_count          NUMBER;
        l_uk_count          NUMBER;
        l_ch_count          NUMBER;
    BEGIN
        l_period_name := UPPER(TRIM(p_period_name));

        IF l_period_name IS NULL
           OR NOT REGEXP_LIKE(l_period_name, '^[A-Z]{3}-[0-9]{4}$')
        THEN
            RAISE_APPLICATION_ERROR(
                -20021,
                'Invalid accounting period format. Expected MON-YYYY.'
            );
        END IF;

        l_period_count := xxme_db_source_pkg.period_count(
            p_db_link     => l_db_link,
            p_period_name => l_period_name
        );

        IF l_period_count = 0 THEN
            RAISE_APPLICATION_ERROR(
                -20022,
                'Accounting period is not available in the approved ledger scope.'
            );
        END IF;

        FOR i IN 1 .. 2 LOOP
            IF i = 1 THEN
                l_application_id := 200;
                l_module_name := 'Payables';
            ELSE
                l_application_id := 222;
                l_module_name := 'Receivables';
            END IF;

            SELECT NVL(SUM(CASE WHEN d.severity IN ('RED', 'AMBER')
                                THEN d.event_count ELSE 0 END), 0),
                   NVL(SUM(CASE WHEN d.severity = 'RED'
                                THEN d.event_count ELSE 0 END), 0),
                   NVL(SUM(CASE WHEN d.severity = 'AMBER'
                                THEN d.event_count ELSE 0 END), 0),
                   NVL(SUM(CASE WHEN d.severity = 'INFORMATIONAL'
                                THEN d.event_count ELSE 0 END), 0),
                   NVL(SUM(CASE WHEN d.ledger_id = 1003
                                 AND d.severity IN ('RED', 'AMBER')
                                THEN d.event_count ELSE 0 END), 0),
                   NVL(SUM(CASE WHEN d.ledger_id = 5001
                                 AND d.severity IN ('RED', 'AMBER')
                                THEN d.event_count ELSE 0 END), 0),
                   NVL(SUM(CASE WHEN d.ledger_id = 10001
                                 AND d.severity IN ('RED', 'AMBER')
                                THEN d.event_count ELSE 0 END), 0)
            INTO   l_actionable_count,
                   l_red_count,
                   l_amber_count,
                   l_information_count,
                   l_us_count,
                   l_uk_count,
                   l_ch_count
            FROM   TABLE(xxme_ap_ar_detail_pkg.get_summary(
                       l_application_id,
                       l_period_name,
                       l_db_link
                   )) d;

            PIPE ROW (
                xxme_module_kpi_row_ot(
                    l_application_id,
                    l_module_name,
                    l_actionable_count,
                    l_red_count,
                    l_amber_count,
                    l_information_count,
                    l_us_count,
                    l_uk_count,
                    l_ch_count,
                    l_refresh_ts
                )
            );
        END LOOP;

        RETURN;
    EXCEPTION
        WHEN NO_DATA_NEEDED THEN
            RETURN;
    END get_cards;
END xxme_ap_ar_kpi_pkg;
/

CREATE OR REPLACE PACKAGE BODY xxme_sla_summary_pkg
AS
    FUNCTION get_summary (
        p_period_name IN VARCHAR2,
        p_db_link     IN VARCHAR2
    ) RETURN xxme_sla_summary_row_nt PIPELINED
    IS
        l_db_link                    VARCHAR2(30) := xxme_db_source_pkg.normalize_db_link(p_db_link);
        l_period_name                VARCHAR2(15);
        l_period_count               PLS_INTEGER;
        l_start_date                 DATE;
        l_end_date                   DATE;
        l_today                      DATE := TRUNC(SYSDATE);
        l_refresh_ts                 DATE := SYSDATE;
        l_end_excl                   DATE;
        l_start_literal              VARCHAR2(30);
        l_end_excl_literal           VARCHAR2(30);
        l_today_literal              VARCHAR2(30);
        l_sql                        CLOB;
        l_rc                         SYS_REFCURSOR;
        l_cursor_open                BOOLEAN := FALSE;

        c_fetch_limit                CONSTANT PLS_INTEGER := 500;

        TYPE t_number_tab IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
        TYPE t_date_tab IS TABLE OF DATE INDEX BY PLS_INTEGER;
        TYPE t_varchar20_tab IS TABLE OF VARCHAR2(20) INDEX BY PLS_INTEGER;
        TYPE t_varchar30_tab IS TABLE OF VARCHAR2(30) INDEX BY PLS_INTEGER;
        TYPE t_varchar50_tab IS TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
        TYPE t_varchar240_tab IS TABLE OF VARCHAR2(240) INDEX BY PLS_INTEGER;

        l_ledger_ids                 t_number_tab;
        l_ledger_names               t_varchar240_tab;
        l_org_ids                    t_number_tab;
        l_operating_units            t_varchar240_tab;
        l_application_ids            t_number_tab;
        l_sla_sources                t_varchar30_tab;
        l_entity_codes               t_varchar30_tab;
        l_exception_types            t_varchar50_tab;
        l_event_counts               t_number_tab;
        l_transaction_counts         t_number_tab;
        l_earliest_exception_dates   t_date_tab;
        l_latest_exception_dates     t_date_tab;
        l_oldest_exception_age_days  t_number_tab;
        l_severities                 t_varchar20_tab;
    BEGIN
        l_period_name := UPPER(TRIM(p_period_name));

        IF l_period_name IS NULL
           OR NOT REGEXP_LIKE(l_period_name, '^[A-Z]{3}-[0-9]{4}$')
        THEN
            RAISE_APPLICATION_ERROR(
                -20011,
                'Invalid accounting period format. Expected MON-YYYY.'
            );
        END IF;

        l_period_count := xxme_db_source_pkg.period_count(
            p_db_link     => l_db_link,
            p_period_name => l_period_name
        );

        IF l_period_count = 0 THEN
            RAISE_APPLICATION_ERROR(
                -20012,
                'Accounting period is not available in the approved ledger scope.'
            );
        END IF;

        EXECUTE IMMEDIATE
            'SELECT MIN(gps.start_date), MAX(gps.end_date) ' ||
            'FROM   apps.gl_period_statuses@' || l_db_link || ' gps ' ||
            'WHERE  gps.application_id = 101 ' ||
            'AND    gps.ledger_id IN (1003, 5001, 10001) ' ||
            'AND    gps.period_name = :1'
        INTO l_start_date, l_end_date
        USING l_period_name;

        IF l_start_date IS NULL OR l_end_date IS NULL THEN
            RETURN;
        END IF;

        l_end_excl := LEAST(TRUNC(l_end_date), l_today) + 1;
        IF l_end_excl <= TRUNC(l_start_date) THEN
            RETURN;
        END IF;

        l_start_literal    := 'DATE ' || DBMS_ASSERT.ENQUOTE_LITERAL(TO_CHAR(TRUNC(l_start_date), 'YYYY-MM-DD'));
        l_end_excl_literal := 'DATE ' || DBMS_ASSERT.ENQUOTE_LITERAL(TO_CHAR(l_end_excl, 'YYYY-MM-DD'));
        l_today_literal    := 'DATE ' || DBMS_ASSERT.ENQUOTE_LITERAL(TO_CHAR(l_today, 'YYYY-MM-DD'));

        l_sql := REPLACE(
            REPLACE(
                REPLACE(
                    q'~WITH
candidate_events_raw AS
(
    -- Cost Management: use the process-status index and validate the SLA event date.
    SELECT /*+ LEADING(xe)
               INDEX(xe XLA_EVENTS_N3) */
           xe.application_id,
           xe.event_id
    FROM   apps.xla_events@ADG xe
    WHERE  xe.application_id = 707
    AND    xe.event_date >= __START_DATE__
    AND    xe.event_date <  __END_EXCL__
    AND    xe.event_status_code <> 'N'
    AND    xe.process_status_code IN ('U', 'I', 'R', 'D')

    UNION ALL

    -- Cost Management: only final accounting not transferred to GL.
    -- Draft/error headers are reached through the event branch above.
    SELECT /*+ INDEX(xah XLA_AE_HEADERS_N5) */
           xah.application_id,
           xah.event_id
    FROM   apps.xla_ae_headers@ADG xah
    WHERE  xah.application_id = 707
    AND    xah.ledger_id IN (1003, 5001, 10001)
    AND    xah.accounting_date >= __START_DATE__
    AND    xah.accounting_date <  __END_EXCL__
    AND    xah.accounting_entry_status_code = 'F'
    AND    xah.gl_transfer_status_code = 'N'
    AND    xah.event_id IS NOT NULL
),
candidate_events AS
(
    SELECT DISTINCT application_id, event_id
    FROM candidate_events_raw
),
event_evaluation AS
(
    SELECT /*+ LEADING(ce xe xte xah)
               USE_NL(xe xte xah)
               INDEX(xe XLA_EVENTS_U1)
               INDEX(xte XLA_TRANSACTION_ENTITIES_U1) */
           xe.application_id,
           xte.ledger_id,
           xte.security_id_int_1 AS org_id,
           xte.entity_code,
           xte.source_id_int_1 AS transaction_id,
           xe.event_id,
           xe.event_date,
           xe.transaction_date,
           xe.event_status_code,
           xe.process_status_code,
           COUNT(xah.ae_header_id) AS header_count,
           MAX(xah.accounting_date) AS accounting_date,
           SUM(CASE
                   WHEN xah.accounting_entry_status_code IN
                        ('I', 'RELATED_EVENT_ERROR')
                   THEN 1 ELSE 0
               END) AS error_header_count,
           SUM(CASE
                   WHEN xah.ae_header_id IS NOT NULL
                    AND NVL(xah.accounting_entry_status_code, '?')
                        NOT IN ('F', 'D', 'I', 'RELATED_EVENT_ERROR')
                   THEN 1 ELSE 0
               END) AS other_nonfinal_header_count,
           SUM(CASE
                   WHEN xah.accounting_entry_status_code = 'D'
                   THEN 1 ELSE 0
               END) AS draft_header_count,
           SUM(CASE
                   WHEN xah.accounting_entry_status_code = 'F'
                    AND NVL(xah.gl_transfer_status_code, '?') <> 'Y'
                   THEN 1 ELSE 0
               END) AS final_untransferred_count,
           SUM(CASE
                   WHEN xah.accounting_entry_status_code = 'F'
                    AND xah.gl_transfer_status_code = 'Y'
                   THEN 1 ELSE 0
               END) AS successful_header_count
    FROM   candidate_events ce
           JOIN apps.xla_events@ADG xe
             ON xe.application_id = ce.application_id
            AND xe.event_id = ce.event_id
           JOIN xla.xla_transaction_entities@ADG xte
             ON xte.application_id = xe.application_id
            AND xte.entity_id = xe.entity_id
           LEFT JOIN apps.xla_ae_headers@ADG xah
             ON xah.application_id = xe.application_id
            AND xah.event_id = xe.event_id
            AND xah.ledger_id = xte.ledger_id
    WHERE  xte.ledger_id IN (1003, 5001, 10001)
    GROUP BY xe.application_id,
             xte.ledger_id,
             xte.security_id_int_1,
             xte.entity_code,
             xte.source_id_int_1,
             xe.event_id,
             xe.event_date,
             xe.transaction_date,
             xe.event_status_code,
             xe.process_status_code
),
classified AS
(
    SELECT e.*,
           CASE
               WHEN e.successful_header_count > 0
               THEN NULL
               WHEN e.error_header_count > 0
                 OR e.process_status_code IN ('I', 'R')
               THEN 'PROCESSING/ACCOUNTING ERROR'
               WHEN e.draft_header_count > 0
                 OR e.other_nonfinal_header_count > 0
               THEN 'ACCOUNTING NOT FINAL'
               WHEN e.final_untransferred_count > 0
               THEN 'NOT TRANSFERRED TO GL'
               WHEN e.event_status_code <> 'P'
                 OR e.process_status_code <> 'P'
               THEN 'UNPROCESSED EVENT'
           END AS exception_type,
           CASE
               WHEN e.error_header_count > 0
                 OR e.draft_header_count > 0
                 OR e.other_nonfinal_header_count > 0
                 OR e.final_untransferred_count > 0
               THEN e.accounting_date
               ELSE e.event_date
           END AS exception_date
    FROM event_evaluation e
),
summary AS
(
    SELECT c.application_id,
           c.ledger_id,
           c.org_id,
           c.entity_code,
           c.exception_type,
           COUNT(DISTINCT c.event_id) AS event_count,
           COUNT(DISTINCT c.transaction_id) AS transaction_count,
           MIN(c.exception_date) AS earliest_exception_date,
           MAX(c.exception_date) AS latest_exception_date,
           __TODAY__ - TRUNC(MIN(c.exception_date))
             AS oldest_exception_age_days
    FROM   classified c
    WHERE  c.exception_type IS NOT NULL
    GROUP BY c.application_id,
             c.ledger_id,
             c.org_id,
             c.entity_code,
             c.exception_type
)
SELECT /*+ DRIVING_SITE(gl) */
       s.ledger_id,
       gl.name AS ledger_name,
       s.org_id,
       TRIM(haou.name) AS operating_unit,
       s.application_id,
       'COST MANAGEMENT' AS sla_source,
       s.entity_code,
       s.exception_type,
       s.event_count,
       s.transaction_count,
       s.earliest_exception_date,
       s.latest_exception_date,
       s.oldest_exception_age_days,
       CASE
           WHEN s.exception_type IN
                ('PROCESSING/ACCOUNTING ERROR', 'NOT TRANSFERRED TO GL')
           THEN 'RED'
           WHEN s.oldest_exception_age_days >= 5
           THEN 'RED'
           WHEN s.exception_type = 'ACCOUNTING NOT FINAL'
             OR s.oldest_exception_age_days >= 2
           THEN 'AMBER'
           ELSE 'INFORMATIONAL'
       END AS severity
FROM   summary s
       JOIN apps.gl_ledgers@ADG gl
         ON gl.ledger_id = s.ledger_id
       LEFT JOIN apps.hr_all_organization_units_tl@ADG haou
         ON haou.organization_id = s.org_id
        AND haou.language = 'US'
ORDER BY s.ledger_id,
         s.application_id,
         s.org_id,
         s.entity_code,
         s.exception_type~',
                    '__START_DATE__',
                    l_start_literal
                ),
                '__END_EXCL__',
                l_end_excl_literal
            ),
            '__TODAY__',
            l_today_literal
        );

        l_sql := REPLACE(l_sql, '@ADG', '@' || l_db_link);

        OPEN l_rc FOR l_sql;
        l_cursor_open := TRUE;

        LOOP
            FETCH l_rc BULK COLLECT INTO
                l_ledger_ids,
                l_ledger_names,
                l_org_ids,
                l_operating_units,
                l_application_ids,
                l_sla_sources,
                l_entity_codes,
                l_exception_types,
                l_event_counts,
                l_transaction_counts,
                l_earliest_exception_dates,
                l_latest_exception_dates,
                l_oldest_exception_age_days,
                l_severities
            LIMIT c_fetch_limit;

            EXIT WHEN l_ledger_ids.COUNT = 0;

            FOR i IN 1 .. l_ledger_ids.COUNT LOOP
                PIPE ROW (
                    xxme_sla_summary_row_ot(
                        l_ledger_ids(i),
                        l_ledger_names(i),
                        l_org_ids(i),
                        l_operating_units(i),
                        l_application_ids(i),
                        l_sla_sources(i),
                        l_entity_codes(i),
                        l_exception_types(i),
                        l_event_counts(i),
                        l_transaction_counts(i),
                        l_earliest_exception_dates(i),
                        l_latest_exception_dates(i),
                        l_oldest_exception_age_days(i),
                        l_severities(i),
                        l_refresh_ts
                    )
                );
            END LOOP;
        END LOOP;

        CLOSE l_rc;
        l_cursor_open := FALSE;
        RETURN;
    EXCEPTION
        WHEN NO_DATA_NEEDED THEN
            IF l_cursor_open THEN
                CLOSE l_rc;
            END IF;
            RETURN;
        WHEN OTHERS THEN
            IF l_cursor_open THEN
                CLOSE l_rc;
            END IF;
            RAISE;
    END get_summary;
END xxme_sla_summary_pkg;
/
