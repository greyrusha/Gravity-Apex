prompt --application/pages/page_00070
begin
--   Manifest
--     PAGE: 00070
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
,p_internal_uid=>1287000000000089
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(1287000000000088)
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
,p_internal_uid=>1287000000000088
);
wwv_flow_imp.component_end;
end;
/
