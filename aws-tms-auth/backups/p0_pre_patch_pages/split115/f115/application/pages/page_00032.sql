prompt --application/pages/page_00032
begin
--   Manifest
--     PAGE: 00032
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
 p_id=>32
,p_name=>'AR Open Balance Snapshot'
,p_alias=>'AR-OPEN-BALANCE-SNAPSHOT'
,p_step_title=>'AR Open Balance Snapshot'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* Page 32 AR open-balance snapshot workflow. */',
'var p32Controller = (function ($) {',
'  ''use strict'';',
'  var busy=false, spinner=null, timerId=null, startedAt=null, known=null;',
'  function byId(id){return $(''#''+id);}',
'  function reportElement(){return byId(''ar-open-balance-ir'');}',
'  function reportRegion(){try{return apex.region(''ar-open-balance-ir'');}catch(ignore){return null;}}',
'  function filters$(){return $(''#P32_DB_LINK,#P32_PERIOD_NAME,#P32_LEDGER_ID,#P32_COMPANY_SEGMENT'');}',
'  function actionButtons(show){byId(''use-existing-snapshot'').toggle(show);byId(''reload-snapshot'').toggle(show);}',
'  function runButton(show){byId(''run-ar-snapshot'').toggle(show);}',
'  function analysisButton(show){byId(''aging-analysis'').toggle(show);byId(''gl-ar-reconciliation'').toggle(show);byId(''ar-ai-analyst'').toggle(show);}',
'  function setBusy(on){busy=on;filters$().prop(''disabled'',on);byId(''run-ar-snapshot'').prop(''disabled'',on);byId(''use-existing-snapshot'').prop(''disabled'',on);byId(''reload-snapshot'').prop(''disabled'',on);}',
'  function stopActivity(){if(timerId){clearInterval(timerId);timerId=null;}if(spinner){spinner.remove();spinner=null;}}',
'  function seconds(){return ((performance.now()-startedAt)/1000).toFixed(1)+'' s'';}',
'  function startActivity(){stopActivity();startedAt=performance.now();byId(''p32-status-timing'').text(''Elapsed: 0.0 s'');timerId=setInterval(function(){byId(''p32-status-timing'').text(''Elapsed: ''+seconds());},250);try{spinner=apex.util.showSpinner(byId('
||'''snapshot-status''));}catch(ignore){spinner=null;}}',
'  function showStatus(kind,title,body,timing){byId(''snapshot-status'').show();var p=byId(''p32-status-panel'');p.removeAttr(''hidden'').removeClass(''p32-status--info p32-status--warning p32-status--success p32-status--error'').addClass(''p32-status--''+kind)'
||';byId(''p32-status-title'').text(title);byId(''p32-status-body'').text(body||'''');byId(''p32-status-timing'').text(timing||'''');}',
'  function hideReport(){apex.item(''P32_REPORT_READY'').setValue(''N'',null,true);analysisButton(false);reportElement().hide();}',
'  function setRunContext(m){apex.item(''P32_RUN_DB_LINK'').setValue(m.db_link,null,true);apex.item(''P32_RUN_PERIOD_NAME'').setValue(m.period_name,null,true);apex.item(''P32_RUN_LEDGER_ID'').setValue(m.ledger_id,null,true);apex.item(''P32_RUN_COMPANY'').setV'
||'alue(m.company,null,true);apex.item(''P32_RUN_AGING_BUCKET_ID'').setValue(m.aging_bucket_id,null,true);apex.item(''P32_REPORT_READY'').setValue(''Y'',null,true);}',
'  function showReport(m){if(Number(m.row_count)<1){actionButtons(false);runButton(false);hideReport();return;}setRunContext(m);actionButtons(false);runButton(false);var e=reportElement(),r;if(!e.length){throw new Error(''The AR Open Balance report reg'
||'ion is unavailable.'');}e.show();r=reportRegion();if(r&&typeof r.refresh===''function''){r.refresh();}else{e.trigger(''apexrefresh'');}analysisButton(true);}',
'  function metadataText(m){return ''Generated ''+m.loaded_on+'' by ''+m.loaded_by+'' (''+m.row_count+'' rows). As of ''+m.as_of_date+''.'';}',
'  function renderExisting(m,changed){known=m;hideReport();actionButtons(true);runButton(false);showStatus(changed?''warning'':''info'',changed?''Snapshot changed'':''Existing snapshot found'',(changed?''Another user generated a newer snapshot. Review it befor'
||'e choosing again. '':'''')+metadataText(m));}',
'  function params(){var r={db_link:$.trim(apex.item(''P32_DB_LINK'').getValue()).toUpperCase(),period_name:$.trim(apex.item(''P32_PERIOD_NAME'').getValue()).toUpperCase(),ledger_id:$.trim(apex.item(''P32_LEDGER_ID'').getValue()),company:$.trim(apex.item(''P'
||'32_COMPANY_SEGMENT'').getValue()).toUpperCase(),aging_bucket_id:$.trim(apex.item(''P32_AGING_BUCKET_ID'').getValue())},m=[];if(!r.db_link)m.push(''Database Source'');if(!r.period_name)m.push(''Period'');if(!r.ledger_id)m.push(''Ledger'');if(!r.company)m.push('
||'''Company Code'');if(m.length){apex.message.showErrors([{type:''error'',location:''page'',message:''Select ''+m.join('', '')+'' before running.'',unsafe:false}]);return null;}apex.item(''P32_PERIOD_NAME'').setValue(r.period_name,null,true);apex.item(''P32_COMPANY_S'
||'EGMENT'').setValue(r.company,null,true);apex.message.clearErrors();return r;}',
'  function payload(p){return{x01:p.db_link,x02:p.period_name,x03:p.ledger_id,x04:p.company,x07:p.aging_bucket_id};}',
'  function requestError(message,preserve){stopActivity();setBusy(false);actionButtons(!!preserve&&!!known);runButton(!(preserve&&known));showStatus(''error'',preserve?''Reload failed'':''Request failed'',message+(preserve?'' The previous snapshot remains av'
||'ailable.'':''''));}',
'  function beginLoad(p,reload){actionButtons(false);runButton(false);hideReport();setBusy(true);showStatus(''warning'',reload?''Reloading snapshot'':''Generating snapshot'',(reload?''The existing snapshot is being replaced. '':''No existing snapshot was found'
||'. '')+''Retrieving open Receivables balances from TMS may take up to two minutes.'');startActivity();var d=payload(p);d.x05=reload&&known?known.token:'''';d.x06=reload?''Y'':''N'';apex.server.process(''P32_LOAD_SNAPSHOT'',d,{dataType:''json''}).then(function(resu'
||'lt){stopActivity();setBusy(false);if(!result||result.ok!==true){requestError((result&&result.message)||''Unable to generate the snapshot.'',reload);return;}if(result.changed===true){renderExisting(result.snapshot,true);return;}known=result.snapshot;if('
||'Number(known.row_count)<1){showStatus(''warning'',''No AR open-balance data found'',''No rows matched the selected source, period, ledger and company. Verify the combination and try again.'',''Total: ''+seconds());showReport(known);return;}showStatus(''succes'
||'s'',''Snapshot generated'',metadataText(known),''Total: ''+seconds());try{showReport(known);}catch(e){requestError(e.message,false);}},function(error){requestError((error&&error.message)||''Unable to generate the snapshot.'',reload);});}',
'  function check(){if(busy)return;var p=params();if(!p)return;known=null;actionButtons(false);hideReport();setBusy(true);showStatus(''info'',''Checking snapshot availability'',''Checking the selected database source, period, ledger and company.'');apex.ser'
||'ver.process(''P32_CHECK_SNAPSHOT'',payload(p),{dataType:''json''}).then(function(result){if(!result||result.ok!==true){requestError((result&&result.message)||''Unable to check snapshot availability.'',false);return;}if(result.exists===true){setBusy(false);'
||'renderExisting(result.snapshot,false);}else{beginLoad(result.snapshot,false);}},function(error){requestError((error&&error.message)||''Unable to check snapshot availability.'',false);});}',
'  function useExisting(){if(busy||!known)return;showStatus(''success'',''Using existing snapshot'',metadataText(known));try{showReport(known);}catch(e){requestError(e.message,false);}}',
'  function recheckAndReload(){var p=params();if(!p)return;setBusy(true);actionButtons(false);hideReport();showStatus(''info'',''Rechecking snapshot'',''Confirming that the snapshot has not changed.'');apex.server.process(''P32_CHECK_SNAPSHOT'',payload(p),{da'
||'taType:''json''}).then(function(result){if(!result||result.ok!==true){requestError((result&&result.message)||''Unable to recheck the snapshot.'',true);return;}if(result.exists===true&&known&&result.snapshot.token!==known.token){setBusy(false);renderExist'
||'ing(result.snapshot,true);return;}beginLoad(result.snapshot,true);},function(error){requestError((error&&error.message)||''Unable to recheck the snapshot.'',true);});}',
'  function requestReload(){if(busy||!known)return;apex.message.confirm(''Replace the snapshot ''+metadataText(known),function(ok){if(ok)recheckAndReload();});}',
'  function openAging(){if(busy||apex.item(''P32_REPORT_READY'').getValue()!==''Y'')return;var target=''ar_aging_''+Date.now(),child=window.open('''',target);if(!child){apex.message.showErrors([{type:''error'',location:''page'',message:''Allow pop-ups to open Agin'
||'g Analysis in a new tab.'',unsafe:false}]);return;}child.document.write(''<title>Opening AR Aging Analysis</title><p style="font-family:sans-serif;padding:1rem">Opening AR Aging Analysis...</p>'');apex.server.process(''P32_GET_AGING_URL'',{pageItems:''#P32'
||'_REPORT_READY,#P32_RUN_DB_LINK,#P32_RUN_PERIOD_NAME,#P32_RUN_LEDGER_ID,#P32_RUN_COMPANY,#P32_RUN_AGING_BUCKET_ID''},{dataType:''json''}).then(function(result){if(!result||result.ok!==true||!result.url){child.close();apex.message.showErrors([{type:''error'
||''',location:''page'',message:(result&&result.message)||''Unable to open Aging Analysis.'',unsafe:false}]);return;}child.location.replace(result.url);},function(error){child.close();apex.message.showErrors([{type:''error'',location:''page'',message:(error&&err'
||'or.message)||''Unable to open Aging Analysis.'',unsafe:false}]);});}',
'  function openReconciliation(){if(busy||apex.item(''P32_REPORT_READY'').getValue()!==''Y'')return;var target=''gl_ar_recon_''+Date.now(),child=window.open('''',target);if(!child){apex.message.showErrors([{type:''error'',location:''page'',message:''Allow pop-ups '
||'to open GL/AR Reconciliation in a new tab.'',unsafe:false}]);return;}child.document.write(''<title>Opening GL/AR Reconciliation</title><p style="font-family:sans-serif;padding:1rem">Opening GL/AR Reconciliation...</p>'');apex.server.process(''P32_GET_REC'
||'ON_URL'',{pageItems:''#P32_REPORT_READY,#P32_RUN_DB_LINK,#P32_RUN_PERIOD_NAME,#P32_RUN_LEDGER_ID,#P32_RUN_COMPANY,#P32_RUN_AGING_BUCKET_ID''},{dataType:''json''}).then(function(result){if(!result||result.ok!==true||!result.url){child.close();apex.message.'
||'showErrors([{type:''error'',location:''page'',message:(result&&result.message)||''Unable to open GL/AR Reconciliation.'',unsafe:false}]);return;}child.location.replace(result.url);},function(error){child.close();apex.message.showErrors([{type:''error'',locat'
||'ion:''page'',message:(error&&error.message)||''Unable to open GL/AR Reconciliation.'',unsafe:false}]);});}',
'  function openAi(){if(busy||apex.item(''P32_REPORT_READY'').getValue()!==''Y'')return;var target=''ar_ai_''+Date.now(),child=window.open('''',target);if(!child){apex.message.showErrors([{type:''error'',location:''page'',message:''Allow pop-ups to open the AI Ana'
||'lyst in a new tab.'',unsafe:false}]);return;}child.document.write(''<title>Opening AI Analyst</title><p style="font-family:sans-serif;padding:1rem">Opening AI Analyst...</p>'');apex.server.process(''P32_GET_AI_URL'',{pageItems:''#P32_REPORT_READY,#P32_RUN_'
||'DB_LINK,#P32_RUN_PERIOD_NAME,#P32_RUN_LEDGER_ID,#P32_RUN_COMPANY,#P32_RUN_AGING_BUCKET_ID''},{dataType:''json''}).then(function(result){if(!result||result.ok!==true||!result.url){child.close();apex.message.showErrors([{type:''error'',location:''page'',messa'
||'ge:(result&&result.message)||''Unable to open the AI Analyst.'',unsafe:false}]);return;}child.location.replace(result.url);},function(error){child.close();apex.message.showErrors([{type:''error'',location:''page'',message:(error&&error.message)||''Unable to'
||' open the AI Analyst.'',unsafe:false}]);});}',
'  function reset(){if(busy)return;known=null;stopActivity();actionButtons(false);runButton(true);hideReport();byId(''p32-status-panel'').attr(''hidden'',''hidden'');byId(''snapshot-status'').hide();apex.message.clearErrors();}',
'  $(function(){actionButtons(false);runButton(true);hideReport();byId(''p32-status-panel'').attr(''hidden'',''hidden'');byId(''snapshot-status'').hide();filters$().on(''change.p32'',reset);});',
'  return{check:check,useExisting:useExisting,requestReload:requestReload,openAging:openAging,openReconciliation:openReconciliation,openAi:openAi,reset:reset};',
'})(apex.jQuery);'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#ar-open-balance-ir{display:none;}',
'#use-existing-snapshot,#reload-snapshot,#aging-analysis,#gl-ar-reconciliation,#ar-ai-analyst{display:none;}',
'#snapshot-status{position:relative;min-height:4rem;}',
'.p32-status{border-left:4px solid #6b7280;border-radius:.25rem;padding:.8rem 1rem;background:#f6f7f8;}',
'.p32-status--info{border-left-color:#2563eb;background:#eff6ff;}',
'.p32-status--warning{border-left-color:#d97706;background:#fffbeb;}',
'.p32-status--success{border-left-color:#15803d;background:#f0fdf4;}',
'.p32-status--error{border-left-color:#b91c1c;background:#fef2f2;}',
'#p32-status-title{font-size:1rem;font-weight:700;margin:0 0 .25rem;}',
'#p32-status-body{margin:0;}',
'#p32-status-timing{font-variant-numeric:tabular-nums;font-weight:600;margin-top:.35rem;}',
'.p32-control-N{display:inline-block;padding:.15rem .45rem;border-radius:1rem;background:#fee2e2;color:#991b1b;font-weight:700;}',
'.p32-control-Y{display:inline-block;padding:.15rem .45rem;border-radius:1rem;background:#dcfce7;color:#166534;font-weight:700;}'))
,p_step_template=>4075783602716660119
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(9156329399484443)
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(991705178578422781)
,p_plug_name=>'AR Open Balance'
,p_static_id=>'ar-open-balance-ir'
,p_title=>'AR Open Balance'
,p_region_name=>'ar-open-balance-ir'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>30
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select customer_number, customer_name, trx_number, class_code, trx_date, due_date,',
'       days_past_due, bucket_heading, currency_code, entered_balance_asof,',
'       accounted_balance_asof, account_segments,',
'       case control_account_flag when ''Y'' then ''Control Account''',
'            else ''Outside Control Account'' end control_account_status,',
'       payment_schedule_id, customer_id, customer_trx_id, receivable_ccid, org_id,',
'       bucket_sequence, control_account_flag',
'  from xxme_ar_recon_v2_snap',
' where :P32_REPORT_READY = ''Y''',
'   and db_link_name = :P32_RUN_DB_LINK',
'   and period_name = :P32_RUN_PERIOD_NAME',
'   and ledger_id = to_number(:P32_RUN_LEDGER_ID)',
'   and company_segment = :P32_RUN_COMPANY',
'   and aging_bucket_id = to_number(:P32_RUN_AGING_BUCKET_ID)'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P32_REPORT_READY,P32_RUN_DB_LINK,P32_RUN_PERIOD_NAME,P32_RUN_LEDGER_ID,P32_RUN_COMPANY,P32_RUN_AGING_BUCKET_ID'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'AR Open Balance'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(991705178578422817)
,p_no_data_found_message=>'The selected snapshot contains no AR open-balance rows.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>true
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_internal_uid=>932160000000686645
,p_ai_report_hint=>'Transaction-level local AR open-balance snapshot for one database source, Receivables period, ledger, company, and aging-bucket definition. ACCOUNTED_BALANCE_ASOF is ledger-functional and is the correct measure for totals and reconciliation. ENTERED_'
||'BALANCE_ASOF is transaction-currency and must only be totaled within CURRENCY_CODE. Prefer customer number/name, transaction number, full account combination, dates, bucket heading, and report amounts over hidden technical IDs.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(991705178578421987)
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
 p_id=>wwv_flow_imp.id(991705178578421988)
,p_db_column_name=>'ACCOUNT_SEGMENTS'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Receivable Account'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Full concatenated receivable account combination. Prefer this business-facing value over RECEIVABLE_CCID.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(991705178578421984)
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
 p_id=>wwv_flow_imp.id(991705178578421995)
,p_db_column_name=>'BUCKET_SEQUENCE'
,p_display_order=>950
,p_column_identifier=>'S'
,p_column_label=>'Bucket Sequence'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden configured aging bucket sequence used for drilldown.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(991705178578421980)
,p_db_column_name=>'CLASS_CODE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Transaction Class'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Receivables transaction class, such as invoice, debit memo, chargeback, or credit memo.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(991705178578421996)
,p_db_column_name=>'CONTROL_ACCOUNT_FLAG'
,p_display_order=>960
,p_column_identifier=>'T'
,p_column_label=>'Control Account Flag'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical Y/N control-account indicator.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(991705178578421989)
,p_db_column_name=>'CONTROL_ACCOUNT_STATUS'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Control Account Status'
,p_column_html_expression=>'<span class="p32-control-#CONTROL_ACCOUNT_FLAG#">#CONTROL_ACCOUNT_STATUS#</span>'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Shows whether the receivable account natural account is in the finance-approved control-account configuration.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(991705178578421985)
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
 p_id=>wwv_flow_imp.id(991705178578421991)
,p_db_column_name=>'CUSTOMER_ID'
,p_display_order=>910
,p_column_identifier=>'O'
,p_column_label=>'Customer ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical customer account identifier. Prefer customer name and customer number.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(991705178578421978)
,p_db_column_name=>'CUSTOMER_NAME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Customer Name'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Customer business name. Use contains-style searching and group by this value for customer comparisons.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(991705178578421977)
,p_db_column_name=>'CUSTOMER_NUMBER'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Customer Number'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Customer account number. Use exact matching and pair it with CUSTOMER_NAME in business-facing answers.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(991705178578421992)
,p_db_column_name=>'CUSTOMER_TRX_ID'
,p_display_order=>920
,p_column_identifier=>'P'
,p_column_label=>'Customer Transaction ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical Receivables transaction identifier. Prefer transaction number.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(991705178578421983)
,p_db_column_name=>'DAYS_PAST_DUE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Days Past Due'
,p_column_type=>'NUMBER'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Calendar days past due as of the snapshot date. Positive values are overdue; zero or negative values are current.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(991705178578421982)
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
 p_id=>wwv_flow_imp.id(991705178578421986)
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
 p_id=>wwv_flow_imp.id(991705178578421994)
,p_db_column_name=>'ORG_ID'
,p_display_order=>940
,p_column_identifier=>'R'
,p_column_label=>'Organization ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical Receivables organization identifier. It is not the company code.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(991705178578421990)
,p_db_column_name=>'PAYMENT_SCHEDULE_ID'
,p_display_order=>900
,p_column_identifier=>'N'
,p_column_label=>'Payment Schedule ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical AR payment schedule identifier.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(991705178578421993)
,p_db_column_name=>'RECEIVABLE_CCID'
,p_display_order=>930
,p_column_identifier=>'Q'
,p_column_label=>'Receivable CCID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical GL code combination identifier. Prefer the full receivable account combination.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(991705178578421981)
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
 p_id=>wwv_flow_imp.id(991705178578421979)
,p_db_column_name=>'TRX_NUMBER'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Transaction Number'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Receivables transaction number. Treat as text and prefer it over hidden transaction IDs.'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(991705178578422818)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'932160000000686646'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CUSTOMER_NUMBER:CUSTOMER_NAME:TRX_NUMBER:CLASS_CODE:TRX_DATE:DUE_DATE:DAYS_PAST_DUE:BUCKET_HEADING:CURRENCY_CODE:ENTERED_BALANCE_ASOF:ACCOUNTED_BALANCE_ASOF:ACCOUNT_SEGMENTS:CONTROL_ACCOUNT_STATUS'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(317992543199423948)
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
 p_id=>wwv_flow_imp.id(991705178578421779)
,p_plug_name=>'Snapshot Parameters'
,p_static_id=>'snapshot-parameters'
,p_title=>'Snapshot Parameters'
,p_region_name=>'snapshot-parameters'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Select the TMS database source, Receivables period, ledger, and company code, then click <strong>Run AR Snapshot</strong>.</p>',
'<p>If a snapshot exists, review its generation details and choose whether to use it or replace it.</p>',
'<details><summary>Amount definitions</summary><dl><dt>Entered Open Balance</dt><dd>Remaining open amount in transaction currency; do not total across currencies.</dd><dt>Accounted Open Balance</dt><dd>Remaining open amount in ledger functional curren'
||'cy; use this for ledger-level totals and reconciliation.</dd></dl></details>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(991705178578421780)
,p_plug_name=>'Snapshot Status'
,p_static_id=>'snapshot-status'
,p_title=>'Snapshot Status'
,p_region_name=>'snapshot-status'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>20
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div id="p32-status-panel" class="p32-status p32-status--info" role="status" aria-live="polite" hidden>',
'  <h3 id="p32-status-title"></h3>',
'  <p id="p32-status-body"></p>',
'  <div id="p32-status-timing"></div>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(991705178578421801)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(991705178578421779)
,p_button_name=>'AGING_ANALYSIS'
,p_static_id=>'aging-analysis'
,p_button_static_id=>'aging-analysis'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Aging Analysis'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-chart-bar'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(991705178578421803)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_imp.id(991705178578421779)
,p_button_name=>'AR_AI_ANALYST'
,p_static_id=>'ar-ai-analyst'
,p_button_static_id=>'ar-ai-analyst'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Analyze with AI'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-sparkles'
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(991705178578421802)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_imp.id(991705178578421779)
,p_button_name=>'GL_AR_RECONCILIATION'
,p_static_id=>'gl-ar-reconciliation'
,p_button_static_id=>'gl-ar-reconciliation'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'GL/AR Reconciliation'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-balance-scale'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(991705178578421799)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(991705178578421779)
,p_button_name=>'RELOAD_SNAPSHOT'
,p_static_id=>'reload-snapshot'
,p_button_static_id=>'reload-snapshot'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Reload Snapshot'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(991705178578421800)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_imp.id(991705178578421779)
,p_button_name=>'RESET_PAGE'
,p_static_id=>'reset-page'
,p_button_static_id=>'reset-page'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Reset'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-undo'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(991705178578421797)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(991705178578421779)
,p_button_name=>'RUN_AR_SNAPSHOT'
,p_static_id=>'run-ar-snapshot'
,p_button_static_id=>'run-ar-snapshot'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Run AR Snapshot'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-play'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(991705178578421798)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(991705178578421779)
,p_button_name=>'USE_EXISTING_SNAPSHOT'
,p_static_id=>'use-existing-snapshot'
,p_button_static_id=>'use-existing-snapshot'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Use Existing Snapshot'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-database'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(991705178578421881)
,p_name=>'P32_AGING_BUCKET_ID'
,p_item_sequence=>90
,p_item_default=>'1121'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(991705178578421880)
,p_name=>'P32_COMPANY_SEGMENT'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(991705178578421779)
,p_prompt=>'Company Code'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>25
,p_cMaxlength=>25
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'placeholder', 'e.g. 010',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'text_case', 'UPPER',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(991705178578421877)
,p_name=>'P32_DB_LINK'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(991705178578421779)
,p_item_default=>'ADG'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_cHeight=>1
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(991705178578421879)
,p_name=>'P32_LEDGER_ID'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(991705178578421779)
,p_prompt=>'Ledger'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select d, r from (',
'  select ''TEREX US'' d, ''1003'' r, 1 seq from dual',
'  union all select ''TEREX UK 120'',''5001'',2 from dual',
'  union all select ''TEREX CH'',''10001'',3 from dual',
') order by seq'))
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(991705178578421878)
,p_name=>'P32_PERIOD_NAME'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(991705178578421779)
,p_prompt=>'Receivables Period'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>30
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'placeholder', 'e.g. AUG-2026',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'text_case', 'UPPER',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(991705178578421882)
,p_name=>'P32_REPORT_READY'
,p_item_sequence=>100
,p_item_default=>'N'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(991705178578421887)
,p_name=>'P32_RUN_AGING_BUCKET_ID'
,p_item_sequence=>105
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(991705178578421886)
,p_name=>'P32_RUN_COMPANY'
,p_item_sequence=>104
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(991705178578421883)
,p_name=>'P32_RUN_DB_LINK'
,p_item_sequence=>101
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(991705178578421885)
,p_name=>'P32_RUN_LEDGER_ID'
,p_item_sequence=>103
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(991705178578421884)
,p_name=>'P32_RUN_PERIOD_NAME'
,p_item_sequence=>102
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(991705178578422085)
,p_name=>'Open Aging Analysis'
,p_static_id=>'open-aging-analysis'
,p_event_sequence=>50
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(991705178578421801)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(991705178578422086)
,p_event_id=>wwv_flow_imp.id(991705178578422085)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p32Controller.openAging();')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(991705178578422089)
,p_name=>'Open AR AI Analyst'
,p_static_id=>'open-ar-ai-analyst'
,p_event_sequence=>70
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(991705178578421803)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(991705178578422090)
,p_event_id=>wwv_flow_imp.id(991705178578422089)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p32Controller.openAi();')).to_clob
,p_build_option_id=>wwv_flow_imp.id(1017112543199391948)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(991705178578422087)
,p_name=>'Open GL AR Reconciliation'
,p_static_id=>'open-gl-ar-reconciliation'
,p_event_sequence=>60
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(991705178578421802)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(991705178578422088)
,p_event_id=>wwv_flow_imp.id(991705178578422087)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p32Controller.openReconciliation();')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(991705178578422081)
,p_name=>'Reload Snapshot'
,p_static_id=>'reload-snapshot'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(991705178578421799)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(991705178578422082)
,p_event_id=>wwv_flow_imp.id(991705178578422081)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p32Controller.requestReload();')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(991705178578422083)
,p_name=>'Reset Page'
,p_static_id=>'reset-page'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(991705178578421800)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(991705178578422084)
,p_event_id=>wwv_flow_imp.id(991705178578422083)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p32Controller.reset();')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(991705178578422077)
,p_name=>'Run AR Snapshot'
,p_static_id=>'run-ar-snapshot'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(991705178578421797)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(991705178578422078)
,p_event_id=>wwv_flow_imp.id(991705178578422077)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p32Controller.check();')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(991705178578422079)
,p_name=>'Use Existing Snapshot'
,p_static_id=>'use-existing-snapshot'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(991705178578421798)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(991705178578422080)
,p_event_id=>wwv_flow_imp.id(991705178578422079)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p32Controller.useExisting();')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(991705178578422177)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Initialize Page 32 State'
,p_static_id=>'initialize-page-32-state'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'  apex_util.set_session_state(''P32_REPORT_READY'',''N'',p_commit=>false);',
'  apex_util.set_session_state(''P32_RUN_DB_LINK'',null,p_commit=>false);',
'  apex_util.set_session_state(''P32_RUN_PERIOD_NAME'',null,p_commit=>false);',
'  apex_util.set_session_state(''P32_RUN_LEDGER_ID'',null,p_commit=>false);',
'  apex_util.set_session_state(''P32_RUN_COMPANY'',null,p_commit=>false);',
'  apex_util.set_session_state(''P32_RUN_AGING_BUCKET_ID'',null,p_commit=>false);',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>932160000000686005
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(991705178578422178)
,p_process_sequence=>20
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'P32_CHECK_SNAPSHOT'
,p_static_id=>'p32-check-snapshot'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_db varchar2(128):=upper(trim(apex_application.g_x01)); l_period varchar2(30):=upper(trim(apex_application.g_x02));',
'  l_ledger_text varchar2(30):=trim(apex_application.g_x03); l_company varchar2(25):=upper(trim(apex_application.g_x04));',
'  l_bucket_text varchar2(30):=trim(apex_application.g_x07); l_ledger number; l_bucket number; l_count number; l_by varchar2(128); l_on timestamp; l_asof date;',
'  procedure validate_inputs is begin',
'    if l_db not in (''ADG'') then raise_application_error(-20321,''Select an approved database source.''); end if;',
'    if l_period is null or not regexp_like(l_period,''^[A-Z0-9 _./-]{1,30}$'') then raise_application_error(-20322,''Enter a valid Receivables period.''); end if;',
'    if not regexp_like(l_ledger_text,''^[0-9]{1,18}$'') then raise_application_error(-20323,''Select a valid Ledger.''); end if; l_ledger:=to_number(l_ledger_text);',
'    if l_company is null or not regexp_like(l_company,''^[A-Z0-9_.-]{1,25}$'') then raise_application_error(-20324,''Enter a valid Company Code.''); end if;',
'    if not regexp_like(l_bucket_text,''^[0-9]{1,18}$'') then raise_application_error(-20325,''The configured aging bucket is invalid.''); end if; l_bucket:=to_number(l_bucket_text);',
'  end;',
'  procedure respond(p_exists boolean) is begin',
'    apex_json.open_object; apex_json.write(''ok'',true); apex_json.write(''exists'',p_exists); apex_json.open_object(''snapshot'');',
'    apex_json.write(''db_link'',l_db); apex_json.write(''period_name'',l_period); apex_json.write(''ledger_id'',to_char(l_ledger)); apex_json.write(''company'',l_company); apex_json.write(''aging_bucket_id'',to_char(l_bucket));',
'    apex_json.write(''as_of_date'',case when l_asof is not null then to_char(l_asof,''DD-MON-YYYY'') end); apex_json.write(''row_count'',nvl(l_count,0)); apex_json.write(''loaded_by'',l_by);',
'    apex_json.write(''loaded_on'',case when l_on is not null then to_char(l_on,''DD-MON-YYYY HH24:MI:SS'') end); apex_json.write(''token'',case when l_on is not null then to_char(l_on,''YYYYMMDDHH24MISSFF6'') end); apex_json.close_object; apex_json.close_obj'
||'ect;',
'  end;',
'begin',
'  validate_inputs;',
'  select count(*),max(loaded_by),max(loaded_at),max(as_of_date) into l_count,l_by,l_on,l_asof from xxme_ar_recon_v2_snap where db_link_name=l_db and ledger_id=l_ledger and company_segment=l_company and period_name=l_period and aging_bucket_id=l_bucke'
||'t;',
'  respond(l_count>0);',
'exception when others then apex_json.open_object; apex_json.write(''ok'',false); apex_json.write(''message'',case when sqlcode between -20999 and -20000 then substr(sqlerrm,12) else ''Unable to check snapshot availability. Check the APEX debug log.'' end);'
||' apex_json.close_object;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>932160000000686006
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(991705178578422180)
,p_process_sequence=>40
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'P32_GET_AGING_URL'
,p_static_id=>'p32-get-aging-url'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare l_count number; l_url varchar2(32767);',
'begin',
' if :P32_REPORT_READY<>''Y'' or :P32_RUN_DB_LINK not in (''ADG'') or not regexp_like(:P32_RUN_PERIOD_NAME,''^[A-Z0-9 _./-]{1,30}$'')',
'    or not regexp_like(:P32_RUN_LEDGER_ID,''^[0-9]{1,18}$'') or not regexp_like(:P32_RUN_COMPANY,''^[A-Z0-9_.-]{1,25}$'') or not regexp_like(:P32_RUN_AGING_BUCKET_ID,''^[0-9]{1,18}$'') then raise_application_error(-20331,''Invalid AR snapshot context.''); en'
||'d if;',
' select count(*) into l_count from xxme_ar_recon_v2_snap where db_link_name=:P32_RUN_DB_LINK and ledger_id=to_number(:P32_RUN_LEDGER_ID) and company_segment=:P32_RUN_COMPANY and period_name=:P32_RUN_PERIOD_NAME and aging_bucket_id=to_number(:P32_RUN_'
||'AGING_BUCKET_ID);',
' if l_count=0 then raise_application_error(-20332,''The selected AR snapshot is no longer available.''); end if;',
' l_url:=apex_page.get_url(p_page=>33,p_clear_cache=>''33'',p_items=>''P33_DB_LINK,P33_PERIOD_NAME,P33_LEDGER_ID,P33_COMPANY,P33_AGING_BUCKET_ID'',p_values=>:P32_RUN_DB_LINK||'',''||:P32_RUN_PERIOD_NAME||'',''||:P32_RUN_LEDGER_ID||'',''||:P32_RUN_COMPANY||'',''||'
||':P32_RUN_AGING_BUCKET_ID);',
' apex_json.open_object;apex_json.write(''ok'',true);apex_json.write(''url'',l_url);apex_json.close_object;',
'exception when others then apex_json.open_object;apex_json.write(''ok'',false);apex_json.write(''message'',case when sqlcode between -20999 and -20000 then substr(sqlerrm,12) else ''Unable to prepare the Aging Analysis URL.'' end);apex_json.close_object;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>932160000000686008
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(991705178578422182)
,p_process_sequence=>60
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'P32_GET_AI_URL'
,p_static_id=>'p32-get-ai-url'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare l_count number; l_asof date; l_url varchar2(32767);',
'begin',
' if :P32_REPORT_READY<>''Y'' or :P32_RUN_DB_LINK not in (''ADG'') or not regexp_like(:P32_RUN_PERIOD_NAME,''^[A-Z0-9 _./-]{1,30}$'')',
'    or not regexp_like(:P32_RUN_LEDGER_ID,''^[0-9]{1,18}$'') or not regexp_like(:P32_RUN_COMPANY,''^[A-Z0-9_.-]{1,25}$'') or not regexp_like(:P32_RUN_AGING_BUCKET_ID,''^[0-9]{1,18}$'') then raise_application_error(-20335,''Invalid AR snapshot context.''); en'
||'d if;',
' select count(*),max(as_of_date) into l_count,l_asof from xxme_ar_recon_v2_snap where db_link_name=:P32_RUN_DB_LINK and ledger_id=to_number(:P32_RUN_LEDGER_ID) and company_segment=:P32_RUN_COMPANY and period_name=:P32_RUN_PERIOD_NAME and aging_bucket'
||'_id=to_number(:P32_RUN_AGING_BUCKET_ID);',
' if l_count=0 then raise_application_error(-20336,''The selected AR snapshot is no longer available.''); end if;',
' l_url:=apex_page.get_url(p_page=>50,p_clear_cache=>''50'',p_items=>''P50_DB_LINK,P50_PERIOD_NAME,P50_AR_SCOPE_AS_OF_DATE,P50_AR_LEDGER_ID,P50_AR_COMPANY,P50_AR_AGING_BUCKET_ID,P50_AR_SOURCE_PAGE,P50_AR_RECON_READY'',p_values=>:P32_RUN_DB_LINK||'',''||:P32'
||'_RUN_PERIOD_NAME||'',''||to_char(l_asof,''YYYY-MM-DD'')||'',''||:P32_RUN_LEDGER_ID||'',''||:P32_RUN_COMPANY||'',''||:P32_RUN_AGING_BUCKET_ID||'',32,N'');',
' apex_json.open_object;apex_json.write(''ok'',true);apex_json.write(''url'',l_url);apex_json.close_object;',
'exception when others then apex_json.open_object;apex_json.write(''ok'',false);apex_json.write(''message'',case when sqlcode between -20999 and -20000 then substr(sqlerrm,12) else ''Unable to prepare the AI Analyst URL.'' end);apex_json.close_object;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
,p_internal_uid=>932160000000686010
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(991705178578422181)
,p_process_sequence=>50
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'P32_GET_RECON_URL'
,p_static_id=>'p32-get-recon-url'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare l_count number; l_url varchar2(32767);',
'begin',
' if :P32_REPORT_READY<>''Y'' or :P32_RUN_DB_LINK not in (''ADG'') or not regexp_like(:P32_RUN_PERIOD_NAME,''^[A-Z0-9 _./-]{1,30}$'')',
'    or not regexp_like(:P32_RUN_LEDGER_ID,''^[0-9]{1,18}$'') or not regexp_like(:P32_RUN_COMPANY,''^[A-Z0-9_.-]{1,25}$'') or not regexp_like(:P32_RUN_AGING_BUCKET_ID,''^[0-9]{1,18}$'') then raise_application_error(-20333,''Invalid AR snapshot context.''); en'
||'d if;',
' select count(*) into l_count from xxme_ar_recon_v2_snap where db_link_name=:P32_RUN_DB_LINK and ledger_id=to_number(:P32_RUN_LEDGER_ID) and company_segment=:P32_RUN_COMPANY and period_name=:P32_RUN_PERIOD_NAME and aging_bucket_id=to_number(:P32_RUN_'
||'AGING_BUCKET_ID);',
' if l_count=0 then raise_application_error(-20334,''The selected AR snapshot is no longer available.''); end if;',
' l_url:=apex_page.get_url(p_page=>34,p_clear_cache=>''34'',p_items=>''P34_DB_LINK,P34_PERIOD_NAME,P34_LEDGER_ID,P34_COMPANY,P34_AGING_BUCKET_ID'',p_values=>:P32_RUN_DB_LINK||'',''||:P32_RUN_PERIOD_NAME||'',''||:P32_RUN_LEDGER_ID||'',''||:P32_RUN_COMPANY||'',''||'
||':P32_RUN_AGING_BUCKET_ID);',
' apex_json.open_object;apex_json.write(''ok'',true);apex_json.write(''url'',l_url);apex_json.close_object;',
'exception when others then apex_json.open_object;apex_json.write(''ok'',false);apex_json.write(''message'',case when sqlcode between -20999 and -20000 then substr(sqlerrm,12) else ''Unable to prepare the GL/AR Reconciliation URL.'' end);apex_json.close_obj'
||'ect;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>932160000000686009
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(991705178578422179)
,p_process_sequence=>30
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'P32_LOAD_SNAPSHOT'
,p_static_id=>'p32-load-snapshot'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_db varchar2(128):=upper(trim(apex_application.g_x01)); l_period varchar2(30):=upper(trim(apex_application.g_x02));',
'  l_ledger_text varchar2(30):=trim(apex_application.g_x03); l_company varchar2(25):=upper(trim(apex_application.g_x04)); l_expected varchar2(30):=trim(apex_application.g_x05); l_reload varchar2(1):=upper(trim(apex_application.g_x06));',
'  l_bucket_text varchar2(30):=trim(apex_application.g_x07); l_ledger number; l_bucket number; l_rows number:=0; l_actual number; l_by varchar2(128); l_on timestamp; l_asof date; l_token varchar2(30);',
'begin',
'  if l_db not in (''ADG'') then raise_application_error(-20321,''Select an approved database source.''); end if;',
'  if l_period is null or not regexp_like(l_period,''^[A-Z0-9 _./-]{1,30}$'') then raise_application_error(-20322,''Enter a valid Receivables period.''); end if;',
'  if not regexp_like(l_ledger_text,''^[0-9]{1,18}$'') then raise_application_error(-20323,''Select a valid Ledger.''); end if; l_ledger:=to_number(l_ledger_text);',
'  if l_company is null or not regexp_like(l_company,''^[A-Z0-9_.-]{1,25}$'') then raise_application_error(-20324,''Enter a valid Company Code.''); end if;',
'  if not regexp_like(l_bucket_text,''^[0-9]{1,18}$'') then raise_application_error(-20325,''The configured aging bucket is invalid.''); end if; l_bucket:=to_number(l_bucket_text);',
'  if l_reload=''Y'' and l_expected is not null then',
'    select count(*),max(loaded_by),max(loaded_at),max(as_of_date) into l_actual,l_by,l_on,l_asof from xxme_ar_recon_v2_snap where db_link_name=l_db and ledger_id=l_ledger and company_segment=l_company and period_name=l_period and aging_bucket_id=l_bu'
||'cket;',
'    l_token:=case when l_on is not null then to_char(l_on,''YYYYMMDDHH24MISSFF6'') end;',
'    if l_actual>0 and nvl(l_token,''-'')<>l_expected then apex_json.open_object; apex_json.write(''ok'',true); apex_json.write(''changed'',true); apex_json.open_object(''snapshot''); apex_json.write(''db_link'',l_db); apex_json.write(''period_name'',l_period); a'
||'pex_json.write(''ledger_id'',to_char(l_ledger)); apex_json.write(''company'',l_company); apex_json.write(''aging_bucket_id'',to_char(l_bucket)); apex_json.write(''as_of_date'',to_char(l_asof,''DD-MON-YYYY'')); apex_json.write(''row_count'',l_actual); apex_json.w'
||'rite(''loaded_by'',l_by); apex_json.write(''loaded_on'',to_char(l_on,''DD-MON-YYYY HH24:MI:SS'')); apex_json.write(''token'',l_token); apex_json.close_object; apex_json.close_object; return; end if;',
'  end if;',
'  xxme_ar_recon_v2_pkg.populate_snapshot(p_db_link=>l_db,p_ledger_id=>l_ledger,p_company_segment=>l_company,p_period_name=>l_period,p_aging_bucket_id=>l_bucket,p_loaded_by=>nvl(v(''APP_USER''),user),p_row_count=>l_rows);',
'  select count(*),max(loaded_by),max(loaded_at),max(as_of_date) into l_actual,l_by,l_on,l_asof from xxme_ar_recon_v2_snap where db_link_name=l_db and ledger_id=l_ledger and company_segment=l_company and period_name=l_period and aging_bucket_id=l_buck'
||'et;',
'  if l_actual<>nvl(l_rows,0) then raise_application_error(-20326,''Snapshot row-count validation failed after loading.''); end if;',
'  if l_actual=0 then l_by:=nvl(v(''APP_USER''),user); l_on:=systimestamp; end if;',
'  apex_json.open_object; apex_json.write(''ok'',true); apex_json.open_object(''snapshot''); apex_json.write(''db_link'',l_db); apex_json.write(''period_name'',l_period); apex_json.write(''ledger_id'',to_char(l_ledger)); apex_json.write(''company'',l_company); ap'
||'ex_json.write(''aging_bucket_id'',to_char(l_bucket)); apex_json.write(''as_of_date'',case when l_asof is not null then to_char(l_asof,''DD-MON-YYYY'') else l_period end); apex_json.write(''row_count'',l_actual); apex_json.write(''loaded_by'',l_by); apex_json.w'
||'rite(''loaded_on'',to_char(l_on,''DD-MON-YYYY HH24:MI:SS'')); apex_json.write(''token'',to_char(l_on,''YYYYMMDDHH24MISSFF6'')); apex_json.close_object; apex_json.close_object;',
'exception when others then rollback; apex_json.open_object; apex_json.write(''ok'',false); apex_json.write(''message'',case when sqlcode between -20999 and -20000 then substr(sqlerrm,12) else ''Unable to generate the AR Open Balance snapshot. Check the AP'
||'EX debug log.'' end); apex_json.close_object;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>932160000000686007
);
wwv_flow_imp.component_end;
end;
/
