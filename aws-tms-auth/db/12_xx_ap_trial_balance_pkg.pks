set define off

CREATE OR REPLACE PACKAGE xx_ap_trial_balance_pkg AS

  -- Hardcoded per your instruction, in place of a dynamic
  -- FND_ID_FLEX_SEGMENTS lookup -- see 04's header for the tradeoff and
  -- what would need to change if this ever stops being true.
  c_intercompany_vset_id CONSTANT NUMBER := 1011067;

  -- p_db_link is retained for API compatibility. AWS phase 1 accepts
  -- only the centrally governed ADG link. It is also part of
  -- the snapshot key (see 01_xx_ap_trial_balance_snap.sql) -- since this
  -- is itself a runtime parameter, ledger_id/company_segment alone don't
  -- guarantee uniqueness if this is ever loaded from more than one EBS
  -- source.
  --
  -- p_snapshot_date: the AS OF date this load represents (e.g. a
  -- period-end) -- together with p_ledger_id/p_company/p_db_link, this
  -- is the snapshot key. Re-running this for a key that's already loaded
  -- replaces just that key's rows; a new key adds a new snapshot
  -- alongside the ones already there.
  --
  -- p_loaded_by: defaults to the current session's user if omitted --
  -- pass it explicitly only if you want the audit trail to show someone
  -- other than the actual database session user (e.g. an APEX
  -- application user id/username, if this were ever called from a
  -- context where those differ).
  PROCEDURE populate_snapshot (
    p_ledger_id     IN  NUMBER,
    p_snapshot_date IN  DATE,
    p_company       IN  VARCHAR2,
    p_db_link       IN  VARCHAR2,
    p_loaded_by     IN  VARCHAR2 DEFAULT NULL,
    p_row_count     OUT NUMBER
  );

  -- Acquires an exclusive transaction-scoped lock row for one snapshot key
  -- using FOR UPDATE NOWAIT (creating the lock row autonomously if absent).
  -- Raises -20003 when another session currently holds the lock.
  PROCEDURE acquire_snapshot_lock (
    p_ledger_id     IN NUMBER,
    p_snapshot_date IN DATE,
    p_company       IN VARCHAR2,
    p_db_link       IN VARCHAR2
  );

  -- Deletes just the rows for one snapshot key, leaving every other
  -- loaded snapshot untouched. Does NOT commit (see body) -- also called
  -- automatically at the start of POPULATE_SNAPSHOT as part of that same
  -- transaction. Call this standalone only if you want to purge one
  -- snapshot without reloading it, and remember to COMMIT afterward
  -- yourself. p_db_link here is just the stored key value (an exact
  -- match against what was loaded) -- it is not validated or used to
  -- build a link reference, so an arbitrary/nonexistent link name simply
  -- matches zero rows rather than erroring.
  PROCEDURE clear_snapshot (
    p_ledger_id     IN NUMBER,
    p_snapshot_date IN DATE,
    p_company       IN VARCHAR2,
    p_db_link       IN VARCHAR2
  );

  -- AP aging by year, for one loaded snapshot (p_ledger_id/p_snapshot_date
  -- /p_company/p_db_link), aged as of p_aging_as_of_date (defaults to
  -- today). Call as:
  --   SELECT * FROM TABLE(xx_ap_trial_balance_pkg.get_ap_aging_by_year(
  --            2061, DATE '2026-08-31', '01', 'ADG', DATE '2026-08-31'))
  FUNCTION get_ap_aging_by_year (
    p_ledger_id        IN NUMBER,
    p_snapshot_date     IN DATE,
    p_company            IN VARCHAR2,
    p_db_link             IN VARCHAR2,
    p_aging_as_of_date      IN DATE DEFAULT TRUNC(SYSDATE)
  ) RETURN xx_ap_aging_tt PIPELINED;

  -- THE aging report: one row per supplier, aging buckets as open balance
  -- columns, for one loaded snapshot. Call as:
  --   SELECT * FROM TABLE(xx_ap_trial_balance_pkg.get_ap_aging_by_supplier(
  --            2061, DATE '2026-08-31', '01', 'ADG', DATE '2026-08-31'))
  --   ORDER BY total_amount DESC;
  FUNCTION get_ap_aging_by_supplier (
    p_ledger_id        IN NUMBER,
    p_snapshot_date     IN DATE,
    p_company            IN VARCHAR2,
    p_db_link             IN VARCHAR2,
    p_aging_as_of_date      IN DATE DEFAULT TRUNC(SYSDATE)
  ) RETURN xx_ap_aging_supplier_tt PIPELINED;

  -- AP-TO-GL RECONCILIATION: for one loaded AP snapshot
  -- (p_ledger_id/p_snapshot_date/p_company/p_db_link), one row per GL
  -- liability CCID present in that snapshot, live-queried against EBS
  -- GL_BALANCES/GL_JE_HEADERS/GL_JE_LINES/XLA_AE_HEADERS/XLA_AE_LINES
  -- over p_db_link -- nothing is stored locally by this function, unlike
  -- POPULATE_SNAPSHOT. Includes AP_NOT_TRANSFERRED_AMOUNT, the standard
  -- EBS AP/GL reconciliation timing check (how much AP accounting for a
  -- CCID hasn't reached GL yet) -- a large VARIANCE_AMOUNT alongside a
  -- large AP_NOT_TRANSFERRED_AMOUNT usually means "run Transfer to GL,"
  -- not "something's wrong." Also includes GL_YTD_PAYABLES_ACTIVITY/
  -- GL_YTD_REVALUATION_ACTIVITY/GL_YTD_NON_PAYABLES_ACTIVITY -- the same
  -- three-way JE_SOURCE split as GL_PERIOD_PAYABLES_ACTIVITY/
  -- GL_PERIOD_REVALUATION_ACTIVITY/GL_PERIOD_NON_PAYABLES_ACTIVITY, but
  -- cumulative through the as-of date instead of one period, matching
  -- Oracle's own seeded Payables Trial Balance report's Original
  -- Amount/Other Sources columns (with Other Sources further split into
  -- Revaluation and everything else) -- this is usually the biggest piece
  -- of a large VARIANCE_AMOUNT once transfer timing is ruled out. See 04's
  -- header for the full design (including why this is the heaviest query
  -- in the package) and xx_ap_gl_recon_row_ot in 02_xx_ap_aging_types.sql
  -- for what each output column means.
  --
  -- p_gl_as_of_date: which GL period to reconcile against, resolved via
  -- GL_PERIODS for p_ledger_id. Defaults to p_snapshot_date (reconcile the
  -- snapshot to the GL period covering its own as-of date) -- pass this
  -- explicitly only if you want to compare an already-loaded AP snapshot
  -- against a DIFFERENT GL period's closing balance, same independent-
  -- parameter pattern as p_aging_as_of_date above.
  --
  -- Call as:
  --   SELECT * FROM TABLE(xx_ap_trial_balance_pkg.get_ap_gl_reconciliation(
  --            2061, DATE '2026-08-31', '01', 'ADG'))
  --   ORDER BY ABS(NVL(variance_amount,0)) DESC;
  FUNCTION get_ap_gl_reconciliation (
    p_ledger_id       IN NUMBER,
    p_snapshot_date    IN DATE,
    p_company           IN VARCHAR2,
    p_db_link            IN VARCHAR2,
    p_gl_as_of_date        IN DATE DEFAULT NULL
  ) RETURN xx_ap_gl_recon_tt PIPELINED;

END xx_ap_trial_balance_pkg;
/
