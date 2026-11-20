prompt --application/set_environment
set define off verify off feedback off
set autocommit off
begin
  if user <> 'GL_ACCOUNTS' or sys_context('USERENV', 'CURRENT_SCHEMA') <> 'GL_ACCOUNTS' then
    raise_application_error(-20997, 'ABORT: Wave 2 APEX patch must run as GL_ACCOUNTS, got ' || user);
  end if;
end;
/
whenever sqlerror continue none
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run this script using a SQL client connected to the database as
-- the owner (parsing schema) of the application or as a database user with the
-- APEX_ADMINISTRATOR_ROLE role.
--
-- This export file has been automatically generated. Modifying this file is not
-- supported by Oracle and can lead to unexpected application and/or instance
-- behavior now or in the future.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
apex_application_install.clear_all;
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2026.04.07'
,p_release=>'26.2.0'
,p_default_workspace_id=>100789
,p_default_application_id=>128
,p_default_id_offset=>9401733729708713
,p_default_owner=>'GL_ACCOUNTS'
);
if wwv_flow.g_flow_id <> 128 then
  apex_application_install.clear_all;
  raise_application_error(-20999, 'Unexpected g_flow_id=' || nvl(to_char(wwv_flow.g_flow_id), 'NULL'));
end if;
end;
/
 
prompt APPLICATION 128 - TMS GBS Control Tower (Working Copy: TMS GBS Control Tower Enhancements)
--
-- Application Export:
--   Application:     128
--   Name:            TMS GBS Control Tower (Working Copy: TMS GBS Control Tower Enhancements)
--   Date and Time:   04:27 Friday November 20, 2026
--   Exported By:     GL_ACCOUNTS
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PAGE: 60
--     PAGE: 61
--     PAGE: 70
--     PAGE: 71
--     PAGE: 72
--   Manifest End
--   Version:         26.2.0
--   Instance ID:     649767868204930
--

begin
  -- replace components
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/
prompt --application/pages/delete_00060
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>60);
end;
/
prompt --application/pages/page_00060
begin
wwv_flow_imp_page.create_page(
 p_id=>60
,p_name=>'Period Status'
,p_alias=>'PERIOD-STATUS'
,p_step_title=>'Period Status'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(function ($) {',
'  var ledgerId = apex.item("P60_INV_LEDGER_ID").getValue();',
'  var ledgerNames = {"1003":"TEREX US", "5001":"TEREX UK 120", "10001":"TEREX CH"};',
'  if (!ledgerNames[ledgerId]) { return; }',
'  var monthName = $("#P60_MONTH_OFFSET option:selected").text();',
'  $("#R1286062000000008_heading").text("Inventory Organizations - " + ledgerNames[ledgerId] + " - " + monthName);',
'  $("#R1286062000000008").show();',
'  window.setTimeout(function () {',
'    document.getElementById("R1286062000000008").scrollIntoView({behavior:"auto", block:"start"});',
'  }, 0);',
'})(apex.jQuery);'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.xxme-period-status {',
'  display: inline-flex;',
'  align-items: center;',
'  justify-content: center;',
'  min-width: 132px;',
'  min-height: 30px;',
'  padding: 5px 12px;',
'  border-radius: 16px;',
'  color: #fff;',
'  font-weight: 700;',
'  line-height: 1.2;',
'  text-align: center;',
'}',
'.xxme-period-status-OPEN { background-color: #2e7d32; }',
'.xxme-period-status-CLOSED { background-color: #455a64; }',
'.xxme-period-status-PERMANENT { background-color: #263238; }',
'.xxme-period-status-FUTURE { background-color: #287c96; }',
'.xxme-period-status-NEVER { background-color: #8a6d3b; }',
'.xxme-period-status-MIXED { background-color: #6a4c93; }',
'.xxme-period-status-UNKNOWN { background-color: #c62828; }',
'.xxme-inventory-drill {',
'  border: 0;',
'  background: transparent;',
'  padding: 0;',
'  cursor: pointer;',
'  font: inherit;',
'}',
'.xxme-inventory-drill:hover .xxme-period-status,',
'.xxme-inventory-drill:focus .xxme-period-status {',
'  box-shadow: 0 0 0 3px rgba(0, 112, 173, .22);',
'}',
'.p60-pending-count {',
'  font-weight: 700;',
'  text-decoration: underline;',
'}',
'#R1286062000000008 {',
'  display: none;',
'  margin-top: 16px;',
'}',
'#R1286062000000008 .t-Report-cell:nth-child(5) {',
'  text-align: right;',
'  font-weight: 700;',
'}',
'#period-status-report .t-Report-report {',
'  table-layout: fixed;',
'  width: 100%;',
'}',
'#period-status-report .t-Report-colHead {',
'  text-align: center;',
'  vertical-align: bottom;',
'}',
'#period-status-report .t-Report-cell {',
'  padding-top: 12px;',
'  padding-bottom: 12px;',
'}',
'#period-status-report .t-Report-report th:first-child,',
'#period-status-report .t-Report-report td:first-child {',
'  width: 22%;',
'  text-align: left;',
'  font-weight: 700;',
'}',
'#period-status-report .t-Report-report td:not(:first-child) {',
'  text-align: center;',
'}',
'',
'/* Approved Page 60 palette. Scoped to the two reports; native appearance preference controls mode. */',
':is(#R1286062000000003, #R1286062000000008) {',
'  --p60-text: #30313b;',
'  --p60-line: #e4e2ec;',
'  --p60-row-odd: #ffffff;',
'  --p60-row-even: #f8f7fb;',
'  --p60-header: #f0edf7;',
'  --p60-header-text: #484058;',
'  --p60-accent: #5c47a3;',
'  --p60-open-bg: #eee8f9; --p60-open-text: #58418f;',
'  --p60-closed-bg: #edf0f4; --p60-closed-text: #4b5769;',
'  --p60-permanent-bg: #dfe4eb; --p60-permanent-text: #39465a;',
'  --p60-never-bg: #f4eddf; --p60-never-text: #806132;',
'  --p60-future-bg: #e8eef6; --p60-future-text: #425f84;',
'  --p60-error-bg: #f9e8eb; --p60-error-text: #a43d53;',
'  --p60-panel: #ffffff;',
'}',
'body.tms-dark-mode :is(#R1286062000000003, #R1286062000000008) {',
'  --p60-text: #f0f3f9;',
'  --p60-line: #465268;',
'  --p60-row-odd: #2a3343;',
'  --p60-row-even: #303c4f;',
'  --p60-header: #384458;',
'  --p60-header-text: #e2e8f3;',
'  --p60-accent: #bca7ee;',
'  --p60-open-bg: #51416f; --p60-open-text: #f4ebff;',
'  --p60-closed-bg: #465468; --p60-closed-text: #f1f5fb;',
'  --p60-permanent-bg: #3a485c; --p60-permanent-text: #f1f5fb;',
'  --p60-never-bg: #58482d; --p60-never-text: #ffe0a5;',
'  --p60-future-bg: #293c51; --p60-future-text: #bdd4ee;',
'  --p60-error-bg: #4e2934; --p60-error-text: #ffc1cf;',
'  --p60-panel: #2b3443;',
'}',
':is(#R1286062000000003, #R1286062000000008) .t-Report-report {',
'  background: var(--p60-panel);',
'  color: var(--p60-text);',
'}',
':is(#R1286062000000003, #R1286062000000008) .t-Report-report th {',
'  background: var(--p60-header) !important;',
'  color: var(--p60-header-text) !important;',
'  border-color: var(--p60-line) !important;',
'}',
':is(#R1286062000000003, #R1286062000000008) .t-Report-report td {',
'  background: var(--p60-row-odd);',
'  color: var(--p60-text);',
'  border-color: var(--p60-line);',
'}',
':is(#R1286062000000003, #R1286062000000008) .t-Report-report tr:nth-child(even) td {',
'  background: var(--p60-row-even);',
'}',
':is(#R1286062000000003, #R1286062000000008) .xxme-period-status {',
'  border: 1px solid transparent;',
'  color: var(--p60-text);',
'}',
':is(#R1286062000000003, #R1286062000000008) .xxme-period-status-OPEN {',
'  background: var(--p60-open-bg); color: var(--p60-open-text);',
'}',
':is(#R1286062000000003, #R1286062000000008) .xxme-period-status-CLOSED {',
'  background: var(--p60-closed-bg); color: var(--p60-closed-text);',
'}',
':is(#R1286062000000003, #R1286062000000008) .xxme-period-status-PERMANENT {',
'  background: var(--p60-permanent-bg); color: var(--p60-permanent-text);',
'}',
':is(#R1286062000000003, #R1286062000000008) .xxme-period-status-NEVER {',
'  background: var(--p60-never-bg); color: var(--p60-never-text);',
'}',
':is(#R1286062000000003, #R1286062000000008) .xxme-period-status-FUTURE {',
'  background: var(--p60-future-bg); color: var(--p60-future-text);',
'}',
':is(#R1286062000000003, #R1286062000000008) .xxme-period-status-UNKNOWN {',
'  background: var(--p60-error-bg); color: var(--p60-error-text);',
'}',
':is(#R1286062000000003, #R1286062000000008) .xxme-period-status-MIXED {',
'  background: var(--p60-panel); color: var(--p60-accent); border-color: var(--p60-accent);',
'}',
':is(#R1286062000000003, #R1286062000000008) a.p60-pending-count {',
'  color: var(--p60-accent);',
'}',
'#R1286062000000003 .xxme-inventory-drill:focus-visible {',
'  outline: 2px solid var(--p60-accent); outline-offset: 3px; border-radius: 16px;',
'}'))
,p_step_template=>4075783602716660119
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(18558063129193156)
,p_protection_level=>'C'
,p_page_component_map=>'03'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1286062000000001)
,p_plug_name=>'Breadcrumb'
,p_static_id=>'breadcrumb'
,p_title=>'Period Status'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2534890969069732905
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_menu_id=>wwv_flow_imp.id(199435849224420349)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4075790987805660140
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(1286062000000008)
,p_name=>'Inventory Organization Details'
,p_static_id=>'inventory-org-drilldown'
,p_title=>'Inventory Organization Details'
,p_template=>2103954283454391425
,p_display_sequence=>30
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- App128 Page60 inventory details. Generated by sql/build_pending.js.',
'-- Required = selected calendar month intersect selected OAP dates; null dates excluded.',
'select d.organization_code, d.organization_name, d.operating_unit,',
'  ''<span class="xxme-period-status xxme-period-status-''||d.css||''">''||apex_escape.html(d.status)||''</span>'' period_status,',
'  case when d.acct_period_id is null then ''&mdash;''',
'    when d.pending>0 then ''<a class="p60-pending-count" href="''||',
'      apex_escape.html_attribute(apex_page.get_url(',
'        p_page=>62,p_clear_cache=>''62'',',
'        p_items=>''P62_PERIOD_NAME,P62_ORG_ID,P62_ORG_NAME,P62_MONTH_OFFSET,P62_LEDGER_ID'',',
'        p_values=>d.period_name||'',''||d.organization_id||'',\''||d.organization_name||''\,''||nvl(:P60_MONTH_OFFSET,''0'')||'',''||d.ledger_id))||',
'      ''" aria-label="Show ''||d.pending||'' pending transactions for ''||apex_escape.html_attribute(d.organization_name)||'' on Page 62">''||d.pending||''</a>''',
'    else to_char(d.pending) end required_pending_count,',
'  d.schedule_close_date,d.period_close_date',
'from (',
'  select /*+ DRIVING_SITE(ood) */ gl.ledger_id,gp.period_name,',
'    ood.organization_id,ood.organization_code,ood.organization_name,hou.name operating_unit,',
'    oap.acct_period_id,nvl2(oap.acct_period_id,nvl2(oap.period_close_date,decode(oap.open_flag,''P'',''Pending Close'',''N'',decode(oap.summarized_flag,''N'',''Closed not Summarized'',''Closed''),''Error''),''Open''),''No Period'') status,nvl2(oap.acct_period_id,nvl2('
||'oap.period_close_date,decode(oap.open_flag,''P'',''FUTURE'',''N'',''CLOSED'',''UNKNOWN''),''OPEN''),''NEVER'') css,',
'    nvl(sum(case when p.d>=trunc(oap.period_start_date)',
'      and p.d<trunc(oap.schedule_close_date)+1',
'      and oap.period_start_date<trunc(gp.end_date)+1',
'      and oap.schedule_close_date>=trunc(gp.start_date)',
'      and p.d>=trunc(gp.start_date) and p.d<trunc(gp.end_date)+1',
'      then p.n end),0) pending,',
'    oap.schedule_close_date,oap.period_close_date',
'  from apps.gl_ledgers@ADG gl,apps.gl_periods@ADG gp,',
'    apps.org_organization_definitions@ADG ood,apps.hr_operating_units@ADG hou,',
'    apps.org_acct_periods@ADG oap,',
'    (select e.organization_id,trunc(e.transaction_date) d,count(*) n',
'     from (',
'-- BEGIN CANONICAL EVENTS',
'select /*+ DRIVING_SITE(t) */',
'  t.organization_id, t.transaction_date, ''MMTT'' source_tag,',
'  to_char(t.transaction_temp_id) source_id, t.transaction_type_id transaction_type_id,',
'  t.inventory_item_id inventory_item_id',
'from apps.mtl_material_transactions_temp@ADG t',
'where nvl(t.transaction_status,0)<>2 and t.organization_id is not null and t.transaction_date >= add_months(trunc(sysdate,''MM''),to_number(nvl(:P60_MONTH_OFFSET,''0''))) and t.transaction_date < add_months(add_months(trunc(sysdate,''MM''),to_number(nvl(:P'
||'60_MONTH_OFFSET,''0''))),1)',
'union all',
'select /*+ DRIVING_SITE(m) INDEX(m MTL_MATERIAL_TRANSACTIONS_N10) */',
'  m.organization_id, m.transaction_date, ''MMT'' source_tag,',
'  to_char(m.transaction_id) source_id, m.transaction_type_id transaction_type_id,',
'  m.inventory_item_id inventory_item_id',
'from apps.mtl_material_transactions@ADG m',
'where m.costed_flag in (''N'',''E'') and m.organization_id is not null and m.transaction_date >= add_months(trunc(sysdate,''MM''),to_number(nvl(:P60_MONTH_OFFSET,''0''))) and m.transaction_date < add_months(add_months(trunc(sysdate,''MM''),to_number(nvl(:P60_M'
||'ONTH_OFFSET,''0''))),1)',
'union all',
'select /*+ DRIVING_SITE(w) */',
'  w.organization_id, w.transaction_date, ''WCTI'' source_tag,',
'  to_char(w.transaction_id) source_id, w.transaction_type transaction_type_id,',
'  w.primary_item_id inventory_item_id',
'from apps.wip_cost_txn_interface@ADG w',
'where 1=1 and w.organization_id is not null and w.transaction_date >= add_months(trunc(sysdate,''MM''),to_number(nvl(:P60_MONTH_OFFSET,''0''))) and w.transaction_date < add_months(add_months(trunc(sysdate,''MM''),to_number(nvl(:P60_MONTH_OFFSET,''0''))),1)',
'union all',
'select /*+ DRIVING_SITE(s) */',
'  s.organization_id, s.transaction_date, ''WSMSM'' source_tag,',
'  to_char(s.transaction_id) source_id, s.transaction_type_id transaction_type_id,',
'  cast(null as number) inventory_item_id',
'from apps.wsm_split_merge_txn_interface@ADG s',
'where s.process_status<>4 and s.organization_id is not null and s.transaction_date >= add_months(trunc(sysdate,''MM''),to_number(nvl(:P60_MONTH_OFFSET,''0''))) and s.transaction_date < add_months(add_months(trunc(sysdate,''MM''),to_number(nvl(:P60_MONTH_OF'
||'FSET,''0''))),1)',
'union all',
'select /*+ DRIVING_SITE(s) */',
'  s.organization_id, s.transaction_date, ''WSMLM'' source_tag,',
'  to_char(s.transaction_id) source_id, s.transaction_type transaction_type_id,',
'  cast(null as number) inventory_item_id',
'from apps.wsm_lot_move_txn_interface@ADG s',
'where s.status<>4 and s.organization_id is not null and s.transaction_date >= add_months(trunc(sysdate,''MM''),to_number(nvl(:P60_MONTH_OFFSET,''0''))) and s.transaction_date < add_months(add_months(trunc(sysdate,''MM''),to_number(nvl(:P60_MONTH_OFFSET,''0'''
||'))),1)',
'union all',
'select /*+ DRIVING_SITE(s) */',
'  s.organization_id, s.transaction_date, ''WSMLS'' source_tag,',
'  to_char(s.transaction_id) source_id, s.transaction_type_id transaction_type_id,',
'  cast(null as number) inventory_item_id',
'from apps.wsm_lot_split_merges_interface@ADG s',
'where s.process_status<>4 and s.organization_id is not null and s.transaction_date >= add_months(trunc(sysdate,''MM''),to_number(nvl(:P60_MONTH_OFFSET,''0''))) and s.transaction_date < add_months(add_months(trunc(sysdate,''MM''),to_number(nvl(:P60_MONTH_OF'
||'FSET,''0''))),1)',
'union all',
'select /*+ DRIVING_SITE(c) */',
'  c.organization_id, c.transaction_date, ''LCM'', to_char(c.transaction_id),',
'  cast(null as number), cast(null as number)',
'from apps.cst_lc_adj_interface@ADG c, apps.mtl_parameters@ADG mp',
'where mp.organization_id=c.organization_id and mp.lcm_enabled_flag=''Y''',
'  and c.organization_id is not null and c.transaction_date >= add_months(trunc(sysdate,''MM''),to_number(nvl(:P60_MONTH_OFFSET,''0''))) and c.transaction_date < add_months(add_months(trunc(sysdate,''MM''),to_number(nvl(:P60_MONTH_OFFSET,''0''))),1)',
'union all',
'-- One eligible row per delivery/org, matching the existing summary business key.',
'-- MIN eligible departure date fixes historical summary/detail duplicate-date disagreement.',
'select sh.organization_id, min(sh.transaction_date) transaction_date, ''SHIP'', to_char(sh.delivery_id),',
'  cast(null as number), cast(null as number)',
'from (',
'select /*+ DRIVING_SITE(wts) LEADING(wts) USE_NL(wdl wnd wda wdd) */',
'  wdd.organization_id organization_id, wts.actual_departure_date transaction_date, wnd.delivery_id',
'from apps.wsh_trip_stops@ADG wts, apps.wsh_delivery_legs@ADG wdl,',
'  apps.wsh_new_deliveries@ADG wnd, apps.wsh_delivery_assignments@ADG wda,',
'  apps.wsh_delivery_details@ADG wdd, apps.org_acct_periods@ADG ship_oap',
'where wts.pending_interface_flag in (''Y'',''P'') and wdl.pick_up_stop_id=wts.stop_id',
'  and wnd.delivery_id=wdl.delivery_id and wnd.status_code in (''CL'',''IT'')',
'  and wda.delivery_id=wnd.delivery_id and wdd.delivery_detail_id=wda.delivery_detail_id and (wda.type in (''S'',''O'') or wda.type is null)',
'  and wdd.source_code=''OE'' and wdd.released_status=''C''',
'  and wdd.inv_interfaced_flag in (''N'',''P'')',
'  and ship_oap.organization_id=wdd.organization_id and ship_oap.period_name=to_char(add_months(trunc(sysdate,''MM''),to_number(nvl(:P60_MONTH_OFFSET,''0''))),''MON-YYYY'',''NLS_DATE_LANGUAGE=English'')',
'  and ship_oap.period_start_date<add_months(add_months(trunc(sysdate,''MM''),to_number(nvl(:P60_MONTH_OFFSET,''0''))),1) and ship_oap.schedule_close_date>=add_months(trunc(sysdate,''MM''),to_number(nvl(:P60_MONTH_OFFSET,''0'')))',
'  and wts.actual_departure_date>=trunc(ship_oap.period_start_date)',
'  and wts.actual_departure_date<trunc(ship_oap.schedule_close_date)+1',
'  and wdd.organization_id is not null and wts.actual_departure_date >= add_months(trunc(sysdate,''MM''),to_number(nvl(:P60_MONTH_OFFSET,''0''))) and wts.actual_departure_date < add_months(add_months(trunc(sysdate,''MM''),to_number(nvl(:P60_MONTH_OFFSET,''0'''
||'))),1)',
'union all',
'select /*+ DRIVING_SITE(wts) LEADING(wts) USE_NL(wdl wnd wda wdd) */',
'  pl.destination_organization_id organization_id, wts.actual_departure_date transaction_date, wnd.delivery_id',
'from apps.wsh_trip_stops@ADG wts, apps.wsh_delivery_legs@ADG wdl,',
'  apps.wsh_new_deliveries@ADG wnd, apps.wsh_delivery_assignments@ADG wda,',
'  apps.wsh_delivery_details@ADG wdd,',
'  apps.oe_order_lines_all@ADG oel, apps.po_requisition_lines_all@ADG pl, apps.org_acct_periods@ADG ship_oap',
'where wts.pending_interface_flag in (''Y'',''P'') and wdl.pick_up_stop_id=wts.stop_id',
'  and wnd.delivery_id=wdl.delivery_id and wnd.status_code in (''CL'',''IT'')',
'  and wda.delivery_id=wnd.delivery_id and wdd.delivery_detail_id=wda.delivery_detail_id',
'  and wdd.source_code=''OE'' and wdd.released_status=''C''',
'  and wdd.inv_interfaced_flag in (''N'',''P'')',
'  and wts.stop_location_id=wnd.initial_pickup_location_id',
'  and wdd.source_line_id=oel.line_id and wdd.source_document_type_id=10',
'  and oel.source_document_line_id=pl.requisition_line_id',
'  and pl.destination_organization_id<>pl.source_organization_id',
'  and pl.destination_type_code=''EXPENSE''',
'  and ship_oap.organization_id=pl.destination_organization_id and ship_oap.period_name=to_char(add_months(trunc(sysdate,''MM''),to_number(nvl(:P60_MONTH_OFFSET,''0''))),''MON-YYYY'',''NLS_DATE_LANGUAGE=English'')',
'  and ship_oap.period_start_date<add_months(add_months(trunc(sysdate,''MM''),to_number(nvl(:P60_MONTH_OFFSET,''0''))),1) and ship_oap.schedule_close_date>=add_months(trunc(sysdate,''MM''),to_number(nvl(:P60_MONTH_OFFSET,''0'')))',
'  and wts.actual_departure_date>=trunc(ship_oap.period_start_date)',
'  and wts.actual_departure_date<trunc(ship_oap.schedule_close_date)+1',
'  and pl.destination_organization_id is not null and wts.actual_departure_date >= add_months(trunc(sysdate,''MM''),to_number(nvl(:P60_MONTH_OFFSET,''0''))) and wts.actual_departure_date < add_months(add_months(trunc(sysdate,''MM''),to_number(nvl(:P60_MONTH'
||'_OFFSET,''0''))),1)',
'union all',
'select /*+ DRIVING_SITE(wts) LEADING(wts) USE_NL(wdl wnd wda wdd) */',
'  pl.destination_organization_id organization_id, wts.actual_departure_date transaction_date, wnd.delivery_id',
'from apps.wsh_trip_stops@ADG wts, apps.wsh_delivery_legs@ADG wdl,',
'  apps.wsh_new_deliveries@ADG wnd, apps.wsh_delivery_assignments@ADG wda,',
'  apps.wsh_delivery_details@ADG wdd,',
'  apps.oe_order_lines_all@ADG oel, apps.po_requisition_lines_all@ADG pl, apps.mtl_interorg_parameters@ADG mip, apps.org_acct_periods@ADG ship_oap',
'where wts.pending_interface_flag in (''Y'',''P'') and wdl.pick_up_stop_id=wts.stop_id',
'  and wnd.delivery_id=wdl.delivery_id and wnd.status_code in (''CL'',''IT'')',
'  and wda.delivery_id=wnd.delivery_id and wdd.delivery_detail_id=wda.delivery_detail_id',
'  and wdd.source_code=''OE'' and wdd.released_status=''C''',
'  and wdd.inv_interfaced_flag in (''N'',''P'')',
'  and wts.stop_location_id=wnd.initial_pickup_location_id',
'  and wdd.source_line_id=oel.line_id and wdd.source_document_type_id=10',
'  and oel.source_document_line_id=pl.requisition_line_id',
'  and pl.destination_organization_id<>pl.source_organization_id',
'  and pl.destination_organization_id=mip.to_organization_id',
'  and pl.source_organization_id=mip.from_organization_id',
'  and mip.intransit_type=1 and pl.destination_type_code<>''EXPENSE''',
'  and ship_oap.organization_id=pl.destination_organization_id and ship_oap.period_name=to_char(add_months(trunc(sysdate,''MM''),to_number(nvl(:P60_MONTH_OFFSET,''0''))),''MON-YYYY'',''NLS_DATE_LANGUAGE=English'')',
'  and ship_oap.period_start_date<add_months(add_months(trunc(sysdate,''MM''),to_number(nvl(:P60_MONTH_OFFSET,''0''))),1) and ship_oap.schedule_close_date>=add_months(trunc(sysdate,''MM''),to_number(nvl(:P60_MONTH_OFFSET,''0'')))',
'  and wts.actual_departure_date>=trunc(ship_oap.period_start_date)',
'  and wts.actual_departure_date<trunc(ship_oap.schedule_close_date)+1',
'  and pl.destination_organization_id is not null and wts.actual_departure_date >= add_months(trunc(sysdate,''MM''),to_number(nvl(:P60_MONTH_OFFSET,''0''))) and wts.actual_departure_date < add_months(add_months(trunc(sysdate,''MM''),to_number(nvl(:P60_MONTH'
||'_OFFSET,''0''))),1)',
') sh',
'group by sh.organization_id,sh.delivery_id',
'-- END CANONICAL EVENTS',
'     ) e group by e.organization_id,trunc(e.transaction_date)) p',
'  where gl.ledger_id=to_number(:P60_INV_LEDGER_ID) and gl.ledger_id in (1003,5001,10001)',
'    and gp.period_set_name=gl.period_set_name and gp.period_type=gl.accounted_period_type',
'    and gp.adjustment_period_flag=''N''',
'    and add_months(trunc(sysdate,''MM''),to_number(nvl(:P60_MONTH_OFFSET,''0''))) between gp.start_date and gp.end_date',
'    and ood.set_of_books_id=gl.ledger_id and nvl(ood.disable_date,sysdate)>=sysdate',
'    and hou.organization_id(+)=ood.operating_unit',
'    and oap.organization_id(+)=ood.organization_id and oap.period_name(+)=gp.period_name',
'    and p.organization_id(+)=ood.organization_id',
'  group by gl.ledger_id,gp.period_name,gp.start_date,gp.end_date,',
'    ood.organization_id,ood.organization_code,ood.organization_name,hou.name,',
'    oap.acct_period_id,oap.period_start_date,oap.open_flag,oap.summarized_flag,',
'    oap.schedule_close_date,oap.period_close_date',
') d',
'where nvl(:P60_HIDE_NO_PERIOD,''N'')<>''Y'' or d.acct_period_id is not null',
'order by d.organization_code'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P60_INV_LEDGER_ID,P60_MONTH_OFFSET,P60_HIDE_NO_PERIOD'
,p_lazy_loading=>true
,p_query_row_template=>2542081983073888486
,p_query_num_rows=>100
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'SHOW_ALL'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1286062800000001)
,p_query_column_id=>3
,p_column_alias=>'OPERATING_UNIT'
,p_column_display_sequence=>30
,p_column_heading=>'Operating Unit'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1286062000000009)
,p_query_column_id=>1
,p_column_alias=>'ORGANIZATION_CODE'
,p_column_display_sequence=>10
,p_column_heading=>'Organization Code'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1286062000000010)
,p_query_column_id=>2
,p_column_alias=>'ORGANIZATION_NAME'
,p_column_display_sequence=>20
,p_column_heading=>'Inventory Organization'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1286062000000014)
,p_query_column_id=>7
,p_column_alias=>'PERIOD_CLOSE_DATE'
,p_column_display_sequence=>70
,p_column_heading=>'Period Close Date'
,p_column_format=>'DD-MON-YYYY'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1286062000000011)
,p_query_column_id=>4
,p_column_alias=>'PERIOD_STATUS'
,p_column_display_sequence=>40
,p_column_heading=>'Period Status'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1286062000000012)
,p_query_column_id=>5
,p_column_alias=>'REQUIRED_PENDING_COUNT'
,p_column_display_sequence=>50
,p_column_heading=>'Pending Transactions Requiring Resolution'
,p_column_alignment=>'RIGHT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1286062000000013)
,p_query_column_id=>6
,p_column_alias=>'SCHEDULE_CLOSE_DATE'
,p_column_display_sequence=>60
,p_column_heading=>'Scheduled Close Date'
,p_column_format=>'DD-MON-YYYY'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1286062000000002)
,p_plug_name=>'Period Status Filters'
,p_static_id=>'period-status-filters'
,p_title=>'Period Status Filters'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="t-Alert t-Alert--info t-Alert--horizontal">',
'  <div class="t-Alert-wrap">',
'    <div class="t-Alert-icon"><span class="t-Icon fa fa-calendar" aria-hidden="true"></span></div>',
'    <div class="t-Alert-content">',
'      The matrix compares General Ledger, Payables, Receivables, Purchasing, and Inventory Organization status across all',
'      three Ledgers in Scope. Pending counts include only transactions dated in the selected month.',
'      A dash means the organization has no inventory period for that month.',
'    </div>',
'  </div>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(1286062000000003)
,p_name=>'Period Status Matrix'
,p_static_id=>'period-status-report'
,p_title=>'Ledger and Subledger Period Status'
,p_template=>2103954283454391425
,p_display_sequence=>20
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- App128 matrix: one remote status query; ledger/application scaffold retains missing rows.',
'select y.subledger,',
'nvl(max(decode(y.ledger_id,1003,y.html)),''<span class="xxme-period-status xxme-period-status-UNKNOWN">Not Configured</span>'') terex_us,',
'nvl(max(decode(y.ledger_id,5001,y.html)),''<span class="xxme-period-status xxme-period-status-UNKNOWN">Not Configured</span>'') terex_uk_120,',
'nvl(max(decode(y.ledger_id,10001,y.html)),''<span class="xxme-period-status xxme-period-status-UNKNOWN">Not Configured</span>'') terex_ch',
'from (',
'select x.seq,x.subledger,x.ledger_id,',
'case when x.seq=5 then ''<button type="button" class="xxme-inventory-drill" data-ledger-id="''||x.ledger_id||',
'''" data-ledger-name="''||apex_escape.html_attribute(x.ledger_name)||',
'''" aria-label="Show inventory organizations for ''||apex_escape.html_attribute(x.ledger_name)||''">'' end||',
'''<span class="xxme-period-status xxme-period-status-''||x.css||''">''||apex_escape.html(x.label)||''</span>''||',
'case when x.seq=5 then ''</button>'' end html',
'from (',
'select /*+ DRIVING_SITE(gl) */',
'decode(fa.application_id,101,1,200,2,222,3,201,4) seq,',
'decode(fa.application_id,101,''General Ledger'',200,''Payables'',222,''Receivables'',201,''Purchasing'') subledger,',
'gl.ledger_id,gl.name ledger_name,',
'nvl((select flv.meaning from apps.fnd_lookup_values@ADG flv',
' where flv.lookup_type=decode(fa.application_id,200,''CLOSING STATUS'',''CLOSING_STATUS'')',
' and flv.view_application_id=decode(fa.application_id,200,200,222,222,101)',
' and flv.lookup_code=gps.closing_status and flv.language=''US'' and flv.security_group_id=0),nvl(gps.closing_status,''Not Configured'')) label,',
'decode(gps.closing_status,''O'',''OPEN'',''C'',''CLOSED'',''P'',''PERMANENT'',''F'',''FUTURE'',''N'',''NEVER'',''W'',''FUTURE'',''UNKNOWN'') css',
'from apps.gl_ledgers@ADG gl,apps.fnd_application@ADG fa,',
'(select s.application_id,s.ledger_id,s.closing_status from apps.gl_period_statuses@ADG s',
' where s.application_id in (101,200,222,201) and s.ledger_id in (1003,5001,10001)',
' and nvl(s.adjustment_period_flag,''N'')=''N''',
' and add_months(trunc(sysdate,''MM''),to_number(nvl(:P60_MONTH_OFFSET,''0''))) between s.start_date and s.end_date) gps',
'where gl.ledger_id in (1003,5001,10001) and fa.application_id in (101,200,222,201)',
'and gps.application_id(+)=fa.application_id and gps.ledger_id(+)=gl.ledger_id',
'union all',
'select 5,''Inventory Organizations'',i.ledger_id,i.ledger_name,',
'nvl(listagg(case when i.status is not null then i.cnt||'' ''||i.status end,'' / '')',
' within group(order by decode(i.status,''Open'',1,''Pending Close'',2,''Closed not Summarized'',3,''Closed'',4,5)),''0 Open''),',
'case when count(i.status)=0 then ''NEVER'' when count(i.status)=1 then max(i.css) else ''MIXED'' end',
'from (',
'select /*+ DRIVING_SITE(ood) */ gl.ledger_id,gl.name ledger_name,',
'nvl2(oap.acct_period_id,nvl2(oap.period_close_date,decode(oap.open_flag,''P'',''Pending Close'',''N'',decode(oap.summarized_flag,''N'',''Closed not Summarized'',''Closed''),''Error''),''Open''),null) status,',
'nvl2(oap.acct_period_id,nvl2(oap.period_close_date,decode(oap.open_flag,''P'',''FUTURE'',''N'',''CLOSED'',''UNKNOWN''),''OPEN''),null) css,',
'count(*) cnt',
'from apps.gl_ledgers@ADG gl,apps.gl_periods@ADG gp,apps.org_organization_definitions@ADG ood,apps.org_acct_periods@ADG oap',
'where gl.ledger_id in (1003,5001,10001)',
'and gp.period_set_name=gl.period_set_name and gp.period_type=gl.accounted_period_type and gp.adjustment_period_flag=''N''',
'and add_months(trunc(sysdate,''MM''),to_number(nvl(:P60_MONTH_OFFSET,''0''))) between gp.start_date and gp.end_date',
'and ood.set_of_books_id=gl.ledger_id and nvl(ood.disable_date,sysdate)>=sysdate',
'and oap.organization_id(+)=ood.organization_id and oap.period_name(+)=gp.period_name',
'group by gl.ledger_id,gl.name,',
'nvl2(oap.acct_period_id,nvl2(oap.period_close_date,decode(oap.open_flag,''P'',''Pending Close'',''N'',decode(oap.summarized_flag,''N'',''Closed not Summarized'',''Closed''),''Error''),''Open''),null),',
'nvl2(oap.acct_period_id,nvl2(oap.period_close_date,decode(oap.open_flag,''P'',''FUTURE'',''N'',''CLOSED'',''UNKNOWN''),''OPEN''),null)',
') i group by i.ledger_id,i.ledger_name',
') x',
') y group by y.seq,y.subledger order by y.seq'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P60_MONTH_OFFSET,P60_INV_LEDGER_ID'
,p_lazy_loading=>true
,p_query_row_template=>2542081983073888486
,p_query_num_rows=>10
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'SHOW_ALL'
,p_csv_output=>'Y'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1286062000000007)
,p_query_column_id=>1
,p_column_alias=>'SUBLEDGER'
,p_column_display_sequence=>10
,p_column_heading=>'Subledger'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1286062000000005)
,p_query_column_id=>4
,p_column_alias=>'TEREX_CH'
,p_column_display_sequence=>40
,p_column_heading=>'TEREX CH'
,p_column_alignment=>'CENTER'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1286062000000004)
,p_query_column_id=>3
,p_column_alias=>'TEREX_UK_120'
,p_column_display_sequence=>30
,p_column_heading=>'TEREX UK 120'
,p_column_alignment=>'CENTER'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1286062000000006)
,p_query_column_id=>2
,p_column_alias=>'TEREX_US'
,p_column_display_sequence=>20
,p_column_heading=>'TEREX US'
,p_column_alignment=>'CENTER'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(1286062000000015)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(1286062000000002)
,p_button_name=>'BACK_TO_DASHBOARD'
,p_static_id=>'back-to-dashboard'
,p_show_as_disabled=>false
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Close'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-arrow-left'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(1286062000000016)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(1286062000000002)
,p_button_name=>'REFRESH_STATUS'
,p_static_id=>'refresh-period-status'
,p_show_as_disabled=>false
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Refresh Period Status'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-refresh'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1286062000000017)
,p_name=>'P60_DB_LINK'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(1286062000000002)
,p_item_default=>'ADG'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_cHeight=>1
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1286062800000002)
,p_name=>'P60_HIDE_NO_PERIOD'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(1286062000000008)
,p_item_default=>'N'
,p_prompt=>'Hide orgs with no inventory period'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SINGLE_CHECKBOX'
,p_tag_css_classes=>'js-ignoreChange'
,p_colspan=>6
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'checked_value', 'Y',
  'unchecked_value', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1286062000000019)
,p_name=>'P60_INV_LEDGER_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(1286062000000002)
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_cHeight=>1
,p_tag_css_classes=>'js-ignoreChange'
,p_warn_on_unsaved_changes=>'I'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1286062000000018)
,p_name=>'P60_MONTH_OFFSET'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(1286062000000002)
,p_item_default=>'0'
,p_prompt=>'Month'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select upper(to_char(',
'           add_months(trunc(sysdate, ''MM''), month_offset),',
'           ''MON-YYYY'',',
'           ''NLS_DATE_LANGUAGE=English''',
'       )) d,',
'       month_offset r',
'  from (',
'      select level - 4 month_offset',
'        from dual',
'      connect by level <= 7',
'  )',
' order by month_offset'))
,p_cHeight=>1
,p_tag_css_classes=>'js-ignoreChange'
,p_colspan=>4
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(1286062000000024)
,p_name=>'Change Month'
,p_static_id=>'change-period-month'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P60_MONTH_OFFSET'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(1286062000000026)
,p_event_id=>wwv_flow_imp.id(1286062000000024)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'Hide Inventory Details'
,p_static_id=>'hide-inventory-details'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'apex.item("P60_INV_LEDGER_ID").setValue("", null, true);',
    '$("#R1286062000000008").hide();')))).to_clob
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(1286062000000025)
,p_event_id=>wwv_flow_imp.id(1286062000000024)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_name=>'Refresh Status Matrix'
,p_static_id=>'refresh-status-matrix'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(1286062000000003)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'maintain_pagination', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(1286062000000020)
,p_name=>'Close'
,p_static_id=>'close'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(1286062000000015)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(1286062000000021)
,p_event_id=>wwv_flow_imp.id(1286062000000020)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'close-window'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'window.close();')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(1286062800000003)
,p_name=>'Filter Inventory Organizations'
,p_static_id=>'filter-inventory-organizations'
,p_event_sequence=>60
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P60_HIDE_NO_PERIOD'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(1286062800000004)
,p_event_id=>wwv_flow_imp.id(1286062800000003)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-refresh'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(1286062000000008)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(1286062000000022)
,p_name=>'Refresh Period Status'
,p_static_id=>'refresh-period-status'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(1286062000000016)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(1286062000000023)
,p_event_id=>wwv_flow_imp.id(1286062000000022)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'Refresh Status Report'
,p_static_id=>'refresh-status-report'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(1286062000000003)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'maintain_pagination', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(1286062000000027)
,p_name=>'Show Inventory Organizations'
,p_static_id=>'show-inventory-organizations'
,p_event_sequence=>40
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'.xxme-inventory-drill'
,p_bind_type=>'live'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(1286062000000028)
,p_event_id=>wwv_flow_imp.id(1286062000000027)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'Load Inventory Details'
,p_static_id=>'load-inventory-details'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'var button = this.triggeringElement;',
    'var ledgerId = button.getAttribute("data-ledger-id");',
    'var ledgerName = button.getAttribute("data-ledger-name");',
    'var monthName = $("#P60_MONTH_OFFSET option:selected").text();',
    'apex.item("P60_INV_LEDGER_ID").setValue(ledgerId, null, true);',
    '$("#R1286062000000008_heading").text("Inventory Organizations - " + ledgerName + " - " + monthName);',
    '$("#R1286062000000008").show();',
    'document.getElementById("R1286062000000008").scrollIntoView({behavior:"smooth", block:"start"});')))).to_clob
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(1286062000000029)
,p_event_id=>wwv_flow_imp.id(1286062000000027)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_name=>'Refresh Inventory Details'
,p_static_id=>'refresh-inventory-details'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(1286062000000008)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'maintain_pagination', 'N')).to_clob
);
end;
/
prompt --application/pages/delete_00061
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>61);
end;
/
prompt --application/pages/page_00061
begin
wwv_flow_imp_page.create_page(
 p_id=>61
,p_name=>'Inventory Pending Transactions'
,p_alias=>'INVENTORY-PENDING-TRANSACTIONS'
,p_step_title=>'Inventory Pending Transactions'
,p_reload_on_submit=>'A'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* Page 61 only. Native APEX reports retain pagination, filtering and exports. */',
'(function ($) {',
'  ''use strict'';',
'  var active = null, snapshot = null;',
'  var summary$ = $(''#pending-summary''), details$ = $(''#pending-details'');',
'  var run$ = $(''#run-pending-analysis''), export$ = $(''#export-pending-summary'');',
'  var filters$ = $(''#P61_PERIOD_NAME,#P61_DB_LINK,#P61_RESOLUTION'');',
'  function pane(region$, kind, title) {',
'    region$.wrap(''<section class="p61-pane" id="p61-'' + kind + ''-pane" aria-label="'' + title + ''"></section>'');',
'    var pane$ = region$.parent();',
'    pane$.prepend(''<div class="p61-pane-status" role="status" aria-live="polite"></div><div class="p61-pane-context"></div>'');',
'    // BEGIN P61 TIMER ADDITION',
'    pane$.prepend(''<div class="p61-pane-timing" aria-live="off" style="font-variant-numeric:tabular-nums;margin-bottom:.35rem;font-weight:600"></div>'');',
'    // END P61 TIMER ADDITION',
'    return pane$;',
'  }',
'  var summaryPane$ = pane(summary$, ''summary'', ''Pending transaction summary'');',
'  var detailPane$ = pane(details$, ''detail'', ''Selected transaction details'');',
'  summaryPane$.hide(); detailPane$.hide(); export$.prop(''disabled'',true);',
'  // BEGIN P61 TIMER ADDITION',
'  // Browser elapsed time, not database-only execution time. No server calls here.',
'  function seconds(ms) {return (Math.max(0,ms)/1000).toFixed(1) + '' s'';}',
'  function renderTiming(job) {',
'    var timing = job.timing;',
'    var now = timing.endedAt === null ? performance.now() : timing.endedAt;',
'    var text = (timing.endedAt === null ? ''Elapsed: '' : timing.failed ? ''Stopped after: '' : ''Total: '') + seconds(now-timing.startedAt);',
'    if (timing.refreshAt === null) {',
'      text += '' | Setup: '' + seconds(now-timing.startedAt);',
'      text += timing.endedAt === null ? '' (preparing) | Report: not started'' : '' | Report: not started'';',
'    } else {',
'      text += '' | Setup: '' + (timing.reportOnly ? ''not requested'' : seconds(timing.refreshAt-timing.startedAt));',
'      text += '' | Report: '' + seconds(now-timing.refreshAt);',
'      if (timing.endedAt === null) text += '' (loading)'';',
'    }',
'    job.pane.find(''.p61-pane-timing'').text(text);',
'  }',
'  function startTiming(job) {',
'    job.timing = {startedAt:performance.now(), refreshAt:null, endedAt:null, failed:false, reportOnly:false, interval:null};',
'    renderTiming(job);',
'    job.timing.interval = setInterval(function () {if(active === job) renderTiming(job);},250);',
'  }',
'  function reportTiming(job, reportOnly) {',
'    if (job.timing.refreshAt !== null) return;',
'    job.timing.reportOnly = !!reportOnly;',
'    job.timing.refreshAt = reportOnly ? job.timing.startedAt : performance.now();',
'    renderTiming(job);',
'  }',
'  function stopTiming(job, error) {',
'    job.timing.endedAt = performance.now();',
'    job.timing.failed = !!error;',
'    clearInterval(job.timing.interval);',
'    job.timing.interval = null;',
'    renderTiming(job);',
'  }',
'  // END P61 TIMER ADDITION',
'  function lock(on) {',
'    run$.prop(''disabled'', on);',
'    filters$.prop(''disabled'', on);',
'    summary$.prop(''inert'', on);',
'  }',
'  function begin(kind, context) {',
'    if (active) return false;',
'    var pane$ = kind === ''summary'' ? summaryPane$ : detailPane$;',
'    var region$ = kind === ''summary'' ? summary$ : details$;',
'    pane$.show().attr(''aria-busy'', ''true'');',
'    pane$.find(''.p61-pane-context'').text(context || '''');',
unistr('    pane$.find(''.p61-pane-status'').text(kind === ''summary'' ? ''Loading summary\2026'' : ''Loading details\2026'');'),
'    // Keep the widget measurable while preventing stale data from being used.',
'    region$.removeClass(''p61-failed-content'').addClass(''p61-loading-content'');',
'    active = {kind:kind, pane:pane$, region:region$, phase:''context'', spinner:apex.util.showSpinner(pane$)};',
'    // BEGIN P61 TIMER ADDITION',
'    startTiming(active);',
'    // END P61 TIMER ADDITION',
'    lock(true);',
'    return true;',
'  }',
'  function finish(error) {',
'    if (!active) return;',
'    var job = active;',
'    // BEGIN P61 TIMER ADDITION',
'    stopTiming(job,error);',
'    // END P61 TIMER ADDITION',
'    active = null;',
'    job.spinner.remove();',
'    job.pane.attr(''aria-busy'', ''false'');',
'    job.region.removeClass(''p61-loading-content'');',
'    lock(false);',
'    if (error) {',
'      // Do not show old rows under a new selection after a failed request.',
'      job.region.addClass(''p61-failed-content'');',
'      job.pane.find(''.p61-pane-status'').text(error);',
'      if (job.kind === ''summary'') snapshot = null;',
'    } else {',
'      job.region.removeClass(''p61-failed-content'');',
'      job.pane.find(''.p61-pane-status'').text(job.kind === ''summary'' ? ''Summary loaded. Select a nonzero count below.'' : ''Details loaded.'');',
'      if(job.kind === ''summary'') export$.prop(''disabled'',false);',
'    }',
'  }',
'  function message(error, fallback) {',
'    return error && typeof error.message === ''string'' ? error.message : fallback;',
'  }',
'  function refresh(kind) {',
'    if (!active || active.kind !== kind) return;',
'    var job = active;',
'    active.phase = ''refresh'';',
'    // BEGIN P61 TIMER ADDITION',
'    reportTiming(job,false);',
'    // END P61 TIMER ADDITION',
'    try {',
'      var result = apex.region(kind === ''summary'' ? ''pending-summary'' : ''pending-details'').refresh();',
'      // Classic Report refresh may return undefined; apexafterrefresh covers it.',
'      if (result && typeof result.then === ''function'') {',
'        result.then(function () { if (active === job) finish(); },',
'          function (error) { if (active === job) finish(message(error,''Unable to load results. Please retry.'')); });',
'      }',
'    } catch (error) { finish(message(error,''Unable to refresh this report.'')); }',
'  }',
'  // P61_SERVER_CONTEXT_V1: request inputs and accepted state are separate.',
'  var ownedRunId = null;',
'  function same(a,b) {return String(a == null ? '''' : a) === String(b == null ? '''' : b);}',
'  function clearApproval() {',
'    [''P61_RUN_ID'',''P61_RUN_PERIOD'',''P61_RUN_SOURCE'',''P61_RUN_RESOLUTION'',''P61_ORG_ID'',''P61_TXN_TYPE''].forEach(function (name) {apex.item(name).setValue('''',null,true);});',
'    apex.item(''P61_READY'').setValue(''N'',null,true);',
'    export$.prop(''disabled'',true);',
'  }',
'  function accept(result) {',
'    var values={P61_RUN_ID:result.run_id,P61_READY:''Y'',P61_RUN_PERIOD:result.period,',
'      P61_RUN_SOURCE:result.source,P61_RUN_RESOLUTION:result.resolution,P61_ORG_ID:result.org||'''',P61_TXN_TYPE:result.type||''''};',
'    Object.keys(values).forEach(function (name) {apex.item(name).setValue(values[name],null,true);});',
'  }',
'  function responseMatches(result,data) {',
'    return result.version===''P61_SERVER_CONTEXT_V1'' && result.action===data.x01 && result.ready===''Y''',
'      && /^[0-9A-F]{32}$/.test(result.run_id||'''')',
'      && (data.x01===''RUN'' || same(result.run_id,data.x07))',
'      && same(result.period,data.x02) && same(result.source,data.x03) && same(result.resolution,data.x06)',
'      && same(result.org,data.x01===''DETAIL''?data.x04:'''') && same(result.type,data.x01===''DETAIL''?data.x05:'''');',
'  }',
'  function filtersMatch(data) {',
'    return same(apex.item(''P61_PERIOD_NAME'').getValue(),data.x02)',
'      && same(apex.item(''P61_DB_LINK'').getValue(),data.x03) && same(apex.item(''P61_RESOLUTION'').getValue(),data.x06);',
'  }',
'  function context(data,kind) {',
'    var job=active, expected=Object.assign({},data);',
'    try {',
'      // No pageItems: callback validates explicit inputs and creates the server snapshot.',
'      apex.server.process(''P61_SET_CONTEXT'',Object.assign({},data),{dataType:''json''}).then(function(result){',
'        if(active!==job)return;',
'        if(!result||result.ok!==true){finish(result&&result.message||''Unable to accept this run.'');return;}',
'        if(!responseMatches(result,expected)||!filtersMatch(expected)){',
'          snapshot=null;clearApproval();finish(''The accepted context does not match this selection. Run Analysis again.'');return;',
'        }',
'        accept(result);',
'        if(kind===''summary''){',
'          ownedRunId=result.run_id;',
'          snapshot={runId:result.run_id,period:result.period,source:result.source,resolution:result.resolution};',
'        }',
'        refresh(kind);',
'      },function(error){if(active===job)finish(message(error,''Unable to accept this run. Please retry.''));});',
'    }catch(error){finish(message(error,''Unable to start the request.''));}',
'  }',
'  function resolutionLabel(value) {return value === ''ALL'' ? ''All'' : value === ''RECOMMENDED'' ? ''Recommended'' : ''Required'';}',
'  function run() {',
'    if (active) return;',
'    var period = apex.item(''P61_PERIOD_NAME'').getValue();',
'    var source = apex.item(''P61_DB_LINK'').getValue();',
'    var resolution = apex.item(''P61_RESOLUTION'').getValue();',
'    if (!period || !source || [''REQUIRED'',''RECOMMENDED'',''ALL''].indexOf(resolution) < 0) {',
'      apex.message.showErrors([{type:''error'',location:''page'',message:''Select an accounting period, database source and resolution.'',unsafe:false}]);',
'      return;',
'    }',
'    apex.message.clearErrors();',
'    detailPane$.hide();',
'    snapshot = null;',
unistr('    begin(''summary'', period + '' \00B7 '' + source + '' \00B7 '' + resolutionLabel(resolution));'),
'    clearApproval();',
'    context({x01:''RUN'',x02:period,x03:source,x06:resolution,x07:ownedRunId||''''}, ''summary'');',
'  }',
'  $(document).off(''.p61Ajax'');',
'  $(document).on(''click.p61Ajax'', ''#run-pending-analysis'', function (event) {event.preventDefault();run();});',
'  $(document).on(''click.p61Ajax'', ''#pending-summary .p61-count'', function (event) {',
'    event.preventDefault();',
'    if (active || !snapshot) return;',
'    var button$ = $(this), org = button$.attr(''data-org-id''), type = button$.attr(''data-type'');',
'    var name = button$.attr(''data-org-name'');',
unistr('    begin(''detail'', name + '' \00B7 '' + type + '' \00B7 '' + snapshot.period + '' \00B7 '' + snapshot.source + '' \00B7 '' + resolutionLabel(snapshot.resolution));'),
'    detailPane$[0].scrollIntoView({behavior:''smooth'',block:''nearest''});',
'    context({x01:''DETAIL'',x02:snapshot.period,x03:snapshot.source,x04:org,x05:type,x06:snapshot.resolution,x07:snapshot.runId}, ''detail'');',
'  });',
'  filters$.off(''.p61Ajax'').on(''change.p61Ajax'', function () {',
'    snapshot = null;',
'    clearApproval();',
'    summaryPane$.hide(); detailPane$.hide();',
'    $(''#pending-filter-message'').prop(''hidden'',false);',
'  });',
'  [summary$,details$].forEach(function (region$, index) {',
'    var kind = index === 0 ? ''summary'' : ''detail'';',
'    region$.off(''.p61Ajax'').on(''apexbeforerefresh.p61Ajax'', function (event) {',
'      if (!active && !snapshot) {event.preventDefault(); return false;}',
'      // Also give native pagination/filtering a loading indicator.',
'      if (!active) {begin(kind, (kind === ''summary'' ? summaryPane$ : detailPane$).find(''.p61-pane-context'').text());active.phase=''refresh'';}',
'      // BEGIN P61 TIMER ADDITION',
'      if (active && active.kind === kind && active.timing.refreshAt === null) reportTiming(active,true);',
'      // END P61 TIMER ADDITION',
'    }).on(''apexafterrefresh.p61Ajax'', function () {',
'      if (active && active.kind === kind && active.phase === ''refresh'') {',
'        var hasError = region$.find(''.a-IRR-error,.t-Report-error,.a-Notification--error'').length > 0;',
'        finish(hasError ? ''The report returned an error. Review the message and retry.'' : null);',
'        $(''#pending-filter-message'').prop(''hidden'',true);',
'      }',
'    });',
'  });',
'  $(document).on(''ajaxError.p61Ajax'', function () {',
'    if (active && active.phase === ''refresh'') finish(''The report request failed. Please retry.'');',
'  });',
'})(apex.jQuery);',
''))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.p61-pane {position:relative; margin-bottom:1rem; min-height:100px; border:1px solid #ddd; border-radius:6px; padding:.75rem;}',
'.p61-pane-status {font-weight:600; min-height:1.5em;}',
'.p61-pane-context {margin:.25rem 0 .75rem; overflow-wrap:anywhere;}',
'.p61-pane[aria-busy="true"] {min-height:180px;}',
'.p61-loading-content,.p61-failed-content {visibility:hidden; max-height:180px; overflow:hidden;}',
'#pending-summary .t-Region-body {overflow:visible;}',
'#pending-summary .t-Report-wrap {max-height:42vh;overflow:auto;position:relative;}',
'#pending-summary .t-Report-report {min-width:1250px;}',
'#pending-summary .t-Report-colHead {white-space:normal; vertical-align:bottom;}',
'#pending-details .a-IRR-tableContainer {max-height:42vh; overflow:auto;}',
'.p61-count {border:0; background:transparent; padding:.25rem; color:var(--a-link-text-color,#056ac8); text-decoration:underline; cursor:pointer; font:inherit; font-weight:600;}',
'.p61-count:focus-visible {outline:2px solid currentColor; outline-offset:2px;}',
'#pending-filters .t-Form-fieldContainer {margin-bottom:.25rem;}',
'@media(max-width:640px){#pending-summary .t-Report-wrap,#pending-details .a-IRR-tableContainer {max-height:50vh;}}',
'/* Initial visual hiding is separate from the server-side empty-query guard. */',
'#pending-summary,#pending-details {display:none;}',
'#p61-summary-pane > #pending-summary,#p61-detail-pane > #pending-details {display:block;}',
'/* Keep the entire heading row inside the table scroll wrapper; no padded strip can expose scrolled rows. */',
'#pending-summary .t-Report-report thead {position:sticky;top:0;z-index:3;}',
'#pending-summary .t-Report-report thead th {background:var(--ut-component-background-color,#fff);box-shadow:0 1px 0 rgba(0,0,0,.15);}'))
,p_step_template=>4075783602716660119
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(18558063129193156)
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(355328276289366655)
,p_plug_name=>'Breadcrumb'
,p_static_id=>'breadcrumb'
,p_title=>'Inventory Pending Transactions'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2534890969069732905
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_menu_id=>wwv_flow_imp.id(199435849224420349)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4075790987805660140
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(327394276929161661)
,p_plug_name=>'Interactive Report AI Notice'
,p_static_id=>'interactive-report-ai-notice'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>5
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="t-Alert t-Alert--info t-Alert--horizontal" role="note">',
'  <div class="t-Alert-wrap">',
'    <div class="t-Alert-icon">',
'      <span class="t-Icon fa fa-info-circle" aria-hidden="true"></span>',
'    </div>',
'    <div class="t-Alert-content">',
'      AI Assistant available: Use it to filter, sort, summarize, and create informational charts from this report. It cannot update data, and AI-generated charts are not drillable. Verify important conclusions against the report rows.',
'    </div>',
'  </div>',
'</div>'))
,p_required_patch=>wwv_flow_imp.id(1026514276929100661)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(355328276289366668)
,p_plug_name=>'Transaction Details'
,p_static_id=>'pending-details'
,p_title=>'Transaction Details'
,p_region_name=>'pending-details'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>30
,p_plug_grid_column_span=>12
,p_plug_item_display_point=>'ABOVE'
,p_query_type=>'FUNC_BODY_RETURNING_SQL'
,p_function_body_language=>'PLSQL'
,p_plug_source=>'return xxme_inv_pending_ui_pkg.details_sql;'
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P61_RUN_ID'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(355328276289366865)
,p_no_data_found_message=>'No matching pending details remain for this selection. Transactions may have been processed since the summary was read.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:XLSX'
,p_enable_mail_download=>'N'
,p_internal_uid=>120061000000000200
,p_ai_report_hint=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Current pending inventory transaction details for the accepted Page 61 analysis run. The server-owned run fixes database source, inventory period, resolution, organization, and pending-transaction category.',
'These rows are current operational results, not a historical snapshot. Resolution Required and Recommended are distinct classifications. A row can disappear after the source transaction is processed.',
'Use Inventory Organization, Pending Transaction Category, Transaction Date, Reference Type, Transaction Reference, Transaction Type, and Item as business-facing fields. Do not infer transactions outside the accepted run scope.'))
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(355328276289366886)
,p_db_column_name=>'ITEM'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Item'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Inventory item identifier or item code associated with the pending transaction, when available.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(355328276289366875)
,p_db_column_name=>'ORGANIZATION_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Organization ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(355328276289366879)
,p_db_column_name=>'ORGANIZATION_NAME'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Inventory Organization'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Business name of the inventory organization containing the pending transaction.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(355328276289366876)
,p_db_column_name=>'PERIOD_NAME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Inventory Period'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Inventory accounting period selected for the accepted analysis run.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(355328276289366877)
,p_db_column_name=>'PERIOD_START_DATE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Period Start Date'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(355328276289366882)
,p_db_column_name=>'RESOLUTION'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Resolution'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Resolution classification assigned by the pending-transactions rules: Required or Recommended.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(355328276289366878)
,p_db_column_name=>'SCHEDULE_CLOSE_DATE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Scheduled Close Date'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(355328276289366881)
,p_db_column_name=>'TRANSACTION_DATE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Transaction Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Business date of the pending inventory transaction.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(355328276289366883)
,p_db_column_name=>'TRANSACTION_REF'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Reference Type'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Type of business reference supplied for the pending transaction.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(355328276289366884)
,p_db_column_name=>'TRANSACTION_REF_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Transaction Reference'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Business or system reference value for locating the pending transaction.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(355328276289366880)
,p_db_column_name=>'TRANSACTION_TYPE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Pending Transaction Category'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'High-level pending transaction category selected from the Page 61 summary.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(355328276289366885)
,p_db_column_name=>'TRANSACTION_TYPE_NAME'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Transaction Type'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Detailed Oracle inventory transaction type name.'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(355328276289366895)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>100000
,p_report_columns=>'PERIOD_NAME:ORGANIZATION_NAME:TRANSACTION_TYPE:TRANSACTION_DATE:RESOLUTION:TRANSACTION_REF:TRANSACTION_REF_ID:TRANSACTION_TYPE_NAME:ITEM'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(355328276289366669)
,p_plug_name=>'Analysis Information'
,p_static_id=>'pending-execution-info'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>15
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="t-Alert t-Alert--horizontal t-Alert--defaultIcons t-Alert--info">',
'  <div class="t-Alert-wrap">',
'    <div class="t-Alert-icon"><span class="t-Icon"></span></div>',
'    <div class="t-Alert-content">',
'      <div class="t-Alert-header">',
'        <h2 class="t-Alert-title">Inventory Pending Transactions analysis runs on demand</h2>',
'      </div>',
'      <div class="t-Alert-body">',
'        Select an accounting period and database source, then click <strong>Run Analysis</strong>.',
'        The analysis may take approximately 30&ndash;60 seconds.',
'        Execution time varies by database source and workload. Please wait for the results before clicking again.',
'      </div>',
'    </div>',
'  </div>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(355328276289366666)
,p_plug_name=>'Filters'
,p_static_id=>'pending-filters'
,p_region_name=>'pending-filters'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Select a period, source and resolution, then run analysis. Only organizations with pending transactions are shown. Click a nonzero count to view its details below.</p>',
'<p>Counts reflect current pending transactions within the selected period rules, not a historical snapshot. Required is the default. Total counts only the selected resolution; a dash means the category was not queried. Only records dated within the s'
||'elected period are included. .</p>',
'<p id="pending-filter-message" role="status" hidden>Filters changed. Select Run Analysis to load matching results.</p>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(355328276289366667)
,p_name=>'Pending Transactions by Inventory Organization'
,p_static_id=>'pending-summary'
,p_title=>'Pending Transactions by Inventory Organization'
,p_region_name=>'pending-summary'
,p_template=>4075786578761660127
,p_display_sequence=>20
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'FUNC_BODY_RETURNING_SQL'
,p_function_body_language=>'PLSQL'
,p_source=>'return xxme_inv_pending_ui_pkg.summary_sql;'
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P61_RUN_ID'
,p_lazy_loading=>false
,p_query_row_template=>2542081983073888486
,p_query_num_rows=>100
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No pending transactions found for the selected source and period.'
,p_query_num_rows_type=>'SHOW_ALL'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(355328276289366776)
,p_query_column_id=>12
,p_column_alias=>'INCOMPLETE_WORK_ORDERS_COUNT'
,p_column_display_sequence=>120
,p_column_heading=>'Incomplete Work Orders'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(355328276289366765)
,p_query_column_id=>1
,p_column_alias=>'ORGANIZATION_CODE'
,p_column_display_sequence=>10
,p_column_heading=>'Org Code'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(355328276289366766)
,p_query_column_id=>2
,p_column_alias=>'ORGANIZATION_NAME'
,p_column_display_sequence=>20
,p_column_heading=>'Inventory Organization'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(355328276289366771)
,p_query_column_id=>7
,p_column_alias=>'PENDING_LCM_INTERFACE_COUNT'
,p_column_display_sequence=>70
,p_column_heading=>'Pending LCM Interface'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(355328276289366774)
,p_query_column_id=>10
,p_column_alias=>'PENDING_MATERIAL_COUNT'
,p_column_display_sequence=>100
,p_column_heading=>'Pending Material'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(355328276289366773)
,p_query_column_id=>9
,p_column_alias=>'PENDING_RECEIVING_COUNT'
,p_column_display_sequence=>90
,p_column_heading=>'Pending Receiving'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(355328276289366775)
,p_query_column_id=>11
,p_column_alias=>'PENDING_SHOP_FLOOR_MOVE_COUNT'
,p_column_display_sequence=>110
,p_column_heading=>'Pending Shop Floor Move'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(355328276289366769)
,p_query_column_id=>5
,p_column_alias=>'PENDING_WIP_COSTING_COUNT'
,p_column_display_sequence=>50
,p_column_heading=>'Pending WIP Costing'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(355328276289366770)
,p_query_column_id=>6
,p_column_alias=>'PENDING_WSM_INTERFACE_COUNT'
,p_column_display_sequence=>60
,p_column_heading=>'Pending WSM Interface'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(355328276289366777)
,p_query_column_id=>13
,p_column_alias=>'TOTAL_COUNT'
,p_column_display_sequence=>130
,p_column_heading=>'Total'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(355328276289366768)
,p_query_column_id=>4
,p_column_alias=>'UNCOSTED_MATERIAL_WSM_COUNT'
,p_column_display_sequence=>40
,p_column_heading=>'Uncosted Material/WSM'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(355328276289366767)
,p_query_column_id=>3
,p_column_alias=>'UNPROCESSED_MATERIAL_COUNT'
,p_column_display_sequence=>30
,p_column_heading=>'Unprocessed Material'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(355328276289366772)
,p_query_column_id=>8
,p_column_alias=>'UNPROCESSED_SHIPPING_COUNT'
,p_column_display_sequence=>80
,p_column_heading=>'Unprocessed Shipping Transactions'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(332682561127142360)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(355328276289366666)
,p_button_name=>'EXPORT_SUMMARY'
,p_static_id=>'export-pending-summary'
,p_button_static_id=>'export-pending-summary'
,p_show_as_disabled=>false
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Export Summary to Excel'
,p_button_position=>'CREATE'
,p_button_execute_validations=>'N'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-file-excel-o'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(355328276289366685)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(355328276289366666)
,p_button_name=>'RUN_ANALYSIS'
,p_static_id=>'run-pending-analysis'
,p_button_static_id=>'run-pending-analysis'
,p_show_as_disabled=>false
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Run Analysis'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(355328276289366696)
,p_name=>'P61_DB_LINK'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(355328276289366666)
,p_item_default=>'ADG'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_cHeight=>1
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(355328276289366697)
,p_name=>'P61_ORG_ID'
,p_item_sequence=>30
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(355328276289366695)
,p_name=>'P61_PERIOD_NAME'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(355328276289366666)
,p_item_default=>'select upper(to_char(trunc(sysdate - 7, ''MM''), ''MON-YYYY'', ''NLS_DATE_LANGUAGE=English'')) from dual'
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Accounting Period'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'TMS_CLOSE_PERIODS'
,p_cHeight=>1
,p_colspan=>4
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(355328276289366699)
,p_name=>'P61_READY'
,p_item_sequence=>32
,p_item_default=>'N'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(355328276289366755)
,p_name=>'P61_RESOLUTION'
,p_is_required=>true
,p_item_sequence=>25
,p_item_plug_id=>wwv_flow_imp.id(355328276289366666)
,p_item_default=>'REQUIRED'
,p_prompt=>'Resolution'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''Required'' d, ''REQUIRED'' r from dual',
'union all select ''Recommended'', ''RECOMMENDED'' from dual',
'union all select ''All'', ''ALL'' from dual'))
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(355328276289367699)
,p_name=>'P61_RUN_ID'
,p_item_sequence=>36
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(355328276289366700)
,p_name=>'P61_RUN_PERIOD'
,p_item_sequence=>33
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(355328276289366756)
,p_name=>'P61_RUN_RESOLUTION'
,p_item_sequence=>35
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(355328276289366701)
,p_name=>'P61_RUN_SOURCE'
,p_item_sequence=>34
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(355328276289366698)
,p_name=>'P61_TXN_TYPE'
,p_item_sequence=>31
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(332682561127142361)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Export Accepted Summary to XLSX'
,p_static_id=>'export-accepted-summary-xlsx'
,p_process_sql_clob=>'xxme_inv_pending_ui_pkg.export_accepted_summary_xlsx;'
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(332682561127142360)
,p_internal_uid=>120061000000000052
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(355328276289366705)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Initialize AJAX Panes'
,p_static_id=>'initialize-ajax-panes'
,p_process_sql_clob=>'xxme_inv_pending_ui_pkg.initialize_panes;'
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>120061000000000040
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(355328276289366707)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'P61_SET_CONTEXT'
,p_static_id=>'p61-set-context'
,p_process_sql_clob=>'xxme_inv_pending_ui_pkg.set_context;'
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>120061000000000042
);
end;
/
prompt --application/pages/delete_00070
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>70);
end;
/
prompt --application/pages/page_00070
begin
wwv_flow_imp_page.create_page(
 p_id=>70
,p_name=>'Month-End Process Monitor'
,p_alias=>'MONTH-END-ACTIVITY'
,p_step_title=>'Month-End Process Monitor'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(function(){',
' const $=apex.jQuery; const keys=[''CA'',''RV'',''RS'']; const pending=new Set(); const opened=new Set();',
' function summary(k){if(pending.has(k))return;pending.add(k);const items=k===''CA''?''#P70_CA_LEDGERS,#P70_CA_APPS,#P70_CA_VIEW'':''#P70_''+k+''_LEDGERS'';',
'  apex.server.process(''P70_SUMMARY'',{x01:k,pageItems:items},{dataType:''json'',success:function(d){$(''#p70-summary-''+k).text(d.latest||''No matching runs'');$(''#p70-context-''+k).text(d.context);},error:function(){$(''#p70-summary-''+k).text(''Summary unavai'
||'lable'');},complete:function(){pending.delete(k);}});',
' }',
' function badges(el){$(el).find(''.p70-status-label'').each(function(){const s=this.textContent;this.classList.add(''p70-badge'',s===''Normal''||s===''Posted''||s===''Reversed''?''p70-good'':s===''Error''?''p70-bad'':''p70-warn'');});',
'  if(el.id!==''p70-report-CA''){const panel=$(el).find(''.a-IRR-controlsContainer'');const other=panel.find(''.a-IRR-controls-item:not(.a-IRR-controls-item--controlBreak)'');panel.toggle(other.length>0);}',
' }',
' keys.forEach(k=>{$(''#p70-report-''+k).on(''apexafterrefresh'',function(){badges(this);summary(k);});});',
' function show(k,focus){',
'  if(!keys.includes(k))k=''CA'';',
'  keys.forEach(x=>{const el=document.getElementById(''p70-''+x);el.hidden=x!==k;el.setAttribute(''role'',''tabpanel'');el.setAttribute(''aria-labelledby'',''p70-tab-''+x);});',
'  document.querySelectorAll(''[data-p70-tab]'').forEach(b=>b.setAttribute(''aria-selected'',b.dataset.p70Tab===k?''true'':''false''));',
'  apex.item(''P70_ACTIVE_TAB'').setValue(k);',
'  sessionStorage.setItem(''p70-tab-&APP_ID.'',k);',
'  if(focus)document.querySelector(''[data-p70-tab="''+k+''"]'').focus();',
'  $(window).trigger(''apexwindowresized'');',
'  if(!opened.has(k)){opened.add(k);apex.region(''p70-report-''+k).refresh();}',
' }',
' $(document).on(''click'',''[data-p70-tab]'',function(){show(this.dataset.p70Tab,false);});',
' $(document).on(''keydown'',''[data-p70-tab]'',function(e){if(![''ArrowLeft'',''ArrowRight'',''Home'',''End''].includes(e.key))return;e.preventDefault();let i=keys.indexOf(this.dataset.p70Tab);i=e.key===''Home''?0:e.key===''End''?2:(i+(e.key===''ArrowRight''?1:2))%3;s'
||'how(keys[i],true);});',
' keys.forEach(k=>{$(document).on(''click'',''.p70-refresh-''+k,function(){',
'   const val=apex.item(''P70_''+k+''_LEDGERS'').getValue();',
'   if(k!==''CA''&&(!val||val.length===0)){apex.message.clearErrors();apex.message.showErrors([{type:''error'',location:[''page'',''inline''],pageItem:''P70_''+k+''_LEDGERS'',message:''Select at least one ledger.'',unsafe:false}]);return;}',
'   apex.message.clearErrors();apex.region(''p70-report-''+k).refresh();',
' });});',
' show(sessionStorage.getItem(''p70-tab-&APP_ID.'')||apex.item(''P70_ACTIVE_TAB'').getValue()||''CA'',false);',
' keys.forEach(summary);',
'})();'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.p70-panels [hidden],.p70-panel[hidden]{display:none!important}',
'.p70-processes{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:14px;margin:4px 0 20px}',
'.p70-process{background:var(--ut-region-background-color,#fff);color:var(--ut-body-text-color,#222);border:1px solid var(--ut-component-border-color,#ddd);border-top:3px solid transparent;border-radius:4px;padding:18px;text-align:left;cursor:pointer}',
'.p70-process[aria-selected=true]{border-top-color:var(--ut-palette-primary,#bb2834)}',
'.p70-process strong,.p70-process span{display:block}.p70-process strong{font-size:17px;margin-bottom:8px}.p70-process span{font-size:13px}',
'.p70-filter{border-bottom:1px solid var(--ut-component-border-color,#ddd);padding-bottom:12px}',
'.p70-filter .apex-item-group--popup-lov{height:88px;align-items:stretch}',
'.p70-filter .apex-item-multi{height:88px;min-height:88px;max-height:88px;padding-top:28px!important;padding-bottom:8px!important;box-sizing:border-box;align-content:flex-start;overflow-y:auto}',
'.p70-filter .apex-item-multi:has([data-value])>.apex-item-multi-item:last-child{flex:0 0 1px;min-width:1px;width:1px}',
'.p70-filter .apex-item-multi:has([data-value])>.apex-item-multi-item:last-child input{width:1px!important;min-width:1px!important;max-width:1px!important;padding-left:0;padding-right:0}',
'.p70-filter .a-Button--popupLOV{height:88px;align-self:stretch}',
'.p70-filter .apex-item-select{height:88px;min-height:88px}',
'.p70-panel .a-IRR-header:not(.a-IRR-header--group){background:#edf2f6;color:#243746;border-bottom:2px solid #a5b5c1;font-weight:700}',
'.p70-panel .a-IRR-headerLink{color:inherit;font-weight:700}',
'.p70-panel .a-IRR-header:not(.a-IRR-header--group){text-align:center}',
'.p70-panel .t-fht-thead{box-shadow:0 2px 4px rgba(36,55,70,.12)}',
'#p70-report-RV .a-IRR-tableContainer,#p70-report-RS .a-IRR-tableContainer{max-height:560px;overflow:auto;isolation:isolate}',
'#p70-report-RV .a-IRR-header:not(.a-IRR-header--group),#p70-report-RS .a-IRR-header:not(.a-IRR-header--group){position:sticky;top:0;z-index:2}',
'#p70-report-RV .a-IRR-controls-item--controlBreak,#p70-report-RS .a-IRR-controls-item--controlBreak{display:none!important}',
'.p70-badge{display:inline-block;border-radius:4px;padding:3px 8px;font-weight:500}',
'.p70-good{background:#e6f4eb;color:#185c37}.p70-warn{background:#fff1d6;color:#704500}.p70-bad{background:#fde5e7;color:#9d1521}',
'@media(max-width:640px){.p70-processes{grid-template-columns:1fr}.p70-process{padding:12px}}',
''))
,p_step_template=>4075783602716660119
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(18558063129193156)
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1287000000000003)
,p_plug_name=>'Create Accounting'
,p_static_id=>'p70-CA'
,p_region_name=>'p70-CA'
,p_region_css_classes=>'p70-panel'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>20
,p_plug_item_display_point=>'ABOVE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1287000000000057)
,p_plug_name=>'Reversals'
,p_static_id=>'p70-RS'
,p_region_name=>'p70-RS'
,p_region_css_classes=>'p70-panel'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>40
,p_plug_item_display_point=>'ABOVE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1287000000000031)
,p_plug_name=>'Revaluations'
,p_static_id=>'p70-RV'
,p_region_name=>'p70-RV'
,p_region_css_classes=>'p70-panel'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>30
,p_plug_item_display_point=>'ABOVE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1287000000000004)
,p_plug_name=>'Create Accounting Filters'
,p_static_id=>'p70-filters-CA'
,p_region_name=>'p70-filters-CA'
,p_parent_plug_id=>wwv_flow_imp.id(1287000000000003)
,p_region_css_classes=>'p70-filter'
,p_region_template_options=>'#DEFAULT#:t-Region--noBorder:t-Region--hideHeader'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_item_display_point=>'ABOVE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1287000000000058)
,p_plug_name=>'Reversals Filters'
,p_static_id=>'p70-filters-RS'
,p_region_name=>'p70-filters-RS'
,p_parent_plug_id=>wwv_flow_imp.id(1287000000000057)
,p_region_css_classes=>'p70-filter'
,p_region_template_options=>'#DEFAULT#:t-Region--noBorder:t-Region--hideHeader'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_item_display_point=>'ABOVE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1287000000000032)
,p_plug_name=>'Revaluations Filters'
,p_static_id=>'p70-filters-RV'
,p_region_name=>'p70-filters-RV'
,p_parent_plug_id=>wwv_flow_imp.id(1287000000000031)
,p_region_css_classes=>'p70-filter'
,p_region_template_options=>'#DEFAULT#:t-Region--noBorder:t-Region--hideHeader'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_item_display_point=>'ABOVE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1287000000000001)
,p_plug_name=>'Month-End Activity'
,p_static_id=>'p70-process-selector'
,p_region_name=>'p70-process-selector'
,p_region_template_options=>'#DEFAULT#:t-Region--noBorder:t-Region--noPadding:t-Region--hideHeader'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_plug_source=>'<h1>Month-End Process Monitor</h1><div class="p70-processes" role="tablist" aria-label="Month-end processes"><button type="button" class="p70-process" role="tab" id="p70-tab-CA" aria-controls="p70-CA" aria-selected="true" data-p70-tab="CA"><strong>Cr'
||'eate Accounting</strong><span id="p70-summary-CA">Loading summary...</span><span id="p70-context-CA">AP, AR and Cost Management execution history</span></button><button type="button" class="p70-process" role="tab" id="p70-tab-RV" aria-controls="p70-R'
||'V" aria-selected="false" data-p70-tab="RV"><strong>Revaluations</strong><span id="p70-summary-RV">Loading summary...</span><span id="p70-context-RV">Last 3 revaluation runs per ledger</span></button><button type="button" class="p70-process" role="tab'
||'" id="p70-tab-RS" aria-controls="p70-RS" aria-selected="false" data-p70-tab="RS"><strong>Reversals</strong><span id="p70-summary-RS">Loading summary...</span><span id="p70-context-RS">Last 3 journal reversal runs per ledger</span></button></div>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1287000000000005)
,p_plug_name=>'Create Accounting Executions'
,p_static_id=>'p70-report-CA'
,p_region_name=>'p70-report-CA'
,p_parent_plug_id=>wwv_flow_imp.id(1287000000000003)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_item_display_point=>'ABOVE'
,p_query_type=>'SQL'
,p_plug_source=>'select * from table(xxme_process_monitor_pkg.get_ca_executions(:P70_CA_LEDGERS,:P70_CA_APPS,:P70_CA_VIEW))'
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P70_CA_LEDGERS,P70_CA_APPS,P70_CA_VIEW'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(1287000000000010)
,p_no_data_found_message=>'No completed executions match the selected filters.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_fixed_header=>'REGION'
,p_fixed_header_max_height=>560
,p_lazy_loading=>true
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:XLSX'
,p_enable_mail_download=>'N'
,p_internal_uid=>1287000000000010
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000022)
,p_db_column_name=>'ACCOUNTING_END_DATE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Accounting End Date'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000024)
,p_db_column_name=>'ACCOUNTING_MODE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Accounting Mode'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000019)
,p_db_column_name=>'ACTUAL_COMPLETION_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Actual End Date (UTC)'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH24:MI:SS'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000018)
,p_db_column_name=>'ACTUAL_START_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Actual Start Date (UTC)'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH24:MI:SS'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000025)
,p_db_column_name=>'ERRORS_ONLY'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Errors Only'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000029)
,p_db_column_name=>'GL_BATCH_NAME'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'GL Batch Name'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000021)
,p_db_column_name=>'HOURS_SINCE_RUN'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Hours Since Run'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000016)
,p_db_column_name=>'IS_LATEST'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Latest Successful'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000012)
,p_db_column_name=>'LEDGER_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Ledger Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000013)
,p_db_column_name=>'LEDGER_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Ledger Name'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000011)
,p_db_column_name=>'MODULE'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'SubLedger'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000028)
,p_db_column_name=>'POST_IN_GL'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Post in GL'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000023)
,p_db_column_name=>'PROCESS_CATEGORY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Process Category'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000026)
,p_db_column_name=>'REPORT_STYLE'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Report Style'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000017)
,p_db_column_name=>'REQUESTED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Requested By'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000014)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000020)
,p_db_column_name=>'RUN_MINUTES'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Run Minutes'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000015)
,p_db_column_name=>'STATUS'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Status'
,p_column_html_expression=>'<span class="p70-status-label">#STATUS#</span>'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000027)
,p_db_column_name=>'TRANSFER_TO_GL'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Transfer to GL'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(1287000000000030)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'ca-primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>25
,p_report_columns=>'MODULE:LEDGER_NAME:REQUEST_ID:STATUS:IS_LATEST:REQUESTED_BY:ACTUAL_START_DATE:ACTUAL_COMPLETION_DATE:RUN_MINUTES:HOURS_SINCE_RUN:ACCOUNTING_END_DATE:ACCOUNTING_MODE:TRANSFER_TO_GL:POST_IN_GL'
,p_sort_column_1=>'REQUEST_ID'
,p_sort_direction_1=>'DESC'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1287000000000059)
,p_plug_name=>'Most Recent Reversals'
,p_static_id=>'p70-report-RS'
,p_region_name=>'p70-report-RS'
,p_parent_plug_id=>wwv_flow_imp.id(1287000000000057)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_item_display_point=>'ABOVE'
,p_query_type=>'SQL'
,p_plug_source=>'select * from table(xxme_process_monitor_pkg.get_reversals(:P70_RS_LEDGERS))'
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P70_RS_LEDGERS'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(1287000000000063)
,p_no_data_found_message=>'No matching runs. Select at least one ledger, then Refresh.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_fixed_header=>'REGION'
,p_fixed_header_max_height=>560
,p_lazy_loading=>true
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:XLSX'
,p_enable_mail_download=>'N'
,p_internal_uid=>1287000000000063
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000082)
,p_db_column_name=>'ACCOUNTED_CR'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Accounted Cr'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000081)
,p_db_column_name=>'ACCOUNTED_DR'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Accounted Dr'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000074)
,p_db_column_name=>'BATCH_NAME'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Batch Name'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000075)
,p_db_column_name=>'BATCH_STATUS'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Batch Status'
,p_column_html_expression=>'<span class="p70-status-label">#BATCH_STATUS#</span>'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000080)
,p_db_column_name=>'CURRENCY_CODE'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Currency Code'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000073)
,p_db_column_name=>'JE_BATCH_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Je Batch Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000079)
,p_db_column_name=>'JE_CATEGORY'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Category'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000076)
,p_db_column_name=>'JE_HEADER_ID'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Je Header Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000078)
,p_db_column_name=>'JE_SOURCE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Source'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000077)
,p_db_column_name=>'JOURNAL_NAME'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Journal Name'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000066)
,p_db_column_name=>'LEDGER_CURRENCY'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Ledger Currency'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000065)
,p_db_column_name=>'LEDGER_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Ledger Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000064)
,p_db_column_name=>'LEDGER_NAME'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Ledger Name'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000086)
,p_db_column_name=>'ORIG_BATCH_NAME'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Original Batch'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000083)
,p_db_column_name=>'ORIG_JE_HEADER_ID'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Orig Je Header Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000084)
,p_db_column_name=>'ORIG_JOURNAL_NAME'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Original Journal'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000085)
,p_db_column_name=>'ORIG_PERIOD'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Original Period'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000072)
,p_db_column_name=>'REVERSAL_PERIOD'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Reversal Period'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000070)
,p_db_column_name=>'RUN_BATCHES'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Batches in Run'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000071)
,p_db_column_name=>'RUN_BY'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Run By'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000069)
,p_db_column_name=>'RUN_END'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Run End (UTC)'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH24:MI:SS'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000067)
,p_db_column_name=>'RUN_RANK'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Execution Group'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000068)
,p_db_column_name=>'RUN_START'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Run Start (UTC)'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH24:MI:SS'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(1287000000000087)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'rs-primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>25
,p_report_columns=>'LEDGER_NAME:RUN_RANK:RUN_START:RUN_END:RUN_BATCHES:RUN_BY:REVERSAL_PERIOD:BATCH_NAME:BATCH_STATUS:JOURNAL_NAME:JE_SOURCE:JE_CATEGORY:CURRENCY_CODE:ACCOUNTED_DR:ACCOUNTED_CR:ORIG_JOURNAL_NAME:ORIG_PERIOD:ORIG_BATCH_NAME'
,p_sort_column_1=>'LEDGER_NAME'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'RUN_RANK'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'RUN_START'
,p_sort_direction_3=>'DESC'
,p_break_on=>'LEDGER_NAME:RUN_RANK'
,p_break_enabled_on=>'LEDGER_NAME:RUN_RANK'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1287000000000033)
,p_plug_name=>'Most Recent Revaluations'
,p_static_id=>'p70-report-RV'
,p_region_name=>'p70-report-RV'
,p_parent_plug_id=>wwv_flow_imp.id(1287000000000031)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_item_display_point=>'ABOVE'
,p_query_type=>'SQL'
,p_plug_source=>'select * from table(xxme_process_monitor_pkg.get_revaluations(:P70_RV_LEDGERS))'
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P70_RV_LEDGERS'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(1287000000000037)
,p_no_data_found_message=>'No matching runs. Select at least one ledger, then Refresh.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_fixed_header=>'REGION'
,p_fixed_header_max_height=>560
,p_lazy_loading=>true
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:XLSX'
,p_enable_mail_download=>'N'
,p_internal_uid=>1287000000000037
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000053)
,p_db_column_name=>'ACCOUNTED_CR'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Accounted Cr'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000052)
,p_db_column_name=>'ACCOUNTED_DR'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Accounted Dr'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000047)
,p_db_column_name=>'BATCH_NAME'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Batch Name'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000048)
,p_db_column_name=>'BATCH_STATUS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Batch Status'
,p_column_html_expression=>'<span class="p70-status-label">#BATCH_STATUS#</span>'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000046)
,p_db_column_name=>'JE_BATCH_ID'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Je Batch Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000049)
,p_db_column_name=>'JE_HEADER_ID'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Je Header Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000050)
,p_db_column_name=>'JOURNAL_NAME'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Journal Name'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000040)
,p_db_column_name=>'LEDGER_CURRENCY'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Ledger Currency'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000039)
,p_db_column_name=>'LEDGER_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Ledger Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000038)
,p_db_column_name=>'LEDGER_NAME'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Ledger Name'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000045)
,p_db_column_name=>'PERIOD_NAME'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Period Name'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000051)
,p_db_column_name=>'REVALUED_CURRENCY'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Revalued Currency'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000054)
,p_db_column_name=>'REVERSAL_PERIOD'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Reversal Period'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000055)
,p_db_column_name=>'REVERSAL_STATUS'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Reversal Status'
,p_column_html_expression=>'<span class="p70-status-label">#REVERSAL_STATUS#</span>'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000044)
,p_db_column_name=>'RUN_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Run By'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000043)
,p_db_column_name=>'RUN_END'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Run End (UTC)'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH24:MI:SS'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000041)
,p_db_column_name=>'RUN_RANK'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Execution Group'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1287000000000042)
,p_db_column_name=>'RUN_START'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Run Start (UTC)'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH24:MI:SS'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(1287000000000056)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'rv-primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>25
,p_report_columns=>'LEDGER_NAME:RUN_RANK:PERIOD_NAME:RUN_START:RUN_END:RUN_BY:BATCH_NAME:BATCH_STATUS:JOURNAL_NAME:REVALUED_CURRENCY:ACCOUNTED_DR:ACCOUNTED_CR:REVERSAL_PERIOD:REVERSAL_STATUS'
,p_sort_column_1=>'LEDGER_NAME'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'RUN_RANK'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'RUN_START'
,p_sort_direction_3=>'DESC'
,p_break_on=>'LEDGER_NAME:RUN_RANK'
,p_break_enabled_on=>'LEDGER_NAME:RUN_RANK'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(1287000000000009)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(1287000000000004)
,p_button_name=>'REFRESH_CA'
,p_static_id=>'p70-refresh-CA'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Refresh'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_button_css_classes=>'p70-refresh-CA'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(1287000000000062)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(1287000000000058)
,p_button_name=>'REFRESH_RS'
,p_static_id=>'p70-refresh-RS'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Refresh'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_button_css_classes=>'p70-refresh-RS'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(1287000000000036)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(1287000000000032)
,p_button_name=>'REFRESH_RV'
,p_static_id=>'p70-refresh-RV'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Refresh'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_button_css_classes=>'p70-refresh-RV'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1287000000000002)
,p_name=>'P70_ACTIVE_TAB'
,p_item_sequence=>1
,p_item_default=>'CA'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1287000000000007)
,p_name=>'P70_CA_APPS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(1287000000000004)
,p_prompt=>'Applications'
,p_placeholder=>'All applications'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>'STATIC2:AP - Payables;AP,AR - Receivables;AR,Cost Management;COST'
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_grid_label_column_span=>0
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'NOT_ENTERABLE',
  'initial_fetch', 'FIRST_ROWSET',
  'manual_entry', 'N',
  'multiple', 'Y')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1287000000000006)
,p_name=>'P70_CA_LEDGERS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(1287000000000004)
,p_item_default=>'1003:5001:10001'
,p_prompt=>'Ledgers'
,p_placeholder=>'All in-scope ledgers'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>'select name d, to_char(ledger_id) r from apps.gl_ledgers@ADG where object_type_code = ''L'' and ledger_id in (1003,5001,10001) order by name'
,p_colspan=>4
,p_grid_label_column_span=>0
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'NOT_ENTERABLE',
  'initial_fetch', 'FIRST_ROWSET',
  'manual_entry', 'N',
  'multiple', 'Y')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1287000000000008)
,p_name=>'P70_CA_VIEW'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(1287000000000004)
,p_item_default=>'ALL'
,p_prompt=>'View'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Recent history;ALL,Latest successful only;LATEST'
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_grid_label_column_span=>0
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1287000000000060)
,p_name=>'P70_RS_LEDGERS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(1287000000000058)
,p_item_default=>'1003:5001:10001'
,p_prompt=>'Ledgers *'
,p_placeholder=>'Select ledgers'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>'select name d, to_char(ledger_id) r from apps.gl_ledgers@ADG where object_type_code = ''L'' and ledger_id in (1003,5001,10001) order by name'
,p_colspan=>4
,p_grid_label_column_span=>0
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'NOT_ENTERABLE',
  'initial_fetch', 'FIRST_ROWSET',
  'manual_entry', 'N',
  'multiple', 'Y')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1287000000000061)
,p_name=>'P70_RS_PERIOD'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(1287000000000058)
,p_prompt=>'Reversal period (optional)'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>'select period_name d,period_name r from apps.gl_periods@ADG where adjustment_period_flag=''N'' group by period_name order by max(start_date) desc'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'All periods'
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_grid_label_column_span=>0
,p_display_when_type=>'NEVER'
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'NOT_ENTERABLE',
  'initial_fetch', 'FIRST_ROWSET',
  'manual_entry', 'N',
  'multiple', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1287000000000034)
,p_name=>'P70_RV_LEDGERS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(1287000000000032)
,p_item_default=>'1003:5001:10001'
,p_prompt=>'Ledgers *'
,p_placeholder=>'Select ledgers'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>'select name d, to_char(ledger_id) r from apps.gl_ledgers@ADG where object_type_code = ''L'' and ledger_id in (1003,5001,10001) order by name'
,p_colspan=>4
,p_grid_label_column_span=>0
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'NOT_ENTERABLE',
  'initial_fetch', 'FIRST_ROWSET',
  'manual_entry', 'N',
  'multiple', 'Y')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1287000000000035)
,p_name=>'P70_RV_PERIOD'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(1287000000000032)
,p_prompt=>'Period (optional)'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>'select period_name d,period_name r from apps.gl_periods@ADG where adjustment_period_flag=''N'' group by period_name order by max(start_date) desc'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'All periods'
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_grid_label_column_span=>0
,p_display_when_type=>'NEVER'
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'NOT_ENTERABLE',
  'initial_fetch', 'FIRST_ROWSET',
  'manual_entry', 'N',
  'multiple', 'N')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(1287000000000089)
,p_process_sequence=>5
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Normalize page filters'
,p_static_id=>'normalize-page-filters'
,p_process_sql_clob=>'xxme_process_monitor_pkg.normalize_filters;'
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>1287000000000089
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(1287000000000088)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'P70_SUMMARY'
,p_static_id=>'p70-summary'
,p_process_sql_clob=>'xxme_process_monitor_pkg.emit_summary_json;'
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>1287000000000088
);
end;
/
prompt --application/pages/delete_00071
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>71);
end;
/
prompt --application/pages/page_00071
begin
wwv_flow_imp_page.create_page(
 p_id=>71
,p_name=>'Fixed Assets Month-End Close'
,p_alias=>'FIXED-ASSETS'
,p_step_title=>'Fixed Assets Month-End Close'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(function(){const $=apex.jQuery;',
' function decorate(){const r=$(''#fa71-report'');r.find(''.fa71-status'').each(function(){const s=this.textContent.trim();this.className=''fa71-status fa71-badge ''+(s===''COMPLETE''||s===''COMPLETE (NO GL POSTING)''?''fa71-good'':[''GL NOT POSTED'',''NOT TRANSFERR'
||'ED TO GL'',''ANNUAL CALENDAR - CONFIRM SCOPE''].includes(s)?''fa71-warn'':''fa71-bad'');});',
' r.find(''.fa71-activity'').each(function(){if(this.textContent.trim())this.className=''fa71-activity fa71-badge fa71-note'';});',
' r.find(''.fa71-reconciliation'').each(function(){const s=this.textContent.trim();this.className=''fa71-reconciliation fa71-badge ''+(s===''MATCHED''?''fa71-good'':s===''DIFFERENCE''?''fa71-bad'':''fa71-warn'');});',
' r.find(''.fa71-indicator'').each(function(){this.classList.toggle(''fa71-warn'',/[1-9]/.test(this.textContent));this.classList.toggle(''fa71-badge'',/[1-9]/.test(this.textContent));});}',
' $(''#fa71-report'').on(''apexafterrefresh'',decorate);',
' $(document).on(''click'',''.fa71-refresh'',function(){apex.region(''fa71-report'').refresh();});decorate();})();'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#fa71-filters .apex-item-group--popup-lov,#fa71-filters .apex-item-multi,#fa71-filters .apex-item-select{min-height:76px}',
'#fa71-filters .apex-item-multi{padding-top:26px!important;padding-bottom:6px!important;align-content:flex-start}',
'#fa71-filters .apex-item-multi:has([data-value])>.apex-item-multi-item:last-child{flex:0 0 1px;min-width:1px;width:1px}',
'#fa71-filters .apex-item-multi:has([data-value])>.apex-item-multi-item:last-child input{width:1px!important;min-width:1px!important;padding:0}',
'#fa71-filters .a-Button--popupLOV{min-height:76px}',
'.fa71-intro h1{margin:0 0 8px}.fa71-intro p{margin:6px 0;color:var(--ut-body-text-color,#333)}',
'.fa71-muted{font-size:12px;opacity:.8}',
'.fa71-badge{display:inline-block;padding:4px 8px;border-radius:4px;font-weight:600;white-space:nowrap}',
'.fa71-good{background:#e6f4eb;color:#185c37}.fa71-warn{background:#fff1d6;color:#704500}.fa71-bad{background:#fde5e7;color:#9d1521}.fa71-note{background:var(--ut-component-background-color,#eef0f3);color:var(--ut-body-text-color,#333);font-size:11px}',
'#fa71-report .a-IRR-tableContainer{max-height:560px;overflow:auto;isolation:isolate}',
'#fa71-report .a-IRR-header:not(.a-IRR-header--group){position:sticky;top:0;z-index:2;background:var(--ut-region-header-background-color,#edf2f6);font-weight:700;text-align:center;border-bottom:2px solid var(--ut-component-border-color,#a5b5c1)}',
'#fa71-report .a-IRR-headerLink{color:inherit;font-weight:700}',
''))
,p_step_template=>4075783602716660119
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(18558063129193156)
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(15258152637524983)
,p_plug_name=>'Filters'
,p_static_id=>'filters'
,p_region_name=>'fa71-filters'
,p_region_template_options=>'#DEFAULT#:t-Region--noBorder:t-Region--hideHeader'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>20
,p_plug_item_display_point=>'ABOVE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(15258096844524983)
,p_plug_name=>'Fixed Assets'
,p_static_id=>'fixed-assets'
,p_region_name=>'fa71-intro'
,p_region_template_options=>'#DEFAULT#:t-Region--noBorder:t-Region--hideHeader'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_plug_source=>'<div class="fa71-intro"><h1>Fixed Assets Month-End Close</h1><p>Compare net FA depreciation with final SLA expense and posted GL expense, using expense debits minus credits.</p><p class="fa71-muted">Select a book or difference to open the accounting '
||'bridge and asset details. Unresolved GL mappings require review. Books with GL posting disabled are exempt from the SLA and GL checks.</p></div>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(15258208970524983)
,p_plug_name=>'Fixed Assets Close Status'
,p_static_id=>'fixed-assets-close-status'
,p_region_name=>'fa71-report'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>30
,p_query_type=>'SQL'
,p_plug_source=>'select q.*,apex_page.get_url(p_page=>72,p_clear_cache=>''72'',p_items=>''P72_LEDGER_ID,P72_BOOK_TYPE_CODE,P72_PERIOD_NAME'',p_values=>to_char(q.ledger_id)||'',''||q.book_type_code||'',''||q.period_name) bridge_url from table(xxme_fa_close_pkg.get_close_status(:P71_PERIOD_NAME,:P71_LEDGER_IDS,:P71_BOOK_CLASS)) q'
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_PERIOD_NAME,P71_LEDGER_IDS,P71_BOOK_CLASS'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(15258367436524983)
,p_no_data_found_message=>'No books match the selected filters.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_fixed_header=>'REGION'
,p_fixed_header_max_height=>560
,p_lazy_loading=>true
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:XLSX'
,p_enable_mail_download=>'N'
,p_internal_uid=>15258367436524983
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15261706369524983)
,p_db_column_name=>'ACTIVITY_NOTE'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Activity Note'
,p_column_html_expression=>'<span class="fa71-activity">#ACTIVITY_NOTE#</span>'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15259562752524983)
,p_db_column_name=>'BOOK_CLASS'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Book Class'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15259418956524983)
,p_db_column_name=>'BOOK_TYPE_CODE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'FA Book'
,p_column_link=>'#BRIDGE_URL#'
,p_column_linktext=>'#BOOK_TYPE_CODE#'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15263238529525003)
,p_db_column_name=>'BRIDGE_URL'
,p_display_order=>420
,p_column_identifier=>'AP'
,p_column_label=>'Bridge Url'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15261841015524983)
,p_db_column_name=>'CLOSE_STATUS'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Close Status'
,p_column_html_expression=>'<span class="fa71-status">#CLOSE_STATUS#</span>'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15259359162524983)
,p_db_column_name=>'CURRENCY_CODE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Currency'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15259620579524983)
,p_db_column_name=>'DEPRN_CALENDAR'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Calendar'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15260527640524983)
,p_db_column_name=>'DEPRN_EVENTS'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Deprn Events'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15260091927524983)
,p_db_column_name=>'DEPRN_RUN'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Depreciation Run'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15260784043524983)
,p_db_column_name=>'ENTRIES_NOT_FINAL'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Entries Not Final'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15260808274524983)
,p_db_column_name=>'ENTRIES_NOT_TRANSFERRED'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Entries Not Transferred'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15260477298524983)
,p_db_column_name=>'FA_CATCHUP_AMOUNT'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'FA Catch-up'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15260332623524983)
,p_db_column_name=>'FA_DEPRN_AMOUNT'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'FA Net Depreciation'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15263495051525003)
,p_db_column_name=>'FA_NEGATIVE_DEPRN'
,p_display_order=>440
,p_column_identifier=>'AR'
,p_column_label=>'Fa Negative Deprn'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15260211937524983)
,p_db_column_name=>'FA_NONZERO_ROWS'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Fa Nonzero Rows'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15263324026525003)
,p_db_column_name=>'FA_POSITIVE_DEPRN'
,p_display_order=>430
,p_column_identifier=>'AQ'
,p_column_label=>'Fa Positive Deprn'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15260174028524983)
,p_db_column_name=>'FA_SUMMARY_ROWS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Fa Summary Rows'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15261535805524983)
,p_db_column_name=>'FA_VS_GL_DR_DIFF'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Net FA vs Gross Debits (Legacy)'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15263060020525003)
,p_db_column_name=>'FA_VS_GL_EXPENSE_DIFF'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'FA vs GL Difference'
,p_column_link=>'#BRIDGE_URL#'
,p_column_linktext=>'#FA_VS_GL_EXPENSE_DIFF#'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15261697566524983)
,p_db_column_name=>'GL_BATCH_NAMES'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'GL Batches'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15260924034524983)
,p_db_column_name=>'GL_GROUPS_EXPECTED'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Gl Groups Expected'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15261065340524983)
,p_db_column_name=>'GL_GROUPS_MISSING'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Gl Groups Missing'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15261230338524983)
,p_db_column_name=>'GL_JOURNALS'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Gl Journals'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15261403211524983)
,p_db_column_name=>'GL_JOURNAL_DR_TOTAL'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Whole Journal Debit Total'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15262739287524983)
,p_db_column_name=>'GL_LINE_COUNT'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Gl Line Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15262808412524983)
,p_db_column_name=>'GL_MAPPING_ISSUES'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'GL Mapping Issues'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15262525707524983)
,p_db_column_name=>'GL_POSTED_EXPENSE_CR'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Gl Posted Expense Cr'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15262484794524983)
,p_db_column_name=>'GL_POSTED_EXPENSE_DR'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Gl Posted Expense Dr'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15262967202524983)
,p_db_column_name=>'GL_POSTED_EXPENSE_LINES'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'Gl Posted Expense Lines'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15262601523524983)
,p_db_column_name=>'GL_POSTED_EXPENSE_NET'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Posted GL Net Expense'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15261175918524983)
,p_db_column_name=>'GL_SHARED_GROUPS'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Shared GL Groups'
,p_column_html_expression=>'<span class="fa71-indicator">#GL_SHARED_GROUPS#</span>'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15261387263524983)
,p_db_column_name=>'GL_UNPOSTED'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Gl Unposted'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15259144676524983)
,p_db_column_name=>'LEDGER_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Ledger Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15259203136524983)
,p_db_column_name=>'LEDGER_NAME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Ledger'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15262306037524983)
,p_db_column_name=>'ORPHAN_ASSET_LINES'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Orphan Asset Lines'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15259902941524983)
,p_db_column_name=>'PERIOD_CLOSE_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Period Close Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH24:MI:SS'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15259791905524983)
,p_db_column_name=>'PERIOD_NAME'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Period'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15259878540524983)
,p_db_column_name=>'PERIOD_STATUS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Period Status'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15263120539525003)
,p_db_column_name=>'RECONCILIATION_STATUS'
,p_display_order=>410
,p_column_identifier=>'AO'
,p_column_label=>'Reconciliation'
,p_column_html_expression=>'<span class="fa71-reconciliation">#RECONCILIATION_STATUS#</span>'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15262082613524983)
,p_db_column_name=>'SLA_EXPENSE_CR'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Sla Expense Cr'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15261923057524983)
,p_db_column_name=>'SLA_EXPENSE_DR'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Sla Expense Dr'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15262265840524983)
,p_db_column_name=>'SLA_EXPENSE_LINES'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Sla Expense Lines'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15262148156524983)
,p_db_column_name=>'SLA_EXPENSE_NET'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'SLA Net Expense'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15263549705525003)
,p_db_column_name=>'SLA_PERIOD_MISMATCH_LINES'
,p_display_order=>450
,p_column_identifier=>'AS'
,p_column_label=>'Sla Period Mismatch Lines'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15263616456525003)
,p_db_column_name=>'SLA_UNLINKED_LINES'
,p_display_order=>460
,p_column_identifier=>'AT'
,p_column_label=>'Sla Unlinked Lines'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15260604713524983)
,p_db_column_name=>'UNACCOUNTED_EVENTS'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Unaccounted Events'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(15258429503524983)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'fa-close-primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>25
,p_report_columns=>'LEDGER_NAME:BOOK_TYPE_CODE:PERIOD_NAME:CURRENCY_CODE:CLOSE_STATUS:FA_DEPRN_AMOUNT:SLA_EXPENSE_NET:GL_POSTED_EXPENSE_NET:FA_VS_GL_EXPENSE_DIFF:RECONCILIATION_STATUS'
,p_sort_column_1=>'LEDGER_NAME'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'BOOK_CLASS'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'BOOK_TYPE_CODE'
,p_sort_direction_3=>'ASC'
,p_break_on=>'LEDGER_NAME'
,p_break_enabled_on=>'LEDGER_NAME'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(15258522740524983)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(15258152637524983)
,p_button_name=>'REFRESH'
,p_static_id=>'refresh'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Refresh'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_button_css_classes=>'fa71-refresh'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15259005952524983)
,p_name=>'P71_BOOK_CLASS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(15258152637524983)
,p_item_default=>'CORPORATE'
,p_prompt=>'Book class'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Corporate;CORPORATE,Tax;TAX'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'All book classes'
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_grid_label_column_span=>0
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15258986276524983)
,p_name=>'P71_LEDGER_IDS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(15258152637524983)
,p_item_default=>'1003:5001:10001'
,p_prompt=>'Ledgers'
,p_placeholder=>'All in-scope ledgers'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>'select name d,to_char(ledger_id) r from apps.gl_ledgers@ADG where object_type_code=''L'' and ledger_id in (1003,5001,10001) order by name'
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_grid_label_column_span=>0
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'NOT_ENTERABLE',
  'initial_fetch', 'FIRST_ROWSET',
  'manual_entry', 'N',
  'multiple', 'Y')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15258807836524983)
,p_name=>'P71_PERIOD_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(15258152637524983)
,p_prompt=>'Period'
,p_placeholder=>'Previous month'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>'select dp.period_name d,dp.period_name r from apps.fa_deprn_periods@ADG dp,apps.fa_book_controls@ADG bc where bc.book_type_code=dp.book_type_code and bc.set_of_books_id in (1003,5001,10001) and bc.date_ineffective is null and dp.period_open_date>add_'
||'months(sysdate,-24) group by dp.period_name order by max(dp.period_counter) desc'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'Previous month'
,p_colspan=>4
,p_grid_label_column_span=>0
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'NOT_ENTERABLE',
  'initial_fetch', 'FIRST_ROWSET',
  'manual_entry', 'N',
  'multiple', 'N')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(15258690378524983)
,p_process_sequence=>5
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Normalize Fixed Assets filters'
,p_static_id=>'normalize-fixed-assets-filters'
,p_process_sql_clob=>'xxme_fa_close_pkg.normalize_p71_filters;'
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>15258690378524983
);
end;
/
prompt --application/pages/delete_00072
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>72);
end;
/
prompt --application/pages/page_00072
begin
wwv_flow_imp_page.create_page(
 p_id=>72
,p_name=>'Fixed Assets Accounting Bridge'
,p_alias=>'FIXED-ASSETS-BRIDGE'
,p_page_mode=>'MODAL'
,p_step_title=>'Fixed Assets Accounting Bridge'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code_onload=>'(function(){const $=apex.jQuery;function decorate(){document.querySelectorAll(''.fa72-activity'').forEach(el=>el.classList.toggle(''fa72-negative'',el.textContent.trim()===''NEGATIVE DEPRECIATION''));}function explainSlaLink(){const help="MAPPED: GL line r'
||'eferences resolve consistently to SLA depreciation for the selected FA book, ledger and period, with one accounting class. REVIEW MAPPING: references are missing, unresolved or span conflicting books, ledgers, periods or accounting classes. A GL line'
||' may summarize multiple assets; posting status is checked separately.";document.querySelectorAll(''#fa72-gl-lines th'').forEach(th=>{const link=th.querySelector(''a'');if((link?link.textContent:th.textContent).trim()===''SLA Link Status''){th.title=help;if'
||'(link){link.title=help;link.setAttribute(''aria-label'',''SLA Link Status. ''+help);}}});}$(''#fa72-assets'').on(''apexafterrefresh'',decorate);$(''#fa72-gl-lines'').on(''apexafterrefresh'',explainSlaLink);decorate();explainSlaLink();})();'
,p_inline_css=>'.fa72-context h2{margin-top:0}.fa72-subtle{font-size:12px;opacity:.8}.fa72-stage{width:100%;border-collapse:collapse;margin:12px 0}.fa72-stage th,.fa72-stage td{padding:9px 12px;border-bottom:1px solid var(--ut-component-border-color,#ddd)}.fa72-stag'
||'e td:not(:first-child),.fa72-stage th:not(:first-child){text-align:right}.fa72-status{padding:6px 10px;border-radius:4px;display:inline-block;font-weight:600}.fa72-good{background:#e6f4eb;color:#185c37}.fa72-warn{background:#fff1d6;color:#704500}.fa7'
||'2-negative{background:#fff1d6;color:#704500;font-weight:600;padding:3px 6px;border-radius:3px}.fa72-diff{font-weight:600}#fa72-assets .a-IRR-tableContainer,#fa72-gl-lines .a-IRR-tableContainer{max-height:420px;overflow:auto}#fa72-assets .a-IRR-header'
||',#fa72-gl-lines .a-IRR-header{font-weight:700;text-align:center}'
,p_step_template=>2103835248774687739
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(18558063129193156)
,p_dialog_title=>'Fixed Assets Accounting Bridge'
,p_dialog_height=>'850'
,p_dialog_width=>'1450'
,p_dialog_chained=>'N'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(15400188370111723)
,p_plug_name=>'Actual GL Journal Lines'
,p_static_id=>'actual-gl-journal-lines'
,p_region_name=>'fa72-gl-lines'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>30
,p_query_type=>'SQL'
,p_plug_source=>'select * from table(xxme_fa_close_pkg.get_gl_lines(to_number(:P72_LEDGER_ID),:P72_BOOK_TYPE_CODE,:P72_PERIOD_NAME))'
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P72_LEDGER_ID,P72_BOOK_TYPE_CODE,P72_PERIOD_NAME'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(15403299931111723)
,p_no_data_found_message=>'No rows for this book and period.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_fixed_header=>'REGION'
,p_fixed_header_max_height=>420
,p_lazy_loading=>true
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:XLSX'
,p_enable_mail_download=>'N'
,p_internal_uid=>15403299931111723
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15404366869111723)
,p_db_column_name=>'ACCOUNTED_CR'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'GL Credit'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15404222754111723)
,p_db_column_name=>'ACCOUNTED_DR'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'GL Debit'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15404457861111723)
,p_db_column_name=>'ACCOUNTING_CLASS_CODE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Accounting Class'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15404617244111723)
,p_db_column_name=>'ACCOUNT_CODE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Account'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15403840117111723)
,p_db_column_name=>'BATCH_NAME'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Batch'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15403452486111723)
,p_db_column_name=>'BOOK_TYPE_CODE'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'FA Book'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15404126525111723)
,p_db_column_name=>'CODE_COMBINATION_ID'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Account Combination ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15403686863111723)
,p_db_column_name=>'JE_HEADER_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Journal ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15404042804111723)
,p_db_column_name=>'JE_LINE_NUM'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Line'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15403763507111723)
,p_db_column_name=>'JOURNAL_NAME'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Journal'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15403334405111723)
,p_db_column_name=>'LEDGER_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Ledger ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15404577741111723)
,p_db_column_name=>'MAPPING_STATUS'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'SLA Link Status'
,p_column_html_expression=>'<span class="fa72-sla-link" tabindex="0" title="MAPPED: GL line references resolve consistently to SLA depreciation for the selected FA book, ledger and period, with one accounting class. REVIEW MAPPING: references are missing, unresolved or span con'
||'flicting books, ledgers, periods or accounting classes. A GL line may summarize multiple assets; posting status is checked separately." aria-label="#MAPPING_STATUS#. MAPPED: GL line references resolve consistently to SLA depreciation for the selected'
||' FA book, ledger and period, with one accounting class. REVIEW MAPPING: references are missing, unresolved or span conflicting books, ledgers, periods or accounting classes. A GL line may summarize multiple assets; posting status is checked separatel'
||'y.">#MAPPING_STATUS#</span>'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15403545537111723)
,p_db_column_name=>'PERIOD_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Period'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15403975088111723)
,p_db_column_name=>'STATUS'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Posting Status'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(15404797619111723)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'fa72-gl-lines-primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>25
,p_report_columns=>'JOURNAL_NAME:STATUS:JE_LINE_NUM:ACCOUNT_CODE:ACCOUNTING_CLASS_CODE:ACCOUNTED_DR:ACCOUNTED_CR:MAPPING_STATUS'
,p_sort_column_1=>'JE_HEADER_ID'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'JE_LINE_NUM'
,p_sort_direction_2=>'ASC'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(15400057446111723)
,p_plug_name=>'Asset Details'
,p_static_id=>'asset-details'
,p_region_name=>'fa72-assets'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>20
,p_query_type=>'SQL'
,p_plug_source=>'select * from table(xxme_fa_close_pkg.get_asset_details(to_number(:P72_LEDGER_ID),:P72_BOOK_TYPE_CODE,:P72_PERIOD_NAME))'
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P72_LEDGER_ID,P72_BOOK_TYPE_CODE,P72_PERIOD_NAME'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(15400921190111723)
,p_no_data_found_message=>'No rows for this book and period.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_fixed_header=>'REGION'
,p_fixed_header_max_height=>420
,p_lazy_loading=>true
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:XLSX'
,p_enable_mail_download=>'N'
,p_internal_uid=>15400921190111723
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15402092671111723)
,p_db_column_name=>'ACTIVITY_TYPE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Activity'
,p_column_html_expression=>'<span class="fa72-activity">#ACTIVITY_TYPE#</span>'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15401361576111723)
,p_db_column_name=>'ASSET_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Asset ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15401497393111723)
,p_db_column_name=>'ASSET_NUMBER'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Asset'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15401192521111723)
,p_db_column_name=>'BOOK_TYPE_CODE'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'FA Book'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15401526378111723)
,p_db_column_name=>'DEPRN_RUN_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Depreciation Run'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH24:MI:SS'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15401789578111723)
,p_db_column_name=>'FA_CATCHUP_AMOUNT'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'FA Catch-up'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15401626389111723)
,p_db_column_name=>'FA_DEPRN_AMOUNT'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'FA Net Depreciation'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15402586143111723)
,p_db_column_name=>'FA_SLA_DIFFERENCE'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'FA vs SLA Difference'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15401012155111723)
,p_db_column_name=>'LEDGER_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Ledger ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15401985999111723)
,p_db_column_name=>'NEGATIVE_DEPRN'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Negative Depreciation'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15401227195111723)
,p_db_column_name=>'PERIOD_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Period'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15401899232111723)
,p_db_column_name=>'POSITIVE_DEPRN'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Positive Depreciation'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15402829121111723)
,p_db_column_name=>'POSTED_LINKED_LINES'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Posted-linked Lines'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15402426637111723)
,p_db_column_name=>'POSTED_LINKED_SLA_NET'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Posted-linked SLA Expense'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15402275368111723)
,p_db_column_name=>'SLA_EXPENSE_CR'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'SLA Expense Credit'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15402143581111723)
,p_db_column_name=>'SLA_EXPENSE_DR'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'SLA Expense Debit'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15402770734111723)
,p_db_column_name=>'SLA_EXPENSE_LINES'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'SLA Expense Lines'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15402390778111723)
,p_db_column_name=>'SLA_EXPENSE_NET'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'SLA Net Expense'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15403083933111723)
,p_db_column_name=>'SLA_PERIOD_MISMATCH_LINES'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Accounting-period Mismatch Lines'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15402629478111723)
,p_db_column_name=>'SLA_POSTED_LINK_DIFFERENCE'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'SLA vs Posted-link Difference'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15402973197111723)
,p_db_column_name=>'UNLINKED_EXPENSE_LINES'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Unlinked Expense Lines'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(15403177613111723)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'fa72-assets-primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>25
,p_report_columns=>'ASSET_NUMBER:ACTIVITY_TYPE:FA_DEPRN_AMOUNT:SLA_EXPENSE_DR:SLA_EXPENSE_CR:SLA_EXPENSE_NET:POSTED_LINKED_SLA_NET:FA_SLA_DIFFERENCE:SLA_POSTED_LINK_DIFFERENCE:UNLINKED_EXPENSE_LINES'
,p_sort_column_1=>'FA_DEPRN_AMOUNT'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'ASSET_NUMBER'
,p_sort_direction_2=>'ASC'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(15399985153111723)
,p_plug_name=>'FA to SLA to GL Bridge'
,p_static_id=>'fa-to-sla-to-gl-bridge'
,p_region_name=>'fa72-bridge'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>10
,p_plug_source=>'xxme_fa_close_pkg.render_bridge(to_number(:P72_LEDGER_ID),:P72_BOOK_TYPE_CODE,:P72_PERIOD_NAME);'
,p_plug_source_type=>'NATIVE_PLSQL'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(15400306008111723)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(15399985153111723)
,p_button_name=>'CLOSE_BRIDGE'
,p_static_id=>'close-bridge'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Back to Fixed Assets'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-arrow-left'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15400774650111723)
,p_name=>'P72_BOOK_TYPE_CODE'
,p_item_sequence=>20
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15400624678111723)
,p_name=>'P72_LEDGER_ID'
,p_item_sequence=>10
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15400877747111723)
,p_name=>'P72_PERIOD_NAME'
,p_item_sequence=>30
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(15400409446111723)
,p_name=>'Close accounting bridge'
,p_static_id=>'close-accounting-bridge'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(15400306008111723)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15400578105111723)
,p_event_id=>wwv_flow_imp.id(15400409446111723)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'apex.navigation.dialog.close(true);')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(15400238390111723)
,p_process_sequence=>5
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Validate Fixed Assets context'
,p_static_id=>'validate-fixed-assets-context'
,p_process_sql_clob=>'xxme_fa_close_pkg.validate_p72_context;'
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>15400238390111723
);
end;
/
prompt --application/end_environment
declare
  l_cnt number;
begin
  select count(*)
    into l_cnt
    from apex_application_pages
   where application_id = 128
     and page_id in (60, 61, 70, 71, 72);
  if l_cnt <> 5 then
    rollback;
    apex_application_install.clear_all;
    raise_application_error(-20998, 'Aborted App 128 Wave 2 commit: expected 5 patched pages, found ' || l_cnt);
  end if;
  wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false)
  );
  commit;
  apex_application_install.clear_all;
end;
/
whenever sqlerror continue none
set verify on feedback on define on
prompt  ...done