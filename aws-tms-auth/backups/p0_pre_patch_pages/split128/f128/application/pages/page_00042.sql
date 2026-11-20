prompt --application/pages/page_00042
begin
--   Manifest
--     PAGE: 00042
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
 p_id=>42
,p_name=>'SLA Accounting Errors'
,p_alias=>'SLA-ACCOUNTING-ERRORS'
,p_step_title=>'SLA Accounting Errors'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>4075783602716660119
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(18558063129193156)
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(186777686982726219)
,p_plug_name=>'Breadcrumb'
,p_static_id=>'breadcrumb'
,p_title=>'SLA Accounting Errors'
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
 p_id=>wwv_flow_imp.id(186777779849726219)
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
 p_id=>wwv_flow_imp.id(186777830720726219)
,p_plug_name=>'Instructions'
,p_static_id=>'instructions'
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
'        <h2 class="t-Alert-title">Select an exception before opening this page</h2>',
'      </div>',
'      <div class="t-Alert-body">',
'        Open Page 42 from an exception row on Payables, Receivables, or Cost',
'        Management. The selected period, database source, ledger, organization,',
'        entity, and exception type will be applied automatically.',
'      </div>',
'    </div>',
'  </div>',
'</div>'))
,p_plug_display_condition_type=>'EXPRESSION'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'NVL(:P42_RUN_SLA, ''N'') <> ''Y''',
'OR NVL(:P42_RUN_PERIOD, ''#'') <> NVL(:P42_PERIOD_NAME, ''#'')'))
,p_plug_display_when_cond2=>'PLSQL'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(327394276929142661)
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
 p_id=>wwv_flow_imp.id(257073918116477510)
,p_plug_name=>'Selected Exception Context'
,p_static_id=>'selected-exception-context'
,p_title=>'Selected Exception'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>25
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="t-Alert t-Alert--horizontal t-Alert--defaultIcons t-Alert--info" role="status">',
'  <div class="t-Alert-wrap">',
'    <div class="t-Alert-icon"><span class="t-Icon fa fa-search" aria-hidden="true"></span></div>',
'    <div class="t-Alert-content">',
'      <div class="t-Alert-header">',
'        <h2 class="t-Alert-title">Accounting error details</h2>',
'      </div>',
'      <div class="t-Alert-body">',
'        Period <strong>&P42_PERIOD_NAME!HTML.</strong> &middot;',
'        Ledger <strong>&P42_LEDGER_ID!HTML.</strong> &middot;',
'        Organization <strong>&P42_ORG_NAME!HTML. (&P42_ORG_ID!HTML.)</strong> &middot;',
'        Entity <strong>&P42_ENTITY_CODE!HTML.</strong> &middot;',
'        Source <strong>&P42_DB_LINK!HTML.</strong> &middot;',
'        Exception <strong>&P42_EXCEPTION_TYPE!HTML.</strong>',
'      </div>',
'    </div>',
'  </div>',
'</div>'))
,p_plug_display_condition_type=>'EXPRESSION'
,p_plug_display_when_condition=>':P42_SOURCE_PAGE IS NOT NULL'
,p_plug_display_when_cond2=>'PLSQL'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(186777994642726219)
,p_plug_name=>'SLA Accounting Errors'
,p_static_id=>'sla-accounting-errors'
,p_title=>'SLA Accounting Errors'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>30
,p_plug_item_display_point=>'ABOVE'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT accounting_error_id,',
'       application_id,',
'       sla_source,',
'       ledger_id,',
'       ledger_name,',
'       organization_id,',
'       entity_code,',
'       source_transaction_id,',
'       transaction_number,',
'       event_id,',
'       event_type_code,',
'       event_status_code,',
'       process_status_code,',
'       transaction_date,',
'       ae_header_id,',
'       ae_line_num,',
'       accounting_date,',
'       accounting_entry_status_code,',
'       gl_transfer_status_code,',
'       message_number,',
'       error_source_code,',
'       error_message,',
'       error_creation_date,',
'       error_age_days,',
'       exception_type,',
'       severity,',
'       refresh_timestamp',
'FROM TABLE(',
'    xxme_sla_error_drill_pkg.get_errors(',
'        :P42_RUN_PERIOD,',
'        TO_NUMBER(:P42_APPLICATION_ID),',
'        TO_NUMBER(:P42_LEDGER_ID),',
'        TO_NUMBER(:P42_ORG_ID),',
'        :P42_ENTITY_CODE,',
'        :P42_DB_LINK',
'    )',
') e',
'WHERE (:P42_EXCEPTION_TYPE IS NULL OR UPPER(e.exception_type) = UPPER(:P42_EXCEPTION_TYPE))',
'ORDER BY sla_source,',
'         ledger_id,',
'         transaction_date,',
'         event_id,',
'         accounting_error_id'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P42_PERIOD_NAME,P42_RUN_PERIOD,P42_RUN_SLA,P42_APPLICATION_ID,P42_LEDGER_ID,P42_ORG_ID,P42_ENTITY_CODE,P42_EXCEPTION_TYPE,P42_DB_LINK'
,p_plug_display_condition_type=>'EXPRESSION'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P42_RUN_SLA = ''Y''',
'AND :P42_RUN_PERIOD = :P42_PERIOD_NAME'))
,p_plug_display_when_cond2=>'PLSQL'
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
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(186778059615726219)
,p_no_data_found_message=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="t-Alert t-Alert--success t-Alert--horizontal">',
'  <div class="t-Alert-wrap">',
'    <div class="t-Alert-icon">',
'      <span class="t-Icon fa fa-check-circle" aria-hidden="true"></span>',
'    </div>',
'    <div class="t-Alert-content">',
'      <div class="t-Alert-header">',
'        <h2 class="t-Alert-title">No active SLA accounting errors found</h2>',
'      </div>',
'      <div class="t-Alert-body">',
'        No active processing/accounting errors were found for Payables,',
'        Receivables, or Cost Management for the selected period and approved',
'        ledger scope.',
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
,p_internal_uid=>20646141499248710
,p_ai_report_hint=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Active Subledger Accounting errors for Payables, Receivables, and Cost Management in the selected TMS database source, accounting period, ledger scope, and optional organization.',
'Use ERROR_MESSAGE as the authoritative error text. ERROR_AGE_DAYS is the age of the unresolved error. TRANSACTION_NUMBER and EVENT_ID identify the affected transaction and SLA event.',
'Do not claim an error is resolved, transferred, or posted unless the displayed data explicitly proves that state.'))
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(186779751238726227)
,p_db_column_name=>'ACCOUNTING_DATE'
,p_display_order=>170
,p_column_identifier=>'R'
,p_column_label=>'Accounting Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'GL accounting date associated with the unresolved SLA event.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(186779885553726227)
,p_db_column_name=>'ACCOUNTING_ENTRY_STATUS_CODE'
,p_display_order=>180
,p_column_identifier=>'S'
,p_column_label=>'Accounting Entry Status'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(186778145225726219)
,p_db_column_name=>'ACCOUNTING_ERROR_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Accounting Error ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(186779545079726227)
,p_db_column_name=>'AE_HEADER_ID'
,p_display_order=>150
,p_column_identifier=>'P'
,p_column_label=>'Accounting Header ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(186779698854726227)
,p_db_column_name=>'AE_LINE_NUM'
,p_display_order=>160
,p_column_identifier=>'Q'
,p_column_label=>'Accounting Line Number'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(186778237615726226)
,p_db_column_name=>'APPLICATION_ID'
,p_display_order=>20
,p_column_identifier=>'C'
,p_column_label=>'Application ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(186778807661726227)
,p_db_column_name=>'ENTITY_CODE'
,p_display_order=>70
,p_column_identifier=>'H'
,p_column_label=>'Entity'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'SLA entity code describing the Oracle transaction entity type.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(186780451882726227)
,p_db_column_name=>'ERROR_AGE_DAYS'
,p_display_order=>240
,p_column_identifier=>'Y'
,p_column_label=>'Error Age Days'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Number of days the accounting error has remained unresolved as of the report run.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(186780342471726227)
,p_db_column_name=>'ERROR_CREATION_DATE'
,p_display_order=>230
,p_column_identifier=>'X'
,p_column_label=>'Error Created'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Timestamp when Oracle SLA recorded the accounting error.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(186780271248726227)
,p_db_column_name=>'ERROR_MESSAGE'
,p_display_order=>220
,p_column_identifier=>'W'
,p_column_label=>'Error Message'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Authoritative Oracle SLA accounting error message. Preserve its meaning when summarizing causes or recommended actions.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(186780165140726227)
,p_db_column_name=>'ERROR_SOURCE_CODE'
,p_display_order=>210
,p_column_identifier=>'V'
,p_column_label=>'Error Source'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Oracle source code identifying where the accounting error was recorded.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(186779117961726227)
,p_db_column_name=>'EVENT_ID'
,p_display_order=>100
,p_column_identifier=>'K'
,p_column_label=>'Event ID'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Technical SLA event identifier. Use it to identify a specific event; do not present it as a transaction number.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(186779233968726227)
,p_db_column_name=>'EVENT_STATUS_CODE'
,p_display_order=>120
,p_column_identifier=>'M'
,p_column_label=>'Event Status'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(186779208670726227)
,p_db_column_name=>'EVENT_TYPE_CODE'
,p_display_order=>110
,p_column_identifier=>'L'
,p_column_label=>'Event Type'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Oracle SLA event type code for the affected accounting event.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(186780599670726227)
,p_db_column_name=>'EXCEPTION_TYPE'
,p_display_order=>250
,p_column_identifier=>'Z'
,p_column_label=>'Exception Type'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(186779952637726227)
,p_db_column_name=>'GL_TRANSFER_STATUS_CODE'
,p_display_order=>190
,p_column_identifier=>'T'
,p_column_label=>'GL Transfer Status'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(186778419829726226)
,p_db_column_name=>'LEDGER_ID'
,p_display_order=>40
,p_column_identifier=>'E'
,p_column_label=>'Ledger ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(186778615263726226)
,p_db_column_name=>'LEDGER_NAME'
,p_display_order=>50
,p_column_identifier=>'F'
,p_column_label=>'Ledger'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Business ledger name for the selected accounting-error scope.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(186780110465726227)
,p_db_column_name=>'MESSAGE_NUMBER'
,p_display_order=>200
,p_column_identifier=>'U'
,p_column_label=>'Message Number'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(186778670823726226)
,p_db_column_name=>'ORGANIZATION_ID'
,p_display_order=>60
,p_column_identifier=>'G'
,p_column_label=>'Organization ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(186779382435726227)
,p_db_column_name=>'PROCESS_STATUS_CODE'
,p_display_order=>130
,p_column_identifier=>'N'
,p_column_label=>'Process Status'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(186780770670726227)
,p_db_column_name=>'REFRESH_TIMESTAMP'
,p_display_order=>270
,p_column_identifier=>'AB'
,p_column_label=>'Refresh Timestamp'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(186780657635726227)
,p_db_column_name=>'SEVERITY'
,p_display_order=>260
,p_column_identifier=>'AA'
,p_column_label=>'Severity'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(186778344092726226)
,p_db_column_name=>'SLA_SOURCE'
,p_display_order=>30
,p_column_identifier=>'D'
,p_column_label=>'SLA Source'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Source subledger: Payables, Receivables, or Cost Management.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(186778918072726227)
,p_db_column_name=>'SOURCE_TRANSACTION_ID'
,p_display_order=>80
,p_column_identifier=>'I'
,p_column_label=>'Source Transaction ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(186779447054726227)
,p_db_column_name=>'TRANSACTION_DATE'
,p_display_order=>140
,p_column_identifier=>'O'
,p_column_label=>'Transaction Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Business date of the source transaction associated with the SLA event.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(186779007902726227)
,p_db_column_name=>'TRANSACTION_NUMBER'
,p_display_order=>90
,p_column_identifier=>'J'
,p_column_label=>'Transaction Number'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Business transaction number. Prefer this value when referring to the affected invoice, receipt, or cost transaction.'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(186782125957737873)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ACCOUNTING_ERROR_ID:APPLICATION_ID:SLA_SOURCE:LEDGER_ID:LEDGER_NAME:ORGANIZATION_ID:ENTITY_CODE:SOURCE_TRANSACTION_ID:TRANSACTION_NUMBER:EVENT_ID:EVENT_TYPE_CODE:EVENT_STATUS_CODE:PROCESS_STATUS_CODE:TRANSACTION_DATE:AE_HEADER_ID:AE_LINE_NUM:ACCOUNTI'
||'NG_DATE:ACCOUNTING_ENTRY_STATUS_CODE:GL_TRANSFER_STATUS_CODE:MESSAGE_NUMBER:ERROR_SOURCE_CODE:ERROR_MESSAGE:ERROR_CREATION_DATE:ERROR_AGE_DAYS:EXCEPTION_TYPE:SEVERITY:REFRESH_TIMESTAMP'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(186781308059726229)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(186777779849726219)
,p_button_name=>'CLOSE_PAGE'
,p_static_id=>'close-page'
,p_show_as_disabled=>false
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Back to Exceptions'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-arrow-left'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(257073918116477520)
,p_name=>'P42_APPLICATION_ID'
,p_item_sequence=>80
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(255684415641506859)
,p_name=>'P42_DB_LINK'
,p_item_sequence=>120
,p_item_default=>'ADG'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(257073918116477523)
,p_name=>'P42_ENTITY_CODE'
,p_item_sequence=>110
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(257073918116477524)
,p_name=>'P42_EXCEPTION_TYPE'
,p_item_sequence=>120
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(257073918116477521)
,p_name=>'P42_LEDGER_ID'
,p_item_sequence=>90
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(257073918116477522)
,p_name=>'P42_ORG_ID'
,p_item_sequence=>100
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(264726415640464850)
,p_name=>'P42_ORG_NAME'
,p_item_sequence=>105
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(186780844222726227)
,p_name=>'P42_PERIOD_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(186777779849726219)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select upper(to_char(trunc(sysdate, ''MM''), ''MON-YYYY'', ''NLS_DATE_LANGUAGE=English''))',
'from dual'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Accounting Period'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(264726415640464851)
,p_name=>'P42_RETURN_URL'
,p_item_sequence=>125
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(186780938248726229)
,p_name=>'P42_RUN_PERIOD'
,p_item_sequence=>40
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(186781073824726229)
,p_name=>'P42_RUN_SLA'
,p_item_sequence=>50
,p_item_default=>'N'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(257073918116477525)
,p_name=>'P42_SOURCE_PAGE'
,p_item_sequence=>130
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(186781405967726229)
,p_name=>'Close Page'
,p_static_id=>'close-page'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(186781308059726229)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(186781434027726229)
,p_event_id=>wwv_flow_imp.id(186781405967726229)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_name=>'Return to Source Page'
,p_static_id=>'close-window'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'const returnUrl = apex.item("P42_RETURN_URL").getValue();',
    'if (returnUrl) {',
    '    apex.navigation.redirect(returnUrl);',
    '} else {',
    '    window.close();',
    '}')))).to_clob
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(264726415640464852)
,p_event_id=>wwv_flow_imp.id(186781405967726229)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'Generate Return URL'
,p_static_id=>'generate-return-url'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'items_to_return', 'P42_RETURN_URL',
  'items_to_submit', 'P42_SOURCE_PAGE',
  'language', 'PLSQL',
  'plsql_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    ':P42_RETURN_URL :=',
    '    case :P42_SOURCE_PAGE',
    '        when ''41'' then apex_page.get_url(',
    '            p_page        => 41,',
    '            p_clear_cache => ''41''',
    '        )',
    '        when ''20'' then apex_page.get_url(p_page => 20)',
    '        when ''30'' then apex_page.get_url(p_page => 30)',
    '        else null',
    '    end;')),
  'show_processing', 'N',
  'suppress_change_event', 'N')).to_clob
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(264726415640464859)
,p_process_sequence=>5
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Resolve Organization Name'
,p_static_id=>'resolve-organization-name'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_db_link VARCHAR2(30);',
'    l_sql     VARCHAR2(1000);',
'BEGIN',
'    :P42_ORG_NAME := NULL;',
'',
'    IF :P42_ORG_ID IS NOT NULL',
'       AND :P42_DB_LINK IS NOT NULL',
'       AND :P42_APPLICATION_ID IS NOT NULL',
'    THEN',
'        l_db_link := xxme_db_source_pkg.normalize_db_link(:P42_DB_LINK);',
'',
'        IF TO_NUMBER(:P42_APPLICATION_ID) IN (200, 222) THEN',
'            l_sql :=',
'                ''SELECT MAX(TRIM(name)) '' ||',
'                ''FROM apps.hr_operating_units@'' || l_db_link ||',
'                '' WHERE organization_id = :1'';',
'        ELSIF TO_NUMBER(:P42_APPLICATION_ID) = 707 THEN',
'            l_sql :=',
'                ''SELECT MAX(TRIM(organization_name)) '' ||',
'                ''FROM apps.org_organization_definitions@'' || l_db_link ||',
'                '' WHERE organization_id = :1'';',
'        END IF;',
'',
'        IF l_sql IS NOT NULL THEN',
'            EXECUTE IMMEDIATE l_sql',
'                INTO :P42_ORG_NAME',
'                USING TO_NUMBER(:P42_ORG_ID);',
'        END IF;',
'    END IF;',
'',
'    IF :P42_ORG_ID IS NOT NULL AND :P42_ORG_NAME IS NULL THEN',
'        :P42_ORG_NAME := ''Unknown organization'';',
'    END IF;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>120042000000000010
);
wwv_flow_imp.component_end;
end;
/
