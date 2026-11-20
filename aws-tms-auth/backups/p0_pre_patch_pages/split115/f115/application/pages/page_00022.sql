prompt --application/pages/page_00022
begin
--   Manifest
--     PAGE: 00022
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
 p_id=>22
,p_name=>'AP Trial Balance Snapshot'
,p_alias=>'AP-TRIAL-BALANCE-SNAPSHOT'
,p_step_title=>'AP Trial Balance Snapshot'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* Page 22 snapshot workflow and AI analysis launch. */',
'var p22Controller = (function ($) {',
'  ''use strict'';',
'  var busy = false, spinner = null, timerId = null, startedAt = null, known = null;',
'  var itemNames = [''P22_DB_LINK'',''P22_AS_OF_DATE'',''P22_LEDGER_ID'',''P22_COMPANY_SEGMENT''];',
'',
'  function byId(id) { return $(''#'' + id); }',
'  function reportElement() { return byId(''ap-trial-balance-ir''); }',
'  function reportRegion() {',
'    try { return apex.region(''ap-trial-balance-ir''); } catch (ignore) { return null; }',
'  }',
'  function canonicalDate(value) {',
'    var text = $.trim(value), match, month,',
'      months = {JAN:''01'',FEB:''02'',MAR:''03'',APR:''04'',MAY:''05'',JUN:''06'',JUL:''07'',AUG:''08'',SEP:''09'',OCT:''10'',NOV:''11'',DEC:''12''};',
'    if (/^\d{4}-\d{2}-\d{2}$/.test(text)) { return text; }',
'    match = /^(\d{1,2})-([A-Za-z]{3})-(\d{4})$/.exec(text);',
'    if (!match) { return text; }',
'    month = months[match[2].toUpperCase()];',
'    return month ? match[3] + ''-'' + month + ''-'' + (''0'' + match[1]).slice(-2) : text;',
'  }',
'  function filters$() { return $(''#P22_DB_LINK,#P22_AS_OF_DATE,#P22_LEDGER_ID,#P22_COMPANY_SEGMENT''); }',
'  function actionButtons(show) {',
'    byId(''use-existing-snapshot'').toggle(show);',
'    byId(''reload-snapshot'').toggle(show);',
'  }',
'  function runButton(show) { byId(''run-ap-trial-balance'').toggle(show); }',
'  function analysisButton(show) { byId(''analyze-snapshot'').toggle(show); byId(''reconcile-gl-ap'').toggle(show); byId(''analyze-with-ai'').toggle(show); }',
'  function setBusy(on) {',
'    busy = on;',
'    filters$().prop(''disabled'', on);',
'    byId(''run-ap-trial-balance'').prop(''disabled'', on);',
'    byId(''use-existing-snapshot'').prop(''disabled'', on);',
'    byId(''reload-snapshot'').prop(''disabled'', on);',
'    byId(''analyze-snapshot'').prop(''disabled'', on);',
'    byId(''reconcile-gl-ap'').prop(''disabled'', on);',
'    byId(''analyze-with-ai'').prop(''disabled'', on);',
'  }',
'  function stopActivity() {',
'    if (timerId) { clearInterval(timerId); timerId = null; }',
'    if (spinner) { spinner.remove(); spinner = null; }',
'  }',
'  function seconds() { return ((performance.now() - startedAt) / 1000).toFixed(1) + '' s''; }',
'  function startActivity() {',
'    stopActivity();',
'    startedAt = performance.now();',
'    byId(''p22-status-timing'').text(''Elapsed: 0.0 s'');',
'    timerId = setInterval(function () { byId(''p22-status-timing'').text(''Elapsed: '' + seconds()); }, 250);',
'    try { spinner = apex.util.showSpinner(byId(''snapshot-status'')); } catch (ignore) { spinner = null; }',
'  }',
'  function showStatus(kind, title, body, timing) {',
'    byId(''snapshot-status'').show();',
'    var panel$ = byId(''p22-status-panel'');',
'    panel$.removeAttr(''hidden'').removeClass(''p22-status--info p22-status--warning p22-status--success p22-status--error'')',
'      .addClass(''p22-status--'' + kind);',
'    byId(''p22-status-title'').text(title);',
'    byId(''p22-status-body'').text(body || '''');',
'    byId(''p22-status-timing'').text(timing || '''');',
'  }',
'  function hideReport() {',
'    apex.item(''P22_REPORT_READY'').setValue(''N'', null, true);',
'    analysisButton(false);',
'    reportElement().hide();',
'  }',
'  function setRunContext(meta) {',
'    apex.item(''P22_RUN_DB_LINK'').setValue(meta.db_link, null, true);',
'    apex.item(''P22_RUN_AS_OF_DATE'').setValue(meta.as_of_date, null, true);',
'    apex.item(''P22_RUN_LEDGER_ID'').setValue(meta.ledger_id, null, true);',
'    apex.item(''P22_RUN_COMPANY'').setValue(meta.company, null, true);',
'    apex.item(''P22_REPORT_READY'').setValue(''Y'', null, true);',
'  }',
'  function showReport(meta) {',
'    if (Number(meta.row_count) < 1) { actionButtons(false); runButton(false); hideReport(); return; }',
'    setRunContext(meta);',
'    actionButtons(false); runButton(false);',
'    var region$ = reportElement(), r;',
'    if (!region$.length) { throw new Error(''The AP Trial Balance report region is unavailable.''); }',
'    region$.show();',
'    r = reportRegion();',
'    if (r && typeof r.refresh === ''function'') { r.refresh(); }',
'    else { region$.trigger(''apexrefresh''); }',
'    analysisButton(true);',
'  }',
'  function metadataText(meta) {',
'    return ''Generated '' + meta.loaded_on + '' by '' + meta.loaded_by + '' ('' + meta.row_count + '' rows).'';',
'  }',
'  function renderExisting(meta, changed) {',
'    known = meta;',
'    hideReport();',
'    actionButtons(true); runButton(false);',
'    showStatus(changed ? ''warning'' : ''info'', changed ? ''Snapshot changed'' : ''Existing snapshot found'',',
'      (changed ? ''Another user generated a newer snapshot. Review the updated information before choosing again. '' : '''') + metadataText(meta));',
'  }',
'  function params() {',
'    var result = {',
'      db_link: $.trim(apex.item(''P22_DB_LINK'').getValue()).toUpperCase(),',
'      as_of_date: canonicalDate(apex.item(''P22_AS_OF_DATE'').getValue()),',
'      ledger_id: $.trim(apex.item(''P22_LEDGER_ID'').getValue()),',
'      company: $.trim(apex.item(''P22_COMPANY_SEGMENT'').getValue()).toUpperCase()',
'    }, missing = [];',
'    if (!result.db_link) { missing.push(''Database Source''); }',
'    if (!result.as_of_date) { missing.push(''As-of Date''); }',
'    if (!result.ledger_id) { missing.push(''Ledger''); }',
'    if (!result.company) { missing.push(''Company Code''); }',
'    if (missing.length) {',
'      apex.message.showErrors([{type:''error'', location:''page'', message:''Select '' + missing.join('', '') + '' before running.'', unsafe:false}]);',
'      return null;',
'    }',
'    apex.item(''P22_DB_LINK'').setValue(result.db_link, null, true);',
'    apex.item(''P22_COMPANY_SEGMENT'').setValue(result.company, null, true);',
'    apex.message.clearErrors();',
'    return result;',
'  }',
'  function payload(p) { return {x01:p.db_link, x02:p.as_of_date, x03:p.ledger_id, x04:p.company}; }',
'  function requestError(message, preserveExisting) {',
'    stopActivity(); setBusy(false);',
'    actionButtons(!!preserveExisting && !!known);',
'    runButton(!(preserveExisting && known));',
'    showStatus(''error'', preserveExisting ? ''Reload failed'' : ''Request failed'',',
'      message + (preserveExisting ? '' The previous snapshot remains available.'' : ''''));',
'  }',
'  function beginLoad(p, isReload) {',
'    actionButtons(false); runButton(false); hideReport(); setBusy(true);',
'    showStatus(''warning'', isReload ? ''Reloading snapshot'' : ''Generating snapshot'',',
'      (isReload ? ''The existing snapshot is being replaced.'' : ''No existing snapshot was found.'') +',
'      '' Generation normally takes approximately 30-40 seconds.'');',
'    startActivity();',
'    var data = payload(p);',
'    data.x05 = isReload && known ? known.token : '''';',
'    data.x06 = isReload ? ''Y'' : ''N'';',
'    apex.server.process(''P22_LOAD_SNAPSHOT'', data, {dataType:''json''}).then(function (result) {',
'      stopActivity(); setBusy(false);',
'      if (!result || result.ok !== true) { requestError((result && result.message) || ''Unable to generate the snapshot.'', isReload); return; }',
'      if (result.changed === true) { renderExisting(result.snapshot, true); return; }',
'      known = result.snapshot;',
'      if (Number(result.snapshot.row_count) < 1) {',
'        showStatus(''warning'', ''No AP trial balance data found'',',
'          ''No rows matched the selected database source, date, ledger and company code. Verify the ledger/company combination and try again.'',',
'          ''Total: '' + seconds());',
'        showReport(result.snapshot);',
'        return;',
'      }',
'      showStatus(''success'', ''Snapshot generated'', metadataText(result.snapshot), ''Total: '' + seconds());',
'      try { showReport(result.snapshot); } catch (e) { requestError(e.message, false); }',
'    }, function (error) { requestError((error && error.message) || ''Unable to generate the snapshot.'', isReload); });',
'  }',
'  function check() {',
'    if (busy) { return; }',
'    var p = params(); if (!p) { return; }',
'    known = null; actionButtons(false); hideReport(); setBusy(true);',
'    showStatus(''info'', ''Checking snapshot availability'', ''Checking the selected database source, date, ledger and company code.'');',
'    apex.server.process(''P22_CHECK_SNAPSHOT'', payload(p), {dataType:''json''}).then(function (result) {',
'      if (!result || result.ok !== true) { requestError((result && result.message) || ''Unable to check snapshot availability.'', false); return; }',
'      if (result.exists === true) { setBusy(false); renderExisting(result.snapshot, false); }',
'      else { beginLoad(result.snapshot, false); }',
'    }, function (error) { requestError((error && error.message) || ''Unable to check snapshot availability.'', false); });',
'  }',
'  function useExisting() {',
'    if (busy || !known) { return; }',
'    showStatus(''success'', ''Using existing snapshot'', metadataText(known));',
'    try { showReport(known); } catch (e) { requestError(e.message, false); }',
'  }',
'  function recheckAndReload() {',
'    var p = params(); if (!p) { return; }',
'    setBusy(true); actionButtons(false); hideReport();',
'    showStatus(''info'', ''Rechecking snapshot'', ''Confirming that the snapshot has not changed since it was displayed.'');',
'    apex.server.process(''P22_CHECK_SNAPSHOT'', payload(p), {dataType:''json''}).then(function (result) {',
'      if (!result || result.ok !== true) { requestError((result && result.message) || ''Unable to recheck the snapshot.'', true); return; }',
'      if (result.exists === true && known && result.snapshot.token !== known.token) {',
'        setBusy(false); renderExisting(result.snapshot, true); return;',
'      }',
'      beginLoad(result.snapshot, true);',
'    }, function (error) { requestError((error && error.message) || ''Unable to recheck the snapshot.'', true); });',
'  }',
'  function requestReload() {',
'    if (busy || !known) { return; }',
'    apex.message.confirm(''Replace the snapshot '' + metadataText(known), function (ok) { if (ok) { recheckAndReload(); } });',
'  }',
'  function reset() {',
'    if (busy) { return; }',
'    known = null; stopActivity(); actionButtons(false); runButton(true); hideReport();',
'    byId(''p22-status-panel'').attr(''hidden'', ''hidden''); byId(''snapshot-status'').hide();',
'    apex.message.clearErrors();',
'  }',
'  function openAnalysis(pageId) {',
'    if (busy || apex.item(''P22_REPORT_READY'').getValue() !== ''Y'') { return; }',
'    var target = ''ap_analysis_'' + pageId + ''_'' + Date.now(), child = window.open('''', target);',
'    if (!child) { apex.message.showErrors([{type:''error'',location:''page'',message:''Allow pop-ups for this application to open analysis in a new tab.'',unsafe:false}]); return; }',
unistr('    child.document.write(''<title>Opening analysis</title><p style="font-family:sans-serif;padding:1rem">Opening analysis\2026</p>'');'),
'    apex.server.process(''P22_GET_ANALYSIS_URL'', {',
'      x01:String(pageId), x02:apex.item(''P22_RUN_DB_LINK'').getValue(), x03:apex.item(''P22_RUN_AS_OF_DATE'').getValue(),',
'      x04:apex.item(''P22_RUN_LEDGER_ID'').getValue(), x05:apex.item(''P22_RUN_COMPANY'').getValue()',
'    }, {dataType:''json''}).then(function(result){',
'      if (!result || result.ok !== true || !result.url) { child.close(); requestError((result && result.message) || ''Unable to open analysis.'', true); return; }',
'      child.location.replace(result.url);',
'    }, function(error){ child.close(); requestError((error && error.message) || ''Unable to open analysis.'', true); });',
'  }',
'  $(function () {',
'    actionButtons(false); analysisButton(false); runButton(true); hideReport(); byId(''p22-status-panel'').attr(''hidden'', ''hidden''); byId(''snapshot-status'').hide();',
'    filters$().on(''change.p22'', reset);',
'  });',
'  return {check:check, useExisting:useExisting, requestReload:requestReload, reset:reset, openAnalysis:openAnalysis};',
'})(apex.jQuery);'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#ap-trial-balance-ir {display:none;}',
'#use-existing-snapshot,#reload-snapshot,#analyze-snapshot,#reconcile-gl-ap,#analyze-with-ai {display:none;}',
'#snapshot-status {position:relative;min-height:4rem;}',
'.p22-status {border-left:4px solid #6b7280;border-radius:.25rem;padding:.8rem 1rem;background:#f6f7f8;}',
'.p22-status--info {border-left-color:#2563eb;background:#eff6ff;}',
'.p22-status--warning {border-left-color:#d97706;background:#fffbeb;}',
'.p22-status--success {border-left-color:#15803d;background:#f0fdf4;}',
'.p22-status--error {border-left-color:#b91c1c;background:#fef2f2;}',
'#p22-status-title {font-size:1rem;font-weight:700;margin:0 0 .25rem;}',
'#p22-status-body {margin:0;}',
'#p22-status-timing {font-variant-numeric:tabular-nums;font-weight:600;margin-top:.35rem;}',
'.p22-amount-help {margin-top:.65rem;max-width:80rem;}',
'.p22-amount-help summary {cursor:pointer;font-weight:600;color:#1f4f82;}',
'.p22-amount-help dl {display:grid;grid-template-columns:max-content 1fr;gap:.3rem .8rem;margin:.6rem 0 0;}',
'.p22-amount-help dt {font-weight:600;}',
'.p22-amount-help dd {margin:0;}'))
,p_step_template=>4075783602716660119
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(9156329399484443)
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(982078933012278685)
,p_plug_name=>'AP Trial Balance'
,p_static_id=>'ap-trial-balance-ir'
,p_title=>'AP Trial Balance'
,p_region_name=>'ap-trial-balance-ir'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>30
,p_plug_item_display_point=>'ABOVE'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select org_id, entity_id, gl_liab_ccid, gl_liability_code,',
'       open_accounted_amount, open_entered_amount, invoice_num, invoice_id,',
'       invoice_date, invoice_currency_code, invoice_amount, acct_invoice_amount,',
'       supplier_name, supplier_number, vendor_id, vendor_site_id, vendor_site_code,',
'       min_due_date, max_due_date, placeholder_for_reval',
'  from xx_ap_trial_balance_snap',
' where :P22_REPORT_READY = ''Y''',
'   and as_of_date = to_date(:P22_RUN_AS_OF_DATE,''YYYY-MM-DD'')',
'   and ledger_id = to_number(:P22_RUN_LEDGER_ID)',
'   and company_segment = :P22_RUN_COMPANY',
'   and db_link = :P22_RUN_DB_LINK'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P22_REPORT_READY,P22_RUN_DB_LINK,P22_RUN_AS_OF_DATE,P22_RUN_LEDGER_ID,P22_RUN_COMPANY'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'AP Trial Balance'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(982078933012278721)
,p_no_data_found_message=>'The selected snapshot contains no AP trial-balance rows.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>true
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_internal_uid=>895156623912686645
,p_ai_report_hint=>wwv_flow_string.join(wwv_flow_t_varchar2(
'AP Trial Balance invoice-detail rows from the already generated local snapshot selected on Page 22. The snapshot is fixed by database source, as-of date, ledger ID, and company code; this is not a live EBS query.',
'OPEN_ACCOUNTED_AMOUNT is the remaining open balance in ledger functional currency and is credit-positive. OPEN_ENTERED_AMOUNT is the remaining open balance in invoice currency. Never add entered amounts across different invoice currencies.',
'The two open-balance values originate at GL_LIAB_CCID plus ENTITY_ID plus INVOICE_CURRENCY_CODE grain and can repeat across invoice detail rows. Before aggregating either open-balance column, de-duplicate that exact grain. INVOICE_AMOUNT and ACCT_INV'
||'OICE_AMOUNT are original invoice amounts, not remaining balances.',
'Prefer supplier names, supplier numbers, invoice numbers, vendor site codes, and the full GL liability account over hidden technical IDs.'))
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(982078933012277892)
,p_db_column_name=>'ACCT_INVOICE_AMOUNT'
,p_display_order=>100
,p_column_identifier=>'L'
,p_column_label=>'Accounted Invoice Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Original invoice amount accounted in ledger functional currency, including portions subsequently paid. This is not the remaining open balance.'
,p_help_text=>'Original invoice amount converted to the ledger functional currency, including any portion paid after the invoice was created. This is not the remaining open balance.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(982078933012277882)
,p_db_column_name=>'ENTITY_ID'
,p_display_order=>910
,p_column_identifier=>'B'
,p_column_label=>'XLA Entity ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Technical XLA transaction entity identifier. It is part of the de-duplication grain for open balances and is not an operating-unit identifier.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(982078933012277884)
,p_db_column_name=>'GL_LIABILITY_CODE'
,p_display_order=>130
,p_column_identifier=>'D'
,p_column_label=>'GL Liability Account'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Full concatenated GL liability account combination. Use this business-facing value for account filters, grouping, and display instead of GL_LIAB_CCID.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(982078933012277883)
,p_db_column_name=>'GL_LIAB_CCID'
,p_display_order=>920
,p_column_identifier=>'C'
,p_column_label=>'GL Liability CCID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Technical code combination ID for the AP liability account. Prefer GL_LIABILITY_CODE for display; use this ID only in the open-balance de-duplication grain.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(982078933012277891)
,p_db_column_name=>'INVOICE_AMOUNT'
,p_display_order=>90
,p_column_identifier=>'K'
,p_column_label=>'Original Invoice Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Original invoice amount in INVOICE_CURRENCY_CODE, including portions subsequently paid. This is not the remaining open balance.'
,p_help_text=>'Original invoice amount in the invoice currency, including any portion paid after the invoice was created. This is not the remaining open balance.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(982078933012277890)
,p_db_column_name=>'INVOICE_CURRENCY_CODE'
,p_display_order=>80
,p_column_identifier=>'J'
,p_column_label=>'Invoice Currency'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Currency of INVOICE_AMOUNT and OPEN_ENTERED_AMOUNT. Group by this column before totaling entered-currency amounts.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(982078933012277889)
,p_db_column_name=>'INVOICE_DATE'
,p_display_order=>50
,p_column_identifier=>'I'
,p_column_label=>'Invoice Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Date printed on the supplier invoice. This is not the snapshot as-of date or due date.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(982078933012277888)
,p_db_column_name=>'INVOICE_ID'
,p_display_order=>930
,p_column_identifier=>'H'
,p_column_label=>'Invoice ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Technical AP invoice identifier. Prefer INVOICE_NUM for business display and use distinct values only when an exact invoice count is required.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(982078933012277887)
,p_db_column_name=>'INVOICE_NUM'
,p_display_order=>40
,p_column_identifier=>'G'
,p_column_label=>'Invoice Number'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Supplier invoice number. Treat as text for exact or contains searches, even when it looks numeric.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(982078933012277899)
,p_db_column_name=>'MAX_DUE_DATE'
,p_display_order=>70
,p_column_identifier=>'S'
,p_column_label=>'Latest Due Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Latest scheduled payment due date represented by this invoice row. Use for latest-due analysis.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(982078933012277898)
,p_db_column_name=>'MIN_DUE_DATE'
,p_display_order=>60
,p_column_identifier=>'R'
,p_column_label=>'Earliest Due Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Earliest scheduled payment due date represented by this invoice row. Use for earliest-due and overdue analysis.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(982078933012277885)
,p_db_column_name=>'OPEN_ACCOUNTED_AMOUNT'
,p_display_order=>120
,p_column_identifier=>'E'
,p_column_label=>'Open Balance - Ledger Currency'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Remaining open AP balance at the snapshot date in ledger functional currency, credit-positive. This value can repeat; de-duplicate by GL_LIAB_CCID, ENTITY_ID, and INVOICE_CURRENCY_CODE before summing.'
,p_help_text=>'Remaining open balance as of the snapshot date in the ledger functional currency. It is derived from XLA Trial Balance at GL liability account, XLA entity and transaction-currency grain. The value can repeat when more than one report row represents t'
||'he same grain, so de-duplicate that grain before aggregating.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(982078933012277886)
,p_db_column_name=>'OPEN_ENTERED_AMOUNT'
,p_display_order=>110
,p_column_identifier=>'F'
,p_column_label=>'Open Balance - Invoice Currency'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Remaining open AP balance at the snapshot date in invoice or transaction currency. De-duplicate by GL_LIAB_CCID, ENTITY_ID, and INVOICE_CURRENCY_CODE before summing, and never total across different invoice currencies.'
,p_help_text=>'Remaining open balance as of the snapshot date in the invoice or transaction currency. It is derived from XLA Trial Balance at GL liability account, XLA entity and transaction-currency grain. The value can repeat when more than one report row represe'
||'nts the same grain, so de-duplicate that grain before aggregating.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(982078933012277881)
,p_db_column_name=>'ORG_ID'
,p_display_order=>900
,p_column_identifier=>'A'
,p_column_label=>'Org ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Technical Oracle EBS organization identifier carried by the snapshot. It is not the company code and should normally remain hidden.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(982078933012277902)
,p_db_column_name=>'PLACEHOLDER_FOR_REVAL'
,p_display_order=>960
,p_column_identifier=>'V'
,p_column_label=>'Revaluation Placeholder'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Reserved technical numeric field for future revaluation logic. It is not a current business measure and should remain hidden.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(982078933012277893)
,p_db_column_name=>'SUPPLIER_NAME'
,p_display_order=>10
,p_column_identifier=>'M'
,p_column_label=>'Supplier Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Supplier business name. Use contains-style searching and group by this value for supplier comparisons.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(982078933012277894)
,p_db_column_name=>'SUPPLIER_NUMBER'
,p_display_order=>20
,p_column_identifier=>'N'
,p_column_label=>'Supplier Number'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Supplier account number. Use exact matching and do not confuse it with supplier name or vendor ID.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(982078933012277895)
,p_db_column_name=>'VENDOR_ID'
,p_display_order=>940
,p_column_identifier=>'O'
,p_column_label=>'Vendor ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical supplier identifier. Prefer SUPPLIER_NAME or SUPPLIER_NUMBER for business questions.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(982078933012277897)
,p_db_column_name=>'VENDOR_SITE_CODE'
,p_display_order=>30
,p_column_identifier=>'Q'
,p_column_label=>'Vendor Site Code'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Supplier site code associated with the invoice. Use for location or supplier-site questions.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(982078933012277896)
,p_db_column_name=>'VENDOR_SITE_ID'
,p_display_order=>950
,p_column_identifier=>'P'
,p_column_label=>'Vendor Site ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical supplier-site identifier. Prefer VENDOR_SITE_CODE for business questions.'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(982078933012278722)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>1000
,p_report_columns=>'SUPPLIER_NAME:SUPPLIER_NUMBER:VENDOR_SITE_CODE:INVOICE_NUM:INVOICE_DATE:MIN_DUE_DATE:MAX_DUE_DATE:INVOICE_CURRENCY_CODE:INVOICE_AMOUNT:ACCT_INVOICE_AMOUNT:OPEN_ENTERED_AMOUNT:OPEN_ACCOUNTED_AMOUNT:GL_LIABILITY_CODE'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(317992543199413948)
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
 p_id=>wwv_flow_imp.id(982078933012277683)
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
'<p>Select the database source, as-of date, ledger and company code, then click <strong>Run AP Trial Balance</strong>.</p>',
'<p>If a snapshot already exists, review its generation details and choose whether to use it or replace it.</p>',
'<details class="p22-amount-help">',
'  <summary>Amount column definitions</summary>',
'  <dl>',
'    <dt>Original Invoice Amount</dt><dd>Original invoice value in invoice currency, including any portion subsequently paid.</dd>',
'    <dt>Accounted Invoice Amount</dt><dd>Original invoice value converted to the ledger functional currency.</dd>',
'    <dt>Open Balance - Invoice Currency</dt><dd>Balance remaining open at the snapshot date in invoice or transaction currency.</dd>',
'    <dt>Open Balance - Ledger Currency</dt><dd>Balance remaining open at the snapshot date in ledger functional currency.</dd>',
'  </dl>',
'  <p>The open balances come from XLA Trial Balance at liability account, XLA entity and transaction-currency grain. De-duplicate that grain before aggregating repeated detail rows. The same descriptions are available from each amount column''s heading'
||' menu.</p>',
'</details>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(982078933012277684)
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
'<div id="p22-status-panel" class="p22-status p22-status--info" role="status" aria-live="polite" hidden>',
'  <h3 id="p22-status-title"></h3>',
'  <p id="p22-status-body"></p>',
'  <div id="p22-status-timing"></div>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(982078933012277706)
,p_button_sequence=>15
,p_button_plug_id=>wwv_flow_imp.id(982078933012277683)
,p_button_name=>'ANALYZE_SNAPSHOT'
,p_static_id=>'analyze-snapshot'
,p_button_static_id=>'analyze-snapshot'
,p_show_as_disabled=>false
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
 p_id=>wwv_flow_imp.id(982078933012277708)
,p_button_sequence=>17
,p_button_plug_id=>wwv_flow_imp.id(982078933012277683)
,p_button_name=>'ANALYZE_WITH_AI'
,p_static_id=>'analyze-with-ai'
,p_button_static_id=>'analyze-with-ai'
,p_show_as_disabled=>false
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
 p_id=>wwv_flow_imp.id(982078933012277707)
,p_button_sequence=>16
,p_button_plug_id=>wwv_flow_imp.id(982078933012277683)
,p_button_name=>'RECONCILE_GL_AP'
,p_static_id=>'reconcile-gl-ap'
,p_button_static_id=>'reconcile-gl-ap'
,p_show_as_disabled=>false
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'GL/AP Reconciliation'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-balance-scale'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(982078933012277703)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(982078933012277683)
,p_button_name=>'RELOAD_SNAPSHOT'
,p_static_id=>'reload-snapshot'
,p_button_static_id=>'reload-snapshot'
,p_show_as_disabled=>false
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Reload Snapshot'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(982078933012277704)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(982078933012277683)
,p_button_name=>'RESET_PAGE'
,p_static_id=>'reset-page'
,p_button_static_id=>'reset-page'
,p_show_as_disabled=>false
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Reset'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-undo'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(982078933012277701)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(982078933012277683)
,p_button_name=>'RUN_AP_TRIAL_BALANCE'
,p_static_id=>'run-ap-trial-balance'
,p_button_static_id=>'run-ap-trial-balance'
,p_show_as_disabled=>false
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Run AP Trial Balance'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-play'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(982078933012277702)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(982078933012277683)
,p_button_name=>'USE_EXISTING_SNAPSHOT'
,p_static_id=>'use-existing-snapshot'
,p_button_static_id=>'use-existing-snapshot'
,p_show_as_disabled=>false
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
 p_id=>wwv_flow_imp.id(982078933012277782)
,p_name=>'P22_AS_OF_DATE'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(982078933012277683)
,p_item_default=>'select trunc(sysdate) from dual'
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'As-of Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(982078933012277784)
,p_name=>'P22_COMPANY_SEGMENT'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(982078933012277683)
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
 p_id=>wwv_flow_imp.id(982078933012277781)
,p_name=>'P22_DB_LINK'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(982078933012277683)
,p_item_default=>'ADG'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_cHeight=>1
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(982078933012277783)
,p_name=>'P22_LEDGER_ID'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(982078933012277683)
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
 p_id=>wwv_flow_imp.id(982078933012277785)
,p_name=>'P22_REPORT_READY'
,p_item_sequence=>100
,p_item_default=>'N'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(982078933012277787)
,p_name=>'P22_RUN_AS_OF_DATE'
,p_item_sequence=>102
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(982078933012277789)
,p_name=>'P22_RUN_COMPANY'
,p_item_sequence=>104
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(982078933012277786)
,p_name=>'P22_RUN_DB_LINK'
,p_item_sequence=>101
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(982078933012277788)
,p_name=>'P22_RUN_LEDGER_ID'
,p_item_sequence=>103
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(982078933012277993)
,p_name=>'Open Aging Analysis'
,p_static_id=>'open-aging-analysis'
,p_event_sequence=>50
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(982078933012277706)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(982078933012277994)
,p_event_id=>wwv_flow_imp.id(982078933012277993)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p22Controller.openAnalysis(23);')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(982078933012277997)
,p_name=>'Open AI Analysis'
,p_static_id=>'open-ai-analysis'
,p_event_sequence=>70
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(982078933012277708)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(982078933012277998)
,p_event_id=>wwv_flow_imp.id(982078933012277997)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p22Controller.openAnalysis(50);')).to_clob
,p_build_option_id=>wwv_flow_imp.id(1017112543199391948)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(982078933012277995)
,p_name=>'Open GL AP Reconciliation'
,p_static_id=>'open-gl-ap-reconciliation'
,p_event_sequence=>60
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(982078933012277707)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(982078933012277996)
,p_event_id=>wwv_flow_imp.id(982078933012277995)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p22Controller.openAnalysis(24);')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(982078933012277985)
,p_name=>'Reload Snapshot'
,p_static_id=>'reload-snapshot'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(982078933012277703)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(982078933012277986)
,p_event_id=>wwv_flow_imp.id(982078933012277985)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p22Controller.requestReload();')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(982078933012277987)
,p_name=>'Reset Page'
,p_static_id=>'reset-page'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(982078933012277704)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(982078933012277988)
,p_event_id=>wwv_flow_imp.id(982078933012277987)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p22Controller.reset();')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(982078933012277981)
,p_name=>'Run AP Trial Balance'
,p_static_id=>'run-ap-trial-balance'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(982078933012277701)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(982078933012277982)
,p_event_id=>wwv_flow_imp.id(982078933012277981)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p22Controller.check();')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(982078933012277983)
,p_name=>'Use Existing Snapshot'
,p_static_id=>'use-existing-snapshot'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(982078933012277702)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(982078933012277984)
,p_event_id=>wwv_flow_imp.id(982078933012277983)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p22Controller.useExisting();')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(982078933012278081)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Initialize Page 22 State'
,p_static_id=>'initialize-page-22-state'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'  apex_util.set_session_state(''P22_REPORT_READY'',''N'',p_commit=>false);',
'  apex_util.set_session_state(''P22_RUN_DB_LINK'',null,p_commit=>false);',
'  apex_util.set_session_state(''P22_RUN_AS_OF_DATE'',null,p_commit=>false);',
'  apex_util.set_session_state(''P22_RUN_LEDGER_ID'',null,p_commit=>false);',
'  apex_util.set_session_state(''P22_RUN_COMPANY'',null,p_commit=>false);',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>895156623912686005
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(982078933012278082)
,p_process_sequence=>20
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'P22_CHECK_SNAPSHOT'
,p_static_id=>'p22-check-snapshot'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_db_link     varchar2(128) := upper(trim(apex_application.g_x01));',
'  l_date_text   varchar2(30)  := trim(apex_application.g_x02);',
'  l_ledger_text varchar2(30)  := trim(apex_application.g_x03);',
'  l_company     varchar2(25)  := upper(trim(apex_application.g_x04));',
'  l_as_of_date  date;',
'  l_ledger_id   number;',
'  l_row_count   number;',
'  l_loaded_by   varchar2(100);',
'  l_loaded_on   timestamp;',
'  procedure validate_inputs is',
'  begin',
'    if l_db_link not in (''ADG'') then',
'      raise_application_error(-20221,''Select an approved database source.'');',
'    end if;',
'    begin',
'      if regexp_like(l_date_text,''^[0-9]{4}-[0-9]{2}-[0-9]{2}$'',''c'') then',
'        l_as_of_date := to_date(l_date_text,''FXYYYY-MM-DD'');',
'      elsif regexp_like(l_date_text,''^[0-9]{1,2}-[A-Za-z]{3}-[0-9]{4}$'',''c'') then',
'        l_as_of_date := to_date(l_date_text,''FXDD-MON-YYYY'',''NLS_DATE_LANGUAGE=English'');',
'      else',
'        raise value_error;',
'      end if;',
'    exception when others then',
'      raise_application_error(-20222,''Select a valid As-of Date.'');',
'    end;',
'    if not regexp_like(l_ledger_text,''^[0-9]{1,18}$'',''c'') then',
'      raise_application_error(-20223,''Select a valid Ledger.'');',
'    end if;',
'    l_ledger_id := to_number(l_ledger_text);',
'    if l_company is null or not regexp_like(l_company,''^[A-Z0-9_.-]{1,25}$'',''c'') then',
'      raise_application_error(-20224,''Enter a valid Company Code.'');',
'    end if;',
'  end;',
'  procedure write_snapshot(p_exists boolean) is',
'  begin',
'    apex_json.open_object;',
'    apex_json.write(''ok'',true);',
'    apex_json.write(''exists'',p_exists);',
'    apex_json.open_object(''snapshot'');',
'    apex_json.write(''db_link'',l_db_link);',
'    apex_json.write(''as_of_date'',to_char(l_as_of_date,''YYYY-MM-DD''));',
'    apex_json.write(''ledger_id'',to_char(l_ledger_id,''FM99999999999999999990''));',
'    apex_json.write(''company'',l_company);',
'    apex_json.write(''row_count'',nvl(l_row_count,0));',
'    apex_json.write(''loaded_by'',l_loaded_by);',
'    apex_json.write(''loaded_on'',case when l_loaded_on is not null then to_char(l_loaded_on,''DD-MON-YYYY HH24:MI:SS'') end);',
'    apex_json.write(''token'',case when l_loaded_on is not null then to_char(l_loaded_on,''YYYYMMDDHH24MISSFF6'') end);',
'    apex_json.close_object;',
'    apex_json.close_object;',
'  end;',
'begin',
'  validate_inputs;',
'  select count(*), max(loaded_by), max(loaded_on)',
'    into l_row_count, l_loaded_by, l_loaded_on',
'    from xx_ap_trial_balance_snap',
'   where as_of_date = l_as_of_date',
'     and ledger_id = l_ledger_id',
'     and company_segment = l_company',
'     and db_link = l_db_link;',
'  write_snapshot(l_row_count > 0);',
'exception when others then',
'  apex_json.open_object; apex_json.write(''ok'',false);',
'  apex_json.write(''message'',case when sqlcode between -20999 and -20000 then substr(sqlerrm,12)',
'    else ''Unable to check snapshot availability. Check the APEX debug log.'' end);',
'  apex_json.close_object;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>895156623912686006
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(982078933012278084)
,p_process_sequence=>40
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'P22_GET_ANALYSIS_URL'
,p_static_id=>'p22-get-analysis-url'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_page number; l_db_link varchar2(128):=upper(trim(apex_application.g_x02));',
'  l_date varchar2(30):=trim(apex_application.g_x03); l_ledger varchar2(30):=trim(apex_application.g_x04);',
'  l_company varchar2(25):=upper(trim(apex_application.g_x05)); l_items varchar2(4000); l_url varchar2(32767);',
'begin',
'  if apex_application.g_x01 not in (''23'',''24'',''50'') then raise_application_error(-20231,''Invalid analysis page.''); end if;',
'  l_page:=to_number(apex_application.g_x01);',
'  if l_page=50 and apex_application_admin.get_build_option_status(p_application_id=>:APP_ID,p_build_option_name=>''FEATURE_AI'') <> ''INCLUDE'' then',
'    raise_application_error(-20233,''AI analysis is disabled in this environment.'');',
'  end if;',
'  if l_db_link not in (''ADG'')',
'     or not regexp_like(l_date,''^[0-9]{4}-[0-9]{2}-[0-9]{2}$'',''c'')',
'     or not regexp_like(l_ledger,''^[0-9]{1,18}$'',''c'')',
'     or l_company is null or not regexp_like(l_company,''^[A-Z0-9_.-]{1,25}$'',''c'') then',
'    raise_application_error(-20232,''The selected snapshot context is invalid.'');',
'  end if;',
'  l_items:=case when l_page=23 then ''P23_DB_LINK,P23_AS_OF_DATE,P23_LEDGER_ID,P23_COMPANY''',
'                when l_page=24 then ''P24_DB_LINK,P24_AS_OF_DATE,P24_LEDGER_ID,P24_COMPANY''',
'                else ''P50_DB_LINK,P50_PERIOD_NAME,P50_AP_SCOPE_AS_OF_DATE,P50_AP_LEDGER_ID,P50_AP_COMPANY,P50_AP_SOURCE_PAGE,P50_AP_RECON_READY'' end;',
'  l_url:=apex_page.get_url(p_page=>l_page,p_clear_cache=>to_char(l_page),p_items=>l_items,',
'    p_values=>case when l_page=50 then l_db_link||'',''||upper(to_char(to_date(l_date,''YYYY-MM-DD''),''MON-YYYY'',''NLS_DATE_LANGUAGE=English''))||'',''||l_date||'',''||l_ledger||'',''||l_company||'',22,N''',
'                   else l_db_link||'',''||l_date||'',''||l_ledger||'',''||l_company end);',
'  apex_json.open_object; apex_json.write(''ok'',true); apex_json.write(''url'',l_url); apex_json.close_object;',
'exception when others then',
'  apex_json.open_object; apex_json.write(''ok'',false);',
'  apex_json.write(''message'',case when sqlcode between -20999 and -20000 then substr(sqlerrm,12) else ''Unable to prepare the analysis URL. Check the APEX debug log.'' end);',
'  apex_json.close_object;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>895156623912686008
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(982078933012278083)
,p_process_sequence=>30
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'P22_LOAD_SNAPSHOT'
,p_static_id=>'p22-load-snapshot'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_db_link     varchar2(128) := upper(trim(apex_application.g_x01));',
'  l_date_text   varchar2(30)  := trim(apex_application.g_x02);',
'  l_ledger_text varchar2(30)  := trim(apex_application.g_x03);',
'  l_company     varchar2(25)  := upper(trim(apex_application.g_x04));',
'  l_expected_token varchar2(30) := trim(apex_application.g_x05);',
'  l_is_reload   varchar2(1)   := upper(trim(apex_application.g_x06));',
'  l_as_of_date  date;',
'  l_ledger_id   number;',
'  l_row_count   number;',
'  l_actual_count number;',
'  l_loaded_by   varchar2(100);',
'  l_loaded_on   timestamp;',
'  l_current_token varchar2(30);',
'  l_dummy       number;',
'begin',
'  if l_db_link not in (''ADG'') then',
'    raise_application_error(-20221,''Select an approved database source.'');',
'  end if;',
'  begin',
'    if regexp_like(l_date_text,''^[0-9]{4}-[0-9]{2}-[0-9]{2}$'',''c'') then',
'      l_as_of_date := to_date(l_date_text,''FXYYYY-MM-DD'');',
'    elsif regexp_like(l_date_text,''^[0-9]{1,2}-[A-Za-z]{3}-[0-9]{4}$'',''c'') then',
'      l_as_of_date := to_date(l_date_text,''FXDD-MON-YYYY'',''NLS_DATE_LANGUAGE=English'');',
'    else',
'      raise value_error;',
'    end if;',
'  exception when others then',
'    raise_application_error(-20222,''Select a valid As-of Date.'');',
'  end;',
'  if not regexp_like(l_ledger_text,''^[0-9]{1,18}$'',''c'') then',
'    raise_application_error(-20223,''Select a valid Ledger.'');',
'  end if;',
'  l_ledger_id := to_number(l_ledger_text);',
'  if l_company is null or not regexp_like(l_company,''^[A-Z0-9_.-]{1,25}$'',''c'') then',
'    raise_application_error(-20224,''Enter a valid Company Code.'');',
'  end if;',
'  if l_is_reload = ''Y'' and l_expected_token is not null then',
'    begin',
'      insert into xx_ap_trial_balance_lock(as_of_date,ledger_id,company_segment,db_link)',
'      values(l_as_of_date,l_ledger_id,l_company,l_db_link);',
'    exception when dup_val_on_index then null;',
'    end;',
'    select 1 into l_dummy',
'      from xx_ap_trial_balance_lock',
'     where as_of_date = l_as_of_date',
'       and ledger_id = l_ledger_id',
'       and company_segment = l_company',
'       and db_link = l_db_link',
'       for update;',
'    select count(*), max(loaded_by), max(loaded_on)',
'      into l_actual_count, l_loaded_by, l_loaded_on',
'      from xx_ap_trial_balance_snap',
'     where as_of_date = l_as_of_date',
'       and ledger_id = l_ledger_id',
'       and company_segment = l_company',
'       and db_link = l_db_link;',
'    l_current_token := case when l_loaded_on is not null then to_char(l_loaded_on,''YYYYMMDDHH24MISSFF6'') end;',
'    if l_actual_count > 0 and nvl(l_current_token,''-'') <> l_expected_token then',
'      apex_json.open_object; apex_json.write(''ok'',true); apex_json.write(''changed'',true);',
'      apex_json.open_object(''snapshot'');',
'      apex_json.write(''db_link'',l_db_link); apex_json.write(''as_of_date'',to_char(l_as_of_date,''YYYY-MM-DD''));',
'      apex_json.write(''ledger_id'',to_char(l_ledger_id,''FM99999999999999999990'')); apex_json.write(''company'',l_company);',
'      apex_json.write(''row_count'',l_actual_count); apex_json.write(''loaded_by'',l_loaded_by);',
'      apex_json.write(''loaded_on'',to_char(l_loaded_on,''DD-MON-YYYY HH24:MI:SS'')); apex_json.write(''token'',l_current_token);',
'      apex_json.close_object; apex_json.close_object;',
'      commit;',
'      return;',
'    end if;',
'  end if;',
'  xx_ap_trial_balance_pkg.populate_snapshot(',
'    p_ledger_id => l_ledger_id, p_snapshot_date => l_as_of_date,',
'    p_company => l_company, p_db_link => l_db_link,',
'    p_loaded_by => nvl(v(''APP_USER''),user), p_row_count => l_row_count);',
'  select count(*), max(loaded_by), max(loaded_on)',
'    into l_actual_count, l_loaded_by, l_loaded_on',
'    from xx_ap_trial_balance_snap',
'   where as_of_date = l_as_of_date',
'     and ledger_id = l_ledger_id',
'     and company_segment = l_company',
'     and db_link = l_db_link;',
'  if l_actual_count <> nvl(l_row_count,0) then',
'    raise_application_error(-20225,''Snapshot row-count validation failed after loading.'');',
'  end if;',
'  if l_actual_count = 0 then',
'    l_loaded_by := nvl(v(''APP_USER''),user); l_loaded_on := systimestamp;',
'  end if;',
'  apex_json.open_object; apex_json.write(''ok'',true);',
'  apex_json.open_object(''snapshot'');',
'  apex_json.write(''db_link'',l_db_link);',
'  apex_json.write(''as_of_date'',to_char(l_as_of_date,''YYYY-MM-DD''));',
'  apex_json.write(''ledger_id'',to_char(l_ledger_id,''FM99999999999999999990''));',
'  apex_json.write(''company'',l_company); apex_json.write(''row_count'',l_actual_count);',
'  apex_json.write(''loaded_by'',l_loaded_by);',
'  apex_json.write(''loaded_on'',to_char(l_loaded_on,''DD-MON-YYYY HH24:MI:SS''));',
'  apex_json.write(''token'',to_char(l_loaded_on,''YYYYMMDDHH24MISSFF6''));',
'  apex_json.close_object; apex_json.close_object;',
'exception when others then',
'  rollback; apex_json.open_object; apex_json.write(''ok'',false);',
'  apex_json.write(''message'',case when sqlcode between -20999 and -20000 then substr(sqlerrm,12)',
'    else ''Unable to generate the AP Trial Balance snapshot. Check the APEX debug log.'' end);',
'  apex_json.close_object;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>895156623912686007
);
wwv_flow_imp.component_end;
end;
/
