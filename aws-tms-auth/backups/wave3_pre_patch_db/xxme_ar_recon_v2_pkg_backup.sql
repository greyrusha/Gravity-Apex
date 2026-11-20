set define off

CREATE OR REPLACE PACKAGE "XXME_AR_RECON_V2_PKG" authid definer as
  procedure populate_snapshot
  (
    p_db_link         in  varchar2,
    p_ledger_id       in  number,
    p_company_segment in  varchar2,
    p_period_name     in  varchar2,
    p_aging_bucket_id in  number default 1121,
    p_loaded_by       in  varchar2 default null,
    p_row_count       out number
  );

  procedure clear_snapshot
  (
    p_db_link         in varchar2,
    p_ledger_id       in number,
    p_company_segment in varchar2,
    p_period_name     in varchar2,
    p_aging_bucket_id in number default 1121
  );

  function get_aging_detail
  (
    p_db_link              in varchar2,
    p_ledger_id            in number,
    p_company_segment      in varchar2,
    p_period_name          in varchar2,
    p_aging_bucket_id      in number default 1121,
    p_customer_id          in number default null,
    p_bucket_sequence      in number default null,
    p_control_account_flag in varchar2 default null
  ) return xxme_ar_aging_detail_tt pipelined;

  function get_aging_by_customer
  (
    p_db_link         in varchar2,
    p_ledger_id       in number,
    p_company_segment in varchar2,
    p_period_name     in varchar2,
    p_aging_bucket_id in number default 1121
  ) return xxme_ar_aging_customer_tt pipelined;

  function get_gl_reconciliation
  (
    p_db_link         in varchar2,
    p_ledger_id       in number,
    p_company_segment in varchar2,
    p_period_name     in varchar2,
    p_aging_bucket_id in number default 1121
  ) return xxme_ar_gl_recon_v2_tt pipelined;
end xxme_ar_recon_v2_pkg;
/

CREATE OR REPLACE PACKAGE BODY "XXME_AR_RECON_V2_PKG" AS
  -- XXME_AR_RECON_V2_PKG - candidate/comparison build of XXME_AR_RECON_PKG.
  -- Same public API (same procedure/function names, parameters and return
  -- types) as the original, so callers can point at this package for
  -- side-by-side testing. It reads and writes its OWN tables
  -- (XXME_AR_RECON_V2_SNAP, XXME_AR_RECON_V2_LOCK,
  -- XXME_AR_RECON_V2_CTRL_ACCTS) and does not touch the original
  -- XXME_AR_RECON_SNAP / XXME_AR_RECON_LOCK tables or the original
  -- package at all - the two can run concurrently without interfering.
  -- See XXME_AR_RECON_V2_CHANGE_NOTES.md for the full rationale.
  --
  -- Package-level indexed collections are used only by the small live-GL
  -- reconciliation fetch. POPULATE_SNAPSHOT deliberately declares its own
  -- AP-proven nested-table collections locally.
  --
  -- Corrections applied per code review of POPULATE_SNAPSHOT (see review
  -- notes / change log delivered alongside this file). This build is based
  -- on the ACTUALLY-DEPLOYED body (14_CREATE_PACKAGE_BODY.sql, the "exact
  -- tested cursor V4" state re-applied by 15-19 in
  -- C:\Apex\app114\page32-ar-recon-db-v1), not the earlier draft that used
  -- plain bind variables for {COMPANY}/{BUCKET}/{LEDGER}/{PERIOD} - that
  -- draft was superseded by a deliberate, tested move to
  -- DBMS_ASSERT-quoted literal substitution for remote-optimizer-visible
  -- shape (see the comment above the REPLACE() chain in POPULATE_SNAPSHOT).
  -- That literal-substitution mechanism, the remote hints, and every other
  -- piece of query logic are left exactly as tested - untouched below.
  --
  --   1. ACQUIRE_LOCK no longer issues an ambient COMMIT against the
  --      caller's transaction. The lock-row bootstrap insert now runs in
  --      its own PRAGMA AUTONOMOUS_TRANSACTION (ENSURE_LOCK_ROW), so only
  --      that insert is committed; the FOR UPDATE NOWAIT row lock is still
  --      taken in, and released with, the caller's own transaction.
  --   2. The MERGE-based upsert (which could surface a raw ORA-00001 under
  --      a concurrent first-use race) was replaced with a plain INSERT and
  --      an explicit DUP_VAL_ON_INDEX handler, which is deterministic.
  --      (XXME_AR_RECON_V2_LOCK.LOCK_KEY is already the table's PRIMARY KEY
  --      per 11_CREATE_TABLES.sql, so this is safe as-is.)
  --   3. POPULATE_SNAPSHOT now rejects a NULL period end date (an open or
  --      unmapped GL period) instead of silently deleting an existing
  --      snapshot and reloading it with zero rows. RESOLVE_CONTEXT and the
  --      main query's own {L}-linked GL_PERIOD_STATUSES lookup read the
  --      same underlying row, so checking RESOLVE_CONTEXT's result before
  --      the main query runs catches this reliably.
  --   4. The control-account segment list, previously hardcoded in both
  --      POPULATE_SNAPSHOT and GET_GL_RECONCILIATION, is now sourced once
  --      from XXME_AR_RECON_V2_CTRL_ACCTS (see supporting SQL) via
  --      CONTROL_ACCOUNT_LITERAL_LIST, substituted in as one more {CTRL}
  --      token alongside the existing {COMPANY}/{BUCKET}/{LEDGER}/{PERIOD}
  --      substitutions, so the two call sites can no longer drift.
  --   5. P_ROW_COUNT is now initialized before any validation runs, so it
  --      is always defined even if POPULATE_SNAPSHOT fails early.
  -- SQL execution logic/output is unchanged - the control-account values
  -- compared are the six AWS-approved codes, centralized in the control table.
  TYPE t_num_idx_tab IS TABLE OF NUMBER        INDEX BY PLS_INTEGER;
  TYPE t_vc_idx_tab  IS TABLE OF VARCHAR2(500) INDEX BY PLS_INTEGER;

  FUNCTION normalize_db_link(p_db_link IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN xxme_db_source_pkg.normalize_db_link(p_db_link);
  END normalize_db_link;

  -- Centralized source of truth for "which GL natural accounts are AR
  -- control accounts". Used both to flag snapshot rows and to select which
  -- GL balances participate in GET_GL_RECONCILIATION, so the two can never
  -- drift out of sync the way two hardcoded literal lists could.
  FUNCTION control_account_literal_list RETURN VARCHAR2 IS
    l_list VARCHAR2(4000);
  BEGIN
    SELECT LISTAGG('''' || segment3 || '''', ',')
             WITHIN GROUP (ORDER BY segment3)
      INTO l_list
      FROM xxme_ar_recon_v2_ctrl_accts
     WHERE enabled_flag = 'Y';

    IF l_list IS NULL THEN
      RAISE_APPLICATION_ERROR(-20008,
        'XXME_AR_RECON_V2_CTRL_ACCTS has no enabled rows; the control-account list is not configured.');
    END IF;

    RETURN l_list;
  END control_account_literal_list;

  FUNCTION lock_key
  (
    p_db_link         IN VARCHAR2,
    p_ledger_id       IN NUMBER,
    p_company_segment IN VARCHAR2,
    p_period_name     IN VARCHAR2,
    p_aging_bucket_id IN NUMBER
  ) RETURN VARCHAR2 IS
  BEGIN
    RETURN p_db_link || '|' || TO_CHAR(p_ledger_id) || '|' ||
           UPPER(TRIM(p_company_segment)) || '|' ||
           UPPER(TRIM(p_period_name)) || '|' || TO_CHAR(p_aging_bucket_id);
  END lock_key;

  -- Bootstraps the lock row for a key in its own autonomous transaction so
  -- the COMMIT it needs (to make the row visible/lockable) never commits
  -- anything else pending in the caller's transaction. A plain INSERT with
  -- a DUP_VAL_ON_INDEX handler is used instead of MERGE: two sessions
  -- racing to create the same brand-new key can no longer surface a raw
  -- ORA-00001 to the caller - whichever session loses the race simply
  -- finds the row already there, which is exactly the outcome it wanted.
  -- Relies on XXME_AR_RECON_V2_LOCK_PK (LOCK_KEY) from 11_CREATE_TABLES.sql.
  PROCEDURE ensure_lock_row(p_lock_key IN VARCHAR2) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    INSERT INTO xxme_ar_recon_v2_lock (lock_key) VALUES (p_lock_key);
    COMMIT;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      ROLLBACK;
  END ensure_lock_row;

  PROCEDURE acquire_lock(p_lock_key IN VARCHAR2) IS
    l_dummy NUMBER;
  BEGIN
    ensure_lock_row(p_lock_key);

    BEGIN
      SELECT 1
        INTO l_dummy
        FROM xxme_ar_recon_v2_lock
       WHERE lock_key = p_lock_key
       FOR UPDATE NOWAIT;
    EXCEPTION
      WHEN OTHERS THEN
        IF SQLCODE = -54 THEN
          RAISE_APPLICATION_ERROR(-20003,
            'This Page 32 snapshot key is already being loaded.');
        END IF;
        RAISE;
    END;
  END acquire_lock;

  PROCEDURE resolve_context
  (
    p_db_link         IN  VARCHAR2,
    p_ledger_id       IN  NUMBER,
    p_period_name     IN  VARCHAR2,
    p_aging_bucket_id IN  NUMBER,
    p_as_of_date      OUT DATE
  ) IS
    l_sql          VARCHAR2(32767);
    l_bucket_lines PLS_INTEGER;
  BEGIN
    l_sql := REPLACE(q'~
      SELECT gps.end_date
        FROM apps.gl_period_statuses{L} gps
       WHERE gps.application_id = 222
         AND gps.ledger_id = :b1
         AND gps.period_name = :b2~', '{L}', '@' || p_db_link);

    EXECUTE IMMEDIATE l_sql
      INTO p_as_of_date
      USING p_ledger_id, UPPER(TRIM(p_period_name));

    l_sql := REPLACE(q'~
      SELECT COUNT(*)
        FROM apps.ar_aging_bucket_lines_vl{L}
       WHERE aging_bucket_id = :b1~', '{L}', '@' || p_db_link);

    EXECUTE IMMEDIATE l_sql
      INTO l_bucket_lines
      USING p_aging_bucket_id;

    IF l_bucket_lines != 7 THEN
      RAISE_APPLICATION_ERROR(-20004,
        'Aging bucket must contain exactly seven lines. Found: ' || l_bucket_lines);
    END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20005,
        'Ledger/Receivables period was not found.');
  END resolve_context;

  PROCEDURE populate_snapshot
  (
    p_db_link         IN  VARCHAR2,
    p_ledger_id       IN  NUMBER,
    p_company_segment IN  VARCHAR2,
    p_period_name     IN  VARCHAR2,
    p_aging_bucket_id IN  NUMBER DEFAULT 1121,
    p_loaded_by       IN  VARCHAR2 DEFAULT NULL,
    p_row_count       OUT NUMBER
  ) IS
    l_link       VARCHAR2(128);
    l_company    VARCHAR2(25) := UPPER(TRIM(p_company_segment));
    l_period     VARCHAR2(30) := UPPER(TRIM(p_period_name));
    l_as_of_date DATE;
    l_loaded_at  TIMESTAMP := SYSTIMESTAMP;
    l_loaded_by  VARCHAR2(128) := SUBSTR(NVL(TRIM(p_loaded_by), USER), 1, 128);
    l_lock_key   VARCHAR2(400);
    l_sql        CLOB;
    l_cursor     SYS_REFCURSOR;

    -- Match the proven AP snapshot-loader collection pattern exactly.
    TYPE t_num_tab  IS TABLE OF NUMBER;
    TYPE t_str_tab  IS TABLE OF VARCHAR2(2000);
    TYPE t_date_tab IS TABLE OF DATE;

    l_org_id              t_num_tab;
    l_payment_schedule_id t_num_tab;
    l_class_code          t_str_tab;
    l_customer_trx_id     t_num_tab;
    l_trx_number          t_str_tab;
    l_trx_date            t_date_tab;
    l_due_date            t_date_tab;
    l_customer_id         t_num_tab;
    l_customer_number     t_str_tab;
    l_customer_name       t_str_tab;
    l_currency_code       t_str_tab;
    l_amount_original     t_num_tab;
    l_entered_balance     t_num_tab;
    l_accounted_balance   t_num_tab;
    l_receivable_ccid     t_num_tab;
    l_receivable_account  t_str_tab;
    l_account_segments    t_str_tab;
    l_control_flag        t_str_tab;
    l_days_past_due       t_num_tab;
    l_bucket_sequence     t_num_tab;
    l_bucket_heading      t_str_tab;

    c_batch_size CONSTANT PLS_INTEGER := 5000;
  BEGIN
    -- Correction #5: defined even if validation below fails early.
    p_row_count := 0;

    IF p_ledger_id IS NULL OR l_company IS NULL OR l_period IS NULL
       OR p_aging_bucket_id IS NULL THEN
      RAISE_APPLICATION_ERROR(-20006, 'Snapshot key parameters are required.');
    END IF;

    l_link := normalize_db_link(p_db_link);
    resolve_context(l_link, p_ledger_id, l_period,
                    p_aging_bucket_id, l_as_of_date);

    -- Correction #3: a found-but-open/unmapped period would otherwise
    -- silently pass through a NULL as-of date. The main query below reads
    -- GL_PERIOD_STATUSES.END_DATE itself (via the {L}-linked params CTE),
    -- from the same row RESOLVE_CONTEXT just read, so catching a NULL here
    -- catches it there too - before the existing snapshot is deleted.
    IF l_as_of_date IS NULL THEN
      RAISE_APPLICATION_ERROR(-20007,
        'Receivables period ' || l_period ||
        ' has no END_DATE set (period may be open); refusing to rebuild the snapshot.');
    END IF;

    l_lock_key := lock_key(l_link, p_ledger_id, l_company,
                           l_period, p_aging_bucket_id);
    acquire_lock(l_lock_key);

    DELETE FROM xxme_ar_recon_v2_snap
     WHERE db_link_name = l_link
       AND ledger_id = p_ledger_id
       AND company_segment = l_company
       AND period_name = l_period
       AND aging_bucket_id = p_aging_bucket_id;

    l_sql := q'~
      WITH params AS
      (
        SELECT gps.end_date as_of_date,
               gps.ledger_id,
               {COMPANY} company_segment,
               {BUCKET} aging_bucket_id
          FROM apps.gl_period_statuses{L} gps
         WHERE gps.application_id = 222
           AND gps.ledger_id = {LEDGER}
           AND gps.period_name = {PERIOD}
      ), bucket_lines AS
      (
        SELECT /*+ LEADING(p bl) USE_NL(bl) */ bl.aging_bucket_id,
               ROW_NUMBER() OVER
                 (PARTITION BY bl.aging_bucket_id
                      ORDER BY bl.bucket_sequence_num) bucket_ordinal,
               bl.days_start,
               bl.days_to,
               TRIM(bl.report_heading1 || ' ' || bl.report_heading2) bucket_heading
          FROM params p
          JOIN apps.ar_aging_bucket_lines_vl{L} bl
            ON bl.aging_bucket_id = p.aging_bucket_id
      ), selected AS
      (
        SELECT /*+ MATERIALIZE DRIVING_SITE(aps)
                   LEADING(p aps rcta) USE_NL(aps rcta) */ aps.org_id,
               aps.payment_schedule_id,
               aps.class class_code,
               aps.customer_trx_id,
               aps.trx_number,
               aps.trx_date,
               aps.due_date,
               aps.customer_id,
               aps.invoice_currency_code currency_code,
               NVL(aps.exchange_rate, 1) exchange_rate,
               NVL(aps.amount_due_original, 0) amount_due_original,
               NVL(aps.amount_due_remaining, 0) current_entered_balance,
               NVL(aps.acctd_amount_due_remaining, 0) current_accounted_balance,
               p.as_of_date,
               p.company_segment,
               p.aging_bucket_id
          FROM params p
          JOIN apps.ar_payment_schedules_all{L} aps
            ON aps.gl_date <= p.as_of_date
           AND aps.gl_date_closed > p.as_of_date
           AND aps.class IN ('INV','DM','CM','CB')
           AND aps.customer_trx_id IS NOT NULL
          JOIN apps.ra_customer_trx_all{L} rcta
            ON rcta.customer_trx_id = aps.customer_trx_id
           AND rcta.set_of_books_id = p.ledger_id
      ), target_app_after AS
      (
        SELECT /*+ LEADING(s ara) USE_NL(ara) */ s.payment_schedule_id,
               SUM(CASE WHEN ara.apply_date > s.as_of_date THEN
                     NVL(ara.amount_applied,0)
                     + NVL(ara.earned_discount_taken,0)
                     + NVL(ara.unearned_discount_taken,0)
                   ELSE 0 END) entered_amount_after,
               SUM(CASE WHEN ara.gl_date > s.as_of_date THEN
                     NVL(ara.acctd_amount_applied_to,
                         NVL(ara.amount_applied,0) * s.exchange_rate)
                     + NVL(ara.acctd_earned_discount_taken,
                           NVL(ara.earned_discount_taken,0) * s.exchange_rate)
                     + NVL(ara.acctd_unearned_discount_taken,
                           NVL(ara.unearned_discount_taken,0) * s.exchange_rate)
                   ELSE 0 END) accounted_amount_after
          FROM selected s
          JOIN apps.ar_receivable_applications_all{L} ara
            ON ara.applied_payment_schedule_id = s.payment_schedule_id
           AND ara.status = 'APP'
           AND NVL(ara.confirmed_flag,'Y') = 'Y'
           AND (ara.apply_date > s.as_of_date OR ara.gl_date > s.as_of_date)
         GROUP BY s.payment_schedule_id
      ), cm_source_app_after AS
      (
        SELECT /*+ LEADING(s ara) USE_NL(ara) */ s.payment_schedule_id,
               SUM(CASE WHEN ara.apply_date > s.as_of_date
                        THEN NVL(ara.amount_applied,0) ELSE 0 END)
                 entered_amount_after,
               SUM(CASE WHEN ara.gl_date > s.as_of_date THEN
                     NVL(ara.acctd_amount_applied_from,
                         NVL(ara.amount_applied,0) * s.exchange_rate)
                   ELSE 0 END) accounted_amount_after
          FROM selected s
          JOIN apps.ar_receivable_applications_all{L} ara
            ON ara.payment_schedule_id = s.payment_schedule_id
           AND (ara.apply_date > s.as_of_date OR ara.gl_date > s.as_of_date)
         WHERE s.class_code = 'CM'
         GROUP BY s.payment_schedule_id
      ), approved_adj_after AS
      (
        SELECT /*+ LEADING(s adj) USE_NL(adj) */ s.payment_schedule_id,
               SUM(CASE WHEN adj.apply_date > s.as_of_date
                        THEN NVL(adj.amount,0) ELSE 0 END)
                 entered_amount_after,
               SUM(CASE WHEN adj.gl_date > s.as_of_date THEN
                     NVL(adj.acctd_amount,
                         NVL(adj.amount,0) * s.exchange_rate)
                   ELSE 0 END) accounted_amount_after
          FROM selected s
          JOIN apps.ar_adjustments_all{L} adj
            ON adj.payment_schedule_id = s.payment_schedule_id
           AND adj.status = 'A'
           AND (adj.apply_date > s.as_of_date OR adj.gl_date > s.as_of_date)
         GROUP BY s.payment_schedule_id
      ), receivable_dist AS
      (
        SELECT /*+ LEADING(s d) USE_NL(d) */ s.customer_trx_id,
               MAX(d.code_combination_id) code_combination_id
          FROM selected s
          JOIN apps.ra_cust_trx_line_gl_dist_all{L} d
            ON d.customer_trx_id = s.customer_trx_id
           AND d.account_class = 'REC'
           AND d.latest_rec_flag = 'Y'
         GROUP BY s.customer_trx_id
      ), calculated AS
      (
        SELECT s.*,
               s.current_entered_balance
                 - NVL(a.entered_amount_after,0)
                 + NVL(t.entered_amount_after,0)
                 - NVL(cm.entered_amount_after,0) entered_balance,
               s.current_accounted_balance
                 - NVL(a.accounted_amount_after,0)
                 + NVL(t.accounted_amount_after,0)
                 - NVL(cm.accounted_amount_after,0) accounted_balance,
               rd.code_combination_id receivable_ccid,
               CEIL(s.as_of_date - s.due_date) days_past_due
          FROM selected s
          LEFT JOIN approved_adj_after a
            ON a.payment_schedule_id = s.payment_schedule_id
          LEFT JOIN target_app_after t
            ON t.payment_schedule_id = s.payment_schedule_id
          LEFT JOIN cm_source_app_after cm
            ON cm.payment_schedule_id = s.payment_schedule_id
          JOIN receivable_dist rd
            ON rd.customer_trx_id = s.customer_trx_id
      )
      SELECT /*+ DRIVING_SITE(gcc)
                 LEADING(c gcc bl hca hp)
                 USE_NL(gcc bl hca hp) */ c.org_id,
             c.payment_schedule_id,
             c.class_code,
             c.customer_trx_id,
             c.trx_number,
             c.trx_date,
             c.due_date,
             c.customer_id,
             hca.account_number customer_number,
             hp.party_name customer_name,
             c.currency_code,
             c.amount_due_original,
             c.entered_balance,
             c.accounted_balance,
             c.receivable_ccid,
             gcc.segment3 receivable_account,
             gcc.concatenated_segments account_segments,
             CASE WHEN gcc.segment3 IN ({CTRL})
                  THEN 'Y' ELSE 'N' END control_account_flag,
             c.days_past_due,
             bl.bucket_ordinal,
             bl.bucket_heading
        FROM calculated c
        JOIN apps.gl_code_combinations_kfv{L} gcc
          ON gcc.code_combination_id = c.receivable_ccid
         AND gcc.segment1 = c.company_segment
        LEFT JOIN apps.hz_cust_accounts{L} hca
          ON hca.cust_account_id = c.customer_id
        LEFT JOIN apps.hz_parties{L} hp
          ON hp.party_id = hca.party_id
        JOIN bucket_lines bl
          ON bl.aging_bucket_id = c.aging_bucket_id
         AND c.days_past_due BETWEEN bl.days_start AND bl.days_to
       WHERE ABS(NVL(c.entered_balance,0)) >= 0.005
          OR ABS(NVL(c.accounted_balance,0)) >= 0.005~';

    -- The successful APEX-schema test used literal context in the remote
    -- GL_PERIOD_STATUSES CTE. Reproduce that exact optimizer-visible shape.
    -- Every string literal is quoted by DBMS_ASSERT; numeric values arrive as
    -- NUMBER parameters and are rendered with locale-independent TM format.
    -- {CTRL} (correction #4) is substituted the same way: a locally-sourced,
    -- already-quoted literal list, never user input, so no DBMS_ASSERT step
    -- is needed for it specifically.
    l_sql := REPLACE(l_sql, '{L}', '@' || l_link);
    l_sql := REPLACE(l_sql, '{COMPANY}',
                     DBMS_ASSERT.ENQUOTE_LITERAL(l_company));
    l_sql := REPLACE(l_sql, '{BUCKET}',
                     TO_CHAR(p_aging_bucket_id, 'TM9',
                             'NLS_NUMERIC_CHARACTERS=''.,'''));
    l_sql := REPLACE(l_sql, '{LEDGER}',
                     TO_CHAR(p_ledger_id, 'TM9',
                             'NLS_NUMERIC_CHARACTERS=''.,'''));
    l_sql := REPLACE(l_sql, '{PERIOD}',
                     DBMS_ASSERT.ENQUOTE_LITERAL(l_period));
    l_sql := REPLACE(l_sql, '{CTRL}', control_account_literal_list);

    OPEN l_cursor FOR l_sql;

    LOOP
      FETCH l_cursor BULK COLLECT INTO
        l_org_id, l_payment_schedule_id, l_class_code, l_customer_trx_id,
        l_trx_number, l_trx_date, l_due_date, l_customer_id,
        l_customer_number, l_customer_name, l_currency_code,
        l_amount_original, l_entered_balance, l_accounted_balance,
        l_receivable_ccid, l_receivable_account, l_account_segments,
        l_control_flag, l_days_past_due, l_bucket_sequence,
        l_bucket_heading
      LIMIT c_batch_size;

      EXIT WHEN l_payment_schedule_id.COUNT = 0;

      FORALL i IN 1 .. l_payment_schedule_id.COUNT
        INSERT INTO xxme_ar_recon_v2_snap
        (
          db_link_name, ledger_id, company_segment, period_name,
          as_of_date, aging_bucket_id, org_id, payment_schedule_id,
          class_code, customer_trx_id, trx_number, trx_date, due_date,
          customer_id, customer_number, customer_name, currency_code,
          amount_due_original, entered_balance_asof,
          accounted_balance_asof, receivable_ccid, receivable_account,
          account_segments, control_account_flag, days_past_due,
          bucket_sequence, bucket_heading, loaded_at, loaded_by
        )
        VALUES
        (
          l_link, p_ledger_id, l_company, l_period,
          l_as_of_date, p_aging_bucket_id, l_org_id(i),
          l_payment_schedule_id(i), l_class_code(i), l_customer_trx_id(i),
          l_trx_number(i), l_trx_date(i), l_due_date(i), l_customer_id(i),
          l_customer_number(i), l_customer_name(i), l_currency_code(i),
          l_amount_original(i), l_entered_balance(i),
          l_accounted_balance(i), l_receivable_ccid(i),
          l_receivable_account(i), l_account_segments(i),
          l_control_flag(i), l_days_past_due(i), l_bucket_sequence(i),
          l_bucket_heading(i), l_loaded_at, l_loaded_by
        );

      p_row_count := p_row_count + l_payment_schedule_id.COUNT;

      EXIT WHEN l_cursor%NOTFOUND;
    END LOOP;

    CLOSE l_cursor;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      IF l_cursor%ISOPEN THEN
        CLOSE l_cursor;
      END IF;
      ROLLBACK;
      RAISE;
  END populate_snapshot;

  PROCEDURE clear_snapshot
  (
    p_db_link         IN VARCHAR2,
    p_ledger_id       IN NUMBER,
    p_company_segment IN VARCHAR2,
    p_period_name     IN VARCHAR2,
    p_aging_bucket_id IN NUMBER DEFAULT 1121
  ) IS
    l_link     VARCHAR2(128) := normalize_db_link(p_db_link);
    l_company  VARCHAR2(25) := UPPER(TRIM(p_company_segment));
    l_period   VARCHAR2(30) := UPPER(TRIM(p_period_name));
    l_lock_key VARCHAR2(400);
  BEGIN
    l_lock_key := lock_key(l_link, p_ledger_id, l_company,
                           l_period, p_aging_bucket_id);
    acquire_lock(l_lock_key);

    DELETE FROM xxme_ar_recon_v2_snap
     WHERE db_link_name = l_link
       AND ledger_id = p_ledger_id
       AND company_segment = l_company
       AND period_name = l_period
       AND aging_bucket_id = p_aging_bucket_id;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      RAISE;
  END clear_snapshot;

  FUNCTION get_aging_detail
  (
    p_db_link              IN VARCHAR2,
    p_ledger_id            IN NUMBER,
    p_company_segment      IN VARCHAR2,
    p_period_name          IN VARCHAR2,
    p_aging_bucket_id      IN NUMBER DEFAULT 1121,
    p_customer_id          IN NUMBER DEFAULT NULL,
    p_bucket_sequence      IN NUMBER DEFAULT NULL,
    p_control_account_flag IN VARCHAR2 DEFAULT NULL
  ) RETURN xxme_ar_aging_detail_tt PIPELINED IS
    l_link    VARCHAR2(128) := UPPER(TRIM(p_db_link));
    l_company VARCHAR2(25) := UPPER(TRIM(p_company_segment));
    l_period  VARCHAR2(30) := UPPER(TRIM(p_period_name));
    l_flag    VARCHAR2(1) := UPPER(TRIM(p_control_account_flag));
  BEGIN
    FOR r IN
    (
      SELECT payment_schedule_id, class_code, org_id, customer_trx_id,
             trx_number, trx_date, due_date, days_past_due, customer_id,
             customer_number, customer_name, currency_code,
             entered_balance_asof, accounted_balance_asof,
             receivable_ccid, receivable_account, account_segments,
             control_account_flag, bucket_sequence, bucket_heading
        FROM xxme_ar_recon_v2_snap
       WHERE db_link_name = l_link
         AND ledger_id = p_ledger_id
         AND company_segment = l_company
         AND period_name = l_period
         AND aging_bucket_id = p_aging_bucket_id
         AND (p_customer_id IS NULL OR customer_id = p_customer_id)
         AND (p_bucket_sequence IS NULL OR bucket_sequence = p_bucket_sequence)
         AND (l_flag IS NULL OR control_account_flag = l_flag)
       ORDER BY customer_name, customer_number, due_date,
                payment_schedule_id
    ) LOOP
      PIPE ROW(xxme_ar_aging_detail_ot
      (
        r.payment_schedule_id, r.class_code, r.org_id, r.customer_trx_id,
        r.trx_number, r.trx_date, r.due_date, r.days_past_due,
        r.customer_id, r.customer_number, r.customer_name, r.currency_code,
        r.entered_balance_asof, r.accounted_balance_asof,
        r.receivable_ccid, r.receivable_account, r.account_segments,
        r.control_account_flag, r.bucket_sequence, r.bucket_heading
      ));
    END LOOP;
    RETURN;
  END get_aging_detail;

  FUNCTION get_aging_by_customer
  (
    p_db_link         IN VARCHAR2,
    p_ledger_id       IN NUMBER,
    p_company_segment IN VARCHAR2,
    p_period_name     IN VARCHAR2,
    p_aging_bucket_id IN NUMBER DEFAULT 1121
  ) RETURN xxme_ar_aging_customer_tt PIPELINED IS
    l_link    VARCHAR2(128) := UPPER(TRIM(p_db_link));
    l_company VARCHAR2(25) := UPPER(TRIM(p_company_segment));
    l_period  VARCHAR2(30) := UPPER(TRIM(p_period_name));
  BEGIN
    FOR r IN
    (
      SELECT customer_id,
             MAX(customer_number) customer_number,
             MAX(customer_name) customer_name,
             SUM(CASE WHEN bucket_sequence = 1 THEN entered_balance_asof ELSE 0 END) b1,
             SUM(CASE WHEN bucket_sequence = 2 THEN entered_balance_asof ELSE 0 END) b2,
             SUM(CASE WHEN bucket_sequence = 3 THEN entered_balance_asof ELSE 0 END) b3,
             SUM(CASE WHEN bucket_sequence = 4 THEN entered_balance_asof ELSE 0 END) b4,
             SUM(CASE WHEN bucket_sequence = 5 THEN entered_balance_asof ELSE 0 END) b5,
             SUM(CASE WHEN bucket_sequence = 6 THEN entered_balance_asof ELSE 0 END) b6,
             SUM(CASE WHEN bucket_sequence = 7 THEN entered_balance_asof ELSE 0 END) b7,
             SUM(entered_balance_asof) total_amount,
             SUM(CASE WHEN control_account_flag = 'N'
                      THEN entered_balance_asof ELSE 0 END) exception_amount,
             COUNT(*) schedule_count
        FROM xxme_ar_recon_v2_snap
       WHERE db_link_name = l_link
         AND ledger_id = p_ledger_id
         AND company_segment = l_company
         AND period_name = l_period
         AND aging_bucket_id = p_aging_bucket_id
       GROUP BY customer_id
       ORDER BY customer_name, customer_number, customer_id
    ) LOOP
      PIPE ROW(xxme_ar_aging_customer_ot
      (
        r.customer_id, r.customer_number, r.customer_name,
        r.b1, r.b2, r.b3, r.b4, r.b5, r.b6, r.b7,
        r.total_amount, r.exception_amount, r.schedule_count
      ));
    END LOOP;
    RETURN;
  END get_aging_by_customer;

  FUNCTION get_gl_reconciliation
  (
    p_db_link         IN VARCHAR2,
    p_ledger_id       IN NUMBER,
    p_company_segment IN VARCHAR2,
    p_period_name     IN VARCHAR2,
    p_aging_bucket_id IN NUMBER DEFAULT 1121
  ) RETURN xxme_ar_gl_recon_v2_tt PIPELINED IS
    l_link       VARCHAR2(128) := normalize_db_link(p_db_link);
    l_company    VARCHAR2(25) := UPPER(TRIM(p_company_segment));
    l_period     VARCHAR2(30) := UPPER(TRIM(p_period_name));
    l_sql        VARCHAR2(32767);
    l_cursor     SYS_REFCURSOR;
    l_gl_time    TIMESTAMP := SYSTIMESTAMP;

    TYPE t_num_map IS TABLE OF NUMBER INDEX BY VARCHAR2(100);
    TYPE t_vc_map  IS TABLE OF VARCHAR2(500) INDEX BY VARCHAR2(100);
    TYPE t_ts_map  IS TABLE OF TIMESTAMP INDEX BY VARCHAR2(100);
    TYPE t_seen_map IS TABLE OF BOOLEAN INDEX BY VARCHAR2(100);

    l_ar_amount t_num_map;
    l_segments  t_vc_map;
    l_natural   t_vc_map;
    l_loaded_at t_ts_map;
    l_seen      t_seen_map;

    l_gl_begin_map t_num_map;
    l_gl_net_map   t_num_map;
    l_gl_end_map   t_num_map;
    l_recv_map     t_num_map;
    l_reval_map    t_num_map;
    l_nonrecv_map  t_num_map;
    l_not_xfer_map t_num_map;

    l_key       VARCHAR2(100);
    l_ccid_list VARCHAR2(32767);
    l_as_of_date DATE;

    l_ccid      t_num_idx_tab;
    l_gl_seg    t_vc_idx_tab;
    l_gl_nat    t_vc_idx_tab;
    l_gl_begin  t_num_idx_tab;
    l_gl_net    t_num_idx_tab;
    l_gl_end    t_num_idx_tab;
    l_activity_kind t_vc_idx_tab;
    l_activity_amount t_num_idx_tab;
    l_not_xfer_amount t_num_idx_tab;
  BEGIN
    FOR r IN
    (
      SELECT receivable_ccid,
             MAX(account_segments) account_segments,
             MAX(receivable_account) natural_account,
             SUM(accounted_balance_asof) ar_amount,
             MAX(loaded_at) loaded_at,
             MAX(as_of_date) as_of_date
        FROM xxme_ar_recon_v2_snap
       WHERE db_link_name = l_link
         AND ledger_id = p_ledger_id
         AND company_segment = l_company
         AND period_name = l_period
         AND aging_bucket_id = p_aging_bucket_id
         AND control_account_flag = 'Y'
         AND receivable_ccid IS NOT NULL
       GROUP BY receivable_ccid
      HAVING ABS(SUM(accounted_balance_asof)) >= 0.005
    ) LOOP
      l_key := TO_CHAR(r.receivable_ccid);
      l_ar_amount(l_key) := r.ar_amount;
      l_segments(l_key) := r.account_segments;
      l_natural(l_key) := r.natural_account;
      l_loaded_at(l_key) := r.loaded_at;
      l_as_of_date := r.as_of_date;
      IF l_ccid_list IS NULL THEN
        l_ccid_list := l_key;
      ELSE
        l_ccid_list := l_ccid_list || ',' || l_key;
      END IF;
    END LOOP;

    IF l_ccid_list IS NULL THEN
      RETURN;
    END IF;

    l_sql := REPLACE(REPLACE(q'~
      WITH params AS
      (
        SELECT :b_ledger ledger_id,
               :b_company company_segment,
               :b_period period_name
          FROM dual{L}
      )
      SELECT gb.code_combination_id,
             gcc.concatenated_segments,
             gcc.segment3,
             SUM(NVL(gb.begin_balance_dr,0)-NVL(gb.begin_balance_cr,0)) gl_begin,
             SUM(NVL(gb.period_net_dr,0)-NVL(gb.period_net_cr,0)) gl_net,
             SUM(NVL(gb.begin_balance_dr,0)-NVL(gb.begin_balance_cr,0)
                 + NVL(gb.period_net_dr,0)-NVL(gb.period_net_cr,0)) gl_end
        FROM params p
        JOIN apps.gl_ledgers{L} gl
          ON gl.ledger_id = p.ledger_id
        JOIN apps.gl_balances{L} gb
          ON gb.ledger_id = p.ledger_id
         AND gb.period_name = p.period_name
         AND gb.currency_code = gl.currency_code
         AND gb.actual_flag = 'A'
         AND gb.translated_flag IS NULL
        JOIN apps.gl_code_combinations_kfv{L} gcc
          ON gcc.code_combination_id = gb.code_combination_id
         AND gcc.segment1 = p.company_segment
         AND gb.code_combination_id IN ({CCIDS})
       GROUP BY gb.code_combination_id,
                gcc.concatenated_segments, gcc.segment3
       ORDER BY gcc.segment3, gcc.concatenated_segments~',
       '{L}', '@' || l_link), '{CCIDS}', l_ccid_list);

    OPEN l_cursor FOR l_sql USING p_ledger_id, l_company, l_period;
    FETCH l_cursor BULK COLLECT INTO
      l_ccid, l_gl_seg, l_gl_nat, l_gl_begin, l_gl_net, l_gl_end;
    CLOSE l_cursor;

    IF l_ccid.COUNT > 0 THEN
      FOR i IN 1 .. l_ccid.COUNT LOOP
        l_key := TO_CHAR(l_ccid(i));
        l_seen(l_key) := TRUE;
        l_gl_begin_map(l_key) := l_gl_begin(i);
        l_gl_net_map(l_key) := l_gl_net(i);
        l_gl_end_map(l_key) := l_gl_end(i);
        l_segments(l_key) := l_gl_seg(i);
        l_natural(l_key) := l_gl_nat(i);
      END LOOP;
    END IF;

    l_sql := REPLACE(q'~
      SELECT jl.code_combination_id,
             CASE
               WHEN jh.je_source = 'Receivables' THEN 'R'
               WHEN jh.je_source = 'Revaluation' THEN 'V'
               ELSE 'N'
             END activity_kind,
             SUM(NVL(jl.accounted_dr,0)-NVL(jl.accounted_cr,0)) activity_amount
        FROM apps.gl_je_lines{L} jl
        JOIN apps.gl_je_headers{L} jh
          ON jh.je_header_id = jl.je_header_id
       WHERE jh.ledger_id = :b_ledger
         AND jh.period_name = :b_period
         AND jh.actual_flag = 'A'
         AND jh.status = 'P'
         AND jl.code_combination_id IN ({CCIDS})
       GROUP BY jl.code_combination_id,
             CASE
               WHEN jh.je_source = 'Receivables' THEN 'R'
               WHEN jh.je_source = 'Revaluation' THEN 'V'
               ELSE 'N'
             END~', '{L}', '@' || l_link);
    l_sql := REPLACE(l_sql, '{CCIDS}', l_ccid_list);

    OPEN l_cursor FOR l_sql USING p_ledger_id, l_period;
    FETCH l_cursor BULK COLLECT INTO l_ccid, l_activity_kind, l_activity_amount;
    CLOSE l_cursor;

    IF l_ccid.COUNT > 0 THEN
      FOR i IN 1 .. l_ccid.COUNT LOOP
        l_key := TO_CHAR(l_ccid(i));
        CASE l_activity_kind(i)
          WHEN 'R' THEN l_recv_map(l_key) := l_activity_amount(i);
          WHEN 'V' THEN l_reval_map(l_key) := l_activity_amount(i);
          ELSE l_nonrecv_map(l_key) := l_activity_amount(i);
        END CASE;
      END LOOP;
    END IF;

    l_sql := REPLACE(q'~
      SELECT xal.code_combination_id,
             SUM(NVL(xal.accounted_dr,0)-NVL(xal.accounted_cr,0)) not_transferred_amount
        FROM apps.xla_ae_lines{L} xal
        JOIN apps.xla_ae_headers{L} xah
          ON xah.application_id = xal.application_id
         AND xah.ae_header_id = xal.ae_header_id
       WHERE xah.application_id = 222
         AND xah.ledger_id = :b_ledger
         AND xah.accounting_date <= :b_as_of_date
         AND NVL(xah.gl_transfer_status_code,'NT') <> 'Y'
         AND xal.code_combination_id IN ({CCIDS})
       GROUP BY xal.code_combination_id~', '{L}', '@' || l_link);
    l_sql := REPLACE(l_sql, '{CCIDS}', l_ccid_list);

    OPEN l_cursor FOR l_sql USING p_ledger_id, l_as_of_date;
    FETCH l_cursor BULK COLLECT INTO l_ccid, l_not_xfer_amount;
    CLOSE l_cursor;

    IF l_ccid.COUNT > 0 THEN
      FOR i IN 1 .. l_ccid.COUNT LOOP
        l_not_xfer_map(TO_CHAR(l_ccid(i))) := l_not_xfer_amount(i);
      END LOOP;
    END IF;

    l_key := l_ar_amount.FIRST;
    WHILE l_key IS NOT NULL LOOP
      PIPE ROW(xxme_ar_gl_recon_v2_ot
      (
        TO_NUMBER(l_key), l_segments(l_key), l_natural(l_key),
        l_ar_amount(l_key),
        CASE WHEN l_gl_begin_map.EXISTS(l_key) THEN l_gl_begin_map(l_key) END,
        CASE WHEN l_gl_net_map.EXISTS(l_key) THEN l_gl_net_map(l_key) END,
        CASE WHEN l_gl_end_map.EXISTS(l_key) THEN l_gl_end_map(l_key) END,
        l_ar_amount(l_key) - CASE WHEN l_gl_end_map.EXISTS(l_key) THEN NVL(l_gl_end_map(l_key),0) ELSE 0 END,
        l_loaded_at(l_key), l_gl_time,
        CASE WHEN l_not_xfer_map.EXISTS(l_key) THEN NVL(l_not_xfer_map(l_key),0) ELSE 0 END,
        CASE WHEN l_recv_map.EXISTS(l_key) THEN NVL(l_recv_map(l_key),0) ELSE 0 END,
        CASE WHEN l_reval_map.EXISTS(l_key) THEN NVL(l_reval_map(l_key),0) ELSE 0 END,
        CASE WHEN l_nonrecv_map.EXISTS(l_key) THEN NVL(l_nonrecv_map(l_key),0) ELSE 0 END
      ));
      l_key := l_ar_amount.NEXT(l_key);
    END LOOP;
    RETURN;
  EXCEPTION
    WHEN OTHERS THEN
      IF l_cursor%ISOPEN THEN
        CLOSE l_cursor;
      END IF;
      RAISE;
  END get_gl_reconciliation;
END xxme_ar_recon_v2_pkg;
/
