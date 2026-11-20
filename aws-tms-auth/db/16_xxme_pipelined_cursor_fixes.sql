-- 16_xxme_pipelined_cursor_fixes.sql
-- Wave 1: Fix missing WHEN NO_DATA_NEEDED cursor cleanup and add BULK COLLECT LIMIT 500
-- across 9 XXME_* pipelined table-function packages in GL_ACCOUNTS.
-- Preserves all SQL queries, hints, validations, and helper functions unchanged.

whenever sqlerror continue none
set define off

prompt === 1/9: XXME_DB_SOURCE_PKG ===
CREATE OR REPLACE PACKAGE BODY "XXME_DB_SOURCE_PKG" AS
    FUNCTION apex_db_link RETURN VARCHAR2 IS
    BEGIN
        RETURN apex_util.get_session_state('G_DB_LINK');
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END apex_db_link;

    FUNCTION normalize_db_link (
        p_db_link IN VARCHAR2 DEFAULT NULL
    ) RETURN VARCHAR2
    IS
        l_db_link VARCHAR2(30);
    BEGIN
        l_db_link := UPPER(TRIM(COALESCE(p_db_link, apex_db_link, c_default_db_link)));

        IF l_db_link NOT IN ('ADG') THEN
            RAISE_APPLICATION_ERROR(-20080, 'Database source is not approved.');
        END IF;

        RETURN DBMS_ASSERT.SIMPLE_SQL_NAME(l_db_link);
    END normalize_db_link;

    FUNCTION current_db_link RETURN VARCHAR2 IS
    BEGIN
        RETURN normalize_db_link(NULL);
    END current_db_link;

    FUNCTION period_count (
        p_period_name IN VARCHAR2,
        p_db_link     IN VARCHAR2 DEFAULT NULL
    ) RETURN PLS_INTEGER
    IS
        l_db_link VARCHAR2(30) := normalize_db_link(p_db_link);
        l_count   PLS_INTEGER;
        l_sql     VARCHAR2(2000);
    BEGIN
        l_sql :=
            'SELECT COUNT(*) ' ||
            'FROM apps.gl_period_statuses@' || l_db_link || ' gps ' ||
            'WHERE gps.application_id = 101 ' ||
            'AND gps.ledger_id IN (1003, 5001, 10001) ' ||
            'AND gps.period_name = :period_name';

        EXECUTE IMMEDIATE l_sql
            INTO l_count
            USING UPPER(TRIM(p_period_name));

        RETURN l_count;
    END period_count;

    FUNCTION get_periods (
        p_db_link IN VARCHAR2 DEFAULT NULL
    ) RETURN xxme_period_row_nt PIPELINED
    IS
        l_db_link     VARCHAR2(30) := normalize_db_link(p_db_link);
        l_sql         VARCHAR2(4000);
        l_rc          SYS_REFCURSOR;
        l_open        BOOLEAN := FALSE;

        c_fetch_limit CONSTANT PLS_INTEGER := 500;

        TYPE t_period_tab IS TABLE OF VARCHAR2(15) INDEX BY PLS_INTEGER;
        TYPE t_date_tab IS TABLE OF DATE INDEX BY PLS_INTEGER;

        l_periods     t_period_tab;
        l_start_dates t_date_tab;
        l_end_dates   t_date_tab;
    BEGIN
        l_sql :=
            'SELECT gps.period_name, MIN(gps.start_date), MAX(gps.end_date) ' ||
            'FROM apps.gl_period_statuses@' || l_db_link || ' gps ' ||
            'WHERE gps.application_id = 101 ' ||
            'AND gps.ledger_id IN (1003, 5001, 10001) ' ||
            'GROUP BY gps.period_name ' ||
            'ORDER BY MIN(gps.start_date) DESC';

        OPEN l_rc FOR l_sql;
        l_open := TRUE;

        LOOP
            FETCH l_rc BULK COLLECT INTO
                l_periods,
                l_start_dates,
                l_end_dates
            LIMIT c_fetch_limit;

            EXIT WHEN l_periods.COUNT = 0;

            FOR i IN 1 .. l_periods.COUNT LOOP
                PIPE ROW(xxme_period_row_ot(l_periods(i), l_start_dates(i), l_end_dates(i)));
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
    END get_periods;
END xxme_db_source_pkg;
/

prompt === 2/9: XXME_AP_HOLDS_PKG ===
CREATE OR REPLACE PACKAGE BODY "XXME_AP_HOLDS_PKG" AS
    FUNCTION get_holds (
        p_db_link IN VARCHAR2
    ) RETURN xxme_ap_hold_row_nt PIPELINED
    IS
        l_db_link     VARCHAR2(30) := xxme_db_source_pkg.normalize_db_link(p_db_link);
        l_sql         CLOB;
        l_rc          SYS_REFCURSOR;
        l_open        BOOLEAN := FALSE;

        c_fetch_limit CONSTANT PLS_INTEGER := 500;

        TYPE t_row_tab IS TABLE OF xxme_ap_hold_row_ot INDEX BY PLS_INTEGER;
        l_rows        t_row_tab;
    BEGIN
        l_sql := q'~
SELECT xxme_ap_hold_row_ot(
           q.ledger_id, q.ledger_name, q.org_id, q.operating_unit,
           q.invoice_id, q.invoice_num, q.supplier_number, q.supplier_name,
           q.supplier_site, q.invoice_date, q.gl_date, q.currency_code,
           q.invoice_amount, q.amount_paid, q.outstanding_amount,
           q.payment_status_flag, q.hold_code, q.hold_reason, q.hold_date,
           q.hold_age_days, q.severity, q.refresh_timestamp
       )
FROM (
    SELECT DISTINCT /*+ DRIVING_SITE(ah) LEADING(ah aia)
               USE_NL(aia) USE_NL(aps) USE_NL(assa) */
           aia.set_of_books_id ledger_id,
           gl.name ledger_name,
           ah.org_id,
           TRIM(hou.name) operating_unit,
           aia.invoice_id,
           aia.invoice_num,
           aps.segment1 supplier_number,
           aps.vendor_name supplier_name,
           assa.vendor_site_code supplier_site,
           aia.invoice_date,
           aia.gl_date,
           aia.invoice_currency_code currency_code,
           aia.invoice_amount,
           NVL(aia.amount_paid,0) amount_paid,
           aia.invoice_amount-NVL(aia.amount_paid,0) outstanding_amount,
           aia.payment_status_flag,
           ah.hold_lookup_code hold_code,
           ah.hold_reason,
           ah.hold_date,
           TRUNC(SYSDATE)-TRUNC(ah.hold_date) hold_age_days,
           CASE
               WHEN TRUNC(SYSDATE)-TRUNC(ah.hold_date)>=5 THEN 'RED'
               WHEN TRUNC(SYSDATE)-TRUNC(ah.hold_date)>=2 THEN 'AMBER'
               ELSE 'INFORMATIONAL'
           END severity,
           SYSDATE refresh_timestamp
    FROM apps.ap_holds_all@ADG ah
    JOIN apps.ap_invoices_all@ADG aia
      ON aia.invoice_id=ah.invoice_id AND aia.org_id=ah.org_id
    JOIN apps.gl_ledgers@ADG gl
      ON gl.ledger_id=aia.set_of_books_id
    LEFT JOIN apps.hr_operating_units@ADG hou
      ON hou.organization_id=ah.org_id
    LEFT JOIN apps.ap_suppliers@ADG aps
      ON aps.vendor_id=aia.vendor_id
    LEFT JOIN apps.ap_supplier_sites_all@ADG assa
      ON assa.vendor_site_id=aia.vendor_site_id
     AND assa.vendor_id=aia.vendor_id
     AND assa.org_id=aia.org_id
    WHERE aia.set_of_books_id IN (1003,5001,10001)
    AND ah.release_lookup_code IS NULL
    AND aia.cancelled_date IS NULL
    AND NVL(aia.payment_status_flag,'N')<>'Y'
) q~';

        l_sql := REPLACE(l_sql, '@ADG', '@' || l_db_link);
        OPEN l_rc FOR l_sql;
        l_open := TRUE;

        LOOP
            FETCH l_rc BULK COLLECT INTO l_rows LIMIT c_fetch_limit;
            EXIT WHEN l_rows.COUNT = 0;

            FOR i IN 1 .. l_rows.COUNT LOOP
                PIPE ROW(l_rows(i));
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
    END get_holds;
END xxme_ap_holds_pkg;
/

prompt === 3/9: XXME_PERIOD_STATUS_PKG ===
CREATE OR REPLACE PACKAGE BODY "XXME_PERIOD_STATUS_PKG" AS
    FUNCTION status_label (p_status_code IN VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN CASE p_status_code
            WHEN 'O' THEN 'Open'
            WHEN 'C' THEN 'Closed'
            WHEN 'P' THEN 'Permanently Closed'
            WHEN 'F' THEN 'Future Enterable'
            WHEN 'N' THEN 'Never Opened'
            ELSE NVL(p_status_code, 'Not Configured')
        END;
    END status_label;

    FUNCTION status_class (p_status_code IN VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN CASE p_status_code
            WHEN 'O' THEN 'OPEN'
            WHEN 'C' THEN 'CLOSED'
            WHEN 'P' THEN 'PERMANENT'
            WHEN 'F' THEN 'FUTURE'
            WHEN 'N' THEN 'NEVER'
            ELSE 'UNKNOWN'
        END;
    END status_class;

    FUNCTION get_statuses (
        p_db_link IN VARCHAR2,
        p_year    IN NUMBER
    ) RETURN xxme_period_status_row_nt PIPELINED
    IS
        l_db_link      VARCHAR2(30) := xxme_db_source_pkg.normalize_db_link(p_db_link);
        l_year         PLS_INTEGER := NVL(TRUNC(p_year), TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')));
        l_start_date   DATE;
        l_end_date     DATE;
        l_start_sql    VARCHAR2(40);
        l_end_sql      VARCHAR2(40);
        l_sql          CLOB;
        l_rc           SYS_REFCURSOR;
        l_open         BOOLEAN := FALSE;

        c_fetch_limit  CONSTANT PLS_INTEGER := 500;

        TYPE t_number_tab IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
        TYPE t_date_tab IS TABLE OF DATE INDEX BY PLS_INTEGER;
        TYPE t_varchar15_tab IS TABLE OF VARCHAR2(15) INDEX BY PLS_INTEGER;
        TYPE t_varchar240_tab IS TABLE OF VARCHAR2(240) INDEX BY PLS_INTEGER;

        l_ledger_ids   t_number_tab;
        l_ledgers      t_varchar240_tab;
        l_periods      t_varchar15_tab;
        l_period_starts t_date_tab;
        l_period_ends  t_date_tab;
        l_gl_codes     t_varchar15_tab;
        l_ap_codes     t_varchar15_tab;
        l_ar_codes     t_varchar15_tab;
    BEGIN
        IF l_year < 2000 OR l_year > 2100 THEN
            RAISE_APPLICATION_ERROR(-20081, 'Period-status year is outside the approved range.');
        END IF;

        l_start_date := TO_DATE(TO_CHAR(l_year) || '-01-01', 'YYYY-MM-DD');
        l_end_date   := ADD_MONTHS(l_start_date, 12);
        l_start_sql  := 'TO_DATE(''' || TO_CHAR(l_start_date, 'YYYY-MM-DD') || ''',''YYYY-MM-DD'')';
        l_end_sql    := 'TO_DATE(''' || TO_CHAR(l_end_date, 'YYYY-MM-DD') || ''',''YYYY-MM-DD'')';

        l_sql := q'~
SELECT /*+ DRIVING_SITE(gps) */
       gps.set_of_books_id,
       gl.name,
       gps.period_name,
       MIN(gps.start_date),
       MAX(gps.end_date),
       MAX(CASE WHEN gps.application_id = 101 THEN gps.closing_status END),
       MAX(CASE WHEN gps.application_id = 200 THEN gps.closing_status END),
       MAX(CASE WHEN gps.application_id = 222 THEN gps.closing_status END)
  FROM apps.gl_period_statuses@ADG gps
  JOIN apps.gl_ledgers@ADG gl
    ON gl.ledger_id = gps.set_of_books_id
 WHERE gps.set_of_books_id IN (1003, 5001, 10001)
   AND gps.application_id IN (101, 200, 222)
   AND NVL(gps.adjustment_period_flag, 'N') = 'N'
   AND gps.start_date >= __START_DATE__
   AND gps.start_date <  __END_DATE__
 GROUP BY gps.set_of_books_id, gl.name, gps.period_name
 ORDER BY gps.set_of_books_id, MIN(gps.start_date)
~';

        l_sql := REPLACE(l_sql, '__START_DATE__', l_start_sql);
        l_sql := REPLACE(l_sql, '__END_DATE__', l_end_sql);
        l_sql := REPLACE(l_sql, '@ADG', '@' || l_db_link);

        OPEN l_rc FOR l_sql;
        l_open := TRUE;
        LOOP
            FETCH l_rc BULK COLLECT INTO
                l_ledger_ids,
                l_ledgers,
                l_periods,
                l_period_starts,
                l_period_ends,
                l_gl_codes,
                l_ap_codes,
                l_ar_codes
            LIMIT c_fetch_limit;

            EXIT WHEN l_ledger_ids.COUNT = 0;

            FOR i IN 1 .. l_ledger_ids.COUNT LOOP
                PIPE ROW(xxme_period_status_row_ot(
                    l_ledger_ids(i),
                    l_ledgers(i),
                    l_periods(i),
                    l_period_starts(i),
                    l_period_ends(i),
                    status_label(l_gl_codes(i)),
                    status_class(l_gl_codes(i)),
                    status_label(l_ap_codes(i)),
                    status_class(l_ap_codes(i)),
                    status_label(l_ar_codes(i)),
                    status_class(l_ar_codes(i))
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
    END get_statuses;
END xxme_period_status_pkg;
/

prompt === 4/9: XXME_GL_UNPOSTED_PKG ===
CREATE OR REPLACE PACKAGE BODY "XXME_GL_UNPOSTED_PKG"
AS
    FUNCTION get_journals (
        p_period_name IN VARCHAR2,
        p_db_link     IN VARCHAR2
    ) RETURN xxme_gl_unposted_row_nt PIPELINED
    IS
        l_db_link                VARCHAR2(30) := xxme_db_source_pkg.normalize_db_link(p_db_link);
        l_period_name            VARCHAR2(15);
        l_period_literal         VARCHAR2(40);
        l_period_count           PLS_INTEGER;
        l_sql                    CLOB;
        l_rc                     SYS_REFCURSOR;
        l_cursor_open            BOOLEAN := FALSE;

        c_fetch_limit            CONSTANT PLS_INTEGER := 500;

        TYPE t_number_tab IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
        TYPE t_date_tab IS TABLE OF DATE INDEX BY PLS_INTEGER;
        TYPE t_varchar10_tab IS TABLE OF VARCHAR2(10) INDEX BY PLS_INTEGER;
        TYPE t_varchar15_tab IS TABLE OF VARCHAR2(15) INDEX BY PLS_INTEGER;
        TYPE t_varchar20_tab IS TABLE OF VARCHAR2(20) INDEX BY PLS_INTEGER;
        TYPE t_varchar25_tab IS TABLE OF VARCHAR2(25) INDEX BY PLS_INTEGER;
        TYPE t_varchar100_tab IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
        TYPE t_varchar240_tab IS TABLE OF VARCHAR2(240) INDEX BY PLS_INTEGER;

        l_ledger_ids             t_number_tab;
        l_ledger_names           t_varchar240_tab;
        l_result_period_names    t_varchar15_tab;
        l_je_header_ids          t_number_tab;
        l_je_batch_ids           t_number_tab;
        l_batch_names            t_varchar100_tab;
        l_journal_names          t_varchar100_tab;
        l_journal_sources        t_varchar25_tab;
        l_journal_categories     t_varchar25_tab;
        l_effective_dates        t_date_tab;
        l_currency_codes         t_varchar15_tab;
        l_balance_types          t_varchar20_tab;
        l_journal_descriptions   t_varchar240_tab;
        l_batch_descriptions     t_varchar240_tab;
        l_batch_balance_statuses t_varchar20_tab;
        l_severities             t_varchar10_tab;
        l_refresh_timestamps     t_date_tab;
        l_journal_entered_drs    t_number_tab;
        l_journal_entered_crs    t_number_tab;
        l_journal_accounted_drs  t_number_tab;
        l_journal_accounted_crs  t_number_tab;
        l_ledger_currency_codes  t_varchar15_tab;
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
            p_db_link   => l_db_link,
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
            q'~SELECT /*+ DRIVING_SITE(gjh)
                         LEADING(gjh gjb gl gjc)
                         USE_NL(gjb) USE_NL(gl) USE_NL(gjc) */
                      gjh.ledger_id,
                      gl.name AS ledger_name,
                      gjh.period_name,
                      gjh.je_header_id,
                      gjh.je_batch_id,
                      gjb.name AS batch_name,
                      gjh.name AS journal_name,
                      gjh.je_source AS journal_source,
                      NVL(gjc.user_je_category_name, gjh.je_category)
                          AS journal_category,
                      gjh.default_effective_date AS effective_date,
                      gjh.currency_code,
                      CASE gjh.actual_flag
                          WHEN 'A' THEN 'ACTUAL'
                          WHEN 'B' THEN 'BUDGET'
                          WHEN 'E' THEN 'ENCUMBRANCE'
                          ELSE 'UNKNOWN (' || gjh.actual_flag || ')'
                      END AS balance_type,
                      gjh.description AS journal_description,
                      gjb.description AS batch_description,
                      CASE
                          WHEN ABS(NVL(gjb.running_total_accounted_dr, 0)
                                 - NVL(gjb.running_total_accounted_cr, 0)) > 0.01
                          THEN 'OUT OF BALANCE'
                          ELSE 'BALANCED'
                      END AS batch_balance_status,
                      CASE
                          WHEN ABS(NVL(gjb.running_total_accounted_dr, 0)
                                 - NVL(gjb.running_total_accounted_cr, 0)) > 0.01
                          THEN 'RED'
                          ELSE 'AMBER'
                      END AS severity,
                      SYSDATE AS refresh_timestamp,
                      gjh.running_total_dr AS journal_entered_dr,
                      gjh.running_total_cr AS journal_entered_cr,
                      gjh.running_total_accounted_dr AS journal_accounted_dr,
                      gjh.running_total_accounted_cr AS journal_accounted_cr,
                      gl.currency_code AS ledger_currency_code
               FROM   apps.gl_je_headers@ADG gjh
                      JOIN apps.gl_je_batches@ADG gjb
                        ON gjb.je_batch_id = gjh.je_batch_id
                      JOIN apps.gl_ledgers@ADG gl
                        ON gl.ledger_id = gjh.ledger_id
                      LEFT JOIN apps.gl_je_categories@ADG gjc
                        ON gjc.je_category_name = gjh.je_category
               WHERE  gjh.ledger_id IN (1003, 5001, 10001)
               AND    gjh.period_name = __PERIOD_LITERAL__
               AND    gjh.status = 'U'
               ORDER BY gjh.ledger_id,
                        gjh.default_effective_date,
                        gjb.name,
                        gjh.name~',
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
                l_je_header_ids,
                l_je_batch_ids,
                l_batch_names,
                l_journal_names,
                l_journal_sources,
                l_journal_categories,
                l_effective_dates,
                l_currency_codes,
                l_balance_types,
                l_journal_descriptions,
                l_batch_descriptions,
                l_batch_balance_statuses,
                l_severities,
                l_refresh_timestamps,
                l_journal_entered_drs,
                l_journal_entered_crs,
                l_journal_accounted_drs,
                l_journal_accounted_crs,
                l_ledger_currency_codes
            LIMIT c_fetch_limit;

            EXIT WHEN l_ledger_ids.COUNT = 0;

            FOR i IN 1 .. l_ledger_ids.COUNT LOOP
                PIPE ROW (
                    xxme_gl_unposted_row_ot(
                        l_ledger_ids(i),
                        l_ledger_names(i),
                        l_result_period_names(i),
                        l_je_header_ids(i),
                        l_je_batch_ids(i),
                        l_batch_names(i),
                        l_journal_names(i),
                        l_journal_sources(i),
                        l_journal_categories(i),
                        l_effective_dates(i),
                        l_currency_codes(i),
                        l_balance_types(i),
                        l_journal_descriptions(i),
                        l_batch_descriptions(i),
                        l_batch_balance_statuses(i),
                        l_severities(i),
                        l_refresh_timestamps(i),
                        l_journal_entered_drs(i),
                        l_journal_entered_crs(i),
                        l_journal_accounted_drs(i),
                        l_journal_accounted_crs(i),
                        l_ledger_currency_codes(i)
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
    END get_journals;
END xxme_gl_unposted_pkg;
/

prompt === 5/9: XXME_AP_AR_DETAIL_PKG ===
CREATE OR REPLACE PACKAGE BODY "XXME_AP_AR_DETAIL_PKG" AS
    FUNCTION get_summary (
        p_application_id IN NUMBER,
        p_period_name     IN VARCHAR2,
        p_db_link         IN VARCHAR2
    ) RETURN xxme_ap_ar_detail_row_nt PIPELINED
    IS
        l_db_link            VARCHAR2(30) := xxme_db_source_pkg.normalize_db_link(p_db_link);
        l_period_name        VARCHAR2(15) := UPPER(TRIM(p_period_name));
        l_period_literal     VARCHAR2(40);
        l_application_text   VARCHAR2(3);
        l_period_count       PLS_INTEGER;
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
        l_refresh_timestamps t_date_tab;
    BEGIN
        IF p_application_id NOT IN (200, 222) THEN
            RAISE_APPLICATION_ERROR(-20001, 'Application must be 200 (AP) or 222 (AR).');
        END IF;

        IF l_period_name IS NULL
           OR NOT REGEXP_LIKE(l_period_name, '^[A-Z]{3}-[0-9]{4}$') THEN
            RAISE_APPLICATION_ERROR(-20002, 'Invalid period. Expected MON-YYYY.');
        END IF;

        l_period_count := xxme_db_source_pkg.period_count(
            p_db_link   => l_db_link,
            p_period_name => l_period_name
        );

        IF l_period_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20003, 'Period is outside the approved ledger scope.');
        END IF;

        l_period_literal   := DBMS_ASSERT.ENQUOTE_LITERAL(l_period_name);
        l_application_text := TO_CHAR(p_application_id);

        l_sql := q'~
WITH period_bounds AS
(
    SELECT /*+ MATERIALIZE DRIVING_SITE(gps) */
           MIN(gps.start_date) start_date,
           LEAST(MAX(gps.end_date), TRUNC(SYSDATE)) + 1 end_exclusive
    FROM   apps.gl_period_statuses@ADG gps
    WHERE  gps.application_id = __APP_ID__
    AND    gps.ledger_id IN (1003, 5001, 10001)
    AND    gps.period_name = __PERIOD__
),
candidate_events_raw AS
(
    SELECT /*+ DRIVING_SITE(xe) LEADING(pb xe) USE_NL(xe) */ xe.event_id
    FROM   period_bounds pb
           JOIN apps.xla_events@ADG xe
             ON xe.event_date >= pb.start_date
            AND xe.event_date < pb.end_exclusive
    WHERE  xe.application_id = __APP_ID__
    AND   (__APP_ID__ <> 200 OR xe.event_status_code <> 'N')
    AND   xe.process_status_code <> 'P'
    UNION ALL
    SELECT /*+ DRIVING_SITE(xah) LEADING(pb xah)
               INDEX(xah XLA_AE_HEADERS_N5) */ xah.event_id
    FROM   period_bounds pb
           JOIN apps.xla_ae_headers@ADG xah
             ON xah.accounting_date >= pb.start_date
            AND xah.accounting_date < pb.end_exclusive
    WHERE  xah.application_id = __APP_ID__
    AND    xah.ledger_id IN (1003, 5001, 10001)
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
    SELECT /*+ DRIVING_SITE(xe) LEADING(ce xe xte xah)
               USE_NL(xe) USE_NL(xte) USE_NL(xah) */
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
       s.ledger_id, gl.name, s.org_id, TRIM(hou.name), s.entity_code,
       s.exception_type, s.event_count, s.transaction_count,
       s.earliest_exception_date, s.latest_exception_date,
       TRUNC(SYSDATE) - TRUNC(s.earliest_exception_date) age_days,
       CASE
         WHEN s.exception_type IN
              ('PROCESSING/ACCOUNTING ERROR','NOT TRANSFERRED TO GL') THEN 'RED'
         WHEN TRUNC(SYSDATE) - TRUNC(s.earliest_exception_date) >= 5 THEN 'RED'
         WHEN s.exception_type = 'ACCOUNTING NOT FINAL'
           OR TRUNC(SYSDATE) - TRUNC(s.earliest_exception_date) >= 2 THEN 'AMBER'
         ELSE 'INFORMATIONAL'
       END severity,
       SYSDATE refresh_timestamp
FROM summary s
JOIN apps.gl_ledgers@ADG gl ON gl.ledger_id = s.ledger_id
LEFT JOIN apps.hr_operating_units@ADG hou
  ON hou.organization_id = s.org_id
ORDER BY s.ledger_id, s.org_id, s.entity_code, s.exception_type
~';

        l_sql := REPLACE(l_sql, '__APP_ID__', l_application_text);
        l_sql := REPLACE(l_sql, '__PERIOD__', l_period_literal);

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
                l_severities,
                l_refresh_timestamps
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
                    l_refresh_timestamps(i)
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

prompt === 6/9: XXME_GL_SUMMARY_PKG ===
CREATE OR REPLACE PACKAGE BODY "XXME_GL_SUMMARY_PKG"
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
        l_refresh_timestamps         t_date_tab;
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
            p_db_link   => l_db_link,
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
            q'~WITH
parameters AS
(
    SELECT __PERIOD_LITERAL__ AS period_name FROM dual
),
period_scope AS
(
    SELECT /*+ MATERIALIZE DRIVING_SITE(gps) */
           gps.ledger_id,
           gl.name AS ledger_name,
           gps.period_name,
           gps.closing_status,
           gps.start_date,
           gps.end_date,
           gps.last_update_date AS period_last_update_date
    FROM   apps.gl_period_statuses@ADG gps
           JOIN apps.gl_ledgers@ADG gl
             ON gl.ledger_id = gps.ledger_id
           CROSS JOIN parameters p
    WHERE  gps.application_id = 101
    AND    gps.ledger_id IN (1003, 5001, 10001)
    AND    gps.period_name = UPPER(p.period_name)
),
journal_detail AS
(
    SELECT /*+ DRIVING_SITE(gjh)
               LEADING(ps gjh gjb) USE_NL(gjh) USE_NL(gjb) */
           gjh.ledger_id,
           gjh.je_header_id,
           gjh.je_batch_id,
           gjh.je_source,
           gjh.je_category,
           gjh.status AS header_status,
           gjh.default_effective_date,
           gjh.posted_date,
           gjb.status AS batch_status,
           gjb.approval_status_code,
           gjb.running_total_accounted_dr,
           gjb.running_total_accounted_cr,
           ps.end_date
    FROM   period_scope ps
           JOIN apps.gl_je_headers@ADG gjh
             ON gjh.ledger_id = ps.ledger_id
            AND gjh.period_name = ps.period_name
           JOIN apps.gl_je_batches@ADG gjb
             ON gjb.je_batch_id = gjh.je_batch_id
),
journal_summary AS
(
    SELECT jd.ledger_id,
           COUNT(DISTINCT CASE
               WHEN jd.header_status = 'U'
               THEN jd.je_header_id END) AS unposted_due_headers,
           COUNT(DISTINCT CASE
               WHEN jd.header_status NOT IN ('P', 'U')
               THEN jd.je_header_id END) AS error_status_headers,
           COUNT(DISTINCT CASE
               WHEN ABS(NVL(jd.running_total_accounted_dr, 0)
                      - NVL(jd.running_total_accounted_cr, 0)) > 0.01
               THEN jd.je_batch_id END) AS unbalanced_due_batches,
           MIN(CASE
               WHEN jd.header_status = 'U'
               THEN jd.default_effective_date END)
             AS earliest_unposted_due_date,
           MAX(CASE
               WHEN jd.header_status = 'U'
               THEN jd.default_effective_date END)
             AS latest_unposted_due_date
    FROM journal_detail jd
    GROUP BY jd.ledger_id
),
interface_summary AS
(
    SELECT /*+ DRIVING_SITE(gi) */
           ps.ledger_id,
           COUNT(gi.status) AS interface_row_count,
           MIN(gi.accounting_date) AS earliest_interface_date,
           MAX(gi.accounting_date) AS latest_interface_date
    FROM   period_scope ps
           LEFT JOIN apps.gl_interface@ADG gi
             ON NVL(gi.ledger_id, gi.set_of_books_id) = ps.ledger_id
            AND gi.accounting_date >= ps.start_date
            AND gi.accounting_date < ps.end_date + 1
    GROUP BY ps.ledger_id
)
SELECT ps.ledger_id,
       ps.ledger_name,
       ps.period_name,
       ps.closing_status,
       CASE ps.closing_status
           WHEN 'O' THEN 'OPEN'
           WHEN 'C' THEN 'CLOSED'
           WHEN 'F' THEN 'FUTURE-ENTRY'
           WHEN 'N' THEN 'NEVER OPENED'
           WHEN 'P' THEN 'PERMANENTLY CLOSED'
           ELSE 'UNKNOWN (' || ps.closing_status || ')'
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
       ps.period_last_update_date,
       SYSDATE AS refresh_timestamp
FROM   period_scope ps
       LEFT JOIN journal_summary js
         ON js.ledger_id = ps.ledger_id
       LEFT JOIN interface_summary isum
         ON isum.ledger_id = ps.ledger_id
ORDER BY ps.ledger_id~',
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
                l_period_last_update_dates,
                l_refresh_timestamps
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
                        l_refresh_timestamps(i)
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

prompt === 7/9: XXME_AP_AR_KPI_PKG ===
CREATE OR REPLACE PACKAGE BODY "XXME_AP_AR_KPI_PKG"
AS
    FUNCTION get_cards (
        p_period_name IN VARCHAR2,
        p_db_link     IN VARCHAR2
    ) RETURN xxme_module_kpi_row_nt PIPELINED
    IS
        l_db_link              VARCHAR2(30) := xxme_db_source_pkg.normalize_db_link(p_db_link);
        l_period_name          VARCHAR2(15);
        l_period_literal       VARCHAR2(40);
        l_period_count         PLS_INTEGER;
        l_sql                  CLOB;
        l_rc                   SYS_REFCURSOR;
        l_cursor_open          BOOLEAN := FALSE;
        l_application_id       NUMBER;
        l_module_name          VARCHAR2(30);
        l_actionable_count     NUMBER;
        l_red_count            NUMBER;
        l_amber_count          NUMBER;
        l_information_count    NUMBER;
        l_us_count             NUMBER;
        l_uk_count             NUMBER;
        l_ch_count             NUMBER;
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
            p_db_link   => l_db_link,
            p_period_name => l_period_name
        );

        IF l_period_count = 0 THEN
            RAISE_APPLICATION_ERROR(
                -20022,
                'Accounting period is not available in the approved ledger scope.'
            );
        END IF;

        l_period_literal := DBMS_ASSERT.ENQUOTE_LITERAL(l_period_name);

        FOR i IN 1 .. 2 LOOP
            IF i = 1 THEN
                l_application_id := 200;
                l_module_name := 'Payables';
            ELSE
                l_application_id := 222;
                l_module_name := 'Receivables';
            END IF;

            l_sql := REPLACE(
                REPLACE(
                    q'~WITH
parameters AS
(
    SELECT __PERIOD_LITERAL__ AS period_name,
           2 AS warning_age_days,
           5 AS critical_age_days
    FROM dual
),
period_bounds AS
(
    SELECT /*+ MATERIALIZE DRIVING_SITE(gps) */
           MIN(gps.start_date) AS start_date,
           LEAST(MAX(gps.end_date), TRUNC(SYSDATE)) + 1 AS end_exclusive,
           MAX(p.warning_age_days) AS warning_age_days,
           MAX(p.critical_age_days) AS critical_age_days
    FROM   apps.gl_period_statuses@ADG gps
           CROSS JOIN parameters p
    WHERE  gps.application_id = __APPLICATION_ID__
    AND    gps.ledger_id IN (1003, 5001, 10001)
    AND    gps.period_name = UPPER(p.period_name)
),
candidate_events_raw AS
(
    SELECT /*+ DRIVING_SITE(xe)
               LEADING(pb xe)
               USE_NL(xe) */
           xe.event_id
    FROM   period_bounds pb
           JOIN apps.xla_events@ADG xe
             ON xe.event_date >= pb.start_date
            AND xe.event_date <  pb.end_exclusive
    WHERE  xe.application_id = __APPLICATION_ID__
    AND   (__APPLICATION_ID__ <> 200 OR xe.event_status_code <> 'N')
    AND   xe.process_status_code <> 'P'

    UNION ALL

    SELECT /*+ DRIVING_SITE(xah)
               LEADING(pb xah)
               INDEX(xah XLA_AE_HEADERS_N5) */
           xah.event_id
    FROM   period_bounds pb
           JOIN apps.xla_ae_headers@ADG xah
             ON xah.accounting_date >= pb.start_date
            AND xah.accounting_date <  pb.end_exclusive
    WHERE  xah.application_id = __APPLICATION_ID__
    AND    xah.ledger_id IN (1003, 5001, 10001)
    AND   (NVL(xah.accounting_entry_status_code, '?') <> 'F'
           OR NVL(xah.gl_transfer_status_code, '?') <> 'Y')
    AND    xah.event_id IS NOT NULL
),
candidate_events AS
(
    SELECT DISTINCT event_id
    FROM candidate_events_raw
),
event_evaluation AS
(
    SELECT /*+ DRIVING_SITE(xe)
               LEADING(ce xe xte xah)
               USE_NL(xe)
               USE_NL(xte)
               USE_NL(xah) */
           xte.ledger_id,
           xte.security_id_int_1 AS org_id,
           xte.entity_code,
           xte.source_id_int_1 AS transaction_id,
           xe.event_id,
           xe.event_date,
           xe.event_status_code,
           xe.process_status_code,
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
             ON xe.application_id = __APPLICATION_ID__
            AND xe.event_id = ce.event_id
           JOIN xla.xla_transaction_entities@ADG xte
             ON xte.application_id = xe.application_id
            AND xte.entity_id = xe.entity_id
           LEFT JOIN apps.xla_ae_headers@ADG xah
             ON xah.application_id = xe.application_id
            AND xah.event_id = xe.event_id
            AND xah.ledger_id = xte.ledger_id
    WHERE  xte.ledger_id IN (1003, 5001, 10001)
    GROUP BY xte.ledger_id,
             xte.security_id_int_1,
             xte.entity_code,
             xte.source_id_int_1,
             xe.event_id,
             xe.event_date,
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
               WHEN e.process_status_code <> 'P'
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
    SELECT c.ledger_id,
           c.org_id,
           c.entity_code,
           c.exception_type,
           COUNT(DISTINCT c.event_id) AS event_count,
           TRUNC(SYSDATE) - TRUNC(MIN(c.exception_date)) AS age_days,
           CASE
               WHEN c.exception_type IN
                    ('PROCESSING/ACCOUNTING ERROR', 'NOT TRANSFERRED TO GL')
               THEN 'RED'
               WHEN TRUNC(SYSDATE) - TRUNC(MIN(c.exception_date))
                    >= pb.critical_age_days
               THEN 'RED'
               WHEN c.exception_type = 'ACCOUNTING NOT FINAL'
                 OR TRUNC(SYSDATE) - TRUNC(MIN(c.exception_date))
                    >= pb.warning_age_days
               THEN 'AMBER'
               ELSE 'INFORMATIONAL'
           END AS severity
    FROM   classified c
           CROSS JOIN period_bounds pb
    WHERE  c.exception_type IS NOT NULL
    GROUP BY c.ledger_id,
             c.org_id,
             c.entity_code,
             c.exception_type,
             pb.warning_age_days,
             pb.critical_age_days
)
SELECT NVL(SUM(CASE WHEN severity IN ('RED', 'AMBER')
                    THEN event_count ELSE 0 END), 0) AS actionable_count,
       NVL(SUM(CASE WHEN severity = 'RED'
                    THEN event_count ELSE 0 END), 0) AS red_count,
       NVL(SUM(CASE WHEN severity = 'AMBER'
                    THEN event_count ELSE 0 END), 0) AS amber_count,
       NVL(SUM(CASE WHEN severity = 'INFORMATIONAL'
                    THEN event_count ELSE 0 END), 0) AS informational_count,
       NVL(SUM(CASE WHEN ledger_id = 1003
                     AND severity IN ('RED', 'AMBER')
                    THEN event_count ELSE 0 END), 0) AS us_count,
       NVL(SUM(CASE WHEN ledger_id = 5001
                     AND severity IN ('RED', 'AMBER')
                    THEN event_count ELSE 0 END), 0) AS uk_count,
       NVL(SUM(CASE WHEN ledger_id = 10001
                     AND severity IN ('RED', 'AMBER')
                    THEN event_count ELSE 0 END), 0) AS ch_count
FROM summary~',
                    '__PERIOD_LITERAL__',
                    l_period_literal
                ),
                '__APPLICATION_ID__',
                TO_CHAR(l_application_id)
            );

            l_sql := REPLACE(l_sql, '@ADG', '@' || l_db_link);

            OPEN l_rc FOR l_sql;
            l_cursor_open := TRUE;

            FETCH l_rc
            INTO  l_actionable_count,
                  l_red_count,
                  l_amber_count,
                  l_information_count,
                  l_us_count,
                  l_uk_count,
                  l_ch_count;

            CLOSE l_rc;
            l_cursor_open := FALSE;

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
                    SYSDATE
                )
            );
        END LOOP;

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
    END get_cards;
END xxme_ap_ar_kpi_pkg;
/

prompt === 8/9: XXME_SLA_ERROR_DRILL_PKG ===
CREATE OR REPLACE PACKAGE BODY "XXME_SLA_ERROR_DRILL_PKG" AS

    FUNCTION number_literal(p_value IN NUMBER) RETURN VARCHAR2 IS
    BEGIN
        RETURN TO_CHAR(
            TRUNC(p_value),
            'FM99999999999999999999999999999999999990',
            'NLS_NUMERIC_CHARACTERS=''.,'''
        );
    END number_literal;

    FUNCTION date_literal(p_value IN DATE) RETURN VARCHAR2 IS
    BEGIN
        RETURN
            'TO_DATE(''' || TO_CHAR(p_value, 'YYYYMMDDHH24MISS') ||
            ''',''YYYYMMDDHH24MISS'')';
    END date_literal;

    FUNCTION get_errors
    (
        p_period_name     IN VARCHAR2,
        p_application_id  IN NUMBER,
        p_ledger_id       IN NUMBER,
        p_organization_id IN NUMBER,
        p_entity_code     IN VARCHAR2,
        p_db_link         IN VARCHAR2
    )
    RETURN xxme_sla_acct_error_nt PIPELINED
    IS
        l_db_link         VARCHAR2(30) := xxme_db_source_pkg.normalize_db_link(p_db_link);
        l_period_name     VARCHAR2(30) := UPPER(TRIM(p_period_name));
        l_application_id  NUMBER       := TRUNC(p_application_id);
        l_ledger_id       NUMBER       := TRUNC(p_ledger_id);
        l_organization_id NUMBER       := TRUNC(p_organization_id);
        l_entity_code     VARCHAR2(30) := UPPER(TRIM(p_entity_code));
        l_period_sql      VARCHAR2(2000);
        l_sql             VARCHAR2(32767);
        l_org_predicate   VARCHAR2(200);
        l_start_date      DATE;
        l_end_date        DATE;
        l_rc              SYS_REFCURSOR;
        l_open            BOOLEAN := FALSE;

        c_fetch_limit     CONSTANT PLS_INTEGER := 500;

        TYPE t_number_tab IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
        TYPE t_date_tab IS TABLE OF DATE INDEX BY PLS_INTEGER;
        TYPE t_varchar20_tab IS TABLE OF VARCHAR2(20) INDEX BY PLS_INTEGER;
        TYPE t_varchar30_tab IS TABLE OF VARCHAR2(30) INDEX BY PLS_INTEGER;
        TYPE t_varchar40_tab IS TABLE OF VARCHAR2(40) INDEX BY PLS_INTEGER;
        TYPE t_varchar100_tab IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
        TYPE t_varchar240_tab IS TABLE OF VARCHAR2(240) INDEX BY PLS_INTEGER;
        TYPE t_varchar4000_tab IS TABLE OF VARCHAR2(4000) INDEX BY PLS_INTEGER;

        l_accounting_error_ids          t_number_tab;
        l_result_application_ids        t_number_tab;
        l_sla_sources                   t_varchar30_tab;
        l_result_ledger_ids             t_number_tab;
        l_ledger_names                  t_varchar240_tab;
        l_result_organization_ids       t_number_tab;
        l_result_entity_codes           t_varchar30_tab;
        l_source_transaction_ids        t_number_tab;
        l_transaction_numbers           t_varchar240_tab;
        l_event_ids                     t_number_tab;
        l_event_type_codes              t_varchar30_tab;
        l_event_status_codes            t_varchar30_tab;
        l_process_status_codes          t_varchar30_tab;
        l_transaction_dates             t_date_tab;
        l_ae_header_ids                 t_number_tab;
        l_ae_line_nums                  t_number_tab;
        l_accounting_dates              t_date_tab;
        l_accounting_entry_status_codes t_varchar30_tab;
        l_gl_transfer_status_codes      t_varchar30_tab;
        l_message_numbers               t_varchar100_tab;
        l_error_source_codes            t_varchar30_tab;
        l_error_messages                t_varchar4000_tab;
        l_error_creation_dates          t_date_tab;
        l_error_age_days_tab            t_number_tab;
        l_exception_types               t_varchar40_tab;
        l_severities                    t_varchar20_tab;
        l_refresh_timestamps            t_date_tab;
    BEGIN
        IF l_period_name IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'Accounting period is required.');
        END IF;

        IF l_application_id IS NULL
           OR l_application_id NOT IN (200, 222, 707)
        THEN
            RAISE_APPLICATION_ERROR(
                -20003,
                'Application ID is outside the approved SLA scope.'
            );
        END IF;

        IF l_ledger_id IS NULL
           OR l_ledger_id NOT IN (1003, 5001, 10001)
        THEN
            RAISE_APPLICATION_ERROR(
                -20004,
                'Ledger ID is outside the approved ledger scope.'
            );
        END IF;

        IF l_entity_code IS NULL THEN
            RAISE_APPLICATION_ERROR(-20005, 'Entity code is required.');
        END IF;

        IF p_application_id <> l_application_id
           OR p_ledger_id <> l_ledger_id
           OR (
               p_organization_id IS NOT NULL
               AND p_organization_id <> l_organization_id
           )
        THEN
            RAISE_APPLICATION_ERROR(-20006, 'Identifier values must be integers.');
        END IF;

        l_period_sql :=
            'SELECT MIN(gps.start_date), MAX(gps.end_date) ' ||
            'FROM apps.gl_period_statuses@ADG gps ' ||
            'WHERE gps.application_id = 101 ' ||
            'AND gps.ledger_id = ' || number_literal(l_ledger_id) || ' ' ||
            'AND UPPER(gps.period_name) = ' ||
            DBMS_ASSERT.ENQUOTE_LITERAL(l_period_name);

        l_period_sql := REPLACE(l_period_sql, '@ADG', '@' || l_db_link);
        EXECUTE IMMEDIATE l_period_sql INTO l_start_date, l_end_date;

        IF l_start_date IS NULL OR l_end_date IS NULL THEN
            RAISE_APPLICATION_ERROR(
                -20002,
                'Accounting period was not found for the selected ledger.'
            );
        END IF;

        IF l_organization_id IS NULL THEN
            l_org_predicate := NULL;
        ELSE
            l_org_predicate :=
                ' AND xte.security_id_int_1 = ' ||
                number_literal(l_organization_id);
        END IF;

        l_sql := q'~
SELECT /*+ DRIVING_SITE(xah) LEADING(xah xe xte) USE_NL(xe xte ae gl) */
       NVL(ae.accounting_error_id, -xah.ae_header_id)
           AS accounting_error_id,
       xah.application_id,
       CASE xah.application_id
           WHEN 200 THEN 'PAYABLES'
           WHEN 222 THEN 'RECEIVABLES'
           WHEN 707 THEN 'COST MANAGEMENT'
       END AS sla_source,
       xah.ledger_id,
       gl.name AS ledger_name,
       xte.security_id_int_1 AS organization_id,
       xte.entity_code,
       xte.source_id_int_1 AS source_transaction_id,
       xte.transaction_number,
       xe.event_id,
       xe.event_type_code,
       xe.event_status_code,
       xe.process_status_code,
       xe.transaction_date,
       xah.ae_header_id,
       ae.ae_line_num,
       xah.accounting_date,
       xah.accounting_entry_status_code,
       xah.gl_transfer_status_code,
       TO_CHAR(ae.message_number) AS message_number,
       NVL(ae.error_source_code, 'XLA_AE_HEADERS') AS error_source_code,
       CASE
           WHEN ae.accounting_error_id IS NOT NULL
           THEN SUBSTR(ae.encoded_msg, 1, 4000)
           ELSE 'Accounting header is in error status, but no detailed XLA error message is available.'
       END AS error_message,
       NVL(ae.creation_date, xah.creation_date) AS error_creation_date,
       TRUNC(SYSDATE) -
           TRUNC(NVL(xah.accounting_date, xe.transaction_date))
           AS error_age_days,
       'PROCESSING/ACCOUNTING ERROR' AS exception_type,
       'RED' AS severity,
       SYSDATE AS refresh_timestamp
  FROM apps.xla_ae_headers@ADG xah
  JOIN apps.xla_events@ADG xe
    ON xe.application_id = xah.application_id
   AND xe.event_id = xah.event_id
  JOIN xla.xla_transaction_entities@ADG xte
    ON xte.application_id = xe.application_id
   AND xte.entity_id = xe.entity_id
  LEFT JOIN apps.xla_accounting_errors@ADG ae
    ON ae.application_id = xah.application_id
   AND ae.ae_header_id = xah.ae_header_id
   AND ae.event_id = xah.event_id
  LEFT JOIN apps.gl_ledgers@ADG gl
    ON gl.ledger_id = xah.ledger_id
 WHERE xah.application_id = __APPLICATION_ID__
   AND xah.ledger_id = __LEDGER_ID__
   AND xah.accounting_date >= __START_DATE__
   AND xah.accounting_date < __END_DATE__ + 1
   AND xah.accounting_entry_status_code
       IN ('I', 'RELATED_EVENT_ERROR')
   AND UPPER(xte.entity_code) = __ENTITY_CODE__
   __ORG_PREDICATE__
   AND NOT EXISTS
       (
           SELECT /*+ INDEX(successful_xah) */ 1
             FROM apps.xla_ae_headers@ADG successful_xah
            WHERE successful_xah.application_id = xah.application_id
              AND successful_xah.event_id = xah.event_id
              AND successful_xah.ledger_id = xah.ledger_id
              AND successful_xah.accounting_entry_status_code = 'F'
              AND successful_xah.gl_transfer_status_code = 'Y'
       )
 ORDER BY xe.transaction_date,
          xe.event_id,
          xah.ae_header_id,
          ae.accounting_error_id
~';

        l_sql := REPLACE(
            l_sql,
            '__APPLICATION_ID__',
            number_literal(l_application_id)
        );
        l_sql := REPLACE(
            l_sql,
            '__LEDGER_ID__',
            number_literal(l_ledger_id)
        );
        l_sql := REPLACE(l_sql, '__START_DATE__', date_literal(l_start_date));
        l_sql := REPLACE(l_sql, '__END_DATE__', date_literal(l_end_date));
        l_sql := REPLACE(
            l_sql,
            '__ENTITY_CODE__',
            DBMS_ASSERT.ENQUOTE_LITERAL(l_entity_code)
        );
        l_sql := REPLACE(l_sql, '__ORG_PREDICATE__', l_org_predicate);

        l_sql := REPLACE(l_sql, '@ADG', '@' || l_db_link);

        OPEN l_rc FOR l_sql;
        l_open := TRUE;

        LOOP
            FETCH l_rc BULK COLLECT INTO
                l_accounting_error_ids,
                l_result_application_ids,
                l_sla_sources,
                l_result_ledger_ids,
                l_ledger_names,
                l_result_organization_ids,
                l_result_entity_codes,
                l_source_transaction_ids,
                l_transaction_numbers,
                l_event_ids,
                l_event_type_codes,
                l_event_status_codes,
                l_process_status_codes,
                l_transaction_dates,
                l_ae_header_ids,
                l_ae_line_nums,
                l_accounting_dates,
                l_accounting_entry_status_codes,
                l_gl_transfer_status_codes,
                l_message_numbers,
                l_error_source_codes,
                l_error_messages,
                l_error_creation_dates,
                l_error_age_days_tab,
                l_exception_types,
                l_severities,
                l_refresh_timestamps
            LIMIT c_fetch_limit;

            EXIT WHEN l_accounting_error_ids.COUNT = 0;

            FOR i IN 1 .. l_accounting_error_ids.COUNT LOOP
                PIPE ROW
                (
                    xxme_sla_acct_error_ot
                    (
                        l_accounting_error_ids(i),
                        l_result_application_ids(i),
                        l_sla_sources(i),
                        l_result_ledger_ids(i),
                        l_ledger_names(i),
                        l_result_organization_ids(i),
                        l_result_entity_codes(i),
                        l_source_transaction_ids(i),
                        l_transaction_numbers(i),
                        l_event_ids(i),
                        l_event_type_codes(i),
                        l_event_status_codes(i),
                        l_process_status_codes(i),
                        l_transaction_dates(i),
                        l_ae_header_ids(i),
                        l_ae_line_nums(i),
                        l_accounting_dates(i),
                        l_accounting_entry_status_codes(i),
                        l_gl_transfer_status_codes(i),
                        l_message_numbers(i),
                        l_error_source_codes(i),
                        l_error_messages(i),
                        l_error_creation_dates(i),
                        l_error_age_days_tab(i),
                        l_exception_types(i),
                        l_severities(i),
                        l_refresh_timestamps(i)
                    )
                );
            END LOOP;
        END LOOP;

        CLOSE l_rc;
        l_open := FALSE;
        RETURN;
    EXCEPTION
        WHEN NO_DATA_NEEDED THEN
            IF l_open THEN
                CLOSE l_rc;
            END IF;
            RETURN;
        WHEN OTHERS THEN
            IF l_open THEN
                CLOSE l_rc;
            END IF;
            RAISE;
    END get_errors;

END xxme_sla_error_drill_pkg;
/

prompt === 9/9: XXME_SLA_SUMMARY_PKG ===
CREATE OR REPLACE PACKAGE BODY "XXME_SLA_SUMMARY_PKG"
AS
    FUNCTION get_summary (
        p_period_name IN VARCHAR2,
        p_db_link     IN VARCHAR2
    ) RETURN xxme_sla_summary_row_nt PIPELINED
    IS
        l_db_link                    VARCHAR2(30) := xxme_db_source_pkg.normalize_db_link(p_db_link);
        l_period_name                VARCHAR2(15);
        l_period_literal             VARCHAR2(40);
        l_period_count               PLS_INTEGER;
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
        l_refresh_timestamps         t_date_tab;
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
            p_db_link   => l_db_link,
            p_period_name => l_period_name
        );

        IF l_period_count = 0 THEN
            RAISE_APPLICATION_ERROR(
                -20012,
                'Accounting period is not available in the approved ledger scope.'
            );
        END IF;

        l_period_literal := DBMS_ASSERT.ENQUOTE_LITERAL(l_period_name);

        l_sql := REPLACE(
            q'~WITH
parameters AS
(
    SELECT __PERIOD_LITERAL__ AS period_name,
           2 AS warning_age_days,
           5 AS critical_age_days
    FROM dual
),
period_bounds AS
(
    SELECT /*+ MATERIALIZE DRIVING_SITE(gps) */
           MIN(gps.start_date) AS start_date,
           LEAST(MAX(gps.end_date), TRUNC(SYSDATE)) + 1 AS end_exclusive,
           MAX(p.warning_age_days) AS warning_age_days,
           MAX(p.critical_age_days) AS critical_age_days
    FROM   apps.gl_period_statuses@ADG gps
           CROSS JOIN parameters p
    WHERE  gps.application_id = 101
    AND    gps.ledger_id IN (1003, 5001, 10001)
    AND    gps.period_name = UPPER(p.period_name)
),
candidate_events_raw AS
(
    -- Cost Management: use the process-status index and validate the SLA event date.
    SELECT /*+ DRIVING_SITE(xe)
               LEADING(xe pb)
               INDEX(xe XLA_EVENTS_N3) */
           xe.application_id,
           xe.event_id
    FROM   apps.xla_events@ADG xe
           CROSS JOIN period_bounds pb
    WHERE  xe.application_id = 707
    AND    xe.event_date >= pb.start_date
    AND    xe.event_date <  pb.end_exclusive
    AND    xe.event_status_code <> 'N'
    AND    xe.process_status_code IN ('U', 'I', 'R', 'D')

    UNION ALL

    -- Cost Management: only final accounting not transferred to GL.
    -- Draft/error headers are reached through the event branch above.
    SELECT /*+ DRIVING_SITE(xah)
               LEADING(pb xah)
               INDEX(xah XLA_AE_HEADERS_N5) */
           xah.application_id,
           xah.event_id
    FROM   period_bounds pb
           JOIN apps.xla_ae_headers@ADG xah
             ON xah.accounting_date >= pb.start_date
            AND xah.accounting_date <  pb.end_exclusive
    WHERE  xah.application_id = 707
    AND    xah.ledger_id IN (1003, 5001, 10001)
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
    SELECT /*+ DRIVING_SITE(xe)
               LEADING(ce xe xte xah)
               USE_NL(xe)
               USE_NL(xte)
               USE_NL(xah) */
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
               -- A successfully completed and transferred header is authoritative.
               -- Ignore stale event/process statuses and superseded error headers.
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
           TRUNC(SYSDATE) - TRUNC(MIN(c.exception_date))
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
       TRIM(ood.organization_name) AS operating_unit,
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
           WHEN s.oldest_exception_age_days >= pb.critical_age_days
           THEN 'RED'
           WHEN s.exception_type = 'ACCOUNTING NOT FINAL'
             OR s.oldest_exception_age_days >= pb.warning_age_days
           THEN 'AMBER'
           ELSE 'INFORMATIONAL'
       END AS severity,
       SYSDATE AS refresh_timestamp
FROM   summary s
       CROSS JOIN period_bounds pb
       JOIN apps.gl_ledgers@ADG gl
         ON gl.ledger_id = s.ledger_id
       LEFT JOIN apps.org_organization_definitions@ADG ood
         ON ood.organization_id = s.org_id
ORDER BY s.ledger_id,
         s.application_id,
         s.org_id,
         s.entity_code,
         s.exception_type~',
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
                l_severities,
                l_refresh_timestamps
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
                        l_refresh_timestamps(i)
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

show errors
