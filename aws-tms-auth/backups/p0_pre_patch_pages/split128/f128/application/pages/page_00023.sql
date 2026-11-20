prompt --application/pages/page_00023
begin
--   Manifest
--     PAGE: 00023
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
 p_id=>23
,p_name=>'AP Snapshot Analysis'
,p_alias=>'AP-SNAPSHOT-ANALYSIS'
,p_step_title=>'AP Snapshot Analysis'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var p23Controller = (function ($) {',
'  ''use strict'';',
'  function byId(id) { return $(''#'' + id); }',
'  function region(id) { try { return apex.region(id); } catch (ignore) { return null; } }',
'  function drill(vendorId, supplierName, supplierNumber, bucket) {',
'    apex.item(''P23_SELECTED_VENDOR_ID'').setValue(vendorId ? String(vendorId) : '''', null, true);',
'    apex.item(''P23_SELECTED_BUCKET'').setValue(bucket || '''', null, true);',
'    var supplierLabel = vendorId ? ((supplierName || ''Supplier'') + (supplierNumber ? '' ('' + supplierNumber + '')'' : '''')) : ''All suppliers'';',
unistr('    byId(''p23-detail-selection'').text(supplierLabel + (bucket && bucket !== ''All'' ? '' \2022 '' + bucket : '' \2022 All aging buckets''));'),
'    byId(''supplier-detail-context'').show();',
'    byId(''supplier-aging-detail'').show();',
'    var r = region(''supplier-aging-detail'');',
'    if (r && typeof r.refresh === ''function'') { r.refresh(); } else { byId(''supplier-aging-detail'').trigger(''apexrefresh''); }',
'    $(''html, body'').animate({scrollTop: byId(''supplier-detail-context'').offset().top - 12}, 200);',
'  }',
'  function drillBucket(bucket) { drill(null, '''', '''', bucket); }',
'  function closeDetail() {',
'    apex.item(''P23_SELECTED_VENDOR_ID'').setValue('''', null, true);',
'    apex.item(''P23_SELECTED_BUCKET'').setValue('''', null, true);',
'    byId(''supplier-detail-context'').hide();',
'    byId(''supplier-aging-detail'').hide();',
'  }',
'  function openAi() {',
'    if (apex.item(''P23_SNAPSHOT_READY'').getValue() !== ''Y'') { return; }',
'    var target = ''ap_aging_ai_'' + Date.now(), child = window.open('''', target);',
'    if (!child) { apex.message.showErrors([{type:''error'',location:''page'',message:''Allow pop-ups to open the AI Analyst in a new tab.'',unsafe:false}]); return; }',
unistr('    child.document.write(''<title>Opening AI Analyst</title><p style="font-family:sans-serif;padding:1rem">Opening AI Analyst\2026</p>'');'),
'    apex.server.process(''P23_GET_AI_URL'', {pageItems:''#P23_DB_LINK,#P23_AS_OF_DATE,#P23_LEDGER_ID,#P23_COMPANY,#P23_SNAPSHOT_READY''}, {dataType:''json''}).then(function(result){',
'      if (!result || result.ok !== true || !result.url) { child.close(); apex.message.showErrors([{type:''error'',location:''page'',message:(result&&result.message)||''Unable to open the AI Analyst.'',unsafe:false}]); return; }',
'      child.location.replace(result.url);',
'    }, function(error){ child.close(); apex.message.showErrors([{type:''error'',location:''page'',message:(error&&error.message)||''Unable to open the AI Analyst.'',unsafe:false}]); });',
'  }',
'  function closePage() {',
'    window.close();',
'    setTimeout(function () { if (!window.closed) { apex.navigation.redirect(apex.item(''P23_BACK_URL'').getValue()); } }, 250);',
'  }',
'  $(function () {',
'    closeDetail();',
'    $(document).on(''click.p23'', ''.p23-aging-drill'', function () { drillBucket($(this).attr(''data-bucket'')); });',
'  });',
'  return {drill:drill, drillBucket:drillBucket, openAi:openAi, closeDetail:closeDetail, closePage:closePage};',
'})(apex.jQuery);'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#supplier-detail-context,#supplier-aging-detail{display:none;}',
'.p23-context-note{margin:.25rem 0 0;color:var(--ut-component-text-muted-color,#5f6368);}',
'.p23-kpis{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:1rem;padding:.25rem;}',
'.p23-kpi{border:1px solid var(--ut-component-border-color,#d9dce1);border-radius:.5rem;padding:1rem;background:var(--ut-component-background-color,#fff);}',
'.p23-kpi-label{font-size:.78rem;text-transform:uppercase;letter-spacing:.04em;color:#5f6368;}',
'.p23-kpi-value{font-size:1.55rem;font-weight:700;font-variant-numeric:tabular-nums;margin-top:.3rem;}',
'.p23-aging-row{display:grid;grid-template-columns:7rem 1fr 10rem;gap:.75rem;align-items:center;min-width:32rem;}',
'.p23-aging-track{height:1.1rem;background:#eef0f3;border-radius:.25rem;overflow:hidden;}',
'.p23-aging-bar{display:block;height:100%;min-width:2px;background:#2563eb;border-radius:.25rem;}',
'.p23-aging-amount{text-align:right;font-variant-numeric:tabular-nums;font-weight:600;}',
'.p23-aging-drill{display:block;width:100%;border:0;background:transparent;padding:.45rem .25rem;cursor:pointer;text-align:inherit;border-radius:.3rem;}',
'.p23-aging-drill:hover,.p23-aging-drill:focus{background:#eff6ff;outline:2px solid transparent;}',
'.p23-detail-banner{display:flex;align-items:center;justify-content:space-between;gap:1rem;padding:.35rem 0;}',
'#p23-detail-selection{font-weight:600;}',
'@media(max-width:800px){.p23-kpis{grid-template-columns:repeat(2,minmax(0,1fr));}}'))
,p_step_template=>4075783602716660119
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(18558063129193156)
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(992480666741986397)
,p_name=>'Aging Distribution'
,p_static_id=>'aging-distribution'
,p_title=>'Aging Distribution'
,p_region_name=>'aging-distribution'
,p_template=>4075786578761660127
,p_display_sequence=>30
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--noBorders'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'with a as (',
'  select aging_bucket, aging_bucket_sort, sum(nvl(acct_invoice_amount,0)) amount',
'    from table(xx_ap_trial_balance_pkg.get_ap_aging_by_year(',
'      to_number(:P23_LEDGER_ID), to_date(:P23_AS_OF_DATE,''YYYY-MM-DD''),',
'      :P23_COMPANY, :P23_DB_LINK, to_date(:P23_AS_OF_DATE,''YYYY-MM-DD'')))',
'   where :P23_SNAPSHOT_READY = ''Y''',
'   group by aging_bucket, aging_bucket_sort',
'), b as (',
'  select a.*, max(abs(amount)) over () max_amount from a',
')',
'select ''<button type="button" class="p23-aging-drill" data-bucket="'' || apex_escape.html_attribute(aging_bucket) || ''"><span class="p23-aging-row"><span>'' || apex_escape.html(aging_bucket) || ''</span>'' ||',
'       ''<span class="p23-aging-track"><span class="p23-aging-bar" style="width:'' ||',
'       to_char(case when max_amount = 0 then 0 else round(abs(amount) / max_amount * 100,2) end,''FM990D00'',''NLS_NUMERIC_CHARACTERS=''''.,'''''') || ''%"></span></span>'' ||',
'       ''<span class="p23-aging-amount">'' || to_char(amount,''FM999G999G999G990D00'') || ''</span></span></button>'' aging_bar',
'  from b',
' order by aging_bucket_sort'))
,p_display_when_condition=>'P23_SNAPSHOT_READY'
,p_display_when_cond2=>'Y'
,p_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P23_DB_LINK,P23_AS_OF_DATE,P23_LEDGER_ID,P23_COMPANY,P23_SNAPSHOT_READY'
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
 p_id=>wwv_flow_imp.id(992480666741986415)
,p_query_column_id=>1
,p_column_alias=>'AGING_BAR'
,p_column_display_sequence=>10
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(327394276929123661)
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
 p_id=>wwv_flow_imp.id(992480666741986395)
,p_plug_name=>'Snapshot Context'
,p_static_id=>'snapshot-analysis-context'
,p_title=>'Snapshot Context'
,p_region_name=>'snapshot-analysis-context'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>'<p class="p23-context-note">All amounts and aging buckets are calculated from the selected local AP snapshot. The snapshot date is also used as the aging date.</p>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(992480666741986396)
,p_name=>'Snapshot KPIs'
,p_static_id=>'snapshot-kpis'
,p_title=>'Snapshot Summary'
,p_region_name=>'snapshot-kpis'
,p_template=>4075786578761660127
,p_display_sequence=>20
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#:t-Report--noBorders'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'with s as (',
'  select *',
'    from table(xx_ap_trial_balance_pkg.get_ap_aging_by_supplier(',
'      to_number(:P23_LEDGER_ID), to_date(:P23_AS_OF_DATE,''YYYY-MM-DD''),',
'      :P23_COMPANY, :P23_DB_LINK, to_date(:P23_AS_OF_DATE,''YYYY-MM-DD'')))',
'   where :P23_SNAPSHOT_READY = ''Y''',
'), k as (',
'  select count(*) supplier_count, nvl(sum(invoice_count),0) invoice_count,',
'         nvl(sum(total_amount),0) total_amount,',
'         nvl(sum(year1_amount + year2_amount + year3plus_amount),0) overdue_amount',
'    from s',
')',
'select ''<div class="p23-kpis">'' ||',
'       ''<div class="p23-kpi"><div class="p23-kpi-label">Suppliers</div><div class="p23-kpi-value">'' || to_char(supplier_count,''FM999G999G990'') || ''</div></div>'' ||',
'       ''<div class="p23-kpi"><div class="p23-kpi-label">Invoices</div><div class="p23-kpi-value">'' || to_char(invoice_count,''FM999G999G990'') || ''</div></div>'' ||',
'       ''<div class="p23-kpi"><div class="p23-kpi-label">Accounted Amount</div><div class="p23-kpi-value">'' || to_char(total_amount,''FM999G999G999G990D00'') || ''</div></div>'' ||',
'       ''<div class="p23-kpi"><div class="p23-kpi-label">Prior-Year Aging</div><div class="p23-kpi-value">'' || to_char(overdue_amount,''FM999G999G999G990D00'') || ''</div></div>'' ||',
'       ''</div>'' kpi_html',
'  from k'))
,p_display_when_condition=>'P23_SNAPSHOT_READY'
,p_display_when_cond2=>'Y'
,p_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P23_DB_LINK,P23_AS_OF_DATE,P23_LEDGER_ID,P23_COMPANY,P23_SNAPSHOT_READY'
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
 p_id=>wwv_flow_imp.id(992480666741986414)
,p_query_column_id=>1
,p_column_alias=>'KPI_HTML'
,p_column_display_sequence=>10
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(992480666741986400)
,p_plug_name=>'Invoice Aging Detail'
,p_static_id=>'supplier-aging-detail'
,p_title=>'Invoice Aging Detail'
,p_region_name=>'supplier-aging-detail'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>60
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select invoice_num, invoice_date, min_due_date, max_due_date, aging_bucket, days_overdue,',
'       gl_liability_code, invoice_amount, acct_invoice_amount, open_accounted_amount,',
'       supplier_name, supplier_number, invoice_id, vendor_id',
'  from table(xx_ap_trial_balance_pkg.get_ap_aging_by_year(',
'    to_number(:P23_LEDGER_ID), to_date(:P23_AS_OF_DATE,''YYYY-MM-DD''),',
'    :P23_COMPANY, :P23_DB_LINK, to_date(:P23_AS_OF_DATE,''YYYY-MM-DD'')))',
' where :P23_SNAPSHOT_READY = ''Y''',
'   and (:P23_SELECTED_VENDOR_ID is null or vendor_id = to_number(:P23_SELECTED_VENDOR_ID))',
'   and (:P23_SELECTED_BUCKET in (''All'','''') or aging_bucket = :P23_SELECTED_BUCKET)'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P23_DB_LINK,P23_AS_OF_DATE,P23_LEDGER_ID,P23_COMPANY,P23_SNAPSHOT_READY,P23_SELECTED_VENDOR_ID,P23_SELECTED_BUCKET'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P23_SNAPSHOT_READY'
,p_plug_display_when_cond2=>'Y'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Invoice Aging Detail'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(992480666741986444)
,p_no_data_found_message=>'No invoices match the selected supplier and aging bucket.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>true
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_internal_uid=>896156623912685650
,p_ai_report_hint=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Invoice-level drilldown for the selected local AP snapshot, optionally filtered by the supplier and aging bucket chosen on Page 23.',
'AGING_BUCKET and DAYS_OVERDUE are calculated as of the snapshot date using the package aging rules. OPEN_ACCOUNTED_AMOUNT is the remaining balance in ledger functional currency; INVOICE_AMOUNT is original entered currency and ACCT_INVOICE_AMOUNT is o'
||'riginal ledger-currency amount.',
'Prefer supplier and invoice business identifiers over hidden IDs. Do not add original invoice amounts to open balances or describe original amounts as outstanding.'))
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992480666741986522)
,p_db_column_name=>'ACCT_INVOICE_AMOUNT'
,p_display_order=>90
,p_column_identifier=>'I'
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
 p_id=>wwv_flow_imp.id(992480666741986518)
,p_db_column_name=>'AGING_BUCKET'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Aging Bucket'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Package-defined aging classification as of the snapshot date: Current, 1 Year, 2 Years, 3+ Years, or Unknown.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992480666741986519)
,p_db_column_name=>'DAYS_OVERDUE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Days Overdue'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G990'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Calendar days overdue as of the selected snapshot date. Larger positive values are older; Current invoices are not overdue.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992480666741986520)
,p_db_column_name=>'GL_LIABILITY_CODE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'GL Liability Account'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Full concatenated GL liability account combination associated with the invoice.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992480666741986521)
,p_db_column_name=>'INVOICE_AMOUNT'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Original Invoice Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Original invoice value in invoice currency, including any portion subsequently paid. It is not the outstanding amount.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992480666741986515)
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
,p_ai_column_hint=>'Date printed on the supplier invoice; this is not the due date or snapshot date.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992480666741986526)
,p_db_column_name=>'INVOICE_ID'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Invoice ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical AP invoice identifier. Prefer INVOICE_NUM in business-facing output.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992480666741986514)
,p_db_column_name=>'INVOICE_NUM'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Invoice Number'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Supplier invoice number. Treat as text for exact or contains searches, even when numeric-looking.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992480666741986517)
,p_db_column_name=>'MAX_DUE_DATE'
,p_display_order=>40
,p_column_identifier=>'D'
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
 p_id=>wwv_flow_imp.id(992480666741986516)
,p_db_column_name=>'MIN_DUE_DATE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Earliest Due Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Earliest scheduled payment due date represented by this invoice. Aging is based on the package due-date rules.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992480666741986523)
,p_db_column_name=>'OPEN_ACCOUNTED_AMOUNT'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Open Accounted Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Remaining open AP balance at the snapshot date in ledger functional currency, credit-positive. Use this for aging exposure.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992480666741986524)
,p_db_column_name=>'SUPPLIER_NAME'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Supplier Name'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Supplier business name retained as hidden drilldown context.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992480666741986525)
,p_db_column_name=>'SUPPLIER_NUMBER'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Supplier Number'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Supplier account number retained as hidden drilldown context.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992480666741986527)
,p_db_column_name=>'VENDOR_ID'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Vendor ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical supplier identifier used for drilldown. Prefer SUPPLIER_NAME or SUPPLIER_NUMBER.'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(992480666741986445)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'INVOICE_NUM:INVOICE_DATE:MIN_DUE_DATE:MAX_DUE_DATE:AGING_BUCKET:DAYS_OVERDUE:GL_LIABILITY_CODE:INVOICE_AMOUNT:ACCT_INVOICE_AMOUNT:OPEN_ACCOUNTED_AMOUNT'
,p_sort_column_1=>'MAX_DUE_DATE'
,p_sort_direction_1=>'ASC'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(992480666741986398)
,p_plug_name=>'Supplier Aging Summary'
,p_static_id=>'supplier-aging-summary'
,p_title=>'Supplier Aging Summary'
,p_region_name=>'supplier-aging-summary'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>40
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select vendor_id, supplier_name, supplier_number, current_amount, year1_amount,',
'       year2_amount, year3plus_amount, unknown_amount, total_amount, invoice_count',
'  from table(xx_ap_trial_balance_pkg.get_ap_aging_by_supplier(',
'    to_number(:P23_LEDGER_ID), to_date(:P23_AS_OF_DATE,''YYYY-MM-DD''),',
'    :P23_COMPANY, :P23_DB_LINK, to_date(:P23_AS_OF_DATE,''YYYY-MM-DD'')))',
' where :P23_SNAPSHOT_READY = ''Y'''))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P23_DB_LINK,P23_AS_OF_DATE,P23_LEDGER_ID,P23_COMPANY,P23_SNAPSHOT_READY'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P23_SNAPSHOT_READY'
,p_plug_display_when_cond2=>'Y'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Supplier Aging Summary'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(992480666741986434)
,p_no_data_found_message=>'No supplier aging rows are available for this snapshot.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>true
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_internal_uid=>896156623912685640
,p_ai_report_hint=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Supplier aging summary for the selected local AP snapshot. Each row is one supplier. The package calculates every bucket and TOTAL_AMOUNT from ACCT_INVOICE_AMOUNT, the original accounted invoice value in ledger functional currency.',
'Use the package-defined buckets exactly: Current means not overdue at the selected as-of date; 1 Year means overdue within the first yearly band; 2 Years means the second yearly band; 3+ Years means three or more years overdue; Unknown means no usabl'
||'e due date.',
'TOTAL_AMOUNT is the supplier total across the bucket columns. INVOICE_COUNT is the number of snapshot rows represented. These aging measures are original accounted invoice values, not remaining open balances and not entered-currency amounts.'))
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992480666741986497)
,p_db_column_name=>'CURRENT_AMOUNT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Current'
,p_column_link=>'javascript:p23Controller.drill(#VENDOR_ID#,''#SUPPLIER_NAME!JS#'',''#SUPPLIER_NUMBER!JS#'',''Current'');'
,p_column_linktext=>'#CURRENT_AMOUNT#'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Sum of original accounted invoice amounts in ledger functional currency for rows classified Current by the package as of the selected snapshot date. This is not remaining open balance.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992480666741986503)
,p_db_column_name=>'INVOICE_COUNT'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Invoices'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G990'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Number of snapshot invoice rows represented for this supplier, as returned by the existing package aggregation.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992480666741986495)
,p_db_column_name=>'SUPPLIER_NAME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Supplier Name'
,p_column_link=>'javascript:p23Controller.drill(#VENDOR_ID#,''#SUPPLIER_NAME!JS#'',''#SUPPLIER_NUMBER!JS#'',''All'');'
,p_column_linktext=>'#SUPPLIER_NAME#'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Supplier business name. Each summary row represents one supplier; use this value for supplier comparisons and contains-style searching.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992480666741986496)
,p_db_column_name=>'SUPPLIER_NUMBER'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Supplier Number'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Supplier account number. Use exact matching and do not confuse it with supplier name or vendor ID.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992480666741986502)
,p_db_column_name=>'TOTAL_AMOUNT'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Total'
,p_column_link=>'javascript:p23Controller.drill(#VENDOR_ID#,''#SUPPLIER_NAME!JS#'',''#SUPPLIER_NUMBER!JS#'',''All'');'
,p_column_linktext=>'#TOTAL_AMOUNT#'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Total original accounted invoice amount for this supplier in ledger functional currency, equal to the sum of the displayed aging-bucket amounts. It is not remaining open balance.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992480666741986501)
,p_db_column_name=>'UNKNOWN_AMOUNT'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Unknown'
,p_column_link=>'javascript:p23Controller.drill(#VENDOR_ID#,''#SUPPLIER_NAME!JS#'',''#SUPPLIER_NUMBER!JS#'',''Unknown'');'
,p_column_linktext=>'#UNKNOWN_AMOUNT#'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Sum of original accounted invoice amounts in ledger functional currency for rows without a usable due date. This is not remaining open balance; do not assign these rows to another bucket.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992480666741986494)
,p_db_column_name=>'VENDOR_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Vendor ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical supplier identifier used for drilldown. Prefer SUPPLIER_NAME or SUPPLIER_NUMBER in business-facing output.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992480666741986498)
,p_db_column_name=>'YEAR1_AMOUNT'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'1 Year'
,p_column_link=>'javascript:p23Controller.drill(#VENDOR_ID#,''#SUPPLIER_NAME!JS#'',''#SUPPLIER_NUMBER!JS#'',''1 Year'');'
,p_column_linktext=>'#YEAR1_AMOUNT#'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Sum of original accounted invoice amounts in ledger functional currency in the package-defined 1 Year overdue bucket. This is not remaining open balance.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992480666741986499)
,p_db_column_name=>'YEAR2_AMOUNT'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'2 Years'
,p_column_link=>'javascript:p23Controller.drill(#VENDOR_ID#,''#SUPPLIER_NAME!JS#'',''#SUPPLIER_NUMBER!JS#'',''2 Years'');'
,p_column_linktext=>'#YEAR2_AMOUNT#'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Sum of original accounted invoice amounts in ledger functional currency in the package-defined 2 Years overdue bucket. This is not remaining open balance.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992480666741986500)
,p_db_column_name=>'YEAR3PLUS_AMOUNT'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'3+ Years'
,p_column_link=>'javascript:p23Controller.drill(#VENDOR_ID#,''#SUPPLIER_NAME!JS#'',''#SUPPLIER_NUMBER!JS#'',''3+ Years'');'
,p_column_linktext=>'#YEAR3PLUS_AMOUNT#'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Sum of original accounted invoice amounts in ledger functional currency in the package-defined 3+ Years overdue bucket. This is not remaining open balance.'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(992480666741986435)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SUPPLIER_NAME:SUPPLIER_NUMBER:CURRENT_AMOUNT:YEAR1_AMOUNT:YEAR2_AMOUNT:YEAR3PLUS_AMOUNT:UNKNOWN_AMOUNT:TOTAL_AMOUNT:INVOICE_COUNT'
,p_sort_column_1=>'TOTAL_AMOUNT'
,p_sort_direction_1=>'DESC'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(992480666741986399)
,p_plug_name=>'Supplier Detail Context'
,p_static_id=>'supplier-detail-context'
,p_title=>'Selected Supplier'
,p_region_name=>'supplier-detail-context'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>50
,p_location=>null
,p_plug_source=>'<div class="p23-detail-banner"><span id="p23-detail-selection"></span></div>'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P23_SNAPSHOT_READY'
,p_plug_display_when_cond2=>'Y'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(992480666741986596)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(992480666741986395)
,p_button_name=>'ANALYZE_AGING_WITH_AI'
,p_static_id=>'analyze-aging-with-ai'
,p_button_static_id=>'analyze-aging-with-ai'
,p_show_as_disabled=>false
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Analyze Aging with AI'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P23_SNAPSHOT_READY'
,p_button_condition2=>'Y'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-sparkles'
,p_required_patch=>wwv_flow_imp.id(1026514276929100661)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(992480666741986595)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(992480666741986399)
,p_button_name=>'CLOSE_DETAIL'
,p_static_id=>'close-detail'
,p_button_static_id=>'close-detail'
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
 p_id=>wwv_flow_imp.id(992480666741986594)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(992480666741986395)
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
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(992480666741986695)
,p_name=>'P23_AS_OF_DATE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(992480666741986395)
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
 p_id=>wwv_flow_imp.id(992480666741986704)
,p_name=>'P23_BACK_URL'
,p_item_sequence=>130
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(992480666741986697)
,p_name=>'P23_COMPANY'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(992480666741986395)
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
 p_id=>wwv_flow_imp.id(992480666741986694)
,p_name=>'P23_DB_LINK'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(992480666741986395)
,p_item_default=>'ADG'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(992480666741986699)
,p_name=>'P23_GENERATED_BY'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(992480666741986395)
,p_prompt=>'Generated By'
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
 p_id=>wwv_flow_imp.id(992480666741986698)
,p_name=>'P23_GENERATED_ON'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(992480666741986395)
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
 p_id=>wwv_flow_imp.id(992480666741986696)
,p_name=>'P23_LEDGER_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(992480666741986395)
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
 p_id=>wwv_flow_imp.id(992480666741986700)
,p_name=>'P23_ROW_COUNT'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(992480666741986395)
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
 p_id=>wwv_flow_imp.id(992480666741986703)
,p_name=>'P23_SELECTED_BUCKET'
,p_item_sequence=>120
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(992480666741986702)
,p_name=>'P23_SELECTED_VENDOR_ID'
,p_item_sequence=>110
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(992480666741986701)
,p_name=>'P23_SNAPSHOT_READY'
,p_item_sequence=>100
,p_item_default=>'N'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(992480666741986798)
,p_name=>'Analyze Aging with AI'
,p_static_id=>'analyze-aging-with-ai'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(992480666741986596)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_required_patch=>wwv_flow_imp.id(1026514276929100661)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(992480666741986799)
,p_event_id=>wwv_flow_imp.id(992480666741986798)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p23Controller.openAi();')).to_clob
,p_build_option_id=>wwv_flow_imp.id(1026514276929100661)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(992480666741986796)
,p_name=>'Close Detail'
,p_static_id=>'close-detail'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(992480666741986595)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(992480666741986797)
,p_event_id=>wwv_flow_imp.id(992480666741986796)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p23Controller.closeDetail();')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(992480666741986794)
,p_name=>'Close Page'
,p_static_id=>'close-page'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(992480666741986594)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(992480666741986795)
,p_event_id=>wwv_flow_imp.id(992480666741986794)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p23Controller.closePage();')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(992480666741986895)
,p_process_sequence=>20
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'P23_GET_AI_URL'
,p_static_id=>'p23-get-ai-url'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare l_date date; l_url varchar2(32767);',
'begin',
'  if :P23_SNAPSHOT_READY <> ''Y'' or :P23_DB_LINK not in (''ADG'')',
'     or not regexp_like(:P23_AS_OF_DATE,''^[0-9]{4}-[0-9]{2}-[0-9]{2}$'',''c'')',
'     or not regexp_like(:P23_LEDGER_ID,''^[0-9]{1,18}$'',''c'')',
'     or not regexp_like(:P23_COMPANY,''^[A-Z0-9_.-]{1,25}$'',''c'') then raise_application_error(-20241,''Invalid aging-analysis context.''); end if;',
'  l_date:=to_date(:P23_AS_OF_DATE,''FXYYYY-MM-DD'');',
'  l_url:=apex_page.get_url(p_page=>50,p_clear_cache=>''50'',',
'    p_items=>''P50_DB_LINK,P50_PERIOD_NAME,P50_AP_SCOPE_AS_OF_DATE,P50_AP_LEDGER_ID,P50_AP_COMPANY,P50_AP_SOURCE_PAGE,P50_AP_RECON_READY'',',
'    p_values=>:P23_DB_LINK||'',''||upper(to_char(l_date,''MON-YYYY'',''NLS_DATE_LANGUAGE=English''))||'',''||:P23_AS_OF_DATE||'',''||:P23_LEDGER_ID||'',''||:P23_COMPANY||'',23,N'');',
'  apex_json.open_object; apex_json.write(''ok'',true); apex_json.write(''url'',l_url); apex_json.close_object;',
'exception when others then apex_json.open_object; apex_json.write(''ok'',false); apex_json.write(''message'',case when sqlcode between -20999 and -20000 then substr(sqlerrm,12) else ''Unable to prepare the AI Analyst URL.'' end); apex_json.close_object;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_required_patch=>wwv_flow_imp.id(1026514276929100661)
,p_internal_uid=>896156623912686001
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(992480666741986894)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Validate Snapshot Context'
,p_static_id=>'validate-snapshot-context'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_db_link varchar2(128) := upper(trim(:P23_DB_LINK));',
'  l_date_text varchar2(30) := trim(:P23_AS_OF_DATE);',
'  l_ledger_text varchar2(30) := trim(:P23_LEDGER_ID);',
'  l_company varchar2(25) := upper(trim(:P23_COMPANY));',
'  l_as_of_date date;',
'  l_count number;',
'  l_loaded_by varchar2(100);',
'  l_loaded_on timestamp;',
'begin',
'  :P23_BACK_URL := apex_page.get_url(p_page=>22,p_clear_cache=>''22'');',
'  :P23_SNAPSHOT_READY := ''N'';',
'  :P23_GENERATED_ON := null; :P23_GENERATED_BY := null; :P23_ROW_COUNT := null;',
'  if l_db_link not in (''ADG'')',
'     or not regexp_like(l_date_text,''^[0-9]{4}-[0-9]{2}-[0-9]{2}$'',''c'')',
'     or not regexp_like(l_ledger_text,''^[0-9]{1,18}$'',''c'')',
'     or l_company is null or not regexp_like(l_company,''^[A-Z0-9_.-]{1,25}$'',''c'') then',
'    apex_error.add_error(p_message=>''Select a valid snapshot on Page 22 before opening analysis.'',p_display_location=>apex_error.c_inline_in_notification);',
'    return;',
'  end if;',
'  begin l_as_of_date := to_date(l_date_text,''FXYYYY-MM-DD'');',
'  exception when others then',
'    apex_error.add_error(p_message=>''Select a valid snapshot date on Page 22 before opening analysis.'',p_display_location=>apex_error.c_inline_in_notification);',
'    return;',
'  end;',
'  :P23_DB_LINK := l_db_link; :P23_COMPANY := l_company;',
'  select count(*), max(loaded_by), max(loaded_on)',
'    into l_count, l_loaded_by, l_loaded_on',
'    from xx_ap_trial_balance_snap',
'   where db_link = l_db_link and as_of_date = l_as_of_date',
'     and ledger_id = to_number(l_ledger_text) and company_segment = l_company;',
'  :P23_ROW_COUNT := to_char(l_count,''FM999G999G999G990'');',
'  if l_count > 0 then',
'    :P23_SNAPSHOT_READY := ''Y'';',
'    :P23_GENERATED_BY := l_loaded_by;',
'    :P23_GENERATED_ON := to_char(l_loaded_on,''DD-MON-YYYY HH24:MI:SS'');',
'  else',
'    apex_error.add_error(p_message=>''No snapshot is available for this database source, date, ledger and company. Return to Page 22 to generate it.'',p_display_location=>apex_error.c_inline_in_notification);',
'  end if;',
'exception when others then',
'  :P23_SNAPSHOT_READY := ''N'';',
'  apex_error.add_error(p_message=>''Unable to validate the selected snapshot. Check the APEX debug log.'',p_display_location=>apex_error.c_inline_in_notification);',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>896156623912686000
);
wwv_flow_imp.component_end;
end;
/
