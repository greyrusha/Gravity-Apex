prompt --application/pages/page_00011
begin
--   Manifest
--     PAGE: 00011
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
 p_id=>11
,p_name=>'GL Unposted Journals'
,p_alias=>'GL-UNPOSTED-JOURNALS'
,p_step_title=>'GL Unposted Journals'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.xxme-status {',
'    display: inline-block;',
'    min-width: 105px;',
'    padding: 4px 10px;',
'    border-radius: 12px;',
'    color: #fff;',
'    font-size: 0.75rem;',
'    font-weight: 700;',
'    line-height: 1.2;',
'    text-align: center;',
'    white-space: nowrap;',
'    letter-spacing: 0.02em;',
'}',
'',
'.xxme-status-RED {',
'    background-color: #c62828;',
'}',
'',
'.xxme-status-AMBER {',
'    background-color: #d98200;',
'}',
'',
'.xxme-status-GREEN {',
'    background-color: #2e7d32;',
'}',
'',
'.xxme-status-INFORMATIONAL {',
'    background-color: #287c96;',
'}'))
,p_step_template=>4075783602716660119
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(18558063129193156)
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(217573855982232032)
,p_plug_name=>'Breadcrumb'
,p_static_id=>'breadcrumb'
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
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(215802773311070973)
,p_plug_name=>'Filters'
,p_static_id=>'filters'
,p_title=>'Filters'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(327394276929111661)
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
 p_id=>wwv_flow_imp.id(203866066879296946)
,p_plug_name=>'Unposted Journals'
,p_static_id=>'unposted-journals'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>20
,p_plug_item_display_point=>'ABOVE'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ledger_id,',
'       ledger_name,',
'       period_name,',
'       je_header_id,',
'       je_batch_id,',
'       batch_name,',
'       journal_name,',
'       journal_source,',
'       journal_category,',
'       effective_date,',
'       currency_code,',
'       journal_entered_dr,',
'       journal_entered_cr,',
'       ledger_currency_code,',
'       journal_accounted_dr,',
'       journal_accounted_cr,',
'       ABS(NVL(journal_accounted_dr, 0)',
'         - NVL(journal_accounted_cr, 0)) AS accounted_difference,',
'       balance_type,',
'       journal_description,',
'       batch_description,',
'       batch_balance_status,',
'       severity,',
'       refresh_timestamp',
'FROM   TABLE(',
'           xxme_gl_unposted_pkg.get_journals(:P11_PERIOD_NAME, :P11_DB_LINK)',
'       )',
'ORDER BY ledger_id,',
'         effective_date,',
'         batch_name,',
'         journal_name'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P11_PERIOD_NAME,P11_DB_LINK'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#EEEEEE'
,p_prn_header_font_color=>'#000000'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'bold'
,p_prn_header_font_size=>'10'
,p_prn_body_bg_color=>'#FFFFFF'
,p_prn_body_font_color=>'#000000'
,p_prn_body_font_family=>'Helvetica'
,p_prn_body_font_weight=>'normal'
,p_prn_body_font_size=>'10'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(203866183879296947)
,p_no_data_found_message=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="t-Alert t-Alert--success t-Alert--horizontal">',
'  <div class="t-Alert-wrap">',
'    <div class="t-Alert-content">',
'      <div class="t-Alert-title">No unposted journals found</div>',
'      <div class="t-Alert-body">',
'        No unposted GL journals were found for the selected period and approved ledger scope.',
'      </div>',
'    </div>',
'  </div>',
'</div>'))
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>true
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_internal_uid=>17490962108304104
,p_ai_search_mode=>'A'
,p_ai_report_hint=>wwv_flow_string.join(wwv_flow_t_varchar2(
'This is a trusted, read-only Oracle EBS General Ledger report containing one',
'row per unposted journal header for the selected accounting period. Scope is',
'limited to ledger 1003 TEREX US, ledger 5001 TEREX UK 120, and ledger 10001',
'TEREX CH.',
'',
'Treat natural-language questions as requests to modify the current Interactive',
'Report. For requests containing how many, which, show, find, list, compare,',
'highest, lowest, oldest, newest, largest, or smallest, apply the relevant exact',
'filters, sorting, control break, grouping, aggregation, or highlighting. Do not',
unistr('refuse because the request is phrased as a question. For example, \201CHow many'),
unistr('unposted journals from Payables in TEREX US?\201D means filter LEDGER_NAME to TEREX'),
'US and JOURNAL_SOURCE to Payables; the filtered row count is the answer.',
'',
'Each row is one distinct unposted journal header. Count journals by report rows',
'or distinct JE_HEADER_ID. Count batches by distinct JE_BATCH_ID, because one',
'batch may contain multiple journals. BATCH_BALANCE_STATUS repeats on every',
'journal in a batch; do not count an out-of-balance batch once per journal.',
'',
'Entered debit and credit amounts use CURRENCY_CODE. Accounted debit and credit',
'amounts use LEDGER_CURRENCY_CODE. Never add entered amounts across different',
'CURRENCY_CODE values and never combine amounts expressed in different',
'currencies. ACCOUNTED_DIFFERENCE is the absolute difference between accounted',
'debit and accounted credit for the journal. RED means the containing batch is',
'out of balance; AMBER means the journal is unposted without that confirmed',
'balance issue. Results are current query results, not a historical snapshot.'))
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203868446800296970)
,p_db_column_name=>'ACCOUNTED_DIFFERENCE'
,p_display_order=>150
,p_column_identifier=>'W'
,p_column_label=>'Accounted Difference'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Absolute difference between journal accounted debit and accounted credit in LEDGER_CURRENCY_CODE. Zero means the journal totals balance; a positive value indicates a difference.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203867405640296959)
,p_db_column_name=>'BALANCE_TYPE'
,p_display_order=>170
,p_column_identifier=>'L'
,p_column_label=>'Balance Type'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Accounting balance type derived from ACTUAL_FLAG, normally Actual, Budget, or Encumbrance. Use for requests mentioning actual, budget, or encumbrance journals.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203867654759296962)
,p_db_column_name=>'BATCH_BALANCE_STATUS'
,p_display_order=>200
,p_column_identifier=>'O'
,p_column_label=>'Batch Balance Status'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Management status of the containing batch: BALANCED or OUT OF BALANCE. It repeats for every journal in the batch, so count distinct JE_BATCH_ID for batch questions.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203867571884296961)
,p_db_column_name=>'BATCH_DESCRIPTION'
,p_display_order=>190
,p_column_identifier=>'N'
,p_column_label=>'Batch Description'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Free-text description of the containing batch. Use contains-style searching for descriptive terms; do not confuse with journal description.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203866792084296953)
,p_db_column_name=>'BATCH_NAME'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Batch Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'EBS journal batch name. Use for requests naming, finding, or grouping journals by batch. Do not confuse with JOURNAL_NAME.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203867243263296958)
,p_db_column_name=>'CURRENCY_CODE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Currency Code'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Currency of JOURNAL_ENTERED_DR and JOURNAL_ENTERED_CR. Group by this column before totaling entered amounts.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203867148118296957)
,p_db_column_name=>'EFFECTIVE_DATE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Effective Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Journal effective date within the accounting period. Treat journal date, effective date, oldest, newest, before, and after as filters or sorting on this column.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203866715642296952)
,p_db_column_name=>'JE_BATCH_ID'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Je Batch Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Unique technical identifier of a GL journal batch. Use distinct values to count batches; multiple journal rows can share one batch.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203866597881296951)
,p_db_column_name=>'JE_HEADER_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Je Header Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Unique technical identifier of a GL journal header. Distinct JE_HEADER_ID is the definitive journal count. Use for exact identification or duplicate checks, not for business descriptions.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203868358928296969)
,p_db_column_name=>'JOURNAL_ACCOUNTED_CR'
,p_display_order=>230
,p_column_identifier=>'V'
,p_column_label=>'Journal Accounted Cr'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Total accounted credit for this journal in LEDGER_CURRENCY_CODE.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203868307958296968)
,p_db_column_name=>'JOURNAL_ACCOUNTED_DR'
,p_display_order=>160
,p_column_identifier=>'U'
,p_column_label=>'Journal Accounted Dr'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Total accounted debit for this journal in LEDGER_CURRENCY_CODE.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203867028156296956)
,p_db_column_name=>'JOURNAL_CATEGORY'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Journal Category'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'User-facing journal category from GL_JE_CATEGORIES.USER_JE_CATEGORY_NAME, such as Purchase Invoices, Payments, Sales Invoices, Receipts, Adjustment, Inventory, Receiving, or WIP. The internal GL_JE_HEADERS.JE_CATEGORY code is used only as a fallback '
||'when no category setup row is found. Source and category are separate classifications.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203867453006296960)
,p_db_column_name=>'JOURNAL_DESCRIPTION'
,p_display_order=>180
,p_column_identifier=>'M'
,p_column_label=>'Journal Description'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Free-text description of the journal header. Use contains-style searching for descriptive terms; do not treat it as a controlled category.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203868088981296966)
,p_db_column_name=>'JOURNAL_ENTERED_CR'
,p_display_order=>130
,p_column_identifier=>'S'
,p_column_label=>'Entered CR'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Total entered credit amount for this journal in CURRENCY_CODE. Do not total across different entered currencies.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203868007416296965)
,p_db_column_name=>'JOURNAL_ENTERED_DR'
,p_display_order=>120
,p_column_identifier=>'R'
,p_column_label=>' Entered DR'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Total entered debit amount for this journal in CURRENCY_CODE. Do not total across different entered currencies.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203866873076296954)
,p_db_column_name=>'JOURNAL_NAME'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Journal Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'EBS journal header name. Use for requests naming or searching for a specific journal. Each row represents one journal.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203866962988296955)
,p_db_column_name=>'JOURNAL_SOURCE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Journal Source'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>unistr('Journal source, such as Payables, Receivables, Cost Management, or Spreadsheet. \201CFrom Payables\201D means exact filter JOURNAL_SOURCE = Payables, not a batch-name search.')
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203868190031296967)
,p_db_column_name=>'LEDGER_CURRENCY_CODE'
,p_display_order=>140
,p_column_identifier=>'T'
,p_column_label=>'Ledger Currency'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Ledger currency used for accounted debit, accounted credit, and accounted difference. Group by ledger currency before totaling accounted values.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203866272766296948)
,p_db_column_name=>'LEDGER_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Ledger Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Technical ledger identifier: 1003 TEREX US, 5001 TEREX UK 120, 10001 TEREX CH. Prefer LEDGER_NAME for business-name filters.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203866323862296949)
,p_db_column_name=>'LEDGER_NAME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Ledger Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>unistr('Business ledger. Map US or USA to TEREX US; UK to TEREX UK 120; CH or Switzerland to TEREX CH. \201CIn\201D or \201Cfor\201D a ledger means filter this column.')
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203866512824296950)
,p_db_column_name=>'PERIOD_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Period Name'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Accounting period in MON-YYYY format. Every row is scoped to the selected period.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203867920007296964)
,p_db_column_name=>'REFRESH_TIMESTAMP'
,p_display_order=>220
,p_column_identifier=>'Q'
,p_column_label=>'Refresh Timestamp'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Query refresh time, not journal creation, effective, or posting time. Use only for freshness questions.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203867755644296963)
,p_db_column_name=>'SEVERITY'
,p_display_order=>210
,p_column_identifier=>'P'
,p_column_label=>'Severity'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'RED when the containing batch is out of balance; otherwise AMBER for an unposted journal. Use for risk or attention questions.'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(204006576547991639)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>1000
,p_report_columns=>'LEDGER_ID:LEDGER_NAME:PERIOD_NAME:JE_HEADER_ID:JE_BATCH_ID:BATCH_NAME:JOURNAL_NAME:JOURNAL_SOURCE:JOURNAL_CATEGORY:EFFECTIVE_DATE:CURRENCY_CODE:JOURNAL_ENTERED_DR:JOURNAL_ENTERED_CR:LEDGER_CURRENCY_CODE:ACCOUNTED_DIFFERENCE:JOURNAL_ACCOUNTED_DR:BALAN'
||'CE_TYPE:JOURNAL_DESCRIPTION:BATCH_DESCRIPTION:BATCH_BALANCE_STATUS:SEVERITY:REFRESH_TIMESTAMP:JOURNAL_ACCOUNTED_CR'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(203931483608779199)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(215802773311070973)
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
 p_id=>wwv_flow_imp.id(203931866226779202)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(215802773311070973)
,p_button_name=>'REFRESH_GL'
,p_static_id=>'refresh-gl'
,p_show_as_disabled=>false
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Refresh'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(255684415641475859)
,p_name=>'P11_DB_LINK'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(215802773311070973)
,p_item_default=>'ADG'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_cHeight=>1
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(215804996111071009)
,p_name=>'P11_PERIOD_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(215802773311070973)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select upper(to_char(trunc(sysdate, ''MM''), ''MON-YYYY'', ''NLS_DATE_LANGUAGE=English''))',
'from dual'))
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
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(203945383437779255)
,p_name=>'Close'
,p_static_id=>'close'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(203931483608779199)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(203945794687779257)
,p_event_id=>wwv_flow_imp.id(203945383437779255)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'window.close();')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(203868572363296971)
,p_name=>'New'
,p_static_id=>'new'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(203931866226779202)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(203868709868296972)
,p_event_id=>wwv_flow_imp.id(203868572363296971)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-refresh'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(203866066879296946)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'maintain_pagination', 'N')).to_clob
);
wwv_flow_imp.component_end;
end;
/
