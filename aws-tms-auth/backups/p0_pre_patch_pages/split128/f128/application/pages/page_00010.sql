prompt --application/pages/page_00010
begin
--   Manifest
--     PAGE: 00010
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
 p_id=>10
,p_name=>'General Ledger'
,p_alias=>'GENERAL-LEDGER'
,p_step_title=>'General Ledger'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>4075783602716660119
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(18558063129193156)
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(200018911163445707)
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
 p_id=>wwv_flow_imp.id(198247828492284648)
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
 p_id=>wwv_flow_imp.id(198248075567284650)
,p_plug_name=>'GL Readiness'
,p_static_id=>'gl-readiness'
,p_title=>'GL Readiness'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>20
,p_plug_item_display_point=>'ABOVE'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ledger_id,',
'       ledger_name,',
'       period_name,',
'       period_status_description,',
'       unposted_due_headers,',
'       error_status_headers,',
'       unbalanced_due_batches,',
'       interface_row_count,',
'       earliest_unposted_due_date,',
'       latest_unposted_due_date,',
'       refresh_timestamp',
'FROM   TABLE(',
'           xxme_gl_summary_pkg.get_summary(:P10_PERIOD_NAME, :P10_DB_LINK)',
'       )',
'ORDER BY ledger_id'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P10_PERIOD_NAME,P10_DB_LINK'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'GL Readiness'
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
 p_id=>wwv_flow_imp.id(201618499523401448)
,p_no_data_found_message=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="t-Alert t-Alert--success t-Alert--horizontal">',
'  <div class="t-Alert-wrap">',
'    <div class="t-Alert-icon">',
'      <span class="t-Icon fa fa-check-circle" aria-hidden="true"></span>',
'    </div>',
'    <div class="t-Alert-content">',
'      <div class="t-Alert-header">',
'        <h2 class="t-Alert-title">No GL readiness issues found</h2>',
'      </div>',
'      <div class="t-Alert-body">',
'        No General Ledger readiness issues were found for the selected period and ledger scope.',
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
,p_internal_uid=>15243277752408605
,p_ai_search_mode=>'A'
,p_ai_report_hint=>wwv_flow_string.join(wwv_flow_t_varchar2(
'This is a trusted, read-only Oracle EBS General Ledger management summary for',
'the selected accounting period. Scope is limited to ledger 1003 TEREX US,',
'ledger 5001 TEREX UK 120, and ledger 10001 TEREX CH. Each row represents one',
'ledger for the selected period; it does not represent one journal.',
'',
'Treat natural-language questions as requests to modify the current Interactive',
'Report. For questions containing how many, which, show, find, list, compare,',
'highest, lowest, oldest, newest, largest, or smallest, apply the relevant',
'filters, sorting, grouping, aggregation, or highlighting. Do not refuse because',
'the request is phrased as a question. Briefly state the report action taken.',
'',
'UNPOSTED_DUE_HEADERS is the number of unposted journal headers anywhere in the',
'entire selected period. ERROR_STATUS_HEADERS is the number of journal headers',
'whose status is neither Posted nor Unposted and therefore requires attention.',
'UNBALANCED_DUE_BATCHES is the number of distinct journal batches whose accounted',
'debits and credits differ by more than 0.01. INTERFACE_ROW_COUNT is the number',
'of raw rows waiting in GL_INTERFACE; it is not a journal or batch count.',
'',
'EARLIEST_UNPOSTED_DUE_DATE is the oldest unposted journal effective date.',
'LATEST_UNPOSTED_DUE_DATE is the newest unposted journal effective date.',
'Never claim that enterprise month-end is complete from this report alone.'))
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(201619752137401461)
,p_db_column_name=>'EARLIEST_UNPOSTED_DUE_DATE'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Oldest Unposted Journal Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>unistr('Oldest effective date among unposted journals in the selected period. Use for \201Coldest unposted journal date\201D or age-oriented questions. A null value means there are no unposted journals for that row.')
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(201619311661401456)
,p_db_column_name=>'ERROR_STATUS_HEADERS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Journals in Error/Other Status'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>unistr('Count of distinct journal headers with a status other than P (Posted) or U (Unposted). Heading is Journals in Error/Other Status. Treat \201Cproblem journals,\201D \201Cerror journals,\201D and \201Cjournals requiring attention\201D as this measure.')
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(201619540034401459)
,p_db_column_name=>'INTERFACE_ROW_COUNT'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Interface Transactions'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Count of raw GL_INTERFACE transaction lines for the selected ledger and period. Heading is Interface Transactions. Do not describe this as a journal count or batch count.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(201619866471401462)
,p_db_column_name=>'LATEST_UNPOSTED_DUE_DATE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Newest Unposted Journal Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>unistr('Newest effective date among unposted journals in the selected period. Use for \201Cnewest\201D or \201Cmost recent unposted journal date.\201D A null value means there are no unposted journals for that row.')
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(201618532115401449)
,p_db_column_name=>'LEDGER_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Ledger Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Technical numeric ledger identifier. Valid values are 1003 TEREX US, 5001 TEREX UK 120, and 10001 TEREX CH. Prefer filtering by LEDGER_NAME when the user gives a business name.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(201618687897401450)
,p_db_column_name=>'LEDGER_NAME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Ledger Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Business ledger name. Map US or USA to TEREX US; UK to TEREX UK 120; CH or Switzerland to TEREX CH. Use this column for requests mentioning a ledger.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(201618797817401451)
,p_db_column_name=>'PERIOD_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Period Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Oracle accounting period in MON-YYYY format, such as AUG-2026. This report already contains the selected period. Filter only when the user explicitly mentions a period present in the report.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(201618923224401453)
,p_db_column_name=>'PERIOD_STATUS_DESCRIPTION'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Period Status'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Human-readable GL period state such as OPEN, CLOSED, FUTURE-ENTRY, NEVER OPENED, or PERMANENTLY CLOSED.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(201620181375401465)
,p_db_column_name=>'REFRESH_TIMESTAMP'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Refresh Timestamp'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Time when this report query produced the current row. Use only for data freshness questions; do not use it as an accounting activity date.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(201619459879401458)
,p_db_column_name=>'UNBALANCED_DUE_BATCHES'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Batches Out of Balance'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>unistr('Count of distinct journal batches where accounted debits and credits differ by more than 0.01. Treat \201Cout of balance\201D or \201Cunbalanced batches\201D as this measure.')
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(201619102730401454)
,p_db_column_name=>'UNPOSTED_DUE_HEADERS'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Unposted Journals'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>unistr('Count of unposted GL journal headers for the entire selected period. Treat \201Cunposted journals\201D and \201Cjournals not posted\201D as this column. It is a journal count, not a batch or line count.')
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(201704824447421210)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'LEDGER_ID:LEDGER_NAME:PERIOD_NAME:PERIOD_STATUS_DESCRIPTION:UNPOSTED_DUE_HEADERS:ERROR_STATUS_HEADERS:UNBALANCED_DUE_BATCHES:INTERFACE_ROW_COUNT:EARLIEST_UNPOSTED_DUE_DATE:LATEST_UNPOSTED_DUE_DATE:REFRESH_TIMESTAMP'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(201685552746418787)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(198247828492284648)
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
 p_id=>wwv_flow_imp.id(198249957354284669)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(198247828492284648)
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
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(203868905541296974)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(198247828492284648)
,p_button_name=>'VIEW_UNPOSTED_JOURNALS'
,p_static_id=>'view-unposted-journals'
,p_show_as_disabled=>false
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'View Unposted Journals'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-book-open'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(255684415641474859)
,p_name=>'P10_DB_LINK'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(198247828492284648)
,p_item_default=>'ADG'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_cHeight=>1
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(203868803046296973)
,p_name=>'P10_GL_UNPOSTED_URL'
,p_item_sequence=>40
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(198247962146284649)
,p_name=>'P10_PERIOD_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(198247828492284648)
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
 p_id=>wwv_flow_imp.id(202853530345954553)
,p_name=>'Close'
,p_static_id=>'close'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(201685552746418787)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(202853662305954554)
,p_event_id=>wwv_flow_imp.id(202853530345954553)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'window.close();')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(203868967734296975)
,p_name=>'Open Unposted Journals'
,p_static_id=>'open-unposted-journals'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(203868905541296974)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(203869023302296976)
,p_event_id=>wwv_flow_imp.id(203868967734296975)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-execute-plsql-code'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'items_to_return', 'P10_GL_UNPOSTED_URL',
  'items_to_submit', 'P10_PERIOD_NAME,P10_DB_LINK',
  'language', 'PLSQL',
  'plsql_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    ':P10_GL_UNPOSTED_URL := apex_page.get_url(',
    '    p_page        => 11,',
    '    p_clear_cache => ''11'',',
    '    p_items       => ''P11_PERIOD_NAME,P11_DB_LINK'',',
    '    p_values      => :P10_PERIOD_NAME || '','' || :P10_DB_LINK',
    ');')),
  'show_processing', 'N',
  'suppress_change_event', 'N')).to_clob
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(203869145847296977)
,p_event_id=>wwv_flow_imp.id(203868967734296975)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'apex.navigation.openInNewWindow(',
    '    $v("P10_GL_UNPOSTED_URL"),',
    '    "tms_gl_unposted"',
    ');')))).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(198250106378284670)
,p_name=>'Refresh GL Report'
,p_static_id=>'refresh-gl-report'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(198249957354284669)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(198250148997284671)
,p_event_id=>wwv_flow_imp.id(198250106378284670)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-refresh'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(198248075567284650)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'maintain_pagination', 'N')).to_clob
);
wwv_flow_imp.component_end;
end;
/
