prompt --application/pages/page_00033
begin
--   Manifest
--     PAGE: 00033
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
 p_id=>33
,p_name=>'AR Aging Analysis'
,p_alias=>'AR-AGING-ANALYSIS'
,p_step_title=>'AR Aging Analysis'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var p33Controller=(function($){',
'  ''use strict'';',
'  function byId(id){return $(''#''+id);}',
'  function region(id){try{return apex.region(id);}catch(ignore){return null;}}',
'  function drill(customerId,bucketSequence,bucketLabel,customerName,customerNumber){',
'    apex.item(''P33_SELECTED_CUSTOMER_ID'').setValue(customerId?String(customerId):'''',null,true);',
'    apex.item(''P33_SELECTED_BUCKET_SEQUENCE'').setValue(bucketSequence?String(bucketSequence):'''',null,true);',
'    var customer=customerName?(customerName+(customerNumber?'' (''+customerNumber+'')'':'''')):''All customers'';',
'    var bucket=bucketLabel||(bucketSequence?apex.item(''P33_BUCKET_''+bucketSequence+''_LABEL'').getValue():''All aging buckets'');',
unistr('    byId(''p33-detail-selection'').text(customer+'' \2022 ''+bucket);'),
'    byId(''customer-detail-context'').show();byId(''customer-aging-detail'').show();',
'    var r=region(''customer-aging-detail'');if(r&&typeof r.refresh===''function''){r.refresh();}else{byId(''customer-aging-detail'').trigger(''apexrefresh'');}',
'    $(''html, body'').animate({scrollTop:byId(''customer-detail-context'').offset().top-12},200);',
'  }',
'  function closeDetail(){apex.item(''P33_SELECTED_CUSTOMER_ID'').setValue('''',null,true);apex.item(''P33_SELECTED_BUCKET_SEQUENCE'').setValue('''',null,true);byId(''customer-detail-context'').hide();byId(''customer-aging-detail'').hide();}',
'  function openAi(){if(apex.item(''P33_SNAPSHOT_READY'').getValue()!==''Y'')return;var target=''ar_aging_ai_''+Date.now(),child=window.open('''',target);if(!child){apex.message.showErrors([{type:''error'',location:''page'',message:''Allow pop-ups to open the AI A'
||'nalyst in a new tab.'',unsafe:false}]);return;}child.document.write(''<title>Opening AI Analyst</title><p style="font-family:sans-serif;padding:1rem">Opening AI Analyst...</p>'');apex.server.process(''P33_GET_AI_URL'',{pageItems:''#P33_SNAPSHOT_READY,#P33_'
||'DB_LINK,#P33_PERIOD_NAME,#P33_LEDGER_ID,#P33_COMPANY,#P33_AGING_BUCKET_ID''},{dataType:''json''}).then(function(result){if(!result||result.ok!==true||!result.url){child.close();apex.message.showErrors([{type:''error'',location:''page'',message:(result&&resu'
||'lt.message)||''Unable to open the AI Analyst.'',unsafe:false}]);return;}child.location.replace(result.url);},function(error){child.close();apex.message.showErrors([{type:''error'',location:''page'',message:(error&&error.message)||''Unable to open the AI Ana'
||'lyst.'',unsafe:false}]);});}',
'  function closePage(){window.close();setTimeout(function(){if(!window.closed){apex.navigation.redirect(apex.item(''P33_BACK_URL'').getValue());}},250);}',
'  $(function(){closeDetail();$(document).on(''click.p33'',''.p33-aging-drill'',function(){drill(null,$(this).attr(''data-seq''),$(this).attr(''data-label''));});});',
'  return{drill:drill,closeDetail:closeDetail,openAi:openAi,closePage:closePage};',
'})(apex.jQuery);'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#customer-detail-context,#customer-aging-detail{display:none;}',
'.p33-context-note{margin:.25rem 0 0;color:var(--ut-component-text-muted-color,#5f6368);}',
'.p33-kpis{display:grid;grid-template-columns:repeat(5,minmax(0,1fr));gap:1rem;padding:.25rem;}',
'.p33-kpi{border:1px solid var(--ut-component-border-color,#d9dce1);border-radius:.5rem;padding:1rem;background:var(--ut-component-background-color,#fff);}',
'.p33-kpi-label{font-size:.76rem;text-transform:uppercase;letter-spacing:.04em;color:#5f6368;}',
'.p33-kpi-value{font-size:1.42rem;font-weight:700;font-variant-numeric:tabular-nums;margin-top:.3rem;}',
'.p33-kpi--alert{border-left:4px solid #b91c1c;background:#fef2f2;}',
'.p33-aging-row{display:grid;grid-template-columns:12rem 1fr 11rem;gap:.75rem;align-items:center;min-width:38rem;}',
'.p33-aging-track{height:1.1rem;background:#eef0f3;border-radius:.25rem;overflow:hidden;}',
'.p33-aging-bar{display:block;height:100%;min-width:2px;background:#2563eb;border-radius:.25rem;}',
'.p33-aging-amount{text-align:right;font-variant-numeric:tabular-nums;font-weight:600;}',
'.p33-aging-drill{display:block;width:100%;border:0;background:transparent;padding:.45rem .25rem;cursor:pointer;text-align:inherit;border-radius:.3rem;}',
'.p33-aging-drill:hover,.p33-aging-drill:focus{background:#eff6ff;outline:2px solid transparent;}',
'.p33-detail-banner{display:flex;align-items:center;justify-content:space-between;gap:1rem;padding:.35rem 0;}',
'#p33-detail-selection{font-weight:600;}',
'.p33-control-exception{display:inline-block;padding:.15rem .45rem;border-radius:1rem;background:#fee2e2;color:#991b1b;font-weight:700;}',
'.p33-control-ok{display:inline-block;padding:.15rem .45rem;border-radius:1rem;background:#dcfce7;color:#166534;}',
'@media(max-width:1000px){.p33-kpis{grid-template-columns:repeat(2,minmax(0,1fr));}}'))
,p_step_template=>4075783602716660119
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(9156329399484443)
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(992705178578421778)
,p_plug_name=>'Snapshot Context'
,p_static_id=>'ar-aging-context'
,p_title=>'Snapshot Context'
,p_region_name=>'ar-aging-context'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>'<p class="p33-context-note">All summaries use Accounted Open Balance in ledger functional currency. Entered-currency balances are shown only in transaction detail and are never totaled across currencies.</p>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(992705178578421780)
,p_name=>'Aging Distribution'
,p_static_id=>'ar-aging-distribution'
,p_title=>'Aging Distribution'
,p_template=>4075786578761660127
,p_display_sequence=>30
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--noBorders'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'with a as (',
' select bucket_sequence,bucket_heading,sum(nvl(accounted_balance_asof,0)) amount',
' from xxme_ar_recon_v2_snap',
' where :P33_SNAPSHOT_READY=''Y'' and db_link_name=:P33_DB_LINK and ledger_id=to_number(:P33_LEDGER_ID)',
'   and company_segment=:P33_COMPANY and period_name=:P33_PERIOD_NAME and aging_bucket_id=to_number(:P33_AGING_BUCKET_ID)',
' group by bucket_sequence,bucket_heading',
'), b as (select a.*,max(abs(amount)) over() max_amount from a)',
'select ''<button type="button" class="p33-aging-drill" data-seq="''||bucket_sequence||''" data-label="''||apex_escape.html_attribute(bucket_heading)||''"><span class="p33-aging-row"><span>''||apex_escape.html(bucket_heading)||''</span>''||',
' ''<span class="p33-aging-track"><span class="p33-aging-bar" style="width:''||to_char(case when max_amount=0 then 0 else round(abs(amount)/max_amount*100,2) end,''FM990D00'',''NLS_NUMERIC_CHARACTERS=''''.,'''''')||''%"></span></span>''||',
' ''<span class="p33-aging-amount">''||to_char(amount,''FM999G999G999G990D00'')||''</span></span></button>'' aging_bar',
' from b order by bucket_sequence'))
,p_display_when_condition=>'P33_SNAPSHOT_READY'
,p_display_when_cond2=>'Y'
,p_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P33_SNAPSHOT_READY,P33_DB_LINK,P33_LEDGER_ID,P33_COMPANY,P33_PERIOD_NAME,P33_AGING_BUCKET_ID'
,p_lazy_loading=>false
,p_query_row_template=>2542081983073888486
,p_query_num_rows=>10
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'SHOW_ALL'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(992705178578421798)
,p_query_column_id=>1
,p_column_alias=>'AGING_BAR'
,p_column_display_sequence=>10
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(992705178578421779)
,p_name=>'Snapshot KPIs'
,p_static_id=>'ar-aging-kpis'
,p_title=>'Snapshot Summary'
,p_template=>4075786578761660127
,p_display_sequence=>20
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#:t-Report--noBorders'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'with k as (',
'  select count(distinct customer_id) customer_count, count(*) open_item_count,',
'         nvl(sum(accounted_balance_asof),0) open_amount,',
'         nvl(sum(case when days_past_due > 0 then accounted_balance_asof else 0 end),0) past_due_amount,',
'         nvl(sum(case when control_account_flag = ''N'' then accounted_balance_asof else 0 end),0) exception_amount',
'    from xxme_ar_recon_v2_snap',
'   where :P33_SNAPSHOT_READY = ''Y'' and db_link_name=:P33_DB_LINK and ledger_id=to_number(:P33_LEDGER_ID)',
'     and company_segment=:P33_COMPANY and period_name=:P33_PERIOD_NAME and aging_bucket_id=to_number(:P33_AGING_BUCKET_ID)',
')',
'select ''<div class="p33-kpis">''||',
' ''<div class="p33-kpi"><div class="p33-kpi-label">Customers</div><div class="p33-kpi-value">''||to_char(customer_count,''FM999G999G990'')||''</div></div>''||',
' ''<div class="p33-kpi"><div class="p33-kpi-label">Open Items</div><div class="p33-kpi-value">''||to_char(open_item_count,''FM999G999G990'')||''</div></div>''||',
' ''<div class="p33-kpi"><div class="p33-kpi-label">AR Open Accounted</div><div class="p33-kpi-value">''||to_char(open_amount,''FM999G999G999G990D00'')||''</div></div>''||',
' ''<div class="p33-kpi"><div class="p33-kpi-label">Past Due Accounted</div><div class="p33-kpi-value">''||to_char(past_due_amount,''FM999G999G999G990D00'')||''</div></div>''||',
' ''<div class="p33-kpi p33-kpi--alert"><div class="p33-kpi-label">Outside Control Accounts</div><div class="p33-kpi-value">''||to_char(exception_amount,''FM999G999G999G990D00'')||''</div></div></div>'' kpi_html from k'))
,p_display_when_condition=>'P33_SNAPSHOT_READY'
,p_display_when_cond2=>'Y'
,p_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P33_SNAPSHOT_READY,P33_DB_LINK,P33_LEDGER_ID,P33_COMPANY,P33_PERIOD_NAME,P33_AGING_BUCKET_ID'
,p_lazy_loading=>false
,p_query_row_template=>2542081983073888486
,p_query_num_rows=>1
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'SHOW_ALL'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(992705178578421797)
,p_query_column_id=>1
,p_column_alias=>'KPI_HTML'
,p_column_display_sequence=>10
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(992705178578421783)
,p_plug_name=>'Customer Aging Detail'
,p_static_id=>'customer-aging-detail'
,p_title=>'Customer Aging Detail'
,p_region_name=>'customer-aging-detail'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>60
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select class_code,trx_number,trx_date,due_date,days_past_due,bucket_heading,currency_code,',
' entered_balance_asof,accounted_balance_asof,account_segments,',
' case control_account_flag when ''Y'' then ''<span class="p33-control-ok">Control Account</span>'' else ''<span class="p33-control-exception">Outside Control Account</span>'' end control_account_status,',
' customer_number,customer_name,payment_schedule_id,customer_trx_id,receivable_ccid,org_id,bucket_sequence,control_account_flag',
' from table(xxme_ar_recon_v2_pkg.get_aging_detail(',
'   :P33_DB_LINK,to_number(:P33_LEDGER_ID),:P33_COMPANY,:P33_PERIOD_NAME,to_number(:P33_AGING_BUCKET_ID),',
'   case when :P33_SELECTED_CUSTOMER_ID is null then null else to_number(:P33_SELECTED_CUSTOMER_ID) end,',
'   case when :P33_SELECTED_BUCKET_SEQUENCE is null then null else to_number(:P33_SELECTED_BUCKET_SEQUENCE) end,null))',
' where :P33_SNAPSHOT_READY=''Y'''))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P33_SNAPSHOT_READY,P33_DB_LINK,P33_LEDGER_ID,P33_COMPANY,P33_PERIOD_NAME,P33_AGING_BUCKET_ID,P33_SELECTED_CUSTOMER_ID,P33_SELECTED_BUCKET_SEQUENCE'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P33_SNAPSHOT_READY'
,p_plug_display_when_cond2=>'Y'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>14
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Customer Aging Detail'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(992705178578422827)
,p_no_data_found_message=>'No open items match the selected customer and aging bucket.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>true
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_internal_uid=>933160000000686655
,p_ai_report_hint=>'Transaction-level AR aging drilldown for the customer and/or bucket selected on Page 33. ACCOUNTED_BALANCE_ASOF is ledger-functional. ENTERED_BALANCE_ASOF is transaction-currency and must remain grouped by CURRENCY_CODE. Prefer customer and transacti'
||'on business identifiers over hidden IDs.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578422030)
,p_db_column_name=>'ACCOUNTED_BALANCE_ASOF'
,p_display_order=>90
,p_column_identifier=>'I'
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
 p_id=>wwv_flow_imp.id(992705178578422031)
,p_db_column_name=>'ACCOUNT_SEGMENTS'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Receivable Account'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Full concatenated receivable account combination. Prefer this business-facing value over RECEIVABLE_CCID.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578422027)
,p_db_column_name=>'BUCKET_HEADING'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Aging Bucket'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Configured TMS aging bucket heading as of the snapshot date.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578422039)
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
 p_id=>wwv_flow_imp.id(992705178578422022)
,p_db_column_name=>'CLASS_CODE'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Transaction Class'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Receivables transaction class, such as invoice, debit memo, chargeback, or credit memo.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578422040)
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
 p_id=>wwv_flow_imp.id(992705178578422032)
,p_db_column_name=>'CONTROL_ACCOUNT_STATUS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Control Account Status'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Shows whether the receivable account natural account is in the finance-approved control-account configuration.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578422028)
,p_db_column_name=>'CURRENCY_CODE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Transaction Currency'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Transaction currency for ENTERED_BALANCE_ASOF. Never total entered balances across different currency codes.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578422034)
,p_db_column_name=>'CUSTOMER_NAME'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Customer Name'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Customer business name. Use contains-style searching and group by this value for customer comparisons.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578422033)
,p_db_column_name=>'CUSTOMER_NUMBER'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Customer Number'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Customer account number. Use exact matching and pair it with CUSTOMER_NAME in business-facing answers.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578422036)
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
 p_id=>wwv_flow_imp.id(992705178578422026)
,p_db_column_name=>'DAYS_PAST_DUE'
,p_display_order=>50
,p_column_identifier=>'E'
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
 p_id=>wwv_flow_imp.id(992705178578422025)
,p_db_column_name=>'DUE_DATE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Due Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Scheduled due date used by the configured aging bucket calculation.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578422029)
,p_db_column_name=>'ENTERED_BALANCE_ASOF'
,p_display_order=>80
,p_column_identifier=>'H'
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
 p_id=>wwv_flow_imp.id(992705178578422038)
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
 p_id=>wwv_flow_imp.id(992705178578422035)
,p_db_column_name=>'PAYMENT_SCHEDULE_ID'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Payment Schedule ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical AR payment schedule identifier.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578422037)
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
 p_id=>wwv_flow_imp.id(992705178578422024)
,p_db_column_name=>'TRX_DATE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Transaction Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Receivables transaction date. This is not the due date or snapshot date.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578422023)
,p_db_column_name=>'TRX_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Transaction Number'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Receivables transaction number. Treat as text and prefer it over hidden transaction IDs.'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(992705178578422828)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CLASS_CODE:TRX_NUMBER:TRX_DATE:DUE_DATE:DAYS_PAST_DUE:BUCKET_HEADING:CURRENCY_CODE:ENTERED_BALANCE_ASOF:ACCOUNTED_BALANCE_ASOF:ACCOUNT_SEGMENTS:CONTROL_ACCOUNT_STATUS'
,p_sort_column_1=>'DUE_DATE'
,p_sort_direction_1=>'ASC'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(992705178578421781)
,p_plug_name=>'Customer Aging Summary'
,p_static_id=>'customer-aging-summary'
,p_title=>'Customer Aging Summary'
,p_region_name=>'customer-aging-summary'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>40
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select customer_id,max(customer_number) customer_number,max(customer_name) customer_name,',
' sum(case when bucket_sequence=1 then accounted_balance_asof else 0 end) bucket_1_amount,',
' sum(case when bucket_sequence=2 then accounted_balance_asof else 0 end) bucket_2_amount,',
' sum(case when bucket_sequence=3 then accounted_balance_asof else 0 end) bucket_3_amount,',
' sum(case when bucket_sequence=4 then accounted_balance_asof else 0 end) bucket_4_amount,',
' sum(case when bucket_sequence=5 then accounted_balance_asof else 0 end) bucket_5_amount,',
' sum(case when bucket_sequence=6 then accounted_balance_asof else 0 end) bucket_6_amount,',
' sum(case when bucket_sequence=7 then accounted_balance_asof else 0 end) bucket_7_amount,',
' sum(accounted_balance_asof) total_amount,',
' sum(case when control_account_flag=''N'' then accounted_balance_asof else 0 end) control_exception_amount,',
' count(*) schedule_count',
' from xxme_ar_recon_v2_snap',
' where :P33_SNAPSHOT_READY=''Y'' and db_link_name=:P33_DB_LINK and ledger_id=to_number(:P33_LEDGER_ID)',
'   and company_segment=:P33_COMPANY and period_name=:P33_PERIOD_NAME and aging_bucket_id=to_number(:P33_AGING_BUCKET_ID)',
' group by customer_id'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P33_SNAPSHOT_READY,P33_DB_LINK,P33_LEDGER_ID,P33_COMPANY,P33_PERIOD_NAME,P33_AGING_BUCKET_ID'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P33_SNAPSHOT_READY'
,p_plug_display_when_cond2=>'Y'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>14
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Customer Aging Summary'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(992705178578422817)
,p_no_data_found_message=>'No customers are available for the selected snapshot.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>true
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_internal_uid=>933160000000686645
,p_ai_report_hint=>'Customer aging summary for the selected local AR snapshot. Every bucket amount and TOTAL_AMOUNT uses ACCOUNTED_BALANCE_ASOF in ledger functional currency. The seven bucket labels come from the configured TMS aging bucket and may vary by configuration'
||'. CONTROL_EXCEPTION_AMOUNT is the accounted balance outside approved control accounts. Each row represents one customer.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578421980)
,p_db_column_name=>'BUCKET_1_AMOUNT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'&P33_BUCKET_1_LABEL.'
,p_column_link=>'javascript:p33Controller.drill(#CUSTOMER_ID#,''1'','''',''#CUSTOMER_NAME!JS#'',''#CUSTOMER_NUMBER!JS#'');'
,p_column_linktext=>'#BUCKET_1_AMOUNT#'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Accounted open balance for the first configured aging bucket, in ledger functional currency.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578421981)
,p_db_column_name=>'BUCKET_2_AMOUNT'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'&P33_BUCKET_2_LABEL.'
,p_column_link=>'javascript:p33Controller.drill(#CUSTOMER_ID#,''2'','''',''#CUSTOMER_NAME!JS#'',''#CUSTOMER_NUMBER!JS#'');'
,p_column_linktext=>'#BUCKET_2_AMOUNT#'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Accounted open balance for the second configured aging bucket, in ledger functional currency.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578421982)
,p_db_column_name=>'BUCKET_3_AMOUNT'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'&P33_BUCKET_3_LABEL.'
,p_column_link=>'javascript:p33Controller.drill(#CUSTOMER_ID#,''3'','''',''#CUSTOMER_NAME!JS#'',''#CUSTOMER_NUMBER!JS#'');'
,p_column_linktext=>'#BUCKET_3_AMOUNT#'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Accounted open balance for the third configured aging bucket, in ledger functional currency.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578421983)
,p_db_column_name=>'BUCKET_4_AMOUNT'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'&P33_BUCKET_4_LABEL.'
,p_column_link=>'javascript:p33Controller.drill(#CUSTOMER_ID#,''4'','''',''#CUSTOMER_NAME!JS#'',''#CUSTOMER_NUMBER!JS#'');'
,p_column_linktext=>'#BUCKET_4_AMOUNT#'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Accounted open balance for the fourth configured aging bucket, in ledger functional currency.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578421984)
,p_db_column_name=>'BUCKET_5_AMOUNT'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'&P33_BUCKET_5_LABEL.'
,p_column_link=>'javascript:p33Controller.drill(#CUSTOMER_ID#,''5'','''',''#CUSTOMER_NAME!JS#'',''#CUSTOMER_NUMBER!JS#'');'
,p_column_linktext=>'#BUCKET_5_AMOUNT#'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Accounted open balance for the fifth configured aging bucket, in ledger functional currency.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578421985)
,p_db_column_name=>'BUCKET_6_AMOUNT'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'&P33_BUCKET_6_LABEL.'
,p_column_link=>'javascript:p33Controller.drill(#CUSTOMER_ID#,''6'','''',''#CUSTOMER_NAME!JS#'',''#CUSTOMER_NUMBER!JS#'');'
,p_column_linktext=>'#BUCKET_6_AMOUNT#'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Accounted open balance for the sixth configured aging bucket, in ledger functional currency.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578421986)
,p_db_column_name=>'BUCKET_7_AMOUNT'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'&P33_BUCKET_7_LABEL.'
,p_column_link=>'javascript:p33Controller.drill(#CUSTOMER_ID#,''7'','''',''#CUSTOMER_NAME!JS#'',''#CUSTOMER_NUMBER!JS#'');'
,p_column_linktext=>'#BUCKET_7_AMOUNT#'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Accounted open balance for the seventh configured aging bucket, in ledger functional currency.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578421988)
,p_db_column_name=>'CONTROL_EXCEPTION_AMOUNT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Outside Control Accounts'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Accounted open balance posted outside the finance-approved receivable control accounts.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578421977)
,p_db_column_name=>'CUSTOMER_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Customer ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical customer account identifier. Prefer customer name and customer number.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578421978)
,p_db_column_name=>'CUSTOMER_NAME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Customer Name'
,p_column_link=>'javascript:p33Controller.drill(#CUSTOMER_ID#,'''',''All aging buckets'',''#CUSTOMER_NAME!JS#'',''#CUSTOMER_NUMBER!JS#'');'
,p_column_linktext=>'#CUSTOMER_NAME#'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Customer business name. Use contains-style searching and group by this value for customer comparisons.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578421979)
,p_db_column_name=>'CUSTOMER_NUMBER'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Customer Number'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Customer account number. Use exact matching and pair it with CUSTOMER_NAME in business-facing answers.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578421989)
,p_db_column_name=>'SCHEDULE_COUNT'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Open Items'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G990'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Count of open AR payment-schedule rows represented by the customer summary.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578421987)
,p_db_column_name=>'TOTAL_AMOUNT'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Total Accounted Open'
,p_column_link=>'javascript:p33Controller.drill(#CUSTOMER_ID#,'''',''All aging buckets'',''#CUSTOMER_NAME!JS#'',''#CUSTOMER_NUMBER!JS#'');'
,p_column_linktext=>'#TOTAL_AMOUNT#'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Total accounted open balance for the customer across all configured aging buckets, in ledger functional currency.'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(992705178578422818)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CUSTOMER_NAME:CUSTOMER_NUMBER:BUCKET_1_AMOUNT:BUCKET_2_AMOUNT:BUCKET_3_AMOUNT:BUCKET_4_AMOUNT:BUCKET_5_AMOUNT:BUCKET_6_AMOUNT:BUCKET_7_AMOUNT:TOTAL_AMOUNT:CONTROL_EXCEPTION_AMOUNT:SCHEDULE_COUNT'
,p_sort_column_1=>'TOTAL_AMOUNT'
,p_sort_direction_1=>'DESC'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(992705178578421782)
,p_plug_name=>'Customer Detail Context'
,p_static_id=>'customer-detail-context'
,p_title=>'Selected Customer / Aging Bucket'
,p_region_name=>'customer-detail-context'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>50
,p_location=>null
,p_plug_source=>'<div class="p33-detail-banner"><span id="p33-detail-selection"></span></div>'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P33_SNAPSHOT_READY'
,p_plug_display_when_cond2=>'Y'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(317992543199424948)
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
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(992705178578421879)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(992705178578421778)
,p_button_name=>'ANALYZE_AGING_AI'
,p_static_id=>'analyze-aging-with-ai'
,p_button_static_id=>'analyze-aging-with-ai'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Analyze Aging with AI'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-sparkles'
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(992705178578421878)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(992705178578421782)
,p_button_name=>'CLOSE_DETAIL'
,p_static_id=>'close-detail'
,p_button_static_id=>'close-detail'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Close Detail'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-times'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(992705178578421877)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(992705178578421778)
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
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(992705178578422142)
,p_name=>'P33_AGING_BUCKET_ID'
,p_item_sequence=>100
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(992705178578422124)
,p_name=>'P33_AS_OF_DATE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(992705178578421778)
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
 p_id=>wwv_flow_imp.id(992705178578422146)
,p_name=>'P33_BACK_URL'
,p_item_sequence=>104
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(992705178578422147)
,p_name=>'P33_BUCKET_1_LABEL'
,p_item_sequence=>105
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(992705178578422148)
,p_name=>'P33_BUCKET_2_LABEL'
,p_item_sequence=>106
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(992705178578422149)
,p_name=>'P33_BUCKET_3_LABEL'
,p_item_sequence=>107
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(992705178578422150)
,p_name=>'P33_BUCKET_4_LABEL'
,p_item_sequence=>108
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(992705178578422151)
,p_name=>'P33_BUCKET_5_LABEL'
,p_item_sequence=>109
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(992705178578422152)
,p_name=>'P33_BUCKET_6_LABEL'
,p_item_sequence=>110
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(992705178578422153)
,p_name=>'P33_BUCKET_7_LABEL'
,p_item_sequence=>111
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(992705178578422126)
,p_name=>'P33_COMPANY'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(992705178578421778)
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
 p_id=>wwv_flow_imp.id(992705178578422122)
,p_name=>'P33_DB_LINK'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(992705178578421778)
,p_item_default=>'ADG'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(992705178578422128)
,p_name=>'P33_GENERATED_BY'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(992705178578421778)
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
 p_id=>wwv_flow_imp.id(992705178578422127)
,p_name=>'P33_GENERATED_ON'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(992705178578421778)
,p_prompt=>'Generated On'
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
 p_id=>wwv_flow_imp.id(992705178578422125)
,p_name=>'P33_LEDGER_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(992705178578421778)
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
 p_id=>wwv_flow_imp.id(992705178578422123)
,p_name=>'P33_PERIOD_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(992705178578421778)
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
 p_id=>wwv_flow_imp.id(992705178578422129)
,p_name=>'P33_ROW_COUNT'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(992705178578421778)
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
 p_id=>wwv_flow_imp.id(992705178578422145)
,p_name=>'P33_SELECTED_BUCKET_SEQUENCE'
,p_item_sequence=>103
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(992705178578422144)
,p_name=>'P33_SELECTED_CUSTOMER_ID'
,p_item_sequence=>102
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(992705178578422143)
,p_name=>'P33_SNAPSHOT_READY'
,p_item_sequence=>101
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(992705178578422179)
,p_name=>'Close Detail'
,p_static_id=>'close-detail'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(992705178578421878)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(992705178578422180)
,p_event_id=>wwv_flow_imp.id(992705178578422179)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p33Controller.closeDetail();')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(992705178578422177)
,p_name=>'Close Page'
,p_static_id=>'close-page'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(992705178578421877)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(992705178578422178)
,p_event_id=>wwv_flow_imp.id(992705178578422177)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p33Controller.closePage();')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(992705178578422181)
,p_name=>'Open Aging AI Analyst'
,p_static_id=>'open-aging-ai-analyst'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(992705178578421879)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(992705178578422182)
,p_event_id=>wwv_flow_imp.id(992705178578422181)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p33Controller.openAi();')).to_clob
,p_build_option_id=>wwv_flow_imp.id(1017112543199391948)
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(992705178578422278)
,p_process_sequence=>20
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'P33_GET_AI_URL'
,p_static_id=>'p33-get-ai-url'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare l_count number; l_asof date; l_url varchar2(32767);',
'begin',
' if :P33_SNAPSHOT_READY<>''Y'' or :P33_DB_LINK not in (''ADG'') or not regexp_like(:P33_PERIOD_NAME,''^[A-Z0-9 _./-]{1,30}$'') or not regexp_like(:P33_LEDGER_ID,''^[0-9]{1,18}$'') or not regexp_like(:P33_COMPANY,''^[A-Z0-9_.-]{1,25}$'') or not regexp_like(:P33'
||'_AGING_BUCKET_ID,''^[0-9]{1,18}$'') then raise_application_error(-20337,''Invalid AR aging context.''); end if;',
' select count(*),max(as_of_date) into l_count,l_asof from xxme_ar_recon_v2_snap where db_link_name=:P33_DB_LINK and ledger_id=to_number(:P33_LEDGER_ID) and company_segment=:P33_COMPANY and period_name=:P33_PERIOD_NAME and aging_bucket_id=to_number(:P'
||'33_AGING_BUCKET_ID);',
' if l_count=0 then raise_application_error(-20338,''The selected AR snapshot is no longer available.''); end if;',
' l_url:=apex_page.get_url(p_page=>50,p_clear_cache=>''50'',p_items=>''P50_DB_LINK,P50_PERIOD_NAME,P50_AR_SCOPE_AS_OF_DATE,P50_AR_LEDGER_ID,P50_AR_COMPANY,P50_AR_AGING_BUCKET_ID,P50_AR_SOURCE_PAGE,P50_AR_RECON_READY'',p_values=>:P33_DB_LINK||'',''||:P33_PER'
||'IOD_NAME||'',''||to_char(l_asof,''YYYY-MM-DD'')||'',''||:P33_LEDGER_ID||'',''||:P33_COMPANY||'',''||:P33_AGING_BUCKET_ID||'',33,N'');',
' apex_json.open_object;apex_json.write(''ok'',true);apex_json.write(''url'',l_url);apex_json.close_object;',
'exception when others then apex_json.open_object;apex_json.write(''ok'',false);apex_json.write(''message'',case when sqlcode between -20999 and -20000 then substr(sqlerrm,12) else ''Unable to prepare the AI Analyst URL.'' end);apex_json.close_object;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
,p_internal_uid=>933160000000686106
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(992705178578422277)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Validate AR Snapshot Context'
,p_static_id=>'validate-ar-snapshot-context'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
' l_db varchar2(128):=upper(trim(:P33_DB_LINK)); l_period varchar2(30):=upper(trim(:P33_PERIOD_NAME));',
' l_ledger_text varchar2(30):=trim(:P33_LEDGER_ID); l_company varchar2(25):=upper(trim(:P33_COMPANY)); l_bucket_text varchar2(30):=trim(:P33_AGING_BUCKET_ID);',
' l_ledger number; l_bucket number; l_count number; l_by varchar2(128); l_on timestamp; l_asof date;',
' l_b1 varchar2(120);l_b2 varchar2(120);l_b3 varchar2(120);l_b4 varchar2(120);l_b5 varchar2(120);l_b6 varchar2(120);l_b7 varchar2(120);',
'begin',
' :P33_BACK_URL:=apex_page.get_url(p_page=>32,p_clear_cache=>''32''); :P33_SNAPSHOT_READY:=''N'';',
' if l_db not in (''ADG'') or l_period is null or not regexp_like(l_period,''^[A-Z0-9 _./-]{1,30}$'')',
'    or not regexp_like(l_ledger_text,''^[0-9]{1,18}$'') or l_company is null or not regexp_like(l_company,''^[A-Z0-9_.-]{1,25}$'')',
'    or not regexp_like(l_bucket_text,''^[0-9]{1,18}$'') then',
'   apex_error.add_error(p_message=>''Select an available AR snapshot on Page 32 before opening Aging Analysis.'',p_display_location=>apex_error.c_inline_in_notification); return; end if;',
' l_ledger:=to_number(l_ledger_text);l_bucket:=to_number(l_bucket_text);',
' select count(*),max(loaded_by),max(loaded_at),max(as_of_date),',
'  max(case when bucket_sequence=1 then bucket_heading end),max(case when bucket_sequence=2 then bucket_heading end),max(case when bucket_sequence=3 then bucket_heading end),',
'  max(case when bucket_sequence=4 then bucket_heading end),max(case when bucket_sequence=5 then bucket_heading end),max(case when bucket_sequence=6 then bucket_heading end),max(case when bucket_sequence=7 then bucket_heading end)',
' into l_count,l_by,l_on,l_asof,l_b1,l_b2,l_b3,l_b4,l_b5,l_b6,l_b7',
' from xxme_ar_recon_v2_snap where db_link_name=l_db and ledger_id=l_ledger and company_segment=l_company and period_name=l_period and aging_bucket_id=l_bucket;',
' :P33_DB_LINK:=l_db;:P33_PERIOD_NAME:=l_period;:P33_LEDGER_ID:=to_char(l_ledger);:P33_COMPANY:=l_company;:P33_AGING_BUCKET_ID:=to_char(l_bucket);',
' :P33_AS_OF_DATE:=to_char(l_asof,''DD-MON-YYYY'');:P33_GENERATED_ON:=to_char(l_on,''DD-MON-YYYY HH24:MI:SS'');:P33_GENERATED_BY:=l_by;:P33_ROW_COUNT:=to_char(l_count,''FM999G999G999G990'');',
' :P33_BUCKET_1_LABEL:=nvl(l_b1,''Bucket 1'');:P33_BUCKET_2_LABEL:=nvl(l_b2,''Bucket 2'');:P33_BUCKET_3_LABEL:=nvl(l_b3,''Bucket 3'');:P33_BUCKET_4_LABEL:=nvl(l_b4,''Bucket 4'');',
' :P33_BUCKET_5_LABEL:=nvl(l_b5,''Bucket 5'');:P33_BUCKET_6_LABEL:=nvl(l_b6,''Bucket 6'');:P33_BUCKET_7_LABEL:=nvl(l_b7,''Bucket 7'');',
' if l_count>0 then :P33_SNAPSHOT_READY:=''Y''; else apex_error.add_error(p_message=>''The selected AR snapshot is no longer available. Return to Page 32 and run it again.'',p_display_location=>apex_error.c_inline_in_notification); end if;',
'exception when others then :P33_SNAPSHOT_READY:=''N''; apex_error.add_error(p_message=>''Unable to validate the selected AR snapshot. Check the APEX debug log.'',p_display_location=>apex_error.c_inline_in_notification);',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>933160000000686105
);
wwv_flow_imp.component_end;
end;
/
