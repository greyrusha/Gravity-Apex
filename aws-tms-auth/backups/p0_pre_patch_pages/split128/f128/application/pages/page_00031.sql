prompt --application/pages/page_00031
begin
--   Manifest
--     PAGE: 00031
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
 p_id=>31
,p_name=>unistr('AR Unapplied Receipts \2014 Current')
,p_alias=>'AR-UNAPPLIED-RECEIPTS-CURRENT'
,p_step_title=>unistr('AR Unapplied Receipts \2014 Current')
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>4075783602716660119
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(18558063129193156)
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(218773012728108142)
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
 p_id=>wwv_flow_imp.id(245280724815537752)
,p_plug_name=>'Current State'
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
'      This report shows the current open unapplied and unidentified receipt',
'      position. It is not a historical period-end snapshot.',
'    </div>',
'  </div>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(245280971890537754)
,p_plug_name=>'AR Unapplied Receipts'
,p_static_id=>'gl-readiness'
,p_title=>'Receivables Exceptions'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>20
,p_plug_grid_column_span=>12
,p_plug_item_display_point=>'ABOVE'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT r.ledger_id,',
'       r.ledger_name,',
'       r.org_id,',
'       r.operating_unit,',
'       r.receipt_number,',
'       r.receipt_date,',
'       r.receipt_type,',
'       r.receipt_status,',
'       r.customer_number,',
'       r.customer_name,',
'       r.currency_code,',
'       r.original_receipt_amount,',
'       r.applied_amount,',
'       r.unapplied_amount,',
'       r.ledger_currency_code,',
'       r.accounted_unapplied_amount,',
'       r.receipt_age_days,',
'       r.cash_receipt_id,',
'       r.refresh_timestamp',
'FROM TABLE(xxme_ar_unapplied_pkg.get_receipts(:P31_DB_LINK)) r'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P31_DB_LINK'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Receivables Exceptions'
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
 p_id=>wwv_flow_imp.id(218966291904398820)
,p_no_data_found_message=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="t-Alert t-Alert--success t-Alert--horizontal">',
'  <div class="t-Alert-wrap">',
'    <div class="t-Alert-icon">',
'      <span class="t-Icon fa fa-check-circle" aria-hidden="true"></span>',
'    </div>',
'    <div class="t-Alert-content">',
'      <div class="t-Alert-header">',
'        <h2 class="t-Alert-title">No unapplied receipts found</h2>',
'      </div>',
'      <div class="t-Alert-body">',
'        No material open unapplied or unidentified receipts were found within',
'        the approved ledger scope.',
'      </div>',
'    </div>',
'  </div>',
'</div>'))
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_display_row_count=>'Y'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>true
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_internal_uid=>32591070133405977
,p_ai_search_mode=>'A'
,p_ai_report_hint=>wwv_flow_string.join(wwv_flow_t_varchar2(
'This is a trusted, read-only Oracle EBS Receivables report showing the current',
'open unapplied and unidentified receipt position. It has no accounting-period',
'parameter and is not a historical period-end snapshot. Scope is limited to',
'ledger 1003 TEREX US, ledger 5001 TEREX UK 120, and ledger 10001 TEREX CH.',
'',
'Treat natural-language questions as requests to modify the current Interactive',
'Report. For requests containing how many, which, show, find, list, compare,',
'highest, lowest, oldest, newest, largest, or smallest, apply filters, sorting,',
'control breaks, grouping, aggregation, or highlighting. Do not refuse because',
'the request is phrased as a question. For receipt counts, filter and use report',
'row count or distinct CASH_RECEIPT_ID.',
'',
'Each row represents one current open cash receipt. Only non-reversed receipts',
'with current status UNAPP or UNID are included, with an open PMT payment',
'schedule and an absolute remaining amount greater than 0.01. UNAPP means an',
'unapplied or partially unapplied receipt; UNID means unidentified.',
'',
'ORIGINAL_RECEIPT_AMOUNT, APPLIED_AMOUNT, and UNAPPLIED_AMOUNT use CURRENCY_CODE.',
'ACCOUNTED_UNAPPLIED_AMOUNT uses LEDGER_CURRENCY_CODE. Never total or compare',
'amounts across currencies without grouping by the corresponding currency.',
'RECEIPT_AGE_DAYS is calendar age from RECEIPT_DATE through today. If a user',
'asks for a historical period, explain',
'that this report can only show the current open position. No matching rows do',
'not prove AR is complete.'))
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203668148015526464)
,p_db_column_name=>'ACCOUNTED_UNAPPLIED_AMOUNT'
,p_display_order=>150
,p_column_identifier=>'Z'
,p_column_label=>'Accounted Unapplied Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Current unapplied balance translated/accounted in LEDGER_CURRENCY_CODE. Group by ledger and ledger currency before summing.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203667888894526461)
,p_db_column_name=>'APPLIED_AMOUNT'
,p_display_order=>120
,p_column_identifier=>'W'
,p_column_label=>'Applied Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Amount already applied, calculated as original receipt amount minus current unapplied amount, in CURRENCY_CODE.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203666999124526452)
,p_db_column_name=>'CASH_RECEIPT_ID'
,p_display_order=>200
,p_column_identifier=>'N'
,p_column_label=>'Cash Receipt Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Unique technical receipt identifier. Distinct CASH_RECEIPT_ID is the definitive receipt count. Prefer RECEIPT_NUMBER for business searches.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203667706931526459)
,p_db_column_name=>'CURRENCY_CODE'
,p_display_order=>100
,p_column_identifier=>'U'
,p_column_label=>'Currency Code'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Receipt currency for original, applied, and unapplied amounts. Group by this column before totaling those measures.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203667615569526458)
,p_db_column_name=>'CUSTOMER_NAME'
,p_display_order=>90
,p_column_identifier=>'T'
,p_column_label=>'Customer Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Customer or party name. Use contains-style searching and group by this column for customer comparisons. UNIDENTIFIED CUSTOMER is a valid displayed value.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203667449934526457)
,p_db_column_name=>'CUSTOMER_NUMBER'
,p_display_order=>80
,p_column_identifier=>'S'
,p_column_label=>'Customer Number'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Customer account number. Use exact filtering for customer-number questions; it can be null for unidentified receipts.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203668070881526463)
,p_db_column_name=>'LEDGER_CURRENCY_CODE'
,p_display_order=>140
,p_column_identifier=>'Y'
,p_column_label=>'Ledger Currency Code'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Ledger currency for ACCOUNTED_UNAPPLIED_AMOUNT. It can differ from receipt currency.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(218966354081398821)
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
 p_id=>wwv_flow_imp.id(218966500303398822)
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
 p_id=>wwv_flow_imp.id(218966678441398824)
,p_db_column_name=>'OPERATING_UNIT'
,p_display_order=>30
,p_column_identifier=>'D'
,p_column_label=>'Operating Unit'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Receivables operating-unit name associated with the cash receipt. Use for operating-unit or company filters.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(218966601513398823)
,p_db_column_name=>'ORG_ID'
,p_display_order=>170
,p_column_identifier=>'C'
,p_column_label=>'Org Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Oracle EBS Receivables operating-unit identifier. Use OPERATING_UNIT for business-name questions.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203667770322526460)
,p_db_column_name=>'ORIGINAL_RECEIPT_AMOUNT'
,p_display_order=>110
,p_column_identifier=>'V'
,p_column_label=>'Original Receipt Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Original cash receipt amount in CURRENCY_CODE.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203668317841526465)
,p_db_column_name=>'RECEIPT_AGE_DAYS'
,p_display_order=>160
,p_column_identifier=>'AA'
,p_column_label=>'Receipt Age Days'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>unistr('Current calendar age from RECEIPT_DATE. Larger values are older. Use numeric filters for \201Colder than N days.\201D')
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203667193055526454)
,p_db_column_name=>'RECEIPT_DATE'
,p_display_order=>50
,p_column_identifier=>'P'
,p_column_label=>'Receipt Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Date the receipt was recorded. Use for oldest, newest, before, after, and date-range questions.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203667114672526453)
,p_db_column_name=>'RECEIPT_NUMBER'
,p_display_order=>40
,p_column_identifier=>'O'
,p_column_label=>'Receipt Number'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Business receipt reference. Use exact or contains searching when the user supplies a receipt number; treat it as text even if numeric-looking.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203667340003526456)
,p_db_column_name=>'RECEIPT_STATUS'
,p_display_order=>70
,p_column_identifier=>'R'
,p_column_label=>'Receipt Status'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>unistr('Current EBS status: UNAPP means unapplied or partially unapplied; UNID means unidentified. Map \201Cunidentified\201D to UNID and \201Cunapplied\201D to UNAPP unless the user asks for both.')
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203667304117526455)
,p_db_column_name=>'RECEIPT_TYPE'
,p_display_order=>60
,p_column_identifier=>'Q'
,p_column_label=>'Receipt Type'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Receipt type, normally CASH for this report. It is different from receipt status.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(218967567028398833)
,p_db_column_name=>'REFRESH_TIMESTAMP'
,p_display_order=>190
,p_column_identifier=>'M'
,p_column_label=>'Refresh Timestamp'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Current-state query time. It is not the receipt date or application date.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203667960959526462)
,p_db_column_name=>'UNAPPLIED_AMOUNT'
,p_display_order=>130
,p_column_identifier=>'X'
,p_column_label=>'Unapplied Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Current positive remaining receipt balance in CURRENCY_CODE. This is the primary open cash amount. Group by currency before summing.'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(219060999180784817)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>100
,p_report_columns=>'LEDGER_NAME:OPERATING_UNIT:RECEIPT_NUMBER:RECEIPT_DATE:RECEIPT_TYPE:RECEIPT_STATUS:CURRENCY_CODE:CUSTOMER_NUMBER:CUSTOMER_NAME:ORIGINAL_RECEIPT_AMOUNT:APPLIED_AMOUNT:UNAPPLIED_AMOUNT:LEDGER_CURRENCY_CODE:ACCOUNTED_UNAPPLIED_AMOUNT:RECEIPT_AGE_DAYS'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(203722462686990211)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(245280724815537752)
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
 p_id=>wwv_flow_imp.id(203722875979990216)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(245280724815537752)
,p_button_name=>'REFRESH_AR'
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
 p_id=>wwv_flow_imp.id(255684415641495859)
,p_name=>'P31_DB_LINK'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(245280724815537752)
,p_item_default=>'ADG'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_cHeight=>1
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(203729123094990236)
,p_name=>'Close'
,p_static_id=>'close'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(203722462686990211)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(203729576097990238)
,p_event_id=>wwv_flow_imp.id(203729123094990236)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'window.close();')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(203730073153990238)
,p_name=>'Refresh AR Report'
,p_static_id=>'refresh-ar-report'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(203722875979990216)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(203730506212990238)
,p_event_id=>wwv_flow_imp.id(203730073153990238)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-refresh'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(245280971890537754)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'maintain_pagination', 'N')).to_clob
);
wwv_flow_imp.component_end;
end;
/
