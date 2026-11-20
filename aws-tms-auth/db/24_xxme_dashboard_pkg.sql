set define off

-- Wave 3 (Item 2): Home Dashboard (Page 1 MONTH_END_OVERVIEW) service package.
-- Consolidates 8 sequential @ADG round trips into:
--   1. One gl_period_statuses query (validating GL 101 scope + fetching AP 200 & AR 222 bounds)
--   2. One GL summary query (XXME_GL_SUMMARY_PKG semantics)
--   3. One combined XLA SLA exception query for application_id IN (200, 222) with per-app
--      date bounds and future-period short-circuiting.

CREATE OR REPLACE TYPE xxme_dashboard_card_ot FORCE AS OBJECT (
  display_sequence NUMBER,
  target_page      NUMBER,
  target_item      VARCHAR2(30),
  card_title       VARCHAR2(100),
  card_text        VARCHAR2(500),
  card_icon        VARCHAR2(100),
  card_color_class VARCHAR2(30),
  open_count       NUMBER,
  us_count         NUMBER,
  uk_count         NUMBER,
  ch_count         NUMBER,
  is_clickable     VARCHAR2(1),
  card_link        VARCHAR2(2000)
);
/

CREATE OR REPLACE TYPE xxme_dashboard_card_nt AS TABLE OF xxme_dashboard_card_ot;
/

CREATE OR REPLACE PACKAGE xxme_dashboard_pkg AUTHID DEFINER AS
  FUNCTION get_overview_cards (
    p_period_name IN VARCHAR2,
    p_db_link     IN VARCHAR2 DEFAULT 'ADG',
    p_app_id      IN NUMBER   DEFAULT NULL
  ) RETURN xxme_dashboard_card_nt PIPELINED;
END xxme_dashboard_pkg;
/

CREATE OR REPLACE PACKAGE BODY xxme_dashboard_pkg AS

  FUNCTION build_card_link (
    p_app_id      IN NUMBER,
    p_target_page IN NUMBER,
    p_target_item IN VARCHAR2,
    p_period_name IN VARCHAR2,
    p_db_link     IN VARCHAR2
  ) RETURN VARCHAR2 IS
  BEGIN
    IF p_target_page IS NULL THEN
      RETURN NULL;
    END IF;

    IF p_app_id IS NOT NULL AND apex_application.g_flow_id IS NOT NULL THEN
      RETURN apex_page.get_url(
        p_application => p_app_id,
        p_page        => p_target_page,
        p_clear_cache => TO_CHAR(p_target_page),
        p_items       => p_target_item || ',P' || p_target_page || '_DB_LINK',
        p_values      => p_period_name || ',' || p_db_link
      );
    END IF;

    IF p_app_id IS NOT NULL THEN
      RETURN 'f?p=' || p_app_id || ':' || p_target_page || ':::' || p_target_page || ':' ||
             p_target_item || ',P' || p_target_page || '_DB_LINK:' ||
             p_period_name || ',' || p_db_link;
    END IF;

    RETURN NULL;
  END build_card_link;

  FUNCTION get_overview_cards (
    p_period_name IN VARCHAR2,
    p_db_link     IN VARCHAR2 DEFAULT 'ADG',
    p_app_id      IN NUMBER   DEFAULT NULL
  ) RETURN xxme_dashboard_card_nt PIPELINED IS
    l_db_link     VARCHAR2(30) := xxme_db_source_pkg.normalize_db_link(p_db_link);
    l_period_name VARCHAR2(15) := UPPER(TRIM(p_period_name));
    l_period_lit  VARCHAR2(40);
    l_app_id      NUMBER := COALESCE(p_app_id, apex_application.g_flow_id, TO_NUMBER(v('APP_ID')));
    l_today       DATE := TRUNC(SYSDATE);
    l_today_lit   VARCHAR2(40);
    l_sql         CLOB;
    l_rc          SYS_REFCURSOR;
    l_open        BOOLEAN := FALSE;

    -- Single-round-trip period validation + per-app date bounds
    l_has_gl      BOOLEAN := FALSE;
    l_ap_start    DATE;
    l_ap_end      DATE;
    l_ar_start    DATE;
    l_ar_end      DATE;
    l_ap_end_excl DATE;
    l_ar_end_excl DATE;
    l_run_ap      BOOLEAN := FALSE;
    l_run_ar      BOOLEAN := FALSE;

    -- GL summary counters (preserving XXME_GL_SUMMARY_PKG + Page 1 card semantics)
    l_gl_open     NUMBER := 0;
    l_gl_us       NUMBER := 0;
    l_gl_uk       NUMBER := 0;
    l_gl_ch       NUMBER := 0;
    l_gl_bad      NUMBER := 0;
    l_gl_color    VARCHAR2(30);

    -- AP (200) and AR (222) SLA summary counters
    l_ap_open     NUMBER := 0;
    l_ap_us       NUMBER := 0;
    l_ap_uk       NUMBER := 0;
    l_ap_ch       NUMBER := 0;
    l_ap_red      NUMBER := 0;
    l_ap_color    VARCHAR2(30);

    l_ar_open     NUMBER := 0;
    l_ar_us       NUMBER := 0;
    l_ar_uk       NUMBER := 0;
    l_ar_ch       NUMBER := 0;
    l_ar_red      NUMBER := 0;
    l_ar_color    VARCHAR2(30);

    -- Cursor fetch targets
    l_bound_app   NUMBER;
    l_bound_start DATE;
    l_bound_end   DATE;

    l_sla_app     NUMBER;
    l_sla_open    NUMBER;
    l_sla_us      NUMBER;
    l_sla_uk      NUMBER;
    l_sla_ch      NUMBER;
    l_sla_red     NUMBER;

    l_branch_sql  CLOB;
    l_ai_status   VARCHAR2(30);

    PROCEDURE close_rc IS
    BEGIN
      IF l_open THEN
        CLOSE l_rc;
        l_open := FALSE;
      END IF;
    END close_rc;
  BEGIN
    IF l_period_name IS NULL
       OR NOT REGEXP_LIKE(l_period_name, '^[A-Z]{3}-[0-9]{4}$')
    THEN
      RAISE_APPLICATION_ERROR(-20001, 'Invalid accounting period format. Expected MON-YYYY.');
    END IF;

    l_period_lit := DBMS_ASSERT.ENQUOTE_LITERAL(l_period_name);
    l_today_lit  := 'DATE ' || DBMS_ASSERT.ENQUOTE_LITERAL(TO_CHAR(l_today, 'YYYY-MM-DD'));

    -- Step 1: Resolve period scope and per-application date bounds in one round trip.
    l_sql := REPLACE(
      q'~SELECT /*+ DRIVING_SITE(gps) */
       gps.application_id,
       MIN(gps.start_date) AS start_date,
       MAX(gps.end_date)   AS end_date
  FROM apps.gl_period_statuses@ADG gps
 WHERE gps.application_id IN (101, 200, 222)
   AND gps.ledger_id IN (1003, 5001, 10001)
   AND gps.period_name = :b_period
 GROUP BY gps.application_id~',
      '@ADG', '@' || l_db_link
    );

    OPEN l_rc FOR l_sql USING l_period_name;
    l_open := TRUE;
    LOOP
      FETCH l_rc INTO l_bound_app, l_bound_start, l_bound_end;
      EXIT WHEN l_rc%NOTFOUND;
      IF l_bound_app = 101 THEN
        l_has_gl := TRUE;
      ELSIF l_bound_app = 200 THEN
        l_ap_start := TRUNC(l_bound_start);
        l_ap_end   := TRUNC(l_bound_end);
      ELSIF l_bound_app = 222 THEN
        l_ar_start := TRUNC(l_bound_start);
        l_ar_end   := TRUNC(l_bound_end);
      END IF;
    END LOOP;
    close_rc;

    IF NOT l_has_gl THEN
      RAISE_APPLICATION_ERROR(-20002, 'Accounting period is not available in the approved ledger scope.');
    END IF;

    -- Step 2: Fetch GL open-item totals in one aggregate remote query.
    l_sql := REPLACE(
      REPLACE(
        q'~SELECT /*+ DRIVING_SITE(gps) */
       NVL(SUM(NVL(js.unposted_due_headers, 0) + NVL(js.error_status_headers, 0) +
               NVL(js.unbalanced_due_batches, 0) + NVL(isum.interface_row_count, 0)), 0) AS open_count,
       NVL(SUM(CASE WHEN gps.ledger_id = 1003 THEN
               NVL(js.unposted_due_headers, 0) + NVL(js.error_status_headers, 0) +
               NVL(js.unbalanced_due_batches, 0) + NVL(isum.interface_row_count, 0) ELSE 0 END), 0) AS us_count,
       NVL(SUM(CASE WHEN gps.ledger_id = 5001 THEN
               NVL(js.unposted_due_headers, 0) + NVL(js.error_status_headers, 0) +
               NVL(js.unbalanced_due_batches, 0) + NVL(isum.interface_row_count, 0) ELSE 0 END), 0) AS uk_count,
       NVL(SUM(CASE WHEN gps.ledger_id = 10001 THEN
               NVL(js.unposted_due_headers, 0) + NVL(js.error_status_headers, 0) +
               NVL(js.unbalanced_due_batches, 0) + NVL(isum.interface_row_count, 0) ELSE 0 END), 0) AS ch_count,
       NVL(SUM(NVL(js.error_status_headers, 0) + NVL(js.unbalanced_due_batches, 0)), 0) AS bad_count
  FROM apps.gl_period_statuses@ADG gps
  LEFT JOIN (
    SELECT gjh.ledger_id,
           COUNT(DISTINCT CASE WHEN gjh.status = 'U' THEN gjh.je_header_id END) AS unposted_due_headers,
           COUNT(DISTINCT CASE WHEN gjh.status NOT IN ('P', 'U') THEN gjh.je_header_id END) AS error_status_headers,
           COUNT(DISTINCT CASE WHEN ABS(NVL(gjb.running_total_accounted_dr, 0)
                                      - NVL(gjb.running_total_accounted_cr, 0)) > 0.01
                               THEN gjh.je_batch_id END) AS unbalanced_due_batches
      FROM apps.gl_je_headers@ADG gjh
      JOIN apps.gl_je_batches@ADG gjb
        ON gjb.je_batch_id = gjh.je_batch_id
     WHERE gjh.ledger_id IN (1003, 5001, 10001)
       AND gjh.period_name = __PERIOD_LITERAL__
     GROUP BY gjh.ledger_id
  ) js
    ON js.ledger_id = gps.ledger_id
  LEFT JOIN (
    SELECT gps2.ledger_id,
           COUNT(gi.status) AS interface_row_count
      FROM apps.gl_period_statuses@ADG gps2
      JOIN apps.gl_interface@ADG gi
        ON NVL(gi.ledger_id, gi.set_of_books_id) = gps2.ledger_id
       AND gi.accounting_date >= gps2.start_date
       AND gi.accounting_date <  gps2.end_date + 1
     WHERE gps2.application_id = 101
       AND gps2.ledger_id IN (1003, 5001, 10001)
       AND gps2.period_name = __PERIOD_LITERAL__
     GROUP BY gps2.ledger_id
  ) isum
    ON isum.ledger_id = gps.ledger_id
 WHERE gps.application_id = 101
   AND gps.ledger_id IN (1003, 5001, 10001)
   AND gps.period_name = __PERIOD_LITERAL__~',
        '__PERIOD_LITERAL__', l_period_lit
      ),
      '@ADG', '@' || l_db_link
    );

    EXECUTE IMMEDIATE l_sql
      INTO l_gl_open, l_gl_us, l_gl_uk, l_gl_ch, l_gl_bad;

    l_gl_color := CASE
                    WHEN l_gl_bad > 0 THEN 'kpi-bad'
                    WHEN l_gl_open > 0 THEN 'kpi-warn'
                    ELSE 'kpi-good'
                  END;

    -- Step 3: Combined AP (200) + AR (222) XLA exception pass with future-period short-circuit.
    IF l_ap_start IS NOT NULL AND l_ap_end IS NOT NULL THEN
      l_ap_end_excl := LEAST(l_ap_end, l_today) + 1;
      l_run_ap := (l_ap_end_excl > l_ap_start);
    END IF;

    IF l_ar_start IS NOT NULL AND l_ar_end IS NOT NULL THEN
      l_ar_end_excl := LEAST(l_ar_end, l_today) + 1;
      l_run_ar := (l_ar_end_excl > l_ar_start);
    END IF;

    IF l_run_ap OR l_run_ar THEN
      IF l_run_ap THEN
        l_branch_sql := REPLACE(
          REPLACE(
            q'~    SELECT /*+ INDEX(xe XLA_EVENTS_N3) */
           xe.application_id,
           xe.event_id
      FROM apps.xla_events@ADG xe
     WHERE xe.application_id = 200
       AND xe.event_date >= __AP_START__
       AND xe.event_date <  __AP_END__
       AND xe.event_status_code <> 'N'
       AND xe.process_status_code IN ('U', 'I', 'R', 'D', 'E', 'Z')
    UNION ALL
    SELECT /*+ INDEX(xah XLA_AE_HEADERS_N5) */
           xah.application_id,
           xah.event_id
      FROM apps.xla_ae_headers@ADG xah
     WHERE xah.application_id = 200
       AND xah.ledger_id IN (1003, 5001, 10001)
       AND xah.accounting_date >= __AP_START__
       AND xah.accounting_date <  __AP_END__
       AND (NVL(xah.accounting_entry_status_code, '?') <> 'F'
            OR NVL(xah.gl_transfer_status_code, '?') <> 'Y')
       AND xah.event_id IS NOT NULL~',
            '__AP_START__', 'DATE ' || DBMS_ASSERT.ENQUOTE_LITERAL(TO_CHAR(l_ap_start, 'YYYY-MM-DD'))
          ),
          '__AP_END__', 'DATE ' || DBMS_ASSERT.ENQUOTE_LITERAL(TO_CHAR(l_ap_end_excl, 'YYYY-MM-DD'))
        );
      END IF;

      IF l_run_ar THEN
        IF l_branch_sql IS NOT NULL THEN
          l_branch_sql := l_branch_sql || CHR(10) || '    UNION ALL' || CHR(10);
        END IF;
        l_branch_sql := l_branch_sql || REPLACE(
          REPLACE(
            q'~    SELECT /*+ INDEX(xe XLA_EVENTS_N3) */
           xe.application_id,
           xe.event_id
      FROM apps.xla_events@ADG xe
     WHERE xe.application_id = 222
       AND xe.event_date >= __AR_START__
       AND xe.event_date <  __AR_END__
       AND xe.process_status_code IN ('U', 'I', 'R', 'D', 'E', 'Z')
    UNION ALL
    SELECT /*+ INDEX(xah XLA_AE_HEADERS_N5) */
           xah.application_id,
           xah.event_id
      FROM apps.xla_ae_headers@ADG xah
     WHERE xah.application_id = 222
       AND xah.ledger_id IN (1003, 5001, 10001)
       AND xah.accounting_date >= __AR_START__
       AND xah.accounting_date <  __AR_END__
       AND (NVL(xah.accounting_entry_status_code, '?') <> 'F'
            OR NVL(xah.gl_transfer_status_code, '?') <> 'Y')
       AND xah.event_id IS NOT NULL~',
            '__AR_START__', 'DATE ' || DBMS_ASSERT.ENQUOTE_LITERAL(TO_CHAR(l_ar_start, 'YYYY-MM-DD'))
          ),
          '__AR_END__', 'DATE ' || DBMS_ASSERT.ENQUOTE_LITERAL(TO_CHAR(l_ar_end_excl, 'YYYY-MM-DD'))
        );
      END IF;

      l_sql :=
        'WITH' || CHR(10) ||
        'candidate_events_raw AS' || CHR(10) ||
        '(' || CHR(10) ||
        l_branch_sql || CHR(10) ||
        '),' || CHR(10) ||
        REPLACE(
          REPLACE(
            q'~candidate_events AS
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
           xe.event_id,
           xe.event_date,
           xe.process_status_code,
           MAX(xah.accounting_date) AS accounting_date,
           SUM(CASE WHEN xah.accounting_entry_status_code IN ('I', 'RELATED_EVENT_ERROR') THEN 1 ELSE 0 END) AS error_header_count,
           SUM(CASE WHEN xah.ae_header_id IS NOT NULL
                     AND NVL(xah.accounting_entry_status_code, '?') NOT IN ('F', 'D', 'I', 'RELATED_EVENT_ERROR')
                    THEN 1 ELSE 0 END) AS other_nonfinal_header_count,
           SUM(CASE WHEN xah.accounting_entry_status_code = 'D' THEN 1 ELSE 0 END) AS draft_header_count,
           SUM(CASE WHEN xah.accounting_entry_status_code = 'F'
                     AND NVL(xah.gl_transfer_status_code, '?') <> 'Y'
                    THEN 1 ELSE 0 END) AS final_untransferred_count,
           SUM(CASE WHEN xah.accounting_entry_status_code = 'F'
                     AND xah.gl_transfer_status_code = 'Y'
                    THEN 1 ELSE 0 END) AS successful_header_count
      FROM candidate_events ce
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
     WHERE xte.ledger_id IN (1003, 5001, 10001)
     GROUP BY xe.application_id,
              xte.ledger_id,
              xte.security_id_int_1,
              xte.entity_code,
              xe.event_id,
              xe.event_date,
              xe.process_status_code
),
classified AS
(
    SELECT e.application_id,
           e.ledger_id,
           e.org_id,
           e.entity_code,
           e.event_id,
           CASE
             WHEN e.successful_header_count > 0 THEN NULL
             WHEN e.error_header_count > 0 OR e.process_status_code IN ('I', 'R')
               THEN 'PROCESSING/ACCOUNTING ERROR'
             WHEN e.draft_header_count > 0 OR e.other_nonfinal_header_count > 0
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
    SELECT c.application_id,
           c.ledger_id,
           c.org_id,
           c.entity_code,
           c.exception_type,
           COUNT(DISTINCT c.event_id) AS event_count,
           CASE
             WHEN c.exception_type IN ('PROCESSING/ACCOUNTING ERROR', 'NOT TRANSFERRED TO GL') THEN 'RED'
             WHEN __TODAY__ - TRUNC(MIN(c.exception_date)) >= 5 THEN 'RED'
             WHEN c.exception_type = 'ACCOUNTING NOT FINAL'
               OR __TODAY__ - TRUNC(MIN(c.exception_date)) >= 2 THEN 'AMBER'
             ELSE 'INFORMATIONAL'
           END AS severity
      FROM classified c
     WHERE c.exception_type IS NOT NULL
     GROUP BY c.application_id,
              c.ledger_id,
              c.org_id,
              c.entity_code,
              c.exception_type
)
SELECT /*+ DRIVING_SITE(gl) */
       s.application_id,
       NVL(SUM(s.event_count), 0) AS open_count,
       NVL(SUM(CASE WHEN s.ledger_id = 1003  THEN s.event_count ELSE 0 END), 0) AS us_count,
       NVL(SUM(CASE WHEN s.ledger_id = 5001  THEN s.event_count ELSE 0 END), 0) AS uk_count,
       NVL(SUM(CASE WHEN s.ledger_id = 10001 THEN s.event_count ELSE 0 END), 0) AS ch_count,
       NVL(SUM(CASE WHEN s.severity = 'RED'  THEN s.event_count ELSE 0 END), 0) AS red_count
  FROM summary s
  JOIN apps.gl_ledgers@ADG gl
    ON gl.ledger_id = s.ledger_id
 GROUP BY s.application_id~',
            '__TODAY__', l_today_lit
          ),
          '@ADG', '@' || l_db_link
        );

      l_sql := REPLACE(l_sql, '@ADG', '@' || l_db_link);

      OPEN l_rc FOR l_sql;
      l_open := TRUE;
      LOOP
        FETCH l_rc INTO l_sla_app, l_sla_open, l_sla_us, l_sla_uk, l_sla_ch, l_sla_red;
        EXIT WHEN l_rc%NOTFOUND;
        IF l_sla_app = 200 THEN
          l_ap_open := l_sla_open;
          l_ap_us   := l_sla_us;
          l_ap_uk   := l_sla_uk;
          l_ap_ch   := l_sla_ch;
          l_ap_red  := l_sla_red;
        ELSIF l_sla_app = 222 THEN
          l_ar_open := l_sla_open;
          l_ar_us   := l_sla_us;
          l_ar_uk   := l_sla_uk;
          l_ar_ch   := l_sla_ch;
          l_ar_red  := l_sla_red;
        END IF;
      END LOOP;
      close_rc;
    END IF;

    l_ap_color := CASE WHEN l_ap_red > 0 THEN 'kpi-bad' WHEN l_ap_open > 0 THEN 'kpi-warn' ELSE 'kpi-good' END;
    l_ar_color := CASE WHEN l_ar_red > 0 THEN 'kpi-bad' WHEN l_ar_open > 0 THEN 'kpi-warn' ELSE 'kpi-good' END;

    -- Card 1 (10): General Ledger
    PIPE ROW (xxme_dashboard_card_ot(
      10,
      10,
      'P10_PERIOD_NAME',
      'General Ledger',
      l_gl_open || ' Open GL items<br>US: ' || l_gl_us || ' | UK: ' || l_gl_uk || ' | CH: ' || l_gl_ch,
      'fa fa-book',
      l_gl_color,
      l_gl_open,
      l_gl_us,
      l_gl_uk,
      l_gl_ch,
      'Y',
      build_card_link(l_app_id, 10, 'P10_PERIOD_NAME', l_period_name, l_db_link)
    ));

    -- Card 2 (20): Payables SLA Exceptions
    PIPE ROW (xxme_dashboard_card_ot(
      20,
      20,
      'P20_PERIOD_NAME',
      'Payables SLA Exceptions',
      l_ap_open || ' Open accounting exceptions<br>US: ' || l_ap_us || ' | UK: ' || l_ap_uk || ' | CH: ' || l_ap_ch,
      'fa fa-file-text-o',
      l_ap_color,
      l_ap_open,
      l_ap_us,
      l_ap_uk,
      l_ap_ch,
      'Y',
      build_card_link(l_app_id, 20, 'P20_PERIOD_NAME', l_period_name, l_db_link)
    ));

    -- Card 3 (30): Receivables SLA Exceptions
    PIPE ROW (xxme_dashboard_card_ot(
      30,
      30,
      'P30_PERIOD_NAME',
      'Receivables SLA Exceptions',
      l_ar_open || ' Open accounting exceptions<br>US: ' || l_ar_us || ' | UK: ' || l_ar_uk || ' | CH: ' || l_ar_ch,
      'fa fa-money',
      l_ar_color,
      l_ar_open,
      l_ar_us,
      l_ar_uk,
      l_ar_ch,
      'Y',
      build_card_link(l_app_id, 30, 'P30_PERIOD_NAME', l_period_name, l_db_link)
    ));

    -- Card 4 (40): Inventory/Cost Management SLA
    PIPE ROW (xxme_dashboard_card_ot(
      40,
      41,
      'P41_PERIOD_NAME',
      'Inventory/Cost Management SLA',
      'Open dedicated Inventory/Cost Management SLA analysis',
      'fa fa-database',
      'kpi-neutral',
      NULL,
      NULL,
      NULL,
      NULL,
      'Y',
      build_card_link(l_app_id, 41, 'P41_PERIOD_NAME', l_period_name, l_db_link)
    ));

    -- Card 5 (50): AI Analyst (respecting FEATURE_AI build option)
    IF l_app_id IS NOT NULL THEN
      BEGIN
        l_ai_status := apex_application_admin.get_build_option_status(
          p_application_id    => l_app_id,
          p_build_option_name => 'FEATURE_AI'
        );
      EXCEPTION
        WHEN OTHERS THEN
          l_ai_status := 'EXCLUDE';
      END;
    ELSE
      l_ai_status := 'EXCLUDE';
    END IF;

    IF l_ai_status = 'INCLUDE' THEN
      PIPE ROW (xxme_dashboard_card_ot(
        50,
        50,
        'P50_PERIOD_NAME',
        'AI Month-End Analyst',
        'Ask month-end questions in plain language',
        'fa fa-comments',
        'kpi-neutral',
        NULL,
        NULL,
        NULL,
        NULL,
        'Y',
        build_card_link(l_app_id, 50, 'P50_PERIOD_NAME', l_period_name, l_db_link)
      ));
    ELSE
      PIPE ROW (xxme_dashboard_card_ot(
        50,
        NULL,
        NULL,
        'AI Analyst',
        'Reserved for future AI Analyst capability.',
        'fa fa-comments',
        'kpi-neutral',
        NULL,
        NULL,
        NULL,
        NULL,
        'N',
        NULL
      ));
    END IF;

    RETURN;
  EXCEPTION
    WHEN NO_DATA_NEEDED THEN
      close_rc;
      RETURN;
    WHEN OTHERS THEN
      close_rc;
      RAISE;
  END get_overview_cards;

END xxme_dashboard_pkg;
/
