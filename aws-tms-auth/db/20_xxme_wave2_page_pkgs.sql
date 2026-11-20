-- 20_xxme_wave2_page_pkgs.sql
-- Wave 2: Consolidate inline SQL/PLSQL from APEX Pages 61, 70, 71, 72 into AUTHID DEFINER packages
--         and eliminate REPLACE() literal concatenation + remote SYSDATE / predicate pushdown traps.
-- Packages created:
--   1. XXME_INV_PENDING_UI_PKG (Page 61)
--   2. XXME_PROCESS_MONITOR_PKG (Page 70)
--   3. XXME_FA_CLOSE_PKG        (Pages 71 & 72)

whenever sqlerror exit failure rollback
set define off

BEGIN
  IF USER <> 'GL_ACCOUNTS' OR SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') <> 'GL_ACCOUNTS' THEN
    RAISE_APPLICATION_ERROR(-20997, 'ABORT: 20_xxme_wave2_page_pkgs.sql must run as GL_ACCOUNTS, got ' || USER);
  END IF;
END;
/

whenever sqlerror continue none

prompt === 1/4: Create/Refresh Wave 2 SQL Object & Nested Table Types ===

DECLARE
  PROCEDURE drop_type_if_exists (p_type_name IN VARCHAR2) IS
  BEGIN
    EXECUTE IMMEDIATE 'DROP TYPE ' || DBMS_ASSERT.SIMPLE_SQL_NAME(p_type_name);
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE <> -4043 THEN
        RAISE;
      END IF;
  END drop_type_if_exists;
BEGIN
  drop_type_if_exists('XXME_P70_CA_ROW_NT');
  drop_type_if_exists('XXME_P70_RV_ROW_NT');
  drop_type_if_exists('XXME_P70_RS_ROW_NT');
  drop_type_if_exists('XXME_FA_CLOSE_STATUS_ROW_NT');
  drop_type_if_exists('XXME_FA_ASSET_DTL_ROW_NT');
  drop_type_if_exists('XXME_FA_GL_LINE_ROW_NT');
END;
/

CREATE OR REPLACE TYPE xxme_p70_ca_row_ot FORCE AS OBJECT (
  module                 VARCHAR2(400),
  ledger_id              NUMBER,
  ledger_name            VARCHAR2(100),
  request_id             NUMBER,
  status                 VARCHAR2(30),
  is_latest              VARCHAR2(1),
  requested_by           VARCHAR2(100),
  actual_start_date      DATE,
  actual_completion_date DATE,
  run_minutes            NUMBER,
  hours_since_run        NUMBER,
  accounting_end_date    VARCHAR2(10),
  process_category       VARCHAR2(240),
  accounting_mode        VARCHAR2(240),
  errors_only            VARCHAR2(240),
  report_style           VARCHAR2(240),
  transfer_to_gl         VARCHAR2(240),
  post_in_gl             VARCHAR2(240),
  gl_batch_name          VARCHAR2(240)
);
/

CREATE OR REPLACE TYPE xxme_p70_ca_row_nt AS TABLE OF xxme_p70_ca_row_ot;
/

CREATE OR REPLACE TYPE xxme_p70_rv_row_ot FORCE AS OBJECT (
  ledger_name       VARCHAR2(100),
  ledger_id         NUMBER,
  ledger_currency   VARCHAR2(30),
  run_rank          VARCHAR2(100),
  run_start         DATE,
  run_end           DATE,
  run_by            VARCHAR2(100),
  period_name       VARCHAR2(30),
  je_batch_id       NUMBER,
  batch_name        VARCHAR2(240),
  batch_status      VARCHAR2(30),
  je_header_id      NUMBER,
  journal_name      VARCHAR2(240),
  revalued_currency VARCHAR2(30),
  accounted_dr      NUMBER,
  accounted_cr      NUMBER,
  reversal_period   VARCHAR2(30),
  reversal_status   VARCHAR2(30)
);
/

CREATE OR REPLACE TYPE xxme_p70_rv_row_nt AS TABLE OF xxme_p70_rv_row_ot;
/

CREATE OR REPLACE TYPE xxme_p70_rs_row_ot FORCE AS OBJECT (
  ledger_name       VARCHAR2(100),
  ledger_id         NUMBER,
  ledger_currency   VARCHAR2(30),
  run_rank          VARCHAR2(100),
  run_start         DATE,
  run_end           DATE,
  run_batches       NUMBER,
  run_by            VARCHAR2(100),
  reversal_period   VARCHAR2(30),
  je_batch_id       NUMBER,
  batch_name        VARCHAR2(240),
  batch_status      VARCHAR2(30),
  je_header_id      NUMBER,
  journal_name      VARCHAR2(240),
  je_source         VARCHAR2(100),
  je_category       VARCHAR2(100),
  currency_code     VARCHAR2(30),
  accounted_dr      NUMBER,
  accounted_cr      NUMBER,
  orig_je_header_id NUMBER,
  orig_journal_name VARCHAR2(240),
  orig_period       VARCHAR2(30),
  orig_batch_name   VARCHAR2(240)
);
/

CREATE OR REPLACE TYPE xxme_p70_rs_row_nt AS TABLE OF xxme_p70_rs_row_ot;
/

CREATE OR REPLACE TYPE xxme_fa_close_status_row_ot FORCE AS OBJECT (
  ledger_id                 NUMBER,
  ledger_name               VARCHAR2(100),
  currency_code             VARCHAR2(30),
  book_type_code            VARCHAR2(30),
  book_class                VARCHAR2(30),
  deprn_calendar            VARCHAR2(30),
  period_name               VARCHAR2(30),
  period_status             VARCHAR2(30),
  period_close_date         DATE,
  deprn_run                 VARCHAR2(10),
  fa_summary_rows           NUMBER,
  fa_nonzero_rows           NUMBER,
  fa_deprn_amount           NUMBER,
  fa_catchup_amount         NUMBER,
  fa_positive_deprn         NUMBER,
  fa_negative_deprn         NUMBER,
  deprn_events              NUMBER,
  unaccounted_events        NUMBER,
  entries_not_final         NUMBER,
  entries_not_transferred   NUMBER,
  gl_groups_expected        NUMBER,
  gl_groups_missing         NUMBER,
  gl_shared_groups          NUMBER,
  gl_journals               NUMBER,
  gl_unposted               NUMBER,
  gl_journal_dr_total       NUMBER,
  fa_vs_gl_dr_diff          NUMBER,
  gl_batch_names            VARCHAR2(4000),
  activity_note             VARCHAR2(100),
  close_status              VARCHAR2(100),
  sla_expense_dr            NUMBER,
  sla_expense_cr            NUMBER,
  sla_expense_net           NUMBER,
  sla_expense_lines         NUMBER,
  orphan_asset_lines        NUMBER,
  sla_period_mismatch_lines NUMBER,
  sla_unlinked_lines        NUMBER,
  gl_posted_expense_dr      NUMBER,
  gl_posted_expense_cr      NUMBER,
  gl_posted_expense_net     NUMBER,
  gl_line_count             NUMBER,
  gl_mapping_issues         NUMBER,
  gl_posted_expense_lines   NUMBER,
  fa_vs_gl_expense_diff     NUMBER,
  reconciliation_status     VARCHAR2(50)
);
/

CREATE OR REPLACE TYPE xxme_fa_close_status_row_nt AS TABLE OF xxme_fa_close_status_row_ot;
/

CREATE OR REPLACE TYPE xxme_fa_asset_dtl_row_ot FORCE AS OBJECT (
  ledger_id                  NUMBER,
  book_type_code             VARCHAR2(30),
  period_name                VARCHAR2(30),
  asset_id                   NUMBER,
  asset_number               VARCHAR2(100),
  deprn_run_date             DATE,
  fa_deprn_amount            NUMBER,
  fa_catchup_amount          NUMBER,
  positive_deprn             NUMBER,
  negative_deprn             NUMBER,
  activity_type              VARCHAR2(50),
  sla_expense_dr             NUMBER,
  sla_expense_cr             NUMBER,
  sla_expense_net            NUMBER,
  posted_linked_sla_net      NUMBER,
  fa_sla_difference          NUMBER,
  sla_posted_link_difference NUMBER,
  sla_expense_lines          NUMBER,
  sla_period_mismatch_lines  NUMBER,
  posted_linked_lines        NUMBER,
  unlinked_expense_lines     NUMBER
);
/

CREATE OR REPLACE TYPE xxme_fa_asset_dtl_row_nt AS TABLE OF xxme_fa_asset_dtl_row_ot;
/

CREATE OR REPLACE TYPE xxme_fa_gl_line_row_ot FORCE AS OBJECT (
  ledger_id             NUMBER,
  book_type_code        VARCHAR2(30),
  period_name           VARCHAR2(30),
  je_header_id          NUMBER,
  journal_name          VARCHAR2(240),
  batch_name            VARCHAR2(240),
  status                VARCHAR2(30),
  je_line_num           NUMBER,
  code_combination_id   NUMBER,
  accounted_dr          NUMBER,
  accounted_cr          NUMBER,
  accounting_class_code VARCHAR2(30),
  mapping_status        VARCHAR2(30),
  account_code          VARCHAR2(4000)
);
/

CREATE OR REPLACE TYPE xxme_fa_gl_line_row_nt AS TABLE OF xxme_fa_gl_line_row_ot;
/

prompt === 2/4: XXME_INV_PENDING_UI_PKG (Page 61) ===

CREATE OR REPLACE PACKAGE xxme_inv_pending_ui_pkg AUTHID DEFINER AS
  PROCEDURE initialize_panes;

  PROCEDURE set_context;

  FUNCTION summary_sql RETURN VARCHAR2;

  FUNCTION details_sql RETURN VARCHAR2;

  PROCEDURE export_accepted_summary_xlsx;
END xxme_inv_pending_ui_pkg;
/

CREATE OR REPLACE PACKAGE BODY xxme_inv_pending_ui_pkg AS

  PROCEDURE validate_run_header (
    p_run_id     IN  VARCHAR2,
    p_period     OUT VARCHAR2,
    p_source     OUT VARCHAR2,
    p_resolution OUT VARCHAR2
  ) IS
  BEGIN
    IF p_run_id IS NULL OR NOT REGEXP_LIKE(p_run_id, '^[0-9A-F]{32}$', 'c') THEN
      RAISE_APPLICATION_ERROR(-20163, 'Invalid run context. Run Analysis again.');
    END IF;

    BEGIN
      SELECT c001, c002, c003
        INTO p_period, p_source, p_resolution
        FROM apex_collections
       WHERE collection_name = 'P61RUN_' || p_run_id
         AND seq_id = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20163, 'This run has expired. Run Analysis again.');
    END;

    IF p_source IS NULL
       OR p_source NOT IN ('ADG')
       OR p_period IS NULL
       OR NOT REGEXP_LIKE(p_period, '^(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)-[0-9]{4}$', 'c')
       OR p_resolution IS NULL
       OR p_resolution NOT IN ('REQUIRED', 'RECOMMENDED', 'ALL')
    THEN
      RAISE_APPLICATION_ERROR(-20163, 'Invalid accepted run. Run Analysis again.');
    END IF;
  END validate_run_header;

  PROCEDURE initialize_panes IS
    PROCEDURE put (
      p_name  IN VARCHAR2,
      p_value IN VARCHAR2
    ) IS
    BEGIN
      apex_util.set_session_state(p_name => p_name, p_value => p_value, p_commit => FALSE);
    END put;
  BEGIN
    -- Every full render starts idle. Do not delete collections belonging to other tabs.
    put('P61_RUN_ID',         NULL);
    put('P61_READY',          'N');
    put('P61_ORG_ID',         NULL);
    put('P61_TXN_TYPE',       NULL);
    put('P61_RUN_PERIOD',     NULL);
    put('P61_RUN_SOURCE',     NULL);
    put('P61_RUN_RESOLUTION', NULL);
  END initialize_panes;

  PROCEDURE set_context IS
    l_action         VARCHAR2(20)  := apex_application.g_x01;
    l_period         VARCHAR2(15)  := UPPER(TRIM(apex_application.g_x02));
    l_source         VARCHAR2(30)  := UPPER(TRIM(apex_application.g_x03));
    l_org_text       VARCHAR2(30)  := apex_application.g_x04;
    l_type           VARCHAR2(80)  := apex_application.g_x05;
    l_resolution     VARCHAR2(20)  := UPPER(TRIM(apex_application.g_x06));
    l_previous_id    VARCHAR2(32)  := UPPER(apex_application.g_x07);
    l_run_id         VARCHAR2(32);
    l_collection     VARCHAR2(255);
    l_org            NUMBER;
    l_saved_period   VARCHAR2(15);
    l_saved_source   VARCHAR2(30);
    l_saved_res      VARCHAR2(20);
    l_created        BOOLEAN       := FALSE;
    l_requested_type VARCHAR2(80);
  BEGIN
    -- P61_SERVER_CONTEXT_V1: scalar inputs describe a request, not preapproved state.
    IF l_action IS NULL OR l_action NOT IN ('RUN', 'DETAIL') THEN
      RAISE_APPLICATION_ERROR(-20166, 'Unsupported report request.');
    END IF;

    IF l_source IS NULL OR l_source NOT IN ('ADG') THEN
      RAISE_APPLICATION_ERROR(-20161, 'Select an approved database source.');
    END IF;

    IF l_period IS NULL
       OR NOT REGEXP_LIKE(l_period, '^(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)-[0-9]{4}$', 'c')
    THEN
      RAISE_APPLICATION_ERROR(-20162, 'Select an accounting period.');
    END IF;

    IF l_resolution IS NULL OR l_resolution NOT IN ('REQUIRED', 'RECOMMENDED', 'ALL') THEN
      RAISE_APPLICATION_ERROR(-20167, 'Select Required, Recommended or All.');
    END IF;

    IF l_action = 'RUN' THEN
      l_run_id := RAWTOHEX(SYS_GUID());
      l_collection := 'P61RUN_' || l_run_id;
      apex_collection.create_collection(p_collection_name => l_collection);
      l_created := TRUE;
      apex_collection.add_member(
        p_collection_name => l_collection,
        p_c001            => l_period,
        p_c002            => l_source,
        p_c003            => l_resolution,
        p_d001            => SYSDATE
      );
      -- Member 1 is immutable run context; member 2 is this run's selected detail.
      apex_collection.add_member(
        p_collection_name => l_collection,
        p_c050            => 'DETAIL_SELECTION'
      );
      l_org  := NULL;
      l_type := NULL;
    ELSE
      IF l_previous_id IS NULL OR NOT REGEXP_LIKE(l_previous_id, '^[0-9A-F]{32}$', 'c') THEN
        RAISE_APPLICATION_ERROR(-20163, 'Run Analysis before selecting a count.');
      END IF;

      l_run_id := l_previous_id;
      l_collection := 'P61RUN_' || l_run_id;

      BEGIN
        SELECT c001, c002, c003
          INTO l_saved_period, l_saved_source, l_saved_res
          FROM apex_collections
         WHERE collection_name = l_collection
           AND seq_id = 1;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20163, 'This run has expired. Run Analysis again.');
      END;

      IF l_period <> l_saved_period
         OR l_source <> l_saved_source
         OR l_resolution <> l_saved_res
      THEN
        RAISE_APPLICATION_ERROR(-20163, 'The selected count does not belong to this run. Run Analysis again.');
      END IF;

      IF l_org_text IS NULL OR NOT REGEXP_LIKE(l_org_text, '^[0-9]{1,18}$', 'c') THEN
        RAISE_APPLICATION_ERROR(-20164, 'Invalid inventory organization.');
      END IF;

      l_org := TO_NUMBER(l_org_text);
      l_requested_type := l_type;

      IF l_requested_type = 'Total' THEN
        l_type := CASE l_resolution
                    WHEN 'REQUIRED'    THEN '__TOTAL_REQUIRED__'
                    WHEN 'RECOMMENDED' THEN '__TOTAL_RECOMMENDED__'
                    ELSE '__TOTAL_ALL__'
                  END;
      ELSIF l_requested_type IN (
        'Unprocessed Material', 'Uncosted Material/WSM', 'Pending WIP Costing',
        'Pending WSM Interface', 'Pending LCM Interface', 'Unprocessed Shipping Transactions',
        'Pending Receiving', 'Pending Material', 'Pending Shop Floor Move', 'Incomplete Work Orders'
      ) THEN
        l_type := l_requested_type;
      ELSE
        RAISE_APPLICATION_ERROR(-20165, 'Invalid transaction category.');
      END IF;

      IF l_org <= 0 THEN
        RAISE_APPLICATION_ERROR(-20164, 'Invalid inventory organization.');
      END IF;

      IF (l_resolution = 'REQUIRED' AND l_type IN (
            'Pending Receiving', 'Pending Material', 'Pending Shop Floor Move', 'Incomplete Work Orders'))
         OR (l_resolution = 'RECOMMENDED' AND l_type IN (
            'Unprocessed Material', 'Uncosted Material/WSM', 'Pending WIP Costing',
            'Pending WSM Interface', 'Pending LCM Interface', 'Unprocessed Shipping Transactions'))
      THEN
        RAISE_APPLICATION_ERROR(-20168, 'Transaction type is outside the selected resolution.');
      END IF;

      apex_ir.reset_report(p_page_id => 61, p_region_static_id => 'pending-details');
      apex_collection.update_member(
        p_collection_name => l_collection,
        p_seq             => 2,
        p_c001            => l_type,
        p_n001            => l_org,
        p_c050            => 'DETAIL_SELECTION'
      );
    END IF;

    -- Retire only this tab's previous run after its replacement was accepted.
    IF l_action = 'RUN'
       AND REGEXP_LIKE(l_previous_id, '^[0-9A-F]{32}$', 'c')
       AND l_previous_id <> l_run_id
    THEN
      IF apex_collection.collection_exists(p_collection_name => 'P61RUN_' || l_previous_id) THEN
        apex_collection.delete_collection(p_collection_name => 'P61RUN_' || l_previous_id);
      END IF;
    END IF;

    apex_json.open_object;
    apex_json.write('ok',         TRUE);
    apex_json.write('version',    'P61_SERVER_CONTEXT_V1');
    apex_json.write('action',     l_action);
    apex_json.write('run_id',     l_run_id);
    apex_json.write('ready',      'Y');
    apex_json.write('period',     l_period);
    apex_json.write('source',     l_source);
    apex_json.write('resolution', l_resolution);
    apex_json.write('org',        TO_CHAR(l_org, 'FM99999999999999999990'));
    apex_json.write('type',       l_requested_type);
    apex_json.close_object;
  EXCEPTION
    WHEN OTHERS THEN
      IF l_created AND apex_collection.collection_exists(p_collection_name => l_collection) THEN
        apex_collection.delete_collection(p_collection_name => l_collection);
      END IF;
      apex_json.open_object;
      apex_json.write('ok', FALSE);
      apex_json.write(
        'message',
        CASE
          WHEN SQLCODE BETWEEN -20999 AND -20000 THEN SUBSTR(SQLERRM, 12)
          ELSE 'Unable to prepare the report. Check the APEX debug log.'
        END
      );
      apex_json.close_object;
  END set_context;

  FUNCTION summary_sql RETURN VARCHAR2 IS
    l_run_id     VARCHAR2(32) := UPPER(apex_util.get_session_state('P61_RUN_ID'));
    l_period     VARCHAR2(15);
    l_source     VARCHAR2(30);
    l_resolution VARCHAR2(20);
  BEGIN
    -- P61_SERVER_CONTEXT_V1: no accepted run ID means no inventory query.
    IF l_run_id IS NULL THEN
      RETURN q'~select cast(null as varchar2(30)) organization_code,
       cast(null as varchar2(240)) organization_name,
       cast(null as varchar2(4000)) unprocessed_material_count,
       cast(null as varchar2(4000)) uncosted_material_wsm_count,
       cast(null as varchar2(4000)) pending_wip_costing_count,
       cast(null as varchar2(4000)) pending_wsm_interface_count,
       cast(null as varchar2(4000)) pending_lcm_interface_count,
       cast(null as varchar2(4000)) unprocessed_shipping_count,
       cast(null as varchar2(4000)) pending_receiving_count,
       cast(null as varchar2(4000)) pending_material_count,
       cast(null as varchar2(4000)) pending_shop_floor_move_count,
       cast(null as varchar2(4000)) incomplete_work_orders_count,
       cast(null as varchar2(4000)) total_count from dual where 1=0~';
    END IF;

    validate_run_header(
      p_run_id     => l_run_id,
      p_period     => l_period,
      p_source     => l_source,
      p_resolution => l_resolution
    );

    -- Bind-parameterized query joining validated server-owned collection row (zero REPLACE literals).
    RETURN q'~select s.organization_code, s.organization_name,
       case when ctx.resolution = 'RECOMMENDED' then '<span title="Not included by Resolution filter">&mdash;</span>'
       when s.unprocessed_material_count > 0 then
         '<button type="button" class="p61-count" data-org-id="' ||
         to_char(s.organization_id,'FM99999999999999999990') ||
         '" data-org-name="' || apex_escape.html_attribute(s.organization_name) ||
         '" data-type="' || apex_escape.html_attribute('Unprocessed Material') ||
         '" aria-label="' || apex_escape.html_attribute('Unprocessed Material for ' || s.organization_name) || '">' ||
         to_char(s.unprocessed_material_count,'FM999G999G999G999G990') || '</button>'
       else '0' end unprocessed_material_count,
       case when ctx.resolution = 'RECOMMENDED' then '<span title="Not included by Resolution filter">&mdash;</span>'
       when s.uncosted_material_wsm_count > 0 then
         '<button type="button" class="p61-count" data-org-id="' ||
         to_char(s.organization_id,'FM99999999999999999990') ||
         '" data-org-name="' || apex_escape.html_attribute(s.organization_name) ||
         '" data-type="' || apex_escape.html_attribute('Uncosted Material/WSM') ||
         '" aria-label="' || apex_escape.html_attribute('Uncosted Material/WSM for ' || s.organization_name) || '">' ||
         to_char(s.uncosted_material_wsm_count,'FM999G999G999G999G990') || '</button>'
       else '0' end uncosted_material_wsm_count,
       case when ctx.resolution = 'RECOMMENDED' then '<span title="Not included by Resolution filter">&mdash;</span>'
       when s.pending_wip_costing_count > 0 then
         '<button type="button" class="p61-count" data-org-id="' ||
         to_char(s.organization_id,'FM99999999999999999990') ||
         '" data-org-name="' || apex_escape.html_attribute(s.organization_name) ||
         '" data-type="' || apex_escape.html_attribute('Pending WIP Costing') ||
         '" aria-label="' || apex_escape.html_attribute('Pending WIP Costing for ' || s.organization_name) || '">' ||
         to_char(s.pending_wip_costing_count,'FM999G999G999G999G990') || '</button>'
       else '0' end pending_wip_costing_count,
       case when ctx.resolution = 'RECOMMENDED' then '<span title="Not included by Resolution filter">&mdash;</span>'
       when s.pending_wsm_interface_count > 0 then
         '<button type="button" class="p61-count" data-org-id="' ||
         to_char(s.organization_id,'FM99999999999999999990') ||
         '" data-org-name="' || apex_escape.html_attribute(s.organization_name) ||
         '" data-type="' || apex_escape.html_attribute('Pending WSM Interface') ||
         '" aria-label="' || apex_escape.html_attribute('Pending WSM Interface for ' || s.organization_name) || '">' ||
         to_char(s.pending_wsm_interface_count,'FM999G999G999G999G990') || '</button>'
       else '0' end pending_wsm_interface_count,
       case when ctx.resolution = 'RECOMMENDED' then '<span title="Not included by Resolution filter">&mdash;</span>'
       when s.pending_lcm_interface_count > 0 then
         '<button type="button" class="p61-count" data-org-id="' ||
         to_char(s.organization_id,'FM99999999999999999990') ||
         '" data-org-name="' || apex_escape.html_attribute(s.organization_name) ||
         '" data-type="' || apex_escape.html_attribute('Pending LCM Interface') ||
         '" aria-label="' || apex_escape.html_attribute('Pending LCM Interface for ' || s.organization_name) || '">' ||
         to_char(s.pending_lcm_interface_count,'FM999G999G999G999G990') || '</button>'
       else '0' end pending_lcm_interface_count,
       case when ctx.resolution = 'RECOMMENDED' then '<span title="Not included by Resolution filter">&mdash;</span>'
       when s.unprocessed_shipping_count > 0 then
         '<button type="button" class="p61-count" data-org-id="' ||
         to_char(s.organization_id,'FM99999999999999999990') ||
         '" data-org-name="' || apex_escape.html_attribute(s.organization_name) ||
         '" data-type="' || apex_escape.html_attribute('Unprocessed Shipping Transactions') ||
         '" aria-label="' || apex_escape.html_attribute('Unprocessed Shipping Transactions for ' || s.organization_name) || '">' ||
         to_char(s.unprocessed_shipping_count,'FM999G999G999G999G990') || '</button>'
       else '0' end unprocessed_shipping_count,
       case when ctx.resolution = 'REQUIRED' then '<span title="Not included by Resolution filter">&mdash;</span>'
       when s.pending_receiving_count > 0 then
         '<button type="button" class="p61-count" data-org-id="' ||
         to_char(s.organization_id,'FM99999999999999999990') ||
         '" data-org-name="' || apex_escape.html_attribute(s.organization_name) ||
         '" data-type="' || apex_escape.html_attribute('Pending Receiving') ||
         '" aria-label="' || apex_escape.html_attribute('Pending Receiving for ' || s.organization_name) || '">' ||
         to_char(s.pending_receiving_count,'FM999G999G999G999G990') || '</button>'
       else '0' end pending_receiving_count,
       case when ctx.resolution = 'REQUIRED' then '<span title="Not included by Resolution filter">&mdash;</span>'
       when s.pending_material_count > 0 then
         '<button type="button" class="p61-count" data-org-id="' ||
         to_char(s.organization_id,'FM99999999999999999990') ||
         '" data-org-name="' || apex_escape.html_attribute(s.organization_name) ||
         '" data-type="' || apex_escape.html_attribute('Pending Material') ||
         '" aria-label="' || apex_escape.html_attribute('Pending Material for ' || s.organization_name) || '">' ||
         to_char(s.pending_material_count,'FM999G999G999G999G990') || '</button>'
       else '0' end pending_material_count,
       case when ctx.resolution = 'REQUIRED' then '<span title="Not included by Resolution filter">&mdash;</span>'
       when s.pending_shop_floor_move_count > 0 then
         '<button type="button" class="p61-count" data-org-id="' ||
         to_char(s.organization_id,'FM99999999999999999990') ||
         '" data-org-name="' || apex_escape.html_attribute(s.organization_name) ||
         '" data-type="' || apex_escape.html_attribute('Pending Shop Floor Move') ||
         '" aria-label="' || apex_escape.html_attribute('Pending Shop Floor Move for ' || s.organization_name) || '">' ||
         to_char(s.pending_shop_floor_move_count,'FM999G999G999G999G990') || '</button>'
       else '0' end pending_shop_floor_move_count,
       case when ctx.resolution = 'REQUIRED' then '<span title="Not included by Resolution filter">&mdash;</span>'
       when s.incomplete_work_orders_count > 0 then
         '<button type="button" class="p61-count" data-org-id="' ||
         to_char(s.organization_id,'FM99999999999999999990') ||
         '" data-org-name="' || apex_escape.html_attribute(s.organization_name) ||
         '" data-type="' || apex_escape.html_attribute('Incomplete Work Orders') ||
         '" aria-label="' || apex_escape.html_attribute('Incomplete Work Orders for ' || s.organization_name) || '">' ||
         to_char(s.incomplete_work_orders_count,'FM999G999G999G999G990') || '</button>'
       else '0' end incomplete_work_orders_count,
       case when s.total_count > 0 then
         '<button type="button" class="p61-count" data-org-id="' ||
         to_char(s.organization_id,'FM99999999999999999990') ||
         '" data-org-name="' || apex_escape.html_attribute(s.organization_name) ||
         '" data-type="Total" aria-label="' ||
         apex_escape.html_attribute('Total for ' || s.organization_name) || '">' ||
         to_char(s.total_count,'FM999G999G999G999G990') || '</button>'
       else '0' end total_count
  from (select /*+ NO_MERGE */ c001 as period_name, c002 as db_link, c003 as resolution
          from apex_collections
         where collection_name = 'P61RUN_' || upper(:P61_RUN_ID)
           and seq_id = 1) ctx,
       table(xxme_inv_pending_period_pkg.get_summary(ctx.period_name, ctx.db_link, ctx.resolution)) s
 where s.total_count > 0
 order by s.organization_name, s.organization_code~';
  END summary_sql;

  FUNCTION details_sql RETURN VARCHAR2 IS
    l_run_id     VARCHAR2(32) := UPPER(apex_util.get_session_state('P61_RUN_ID'));
    l_period     VARCHAR2(15);
    l_source     VARCHAR2(30);
    l_resolution VARCHAR2(20);
    l_org        NUMBER;
    l_type       VARCHAR2(80);
  BEGIN
    -- P61_SERVER_CONTEXT_V1: no accepted run ID means no inventory query.
    IF l_run_id IS NULL THEN
      RETURN q'~select cast(null as number) organization_id,
       cast(null as varchar2(15)) period_name,
       cast(null as date) period_start_date,
       cast(null as date) schedule_close_date,
       cast(null as varchar2(240)) organization_name,
       cast(null as varchar2(80)) transaction_type,
       cast(null as date) transaction_date,
       cast(null as varchar2(20)) resolution,
       cast(null as varchar2(40)) transaction_ref,
       cast(null as varchar2(240)) transaction_ref_id,
       cast(null as varchar2(240)) transaction_type_name,
       cast(null as varchar2(240)) item from dual where 1=0~';
    END IF;

    validate_run_header(
      p_run_id     => l_run_id,
      p_period     => l_period,
      p_source     => l_source,
      p_resolution => l_resolution
    );

    SELECT n001, c001
      INTO l_org, l_type
      FROM apex_collections
     WHERE collection_name = 'P61RUN_' || l_run_id
       AND seq_id = 2;

    IF l_org IS NULL AND l_type IS NULL THEN
      RETURN q'~select cast(null as number) organization_id,
       cast(null as varchar2(15)) period_name,
       cast(null as date) period_start_date,
       cast(null as date) schedule_close_date,
       cast(null as varchar2(240)) organization_name,
       cast(null as varchar2(80)) transaction_type,
       cast(null as date) transaction_date,
       cast(null as varchar2(20)) resolution,
       cast(null as varchar2(40)) transaction_ref,
       cast(null as varchar2(240)) transaction_ref_id,
       cast(null as varchar2(240)) transaction_type_name,
       cast(null as varchar2(240)) item from dual where 1=0~';
    END IF;

    IF l_org IS NULL
       OR l_org <= 0
       OR l_org <> TRUNC(l_org)
       OR l_type IS NULL
       OR l_type NOT IN (
         'Unprocessed Material', 'Uncosted Material/WSM', 'Pending WIP Costing',
         'Pending WSM Interface', 'Pending LCM Interface', 'Unprocessed Shipping Transactions',
         'Pending Receiving', 'Pending Material', 'Pending Shop Floor Move', 'Incomplete Work Orders',
         '__TOTAL_REQUIRED__', '__TOTAL_RECOMMENDED__', '__TOTAL_ALL__'
       )
    THEN
      RAISE_APPLICATION_ERROR(-20164, 'Select a valid exception count again.');
    END IF;

    IF (l_resolution = 'REQUIRED' AND (
          l_type IN ('Pending Receiving', 'Pending Material', 'Pending Shop Floor Move', 'Incomplete Work Orders')
          OR l_type IN ('__TOTAL_RECOMMENDED__', '__TOTAL_ALL__')))
       OR (l_resolution = 'RECOMMENDED' AND (
          l_type IN ('Unprocessed Material', 'Uncosted Material/WSM', 'Pending WIP Costing',
                     'Pending WSM Interface', 'Pending LCM Interface', 'Unprocessed Shipping Transactions')
          OR l_type IN ('__TOTAL_REQUIRED__', '__TOTAL_ALL__')))
       OR (l_resolution = 'ALL' AND l_type IN ('__TOTAL_REQUIRED__', '__TOTAL_RECOMMENDED__'))
    THEN
      RAISE_APPLICATION_ERROR(-20168, 'Selected category does not belong to the accepted Resolution.');
    END IF;

    -- Bind-parameterized query joining validated server-owned collection rows (zero REPLACE literals).
    RETURN q'~select d.organization_id, d.period_name, d.period_start_date, d.schedule_close_date,
       d.organization_name, d.transaction_type, d.transaction_date, d.resolution,
       d.transaction_ref, d.transaction_ref_id, d.transaction_type_name, d.item
  from (select /*+ NO_MERGE */ c001 as period_name, c002 as db_link
          from apex_collections
         where collection_name = 'P61RUN_' || upper(:P61_RUN_ID)
           and seq_id = 1) ctx1,
       (select /*+ NO_MERGE */ n001 as org_id, c001 as txn_type
          from apex_collections
         where collection_name = 'P61RUN_' || upper(:P61_RUN_ID)
           and seq_id = 2) ctx2,
       table(xxme_inv_pending_dtl_v3_pkg.get_details(
         ctx1.period_name, ctx2.org_id, ctx2.txn_type, ctx1.db_link)) d~';
  END details_sql;

  PROCEDURE export_accepted_summary_xlsx IS
    l_run_id     VARCHAR2(32) := UPPER(apex_util.get_session_state('P61_RUN_ID'));
    l_period     VARCHAR2(15);
    l_source     VARCHAR2(30);
    l_resolution VARCHAR2(20);
    l_sql        VARCHAR2(32767);
    l_params     apex_exec.t_parameters;
    l_context    apex_exec.t_context;
    l_export     apex_data_export.t_export;
    l_open       BOOLEAN := FALSE;
    l_filename   VARCHAR2(255);
  BEGIN
    IF l_run_id IS NULL OR NOT REGEXP_LIKE(l_run_id, '^[0-9A-F]{32}$', 'c') THEN
      RAISE_APPLICATION_ERROR(-20163, 'Run Analysis before exporting the summary.');
    END IF;

    validate_run_header(
      p_run_id     => l_run_id,
      p_period     => l_period,
      p_source     => l_source,
      p_resolution => l_resolution
    );

    l_sql := q'~select s.organization_code "Org Code", s.organization_name "Inventory Organization",
       case when :R in ('REQUIRED','ALL') then s.unprocessed_material_count end "Unprocessed Material",
       case when :R in ('REQUIRED','ALL') then s.uncosted_material_wsm_count end "Uncosted Material/WSM",
       case when :R in ('REQUIRED','ALL') then s.pending_wip_costing_count end "Pending WIP Costing",
       case when :R in ('REQUIRED','ALL') then s.pending_wsm_interface_count end "Pending WSM Interface",
       case when :R in ('REQUIRED','ALL') then s.pending_lcm_interface_count end "Pending LCM Interface",
       case when :R in ('REQUIRED','ALL') then s.unprocessed_shipping_count end "Unprocessed Shipping Transactions",
       case when :R in ('RECOMMENDED','ALL') then s.pending_receiving_count end "Pending Receiving",
       case when :R in ('RECOMMENDED','ALL') then s.pending_material_count end "Pending Material",
       case when :R in ('RECOMMENDED','ALL') then s.pending_shop_floor_move_count end "Pending Shop Floor Move",
       case when :R in ('RECOMMENDED','ALL') then s.incomplete_work_orders_count end "Incomplete Work Orders",
       s.total_count "Total"
  from table(xxme_inv_pending_period_pkg.get_summary(:P,:L,:R)) s
 where s.total_count>0 order by s.organization_name,s.organization_code~';

    apex_exec.add_parameter(l_params, 'P', l_period);
    apex_exec.add_parameter(l_params, 'L', l_source);
    apex_exec.add_parameter(l_params, 'R', l_resolution);

    l_context := apex_exec.open_query_context(
      p_location         => apex_exec.c_location_local_db,
      p_sql_query        => l_sql,
      p_sql_parameters   => l_params,
      p_auto_bind_items  => FALSE
    );
    l_open := TRUE;

    l_filename := 'Inventory_Pending_' || l_period || '_' || l_source || '_' || l_resolution;
    l_export := apex_data_export.export(
      p_context   => l_context,
      p_format    => apex_data_export.c_format_xlsx,
      p_file_name => l_filename
    );
    apex_exec.close(l_context);
    l_open := FALSE;
    apex_data_export.download(p_export => l_export);
  EXCEPTION
    WHEN apex_application.e_stop_apex_engine THEN
      RAISE;
    WHEN OTHERS THEN
      IF l_open THEN
        apex_exec.close(l_context);
      END IF;
      RAISE;
  END export_accepted_summary_xlsx;

END xxme_inv_pending_ui_pkg;
/

prompt === 3/4: XXME_PROCESS_MONITOR_PKG (Page 70) ===

CREATE OR REPLACE PACKAGE xxme_process_monitor_pkg AUTHID DEFINER AS
  PROCEDURE normalize_filters;

  FUNCTION get_ca_executions (
    p_ledgers IN VARCHAR2,
    p_apps    IN VARCHAR2 DEFAULT NULL,
    p_view    IN VARCHAR2 DEFAULT 'ALL',
    p_db_link IN VARCHAR2 DEFAULT 'ADG'
  ) RETURN xxme_p70_ca_row_nt PIPELINED;

  FUNCTION get_revaluations (
    p_ledgers     IN VARCHAR2,
    p_period_name IN VARCHAR2 DEFAULT NULL,
    p_db_link     IN VARCHAR2 DEFAULT 'ADG'
  ) RETURN xxme_p70_rv_row_nt PIPELINED;

  FUNCTION get_reversals (
    p_ledgers     IN VARCHAR2,
    p_period_name IN VARCHAR2 DEFAULT NULL,
    p_db_link     IN VARCHAR2 DEFAULT 'ADG'
  ) RETURN xxme_p70_rs_row_nt PIPELINED;

  PROCEDURE emit_summary_json (
    p_tab     IN VARCHAR2 DEFAULT NULL,
    p_db_link IN VARCHAR2 DEFAULT 'ADG'
  );
END xxme_process_monitor_pkg;
/

CREATE OR REPLACE PACKAGE BODY xxme_process_monitor_pkg AS

  c_fetch_limit CONSTANT PLS_INTEGER := 500;

  PROCEDURE parse_scope_ledgers (
    p_ledgers        IN  VARCHAR2,
    p_empty_all      IN  BOOLEAN,
    p_l1             OUT NUMBER,
    p_l2             OUT NUMBER,
    p_l3             OUT NUMBER
  ) IS
    l_clean VARCHAR2(4000);
    l_idx   PLS_INTEGER := 1;
    l_tok   VARCHAR2(100);
  BEGIN
    p_l1 := NULL;
    p_l2 := NULL;
    p_l3 := NULL;

    l_clean := TRIM(REPLACE(p_ledgers, ''''));
    IF l_clean IS NULL THEN
      IF p_empty_all THEN
        p_l1 := 1003;
        p_l2 := 5001;
        p_l3 := 10001;
      END IF;
      RETURN;
    END IF;

    LOOP
      l_tok := REGEXP_SUBSTR(l_clean, '[0-9]+', 1, l_idx);
      EXIT WHEN l_tok IS NULL;
      IF l_tok = '1003' THEN
        p_l1 := 1003;
      ELSIF l_tok = '5001' THEN
        p_l2 := 5001;
      ELSIF l_tok = '10001' THEN
        p_l3 := 10001;
      END IF;
      l_idx := l_idx + 1;
    END LOOP;
  END parse_scope_ledgers;

  PROCEDURE normalize_filters IS
    l_apps    VARCHAR2(4000);
    l_old     VARCHAR2(4000);
    l_ledgers VARCHAR2(4000);
    l_item    VARCHAR2(30);
  BEGIN
    SELECT LISTAGG(column_value, ':') WITHIN GROUP (ORDER BY column_value)
      INTO l_apps
      FROM (SELECT DISTINCT column_value
              FROM TABLE(apex_string.split(apex_util.get_session_state('P70_CA_APPS'), ':'))
             WHERE column_value IN ('AP', 'AR', 'COST'));

    apex_util.set_session_state(p_name => 'P70_CA_APPS', p_value => l_apps, p_commit => FALSE);

    FOR k IN (SELECT column_value AS key FROM TABLE(apex_t_varchar2('CA', 'RV', 'RS'))) LOOP
      l_item := 'P70_' || k.key || '_LEDGERS';
      l_old  := apex_util.get_session_state(l_item);

      SELECT LISTAGG(column_value, ':') WITHIN GROUP (ORDER BY column_value)
        INTO l_ledgers
        FROM (SELECT DISTINCT column_value
                FROM TABLE(apex_string.split(l_old, ':'))
               WHERE column_value IN ('1003', '5001', '10001'));

      IF l_old IS NOT NULL AND l_ledgers IS NULL THEN
        l_ledgers := '1003:5001:10001';
      END IF;

      apex_util.set_session_state(p_name => l_item, p_value => l_ledgers, p_commit => FALSE);
    END LOOP;

    apex_util.set_session_state(p_name => 'P70_RV_PERIOD', p_value => NULL, p_commit => FALSE);
    apex_util.set_session_state(p_name => 'P70_RS_PERIOD', p_value => NULL, p_commit => FALSE);
  END normalize_filters;

  FUNCTION get_ca_executions (
    p_ledgers IN VARCHAR2,
    p_apps    IN VARCHAR2 DEFAULT NULL,
    p_view    IN VARCHAR2 DEFAULT 'ALL',
    p_db_link IN VARCHAR2 DEFAULT 'ADG'
  ) RETURN xxme_p70_ca_row_nt PIPELINED IS
    l_db_link VARCHAR2(30) := xxme_db_source_pkg.normalize_db_link(p_db_link);
    l_now     DATE         := SYSDATE;
    l_l1      NUMBER;
    l_l2      NUMBER;
    l_l3      NUMBER;
    l_apps    VARCHAR2(4000) := UPPER(TRIM(p_apps));
    l_view    VARCHAR2(30)   := UPPER(TRIM(p_view));
    l_sql     VARCHAR2(16000);
    l_rc      SYS_REFCURSOR;
    l_open    BOOLEAN := FALSE;

    TYPE t_num_tab  IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    TYPE t_date_tab IS TABLE OF DATE INDEX BY PLS_INTEGER;
    TYPE t_v1_tab   IS TABLE OF VARCHAR2(1) INDEX BY PLS_INTEGER;
    TYPE t_v10_tab  IS TABLE OF VARCHAR2(10) INDEX BY PLS_INTEGER;
    TYPE t_v30_tab  IS TABLE OF VARCHAR2(30) INDEX BY PLS_INTEGER;
    TYPE t_v100_tab IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
    TYPE t_v240_tab IS TABLE OF VARCHAR2(240) INDEX BY PLS_INTEGER;
    TYPE t_v400_tab IS TABLE OF VARCHAR2(400) INDEX BY PLS_INTEGER;

    l_module           t_v400_tab;
    l_ledger_id        t_num_tab;
    l_ledger_name      t_v100_tab;
    l_request_id       t_num_tab;
    l_status           t_v30_tab;
    l_is_latest        t_v1_tab;
    l_requested_by     t_v100_tab;
    l_start_date       t_date_tab;
    l_comp_date        t_date_tab;
    l_run_minutes      t_num_tab;
    l_hours_since      t_num_tab;
    l_acct_end_date    t_v10_tab;
    l_proc_category    t_v240_tab;
    l_acct_mode        t_v240_tab;
    l_errors_only      t_v240_tab;
    l_report_style     t_v240_tab;
    l_transfer_to_gl   t_v240_tab;
    l_post_in_gl       t_v240_tab;
    l_gl_batch_name    t_v240_tab;
  BEGIN
    parse_scope_ledgers(
      p_ledgers   => p_ledgers,
      p_empty_all => TRUE,
      p_l1        => l_l1,
      p_l2        => l_l2,
      p_l3        => l_l3
    );

    IF l_l1 IS NULL AND l_l2 IS NULL AND l_l3 IS NULL THEN
      RETURN;
    END IF;

    l_sql := REPLACE(q'~SELECT q.module,
       q.ledger_id,
       q.ledger_name,
       q.request_id,
       q.status,
       q.is_latest,
       q.requested_by,
       q.actual_start_date,
       q.actual_completion_date,
       q.run_minutes,
       q.hours_since_run,
       q.accounting_end_date,
       q.process_category,
       q.accounting_mode,
       q.errors_only,
       q.report_style,
       q.transfer_to_gl,
       q.post_in_gl,
       q.gl_batch_name
FROM (
  SELECT /*+ DRIVING_SITE(fcr) */
         DECODE(fcp.concurrent_program_name,
                'CSTCRACC',    'Inventory (Cost Management)',
                'CSTCRACCRCV', 'Receiving (Cost Management)',
                DECODE(fcr.argument2, '200', 'AP - Payables',
                                      '222', 'AR - Receivables',
                                      NVL(fat.application_name, NVL(fcr.argument2, fcr.argument1))
                                        || DECODE(fcr.argument2, NULL, ' (online / single document)'))) AS module,
         gl.ledger_id,
         gl.name AS ledger_name,
         fcr.request_id,
         DECODE(fcr.status_code, 'C', 'Normal', 'G', 'Warning', 'E', 'Error', fcr.status_code) AS status,
         CASE
           WHEN ROW_NUMBER() OVER (
                  PARTITION BY fcp.concurrent_program_name, fcr.argument1, fcr.argument2, fcr.argument4
                  ORDER BY DECODE(fcr.status_code, 'E', 1, 0),
                           fcr.actual_completion_date DESC,
                           fcr.request_id DESC) = 1
                AND fcr.status_code <> 'E'
           THEN 'Y'
           ELSE 'N'
         END AS is_latest,
         fu.user_name AS requested_by,
         fcr.actual_start_date,
         fcr.actual_completion_date,
         ROUND((fcr.actual_completion_date - fcr.actual_start_date) * 1440, 1) AS run_minutes,
         ROUND((:p_now - fcr.actual_completion_date) * 24, 1) AS hours_since_run,
         SUBSTR(fcr.argument6, 1, 10) AS accounting_end_date,
         fcr.argument5 AS process_category,
         DECODE(fcr.argument9,  'F', 'Final', 'D', 'Draft', fcr.argument9) AS accounting_mode,
         DECODE(fcr.argument11, 'Y', 'Yes', 'N', 'No', fcr.argument11) AS errors_only,
         DECODE(fcr.argument12, 'D', 'Detail', 'S', 'Summary', 'N', 'No Report', fcr.argument12) AS report_style,
         DECODE(fcr.argument13, 'Y', 'Yes', 'N', 'No', fcr.argument13) AS transfer_to_gl,
         DECODE(fcr.argument15, 'Y', 'Yes', 'N', 'No', fcr.argument15) AS post_in_gl,
         fcr.argument16 AS gl_batch_name
    FROM apps.fnd_concurrent_requests@ADG fcr,
         apps.fnd_concurrent_programs@ADG fcp,
         apps.gl_ledgers@ADG              gl,
         apps.fnd_user@ADG                fu,
         apps.fnd_application_tl@ADG      fat
   WHERE ((fcp.application_id = 602 AND fcp.concurrent_program_name = 'XLAACCPB')
          OR (fcp.application_id = 702 AND fcp.concurrent_program_name IN ('CSTCRACC', 'CSTCRACCRCV')))
     AND fcr.program_application_id = fcp.application_id
     AND fcr.concurrent_program_id  = fcp.concurrent_program_id
     AND fcr.phase_code             = 'C'
     AND fcr.status_code            IN ('C', 'G', 'E')
     AND gl.ledger_id               IN (:b_l1, :b_l2, :b_l3)
     AND TO_CHAR(gl.ledger_id)      = TRIM(fcr.argument4)
     AND fu.user_id             (+) = fcr.requested_by
     AND TO_CHAR(fat.application_id (+)) = NVL(fcr.argument2, fcr.argument1)
     AND fat.language           (+) = 'US'
) q
WHERE (:p_view = 'ALL' OR q.is_latest = 'Y')
  AND (:p_apps IS NULL
       OR (INSTR(':' || :p_apps || ':', ':AP:')   > 0 AND q.module = 'AP - Payables')
       OR (INSTR(':' || :p_apps || ':', ':AR:')   > 0 AND q.module = 'AR - Receivables')
       OR (INSTR(':' || :p_apps || ':', ':COST:') > 0 AND q.module IN ('Inventory (Cost Management)', 'Receiving (Cost Management)')))
ORDER BY q.request_id DESC~', '@ADG', '@' || l_db_link);

    OPEN l_rc FOR l_sql USING l_now, l_l1, l_l2, l_l3, l_view, l_apps, l_apps, l_apps, l_apps;
    l_open := TRUE;

    LOOP
      FETCH l_rc BULK COLLECT INTO
        l_module, l_ledger_id, l_ledger_name, l_request_id, l_status, l_is_latest,
        l_requested_by, l_start_date, l_comp_date, l_run_minutes, l_hours_since,
        l_acct_end_date, l_proc_category, l_acct_mode, l_errors_only, l_report_style,
        l_transfer_to_gl, l_post_in_gl, l_gl_batch_name
      LIMIT c_fetch_limit;

      EXIT WHEN l_request_id.COUNT = 0;

      FOR i IN 1 .. l_request_id.COUNT LOOP
        PIPE ROW(xxme_p70_ca_row_ot(
          l_module(i), l_ledger_id(i), l_ledger_name(i), l_request_id(i), l_status(i),
          l_is_latest(i), l_requested_by(i), l_start_date(i), l_comp_date(i),
          l_run_minutes(i), l_hours_since(i), l_acct_end_date(i), l_proc_category(i),
          l_acct_mode(i), l_errors_only(i), l_report_style(i), l_transfer_to_gl(i),
          l_post_in_gl(i), l_gl_batch_name(i)
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
  END get_ca_executions;

  FUNCTION get_revaluations (
    p_ledgers     IN VARCHAR2,
    p_period_name IN VARCHAR2 DEFAULT NULL,
    p_db_link     IN VARCHAR2 DEFAULT 'ADG'
  ) RETURN xxme_p70_rv_row_nt PIPELINED IS
    l_db_link VARCHAR2(30) := xxme_db_source_pkg.normalize_db_link(p_db_link);
    l_period  VARCHAR2(30) := UPPER(TRIM(REPLACE(p_period_name, '''')));
    l_l1      NUMBER;
    l_l2      NUMBER;
    l_l3      NUMBER;
    l_sql     VARCHAR2(16000);
    l_rc      SYS_REFCURSOR;
    l_open    BOOLEAN := FALSE;

    TYPE t_num_tab  IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    TYPE t_date_tab IS TABLE OF DATE INDEX BY PLS_INTEGER;
    TYPE t_v30_tab  IS TABLE OF VARCHAR2(30) INDEX BY PLS_INTEGER;
    TYPE t_v100_tab IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
    TYPE t_v240_tab IS TABLE OF VARCHAR2(240) INDEX BY PLS_INTEGER;

    l_ledger_name     t_v100_tab;
    l_ledger_id       t_num_tab;
    l_ledger_currency t_v30_tab;
    l_run_rank        t_v100_tab;
    l_run_start       t_date_tab;
    l_run_end         t_date_tab;
    l_run_by          t_v100_tab;
    l_period_name     t_v30_tab;
    l_je_batch_id     t_num_tab;
    l_batch_name      t_v240_tab;
    l_batch_status    t_v30_tab;
    l_je_header_id    t_num_tab;
    l_journal_name    t_v240_tab;
    l_reval_currency  t_v30_tab;
    l_accounted_dr    t_num_tab;
    l_accounted_cr    t_num_tab;
    l_rev_period      t_v30_tab;
    l_rev_status      t_v30_tab;
  BEGIN
    parse_scope_ledgers(
      p_ledgers   => p_ledgers,
      p_empty_all => FALSE,
      p_l1        => l_l1,
      p_l2        => l_l2,
      p_l3        => l_l3
    );

    IF l_l1 IS NULL AND l_l2 IS NULL AND l_l3 IS NULL THEN
      RETURN;
    END IF;

    -- Keep ORDER BY l.name, r.run_rank, r.batch_created, r.je_batch_id, r.currency_code inside cursor (Trap H).
    l_sql := REPLACE(q'~SELECT /*+ DRIVING_SITE(l) LEADING(r l fu) USE_NL(l fu)
           INDEX(l (ledger_id)) INDEX(fu FND_USER_U1) */
       l.name AS ledger_name,
       r.ledger_id,
       l.currency_code AS ledger_currency,
       CASE r.run_rank
         WHEN 1 THEN 'Latest execution'
         WHEN 2 THEN 'Previous execution'
         WHEN 3 THEN 'Third-most-recent execution'
       END || ' | ' || TO_CHAR(r.run_start, 'DD-MON-YYYY HH24:MI:SS') AS run_rank,
       r.run_start AS run_start,
       r.run_end AS run_end,
       fu.user_name AS run_by,
       r.period_name,
       r.je_batch_id,
       r.batch_name,
       DECODE(r.batch_status, 'P', 'Posted', 'U', 'Unposted', r.batch_status) AS batch_status,
       r.je_header_id,
       r.journal_name,
       r.currency_code AS revalued_currency,
       r.accounted_dr,
       r.accounted_cr,
       r.accrual_rev_period_name AS reversal_period,
       DECODE(r.accrual_rev_status, 'R', 'Reversed', NULL, 'Not reversed', r.accrual_rev_status) AS reversal_status
FROM  (SELECT x.*,
              MAX(x.run_seq) OVER (PARTITION BY x.ledger_id) - x.run_seq + 1 AS run_rank,
              MIN(x.batch_created) OVER (PARTITION BY x.ledger_id, x.run_seq) AS run_start,
              MAX(x.batch_created) OVER (PARTITION BY x.ledger_id, x.run_seq) AS run_end
       FROM  (SELECT y.*,
                     SUM(y.new_run) OVER (PARTITION BY y.ledger_id
                                          ORDER BY y.batch_created, y.je_batch_id, y.je_header_id
                                          ROWS UNBOUNDED PRECEDING) AS run_seq
              FROM  (SELECT /*+ LEADING(h b) USE_HASH(b) */
                            h.ledger_id,
                            h.period_name,
                            h.je_header_id,
                            h.name AS journal_name,
                            h.currency_code,
                            h.running_total_accounted_dr AS accounted_dr,
                            h.running_total_accounted_cr AS accounted_cr,
                            h.accrual_rev_period_name,
                            h.accrual_rev_status,
                            b.je_batch_id,
                            b.name AS batch_name,
                            b.status AS batch_status,
                            b.created_by,
                            b.creation_date AS batch_created,
                            CASE
                              WHEN LAG(b.creation_date) OVER (PARTITION BY h.ledger_id
                                                              ORDER BY b.creation_date, b.je_batch_id, h.je_header_id) IS NULL
                                OR b.creation_date - LAG(b.creation_date) OVER (PARTITION BY h.ledger_id
                                                              ORDER BY b.creation_date, b.je_batch_id, h.je_header_id) > 10/1440
                                OR b.created_by <> LAG(b.created_by) OVER (PARTITION BY h.ledger_id
                                                              ORDER BY b.creation_date, b.je_batch_id, h.je_header_id)
                              THEN 1 ELSE 0
                            END AS new_run
                     FROM   apps.gl_je_headers@ADG h,
                            apps.gl_je_batches@ADG b
                     WHERE  h.ledger_id IN (:b_l1, :b_l2, :b_l3)
                     AND    h.je_source = 'Revaluation'
                     AND    h.actual_flag = 'A'
                     AND    h.reversed_je_header_id IS NULL
                     AND    (:b_period IS NULL OR h.period_name = :b_period)
                     AND    b.je_batch_id = h.je_batch_id
                    ) y
             ) x
      ) r,
       apps.gl_ledgers@ADG l,
       apps.fnd_user@ADG   fu
WHERE r.ledger_id IN (1003, 5001, 10001)
AND   r.run_rank <= 3
AND   l.ledger_id = r.ledger_id
AND   fu.user_id (+) = r.created_by
ORDER BY l.name, r.run_rank, r.batch_created, r.je_batch_id, r.currency_code~', '@ADG', '@' || l_db_link);

    OPEN l_rc FOR l_sql USING l_l1, l_l2, l_l3, l_period, l_period;
    l_open := TRUE;

    LOOP
      FETCH l_rc BULK COLLECT INTO
        l_ledger_name, l_ledger_id, l_ledger_currency, l_run_rank,
        l_run_start, l_run_end, l_run_by, l_period_name, l_je_batch_id,
        l_batch_name, l_batch_status, l_je_header_id, l_journal_name,
        l_reval_currency, l_accounted_dr, l_accounted_cr, l_rev_period, l_rev_status
      LIMIT c_fetch_limit;

      EXIT WHEN l_je_header_id.COUNT = 0;

      FOR i IN 1 .. l_je_header_id.COUNT LOOP
        PIPE ROW(xxme_p70_rv_row_ot(
          l_ledger_name(i), l_ledger_id(i), l_ledger_currency(i), l_run_rank(i),
          l_run_start(i), l_run_end(i), l_run_by(i), l_period_name(i), l_je_batch_id(i),
          l_batch_name(i), l_batch_status(i), l_je_header_id(i), l_journal_name(i),
          l_reval_currency(i), l_accounted_dr(i), l_accounted_cr(i), l_rev_period(i),
          l_rev_status(i)
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
  END get_revaluations;

  FUNCTION get_reversals (
    p_ledgers     IN VARCHAR2,
    p_period_name IN VARCHAR2 DEFAULT NULL,
    p_db_link     IN VARCHAR2 DEFAULT 'ADG'
  ) RETURN xxme_p70_rs_row_nt PIPELINED IS
    l_db_link VARCHAR2(30) := xxme_db_source_pkg.normalize_db_link(p_db_link);
    l_period  VARCHAR2(30) := UPPER(TRIM(REPLACE(p_period_name, '''')));
    l_l1      NUMBER;
    l_l2      NUMBER;
    l_l3      NUMBER;
    l_sql     VARCHAR2(16000);
    l_rc      SYS_REFCURSOR;
    l_open    BOOLEAN := FALSE;

    TYPE t_num_tab  IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    TYPE t_date_tab IS TABLE OF DATE INDEX BY PLS_INTEGER;
    TYPE t_v30_tab  IS TABLE OF VARCHAR2(30) INDEX BY PLS_INTEGER;
    TYPE t_v100_tab IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
    TYPE t_v240_tab IS TABLE OF VARCHAR2(240) INDEX BY PLS_INTEGER;

    l_ledger_name     t_v100_tab;
    l_ledger_id       t_num_tab;
    l_ledger_currency t_v30_tab;
    l_run_rank        t_v100_tab;
    l_run_start       t_date_tab;
    l_run_end         t_date_tab;
    l_run_batches     t_num_tab;
    l_run_by          t_v100_tab;
    l_rev_period      t_v30_tab;
    l_je_batch_id     t_num_tab;
    l_batch_name      t_v240_tab;
    l_batch_status    t_v30_tab;
    l_je_header_id    t_num_tab;
    l_journal_name    t_v240_tab;
    l_je_source       t_v100_tab;
    l_je_category     t_v100_tab;
    l_currency_code   t_v30_tab;
    l_accounted_dr    t_num_tab;
    l_accounted_cr    t_num_tab;
    l_orig_hdr_id     t_num_tab;
    l_orig_jrn_name   t_v240_tab;
    l_orig_period     t_v30_tab;
    l_orig_batch_name t_v240_tab;
  BEGIN
    parse_scope_ledgers(
      p_ledgers   => p_ledgers,
      p_empty_all => FALSE,
      p_l1        => l_l1,
      p_l2        => l_l2,
      p_l3        => l_l3
    );

    IF l_l1 IS NULL AND l_l2 IS NULL AND l_l3 IS NULL THEN
      RETURN;
    END IF;

    -- Keep ORDER BY l.name, r.run_rank, r.batch_created, r.je_batch_id, r.currency_code inside cursor (Trap H).
    l_sql := REPLACE(q'~SELECT /*+ DRIVING_SITE(l) LEADING(r l fu o ob) USE_NL(l fu o ob)
           INDEX(l (ledger_id)) INDEX(fu FND_USER_U1) INDEX(o GL_JE_HEADERS_U1) INDEX(ob GL_JE_BATCHES_U1) */
       l.name AS ledger_name,
       r.ledger_id,
       l.currency_code AS ledger_currency,
       CASE r.run_rank
         WHEN 1 THEN 'Latest execution'
         WHEN 2 THEN 'Previous execution'
         WHEN 3 THEN 'Third-most-recent execution'
       END || ' | ' || TO_CHAR(r.run_start, 'DD-MON-YYYY HH24:MI:SS') AS run_rank,
       r.run_start AS run_start,
       r.run_end AS run_end,
       r.run_batches,
       fu.user_name AS run_by,
       r.period_name AS reversal_period,
       r.je_batch_id,
       r.batch_name,
       DECODE(r.batch_status, 'P', 'Posted', 'U', 'Unposted', r.batch_status) AS batch_status,
       r.je_header_id,
       r.journal_name,
       js.user_je_source_name AS je_source,
       jc.user_je_category_name AS je_category,
       r.currency_code,
       r.accounted_dr,
       r.accounted_cr,
       o.je_header_id AS orig_je_header_id,
       o.name AS orig_journal_name,
       o.period_name AS orig_period,
       ob.name AS orig_batch_name
FROM  (SELECT x.*,
              MAX(x.run_seq) OVER (PARTITION BY x.ledger_id) - x.run_seq + 1 AS run_rank,
              MIN(x.batch_created) OVER (PARTITION BY x.ledger_id, x.run_seq) AS run_start,
              MAX(x.batch_created) OVER (PARTITION BY x.ledger_id, x.run_seq) AS run_end,
              COUNT(DISTINCT x.je_batch_id) OVER (PARTITION BY x.ledger_id, x.run_seq) AS run_batches
       FROM  (SELECT y.*,
                     SUM(y.new_run) OVER (PARTITION BY y.ledger_id
                                          ORDER BY y.batch_created, y.je_batch_id, y.je_header_id
                                          ROWS UNBOUNDED PRECEDING) AS run_seq
              FROM  (SELECT /*+ LEADING(h b) USE_HASH(b) */
                            h.ledger_id,
                            h.period_name,
                            h.je_header_id,
                            h.name AS journal_name,
                            h.je_source,
                            h.je_category,
                            h.currency_code,
                            h.running_total_accounted_dr AS accounted_dr,
                            h.running_total_accounted_cr AS accounted_cr,
                            h.reversed_je_header_id,
                            b.je_batch_id,
                            b.name AS batch_name,
                            b.status AS batch_status,
                            b.created_by,
                            b.creation_date AS batch_created,
                            CASE
                              WHEN LAG(b.creation_date) OVER (PARTITION BY h.ledger_id
                                                              ORDER BY b.creation_date, b.je_batch_id, h.je_header_id) IS NULL
                                OR b.creation_date - LAG(b.creation_date) OVER (PARTITION BY h.ledger_id
                                                              ORDER BY b.creation_date, b.je_batch_id, h.je_header_id) > 10/1440
                                OR b.created_by <> LAG(b.created_by) OVER (PARTITION BY h.ledger_id
                                                              ORDER BY b.creation_date, b.je_batch_id, h.je_header_id)
                              THEN 1 ELSE 0
                            END AS new_run
                     FROM   apps.gl_je_headers@ADG h,
                            apps.gl_je_batches@ADG b
                     WHERE  h.ledger_id IN (:b_l1, :b_l2, :b_l3)
                     AND    h.actual_flag = 'A'
                     AND    h.reversed_je_header_id IS NOT NULL
                     AND    (:b_period IS NULL OR h.period_name = :b_period)
                     AND    b.je_batch_id = h.je_batch_id
                    ) y
             ) x
      ) r,
       apps.gl_ledgers@ADG       l,
       apps.fnd_user@ADG         fu,
       apps.gl_je_headers@ADG    o,
       apps.gl_je_batches@ADG    ob,
       apps.gl_je_sources@ADG    js,
       apps.gl_je_categories@ADG jc
WHERE r.ledger_id IN (1003, 5001, 10001)
AND   r.run_rank <= 3
AND   l.ledger_id           = r.ledger_id
AND   fu.user_id        (+) = r.created_by
AND   o.je_header_id    (+) = r.reversed_je_header_id
AND   ob.je_batch_id    (+) = o.je_batch_id
AND   js.je_source_name (+) = r.je_source
AND   jc.je_category_name (+) = r.je_category
ORDER BY l.name, r.run_rank, r.batch_created, r.je_batch_id, r.currency_code~', '@ADG', '@' || l_db_link);

    OPEN l_rc FOR l_sql USING l_l1, l_l2, l_l3, l_period, l_period;
    l_open := TRUE;

    LOOP
      FETCH l_rc BULK COLLECT INTO
        l_ledger_name, l_ledger_id, l_ledger_currency, l_run_rank,
        l_run_start, l_run_end, l_run_batches, l_run_by, l_rev_period,
        l_je_batch_id, l_batch_name, l_batch_status, l_je_header_id,
        l_journal_name, l_je_source, l_je_category, l_currency_code,
        l_accounted_dr, l_accounted_cr, l_orig_hdr_id, l_orig_jrn_name,
        l_orig_period, l_orig_batch_name
      LIMIT c_fetch_limit;

      EXIT WHEN l_je_header_id.COUNT = 0;

      FOR i IN 1 .. l_je_header_id.COUNT LOOP
        PIPE ROW(xxme_p70_rs_row_ot(
          l_ledger_name(i), l_ledger_id(i), l_ledger_currency(i), l_run_rank(i),
          l_run_start(i), l_run_end(i), l_run_batches(i), l_run_by(i), l_rev_period(i),
          l_je_batch_id(i), l_batch_name(i), l_batch_status(i), l_je_header_id(i),
          l_journal_name(i), l_je_source(i), l_je_category(i), l_currency_code(i),
          l_accounted_dr(i), l_accounted_cr(i), l_orig_hdr_id(i), l_orig_jrn_name(i),
          l_orig_period(i), l_orig_batch_name(i)
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
  END get_reversals;

  PROCEDURE emit_summary_json (
    p_tab     IN VARCHAR2 DEFAULT NULL,
    p_db_link IN VARCHAR2 DEFAULT 'ADG'
  ) IS
    l_tab     VARCHAR2(30)  := UPPER(TRIM(COALESCE(p_tab, apex_application.g_x01)));
    l_latest  DATE;
    l_rows    NUMBER        := 0;
    l_extra   NUMBER        := 0;
    l_context VARCHAR2(200);
  BEGIN
    CASE l_tab
      WHEN 'CA' THEN
        SELECT MAX(CASE WHEN is_latest = 'Y' THEN actual_completion_date END),
               COUNT(*)
          INTO l_latest, l_rows
          FROM TABLE(get_ca_executions(
            p_ledgers => apex_util.get_session_state('P70_CA_LEDGERS'),
            p_apps    => apex_util.get_session_state('P70_CA_APPS'),
            p_view    => apex_util.get_session_state('P70_CA_VIEW'),
            p_db_link => p_db_link
          ));
        l_context := 'Latest successful run | ' || l_rows || ' matching executions';
      WHEN 'RV' THEN
        SELECT MAX(run_start),
               COUNT(*),
               SUM(CASE WHEN run_rank LIKE 'Latest execution | %' AND batch_status = 'Unposted' THEN 1 ELSE 0 END)
          INTO l_latest, l_rows, l_extra
          FROM TABLE(get_revaluations(
            p_ledgers => apex_util.get_session_state('P70_RV_LEDGERS'),
            p_db_link => p_db_link
          ));
        l_context := 'Last 3 runs per ledger | ' || l_rows || ' journals | ' || NVL(l_extra, 0) || ' unposted in latest runs';
      WHEN 'RS' THEN
        SELECT MAX(run_start),
               COUNT(*),
               SUM(CASE WHEN run_rank LIKE 'Latest execution | %' AND batch_status = 'Unposted' THEN 1 ELSE 0 END)
          INTO l_latest, l_rows, l_extra
          FROM TABLE(get_reversals(
            p_ledgers => apex_util.get_session_state('P70_RS_LEDGERS'),
            p_db_link => p_db_link
          ));
        l_context := 'Last 3 runs per ledger | ' || l_rows || ' journals | ' || NVL(l_extra, 0) || ' unposted in latest runs';
      ELSE
        RAISE_APPLICATION_ERROR(-20003, 'Unknown process');
    END CASE;

    apex_json.open_object;
    apex_json.write('latest',  TO_CHAR(l_latest, 'DD-MON-YYYY HH24:MI:SS'));
    apex_json.write('context', l_context);
    apex_json.close_object;
  END emit_summary_json;

END xxme_process_monitor_pkg;
/

prompt === 4/4: XXME_FA_CLOSE_PKG (Pages 71 & 72) ===

CREATE OR REPLACE PACKAGE xxme_fa_close_pkg AUTHID DEFINER AS
  PROCEDURE normalize_p71_filters;

  PROCEDURE validate_p72_context (
    p_ledger_id      IN VARCHAR2 DEFAULT NULL,
    p_book_type_code IN VARCHAR2 DEFAULT NULL,
    p_period_name    IN VARCHAR2 DEFAULT NULL,
    p_db_link        IN VARCHAR2 DEFAULT 'ADG'
  );

  FUNCTION get_close_status (
    p_period_name    IN VARCHAR2 DEFAULT NULL,
    p_ledgers        IN VARCHAR2 DEFAULT '1003:5001:10001',
    p_book_class     IN VARCHAR2 DEFAULT 'CORPORATE',
    p_book_type_code IN VARCHAR2 DEFAULT NULL,
    p_db_link        IN VARCHAR2 DEFAULT 'ADG'
  ) RETURN xxme_fa_close_status_row_nt PIPELINED;

  PROCEDURE render_bridge (
    p_ledger_id      IN NUMBER,
    p_book_type_code IN VARCHAR2,
    p_period_name    IN VARCHAR2,
    p_db_link        IN VARCHAR2 DEFAULT 'ADG'
  );

  FUNCTION get_asset_details (
    p_ledger_id      IN NUMBER,
    p_book_type_code IN VARCHAR2,
    p_period_name    IN VARCHAR2,
    p_db_link        IN VARCHAR2 DEFAULT 'ADG'
  ) RETURN xxme_fa_asset_dtl_row_nt PIPELINED;

  FUNCTION get_gl_lines (
    p_ledger_id      IN NUMBER,
    p_book_type_code IN VARCHAR2,
    p_period_name    IN VARCHAR2,
    p_db_link        IN VARCHAR2 DEFAULT 'ADG'
  ) RETURN xxme_fa_gl_line_row_nt PIPELINED;
END xxme_fa_close_pkg;
/

CREATE OR REPLACE PACKAGE BODY xxme_fa_close_pkg AS

  c_fetch_limit CONSTANT PLS_INTEGER := 500;

  PROCEDURE normalize_p71_filters IS
    l_old   VARCHAR2(4000) := apex_util.get_session_state('P71_LEDGER_IDS');
    l_valid VARCHAR2(4000);
    l_class VARCHAR2(100)  := apex_util.get_session_state('P71_BOOK_CLASS');
  BEGIN
    SELECT LISTAGG(column_value, ':') WITHIN GROUP (ORDER BY column_value)
      INTO l_valid
      FROM (SELECT DISTINCT column_value
              FROM TABLE(apex_string.split(l_old, ':'))
             WHERE column_value IN ('1003', '5001', '10001'));

    IF l_old IS NOT NULL AND l_valid IS NULL THEN
      l_valid := '1003:5001:10001';
    END IF;

    apex_util.set_session_state(p_name => 'P71_LEDGER_IDS', p_value => l_valid, p_commit => FALSE);

    IF l_class IS NOT NULL AND l_class NOT IN ('CORPORATE', 'TAX') THEN
      apex_util.set_session_state(p_name => 'P71_BOOK_CLASS', p_value => 'CORPORATE', p_commit => FALSE);
    END IF;
  END normalize_p71_filters;

  PROCEDURE validate_p72_context (
    p_ledger_id      IN VARCHAR2 DEFAULT NULL,
    p_book_type_code IN VARCHAR2 DEFAULT NULL,
    p_period_name    IN VARCHAR2 DEFAULT NULL,
    p_db_link        IN VARCHAR2 DEFAULT 'ADG'
  ) IS
    l_db_link   VARCHAR2(30)  := xxme_db_source_pkg.normalize_db_link(p_db_link);
    l_ledger    VARCHAR2(100) := COALESCE(p_ledger_id, apex_util.get_session_state('P72_LEDGER_ID'));
    l_book      VARCHAR2(100) := COALESCE(p_book_type_code, apex_util.get_session_state('P72_BOOK_TYPE_CODE'));
    l_period    VARCHAR2(100) := COALESCE(p_period_name, apex_util.get_session_state('P72_PERIOD_NAME'));
    l_cnt       NUMBER        := 0;
    l_sql       VARCHAR2(1000);
  BEGIN
    IF l_ledger IS NULL
       OR l_ledger NOT IN ('1003', '5001', '10001')
       OR l_book IS NULL
       OR l_period IS NULL
       OR LENGTH(l_period) > 30
    THEN
      RAISE_APPLICATION_ERROR(-20072, 'Open an in-scope book from Fixed Assets.');
    END IF;

    l_sql := REPLACE(
      'SELECT /*+ DRIVING_SITE(bc) */ COUNT(*) ' ||
      'FROM apps.fa_book_controls@ADG bc ' ||
      'WHERE bc.set_of_books_id IN (1003, 5001, 10001) ' ||
      'AND bc.set_of_books_id = TO_NUMBER(:1) ' ||
      'AND bc.book_type_code = :2 ' ||
      'AND bc.date_ineffective IS NULL',
      '@ADG',
      '@' || l_db_link
    );

    EXECUTE IMMEDIATE l_sql INTO l_cnt USING l_ledger, l_book;

    IF l_cnt <> 1 THEN
      RAISE_APPLICATION_ERROR(-20073, 'The selected book does not belong to the selected ledger.');
    END IF;
  END validate_p72_context;

  FUNCTION get_close_status (
    p_period_name    IN VARCHAR2 DEFAULT NULL,
    p_ledgers        IN VARCHAR2 DEFAULT '1003:5001:10001',
    p_book_class     IN VARCHAR2 DEFAULT 'CORPORATE',
    p_book_type_code IN VARCHAR2 DEFAULT NULL,
    p_db_link        IN VARCHAR2 DEFAULT 'ADG'
  ) RETURN xxme_fa_close_status_row_nt PIPELINED IS
    l_db_link    VARCHAR2(30)   := xxme_db_source_pkg.normalize_db_link(p_db_link);
    l_now        DATE           := SYSDATE;
    l_period     VARCHAR2(30)   := NVL(
                                     UPPER(TRIM(REPLACE(p_period_name, ''''))),
                                     TO_CHAR(ADD_MONTHS(l_now, -1), 'MON-YYYY', 'NLS_DATE_LANGUAGE=ENGLISH')
                                   );
    l_book_class VARCHAR2(30)   := UPPER(TRIM(REPLACE(p_book_class, '''')));
    l_book       VARCHAR2(30)   := UPPER(TRIM(REPLACE(p_book_type_code, '''')));
    l_clean_ledg VARCHAR2(4000) := TRIM(REPLACE(p_ledgers, ''''));
    l_l1         NUMBER;
    l_l2         NUMBER;
    l_l3         NUMBER;
    l_b1         NUMBER;
    l_b2         NUMBER;
    l_b3         NUMBER;
    l_idx        PLS_INTEGER    := 1;
    l_tok        VARCHAR2(100);
    l_sql        CLOB;
    l_rc         SYS_REFCURSOR;
    l_open       BOOLEAN        := FALSE;

    TYPE t_num_tab   IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    TYPE t_date_tab  IS TABLE OF DATE INDEX BY PLS_INTEGER;
    TYPE t_v10_tab   IS TABLE OF VARCHAR2(10) INDEX BY PLS_INTEGER;
    TYPE t_v30_tab   IS TABLE OF VARCHAR2(30) INDEX BY PLS_INTEGER;
    TYPE t_v100_tab  IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
    TYPE t_v240_tab  IS TABLE OF VARCHAR2(240) INDEX BY PLS_INTEGER;
    TYPE t_v4000_tab IS TABLE OF VARCHAR2(4000) INDEX BY PLS_INTEGER;

    TYPE t_book_rec IS RECORD (
      ledger_id                 NUMBER,
      ledger_name               VARCHAR2(100),
      currency_code             VARCHAR2(30),
      book_type_code            VARCHAR2(30),
      book_class                VARCHAR2(30),
      deprn_calendar            VARCHAR2(30),
      gl_posting_allowed_flag   VARCHAR2(30),
      number_per_fiscal_year    NUMBER,
      period_counter            NUMBER,
      period_name               VARCHAR2(30),
      period_status             VARCHAR2(30),
      period_close_date         DATE,
      deprn_run                 VARCHAR2(10),
      fa_summary_rows           NUMBER,
      fa_nonzero_rows           NUMBER,
      fa_deprn_amount           NUMBER,
      fa_catchup_amount         NUMBER,
      fa_positive_deprn         NUMBER,
      fa_negative_deprn         NUMBER,
      deprn_events              NUMBER,
      unaccounted_events        NUMBER,
      entries_not_final         NUMBER,
      entries_not_transferred   NUMBER,
      group_ids_csv             VARCHAR2(4000),
      sla_expense_dr            NUMBER,
      sla_expense_cr            NUMBER,
      sla_expense_net           NUMBER,
      sla_expense_lines         NUMBER,
      orphan_asset_lines        NUMBER,
      sla_period_mismatch_lines NUMBER,
      sla_unlinked_lines        NUMBER,
      gl_groups_expected        NUMBER,
      gl_groups_missing         NUMBER,
      gl_shared_groups          NUMBER,
      gl_journals               NUMBER,
      gl_unposted               NUMBER,
      gl_journal_dr_total       NUMBER,
      has_gl_dr                 BOOLEAN,
      gl_batch_names            VARCHAR2(4000),
      gl_line_count             NUMBER,
      gl_mapping_issues         NUMBER,
      gl_posted_expense_lines   NUMBER,
      raw_post_dr               NUMBER,
      raw_post_cr               NUMBER,
      raw_post_net              NUMBER
    );
    TYPE t_book_tab IS TABLE OF t_book_rec INDEX BY PLS_INTEGER;
    l_books     t_book_tab;
    l_book_cnt  PLS_INTEGER := 0;

    TYPE t_int_by_key  IS TABLE OF PLS_INTEGER INDEX BY VARCHAR2(120);
    TYPE t_idx_list    IS TABLE OF PLS_INTEGER INDEX BY PLS_INTEGER;
    TYPE t_idx_by_grp  IS TABLE OF t_idx_list INDEX BY VARCHAR2(120);
    TYPE t_num_by_grp  IS TABLE OF NUMBER INDEX BY VARCHAR2(120);
    TYPE t_bool_by_key IS TABLE OF BOOLEAN INDEX BY VARCHAR2(1000);

    l_book_by_key     t_int_by_key;
    l_books_by_lg_grp t_idx_by_grp;
    l_empty_idx_list  t_idx_list;
    l_distinct_grps   t_v100_tab;
    l_distinct_ledgs  t_num_tab;
    l_distinct_grpids t_num_tab;
    l_distinct_cnt    PLS_INTEGER := 0;
    l_shared_cnt_map  t_num_by_grp;
    l_grp_has_jrn     t_bool_by_key;
    l_seen_batches    t_bool_by_key;
    l_any_groups      BOOLEAN     := FALSE;

    l_f1_ledger_id     t_num_tab;
    l_f1_ledger_name   t_v100_tab;
    l_f1_currency      t_v30_tab;
    l_f1_book          t_v30_tab;
    l_f1_class         t_v30_tab;
    l_f1_cal           t_v30_tab;
    l_f1_gl_allow      t_v30_tab;
    l_f1_per_fy        t_num_tab;
    l_f1_pc            t_num_tab;
    l_f1_period        t_v30_tab;
    l_f1_pstat         t_v30_tab;
    l_f1_pclose        t_date_tab;
    l_f1_deprn_run     t_v10_tab;
    l_f1_fa_rows       t_num_tab;
    l_f1_fa_nz         t_num_tab;
    l_f1_fa_amt        t_num_tab;
    l_f1_fa_catchup    t_num_tab;
    l_f1_fa_pos        t_num_tab;
    l_f1_fa_neg        t_num_tab;

    l_f2_ledger_id     t_num_tab;
    l_f2_book          t_v30_tab;
    l_f2_pc            t_num_tab;
    l_f2_ev            t_num_tab;
    l_f2_unacct        t_num_tab;
    l_f2_not_final     t_num_tab;
    l_f2_not_xfer      t_num_tab;
    l_f2_gcsv          t_v4000_tab;
    l_f2_sla_lines     t_num_tab;
    l_f2_sla_dr        t_num_tab;
    l_f2_sla_cr        t_num_tab;
    l_f2_sla_net       t_num_tab;
    l_f2_sla_mism      t_num_tab;
    l_f2_sla_unlnk     t_num_tab;
    l_f2_orphan        t_num_tab;

    l_f3_ledger_id     t_num_tab;
    l_f3_group_id      t_num_tab;
    l_f3_je_hdr_id     t_num_tab;
    l_f3_status        t_v30_tab;
    l_f3_dr            t_num_tab;
    l_f3_batch_lbl     t_v4000_tab;

    l_f4_ledger_id     t_num_tab;
    l_f4_group_id      t_num_tab;
    l_f4_status        t_v30_tab;
    l_f4_clean         t_v10_tab;
    l_f4_book          t_v30_tab;
    l_f4_pc            t_num_tab;
    l_f4_class         t_v30_tab;
    l_f4_cnt           t_num_tab;
    l_f4_dr            t_num_tab;
    l_f4_cr            t_num_tab;
    l_f4_net           t_num_tab;

    l_key              VARCHAR2(120);
    l_bi               PLS_INTEGER;
    l_gi               PLS_INTEGER;
    l_gid_tok          VARCHAR2(100);
    l_gid              NUMBER;
    l_shared_sql       VARCHAR2(1000);
    l_shared_cnt       NUMBER;
    l_batch_key        VARCHAR2(1000);
    l_targets          t_idx_list;
    l_fa_vs_gl_dr_diff NUMBER;
    l_activity_note    VARCHAR2(100);
    l_close_status     VARCHAR2(100);
    l_gl_post_dr       NUMBER;
    l_gl_post_cr       NUMBER;
    l_gl_post_net      NUMBER;
    l_fa_vs_gl_exp_diff NUMBER;
    l_recon_status     VARCHAR2(50);

    PROCEDURE close_rc IS
    BEGIN
      IF l_open THEN
        CLOSE l_rc;
        l_open := FALSE;
      END IF;
    END close_rc;
  BEGIN
    IF l_clean_ledg IS NULL THEN
      l_l1 := 1003;
      l_l2 := 5001;
      l_l3 := 10001;
    ELSE
      LOOP
        l_tok := REGEXP_SUBSTR(l_clean_ledg, '[^,;: ]+', 1, l_idx);
        EXIT WHEN l_tok IS NULL;
        IF l_tok = '1003' THEN
          l_l1 := 1003;
        ELSIF l_tok = '5001' THEN
          l_l2 := 5001;
        ELSIF l_tok = '10001' THEN
          l_l3 := 10001;
        END IF;
        l_idx := l_idx + 1;
      END LOOP;

      IF l_l1 IS NULL AND l_l2 IS NULL AND l_l3 IS NULL THEN
        RETURN;
      END IF;
    END IF;

    l_b1 := COALESCE(l_l1, l_l2, l_l3);
    l_b2 := COALESCE(l_l2, l_l1, l_l3);
    l_b3 := COALESCE(l_l3, l_l1, l_l2);

    -- Fetch 1: Book controls + deprn periods + fa_deprn_summary (~0.3s over @ADG).
    l_sql := REPLACE(q'~SELECT /*+ DRIVING_SITE(bc) NO_PUSH_PRED(fa) */
       gl.ledger_id,
       gl.name AS ledger_name,
       gl.currency_code,
       bc.book_type_code,
       bc.book_class,
       bc.deprn_calendar,
       bc.gl_posting_allowed_flag,
       ct.number_per_fiscal_year,
       dp.period_counter,
       NVL(dp.period_name, :b01) AS period_name,
       CASE
         WHEN dp.period_counter IS NULL        THEN 'Not found'
         WHEN dp.period_close_date IS NOT NULL THEN 'Closed'
         ELSE 'Open'
       END AS period_status,
       dp.period_close_date,
       NVL(dp.deprn_run, 'N') AS deprn_run,
       NVL(fa.fa_summary_rows, 0) AS fa_summary_rows,
       NVL(fa.fa_nonzero_rows, 0) AS fa_nonzero_rows,
       fa.fa_deprn_amount,
       fa.fa_catchup_amount,
       fa.fa_positive_deprn,
       fa.fa_negative_deprn
  FROM apps.fa_book_controls@ADG  bc,
       apps.gl_ledgers@ADG        gl,
       apps.fa_calendar_types@ADG ct,
       apps.fa_deprn_periods@ADG  dp,
       (SELECT /*+ NO_MERGE */
               ds.book_type_code,
               ds.period_counter,
               COUNT(*) AS fa_summary_rows,
               SUM(CASE WHEN ds.deprn_amount - NVL(ds.deprn_adjustment_amount, 0) > 0 THEN ds.deprn_amount - NVL(ds.deprn_adjustment_amount, 0) ELSE 0 END) AS fa_positive_deprn,
               SUM(CASE WHEN ds.deprn_amount - NVL(ds.deprn_adjustment_amount, 0) < 0 THEN ds.deprn_amount - NVL(ds.deprn_adjustment_amount, 0) ELSE 0 END) AS fa_negative_deprn,
               SUM(CASE WHEN ds.deprn_amount - NVL(ds.deprn_adjustment_amount, 0) <> 0 THEN 1 ELSE 0 END) AS fa_nonzero_rows,
               SUM(ds.deprn_amount - NVL(ds.deprn_adjustment_amount, 0)) AS fa_deprn_amount,
               SUM(NVL(ds.deprn_adjustment_amount, 0)) AS fa_catchup_amount
          FROM apps.fa_book_controls@ADG bc2,
               apps.fa_deprn_periods@ADG dp2,
               apps.fa_deprn_summary@ADG ds
         WHERE bc2.set_of_books_id IN (:b02, :b03, :b04)
           AND bc2.date_ineffective IS NULL
           AND (:b05 IS NULL OR bc2.book_class     = :b06)
           AND (:b07 IS NULL OR bc2.book_type_code = :b08)
           AND dp2.book_type_code    = bc2.book_type_code
           AND dp2.period_name       = :b09
           AND ds.book_type_code     = dp2.book_type_code
           AND ds.period_counter     = dp2.period_counter
           AND ds.deprn_source_code  = 'DEPRN'
         GROUP BY ds.book_type_code, ds.period_counter) fa
 WHERE gl.ledger_id        = bc.set_of_books_id
   AND bc.set_of_books_id IN (:b10, :b11, :b12)
   AND bc.date_ineffective IS NULL
   AND (:b13 IS NULL OR bc.book_class     = :b14)
   AND (:b15 IS NULL OR bc.book_type_code = :b16)
   AND ct.calendar_type    = bc.deprn_calendar
   AND dp.book_type_code (+) = bc.book_type_code
   AND dp.period_name    (+) = :b17
   AND fa.book_type_code (+) = dp.book_type_code
   AND fa.period_counter (+) = dp.period_counter
 ORDER BY gl.ledger_id, bc.book_class, bc.book_type_code~', '@ADG', '@' || l_db_link);

    OPEN l_rc FOR l_sql USING
      l_period,
      l_b1, l_b2, l_b3, l_book_class, l_book_class, l_book, l_book, l_period,
      l_b1, l_b2, l_b3, l_book_class, l_book_class, l_book, l_book, l_period;
    l_open := TRUE;

    LOOP
      FETCH l_rc BULK COLLECT INTO
        l_f1_ledger_id, l_f1_ledger_name, l_f1_currency, l_f1_book, l_f1_class,
        l_f1_cal, l_f1_gl_allow, l_f1_per_fy, l_f1_pc, l_f1_period, l_f1_pstat,
        l_f1_pclose, l_f1_deprn_run, l_f1_fa_rows, l_f1_fa_nz, l_f1_fa_amt,
        l_f1_fa_catchup, l_f1_fa_pos, l_f1_fa_neg
      LIMIT c_fetch_limit;
      EXIT WHEN l_f1_ledger_id.COUNT = 0;

      FOR i IN 1 .. l_f1_ledger_id.COUNT LOOP
        l_book_cnt := l_book_cnt + 1;
        l_books(l_book_cnt).ledger_id                 := l_f1_ledger_id(i);
        l_books(l_book_cnt).ledger_name               := l_f1_ledger_name(i);
        l_books(l_book_cnt).currency_code             := l_f1_currency(i);
        l_books(l_book_cnt).book_type_code            := l_f1_book(i);
        l_books(l_book_cnt).book_class                := l_f1_class(i);
        l_books(l_book_cnt).deprn_calendar            := l_f1_cal(i);
        l_books(l_book_cnt).gl_posting_allowed_flag   := l_f1_gl_allow(i);
        l_books(l_book_cnt).number_per_fiscal_year    := l_f1_per_fy(i);
        l_books(l_book_cnt).period_counter            := l_f1_pc(i);
        l_books(l_book_cnt).period_name               := l_f1_period(i);
        l_books(l_book_cnt).period_status             := l_f1_pstat(i);
        l_books(l_book_cnt).period_close_date         := l_f1_pclose(i);
        l_books(l_book_cnt).deprn_run                 := l_f1_deprn_run(i);
        l_books(l_book_cnt).fa_summary_rows           := l_f1_fa_rows(i);
        l_books(l_book_cnt).fa_nonzero_rows           := l_f1_fa_nz(i);
        l_books(l_book_cnt).fa_deprn_amount           := l_f1_fa_amt(i);
        l_books(l_book_cnt).fa_catchup_amount         := l_f1_fa_catchup(i);
        l_books(l_book_cnt).fa_positive_deprn         := l_f1_fa_pos(i);
        l_books(l_book_cnt).fa_negative_deprn         := l_f1_fa_neg(i);
        l_books(l_book_cnt).deprn_events              := 0;
        l_books(l_book_cnt).unaccounted_events        := 0;
        l_books(l_book_cnt).entries_not_final         := 0;
        l_books(l_book_cnt).entries_not_transferred   := 0;
        l_books(l_book_cnt).group_ids_csv             := NULL;
        l_books(l_book_cnt).sla_expense_dr            := NULL;
        l_books(l_book_cnt).sla_expense_cr            := NULL;
        l_books(l_book_cnt).sla_expense_net           := NULL;
        l_books(l_book_cnt).sla_expense_lines         := 0;
        l_books(l_book_cnt).orphan_asset_lines        := 0;
        l_books(l_book_cnt).sla_period_mismatch_lines := 0;
        l_books(l_book_cnt).sla_unlinked_lines        := 0;
        l_books(l_book_cnt).gl_groups_expected        := 0;
        l_books(l_book_cnt).gl_groups_missing         := 0;
        l_books(l_book_cnt).gl_shared_groups          := 0;
        l_books(l_book_cnt).gl_journals               := 0;
        l_books(l_book_cnt).gl_unposted               := 0;
        l_books(l_book_cnt).gl_journal_dr_total       := NULL;
        l_books(l_book_cnt).has_gl_dr                 := FALSE;
        l_books(l_book_cnt).gl_batch_names            := NULL;
        l_books(l_book_cnt).gl_line_count             := 0;
        l_books(l_book_cnt).gl_mapping_issues         := 0;
        l_books(l_book_cnt).gl_posted_expense_lines   := 0;
        l_books(l_book_cnt).raw_post_dr               := 0;
        l_books(l_book_cnt).raw_post_cr               := 0;
        l_books(l_book_cnt).raw_post_net              := 0;

        IF l_f1_pc(i) IS NOT NULL THEN
          l_key := TO_CHAR(l_f1_ledger_id(i)) || '|' || l_f1_book(i) || '|' || TO_CHAR(l_f1_pc(i));
          l_book_by_key(l_key) := l_book_cnt;
        END IF;
      END LOOP;
    END LOOP;
    close_rc;

    IF l_book_cnt = 0 THEN
      RETURN;
    END IF;

    -- Fetch 2: Single combined XLA scan (x + s + transferred group_id list) on PTRXI (~7.9s).
    l_sql := REPLACE(q'~SELECT /*+ DRIVING_SITE(te) LEADING(bc dp te e ah xl) FULL(te) USE_NL(e ah xl)
           INDEX(e XLA_EVENTS_U2) INDEX(ah XLA_AE_HEADERS_N2) INDEX(xl XLA_AE_LINES_U1) */
       te.ledger_id,
       te.source_id_char_1 AS book_type_code,
       te.source_id_int_2  AS period_counter,
       COUNT(DISTINCT e.event_id) AS deprn_events,
       COUNT(DISTINCT CASE WHEN e.event_status_code IN ('U', 'I') THEN e.event_id END) AS unaccounted_events,
       COUNT(DISTINCT CASE WHEN ah.accounting_entry_status_code <> 'F' THEN ah.ae_header_id END) AS entries_not_final,
       COUNT(DISTINCT CASE WHEN ah.accounting_entry_status_code = 'F'
                            AND (NVL(ah.gl_transfer_status_code, 'N') <> 'Y' OR ah.group_id IS NULL)
                           THEN ah.ae_header_id END) AS entries_not_transferred,
       LISTAGG(DISTINCT CASE WHEN ah.accounting_entry_status_code = 'F'
                              AND ah.gl_transfer_status_code = 'Y'
                              AND ah.group_id IS NOT NULL
                             THEN TO_CHAR(ah.group_id) END, ',')
         WITHIN GROUP (ORDER BY ah.group_id) AS group_ids_csv,
       COUNT(CASE WHEN ah.accounting_entry_status_code = 'F' AND xl.ae_header_id IS NOT NULL THEN 1 END) AS sla_expense_lines,
       CASE WHEN COUNT(CASE WHEN ah.accounting_entry_status_code = 'F' AND xl.ae_header_id IS NOT NULL THEN 1 END) > 0
            THEN SUM(CASE WHEN ah.accounting_entry_status_code = 'F' AND xl.ae_header_id IS NOT NULL THEN NVL(xl.accounted_dr, 0) ELSE 0 END)
       END AS sla_expense_dr,
       CASE WHEN COUNT(CASE WHEN ah.accounting_entry_status_code = 'F' AND xl.ae_header_id IS NOT NULL THEN 1 END) > 0
            THEN SUM(CASE WHEN ah.accounting_entry_status_code = 'F' AND xl.ae_header_id IS NOT NULL THEN NVL(xl.accounted_cr, 0) ELSE 0 END)
       END AS sla_expense_cr,
       CASE WHEN COUNT(CASE WHEN ah.accounting_entry_status_code = 'F' AND xl.ae_header_id IS NOT NULL THEN 1 END) > 0
            THEN SUM(CASE WHEN ah.accounting_entry_status_code = 'F' AND xl.ae_header_id IS NOT NULL THEN NVL(xl.accounted_dr, 0) - NVL(xl.accounted_cr, 0) ELSE 0 END)
       END AS sla_expense_net,
       COUNT(CASE WHEN ah.accounting_entry_status_code = 'F' AND xl.ae_header_id IS NOT NULL
                   AND (ah.period_name <> dp.period_name OR ah.period_name IS NULL) THEN 1 END) AS sla_period_mismatch_lines,
       COUNT(CASE WHEN ah.accounting_entry_status_code = 'F' AND xl.ae_header_id IS NOT NULL
                   AND NOT EXISTS (
                     SELECT 1
                       FROM apps.gl_import_references@ADG ir,
                            apps.gl_je_lines@ADG          jl,
                            apps.gl_je_headers@ADG        jh
                      WHERE ir.gl_sl_link_id    = xl.gl_sl_link_id
                        AND ir.gl_sl_link_table = xl.gl_sl_link_table
                        AND jl.je_header_id     = ir.je_header_id
                        AND jl.je_line_num      = ir.je_line_num
                        AND jh.je_header_id     = jl.je_header_id
                        AND jh.ledger_id        = te.ledger_id
                        AND jh.period_name      = dp.period_name
                        AND jh.je_source        = 'Assets'
                        AND jh.je_category      = 'Depreciation'
                        AND jh.actual_flag      = 'A'
                        AND jh.status           = 'P') THEN 1 END) AS sla_unlinked_lines,
       COUNT(CASE WHEN ah.accounting_entry_status_code = 'F' AND xl.ae_header_id IS NOT NULL
                   AND NOT EXISTS (
                     SELECT 1
                       FROM apps.fa_deprn_summary@ADG ds
                      WHERE ds.book_type_code    = te.source_id_char_1
                        AND ds.period_counter    = te.source_id_int_2
                        AND ds.asset_id          = te.source_id_int_1
                        AND ds.deprn_source_code = 'DEPRN') THEN 1 END) AS orphan_asset_lines
  FROM apps.fa_book_controls@ADG         bc,
       apps.fa_deprn_periods@ADG         dp,
       apps.xla_transaction_entities@ADG te,
       apps.xla_events@ADG               e,
       apps.xla_ae_headers@ADG           ah,
       apps.xla_ae_lines@ADG             xl
 WHERE bc.set_of_books_id IN (:b01, :b02, :b03)
   AND bc.date_ineffective IS NULL
   AND (:b04 IS NULL OR bc.book_class     = :b05)
   AND (:b06 IS NULL OR bc.book_type_code = :b07)
   AND dp.book_type_code   = bc.book_type_code
   AND dp.period_name      = :b08
   AND te.application_id   = 140
   AND te.entity_code      = 'DEPRECIATION'
   AND te.ledger_id        = bc.set_of_books_id
   AND te.source_id_char_1 = bc.book_type_code
   AND te.source_id_int_2  = dp.period_counter
   AND e.application_id    = 140
   AND e.entity_id         = te.entity_id
   AND ah.application_id (+) = 140
   AND ah.event_id       (+) = e.event_id
   AND ah.ledger_id      (+) = te.ledger_id
   AND xl.application_id (+) = 140
   AND xl.ae_header_id   (+) = ah.ae_header_id
   AND xl.accounting_class_code (+) = 'EXPENSE'
 GROUP BY te.ledger_id, te.source_id_char_1, te.source_id_int_2~', '@ADG', '@' || l_db_link);

    OPEN l_rc FOR l_sql USING
      l_b1, l_b2, l_b3, l_book_class, l_book_class, l_book, l_book, l_period;
    l_open := TRUE;

    LOOP
      FETCH l_rc BULK COLLECT INTO
        l_f2_ledger_id, l_f2_book, l_f2_pc, l_f2_ev, l_f2_unacct, l_f2_not_final,
        l_f2_not_xfer, l_f2_gcsv, l_f2_sla_lines, l_f2_sla_dr, l_f2_sla_cr,
        l_f2_sla_net, l_f2_sla_mism, l_f2_sla_unlnk, l_f2_orphan
      LIMIT c_fetch_limit;
      EXIT WHEN l_f2_ledger_id.COUNT = 0;

      FOR i IN 1 .. l_f2_ledger_id.COUNT LOOP
        l_key := TO_CHAR(l_f2_ledger_id(i)) || '|' || l_f2_book(i) || '|' || TO_CHAR(l_f2_pc(i));
        IF l_book_by_key.EXISTS(l_key) THEN
          l_bi := l_book_by_key(l_key);
          l_books(l_bi).deprn_events              := l_f2_ev(i);
          l_books(l_bi).unaccounted_events        := l_f2_unacct(i);
          l_books(l_bi).entries_not_final         := l_f2_not_final(i);
          l_books(l_bi).entries_not_transferred   := l_f2_not_xfer(i);
          l_books(l_bi).group_ids_csv             := l_f2_gcsv(i);
          l_books(l_bi).sla_expense_lines         := l_f2_sla_lines(i);
          l_books(l_bi).sla_expense_dr            := l_f2_sla_dr(i);
          l_books(l_bi).sla_expense_cr            := l_f2_sla_cr(i);
          l_books(l_bi).sla_expense_net           := l_f2_sla_net(i);
          l_books(l_bi).sla_period_mismatch_lines := l_f2_sla_mism(i);
          l_books(l_bi).sla_unlinked_lines        := l_f2_sla_unlnk(i);
          l_books(l_bi).orphan_asset_lines        := l_f2_orphan(i);

          IF l_f2_gcsv(i) IS NOT NULL THEN
            l_gi := 1;
            LOOP
              l_gid_tok := REGEXP_SUBSTR(l_f2_gcsv(i), '[^,]+', 1, l_gi);
              EXIT WHEN l_gid_tok IS NULL;
              l_gid := TO_NUMBER(l_gid_tok);
              l_any_groups := TRUE;
              l_books(l_bi).gl_groups_expected := l_books(l_bi).gl_groups_expected + 1;
              l_key := TO_CHAR(l_f2_ledger_id(i)) || '|' || TO_CHAR(l_gid);
              IF NOT l_books_by_lg_grp.EXISTS(l_key) THEN
                l_distinct_cnt := l_distinct_cnt + 1;
                l_distinct_grps(l_distinct_cnt)   := l_key;
                l_distinct_ledgs(l_distinct_cnt)  := l_f2_ledger_id(i);
                l_distinct_grpids(l_distinct_cnt) := l_gid;
                l_books_by_lg_grp(l_key)          := l_empty_idx_list;
              END IF;
              l_books_by_lg_grp(l_key)(l_books_by_lg_grp(l_key).COUNT + 1) := l_bi;
              l_gi := l_gi + 1;
            END LOOP;
          END IF;
        END IF;
      END LOOP;
    END LOOP;
    close_rc;

    IF l_any_groups THEN
      -- Fetch 3a: Check books_in_group per distinct (ledger_id, group_id) via XLA_AE_HEADERS_N1.
      l_shared_sql := REPLACE(
        'SELECT /*+ DRIVING_SITE(shared_ah) LEADING(shared_ah shared_te) USE_NL(shared_te) ' ||
        '           INDEX(shared_ah XLA_AE_HEADERS_N1) INDEX(shared_te XLA_TRANSACTION_ENTITIES_U1) */ ' ||
        '       COUNT(DISTINCT shared_te.source_id_char_1) ' ||
        '  FROM apps.xla_ae_headers@ADG shared_ah, ' ||
        '       apps.xla_transaction_entities@ADG shared_te ' ||
        ' WHERE shared_ah.application_id = 140 ' ||
        '   AND shared_ah.ledger_id = :b01 ' ||
        '   AND shared_ah.group_id = :b02 ' ||
        '   AND shared_ah.accounting_entry_status_code = ''F'' ' ||
        '   AND shared_ah.gl_transfer_status_code = ''Y'' ' ||
        '   AND shared_te.application_id = 140 ' ||
        '   AND shared_te.entity_id = shared_ah.entity_id ' ||
        '   AND shared_te.ledger_id = shared_ah.ledger_id ' ||
        '   AND shared_te.entity_code = ''DEPRECIATION''',
        '@ADG', '@' || l_db_link
      );

      FOR d IN 1 .. l_distinct_cnt LOOP
        EXECUTE IMMEDIATE l_shared_sql INTO l_shared_cnt
          USING l_distinct_ledgs(d), l_distinct_grpids(d);
        l_shared_cnt_map(l_distinct_grps(d)) := l_shared_cnt;
        IF l_shared_cnt > 1 THEN
          l_targets := l_books_by_lg_grp(l_distinct_grps(d));
          FOR t IN 1 .. l_targets.COUNT LOOP
            l_bi := l_targets(t);
            l_books(l_bi).gl_shared_groups := l_books(l_bi).gl_shared_groups + 1;
          END LOOP;
        END IF;
      END LOOP;

      -- Fetch 3b: GL Assets/Depreciation headers + batches for the period (~0.06s).
      l_sql := REPLACE(q'~SELECT /*+ DRIVING_SITE(h) */
       h.ledger_id,
       b.group_id,
       h.je_header_id,
       h.status,
       h.running_total_accounted_dr,
       b.name || ' [' || b.status || ']' AS batch_label
  FROM apps.gl_je_headers@ADG h,
       apps.gl_je_batches@ADG b
 WHERE h.period_name = :b01
   AND h.je_category = 'Depreciation'
   AND h.je_source   = 'Assets'
   AND h.actual_flag = 'A'
   AND h.ledger_id   IN (:b02, :b03, :b04)
   AND b.je_batch_id = h.je_batch_id
   AND b.group_id IS NOT NULL
 ORDER BY b.name || ' [' || b.status || ']'~', '@ADG', '@' || l_db_link);

      OPEN l_rc FOR l_sql USING l_period, l_b1, l_b2, l_b3;
      l_open := TRUE;

      LOOP
        FETCH l_rc BULK COLLECT INTO
          l_f3_ledger_id, l_f3_group_id, l_f3_je_hdr_id, l_f3_status, l_f3_dr, l_f3_batch_lbl
        LIMIT c_fetch_limit;
        EXIT WHEN l_f3_ledger_id.COUNT = 0;

        FOR i IN 1 .. l_f3_ledger_id.COUNT LOOP
          l_key := TO_CHAR(l_f3_ledger_id(i)) || '|' || TO_CHAR(l_f3_group_id(i));
          IF l_books_by_lg_grp.EXISTS(l_key) THEN
            l_grp_has_jrn(l_key) := TRUE;
            l_targets := l_books_by_lg_grp(l_key);
            FOR t IN 1 .. l_targets.COUNT LOOP
              l_bi := l_targets(t);
              l_books(l_bi).gl_journals := l_books(l_bi).gl_journals + 1;
              IF l_f3_status(i) <> 'P' OR l_f3_status(i) IS NULL THEN
                l_books(l_bi).gl_unposted := l_books(l_bi).gl_unposted + 1;
              END IF;
              IF l_f3_dr(i) IS NOT NULL THEN
                l_books(l_bi).gl_journal_dr_total := NVL(l_books(l_bi).gl_journal_dr_total, 0) + l_f3_dr(i);
                l_books(l_bi).has_gl_dr := TRUE;
              END IF;
              IF l_f3_batch_lbl(i) IS NOT NULL THEN
                l_batch_key := TO_CHAR(l_bi) || '|' || SUBSTRB(l_f3_batch_lbl(i), 1, 900);
                IF NOT l_seen_batches.EXISTS(l_batch_key) THEN
                  l_seen_batches(l_batch_key) := TRUE;
                  IF l_books(l_bi).gl_batch_names IS NULL THEN
                    l_books(l_bi).gl_batch_names := l_f3_batch_lbl(i);
                  ELSIF LENGTHB(l_books(l_bi).gl_batch_names) + 2 + LENGTHB(l_f3_batch_lbl(i)) <= 3950 THEN
                    l_books(l_bi).gl_batch_names := l_books(l_bi).gl_batch_names || '; ' || l_f3_batch_lbl(i);
                  END IF;
                END IF;
              END IF;
            END LOOP;
          END IF;
        END LOOP;
      END LOOP;
      close_rc;

      FOR d IN 1 .. l_distinct_cnt LOOP
        IF NOT l_grp_has_jrn.EXISTS(l_distinct_grps(d)) THEN
          l_targets := l_books_by_lg_grp(l_distinct_grps(d));
          FOR t IN 1 .. l_targets.COUNT LOOP
            l_bi := l_targets(t);
            l_books(l_bi).gl_groups_missing := l_books(l_bi).gl_groups_missing + 1;
          END LOOP;
        END IF;
      END LOOP;

      -- Fetch 4: GL line mapping driven directly from GL_JE_HEADERS -> GL_JE_LINES -> m (~3.1s).
      l_sql := REPLACE(q'~SELECT /*+ DRIVING_SITE(jl) NO_MERGE(jh) NO_MERGE(m) NO_PUSH_PRED(m) */
       jh.ledger_id,
       jh.group_id,
       jh.status,
       CASE
         WHEN m.reference_rows IS NOT NULL
          AND m.unresolved_refs = 0
          AND m.class_count     = 1
          AND m.book_count      = 1
          AND m.period_count    = 1
          AND m.ledger_count    = 1
          AND m.min_application = 140
          AND m.max_application = 140
          AND m.min_entity      = 'DEPRECIATION'
          AND m.max_entity      = 'DEPRECIATION'
          AND m.ledger_id       = jh.ledger_id
         THEN 'Y'
         ELSE 'N'
       END AS is_clean_140,
       m.book_type_code,
       m.period_counter,
       m.accounting_class_code,
       COUNT(*) AS line_cnt,
       SUM(NVL(jl.accounted_dr, 0)) AS sum_dr,
       SUM(NVL(jl.accounted_cr, 0)) AS sum_cr,
       SUM(NVL(jl.accounted_dr, 0) - NVL(jl.accounted_cr, 0)) AS sum_net
  FROM (SELECT /*+ NO_MERGE */
               h.ledger_id,
               h.je_header_id,
               h.status,
               b.group_id
          FROM apps.gl_je_headers@ADG h,
               apps.gl_je_batches@ADG b
         WHERE h.period_name = :b01
           AND h.je_source   = 'Assets'
           AND h.je_category = 'Depreciation'
           AND h.actual_flag = 'A'
           AND h.ledger_id   IN (:b02, :b03, :b04)
           AND b.je_batch_id = h.je_batch_id
           AND b.group_id IS NOT NULL) jh,
       apps.gl_je_lines@ADG jl,
       (SELECT /*+ NO_MERGE LEADING(h b ir xl ah te) USE_NL(ir xl ah te) INDEX(xl XLA_AE_LINES_N4) */
               ir.je_header_id,
               ir.je_line_num,
               COUNT(*) AS reference_rows,
               COUNT(CASE WHEN xl.ae_header_id IS NULL OR te.entity_id IS NULL THEN 1 END) AS unresolved_refs,
               COUNT(DISTINCT xl.accounting_class_code) AS class_count,
               MIN(xl.accounting_class_code) AS accounting_class_code,
               COUNT(DISTINCT te.source_id_char_1) AS book_count,
               MIN(te.source_id_char_1) AS book_type_code,
               COUNT(DISTINCT te.source_id_int_2) AS period_count,
               MIN(te.source_id_int_2) AS period_counter,
               COUNT(DISTINCT te.ledger_id) AS ledger_count,
               MIN(te.ledger_id) AS ledger_id,
               MIN(te.application_id) AS min_application,
               MAX(te.application_id) AS max_application,
               MIN(te.entity_code) AS min_entity,
               MAX(te.entity_code) AS max_entity
          FROM apps.gl_je_headers@ADG            h,
               apps.gl_je_batches@ADG            b,
               apps.gl_import_references@ADG     ir,
               apps.xla_ae_lines@ADG             xl,
               apps.xla_ae_headers@ADG           ah,
               apps.xla_transaction_entities@ADG te
         WHERE h.period_name = :b05
           AND h.je_source   = 'Assets'
           AND h.je_category = 'Depreciation'
           AND h.actual_flag = 'A'
           AND h.ledger_id   IN (:b06, :b07, :b08)
           AND b.je_batch_id = h.je_batch_id
           AND b.group_id IS NOT NULL
           AND ir.je_header_id       = h.je_header_id
           AND xl.application_id (+) = 140
           AND xl.gl_sl_link_id  (+) = ir.gl_sl_link_id
           AND xl.gl_sl_link_table (+) = ir.gl_sl_link_table
           AND ah.application_id (+) = xl.application_id
           AND ah.ae_header_id   (+) = xl.ae_header_id
           AND te.application_id (+) = ah.application_id
           AND te.entity_id      (+) = ah.entity_id
         GROUP BY ir.je_header_id, ir.je_line_num) m
 WHERE jl.je_header_id   = jh.je_header_id
   AND m.je_header_id (+) = jl.je_header_id
   AND m.je_line_num  (+) = jl.je_line_num
 GROUP BY jh.ledger_id, jh.group_id, jh.status,
          CASE
            WHEN m.reference_rows IS NOT NULL
             AND m.unresolved_refs = 0
             AND m.class_count     = 1
             AND m.book_count      = 1
             AND m.period_count    = 1
             AND m.ledger_count    = 1
             AND m.min_application = 140
             AND m.max_application = 140
             AND m.min_entity      = 'DEPRECIATION'
             AND m.max_entity      = 'DEPRECIATION'
             AND m.ledger_id       = jh.ledger_id
            THEN 'Y'
            ELSE 'N'
          END,
          m.book_type_code, m.period_counter, m.accounting_class_code~', '@ADG', '@' || l_db_link);

      OPEN l_rc FOR l_sql USING
        l_period, l_b1, l_b2, l_b3,
        l_period, l_b1, l_b2, l_b3;
      l_open := TRUE;

      LOOP
        FETCH l_rc BULK COLLECT INTO
          l_f4_ledger_id, l_f4_group_id, l_f4_status, l_f4_clean,
          l_f4_book, l_f4_pc, l_f4_class, l_f4_cnt, l_f4_dr, l_f4_cr, l_f4_net
        LIMIT c_fetch_limit;
        EXIT WHEN l_f4_ledger_id.COUNT = 0;

        FOR i IN 1 .. l_f4_ledger_id.COUNT LOOP
          l_key := TO_CHAR(l_f4_ledger_id(i)) || '|' || TO_CHAR(l_f4_group_id(i));
          IF l_books_by_lg_grp.EXISTS(l_key) THEN
            l_targets := l_books_by_lg_grp(l_key);
            FOR t IN 1 .. l_targets.COUNT LOOP
              l_bi := l_targets(t);
              l_books(l_bi).gl_line_count := l_books(l_bi).gl_line_count + l_f4_cnt(i);
              IF l_f4_clean(i) = 'Y'
                 AND l_f4_book(i) = l_books(l_bi).book_type_code
                 AND l_f4_pc(i)   = l_books(l_bi).period_counter
              THEN
                IF l_f4_class(i) = 'EXPENSE' AND l_f4_status(i) = 'P' THEN
                  l_books(l_bi).gl_posted_expense_lines := l_books(l_bi).gl_posted_expense_lines + l_f4_cnt(i);
                  l_books(l_bi).raw_post_dr  := l_books(l_bi).raw_post_dr  + l_f4_dr(i);
                  l_books(l_bi).raw_post_cr  := l_books(l_bi).raw_post_cr  + l_f4_cr(i);
                  l_books(l_bi).raw_post_net := l_books(l_bi).raw_post_net + l_f4_net(i);
                END IF;
              ELSE
                l_books(l_bi).gl_mapping_issues := l_books(l_bi).gl_mapping_issues + l_f4_cnt(i);
              END IF;
            END LOOP;
          END IF;
        END LOOP;
      END LOOP;
      close_rc;
    END IF;

    FOR i IN 1 .. l_book_cnt LOOP
      l_fa_vs_gl_dr_diff := NVL(l_books(i).fa_deprn_amount, 0) - NVL(l_books(i).gl_journal_dr_total, 0);

      l_activity_note := CASE
        WHEN l_books(i).period_counter IS NULL      THEN NULL
        WHEN NVL(l_books(i).fa_summary_rows, 0) = 0 THEN 'NO DEPRECIATION DATA'
        WHEN l_books(i).fa_nonzero_rows = 0         THEN 'ZERO DEPRECIATION'
        WHEN l_books(i).fa_deprn_amount = 0         THEN 'ZERO NET DEPRECIATION'
        ELSE NULL
      END;

      l_close_status := CASE
        WHEN l_books(i).number_per_fiscal_year = 1          THEN 'ANNUAL CALENDAR - CONFIRM SCOPE'
        WHEN l_books(i).period_counter IS NULL              THEN 'PERIOD NOT FOUND'
        WHEN l_books(i).period_close_date IS NULL           THEN 'NOT CLOSED'
        WHEN NVL(l_books(i).deprn_run, 'N') <> 'Y'          THEN 'NO DEPRN RUN'
        WHEN l_books(i).gl_posting_allowed_flag <> 'YES'    THEN 'COMPLETE (NO GL POSTING)'
        WHEN NVL(l_books(i).unaccounted_events, 0) > 0      THEN 'UNACCOUNTED EVENTS'
        WHEN NVL(l_books(i).entries_not_final, 0) > 0       THEN 'ACCOUNTING NOT FINAL'
        WHEN NVL(l_books(i).entries_not_transferred, 0) > 0 THEN 'NOT TRANSFERRED TO GL'
        WHEN NVL(l_books(i).fa_nonzero_rows, 0) > 0
         AND NVL(l_books(i).deprn_events, 0) = 0            THEN 'NO ACCOUNTING EVENTS'
        WHEN NVL(l_books(i).gl_groups_missing, 0) > 0       THEN 'GL JOURNAL MISSING'
        WHEN NVL(l_books(i).fa_nonzero_rows, 0) > 0
         AND NVL(l_books(i).gl_journals, 0) = 0             THEN 'NO GL JOURNAL'
        WHEN NVL(l_books(i).gl_unposted, 0) > 0             THEN 'GL NOT POSTED'
        ELSE 'COMPLETE'
      END;

      IF l_books(i).gl_line_count > 0 AND l_books(i).gl_mapping_issues = 0 THEN
        l_gl_post_dr  := l_books(i).raw_post_dr;
        l_gl_post_cr  := l_books(i).raw_post_cr;
        l_gl_post_net := l_books(i).raw_post_net;
      ELSE
        l_gl_post_dr  := NULL;
        l_gl_post_cr  := NULL;
        l_gl_post_net := NULL;
      END IF;

      IF l_books(i).fa_summary_rows > 0
         AND l_books(i).gl_mapping_issues = 0
         AND l_books(i).orphan_asset_lines = 0
         AND l_books(i).sla_period_mismatch_lines = 0
         AND l_books(i).sla_unlinked_lines = 0
         AND (l_books(i).gl_posted_expense_lines > 0 OR (l_books(i).fa_nonzero_rows = 0 AND l_books(i).deprn_events = 0))
         AND l_close_status NOT IN ('COMPLETE (NO GL POSTING)', 'ANNUAL CALENDAR - CONFIRM SCOPE')
      THEN
        l_fa_vs_gl_exp_diff := ROUND(l_books(i).fa_deprn_amount - NVL(l_gl_post_net, 0), 2);
      ELSE
        l_fa_vs_gl_exp_diff := NULL;
      END IF;

      l_recon_status := CASE
        WHEN l_close_status = 'COMPLETE (NO GL POSTING)'        THEN 'NOT APPLICABLE'
        WHEN l_close_status = 'ANNUAL CALENDAR - CONFIRM SCOPE' THEN 'SCOPE REVIEW'
        WHEN l_books(i).period_status = 'Not found'             THEN 'PERIOD NOT FOUND'
        WHEN l_books(i).gl_mapping_issues > 0
          OR l_books(i).orphan_asset_lines > 0
          OR l_books(i).sla_period_mismatch_lines > 0           THEN 'MAPPING REVIEW'
        WHEN l_close_status <> 'COMPLETE'                       THEN 'PENDING CLOSE'
        WHEN l_books(i).sla_unlinked_lines > 0                  THEN 'POSTING COVERAGE REVIEW'
        WHEN l_books(i).fa_summary_rows = 0                     THEN 'NO FA DATA'
        WHEN l_fa_vs_gl_exp_diff IS NULL                        THEN 'NO POSTED EXPENSE'
        WHEN l_fa_vs_gl_exp_diff <> 0
          OR ROUND(l_books(i).fa_deprn_amount - NVL(l_books(i).sla_expense_net, 0), 2) <> 0 THEN 'DIFFERENCE'
        ELSE 'MATCHED'
      END;

      PIPE ROW(xxme_fa_close_status_row_ot(
        l_books(i).ledger_id,
        l_books(i).ledger_name,
        l_books(i).currency_code,
        l_books(i).book_type_code,
        l_books(i).book_class,
        l_books(i).deprn_calendar,
        l_books(i).period_name,
        l_books(i).period_status,
        l_books(i).period_close_date,
        l_books(i).deprn_run,
        l_books(i).fa_summary_rows,
        l_books(i).fa_nonzero_rows,
        l_books(i).fa_deprn_amount,
        l_books(i).fa_catchup_amount,
        l_books(i).fa_positive_deprn,
        l_books(i).fa_negative_deprn,
        l_books(i).deprn_events,
        l_books(i).unaccounted_events,
        l_books(i).entries_not_final,
        l_books(i).entries_not_transferred,
        l_books(i).gl_groups_expected,
        l_books(i).gl_groups_missing,
        l_books(i).gl_shared_groups,
        l_books(i).gl_journals,
        l_books(i).gl_unposted,
        CASE WHEN l_books(i).has_gl_dr THEN l_books(i).gl_journal_dr_total END,
        l_fa_vs_gl_dr_diff,
        l_books(i).gl_batch_names,
        l_activity_note,
        l_close_status,
        l_books(i).sla_expense_dr,
        l_books(i).sla_expense_cr,
        l_books(i).sla_expense_net,
        l_books(i).sla_expense_lines,
        l_books(i).orphan_asset_lines,
        l_books(i).sla_period_mismatch_lines,
        l_books(i).sla_unlinked_lines,
        l_gl_post_dr,
        l_gl_post_cr,
        l_gl_post_net,
        l_books(i).gl_line_count,
        l_books(i).gl_mapping_issues,
        l_books(i).gl_posted_expense_lines,
        l_fa_vs_gl_exp_diff,
        l_recon_status
      ));
    END LOOP;
    RETURN;
  EXCEPTION
    WHEN NO_DATA_NEEDED THEN
      close_rc;
      RETURN;
    WHEN OTHERS THEN
      close_rc;
      RAISE;
  END get_close_status;

  PROCEDURE render_bridge (
    p_ledger_id      IN NUMBER,
    p_book_type_code IN VARCHAR2,
    p_period_name    IN VARCHAR2,
    p_db_link        IN VARCHAR2 DEFAULT 'ADG'
  ) IS
    FUNCTION f (v IN NUMBER) RETURN VARCHAR2 IS
    BEGIN
      RETURN CASE WHEN v IS NULL THEN '&mdash;' ELSE TO_CHAR(v, 'FM999G999G999G999G990D00') END;
    END f;

    PROCEDURE stage (
      label IN VARCHAR2,
      dr    IN NUMBER,
      cr    IN NUMBER,
      net   IN NUMBER
    ) IS
    BEGIN
      sys.htp.p(
        '<tr><th scope="row">' || apex_escape.html(label) ||
        '</th><td>' || f(dr) ||
        '</td><td>' || f(cr) ||
        '</td><td>' || f(net) || '</td></tr>'
      );
    END stage;
  BEGIN
    IF p_ledger_id IS NULL OR p_book_type_code IS NULL THEN
      RETURN;
    END IF;

    FOR r IN (
      SELECT *
        FROM TABLE(get_close_status(
          p_period_name    => p_period_name,
          p_ledgers        => TO_CHAR(p_ledger_id),
          p_book_class     => NULL,
          p_book_type_code => p_book_type_code,
          p_db_link        => p_db_link
        ))
       WHERE ledger_id = p_ledger_id
         AND book_type_code = p_book_type_code
    ) LOOP
      sys.htp.p(
        '<div class="fa72-context"><h2>' || apex_escape.html(r.book_type_code) ||
        ' &middot; ' || apex_escape.html(r.period_name) || '</h2><p>' ||
        apex_escape.html(r.ledger_name) || ' &middot; ' || apex_escape.html(r.currency_code) ||
        ' &middot; Close status: ' || apex_escape.html(r.close_status) || '</p>'
      );
      sys.htp.p(
        '<span class="fa72-status ' ||
        CASE WHEN r.reconciliation_status = 'MATCHED' THEN 'fa72-good' ELSE 'fa72-warn' END ||
        '">' || apex_escape.html(r.reconciliation_status) || '</span>'
      );
      sys.htp.p(
        '<table class="fa72-stage" aria-label="FA to SLA to GL amount bridge">' ||
        '<thead><tr><th>Stage</th><th>Positive / Debit</th><th>Negative / Credit</th><th>Net amount</th></tr></thead><tbody>'
      );
      stage('FA depreciation excluding catch-up', r.fa_positive_deprn, ABS(r.fa_negative_deprn), r.fa_deprn_amount);
      stage('Final SLA depreciation expense',     r.sla_expense_dr,    r.sla_expense_cr,         r.sla_expense_net);
      stage('Posted GL depreciation expense',     r.gl_posted_expense_dr, r.gl_posted_expense_cr, r.gl_posted_expense_net);
      stage('FA minus posted GL expense',         NULL,              NULL,                     r.fa_vs_gl_expense_diff);
      sys.htp.p('</tbody></table>');

      IF r.reconciliation_status = 'MATCHED'
         AND NVL(r.fa_negative_deprn, 0) < 0
         AND ROUND(r.fa_vs_gl_dr_diff - 2 * r.fa_negative_deprn, 2) = 0
         AND r.gl_shared_groups = 0
      THEN
        sys.htp.p(
          '<p><strong>Explained: negative depreciation.</strong> Negative depreciation totals ' ||
          f(r.fa_negative_deprn) || ' ' || apex_escape.html(r.currency_code) ||
          '. It credits expense and debits the asset reserve. The whole-journal debit total of ' ||
          f(r.gl_journal_dr_total) || ' therefore exceeds net FA depreciation by ' ||
          f(-r.fa_vs_gl_dr_diff) || '. The net expense comparison above matches.</p>'
        );
      END IF;

      sys.htp.p(
        '<p class="fa72-subtle">FA catch-up excluded from this depreciation bridge: ' || f(r.fa_catchup_amount) ||
        '. GL lines inspected: ' || r.gl_line_count ||
        '; mapping issues: ' || r.gl_mapping_issues ||
        '; SLA expense lines without an FA asset row: ' || r.orphan_asset_lines ||
        '; expense lines not linked to posted GL: ' || r.sla_unlinked_lines ||
        '; accounting-period mismatches: ' || r.sla_period_mismatch_lines || '.</p>'
      );

      IF r.gl_mapping_issues > 0
         OR r.orphan_asset_lines > 0
         OR r.sla_unlinked_lines > 0
         OR r.sla_period_mismatch_lines > 0
      THEN
        sys.htp.p(
          '<p class="fa72-status fa72-warn">Review the unmapped, shared, unposted, or period-mismatched entries below. ' ||
          'A complete reconciliation cannot be established.</p>'
        );
      END IF;

      sys.htp.p(
        '<p class="fa72-subtle">GL journals can summarize multiple assets. Asset amounts below show SLA expense ' ||
        'linked to posted GL; actual GL line totals are listed separately. Negative asset costs require a separate business review.</p></div>'
      );
    END LOOP;
  END render_bridge;

  FUNCTION get_asset_details (
    p_ledger_id      IN NUMBER,
    p_book_type_code IN VARCHAR2,
    p_period_name    IN VARCHAR2,
    p_db_link        IN VARCHAR2 DEFAULT 'ADG'
  ) RETURN xxme_fa_asset_dtl_row_nt PIPELINED IS
    l_db_link VARCHAR2(30) := xxme_db_source_pkg.normalize_db_link(p_db_link);
    l_book    VARCHAR2(30) := UPPER(TRIM(p_book_type_code));
    l_period  VARCHAR2(30) := UPPER(TRIM(p_period_name));
    l_sql     CLOB;
    l_rc      SYS_REFCURSOR;
    l_open    BOOLEAN := FALSE;

    TYPE t_num_tab  IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    TYPE t_date_tab IS TABLE OF DATE INDEX BY PLS_INTEGER;
    TYPE t_v30_tab  IS TABLE OF VARCHAR2(30) INDEX BY PLS_INTEGER;
    TYPE t_v50_tab  IS TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
    TYPE t_v100_tab IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;

    l_ledger_id           t_num_tab;
    l_book_type_code      t_v30_tab;
    l_period_name         t_v30_tab;
    l_asset_id            t_num_tab;
    l_asset_number        t_v100_tab;
    l_deprn_run_date      t_date_tab;
    l_fa_deprn_amount     t_num_tab;
    l_fa_catchup_amount   t_num_tab;
    l_positive_deprn      t_num_tab;
    l_negative_deprn      t_num_tab;
    l_activity_type       t_v50_tab;
    l_sla_exp_dr          t_num_tab;
    l_sla_exp_cr          t_num_tab;
    l_sla_exp_net         t_num_tab;
    l_posted_linked_net   t_num_tab;
    l_fa_sla_diff         t_num_tab;
    l_sla_posted_diff     t_num_tab;
    l_sla_exp_lines       t_num_tab;
    l_sla_mismatch        t_num_tab;
    l_posted_linked_lines t_num_tab;
    l_unlinked_lines      t_num_tab;
  BEGIN
    IF p_ledger_id IS NULL
       OR p_ledger_id NOT IN (1003, 5001, 10001)
       OR l_book IS NULL
       OR l_period IS NULL
    THEN
      RETURN;
    END IF;

    -- Keep ad (fa_additions_b@ADG) in outermost FROM so DRIVING_SITE(ad) drives full remote execution (Trap B).
    l_sql := REPLACE(q'~SELECT /*+ DRIVING_SITE(ad) NO_MERGE(a) NO_MERGE(s) */
       a.ledger_id,
       a.book_type_code,
       a.period_name,
       a.asset_id,
       ad.asset_number,
       a.deprn_run_date,
       a.fa_deprn_amount,
       a.fa_catchup_amount,
       CASE WHEN a.fa_deprn_amount > 0 THEN a.fa_deprn_amount ELSE 0 END AS positive_deprn,
       CASE WHEN a.fa_deprn_amount < 0 THEN a.fa_deprn_amount ELSE 0 END AS negative_deprn,
       CASE
         WHEN a.fa_deprn_amount < 0 THEN 'NEGATIVE DEPRECIATION'
         WHEN a.fa_deprn_amount > 0 THEN 'POSITIVE DEPRECIATION'
         ELSE 'ZERO DEPRECIATION'
       END AS activity_type,
       NVL(s.sla_expense_dr, 0) AS sla_expense_dr,
       NVL(s.sla_expense_cr, 0) AS sla_expense_cr,
       NVL(s.sla_expense_net, 0) AS sla_expense_net,
       NVL(s.posted_linked_sla_net, 0) AS posted_linked_sla_net,
       a.fa_deprn_amount - NVL(s.sla_expense_net, 0) AS fa_sla_difference,
       NVL(s.sla_expense_net, 0) - NVL(s.posted_linked_sla_net, 0) AS sla_posted_link_difference,
       NVL(s.sla_expense_lines, 0) AS sla_expense_lines,
       NVL(s.sla_period_mismatch_lines, 0) AS sla_period_mismatch_lines,
       NVL(s.posted_linked_lines, 0) AS posted_linked_lines,
       NVL(s.sla_expense_lines, 0) - NVL(s.posted_linked_lines, 0) AS unlinked_expense_lines
  FROM (SELECT bc.set_of_books_id AS ledger_id,
               ds.book_type_code,
               dp.period_name,
               ds.asset_id,
               MAX(ds.deprn_run_date) AS deprn_run_date,
               SUM(ds.deprn_amount - NVL(ds.deprn_adjustment_amount, 0)) AS fa_deprn_amount,
               SUM(NVL(ds.deprn_adjustment_amount, 0)) AS fa_catchup_amount
          FROM apps.fa_book_controls@ADG bc,
               apps.fa_deprn_periods@ADG dp,
               apps.fa_deprn_summary@ADG ds
         WHERE bc.set_of_books_id IN (1003, 5001, 10001)
           AND bc.set_of_books_id  = :b_ledger_id
           AND bc.book_type_code   = :b_book
           AND bc.date_ineffective IS NULL
           AND dp.book_type_code   = bc.book_type_code
           AND dp.period_name      = :b_period
           AND ds.book_type_code   = dp.book_type_code
           AND ds.period_counter   = dp.period_counter
           AND ds.deprn_source_code = 'DEPRN'
         GROUP BY bc.set_of_books_id, ds.book_type_code, dp.period_name, ds.asset_id) a,
       (SELECT q.ledger_id,
               q.book_type_code,
               q.asset_id,
               COUNT(*) AS sla_expense_lines,
               SUM(q.sla_period_mismatch) AS sla_period_mismatch_lines,
               SUM(q.accounted_dr) AS sla_expense_dr,
               SUM(q.accounted_cr) AS sla_expense_cr,
               SUM(q.accounted_dr - q.accounted_cr) AS sla_expense_net,
               SUM(q.posted_link) AS posted_linked_lines,
               SUM(CASE WHEN q.posted_link = 1 THEN q.accounted_dr - q.accounted_cr ELSE 0 END) AS posted_linked_sla_net
          FROM (SELECT te.ledger_id,
                       te.source_id_char_1 AS book_type_code,
                       te.source_id_int_1  AS asset_id,
                       CASE WHEN ah.period_name = dp.period_name THEN 0 ELSE 1 END AS sla_period_mismatch,
                       al.accounted_dr,
                       al.accounted_cr,
                       CASE WHEN EXISTS
                         (SELECT 1
                            FROM apps.gl_import_references@ADG ir,
                                 apps.gl_je_lines@ADG           jl,
                                 apps.gl_je_headers@ADG         jh
                           WHERE ir.gl_sl_link_id    = al.gl_sl_link_id
                             AND ir.gl_sl_link_table = al.gl_sl_link_table
                             AND jl.je_header_id     = ir.je_header_id
                             AND jl.je_line_num      = ir.je_line_num
                             AND jh.je_header_id     = jl.je_header_id
                             AND jh.ledger_id        = te.ledger_id
                             AND jh.period_name      = :b_period
                             AND jh.je_source        = 'Assets'
                             AND jh.je_category      = 'Depreciation'
                             AND jh.actual_flag      = 'A'
                             AND jh.status           = 'P') THEN 1 ELSE 0 END AS posted_link
                  FROM apps.fa_book_controls@ADG bc,
                       apps.fa_deprn_periods@ADG dp,
                       apps.xla_transaction_entities@ADG te,
                       apps.xla_ae_headers@ADG ah,
                       (SELECT application_id, ae_header_id, ae_line_num,
                               NVL(accounted_dr, 0) AS accounted_dr,
                               NVL(accounted_cr, 0) AS accounted_cr,
                               gl_sl_link_id, gl_sl_link_table
                          FROM apps.xla_ae_lines@ADG
                         WHERE application_id = 140
                           AND accounting_class_code = 'EXPENSE') al
                 WHERE bc.set_of_books_id IN (1003, 5001, 10001)
                   AND bc.set_of_books_id  = :b_ledger_id
                   AND bc.book_type_code   = :b_book
                   AND bc.date_ineffective IS NULL
                   AND dp.book_type_code   = bc.book_type_code
                   AND dp.period_name      = :b_period
                   AND te.application_id   = 140
                   AND te.ledger_id        = bc.set_of_books_id
                   AND te.entity_code      = 'DEPRECIATION'
                   AND te.source_id_char_1 = dp.book_type_code
                   AND te.source_id_int_2  = dp.period_counter
                   AND ah.application_id   = te.application_id
                   AND ah.entity_id        = te.entity_id
                   AND ah.ledger_id        = te.ledger_id
                   AND ah.accounting_entry_status_code = 'F'
                   AND al.application_id   = ah.application_id
                   AND al.ae_header_id     = ah.ae_header_id) q
         GROUP BY q.ledger_id, q.book_type_code, q.asset_id) s,
       apps.fa_additions_b@ADG ad
 WHERE ad.asset_id       (+) = a.asset_id
   AND s.ledger_id       (+) = a.ledger_id
   AND s.book_type_code  (+) = a.book_type_code
   AND s.asset_id        (+) = a.asset_id
 ORDER BY CASE WHEN a.fa_deprn_amount < 0 THEN 0 ELSE 1 END,
          a.fa_deprn_amount, ad.asset_number, a.asset_id~', '@ADG', '@' || l_db_link);

    OPEN l_rc FOR l_sql USING
      p_ledger_id, l_book, l_period,
      l_period, p_ledger_id, l_book, l_period;
    l_open := TRUE;

    LOOP
      FETCH l_rc BULK COLLECT INTO
        l_ledger_id, l_book_type_code, l_period_name, l_asset_id, l_asset_number,
        l_deprn_run_date, l_fa_deprn_amount, l_fa_catchup_amount, l_positive_deprn,
        l_negative_deprn, l_activity_type, l_sla_exp_dr, l_sla_exp_cr, l_sla_exp_net,
        l_posted_linked_net, l_fa_sla_diff, l_sla_posted_diff, l_sla_exp_lines,
        l_sla_mismatch, l_posted_linked_lines, l_unlinked_lines
      LIMIT c_fetch_limit;

      EXIT WHEN l_asset_id.COUNT = 0;

      FOR i IN 1 .. l_asset_id.COUNT LOOP
        PIPE ROW(xxme_fa_asset_dtl_row_ot(
          l_ledger_id(i), l_book_type_code(i), l_period_name(i), l_asset_id(i),
          l_asset_number(i), l_deprn_run_date(i), l_fa_deprn_amount(i), l_fa_catchup_amount(i),
          l_positive_deprn(i), l_negative_deprn(i), l_activity_type(i), l_sla_exp_dr(i),
          l_sla_exp_cr(i), l_sla_exp_net(i), l_posted_linked_net(i), l_fa_sla_diff(i),
          l_sla_posted_diff(i), l_sla_exp_lines(i), l_sla_mismatch(i),
          l_posted_linked_lines(i), l_unlinked_lines(i)
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
  END get_asset_details;

  FUNCTION get_gl_lines (
    p_ledger_id      IN NUMBER,
    p_book_type_code IN VARCHAR2,
    p_period_name    IN VARCHAR2,
    p_db_link        IN VARCHAR2 DEFAULT 'ADG'
  ) RETURN xxme_fa_gl_line_row_nt PIPELINED IS
    l_db_link VARCHAR2(30) := xxme_db_source_pkg.normalize_db_link(p_db_link);
    l_book    VARCHAR2(30) := UPPER(TRIM(p_book_type_code));
    l_period  VARCHAR2(30) := UPPER(TRIM(p_period_name));
    l_sql     CLOB;
    l_rc      SYS_REFCURSOR;
    l_open    BOOLEAN := FALSE;

    TYPE t_num_tab   IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    TYPE t_v30_tab   IS TABLE OF VARCHAR2(30) INDEX BY PLS_INTEGER;
    TYPE t_v240_tab  IS TABLE OF VARCHAR2(240) INDEX BY PLS_INTEGER;
    TYPE t_v4000_tab IS TABLE OF VARCHAR2(4000) INDEX BY PLS_INTEGER;

    l_ledger_id      t_num_tab;
    l_book_type_code t_v30_tab;
    l_period_name    t_v30_tab;
    l_je_header_id   t_num_tab;
    l_journal_name   t_v240_tab;
    l_batch_name     t_v240_tab;
    l_status         t_v30_tab;
    l_je_line_num    t_num_tab;
    l_ccid           t_num_tab;
    l_accounted_dr   t_num_tab;
    l_accounted_cr   t_num_tab;
    l_acct_class     t_v30_tab;
    l_mapping_status t_v30_tab;
    l_account_code   t_v4000_tab;
  BEGIN
    IF l_period IS NULL THEN
      RETURN;
    END IF;

    -- Inline fa_gl_headers and outer-join gl_code_combinations_kfv with DRIVING_SITE(jl) (zero WITH CTE binds over @ADG).
    l_sql := REPLACE(q'~SELECT /*+ DRIVING_SITE(jl) NO_MERGE(j) NO_MERGE(m) NO_PUSH_PRED(m) */
       j.ledger_id,
       j.book_type_code,
       j.period_name,
       j.je_header_id,
       j.journal_name,
       j.batch_name,
       j.status,
       jl.je_line_num,
       jl.code_combination_id,
       NVL(jl.accounted_dr, 0) AS accounted_dr,
       NVL(jl.accounted_cr, 0) AS accounted_cr,
       m.accounting_class_code,
       CASE
         WHEN m.reference_rows IS NOT NULL
          AND m.unresolved_refs = 0
          AND m.class_count     = 1
          AND m.book_count      = 1
          AND m.period_count    = 1
          AND m.ledger_count    = 1
          AND m.min_application = 140
          AND m.max_application = 140
          AND m.min_entity      = 'DEPRECIATION'
          AND m.max_entity      = 'DEPRECIATION'
          AND m.ledger_id       = j.ledger_id
          AND m.book_type_code  = j.book_type_code
          AND m.period_counter  = j.period_counter
         THEN 'MAPPED'
         ELSE 'REVIEW MAPPING'
       END AS mapping_status,
       cc.concatenated_segments AS account_code
  FROM (SELECT /*+ NO_MERGE */ DISTINCT
               te.ledger_id,
               te.source_id_char_1 AS book_type_code,
               dp.period_name,
               dp.period_counter,
               h.je_header_id,
               h.name AS journal_name,
               h.status,
               b.name AS batch_name,
               b.je_batch_id
          FROM apps.fa_book_controls@ADG bc,
               apps.fa_deprn_periods@ADG dp,
               apps.xla_transaction_entities@ADG te,
               apps.xla_ae_headers@ADG ah,
               apps.gl_je_batches@ADG b,
               apps.gl_je_headers@ADG h
         WHERE bc.set_of_books_id IN (1003, 5001, 10001)
           AND bc.date_ineffective IS NULL
           AND (:b01 IS NULL OR bc.set_of_books_id = :b02)
           AND (:b03 IS NULL OR bc.book_type_code  = :b04)
           AND dp.book_type_code = bc.book_type_code
           AND dp.period_name    = :b05
           AND te.application_id = 140
           AND te.entity_code    = 'DEPRECIATION'
           AND te.ledger_id      = bc.set_of_books_id
           AND te.source_id_char_1 = bc.book_type_code
           AND te.source_id_int_2  = dp.period_counter
           AND ah.application_id = te.application_id
           AND ah.entity_id      = te.entity_id
           AND ah.ledger_id      = te.ledger_id
           AND ah.accounting_entry_status_code = 'F'
           AND ah.group_id IS NOT NULL
           AND ah.gl_transfer_status_code = 'Y'
           AND b.group_id    = ah.group_id
           AND h.je_batch_id = b.je_batch_id
           AND h.ledger_id   = te.ledger_id
           AND h.je_source   = 'Assets'
           AND h.je_category = 'Depreciation'
           AND h.actual_flag = 'A'
           AND h.period_name = dp.period_name) j
  JOIN apps.gl_je_lines@ADG jl
    ON jl.je_header_id = j.je_header_id
  LEFT JOIN (SELECT /*+ NO_MERGE */
                    ir.je_header_id,
                    ir.je_line_num,
                    COUNT(*) AS reference_rows,
                    COUNT(CASE WHEN xl.ae_header_id IS NULL OR te.entity_id IS NULL THEN 1 END) AS unresolved_refs,
                    COUNT(DISTINCT xl.accounting_class_code) AS class_count,
                    MIN(xl.accounting_class_code) AS accounting_class_code,
                    COUNT(DISTINCT te.source_id_char_1) AS book_count,
                    MIN(te.source_id_char_1) AS book_type_code,
                    COUNT(DISTINCT te.source_id_int_2) AS period_count,
                    MIN(te.source_id_int_2) AS period_counter,
                    COUNT(DISTINCT te.ledger_id) AS ledger_count,
                    MIN(te.ledger_id) AS ledger_id,
                    MIN(te.application_id) AS min_application,
                    MAX(te.application_id) AS max_application,
                    MIN(te.entity_code) AS min_entity,
                    MAX(te.entity_code) AS max_entity
               FROM apps.gl_import_references@ADG ir,
                    apps.xla_ae_lines@ADG xl,
                    apps.xla_ae_headers@ADG ah,
                    apps.xla_transaction_entities@ADG te
              WHERE EXISTS (
                      SELECT 1
                        FROM (SELECT DISTINCT
                                     h.je_header_id
                                FROM apps.fa_book_controls@ADG bc_sj,
                                     apps.fa_deprn_periods@ADG dp,
                                     apps.xla_transaction_entities@ADG te,
                                     apps.xla_ae_headers@ADG ah,
                                     apps.gl_je_batches@ADG b,
                                     apps.gl_je_headers@ADG h
                               WHERE bc_sj.set_of_books_id IN (1003, 5001, 10001)
                                 AND bc_sj.date_ineffective IS NULL
                                 AND (:b06 IS NULL OR bc_sj.set_of_books_id = :b07)
                                 AND (:b08 IS NULL OR bc_sj.book_type_code  = :b09)
                                 AND dp.book_type_code = bc_sj.book_type_code
                                 AND dp.period_name    = :b10
                                 AND te.application_id = 140
                                 AND te.entity_code    = 'DEPRECIATION'
                                 AND te.ledger_id      = bc_sj.set_of_books_id
                                 AND te.source_id_char_1 = bc_sj.book_type_code
                                 AND te.source_id_int_2  = dp.period_counter
                                 AND ah.application_id = te.application_id
                                 AND ah.entity_id      = te.entity_id
                                 AND ah.ledger_id      = te.ledger_id
                                 AND ah.accounting_entry_status_code = 'F'
                                 AND ah.group_id IS NOT NULL
                                 AND ah.gl_transfer_status_code = 'Y'
                                 AND b.group_id    = ah.group_id
                                 AND h.je_batch_id = b.je_batch_id
                                 AND h.ledger_id   = te.ledger_id
                                 AND h.je_source   = 'Assets'
                                 AND h.je_category = 'Depreciation'
                                 AND h.actual_flag = 'A'
                                 AND h.period_name = dp.period_name) sj
                       WHERE sj.je_header_id = ir.je_header_id)
                AND xl.gl_sl_link_id    (+) = ir.gl_sl_link_id
                AND xl.gl_sl_link_table (+) = ir.gl_sl_link_table
                AND ah.application_id   (+) = xl.application_id
                AND ah.ae_header_id     (+) = xl.ae_header_id
                AND te.application_id   (+) = ah.application_id
                AND te.entity_id        (+) = ah.entity_id
              GROUP BY ir.je_header_id, ir.je_line_num) m
    ON m.je_header_id = jl.je_header_id
   AND m.je_line_num  = jl.je_line_num
  LEFT JOIN apps.gl_code_combinations_kfv@ADG cc
    ON cc.code_combination_id = jl.code_combination_id
 ORDER BY j.je_header_id, jl.je_line_num~', '@ADG', '@' || l_db_link);

    OPEN l_rc FOR l_sql USING
      p_ledger_id, p_ledger_id, l_book, l_book, l_period,
      p_ledger_id, p_ledger_id, l_book, l_book, l_period;
    l_open := TRUE;

    LOOP
      FETCH l_rc BULK COLLECT INTO
        l_ledger_id, l_book_type_code, l_period_name, l_je_header_id, l_journal_name,
        l_batch_name, l_status, l_je_line_num, l_ccid, l_accounted_dr, l_accounted_cr,
        l_acct_class, l_mapping_status, l_account_code
      LIMIT c_fetch_limit;

      EXIT WHEN l_je_header_id.COUNT = 0;

      FOR i IN 1 .. l_je_header_id.COUNT LOOP
        PIPE ROW(xxme_fa_gl_line_row_ot(
          l_ledger_id(i), l_book_type_code(i), l_period_name(i), l_je_header_id(i),
          l_journal_name(i), l_batch_name(i), l_status(i), l_je_line_num(i),
          l_ccid(i), l_accounted_dr(i), l_accounted_cr(i), l_acct_class(i),
          l_mapping_status(i), l_account_code(i)
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
  END get_gl_lines;

END xxme_fa_close_pkg;
/
