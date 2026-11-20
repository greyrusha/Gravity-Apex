set define off

CREATE OR REPLACE PACKAGE BODY xx_ap_trial_balance_pkg AS

  PROCEDURE clear_snapshot (
    p_ledger_id     IN NUMBER,
    p_snapshot_date IN DATE,
    p_company       IN VARCHAR2,
    p_db_link       IN VARCHAR2
  ) IS
  BEGIN
    DELETE FROM xx_ap_trial_balance_snap
    WHERE  ledger_id       = p_ledger_id
    AND    as_of_date      = p_snapshot_date
    AND    company_segment = p_company
    AND    db_link         = p_db_link;
    -- Deliberately no COMMIT here -- see the concurrency-lock note in the
    -- package header. This must stay part of the SAME transaction as the
    -- lock acquisition and the reload INSERT in POPULATE_SNAPSHOT. If you
    -- call this standalone, COMMIT at the call site yourself.
  END clear_snapshot;

  -- AWS phase 1 accepts only the centrally governed ADG database link.
  FUNCTION validate_db_link(p_db_link IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN xxme_db_source_pkg.normalize_db_link(p_db_link);
  END validate_db_link;

  -- Bootstraps the lock row in an autonomous transaction so creating a
  -- missing key never commits pending caller DML.
  PROCEDURE ensure_snapshot_lock_row (
    p_ledger_id     IN NUMBER,
    p_snapshot_date IN DATE,
    p_company       IN VARCHAR2,
    p_db_link       IN VARCHAR2
  ) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    INSERT INTO xx_ap_trial_balance_lock (
      as_of_date,ledger_id,company_segment,db_link
    ) VALUES (
      p_snapshot_date,p_ledger_id,p_company,p_db_link
    );
    COMMIT;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      ROLLBACK;
  END ensure_snapshot_lock_row;

  -- Attempts a non-blocking exclusive row lock on the key; returns false if absent.
  FUNCTION try_lock_snapshot_row (
    p_ledger_id     IN NUMBER,
    p_snapshot_date IN DATE,
    p_company       IN VARCHAR2,
    p_db_link       IN VARCHAR2
  ) RETURN BOOLEAN IS
    l_dummy PLS_INTEGER;
  BEGIN
    SELECT 1
    INTO   l_dummy
    FROM   xx_ap_trial_balance_lock lck
    WHERE  lck.as_of_date=p_snapshot_date AND
           lck.ledger_id=p_ledger_id AND
           lck.company_segment=p_company AND
           lck.db_link=p_db_link
    FOR UPDATE NOWAIT;
    RETURN TRUE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN FALSE;
    WHEN OTHERS THEN
      IF SQLCODE = -54 THEN
        RAISE_APPLICATION_ERROR(-20003,
          'This AP Trial Balance snapshot is already being loaded by another session. Please wait for it to finish and try again.');
      END IF;
      RAISE;
  END try_lock_snapshot_row;

  -- Serializes concurrent POPULATE_SNAPSHOT calls for the same snapshot
  -- key using an autonomous lock-row bootstrap plus FOR UPDATE NOWAIT.
  PROCEDURE acquire_snapshot_lock (
    p_ledger_id     IN NUMBER,
    p_snapshot_date IN DATE,
    p_company       IN VARCHAR2,
    p_db_link       IN VARCHAR2
  ) IS
    l_db_link VARCHAR2(128);
  BEGIN
    l_db_link := validate_db_link(p_db_link);

    -- Attempt lock before autonomous bootstrap to avoid self-deadlock if
    -- the caller already created or touched the lock row in this txn.
    IF try_lock_snapshot_row(p_ledger_id, p_snapshot_date, p_company, l_db_link) THEN
      RETURN;
    END IF;

    ensure_snapshot_lock_row(p_ledger_id, p_snapshot_date, p_company, l_db_link);

    IF NOT try_lock_snapshot_row(p_ledger_id, p_snapshot_date, p_company, l_db_link) THEN
      RAISE_APPLICATION_ERROR(-20003,
        'Unable to acquire AP Trial Balance snapshot lock.');
    END IF;
  END acquire_snapshot_lock;

  PROCEDURE populate_snapshot (
    p_ledger_id     IN  NUMBER,
    p_snapshot_date IN  DATE,
    p_company       IN  VARCHAR2,
    p_db_link       IN  VARCHAR2,
    p_loaded_by     IN  VARCHAR2 DEFAULT NULL,
    p_row_count     OUT NUMBER
  ) IS
    l_db_link   VARCHAR2(128);
    l_loaded_by VARCHAR2(100);
    l_sql       CLOB;
    l_cursor    SYS_REFCURSOR;

    -- Generic collection types for the BULK COLLECT below -- one physical
    -- collection variable per remote column (a weakly-typed ref cursor's
    -- BULK COLLECT INTO takes one target per selected column, there's no
    -- single-record shortcut for dynamic SQL). Sized generously and
    -- reused across columns rather than declaring a distinct TYPE per
    -- column -- the local variable only needs to be AT LEAST as wide as
    -- the widest value fetched; the real width constraint is enforced by
    -- the destination table column on INSERT.
    TYPE t_num_tab  IS TABLE OF NUMBER;
    TYPE t_str_tab  IS TABLE OF VARCHAR2(2000);
    TYPE t_date_tab IS TABLE OF DATE;

    l_org_id                t_num_tab;
    l_entity_id     t_num_tab;
    l_open_accounted_amount t_num_tab;
    l_open_entered_amount   t_num_tab;
    l_gl_liability_code     t_str_tab;
    l_gl_liab_ccid          t_num_tab;
    l_invoice_num           t_str_tab;
    l_invoice_id            t_num_tab;
    l_vendor_id             t_num_tab;
    l_vendor_site_id        t_num_tab;
    l_invoice_amount        t_num_tab;
    l_acct_invoice_amount   t_num_tab;
    l_supplier_name         t_str_tab;
    l_supplier_number       t_str_tab;
    l_vendor_site_code      t_str_tab;
    l_invoice_currency_code t_str_tab;
    l_invoice_date          t_date_tab;
    l_min_due_date          t_date_tab;
    l_max_due_date          t_date_tab;
    l_intercompany_segment  t_str_tab;

    -- Rows per FETCH/FORALL round trip. 19k rows / 5000 = ~4 round trips
    -- total -- tune if row counts grow much larger, but don't chase this
    -- too far: the whole point of batching is to avoid the distributed-DML
    -- row-by-row behavior, not to minimize round trips to exactly one.
    c_batch_size CONSTANT PLS_INTEGER := 5000;
  BEGIN
    l_db_link   := validate_db_link(p_db_link);
    l_loaded_by := NVL(p_loaded_by, SYS_CONTEXT('USERENV', 'SESSION_USER'));
    p_row_count := 0;

    -- Serialize against any other session loading this exact
    -- (as_of_date, ledger_id, company_segment, db_link) key right now.
    acquire_snapshot_lock(p_ledger_id, p_snapshot_date, p_company, l_db_link);

    -- Replace just this snapshot's rows -- every other loaded snapshot in
    -- the table is untouched. Same transaction as the lock above and the
    -- inserts below (no commit inside clear_snapshot).
    clear_snapshot(p_ledger_id, p_snapshot_date, p_company, l_db_link);

    -- NOT an INSERT ... SELECT ... @link anymore -- see the PERFORMANCE
    -- note in the package header for why. This is a plain remote SELECT
    -- (opened as a cursor), fetched in batches with BULK COLLECT, and
    -- inserted locally with FORALL. The snapshot-key/audit columns
    -- (as_of_date, ledger_id, company_segment, db_link, loaded_by,
    -- loaded_on) and the still-NULL intercompany_segment_desc are NOT
    -- selected here -- they're the same for every row in this load, so
    -- they're supplied once, locally, in the FORALL INSERT below instead
    -- of being fetched redundantly from the remote site 19,000 times.
    -- One side benefit: every remaining bind below is used exactly ONCE
    -- in the text, so (unlike the old version of this procedure) there's
    -- no repeated-placeholder/positional-USING-list bookkeeping to get
    -- wrong here.
    IF p_ledger_id IS NULL OR p_snapshot_date IS NULL OR p_company IS NULL THEN
      RAISE_APPLICATION_ERROR(-20002, 'Snapshot key parameters (ledger, date, company) are required.');
    END IF;

    -- Wave 3 (Item 1B): push company pruning (gl_code_combinations) into the xx
    -- aggregation block, replace _kfv with base gl_code_combinations, drop rigid
    -- global USE_NL on xte2/aia/pvs/pv while retaining PUSH_PRED(aps_due), and pass
    -- DBMS_ASSERT / locale-independent literals so @ADG sees exact selectivity.
    l_sql :=
      'SELECT /*+ DRIVING_SITE(aia) NO_MERGE(xx) LEADING(xx xte2 aia pvs pv aps_due) USE_NL(xte2 aia aps_due) USE_HASH(pvs pv) SWAP_JOIN_INPUTS(pvs) SWAP_JOIN_INPUTS(pv) PUSH_PRED(aps_due) */' ||
      '       aia.org_id,' ||
      '       xx.entity_id,' ||
      '       xx.open_accounted_amount,' ||
      '       xx.open_entered_amount,' ||
      '       xx.concatenated_segments,' ||
      '       xx.code_combination_id,' ||
      '       aia.invoice_num,' ||
      '       aia.invoice_id,' ||
      '       aia.vendor_id,' ||
      '       aia.vendor_site_id,' ||
      '       aia.invoice_amount,' ||
      '       NVL(aia.base_amount, aia.invoice_amount),' ||
      '       pv.vendor_name,' ||
      '       pv.segment1,' ||
      '       pvs.vendor_site_code,' ||
      '       aia.invoice_currency_code,' ||
      '       aia.invoice_date,' ||
      '       aps_due.min_due_date,' ||
      '       aps_due.max_due_date,' ||
      '       xx.segment8' ||
      ' FROM' ||
      '     ( SELECT /*+ NO_MERGE LEADING(gl xtd gcc tb) USE_HASH(tb) FULL(tb) */' ||
      '              tb.code_combination_id,' ||
      '              tb.trx_currency_code,' ||
      '              NVL(tb.applied_to_entity_id, tb.source_entity_id) entity_id,' ||
      '              SUM(NVL(tb.acctd_rounded_cr,0)) - SUM(NVL(tb.acctd_rounded_dr,0)) open_accounted_amount,' ||
      '              SUM(NVL(tb.entered_rounded_cr,0)) - SUM(NVL(tb.entered_rounded_dr,0)) open_entered_amount,' ||
      '              MAX(gcc.segment1 || ''.'' || gcc.segment2 || ''.'' || gcc.segment3 || ''.'' ||' ||
      '                  gcc.segment4 || ''.'' || gcc.segment5 || ''.'' || gcc.segment6 || ''.'' ||' ||
      '                  gcc.segment7 || ''.'' || gcc.segment8 || ''.'' || gcc.segment9) concatenated_segments,' ||
      '              MAX(gcc.segment8) segment8' ||
      '       FROM   apps.xla_trial_balances@' || l_db_link || ' tb,' ||
      '              apps.gl_ledgers@' || l_db_link || ' gl,' ||
      '              apps.xla_tb_definitions_b@' || l_db_link || ' xtd,' ||
      '              apps.gl_code_combinations@' || l_db_link || ' gcc' ||
      '       WHERE  tb.gl_date < TO_DATE(' ||
                     DBMS_ASSERT.ENQUOTE_LITERAL(TO_CHAR(TRUNC(p_snapshot_date), 'YYYY-MM-DD')) ||
                     ', ''YYYY-MM-DD'') + 1' ||
      '       AND    gl.ledger_id = ' || TO_CHAR(p_ledger_id, 'TM9', 'NLS_NUMERIC_CHARACTERS=''.,''') ||
      '       AND    gl.ledger_category_code = ''PRIMARY''' ||
      '       AND    tb.definition_code = xtd.definition_code' ||
      '       AND    xtd.ledger_id = gl.ledger_id' ||
      '       AND    gcc.code_combination_id = tb.code_combination_id' ||
      '       AND    gcc.segment1 = ' || DBMS_ASSERT.ENQUOTE_LITERAL(p_company) ||
      '       GROUP BY tb.code_combination_id,' ||
      '                NVL(tb.applied_to_entity_id, tb.source_entity_id),' ||
      '                tb.trx_currency_code' ||
      '       HAVING SUM(NVL(tb.acctd_rounded_cr,0)) <> SUM(NVL(tb.acctd_rounded_dr,0))' ||
      '     ) xx,' ||
      '     apps.ap_invoices_all@' || l_db_link || ' aia,' ||
      '     xla.xla_transaction_entities@' || l_db_link || ' xte2,' ||
      '     apps.ap_supplier_sites_all@' || l_db_link || ' pvs,' ||
      '     apps.ap_suppliers@' || l_db_link || ' pv,' ||
      '     ( SELECT aps.invoice_id, MIN(aps.due_date) min_due_date, MAX(aps.due_date) max_due_date' ||
      '       FROM   apps.ap_payment_schedules_all@' || l_db_link || ' aps' ||
      '       GROUP BY aps.invoice_id ) aps_due' ||
      ' WHERE  aia.invoice_id = xte2.source_id_int_1' ||
      ' AND    xte2.entity_id = xx.entity_id' ||
      ' AND    xte2.application_id = 200' ||
      ' AND    aia.vendor_site_id = pvs.vendor_site_id' ||
      ' AND    pvs.vendor_id = pv.vendor_id' ||
      ' AND    aps_due.invoice_id(+) = aia.invoice_id';

    OPEN l_cursor FOR l_sql;

    LOOP
      FETCH l_cursor BULK COLLECT INTO
        l_org_id, l_entity_id, l_open_accounted_amount, l_open_entered_amount,
        l_gl_liability_code, l_gl_liab_ccid, l_invoice_num, l_invoice_id, l_vendor_id,
        l_vendor_site_id, l_invoice_amount, l_acct_invoice_amount, l_supplier_name,
        l_supplier_number, l_vendor_site_code, l_invoice_currency_code, l_invoice_date,
        l_min_due_date, l_max_due_date, l_intercompany_segment
      LIMIT c_batch_size;

      EXIT WHEN l_org_id.COUNT = 0;

      FORALL i IN 1 .. l_org_id.COUNT
        INSERT INTO xx_ap_trial_balance_snap
          ( as_of_date, ledger_id, company_segment, db_link, org_id, entity_id,
            open_accounted_amount, open_entered_amount, gl_liability_code, gl_liab_ccid,
            invoice_num, invoice_id, vendor_id, vendor_site_id, invoice_amount,
            acct_invoice_amount, supplier_name, supplier_number, vendor_site_code,
            invoice_currency_code, invoice_date, min_due_date, max_due_date,
            intercompany_segment, intercompany_segment_desc, placeholder_for_reval,
            loaded_by, loaded_on )
        VALUES
          ( p_snapshot_date, p_ledger_id, p_company, l_db_link,
            l_org_id(i), l_entity_id(i), l_open_accounted_amount(i),
            l_open_entered_amount(i), l_gl_liability_code(i), l_gl_liab_ccid(i),
            l_invoice_num(i), l_invoice_id(i), l_vendor_id(i), l_vendor_site_id(i),
            l_invoice_amount(i), l_acct_invoice_amount(i), l_supplier_name(i),
            l_supplier_number(i), l_vendor_site_code(i), l_invoice_currency_code(i),
            l_invoice_date(i), l_min_due_date(i), l_max_due_date(i),
            l_intercompany_segment(i), NULL, NULL,
            l_loaded_by, SYSTIMESTAMP );

      p_row_count := p_row_count + l_org_id.COUNT;

      EXIT WHEN l_cursor%NOTFOUND;
    END LOOP;

    CLOSE l_cursor;

    -- Single commit point for the whole operation: lock acquisition,
    -- delete, and every batch inserted above all commit together here,
    -- which is also what releases the row lock for any session waiting
    -- behind it in ACQUIRE_SNAPSHOT_LOCK.
    COMMIT;

  EXCEPTION
    WHEN OTHERS THEN
      IF l_cursor%ISOPEN THEN
        CLOSE l_cursor;
      END IF;
      ROLLBACK;
      RAISE;
  END populate_snapshot;

  FUNCTION get_ap_aging_by_year (
    p_ledger_id        IN NUMBER,
    p_snapshot_date     IN DATE,
    p_company            IN VARCHAR2,
    p_db_link             IN VARCHAR2,
    p_aging_as_of_date      IN DATE DEFAULT TRUNC(SYSDATE)
  ) RETURN xx_ap_aging_tt PIPELINED IS
  BEGIN
    FOR r IN (
      SELECT g.ledger_id, g.org_id, g.entity_id, g.open_accounted_amount,
             g.open_entered_amount, g.gl_liability_code, g.gl_liab_ccid, g.invoice_num,
             g.invoice_id, g.vendor_id, g.vendor_site_id, g.invoice_amount,
             g.acct_invoice_amount, g.supplier_name, g.supplier_number,
             g.vendor_site_code, g.invoice_currency_code, g.invoice_date,
             g.min_due_date, g.max_due_date, g.intercompany_segment,
             g.intercompany_segment_desc,
             EXTRACT(YEAR FROM g.max_due_date)                                     due_year,
             TRUNC(p_aging_as_of_date) - TRUNC(g.max_due_date)                     days_overdue,
             CASE
               WHEN g.max_due_date IS NULL THEN NULL
               WHEN TRUNC(g.max_due_date) >= TRUNC(p_aging_as_of_date) THEN NULL   -- not yet due
               ELSE FLOOR((TRUNC(p_aging_as_of_date) - TRUNC(g.max_due_date)) / 365.25)
             END                                                                   years_overdue,
             CASE
               WHEN g.max_due_date IS NULL THEN 'Unknown'
               WHEN TRUNC(g.max_due_date) >= TRUNC(p_aging_as_of_date) THEN 'Current'
               WHEN FLOOR((TRUNC(p_aging_as_of_date) - TRUNC(g.max_due_date)) / 365.25) = 0 THEN '1 Year'
               WHEN FLOOR((TRUNC(p_aging_as_of_date) - TRUNC(g.max_due_date)) / 365.25) = 1 THEN '2 Years'
               ELSE '3+ Years'
             END                                                                   aging_bucket,
             CASE
               WHEN g.max_due_date IS NULL THEN 9
               WHEN TRUNC(g.max_due_date) >= TRUNC(p_aging_as_of_date) THEN 0
               WHEN FLOOR((TRUNC(p_aging_as_of_date) - TRUNC(g.max_due_date)) / 365.25) = 0 THEN 1
               WHEN FLOOR((TRUNC(p_aging_as_of_date) - TRUNC(g.max_due_date)) / 365.25) = 1 THEN 2
               ELSE 3
             END                                                                   aging_bucket_sort
      FROM   xx_ap_trial_balance_snap g
      WHERE  g.ledger_id       = p_ledger_id
      AND    g.as_of_date      = p_snapshot_date
      AND    g.company_segment = p_company
      AND    g.db_link         = p_db_link
    )
    LOOP
      PIPE ROW (
        xx_ap_aging_row_ot(
          r.ledger_id, r.org_id, r.entity_id, r.open_accounted_amount,
          r.open_entered_amount, r.gl_liability_code, r.gl_liab_ccid, r.invoice_num,
          r.invoice_id, r.vendor_id, r.vendor_site_id, r.invoice_amount,
          r.acct_invoice_amount, r.supplier_name, r.supplier_number,
          r.vendor_site_code, r.invoice_currency_code, r.invoice_date,
          r.min_due_date, r.max_due_date, r.intercompany_segment,
          r.intercompany_segment_desc, r.due_year, r.days_overdue,
          r.years_overdue, r.aging_bucket, r.aging_bucket_sort
        )
      );
    END LOOP;
    RETURN;
  END get_ap_aging_by_year;

  FUNCTION get_ap_aging_by_supplier (
    p_ledger_id        IN NUMBER,
    p_snapshot_date     IN DATE,
    p_company            IN VARCHAR2,
    p_db_link             IN VARCHAR2,
    p_aging_as_of_date      IN DATE DEFAULT TRUNC(SYSDATE)
  ) RETURN xx_ap_aging_supplier_tt PIPELINED IS
  BEGIN
    FOR r IN (
      -- Aggregate open_accounted_amount (unpaid snapshot liability) rather
      -- than acct_invoice_amount so supplier aging ties to Pages 22 and 24.
      SELECT y.vendor_id,
             y.supplier_name,
             y.supplier_number,
             SUM(CASE WHEN y.aging_bucket = 'Current'  THEN NVL(y.open_accounted_amount, 0) ELSE 0 END) current_amount,
             SUM(CASE WHEN y.aging_bucket = '1 Year'   THEN NVL(y.open_accounted_amount, 0) ELSE 0 END) year1_amount,
             SUM(CASE WHEN y.aging_bucket = '2 Years'  THEN NVL(y.open_accounted_amount, 0) ELSE 0 END) year2_amount,
             SUM(CASE WHEN y.aging_bucket = '3+ Years' THEN NVL(y.open_accounted_amount, 0) ELSE 0 END) year3plus_amount,
             SUM(CASE WHEN y.aging_bucket = 'Unknown'  THEN NVL(y.open_accounted_amount, 0) ELSE 0 END) unknown_amount,
             SUM(NVL(y.open_accounted_amount, 0))                                                     total_amount,
             COUNT(*)                                                                                 invoice_count
      FROM   TABLE(xx_ap_trial_balance_pkg.get_ap_aging_by_year(
                      p_ledger_id, p_snapshot_date, p_company, p_db_link, p_aging_as_of_date)) y
      GROUP BY y.vendor_id, y.supplier_name, y.supplier_number
    )
    LOOP
      PIPE ROW (
        xx_ap_aging_supplier_ot(
          r.vendor_id, r.supplier_name, r.supplier_number,
          r.current_amount, r.year1_amount, r.year2_amount, r.year3plus_amount,
          r.unknown_amount, r.total_amount, r.invoice_count
        )
      );
    END LOOP;
    RETURN;
  END get_ap_aging_by_supplier;

  FUNCTION get_ap_gl_reconciliation (
    p_ledger_id       IN NUMBER,
    p_snapshot_date    IN DATE,
    p_company           IN VARCHAR2,
    p_db_link            IN VARCHAR2,
    p_gl_as_of_date        IN DATE DEFAULT NULL
  ) RETURN xx_ap_gl_recon_tt PIPELINED IS

    l_db_link        VARCHAR2(128);
    l_gl_as_of_date  DATE;
    l_period_name    VARCHAR2(15);
    l_period_end_date DATE;
    l_currency_code  VARCHAR2(15);
    l_sql            VARCHAR2(4000);
    l_cursor         SYS_REFCURSOR;

    -- Keyed by TO_CHAR(code_combination_id) -- PL/SQL associative arrays
    -- can't be indexed by NUMBER directly. A plain NUMBER->VARCHAR2 cast
    -- is safe here since every CCID is a whole number with no NLS
    -- formatting applied. Missing key = no matching remote row; see the
    -- header note on NULL vs. 0 for what that means per amount.
    TYPE t_num_by_ccid IS TABLE OF NUMBER INDEX BY VARCHAR2(38);
    l_closing_bal      t_num_by_ccid;
    l_pay_activity     t_num_by_ccid;
    l_reval_activity   t_num_by_ccid;  -- period-scoped, JE_SOURCE = 'Revaluation'
    l_nonpay_activity  t_num_by_ccid;  -- period-scoped, "the rest" (not Payables, not Revaluation)
    l_not_transferred  t_num_by_ccid;
    l_ytd_pay          t_num_by_ccid;
    l_ytd_reval        t_num_by_ccid;  -- cumulative, JE_SOURCE = 'Revaluation'
    l_ytd_nonpay       t_num_by_ccid;  -- cumulative, "the rest"
    l_key              VARCHAR2(38);

    -- BULK COLLECT targets for the four remote fetches below.
    TYPE t_num_tab IS TABLE OF NUMBER;
    TYPE t_str_tab IS TABLE OF VARCHAR2(30);
    l_ccid_tab   t_num_tab;
    l_amt_tab    t_num_tab;
    l_src_tab    t_str_tab;

    -- The local driving row source: one row per GL liability CCID found
    -- in the loaded AP snapshot, with the true (de-duplicated) AP balance
    -- for that CCID -- see the header note on why DISTINCT-then-SUM is
    -- required here, same trap as OPEN_ACCOUNTED_AMOUNT elsewhere in this
    -- package.
    l_ccid_list VARCHAR2(4000); -- comma-separated literal list for the remote IN-lists below
  BEGIN
    l_db_link       := validate_db_link(p_db_link);
    l_gl_as_of_date := NVL(p_gl_as_of_date, p_snapshot_date);

    -- Resolve the GL period covering l_gl_as_of_date for this ledger, that
    -- ledger's functional currency, AND that period's END_DATE (needed
    -- below to bound the cumulative YTD activity fetch), in one remote
    -- round trip. See header note: BETWEEN start_date/end_date, not
    -- string/date-trunc matching -- period boundaries are
    -- ledger-calendar-defined.
    l_sql :=
      'SELECT gp.period_name, gl.currency_code, gp.end_date' ||
      ' FROM   apps.gl_ledgers@' || l_db_link || ' gl,' ||
      '        apps.gl_periods@' || l_db_link || ' gp' ||
      ' WHERE  gl.ledger_id = :p_ledger_id' ||
      ' AND    gp.period_set_name = gl.period_set_name' ||
      ' AND    gp.period_type = gl.accounted_period_type' ||
      ' AND    gp.adjustment_period_flag = ''N''' ||
      ' AND    :p_as_of_date BETWEEN gp.start_date AND gp.end_date';

    BEGIN
      EXECUTE IMMEDIATE l_sql INTO l_period_name, l_currency_code, l_period_end_date
        USING p_ledger_id, l_gl_as_of_date;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20004,
          'No GL period found for ledger_id ' || p_ledger_id ||
          ' covering ' || TO_CHAR(l_gl_as_of_date, 'YYYY-MM-DD') ||
          ' -- check the GL calendar is defined that far, or pass a different p_gl_as_of_date.');
      WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20005,
          'Multiple GL periods matched ledger_id ' || p_ledger_id ||
          ' for ' || TO_CHAR(l_gl_as_of_date, 'YYYY-MM-DD') ||
          ' -- overlapping period definitions in GL_PERIODS; this needs to be resolved on the EBS side.');
    END;

    -- Local driving row source: one row per GL_LIAB_CCID in this snapshot,
    -- true AP balance per CCID (DISTINCT collapses the repeated
    -- open_accounted_amount within each ccid/entity/currency group before
    -- SUMming across groups -- see header note). No db link involved here.
    FOR c IN (
      SELECT gl_liab_ccid,
             MAX(gl_liability_code) gl_liability_code,
             SUM(open_accounted_amount) ap_open_accounted_amount
      FROM   ( SELECT DISTINCT gl_liab_ccid, gl_liability_code, entity_id,
                               invoice_currency_code, open_accounted_amount
               FROM   xx_ap_trial_balance_snap
               WHERE  ledger_id       = p_ledger_id
               AND    as_of_date      = p_snapshot_date
               AND    company_segment = p_company
               AND    db_link         = l_db_link
               AND    gl_liab_ccid IS NOT NULL )
      GROUP BY gl_liab_ccid
    ) LOOP
      l_ccid_list := l_ccid_list || CASE WHEN l_ccid_list IS NULL THEN '' ELSE ',' END || c.gl_liab_ccid;
    END LOOP;

    -- Nothing to reconcile (no rows in this snapshot, or none carry a
    -- gl_liab_ccid) -- pipe nothing rather than run remote queries with an
    -- empty IN-list (which is a SQL syntax error, not just zero rows).
    IF l_ccid_list IS NULL THEN
      RETURN;
    END IF;

    -- Remote fetch 1: cumulative closing balance per CCID from
    -- GL_BALANCES. SUM/GROUP BY defensively covers more than one matching
    -- row per CCID (see header note); normally resolves to exactly one.
    --
    -- SIGN CONVENTION -- CR minus DR, NOT the more common DR-CR: this
    -- matches AP_OPEN_ACCOUNTED_AMOUNT above, which is computed
    -- CR-DR in POPULATE_SNAPSHOT's XLA_TRIAL_BALANCES subquery (credit-
    -- positive, appropriate for a liability's normal balance). GL_BALANCES
    -- has no sign convention of its own -- BEGIN_BALANCE_DR/CR and
    -- PERIOD_NET_DR/CR are just paired columns, and whoever derives a
    -- "balance" from them picks the sign. Deriving it here as DR-CR (the
    -- textbook GL convention) would put a healthy liability's GL side at
    -- roughly the NEGATIVE of its AP side, making VARIANCE_AMOUNT show a
    -- swing of roughly double the true balance for every CCID that's
    -- actually fine. CR-DR here is what makes GL_CLOSING_BALANCE
    -- comparable to AP_OPEN_ACCOUNTED_AMOUNT at all.
    l_sql :=
      'SELECT /*+ DRIVING_SITE(gb) */ gb.code_combination_id,' ||
      '       SUM( NVL(gb.begin_balance_cr,0) - NVL(gb.begin_balance_dr,0)' ||
      '          + NVL(gb.period_net_cr,0)   - NVL(gb.period_net_dr,0) )' ||
      ' FROM   apps.gl_balances@' || l_db_link || ' gb' ||
      ' WHERE  gb.ledger_id      = :p_ledger_id' ||
      ' AND    gb.period_name    = :p_period_name' ||
      ' AND    gb.actual_flag    = ''A''' ||
      ' AND    gb.currency_code  = :p_currency_code' ||
      ' AND    gb.translated_flag IS NULL' ||
      ' AND    gb.code_combination_id IN (' || l_ccid_list || ')' ||
      ' GROUP BY gb.code_combination_id';

    OPEN l_cursor FOR l_sql USING p_ledger_id, l_period_name, l_currency_code;
    FETCH l_cursor BULK COLLECT INTO l_ccid_tab, l_amt_tab;
    CLOSE l_cursor;

    FOR i IN 1 .. l_ccid_tab.COUNT LOOP
      l_closing_bal(TO_CHAR(l_ccid_tab(i))) := l_amt_tab(i);
    END LOOP;

    -- Remote fetch 2: period-scoped net activity per CCID, split THREE
    -- ways -- Payables / Revaluation / everything else -- from posted
    -- (STATUS = 'P') journals only. One query, GROUP BY ccid + source-flag,
    -- rather than three separate remote round trips.
    --
    -- 'Revaluation' is Oracle's own standard seeded JE_SOURCE for the
    -- Revalue Balances/Foreign Currency Revaluation program's unrealized
    -- FX gain/loss postings -- same kind of fixed, environment-independent
    -- value as 'Payables' itself, not something specific to this package.
    -- Broken out separately because it's routine, automated GL activity
    -- for any CCID with foreign-currency invoices, and lumping it into
    -- "everything else" made that bucket harder to read: a large
    -- non-Payables swing could be ordinary FX revaluation or something
    -- genuinely worth investigating, and the combined bucket couldn't
    -- tell you which.
    --
    -- SAME SIGN CONVENTION AS THE GL_BALANCES FETCH ABOVE -- CR-DR, not
    -- DR-CR, so a positive number here means that source's postings
    -- INCREASED the liability that period (a net credit), consistent with
    -- AP_OPEN_ACCOUNTED_AMOUNT/GL_CLOSING_BALANCE both being credit-
    -- positive. A net debit (the liability being paid down/relieved) comes
    -- back negative -- that's expected, not a sign error.
    l_sql :=
      'SELECT /*+ DRIVING_SITE(jl) */ jl.code_combination_id,' ||
      '       CASE WHEN jh.je_source = ''Payables''    THEN ''P''' ||
      '            WHEN jh.je_source = ''Revaluation'' THEN ''R''' ||
      '            ELSE ''N'' END,' ||
      '       SUM(NVL(jl.accounted_cr,0)) - SUM(NVL(jl.accounted_dr,0))' ||
      ' FROM   apps.gl_je_lines@' || l_db_link || ' jl,' ||
      '        apps.gl_je_headers@' || l_db_link || ' jh' ||
      ' WHERE  jl.je_header_id = jh.je_header_id' ||
      ' AND    jh.ledger_id    = :p_ledger_id' ||
      ' AND    jh.period_name  = :p_period_name' ||
      ' AND    jh.actual_flag  = ''A''' ||
      ' AND    jh.status       = ''P''' ||
      ' AND    jl.code_combination_id IN (' || l_ccid_list || ')' ||
      ' GROUP BY jl.code_combination_id,' ||
      '          CASE WHEN jh.je_source = ''Payables''    THEN ''P''' ||
      '               WHEN jh.je_source = ''Revaluation'' THEN ''R''' ||
      '               ELSE ''N'' END';

    OPEN l_cursor FOR l_sql USING p_ledger_id, l_period_name;
    FETCH l_cursor BULK COLLECT INTO l_ccid_tab, l_src_tab, l_amt_tab;
    CLOSE l_cursor;

    FOR i IN 1 .. l_ccid_tab.COUNT LOOP
      l_key := TO_CHAR(l_ccid_tab(i));
      IF l_src_tab(i) = 'P' THEN
        l_pay_activity(l_key) := l_amt_tab(i);
      ELSIF l_src_tab(i) = 'R' THEN
        l_reval_activity(l_key) := l_amt_tab(i);
      ELSE
        l_nonpay_activity(l_key) := l_amt_tab(i);
      END IF;
    END LOOP;

    -- Remote fetch 3: AP subledger accounting NOT YET transferred to GL,
    -- per CCID -- the standard Oracle "timing gap" check (see header note
    -- and 02_xx_ap_aging_types.sql). CUMULATIVE through l_gl_as_of_date
    -- (ACCOUNTING_DATE <= :p_as_of_date), NOT period-scoped like the two
    -- activity fetches above -- this has to cover everything ever
    -- accounted and still stuck pre-transfer, not just this period's,
    -- since a backlog from an earlier period is just as real a
    -- contributor to today's variance. APPLICATION_ID = 200 is Payables'
    -- own seeded, stable application id in EBS (same kind of hardcode as
    -- C_INTERCOMPANY_VSET_ID in the package spec) -- restricts this to AP
    -- subledger accounting events only, not every application's XLA data.
    -- GL_TRANSFER_STATUS_CODE <> 'Y' catches 'NT' (not transferred) and
    -- any other non-'Y' in-process status; NVL guards a NULL status the
    -- same way. Same CR-DR sign convention as everything else in this
    -- function.
    l_sql :=
      'SELECT /*+ DRIVING_SITE(xah) FULL(xah) */ xal.code_combination_id,' ||
      '       SUM(NVL(xal.accounted_cr,0)) - SUM(NVL(xal.accounted_dr,0))' ||
      ' FROM   apps.xla_ae_lines@' || l_db_link || ' xal,' ||
      '        apps.xla_ae_headers@' || l_db_link || ' xah' ||
      ' WHERE  xal.ae_header_id  = xah.ae_header_id' ||
      ' AND    xal.application_id = 200' ||
      ' AND    xah.application_id = 200' ||
      ' AND    xah.ledger_id      = :p_ledger_id' ||
      ' AND    xah.accounting_date <= :p_as_of_date' ||
      ' AND    NVL(xah.gl_transfer_status_code,''NT'') <> ''Y''' ||
      ' AND    xal.code_combination_id IN (' || l_ccid_list || ')' ||
      ' GROUP BY xal.code_combination_id';

    OPEN l_cursor FOR l_sql USING p_ledger_id, l_gl_as_of_date;
    FETCH l_cursor BULK COLLECT INTO l_ccid_tab, l_amt_tab;
    CLOSE l_cursor;

    FOR i IN 1 .. l_ccid_tab.COUNT LOOP
      l_not_transferred(TO_CHAR(l_ccid_tab(i))) := l_amt_tab(i);
    END LOOP;

    -- Remote fetch 4: CUMULATIVE (not period-scoped) net activity per CCID,
    -- same three-way Payables/Revaluation/everything-else split as fetch
    -- 2, but joined through GL_PERIODS/GL_LEDGERS and filtered on
    -- GP.END_DATE <= L_PERIOD_END_DATE instead of JH.PERIOD_NAME =
    -- :p_period_name, so it sums every posted period from this ledger's
    -- journal history through the resolved period, not just one. THIS IS
    -- THE HEAVIEST QUERY IN THE PACKAGE -- it can scan years of
    -- GL_JE_LINES for a mature ledger, bounded only by the CCID IN-list
    -- (see header note: check this first if GET_AP_GL_RECONCILIATION ever
    -- feels slow). Confirmed against Oracle's own seeded Payables Trial
    -- Balance report during development -- see 02_xx_ap_aging_types.sql's
    -- GL_YTD_PAYABLES_ACTIVITY/GL_YTD_REVALUATION_ACTIVITY/
    -- GL_YTD_NON_PAYABLES_ACTIVITY comments for what this does and does
    -- not explain.
    l_sql :=
      'SELECT /*+ DRIVING_SITE(jl) LEADING(gl gp jl jh) USE_NL(jl jh)' ||
      '           INDEX(jl GL_JE_LINES_N1) INDEX(jh GL_JE_HEADERS_U1) */' ||
      '       jl.code_combination_id,' ||
      '       CASE WHEN jh.je_source = ''Payables''    THEN ''P''' ||
      '            WHEN jh.je_source = ''Revaluation'' THEN ''R''' ||
      '            ELSE ''N'' END,' ||
      '       SUM(NVL(jl.accounted_cr,0)) - SUM(NVL(jl.accounted_dr,0))' ||
      ' FROM   apps.gl_je_lines@' || l_db_link || ' jl,' ||
      '        apps.gl_je_headers@' || l_db_link || ' jh,' ||
      '        apps.gl_periods@' || l_db_link || ' gp,' ||
      '        apps.gl_ledgers@' || l_db_link || ' gl' ||
      ' WHERE  jl.je_header_id = jh.je_header_id' ||
      ' AND    jl.period_name  = gp.period_name' ||
      ' AND    jh.ledger_id    = :p_ledger_id' ||
      ' AND    gl.ledger_id    = :p_ledger_id' ||
      ' AND    gp.period_set_name = gl.period_set_name' ||
      ' AND    gp.period_type     = gl.accounted_period_type' ||
      ' AND    gp.period_name     = jh.period_name' ||
      ' AND    gp.end_date <= :p_period_end_date' ||
      ' AND    jh.actual_flag  = ''A''' ||
      ' AND    jh.status       = ''P''' ||
      ' AND    jl.code_combination_id IN (' || l_ccid_list || ')' ||
      ' GROUP BY jl.code_combination_id,' ||
      '          CASE WHEN jh.je_source = ''Payables''    THEN ''P''' ||
      '               WHEN jh.je_source = ''Revaluation'' THEN ''R''' ||
      '               ELSE ''N'' END';

    OPEN l_cursor FOR l_sql USING p_ledger_id, p_ledger_id, l_period_end_date;
    FETCH l_cursor BULK COLLECT INTO l_ccid_tab, l_src_tab, l_amt_tab;
    CLOSE l_cursor;

    FOR i IN 1 .. l_ccid_tab.COUNT LOOP
      l_key := TO_CHAR(l_ccid_tab(i));
      IF l_src_tab(i) = 'P' THEN
        l_ytd_pay(l_key) := l_amt_tab(i);
      ELSIF l_src_tab(i) = 'R' THEN
        l_ytd_reval(l_key) := l_amt_tab(i);
      ELSE
        l_ytd_nonpay(l_key) := l_amt_tab(i);
      END IF;
    END LOOP;

    -- Second pass over the same local driving set, now piping each row
    -- combined with whatever the four remote fetches found for its CCID.
    -- A CCID absent from l_closing_bal (no GL_BALANCES row at all) pipes
    -- GL_CLOSING_BALANCE/VARIANCE_AMOUNT as NULL rather than assuming
    -- zero -- see header/type comments. Absent from l_pay_activity/
    -- l_reval_activity/l_nonpay_activity/l_not_transferred/l_ytd_pay/
    -- l_ytd_reval/l_ytd_nonpay legitimately means zero (no activity from
    -- that source in scope; nothing pending transfer), so those default to
    -- 0, not NULL -- this is expected and common for l_reval_activity/
    -- l_ytd_reval in particular, on any CCID whose invoices never carry a
    -- foreign currency.
    FOR c IN (
      SELECT gl_liab_ccid,
             MAX(gl_liability_code) gl_liability_code,
             SUM(open_accounted_amount) ap_open_accounted_amount
      FROM   ( SELECT DISTINCT gl_liab_ccid, gl_liability_code, entity_id,
                               invoice_currency_code, open_accounted_amount
               FROM   xx_ap_trial_balance_snap
               WHERE  ledger_id       = p_ledger_id
               AND    as_of_date      = p_snapshot_date
               AND    company_segment = p_company
               AND    db_link         = l_db_link
               AND    gl_liab_ccid IS NOT NULL )
      GROUP BY gl_liab_ccid
    ) LOOP
      l_key := TO_CHAR(c.gl_liab_ccid);

      PIPE ROW (
        xx_ap_gl_recon_row_ot(
          c.gl_liab_ccid,
          c.gl_liability_code,
          c.ap_open_accounted_amount,
          l_period_name,
          l_currency_code,
          CASE WHEN l_closing_bal.EXISTS(l_key) THEN l_closing_bal(l_key) END,
          NVL(CASE WHEN l_pay_activity.EXISTS(l_key)    THEN l_pay_activity(l_key)    END, 0),
          NVL(CASE WHEN l_reval_activity.EXISTS(l_key)  THEN l_reval_activity(l_key)  END, 0),
          NVL(CASE WHEN l_nonpay_activity.EXISTS(l_key) THEN l_nonpay_activity(l_key) END, 0),
          CASE WHEN l_closing_bal.EXISTS(l_key)
               THEN c.ap_open_accounted_amount - l_closing_bal(l_key)
          END,
          NVL(CASE WHEN l_not_transferred.EXISTS(l_key) THEN l_not_transferred(l_key) END, 0),
          NVL(CASE WHEN l_ytd_pay.EXISTS(l_key)    THEN l_ytd_pay(l_key)    END, 0),
          NVL(CASE WHEN l_ytd_reval.EXISTS(l_key)  THEN l_ytd_reval(l_key)  END, 0),
          NVL(CASE WHEN l_ytd_nonpay.EXISTS(l_key) THEN l_ytd_nonpay(l_key) END, 0)
        )
      );
    END LOOP;

    RETURN;

  EXCEPTION
    WHEN NO_DATA_NEEDED THEN
      IF l_cursor%ISOPEN THEN
        CLOSE l_cursor;
      END IF;
      RETURN;
    WHEN OTHERS THEN
      IF l_cursor%ISOPEN THEN
        CLOSE l_cursor;
      END IF;
      RAISE;
  END get_ap_gl_reconciliation;

END xx_ap_trial_balance_pkg;
/
