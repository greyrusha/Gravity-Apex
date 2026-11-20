prompt --application/pages/page_00061
begin
--   Manifest
--     PAGE: 00061
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.04.07'
,p_release=>'26.2.0'
,p_default_workspace_id=>100789
,p_default_application_id=>115
,p_default_id_offset=>9156328499369442
,p_default_owner=>'GL_ACCOUNTS'
);
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
,p_is_required=>true
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
,p_item_default=>'select upper(to_char(trunc(sysdate, ''MM''), ''MON-YYYY'', ''NLS_DATE_LANGUAGE=English'')) from dual'
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Accounting Period'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select upper(to_char(period_start, ''MON-YYYY'', ''NLS_DATE_LANGUAGE=English'')) d,',
'       upper(to_char(period_start, ''MON-YYYY'', ''NLS_DATE_LANGUAGE=English'')) r',
'from (',
'    select add_months(trunc(sysdate, ''YYYY''), level - 1) period_start',
'    from dual',
'    connect by level <= to_number(to_char(sysdate, ''MM''))',
')',
'order by period_start desc'))
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
wwv_flow_imp.component_end;
end;
/
