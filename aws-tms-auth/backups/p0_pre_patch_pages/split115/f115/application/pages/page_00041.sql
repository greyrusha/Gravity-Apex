prompt --application/pages/page_00041
begin
--   Manifest
--     PAGE: 00041
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
 p_id=>41
,p_name=>'Cost Management SLA'
,p_alias=>'SUBLEDGER-ACCOUNTING-ON-DEMAND'
,p_step_title=>'Cost Management SLA'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'body.sla-processing::before {',
'    content: "";',
'    position: fixed;',
'    inset: 0;',
'    background: rgba(255, 255, 255, 0.78);',
'    z-index: 9998;',
'}',
'',
'body.sla-processing .u-Processing {',
'    z-index: 10000 !important;',
'}',
'',
'#sla-processing-message {',
'    position: fixed;',
'    top: calc(50% + 45px);',
'    left: 50%;',
'    transform: translateX(-50%);',
'    z-index: 10001;',
'    min-width: 360px;',
'    max-width: 520px;',
'    padding: 18px 24px;',
'    border-radius: 8px;',
'    background: #ffffff;',
'    box-shadow: 0 4px 18px rgba(0, 0, 0, 0.22);',
'    text-align: center;',
'    color: #202020;',
'}',
'',
'#sla-processing-message strong {',
'    display: block;',
'    margin-bottom: 8px;',
'    font-size: 1.15rem;',
'}',
'',
'#sla-processing-message div {',
'    margin-top: 4px;',
'}'))
,p_step_template=>4075783602716660119
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(9156329399484443)
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(193433835922853139)
,p_plug_name=>'Breadcrumb'
,p_static_id=>'breadcrumb'
,p_title=>'Cost Management SLA'
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
 p_id=>wwv_flow_imp.id(192867016006153576)
,p_plug_name=>'Filters'
,p_static_id=>'filters'
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
 p_id=>wwv_flow_imp.id(317992543199432948)
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
 p_id=>wwv_flow_imp.id(192867452083153580)
,p_plug_name=>'Warning'
,p_static_id=>'sla-instructions'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>20
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="t-Alert t-Alert--horizontal t-Alert--defaultIcons t-Alert--info">',
'  <div class="t-Alert-wrap">',
'    <div class="t-Alert-icon">',
'      <span class="t-Icon"></span>',
'    </div>',
'    <div class="t-Alert-content">',
'      <div class="t-Alert-header">',
'        <h2 class="t-Alert-title">Cost Management SLA Analysis runs on demand</h2>',
'      </div>',
'      <div class="t-Alert-body">',
'        Select an accounting period and click',
'        <strong>Run Analysis</strong>.',
unistr('        The analysis may take approximately 30\201360 seconds.'),
'      </div>',
'    </div>',
'  </div>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(193436237082894631)
,p_plug_name=>'Subledger Accounting'
,p_static_id=>'subledger-accounting'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>30
,p_plug_item_display_point=>'ABOVE'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT CASE',
'           WHEN s.exception_type = ''PROCESSING/ACCOUNTING ERROR''',
'           THEN ''View Details''',
'       END AS detail_action,',
'       s.ledger_id,',
'       s.ledger_name,',
'       s.org_id,',
'       s.operating_unit,',
'       s.application_id,',
'       s.sla_source,',
'       s.entity_code,',
'       s.exception_type,',
'       s.event_count,',
'       s.transaction_count,',
'       s.earliest_exception_date,',
'       s.latest_exception_date,',
'       s.oldest_exception_age_days,',
'       s.refresh_timestamp',
'FROM TABLE(',
'    xxme_sla_summary_pkg.get_summary(:P41_PERIOD_NAME, :P41_DB_LINK)',
') s',
'ORDER BY ledger_id,',
'         application_id,',
'         org_id,',
'         entity_code,',
'         exception_type'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P41_PERIOD_NAME,P41_DB_LINK,P41_RUN_SLA'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P41_RUN_SLA'
,p_plug_display_when_cond2=>'Y'
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
 p_id=>wwv_flow_imp.id(193436325389894632)
,p_no_data_found_message=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="t-Alert t-Alert--success t-Alert--horizontal">',
'  <div class="t-Alert-wrap">',
'    <div class="t-Alert-icon">',
'      <span class="t-Icon fa fa-check-circle" aria-hidden="true"></span>',
'    </div>',
'    <div class="t-Alert-content">',
'      <div class="t-Alert-header">',
'        <h2 class="t-Alert-title">No Cost Management SLA exceptions found</h2>',
'      </div>',
'      <div class="t-Alert-body">',
'        No Cost Management Subledger Accounting exceptions were found for',
'        the selected period and ledger scope.',
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
,p_internal_uid=>16462837348610502
,p_ai_search_mode=>'A'
,p_ai_report_hint=>wwv_flow_string.join(wwv_flow_t_varchar2(
'This is a trusted, read-only Oracle EBS Subledger Accounting exception summary',
'for Cost Management application 707 and the selected accounting period. It does',
'not include Payables or Receivables, because those are reported on Pages 20 and',
'30. Scope is limited to ledger 1003 TEREX US, ledger 5001 TEREX UK 120, and',
'ledger 10001 TEREX CH. The analysis runs on demand.',
'',
'Treat natural-language questions as requests to modify the current Interactive',
'Report. For requests containing how many, which, show, find, list, compare,',
'highest, lowest, oldest, newest, largest, or smallest, apply filters, sorting,',
'control breaks, grouping, aggregation, or highlighting. Do not refuse because',
'the request is phrased as a question. For event totals, filter and sum',
'EVENT_COUNT; report row count is only the number of aggregated exception groups.',
'',
'Each row is an aggregated group by ledger, inventory organization, Cost',
'Management entity, and exception type. Despite its legacy database alias,',
'OPERATING_UNIT contains the Inventory Organization name and ORG_ID contains the',
'Inventory Organization ID. EVENT_COUNT is distinct SLA events and',
'TRANSACTION_COUNT is distinct source transactions. These counts may differ,',
'especially for WIP.',
'',
'Entities can include MTL_ACCOUNTING_EVENTS for inventory/material accounting,',
'RCV_ACCOUNTING_EVENTS for receiving, WIP_ACCOUNTING_EVENTS for work in process,',
'and WO_ACCOUNTING_EVENTS for work orders. Exception types can include',
'PROCESSING/ACCOUNTING ERROR, ACCOUNTING NOT FINAL, NOT TRANSFERRED TO GL, and',
'UNPROCESSED EVENT. No rows mean no matching Cost Management',
'SLA exceptions were found for this analysis, not that all EBS processing or',
'enterprise month-end is complete.'))
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(193436825976894637)
,p_db_column_name=>'APPLICATION_ID'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Application Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Oracle SLA application identifier. It is always 707 for Cost Management on this page. Hide by default; it is not a ledger or organization identifier.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1008297328499369443)
,p_db_column_name=>'DETAIL_ACTION'
,p_display_order=>15
,p_column_identifier=>'N'
,p_column_label=>'Details'
,p_column_link=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_PERIOD_NAME,P42_APPLICATION_ID,P42_LEDGER_ID,P42_ORG_ID,P42_ENTITY_CODE,P42_EXCEPTION_TYPE,P42_RUN_SLA,P42_RUN_PERIOD,P42_SOURCE_PAGE,P42_DB_LINK:&P41_PERIOD_NAME.,#APPLICATION_ID#,#LEDGER_ID#,#ORG_ID#,#ENTIT'
||'Y_CODE#,#EXCEPTION_TYPE#,Y,&P41_PERIOD_NAME.,41,&P41_DB_LINK.'
,p_column_linktext=>'#DETAIL_ACTION#'
,p_column_link_attr=>'class="t-Button t-Button--small t-Button--noUI" aria-label="View accounting error details"'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(193437400050894643)
,p_db_column_name=>'EARLIEST_EXCEPTION_DATE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Earliest Exception Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Oldest exception date in the summary group. Use for oldest, before, since, and aging questions.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(193437065211894639)
,p_db_column_name=>'ENTITY_CODE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Entity Code'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Cost Management transaction entity. MTL_ACCOUNTING_EVENTS means material/inventory; RCV_ACCOUNTING_EVENTS means receiving; WIP_ACCOUNTING_EVENTS means work in process; WO_ACCOUNTING_EVENTS means work orders.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(193437243435894641)
,p_db_column_name=>'EVENT_COUNT'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Event Count'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Number of distinct SLA events in this summary group. Sum after applying filters for event totals; do not use report row count.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(193437129611894640)
,p_db_column_name=>'EXCEPTION_TYPE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Exception Type'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'SLA exception classification: PROCESSING/ACCOUNTING ERROR, ACCOUNTING NOT FINAL, NOT TRANSFERRED TO GL, or UNPROCESSED EVENT. Use exact filtering for errors, incomplete accounting, transfer, or unprocessed requests.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(193437534127894644)
,p_db_column_name=>'LATEST_EXCEPTION_DATE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Latest Exception Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Most recent exception date in the summary group. Use for newest, most recent, and after questions.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(193436455119894633)
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
 p_id=>wwv_flow_imp.id(193436551254894634)
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
 p_id=>wwv_flow_imp.id(193437649230894645)
,p_db_column_name=>'OLDEST_EXCEPTION_AGE_DAYS'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Oldest Exception Age Days'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>unistr('Calendar age of the oldest exception in the group. Larger means older. Use numeric filtering for \201Colder than N days.\201D')
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(193436758280894636)
,p_db_column_name=>'OPERATING_UNIT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Inventory Organization'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>unistr('Legacy alias containing the Inventory Organization name. Treat \201Cinventory org,\201D \201Cinventory organization,\201D \201Cplant,\201D \201Cwarehouse,\201D or \201Corganization\201D as filters on this column. Recommended visible heading: Inventory Organization.')
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(193436637075894635)
,p_db_column_name=>'ORG_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Inv Org ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Inventory Organization ID for Cost Management. This is not an AP or AR operating-unit ID on this page. Use OPERATING_UNIT for the inventory organization name.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(193437834232894647)
,p_db_column_name=>'REFRESH_TIMESTAMP'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Refresh Timestamp'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Time the on-demand SLA analysis query completed. It is not an event, transaction, or accounting date.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(193436889058894638)
,p_db_column_name=>'SLA_SOURCE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Sla Source'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Functional SLA source. It is always COST MANAGEMENT on this page. Do not interpret it as journal source.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(193437323498894642)
,p_db_column_name=>'TRANSACTION_COUNT'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Transaction Count'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Number of distinct Cost Management source transactions in the group. One transaction can have multiple SLA events, especially WIP, so this can be lower than EVENT_COUNT.'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(193448102647065784)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>1000
,p_report_columns=>'DETAIL_ACTION:LEDGER_ID:LEDGER_NAME:ORG_ID:OPERATING_UNIT:APPLICATION_ID:SLA_SOURCE:ENTITY_CODE:EXCEPTION_TYPE:EVENT_COUNT:TRANSACTION_COUNT:EARLIEST_EXCEPTION_DATE:LATEST_EXCEPTION_DATE:OLDEST_EXCEPTION_AGE_DAYS:REFRESH_TIMESTAMP'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(192867380920153579)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(192867016006153576)
,p_button_name=>'BACK_TO_DASHBOARD'
,p_static_id=>'back-to-dashboard'
,p_show_as_disabled=>false
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Close'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(192867279405153578)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(192867016006153576)
,p_button_name=>'RUN_SLA'
,p_static_id=>'run-sla'
,p_show_as_disabled=>false
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Run Analysis'
,p_button_position=>'CREATE'
,p_button_execute_validations=>'N'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(246282681911797146)
,p_name=>'P41_DB_LINK'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(192867016006153576)
,p_item_default=>'ADG'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_cHeight=>1
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(192867169270153577)
,p_name=>'P41_PERIOD_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(192867016006153576)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select upper(to_char(trunc(sysdate, ''MM''), ''MON-YYYY'', ''NLS_DATE_LANGUAGE=English''))',
'from dual'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Period Name'
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
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(193437911286894648)
,p_name=>'P41_RUN_SLA'
,p_item_sequence=>40
,p_item_default=>'N'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(193452227079245844)
,p_name=>'Close'
,p_static_id=>'close'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(192867380920153579)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(193452330206245845)
,p_event_id=>wwv_flow_imp.id(193452227079245844)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'window.close();')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(193438078263894649)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Enable SLA Report'
,p_static_id=>'enable-sla-report'
,p_process_sql_clob=>':P41_RUN_SLA := ''Y'';'
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(192867279405153578)
,p_internal_uid=>16464590222610519
);
wwv_flow_imp.component_end;
end;
/
