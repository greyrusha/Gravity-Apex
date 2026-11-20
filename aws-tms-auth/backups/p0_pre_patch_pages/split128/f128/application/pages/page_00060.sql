prompt --application/pages/page_00060
begin
--   Manifest
--     PAGE: 00060
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.04.07'
,p_release=>'26.2.0'
,p_default_workspace_id=>100789
,p_default_application_id=>128
,p_default_id_offset=>9401733729708713
,p_default_owner=>'GL_ACCOUNTS'
);
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
wwv_flow_imp.component_end;
end;
/
