prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
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
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2026.04.07'
,p_release=>'26.2.0'
,p_default_workspace_id=>100789
,p_default_application_id=>115
,p_default_id_offset=>9156328499369442
,p_default_owner=>'GL_ACCOUNTS'
);
end;
/
 
prompt APPLICATION 115 - TMS GBS Control Tower
--
-- Application Export:
--   Application:     115
--   Name:            TMS GBS Control Tower
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
'  $("#R264744415640464852_heading").text("Inventory Organizations - " + ledgerNames[ledgerId] + " - " + monthName);',
'  $("#R264744415640464852").show();',
'  window.setTimeout(function () {',
'    document.getElementById("R264744415640464852").scrollIntoView({behavior:"auto", block:"start"});',
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
'#R264744415640464852 {',
'  display: none;',
'  margin-top: 16px;',
'}',
'#R264744415640464852 .t-Report-cell:nth-child(5) {',
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
':is(#R264744415640464851, #R264744415640464852) {',
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
'body.tms-dark-mode :is(#R264744415640464851, #R264744415640464852) {',
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
':is(#R264744415640464851, #R264744415640464852) .t-Report-report {',
'  background: var(--p60-panel);',
'  color: var(--p60-text);',
'}',
':is(#R264744415640464851, #R264744415640464852) .t-Report-report th {',
'  background: var(--p60-header) !important;',
'  color: var(--p60-header-text) !important;',
'  border-color: var(--p60-line) !important;',
'}',
':is(#R264744415640464851, #R264744415640464852) .t-Report-report td {',
'  background: var(--p60-row-odd);',
'  color: var(--p60-text);',
'  border-color: var(--p60-line);',
'}',
':is(#R264744415640464851, #R264744415640464852) .t-Report-report tr:nth-child(even) td {',
'  background: var(--p60-row-even);',
'}',
':is(#R264744415640464851, #R264744415640464852) .xxme-period-status {',
'  border: 1px solid transparent;',
'  color: var(--p60-text);',
'}',
':is(#R264744415640464851, #R264744415640464852) .xxme-period-status-OPEN {',
'  background: var(--p60-open-bg); color: var(--p60-open-text);',
'}',
':is(#R264744415640464851, #R264744415640464852) .xxme-period-status-CLOSED {',
'  background: var(--p60-closed-bg); color: var(--p60-closed-text);',
'}',
':is(#R264744415640464851, #R264744415640464852) .xxme-period-status-PERMANENT {',
'  background: var(--p60-permanent-bg); color: var(--p60-permanent-text);',
'}',
':is(#R264744415640464851, #R264744415640464852) .xxme-period-status-NEVER {',
'  background: var(--p60-never-bg); color: var(--p60-never-text);',
'}',
':is(#R264744415640464851, #R264744415640464852) .xxme-period-status-FUTURE {',
'  background: var(--p60-future-bg); color: var(--p60-future-text);',
'}',
':is(#R264744415640464851, #R264744415640464852) .xxme-period-status-UNKNOWN {',
'  background: var(--p60-error-bg); color: var(--p60-error-text);',
'}',
':is(#R264744415640464851, #R264744415640464852) .xxme-period-status-MIXED {',
'  background: var(--p60-panel); color: var(--p60-accent); border-color: var(--p60-accent);',
'}',
':is(#R264744415640464851, #R264744415640464852) a.p60-pending-count {',
'  color: var(--p60-accent);',
'}',
'#R264744415640464851 .xxme-inventory-drill:focus-visible {',
'  outline: 2px solid var(--p60-accent); outline-offset: 3px; border-radius: 16px;',
'}'))
,p_step_template=>4075783602716660119
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(9156329399484443)
,p_protection_level=>'C'
,p_page_component_map=>'03'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(264744415640464845)
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
,p_menu_id=>wwv_flow_imp.id(190034115494711636)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4075790987805660140
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(264744415640464852)
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
'  apps.wsh_new_deliveries@ADG wnd, apps.wsh_delivery_assignments_v@ADG wda,',
'  apps.wsh_delivery_details@ADG wdd, apps.org_acct_periods@ADG ship_oap',
'where wts.pending_interface_flag in (''Y'',''P'') and wdl.pick_up_stop_id=wts.stop_id',
'  and wnd.delivery_id=wdl.delivery_id and wnd.status_code in (''CL'',''IT'')',
'  and wda.delivery_id=wnd.delivery_id and wdd.delivery_detail_id=wda.delivery_detail_id',
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
 p_id=>wwv_flow_imp.id(1156062800000001)
,p_query_column_id=>3
,p_column_alias=>'OPERATING_UNIT'
,p_column_display_sequence=>30
,p_column_heading=>'Operating Unit'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(264744415640464870)
,p_query_column_id=>1
,p_column_alias=>'ORGANIZATION_CODE'
,p_column_display_sequence=>10
,p_column_heading=>'Organization Code'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(264744415640464871)
,p_query_column_id=>2
,p_column_alias=>'ORGANIZATION_NAME'
,p_column_display_sequence=>20
,p_column_heading=>'Inventory Organization'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(264744415640464875)
,p_query_column_id=>7
,p_column_alias=>'PERIOD_CLOSE_DATE'
,p_column_display_sequence=>70
,p_column_heading=>'Period Close Date'
,p_column_format=>'DD-MON-YYYY'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(264744415640464872)
,p_query_column_id=>4
,p_column_alias=>'PERIOD_STATUS'
,p_column_display_sequence=>40
,p_column_heading=>'Period Status'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(264744415640464873)
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
 p_id=>wwv_flow_imp.id(264744415640464874)
,p_query_column_id=>6
,p_column_alias=>'SCHEDULE_CLOSE_DATE'
,p_column_display_sequence=>60
,p_column_heading=>'Scheduled Close Date'
,p_column_format=>'DD-MON-YYYY'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(264744415640464850)
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
 p_id=>wwv_flow_imp.id(264744415640464851)
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
 p_id=>wwv_flow_imp.id(264744415640464860)
,p_query_column_id=>1
,p_column_alias=>'SUBLEDGER'
,p_column_display_sequence=>10
,p_column_heading=>'Subledger'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(264744415640464865)
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
 p_id=>wwv_flow_imp.id(264744415640464864)
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
 p_id=>wwv_flow_imp.id(264744415640464863)
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
 p_id=>wwv_flow_imp.id(264744415640464868)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(264744415640464850)
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
 p_id=>wwv_flow_imp.id(264744415640464869)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(264744415640464850)
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
 p_id=>wwv_flow_imp.id(264744415640464880)
,p_name=>'P60_DB_LINK'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(264744415640464850)
,p_item_default=>'ADG'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_cHeight=>1
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1156062800000002)
,p_name=>'P60_HIDE_NO_PERIOD'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(264744415640464852)
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
 p_id=>wwv_flow_imp.id(264744415640464881)
,p_name=>'P60_INV_LEDGER_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(264744415640464850)
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_cHeight=>1
,p_tag_css_classes=>'js-ignoreChange'
,p_warn_on_unsaved_changes=>'I'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(264744415640464879)
,p_name=>'P60_MONTH_OFFSET'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(264744415640464850)
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
 p_id=>wwv_flow_imp.id(264744415640464891)
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
 p_id=>wwv_flow_imp.id(264744415640464895)
,p_event_id=>wwv_flow_imp.id(264744415640464891)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'Hide Inventory Details'
,p_static_id=>'hide-inventory-details'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'apex.item("P60_INV_LEDGER_ID").setValue("", null, true);',
    '$("#R264744415640464852").hide();')))).to_clob
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(264744415640464892)
,p_event_id=>wwv_flow_imp.id(264744415640464891)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_name=>'Refresh Status Matrix'
,p_static_id=>'refresh-status-matrix'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(264744415640464851)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'maintain_pagination', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(264744415640464887)
,p_name=>'Close'
,p_static_id=>'close'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(264744415640464868)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(264744415640464888)
,p_event_id=>wwv_flow_imp.id(264744415640464887)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'close-window'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'window.close();')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(1156062800000003)
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
 p_id=>wwv_flow_imp.id(1156062800000004)
,p_event_id=>wwv_flow_imp.id(1156062800000003)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-refresh'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(264744415640464852)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(264744415640464889)
,p_name=>'Refresh Period Status'
,p_static_id=>'refresh-period-status'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(264744415640464869)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(264744415640464890)
,p_event_id=>wwv_flow_imp.id(264744415640464889)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'Refresh Status Report'
,p_static_id=>'refresh-status-report'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(264744415640464851)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'maintain_pagination', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(264744415640464893)
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
 p_id=>wwv_flow_imp.id(264744415640464894)
,p_event_id=>wwv_flow_imp.id(264744415640464893)
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
    '$("#R264744415640464852_heading").text("Inventory Organizations - " + ledgerName + " - " + monthName);',
    '$("#R264744415640464852").show();',
    'document.getElementById("R264744415640464852").scrollIntoView({behavior:"smooth", block:"start"});')))).to_clob
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(264744415640464896)
,p_event_id=>wwv_flow_imp.id(264744415640464893)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_name=>'Refresh Inventory Details'
,p_static_id=>'refresh-inventory-details'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(264744415640464852)
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
,p_required_role=>wwv_flow_imp.id(9156329399484443)
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(345926542559657942)
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
,p_menu_id=>wwv_flow_imp.id(190034115494711636)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4075790987805660140
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(317992543199452948)
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
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(345926542559657955)
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
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_run_id varchar2(32):=upper(apex_util.get_session_state(''P61_RUN_ID''));',
'  l_period varchar2(15); l_source varchar2(30); l_resolution varchar2(20);',
'  l_org number; l_type varchar2(80); l_sql varchar2(32767);',
'begin',
'  -- P61_SERVER_CONTEXT_V1: no accepted run ID means no inventory query.',
'  if l_run_id is null then return q''~select cast(null as number) organization_id,',
'       cast(null as varchar2(15)) period_name,',
'       cast(null as date) period_start_date,',
'       cast(null as date) schedule_close_date,',
'       cast(null as varchar2(240)) organization_name,',
'       cast(null as varchar2(80)) transaction_type,',
'       cast(null as date) transaction_date,',
'       cast(null as varchar2(20)) resolution,',
'       cast(null as varchar2(40)) transaction_ref,',
'       cast(null as varchar2(240)) transaction_ref_id,',
'       cast(null as varchar2(240)) transaction_type_name,',
'       cast(null as varchar2(240)) item from dual where 1=0~''; end if;',
'  if not regexp_like(l_run_id,''^[0-9A-F]{32}$'',''c'') then',
'    raise_application_error(-20163,''Invalid run context. Run Analysis again.'');',
'  end if;',
'  begin',
'    select c001,c002,c003 into l_period,l_source,l_resolution',
'    from apex_collections where collection_name=''P61RUN_''||l_run_id and seq_id=1;',
'  exception when no_data_found then',
'    raise_application_error(-20163,''This run has expired. Run Analysis again.'');',
'  end;',
'  if l_source is null or l_source not in (''ADG'')',
'    or l_period is null or not regexp_like(l_period,''^(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)-[0-9]{4}$'',''c'')',
'    or l_resolution is null or l_resolution not in (''REQUIRED'',''RECOMMENDED'',''ALL'') then',
'    raise_application_error(-20163,''Invalid accepted run. Run Analysis again.'');',
'  end if;',
'  select n001,c001 into l_org,l_type',
'  from apex_collections where collection_name=''P61RUN_''||l_run_id and seq_id=2;',
'  if l_org is null and l_type is null then return q''~select cast(null as number) organization_id,',
'       cast(null as varchar2(15)) period_name,',
'       cast(null as date) period_start_date,',
'       cast(null as date) schedule_close_date,',
'       cast(null as varchar2(240)) organization_name,',
'       cast(null as varchar2(80)) transaction_type,',
'       cast(null as date) transaction_date,',
'       cast(null as varchar2(20)) resolution,',
'       cast(null as varchar2(40)) transaction_ref,',
'       cast(null as varchar2(240)) transaction_ref_id,',
'       cast(null as varchar2(240)) transaction_type_name,',
'       cast(null as varchar2(240)) item from dual where 1=0~''; end if;',
'  if l_org is null or l_org<=0 or l_org<>trunc(l_org) or l_type is null or l_type not in (''Unprocessed Material'',''Uncosted Material/WSM'',''Pending WIP Costing'',''Pending WSM Interface'',''Pending LCM Interface'',''Unprocessed Shipping Transactions'',''Pendin'
||'g Receiving'',''Pending Material'',''Pending Shop Floor Move'',''Incomplete Work Orders'',''__TOTAL_REQUIRED__'',''__TOTAL_RECOMMENDED__'',''__TOTAL_ALL__'') then',
'    raise_application_error(-20164,''Select a valid exception count again.'');',
'  end if;',
'  if (l_resolution=''REQUIRED'' and (l_type in (''Pending Receiving'',''Pending Material'',''Pending Shop Floor Move'',''Incomplete Work Orders'') or l_type in (''__TOTAL_RECOMMENDED__'',''__TOTAL_ALL__'')))',
'    or (l_resolution=''RECOMMENDED'' and (l_type in (''Unprocessed Material'',''Uncosted Material/WSM'',''Pending WIP Costing'',''Pending WSM Interface'',''Pending LCM Interface'',''Unprocessed Shipping Transactions'') or l_type in (''__TOTAL_REQUIRED__'',''__TOTAL_A'
||'LL__'')))',
'    or (l_resolution=''ALL'' and l_type in (''__TOTAL_REQUIRED__'',''__TOTAL_RECOMMENDED__'')) then',
'    raise_application_error(-20168,''Selected category does not belong to the accepted Resolution.'');',
'  end if;',
'  -- Query text is unchanged; bind placeholders are replaced using validated server-owned values.',
'  l_sql:=q''~select organization_id, period_name, period_start_date, schedule_close_date,',
'       organization_name, transaction_type, transaction_date, resolution,',
'       transaction_ref, transaction_ref_id, transaction_type_name, item',
'  from table(xxme_inv_pending_dtl_v3_pkg.get_details(',
'       :P61_PERIOD_NAME, to_number(:P61_ORG_ID), :P61_TXN_TYPE, :P61_DB_LINK))~'';',
'  l_sql:=replace(l_sql,'':P61_PERIOD_NAME'',dbms_assert.enquote_literal(l_period));',
'  l_sql:=replace(l_sql,'':P61_DB_LINK'',dbms_assert.enquote_literal(l_source));',
'  l_sql:=replace(l_sql,'':P61_RESOLUTION'',dbms_assert.enquote_literal(l_resolution));',
'  l_sql:=replace(l_sql,'':P61_ORG_ID'',to_char(l_org,''FM99999999999999999990''));',
'  l_sql:=replace(l_sql,'':P61_TXN_TYPE'',dbms_assert.enquote_literal(l_type));',
'  return l_sql;',
'end;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P61_RUN_ID'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(345926542559658152)
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
 p_id=>wwv_flow_imp.id(345926542559658173)
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
 p_id=>wwv_flow_imp.id(345926542559658162)
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
 p_id=>wwv_flow_imp.id(345926542559658166)
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
 p_id=>wwv_flow_imp.id(345926542559658163)
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
 p_id=>wwv_flow_imp.id(345926542559658164)
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
 p_id=>wwv_flow_imp.id(345926542559658169)
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
 p_id=>wwv_flow_imp.id(345926542559658165)
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
 p_id=>wwv_flow_imp.id(345926542559658168)
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
 p_id=>wwv_flow_imp.id(345926542559658170)
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
 p_id=>wwv_flow_imp.id(345926542559658171)
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
 p_id=>wwv_flow_imp.id(345926542559658167)
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
 p_id=>wwv_flow_imp.id(345926542559658172)
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
 p_id=>wwv_flow_imp.id(345926542559658182)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>100000
,p_report_columns=>'PERIOD_NAME:ORGANIZATION_NAME:TRANSACTION_TYPE:TRANSACTION_DATE:RESOLUTION:TRANSACTION_REF:TRANSACTION_REF_ID:TRANSACTION_TYPE_NAME:ITEM'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(345926542559657956)
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
 p_id=>wwv_flow_imp.id(345926542559657953)
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
 p_id=>wwv_flow_imp.id(345926542559657954)
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
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_run_id varchar2(32):=upper(apex_util.get_session_state(''P61_RUN_ID''));',
'  l_period varchar2(15); l_source varchar2(30); l_resolution varchar2(20);',
'  l_org number; l_type varchar2(80); l_sql varchar2(32767);',
'begin',
'  -- P61_SERVER_CONTEXT_V1: no accepted run ID means no inventory query.',
'  if l_run_id is null then return q''~select cast(null as varchar2(30)) organization_code,',
'       cast(null as varchar2(240)) organization_name,',
'       cast(null as varchar2(4000)) unprocessed_material_count,',
'       cast(null as varchar2(4000)) uncosted_material_wsm_count,',
'       cast(null as varchar2(4000)) pending_wip_costing_count,',
'       cast(null as varchar2(4000)) pending_wsm_interface_count,',
'       cast(null as varchar2(4000)) pending_lcm_interface_count,',
'       cast(null as varchar2(4000)) unprocessed_shipping_count,',
'       cast(null as varchar2(4000)) pending_receiving_count,',
'       cast(null as varchar2(4000)) pending_material_count,',
'       cast(null as varchar2(4000)) pending_shop_floor_move_count,',
'       cast(null as varchar2(4000)) incomplete_work_orders_count,',
'       cast(null as varchar2(4000)) total_count from dual where 1=0~''; end if;',
'  if not regexp_like(l_run_id,''^[0-9A-F]{32}$'',''c'') then',
'    raise_application_error(-20163,''Invalid run context. Run Analysis again.'');',
'  end if;',
'  begin',
'    select c001,c002,c003 into l_period,l_source,l_resolution',
'    from apex_collections where collection_name=''P61RUN_''||l_run_id and seq_id=1;',
'  exception when no_data_found then',
'    raise_application_error(-20163,''This run has expired. Run Analysis again.'');',
'  end;',
'  if l_source is null or l_source not in (''ADG'')',
'    or l_period is null or not regexp_like(l_period,''^(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)-[0-9]{4}$'',''c'')',
'    or l_resolution is null or l_resolution not in (''REQUIRED'',''RECOMMENDED'',''ALL'') then',
'    raise_application_error(-20163,''Invalid accepted run. Run Analysis again.'');',
'  end if;',
'  -- Query text is unchanged; bind placeholders are replaced using validated server-owned values.',
'  l_sql:=q''~select s.organization_code, s.organization_name,',
'       case when :P61_RESOLUTION = ''RECOMMENDED'' then ''<span title="Not included by Resolution filter">&mdash;</span>''',
'       when s.unprocessed_material_count > 0 then',
'         ''<button type="button" class="p61-count" data-org-id="'' ||',
'         to_char(s.organization_id,''FM99999999999999999990'') ||',
'         ''" data-org-name="'' || apex_escape.html_attribute(s.organization_name) ||',
'         ''" data-type="'' || apex_escape.html_attribute(''Unprocessed Material'') ||',
'         ''" aria-label="'' || apex_escape.html_attribute(''Unprocessed Material for '' || s.organization_name) || ''">'' ||',
'         to_char(s.unprocessed_material_count,''FM999G999G999G999G990'') || ''</button>''',
'       else ''0'' end unprocessed_material_count,',
'       case when :P61_RESOLUTION = ''RECOMMENDED'' then ''<span title="Not included by Resolution filter">&mdash;</span>''',
'       when s.uncosted_material_wsm_count > 0 then',
'         ''<button type="button" class="p61-count" data-org-id="'' ||',
'         to_char(s.organization_id,''FM99999999999999999990'') ||',
'         ''" data-org-name="'' || apex_escape.html_attribute(s.organization_name) ||',
'         ''" data-type="'' || apex_escape.html_attribute(''Uncosted Material/WSM'') ||',
'         ''" aria-label="'' || apex_escape.html_attribute(''Uncosted Material/WSM for '' || s.organization_name) || ''">'' ||',
'         to_char(s.uncosted_material_wsm_count,''FM999G999G999G999G990'') || ''</button>''',
'       else ''0'' end uncosted_material_wsm_count,',
'       case when :P61_RESOLUTION = ''RECOMMENDED'' then ''<span title="Not included by Resolution filter">&mdash;</span>''',
'       when s.pending_wip_costing_count > 0 then',
'         ''<button type="button" class="p61-count" data-org-id="'' ||',
'         to_char(s.organization_id,''FM99999999999999999990'') ||',
'         ''" data-org-name="'' || apex_escape.html_attribute(s.organization_name) ||',
'         ''" data-type="'' || apex_escape.html_attribute(''Pending WIP Costing'') ||',
'         ''" aria-label="'' || apex_escape.html_attribute(''Pending WIP Costing for '' || s.organization_name) || ''">'' ||',
'         to_char(s.pending_wip_costing_count,''FM999G999G999G999G990'') || ''</button>''',
'       else ''0'' end pending_wip_costing_count,',
'       case when :P61_RESOLUTION = ''RECOMMENDED'' then ''<span title="Not included by Resolution filter">&mdash;</span>''',
'       when s.pending_wsm_interface_count > 0 then',
'         ''<button type="button" class="p61-count" data-org-id="'' ||',
'         to_char(s.organization_id,''FM99999999999999999990'') ||',
'         ''" data-org-name="'' || apex_escape.html_attribute(s.organization_name) ||',
'         ''" data-type="'' || apex_escape.html_attribute(''Pending WSM Interface'') ||',
'         ''" aria-label="'' || apex_escape.html_attribute(''Pending WSM Interface for '' || s.organization_name) || ''">'' ||',
'         to_char(s.pending_wsm_interface_count,''FM999G999G999G999G990'') || ''</button>''',
'       else ''0'' end pending_wsm_interface_count,',
'       case when :P61_RESOLUTION = ''RECOMMENDED'' then ''<span title="Not included by Resolution filter">&mdash;</span>''',
'       when s.pending_lcm_interface_count > 0 then',
'         ''<button type="button" class="p61-count" data-org-id="'' ||',
'         to_char(s.organization_id,''FM99999999999999999990'') ||',
'         ''" data-org-name="'' || apex_escape.html_attribute(s.organization_name) ||',
'         ''" data-type="'' || apex_escape.html_attribute(''Pending LCM Interface'') ||',
'         ''" aria-label="'' || apex_escape.html_attribute(''Pending LCM Interface for '' || s.organization_name) || ''">'' ||',
'         to_char(s.pending_lcm_interface_count,''FM999G999G999G999G990'') || ''</button>''',
'       else ''0'' end pending_lcm_interface_count,',
'       case when :P61_RESOLUTION = ''RECOMMENDED'' then ''<span title="Not included by Resolution filter">&mdash;</span>''',
'       when s.unprocessed_shipping_count > 0 then',
'         ''<button type="button" class="p61-count" data-org-id="'' ||',
'         to_char(s.organization_id,''FM99999999999999999990'') ||',
'         ''" data-org-name="'' || apex_escape.html_attribute(s.organization_name) ||',
'         ''" data-type="'' || apex_escape.html_attribute(''Unprocessed Shipping Transactions'') ||',
'         ''" aria-label="'' || apex_escape.html_attribute(''Unprocessed Shipping Transactions for '' || s.organization_name) || ''">'' ||',
'         to_char(s.unprocessed_shipping_count,''FM999G999G999G999G990'') || ''</button>''',
'       else ''0'' end unprocessed_shipping_count,',
'       case when :P61_RESOLUTION = ''REQUIRED'' then ''<span title="Not included by Resolution filter">&mdash;</span>''',
'       when s.pending_receiving_count > 0 then',
'         ''<button type="button" class="p61-count" data-org-id="'' ||',
'         to_char(s.organization_id,''FM99999999999999999990'') ||',
'         ''" data-org-name="'' || apex_escape.html_attribute(s.organization_name) ||',
'         ''" data-type="'' || apex_escape.html_attribute(''Pending Receiving'') ||',
'         ''" aria-label="'' || apex_escape.html_attribute(''Pending Receiving for '' || s.organization_name) || ''">'' ||',
'         to_char(s.pending_receiving_count,''FM999G999G999G999G990'') || ''</button>''',
'       else ''0'' end pending_receiving_count,',
'       case when :P61_RESOLUTION = ''REQUIRED'' then ''<span title="Not included by Resolution filter">&mdash;</span>''',
'       when s.pending_material_count > 0 then',
'         ''<button type="button" class="p61-count" data-org-id="'' ||',
'         to_char(s.organization_id,''FM99999999999999999990'') ||',
'         ''" data-org-name="'' || apex_escape.html_attribute(s.organization_name) ||',
'         ''" data-type="'' || apex_escape.html_attribute(''Pending Material'') ||',
'         ''" aria-label="'' || apex_escape.html_attribute(''Pending Material for '' || s.organization_name) || ''">'' ||',
'         to_char(s.pending_material_count,''FM999G999G999G999G990'') || ''</button>''',
'       else ''0'' end pending_material_count,',
'       case when :P61_RESOLUTION = ''REQUIRED'' then ''<span title="Not included by Resolution filter">&mdash;</span>''',
'       when s.pending_shop_floor_move_count > 0 then',
'         ''<button type="button" class="p61-count" data-org-id="'' ||',
'         to_char(s.organization_id,''FM99999999999999999990'') ||',
'         ''" data-org-name="'' || apex_escape.html_attribute(s.organization_name) ||',
'         ''" data-type="'' || apex_escape.html_attribute(''Pending Shop Floor Move'') ||',
'         ''" aria-label="'' || apex_escape.html_attribute(''Pending Shop Floor Move for '' || s.organization_name) || ''">'' ||',
'         to_char(s.pending_shop_floor_move_count,''FM999G999G999G999G990'') || ''</button>''',
'       else ''0'' end pending_shop_floor_move_count,',
'       case when :P61_RESOLUTION = ''REQUIRED'' then ''<span title="Not included by Resolution filter">&mdash;</span>''',
'       when s.incomplete_work_orders_count > 0 then',
'         ''<button type="button" class="p61-count" data-org-id="'' ||',
'         to_char(s.organization_id,''FM99999999999999999990'') ||',
'         ''" data-org-name="'' || apex_escape.html_attribute(s.organization_name) ||',
'         ''" data-type="'' || apex_escape.html_attribute(''Incomplete Work Orders'') ||',
'         ''" aria-label="'' || apex_escape.html_attribute(''Incomplete Work Orders for '' || s.organization_name) || ''">'' ||',
'         to_char(s.incomplete_work_orders_count,''FM999G999G999G999G990'') || ''</button>''',
'       else ''0'' end incomplete_work_orders_count,',
'       case when s.total_count > 0 then',
'         ''<button type="button" class="p61-count" data-org-id="'' ||',
'         to_char(s.organization_id,''FM99999999999999999990'') ||',
'         ''" data-org-name="'' || apex_escape.html_attribute(s.organization_name) ||',
'         ''" data-type="Total" aria-label="'' ||',
'         apex_escape.html_attribute(''Total for '' || s.organization_name) || ''">'' ||',
'         to_char(s.total_count,''FM999G999G999G999G990'') || ''</button>''',
'       else ''0'' end total_count',
'  from table(xxme_inv_pending_period_pkg.get_summary(:P61_PERIOD_NAME, :P61_DB_LINK, :P61_RESOLUTION)) s',
' where s.total_count > 0',
' order by s.organization_name, s.organization_code~'';',
'  l_sql:=replace(l_sql,'':P61_PERIOD_NAME'',dbms_assert.enquote_literal(l_period));',
'  l_sql:=replace(l_sql,'':P61_DB_LINK'',dbms_assert.enquote_literal(l_source));',
'  l_sql:=replace(l_sql,'':P61_RESOLUTION'',dbms_assert.enquote_literal(l_resolution));',
'  return l_sql;',
'end;'))
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
 p_id=>wwv_flow_imp.id(345926542559658063)
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
 p_id=>wwv_flow_imp.id(345926542559658052)
,p_query_column_id=>1
,p_column_alias=>'ORGANIZATION_CODE'
,p_column_display_sequence=>10
,p_column_heading=>'Org Code'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(345926542559658053)
,p_query_column_id=>2
,p_column_alias=>'ORGANIZATION_NAME'
,p_column_display_sequence=>20
,p_column_heading=>'Inventory Organization'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(345926542559658058)
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
 p_id=>wwv_flow_imp.id(345926542559658061)
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
 p_id=>wwv_flow_imp.id(345926542559658060)
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
 p_id=>wwv_flow_imp.id(345926542559658062)
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
 p_id=>wwv_flow_imp.id(345926542559658056)
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
 p_id=>wwv_flow_imp.id(345926542559658057)
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
 p_id=>wwv_flow_imp.id(345926542559658064)
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
 p_id=>wwv_flow_imp.id(345926542559658055)
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
 p_id=>wwv_flow_imp.id(345926542559658054)
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
 p_id=>wwv_flow_imp.id(345926542559658059)
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
 p_id=>wwv_flow_imp.id(323280827397433647)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(345926542559657953)
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
 p_id=>wwv_flow_imp.id(345926542559657972)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(345926542559657953)
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
 p_id=>wwv_flow_imp.id(345926542559657983)
,p_name=>'P61_DB_LINK'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(345926542559657953)
,p_item_default=>'ADG'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_cHeight=>1
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(345926542559657984)
,p_name=>'P61_ORG_ID'
,p_item_sequence=>30
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(345926542559657982)
,p_name=>'P61_PERIOD_NAME'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(345926542559657953)
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
 p_id=>wwv_flow_imp.id(345926542559657986)
,p_name=>'P61_READY'
,p_item_sequence=>32
,p_item_default=>'N'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(345926542559658042)
,p_name=>'P61_RESOLUTION'
,p_is_required=>true
,p_item_sequence=>25
,p_item_plug_id=>wwv_flow_imp.id(345926542559657953)
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
 p_id=>wwv_flow_imp.id(345926542559658986)
,p_name=>'P61_RUN_ID'
,p_item_sequence=>36
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(345926542559657987)
,p_name=>'P61_RUN_PERIOD'
,p_item_sequence=>33
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(345926542559658043)
,p_name=>'P61_RUN_RESOLUTION'
,p_item_sequence=>35
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(345926542559657988)
,p_name=>'P61_RUN_SOURCE'
,p_item_sequence=>34
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(345926542559657985)
,p_name=>'P61_TXN_TYPE'
,p_item_sequence=>31
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(323280827397433648)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Export Accepted Summary to XLSX'
,p_static_id=>'export-accepted-summary-xlsx'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_run_id varchar2(32):=upper(apex_util.get_session_state(''P61_RUN_ID''));',
'  l_period varchar2(15); l_source varchar2(30); l_resolution varchar2(20);',
'  l_sql varchar2(32767); l_context apex_exec.t_context; l_export apex_data_export.t_export;',
'  l_open boolean:=false; l_filename varchar2(255);',
'begin',
'  if l_run_id is null or not regexp_like(l_run_id,''^[0-9A-F]{32}$'',''c'') then',
'    raise_application_error(-20163,''Run Analysis before exporting the summary.'');',
'  end if;',
'  begin',
'    select c001,c002,c003 into l_period,l_source,l_resolution',
'    from apex_collections where collection_name=''P61RUN_''||l_run_id and seq_id=1;',
'  exception when no_data_found then',
'    raise_application_error(-20163,''This run has expired. Run Analysis again.'');',
'  end;',
'  if l_source not in (''ADG'')',
'    or not regexp_like(l_period,''^(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)-[0-9]{4}$'',''c'')',
'    or l_resolution not in (''REQUIRED'',''RECOMMENDED'',''ALL'') then',
'    raise_application_error(-20163,''Invalid accepted run. Run Analysis again.'');',
'  end if;',
'  l_sql:=q''~select s.organization_code "Org Code", s.organization_name "Inventory Organization",',
'       case when :R in (''REQUIRED'',''ALL'') then s.unprocessed_material_count end "Unprocessed Material",',
'       case when :R in (''REQUIRED'',''ALL'') then s.uncosted_material_wsm_count end "Uncosted Material/WSM",',
'       case when :R in (''REQUIRED'',''ALL'') then s.pending_wip_costing_count end "Pending WIP Costing",',
'       case when :R in (''REQUIRED'',''ALL'') then s.pending_wsm_interface_count end "Pending WSM Interface",',
'       case when :R in (''REQUIRED'',''ALL'') then s.pending_lcm_interface_count end "Pending LCM Interface",',
'       case when :R in (''REQUIRED'',''ALL'') then s.unprocessed_shipping_count end "Unprocessed Shipping Transactions",',
'       case when :R in (''RECOMMENDED'',''ALL'') then s.pending_receiving_count end "Pending Receiving",',
'       case when :R in (''RECOMMENDED'',''ALL'') then s.pending_material_count end "Pending Material",',
'       case when :R in (''RECOMMENDED'',''ALL'') then s.pending_shop_floor_move_count end "Pending Shop Floor Move",',
'       case when :R in (''RECOMMENDED'',''ALL'') then s.incomplete_work_orders_count end "Incomplete Work Orders",',
'       s.total_count "Total"',
'  from table(xxme_inv_pending_period_pkg.get_summary(:P,:L,:R)) s',
' where s.total_count>0 order by s.organization_name,s.organization_code~'';',
'  l_sql:=replace(l_sql,'':P'',dbms_assert.enquote_literal(l_period));',
'  l_sql:=replace(l_sql,'':L'',dbms_assert.enquote_literal(l_source));',
'  l_sql:=replace(l_sql,'':R'',dbms_assert.enquote_literal(l_resolution));',
'  l_context:=apex_exec.open_query_context(p_location=>apex_exec.c_location_local_db,',
'    p_sql_query=>l_sql,p_auto_bind_items=>false); l_open:=true;',
'  l_filename:=''Inventory_Pending_''||l_period||''_''||l_source||''_''||l_resolution;',
'  l_export:=apex_data_export.export(p_context=>l_context,p_format=>apex_data_export.c_format_xlsx,p_file_name=>l_filename);',
'  apex_exec.close(l_context); l_open:=false;',
'  apex_data_export.download(p_export=>l_export);',
'exception when apex_application.e_stop_apex_engine then raise;',
'  when others then if l_open then apex_exec.close(l_context); end if; raise;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(323280827397433647)
,p_internal_uid=>120061000000000052
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(345926542559657992)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Initialize AJAX Panes'
,p_static_id=>'initialize-ajax-panes'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  procedure put(p_name varchar2,p_value varchar2) is',
'  begin',
'    apex_util.set_session_state(p_name=>p_name,p_value=>p_value,p_commit=>false);',
'  end;',
'begin',
'  -- Every full render starts idle. Do not delete collections belonging to other tabs.',
'  put(''P61_RUN_ID'',null); put(''P61_READY'',''N'');',
'  put(''P61_ORG_ID'',null); put(''P61_TXN_TYPE'',null);',
'  put(''P61_RUN_PERIOD'',null); put(''P61_RUN_SOURCE'',null); put(''P61_RUN_RESOLUTION'',null);',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>120061000000000040
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(345926542559657994)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'P61_SET_CONTEXT'
,p_static_id=>'p61-set-context'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_action varchar2(20) := apex_application.g_x01;',
'  l_period varchar2(15) := upper(trim(apex_application.g_x02));',
'  l_source varchar2(30) := upper(trim(apex_application.g_x03));',
'  l_org_text varchar2(30) := apex_application.g_x04;',
'  l_type varchar2(80) := apex_application.g_x05;',
'  l_resolution varchar2(20) := upper(trim(apex_application.g_x06));',
'  l_previous_id varchar2(32) := upper(apex_application.g_x07);',
'  l_run_id varchar2(32); l_collection varchar2(255); l_org number;',
'  l_saved_period varchar2(15); l_saved_source varchar2(30); l_saved_resolution varchar2(20);',
'  l_created boolean := false;',
'  l_requested_type varchar2(80);',
'begin',
'  -- P61_SERVER_CONTEXT_V1: scalar inputs describe a request, not preapproved state.',
'  if l_action is null or l_action not in (''RUN'',''DETAIL'') then',
'    raise_application_error(-20166,''Unsupported report request.'');',
'  end if;',
'  if l_source is null or l_source not in (''ADG'') then',
'    raise_application_error(-20161,''Select an approved database source.'');',
'  end if;',
'  if l_period is null or not regexp_like(l_period,''^(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)-[0-9]{4}$'',''c'') then',
'    raise_application_error(-20162,''Select an accounting period.'');',
'  end if;',
'  if l_resolution is null or l_resolution not in (''REQUIRED'',''RECOMMENDED'',''ALL'') then',
'    raise_application_error(-20167,''Select Required, Recommended or All.'');',
'  end if;',
'  if l_action=''RUN'' then',
'    l_run_id:=rawtohex(sys_guid());',
'    l_collection:=''P61RUN_''||l_run_id;',
'    apex_collection.create_collection(p_collection_name=>l_collection);',
'    l_created:=true;',
'    apex_collection.add_member(p_collection_name=>l_collection,',
'      p_c001=>l_period,p_c002=>l_source,p_c003=>l_resolution,p_d001=>sysdate);',
'    -- Member 1 is immutable run context; member 2 is this run''s selected detail.',
'    apex_collection.add_member(p_collection_name=>l_collection,p_c050=>''DETAIL_SELECTION'');',
'    l_org:=null; l_type:=null;',
'  else',
'    if l_previous_id is null or not regexp_like(l_previous_id,''^[0-9A-F]{32}$'',''c'') then',
'      raise_application_error(-20163,''Run Analysis before selecting a count.'');',
'    end if;',
'    l_run_id:=l_previous_id; l_collection:=''P61RUN_''||l_run_id;',
'    begin',
'      select c001,c002,c003 into l_saved_period,l_saved_source,l_saved_resolution',
'      from apex_collections where collection_name=l_collection and seq_id=1;',
'    exception when no_data_found then',
'      raise_application_error(-20163,''This run has expired. Run Analysis again.'');',
'    end;',
'    if l_period<>l_saved_period or l_source<>l_saved_source or l_resolution<>l_saved_resolution then',
'      raise_application_error(-20163,''The selected count does not belong to this run. Run Analysis again.'');',
'    end if;',
'    if l_org_text is null or not regexp_like(l_org_text,''^[0-9]{1,18}$'',''c'') then',
'      raise_application_error(-20164,''Invalid inventory organization.'');',
'    end if;',
'    l_org:=to_number(l_org_text); l_requested_type:=l_type;',
'    if l_requested_type=''Total'' then',
'      l_type:=case l_resolution when ''REQUIRED'' then ''__TOTAL_REQUIRED__''',
'        when ''RECOMMENDED'' then ''__TOTAL_RECOMMENDED__'' else ''__TOTAL_ALL__'' end;',
'    elsif l_requested_type in (''Unprocessed Material'',''Uncosted Material/WSM'',''Pending WIP Costing'',''Pending WSM Interface'',''Pending LCM Interface'',''Unprocessed Shipping Transactions'',''Pending Receiving'',''Pending Material'',''Pending Shop Floor Move'','''
||'Incomplete Work Orders'') then',
'      l_type:=l_requested_type;',
'    else',
'      raise_application_error(-20165,''Invalid transaction category.'');',
'    end if;',
'    if l_org<=0 then raise_application_error(-20164,''Invalid inventory organization.''); end if;',
'    if (l_resolution=''REQUIRED'' and l_type in (''Pending Receiving'',''Pending Material'',''Pending Shop Floor Move'',''Incomplete Work Orders''))',
'      or (l_resolution=''RECOMMENDED'' and l_type in (''Unprocessed Material'',''Uncosted Material/WSM'',''Pending WIP Costing'',''Pending WSM Interface'',''Pending LCM Interface'',''Unprocessed Shipping Transactions'')) then',
'      raise_application_error(-20168,''Transaction type is outside the selected resolution.'');',
'    end if;',
'    apex_ir.reset_report(p_page_id=>61,p_region_static_id=>''pending-details'');',
'    apex_collection.update_member(p_collection_name=>l_collection,p_seq=>2,',
'      p_c001=>l_type,p_n001=>l_org,p_c050=>''DETAIL_SELECTION'');',
'  end if;',
'  -- Retire only this tab''s previous run after its replacement was accepted.',
'  if l_action=''RUN'' and regexp_like(l_previous_id,''^[0-9A-F]{32}$'',''c'') and l_previous_id<>l_run_id then',
'    if apex_collection.collection_exists(p_collection_name=>''P61RUN_''||l_previous_id) then',
'      apex_collection.delete_collection(p_collection_name=>''P61RUN_''||l_previous_id);',
'    end if;',
'  end if;',
'  apex_json.open_object;',
'  apex_json.write(''ok'',true); apex_json.write(''version'',''P61_SERVER_CONTEXT_V1'');',
'  apex_json.write(''action'',l_action); apex_json.write(''run_id'',l_run_id); apex_json.write(''ready'',''Y'');',
'  apex_json.write(''period'',l_period); apex_json.write(''source'',l_source); apex_json.write(''resolution'',l_resolution);',
'  apex_json.write(''org'',to_char(l_org,''FM99999999999999999990'')); apex_json.write(''type'',l_requested_type);',
'  apex_json.close_object;',
'exception when others then',
'  if l_created and apex_collection.collection_exists(p_collection_name=>l_collection) then',
'    apex_collection.delete_collection(p_collection_name=>l_collection);',
'  end if;',
'  apex_json.open_object; apex_json.write(''ok'',false);',
'  apex_json.write(''message'',case when sqlcode between -20999 and -20000 then substr(sqlerrm,12)',
'    else ''Unable to prepare the report. Check the APEX debug log.'' end);',
'  apex_json.close_object;',
'end;'))
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
,p_required_role=>wwv_flow_imp.id(9156329399484443)
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(15226483324931637)
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
 p_id=>wwv_flow_imp.id(15226513131931637)
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
 p_id=>wwv_flow_imp.id(15226673049931637)
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
 p_id=>wwv_flow_imp.id(15226731152931637)
,p_plug_name=>'Create Accounting Filters'
,p_static_id=>'p70-filters-CA'
,p_region_name=>'p70-filters-CA'
,p_parent_plug_id=>wwv_flow_imp.id(15226483324931637)
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
 p_id=>wwv_flow_imp.id(15226883931931637)
,p_plug_name=>'Reversals Filters'
,p_static_id=>'p70-filters-RS'
,p_region_name=>'p70-filters-RS'
,p_parent_plug_id=>wwv_flow_imp.id(15226513131931637)
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
 p_id=>wwv_flow_imp.id(15226998296931637)
,p_plug_name=>'Revaluations Filters'
,p_static_id=>'p70-filters-RV'
,p_region_name=>'p70-filters-RV'
,p_parent_plug_id=>wwv_flow_imp.id(15226673049931637)
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
 p_id=>wwv_flow_imp.id(15227033699931637)
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
 p_id=>wwv_flow_imp.id(15227113744931637)
,p_plug_name=>'Create Accounting Executions'
,p_static_id=>'p70-report-CA'
,p_region_name=>'p70-report-CA'
,p_parent_plug_id=>wwv_flow_imp.id(15226483324931637)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_item_display_point=>'ABOVE'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select q.* from (',
'SELECT x.module,',
'       x.ledger_id,',
'       x.ledger_name,',
'       x.request_id,',
'       x.status,',
'       CASE WHEN x.rn = 1 AND x.status <> ''Error'' THEN ''Y'' ELSE ''N'' END is_latest,  -- latest successful run',
'       x.requested_by,',
'       x.actual_start_date,',
'       x.actual_completion_date,',
'       x.run_minutes,',
'       x.hours_since_run,',
'       substr(x.accounting_end_date,1,10) AS accounting_end_date,',
'       x.process_category,',
'       x.accounting_mode,',
'       x.errors_only,',
'       x.report_style,',
'       x.transfer_to_gl,',
'       x.post_in_gl,',
'       x.gl_batch_name',
'  FROM (SELECT /*+ DRIVING_SITE(fcr) */',
'               DECODE(fcp.concurrent_program_name,',
'                      ''CSTCRACC'',    ''Inventory (Cost Management)'',',
'                      ''CSTCRACCRCV'', ''Receiving (Cost Management)'',',
'                      DECODE(fcr.argument2, ''200'', ''AP - Payables'',',
'                                            ''222'', ''AR - Receivables'',',
'                                            NVL(fat.application_name, NVL(fcr.argument2, fcr.argument1))',
'                                              || DECODE(fcr.argument2, NULL, '' (online / single document)'')))  module,',
'               gl.ledger_id,',
'               gl.name                                                   ledger_name,',
'               fcr.request_id,',
'               DECODE(fcr.status_code, ''C'', ''Normal'', ''G'', ''Warning'', ''E'', ''Error'', fcr.status_code) status,',
'               fu.user_name                                              requested_by,',
'               fcr.actual_start_date,',
'               fcr.actual_completion_date,',
'               ROUND((fcr.actual_completion_date - fcr.actual_start_date) * 1440, 1) run_minutes,',
'               ROUND((SYSDATE - fcr.actual_completion_date) * 24, 1)     hours_since_run,',
'               fcr.argument6                                             accounting_end_date,',
'               fcr.argument5                                             process_category,',
'               DECODE(fcr.argument9,  ''F'', ''Final'', ''D'', ''Draft'', fcr.argument9)                 accounting_mode,',
'               DECODE(fcr.argument11, ''Y'', ''Yes'', ''N'', ''No'', fcr.argument11)                     errors_only,',
'               DECODE(fcr.argument12, ''D'', ''Detail'', ''S'', ''Summary'', ''N'', ''No Report'', fcr.argument12) report_style,',
'               DECODE(fcr.argument13, ''Y'', ''Yes'', ''N'', ''No'', fcr.argument13)                     transfer_to_gl,',
'               DECODE(fcr.argument15, ''Y'', ''Yes'', ''N'', ''No'', fcr.argument15)                     post_in_gl,',
'               fcr.argument16                                            gl_batch_name,',
'               ROW_NUMBER() OVER (PARTITION BY fcp.concurrent_program_name, fcr.argument1, fcr.argument2, fcr.argument4',
'                                  ORDER BY DECODE(fcr.status_code, ''E'', 1, 0),   -- successful runs first',
'                                           fcr.actual_completion_date DESC, fcr.request_id DESC) rn',
'          FROM apps.fnd_concurrent_requests@ADG fcr,',
'               apps.fnd_concurrent_programs@ADG fcp,',
'               apps.gl_ledgers@ADG              gl,',
'               apps.fnd_user@ADG                fu,',
'               apps.fnd_application_tl@ADG      fat',
'         WHERE (   (fcp.application_id = 602 AND fcp.concurrent_program_name = ''XLAACCPB'')',
'                OR (fcp.application_id = 702 AND fcp.concurrent_program_name IN (''CSTCRACC'', ''CSTCRACCRCV'')))',
'           AND fcr.program_application_id = fcp.application_id',
'           AND fcr.concurrent_program_id  = fcp.concurrent_program_id',
'           AND fcr.phase_code             = ''C''',
'           AND fcr.status_code IN (''C'', ''G'', ''E'')  -- Normal + Warning + Error',
'        -- AND fcr.argument9              = ''F''      -- uncomment = FINAL runs only',
'           AND TO_CHAR(gl.ledger_id)      = TRIM(fcr.argument4)',
'           AND fu.user_id (+)             = fcr.requested_by',
'           AND TO_CHAR(fat.application_id (+)) = NVL(fcr.argument2, fcr.argument1)',
'           AND fat.language (+)           = ''US''',
'           AND (   :P70_CA_LEDGERS IS NULL         -- any separator: 1003,5001 10001',
'                OR INSTR('','' || REGEXP_REPLACE(:P70_CA_LEDGERS, ''[^0-9]+'', '','') || '','',',
'                         '','' || TRIM(fcr.argument4) || '','') > 0)',
'       ) x',
' ORDER BY x.request_id DESC',
') q',
'where q.ledger_id in (1003,5001,10001) and (:P70_CA_VIEW = ''ALL'' or q.is_latest = ''Y'')',
' and (:P70_CA_APPS is null',
' or (instr('':''||:P70_CA_APPS||'':'', '':AP:'')>0 and q.module=''AP - Payables'')',
' or (instr('':''||:P70_CA_APPS||'':'', '':AR:'')>0 and q.module=''AR - Receivables'')',
' or (instr('':''||:P70_CA_APPS||'':'', '':COST:'')>0 and q.module in (''Inventory (Cost Management)'',''Receiving (Cost Management)'')))',
'order by q.request_id desc'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P70_CA_LEDGERS,P70_CA_APPS,P70_CA_VIEW'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(15227210588931637)
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
,p_internal_uid=>15227210588931637
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15227329545931637)
,p_db_column_name=>'ACCOUNTING_END_DATE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Accounting End Date'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15227477375931637)
,p_db_column_name=>'ACCOUNTING_MODE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Accounting Mode'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15227532115931637)
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
 p_id=>wwv_flow_imp.id(15227613414931637)
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
 p_id=>wwv_flow_imp.id(15227756069931637)
,p_db_column_name=>'ERRORS_ONLY'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Errors Only'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15227878150931637)
,p_db_column_name=>'GL_BATCH_NAME'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'GL Batch Name'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15227948447931637)
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
 p_id=>wwv_flow_imp.id(15228049573931637)
,p_db_column_name=>'IS_LATEST'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Latest Successful'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15228127888931637)
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
 p_id=>wwv_flow_imp.id(15228248909931637)
,p_db_column_name=>'LEDGER_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Ledger Name'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15228322210931637)
,p_db_column_name=>'MODULE'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'SubLedger'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15228462297931637)
,p_db_column_name=>'POST_IN_GL'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Post in GL'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15228523209931637)
,p_db_column_name=>'PROCESS_CATEGORY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Process Category'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15228684293931637)
,p_db_column_name=>'REPORT_STYLE'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Report Style'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15228750125931637)
,p_db_column_name=>'REQUESTED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Requested By'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15228828552931637)
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
 p_id=>wwv_flow_imp.id(15228925551931637)
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
 p_id=>wwv_flow_imp.id(15229033580931637)
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
 p_id=>wwv_flow_imp.id(15229154788931637)
,p_db_column_name=>'TRANSFER_TO_GL'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Transfer to GL'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(15229203075931637)
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
 p_id=>wwv_flow_imp.id(15229385565931637)
,p_plug_name=>'Most Recent Reversals'
,p_static_id=>'p70-report-RS'
,p_region_name=>'p70-report-RS'
,p_parent_plug_id=>wwv_flow_imp.id(15226513131931637)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_item_display_point=>'ABOVE'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* =====================================================================',
'   Oracle EBS 12.2.x - Last 3 journal REVERSAL runs per ledger, all sources (via DB link ADG)',
'   A reversal journal = any GL journal with reversed_je_header_id populated',
'   (batches named ''Reverses "Revalues for XXX transactions" ...'').',
'   A "run" = reversal batches of the same ledger, created by the same user,',
'   with < 10 min between consecutive batches (one batch per reversed journal).',
'   Binds:',
'     :P70_RS_LEDGERS   ledger IDs, any separator (quotes/spaces ignored), e.g. 1003,10001,5001',
'     cast(null as varchar2(30))  period of the REVERSAL journal, e.g. SEP-2026',
'                     (case-insensitive, quotes ignored; NULL = any period)',
'   ===================================================================== */',
'SELECT /*+ DRIVING_SITE(l) LEADING(r l fu o ob) USE_NL(l fu o ob)',
'           INDEX(l (ledger_id)) INDEX(fu FND_USER_U1) INDEX(o GL_JE_HEADERS_U1) INDEX(ob GL_JE_BATCHES_U1) */',
'       l.name                                        AS ledger_name,',
'       r.ledger_id,',
'       l.currency_code                               AS ledger_currency,',
'       case r.run_rank when 1 then ''Latest execution'' when 2 then ''Previous execution'' when 3 then ''Third-most-recent execution'' end',
'       || '' | '' || to_char(r.run_start,''DD-MON-YYYY HH24:MI:SS'') AS run_rank,                                   -- 1 = most recent',
'       r.run_start AS run_start,',
'       r.run_end AS run_end,',
'       r.run_batches,',
'       fu.user_name                                  AS run_by,',
'       r.period_name                                 AS reversal_period,',
'       r.je_batch_id,',
'       r.batch_name,',
'       DECODE(r.batch_status, ''P'', ''Posted'', ''U'', ''Unposted'', r.batch_status) AS batch_status,',
'       r.je_header_id,',
'       r.journal_name,',
'       js.user_je_source_name                        AS je_source,',
'       jc.user_je_category_name                      AS je_category,',
'       r.currency_code,',
'       r.accounted_dr,',
'       r.accounted_cr,',
'       o.je_header_id                                AS orig_je_header_id,',
'       o.name                                        AS orig_journal_name,',
'       o.period_name                                 AS orig_period,',
'       ob.name                                       AS orig_batch_name',
'FROM  (SELECT x.*,',
'              MAX(x.run_seq) OVER (PARTITION BY x.ledger_id) - x.run_seq + 1 AS run_rank,',
'              MIN(x.batch_created) OVER (PARTITION BY x.ledger_id, x.run_seq) AS run_start,',
'              MAX(x.batch_created) OVER (PARTITION BY x.ledger_id, x.run_seq) AS run_end,',
'              COUNT(DISTINCT x.je_batch_id) OVER (PARTITION BY x.ledger_id, x.run_seq) AS run_batches',
'       FROM  (SELECT y.*,',
'                     SUM(y.new_run) OVER (PARTITION BY y.ledger_id',
'                                          ORDER BY y.batch_created, y.je_batch_id, y.je_header_id',
'                                          ROWS UNBOUNDED PRECEDING) AS run_seq',
'              FROM  (SELECT /*+ LEADING(h b) USE_NL(b) INDEX(h (ledger_id)) INDEX(b GL_JE_BATCHES_U1) */',
'                            h.ledger_id,',
'                            h.period_name,',
'                            h.je_header_id,',
'                            h.name                        AS journal_name,',
'                            h.je_source,',
'                            h.je_category,',
'                            h.currency_code,',
'                            h.running_total_accounted_dr  AS accounted_dr,',
'                            h.running_total_accounted_cr  AS accounted_cr,',
'                            h.reversed_je_header_id,',
'                            b.je_batch_id,',
'                            b.name                        AS batch_name,',
'                            b.status                      AS batch_status,',
'                            b.created_by,',
'                            b.creation_date               AS batch_created,',
'                            CASE',
'                              WHEN LAG(b.creation_date) OVER (PARTITION BY h.ledger_id',
'                                                              ORDER BY b.creation_date, b.je_batch_id, h.je_header_id) IS NULL',
'                                OR b.creation_date - LAG(b.creation_date) OVER (PARTITION BY h.ledger_id',
'                                                              ORDER BY b.creation_date, b.je_batch_id, h.je_header_id) > 10/1440',
'                                OR b.created_by <> LAG(b.created_by) OVER (PARTITION BY h.ledger_id',
'                                                              ORDER BY b.creation_date, b.je_batch_id, h.je_header_id)',
'                              THEN 1 ELSE 0',
'                            END                           AS new_run',
'                     FROM   apps.gl_je_headers@ADG h,',
'                            apps.gl_je_batches@ADG b',
'                     WHERE  h.ledger_id IN (SELECT TO_NUMBER(REGEXP_SUBSTR(:P70_RS_LEDGERS, ''[0-9]+'', 1, LEVEL))',
'                                            FROM   dual@ADG',
'                                            CONNECT BY REGEXP_SUBSTR(:P70_RS_LEDGERS, ''[0-9]+'', 1, LEVEL) IS NOT NULL)',
'                     AND    h.actual_flag = ''A''',
'                     AND    h.reversed_je_header_id IS NOT NULL      -- reversals only',
'                     AND    (TRIM(REPLACE(cast(null as varchar2(30)), '''''''')) IS NULL',
'                             OR h.period_name = UPPER(TRIM(REPLACE(cast(null as varchar2(30)), ''''''''))))',
'                     AND    b.je_batch_id = h.je_batch_id',
'                    ) y',
'             ) x',
'      ) r,',
'       apps.gl_ledgers@ADG    l,',
'       apps.fnd_user@ADG      fu,',
'       apps.gl_je_headers@ADG o,',
'       apps.gl_je_batches@ADG ob,',
'       apps.gl_je_sources@ADG js,',
'       apps.gl_je_categories@ADG jc',
'WHERE r.ledger_id IN (1003,5001,10001) AND r.run_rank <= 3                                       -- last 3 runs',
'AND    l.ledger_id          = r.ledger_id',
'AND    fu.user_id       (+) = r.created_by',
'AND    o.je_header_id   (+) = r.reversed_je_header_id',
'AND    ob.je_batch_id   (+) = o.je_batch_id',
'AND    js.je_source_name (+) = r.je_source',
'AND    jc.je_category_name (+) = r.je_category',
'ORDER  BY l.name, r.run_rank, r.batch_created, r.je_batch_id, r.currency_code'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P70_RS_LEDGERS'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(15229474211931637)
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
,p_internal_uid=>15229474211931637
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15229571159931637)
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
 p_id=>wwv_flow_imp.id(15229658725931637)
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
 p_id=>wwv_flow_imp.id(15229764019931637)
,p_db_column_name=>'BATCH_NAME'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Batch Name'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15229871527931637)
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
 p_id=>wwv_flow_imp.id(15229956847931637)
,p_db_column_name=>'CURRENCY_CODE'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Currency Code'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15230017780931637)
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
 p_id=>wwv_flow_imp.id(15230118652931637)
,p_db_column_name=>'JE_CATEGORY'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Category'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15230289411931637)
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
 p_id=>wwv_flow_imp.id(15230341836931637)
,p_db_column_name=>'JE_SOURCE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Source'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15230400377931637)
,p_db_column_name=>'JOURNAL_NAME'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Journal Name'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15230532015931637)
,p_db_column_name=>'LEDGER_CURRENCY'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Ledger Currency'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15230613850931637)
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
 p_id=>wwv_flow_imp.id(15230704198931637)
,p_db_column_name=>'LEDGER_NAME'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Ledger Name'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15230887500931637)
,p_db_column_name=>'ORIG_BATCH_NAME'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Original Batch'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15230926300931637)
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
 p_id=>wwv_flow_imp.id(15231006025931637)
,p_db_column_name=>'ORIG_JOURNAL_NAME'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Original Journal'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15231157332931637)
,p_db_column_name=>'ORIG_PERIOD'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Original Period'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15231215625931637)
,p_db_column_name=>'REVERSAL_PERIOD'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Reversal Period'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15231386546931637)
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
 p_id=>wwv_flow_imp.id(15231420294931737)
,p_db_column_name=>'RUN_BY'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Run By'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15231555394931737)
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
 p_id=>wwv_flow_imp.id(15231650900931737)
,p_db_column_name=>'RUN_RANK'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Execution Group'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15231760199931737)
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
 p_id=>wwv_flow_imp.id(15231830596931737)
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
 p_id=>wwv_flow_imp.id(15231934956931737)
,p_plug_name=>'Most Recent Revaluations'
,p_static_id=>'p70-report-RV'
,p_region_name=>'p70-report-RV'
,p_parent_plug_id=>wwv_flow_imp.id(15226673049931637)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_item_display_point=>'ABOVE'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* =====================================================================',
'   Oracle EBS 12.2.x - Last 3 Revaluation runs per ledger (via DB link ADG)',
'   A "run" = Revaluation batches of the same ledger, created by the same',
'   user, with < 10 min between consecutive batches (one batch is created',
'   per revaluation definition). Auto-reversal batches ("Reverses ...") of',
'   prior-period revaluations are excluded.',
'   Binds:',
'     :P70_RV_LEDGERS   ledger IDs, any separator (quotes/spaces ignored), e.g. 1003,10001,5001',
'     cast(null as varchar2(30))  e.g. SEP-2026 (case-insensitive, quotes ignored; NULL = any period)',
'   ===================================================================== */',
'SELECT /*+ DRIVING_SITE(l) LEADING(r l fu) USE_NL(l fu)',
'           INDEX(l (ledger_id)) INDEX(fu FND_USER_U1) */',
'       l.name                                        AS ledger_name,',
'       r.ledger_id,',
'       l.currency_code                               AS ledger_currency,',
'       case r.run_rank when 1 then ''Latest execution'' when 2 then ''Previous execution'' when 3 then ''Third-most-recent execution'' end',
'       || '' | '' || to_char(r.run_start,''DD-MON-YYYY HH24:MI:SS'') AS run_rank,                                   -- 1 = most recent',
'       r.run_start AS run_start,',
'       r.run_end AS run_end,',
'       fu.user_name                                  AS run_by,',
'       r.period_name,',
'       r.je_batch_id,',
'       r.batch_name,',
'       DECODE(r.batch_status, ''P'', ''Posted'', ''U'', ''Unposted'', r.batch_status) AS batch_status,',
'       r.je_header_id,',
'       r.journal_name,',
'       r.currency_code                               AS revalued_currency,',
'       r.accounted_dr,',
'       r.accounted_cr,',
'       r.accrual_rev_period_name                     AS reversal_period,',
'       DECODE(r.accrual_rev_status, ''R'', ''Reversed'', NULL, ''Not reversed'', r.accrual_rev_status) AS reversal_status',
'FROM  (SELECT x.*,',
'              MAX(x.run_seq) OVER (PARTITION BY x.ledger_id) - x.run_seq + 1 AS run_rank,',
'              MIN(x.batch_created) OVER (PARTITION BY x.ledger_id, x.run_seq) AS run_start,',
'              MAX(x.batch_created) OVER (PARTITION BY x.ledger_id, x.run_seq) AS run_end',
'       FROM  (SELECT y.*,',
'                     SUM(y.new_run) OVER (PARTITION BY y.ledger_id',
'                                          ORDER BY y.batch_created, y.je_batch_id, y.je_header_id',
'                                          ROWS UNBOUNDED PRECEDING) AS run_seq',
'              FROM  (SELECT /*+ LEADING(h b) USE_NL(b) INDEX(h (ledger_id)) INDEX(b GL_JE_BATCHES_U1) */',
'                            h.ledger_id,',
'                            h.period_name,',
'                            h.je_header_id,',
'                            h.name                        AS journal_name,',
'                            h.currency_code,',
'                            h.running_total_accounted_dr  AS accounted_dr,',
'                            h.running_total_accounted_cr  AS accounted_cr,',
'                            h.accrual_rev_period_name,',
'                            h.accrual_rev_status,',
'                            b.je_batch_id,',
'                            b.name                        AS batch_name,',
'                            b.status                      AS batch_status,',
'                            b.created_by,',
'                            b.creation_date               AS batch_created,',
'                            CASE',
'                              WHEN LAG(b.creation_date) OVER (PARTITION BY h.ledger_id',
'                                                              ORDER BY b.creation_date, b.je_batch_id, h.je_header_id) IS NULL',
'                                OR b.creation_date - LAG(b.creation_date) OVER (PARTITION BY h.ledger_id',
'                                                              ORDER BY b.creation_date, b.je_batch_id, h.je_header_id) > 10/1440',
'                                OR b.created_by <> LAG(b.created_by) OVER (PARTITION BY h.ledger_id',
'                                                              ORDER BY b.creation_date, b.je_batch_id, h.je_header_id)',
'                              THEN 1 ELSE 0',
'                            END                           AS new_run',
'                     FROM   apps.gl_je_headers@ADG h,',
'                            apps.gl_je_batches@ADG b',
'                     WHERE  h.ledger_id IN (SELECT TO_NUMBER(REGEXP_SUBSTR(:P70_RV_LEDGERS, ''[0-9]+'', 1, LEVEL))',
'                                            FROM   dual@ADG',
'                                            CONNECT BY REGEXP_SUBSTR(:P70_RV_LEDGERS, ''[0-9]+'', 1, LEVEL) IS NOT NULL)',
'                     AND    h.je_source   = ''Revaluation''',
'                     AND    h.actual_flag = ''A''',
'                     AND    h.reversed_je_header_id IS NULL          -- exclude auto-reversals',
'                     AND    (TRIM(REPLACE(cast(null as varchar2(30)), '''''''')) IS NULL OR h.period_name = UPPER(TRIM(REPLACE(cast(null as varchar2(30)), ''''''''))))',
'                     AND    b.je_batch_id = h.je_batch_id',
'                    ) y',
'             ) x',
'      ) r,',
'       apps.gl_ledgers@ADG l,',
'       apps.fnd_user@ADG   fu',
'WHERE r.ledger_id IN (1003,5001,10001) AND r.run_rank <= 3                                           -- last 3 runs',
'AND    l.ledger_id      = r.ledger_id',
'AND    fu.user_id   (+) = r.created_by',
'ORDER  BY l.name, r.run_rank, r.batch_created, r.je_batch_id, r.currency_code'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P70_RV_LEDGERS'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(15232018582931737)
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
,p_internal_uid=>15232018582931737
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15232110372931737)
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
 p_id=>wwv_flow_imp.id(15232209562931737)
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
 p_id=>wwv_flow_imp.id(15232366889931737)
,p_db_column_name=>'BATCH_NAME'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Batch Name'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15232445950931737)
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
 p_id=>wwv_flow_imp.id(15232549416931737)
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
 p_id=>wwv_flow_imp.id(15232623858931737)
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
 p_id=>wwv_flow_imp.id(15232720168931737)
,p_db_column_name=>'JOURNAL_NAME'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Journal Name'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15232867882931737)
,p_db_column_name=>'LEDGER_CURRENCY'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Ledger Currency'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15232988384931745)
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
 p_id=>wwv_flow_imp.id(15233033415931745)
,p_db_column_name=>'LEDGER_NAME'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Ledger Name'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15233101037931745)
,p_db_column_name=>'PERIOD_NAME'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Period Name'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15233235677931745)
,p_db_column_name=>'REVALUED_CURRENCY'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Revalued Currency'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15233389723931745)
,p_db_column_name=>'REVERSAL_PERIOD'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Reversal Period'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15233413036931745)
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
 p_id=>wwv_flow_imp.id(15233553135931745)
,p_db_column_name=>'RUN_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Run By'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15233600415931745)
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
 p_id=>wwv_flow_imp.id(15233701646931745)
,p_db_column_name=>'RUN_RANK'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Execution Group'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15233809216931745)
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
 p_id=>wwv_flow_imp.id(15233930554931745)
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
 p_id=>wwv_flow_imp.id(15234050401931745)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(15226731152931637)
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
 p_id=>wwv_flow_imp.id(15234135831931745)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(15226883931931637)
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
 p_id=>wwv_flow_imp.id(15234258528931745)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(15226998296931637)
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
 p_id=>wwv_flow_imp.id(15234339340931745)
,p_name=>'P70_ACTIVE_TAB'
,p_item_sequence=>1
,p_item_default=>'CA'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15234421724931754)
,p_name=>'P70_CA_APPS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(15226731152931637)
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
 p_id=>wwv_flow_imp.id(15234563593931754)
,p_name=>'P70_CA_LEDGERS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(15226731152931637)
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
 p_id=>wwv_flow_imp.id(15234618805931754)
,p_name=>'P70_CA_VIEW'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(15226731152931637)
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
 p_id=>wwv_flow_imp.id(15234751095931754)
,p_name=>'P70_RS_LEDGERS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(15226883931931637)
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
 p_id=>wwv_flow_imp.id(15234811939931754)
,p_name=>'P70_RS_PERIOD'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(15226883931931637)
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
 p_id=>wwv_flow_imp.id(15234962461931754)
,p_name=>'P70_RV_LEDGERS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(15226998296931637)
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
 p_id=>wwv_flow_imp.id(15235003745931754)
,p_name=>'P70_RV_PERIOD'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(15226998296931637)
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
 p_id=>wwv_flow_imp.id(15235173202931754)
,p_process_sequence=>5
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Normalize page filters'
,p_static_id=>'normalize-page-filters'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare l_apps varchar2(4000); l_old varchar2(4000); l_ledgers varchar2(4000); l_item varchar2(30);begin',
'select listagg(column_value,'':'') within group(order by column_value) into l_apps from (select distinct column_value from table(apex_string.split(apex_util.get_session_state(''P70_CA_APPS''),'':'')) where column_value in (''AP'',''AR'',''COST''));',
'apex_util.set_session_state(p_name=>''P70_CA_APPS'',p_value=>l_apps,p_commit=>false);',
'for k in (select column_value key from table(apex_t_varchar2(''CA'',''RV'',''RS''))) loop',
'l_item:=''P70_''||k.key||''_LEDGERS'';l_old:=apex_util.get_session_state(l_item);',
'select listagg(column_value,'':'') within group(order by column_value) into l_ledgers from (select distinct column_value from table(apex_string.split(l_old,'':'')) where column_value in (''1003'',''5001'',''10001''));',
'if l_old is not null and l_ledgers is null then l_ledgers:=''1003:5001:10001'';end if;',
'apex_util.set_session_state(p_name=>l_item,p_value=>l_ledgers,p_commit=>false);',
'end loop;',
'apex_util.set_session_state(p_name=>''P70_RV_PERIOD'',p_value=>null,p_commit=>false);',
'apex_util.set_session_state(p_name=>''P70_RS_PERIOD'',p_value=>null,p_commit=>false);',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>15235173202931754
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(15235204448931754)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'P70_SUMMARY'
,p_static_id=>'p70-summary'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare l_latest date; l_rows number; l_extra number; l_context varchar2(200);begin',
'case apex_application.g_x01',
'when ''CA'' then',
' select max(case when is_latest=''Y'' then actual_completion_date end),count(*) into l_latest,l_rows from (select q.* from (',
'SELECT x.module,',
'       x.ledger_id,',
'       x.ledger_name,',
'       x.request_id,',
'       x.status,',
'       CASE WHEN x.rn = 1 AND x.status <> ''Error'' THEN ''Y'' ELSE ''N'' END is_latest,  -- latest successful run',
'       x.requested_by,',
'       x.actual_start_date,',
'       x.actual_completion_date,',
'       x.run_minutes,',
'       x.hours_since_run,',
'       substr(x.accounting_end_date,1,10) AS accounting_end_date,',
'       x.process_category,',
'       x.accounting_mode,',
'       x.errors_only,',
'       x.report_style,',
'       x.transfer_to_gl,',
'       x.post_in_gl,',
'       x.gl_batch_name',
'  FROM (SELECT /*+ DRIVING_SITE(fcr) */',
'               DECODE(fcp.concurrent_program_name,',
'                      ''CSTCRACC'',    ''Inventory (Cost Management)'',',
'                      ''CSTCRACCRCV'', ''Receiving (Cost Management)'',',
'                      DECODE(fcr.argument2, ''200'', ''AP - Payables'',',
'                                            ''222'', ''AR - Receivables'',',
'                                            NVL(fat.application_name, NVL(fcr.argument2, fcr.argument1))',
'                                              || DECODE(fcr.argument2, NULL, '' (online / single document)'')))  module,',
'               gl.ledger_id,',
'               gl.name                                                   ledger_name,',
'               fcr.request_id,',
'               DECODE(fcr.status_code, ''C'', ''Normal'', ''G'', ''Warning'', ''E'', ''Error'', fcr.status_code) status,',
'               fu.user_name                                              requested_by,',
'               fcr.actual_start_date,',
'               fcr.actual_completion_date,',
'               ROUND((fcr.actual_completion_date - fcr.actual_start_date) * 1440, 1) run_minutes,',
'               ROUND((SYSDATE - fcr.actual_completion_date) * 24, 1)     hours_since_run,',
'               fcr.argument6                                             accounting_end_date,',
'               fcr.argument5                                             process_category,',
'               DECODE(fcr.argument9,  ''F'', ''Final'', ''D'', ''Draft'', fcr.argument9)                 accounting_mode,',
'               DECODE(fcr.argument11, ''Y'', ''Yes'', ''N'', ''No'', fcr.argument11)                     errors_only,',
'               DECODE(fcr.argument12, ''D'', ''Detail'', ''S'', ''Summary'', ''N'', ''No Report'', fcr.argument12) report_style,',
'               DECODE(fcr.argument13, ''Y'', ''Yes'', ''N'', ''No'', fcr.argument13)                     transfer_to_gl,',
'               DECODE(fcr.argument15, ''Y'', ''Yes'', ''N'', ''No'', fcr.argument15)                     post_in_gl,',
'               fcr.argument16                                            gl_batch_name,',
'               ROW_NUMBER() OVER (PARTITION BY fcp.concurrent_program_name, fcr.argument1, fcr.argument2, fcr.argument4',
'                                  ORDER BY DECODE(fcr.status_code, ''E'', 1, 0),   -- successful runs first',
'                                           fcr.actual_completion_date DESC, fcr.request_id DESC) rn',
'          FROM apps.fnd_concurrent_requests@ADG fcr,',
'               apps.fnd_concurrent_programs@ADG fcp,',
'               apps.gl_ledgers@ADG              gl,',
'               apps.fnd_user@ADG                fu,',
'               apps.fnd_application_tl@ADG      fat',
'         WHERE (   (fcp.application_id = 602 AND fcp.concurrent_program_name = ''XLAACCPB'')',
'                OR (fcp.application_id = 702 AND fcp.concurrent_program_name IN (''CSTCRACC'', ''CSTCRACCRCV'')))',
'           AND fcr.program_application_id = fcp.application_id',
'           AND fcr.concurrent_program_id  = fcp.concurrent_program_id',
'           AND fcr.phase_code             = ''C''',
'           AND fcr.status_code IN (''C'', ''G'', ''E'')  -- Normal + Warning + Error',
'        -- AND fcr.argument9              = ''F''      -- uncomment = FINAL runs only',
'           AND TO_CHAR(gl.ledger_id)      = TRIM(fcr.argument4)',
'           AND fu.user_id (+)             = fcr.requested_by',
'           AND TO_CHAR(fat.application_id (+)) = NVL(fcr.argument2, fcr.argument1)',
'           AND fat.language (+)           = ''US''',
'           AND (   :P70_CA_LEDGERS IS NULL         -- any separator: 1003,5001 10001',
'                OR INSTR('','' || REGEXP_REPLACE(:P70_CA_LEDGERS, ''[^0-9]+'', '','') || '','',',
'                         '','' || TRIM(fcr.argument4) || '','') > 0)',
'       ) x',
' ORDER BY x.request_id DESC',
') q',
'where q.ledger_id in (1003,5001,10001) and (:P70_CA_VIEW = ''ALL'' or q.is_latest = ''Y'')',
' and (:P70_CA_APPS is null',
' or (instr('':''||:P70_CA_APPS||'':'', '':AP:'')>0 and q.module=''AP - Payables'')',
' or (instr('':''||:P70_CA_APPS||'':'', '':AR:'')>0 and q.module=''AR - Receivables'')',
' or (instr('':''||:P70_CA_APPS||'':'', '':COST:'')>0 and q.module in (''Inventory (Cost Management)'',''Receiving (Cost Management)'')))',
'order by q.request_id desc);',
' l_context:=''Latest successful run | ''||l_rows||'' matching executions'';',
'when ''RV'' then',
' select max(run_start),count(*),sum(case when run_rank like ''Latest execution | %'' and batch_status=''Unposted'' then 1 else 0 end) into l_latest,l_rows,l_extra from (/* =====================================================================',
'   Oracle EBS 12.2.x - Last 3 Revaluation runs per ledger (via DB link ADG)',
'   A "run" = Revaluation batches of the same ledger, created by the same',
'   user, with < 10 min between consecutive batches (one batch is created',
'   per revaluation definition). Auto-reversal batches ("Reverses ...") of',
'   prior-period revaluations are excluded.',
'   Binds:',
'     :P70_RV_LEDGERS   ledger IDs, any separator (quotes/spaces ignored), e.g. 1003,10001,5001',
'     cast(null as varchar2(30))  e.g. SEP-2026 (case-insensitive, quotes ignored; NULL = any period)',
'   ===================================================================== */',
'SELECT /*+ DRIVING_SITE(l) LEADING(r l fu) USE_NL(l fu)',
'           INDEX(l (ledger_id)) INDEX(fu FND_USER_U1) */',
'       l.name                                        AS ledger_name,',
'       r.ledger_id,',
'       l.currency_code                               AS ledger_currency,',
'       case r.run_rank when 1 then ''Latest execution'' when 2 then ''Previous execution'' when 3 then ''Third-most-recent execution'' end',
'       || '' | '' || to_char(r.run_start,''DD-MON-YYYY HH24:MI:SS'') AS run_rank,                                   -- 1 = most recent',
'       r.run_start AS run_start,',
'       r.run_end AS run_end,',
'       fu.user_name                                  AS run_by,',
'       r.period_name,',
'       r.je_batch_id,',
'       r.batch_name,',
'       DECODE(r.batch_status, ''P'', ''Posted'', ''U'', ''Unposted'', r.batch_status) AS batch_status,',
'       r.je_header_id,',
'       r.journal_name,',
'       r.currency_code                               AS revalued_currency,',
'       r.accounted_dr,',
'       r.accounted_cr,',
'       r.accrual_rev_period_name                     AS reversal_period,',
'       DECODE(r.accrual_rev_status, ''R'', ''Reversed'', NULL, ''Not reversed'', r.accrual_rev_status) AS reversal_status',
'FROM  (SELECT x.*,',
'              MAX(x.run_seq) OVER (PARTITION BY x.ledger_id) - x.run_seq + 1 AS run_rank,',
'              MIN(x.batch_created) OVER (PARTITION BY x.ledger_id, x.run_seq) AS run_start,',
'              MAX(x.batch_created) OVER (PARTITION BY x.ledger_id, x.run_seq) AS run_end',
'       FROM  (SELECT y.*,',
'                     SUM(y.new_run) OVER (PARTITION BY y.ledger_id',
'                                          ORDER BY y.batch_created, y.je_batch_id, y.je_header_id',
'                                          ROWS UNBOUNDED PRECEDING) AS run_seq',
'              FROM  (SELECT /*+ LEADING(h b) USE_NL(b) INDEX(h (ledger_id)) INDEX(b GL_JE_BATCHES_U1) */',
'                            h.ledger_id,',
'                            h.period_name,',
'                            h.je_header_id,',
'                            h.name                        AS journal_name,',
'                            h.currency_code,',
'                            h.running_total_accounted_dr  AS accounted_dr,',
'                            h.running_total_accounted_cr  AS accounted_cr,',
'                            h.accrual_rev_period_name,',
'                            h.accrual_rev_status,',
'                            b.je_batch_id,',
'                            b.name                        AS batch_name,',
'                            b.status                      AS batch_status,',
'                            b.created_by,',
'                            b.creation_date               AS batch_created,',
'                            CASE',
'                              WHEN LAG(b.creation_date) OVER (PARTITION BY h.ledger_id',
'                                                              ORDER BY b.creation_date, b.je_batch_id, h.je_header_id) IS NULL',
'                                OR b.creation_date - LAG(b.creation_date) OVER (PARTITION BY h.ledger_id',
'                                                              ORDER BY b.creation_date, b.je_batch_id, h.je_header_id) > 10/1440',
'                                OR b.created_by <> LAG(b.created_by) OVER (PARTITION BY h.ledger_id',
'                                                              ORDER BY b.creation_date, b.je_batch_id, h.je_header_id)',
'                              THEN 1 ELSE 0',
'                            END                           AS new_run',
'                     FROM   apps.gl_je_headers@ADG h,',
'                            apps.gl_je_batches@ADG b',
'                     WHERE  h.ledger_id IN (SELECT TO_NUMBER(REGEXP_SUBSTR(:P70_RV_LEDGERS, ''[0-9]+'', 1, LEVEL))',
'                                            FROM   dual@ADG',
'                                            CONNECT BY REGEXP_SUBSTR(:P70_RV_LEDGERS, ''[0-9]+'', 1, LEVEL) IS NOT NULL)',
'                     AND    h.je_source   = ''Revaluation''',
'                     AND    h.actual_flag = ''A''',
'                     AND    h.reversed_je_header_id IS NULL          -- exclude auto-reversals',
'                     AND    (TRIM(REPLACE(cast(null as varchar2(30)), '''''''')) IS NULL OR h.period_name = UPPER(TRIM(REPLACE(cast(null as varchar2(30)), ''''''''))))',
'                     AND    b.je_batch_id = h.je_batch_id',
'                    ) y',
'             ) x',
'      ) r,',
'       apps.gl_ledgers@ADG l,',
'       apps.fnd_user@ADG   fu',
'WHERE r.ledger_id IN (1003,5001,10001) AND r.run_rank <= 3                                           -- last 3 runs',
'AND    l.ledger_id      = r.ledger_id',
'AND    fu.user_id   (+) = r.created_by',
'ORDER  BY l.name, r.run_rank, r.batch_created, r.je_batch_id, r.currency_code);',
' l_context:=''Last 3 runs per ledger | ''||l_rows||'' journals | ''||nvl(l_extra,0)||'' unposted in latest runs'';',
'when ''RS'' then',
' select max(run_start),count(*),sum(case when run_rank like ''Latest execution | %'' and batch_status=''Unposted'' then 1 else 0 end) into l_latest,l_rows,l_extra from (/* =====================================================================',
'   Oracle EBS 12.2.x - Last 3 journal REVERSAL runs per ledger, all sources (via DB link ADG)',
'   A reversal journal = any GL journal with reversed_je_header_id populated',
'   (batches named ''Reverses "Revalues for XXX transactions" ...'').',
'   A "run" = reversal batches of the same ledger, created by the same user,',
'   with < 10 min between consecutive batches (one batch per reversed journal).',
'   Binds:',
'     :P70_RS_LEDGERS   ledger IDs, any separator (quotes/spaces ignored), e.g. 1003,10001,5001',
'     cast(null as varchar2(30))  period of the REVERSAL journal, e.g. SEP-2026',
'                     (case-insensitive, quotes ignored; NULL = any period)',
'   ===================================================================== */',
'SELECT /*+ DRIVING_SITE(l) LEADING(r l fu o ob) USE_NL(l fu o ob)',
'           INDEX(l (ledger_id)) INDEX(fu FND_USER_U1) INDEX(o GL_JE_HEADERS_U1) INDEX(ob GL_JE_BATCHES_U1) */',
'       l.name                                        AS ledger_name,',
'       r.ledger_id,',
'       l.currency_code                               AS ledger_currency,',
'       case r.run_rank when 1 then ''Latest execution'' when 2 then ''Previous execution'' when 3 then ''Third-most-recent execution'' end',
'       || '' | '' || to_char(r.run_start,''DD-MON-YYYY HH24:MI:SS'') AS run_rank,                                   -- 1 = most recent',
'       r.run_start AS run_start,',
'       r.run_end AS run_end,',
'       r.run_batches,',
'       fu.user_name                                  AS run_by,',
'       r.period_name                                 AS reversal_period,',
'       r.je_batch_id,',
'       r.batch_name,',
'       DECODE(r.batch_status, ''P'', ''Posted'', ''U'', ''Unposted'', r.batch_status) AS batch_status,',
'       r.je_header_id,',
'       r.journal_name,',
'       js.user_je_source_name                        AS je_source,',
'       jc.user_je_category_name                      AS je_category,',
'       r.currency_code,',
'       r.accounted_dr,',
'       r.accounted_cr,',
'       o.je_header_id                                AS orig_je_header_id,',
'       o.name                                        AS orig_journal_name,',
'       o.period_name                                 AS orig_period,',
'       ob.name                                       AS orig_batch_name',
'FROM  (SELECT x.*,',
'              MAX(x.run_seq) OVER (PARTITION BY x.ledger_id) - x.run_seq + 1 AS run_rank,',
'              MIN(x.batch_created) OVER (PARTITION BY x.ledger_id, x.run_seq) AS run_start,',
'              MAX(x.batch_created) OVER (PARTITION BY x.ledger_id, x.run_seq) AS run_end,',
'              COUNT(DISTINCT x.je_batch_id) OVER (PARTITION BY x.ledger_id, x.run_seq) AS run_batches',
'       FROM  (SELECT y.*,',
'                     SUM(y.new_run) OVER (PARTITION BY y.ledger_id',
'                                          ORDER BY y.batch_created, y.je_batch_id, y.je_header_id',
'                                          ROWS UNBOUNDED PRECEDING) AS run_seq',
'              FROM  (SELECT /*+ LEADING(h b) USE_NL(b) INDEX(h (ledger_id)) INDEX(b GL_JE_BATCHES_U1) */',
'                            h.ledger_id,',
'                            h.period_name,',
'                            h.je_header_id,',
'                            h.name                        AS journal_name,',
'                            h.je_source,',
'                            h.je_category,',
'                            h.currency_code,',
'                            h.running_total_accounted_dr  AS accounted_dr,',
'                            h.running_total_accounted_cr  AS accounted_cr,',
'                            h.reversed_je_header_id,',
'                            b.je_batch_id,',
'                            b.name                        AS batch_name,',
'                            b.status                      AS batch_status,',
'                            b.created_by,',
'                            b.creation_date               AS batch_created,',
'                            CASE',
'                              WHEN LAG(b.creation_date) OVER (PARTITION BY h.ledger_id',
'                                                              ORDER BY b.creation_date, b.je_batch_id, h.je_header_id) IS NULL',
'                                OR b.creation_date - LAG(b.creation_date) OVER (PARTITION BY h.ledger_id',
'                                                              ORDER BY b.creation_date, b.je_batch_id, h.je_header_id) > 10/1440',
'                                OR b.created_by <> LAG(b.created_by) OVER (PARTITION BY h.ledger_id',
'                                                              ORDER BY b.creation_date, b.je_batch_id, h.je_header_id)',
'                              THEN 1 ELSE 0',
'                            END                           AS new_run',
'                     FROM   apps.gl_je_headers@ADG h,',
'                            apps.gl_je_batches@ADG b',
'                     WHERE  h.ledger_id IN (SELECT TO_NUMBER(REGEXP_SUBSTR(:P70_RS_LEDGERS, ''[0-9]+'', 1, LEVEL))',
'                                            FROM   dual@ADG',
'                                            CONNECT BY REGEXP_SUBSTR(:P70_RS_LEDGERS, ''[0-9]+'', 1, LEVEL) IS NOT NULL)',
'                     AND    h.actual_flag = ''A''',
'                     AND    h.reversed_je_header_id IS NOT NULL      -- reversals only',
'                     AND    (TRIM(REPLACE(cast(null as varchar2(30)), '''''''')) IS NULL',
'                             OR h.period_name = UPPER(TRIM(REPLACE(cast(null as varchar2(30)), ''''''''))))',
'                     AND    b.je_batch_id = h.je_batch_id',
'                    ) y',
'             ) x',
'      ) r,',
'       apps.gl_ledgers@ADG    l,',
'       apps.fnd_user@ADG      fu,',
'       apps.gl_je_headers@ADG o,',
'       apps.gl_je_batches@ADG ob,',
'       apps.gl_je_sources@ADG js,',
'       apps.gl_je_categories@ADG jc',
'WHERE r.ledger_id IN (1003,5001,10001) AND r.run_rank <= 3                                       -- last 3 runs',
'AND    l.ledger_id          = r.ledger_id',
'AND    fu.user_id       (+) = r.created_by',
'AND    o.je_header_id   (+) = r.reversed_je_header_id',
'AND    ob.je_batch_id   (+) = o.je_batch_id',
'AND    js.je_source_name (+) = r.je_source',
'AND    jc.je_category_name (+) = r.je_category',
'ORDER  BY l.name, r.run_rank, r.batch_created, r.je_batch_id, r.currency_code);',
' l_context:=''Last 3 runs per ledger | ''||l_rows||'' journals | ''||nvl(l_extra,0)||'' unposted in latest runs'';',
'else raise_application_error(-20003,''Unknown process'');',
'end case;',
'apex_json.open_object;apex_json.write(''latest'',to_char(l_latest,''DD-MON-YYYY HH24:MI:SS''));apex_json.write(''context'',l_context);apex_json.close_object;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>15235204448931754
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
,p_required_role=>wwv_flow_imp.id(9156329399484443)
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(15409186303381769)
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
 p_id=>wwv_flow_imp.id(15409299442381769)
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
 p_id=>wwv_flow_imp.id(15409339344381769)
,p_plug_name=>'Fixed Assets Close Status'
,p_static_id=>'fixed-assets-close-status'
,p_region_name=>'fa71-report'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>30
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select q.*,apex_page.get_url(p_page=>72,p_clear_cache=>''72'',p_items=>''P72_LEDGER_ID,P72_BOOK_TYPE_CODE,P72_PERIOD_NAME'',p_values=>to_char(q.ledger_id)||'',''||q.book_type_code||'',''||q.period_name) bridge_url from (select r.*,',
' case when r.close_status=''COMPLETE (NO GL POSTING)'' then ''NOT APPLICABLE''',
' when r.close_status=''ANNUAL CALENDAR - CONFIRM SCOPE'' then ''SCOPE REVIEW''',
' when r.period_status=''Not found'' then ''PERIOD NOT FOUND''',
' when r.gl_mapping_issues>0 or r.orphan_asset_lines>0 or r.sla_period_mismatch_lines>0 then ''MAPPING REVIEW''',
' when r.close_status<>''COMPLETE'' then ''PENDING CLOSE''',
' when r.sla_unlinked_lines>0 then ''POSTING COVERAGE REVIEW''',
' when r.fa_summary_rows=0 then ''NO FA DATA''',
' when r.fa_vs_gl_expense_diff is null then ''NO POSTED EXPENSE''',
' when r.fa_vs_gl_expense_diff<>0 or round(r.fa_deprn_amount-nvl(r.sla_expense_net,0),2)<>0 then ''DIFFERENCE''',
' else ''MATCHED'' end reconciliation_status',
' from (select q.*,s.sla_expense_dr,s.sla_expense_cr,s.sla_expense_net,',
' nvl(s.sla_expense_lines,0) sla_expense_lines,nvl(s.orphan_asset_lines,0) orphan_asset_lines,',
' nvl(s.sla_period_mismatch_lines,0) sla_period_mismatch_lines,nvl(s.sla_unlinked_lines,0) sla_unlinked_lines,',
' case when g.gl_mapping_issues=0 then g.gl_posted_expense_dr end gl_posted_expense_dr,',
' case when g.gl_mapping_issues=0 then g.gl_posted_expense_cr end gl_posted_expense_cr,',
' case when g.gl_mapping_issues=0 then g.gl_posted_expense_net end gl_posted_expense_net,',
' nvl(g.gl_line_count,0) gl_line_count,nvl(g.gl_mapping_issues,0) gl_mapping_issues,',
' nvl(g.gl_posted_expense_lines,0) gl_posted_expense_lines,',
' case when q.fa_summary_rows>0 and nvl(g.gl_mapping_issues,0)=0 and nvl(s.orphan_asset_lines,0)=0',
'  and nvl(s.sla_period_mismatch_lines,0)=0 and nvl(s.sla_unlinked_lines,0)=0',
'  and (nvl(g.gl_posted_expense_lines,0)>0 or (q.fa_nonzero_rows=0 and q.deprn_events=0))',
'  and q.close_status not in (''COMPLETE (NO GL POSTING)'',''ANNUAL CALENDAR - CONFIRM SCOPE'')',
'  then round(q.fa_deprn_amount-nvl(g.gl_posted_expense_net,0),2) end fa_vs_gl_expense_diff',
' from (SELECT /*+ DRIVING_SITE(bc) */',
'       gl.ledger_id,',
'       gl.name                                   ledger_name,',
'       gl.currency_code,',
'       bc.book_type_code,',
'       bc.book_class,',
'       bc.deprn_calendar,',
'       NVL(dp.period_name, NVL(UPPER(TRIM(REPLACE(:P71_PERIOD_NAME, ''''''''))),',
'                               TO_CHAR(ADD_MONTHS(SYSDATE, -1), ''MON-YYYY'', ''NLS_DATE_LANGUAGE=ENGLISH'')))  period_name,',
'       CASE WHEN dp.period_counter IS NULL        THEN ''Not found''',
'            WHEN dp.period_close_date IS NOT NULL THEN ''Closed''',
'            ELSE ''Open'' END                      period_status,',
'       dp.period_close_date,',
'       NVL(dp.deprn_run, ''N'')                    deprn_run,',
'       NVL(fa.fa_summary_rows, 0)                fa_summary_rows,',
'       NVL(fa.fa_nonzero_rows, 0)                fa_nonzero_rows,',
'       fa.fa_deprn_amount,',
'       fa.fa_catchup_amount,',
'       fa.fa_positive_deprn,fa.fa_negative_deprn,',
'       NVL(x.deprn_events, 0)                    deprn_events,',
'       NVL(x.unaccounted_events, 0)              unaccounted_events,',
'       NVL(x.entries_not_final, 0)               entries_not_final,',
'       NVL(x.entries_not_transferred, 0)         entries_not_transferred,',
'       NVL(j.gl_groups_expected, 0)              gl_groups_expected,',
'       NVL(j.gl_groups_missing, 0)               gl_groups_missing,',
'       NVL(j.gl_shared_groups, 0)                gl_shared_groups,',
'       NVL(j.gl_journals, 0)                     gl_journals,',
'       NVL(j.gl_unposted, 0)                     gl_unposted,',
'       j.gl_journal_dr_total,',
'       -- indicator only: FA period depreciation vs whole-journal debit total',
'       NVL(fa.fa_deprn_amount, 0) - NVL(j.gl_journal_dr_total, 0)  fa_vs_gl_dr_diff,',
'       j.gl_batch_names,',
'       CASE',
'         WHEN dp.period_counter IS NULL                   THEN NULL',
'         WHEN NVL(fa.fa_summary_rows, 0) = 0              THEN ''NO DEPRECIATION DATA''',
'         WHEN fa.fa_nonzero_rows = 0                      THEN ''ZERO DEPRECIATION''',
'         WHEN fa.fa_deprn_amount = 0                      THEN ''ZERO NET DEPRECIATION''',
'       END                                       activity_note,',
'       CASE',
'         WHEN ct.number_per_fiscal_year = 1               THEN ''ANNUAL CALENDAR - CONFIRM SCOPE''',
'         WHEN dp.period_counter IS NULL                   THEN ''PERIOD NOT FOUND''',
'         WHEN dp.period_close_date IS NULL                THEN ''NOT CLOSED''',
'         WHEN NVL(dp.deprn_run, ''N'') <> ''Y''               THEN ''NO DEPRN RUN''',
'         WHEN bc.gl_posting_allowed_flag <> ''YES''         THEN ''COMPLETE (NO GL POSTING)''',
'         WHEN NVL(x.unaccounted_events, 0) > 0            THEN ''UNACCOUNTED EVENTS''',
'         WHEN NVL(x.entries_not_final, 0) > 0             THEN ''ACCOUNTING NOT FINAL''',
'         WHEN NVL(x.entries_not_transferred, 0) > 0       THEN ''NOT TRANSFERRED TO GL''',
'         WHEN NVL(fa.fa_nonzero_rows, 0) > 0',
'          AND NVL(x.deprn_events, 0) = 0                  THEN ''NO ACCOUNTING EVENTS''',
'         WHEN NVL(j.gl_groups_missing, 0) > 0             THEN ''GL JOURNAL MISSING''',
'         WHEN NVL(fa.fa_nonzero_rows, 0) > 0',
'          AND NVL(j.gl_journals, 0) = 0                   THEN ''NO GL JOURNAL''',
'         WHEN NVL(j.gl_unposted, 0) > 0                   THEN ''GL NOT POSTED''',
'         ELSE ''COMPLETE''',
'       END                                       close_status',
'  FROM apps.fa_book_controls@ADG  bc,',
'       apps.gl_ledgers@ADG        gl,',
'       apps.fa_calendar_types@ADG ct,',
'       apps.fa_deprn_periods@ADG  dp,',
'       -- FA side: depreciation calculated for the period (in-scope books only)',
'       (SELECT ds.book_type_code, ds.period_counter,',
'               COUNT(*)                                                   fa_summary_rows,',
'               SUM(CASE WHEN ds.deprn_amount-NVL(ds.deprn_adjustment_amount,0)>0 THEN ds.deprn_amount-NVL(ds.deprn_adjustment_amount,0) ELSE 0 END) fa_positive_deprn,',
'               SUM(CASE WHEN ds.deprn_amount-NVL(ds.deprn_adjustment_amount,0)<0 THEN ds.deprn_amount-NVL(ds.deprn_adjustment_amount,0) ELSE 0 END) fa_negative_deprn,',
'               SUM(CASE WHEN ds.deprn_amount - NVL(ds.deprn_adjustment_amount, 0) <> 0',
'                        THEN 1 ELSE 0 END)                                fa_nonzero_rows,',
'               -- catch-up (deprn_adjustment_amount) is booked by the Adjustment journal, not Depreciation',
'               SUM(ds.deprn_amount - NVL(ds.deprn_adjustment_amount, 0))  fa_deprn_amount,',
'               SUM(NVL(ds.deprn_adjustment_amount, 0))                    fa_catchup_amount',
'          FROM apps.fa_deprn_summary@ADG ds,',
'               apps.fa_deprn_periods@ADG dp2,',
'               apps.fa_book_controls@ADG bc2',
'         WHERE bc2.set_of_books_id IN (1003, 5001, 10001)',
'           AND dp2.book_type_code  = bc2.book_type_code',
'           AND dp2.period_name     = NVL(UPPER(TRIM(REPLACE(:P71_PERIOD_NAME, ''''''''))),',
'                                         TO_CHAR(ADD_MONTHS(SYSDATE, -1), ''MON-YYYY'', ''NLS_DATE_LANGUAGE=ENGLISH''))',
'           AND ds.book_type_code   = dp2.book_type_code',
'           AND ds.period_counter   = dp2.period_counter',
'           AND ds.deprn_source_code = ''DEPRN''',
'         GROUP BY ds.book_type_code, ds.period_counter) fa,',
'       -- SLA side: depreciation events and entries in the book''s own ledger',
'       (SELECT te.ledger_id,',
'               te.source_id_char_1 book_type_code,',
'               te.source_id_int_2  period_counter,',
'               COUNT(DISTINCT e.event_id) deprn_events,',
'               COUNT(DISTINCT CASE WHEN e.event_status_code IN (''U'', ''I'') THEN e.event_id END) unaccounted_events,',
'               COUNT(DISTINCT CASE WHEN ah.accounting_entry_status_code <> ''F''',
'                                   THEN ah.ae_header_id END) entries_not_final,',
'               COUNT(DISTINCT CASE WHEN ah.accounting_entry_status_code = ''F''',
'                                    AND (NVL(ah.gl_transfer_status_code, ''N'') <> ''Y'' OR ah.group_id IS NULL)',
'                                   THEN ah.ae_header_id END) entries_not_transferred',
'          FROM apps.xla_transaction_entities@ADG te,',
'               apps.xla_events@ADG               e,',
'               apps.xla_ae_headers@ADG           ah',
'         WHERE te.application_id  = 140',
'           AND te.ledger_id       IN (1003, 5001, 10001)',
'           AND te.entity_code     = ''DEPRECIATION''',
'           AND EXISTS (SELECT 1',
'                         FROM apps.fa_deprn_periods@ADG dp3',
'                        WHERE dp3.book_type_code = te.source_id_char_1',
'                          AND dp3.period_counter = te.source_id_int_2',
'                          AND dp3.period_name = NVL(UPPER(TRIM(REPLACE(:P71_PERIOD_NAME, ''''''''))),',
'                                                    TO_CHAR(ADD_MONTHS(SYSDATE, -1), ''MON-YYYY'', ''NLS_DATE_LANGUAGE=ENGLISH'')))',
'           AND e.application_id  = 140',
'           AND e.entity_id       = te.entity_id',
'           -- outer join keeps events that have no accounting header yet',
'           AND ah.application_id (+) = 140',
'           AND ah.event_id       (+) = e.event_id',
'           AND ah.ledger_id      (+) = te.ledger_id',
'         GROUP BY te.ledger_id, te.source_id_char_1, te.source_id_int_2) x,',
'       -- GL side: every transferred SLA group must have a Depreciation journal in the period',
'       (SELECT g.ledger_id,',
'               g.book_type_code,',
'               g.period_counter,',
'               COUNT(DISTINCT g.group_id)                                          gl_groups_expected,',
'               COUNT(DISTINCT CASE WHEN gh.je_header_id IS NULL THEN g.group_id END) gl_groups_missing,',
'               COUNT(DISTINCT CASE WHEN g.books_in_group > 1 THEN g.group_id END)  gl_shared_groups,',
'               COUNT(gh.je_header_id)                                              gl_journals,',
'               SUM(CASE WHEN gh.status <> ''P'' THEN 1 ELSE 0 END)                   gl_unposted,',
'               SUM(gh.running_total_accounted_dr)                                  gl_journal_dr_total,',
'               LISTAGG(DISTINCT CASE WHEN gh.je_header_id IS NOT NULL',
'                                    THEN gh.batch_name || '' ['' || gh.batch_status || '']''',
'                               END, ''; '' ON OVERFLOW TRUNCATE ''...'' WITH COUNT)',
'                 WITHIN GROUP (ORDER BY gh.batch_name || '' ['' || gh.batch_status || '']'') gl_batch_names',
'          FROM (SELECT gg.ledger_id, gg.book_type_code, gg.period_counter, gg.group_id,',
'                       -- Count distinct books across the group''s periods, not book-period rows.',
'                       -- A second book outside the selected period still makes the total shared.',
'                       (SELECT COUNT(DISTINCT shared_te.source_id_char_1)',
'                          FROM apps.xla_transaction_entities@ADG shared_te,',
'                               apps.xla_ae_headers@ADG shared_ah',
'                         WHERE shared_te.application_id = 140',
'                           AND shared_te.ledger_id = gg.ledger_id',
'                           AND shared_te.entity_code = ''DEPRECIATION''',
'                           AND shared_ah.application_id = 140',
'                           AND shared_ah.entity_id = shared_te.entity_id',
'                           AND shared_ah.ledger_id = shared_te.ledger_id',
'                           AND shared_ah.accounting_entry_status_code = ''F''',
'                           AND shared_ah.gl_transfer_status_code = ''Y''',
'                           AND shared_ah.group_id = gg.group_id) books_in_group',
'                  FROM (SELECT DISTINCT te.ledger_id,',
'                               te.source_id_char_1 book_type_code,',
'                               te.source_id_int_2  period_counter,',
'                               ah.group_id',
'                          FROM apps.xla_transaction_entities@ADG te,',
'                               apps.xla_ae_headers@ADG           ah',
'                         WHERE te.application_id  = 140',
'                           AND te.ledger_id       IN (1003, 5001, 10001)',
'                           AND te.entity_code     = ''DEPRECIATION''',
'                           AND EXISTS (SELECT 1',
'                                         FROM apps.fa_deprn_periods@ADG dp4',
'                                        WHERE dp4.book_type_code = te.source_id_char_1',
'                                          AND dp4.period_counter = te.source_id_int_2',
'                                          AND dp4.period_name = NVL(UPPER(TRIM(REPLACE(:P71_PERIOD_NAME, ''''''''))),',
'                                                                    TO_CHAR(ADD_MONTHS(SYSDATE, -1), ''MON-YYYY'', ''NLS_DATE_LANGUAGE=ENGLISH'')))',
'                           AND ah.application_id  = 140',
'                           AND ah.entity_id       = te.entity_id',
'                           AND ah.ledger_id       = te.ledger_id',
'                           AND ah.accounting_entry_status_code = ''F''',
'                           AND ah.gl_transfer_status_code      = ''Y''',
'                           AND ah.group_id IS NOT NULL) gg) g,',
'               (SELECT b.group_id, h.ledger_id, h.je_header_id, h.status, h.running_total_accounted_dr,',
'                       b.name batch_name, b.status batch_status',
'                  FROM apps.gl_je_batches@ADG b,',
'                       apps.gl_je_headers@ADG h',
'                 WHERE h.period_name = NVL(UPPER(TRIM(REPLACE(:P71_PERIOD_NAME, ''''''''))),',
'                                           TO_CHAR(ADD_MONTHS(SYSDATE, -1), ''MON-YYYY'', ''NLS_DATE_LANGUAGE=ENGLISH''))',
'                   AND h.je_category = ''Depreciation''',
'                   AND h.je_source   = ''Assets''',
'                   AND h.actual_flag = ''A''',
'                   AND h.ledger_id   IN (1003, 5001, 10001)',
'                   AND b.je_batch_id = h.je_batch_id) gh',
'         WHERE gh.group_id  (+) = g.group_id',
'           AND gh.ledger_id (+) = g.ledger_id',
'         GROUP BY g.ledger_id, g.book_type_code, g.period_counter) j',
' WHERE gl.ledger_id         = bc.set_of_books_id',
'   -- App 128 ledger scope, enforced regardless of the filter',
'   AND bc.set_of_books_id  IN (1003, 5001, 10001)',
'   AND bc.date_ineffective IS NULL',
'   AND ct.calendar_type     = bc.deprn_calendar',
'   AND (:P71_BOOK_CLASS IS NULL OR bc.book_class = UPPER(TRIM(REPLACE(:P71_BOOK_CLASS, ''''''''))))',
'   -- ledger filter: whole numeric tokens only (separators: comma, semicolon, colon, space)',
'   AND (TRIM(REPLACE(:P71_LEDGER_IDS, '''''''')) IS NULL',
'        OR bc.set_of_books_id IN (SELECT TO_NUMBER(CASE WHEN REGEXP_LIKE(t.tok, ''^[0-9]{1,15}$'') THEN t.tok END)',
'                                    FROM (SELECT REGEXP_SUBSTR(REPLACE(:P71_LEDGER_IDS, ''''''''), ''[^,;: ]+'', 1, LEVEL) tok',
'                                            FROM dual@ADG',
'                                         CONNECT BY REGEXP_SUBSTR(REPLACE(:P71_LEDGER_IDS, ''''''''), ''[^,;: ]+'', 1, LEVEL) IS NOT NULL) t))',
'   -- outer join: a book without the requested period still shows as PERIOD NOT FOUND',
'   AND dp.book_type_code (+) = bc.book_type_code',
'   AND dp.period_name    (+) = NVL(UPPER(TRIM(REPLACE(:P71_PERIOD_NAME, ''''''''))),',
'                                   TO_CHAR(ADD_MONTHS(SYSDATE, -1), ''MON-YYYY'', ''NLS_DATE_LANGUAGE=ENGLISH''))',
'   AND fa.book_type_code (+) = dp.book_type_code',
'   AND fa.period_counter (+) = dp.period_counter',
'   AND x.ledger_id       (+) = bc.set_of_books_id',
'   AND x.book_type_code  (+) = dp.book_type_code',
'   AND x.period_counter  (+) = dp.period_counter',
'   AND j.ledger_id       (+) = bc.set_of_books_id',
'   AND j.book_type_code  (+) = dp.book_type_code',
'   AND j.period_counter  (+) = dp.period_counter',
' ORDER BY gl.ledger_id, bc.book_class, bc.book_type_code) q,(select te.ledger_id,te.source_id_char_1 book_type_code,dp.period_name,',
' count(*) sla_expense_lines,sum(nvl(xl.accounted_dr,0)) sla_expense_dr,',
' sum(nvl(xl.accounted_cr,0)) sla_expense_cr,',
' sum(nvl(xl.accounted_dr,0)-nvl(xl.accounted_cr,0)) sla_expense_net,',
' count(case when ah.period_name<>dp.period_name or ah.period_name is null then 1 end) sla_period_mismatch_lines,',
' count(case when not exists(select 1 from apps.gl_import_references@ADG ir,',
'  apps.gl_je_lines@ADG jl,apps.gl_je_headers@ADG jh',
'  where ir.gl_sl_link_id=xl.gl_sl_link_id and ir.gl_sl_link_table=xl.gl_sl_link_table',
'  and jl.je_header_id=ir.je_header_id and jl.je_line_num=ir.je_line_num',
'  and jh.je_header_id=jl.je_header_id and jh.ledger_id=te.ledger_id',
'  and jh.period_name=dp.period_name and jh.je_source=''Assets'' and jh.je_category=''Depreciation''',
'  and jh.actual_flag=''A'' and jh.status=''P'') then 1 end) sla_unlinked_lines,',
' count(case when not exists(select 1 from apps.fa_deprn_summary@ADG ds',
'  where ds.book_type_code=te.source_id_char_1 and ds.period_counter=te.source_id_int_2',
'  and ds.asset_id=te.source_id_int_1 and ds.deprn_source_code=''DEPRN'') then 1 end) orphan_asset_lines',
' from apps.fa_book_controls@ADG bc,apps.fa_deprn_periods@ADG dp,',
' apps.xla_transaction_entities@ADG te,apps.xla_ae_headers@ADG ah,apps.xla_ae_lines@ADG xl',
' where bc.set_of_books_id in (1003,5001,10001) and bc.date_ineffective is null',
' and (cast(null as number) is null or bc.set_of_books_id=cast(null as number))',
' and (cast(null as varchar2(30)) is null or bc.book_type_code=cast(null as varchar2(30)))',
' and dp.book_type_code=bc.book_type_code and dp.period_name=NVL(UPPER(TRIM(REPLACE(:P71_PERIOD_NAME, ''''''''))),TO_CHAR(ADD_MONTHS(SYSDATE,-1),''MON-YYYY'',''NLS_DATE_LANGUAGE=ENGLISH''))',
' and te.application_id=140 and te.entity_code=''DEPRECIATION''',
' and te.ledger_id=bc.set_of_books_id and te.source_id_char_1=bc.book_type_code',
' and te.source_id_int_2=dp.period_counter',
' and ah.application_id=te.application_id and ah.entity_id=te.entity_id',
' and ah.ledger_id=te.ledger_id and ah.accounting_entry_status_code=''F''',
' and xl.application_id=ah.application_id and xl.ae_header_id=ah.ae_header_id',
' and xl.accounting_class_code=''EXPENSE''',
' group by te.ledger_id,te.source_id_char_1,dp.period_name) s,(select ledger_id,book_type_code,period_name,count(*) gl_line_count,',
' count(case when mapping_status<>''MAPPED'' then 1 end) gl_mapping_issues,',
' count(case when mapping_status=''MAPPED'' and accounting_class_code=''EXPENSE'' and status=''P'' then 1 end) gl_posted_expense_lines,',
' sum(case when mapping_status=''MAPPED'' and accounting_class_code=''EXPENSE'' and status=''P'' then accounted_dr else 0 end) gl_posted_expense_dr,',
' sum(case when mapping_status=''MAPPED'' and accounting_class_code=''EXPENSE'' and status=''P'' then accounted_cr else 0 end) gl_posted_expense_cr,',
' sum(case when mapping_status=''MAPPED'' and accounting_class_code=''EXPENSE'' and status=''P'' then accounted_dr-accounted_cr else 0 end) gl_posted_expense_net',
' from (select j.ledger_id,j.book_type_code,j.period_name,j.je_header_id,j.journal_name,j.batch_name,j.status,',
' jl.je_line_num,jl.code_combination_id,nvl(jl.accounted_dr,0) accounted_dr,nvl(jl.accounted_cr,0) accounted_cr,',
' m.accounting_class_code,',
' case when m.reference_rows is not null and m.unresolved_refs=0 and m.class_count=1',
' and m.book_count=1 and m.period_count=1 and m.ledger_count=1',
' and m.min_application=140 and m.max_application=140',
' and m.min_entity=''DEPRECIATION'' and m.max_entity=''DEPRECIATION''',
' and m.ledger_id=j.ledger_id and m.book_type_code=j.book_type_code and m.period_counter=j.period_counter then ''MAPPED'' else ''REVIEW MAPPING'' end mapping_status',
' from (select distinct te.ledger_id,te.source_id_char_1 book_type_code,',
' dp.period_name,dp.period_counter,h.je_header_id,h.name journal_name,h.status,',
' b.name batch_name,b.je_batch_id',
' from apps.fa_book_controls@ADG bc,apps.fa_deprn_periods@ADG dp,',
' apps.xla_transaction_entities@ADG te,apps.xla_ae_headers@ADG ah,apps.gl_je_batches@ADG b,apps.gl_je_headers@ADG h',
' where bc.set_of_books_id in (1003,5001,10001) and bc.date_ineffective is null',
' and (cast(null as number) is null or bc.set_of_books_id=cast(null as number))',
' and (cast(null as varchar2(30)) is null or bc.book_type_code=cast(null as varchar2(30)))',
' and dp.book_type_code=bc.book_type_code and dp.period_name=NVL(UPPER(TRIM(REPLACE(:P71_PERIOD_NAME, ''''''''))),TO_CHAR(ADD_MONTHS(SYSDATE,-1),''MON-YYYY'',''NLS_DATE_LANGUAGE=ENGLISH''))',
' and te.application_id=140 and te.entity_code=''DEPRECIATION''',
' and te.ledger_id=bc.set_of_books_id and te.source_id_char_1=bc.book_type_code',
' and te.source_id_int_2=dp.period_counter',
' and ah.application_id=te.application_id and ah.entity_id=te.entity_id',
' and ah.ledger_id=te.ledger_id and ah.accounting_entry_status_code=''F''',
' and ah.group_id is not null and ah.gl_transfer_status_code=''Y''',
' and b.group_id=ah.group_id and h.je_batch_id=b.je_batch_id and h.ledger_id=te.ledger_id',
' and h.je_source=''Assets'' and h.je_category=''Depreciation'' and h.actual_flag=''A''',
' and h.period_name=dp.period_name) j,apps.gl_je_lines@ADG jl,(select ir.je_header_id,ir.je_line_num,count(*) reference_rows,',
' count(case when xl.ae_header_id is null or te.entity_id is null then 1 end) unresolved_refs,',
' count(distinct xl.accounting_class_code) class_count,min(xl.accounting_class_code) accounting_class_code,',
' count(distinct te.source_id_char_1) book_count,min(te.source_id_char_1) book_type_code,',
' count(distinct te.source_id_int_2) period_count,min(te.source_id_int_2) period_counter,',
' count(distinct te.ledger_id) ledger_count,min(te.ledger_id) ledger_id,',
' min(te.application_id) min_application,max(te.application_id) max_application,',
' min(te.entity_code) min_entity,max(te.entity_code) max_entity',
' from apps.gl_import_references@ADG ir,apps.xla_ae_lines@ADG xl,',
' apps.xla_ae_headers@ADG ah,apps.xla_transaction_entities@ADG te',
' where exists(select 1 from (select distinct te.ledger_id,te.source_id_char_1 book_type_code,',
' dp.period_name,dp.period_counter,h.je_header_id,h.name journal_name,h.status,',
' b.name batch_name,b.je_batch_id',
' from apps.fa_book_controls@ADG bc,apps.fa_deprn_periods@ADG dp,',
' apps.xla_transaction_entities@ADG te,apps.xla_ae_headers@ADG ah,apps.gl_je_batches@ADG b,apps.gl_je_headers@ADG h',
' where bc.set_of_books_id in (1003,5001,10001) and bc.date_ineffective is null',
' and (cast(null as number) is null or bc.set_of_books_id=cast(null as number))',
' and (cast(null as varchar2(30)) is null or bc.book_type_code=cast(null as varchar2(30)))',
' and dp.book_type_code=bc.book_type_code and dp.period_name=NVL(UPPER(TRIM(REPLACE(:P71_PERIOD_NAME, ''''''''))),TO_CHAR(ADD_MONTHS(SYSDATE,-1),''MON-YYYY'',''NLS_DATE_LANGUAGE=ENGLISH''))',
' and te.application_id=140 and te.entity_code=''DEPRECIATION''',
' and te.ledger_id=bc.set_of_books_id and te.source_id_char_1=bc.book_type_code',
' and te.source_id_int_2=dp.period_counter',
' and ah.application_id=te.application_id and ah.entity_id=te.entity_id',
' and ah.ledger_id=te.ledger_id and ah.accounting_entry_status_code=''F''',
' and ah.group_id is not null and ah.gl_transfer_status_code=''Y''',
' and b.group_id=ah.group_id and h.je_batch_id=b.je_batch_id and h.ledger_id=te.ledger_id',
' and h.je_source=''Assets'' and h.je_category=''Depreciation'' and h.actual_flag=''A''',
' and h.period_name=dp.period_name) sj where sj.je_header_id=ir.je_header_id)',
' and xl.gl_sl_link_id (+)=ir.gl_sl_link_id and xl.gl_sl_link_table (+)=ir.gl_sl_link_table',
' and ah.application_id (+)=xl.application_id and ah.ae_header_id (+)=xl.ae_header_id',
' and te.application_id (+)=ah.application_id and te.entity_id (+)=ah.entity_id',
' group by ir.je_header_id,ir.je_line_num) m',
' where jl.je_header_id=j.je_header_id and m.je_header_id (+)=jl.je_header_id',
' and m.je_line_num (+)=jl.je_line_num) group by ledger_id,book_type_code,period_name) g',
' where s.ledger_id (+)=q.ledger_id and s.book_type_code (+)=q.book_type_code and s.period_name (+)=q.period_name',
' and g.ledger_id (+)=q.ledger_id and g.book_type_code (+)=q.book_type_code and g.period_name (+)=q.period_name',
' ) r) q'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_PERIOD_NAME,P71_LEDGER_IDS,P71_BOOK_CLASS'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(15409416763381769)
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
,p_internal_uid=>15409416763381769
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15409560792381769)
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
 p_id=>wwv_flow_imp.id(15409673268381769)
,p_db_column_name=>'BOOK_CLASS'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Book Class'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15409760626381769)
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
 p_id=>wwv_flow_imp.id(15409823019381769)
,p_db_column_name=>'BRIDGE_URL'
,p_display_order=>420
,p_column_identifier=>'AP'
,p_column_label=>'Bridge Url'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15409991227381769)
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
 p_id=>wwv_flow_imp.id(15410047533381769)
,p_db_column_name=>'CURRENCY_CODE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Currency'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15410187327381769)
,p_db_column_name=>'DEPRN_CALENDAR'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Calendar'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15410263211381769)
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
 p_id=>wwv_flow_imp.id(15410395031381769)
,p_db_column_name=>'DEPRN_RUN'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Depreciation Run'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15410492982381769)
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
 p_id=>wwv_flow_imp.id(15410573289381769)
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
 p_id=>wwv_flow_imp.id(15410682132381769)
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
 p_id=>wwv_flow_imp.id(15410795254381769)
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
 p_id=>wwv_flow_imp.id(15410803560381769)
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
 p_id=>wwv_flow_imp.id(15410941795381769)
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
 p_id=>wwv_flow_imp.id(15411035767381769)
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
 p_id=>wwv_flow_imp.id(15411174174381769)
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
 p_id=>wwv_flow_imp.id(15411225579381769)
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
 p_id=>wwv_flow_imp.id(15411336980381769)
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
 p_id=>wwv_flow_imp.id(15411463664381769)
,p_db_column_name=>'GL_BATCH_NAMES'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'GL Batches'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15411585124381769)
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
 p_id=>wwv_flow_imp.id(15411626803381769)
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
 p_id=>wwv_flow_imp.id(15411729927381769)
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
 p_id=>wwv_flow_imp.id(15411828486381769)
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
 p_id=>wwv_flow_imp.id(15411957413381769)
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
 p_id=>wwv_flow_imp.id(15412035897381769)
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
 p_id=>wwv_flow_imp.id(15412179259381769)
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
 p_id=>wwv_flow_imp.id(15412290298381769)
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
 p_id=>wwv_flow_imp.id(15412314089381769)
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
 p_id=>wwv_flow_imp.id(15412415297381769)
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
 p_id=>wwv_flow_imp.id(15412539015381769)
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
 p_id=>wwv_flow_imp.id(15412624761381769)
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
 p_id=>wwv_flow_imp.id(15412759495381769)
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
 p_id=>wwv_flow_imp.id(15412827274381769)
,p_db_column_name=>'LEDGER_NAME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Ledger'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15412976373381769)
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
 p_id=>wwv_flow_imp.id(15413079494381769)
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
 p_id=>wwv_flow_imp.id(15413174074381769)
,p_db_column_name=>'PERIOD_NAME'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Period'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15413299898381769)
,p_db_column_name=>'PERIOD_STATUS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Period Status'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15413320045381769)
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
 p_id=>wwv_flow_imp.id(15413497065381769)
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
 p_id=>wwv_flow_imp.id(15413575812381769)
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
 p_id=>wwv_flow_imp.id(15413664638381769)
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
 p_id=>wwv_flow_imp.id(15413796613381769)
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
 p_id=>wwv_flow_imp.id(15413806574381769)
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
 p_id=>wwv_flow_imp.id(15413988000381769)
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
 p_id=>wwv_flow_imp.id(15414002641381769)
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
 p_id=>wwv_flow_imp.id(15414185616381780)
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
 p_id=>wwv_flow_imp.id(15414221843381780)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(15409186303381769)
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
 p_id=>wwv_flow_imp.id(15414359401381780)
,p_name=>'P71_BOOK_CLASS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(15409186303381769)
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
 p_id=>wwv_flow_imp.id(15414446156381780)
,p_name=>'P71_LEDGER_IDS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(15409186303381769)
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
 p_id=>wwv_flow_imp.id(15414576750381780)
,p_name=>'P71_PERIOD_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(15409186303381769)
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
 p_id=>wwv_flow_imp.id(15414654583381780)
,p_process_sequence=>5
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Normalize Fixed Assets filters'
,p_static_id=>'normalize-fixed-assets-filters'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare old_value varchar2(4000):=:P71_LEDGER_IDS; valid_value varchar2(4000);begin',
' select listagg(column_value,'':'') within group(order by column_value) into valid_value from (select distinct column_value from table(apex_string.split(old_value,'':'')) where column_value in (''1003'',''5001'',''10001''));',
' if old_value is not null and valid_value is null then valid_value:=''1003:5001:10001'';end if;',
' :P71_LEDGER_IDS:=valid_value;',
' if :P71_BOOK_CLASS is not null and :P71_BOOK_CLASS not in (''CORPORATE'',''TAX'') then :P71_BOOK_CLASS:=''CORPORATE'';end if;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>15414654583381780
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
,p_required_role=>wwv_flow_imp.id(9156329399484443)
,p_dialog_title=>'Fixed Assets Accounting Bridge'
,p_dialog_height=>'850'
,p_dialog_width=>'1450'
,p_dialog_chained=>'N'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(15414711346381780)
,p_plug_name=>'Actual GL Journal Lines'
,p_static_id=>'actual-gl-journal-lines'
,p_region_name=>'fa72-gl-lines'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>30
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select l.*,(select cc.concatenated_segments from apps.gl_code_combinations_kfv@ADG cc where cc.code_combination_id=l.code_combination_id) account_code from (select j.ledger_id,j.book_type_code,j.period_name,j.je_header_id,j.journal_name,j.batch_name,'
||'j.status,',
' jl.je_line_num,jl.code_combination_id,nvl(jl.accounted_dr,0) accounted_dr,nvl(jl.accounted_cr,0) accounted_cr,',
' m.accounting_class_code,',
' case when m.reference_rows is not null and m.unresolved_refs=0 and m.class_count=1',
' and m.book_count=1 and m.period_count=1 and m.ledger_count=1',
' and m.min_application=140 and m.max_application=140',
' and m.min_entity=''DEPRECIATION'' and m.max_entity=''DEPRECIATION''',
' and m.ledger_id=j.ledger_id and m.book_type_code=j.book_type_code and m.period_counter=j.period_counter then ''MAPPED'' else ''REVIEW MAPPING'' end mapping_status',
' from (select distinct te.ledger_id,te.source_id_char_1 book_type_code,',
' dp.period_name,dp.period_counter,h.je_header_id,h.name journal_name,h.status,',
' b.name batch_name,b.je_batch_id',
' from apps.fa_book_controls@ADG bc,apps.fa_deprn_periods@ADG dp,',
' apps.xla_transaction_entities@ADG te,apps.xla_ae_headers@ADG ah,apps.gl_je_batches@ADG b,apps.gl_je_headers@ADG h',
' where bc.set_of_books_id in (1003,5001,10001) and bc.date_ineffective is null',
' and (:P72_LEDGER_ID is null or bc.set_of_books_id=:P72_LEDGER_ID)',
' and (:P72_BOOK_TYPE_CODE is null or bc.book_type_code=:P72_BOOK_TYPE_CODE)',
' and dp.book_type_code=bc.book_type_code and dp.period_name=:P72_PERIOD_NAME',
' and te.application_id=140 and te.entity_code=''DEPRECIATION''',
' and te.ledger_id=bc.set_of_books_id and te.source_id_char_1=bc.book_type_code',
' and te.source_id_int_2=dp.period_counter',
' and ah.application_id=te.application_id and ah.entity_id=te.entity_id',
' and ah.ledger_id=te.ledger_id and ah.accounting_entry_status_code=''F''',
' and ah.group_id is not null and ah.gl_transfer_status_code=''Y''',
' and b.group_id=ah.group_id and h.je_batch_id=b.je_batch_id and h.ledger_id=te.ledger_id',
' and h.je_source=''Assets'' and h.je_category=''Depreciation'' and h.actual_flag=''A''',
' and h.period_name=dp.period_name) j,apps.gl_je_lines@ADG jl,(select ir.je_header_id,ir.je_line_num,count(*) reference_rows,',
' count(case when xl.ae_header_id is null or te.entity_id is null then 1 end) unresolved_refs,',
' count(distinct xl.accounting_class_code) class_count,min(xl.accounting_class_code) accounting_class_code,',
' count(distinct te.source_id_char_1) book_count,min(te.source_id_char_1) book_type_code,',
' count(distinct te.source_id_int_2) period_count,min(te.source_id_int_2) period_counter,',
' count(distinct te.ledger_id) ledger_count,min(te.ledger_id) ledger_id,',
' min(te.application_id) min_application,max(te.application_id) max_application,',
' min(te.entity_code) min_entity,max(te.entity_code) max_entity',
' from apps.gl_import_references@ADG ir,apps.xla_ae_lines@ADG xl,',
' apps.xla_ae_headers@ADG ah,apps.xla_transaction_entities@ADG te',
' where exists(select 1 from (select distinct te.ledger_id,te.source_id_char_1 book_type_code,',
' dp.period_name,dp.period_counter,h.je_header_id,h.name journal_name,h.status,',
' b.name batch_name,b.je_batch_id',
' from apps.fa_book_controls@ADG bc,apps.fa_deprn_periods@ADG dp,',
' apps.xla_transaction_entities@ADG te,apps.xla_ae_headers@ADG ah,apps.gl_je_batches@ADG b,apps.gl_je_headers@ADG h',
' where bc.set_of_books_id in (1003,5001,10001) and bc.date_ineffective is null',
' and (:P72_LEDGER_ID is null or bc.set_of_books_id=:P72_LEDGER_ID)',
' and (:P72_BOOK_TYPE_CODE is null or bc.book_type_code=:P72_BOOK_TYPE_CODE)',
' and dp.book_type_code=bc.book_type_code and dp.period_name=:P72_PERIOD_NAME',
' and te.application_id=140 and te.entity_code=''DEPRECIATION''',
' and te.ledger_id=bc.set_of_books_id and te.source_id_char_1=bc.book_type_code',
' and te.source_id_int_2=dp.period_counter',
' and ah.application_id=te.application_id and ah.entity_id=te.entity_id',
' and ah.ledger_id=te.ledger_id and ah.accounting_entry_status_code=''F''',
' and ah.group_id is not null and ah.gl_transfer_status_code=''Y''',
' and b.group_id=ah.group_id and h.je_batch_id=b.je_batch_id and h.ledger_id=te.ledger_id',
' and h.je_source=''Assets'' and h.je_category=''Depreciation'' and h.actual_flag=''A''',
' and h.period_name=dp.period_name) sj where sj.je_header_id=ir.je_header_id)',
' and xl.gl_sl_link_id (+)=ir.gl_sl_link_id and xl.gl_sl_link_table (+)=ir.gl_sl_link_table',
' and ah.application_id (+)=xl.application_id and ah.ae_header_id (+)=xl.ae_header_id',
' and te.application_id (+)=ah.application_id and te.entity_id (+)=ah.entity_id',
' group by ir.je_header_id,ir.je_line_num) m',
' where jl.je_header_id=j.je_header_id and m.je_header_id (+)=jl.je_header_id',
' and m.je_line_num (+)=jl.je_line_num) l',
'order by je_header_id,je_line_num'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P72_LEDGER_ID,P72_BOOK_TYPE_CODE,P72_PERIOD_NAME'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(15414845009381780)
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
,p_internal_uid=>15414845009381780
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15414953234381780)
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
 p_id=>wwv_flow_imp.id(15415022103381780)
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
 p_id=>wwv_flow_imp.id(15415156220381780)
,p_db_column_name=>'ACCOUNTING_CLASS_CODE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Accounting Class'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15415262653381780)
,p_db_column_name=>'ACCOUNT_CODE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Account'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15415337536381780)
,p_db_column_name=>'BATCH_NAME'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Batch'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15415412072381780)
,p_db_column_name=>'BOOK_TYPE_CODE'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'FA Book'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15415522382381780)
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
 p_id=>wwv_flow_imp.id(15415634308381789)
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
 p_id=>wwv_flow_imp.id(15415752171381789)
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
 p_id=>wwv_flow_imp.id(15415822657381789)
,p_db_column_name=>'JOURNAL_NAME'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Journal'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15415978251381789)
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
 p_id=>wwv_flow_imp.id(15416054365381789)
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
 p_id=>wwv_flow_imp.id(15416143620381789)
,p_db_column_name=>'PERIOD_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Period'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15416275671381789)
,p_db_column_name=>'STATUS'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Posting Status'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(15416399427381789)
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
 p_id=>wwv_flow_imp.id(15416464579381789)
,p_plug_name=>'Asset Details'
,p_static_id=>'asset-details'
,p_region_name=>'fa72-assets'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>20
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT a.ledger_id,',
'       a.book_type_code,',
'       a.period_name,',
'       a.asset_id,',
'       a.asset_number,',
'       a.deprn_run_date,',
'       a.fa_deprn_amount,',
'       a.fa_catchup_amount,',
'       CASE WHEN a.fa_deprn_amount > 0 THEN a.fa_deprn_amount ELSE 0 END positive_deprn,',
'       CASE WHEN a.fa_deprn_amount < 0 THEN a.fa_deprn_amount ELSE 0 END negative_deprn,',
'       CASE WHEN a.fa_deprn_amount < 0 THEN ''NEGATIVE DEPRECIATION''',
'            WHEN a.fa_deprn_amount > 0 THEN ''POSITIVE DEPRECIATION''',
'            ELSE ''ZERO DEPRECIATION'' END activity_type,',
'       NVL(s.sla_expense_dr, 0) sla_expense_dr,',
'       NVL(s.sla_expense_cr, 0) sla_expense_cr,',
'       NVL(s.sla_expense_net, 0) sla_expense_net,',
'       NVL(s.posted_linked_sla_net, 0) posted_linked_sla_net,',
'       a.fa_deprn_amount - NVL(s.sla_expense_net, 0) fa_sla_difference,',
'       NVL(s.sla_expense_net, 0) - NVL(s.posted_linked_sla_net, 0) sla_posted_link_difference,',
'       NVL(s.sla_expense_lines, 0) sla_expense_lines,',
'       NVL(s.sla_period_mismatch_lines, 0) sla_period_mismatch_lines,',
'       NVL(s.posted_linked_lines, 0) posted_linked_lines,',
'       NVL(s.sla_expense_lines, 0) - NVL(s.posted_linked_lines, 0) unlinked_expense_lines',
'  FROM (SELECT bc.set_of_books_id ledger_id,',
'               ds.book_type_code,',
'               dp.period_name,',
'               ds.asset_id,',
'               ad.asset_number,',
'               MAX(ds.deprn_run_date) deprn_run_date,',
'               SUM(ds.deprn_amount - NVL(ds.deprn_adjustment_amount, 0)) fa_deprn_amount,',
'               SUM(NVL(ds.deprn_adjustment_amount, 0)) fa_catchup_amount',
'          FROM apps.fa_book_controls@ADG bc,',
'               apps.fa_deprn_periods@ADG dp,',
'               apps.fa_deprn_summary@ADG ds,',
'               apps.fa_additions_b@ADG ad',
'         WHERE bc.set_of_books_id IN (1003, 5001, 10001)',
'           AND bc.set_of_books_id = :P72_LEDGER_ID',
'           AND bc.book_type_code = :P72_BOOK_TYPE_CODE',
'           AND bc.date_ineffective IS NULL',
'           AND dp.book_type_code = bc.book_type_code',
'           AND dp.period_name = :P72_PERIOD_NAME',
'           AND ds.book_type_code = dp.book_type_code',
'           AND ds.period_counter = dp.period_counter',
'           AND ds.deprn_source_code = ''DEPRN''',
'           AND ad.asset_id (+) = ds.asset_id',
'         GROUP BY bc.set_of_books_id, ds.book_type_code, dp.period_name,',
'                  ds.asset_id, ad.asset_number) a,',
'       (SELECT q.ledger_id, q.book_type_code, q.asset_id,',
'               COUNT(*) sla_expense_lines,',
'               SUM(q.sla_period_mismatch) sla_period_mismatch_lines,',
'               SUM(q.accounted_dr) sla_expense_dr,',
'               SUM(q.accounted_cr) sla_expense_cr,',
'               SUM(q.accounted_dr - q.accounted_cr) sla_expense_net,',
'               SUM(q.posted_link) posted_linked_lines,',
'               SUM(CASE WHEN q.posted_link = 1 THEN q.accounted_dr - q.accounted_cr ELSE 0 END) posted_linked_sla_net',
'          FROM (SELECT te.ledger_id,',
'                       te.source_id_char_1 book_type_code,',
'                       te.source_id_int_1 asset_id,',
'                       CASE WHEN ah.period_name = dp.period_name THEN 0 ELSE 1 END sla_period_mismatch,',
'                       al.accounted_dr,',
'                       al.accounted_cr,',
'                       -- EXISTS counts an SLA line once even when references repeat or GL is summarized.',
'                       CASE WHEN EXISTS',
'                         (SELECT 1',
'                            FROM apps.gl_import_references@ADG ir,',
'                                 apps.gl_je_lines@ADG jl,',
'                                 apps.gl_je_headers@ADG jh',
'                           WHERE ir.gl_sl_link_id = al.gl_sl_link_id',
'                             AND ir.gl_sl_link_table = al.gl_sl_link_table',
'                             AND jl.je_header_id = ir.je_header_id',
'                             AND jl.je_line_num = ir.je_line_num',
'                             AND jh.je_header_id = jl.je_header_id',
'                             AND jh.ledger_id = te.ledger_id',
'                             AND jh.period_name = :P72_PERIOD_NAME',
'                             AND jh.je_source = ''Assets''',
'                             AND jh.je_category = ''Depreciation''',
'                             AND jh.actual_flag = ''A''',
'                             AND jh.status = ''P'') THEN 1 ELSE 0 END posted_link',
'                  FROM apps.fa_book_controls@ADG bc,',
'                       apps.fa_deprn_periods@ADG dp,',
'                       apps.xla_transaction_entities@ADG te,',
'                       apps.xla_ae_headers@ADG ah,',
'                       (SELECT application_id, ae_header_id, ae_line_num,',
'                               NVL(accounted_dr, 0) accounted_dr,',
'                               NVL(accounted_cr, 0) accounted_cr,',
'                               gl_sl_link_id, gl_sl_link_table',
'                          FROM apps.xla_ae_lines@ADG',
'                         WHERE application_id = 140',
'                           AND accounting_class_code = ''EXPENSE'') al',
'                 WHERE bc.set_of_books_id IN (1003, 5001, 10001)',
'                   AND bc.set_of_books_id = :P72_LEDGER_ID',
'                   AND bc.book_type_code = :P72_BOOK_TYPE_CODE',
'                   AND bc.date_ineffective IS NULL',
'                   AND dp.book_type_code = bc.book_type_code',
'                   AND dp.period_name = :P72_PERIOD_NAME',
'                   AND te.application_id = 140',
'                   AND te.ledger_id = bc.set_of_books_id',
'                   AND te.entity_code = ''DEPRECIATION''',
'                   AND te.source_id_char_1 = dp.book_type_code',
'                   AND te.source_id_int_2 = dp.period_counter',
'                   AND ah.application_id = te.application_id',
'                   AND ah.entity_id = te.entity_id',
'                   AND ah.ledger_id = te.ledger_id',
'                   AND ah.accounting_entry_status_code = ''F''',
'                   AND al.application_id = ah.application_id',
'                   AND al.ae_header_id = ah.ae_header_id) q',
'         GROUP BY q.ledger_id, q.book_type_code, q.asset_id) s',
' WHERE s.ledger_id (+) = a.ledger_id',
'   AND s.book_type_code (+) = a.book_type_code',
'   AND s.asset_id (+) = a.asset_id',
' ORDER BY CASE WHEN a.fa_deprn_amount < 0 THEN 0 ELSE 1 END,',
'          a.fa_deprn_amount, a.asset_number, a.asset_id'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P72_LEDGER_ID,P72_BOOK_TYPE_CODE,P72_PERIOD_NAME'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(15416551610381789)
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
,p_internal_uid=>15416551610381789
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15416676123381789)
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
 p_id=>wwv_flow_imp.id(15416791140381789)
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
 p_id=>wwv_flow_imp.id(15416807731381789)
,p_db_column_name=>'ASSET_NUMBER'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Asset'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15416908729381789)
,p_db_column_name=>'BOOK_TYPE_CODE'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'FA Book'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15417062496381789)
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
 p_id=>wwv_flow_imp.id(15417144259381797)
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
 p_id=>wwv_flow_imp.id(15417225127381797)
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
 p_id=>wwv_flow_imp.id(15417311168381797)
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
 p_id=>wwv_flow_imp.id(15417458878381797)
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
 p_id=>wwv_flow_imp.id(15417548816381797)
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
 p_id=>wwv_flow_imp.id(15417634663381797)
,p_db_column_name=>'PERIOD_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Period'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15417714236381797)
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
 p_id=>wwv_flow_imp.id(15417861303381797)
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
 p_id=>wwv_flow_imp.id(15417955838381797)
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
 p_id=>wwv_flow_imp.id(15418023956381797)
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
 p_id=>wwv_flow_imp.id(15418144651381797)
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
 p_id=>wwv_flow_imp.id(15418237044381797)
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
 p_id=>wwv_flow_imp.id(15418341471381797)
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
 p_id=>wwv_flow_imp.id(15418420443381797)
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
 p_id=>wwv_flow_imp.id(15418507161381797)
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
 p_id=>wwv_flow_imp.id(15418615361381806)
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
 p_id=>wwv_flow_imp.id(15418767906381806)
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
 p_id=>wwv_flow_imp.id(15418874813381806)
,p_plug_name=>'FA to SLA to GL Bridge'
,p_static_id=>'fa-to-sla-to-gl-bridge'
,p_region_name=>'fa72-bridge'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>10
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
' function f(v number) return varchar2 is begin return case when v is null then ''&mdash;'' else to_char(v,''FM999G999G999G999G990D00'') end;end;',
' procedure stage(label varchar2,dr number,cr number,net number) is begin htp.p(''<tr><th scope="row">''||apex_escape.html(label)||''</th><td>''||f(dr)||''</td><td>''||f(cr)||''</td><td>''||f(net)||''</td></tr>'');end;',
'begin',
' for r in (select r.*,',
' case when r.close_status=''COMPLETE (NO GL POSTING)'' then ''NOT APPLICABLE''',
' when r.close_status=''ANNUAL CALENDAR - CONFIRM SCOPE'' then ''SCOPE REVIEW''',
' when r.period_status=''Not found'' then ''PERIOD NOT FOUND''',
' when r.gl_mapping_issues>0 or r.orphan_asset_lines>0 or r.sla_period_mismatch_lines>0 then ''MAPPING REVIEW''',
' when r.close_status<>''COMPLETE'' then ''PENDING CLOSE''',
' when r.sla_unlinked_lines>0 then ''POSTING COVERAGE REVIEW''',
' when r.fa_summary_rows=0 then ''NO FA DATA''',
' when r.fa_vs_gl_expense_diff is null then ''NO POSTED EXPENSE''',
' when r.fa_vs_gl_expense_diff<>0 or round(r.fa_deprn_amount-nvl(r.sla_expense_net,0),2)<>0 then ''DIFFERENCE''',
' else ''MATCHED'' end reconciliation_status',
' from (select q.*,s.sla_expense_dr,s.sla_expense_cr,s.sla_expense_net,',
' nvl(s.sla_expense_lines,0) sla_expense_lines,nvl(s.orphan_asset_lines,0) orphan_asset_lines,',
' nvl(s.sla_period_mismatch_lines,0) sla_period_mismatch_lines,nvl(s.sla_unlinked_lines,0) sla_unlinked_lines,',
' case when g.gl_mapping_issues=0 then g.gl_posted_expense_dr end gl_posted_expense_dr,',
' case when g.gl_mapping_issues=0 then g.gl_posted_expense_cr end gl_posted_expense_cr,',
' case when g.gl_mapping_issues=0 then g.gl_posted_expense_net end gl_posted_expense_net,',
' nvl(g.gl_line_count,0) gl_line_count,nvl(g.gl_mapping_issues,0) gl_mapping_issues,',
' nvl(g.gl_posted_expense_lines,0) gl_posted_expense_lines,',
' case when q.fa_summary_rows>0 and nvl(g.gl_mapping_issues,0)=0 and nvl(s.orphan_asset_lines,0)=0',
'  and nvl(s.sla_period_mismatch_lines,0)=0 and nvl(s.sla_unlinked_lines,0)=0',
'  and (nvl(g.gl_posted_expense_lines,0)>0 or (q.fa_nonzero_rows=0 and q.deprn_events=0))',
'  and q.close_status not in (''COMPLETE (NO GL POSTING)'',''ANNUAL CALENDAR - CONFIRM SCOPE'')',
'  then round(q.fa_deprn_amount-nvl(g.gl_posted_expense_net,0),2) end fa_vs_gl_expense_diff',
' from (SELECT /*+ DRIVING_SITE(bc) */',
'       gl.ledger_id,',
'       gl.name                                   ledger_name,',
'       gl.currency_code,',
'       bc.book_type_code,',
'       bc.book_class,',
'       bc.deprn_calendar,',
'       NVL(dp.period_name, NVL(UPPER(TRIM(REPLACE(:P72_PERIOD_NAME, ''''''''))),',
'                               TO_CHAR(ADD_MONTHS(SYSDATE, -1), ''MON-YYYY'', ''NLS_DATE_LANGUAGE=ENGLISH'')))  period_name,',
'       CASE WHEN dp.period_counter IS NULL        THEN ''Not found''',
'            WHEN dp.period_close_date IS NOT NULL THEN ''Closed''',
'            ELSE ''Open'' END                      period_status,',
'       dp.period_close_date,',
'       NVL(dp.deprn_run, ''N'')                    deprn_run,',
'       NVL(fa.fa_summary_rows, 0)                fa_summary_rows,',
'       NVL(fa.fa_nonzero_rows, 0)                fa_nonzero_rows,',
'       fa.fa_deprn_amount,',
'       fa.fa_catchup_amount,',
'       fa.fa_positive_deprn,fa.fa_negative_deprn,',
'       NVL(x.deprn_events, 0)                    deprn_events,',
'       NVL(x.unaccounted_events, 0)              unaccounted_events,',
'       NVL(x.entries_not_final, 0)               entries_not_final,',
'       NVL(x.entries_not_transferred, 0)         entries_not_transferred,',
'       NVL(j.gl_groups_expected, 0)              gl_groups_expected,',
'       NVL(j.gl_groups_missing, 0)               gl_groups_missing,',
'       NVL(j.gl_shared_groups, 0)                gl_shared_groups,',
'       NVL(j.gl_journals, 0)                     gl_journals,',
'       NVL(j.gl_unposted, 0)                     gl_unposted,',
'       j.gl_journal_dr_total,',
'       -- indicator only: FA period depreciation vs whole-journal debit total',
'       NVL(fa.fa_deprn_amount, 0) - NVL(j.gl_journal_dr_total, 0)  fa_vs_gl_dr_diff,',
'       j.gl_batch_names,',
'       CASE',
'         WHEN dp.period_counter IS NULL                   THEN NULL',
'         WHEN NVL(fa.fa_summary_rows, 0) = 0              THEN ''NO DEPRECIATION DATA''',
'         WHEN fa.fa_nonzero_rows = 0                      THEN ''ZERO DEPRECIATION''',
'         WHEN fa.fa_deprn_amount = 0                      THEN ''ZERO NET DEPRECIATION''',
'       END                                       activity_note,',
'       CASE',
'         WHEN ct.number_per_fiscal_year = 1               THEN ''ANNUAL CALENDAR - CONFIRM SCOPE''',
'         WHEN dp.period_counter IS NULL                   THEN ''PERIOD NOT FOUND''',
'         WHEN dp.period_close_date IS NULL                THEN ''NOT CLOSED''',
'         WHEN NVL(dp.deprn_run, ''N'') <> ''Y''               THEN ''NO DEPRN RUN''',
'         WHEN bc.gl_posting_allowed_flag <> ''YES''         THEN ''COMPLETE (NO GL POSTING)''',
'         WHEN NVL(x.unaccounted_events, 0) > 0            THEN ''UNACCOUNTED EVENTS''',
'         WHEN NVL(x.entries_not_final, 0) > 0             THEN ''ACCOUNTING NOT FINAL''',
'         WHEN NVL(x.entries_not_transferred, 0) > 0       THEN ''NOT TRANSFERRED TO GL''',
'         WHEN NVL(fa.fa_nonzero_rows, 0) > 0',
'          AND NVL(x.deprn_events, 0) = 0                  THEN ''NO ACCOUNTING EVENTS''',
'         WHEN NVL(j.gl_groups_missing, 0) > 0             THEN ''GL JOURNAL MISSING''',
'         WHEN NVL(fa.fa_nonzero_rows, 0) > 0',
'          AND NVL(j.gl_journals, 0) = 0                   THEN ''NO GL JOURNAL''',
'         WHEN NVL(j.gl_unposted, 0) > 0                   THEN ''GL NOT POSTED''',
'         ELSE ''COMPLETE''',
'       END                                       close_status',
'  FROM apps.fa_book_controls@ADG  bc,',
'       apps.gl_ledgers@ADG        gl,',
'       apps.fa_calendar_types@ADG ct,',
'       apps.fa_deprn_periods@ADG  dp,',
'       -- FA side: depreciation calculated for the period (in-scope books only)',
'       (SELECT ds.book_type_code, ds.period_counter,',
'               COUNT(*)                                                   fa_summary_rows,',
'               SUM(CASE WHEN ds.deprn_amount-NVL(ds.deprn_adjustment_amount,0)>0 THEN ds.deprn_amount-NVL(ds.deprn_adjustment_amount,0) ELSE 0 END) fa_positive_deprn,',
'               SUM(CASE WHEN ds.deprn_amount-NVL(ds.deprn_adjustment_amount,0)<0 THEN ds.deprn_amount-NVL(ds.deprn_adjustment_amount,0) ELSE 0 END) fa_negative_deprn,',
'               SUM(CASE WHEN ds.deprn_amount - NVL(ds.deprn_adjustment_amount, 0) <> 0',
'                        THEN 1 ELSE 0 END)                                fa_nonzero_rows,',
'               -- catch-up (deprn_adjustment_amount) is booked by the Adjustment journal, not Depreciation',
'               SUM(ds.deprn_amount - NVL(ds.deprn_adjustment_amount, 0))  fa_deprn_amount,',
'               SUM(NVL(ds.deprn_adjustment_amount, 0))                    fa_catchup_amount',
'          FROM apps.fa_deprn_summary@ADG ds,',
'               apps.fa_deprn_periods@ADG dp2,',
'               apps.fa_book_controls@ADG bc2',
'         WHERE bc2.set_of_books_id IN (1003, 5001, 10001)',
'           AND dp2.book_type_code  = bc2.book_type_code',
'           AND dp2.period_name     = NVL(UPPER(TRIM(REPLACE(:P72_PERIOD_NAME, ''''''''))),',
'                                         TO_CHAR(ADD_MONTHS(SYSDATE, -1), ''MON-YYYY'', ''NLS_DATE_LANGUAGE=ENGLISH''))',
'           AND ds.book_type_code   = dp2.book_type_code',
'           AND ds.period_counter   = dp2.period_counter',
'           AND ds.deprn_source_code = ''DEPRN''',
'         GROUP BY ds.book_type_code, ds.period_counter) fa,',
'       -- SLA side: depreciation events and entries in the book''s own ledger',
'       (SELECT te.ledger_id,',
'               te.source_id_char_1 book_type_code,',
'               te.source_id_int_2  period_counter,',
'               COUNT(DISTINCT e.event_id) deprn_events,',
'               COUNT(DISTINCT CASE WHEN e.event_status_code IN (''U'', ''I'') THEN e.event_id END) unaccounted_events,',
'               COUNT(DISTINCT CASE WHEN ah.accounting_entry_status_code <> ''F''',
'                                   THEN ah.ae_header_id END) entries_not_final,',
'               COUNT(DISTINCT CASE WHEN ah.accounting_entry_status_code = ''F''',
'                                    AND (NVL(ah.gl_transfer_status_code, ''N'') <> ''Y'' OR ah.group_id IS NULL)',
'                                   THEN ah.ae_header_id END) entries_not_transferred',
'          FROM apps.xla_transaction_entities@ADG te,',
'               apps.xla_events@ADG               e,',
'               apps.xla_ae_headers@ADG           ah',
'         WHERE te.application_id  = 140',
'           AND te.ledger_id       IN (1003, 5001, 10001)',
'           AND te.entity_code     = ''DEPRECIATION''',
'           AND EXISTS (SELECT 1',
'                         FROM apps.fa_deprn_periods@ADG dp3',
'                        WHERE dp3.book_type_code = te.source_id_char_1',
'                          AND dp3.period_counter = te.source_id_int_2',
'                          AND dp3.period_name = NVL(UPPER(TRIM(REPLACE(:P72_PERIOD_NAME, ''''''''))),',
'                                                    TO_CHAR(ADD_MONTHS(SYSDATE, -1), ''MON-YYYY'', ''NLS_DATE_LANGUAGE=ENGLISH'')))',
'           AND e.application_id  = 140',
'           AND e.entity_id       = te.entity_id',
'           -- outer join keeps events that have no accounting header yet',
'           AND ah.application_id (+) = 140',
'           AND ah.event_id       (+) = e.event_id',
'           AND ah.ledger_id      (+) = te.ledger_id',
'         GROUP BY te.ledger_id, te.source_id_char_1, te.source_id_int_2) x,',
'       -- GL side: every transferred SLA group must have a Depreciation journal in the period',
'       (SELECT g.ledger_id,',
'               g.book_type_code,',
'               g.period_counter,',
'               COUNT(DISTINCT g.group_id)                                          gl_groups_expected,',
'               COUNT(DISTINCT CASE WHEN gh.je_header_id IS NULL THEN g.group_id END) gl_groups_missing,',
'               COUNT(DISTINCT CASE WHEN g.books_in_group > 1 THEN g.group_id END)  gl_shared_groups,',
'               COUNT(gh.je_header_id)                                              gl_journals,',
'               SUM(CASE WHEN gh.status <> ''P'' THEN 1 ELSE 0 END)                   gl_unposted,',
'               SUM(gh.running_total_accounted_dr)                                  gl_journal_dr_total,',
'               LISTAGG(DISTINCT CASE WHEN gh.je_header_id IS NOT NULL',
'                                    THEN gh.batch_name || '' ['' || gh.batch_status || '']''',
'                               END, ''; '' ON OVERFLOW TRUNCATE ''...'' WITH COUNT)',
'                 WITHIN GROUP (ORDER BY gh.batch_name || '' ['' || gh.batch_status || '']'') gl_batch_names',
'          FROM (SELECT gg.ledger_id, gg.book_type_code, gg.period_counter, gg.group_id,',
'                       -- Count distinct books across the group''s periods, not book-period rows.',
'                       -- A second book outside the selected period still makes the total shared.',
'                       (SELECT COUNT(DISTINCT shared_te.source_id_char_1)',
'                          FROM apps.xla_transaction_entities@ADG shared_te,',
'                               apps.xla_ae_headers@ADG shared_ah',
'                         WHERE shared_te.application_id = 140',
'                           AND shared_te.ledger_id = gg.ledger_id',
'                           AND shared_te.entity_code = ''DEPRECIATION''',
'                           AND shared_ah.application_id = 140',
'                           AND shared_ah.entity_id = shared_te.entity_id',
'                           AND shared_ah.ledger_id = shared_te.ledger_id',
'                           AND shared_ah.accounting_entry_status_code = ''F''',
'                           AND shared_ah.gl_transfer_status_code = ''Y''',
'                           AND shared_ah.group_id = gg.group_id) books_in_group',
'                  FROM (SELECT DISTINCT te.ledger_id,',
'                               te.source_id_char_1 book_type_code,',
'                               te.source_id_int_2  period_counter,',
'                               ah.group_id',
'                          FROM apps.xla_transaction_entities@ADG te,',
'                               apps.xla_ae_headers@ADG           ah',
'                         WHERE te.application_id  = 140',
'                           AND te.ledger_id       IN (1003, 5001, 10001)',
'                           AND te.entity_code     = ''DEPRECIATION''',
'                           AND EXISTS (SELECT 1',
'                                         FROM apps.fa_deprn_periods@ADG dp4',
'                                        WHERE dp4.book_type_code = te.source_id_char_1',
'                                          AND dp4.period_counter = te.source_id_int_2',
'                                          AND dp4.period_name = NVL(UPPER(TRIM(REPLACE(:P72_PERIOD_NAME, ''''''''))),',
'                                                                    TO_CHAR(ADD_MONTHS(SYSDATE, -1), ''MON-YYYY'', ''NLS_DATE_LANGUAGE=ENGLISH'')))',
'                           AND ah.application_id  = 140',
'                           AND ah.entity_id       = te.entity_id',
'                           AND ah.ledger_id       = te.ledger_id',
'                           AND ah.accounting_entry_status_code = ''F''',
'                           AND ah.gl_transfer_status_code      = ''Y''',
'                           AND ah.group_id IS NOT NULL) gg) g,',
'               (SELECT b.group_id, h.ledger_id, h.je_header_id, h.status, h.running_total_accounted_dr,',
'                       b.name batch_name, b.status batch_status',
'                  FROM apps.gl_je_batches@ADG b,',
'                       apps.gl_je_headers@ADG h',
'                 WHERE h.period_name = NVL(UPPER(TRIM(REPLACE(:P72_PERIOD_NAME, ''''''''))),',
'                                           TO_CHAR(ADD_MONTHS(SYSDATE, -1), ''MON-YYYY'', ''NLS_DATE_LANGUAGE=ENGLISH''))',
'                   AND h.je_category = ''Depreciation''',
'                   AND h.je_source   = ''Assets''',
'                   AND h.actual_flag = ''A''',
'                   AND h.ledger_id   IN (1003, 5001, 10001)',
'                   AND b.je_batch_id = h.je_batch_id) gh',
'         WHERE gh.group_id  (+) = g.group_id',
'           AND gh.ledger_id (+) = g.ledger_id',
'         GROUP BY g.ledger_id, g.book_type_code, g.period_counter) j',
' WHERE gl.ledger_id         = bc.set_of_books_id',
'   -- App 128 ledger scope, enforced regardless of the filter',
'   AND bc.set_of_books_id  IN (1003, 5001, 10001)',
'   AND bc.date_ineffective IS NULL',
'   AND ct.calendar_type     = bc.deprn_calendar',
'   AND (cast(null as varchar2(30)) IS NULL OR bc.book_class = UPPER(TRIM(REPLACE(cast(null as varchar2(30)), ''''''''))))',
'   -- ledger filter: whole numeric tokens only (separators: comma, semicolon, colon, space)',
'   AND (TRIM(REPLACE(:P72_LEDGER_ID, '''''''')) IS NULL',
'        OR bc.set_of_books_id IN (SELECT TO_NUMBER(CASE WHEN REGEXP_LIKE(t.tok, ''^[0-9]{1,15}$'') THEN t.tok END)',
'                                    FROM (SELECT REGEXP_SUBSTR(REPLACE(:P72_LEDGER_ID, ''''''''), ''[^,;: ]+'', 1, LEVEL) tok',
'                                            FROM dual@ADG',
'                                         CONNECT BY REGEXP_SUBSTR(REPLACE(:P72_LEDGER_ID, ''''''''), ''[^,;: ]+'', 1, LEVEL) IS NOT NULL) t))',
'   -- outer join: a book without the requested period still shows as PERIOD NOT FOUND',
'   AND dp.book_type_code (+) = bc.book_type_code',
'   AND dp.period_name    (+) = NVL(UPPER(TRIM(REPLACE(:P72_PERIOD_NAME, ''''''''))),',
'                                   TO_CHAR(ADD_MONTHS(SYSDATE, -1), ''MON-YYYY'', ''NLS_DATE_LANGUAGE=ENGLISH''))',
'   AND fa.book_type_code (+) = dp.book_type_code',
'   AND fa.period_counter (+) = dp.period_counter',
'   AND x.ledger_id       (+) = bc.set_of_books_id',
'   AND x.book_type_code  (+) = dp.book_type_code',
'   AND x.period_counter  (+) = dp.period_counter',
'   AND j.ledger_id       (+) = bc.set_of_books_id',
'   AND j.book_type_code  (+) = dp.book_type_code',
'   AND j.period_counter  (+) = dp.period_counter',
' ORDER BY gl.ledger_id, bc.book_class, bc.book_type_code) q,(select te.ledger_id,te.source_id_char_1 book_type_code,dp.period_name,',
' count(*) sla_expense_lines,sum(nvl(xl.accounted_dr,0)) sla_expense_dr,',
' sum(nvl(xl.accounted_cr,0)) sla_expense_cr,',
' sum(nvl(xl.accounted_dr,0)-nvl(xl.accounted_cr,0)) sla_expense_net,',
' count(case when ah.period_name<>dp.period_name or ah.period_name is null then 1 end) sla_period_mismatch_lines,',
' count(case when not exists(select 1 from apps.gl_import_references@ADG ir,',
'  apps.gl_je_lines@ADG jl,apps.gl_je_headers@ADG jh',
'  where ir.gl_sl_link_id=xl.gl_sl_link_id and ir.gl_sl_link_table=xl.gl_sl_link_table',
'  and jl.je_header_id=ir.je_header_id and jl.je_line_num=ir.je_line_num',
'  and jh.je_header_id=jl.je_header_id and jh.ledger_id=te.ledger_id',
'  and jh.period_name=dp.period_name and jh.je_source=''Assets'' and jh.je_category=''Depreciation''',
'  and jh.actual_flag=''A'' and jh.status=''P'') then 1 end) sla_unlinked_lines,',
' count(case when not exists(select 1 from apps.fa_deprn_summary@ADG ds',
'  where ds.book_type_code=te.source_id_char_1 and ds.period_counter=te.source_id_int_2',
'  and ds.asset_id=te.source_id_int_1 and ds.deprn_source_code=''DEPRN'') then 1 end) orphan_asset_lines',
' from apps.fa_book_controls@ADG bc,apps.fa_deprn_periods@ADG dp,',
' apps.xla_transaction_entities@ADG te,apps.xla_ae_headers@ADG ah,apps.xla_ae_lines@ADG xl',
' where bc.set_of_books_id in (1003,5001,10001) and bc.date_ineffective is null',
' and (:P72_LEDGER_ID is null or bc.set_of_books_id=:P72_LEDGER_ID)',
' and (:P72_BOOK_TYPE_CODE is null or bc.book_type_code=:P72_BOOK_TYPE_CODE)',
' and dp.book_type_code=bc.book_type_code and dp.period_name=:P72_PERIOD_NAME',
' and te.application_id=140 and te.entity_code=''DEPRECIATION''',
' and te.ledger_id=bc.set_of_books_id and te.source_id_char_1=bc.book_type_code',
' and te.source_id_int_2=dp.period_counter',
' and ah.application_id=te.application_id and ah.entity_id=te.entity_id',
' and ah.ledger_id=te.ledger_id and ah.accounting_entry_status_code=''F''',
' and xl.application_id=ah.application_id and xl.ae_header_id=ah.ae_header_id',
' and xl.accounting_class_code=''EXPENSE''',
' group by te.ledger_id,te.source_id_char_1,dp.period_name) s,(select ledger_id,book_type_code,period_name,count(*) gl_line_count,',
' count(case when mapping_status<>''MAPPED'' then 1 end) gl_mapping_issues,',
' count(case when mapping_status=''MAPPED'' and accounting_class_code=''EXPENSE'' and status=''P'' then 1 end) gl_posted_expense_lines,',
' sum(case when mapping_status=''MAPPED'' and accounting_class_code=''EXPENSE'' and status=''P'' then accounted_dr else 0 end) gl_posted_expense_dr,',
' sum(case when mapping_status=''MAPPED'' and accounting_class_code=''EXPENSE'' and status=''P'' then accounted_cr else 0 end) gl_posted_expense_cr,',
' sum(case when mapping_status=''MAPPED'' and accounting_class_code=''EXPENSE'' and status=''P'' then accounted_dr-accounted_cr else 0 end) gl_posted_expense_net',
' from (select j.ledger_id,j.book_type_code,j.period_name,j.je_header_id,j.journal_name,j.batch_name,j.status,',
' jl.je_line_num,jl.code_combination_id,nvl(jl.accounted_dr,0) accounted_dr,nvl(jl.accounted_cr,0) accounted_cr,',
' m.accounting_class_code,',
' case when m.reference_rows is not null and m.unresolved_refs=0 and m.class_count=1',
' and m.book_count=1 and m.period_count=1 and m.ledger_count=1',
' and m.min_application=140 and m.max_application=140',
' and m.min_entity=''DEPRECIATION'' and m.max_entity=''DEPRECIATION''',
' and m.ledger_id=j.ledger_id and m.book_type_code=j.book_type_code and m.period_counter=j.period_counter then ''MAPPED'' else ''REVIEW MAPPING'' end mapping_status',
' from (select distinct te.ledger_id,te.source_id_char_1 book_type_code,',
' dp.period_name,dp.period_counter,h.je_header_id,h.name journal_name,h.status,',
' b.name batch_name,b.je_batch_id',
' from apps.fa_book_controls@ADG bc,apps.fa_deprn_periods@ADG dp,',
' apps.xla_transaction_entities@ADG te,apps.xla_ae_headers@ADG ah,apps.gl_je_batches@ADG b,apps.gl_je_headers@ADG h',
' where bc.set_of_books_id in (1003,5001,10001) and bc.date_ineffective is null',
' and (:P72_LEDGER_ID is null or bc.set_of_books_id=:P72_LEDGER_ID)',
' and (:P72_BOOK_TYPE_CODE is null or bc.book_type_code=:P72_BOOK_TYPE_CODE)',
' and dp.book_type_code=bc.book_type_code and dp.period_name=:P72_PERIOD_NAME',
' and te.application_id=140 and te.entity_code=''DEPRECIATION''',
' and te.ledger_id=bc.set_of_books_id and te.source_id_char_1=bc.book_type_code',
' and te.source_id_int_2=dp.period_counter',
' and ah.application_id=te.application_id and ah.entity_id=te.entity_id',
' and ah.ledger_id=te.ledger_id and ah.accounting_entry_status_code=''F''',
' and ah.group_id is not null and ah.gl_transfer_status_code=''Y''',
' and b.group_id=ah.group_id and h.je_batch_id=b.je_batch_id and h.ledger_id=te.ledger_id',
' and h.je_source=''Assets'' and h.je_category=''Depreciation'' and h.actual_flag=''A''',
' and h.period_name=dp.period_name) j,apps.gl_je_lines@ADG jl,(select ir.je_header_id,ir.je_line_num,count(*) reference_rows,',
' count(case when xl.ae_header_id is null or te.entity_id is null then 1 end) unresolved_refs,',
' count(distinct xl.accounting_class_code) class_count,min(xl.accounting_class_code) accounting_class_code,',
' count(distinct te.source_id_char_1) book_count,min(te.source_id_char_1) book_type_code,',
' count(distinct te.source_id_int_2) period_count,min(te.source_id_int_2) period_counter,',
' count(distinct te.ledger_id) ledger_count,min(te.ledger_id) ledger_id,',
' min(te.application_id) min_application,max(te.application_id) max_application,',
' min(te.entity_code) min_entity,max(te.entity_code) max_entity',
' from apps.gl_import_references@ADG ir,apps.xla_ae_lines@ADG xl,',
' apps.xla_ae_headers@ADG ah,apps.xla_transaction_entities@ADG te',
' where exists(select 1 from (select distinct te.ledger_id,te.source_id_char_1 book_type_code,',
' dp.period_name,dp.period_counter,h.je_header_id,h.name journal_name,h.status,',
' b.name batch_name,b.je_batch_id',
' from apps.fa_book_controls@ADG bc,apps.fa_deprn_periods@ADG dp,',
' apps.xla_transaction_entities@ADG te,apps.xla_ae_headers@ADG ah,apps.gl_je_batches@ADG b,apps.gl_je_headers@ADG h',
' where bc.set_of_books_id in (1003,5001,10001) and bc.date_ineffective is null',
' and (:P72_LEDGER_ID is null or bc.set_of_books_id=:P72_LEDGER_ID)',
' and (:P72_BOOK_TYPE_CODE is null or bc.book_type_code=:P72_BOOK_TYPE_CODE)',
' and dp.book_type_code=bc.book_type_code and dp.period_name=:P72_PERIOD_NAME',
' and te.application_id=140 and te.entity_code=''DEPRECIATION''',
' and te.ledger_id=bc.set_of_books_id and te.source_id_char_1=bc.book_type_code',
' and te.source_id_int_2=dp.period_counter',
' and ah.application_id=te.application_id and ah.entity_id=te.entity_id',
' and ah.ledger_id=te.ledger_id and ah.accounting_entry_status_code=''F''',
' and ah.group_id is not null and ah.gl_transfer_status_code=''Y''',
' and b.group_id=ah.group_id and h.je_batch_id=b.je_batch_id and h.ledger_id=te.ledger_id',
' and h.je_source=''Assets'' and h.je_category=''Depreciation'' and h.actual_flag=''A''',
' and h.period_name=dp.period_name) sj where sj.je_header_id=ir.je_header_id)',
' and xl.gl_sl_link_id (+)=ir.gl_sl_link_id and xl.gl_sl_link_table (+)=ir.gl_sl_link_table',
' and ah.application_id (+)=xl.application_id and ah.ae_header_id (+)=xl.ae_header_id',
' and te.application_id (+)=ah.application_id and te.entity_id (+)=ah.entity_id',
' group by ir.je_header_id,ir.je_line_num) m',
' where jl.je_header_id=j.je_header_id and m.je_header_id (+)=jl.je_header_id',
' and m.je_line_num (+)=jl.je_line_num) group by ledger_id,book_type_code,period_name) g',
' where s.ledger_id (+)=q.ledger_id and s.book_type_code (+)=q.book_type_code and s.period_name (+)=q.period_name',
' and g.ledger_id (+)=q.ledger_id and g.book_type_code (+)=q.book_type_code and g.period_name (+)=q.period_name',
' and q.ledger_id=:P72_LEDGER_ID and q.book_type_code=:P72_BOOK_TYPE_CODE) r) loop',
' htp.p(''<div class="fa72-context"><h2>''||apex_escape.html(r.book_type_code)||'' &middot; ''||apex_escape.html(r.period_name)||''</h2><p>''||apex_escape.html(r.ledger_name)||'' &middot; ''||apex_escape.html(r.currency_code)||'' &middot; Close status: ''||apex'
||'_escape.html(r.close_status)||''</p>'');',
' htp.p(''<span class="fa72-status ''||case when r.reconciliation_status=''MATCHED'' then ''fa72-good'' else ''fa72-warn'' end||''">''||apex_escape.html(r.reconciliation_status)||''</span>'');',
' htp.p(''<table class="fa72-stage" aria-label="FA to SLA to GL amount bridge"><thead><tr><th>Stage</th><th>Positive / Debit</th><th>Negative / Credit</th><th>Net amount</th></tr></thead><tbody>'');',
' stage(''FA depreciation excluding catch-up'',r.fa_positive_deprn,abs(r.fa_negative_deprn),r.fa_deprn_amount);',
' stage(''Final SLA depreciation expense'',r.sla_expense_dr,r.sla_expense_cr,r.sla_expense_net);',
' stage(''Posted GL depreciation expense'',r.gl_posted_expense_dr,r.gl_posted_expense_cr,r.gl_posted_expense_net);',
' stage(''FA minus posted GL expense'',null,null,r.fa_vs_gl_expense_diff);',
' htp.p(''</tbody></table>'');',
' if r.reconciliation_status=''MATCHED'' and nvl(r.fa_negative_deprn,0)<0 and round(r.fa_vs_gl_dr_diff-2*r.fa_negative_deprn,2)=0 and r.gl_shared_groups=0 then',
' htp.p(''<p><strong>Explained: negative depreciation.</strong> Negative depreciation totals ''||f(r.fa_negative_deprn)||'' ''||apex_escape.html(r.currency_code)||''. It credits expense and debits the asset reserve. The whole-journal debit total of ''||f(r.'
||'gl_journal_dr_total)||'' therefore exceeds net FA depreciation by ''||f(-r.fa_vs_gl_dr_diff)||''. The net expense comparison above matches.</p>'');',
' end if;',
' htp.p(''<p class="fa72-subtle">FA catch-up excluded from this depreciation bridge: ''||f(r.fa_catchup_amount)||''. GL lines inspected: ''||r.gl_line_count||''; mapping issues: ''||r.gl_mapping_issues||''; SLA expense lines without an FA asset row: ''||r.orp'
||'han_asset_lines||''; expense lines not linked to posted GL: ''||r.sla_unlinked_lines||''; accounting-period mismatches: ''||r.sla_period_mismatch_lines||''.</p>'');',
' if r.gl_mapping_issues>0 or r.orphan_asset_lines>0 or r.sla_unlinked_lines>0 or r.sla_period_mismatch_lines>0 then htp.p(''<p class="fa72-status fa72-warn">Review the unmapped, shared, unposted, or period-mismatched entries below. A complete reconcil'
||'iation cannot be established.</p>'');end if;',
' htp.p(''<p class="fa72-subtle">GL journals can summarize multiple assets. Asset amounts below show SLA expense linked to posted GL; actual GL line totals are listed separately. Negative asset costs require a separate business review.</p></div>'');',
' end loop;',
'end;'))
,p_plug_source_type=>'NATIVE_PLSQL'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(15418923256381806)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(15418874813381806)
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
 p_id=>wwv_flow_imp.id(15419007459381806)
,p_name=>'P72_BOOK_TYPE_CODE'
,p_item_sequence=>20
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15419167955381806)
,p_name=>'P72_LEDGER_ID'
,p_item_sequence=>10
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15419244327381806)
,p_name=>'P72_PERIOD_NAME'
,p_item_sequence=>30
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(15419320764381806)
,p_name=>'Close accounting bridge'
,p_static_id=>'close-accounting-bridge'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(15418923256381806)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15419490440381806)
,p_event_id=>wwv_flow_imp.id(15419320764381806)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'apex.navigation.dialog.close(true);')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(15419581732381806)
,p_process_sequence=>5
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Validate Fixed Assets context'
,p_static_id=>'validate-fixed-assets-context'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare n number;begin',
' if :P72_LEDGER_ID is null or :P72_LEDGER_ID not in (''1003'',''5001'',''10001'') or :P72_BOOK_TYPE_CODE is null or :P72_PERIOD_NAME is null or length(:P72_PERIOD_NAME)>30 then raise_application_error(-20072,''Open an in-scope book from Fixed Assets.'');end '
||'if;',
' select count(*) into n from apps.fa_book_controls@ADG bc where bc.set_of_books_id in(1003,5001,10001) and bc.set_of_books_id=to_number(:P72_LEDGER_ID) and bc.book_type_code=:P72_BOOK_TYPE_CODE and bc.date_ineffective is null;',
' if n<>1 then raise_application_error(-20073,''The selected book does not belong to the selected ledger.'');end if;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>15419581732381806
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false)
);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
