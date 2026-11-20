prompt --application/pages/page_00024
begin
--   Manifest
--     PAGE: 00024
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
 p_id=>24
,p_name=>'GL AP Reconciliation'
,p_alias=>'GL-AP-RECONCILIATION'
,p_step_title=>'GL/AP Reconciliation'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var p24Controller = (function ($) {',
'  ''use strict'';',
'  var busy=false, spinner=null, timerId=null, startedAt=null;',
'  function byId(id){return $(''#''+id);}',
'  function region(id){try{return apex.region(id);}catch(ignore){return null;}}',
'  function seconds(){return ((performance.now()-startedAt)/1000).toFixed(1)+'' s'';}',
'  function stop(){if(timerId){clearInterval(timerId);timerId=null;}if(spinner){spinner.remove();spinner=null;}}',
'  function setBusy(on){busy=on;byId(''run-gl-ap-recon'').prop(''disabled'',on);}',
'  function status(kind,title,body,timing){',
'    byId(''recon-status'').show();',
'    byId(''p24-status-panel'').removeAttr(''hidden'').removeClass(''p24-status--info p24-status--success p24-status--error'').addClass(''p24-status--''+kind);',
'    byId(''p24-status-title'').text(title);byId(''p24-status-body'').text(body||'''');byId(''p24-status-timing'').text(timing||'''');',
'  }',
'  function refresh(id){var r=region(id);if(r&&typeof r.refresh===''function''){r.refresh();}else{byId(id).trigger(''apexrefresh'');}}',
'  function highlightVarianceRows(){',
'    byId(''gl-ap-recon-report'').find(''.a-IRR-table tbody tr'').each(function(){',
'      $(this).toggleClass(''p24-variance-row'',$(this).find(''.p24-badge--variance'').length>0);',
'    });',
'  }',
'  function hideResults(){',
'    apex.item(''P24_REPORT_READY'').setValue(''N'',null,true);',
'    byId(''recon-kpis'').hide();byId(''gl-ap-recon-report'').hide();byId(''analyze-reconciliation-with-ai'').hide();closeDetail();',
'  }',
'  function populateKpis(s){',
'    byId(''p24-kpi-accounts'').text(s.account_count);',
'    byId(''p24-kpi-ap'').text(s.ap_total);',
'    byId(''p24-kpi-gl'').text(s.gl_total);',
'    byId(''p24-kpi-variance'').text(s.variance_total);',
'    byId(''p24-kpi-out'').text(s.out_of_balance);',
'  }',
'  function run(){',
'    if(busy||apex.item(''P24_CONTEXT_READY'').getValue()!==''Y''){return;}',
'    hideResults();setBusy(true);startedAt=performance.now();',
'    status(''info'',''Running GL/AP reconciliation'',''Retrieving GL balances and activity from TMS. This normally takes approximately 20-30 seconds.'',''Elapsed: 0.0 s'');',
'    timerId=setInterval(function(){byId(''p24-status-timing'').text(''Elapsed: ''+seconds());},250);',
'    try{spinner=apex.util.showSpinner(byId(''recon-status''));}catch(ignore){spinner=null;}',
'    apex.server.process(''P24_RUN_RECON'',{pageItems:''#P24_DB_LINK,#P24_AS_OF_DATE,#P24_LEDGER_ID,#P24_COMPANY''},{dataType:''json''}).then(function(result){',
'      stop();setBusy(false);',
'      if(!result||result.ok!==true){status(''error'',''Reconciliation failed'',(result&&result.message)||''Unable to run reconciliation.'');return;}',
'      apex.item(''P24_REPORT_READY'').setValue(''Y'',null,true);populateKpis(result.summary);',
'      byId(''recon-kpis'').show();byId(''gl-ap-recon-report'').show();byId(''analyze-reconciliation-with-ai'').show();refresh(''gl-ap-recon-report'');',
'      status(''success'',''Reconciliation complete'',result.summary.account_count+'' liability accounts evaluated.'',''Total: ''+seconds());',
'    },function(error){stop();setBusy(false);status(''error'',''Reconciliation failed'',(error&&error.message)||''Unable to run reconciliation.'');});',
'  }',
'  function drill(ccid){',
'    var account='''';',
'    byId(''gl-ap-recon-report'').find(''a'').each(function(){',
'      var href=this.getAttribute(''href'')||'''';',
'      if(href.indexOf(''drill(''+ccid+'')'')>=0){account=$.trim($(this).text());return false;}',
'    });',
'    apex.item(''P24_SELECTED_CCID'').setValue(String(ccid),null,true);',
'    byId(''p24-detail-selection'').text(account||''Selected liability account'');',
'    byId(''recon-detail-context'').show();byId(''recon-invoice-detail'').show();refresh(''recon-invoice-detail'');',
'    $(''html, body'').animate({scrollTop:byId(''recon-detail-context'').offset().top-12},200);',
'  }',
'  function closeDetail(){apex.item(''P24_SELECTED_CCID'').setValue('''',null,true);byId(''recon-detail-context'').hide();byId(''recon-invoice-detail'').hide();}',
'  function openAi(){',
'    if(busy||apex.item(''P24_REPORT_READY'').getValue()!==''Y''){return;}',
'    var target=''ap_recon_ai_''+Date.now(),child=window.open('''',target);',
'    if(!child){apex.message.showErrors([{type:''error'',location:''page'',message:''Allow pop-ups to open the AI Analyst in a new tab.'',unsafe:false}]);return;}',
unistr('    child.document.write(''<title>Opening AI Analyst</title><p style="font-family:sans-serif;padding:1rem">Opening AI Analyst\2026</p>'');'),
'    apex.server.process(''P24_GET_AI_URL'',{pageItems:''#P24_DB_LINK,#P24_AS_OF_DATE,#P24_LEDGER_ID,#P24_COMPANY,#P24_REPORT_READY''},{dataType:''json''}).then(function(result){',
'      if(!result||result.ok!==true||!result.url){child.close();apex.message.showErrors([{type:''error'',location:''page'',message:(result&&result.message)||''Unable to open the AI Analyst.'',unsafe:false}]);return;}',
'      child.location.replace(result.url);',
'    },function(error){child.close();apex.message.showErrors([{type:''error'',location:''page'',message:(error&&error.message)||''Unable to open the AI Analyst.'',unsafe:false}]);});',
'  }',
'  function closePage(){window.close();setTimeout(function(){if(!window.closed){apex.navigation.redirect(apex.item(''P24_BACK_URL'').getValue());}},250);}',
'  $(function(){',
'    hideResults();byId(''recon-status'').hide();byId(''p24-status-panel'').attr(''hidden'',''hidden'');',
'    $(document).on(''apexafterrefresh.p24'',''#gl-ap-recon-report'',highlightVarianceRows);',
'  });',
'  return {run:run,drill:drill,openAi:openAi,closeDetail:closeDetail,closePage:closePage};',
'})(apex.jQuery);'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#recon-kpis,#gl-ap-recon-report,#recon-detail-context,#recon-invoice-detail{display:none;}',
'#recon-status{position:relative;min-height:4rem;}',
'.p24-status{border-left:4px solid #2563eb;border-radius:.25rem;padding:.8rem 1rem;background:#eff6ff;}',
'.p24-status--success{border-left-color:#15803d;background:#f0fdf4;}',
'.p24-status--error{border-left-color:#b91c1c;background:#fef2f2;}',
'#p24-status-title{font-size:1rem;font-weight:700;margin:0 0 .25rem;}',
'#p24-status-body{margin:0;}#p24-status-timing{font-variant-numeric:tabular-nums;font-weight:600;margin-top:.35rem;}',
'.p24-kpis{display:grid;grid-template-columns:repeat(5,minmax(0,1fr));gap:1rem;padding:.25rem;}',
'.p24-kpi{border:1px solid var(--ut-component-border-color,#d9dce1);border-radius:.5rem;padding:1rem;background:var(--ut-component-background-color,#fff);}',
'.p24-kpi-label{font-size:.75rem;text-transform:uppercase;letter-spacing:.04em;color:#5f6368;}',
'.p24-kpi-value{font-size:1.35rem;font-weight:700;font-variant-numeric:tabular-nums;margin-top:.3rem;}',
'.p24-detail-banner{font-weight:600;padding:.35rem 0;}',
'.p24-status-badge{display:inline-block;border-radius:999px;padding:.15rem .55rem;font-weight:700;}',
'.p24-badge--balanced{background:#ecfdf3;color:#166534;}',
'.p24-badge--variance{background:#fee2e2;color:#991b1b;}',
'.p24-variance-row>td{background:#fff7ed!important;}',
'@media(max-width:900px){.p24-kpis{grid-template-columns:repeat(2,minmax(0,1fr));}}'))
,p_step_template=>4075783602716660119
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(9156329399484443)
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(984078933012277685)
,p_plug_name=>'GL AP Reconciliation Report'
,p_static_id=>'gl-ap-recon-report'
,p_title=>'GL/AP Reconciliation by Liability Account'
,p_region_name=>'gl-ap-recon-report'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>40
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select n001 gl_liab_ccid, c001 gl_liability_code, n002 ap_open_accounted_amount,',
'       c002 gl_period_name, n003 gl_closing_balance,',
'       to_number(c004,''99999999999999999999999999999999999999D99999999999999999999'',''NLS_NUMERIC_CHARACTERS=''''.,'''''') gl_period_payables_activity,',
'       to_number(c005,''99999999999999999999999999999999999999D99999999999999999999'',''NLS_NUMERIC_CHARACTERS=''''.,'''''') gl_period_revaluation_activity,',
'       to_number(c006,''99999999999999999999999999999999999999D99999999999999999999'',''NLS_NUMERIC_CHARACTERS=''''.,'''''') gl_period_non_payables_activity,',
'       n004 variance_amount, n005 ap_not_transferred_amount,',
'       to_number(c007,''99999999999999999999999999999999999999D99999999999999999999'',''NLS_NUMERIC_CHARACTERS=''''.,'''''') gl_ytd_payables_activity,',
'       to_number(c008,''99999999999999999999999999999999999999D99999999999999999999'',''NLS_NUMERIC_CHARACTERS=''''.,'''''') gl_ytd_revaluation_activity,',
'       to_number(c009,''99999999999999999999999999999999999999D99999999999999999999'',''NLS_NUMERIC_CHARACTERS=''''.,'''''') gl_ytd_non_payables_activity,',
'       case when abs(nvl(n004,0)) < 0.01',
'            then ''<span class="p24-status-badge p24-badge--balanced">Balanced</span>''',
'            else ''<span class="p24-status-badge p24-badge--variance">Variance</span>'' end status',
'  from apex_collections',
' where collection_name = ''P24_GL_AP_RECON''',
'   and :P24_REPORT_READY = ''Y'''))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P24_REPORT_READY'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'GL AP Reconciliation'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(984078933012277721)
,p_no_data_found_message=>'No liability accounts were returned for this snapshot.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>true
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_internal_uid=>897156623912685640
,p_ai_report_hint=>wwv_flow_string.join(wwv_flow_t_varchar2(
'GL/AP reconciliation for the selected snapshot, one row per full GL liability account. AP and GL balances are presented credit-positive in ledger functional currency.',
'VARIANCE_AMOUNT equals AP_OPEN_ACCOUNTED_AMOUNT minus GL_CLOSING_BALANCE. STATUS is Balanced when absolute variance is below 0.01; otherwise it is Variance. Highlight and prioritize non-zero variance rows.',
'Period activity columns describe only the resolved GL period. YTD activity columns are cumulative through that period. Do not mix period and YTD values. A null GL closing balance means no matching GL balance was returned and must not be silently trea'
||'ted as zero.',
'Prefer GL_LIABILITY_CODE over hidden GL_LIAB_CCID.'))
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277788)
,p_db_column_name=>'AP_NOT_TRANSFERRED_AMOUNT'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'AP Not Transferred'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'AP accounted amount associated with entries not transferred to GL for this liability account, in ledger functional currency.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277783)
,p_db_column_name=>'AP_OPEN_ACCOUNTED_AMOUNT'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'AP Open Balance'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'AP open trial-balance amount for this liability account in ledger functional currency, presented credit-positive.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277785)
,p_db_column_name=>'GL_CLOSING_BALANCE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'GL Closing Balance'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'GL closing balance for the liability account and resolved period in ledger functional currency, presented credit-positive. Null means no matching GL balance was returned; do not replace null with zero.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277782)
,p_db_column_name=>'GL_LIABILITY_CODE'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'GL Liability Account'
,p_column_link=>'javascript:p24Controller.drill(#GL_LIAB_CCID#);'
,p_column_linktext=>'#GL_LIABILITY_CODE#'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Full concatenated GL liability account combination. Use for display, filters, grouping, and account comparisons.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277781)
,p_db_column_name=>'GL_LIAB_CCID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'GL Liability CCID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical GL code combination ID used for drilldown. Prefer GL_LIABILITY_CODE in all business-facing output.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277784)
,p_db_column_name=>'GL_PERIOD_NAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'GL Period'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Oracle GL accounting period resolved from the reconciliation as-of date.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277791)
,p_db_column_name=>'GL_PERIOD_NON_PAYABLES_ACTIVITY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Period Non-Payables'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Net GL activity from sources other than Payables and revaluation for only the resolved accounting period, presented credit-positive.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277789)
,p_db_column_name=>'GL_PERIOD_PAYABLES_ACTIVITY'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Period Payables Activity'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Net GL Payables-source activity for only the resolved accounting period, presented credit-positive.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277790)
,p_db_column_name=>'GL_PERIOD_REVALUATION_ACTIVITY'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Period Revaluation'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Net GL revaluation activity for only the resolved accounting period, presented credit-positive.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277794)
,p_db_column_name=>'GL_YTD_NON_PAYABLES_ACTIVITY'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'YTD Non-Payables'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Cumulative GL activity from sources other than Payables and revaluation from fiscal-year start through the resolved period, presented credit-positive.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277792)
,p_db_column_name=>'GL_YTD_PAYABLES_ACTIVITY'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'YTD Payables Activity'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Cumulative GL Payables-source activity from fiscal-year start through the resolved period, presented credit-positive.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277793)
,p_db_column_name=>'GL_YTD_REVALUATION_ACTIVITY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'YTD Revaluation'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Cumulative GL revaluation activity from fiscal-year start through the resolved period, presented credit-positive.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277787)
,p_db_column_name=>'STATUS'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Reconciliation classification: Balanced when absolute variance is below 0.01, otherwise Variance. The displayed value contains harmless badge HTML.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277786)
,p_db_column_name=>'VARIANCE_AMOUNT'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Variance'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'AP_OPEN_ACCOUNTED_AMOUNT minus GL_CLOSING_BALANCE. Rank reconciliation issues by absolute variance, preserving the signed value.'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(984078933012277722)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'GL_LIABILITY_CODE:AP_OPEN_ACCOUNTED_AMOUNT:GL_PERIOD_NAME:GL_CLOSING_BALANCE:VARIANCE_AMOUNT:STATUS:AP_NOT_TRANSFERRED_AMOUNT:GL_PERIOD_PAYABLES_ACTIVITY:GL_PERIOD_REVALUATION_ACTIVITY:GL_PERIOD_NON_PAYABLES_ACTIVITY:GL_YTD_PAYABLES_ACTIVITY:GL_YTD_R'
||'EVALUATION_ACTIVITY:GL_YTD_NON_PAYABLES_ACTIVITY'
,p_sort_column_1=>'VARIANCE_AMOUNT'
,p_sort_direction_1=>'DESC'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(317992543199415948)
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
 p_id=>wwv_flow_imp.id(984078933012277682)
,p_plug_name=>'Reconciliation Context'
,p_static_id=>'recon-context'
,p_title=>'GL/AP Reconciliation Context'
,p_region_name=>'recon-context'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>'<p>Reconcile the selected local AP snapshot to TMS GL liability balances as of the same date.</p>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(984078933012277686)
,p_plug_name=>'Reconciliation Detail Context'
,p_static_id=>'recon-detail-context'
,p_title=>'Selected Liability Account'
,p_region_name=>'recon-detail-context'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>50
,p_location=>null
,p_plug_source=>'<div id="p24-detail-selection" class="p24-detail-banner"></div>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(984078933012277687)
,p_plug_name=>'Reconciliation Invoice Detail'
,p_static_id=>'recon-invoice-detail'
,p_title=>'AP Snapshot Invoices for Liability Account'
,p_region_name=>'recon-invoice-detail'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>60
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select invoice_num, invoice_date, supplier_name, supplier_number, min_due_date, max_due_date,',
'       invoice_amount, acct_invoice_amount, open_accounted_amount, invoice_id',
'  from xx_ap_trial_balance_snap',
' where :P24_REPORT_READY = ''Y''',
'   and db_link = :P24_DB_LINK and as_of_date = to_date(:P24_AS_OF_DATE,''YYYY-MM-DD'')',
'   and ledger_id = to_number(:P24_LEDGER_ID) and company_segment = :P24_COMPANY',
'   and gl_liab_ccid = to_number(:P24_SELECTED_CCID)'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P24_REPORT_READY,P24_DB_LINK,P24_AS_OF_DATE,P24_LEDGER_ID,P24_COMPANY,P24_SELECTED_CCID'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'AP Snapshot Invoice Detail'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(984078933012277731)
,p_no_data_found_message=>'No AP snapshot invoices were found for this liability account.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>true
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_internal_uid=>897156623912685650
,p_ai_report_hint=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Invoice-detail rows from the selected local AP snapshot for the GL liability account chosen in the reconciliation report.',
'OPEN_ACCOUNTED_AMOUNT is the remaining balance in ledger functional currency. INVOICE_AMOUNT is the original entered-currency value and ACCT_INVOICE_AMOUNT is the original ledger-currency value; do not describe original amounts as outstanding.',
'The full account is intentionally shown in the parent reconciliation region rather than repeated in this detail report. Prefer invoice and supplier business identifiers over hidden technical IDs.'))
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277808)
,p_db_column_name=>'ACCT_INVOICE_AMOUNT'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Accounted Invoice Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Original invoice value accounted in ledger functional currency. It is not the remaining open balance.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277807)
,p_db_column_name=>'INVOICE_AMOUNT'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Original Invoice Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Original invoice value in invoice currency, including any portion subsequently paid. It is not the remaining open balance.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277802)
,p_db_column_name=>'INVOICE_DATE'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Invoice Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Date printed on the supplier invoice; this is not a due date or snapshot date.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277811)
,p_db_column_name=>'INVOICE_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Invoice ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical AP invoice identifier. Prefer INVOICE_NUM in business-facing output.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277801)
,p_db_column_name=>'INVOICE_NUM'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Invoice Number'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Supplier invoice number. Treat as text for exact or contains searches.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277806)
,p_db_column_name=>'MAX_DUE_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Latest Due Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Latest scheduled payment due date represented by this invoice.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277805)
,p_db_column_name=>'MIN_DUE_DATE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Earliest Due Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Earliest scheduled payment due date represented by this invoice.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277809)
,p_db_column_name=>'OPEN_ACCOUNTED_AMOUNT'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Open Accounted Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Remaining open AP balance at the snapshot date in ledger functional currency, credit-positive.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277803)
,p_db_column_name=>'SUPPLIER_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Supplier Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Supplier business name. Use contains-style searching and group by this value for supplier comparisons.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277804)
,p_db_column_name=>'SUPPLIER_NUMBER'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Supplier Number'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Supplier account number. Use exact matching and do not confuse it with supplier name.'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(984078933012277732)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'INVOICE_NUM:INVOICE_DATE:SUPPLIER_NAME:SUPPLIER_NUMBER:MIN_DUE_DATE:MAX_DUE_DATE:INVOICE_AMOUNT:ACCT_INVOICE_AMOUNT:OPEN_ACCOUNTED_AMOUNT'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(984078933012277684)
,p_plug_name=>'Reconciliation KPIs'
,p_static_id=>'recon-kpis'
,p_title=>'Reconciliation Summary'
,p_region_name=>'recon-kpis'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>30
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="p24-kpis">',
'<div class="p24-kpi"><div class="p24-kpi-label">Liability Accounts</div><div id="p24-kpi-accounts" class="p24-kpi-value"></div></div>',
'<div class="p24-kpi"><div class="p24-kpi-label">AP Open Balance</div><div id="p24-kpi-ap" class="p24-kpi-value"></div></div>',
'<div class="p24-kpi"><div class="p24-kpi-label">GL Closing Balance</div><div id="p24-kpi-gl" class="p24-kpi-value"></div></div>',
'<div class="p24-kpi"><div class="p24-kpi-label">Net Variance</div><div id="p24-kpi-variance" class="p24-kpi-value"></div></div>',
'<div class="p24-kpi"><div class="p24-kpi-label">Accounts With Variance</div><div id="p24-kpi-out" class="p24-kpi-value"></div></div>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(984078933012277683)
,p_plug_name=>'Reconciliation Status'
,p_static_id=>'recon-status'
,p_title=>'Reconciliation Status'
,p_region_name=>'recon-status'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>20
,p_location=>null
,p_plug_source=>'<div id="p24-status-panel" class="p24-status p24-status--info" role="status" aria-live="polite" hidden><h3 id="p24-status-title"></h3><p id="p24-status-body"></p><div id="p24-status-timing"></div></div>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(984078933012277884)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(984078933012277682)
,p_button_name=>'ANALYZE_RECON_WITH_AI'
,p_static_id=>'analyze-reconciliation-with-ai'
,p_button_static_id=>'analyze-reconciliation-with-ai'
,p_show_as_disabled=>false
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Analyze Reconciliation with AI'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-sparkles'
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(984078933012277882)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(984078933012277682)
,p_button_name=>'CLOSE_PAGE'
,p_static_id=>'close-page'
,p_button_static_id=>'close-page'
,p_show_as_disabled=>false
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Close'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-times'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(984078933012277883)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(984078933012277686)
,p_button_name=>'CLOSE_DETAIL'
,p_static_id=>'close-recon-detail'
,p_button_static_id=>'close-recon-detail'
,p_show_as_disabled=>false
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Close Detail'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-times'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(984078933012277881)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(984078933012277682)
,p_button_name=>'RUN_RECON'
,p_static_id=>'run-gl-ap-recon'
,p_button_static_id=>'run-gl-ap-recon'
,p_show_as_disabled=>false
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Run GL/AP Reconciliation'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-play'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(984078933012277982)
,p_name=>'P24_AS_OF_DATE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(984078933012277682)
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
 p_id=>wwv_flow_imp.id(984078933012277989)
,p_name=>'P24_BACK_URL'
,p_item_sequence=>130
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(984078933012277984)
,p_name=>'P24_COMPANY'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(984078933012277682)
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
 p_id=>wwv_flow_imp.id(984078933012277986)
,p_name=>'P24_CONTEXT_READY'
,p_item_sequence=>100
,p_item_default=>'N'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(984078933012277981)
,p_name=>'P24_DB_LINK'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(984078933012277682)
,p_item_default=>'ADG'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(984078933012277985)
,p_name=>'P24_GENERATED_ON'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(984078933012277682)
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
 p_id=>wwv_flow_imp.id(984078933012277983)
,p_name=>'P24_LEDGER_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(984078933012277682)
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1017112567199391948)
,p_name=>'P24_LEDGER_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(984078933012277682)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select case to_char(:P24_LEDGER_ID)',
'         when ''1003'' then ''TEREX US''',
'         when ''5001'' then ''TEREX UK 120''',
'         when ''10001'' then ''TEREX CH''',
'         else ''Unknown Ledger''',
'       end from dual'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Ledger'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'N',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(984078933012277987)
,p_name=>'P24_REPORT_READY'
,p_item_sequence=>110
,p_item_default=>'N'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(984078933012277988)
,p_name=>'P24_SELECTED_CCID'
,p_item_sequence=>120
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(984078933012278087)
,p_name=>'Analyze Reconciliation with AI'
,p_static_id=>'analyze-reconciliation-with-ai'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(984078933012277884)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(984078933012278088)
,p_event_id=>wwv_flow_imp.id(984078933012278087)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p24Controller.openAi();')).to_clob
,p_build_option_id=>wwv_flow_imp.id(1017112543199391948)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(984078933012278085)
,p_name=>'Close Detail'
,p_static_id=>'close-detail'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(984078933012277883)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(984078933012278086)
,p_event_id=>wwv_flow_imp.id(984078933012278085)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p24Controller.closeDetail();')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(984078933012278083)
,p_name=>'Close Page'
,p_static_id=>'close-page'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(984078933012277882)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(984078933012278084)
,p_event_id=>wwv_flow_imp.id(984078933012278083)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p24Controller.closePage();')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(984078933012278081)
,p_name=>'Run Reconciliation'
,p_static_id=>'run-reconciliation'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(984078933012277881)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(984078933012278082)
,p_event_id=>wwv_flow_imp.id(984078933012278081)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p24Controller.run();')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(984078933012278183)
,p_process_sequence=>30
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'P24_GET_AI_URL'
,p_static_id=>'p24-get-ai-url'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare l_date date; l_count number; l_url varchar2(32767);',
'begin',
'  if :P24_REPORT_READY <> ''Y'' or :P24_DB_LINK not in (''ADG'')',
'     or not regexp_like(:P24_AS_OF_DATE,''^[0-9]{4}-[0-9]{2}-[0-9]{2}$'',''c'')',
'     or not regexp_like(:P24_LEDGER_ID,''^[0-9]{1,18}$'',''c'')',
'     or not regexp_like(:P24_COMPANY,''^[A-Z0-9_.-]{1,25}$'',''c'') then raise_application_error(-20251,''Run reconciliation before opening the AI Analyst.''); end if;',
'  select count(*) into l_count from apex_collections where collection_name=''P24_GL_AP_RECON'';',
'  if l_count=0 then raise_application_error(-20252,''No reconciliation results are available for AI analysis.''); end if;',
'  l_date:=to_date(:P24_AS_OF_DATE,''FXYYYY-MM-DD'');',
'  l_url:=apex_page.get_url(p_page=>50,p_clear_cache=>''50'',',
'    p_items=>''P50_DB_LINK,P50_PERIOD_NAME,P50_AP_SCOPE_AS_OF_DATE,P50_AP_LEDGER_ID,P50_AP_COMPANY,P50_AP_SOURCE_PAGE,P50_AP_RECON_READY'',',
'    p_values=>:P24_DB_LINK||'',''||upper(to_char(l_date,''MON-YYYY'',''NLS_DATE_LANGUAGE=English''))||'',''||:P24_AS_OF_DATE||'',''||:P24_LEDGER_ID||'',''||:P24_COMPANY||'',24,Y'');',
'  apex_json.open_object; apex_json.write(''ok'',true); apex_json.write(''url'',l_url); apex_json.close_object;',
'exception when others then apex_json.open_object; apex_json.write(''ok'',false); apex_json.write(''message'',case when sqlcode between -20999 and -20000 then substr(sqlerrm,12) else ''Unable to prepare the AI Analyst URL.'' end); apex_json.close_object;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
,p_internal_uid=>897156623912686002
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(984078933012278182)
,p_process_sequence=>20
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'P24_RUN_RECON'
,p_static_id=>'p24-run-recon'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_count number:=0; l_out number:=0; l_ap number:=0; l_gl number:=0; l_var number:=0;',
'begin',
'  if apex_collection.collection_exists(''P24_GL_AP_RECON'') then apex_collection.truncate_collection(''P24_GL_AP_RECON''); else apex_collection.create_collection(''P24_GL_AP_RECON''); end if;',
'  for r in (select * from table(xx_ap_trial_balance_pkg.get_ap_gl_reconciliation(',
'    to_number(:P24_LEDGER_ID),to_date(:P24_AS_OF_DATE,''YYYY-MM-DD''),:P24_COMPANY,:P24_DB_LINK,to_date(:P24_AS_OF_DATE,''YYYY-MM-DD'')))) loop',
'    apex_collection.add_member(p_collection_name=>''P24_GL_AP_RECON'',',
'      p_c001=>r.gl_liability_code,p_c002=>r.gl_period_name,p_c003=>r.gl_currency_code,',
'      p_c004=>to_char(r.gl_period_payables_activity,''TM9'',''NLS_NUMERIC_CHARACTERS=''''.,''''''),',
'      p_c005=>to_char(r.gl_period_revaluation_activity,''TM9'',''NLS_NUMERIC_CHARACTERS=''''.,''''''),',
'      p_c006=>to_char(r.gl_period_non_payables_activity,''TM9'',''NLS_NUMERIC_CHARACTERS=''''.,''''''),',
'      p_c007=>to_char(r.gl_ytd_payables_activity,''TM9'',''NLS_NUMERIC_CHARACTERS=''''.,''''''),',
'      p_c008=>to_char(r.gl_ytd_revaluation_activity,''TM9'',''NLS_NUMERIC_CHARACTERS=''''.,''''''),',
'      p_c009=>to_char(r.gl_ytd_non_payables_activity,''TM9'',''NLS_NUMERIC_CHARACTERS=''''.,''''''),',
'      p_n001=>r.gl_liab_ccid,p_n002=>r.ap_open_accounted_amount,p_n003=>r.gl_closing_balance,',
'      p_n004=>r.variance_amount,p_n005=>r.ap_not_transferred_amount);',
'    l_count:=l_count+1; l_ap:=l_ap+nvl(r.ap_open_accounted_amount,0); l_gl:=l_gl+nvl(r.gl_closing_balance,0); l_var:=l_var+nvl(r.variance_amount,0);',
'    if abs(nvl(r.variance_amount,0))>=0.01 then l_out:=l_out+1; end if;',
'  end loop;',
'  apex_json.open_object; apex_json.write(''ok'',true); apex_json.open_object(''summary'');',
'  apex_json.write(''account_count'',to_char(l_count,''FM999G999G990'')); apex_json.write(''out_of_balance'',to_char(l_out,''FM999G999G990''));',
'  apex_json.write(''ap_total'',to_char(l_ap,''FM999G999G999G990D00'')); apex_json.write(''gl_total'',to_char(l_gl,''FM999G999G999G990D00''));',
'  apex_json.write(''variance_total'',to_char(l_var,''FM999G999G999G990D00'')); apex_json.close_object; apex_json.close_object;',
'exception when others then',
'  if apex_collection.collection_exists(''P24_GL_AP_RECON'') then apex_collection.delete_collection(''P24_GL_AP_RECON''); end if;',
'  apex_json.open_object; apex_json.write(''ok'',false); apex_json.write(''message'',case when sqlcode between -20999 and -20000 then substr(sqlerrm,12) else ''Unable to run GL/AP reconciliation. Check the APEX debug log.'' end); apex_json.close_object;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>897156623912686001
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(984078933012278181)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Validate Reconciliation Context'
,p_static_id=>'validate-reconciliation-context'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare l_date date; l_count number; l_loaded_on timestamp;',
'begin',
'  :P24_BACK_URL:=apex_page.get_url(p_page=>22,p_clear_cache=>''22'');',
'  :P24_CONTEXT_READY:=''N''; :P24_REPORT_READY:=''N''; :P24_GENERATED_ON:=null;',
'  if apex_collection.collection_exists(''P24_GL_AP_RECON'') then apex_collection.delete_collection(''P24_GL_AP_RECON''); end if;',
'  :P24_DB_LINK:=upper(trim(:P24_DB_LINK)); :P24_COMPANY:=upper(trim(:P24_COMPANY));',
'  if :P24_DB_LINK not in (''ADG'')',
'     or not regexp_like(:P24_AS_OF_DATE,''^[0-9]{4}-[0-9]{2}-[0-9]{2}$'',''c'')',
'     or not regexp_like(:P24_LEDGER_ID,''^[0-9]{1,18}$'',''c'')',
'     or :P24_COMPANY is null or not regexp_like(:P24_COMPANY,''^[A-Z0-9_.-]{1,25}$'',''c'') then',
'    apex_error.add_error(p_message=>''Select a valid snapshot on Page 22 before opening reconciliation.'',p_display_location=>apex_error.c_inline_in_notification); return;',
'  end if;',
'  begin l_date:=to_date(:P24_AS_OF_DATE,''FXYYYY-MM-DD''); exception when others then apex_error.add_error(p_message=>''Select a valid snapshot date.'',p_display_location=>apex_error.c_inline_in_notification); return; end;',
'  select count(*),max(loaded_on) into l_count,l_loaded_on from xx_ap_trial_balance_snap',
'   where db_link=:P24_DB_LINK and as_of_date=l_date and ledger_id=to_number(:P24_LEDGER_ID) and company_segment=:P24_COMPANY;',
'  if l_count>0 then :P24_CONTEXT_READY:=''Y''; :P24_GENERATED_ON:=to_char(l_loaded_on,''DD-MON-YYYY HH24:MI:SS'');',
'  else apex_error.add_error(p_message=>''No snapshot is available for this combination. Return to Page 22 to generate it.'',p_display_location=>apex_error.c_inline_in_notification); end if;',
'exception when others then :P24_CONTEXT_READY:=''N''; apex_error.add_error(p_message=>''Unable to validate the snapshot context. Check the APEX debug log.'',p_display_location=>apex_error.c_inline_in_notification);',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>897156623912686000
);
wwv_flow_imp.component_end;
end;
/
