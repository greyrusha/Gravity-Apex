prompt --application/pages/page_00034
begin
--   Manifest
--     PAGE: 00034
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
 p_id=>34
,p_name=>'GL AR Reconciliation'
,p_alias=>'GL-AR-RECONCILIATION'
,p_step_title=>'GL/AR Reconciliation'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var p34Controller=(function($){',
' ''use strict'';',
' var busy=false,spinner=null,timerId=null,startedAt=null;',
' function byId(id){return $(''#''+id);}',
' function region(id){try{return apex.region(id);}catch(ignore){return null;}}',
' function seconds(){return ((performance.now()-startedAt)/1000).toFixed(1)+'' s'';}',
' function stop(){if(timerId){clearInterval(timerId);timerId=null;}if(spinner){spinner.remove();spinner=null;}}',
' function setBusy(on){busy=on;byId(''run-gl-ar-recon'').prop(''disabled'',on);}',
' function status(kind,title,body,timing){byId(''recon-status'').show();byId(''p34-status-panel'').removeAttr(''hidden'').removeClass(''p34-status--info p34-status--success p34-status--error'').addClass(''p34-status--''+kind);byId(''p34-status-title'').text(title'
||');byId(''p34-status-body'').text(body||'''');byId(''p34-status-timing'').text(timing||'''');}',
' function refresh(id){var r=region(id);if(r&&typeof r.refresh===''function''){r.refresh();}else{byId(id).trigger(''apexrefresh'');}}',
' function highlight(){byId(''gl-ar-recon-report'').find(''.a-IRR-table tbody tr'').each(function(){$(this).toggleClass(''p34-variance-row'',$(this).find(''.p34-badge--variance'').length>0);});}',
' function closeDetail(){apex.item(''P34_SELECTED_CCID'').setValue('''',null,true);byId(''recon-detail-context'').hide();byId(''recon-customer-detail'').hide();}',
' function hideResults(){apex.item(''P34_REPORT_READY'').setValue(''N'',null,true);byId(''analyze-ar-reconciliation-with-ai'').hide();byId(''recon-kpis'').hide();byId(''gl-ar-recon-report'').hide();closeDetail();}',
' function populateKpis(x){byId(''p34-kpi-accounts'').text(x.account_count);byId(''p34-kpi-ar'').text(x.ar_total);byId(''p34-kpi-gl'').text(x.gl_total);byId(''p34-kpi-variance'').text(x.variance_total);byId(''p34-kpi-out'').text(x.out_of_balance);}',
' function run(){if(busy||apex.item(''P34_CONTEXT_READY'').getValue()!==''Y'')return;hideResults();setBusy(true);startedAt=performance.now();status(''info'',''Running GL/AR reconciliation'',''Retrieving GL balances from TMS. This normally takes approximately 2'
||'0-30 seconds.'',''Elapsed: 0.0 s'');timerId=setInterval(function(){byId(''p34-status-timing'').text(''Elapsed: ''+seconds());},250);try{spinner=apex.util.showSpinner(byId(''recon-status''));}catch(ignore){spinner=null;}apex.server.process(''P34_RUN_RECON'',{pag'
||'eItems:''#P34_DB_LINK,#P34_PERIOD_NAME,#P34_LEDGER_ID,#P34_COMPANY,#P34_AGING_BUCKET_ID''},{dataType:''json''}).then(function(result){stop();setBusy(false);if(!result||result.ok!==true){status(''error'',''Reconciliation failed'',(result&&result.message)||''Un'
||'able to run reconciliation.'');return;}apex.item(''P34_REPORT_READY'').setValue(''Y'',null,true);populateKpis(result.summary);byId(''recon-kpis'').show();byId(''gl-ar-recon-report'').show();byId(''analyze-ar-reconciliation-with-ai'').show();refresh(''gl-ar-recon'
||'-report'');status(''success'',''Reconciliation complete'',result.summary.account_count+'' receivable accounts evaluated.'',''Total: ''+seconds());},function(error){stop();setBusy(false);status(''error'',''Reconciliation failed'',(error&&error.message)||''Unable to'
||' run reconciliation.'');});}',
' function drill(ccid,account){apex.item(''P34_SELECTED_CCID'').setValue(String(ccid),null,true);byId(''p34-detail-selection'').text(account||''Selected receivable account'');byId(''recon-detail-context'').show();byId(''recon-customer-detail'').show();refresh('''
||'recon-customer-detail'');$(''html, body'').animate({scrollTop:byId(''recon-detail-context'').offset().top-12},200);}',
' function openAi(){if(apex.item(''P34_REPORT_READY'').getValue()!==''Y'')return;var target=''ar_recon_ai_''+Date.now(),child=window.open('''',target);if(!child){apex.message.showErrors([{type:''error'',location:''page'',message:''Allow pop-ups to open the AI Anal'
||'yst in a new tab.'',unsafe:false}]);return;}child.document.write(''<title>Opening AI Analyst</title><p style="font-family:sans-serif;padding:1rem">Opening AI Analyst...</p>'');apex.server.process(''P34_GET_AI_URL'',{pageItems:''#P34_REPORT_READY,#P34_DB_LI'
||'NK,#P34_PERIOD_NAME,#P34_LEDGER_ID,#P34_COMPANY,#P34_AGING_BUCKET_ID''},{dataType:''json''}).then(function(result){if(!result||result.ok!==true||!result.url){child.close();apex.message.showErrors([{type:''error'',location:''page'',message:(result&&result.me'
||'ssage)||''Unable to open the AI Analyst.'',unsafe:false}]);return;}child.location.replace(result.url);},function(error){child.close();apex.message.showErrors([{type:''error'',location:''page'',message:(error&&error.message)||''Unable to open the AI Analyst.'
||''',unsafe:false}]);});}',
' function closePage(){window.close();setTimeout(function(){if(!window.closed){apex.navigation.redirect(apex.item(''P34_BACK_URL'').getValue());}},250);}',
' $(function(){hideResults();byId(''recon-status'').hide();byId(''p34-status-panel'').attr(''hidden'',''hidden'');$(document).on(''apexafterrefresh.p34'',''#gl-ar-recon-report'',highlight);});',
' return{run:run,drill:drill,closeDetail:closeDetail,openAi:openAi,closePage:closePage};',
'})(apex.jQuery);'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#analyze-ar-reconciliation-with-ai,#recon-kpis,#gl-ar-recon-report,#recon-detail-context,#recon-customer-detail{display:none;}',
'#recon-status{position:relative;min-height:4rem;}',
'.p34-status{border-left:4px solid #2563eb;border-radius:.25rem;padding:.8rem 1rem;background:#eff6ff;}',
'.p34-status--success{border-left-color:#15803d;background:#f0fdf4;}',
'.p34-status--error{border-left-color:#b91c1c;background:#fef2f2;}',
'#p34-status-title{font-size:1rem;font-weight:700;margin:0 0 .25rem;}#p34-status-body{margin:0;}#p34-status-timing{font-variant-numeric:tabular-nums;font-weight:600;margin-top:.35rem;}',
'.p34-kpis{display:grid;grid-template-columns:repeat(5,minmax(0,1fr));gap:1rem;padding:.25rem;}',
'.p34-kpi{border:1px solid var(--ut-component-border-color,#d9dce1);border-radius:.5rem;padding:1rem;background:var(--ut-component-background-color,#fff);}',
'.p34-kpi-label{font-size:.75rem;text-transform:uppercase;letter-spacing:.04em;color:#5f6368;}.p34-kpi-value{font-size:1.35rem;font-weight:700;font-variant-numeric:tabular-nums;margin-top:.3rem;}',
'.p34-status-badge{display:inline-block;border-radius:999px;padding:.15rem .55rem;font-weight:700;}.p34-badge--balanced{background:#ecfdf3;color:#166534;}.p34-badge--variance{background:#fee2e2;color:#991b1b;}',
'.p34-variance-row>td{background:#fff7ed!important;}.p34-detail-banner{font-weight:600;padding:.35rem 0;}',
'.p34-control-exception{display:inline-block;padding:.15rem .45rem;border-radius:1rem;background:#fee2e2;color:#991b1b;font-weight:700;}.p34-control-ok{display:inline-block;padding:.15rem .45rem;border-radius:1rem;background:#dcfce7;color:#166534;}',
'@media(max-width:900px){.p34-kpis{grid-template-columns:repeat(2,minmax(0,1fr));}}'))
,p_step_template=>4075783602716660119
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(9156329399484443)
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(993705178578421781)
,p_plug_name=>'GL AR Reconciliation Report'
,p_static_id=>'gl-ar-recon-report'
,p_title=>'GL/AR Reconciliation by Receivable Account'
,p_region_name=>'gl-ar-recon-report'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>40
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select n001 receivable_ccid,c001 receivable_account,c002 natural_account,n002 ar_open_accounted_amount,',
' n003 gl_beginning_balance,n004 gl_period_net,',
' to_number(c007,''99999999999999999999999999999999999999D99999999999999999999'',''NLS_NUMERIC_CHARACTERS=''''.,'''''') gl_period_receivables_activity,',
' to_number(c008,''99999999999999999999999999999999999999D99999999999999999999'',''NLS_NUMERIC_CHARACTERS=''''.,'''''') gl_period_revaluation_activity,',
' to_number(c009,''99999999999999999999999999999999999999D99999999999999999999'',''NLS_NUMERIC_CHARACTERS=''''.,'''''') gl_period_non_receivables_activity,',
' n005 gl_ending_balance,',
' to_number(c005,''99999999999999999999999999999999999999D99999999999999999999'',''NLS_NUMERIC_CHARACTERS=''''.,'''''') variance_amount,c003 ar_loaded_at,c004 gl_retrieved_at,',
' to_number(c006,''99999999999999999999999999999999999999D99999999999999999999'',''NLS_NUMERIC_CHARACTERS=''''.,'''''') ar_not_transferred_amount,',
' case when abs(nvl(to_number(c005,''99999999999999999999999999999999999999D99999999999999999999'',''NLS_NUMERIC_CHARACTERS=''''.,''''''),0))<0.01 then ''<span class="p34-status-badge p34-badge--balanced">Balanced</span>'' else ''<span class="p34-status-badge p3'
||'4-badge--variance">Variance</span>'' end status',
' from apex_collections where collection_name=''P34_GL_AR_RECON'' and :P34_REPORT_READY=''Y'''))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P34_REPORT_READY'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>12
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'GL AR Reconciliation'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(993705178578422817)
,p_no_data_found_message=>'No receivable control accounts were returned for this snapshot.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>true
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_internal_uid=>934160000000686645
,p_ai_report_hint=>'AR-driven GL/AR reconciliation for the selected snapshot. Only full account combinations with a non-zero AR open accounted balance are included. GL_PERIOD_NET equals GL_PERIOD_RECEIVABLES_ACTIVITY plus GL_PERIOD_REVALUATION_ACTIVITY plus GL_PERIOD_NO'
||'N_RECEIVABLES_ACTIVITY. GL_ENDING_BALANCE equals GL_BEGINNING_BALANCE plus GL_PERIOD_NET. VARIANCE_AMOUNT equals AR_OPEN_ACCOUNTED_AMOUNT minus GL_ENDING_BALANCE; absolute variance below 0.01 is Balanced. AR_NOT_TRANSFERRED_AMOUNT is cumulative AR su'
||'bledger accounting not yet transferred to GL through the as-of date and is diagnostic only; do not subtract it from variance. Null GL balance is not zero. Rank issues by absolute variance and display the full RECEIVABLE_ACCOUNT rather than CCID.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578421986)
,p_db_column_name=>'AR_LOADED_AT'
,p_display_order=>140
,p_column_identifier=>'J'
,p_column_label=>'AR Snapshot Generated'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Timestamp when the selected local AR snapshot was generated.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578421991)
,p_db_column_name=>'AR_NOT_TRANSFERRED_AMOUNT'
,p_display_order=>130
,p_column_identifier=>'O'
,p_column_label=>'AR Not Transferred'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Cumulative AR subledger accounting with application ID 222 that was not transferred to GL through the snapshot as-of date. Diagnostic timing item only; it is not part of the variance formula.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578421980)
,p_db_column_name=>'AR_OPEN_ACCOUNTED_AMOUNT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'AR Open Accounted'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Open AR snapshot balance for this full account combination in ledger functional currency.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578421981)
,p_db_column_name=>'GL_BEGINNING_BALANCE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'GL Beginning Balance'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'GL beginning balance for this full account combination and period, debit-positive as returned by the package.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578421983)
,p_db_column_name=>'GL_ENDING_BALANCE'
,p_display_order=>90
,p_column_identifier=>'G'
,p_column_label=>'GL Ending Balance'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'GL ending balance for this full account combination and period. Null means no matching GL balance was returned.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578421982)
,p_db_column_name=>'GL_PERIOD_NET'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'GL Period Net'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden validation total. Equals Period Receivables Activity plus Period Revaluation plus Period Non-Receivables, using debit-positive signs.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578421990)
,p_db_column_name=>'GL_PERIOD_NON_RECEIVABLES_ACTIVITY'
,p_display_order=>80
,p_column_identifier=>'N'
,p_column_label=>'Period Non-Receivables'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Posted actual GL activity from all journal sources other than Receivables and Revaluation for this account and selected period, in ledger currency with debit-positive signs.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578421988)
,p_db_column_name=>'GL_PERIOD_RECEIVABLES_ACTIVITY'
,p_display_order=>60
,p_column_identifier=>'L'
,p_column_label=>'Period Receivables Activity'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Posted actual GL activity from journal source Receivables for this account and selected period, in ledger currency with debit-positive signs.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578421989)
,p_db_column_name=>'GL_PERIOD_REVALUATION_ACTIVITY'
,p_display_order=>70
,p_column_identifier=>'M'
,p_column_label=>'Period Revaluation'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Posted actual GL activity from journal source Revaluation for this account and selected period, in ledger currency with debit-positive signs.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578421987)
,p_db_column_name=>'GL_RETRIEVED_AT'
,p_display_order=>150
,p_column_identifier=>'K'
,p_column_label=>'GL Retrieved'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Timestamp when Page 34 retrieved the live GL balance.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578421979)
,p_db_column_name=>'NATURAL_ACCOUNT'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Natural Account'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Natural-account segment of the receivable account combination.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578421978)
,p_db_column_name=>'RECEIVABLE_ACCOUNT'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Receivable Account'
,p_column_link=>'javascript:p34Controller.drill(#RECEIVABLE_CCID#,''#RECEIVABLE_ACCOUNT!JS#'');'
,p_column_linktext=>'#RECEIVABLE_ACCOUNT#'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Full concatenated receivable account combination. This is the business-facing reconciliation key.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578421977)
,p_db_column_name=>'RECEIVABLE_CCID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Receivable CCID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical GL code combination identifier. Prefer the full receivable account combination.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578421985)
,p_db_column_name=>'STATUS'
,p_display_order=>110
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Balanced when absolute variance is below 0.01; otherwise Variance.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578421984)
,p_db_column_name=>'VARIANCE_AMOUNT'
,p_display_order=>100
,p_column_identifier=>'H'
,p_column_label=>'Variance'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'AR_OPEN_ACCOUNTED_AMOUNT minus GL_ENDING_BALANCE. Preserve the signed value and rank issues by absolute variance.'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(993705178578422818)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'RECEIVABLE_ACCOUNT:NATURAL_ACCOUNT:AR_OPEN_ACCOUNTED_AMOUNT:GL_BEGINNING_BALANCE:GL_PERIOD_RECEIVABLES_ACTIVITY:GL_PERIOD_REVALUATION_ACTIVITY:GL_PERIOD_NON_RECEIVABLES_ACTIVITY:GL_ENDING_BALANCE:VARIANCE_AMOUNT:STATUS:AR_NOT_TRANSFERRED_AMOUNT:AR_LO'
||'ADED_AT:GL_RETRIEVED_AT'
,p_sort_column_1=>'VARIANCE_AMOUNT'
,p_sort_direction_1=>'DESC'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(317992543199425948)
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
 p_id=>wwv_flow_imp.id(993705178578421778)
,p_plug_name=>'Reconciliation Context'
,p_static_id=>'recon-context'
,p_title=>'GL/AR Reconciliation Context'
,p_region_name=>'recon-context'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>'<p>Reconcile the selected local AR snapshot to TMS GL receivable control-account balances for the same ledger, company, and period.</p>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(993705178578421783)
,p_plug_name=>'Receivable Account Detail'
,p_static_id=>'recon-customer-detail'
,p_title=>'AR Open Items for Selected Receivable Account'
,p_region_name=>'recon-customer-detail'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>60
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select customer_name,customer_number,class_code,trx_number,trx_date,due_date,days_past_due,bucket_heading,currency_code,entered_balance_asof,accounted_balance_asof,',
' case control_account_flag when ''Y'' then ''<span class="p34-control-ok">Control Account</span>'' else ''<span class="p34-control-exception">Outside Control Account</span>'' end control_account_status,',
' payment_schedule_id,customer_id,customer_trx_id,receivable_ccid,org_id,bucket_sequence,control_account_flag',
' from xxme_ar_recon_v2_snap where :P34_REPORT_READY=''Y'' and db_link_name=:P34_DB_LINK and ledger_id=to_number(:P34_LEDGER_ID) and company_segment=:P34_COMPANY and period_name=:P34_PERIOD_NAME and aging_bucket_id=to_number(:P34_AGING_BUCKET_ID) and re'
||'ceivable_ccid=to_number(:P34_SELECTED_CCID)'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P34_REPORT_READY,P34_DB_LINK,P34_LEDGER_ID,P34_COMPANY,P34_PERIOD_NAME,P34_AGING_BUCKET_ID,P34_SELECTED_CCID'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P34_CONTEXT_READY'
,p_plug_display_when_cond2=>'Y'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>14
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'AR Open Items by Receivable Account'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(993705178578422827)
,p_no_data_found_message=>'No AR open items were found for the selected receivable account.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>true
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_internal_uid=>934160000000686655
,p_ai_report_hint=>'AR transaction detail supporting the full receivable account selected on Page 34. ACCOUNTED_BALANCE_ASOF is ledger-functional and reconciles to the account-level AR amount. ENTERED_BALANCE_ASOF is transaction-currency and must remain grouped by CURRE'
||'NCY_CODE.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422032)
,p_db_column_name=>'ACCOUNTED_BALANCE_ASOF'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Accounted Open Balance'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Remaining open balance in ledger functional currency. Use this measure for totals, customer aging, and GL reconciliation.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422029)
,p_db_column_name=>'BUCKET_HEADING'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Aging Bucket'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Configured TMS aging bucket heading as of the snapshot date.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422039)
,p_db_column_name=>'BUCKET_SEQUENCE'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Bucket Sequence'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden configured aging bucket sequence used for drilldown.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422024)
,p_db_column_name=>'CLASS_CODE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Transaction Class'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Receivables transaction class, such as invoice, debit memo, chargeback, or credit memo.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422040)
,p_db_column_name=>'CONTROL_ACCOUNT_FLAG'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Control Flag'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical Y/N control-account indicator.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422033)
,p_db_column_name=>'CONTROL_ACCOUNT_STATUS'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Control Account Status'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Shows whether the receivable account natural account is in the finance-approved control-account configuration.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422030)
,p_db_column_name=>'CURRENCY_CODE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Transaction Currency'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Transaction currency for ENTERED_BALANCE_ASOF. Never total entered balances across different currency codes.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422035)
,p_db_column_name=>'CUSTOMER_ID'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Customer ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical customer account identifier. Prefer customer name and customer number.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422022)
,p_db_column_name=>'CUSTOMER_NAME'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Customer Name'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Customer business name. Use contains-style searching and group by this value for customer comparisons.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422023)
,p_db_column_name=>'CUSTOMER_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Customer Number'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Customer account number. Use exact matching and pair it with CUSTOMER_NAME in business-facing answers.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422036)
,p_db_column_name=>'CUSTOMER_TRX_ID'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Customer Transaction ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical Receivables transaction identifier. Prefer transaction number.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422028)
,p_db_column_name=>'DAYS_PAST_DUE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Days Past Due'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G990'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Calendar days past due as of the snapshot date. Positive values are overdue; zero or negative values are current.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422027)
,p_db_column_name=>'DUE_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Due Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Scheduled due date used by the configured aging bucket calculation.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422031)
,p_db_column_name=>'ENTERED_BALANCE_ASOF'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Entered Open Balance'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Remaining open balance in transaction currency. Group by CURRENCY_CODE before totaling.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422038)
,p_db_column_name=>'ORG_ID'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Organization ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical Receivables organization identifier. It is not the company code.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422034)
,p_db_column_name=>'PAYMENT_SCHEDULE_ID'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Payment Schedule ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical AR payment schedule identifier.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422037)
,p_db_column_name=>'RECEIVABLE_CCID'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Receivable CCID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical GL code combination identifier. Prefer the full receivable account combination.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422026)
,p_db_column_name=>'TRX_DATE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Transaction Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Receivables transaction date. This is not the due date or snapshot date.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422025)
,p_db_column_name=>'TRX_NUMBER'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Transaction Number'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Receivables transaction number. Treat as text and prefer it over hidden transaction IDs.'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(993705178578422828)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CUSTOMER_NAME:CUSTOMER_NUMBER:CLASS_CODE:TRX_NUMBER:TRX_DATE:DUE_DATE:DAYS_PAST_DUE:BUCKET_HEADING:CURRENCY_CODE:ENTERED_BALANCE_ASOF:ACCOUNTED_BALANCE_ASOF:CONTROL_ACCOUNT_STATUS'
,p_sort_column_1=>'DUE_DATE'
,p_sort_direction_1=>'ASC'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(993705178578421782)
,p_plug_name=>'Reconciliation Detail Context'
,p_static_id=>'recon-detail-context'
,p_title=>'Selected Receivable Account'
,p_region_name=>'recon-detail-context'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>50
,p_location=>null
,p_plug_source=>'<div class="p34-detail-banner"><span id="p34-detail-selection"></span></div>'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P34_CONTEXT_READY'
,p_plug_display_when_cond2=>'Y'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(993705178578421780)
,p_plug_name=>'Reconciliation KPIs'
,p_static_id=>'recon-kpis'
,p_title=>'Reconciliation Summary'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>30
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="p34-kpis">',
'<div class="p34-kpi"><div class="p34-kpi-label">Receivable Accounts</div><div id="p34-kpi-accounts" class="p34-kpi-value"></div></div>',
'<div class="p34-kpi"><div class="p34-kpi-label">AR Open Accounted</div><div id="p34-kpi-ar" class="p34-kpi-value"></div></div>',
'<div class="p34-kpi"><div class="p34-kpi-label">GL Ending Balance</div><div id="p34-kpi-gl" class="p34-kpi-value"></div></div>',
'<div class="p34-kpi"><div class="p34-kpi-label">Net Variance</div><div id="p34-kpi-variance" class="p34-kpi-value"></div></div>',
'<div class="p34-kpi"><div class="p34-kpi-label">Accounts With Variance</div><div id="p34-kpi-out" class="p34-kpi-value"></div></div>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(993705178578421779)
,p_plug_name=>'Reconciliation Status'
,p_static_id=>'recon-status'
,p_title=>'Reconciliation Status'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>20
,p_location=>null
,p_plug_source=>'<div id="p34-status-panel" class="p34-status p34-status--info" role="status" aria-live="polite" hidden><h3 id="p34-status-title"></h3><p id="p34-status-body"></p><div id="p34-status-timing"></div></div>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(993705178578421880)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(993705178578421778)
,p_button_name=>'ANALYZE_RECON_AI'
,p_static_id=>'analyze-ar-reconciliation-with-ai'
,p_button_static_id=>'analyze-ar-reconciliation-with-ai'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Analyze Reconciliation with AI'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-sparkles'
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(993705178578421878)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(993705178578421778)
,p_button_name=>'CLOSE_PAGE'
,p_static_id=>'close-page'
,p_button_static_id=>'close-page'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Close'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-times'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(993705178578421879)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(993705178578421782)
,p_button_name=>'CLOSE_DETAIL'
,p_static_id=>'close-recon-detail'
,p_button_static_id=>'close-recon-detail'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Close Detail'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-times'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(993705178578421877)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(993705178578421778)
,p_button_name=>'RUN_RECON'
,p_static_id=>'run-gl-ar-recon'
,p_button_static_id=>'run-gl-ar-recon'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Run GL/AR Reconciliation'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-play'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(993705178578422142)
,p_name=>'P34_AGING_BUCKET_ID'
,p_item_sequence=>100
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(993705178578422124)
,p_name=>'P34_AS_OF_DATE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(993705178578421778)
,p_prompt=>'As-of Date'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(993705178578422146)
,p_name=>'P34_BACK_URL'
,p_item_sequence=>104
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(993705178578422126)
,p_name=>'P34_COMPANY'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(993705178578421778)
,p_prompt=>'Company Code'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(993705178578422143)
,p_name=>'P34_CONTEXT_READY'
,p_item_sequence=>101
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(993705178578422122)
,p_name=>'P34_DB_LINK'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(993705178578421778)
,p_item_default=>'ADG'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(993705178578422128)
,p_name=>'P34_GENERATED_BY'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(993705178578421778)
,p_prompt=>'Generated By'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_colspan=>2
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(993705178578422127)
,p_name=>'P34_GENERATED_ON'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(993705178578421778)
,p_prompt=>'Snapshot Generated On'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(993705178578422125)
,p_name=>'P34_LEDGER_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(993705178578421778)
,p_prompt=>'Ledger ID'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(993705178578422123)
,p_name=>'P34_PERIOD_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(993705178578421778)
,p_prompt=>'Receivables Period'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(993705178578422144)
,p_name=>'P34_REPORT_READY'
,p_item_sequence=>102
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(993705178578422129)
,p_name=>'P34_ROW_COUNT'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(993705178578421778)
,p_prompt=>'Rows'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_colspan=>1
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(993705178578422145)
,p_name=>'P34_SELECTED_CCID'
,p_item_sequence=>103
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(993705178578422181)
,p_name=>'Close Detail'
,p_static_id=>'close-detail'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(993705178578421879)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(993705178578422182)
,p_event_id=>wwv_flow_imp.id(993705178578422181)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p34Controller.closeDetail();')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(993705178578422179)
,p_name=>'Close Page'
,p_static_id=>'close-page'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(993705178578421878)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(993705178578422180)
,p_event_id=>wwv_flow_imp.id(993705178578422179)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p34Controller.closePage();')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(993705178578422183)
,p_name=>'Open Reconciliation AI Analyst'
,p_static_id=>'open-reconciliation-ai-analyst'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(993705178578421880)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(993705178578422184)
,p_event_id=>wwv_flow_imp.id(993705178578422183)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p34Controller.openAi();')).to_clob
,p_build_option_id=>wwv_flow_imp.id(1017112543199391948)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(993705178578422177)
,p_name=>'Run Reconciliation'
,p_static_id=>'run-reconciliation'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(993705178578421877)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(993705178578422178)
,p_event_id=>wwv_flow_imp.id(993705178578422177)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p34Controller.run();')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(993705178578422279)
,p_process_sequence=>30
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'P34_GET_AI_URL'
,p_static_id=>'p34-get-ai-url'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare l_count number; l_asof date; l_url varchar2(32767);',
'begin',
' if :P34_REPORT_READY<>''Y'' or :P34_DB_LINK not in (''ADG'') or not regexp_like(:P34_PERIOD_NAME,''^[A-Z0-9 _./-]{1,30}$'') or not regexp_like(:P34_LEDGER_ID,''^[0-9]{1,18}$'') or not regexp_like(:P34_COMPANY,''^[A-Z0-9_.-]{1,25}$'') or not regexp_like(:P34_A'
||'GING_BUCKET_ID,''^[0-9]{1,18}$'') then raise_application_error(-20339,''Invalid GL/AR reconciliation context.''); end if;',
' if not apex_collection.collection_exists(''P34_GL_AR_RECON'') then raise_application_error(-20340,''Run GL/AR reconciliation before opening the AI Analyst.''); end if;',
' select count(*) into l_count from apex_collections where collection_name=''P34_GL_AR_RECON'';',
' if l_count=0 then raise_application_error(-20341,''The GL/AR reconciliation has no rows to analyze.''); end if;',
' select max(as_of_date) into l_asof from xxme_ar_recon_v2_snap where db_link_name=:P34_DB_LINK and ledger_id=to_number(:P34_LEDGER_ID) and company_segment=:P34_COMPANY and period_name=:P34_PERIOD_NAME and aging_bucket_id=to_number(:P34_AGING_BUCKET_I'
||'D);',
' l_url:=apex_page.get_url(p_page=>50,p_clear_cache=>''50'',p_items=>''P50_DB_LINK,P50_PERIOD_NAME,P50_AR_SCOPE_AS_OF_DATE,P50_AR_LEDGER_ID,P50_AR_COMPANY,P50_AR_AGING_BUCKET_ID,P50_AR_SOURCE_PAGE,P50_AR_RECON_READY'',p_values=>:P34_DB_LINK||'',''||:P34_PER'
||'IOD_NAME||'',''||to_char(l_asof,''YYYY-MM-DD'')||'',''||:P34_LEDGER_ID||'',''||:P34_COMPANY||'',''||:P34_AGING_BUCKET_ID||'',34,Y'');',
' apex_json.open_object;apex_json.write(''ok'',true);apex_json.write(''url'',l_url);apex_json.close_object;',
'exception when others then apex_json.open_object;apex_json.write(''ok'',false);apex_json.write(''message'',case when sqlcode between -20999 and -20000 then substr(sqlerrm,12) else ''Unable to prepare the AI Analyst URL.'' end);apex_json.close_object;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
,p_internal_uid=>934160000000686107
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(993705178578422278)
,p_process_sequence=>20
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'P34_RUN_RECON'
,p_static_id=>'p34-run-recon'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare l_count number:=0;l_out number:=0;l_ar number:=0;l_gl number:=0;l_var number:=0;',
'begin',
' apex_region.reset(p_page_id=>34,p_static_id=>''gl-ar-recon-report'');',
' if apex_collection.collection_exists(''P34_GL_AR_RECON'') then apex_collection.truncate_collection(''P34_GL_AR_RECON'');else apex_collection.create_collection(''P34_GL_AR_RECON'');end if;',
' for r in(select * from table(xxme_ar_recon_v2_pkg.get_gl_reconciliation(:P34_DB_LINK,to_number(:P34_LEDGER_ID),:P34_COMPANY,:P34_PERIOD_NAME,to_number(:P34_AGING_BUCKET_ID))) where abs(nvl(ar_open_accounted_amount,0))>=0.005) loop',
'  apex_collection.add_member(p_collection_name=>''P34_GL_AR_RECON'',p_c001=>r.account_segments,p_c002=>r.natural_account,p_c003=>to_char(r.ar_loaded_at,''DD-MON-YYYY HH24:MI:SS''),p_c004=>to_char(r.gl_retrieved_at,''DD-MON-YYYY HH24:MI:SS''),p_c005=>to_cha'
||'r(r.variance_amount,''TM9'',''NLS_NUMERIC_CHARACTERS=''''.,''''''),p_c006=>to_char(r.ar_not_transferred_amount,''TM9'',''NLS_NUMERIC_CHARACTERS=''''.,''''''),p_c007=>to_char(r.gl_period_receivables_activity,''TM9'',''NLS_NUMERIC_CHARACTERS=''''.,''''''),p_c008=>to_char(r.gl'
||'_period_revaluation_activity,''TM9'',''NLS_NUMERIC_CHARACTERS=''''.,''''''),p_c009=>to_char(r.gl_period_non_receivables_activity,''TM9'',''NLS_NUMERIC_CHARACTERS=''''.,''''''),p_n001=>r.receivable_ccid,p_n002=>r.ar_open_accounted_amount,p_n003=>r.gl_beginning_balanc'
||'e,p_n004=>r.gl_period_net,p_n005=>r.gl_ending_balance);',
'  l_count:=l_count+1;l_ar:=l_ar+nvl(r.ar_open_accounted_amount,0);l_gl:=l_gl+nvl(r.gl_ending_balance,0);l_var:=l_var+nvl(r.variance_amount,0);if abs(nvl(r.variance_amount,0))>=0.01 then l_out:=l_out+1;end if;',
' end loop;',
' apex_json.open_object;apex_json.write(''ok'',true);apex_json.open_object(''summary'');apex_json.write(''account_count'',to_char(l_count,''FM999G999G990''));apex_json.write(''out_of_balance'',to_char(l_out,''FM999G999G990''));apex_json.write(''ar_total'',to_char(l'
||'_ar,''FM999G999G999G990D00''));apex_json.write(''gl_total'',to_char(l_gl,''FM999G999G999G990D00''));apex_json.write(''variance_total'',to_char(l_var,''FM999G999G999G990D00''));apex_json.close_object;apex_json.close_object;',
'exception when others then if apex_collection.collection_exists(''P34_GL_AR_RECON'') then apex_collection.delete_collection(''P34_GL_AR_RECON'');end if;apex_json.open_object;apex_json.write(''ok'',false);apex_json.write(''message'',case when sqlcode between '
||'-20999 and -20000 then substr(sqlerrm,12) else ''Unable to run GL/AR reconciliation. Check the APEX debug log.'' end);apex_json.close_object;end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>934160000000686106
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(993705178578422277)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Validate Reconciliation Context'
,p_static_id=>'validate-reconciliation-context'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare l_count number;l_by varchar2(128);l_on timestamp;l_asof date;',
'begin :P34_BACK_URL:=apex_page.get_url(p_page=>32,p_clear_cache=>''32'');:P34_CONTEXT_READY:=''N'';:P34_REPORT_READY:=''N'';',
' if apex_collection.collection_exists(''P34_GL_AR_RECON'') then apex_collection.delete_collection(''P34_GL_AR_RECON'');end if;',
' :P34_DB_LINK:=upper(trim(:P34_DB_LINK));:P34_PERIOD_NAME:=upper(trim(:P34_PERIOD_NAME));:P34_COMPANY:=upper(trim(:P34_COMPANY));',
' if :P34_DB_LINK not in (''ADG'') or not regexp_like(:P34_PERIOD_NAME,''^[A-Z0-9 _./-]{1,30}$'') or not regexp_like(:P34_LEDGER_ID,''^[0-9]{1,18}$'') or not regexp_like(:P34_COMPANY,''^[A-Z0-9_.-]{1,25}$'') or not regexp_like(:P34_AGING_BUCKET_ID,''^[0-9]{1,1'
||'8}$'') then apex_error.add_error(p_message=>''Select an available AR snapshot on Page 32 before opening reconciliation.'',p_display_location=>apex_error.c_inline_in_notification);return;end if;',
' select count(*),max(loaded_by),max(loaded_at),max(as_of_date) into l_count,l_by,l_on,l_asof from xxme_ar_recon_v2_snap where db_link_name=:P34_DB_LINK and ledger_id=to_number(:P34_LEDGER_ID) and company_segment=:P34_COMPANY and period_name=:P34_PERI'
||'OD_NAME and aging_bucket_id=to_number(:P34_AGING_BUCKET_ID);',
' :P34_AS_OF_DATE:=to_char(l_asof,''DD-MON-YYYY'');:P34_GENERATED_ON:=to_char(l_on,''DD-MON-YYYY HH24:MI:SS'');:P34_GENERATED_BY:=l_by;:P34_ROW_COUNT:=to_char(l_count,''FM999G999G999G990'');',
' if l_count>0 then :P34_CONTEXT_READY:=''Y'';else apex_error.add_error(p_message=>''The selected AR snapshot is no longer available. Return to Page 32 and run it again.'',p_display_location=>apex_error.c_inline_in_notification);end if;',
'exception when others then :P34_CONTEXT_READY:=''N'';apex_error.add_error(p_message=>''Unable to validate the AR snapshot context. Check the APEX debug log.'',p_display_location=>apex_error.c_inline_in_notification);end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>934160000000686105
);
wwv_flow_imp.component_end;
end;
/
