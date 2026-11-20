prompt --application/pages/page_00030
begin
--   Manifest
--     PAGE: 00030
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
 p_id=>30
,p_name=>'Receivables Accounting Exceptions'
,p_alias=>'RECEIVABLES'
,p_step_title=>'Receivables Accounting Exceptions'
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
 p_id=>wwv_flow_imp.id(201427013527110788)
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
 p_id=>wwv_flow_imp.id(227934725614540398)
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
 p_id=>wwv_flow_imp.id(227934972689540400)
,p_plug_name=>'Receivables Exceptions'
,p_static_id=>'gl-readiness'
,p_title=>'Receivables Exceptions'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>20
,p_plug_item_display_point=>'ABOVE'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT s.*,',
'       CASE',
'           WHEN s.exception_type = ''PROCESSING/ACCOUNTING ERROR''',
'           THEN ''View Details''',
'       END AS detail_action',
'FROM TABLE(',
'    xxme_ap_ar_detail_pkg.get_summary(',
'        222,',
'        :P30_PERIOD_NAME,',
'        :P30_DB_LINK',
'    )',
') s'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P30_PERIOD_NAME,P30_DB_LINK'
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
 p_id=>wwv_flow_imp.id(201620292703401466)
,p_no_data_found_message=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="t-Alert t-Alert--success t-Alert--horizontal">',
'  <div class="t-Alert-wrap">',
'    <div class="t-Alert-icon">',
'      <span class="t-Icon fa fa-check-circle" aria-hidden="true"></span>',
'    </div>',
'    <div class="t-Alert-content">',
'      <div class="t-Alert-header">',
'        <h2 class="t-Alert-title">No AR exceptions found</h2>',
'      </div>',
'      <div class="t-Alert-body">',
'        No Receivables accounting exceptions were found for the selected period and ledger scope.',
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
,p_internal_uid=>15245070932408623
,p_ai_search_mode=>'A'
,p_ai_report_hint=>wwv_flow_string.join(wwv_flow_t_varchar2(
'This is a trusted, read-only Oracle EBS Receivables accounting-exception',
'summary for the selected accounting period. Scope is limited to ledger 1003',
'TEREX US, ledger 5001 TEREX UK 120, and ledger 10001 TEREX CH. Each row is an',
'aggregated exception group by ledger, operating unit, AR entity, and exception',
'type; it is not one receipt, transaction, or adjustment.',
'',
'Treat natural-language questions as requests to modify the current Interactive',
'Report. For requests containing how many, which, show, find, list, compare,',
'highest, lowest, oldest, newest, largest, or smallest, apply filters, sorting,',
'control breaks, grouping, aggregation, or highlighting. Do not refuse because',
unistr('the request is phrased as a question. For \201CHow many receipt exception events in'),
unistr('TEREX CH?\201D, filter LEDGER_NAME to TEREX CH and ENTITY_CODE to RECEIPTS, then sum'),
'EVENT_COUNT; report row count is not the event count.',
'',
'EVENT_COUNT is the number of distinct SLA accounting events in the group.',
'TRANSACTION_COUNT is the number of distinct source AR transactions represented',
'by those events. Report row count is only the number of summary groups.',
'Entities are ADJUSTMENTS, RECEIPTS, and TRANSACTIONS. Exception types can include',
'PROCESSING/ACCOUNTING ERROR, ACCOUNTING NOT FINAL, NOT TRANSFERRED TO GL, and',
'UNPROCESSED EVENT.',
'',
'Severity is RED for confirmed processing/accounting errors or not-transferred',
'items, and can also become RED when aged at least 5 days. AMBER applies to',
'accounting-not-final items or items aged at least 2 days; newer backlog is',
'INFORMATIONAL. Do not infer that AR or month-end is complete merely because a',
'filter returns no rows.'))
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(257061918116477510)
,p_db_column_name=>'DETAIL_ACTION'
,p_display_order=>15
,p_column_identifier=>'N'
,p_column_label=>'Details'
,p_column_link=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_PERIOD_NAME,P42_APPLICATION_ID,P42_LEDGER_ID,P42_ORG_ID,P42_ENTITY_CODE,P42_EXCEPTION_TYPE,P42_RUN_SLA,P42_RUN_PERIOD,P42_SOURCE_PAGE,P42_DB_LINK:&P30_PERIOD_NAME.,222,#LEDGER_ID#,#ORG_ID#,#ENTITY_CODE#,#EXCE'
||'PTION_TYPE#,Y,&P30_PERIOD_NAME.,30,&P30_DB_LINK.'
,p_column_linktext=>'#DETAIL_ACTION#'
,p_column_link_attr=>'class="t-Button t-Button--small t-Button--noUI" aria-label="View accounting error details"'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(201621172377401475)
,p_db_column_name=>'EARLIEST_EXCEPTION_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Earliest Exception Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Oldest exception date in this summary group. Use for oldest, before, since, or aging questions.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(201620796388401471)
,p_db_column_name=>'ENTITY_CODE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Entity Code'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'AR source entity. Values are ADJUSTMENTS, RECEIPTS, and TRANSACTIONS. Map adjustments, receipts/cash, and customer transactions/invoices to the respective exact value.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(201620987191401473)
,p_db_column_name=>'EVENT_COUNT'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Event Count'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Number of distinct SLA accounting events in this summary group. Sum this column after filtering for event totals; do not use report row count.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(201620841733401472)
,p_db_column_name=>'EXCEPTION_TYPE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Exception Type'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Accounting exception classification: PROCESSING/ACCOUNTING ERROR, ACCOUNTING NOT FINAL, NOT TRANSFERRED TO GL, or UNPROCESSED EVENT. Use exact filters for error, incomplete accounting, transfer, or unprocessed requests.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(201621236434401476)
,p_db_column_name=>'LATEST_EXCEPTION_DATE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Latest Exception Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Most recent exception date in this summary group. Use for newest, most recent, or after questions.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(201620354880401467)
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
 p_id=>wwv_flow_imp.id(201620501102401468)
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
 p_id=>wwv_flow_imp.id(201621404104401477)
,p_db_column_name=>'OLDEST_EXCEPTION_AGE_DAYS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Oldest Exception Age Days'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>unistr('Calendar age in days of the oldest exception in the group. Larger means older. Use numeric filters for \201Colder than N days.\201D')
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(201620679240401470)
,p_db_column_name=>'OPERATING_UNIT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Operating Unit'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Receivables operating-unit name. Use for questions mentioning company, business unit, or operating unit.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(201620602312401469)
,p_db_column_name=>'ORG_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Org Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Oracle EBS operating-unit identifier for this AR exception group. Use OPERATING_UNIT for name-based questions.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(201621567827401479)
,p_db_column_name=>'REFRESH_TIMESTAMP'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Refresh Timestamp'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Query refresh time. It is not a receipt, transaction, event, or accounting date.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(201621452203401478)
,p_db_column_name=>'SEVERITY'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Internal Legacy Severity'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(201621029197401474)
,p_db_column_name=>'TRANSACTION_COUNT'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Transaction Count'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Number of distinct AR source transactions represented in the group. It can differ from EVENT_COUNT because one transaction can generate multiple events.'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(201714999979787463)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'DETAIL_ACTION:LEDGER_ID:LEDGER_NAME:ORG_ID:OPERATING_UNIT:ENTITY_CODE:EXCEPTION_TYPE:EVENT_COUNT:TRANSACTION_COUNT:EARLIEST_EXCEPTION_DATE:LATEST_EXCEPTION_DATE:OLDEST_EXCEPTION_AGE_DAYS:REFRESH_TIMESTAMP'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(327394276929130661)
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
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(201685777013418789)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(227934725614540398)
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
 p_id=>wwv_flow_imp.id(203668696631526469)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(227934725614540398)
,p_button_name=>'OPEN_AR_UNAPPLIED'
,p_static_id=>'open-ar-unapplied'
,p_show_as_disabled=>false
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'AR Unapplied Receipts'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(201419961655110647)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(227934725614540398)
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
 p_id=>wwv_flow_imp.id(264714415640464850)
,p_name=>'P30_AR_UNAPPLIED_URL'
,p_item_sequence=>30
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(255684415641494859)
,p_name=>'P30_DB_LINK'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(227934725614540398)
,p_item_default=>'ADG'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_cHeight=>1
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(227938245994540765)
,p_name=>'P30_PERIOD_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(227934725614540398)
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
 p_id=>wwv_flow_imp.id(202853767825954555)
,p_name=>'Close'
,p_static_id=>'close'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(201685777013418789)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(202853892383954556)
,p_event_id=>wwv_flow_imp.id(202853767825954555)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'window.close();')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(203668775913526470)
,p_name=>'New'
,p_static_id=>'new'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(203668696631526469)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(203668911358526471)
,p_event_id=>wwv_flow_imp.id(203668775913526470)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'generate-ar-unapplied-url'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'items_to_return', 'P30_AR_UNAPPLIED_URL',
  'items_to_submit', 'P30_DB_LINK',
  'language', 'PLSQL',
  'plsql_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    ':P30_AR_UNAPPLIED_URL := apex_page.get_url(',
    '    p_page        => 31,',
    '    p_clear_cache => ''31'',',
    '    p_items       => ''P31_DB_LINK'',',
    '    p_values      => :P30_DB_LINK',
    ');')),
  'show_processing', 'N',
  'suppress_change_event', 'N')).to_clob
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(264714415640464851)
,p_event_id=>wwv_flow_imp.id(203668775913526470)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_static_id=>'open-ar-unapplied'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'apex.navigation.openInNewWindow(',
    '    $v("P30_AR_UNAPPLIED_URL"),',
    '    "tms_ar_unapplied"',
    ');')))).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(201427785910110836)
,p_name=>'Refresh AR Report'
,p_static_id=>'refresh-ar-report'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(201419961655110647)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(201428154379110846)
,p_event_id=>wwv_flow_imp.id(201427785910110836)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-refresh'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(227934972689540400)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'maintain_pagination', 'N')).to_clob
);
wwv_flow_imp.component_end;
end;
/
