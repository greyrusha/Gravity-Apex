prompt --application/pages/page_00021
begin
--   Manifest
--     PAGE: 00021
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
 p_id=>21
,p_name=>'AP Active Holds - Current'
,p_alias=>'AP-ACTIVE-HOLDS'
,p_step_title=>'AP Active Holds - Current'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>4075783602716660119
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(9156329399484443)
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(193454027698245862)
,p_plug_name=>'AP Active Holds'
,p_static_id=>'ap-holds'
,p_title=>'AP Holds'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>20
,p_plug_item_display_point=>'ABOVE'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT h.ledger_id,',
'       h.ledger_name,',
'       h.org_id,',
'       h.operating_unit,',
'       h.invoice_id,',
'       h.invoice_num,',
'       h.supplier_number,',
'       h.supplier_name,',
'       h.supplier_site,',
'       h.invoice_date,',
'       h.gl_date,',
'       h.currency_code,',
'       h.invoice_amount,',
'       h.amount_paid,',
'       h.outstanding_amount,',
'       h.payment_status_flag,',
'       h.hold_code,',
'       h.hold_reason,',
'       h.hold_date,',
'       h.hold_age_days,',
'       h.refresh_timestamp',
'FROM TABLE(xxme_ap_holds_pkg.get_holds(:P21_DB_LINK)) h'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P21_DB_LINK'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'AP Holds'
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
 p_id=>wwv_flow_imp.id(193454124988245863)
,p_no_data_found_message=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="t-Alert t-Alert--success t-Alert--horizontal">',
'  <div class="t-Alert-wrap">',
'    <div class="t-Alert-icon">',
'      <span class="t-Icon fa fa-check-circle" aria-hidden="true"></span>',
'    </div>',
'    <div class="t-Alert-content">',
'      <div class="t-Alert-header">',
'        <h2 class="t-Alert-title">No active AP holds found</h2>',
'      </div>',
'      <div class="t-Alert-body">',
'        No active holds were found on unpaid, non-cancelled invoices within',
'        the approved ledger scope.',
'      </div>',
'    </div>',
'  </div>',
'</div>'))
,p_max_rows_to_display=>'1000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'TOP_AND_BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>true
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_internal_uid=>16480636946961733
,p_ai_search_mode=>'A'
,p_ai_report_hint=>wwv_flow_string.join(wwv_flow_t_varchar2(
'This is a trusted, read-only Oracle EBS Payables report of the current active',
'hold position. It has no accounting-period parameter and is not a historical',
'period-end snapshot. Scope is limited to ledger 1003 TEREX US, ledger 5001',
'TEREX UK 120, and ledger 10001 TEREX CH.',
'',
'Treat natural-language questions as requests to modify the current Interactive',
'Report. For requests containing how many, which, show, find, list, compare,',
'highest, lowest, oldest, newest, largest, or smallest, apply filters, sorting,',
'control breaks, grouping, aggregation, or highlighting. Do not refuse because',
unistr('the request is phrased as a question. When \201Chow many\201D asks for holds, filter the'),
'report and use row count. For distinct invoices, count distinct INVOICE_ID,',
'because one invoice can have several different active hold codes.',
'',
'Each row is one unique displayed invoice-and-hold exception. Exact duplicate',
'display rows are removed, but different HOLD_CODE values on one invoice remain',
'separate rows. Only unreleased holds are included. Cancelled and fully paid',
'invoices are excluded. OUTSTANDING_AMOUNT equals INVOICE_AMOUNT minus',
'AMOUNT_PAID. Currency amounts use CURRENCY_CODE; never total or compare amounts',
'across currencies without grouping by CURRENCY_CODE.',
'',
'HOLD_AGE_DAYS is calendar age from HOLD_DATE through today.',
'A zero outstanding amount can still be a valid accounting or distribution hold.',
'If a user asks for a historical period, explain that this report can only show',
'the current active-hold position. No matching rows do not prove AP is complete.'))
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(193455550145245877)
,p_db_column_name=>'AMOUNT_PAID'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Amount Paid'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Amount paid against the invoice in CURRENCY_CODE. Fully paid invoices are excluded from this report.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(193455301752245875)
,p_db_column_name=>'CURRENCY_CODE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Currency Code'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Currency of invoice amount, amount paid, and outstanding amount. Group by this column before totaling or comparing monetary values.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(193455228152245874)
,p_db_column_name=>'GL_DATE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'GL Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Invoice accounting date in General Ledger. This is not the invoice date or the date the hold was placed.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(194264611409817733)
,p_db_column_name=>'HOLD_AGE_DAYS'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Hold Age Days'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>unistr('Current calendar age of the hold. Larger values are older. Use numeric filters for \201Colder than N days.\201D')
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(193455879880245880)
,p_db_column_name=>'HOLD_CODE'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Hold Code'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Controlled AP hold classification, such as LINE VARIANCE, QTY REC, QTY ORD, MAX SHIP AMOUNT, DIST ACCT INVALID, or tax-link holds. Use for hold-type filters and grouping.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(194264563645817732)
,p_db_column_name=>'HOLD_DATE'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Hold Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Date and time the active hold was placed. Use for oldest, newest, before, after, and date-range questions.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(194264462890817731)
,p_db_column_name=>'HOLD_REASON'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Hold Reason'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Human-readable explanation recorded for the hold. Use contains-style searching for tax, quantity, distribution, variance, or other reason words.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(193455413085245876)
,p_db_column_name=>'INVOICE_AMOUNT'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Invoice Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Original invoice amount in CURRENCY_CODE. It is not the unpaid or held balance.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(193455093044245873)
,p_db_column_name=>'INVOICE_DATE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Invoice Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Date shown on the supplier invoice. This is not the GL date or hold date.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(193454649492245868)
,p_db_column_name=>'INVOICE_ID'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Invoice Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Unique technical AP invoice identifier. Count distinct INVOICE_ID for number of invoices; row count can be higher when an invoice has several holds.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(193454755972245869)
,p_db_column_name=>'INVOICE_NUM'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Invoice Num'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Supplier invoice number. Use for exact or contains searches when the user gives an invoice reference. Invoice numbers are text, even when numeric-looking.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(193454282000245864)
,p_db_column_name=>'LEDGER_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Ledger Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Technical ledger identifier: 1003 TEREX US, 5001 TEREX UK 120, 10001 TEREX CH. Prefer LEDGER_NAME for business filters.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(193454335218245865)
,p_db_column_name=>'LEDGER_NAME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Ledger Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Business ledger. Map US or USA to TEREX US; UK to TEREX UK 120; CH or Switzerland to TEREX CH.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(193454505995245867)
,p_db_column_name=>'OPERATING_UNIT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Operating Unit'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Payables operating-unit name associated with the invoice and hold. Use for operating-unit or company filters.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(193454484593245866)
,p_db_column_name=>'ORG_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Org Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Oracle EBS AP operating-unit identifier. Use OPERATING_UNIT for business-name questions.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(193455642678245878)
,p_db_column_name=>'OUTSTANDING_AMOUNT'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Outstanding Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'INVOICE_AMOUNT minus AMOUNT_PAID in CURRENCY_CODE. Use for unpaid balance or held exposure. Group by currency before summing.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(193455770313245879)
,p_db_column_name=>'PAYMENT_STATUS_FLAG'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Payment Status Flag'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Technical AP payment flag. Fully paid Y rows are excluded. Prefer AMOUNT_PAID and OUTSTANDING_AMOUNT for management questions.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(194264810358817735)
,p_db_column_name=>'REFRESH_TIMESTAMP'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Refresh Timestamp'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Time the current-state query ran. It is not the hold, invoice, or GL date.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(193454917552245871)
,p_db_column_name=>'SUPPLIER_NAME'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Supplier Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Supplier business name. Use contains-style searching for user-supplied names and group by this column for supplier comparisons.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(193454792167245870)
,p_db_column_name=>'SUPPLIER_NUMBER'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Supplier Number'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Supplier account number from AP suppliers. Use exact matching for a supplier number; do not confuse with supplier name.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(193455051646245872)
,p_db_column_name=>'SUPPLIER_SITE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Supplier Site'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Supplier site code for the invoice. Use when the user asks about a location or supplier site.'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(194292097478836983)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>1000
,p_report_columns=>'LEDGER_ID:LEDGER_NAME:ORG_ID:OPERATING_UNIT:INVOICE_ID:INVOICE_NUM:SUPPLIER_NUMBER:SUPPLIER_NAME:SUPPLIER_SITE:INVOICE_DATE:GL_DATE:CURRENCY_CODE:INVOICE_AMOUNT:AMOUNT_PAID:OUTSTANDING_AMOUNT:PAYMENT_STATUS_FLAG:HOLD_CODE:HOLD_REASON:HOLD_DATE:HOLD_A'
||'GE_DAYS:REFRESH_TIMESTAMP'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(194251286160775283)
,p_plug_name=>'AP Active Holds - Current'
,p_static_id=>'breadcrumb'
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
 p_id=>wwv_flow_imp.id(220759894015204611)
,p_plug_name=>'Filters'
,p_static_id=>'filters'
,p_title=>'Current State'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="t-Alert t-Alert--info t-Alert--horizontal">',
'  <div class="t-Alert-wrap">',
'    <div class="t-Alert-icon">',
'      <span class="t-Icon fa fa-info-circle" aria-hidden="true"></span>',
'    </div>',
'    <div class="t-Alert-content">',
'      This report shows current active holds on unpaid, non-cancelled AP',
'      invoices. It is not a historical period-end snapshot.',
'    </div>',
'  </div>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(194245104352775169)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(220759894015204611)
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
 p_id=>wwv_flow_imp.id(194245493987775198)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(220759894015204611)
,p_button_name=>'REFRESH_HOLDS'
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
 p_id=>wwv_flow_imp.id(246282681911777146)
,p_name=>'P21_DB_LINK'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(220759894015204611)
,p_item_default=>'ADG'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_cHeight=>1
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(194264917120817736)
,p_name=>'Refresh'
,p_static_id=>'refresh'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(194245493987775198)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(194265028125817737)
,p_event_id=>wwv_flow_imp.id(194264917120817736)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-refresh'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(193454027698245862)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'maintain_pagination', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(194252959507775403)
,p_name=>'Return to Dashboard'
,p_static_id=>'return-to-dashboard'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(194245104352775169)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(194253246473775403)
,p_event_id=>wwv_flow_imp.id(194252959507775403)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'window.close();')).to_clob
);
wwv_flow_imp.component_end;
end;
/
