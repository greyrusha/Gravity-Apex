prompt --application/set_environment
set define off verify off feedback off
set autocommit off
whenever sqlerror continue none
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run this script using a SQL client connected to the database as
-- the owner (parsing schema) of the application or as a database user with the
-- APEX_ADMINISTRATOR_ROLE role.
--
-- This export file has been automatically generated. Modifying this file is not
-- supported by Oracle and can lead to unexpected application and/or instance
-- behavior now or in the future.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
apex_application_install.clear_all;
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2026.04.07'
,p_release=>'26.2.0'
,p_default_workspace_id=>100789
,p_default_application_id=>128
,p_default_id_offset=>9401733729708713
,p_default_owner=>'GL_ACCOUNTS'
);
if wwv_flow.g_flow_id <> 128 then
  apex_application_install.clear_all;
  raise_application_error(-20999, 'Unexpected g_flow_id=' || nvl(to_char(wwv_flow.g_flow_id), 'NULL'));
end if;
end;
/
 
prompt APPLICATION 128 - TMS GBS Control Tower (Working Copy: TMS GBS Control Tower Enhancements)
--
-- Application Export:
--   Application:     128
--   Name:            TMS GBS Control Tower (Working Copy: TMS GBS Control Tower Enhancements)
--   Exported By:     GL_ACCOUNTS
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PAGE: 1
--     PAGE: 10
--     PAGE: 11
--     PAGE: 20
--     PAGE: 22
--     PAGE: 23
--     PAGE: 30
--     PAGE: 41
--     PAGE: 50
--     PAGE: 61
--   Manifest End
--   Version:         26.2.0
--   Instance ID:     649767868204930
--

begin
  -- replace components
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/user_interface/lovs/tms_close_periods
begin
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(257401733729708814)
,p_lov_name=>'TMS_CLOSE_PERIODS'
,p_static_id=>'tms-close-periods'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select upper(to_char(period_start, ''MON-YYYY'', ''NLS_DATE_LANGUAGE=English'')) as display_value,',
'       upper(to_char(period_start, ''MON-YYYY'', ''NLS_DATE_LANGUAGE=English'')) as return_value,',
'       sort_seq',
'  from (',
'    select add_months(trunc(sysdate, ''MM''), 2 - level) as period_start,',
'           level as sort_seq',
'      from dual',
'    connect by level <= 6',
'  )'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'RETURN_VALUE'
,p_display_column_name=>'DISPLAY_VALUE'
,p_default_sort_column_name=>'SORT_SEQ'
,p_default_sort_direction=>'ASC'
);
end;
/
prompt --application/pages/delete_00001
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>1);
end;
/
prompt --application/pages/page_00001
begin
wwv_flow_imp_page.create_page(
 p_id=>1
,p_name=>'Month End Dashboard'
,p_alias=>'HOME'
,p_step_title=>'Month End Dashboard'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.kpi-card-body {',
'    margin: -8px -12px -12px -12px;',
'    padding: 14px 12px 16px 12px;',
'    border-left: 6px solid #287c96;',
'    border-radius: 4px;',
'    min-height: 76px;',
'    background-color: #edf7fb;',
'}',
'',
'/* Dashboard heading icon only; follows the existing native appearance palette. */',
'#R199448676502420593 .t-HeroRegion-icon {',
'  background-color: var(--tms-accent, #4840a8);',
'  color: var(--tms-on-accent, #fff);',
'}'))
,p_step_template=>4075783602716660119
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(18558063129193156)
,p_protection_level=>'C'
,p_page_component_map=>'13'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(201682347443418755)
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
 p_id=>wwv_flow_imp.id(199448676502420593)
,p_plug_name=>'Month End Dashboard'
,p_static_id=>'month-end-dashboard-title'
,p_icon_css_classes=>'fa-calendar-check-o'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2677445476673898083
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(202852961588954547)
,p_plug_name=>'MONTH_END_OVERVIEW'
,p_static_id=>'month_end_overview'
,p_title=>'Month End Overview'
,p_region_template_options=>'#DEFAULT#:t-CardsRegion--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2076152157930740558
,p_plug_display_sequence=>50
,p_plug_item_display_point=>'ABOVE'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'with gl as (',
' select 10 display_sequence,10 target_page,''P10_PERIOD_NAME'' target_item,''General Ledger'' card_title,''fa fa-book'' card_icon,',
'        sum(g.unposted_due_headers+g.error_status_headers+g.unbalanced_due_batches+g.interface_row_count) open_count,',
'        sum(case when g.ledger_id=1003 then g.unposted_due_headers+g.error_status_headers+g.unbalanced_due_batches+g.interface_row_count else 0 end) us_count,',
'        sum(case when g.ledger_id=5001 then g.unposted_due_headers+g.error_status_headers+g.unbalanced_due_batches+g.interface_row_count else 0 end) uk_count,',
'        sum(case when g.ledger_id=10001 then g.unposted_due_headers+g.error_status_headers+g.unbalanced_due_batches+g.interface_row_count else 0 end) ch_count',
' from table(xxme_gl_summary_pkg.get_summary(:P1_PERIOD_NAME,:P1_DB_LINK)) g',
'), exceptions as (',
' select 200 application_id,x.* from table(xxme_ap_ar_detail_pkg.get_summary(200,:P1_PERIOD_NAME,:P1_DB_LINK)) x',
' union all',
' select 222 application_id,x.* from table(xxme_ap_ar_detail_pkg.get_summary(222,:P1_PERIOD_NAME,:P1_DB_LINK)) x',
'), arap as (',
' select case application_id when 200 then 20 else 30 end display_sequence,case application_id when 200 then 20 else 30 end target_page,',
'        case application_id when 200 then ''P20_PERIOD_NAME'' else ''P30_PERIOD_NAME'' end target_item,',
'        case application_id when 200 then ''Payables SLA Exceptions'' else ''Receivables SLA Exceptions'' end card_title,',
'        case application_id when 200 then ''fa fa-file-text-o'' else ''fa fa-money'' end card_icon,',
'        sum(event_count) open_count,',
'        sum(case when ledger_id=1003 then event_count else 0 end) us_count,',
'        sum(case when ledger_id=5001 then event_count else 0 end) uk_count,',
'        sum(case when ledger_id=10001 then event_count else 0 end) ch_count',
' from exceptions',
' where exception_type in (''PROCESSING/ACCOUNTING ERROR'',''ACCOUNTING NOT FINAL'',''NOT TRANSFERRED TO GL'',''UNPROCESSED EVENT'')',
' group by application_id',
'), all_cards as (',
' select display_sequence,target_page,target_item,card_title,card_icon,nvl(open_count,0) open_count,nvl(us_count,0) us_count,nvl(uk_count,0) uk_count,nvl(ch_count,0) ch_count,',
'        nvl(open_count,0)||'' Open GL items<br>US: ''||nvl(us_count,0)||'' | UK: ''||nvl(uk_count,0)||'' | CH: ''||nvl(ch_count,0) card_text from gl',
' union all',
' select display_sequence,target_page,target_item,card_title,card_icon,nvl(open_count,0),nvl(us_count,0),nvl(uk_count,0),nvl(ch_count,0),',
'        nvl(open_count,0)||'' Open accounting exceptions<br>US: ''||nvl(us_count,0)||'' | UK: ''||nvl(uk_count,0)||'' | CH: ''||nvl(ch_count,0) from arap',
' union all select 40,41,''P41_PERIOD_NAME'',''Inventory/Cost Management SLA'',''fa fa-database'',null,null,null,null,''Open dedicated Inventory/Cost Management SLA analysis'' from dual',
' union all select 50,50,''P50_PERIOD_NAME'',''AI Month-End Analyst'',''fa fa-comments'',null,null,null,null,''Ask month-end questions in plain language'' from dual',
' where apex_application_admin.get_build_option_status(p_application_id=>:APP_ID,p_build_option_name=>''FEATURE_AI'') = ''INCLUDE''',
' union all select 50,null,null,''AI Analyst'',''fa fa-comments'',null,null,null,null,''Reserved for future AI Analyst capability.'' from dual',
' where apex_application_admin.get_build_option_status(p_application_id=>:APP_ID,p_build_option_name=>''FEATURE_AI'') = ''EXCLUDE''',
')',
'select display_sequence,card_title,card_text,card_icon,''kpi-neutral'' card_color_class,open_count,us_count,uk_count,ch_count,',
' case when target_page is null then ''N'' else ''Y'' end is_clickable,',
' case when target_page is null then null else apex_page.get_url(p_page=>target_page,p_clear_cache=>to_char(target_page),p_items=>target_item||'',P''||target_page||''_DB_LINK'',p_values=>:P1_PERIOD_NAME||'',''||:P1_DB_LINK) end card_link',
'from all_cards order by display_sequence'))
,p_lazy_loading=>true
,p_plug_source_type=>'NATIVE_CARDS'
,p_ajax_items_to_submit=>'P1_PERIOD_NAME,P1_DB_LINK'
,p_plug_query_num_rows_type=>'SCROLL'
,p_show_total_row_count=>false
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'G_DASHBOARD_READY'
,p_plug_display_when_cond2=>'Y'
);
wwv_flow_imp_page.create_card(
 p_id=>wwv_flow_imp.id(202853044746954548)
,p_region_id=>wwv_flow_imp.id(202852961588954547)
,p_layout_type=>'GRID'
,p_grid_column_count=>5
,p_title_adv_formatting=>false
,p_title_column_name=>'CARD_TITLE'
,p_sub_title_adv_formatting=>false
,p_body_adv_formatting=>true
,p_body_html_expr=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="kpi-card-body &CARD_COLOR_CLASS.">',
'  &CARD_TEXT!RAW.',
'</div>'))
,p_second_body_adv_formatting=>false
,p_icon_source_type=>'DYNAMIC_CLASS'
,p_icon_class_column_name=>'CARD_ICON'
,p_icon_position=>'START'
,p_media_adv_formatting=>false
);
wwv_flow_imp_page.create_card_action(
 p_id=>wwv_flow_imp.id(202853154510954549)
,p_card_id=>wwv_flow_imp.id(202853044746954548)
,p_action_type=>'FULL_CARD'
,p_display_sequence=>10
,p_static_id=>'action'
,p_link_target_type=>'REDIRECT_URL'
,p_link_target=>'&CARD_LINK.'
,p_link_attributes=>'target="_blank"'
,p_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_condition_expr1=>'IS_CLICKABLE'
,p_condition_expr2=>'Y'
,p_exec_cond_for_each_row=>true
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(201684574605418777)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(201682347443418755)
,p_button_name=>'REFRESH_GL'
,p_static_id=>'refresh-gl'
,p_show_as_disabled=>false
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Show Dashboard'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1016584965829300790)
,p_name=>'P1_AI_SERVICE_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(201682347443418755)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select coalesce(v(''G_AI_SERVICE_ID''), to_char(ai_server_id))',
'  from apex_applications',
' where application_id = :APP_ID'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'AI Provider / Model'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('select s.remote_server_name || '' \00B7 '' || s.provider_type || '' \00B7 '' ||'),
'       nvl(s.model_name,''Provider default'') display_value,',
'       to_char(s.remote_server_id) return_value',
'  from apex_workspace_ai_services s',
' where exists (',
'       select 1',
'         from apex_appl_ai_configs c',
'        where c.application_id = :APP_ID',
'          and c.remote_server_id = s.remote_server_id',
'          and c.agent_static_id in (',
'              ''month-end-analyst-claude'',',
'              ''month-end-analyst-deepseek'',',
'              ''month-end-analyst-gemini'',',
'              ''month-end-analyst-local-llm'',',
'              ''month-end-analyst-mlx-local'',',
'              ''month-end-analyst-openai'',',
'              ''month-end-analyst-oci''',
'          )',
'   )',
' order by s.remote_server_name'))
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_required_patch=>wwv_flow_imp.id(1026514276929100661)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(255684415641364850)
,p_name=>'P1_DB_LINK'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(201682347443418755)
,p_item_default=>'ADG'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_cHeight=>1
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(201682519741418756)
,p_name=>'P1_PERIOD_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(201682347443418755)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select upper(to_char(trunc(sysdate - 7, ''MM''), ''MON-YYYY'', ''NLS_DATE_LANGUAGE=English''))',
'from dual'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Period Name'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'TMS_CLOSE_PERIODS'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(987308144948403793)
,p_name=>'Select AI Provider'
,p_static_id=>'select-ai-provider'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1_AI_SERVICE_ID'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
,p_required_patch=>wwv_flow_imp.id(1026514276929100661)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(1016584965829300792)
,p_event_id=>wwv_flow_imp.id(987308144948403793)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'Store Provider and Start New Conversation'
,p_static_id=>'store-ai-provider'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'items_to_submit', 'P1_AI_SERVICE_ID',
  'language', 'PLSQL',
  'plsql_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    ':G_AI_SERVICE_ID := :P1_AI_SERVICE_ID;',
    'xxme_ai_chat_pkg.new_conversation;')),
  'show_processing', 'N')).to_clob
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(1026514276929100661)
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(255684415641364852)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Set Dashboard Database Source'
,p_static_id=>'set-dashboard-source'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    :G_DB_LINK := xxme_db_source_pkg.normalize_db_link(:P1_DB_LINK);',
'    :G_DASHBOARD_READY := ''Y'';',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(201684574605418777)
,p_internal_uid=>111000000000900003
);
end;
/
prompt --application/pages/delete_00010
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>10);
end;
/
prompt --application/pages/page_00010
begin
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
'select upper(to_char(trunc(sysdate - 7, ''MM''), ''MON-YYYY'', ''NLS_DATE_LANGUAGE=English''))',
'from dual'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Accounting Period'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'TMS_CLOSE_PERIODS'
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
end;
/
prompt --application/pages/delete_00011
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>11);
end;
/
prompt --application/pages/page_00011
begin
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
'select upper(to_char(trunc(sysdate - 7, ''MM''), ''MON-YYYY'', ''NLS_DATE_LANGUAGE=English''))',
'from dual'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Accounting Period'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'TMS_CLOSE_PERIODS'
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
end;
/
prompt --application/pages/delete_00020
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>20);
end;
/
prompt --application/pages/page_00020
begin
wwv_flow_imp_page.create_page(
 p_id=>20
,p_name=>'Payables Accounting Exceptions'
,p_alias=>'PAYABLES'
,p_step_title=>'Payables Accounting Exceptions'
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
 p_id=>wwv_flow_imp.id(217392637295987174)
,p_plug_name=>'Breadcrumb'
,p_static_id=>'breadcrumb'
,p_title=>'Payables Accounting Exceptions'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2534890969069732905
,p_plug_display_sequence=>40
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_menu_id=>wwv_flow_imp.id(199435849224420349)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4075790987805660140
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(212891010918422873)
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
 p_id=>wwv_flow_imp.id(212891257993422875)
,p_plug_name=>'Payables Exceptions'
,p_static_id=>'gl-readiness'
,p_title=>'Payables Exceptions'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>30
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
'        200,',
'        :P20_PERIOD_NAME,',
'        :P20_DB_LINK',
'    )',
') s'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P20_PERIOD_NAME,P20_DB_LINK'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Payables Exceptions'
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
 p_id=>wwv_flow_imp.id(198251513295284684)
,p_no_data_found_message=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="t-Alert t-Alert--success t-Alert--horizontal">',
'  <div class="t-Alert-wrap">',
'    <div class="t-Alert-icon">',
'      <span class="t-Icon fa fa-check-circle" aria-hidden="true"></span>',
'    </div>',
'    <div class="t-Alert-content">',
'      <div class="t-Alert-header">',
'        <h2 class="t-Alert-title">No AP exceptions found</h2>',
'      </div>',
'      <div class="t-Alert-body">',
'        No Payables accounting exceptions were found for the selected period and ledger scope.',
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
,p_internal_uid=>11876291524291841
,p_ai_search_mode=>'A'
,p_ai_report_hint=>wwv_flow_string.join(wwv_flow_t_varchar2(
'This is a trusted, read-only Oracle EBS Payables accounting-exception summary',
'for the selected accounting period. Scope is limited to ledger 1003 TEREX US,',
'ledger 5001 TEREX UK 120, and ledger 10001 TEREX CH. Each row is an aggregated',
'exception group by ledger, operating unit, AP entity, and exception type; it is',
'not one invoice or payment.',
'',
'Treat natural-language questions as requests to modify the current Interactive',
'Report. For requests containing how many, which, show, find, list, compare,',
'highest, lowest, oldest, newest, largest, or smallest, apply filters, sorting,',
'control breaks, grouping, aggregation, or highlighting. Do not refuse because',
unistr('the request is phrased as a question. For a request such as \201CHow many AP invoice'),
unistr('exception events in TEREX US?\201D, filter LEDGER_NAME to TEREX US and ENTITY_CODE'),
'to AP_INVOICES, then sum EVENT_COUNT; do not use report row count as event count.',
'',
'EVENT_COUNT is the number of distinct SLA accounting events in the group.',
'TRANSACTION_COUNT is the number of distinct source AP transactions represented',
'by those events. Sum EVENT_COUNT for event totals; sum TRANSACTION_COUNT only',
'when the requested groups do not overlap. Report row count is the number of',
'summary groups, not the number of events, invoices, or payments.',
'',
'Exception types are PROCESSING/ACCOUNTING ERROR, ACCOUNTING NOT FINAL,',
'NOT TRANSFERRED TO GL, and UNPROCESSED EVENT. Every displayed row is an',
'open accounting exception. Use EVENT_DATE-based earliest, latest, and age',
'fields for chronology. Do not apply color or severity labels, and do not infer',
'that the module or month-end is complete merely because a filter returns no rows.'))
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(257051918116477510)
,p_db_column_name=>'DETAIL_ACTION'
,p_display_order=>15
,p_column_identifier=>'N'
,p_column_label=>'Details'
,p_column_link=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_PERIOD_NAME,P42_APPLICATION_ID,P42_LEDGER_ID,P42_ORG_ID,P42_ENTITY_CODE,P42_EXCEPTION_TYPE,P42_RUN_SLA,P42_RUN_PERIOD,P42_SOURCE_PAGE,P42_DB_LINK:&P20_PERIOD_NAME.,200,#LEDGER_ID#,#ORG_ID#,#ENTITY_CODE#,#EXCE'
||'PTION_TYPE#,Y,&P20_PERIOD_NAME.,20,&P20_DB_LINK.'
,p_column_linktext=>'#DETAIL_ACTION#'
,p_column_link_attr=>'class="t-Button t-Button--small t-Button--noUI" aria-label="View accounting error details"'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(198252333674284693)
,p_db_column_name=>'EARLIEST_EXCEPTION_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Earliest Exception Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Oldest exception date within this summary group. Use for oldest, before, since, or aging questions.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(198252020376284689)
,p_db_column_name=>'ENTITY_CODE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Entity Code'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>unistr('AP source entity. Expected business values are AP_INVOICES and AP_PAYMENTS. \201CInvoices\201D means AP_INVOICES; \201Cpayments\201D or \201Cchecks\201D means AP_PAYMENTS.')
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(198252205553284691)
,p_db_column_name=>'EVENT_COUNT'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Event Count'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Number of distinct SLA accounting events in this summary group. For event totals, sum this column after applying filters; do not use report row count.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(198252117809284690)
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
 p_id=>wwv_flow_imp.id(201618117046401444)
,p_db_column_name=>'LATEST_EXCEPTION_DATE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Latest Exception Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Most recent exception date within this summary group. Use for newest, most recent, or after questions.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(198251570364284685)
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
 p_id=>wwv_flow_imp.id(198251701673284686)
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
 p_id=>wwv_flow_imp.id(201618192821401445)
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
 p_id=>wwv_flow_imp.id(198251837715284688)
,p_db_column_name=>'OPERATING_UNIT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Operating Unit'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Payables operating-unit name. Use for questions mentioning company, business unit, or operating unit. Do not treat it as a ledger.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(198251816593284687)
,p_db_column_name=>'ORG_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Org Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Oracle EBS operating-unit identifier for this AP exception group. Use OPERATING_UNIT for name-based questions.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(201618382753401447)
,p_db_column_name=>'REFRESH_TIMESTAMP'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Refresh Timestamp'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Query refresh time. It is not an invoice date, payment date, event date, or accounting date.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(201618272647401446)
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
 p_id=>wwv_flow_imp.id(198252263495284692)
,p_db_column_name=>'TRANSACTION_COUNT'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Transaction Count'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Number of distinct source AP transactions represented in this group. It can differ from EVENT_COUNT because a transaction can have multiple events.'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(201705387572423113)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'DETAIL_ACTION:LEDGER_ID:LEDGER_NAME:ORG_ID:OPERATING_UNIT:ENTITY_CODE:EXCEPTION_TYPE:EVENT_COUNT:TRANSACTION_COUNT:EARLIEST_EXCEPTION_DATE:LATEST_EXCEPTION_DATE:OLDEST_EXCEPTION_AGE_DAYS:REFRESH_TIMESTAMP'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(327394276929120661)
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
 p_id=>wwv_flow_imp.id(201685667096418788)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(212891010918422873)
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
 p_id=>wwv_flow_imp.id(203668331188526466)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(212891010918422873)
,p_button_name=>'OPEN_AP_HOLDS'
,p_static_id=>'open-ap-holds'
,p_show_as_disabled=>false
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Open AP Holds'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(201019933920131138)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(212891010918422873)
,p_button_name=>'REFRESH_AP'
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
 p_id=>wwv_flow_imp.id(264704415640464850)
,p_name=>'P20_ACTIVE_HOLDS_URL'
,p_item_sequence=>30
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(255684415641484859)
,p_name=>'P20_DB_LINK'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(212891010918422873)
,p_item_default=>'ADG'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_cHeight=>1
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(212893096682422945)
,p_name=>'P20_PERIOD_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(212891010918422873)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select upper(to_char(trunc(sysdate - 7, ''MM''), ''MON-YYYY'', ''NLS_DATE_LANGUAGE=English''))',
'from dual'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Accounting Period'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'TMS_CLOSE_PERIODS'
,p_cHeight=>1
,p_colspan=>4
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(203668484679526467)
,p_name=>'New'
,p_static_id=>'new'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(203668331188526466)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(203668585830526468)
,p_event_id=>wwv_flow_imp.id(203668484679526467)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'generate-active-holds-url'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'items_to_return', 'P20_ACTIVE_HOLDS_URL',
  'items_to_submit', 'P20_DB_LINK',
  'language', 'PLSQL',
  'plsql_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    ':P20_ACTIVE_HOLDS_URL := apex_page.get_url(',
    '    p_page        => 21,',
    '    p_clear_cache => ''21'',',
    '    p_items       => ''P21_DB_LINK'',',
    '    p_values      => :P20_DB_LINK',
    ');')),
  'show_processing', 'N',
  'suppress_change_event', 'N')).to_clob
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(264704415640464851)
,p_event_id=>wwv_flow_imp.id(203668484679526467)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_static_id=>'open-active-holds'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'apex.navigation.openInNewWindow(',
    '    $v("P20_ACTIVE_HOLDS_URL"),',
    '    "tms_ap_active_holds"',
    ');')))).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(201029029408131186)
,p_name=>'Refresh AP Report'
,p_static_id=>'refresh-gl-report'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(201019933920131138)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(201029426245131188)
,p_event_id=>wwv_flow_imp.id(201029029408131186)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-refresh'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(212891257993422875)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'maintain_pagination', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(202853413643954551)
,p_name=>'Return to Dashboard'
,p_static_id=>'return-to-dashboard'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(201685667096418788)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(202853488267954552)
,p_event_id=>wwv_flow_imp.id(202853413643954551)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'window.close();')).to_clob
);
end;
/
prompt --application/pages/delete_00022
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>22);
end;
/
prompt --application/pages/page_00022
begin
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
,p_required_role=>wwv_flow_imp.id(18558063129193156)
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(991480666741987398)
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
 p_id=>wwv_flow_imp.id(991480666741987434)
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
 p_id=>wwv_flow_imp.id(991480666741986605)
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
 p_id=>wwv_flow_imp.id(991480666741986595)
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
 p_id=>wwv_flow_imp.id(991480666741986597)
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
 p_id=>wwv_flow_imp.id(991480666741986596)
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
 p_id=>wwv_flow_imp.id(991480666741986604)
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
 p_id=>wwv_flow_imp.id(991480666741986603)
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
 p_id=>wwv_flow_imp.id(991480666741986602)
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
 p_id=>wwv_flow_imp.id(991480666741986601)
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
 p_id=>wwv_flow_imp.id(991480666741986600)
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
 p_id=>wwv_flow_imp.id(991480666741986612)
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
 p_id=>wwv_flow_imp.id(991480666741986611)
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
 p_id=>wwv_flow_imp.id(991480666741986598)
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
 p_id=>wwv_flow_imp.id(991480666741986599)
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
 p_id=>wwv_flow_imp.id(991480666741986594)
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
 p_id=>wwv_flow_imp.id(991480666741986615)
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
 p_id=>wwv_flow_imp.id(991480666741986606)
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
 p_id=>wwv_flow_imp.id(991480666741986607)
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
 p_id=>wwv_flow_imp.id(991480666741986608)
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
 p_id=>wwv_flow_imp.id(991480666741986610)
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
 p_id=>wwv_flow_imp.id(991480666741986609)
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
 p_id=>wwv_flow_imp.id(991480666741987435)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>1000
,p_report_columns=>'SUPPLIER_NAME:SUPPLIER_NUMBER:VENDOR_SITE_CODE:INVOICE_NUM:INVOICE_DATE:MIN_DUE_DATE:MAX_DUE_DATE:INVOICE_CURRENCY_CODE:INVOICE_AMOUNT:ACCT_INVOICE_AMOUNT:OPEN_ENTERED_AMOUNT:OPEN_ACCOUNTED_AMOUNT:GL_LIABILITY_CODE'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(327394276929122661)
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
 p_id=>wwv_flow_imp.id(991480666741986396)
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
 p_id=>wwv_flow_imp.id(991480666741986397)
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
 p_id=>wwv_flow_imp.id(991480666741986419)
,p_button_sequence=>15
,p_button_plug_id=>wwv_flow_imp.id(991480666741986396)
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
 p_id=>wwv_flow_imp.id(991480666741986421)
,p_button_sequence=>17
,p_button_plug_id=>wwv_flow_imp.id(991480666741986396)
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
,p_required_patch=>wwv_flow_imp.id(1026514276929100661)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(991480666741986420)
,p_button_sequence=>16
,p_button_plug_id=>wwv_flow_imp.id(991480666741986396)
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
 p_id=>wwv_flow_imp.id(991480666741986416)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(991480666741986396)
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
 p_id=>wwv_flow_imp.id(991480666741986417)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(991480666741986396)
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
 p_id=>wwv_flow_imp.id(991480666741986414)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(991480666741986396)
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
 p_id=>wwv_flow_imp.id(991480666741986415)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(991480666741986396)
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
 p_id=>wwv_flow_imp.id(991480666741986495)
,p_name=>'P22_AS_OF_DATE'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(991480666741986396)
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
 p_id=>wwv_flow_imp.id(991480666741986497)
,p_name=>'P22_COMPANY_SEGMENT'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(991480666741986396)
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
 p_id=>wwv_flow_imp.id(991480666741986494)
,p_name=>'P22_DB_LINK'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(991480666741986396)
,p_item_default=>'ADG'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_cHeight=>1
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(991480666741986496)
,p_name=>'P22_LEDGER_ID'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(991480666741986396)
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
 p_id=>wwv_flow_imp.id(991480666741986498)
,p_name=>'P22_REPORT_READY'
,p_item_sequence=>100
,p_item_default=>'N'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(991480666741986500)
,p_name=>'P22_RUN_AS_OF_DATE'
,p_item_sequence=>102
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(991480666741986502)
,p_name=>'P22_RUN_COMPANY'
,p_item_sequence=>104
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(991480666741986499)
,p_name=>'P22_RUN_DB_LINK'
,p_item_sequence=>101
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(991480666741986501)
,p_name=>'P22_RUN_LEDGER_ID'
,p_item_sequence=>103
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(991480666741986706)
,p_name=>'Open Aging Analysis'
,p_static_id=>'open-aging-analysis'
,p_event_sequence=>50
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(991480666741986419)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(991480666741986707)
,p_event_id=>wwv_flow_imp.id(991480666741986706)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p22Controller.openAnalysis(23);')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(991480666741986710)
,p_name=>'Open AI Analysis'
,p_static_id=>'open-ai-analysis'
,p_event_sequence=>70
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(991480666741986421)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_required_patch=>wwv_flow_imp.id(1026514276929100661)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(991480666741986711)
,p_event_id=>wwv_flow_imp.id(991480666741986710)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p22Controller.openAnalysis(50);')).to_clob
,p_build_option_id=>wwv_flow_imp.id(1026514276929100661)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(991480666741986708)
,p_name=>'Open GL AP Reconciliation'
,p_static_id=>'open-gl-ap-reconciliation'
,p_event_sequence=>60
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(991480666741986420)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(991480666741986709)
,p_event_id=>wwv_flow_imp.id(991480666741986708)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p22Controller.openAnalysis(24);')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(991480666741986698)
,p_name=>'Reload Snapshot'
,p_static_id=>'reload-snapshot'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(991480666741986416)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(991480666741986699)
,p_event_id=>wwv_flow_imp.id(991480666741986698)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p22Controller.requestReload();')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(991480666741986700)
,p_name=>'Reset Page'
,p_static_id=>'reset-page'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(991480666741986417)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(991480666741986701)
,p_event_id=>wwv_flow_imp.id(991480666741986700)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p22Controller.reset();')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(991480666741986694)
,p_name=>'Run AP Trial Balance'
,p_static_id=>'run-ap-trial-balance'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(991480666741986414)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(991480666741986695)
,p_event_id=>wwv_flow_imp.id(991480666741986694)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p22Controller.check();')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(991480666741986696)
,p_name=>'Use Existing Snapshot'
,p_static_id=>'use-existing-snapshot'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(991480666741986415)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(991480666741986697)
,p_event_id=>wwv_flow_imp.id(991480666741986696)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p22Controller.useExisting();')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(991480666741986794)
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
 p_id=>wwv_flow_imp.id(991480666741986795)
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
 p_id=>wwv_flow_imp.id(991480666741986797)
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
 p_id=>wwv_flow_imp.id(991480666741986796)
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
'    xx_ap_trial_balance_pkg.acquire_snapshot_lock(',
'      p_ledger_id     => l_ledger_id,',
'      p_snapshot_date => l_as_of_date,',
'      p_company       => l_company,',
'      p_db_link       => l_db_link',
'    );',
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
end;
/
prompt --application/pages/delete_00023
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>23);
end;
/
prompt --application/pages/page_00023
begin
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
'  select aging_bucket, aging_bucket_sort, sum(nvl(open_accounted_amount,0)) amount',
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
end;
/
prompt --application/pages/delete_00030
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>30);
end;
/
prompt --application/pages/page_00030
begin
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
'select upper(to_char(trunc(sysdate - 7, ''MM''), ''MON-YYYY'', ''NLS_DATE_LANGUAGE=English''))',
'from dual'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Accounting Period'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'TMS_CLOSE_PERIODS'
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
end;
/
prompt --application/pages/delete_00041
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>41);
end;
/
prompt --application/pages/page_00041
begin
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
,p_required_role=>wwv_flow_imp.id(18558063129193156)
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(202835569652561852)
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
,p_menu_id=>wwv_flow_imp.id(199435849224420349)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4075790987805660140
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(202268749735862289)
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
 p_id=>wwv_flow_imp.id(327394276929141661)
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
 p_id=>wwv_flow_imp.id(202269185812862293)
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
 p_id=>wwv_flow_imp.id(202837970812603344)
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
 p_id=>wwv_flow_imp.id(202838059119603345)
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
 p_id=>wwv_flow_imp.id(202838559706603350)
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
 p_id=>wwv_flow_imp.id(1017699062229078156)
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
 p_id=>wwv_flow_imp.id(202839133780603356)
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
 p_id=>wwv_flow_imp.id(202838798941603352)
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
 p_id=>wwv_flow_imp.id(202838977165603354)
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
 p_id=>wwv_flow_imp.id(202838863341603353)
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
 p_id=>wwv_flow_imp.id(202839267857603357)
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
 p_id=>wwv_flow_imp.id(202838188849603346)
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
 p_id=>wwv_flow_imp.id(202838284984603347)
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
 p_id=>wwv_flow_imp.id(202839382960603358)
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
 p_id=>wwv_flow_imp.id(202838492010603349)
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
 p_id=>wwv_flow_imp.id(202838370805603348)
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
 p_id=>wwv_flow_imp.id(202839567962603360)
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
 p_id=>wwv_flow_imp.id(202838622788603351)
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
 p_id=>wwv_flow_imp.id(202839057228603355)
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
 p_id=>wwv_flow_imp.id(202849836376774497)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>1000
,p_report_columns=>'DETAIL_ACTION:LEDGER_ID:LEDGER_NAME:ORG_ID:OPERATING_UNIT:APPLICATION_ID:SLA_SOURCE:ENTITY_CODE:EXCEPTION_TYPE:EVENT_COUNT:TRANSACTION_COUNT:EARLIEST_EXCEPTION_DATE:LATEST_EXCEPTION_DATE:OLDEST_EXCEPTION_AGE_DAYS:REFRESH_TIMESTAMP'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(202269114649862292)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(202268749735862289)
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
 p_id=>wwv_flow_imp.id(202269013134862291)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(202268749735862289)
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
 p_id=>wwv_flow_imp.id(255684415641505859)
,p_name=>'P41_DB_LINK'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(202268749735862289)
,p_item_default=>'ADG'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_cHeight=>1
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202268902999862290)
,p_name=>'P41_PERIOD_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(202268749735862289)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select upper(to_char(trunc(sysdate - 7, ''MM''), ''MON-YYYY'', ''NLS_DATE_LANGUAGE=English''))',
'from dual'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Period Name'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'TMS_CLOSE_PERIODS'
,p_cHeight=>1
,p_colspan=>4
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202839645016603361)
,p_name=>'P41_RUN_SLA'
,p_item_sequence=>40
,p_item_default=>'N'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(202853960808954557)
,p_name=>'Close'
,p_static_id=>'close'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(202269114649862292)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(202854063935954558)
,p_event_id=>wwv_flow_imp.id(202853960808954557)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'window.close();')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(202839811993603362)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Enable SLA Report'
,p_static_id=>'enable-sla-report'
,p_process_sql_clob=>':P41_RUN_SLA := ''Y'';'
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(202269013134862291)
,p_internal_uid=>16464590222610519
);
end;
/
prompt --application/pages/delete_00050
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>50);
end;
/
prompt --application/pages/page_00050
begin
wwv_flow_imp_page.create_page(
 p_id=>50
,p_name=>'AI Month-End Analyst'
,p_alias=>'AI-MONTH-END-ANALYST'
,p_step_title=>'AI Month-End Analyst'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(function($){',
'  function showRelevantExamples(){',
'    var apSource=apex.item("P50_AP_SOURCE_PAGE").getValue();',
'    var arSource=apex.item("P50_AR_SOURCE_PAGE").getValue();',
'    var apScope=apex.item("P50_AP_SCOPE_AS_OF_DATE").getValue();',
'    var arScope=apex.item("P50_AR_SCOPE_AS_OF_DATE").getValue();',
'    var source="default";',
'    if(arScope&&["32","33","34"].indexOf(arSource)!==-1){source=arSource;}',
'    else if(apScope&&["22","23","24"].indexOf(apSource)!==-1){source=apSource;}',
'    var groups=$(".xxme-ai-context-set");',
'    var selected=groups.filter("[data-source-page=\""+source+"\"]");',
'    if(!selected.length){selected=groups.filter("[data-source-page=\"default\"]");}',
'    groups.attr("hidden","hidden");',
'    selected.removeAttr("hidden");',
'    $("#xxme-ai-context-title").text(selected.attr("data-title")||"Questions for this report");',
'  }',
'  $(function(){',
'    showRelevantExamples();',
'    $(document).off("click.xxmeAiExamples",".xxme-ai-example").on("click.xxmeAiExamples",".xxme-ai-example",function(){',
'      apex.item("P50_AI_QUESTION").setValue($(this).text().trim());',
'      var question=document.getElementById("P50_AI_QUESTION");',
'      if(question){question.scrollIntoView({behavior:"smooth",block:"center"});question.focus();}',
'    });',
'  });',
'})(apex.jQuery);'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.xxme-ai-examples{margin-top:1rem;}',
'.xxme-ai-examples h3{font-size:1rem;margin:.9rem 0 .45rem;}',
'.xxme-ai-example-list{display:grid;grid-template-columns:repeat(auto-fit,minmax(22rem,1fr));gap:.45rem;margin:0;padding:0;list-style:none;}',
'.xxme-ai-example{width:100%;height:auto;min-height:2.5rem;justify-content:flex-start;text-align:left;white-space:normal;line-height:1.35;padding:.55rem .75rem;}',
'.xxme-ai-example:hover{background:#eff6ff;border-color:#2563eb;}',
'.xxme-ai-example-note{margin-top:.8rem;color:var(--ut-component-text-muted-color);font-size:.875rem;}'))
,p_step_template=>4075783602716660119
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(18558063129193156)
,p_required_patch=>wwv_flow_imp.id(1026514276929100661)
,p_protection_level=>'C'
,p_page_component_map=>'03'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(201681896558418750)
,p_plug_name=>'AI Context'
,p_static_id=>'ai-context'
,p_title=>'AI Context'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>20
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1031484042829986390)
,p_plug_name=>'AR Snapshot Context'
,p_static_id=>'ar-snapshot-context'
,p_title=>'AR Snapshot Context'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>30
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_display_condition_type=>'EXISTS'
,p_plug_display_when_condition=>'select 1 from dual where :P50_AR_SCOPE_AS_OF_DATE is not null'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(201681476964418746)
,p_plug_name=>'Ask the Month-End Analyst'
,p_static_id=>'ask-the-month-end-analyst'
,p_title=>'Ask the Month-End Analyst'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>40
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Choose a suggested question or enter your own. Selecting a suggestion places it in the analyst question box for review before sending.</p>',
'<div class="xxme-ai-examples">',
'  <h3 id="xxme-ai-context-title">Questions for this report</h3>',
'  <div class="xxme-ai-context-set" data-source-page="22" data-title="Questions for the AP snapshot" hidden>',
'    <ul class="xxme-ai-example-list">',
'      <li><button type="button" class="t-Button xxme-ai-example">Summarize the selected AP snapshot and identify the largest supplier exposures.</button></li>',
'      <li><button type="button" class="t-Button xxme-ai-example">Show the top ten suppliers by open accounted balance in the selected AP snapshot.</button></li>',
'      <li><button type="button" class="t-Button xxme-ai-example">Identify the oldest open invoices and their suppliers in the selected AP snapshot.</button></li>',
'      <li><button type="button" class="t-Button xxme-ai-example">Summarize the selected AP open balance by full liability account.</button></li>',
'      <li><button type="button" class="t-Button xxme-ai-example">Identify unusual, negative, or high-risk balances in the selected AP snapshot.</button></li>',
'    </ul>',
'  </div>',
'  <div class="xxme-ai-context-set" data-source-page="23" data-title="Questions for AP aging" hidden>',
'    <ul class="xxme-ai-example-list">',
'      <li><button type="button" class="t-Button xxme-ai-example">Summarize the selected AP aging results by yearly bucket.</button></li>',
'      <li><button type="button" class="t-Button xxme-ai-example">Which suppliers have balances in the 4+ Years bucket?</button></li>',
'      <li><button type="button" class="t-Button xxme-ai-example">Show the largest overdue supplier exposures in the selected AP snapshot.</button></li>',
'      <li><button type="button" class="t-Button xxme-ai-example">Compare current AP balances with the older aging buckets.</button></li>',
'      <li><button type="button" class="t-Button xxme-ai-example">Show invoice detail for the most material supplier in the oldest aging bucket.</button></li>',
'    </ul>',
'  </div>',
'  <div class="xxme-ai-context-set" data-source-page="24" data-title="Questions for AP/GL reconciliation" hidden>',
'    <ul class="xxme-ai-example-list">',
'      <li><button type="button" class="t-Button xxme-ai-example">Which liability accounts have the largest non-zero AP/GL variances?</button></li>',
'      <li><button type="button" class="t-Button xxme-ai-example">Explain the largest AP/GL variance using the reconciliation bridge.</button></li>',
'      <li><button type="button" class="t-Button xxme-ai-example">Summarize AP not transferred to GL by full liability account.</button></li>',
'      <li><button type="button" class="t-Button xxme-ai-example">Identify material period non-payables activity affecting AP reconciliation.</button></li>',
'      <li><button type="button" class="t-Button xxme-ai-example">Which AP liability accounts require investigation before period close?</button></li>',
'    </ul>',
'  </div>',
'  <div class="xxme-ai-context-set" data-source-page="32" data-title="Questions for the AR snapshot" hidden>',
'    <ul class="xxme-ai-example-list">',
'      <li><button type="button" class="t-Button xxme-ai-example">Summarize the selected AR snapshot and identify the largest customer exposures.</button></li>',
'      <li><button type="button" class="t-Button xxme-ai-example">Show the top ten customers by open accounted balance in the selected AR snapshot.</button></li>',
'      <li><button type="button" class="t-Button xxme-ai-example">Identify the oldest open AR transactions and their customers.</button></li>',
'      <li><button type="button" class="t-Button xxme-ai-example">Summarize the selected AR open balance by full receivable account.</button></li>',
'      <li><button type="button" class="t-Button xxme-ai-example">Show transactions posted outside the approved AR control accounts.</button></li>',
'    </ul>',
'  </div>',
'  <div class="xxme-ai-context-set" data-source-page="33" data-title="Questions for AR aging" hidden>',
'    <ul class="xxme-ai-example-list">',
'      <li><button type="button" class="t-Button xxme-ai-example">Summarize the selected AR aging results by yearly bucket.</button></li>',
'      <li><button type="button" class="t-Button xxme-ai-example">Which customers have balances in the 4+ Years bucket?</button></li>',
'      <li><button type="button" class="t-Button xxme-ai-example">Show the largest overdue customer exposures in the selected AR snapshot.</button></li>',
'      <li><button type="button" class="t-Button xxme-ai-example">Compare current AR balances with the older aging buckets.</button></li>',
'      <li><button type="button" class="t-Button xxme-ai-example">Show transaction detail for the most material customer in the oldest aging bucket.</button></li>',
'    </ul>',
'  </div>',
'  <div class="xxme-ai-context-set" data-source-page="34" data-title="Questions for AR/GL reconciliation" hidden>',
'    <ul class="xxme-ai-example-list">',
'      <li><button type="button" class="t-Button xxme-ai-example">Which receivable accounts have the largest non-zero AR/GL variances?</button></li>',
'      <li><button type="button" class="t-Button xxme-ai-example">Explain the largest AR/GL variance using the reconciliation bridge.</button></li>',
'      <li><button type="button" class="t-Button xxme-ai-example">Summarize AR not transferred to GL by full receivable account.</button></li>',
'      <li><button type="button" class="t-Button xxme-ai-example">Identify material period non-receivables activity affecting AR reconciliation.</button></li>',
'      <li><button type="button" class="t-Button xxme-ai-example">Which AR control accounts require investigation before period close?</button></li>',
'    </ul>',
'  </div>',
'  <div class="xxme-ai-context-set" data-source-page="default" data-title="Questions for the selected month-end context">',
'    <ul class="xxme-ai-example-list">',
'      <li><button type="button" class="t-Button xxme-ai-example">Which accounting period and ledgers are currently in scope?</button></li>',
'      <li><button type="button" class="t-Button xxme-ai-example">What are the main GL readiness blockers for the selected period?</button></li>',
'      <li><button type="button" class="t-Button xxme-ai-example">Summarize current active AP holds by ledger and currency.</button></li>',
'      <li><button type="button" class="t-Button xxme-ai-example">Summarize current unapplied receipts by ledger and currency.</button></li>',
'      <li><button type="button" class="t-Button xxme-ai-example">Run Cost Management SLA analysis and show the open conditions.</button></li>',
'    </ul>',
'  </div>',
'  <h3>Application-wide questions</h3>',
'  <ul class="xxme-ai-example-list">',
'    <li><button type="button" class="t-Button xxme-ai-example">Give me an executive month-end summary and identify the top three priorities.</button></li>',
'    <li><button type="button" class="t-Button xxme-ai-example">Compare GL readiness across all ledgers in the selected period.</button></li>',
'    <li><button type="button" class="t-Button xxme-ai-example">Compare Payables and Receivables accounting exceptions by ledger.</button></li>',
'    <li><button type="button" class="t-Button xxme-ai-example">Identify the largest AP and AR open-balance exposures that require attention.</button></li>',
'    <li><button type="button" class="t-Button xxme-ai-example">What unresolved issues are most likely to prevent period close?</button></li>',
'  </ul>',
'  <p class="xxme-ai-example-note">Period-based analyses use the selected period. AP holds and AR unapplied receipts reflect the current live position.</p>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(201708108629520910)
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
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(203669088555526473)
,p_name=>'Conversation History'
,p_static_id=>'conversation-history'
,p_template=>3374665444246510938
,p_display_sequence=>25
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Comments--chat'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select seq_id,',
'       case c001',
'           when ''user'' then nvl(c003, :APP_USER)',
'           else ''Month-End Analyst''',
'       end as user_name,',
'       case c001',
'           when ''user'' then ''fa-user''',
'           else ''fa-comments''',
'       end as user_icon,',
'       apex_markdown.to_html(',
'           p_markdown => clob001',
'       ) as comment_text,',
'       case',
'           when c001 = ''user'' then',
'               to_char(d001, ''YYYY-MM-DD HH24:MI:SS'')',
'           when previous_role = ''user'' then',
'               to_char(d001, ''YYYY-MM-DD HH24:MI:SS'')',
unistr('               || '' \2022 '''),
'               || round((d001 - previous_date) * 86400)',
'               || '' sec''',
'           else',
'               to_char(d001, ''YYYY-MM-DD HH24:MI:SS'')',
'       end as comment_date,',
'       null as actions,',
'       null as attribute_1,',
'       null as attribute_2,',
'       null as attribute_3,',
'       null as attribute_4,',
'       null as comment_modifiers,',
'       case c001',
'           when ''user'' then ''u-color-8''',
'           else ''u-color-4''',
'       end as icon_modifier,',
'       c001 as message_role,',
'       c002 as period_name',
'  from (',
'        select c.*,',
'               lag(d001) over (order by seq_id) as previous_date,',
'               lag(c001) over (order by seq_id) as previous_role',
'          from apex_collections c',
'         where collection_name = ''XXME_AI_CHAT_HISTORY''',
'       )',
' order by seq_id'))
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>2616596457966365047
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'SHOW_ALL'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(203793376610515558)
,p_query_column_id=>6
,p_column_alias=>'ACTIONS'
,p_column_display_sequence=>80
,p_column_heading=>'Actions'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(203793441098515559)
,p_query_column_id=>7
,p_column_alias=>'ATTRIBUTE_1'
,p_column_display_sequence=>90
,p_column_heading=>'Attribute 1'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(203793572532515560)
,p_query_column_id=>8
,p_column_alias=>'ATTRIBUTE_2'
,p_column_display_sequence=>100
,p_column_heading=>'Attribute 2'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(203793687196515561)
,p_query_column_id=>9
,p_column_alias=>'ATTRIBUTE_3'
,p_column_display_sequence=>110
,p_column_heading=>'Attribute 3'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(203793725011515562)
,p_query_column_id=>10
,p_column_alias=>'ATTRIBUTE_4'
,p_column_display_sequence=>120
,p_column_heading=>'Attribute 4'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(203793065823515555)
,p_query_column_id=>5
,p_column_alias=>'COMMENT_DATE'
,p_column_display_sequence=>50
,p_column_heading=>'Comment Date'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(203793910179515563)
,p_query_column_id=>11
,p_column_alias=>'COMMENT_MODIFIERS'
,p_column_display_sequence=>130
,p_column_heading=>'Comment Modifiers'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(203792955177515554)
,p_query_column_id=>4
,p_column_alias=>'COMMENT_TEXT'
,p_column_display_sequence=>40
,p_column_heading=>'Comment Text'
,p_heading_alignment=>'LEFT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(203793956652515564)
,p_query_column_id=>12
,p_column_alias=>'ICON_MODIFIER'
,p_column_display_sequence=>140
,p_column_heading=>'Icon Modifier'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(203793213852515556)
,p_query_column_id=>13
,p_column_alias=>'MESSAGE_ROLE'
,p_column_display_sequence=>60
,p_column_heading=>'Message Role'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(203793249316515557)
,p_query_column_id=>14
,p_column_alias=>'PERIOD_NAME'
,p_column_display_sequence=>70
,p_column_heading=>'Period Name'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(203792666417515551)
,p_query_column_id=>1
,p_column_alias=>'SEQ_ID'
,p_column_display_sequence=>10
,p_column_heading=>'Seq Id'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(203792899696515553)
,p_query_column_id=>3
,p_column_alias=>'USER_ICON'
,p_column_display_sequence=>30
,p_column_heading=>'User Icon'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(203792731741515552)
,p_query_column_id=>2
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>20
,p_column_heading=>'User Name'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(201685977286418791)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(201681896558418750)
,p_button_name=>'BACK_TO_DASHBOARD'
,p_static_id=>'back-to-dashboard'
,p_show_as_disabled=>false
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Close AI Analyst'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(203670454907526487)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(201681476964418746)
,p_button_name=>'NEW_AI_CONVERSATION'
,p_static_id=>'new-ai-conversation'
,p_show_as_disabled=>false
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'New Conversation'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-plus'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(1054143724698301724)
,p_button_sequence=>15
,p_button_plug_id=>wwv_flow_imp.id(201681476964418746)
,p_button_name=>'REFRESH_EXEC_CONTEXT'
,p_static_id=>'refresh-exec-context'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Refresh Executive Context'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-refresh'
,p_button_comment=>'Explicitly rebuild the provider-independent Page 50 snapshot.'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(203669839037526481)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(201681476964418746)
,p_button_name=>'SEND_AI_MESSAGE'
,p_static_id=>'send-ai-message'
,p_show_as_disabled=>false
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2086257187394300437
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Send'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-send'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(99290905772534892)
,p_name=>'P50_ACTIVE_AI'
,p_item_sequence=>5
,p_item_plug_id=>wwv_flow_imp.id(201681476964418746)
,p_prompt=>'Active Ai'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select a.ai_server_name',
unistr('       || '' \00B7 '''),
'       || nvl(s.provider_type, ''Unknown provider'')',
unistr('       || '' \00B7 '''),
'       || nvl(s.model_name, ''Provider default'')',
'  from apex_applications a',
'  left join apex_workspace_ai_services s',
'    on s.remote_server_id = a.ai_server_id',
' where a.application_id = :APP_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_colspan=>12
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'N',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(203668955268526472)
,p_name=>'P50_AI_QUESTION'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(201681476964418746)
,p_prompt=>'Ask the Month-End Analyst'
,p_placeholder=>'Ask a question about GL, AP, AR, AP Holds, AR Unapplied Receipts, or Cost Management'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_colspan=>12
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'Y',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(203792012593515544)
,p_name=>'P50_AI_QUESTION_SEQ_ID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(201681476964418746)
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1019480666741986498)
,p_name=>'P50_AP_AS_OF_DATE'
,p_item_sequence=>90
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1019480666741986497)
,p_name=>'P50_AP_COMPANY'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(201681896558418750)
,p_prompt=>'AP Snapshot Company Code'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_display_when=>'select 1 from dual where :P50_AP_SCOPE_AS_OF_DATE is not null'
,p_display_when_type=>'EXISTS'
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1019480666741986496)
,p_name=>'P50_AP_LEDGER_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(201681896558418750)
,p_prompt=>'AP Snapshot Ledger ID'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_colspan=>4
,p_display_when=>'select 1 from dual where :P50_AP_SCOPE_AS_OF_DATE is not null'
,p_display_when_type=>'EXISTS'
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1019480666741986500)
,p_name=>'P50_AP_RECON_READY'
,p_item_sequence=>85
,p_item_default=>'N'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1019480666741986495)
,p_name=>'P50_AP_SCOPE_AS_OF_DATE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(201681896558418750)
,p_prompt=>'AP Snapshot As-of Date'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_display_when=>'select 1 from dual where :P50_AP_SCOPE_AS_OF_DATE is not null'
,p_display_when_type=>'EXISTS'
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1019480666741986499)
,p_name=>'P50_AP_SOURCE_PAGE'
,p_item_sequence=>80
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1031484042829986493)
,p_name=>'P50_AR_AGING_BUCKET_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(1031484042829986390)
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1031484042829986492)
,p_name=>'P50_AR_COMPANY'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(1031484042829986390)
,p_prompt=>'AR Snapshot Company Code'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1031484042829986491)
,p_name=>'P50_AR_LEDGER_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(1031484042829986390)
,p_prompt=>'AR Snapshot Ledger ID'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1031484042829986495)
,p_name=>'P50_AR_RECON_READY'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(1031484042829986390)
,p_item_default=>'N'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1031484042829986490)
,p_name=>'P50_AR_SCOPE_AS_OF_DATE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(1031484042829986390)
,p_prompt=>'AR Snapshot As-of Date'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_colspan=>4
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1031484042829986494)
,p_name=>'P50_AR_SOURCE_PAGE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(1031484042829986390)
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(255684415641514859)
,p_name=>'P50_DB_LINK'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(201681896558418750)
,p_item_default=>'ADG'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_cHeight=>1
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1054143724698301723)
,p_name=>'P50_EXEC_CONTEXT_STATUS'
,p_item_sequence=>7
,p_item_plug_id=>wwv_flow_imp.id(201681476964418746)
,p_item_default=>'Executive AI context loading...'
,p_prompt=>'Executive Context'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_colspan=>10
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'N',
  'show_line_breaks', 'Y')).to_clob
,p_item_comment=>'Application 119 only. Session snapshot status; provider-independent.'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(201681958464418751)
,p_name=>'P50_PERIOD_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(201681896558418750)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select upper(to_char(trunc(sysdate - 7, ''MM''), ''MON-YYYY'', ''NLS_DATE_LANGUAGE=English''))',
'from dual'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Period Name'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'TMS_CLOSE_PERIODS'
,p_cHeight=>1
,p_colspan=>4
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(203669958448526482)
,p_name=>'Click'
,p_static_id=>'click'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(203669839037526481)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(1054143724698301727)
,p_event_id=>wwv_flow_imp.id(203669958448526482)
,p_event_result=>'TRUE'
,p_action_sequence=>7
,p_execute_on_page_init=>'N'
,p_name=>'Ensure Executive Context'
,p_static_id=>'ensure-executive-context'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'items_to_submit', 'P50_PERIOD_NAME,P50_DB_LINK',
  'language', 'PLSQL',
  'plsql_code', 'xxme_ai_exec_context_pkg.ensure_snapshot(:P50_PERIOD_NAME, :P50_DB_LINK);',
  'show_processing', 'N',
  'suppress_change_event', 'N')).to_clob
,p_wait_for_result=>'Y'
,p_da_action_comment=>'Synchronous fallback. Normally a no-op because Page 50 preloads the same snapshot in the background.'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(203792359417515548)
,p_event_id=>wwv_flow_imp.id(203669958448526482)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_name=>'Generate AI Answer'
,p_static_id=>'generate-ai-answer'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'language', 'PLSQL',
  'plsql_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'apex_util.set_session_state(''P50_AP_AS_OF_DATE'', null);',
    ':P50_AP_AS_OF_DATE := null;',
    'xxme_ai_chat_pkg.generate_answer (',
    '    p_question_seq_id => :P50_AI_QUESTION_SEQ_ID',
    ');')),
  'show_processing', 'N')).to_clob
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(1031484042829987875)
,p_event_id=>wwv_flow_imp.id(203669958448526482)
,p_event_result=>'TRUE'
,p_action_sequence=>5
,p_execute_on_page_init=>'N'
,p_name=>'Isolate AI Conversation Scope'
,p_static_id=>'isolate-ai-conversation-scope'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'items_to_submit', 'P50_PERIOD_NAME,P50_DB_LINK,P50_AP_SCOPE_AS_OF_DATE,P50_AP_LEDGER_ID,P50_AP_COMPANY,P50_AR_SCOPE_AS_OF_DATE,P50_AR_LEDGER_ID,P50_AR_COMPANY,P50_AR_AGING_BUCKET_ID',
  'language', 'PLSQL',
  'plsql_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'declare',
    '  l_scope_key varchar2(4000);',
    '  l_previous  varchar2(4000);',
    'begin',
    '  l_scope_key := case',
    '    when :P50_AR_SCOPE_AS_OF_DATE is not null then',
    '      ''AR|'' || upper(nvl(:P50_DB_LINK,''-'')) || ''|'' || upper(nvl(:P50_PERIOD_NAME,''-'')) || ''|'' ||',
    '      nvl(:P50_AR_SCOPE_AS_OF_DATE,''-'') || ''|'' || nvl(:P50_AR_LEDGER_ID,''-'') || ''|'' ||',
    '      upper(nvl(:P50_AR_COMPANY,''-'')) || ''|'' || nvl(:P50_AR_AGING_BUCKET_ID,''-'')',
    '    when :P50_AP_SCOPE_AS_OF_DATE is not null then',
    '      ''AP|'' || upper(nvl(:P50_DB_LINK,''-'')) || ''|'' || upper(nvl(:P50_PERIOD_NAME,''-'')) || ''|'' ||',
    '      nvl(:P50_AP_SCOPE_AS_OF_DATE,''-'') || ''|'' || nvl(:P50_AP_LEDGER_ID,''-'') || ''|'' || upper(nvl(:P50_AP_COMPANY,''-''))',
    '    else ''ENTERPRISE|'' || upper(nvl(:P50_DB_LINK,''-'')) || ''|'' || upper(nvl(:P50_PERIOD_NAME,''-'')) end;',
    '  begin',
    '    select c001 into l_previous from apex_collections',
    '     where collection_name = ''P50_AI_SCOPE_STATE'' and seq_id = 1;',
    '  exception when no_data_found then l_previous := null; end;',
    '  if l_previous is not null and l_previous <> l_scope_key then',
    '    xxme_ai_chat_pkg.new_conversation;',
    '  end if;',
    '  apex_collection.create_or_truncate_collection(''P50_AI_SCOPE_STATE'');',
    '  apex_collection.add_member(p_collection_name=>''P50_AI_SCOPE_STATE'',p_c001=>l_scope_key);',
    'end;')),
  'show_processing', 'N')).to_clob
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(203670319794526485)
,p_event_id=>wwv_flow_imp.id(203669958448526482)
,p_event_result=>'TRUE'
,p_action_sequence=>100
,p_execute_on_page_init=>'N'
,p_static_id=>'native-clear'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P50_AI_QUESTION'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(203670410016526486)
,p_event_id=>wwv_flow_imp.id(203669958448526482)
,p_event_result=>'TRUE'
,p_action_sequence=>110
,p_execute_on_page_init=>'Y'
,p_static_id=>'native-set-focus'
,p_action=>'NATIVE_SET_FOCUS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P50_AI_QUESTION'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(203792447591515549)
,p_event_id=>wwv_flow_imp.id(203669958448526482)
,p_event_result=>'TRUE'
,p_action_sequence=>60
,p_execute_on_page_init=>'N'
,p_name=>'Refresh Answer'
,p_static_id=>'refresh-answer'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(203669088555526473)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'maintain_pagination', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(203792122859515546)
,p_event_id=>wwv_flow_imp.id(203669958448526482)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_name=>'Refresh Question'
,p_static_id=>'refresh-question'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(203669088555526473)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'maintain_pagination', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(203792618535515550)
,p_event_id=>wwv_flow_imp.id(203669958448526482)
,p_event_result=>'TRUE'
,p_action_sequence=>70
,p_execute_on_page_init=>'N'
,p_name=>'Remove processing indicator'
,p_static_id=>'remove-processing-indicator'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'if (window.xxmeAiChatSpinner) {',
    '    window.xxmeAiChatSpinner.remove();',
    '    window.xxmeAiChatSpinner = null;',
    '}',
    '')))).to_clob
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(203792243959515547)
,p_event_id=>wwv_flow_imp.id(203669958448526482)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_name=>'Show explicit processing indicator'
,p_static_id=>'show-explicit-processing-indicator'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'window.xxmeAiChatSpinner = apex.util.showSpinner(null, {',
    '    fixed: true,',
    '    alert: "The Month-End Analyst is preparing a response."',
    '});')))).to_clob
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(203792031776515545)
,p_event_id=>wwv_flow_imp.id(203669958448526482)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'Store Question'
,p_static_id=>'store-question'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'items_to_return', 'P50_AI_QUESTION_SEQ_ID',
  'items_to_submit', 'P50_AI_QUESTION,P50_PERIOD_NAME,P50_DB_LINK,P50_AP_SCOPE_AS_OF_DATE,P50_AP_LEDGER_ID,P50_AP_COMPANY,P50_AP_SOURCE_PAGE,P50_AP_RECON_READY,P50_AR_SCOPE_AS_OF_DATE,P50_AR_LEDGER_ID,P50_AR_COMPANY,P50_AR_AGING_BUCKET_ID,P50_AR_SOURCE_PAGE,P50_AR_RECON_R'
||'EADY',
  'language', 'PLSQL',
  'plsql_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'begin',
    '    :G_DB_LINK := xxme_db_source_pkg.normalize_db_link(:P50_DB_LINK);',
    '    :P50_AI_QUESTION_SEQ_ID := xxme_ai_chat_pkg.add_question (',
    '    p_question    => :P50_AI_QUESTION,',
    '    p_period_name => :P50_PERIOD_NAME',
    '    );',
    'end;')),
  'show_processing', 'N',
  'suppress_change_event', 'N')).to_clob
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(203865915440296944)
,p_name=>'Close'
,p_static_id=>'close'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(201685977286418791)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(203865973588296945)
,p_event_id=>wwv_flow_imp.id(203865915440296944)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'apex.page.cancelWarnOnUnsavedChanges();',
    'window.close();')))).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(203670616531526488)
,p_name=>'New'
,p_static_id=>'new'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(203670454907526487)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(203671009065526492)
,p_event_id=>wwv_flow_imp.id(203670616531526488)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_static_id=>'native-clear'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P50_AI_QUESTION'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(203670675971526489)
,p_event_id=>wwv_flow_imp.id(203670616531526488)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-confirm'
,p_action=>'NATIVE_CONFIRM'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'message', 'Start a new conversation? The current session conversation will be cleared')).to_clob
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(203670791935526490)
,p_event_id=>wwv_flow_imp.id(203670616531526488)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_static_id=>'native-execute-plsql-code'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'language', 'PLSQL',
  'plsql_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'xxme_ai_chat_pkg.new_conversation;',
    '')),
  'show_processing', 'N')).to_clob
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(203670891051526491)
,p_event_id=>wwv_flow_imp.id(203670616531526488)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_static_id=>'native-refresh'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(203669088555526473)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'maintain_pagination', 'N')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(203671085129526493)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Initialize AI Conversation'
,p_static_id=>'initialize-ai-conversation'
,p_process_sql_clob=>'xxme_ai_chat_pkg.initialize_conversation;'
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>17295863358533650
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(1031484042829987876)
,p_process_sequence=>15
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Isolate AI Conversation Scope'
,p_static_id=>'isolate-ai-conversation-scope-on-entry'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_scope_key varchar2(4000);',
'  l_previous  varchar2(4000);',
'begin',
'  l_scope_key := case',
'    when :P50_AR_SCOPE_AS_OF_DATE is not null then',
'      ''AR|'' || upper(nvl(:P50_DB_LINK,''-'')) || ''|'' || upper(nvl(:P50_PERIOD_NAME,''-'')) || ''|'' ||',
'      nvl(:P50_AR_SCOPE_AS_OF_DATE,''-'') || ''|'' || nvl(:P50_AR_LEDGER_ID,''-'') || ''|'' ||',
'      upper(nvl(:P50_AR_COMPANY,''-'')) || ''|'' || nvl(:P50_AR_AGING_BUCKET_ID,''-'')',
'    when :P50_AP_SCOPE_AS_OF_DATE is not null then',
'      ''AP|'' || upper(nvl(:P50_DB_LINK,''-'')) || ''|'' || upper(nvl(:P50_PERIOD_NAME,''-'')) || ''|'' ||',
'      nvl(:P50_AP_SCOPE_AS_OF_DATE,''-'') || ''|'' || nvl(:P50_AP_LEDGER_ID,''-'') || ''|'' || upper(nvl(:P50_AP_COMPANY,''-''))',
'    else ''ENTERPRISE|'' || upper(nvl(:P50_DB_LINK,''-'')) || ''|'' || upper(nvl(:P50_PERIOD_NAME,''-'')) end;',
'  begin',
'    select c001 into l_previous from apex_collections',
'     where collection_name = ''P50_AI_SCOPE_STATE'' and seq_id = 1;',
'  exception when no_data_found then l_previous := null; end;',
'  if l_previous is not null and l_previous <> l_scope_key then',
'    xxme_ai_chat_pkg.new_conversation;',
'  end if;',
'  apex_collection.create_or_truncate_collection(''P50_AI_SCOPE_STATE'');',
'  apex_collection.add_member(p_collection_name=>''P50_AI_SCOPE_STATE'',p_c001=>l_scope_key);',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>962537130522542991
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(1054143724698301725)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'LOAD_EXEC_CONTEXT'
,p_static_id=>'load-exec-context'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'',
'declare',
'    l_force varchar2(1) := upper(nvl(apex_application.g_x01, ''N''));',
'begin',
'    if l_force = ''Y'' then',
'        xxme_ai_exec_context_pkg.refresh_snapshot(:P50_PERIOD_NAME, :P50_DB_LINK);',
'    else',
'        xxme_ai_exec_context_pkg.ensure_snapshot(:P50_PERIOD_NAME, :P50_DB_LINK);',
'    end if;',
'',
'    apex_json.open_object;',
'    apex_json.write(''ok'', true);',
'    apex_json.write(''statusText'', xxme_ai_exec_context_pkg.status_text(:P50_PERIOD_NAME, :P50_DB_LINK));',
'    apex_json.write(''rowCount'', xxme_ai_exec_context_pkg.row_count);',
'    apex_json.close_object;',
'exception',
'    when others then',
'        apex_json.open_object;',
'        apex_json.write(''ok'', false);',
'        apex_json.write(''statusText'', ''Executive AI context load failed: '' || sqlerrm);',
'        apex_json.close_object;',
'end;',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>990280002000000003
,p_process_comment=>'Background load/reuse of provider-independent executive context.'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(1019480666741986594)
,p_process_sequence=>5
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Normalize AI Context'
,p_static_id=>'normalize-ai-context'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  procedure clear_item(p_name varchar2) is',
'  begin',
'    apex_util.set_session_state(p_name, null);',
'  end;',
'begin',
'  clear_item(''P50_AP_AS_OF_DATE'');',
'  :P50_AP_AS_OF_DATE := null;',
'  if :P50_AR_SCOPE_AS_OF_DATE is not null and :P50_AR_SOURCE_PAGE in (''32'',''33'',''34'') then',
'    clear_item(''P50_AP_SCOPE_AS_OF_DATE''); clear_item(''P50_AP_LEDGER_ID'');',
'    clear_item(''P50_AP_COMPANY''); clear_item(''P50_AP_SOURCE_PAGE''); clear_item(''P50_AP_RECON_READY'');',
'    :P50_AP_SCOPE_AS_OF_DATE := null; :P50_AP_LEDGER_ID := null; :P50_AP_COMPANY := null;',
'    :P50_AP_SOURCE_PAGE := null; :P50_AP_RECON_READY := null;',
'  elsif :P50_AP_SCOPE_AS_OF_DATE is not null and :P50_AP_SOURCE_PAGE in (''22'',''23'',''24'') then',
'    clear_item(''P50_AR_SCOPE_AS_OF_DATE''); clear_item(''P50_AR_LEDGER_ID''); clear_item(''P50_AR_COMPANY'');',
'    clear_item(''P50_AR_AGING_BUCKET_ID''); clear_item(''P50_AR_SOURCE_PAGE''); clear_item(''P50_AR_RECON_READY'');',
'    :P50_AR_SCOPE_AS_OF_DATE := null; :P50_AR_LEDGER_ID := null; :P50_AR_COMPANY := null;',
'    :P50_AR_AGING_BUCKET_ID := null; :P50_AR_SOURCE_PAGE := null; :P50_AR_RECON_READY := null;',
'  else',
'    clear_item(''P50_AP_SCOPE_AS_OF_DATE''); clear_item(''P50_AP_LEDGER_ID''); clear_item(''P50_AP_COMPANY'');',
'    clear_item(''P50_AP_SOURCE_PAGE''); clear_item(''P50_AP_RECON_READY'');',
'    clear_item(''P50_AR_SCOPE_AS_OF_DATE''); clear_item(''P50_AR_LEDGER_ID''); clear_item(''P50_AR_COMPANY'');',
'    clear_item(''P50_AR_AGING_BUCKET_ID''); clear_item(''P50_AR_SOURCE_PAGE''); clear_item(''P50_AR_RECON_READY'');',
'    :P50_AP_SCOPE_AS_OF_DATE := null; :P50_AP_LEDGER_ID := null; :P50_AP_COMPANY := null;',
'    :P50_AP_SOURCE_PAGE := null; :P50_AP_RECON_READY := null;',
'    :P50_AR_SCOPE_AS_OF_DATE := null; :P50_AR_LEDGER_ID := null; :P50_AR_COMPANY := null;',
'    :P50_AR_AGING_BUCKET_ID := null; :P50_AR_SOURCE_PAGE := null; :P50_AR_RECON_READY := null;',
'  end if;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>950000000000000200
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(1054143724698301726)
,p_process_sequence=>30
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Register Executive Context Loader'
,p_static_id=>'register-executive-context-loader'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin apex_javascript.add_onload_code(p_code => ''',
'(function ($) {',
'    ''''use strict'''';',
'',
'    function setStatus(text) {',
'        apex.item(''''P50_EXEC_CONTEXT_STATUS'''').setValue(text || ''''Executive AI context status unavailable'''', null, true);',
'    }',
'',
'    function setSendEnabled(enabled) {',
'        $(''''#send-ai-message'''').prop(''''disabled'''', !enabled).toggleClass(''''is-disabled'''', !enabled);',
'    }',
'',
'    function load(force) {',
'        setStatus(force ? ''''Refreshing executive AI context...'''' : ''''Loading executive AI context...'''');',
'        setSendEnabled(false);',
'        apex.server.process(''''LOAD_EXEC_CONTEXT'''', {',
'            x01: force ? ''''Y'''' : ''''N'''',',
'            pageItems: ''''#P50_PERIOD_NAME,#P50_DB_LINK''''',
'        }, {',
'            dataType: ''''json''''',
'        }).done(function (data) {',
'            setStatus(data && data.statusText);',
'            setSendEnabled(true);',
'            if (!data || data.ok !== true) {',
'                apex.message.showErrors([{',
'                    type: ''''error'''',',
'                    location: ''''page'''',',
'                    message: (data && data.statusText) || ''''Executive AI context could not be loaded.'''',',
'                    unsafe: false',
'                }]);',
'            }',
'        }).fail(function (request, status, error) {',
'            setStatus(''''Executive AI context load failed'''');',
'            setSendEnabled(true);',
'            apex.message.showErrors([{',
'                type: ''''error'''',',
'                location: ''''page'''',',
'                message: error || status || ''''Executive AI context could not be loaded.'''',',
'                unsafe: false',
'            }]);',
'        });',
'    }',
'',
'    window.xxmeExecutiveContext = { load: load };',
'    $(''''#refresh-exec-context'''').off(''''click.xxmeExec'''').on(''''click.xxmeExec'''', function (event) {',
'        event.preventDefault();',
'        load(true);',
'    });',
'    $(''''#P50_PERIOD_NAME,#P50_DB_LINK'''').off(''''change.xxmeExec'''').on(''''change.xxmeExec'''', function () {',
'        load(false);',
'    });',
'    load(false);',
'})(apex.jQuery);',
'''); end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>990280002000000004
,p_process_comment=>'Registers the Page 50 asynchronous snapshot loader and explicit refresh handler.'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(1016584965829300793)
,p_process_sequence=>20
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Show Selected AI Provider'
,p_static_id=>'show-selected-ai-provider'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'    l_display varchar2(1000);',
'begin',
'    if v(''G_AI_SERVICE_ID'') is null then',
'        apex_util.set_session_state(''P50_ACTIVE_AI'', null);',
'    else',
'        select remote_server_name',
unistr('               || '' \00B7 '''),
'               || nvl(provider_type, ''Unknown provider'')',
unistr('               || '' \00B7 '''),
'               || nvl(model_name, ''Provider default'')',
'          into l_display',
'          from apex_workspace_ai_services',
'         where remote_server_id = to_number(v(''G_AI_SERVICE_ID''));',
'        apex_util.set_session_state(''P50_ACTIVE_AI'', l_display);',
'    end if;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>920260923000000004
);
end;
/
prompt --application/pages/delete_00061
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>61);
end;
/
prompt --application/pages/page_00061
begin
wwv_flow_imp_page.create_page(
 p_id=>61
,p_name=>'Inventory Pending Transactions'
,p_alias=>'INVENTORY-PENDING-TRANSACTIONS'
,p_step_title=>'Inventory Pending Transactions'
,p_reload_on_submit=>'A'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* Page 61 only. Native APEX reports retain pagination, filtering and exports. */',
'(function ($) {',
'  ''use strict'';',
'  var active = null, snapshot = null;',
'  var summary$ = $(''#pending-summary''), details$ = $(''#pending-details'');',
'  var run$ = $(''#run-pending-analysis''), export$ = $(''#export-pending-summary'');',
'  var filters$ = $(''#P61_PERIOD_NAME,#P61_DB_LINK,#P61_RESOLUTION'');',
'  function pane(region$, kind, title) {',
'    region$.wrap(''<section class="p61-pane" id="p61-'' + kind + ''-pane" aria-label="'' + title + ''"></section>'');',
'    var pane$ = region$.parent();',
'    pane$.prepend(''<div class="p61-pane-status" role="status" aria-live="polite"></div><div class="p61-pane-context"></div>'');',
'    // BEGIN P61 TIMER ADDITION',
'    pane$.prepend(''<div class="p61-pane-timing" aria-live="off" style="font-variant-numeric:tabular-nums;margin-bottom:.35rem;font-weight:600"></div>'');',
'    // END P61 TIMER ADDITION',
'    return pane$;',
'  }',
'  var summaryPane$ = pane(summary$, ''summary'', ''Pending transaction summary'');',
'  var detailPane$ = pane(details$, ''detail'', ''Selected transaction details'');',
'  summaryPane$.hide(); detailPane$.hide(); export$.prop(''disabled'',true);',
'  // BEGIN P61 TIMER ADDITION',
'  // Browser elapsed time, not database-only execution time. No server calls here.',
'  function seconds(ms) {return (Math.max(0,ms)/1000).toFixed(1) + '' s'';}',
'  function renderTiming(job) {',
'    var timing = job.timing;',
'    var now = timing.endedAt === null ? performance.now() : timing.endedAt;',
'    var text = (timing.endedAt === null ? ''Elapsed: '' : timing.failed ? ''Stopped after: '' : ''Total: '') + seconds(now-timing.startedAt);',
'    if (timing.refreshAt === null) {',
'      text += '' | Setup: '' + seconds(now-timing.startedAt);',
'      text += timing.endedAt === null ? '' (preparing) | Report: not started'' : '' | Report: not started'';',
'    } else {',
'      text += '' | Setup: '' + (timing.reportOnly ? ''not requested'' : seconds(timing.refreshAt-timing.startedAt));',
'      text += '' | Report: '' + seconds(now-timing.refreshAt);',
'      if (timing.endedAt === null) text += '' (loading)'';',
'    }',
'    job.pane.find(''.p61-pane-timing'').text(text);',
'  }',
'  function startTiming(job) {',
'    job.timing = {startedAt:performance.now(), refreshAt:null, endedAt:null, failed:false, reportOnly:false, interval:null};',
'    renderTiming(job);',
'    job.timing.interval = setInterval(function () {if(active === job) renderTiming(job);},250);',
'  }',
'  function reportTiming(job, reportOnly) {',
'    if (job.timing.refreshAt !== null) return;',
'    job.timing.reportOnly = !!reportOnly;',
'    job.timing.refreshAt = reportOnly ? job.timing.startedAt : performance.now();',
'    renderTiming(job);',
'  }',
'  function stopTiming(job, error) {',
'    job.timing.endedAt = performance.now();',
'    job.timing.failed = !!error;',
'    clearInterval(job.timing.interval);',
'    job.timing.interval = null;',
'    renderTiming(job);',
'  }',
'  // END P61 TIMER ADDITION',
'  function lock(on) {',
'    run$.prop(''disabled'', on);',
'    filters$.prop(''disabled'', on);',
'    summary$.prop(''inert'', on);',
'  }',
'  function begin(kind, context) {',
'    if (active) return false;',
'    var pane$ = kind === ''summary'' ? summaryPane$ : detailPane$;',
'    var region$ = kind === ''summary'' ? summary$ : details$;',
'    pane$.show().attr(''aria-busy'', ''true'');',
'    pane$.find(''.p61-pane-context'').text(context || '''');',
unistr('    pane$.find(''.p61-pane-status'').text(kind === ''summary'' ? ''Loading summary\2026'' : ''Loading details\2026'');'),
'    // Keep the widget measurable while preventing stale data from being used.',
'    region$.removeClass(''p61-failed-content'').addClass(''p61-loading-content'');',
'    active = {kind:kind, pane:pane$, region:region$, phase:''context'', spinner:apex.util.showSpinner(pane$)};',
'    // BEGIN P61 TIMER ADDITION',
'    startTiming(active);',
'    // END P61 TIMER ADDITION',
'    lock(true);',
'    return true;',
'  }',
'  function finish(error) {',
'    if (!active) return;',
'    var job = active;',
'    // BEGIN P61 TIMER ADDITION',
'    stopTiming(job,error);',
'    // END P61 TIMER ADDITION',
'    active = null;',
'    job.spinner.remove();',
'    job.pane.attr(''aria-busy'', ''false'');',
'    job.region.removeClass(''p61-loading-content'');',
'    lock(false);',
'    if (error) {',
'      // Do not show old rows under a new selection after a failed request.',
'      job.region.addClass(''p61-failed-content'');',
'      job.pane.find(''.p61-pane-status'').text(error);',
'      if (job.kind === ''summary'') snapshot = null;',
'    } else {',
'      job.region.removeClass(''p61-failed-content'');',
'      job.pane.find(''.p61-pane-status'').text(job.kind === ''summary'' ? ''Summary loaded. Select a nonzero count below.'' : ''Details loaded.'');',
'      if(job.kind === ''summary'') export$.prop(''disabled'',false);',
'    }',
'  }',
'  function message(error, fallback) {',
'    return error && typeof error.message === ''string'' ? error.message : fallback;',
'  }',
'  function refresh(kind) {',
'    if (!active || active.kind !== kind) return;',
'    var job = active;',
'    active.phase = ''refresh'';',
'    // BEGIN P61 TIMER ADDITION',
'    reportTiming(job,false);',
'    // END P61 TIMER ADDITION',
'    try {',
'      var result = apex.region(kind === ''summary'' ? ''pending-summary'' : ''pending-details'').refresh();',
'      // Classic Report refresh may return undefined; apexafterrefresh covers it.',
'      if (result && typeof result.then === ''function'') {',
'        result.then(function () { if (active === job) finish(); },',
'          function (error) { if (active === job) finish(message(error,''Unable to load results. Please retry.'')); });',
'      }',
'    } catch (error) { finish(message(error,''Unable to refresh this report.'')); }',
'  }',
'  // P61_SERVER_CONTEXT_V1: request inputs and accepted state are separate.',
'  var ownedRunId = null;',
'  function same(a,b) {return String(a == null ? '''' : a) === String(b == null ? '''' : b);}',
'  function clearApproval() {',
'    [''P61_RUN_ID'',''P61_RUN_PERIOD'',''P61_RUN_SOURCE'',''P61_RUN_RESOLUTION'',''P61_ORG_ID'',''P61_TXN_TYPE''].forEach(function (name) {apex.item(name).setValue('''',null,true);});',
'    apex.item(''P61_READY'').setValue(''N'',null,true);',
'    export$.prop(''disabled'',true);',
'  }',
'  function accept(result) {',
'    var values={P61_RUN_ID:result.run_id,P61_READY:''Y'',P61_RUN_PERIOD:result.period,',
'      P61_RUN_SOURCE:result.source,P61_RUN_RESOLUTION:result.resolution,P61_ORG_ID:result.org||'''',P61_TXN_TYPE:result.type||''''};',
'    Object.keys(values).forEach(function (name) {apex.item(name).setValue(values[name],null,true);});',
'  }',
'  function responseMatches(result,data) {',
'    return result.version===''P61_SERVER_CONTEXT_V1'' && result.action===data.x01 && result.ready===''Y''',
'      && /^[0-9A-F]{32}$/.test(result.run_id||'''')',
'      && (data.x01===''RUN'' || same(result.run_id,data.x07))',
'      && same(result.period,data.x02) && same(result.source,data.x03) && same(result.resolution,data.x06)',
'      && same(result.org,data.x01===''DETAIL''?data.x04:'''') && same(result.type,data.x01===''DETAIL''?data.x05:'''');',
'  }',
'  function filtersMatch(data) {',
'    return same(apex.item(''P61_PERIOD_NAME'').getValue(),data.x02)',
'      && same(apex.item(''P61_DB_LINK'').getValue(),data.x03) && same(apex.item(''P61_RESOLUTION'').getValue(),data.x06);',
'  }',
'  function context(data,kind) {',
'    var job=active, expected=Object.assign({},data);',
'    try {',
'      // No pageItems: callback validates explicit inputs and creates the server snapshot.',
'      apex.server.process(''P61_SET_CONTEXT'',Object.assign({},data),{dataType:''json''}).then(function(result){',
'        if(active!==job)return;',
'        if(!result||result.ok!==true){finish(result&&result.message||''Unable to accept this run.'');return;}',
'        if(!responseMatches(result,expected)||!filtersMatch(expected)){',
'          snapshot=null;clearApproval();finish(''The accepted context does not match this selection. Run Analysis again.'');return;',
'        }',
'        accept(result);',
'        if(kind===''summary''){',
'          ownedRunId=result.run_id;',
'          snapshot={runId:result.run_id,period:result.period,source:result.source,resolution:result.resolution};',
'        }',
'        refresh(kind);',
'      },function(error){if(active===job)finish(message(error,''Unable to accept this run. Please retry.''));});',
'    }catch(error){finish(message(error,''Unable to start the request.''));}',
'  }',
'  function resolutionLabel(value) {return value === ''ALL'' ? ''All'' : value === ''RECOMMENDED'' ? ''Recommended'' : ''Required'';}',
'  function run() {',
'    if (active) return;',
'    var period = apex.item(''P61_PERIOD_NAME'').getValue();',
'    var source = apex.item(''P61_DB_LINK'').getValue();',
'    var resolution = apex.item(''P61_RESOLUTION'').getValue();',
'    if (!period || !source || [''REQUIRED'',''RECOMMENDED'',''ALL''].indexOf(resolution) < 0) {',
'      apex.message.showErrors([{type:''error'',location:''page'',message:''Select an accounting period, database source and resolution.'',unsafe:false}]);',
'      return;',
'    }',
'    apex.message.clearErrors();',
'    detailPane$.hide();',
'    snapshot = null;',
unistr('    begin(''summary'', period + '' \00B7 '' + source + '' \00B7 '' + resolutionLabel(resolution));'),
'    clearApproval();',
'    context({x01:''RUN'',x02:period,x03:source,x06:resolution,x07:ownedRunId||''''}, ''summary'');',
'  }',
'  $(document).off(''.p61Ajax'');',
'  $(document).on(''click.p61Ajax'', ''#run-pending-analysis'', function (event) {event.preventDefault();run();});',
'  $(document).on(''click.p61Ajax'', ''#pending-summary .p61-count'', function (event) {',
'    event.preventDefault();',
'    if (active || !snapshot) return;',
'    var button$ = $(this), org = button$.attr(''data-org-id''), type = button$.attr(''data-type'');',
'    var name = button$.attr(''data-org-name'');',
unistr('    begin(''detail'', name + '' \00B7 '' + type + '' \00B7 '' + snapshot.period + '' \00B7 '' + snapshot.source + '' \00B7 '' + resolutionLabel(snapshot.resolution));'),
'    detailPane$[0].scrollIntoView({behavior:''smooth'',block:''nearest''});',
'    context({x01:''DETAIL'',x02:snapshot.period,x03:snapshot.source,x04:org,x05:type,x06:snapshot.resolution,x07:snapshot.runId}, ''detail'');',
'  });',
'  filters$.off(''.p61Ajax'').on(''change.p61Ajax'', function () {',
'    snapshot = null;',
'    clearApproval();',
'    summaryPane$.hide(); detailPane$.hide();',
'    $(''#pending-filter-message'').prop(''hidden'',false);',
'  });',
'  [summary$,details$].forEach(function (region$, index) {',
'    var kind = index === 0 ? ''summary'' : ''detail'';',
'    region$.off(''.p61Ajax'').on(''apexbeforerefresh.p61Ajax'', function (event) {',
'      if (!active && !snapshot) {event.preventDefault(); return false;}',
'      // Also give native pagination/filtering a loading indicator.',
'      if (!active) {begin(kind, (kind === ''summary'' ? summaryPane$ : detailPane$).find(''.p61-pane-context'').text());active.phase=''refresh'';}',
'      // BEGIN P61 TIMER ADDITION',
'      if (active && active.kind === kind && active.timing.refreshAt === null) reportTiming(active,true);',
'      // END P61 TIMER ADDITION',
'    }).on(''apexafterrefresh.p61Ajax'', function () {',
'      if (active && active.kind === kind && active.phase === ''refresh'') {',
'        var hasError = region$.find(''.a-IRR-error,.t-Report-error,.a-Notification--error'').length > 0;',
'        finish(hasError ? ''The report returned an error. Review the message and retry.'' : null);',
'        $(''#pending-filter-message'').prop(''hidden'',true);',
'      }',
'    });',
'  });',
'  $(document).on(''ajaxError.p61Ajax'', function () {',
'    if (active && active.phase === ''refresh'') finish(''The report request failed. Please retry.'');',
'  });',
'})(apex.jQuery);',
''))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.p61-pane {position:relative; margin-bottom:1rem; min-height:100px; border:1px solid #ddd; border-radius:6px; padding:.75rem;}',
'.p61-pane-status {font-weight:600; min-height:1.5em;}',
'.p61-pane-context {margin:.25rem 0 .75rem; overflow-wrap:anywhere;}',
'.p61-pane[aria-busy="true"] {min-height:180px;}',
'.p61-loading-content,.p61-failed-content {visibility:hidden; max-height:180px; overflow:hidden;}',
'#pending-summary .t-Region-body {overflow:visible;}',
'#pending-summary .t-Report-wrap {max-height:42vh;overflow:auto;position:relative;}',
'#pending-summary .t-Report-report {min-width:1250px;}',
'#pending-summary .t-Report-colHead {white-space:normal; vertical-align:bottom;}',
'#pending-details .a-IRR-tableContainer {max-height:42vh; overflow:auto;}',
'.p61-count {border:0; background:transparent; padding:.25rem; color:var(--a-link-text-color,#056ac8); text-decoration:underline; cursor:pointer; font:inherit; font-weight:600;}',
'.p61-count:focus-visible {outline:2px solid currentColor; outline-offset:2px;}',
'#pending-filters .t-Form-fieldContainer {margin-bottom:.25rem;}',
'@media(max-width:640px){#pending-summary .t-Report-wrap,#pending-details .a-IRR-tableContainer {max-height:50vh;}}',
'/* Initial visual hiding is separate from the server-side empty-query guard. */',
'#pending-summary,#pending-details {display:none;}',
'#p61-summary-pane > #pending-summary,#p61-detail-pane > #pending-details {display:block;}',
'/* Keep the entire heading row inside the table scroll wrapper; no padded strip can expose scrolled rows. */',
'#pending-summary .t-Report-report thead {position:sticky;top:0;z-index:3;}',
'#pending-summary .t-Report-report thead th {background:var(--ut-component-background-color,#fff);box-shadow:0 1px 0 rgba(0,0,0,.15);}'))
,p_step_template=>4075783602716660119
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(18558063129193156)
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(355328276289366655)
,p_plug_name=>'Breadcrumb'
,p_static_id=>'breadcrumb'
,p_title=>'Inventory Pending Transactions'
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
 p_id=>wwv_flow_imp.id(327394276929161661)
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
 p_id=>wwv_flow_imp.id(355328276289366668)
,p_plug_name=>'Transaction Details'
,p_static_id=>'pending-details'
,p_title=>'Transaction Details'
,p_region_name=>'pending-details'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>30
,p_plug_grid_column_span=>12
,p_plug_item_display_point=>'ABOVE'
,p_query_type=>'FUNC_BODY_RETURNING_SQL'
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_run_id varchar2(32):=upper(apex_util.get_session_state(''P61_RUN_ID''));',
'  l_period varchar2(15); l_source varchar2(30); l_resolution varchar2(20);',
'  l_org number; l_type varchar2(80); l_sql varchar2(32767);',
'begin',
'  -- P61_SERVER_CONTEXT_V1: no accepted run ID means no inventory query.',
'  if l_run_id is null then return q''~select cast(null as number) organization_id,',
'       cast(null as varchar2(15)) period_name,',
'       cast(null as date) period_start_date,',
'       cast(null as date) schedule_close_date,',
'       cast(null as varchar2(240)) organization_name,',
'       cast(null as varchar2(80)) transaction_type,',
'       cast(null as date) transaction_date,',
'       cast(null as varchar2(20)) resolution,',
'       cast(null as varchar2(40)) transaction_ref,',
'       cast(null as varchar2(240)) transaction_ref_id,',
'       cast(null as varchar2(240)) transaction_type_name,',
'       cast(null as varchar2(240)) item from dual where 1=0~''; end if;',
'  if not regexp_like(l_run_id,''^[0-9A-F]{32}$'',''c'') then',
'    raise_application_error(-20163,''Invalid run context. Run Analysis again.'');',
'  end if;',
'  begin',
'    select c001,c002,c003 into l_period,l_source,l_resolution',
'    from apex_collections where collection_name=''P61RUN_''||l_run_id and seq_id=1;',
'  exception when no_data_found then',
'    raise_application_error(-20163,''This run has expired. Run Analysis again.'');',
'  end;',
'  if l_source is null or l_source not in (''ADG'')',
'    or l_period is null or not regexp_like(l_period,''^(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)-[0-9]{4}$'',''c'')',
'    or l_resolution is null or l_resolution not in (''REQUIRED'',''RECOMMENDED'',''ALL'') then',
'    raise_application_error(-20163,''Invalid accepted run. Run Analysis again.'');',
'  end if;',
'  select n001,c001 into l_org,l_type',
'  from apex_collections where collection_name=''P61RUN_''||l_run_id and seq_id=2;',
'  if l_org is null and l_type is null then return q''~select cast(null as number) organization_id,',
'       cast(null as varchar2(15)) period_name,',
'       cast(null as date) period_start_date,',
'       cast(null as date) schedule_close_date,',
'       cast(null as varchar2(240)) organization_name,',
'       cast(null as varchar2(80)) transaction_type,',
'       cast(null as date) transaction_date,',
'       cast(null as varchar2(20)) resolution,',
'       cast(null as varchar2(40)) transaction_ref,',
'       cast(null as varchar2(240)) transaction_ref_id,',
'       cast(null as varchar2(240)) transaction_type_name,',
'       cast(null as varchar2(240)) item from dual where 1=0~''; end if;',
'  if l_org is null or l_org<=0 or l_org<>trunc(l_org) or l_type is null or l_type not in (''Unprocessed Material'',''Uncosted Material/WSM'',''Pending WIP Costing'',''Pending WSM Interface'',''Pending LCM Interface'',''Unprocessed Shipping Transactions'',''Pendin'
||'g Receiving'',''Pending Material'',''Pending Shop Floor Move'',''Incomplete Work Orders'',''__TOTAL_REQUIRED__'',''__TOTAL_RECOMMENDED__'',''__TOTAL_ALL__'') then',
'    raise_application_error(-20164,''Select a valid exception count again.'');',
'  end if;',
'  if (l_resolution=''REQUIRED'' and (l_type in (''Pending Receiving'',''Pending Material'',''Pending Shop Floor Move'',''Incomplete Work Orders'') or l_type in (''__TOTAL_RECOMMENDED__'',''__TOTAL_ALL__'')))',
'    or (l_resolution=''RECOMMENDED'' and (l_type in (''Unprocessed Material'',''Uncosted Material/WSM'',''Pending WIP Costing'',''Pending WSM Interface'',''Pending LCM Interface'',''Unprocessed Shipping Transactions'') or l_type in (''__TOTAL_REQUIRED__'',''__TOTAL_A'
||'LL__'')))',
'    or (l_resolution=''ALL'' and l_type in (''__TOTAL_REQUIRED__'',''__TOTAL_RECOMMENDED__'')) then',
'    raise_application_error(-20168,''Selected category does not belong to the accepted Resolution.'');',
'  end if;',
'  -- Query text is unchanged; bind placeholders are replaced using validated server-owned values.',
'  l_sql:=q''~select organization_id, period_name, period_start_date, schedule_close_date,',
'       organization_name, transaction_type, transaction_date, resolution,',
'       transaction_ref, transaction_ref_id, transaction_type_name, item',
'  from table(xxme_inv_pending_dtl_v3_pkg.get_details(',
'       :P61_PERIOD_NAME, to_number(:P61_ORG_ID), :P61_TXN_TYPE, :P61_DB_LINK))~'';',
'  l_sql:=replace(l_sql,'':P61_PERIOD_NAME'',dbms_assert.enquote_literal(l_period));',
'  l_sql:=replace(l_sql,'':P61_DB_LINK'',dbms_assert.enquote_literal(l_source));',
'  l_sql:=replace(l_sql,'':P61_RESOLUTION'',dbms_assert.enquote_literal(l_resolution));',
'  l_sql:=replace(l_sql,'':P61_ORG_ID'',to_char(l_org,''FM99999999999999999990''));',
'  l_sql:=replace(l_sql,'':P61_TXN_TYPE'',dbms_assert.enquote_literal(l_type));',
'  return l_sql;',
'end;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P61_RUN_ID'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(355328276289366865)
,p_no_data_found_message=>'No matching pending details remain for this selection. Transactions may have been processed since the summary was read.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:XLSX'
,p_enable_mail_download=>'N'
,p_internal_uid=>120061000000000200
,p_ai_report_hint=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Current pending inventory transaction details for the accepted Page 61 analysis run. The server-owned run fixes database source, inventory period, resolution, organization, and pending-transaction category.',
'These rows are current operational results, not a historical snapshot. Resolution Required and Recommended are distinct classifications. A row can disappear after the source transaction is processed.',
'Use Inventory Organization, Pending Transaction Category, Transaction Date, Reference Type, Transaction Reference, Transaction Type, and Item as business-facing fields. Do not infer transactions outside the accepted run scope.'))
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(355328276289366886)
,p_db_column_name=>'ITEM'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Item'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Inventory item identifier or item code associated with the pending transaction, when available.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(355328276289366875)
,p_db_column_name=>'ORGANIZATION_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Organization ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(355328276289366879)
,p_db_column_name=>'ORGANIZATION_NAME'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Inventory Organization'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Business name of the inventory organization containing the pending transaction.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(355328276289366876)
,p_db_column_name=>'PERIOD_NAME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Inventory Period'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Inventory accounting period selected for the accepted analysis run.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(355328276289366877)
,p_db_column_name=>'PERIOD_START_DATE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Period Start Date'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(355328276289366882)
,p_db_column_name=>'RESOLUTION'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Resolution'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Resolution classification assigned by the pending-transactions rules: Required or Recommended.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(355328276289366878)
,p_db_column_name=>'SCHEDULE_CLOSE_DATE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Scheduled Close Date'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(355328276289366881)
,p_db_column_name=>'TRANSACTION_DATE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Transaction Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Business date of the pending inventory transaction.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(355328276289366883)
,p_db_column_name=>'TRANSACTION_REF'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Reference Type'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Type of business reference supplied for the pending transaction.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(355328276289366884)
,p_db_column_name=>'TRANSACTION_REF_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Transaction Reference'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Business or system reference value for locating the pending transaction.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(355328276289366880)
,p_db_column_name=>'TRANSACTION_TYPE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Pending Transaction Category'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'High-level pending transaction category selected from the Page 61 summary.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(355328276289366885)
,p_db_column_name=>'TRANSACTION_TYPE_NAME'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Transaction Type'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Detailed Oracle inventory transaction type name.'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(355328276289366895)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>100000
,p_report_columns=>'PERIOD_NAME:ORGANIZATION_NAME:TRANSACTION_TYPE:TRANSACTION_DATE:RESOLUTION:TRANSACTION_REF:TRANSACTION_REF_ID:TRANSACTION_TYPE_NAME:ITEM'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(355328276289366669)
,p_plug_name=>'Analysis Information'
,p_static_id=>'pending-execution-info'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>15
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="t-Alert t-Alert--horizontal t-Alert--defaultIcons t-Alert--info">',
'  <div class="t-Alert-wrap">',
'    <div class="t-Alert-icon"><span class="t-Icon"></span></div>',
'    <div class="t-Alert-content">',
'      <div class="t-Alert-header">',
'        <h2 class="t-Alert-title">Inventory Pending Transactions analysis runs on demand</h2>',
'      </div>',
'      <div class="t-Alert-body">',
'        Select an accounting period and database source, then click <strong>Run Analysis</strong>.',
'        The analysis may take approximately 30&ndash;60 seconds.',
'        Execution time varies by database source and workload. Please wait for the results before clicking again.',
'      </div>',
'    </div>',
'  </div>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(355328276289366666)
,p_plug_name=>'Filters'
,p_static_id=>'pending-filters'
,p_region_name=>'pending-filters'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Select a period, source and resolution, then run analysis. Only organizations with pending transactions are shown. Click a nonzero count to view its details below.</p>',
'<p>Counts reflect current pending transactions within the selected period rules, not a historical snapshot. Required is the default. Total counts only the selected resolution; a dash means the category was not queried. Only records dated within the s'
||'elected period are included. .</p>',
'<p id="pending-filter-message" role="status" hidden>Filters changed. Select Run Analysis to load matching results.</p>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(355328276289366667)
,p_name=>'Pending Transactions by Inventory Organization'
,p_static_id=>'pending-summary'
,p_title=>'Pending Transactions by Inventory Organization'
,p_region_name=>'pending-summary'
,p_template=>4075786578761660127
,p_display_sequence=>20
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'FUNC_BODY_RETURNING_SQL'
,p_function_body_language=>'PLSQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_run_id varchar2(32):=upper(apex_util.get_session_state(''P61_RUN_ID''));',
'  l_period varchar2(15); l_source varchar2(30); l_resolution varchar2(20);',
'  l_org number; l_type varchar2(80); l_sql varchar2(32767);',
'begin',
'  -- P61_SERVER_CONTEXT_V1: no accepted run ID means no inventory query.',
'  if l_run_id is null then return q''~select cast(null as varchar2(30)) organization_code,',
'       cast(null as varchar2(240)) organization_name,',
'       cast(null as varchar2(4000)) unprocessed_material_count,',
'       cast(null as varchar2(4000)) uncosted_material_wsm_count,',
'       cast(null as varchar2(4000)) pending_wip_costing_count,',
'       cast(null as varchar2(4000)) pending_wsm_interface_count,',
'       cast(null as varchar2(4000)) pending_lcm_interface_count,',
'       cast(null as varchar2(4000)) unprocessed_shipping_count,',
'       cast(null as varchar2(4000)) pending_receiving_count,',
'       cast(null as varchar2(4000)) pending_material_count,',
'       cast(null as varchar2(4000)) pending_shop_floor_move_count,',
'       cast(null as varchar2(4000)) incomplete_work_orders_count,',
'       cast(null as varchar2(4000)) total_count from dual where 1=0~''; end if;',
'  if not regexp_like(l_run_id,''^[0-9A-F]{32}$'',''c'') then',
'    raise_application_error(-20163,''Invalid run context. Run Analysis again.'');',
'  end if;',
'  begin',
'    select c001,c002,c003 into l_period,l_source,l_resolution',
'    from apex_collections where collection_name=''P61RUN_''||l_run_id and seq_id=1;',
'  exception when no_data_found then',
'    raise_application_error(-20163,''This run has expired. Run Analysis again.'');',
'  end;',
'  if l_source is null or l_source not in (''ADG'')',
'    or l_period is null or not regexp_like(l_period,''^(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)-[0-9]{4}$'',''c'')',
'    or l_resolution is null or l_resolution not in (''REQUIRED'',''RECOMMENDED'',''ALL'') then',
'    raise_application_error(-20163,''Invalid accepted run. Run Analysis again.'');',
'  end if;',
'  -- Query text is unchanged; bind placeholders are replaced using validated server-owned values.',
'  l_sql:=q''~select s.organization_code, s.organization_name,',
'       case when :P61_RESOLUTION = ''RECOMMENDED'' then ''<span title="Not included by Resolution filter">&mdash;</span>''',
'       when s.unprocessed_material_count > 0 then',
'         ''<button type="button" class="p61-count" data-org-id="'' ||',
'         to_char(s.organization_id,''FM99999999999999999990'') ||',
'         ''" data-org-name="'' || apex_escape.html_attribute(s.organization_name) ||',
'         ''" data-type="'' || apex_escape.html_attribute(''Unprocessed Material'') ||',
'         ''" aria-label="'' || apex_escape.html_attribute(''Unprocessed Material for '' || s.organization_name) || ''">'' ||',
'         to_char(s.unprocessed_material_count,''FM999G999G999G999G990'') || ''</button>''',
'       else ''0'' end unprocessed_material_count,',
'       case when :P61_RESOLUTION = ''RECOMMENDED'' then ''<span title="Not included by Resolution filter">&mdash;</span>''',
'       when s.uncosted_material_wsm_count > 0 then',
'         ''<button type="button" class="p61-count" data-org-id="'' ||',
'         to_char(s.organization_id,''FM99999999999999999990'') ||',
'         ''" data-org-name="'' || apex_escape.html_attribute(s.organization_name) ||',
'         ''" data-type="'' || apex_escape.html_attribute(''Uncosted Material/WSM'') ||',
'         ''" aria-label="'' || apex_escape.html_attribute(''Uncosted Material/WSM for '' || s.organization_name) || ''">'' ||',
'         to_char(s.uncosted_material_wsm_count,''FM999G999G999G999G990'') || ''</button>''',
'       else ''0'' end uncosted_material_wsm_count,',
'       case when :P61_RESOLUTION = ''RECOMMENDED'' then ''<span title="Not included by Resolution filter">&mdash;</span>''',
'       when s.pending_wip_costing_count > 0 then',
'         ''<button type="button" class="p61-count" data-org-id="'' ||',
'         to_char(s.organization_id,''FM99999999999999999990'') ||',
'         ''" data-org-name="'' || apex_escape.html_attribute(s.organization_name) ||',
'         ''" data-type="'' || apex_escape.html_attribute(''Pending WIP Costing'') ||',
'         ''" aria-label="'' || apex_escape.html_attribute(''Pending WIP Costing for '' || s.organization_name) || ''">'' ||',
'         to_char(s.pending_wip_costing_count,''FM999G999G999G999G990'') || ''</button>''',
'       else ''0'' end pending_wip_costing_count,',
'       case when :P61_RESOLUTION = ''RECOMMENDED'' then ''<span title="Not included by Resolution filter">&mdash;</span>''',
'       when s.pending_wsm_interface_count > 0 then',
'         ''<button type="button" class="p61-count" data-org-id="'' ||',
'         to_char(s.organization_id,''FM99999999999999999990'') ||',
'         ''" data-org-name="'' || apex_escape.html_attribute(s.organization_name) ||',
'         ''" data-type="'' || apex_escape.html_attribute(''Pending WSM Interface'') ||',
'         ''" aria-label="'' || apex_escape.html_attribute(''Pending WSM Interface for '' || s.organization_name) || ''">'' ||',
'         to_char(s.pending_wsm_interface_count,''FM999G999G999G999G990'') || ''</button>''',
'       else ''0'' end pending_wsm_interface_count,',
'       case when :P61_RESOLUTION = ''RECOMMENDED'' then ''<span title="Not included by Resolution filter">&mdash;</span>''',
'       when s.pending_lcm_interface_count > 0 then',
'         ''<button type="button" class="p61-count" data-org-id="'' ||',
'         to_char(s.organization_id,''FM99999999999999999990'') ||',
'         ''" data-org-name="'' || apex_escape.html_attribute(s.organization_name) ||',
'         ''" data-type="'' || apex_escape.html_attribute(''Pending LCM Interface'') ||',
'         ''" aria-label="'' || apex_escape.html_attribute(''Pending LCM Interface for '' || s.organization_name) || ''">'' ||',
'         to_char(s.pending_lcm_interface_count,''FM999G999G999G999G990'') || ''</button>''',
'       else ''0'' end pending_lcm_interface_count,',
'       case when :P61_RESOLUTION = ''RECOMMENDED'' then ''<span title="Not included by Resolution filter">&mdash;</span>''',
'       when s.unprocessed_shipping_count > 0 then',
'         ''<button type="button" class="p61-count" data-org-id="'' ||',
'         to_char(s.organization_id,''FM99999999999999999990'') ||',
'         ''" data-org-name="'' || apex_escape.html_attribute(s.organization_name) ||',
'         ''" data-type="'' || apex_escape.html_attribute(''Unprocessed Shipping Transactions'') ||',
'         ''" aria-label="'' || apex_escape.html_attribute(''Unprocessed Shipping Transactions for '' || s.organization_name) || ''">'' ||',
'         to_char(s.unprocessed_shipping_count,''FM999G999G999G999G990'') || ''</button>''',
'       else ''0'' end unprocessed_shipping_count,',
'       case when :P61_RESOLUTION = ''REQUIRED'' then ''<span title="Not included by Resolution filter">&mdash;</span>''',
'       when s.pending_receiving_count > 0 then',
'         ''<button type="button" class="p61-count" data-org-id="'' ||',
'         to_char(s.organization_id,''FM99999999999999999990'') ||',
'         ''" data-org-name="'' || apex_escape.html_attribute(s.organization_name) ||',
'         ''" data-type="'' || apex_escape.html_attribute(''Pending Receiving'') ||',
'         ''" aria-label="'' || apex_escape.html_attribute(''Pending Receiving for '' || s.organization_name) || ''">'' ||',
'         to_char(s.pending_receiving_count,''FM999G999G999G999G990'') || ''</button>''',
'       else ''0'' end pending_receiving_count,',
'       case when :P61_RESOLUTION = ''REQUIRED'' then ''<span title="Not included by Resolution filter">&mdash;</span>''',
'       when s.pending_material_count > 0 then',
'         ''<button type="button" class="p61-count" data-org-id="'' ||',
'         to_char(s.organization_id,''FM99999999999999999990'') ||',
'         ''" data-org-name="'' || apex_escape.html_attribute(s.organization_name) ||',
'         ''" data-type="'' || apex_escape.html_attribute(''Pending Material'') ||',
'         ''" aria-label="'' || apex_escape.html_attribute(''Pending Material for '' || s.organization_name) || ''">'' ||',
'         to_char(s.pending_material_count,''FM999G999G999G999G990'') || ''</button>''',
'       else ''0'' end pending_material_count,',
'       case when :P61_RESOLUTION = ''REQUIRED'' then ''<span title="Not included by Resolution filter">&mdash;</span>''',
'       when s.pending_shop_floor_move_count > 0 then',
'         ''<button type="button" class="p61-count" data-org-id="'' ||',
'         to_char(s.organization_id,''FM99999999999999999990'') ||',
'         ''" data-org-name="'' || apex_escape.html_attribute(s.organization_name) ||',
'         ''" data-type="'' || apex_escape.html_attribute(''Pending Shop Floor Move'') ||',
'         ''" aria-label="'' || apex_escape.html_attribute(''Pending Shop Floor Move for '' || s.organization_name) || ''">'' ||',
'         to_char(s.pending_shop_floor_move_count,''FM999G999G999G999G990'') || ''</button>''',
'       else ''0'' end pending_shop_floor_move_count,',
'       case when :P61_RESOLUTION = ''REQUIRED'' then ''<span title="Not included by Resolution filter">&mdash;</span>''',
'       when s.incomplete_work_orders_count > 0 then',
'         ''<button type="button" class="p61-count" data-org-id="'' ||',
'         to_char(s.organization_id,''FM99999999999999999990'') ||',
'         ''" data-org-name="'' || apex_escape.html_attribute(s.organization_name) ||',
'         ''" data-type="'' || apex_escape.html_attribute(''Incomplete Work Orders'') ||',
'         ''" aria-label="'' || apex_escape.html_attribute(''Incomplete Work Orders for '' || s.organization_name) || ''">'' ||',
'         to_char(s.incomplete_work_orders_count,''FM999G999G999G999G990'') || ''</button>''',
'       else ''0'' end incomplete_work_orders_count,',
'       case when s.total_count > 0 then',
'         ''<button type="button" class="p61-count" data-org-id="'' ||',
'         to_char(s.organization_id,''FM99999999999999999990'') ||',
'         ''" data-org-name="'' || apex_escape.html_attribute(s.organization_name) ||',
'         ''" data-type="Total" aria-label="'' ||',
'         apex_escape.html_attribute(''Total for '' || s.organization_name) || ''">'' ||',
'         to_char(s.total_count,''FM999G999G999G999G990'') || ''</button>''',
'       else ''0'' end total_count',
'  from table(xxme_inv_pending_period_pkg.get_summary(:P61_PERIOD_NAME, :P61_DB_LINK, :P61_RESOLUTION)) s',
' where s.total_count > 0',
' order by s.organization_name, s.organization_code~'';',
'  l_sql:=replace(l_sql,'':P61_PERIOD_NAME'',dbms_assert.enquote_literal(l_period));',
'  l_sql:=replace(l_sql,'':P61_DB_LINK'',dbms_assert.enquote_literal(l_source));',
'  l_sql:=replace(l_sql,'':P61_RESOLUTION'',dbms_assert.enquote_literal(l_resolution));',
'  return l_sql;',
'end;'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P61_RUN_ID'
,p_lazy_loading=>false
,p_query_row_template=>2542081983073888486
,p_query_num_rows=>100
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No pending transactions found for the selected source and period.'
,p_query_num_rows_type=>'SHOW_ALL'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(355328276289366776)
,p_query_column_id=>12
,p_column_alias=>'INCOMPLETE_WORK_ORDERS_COUNT'
,p_column_display_sequence=>120
,p_column_heading=>'Incomplete Work Orders'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(355328276289366765)
,p_query_column_id=>1
,p_column_alias=>'ORGANIZATION_CODE'
,p_column_display_sequence=>10
,p_column_heading=>'Org Code'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(355328276289366766)
,p_query_column_id=>2
,p_column_alias=>'ORGANIZATION_NAME'
,p_column_display_sequence=>20
,p_column_heading=>'Inventory Organization'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(355328276289366771)
,p_query_column_id=>7
,p_column_alias=>'PENDING_LCM_INTERFACE_COUNT'
,p_column_display_sequence=>70
,p_column_heading=>'Pending LCM Interface'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(355328276289366774)
,p_query_column_id=>10
,p_column_alias=>'PENDING_MATERIAL_COUNT'
,p_column_display_sequence=>100
,p_column_heading=>'Pending Material'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(355328276289366773)
,p_query_column_id=>9
,p_column_alias=>'PENDING_RECEIVING_COUNT'
,p_column_display_sequence=>90
,p_column_heading=>'Pending Receiving'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(355328276289366775)
,p_query_column_id=>11
,p_column_alias=>'PENDING_SHOP_FLOOR_MOVE_COUNT'
,p_column_display_sequence=>110
,p_column_heading=>'Pending Shop Floor Move'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(355328276289366769)
,p_query_column_id=>5
,p_column_alias=>'PENDING_WIP_COSTING_COUNT'
,p_column_display_sequence=>50
,p_column_heading=>'Pending WIP Costing'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(355328276289366770)
,p_query_column_id=>6
,p_column_alias=>'PENDING_WSM_INTERFACE_COUNT'
,p_column_display_sequence=>60
,p_column_heading=>'Pending WSM Interface'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(355328276289366777)
,p_query_column_id=>13
,p_column_alias=>'TOTAL_COUNT'
,p_column_display_sequence=>130
,p_column_heading=>'Total'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(355328276289366768)
,p_query_column_id=>4
,p_column_alias=>'UNCOSTED_MATERIAL_WSM_COUNT'
,p_column_display_sequence=>40
,p_column_heading=>'Uncosted Material/WSM'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(355328276289366767)
,p_query_column_id=>3
,p_column_alias=>'UNPROCESSED_MATERIAL_COUNT'
,p_column_display_sequence=>30
,p_column_heading=>'Unprocessed Material'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(355328276289366772)
,p_query_column_id=>8
,p_column_alias=>'UNPROCESSED_SHIPPING_COUNT'
,p_column_display_sequence=>80
,p_column_heading=>'Unprocessed Shipping Transactions'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(332682561127142360)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(355328276289366666)
,p_button_name=>'EXPORT_SUMMARY'
,p_static_id=>'export-pending-summary'
,p_button_static_id=>'export-pending-summary'
,p_show_as_disabled=>false
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Export Summary to Excel'
,p_button_position=>'CREATE'
,p_button_execute_validations=>'N'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-file-excel-o'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(355328276289366685)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(355328276289366666)
,p_button_name=>'RUN_ANALYSIS'
,p_static_id=>'run-pending-analysis'
,p_button_static_id=>'run-pending-analysis'
,p_show_as_disabled=>false
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Run Analysis'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(355328276289366696)
,p_name=>'P61_DB_LINK'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(355328276289366666)
,p_item_default=>'ADG'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_cHeight=>1
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(355328276289366697)
,p_name=>'P61_ORG_ID'
,p_item_sequence=>30
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(355328276289366695)
,p_name=>'P61_PERIOD_NAME'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(355328276289366666)
,p_item_default=>'select upper(to_char(trunc(sysdate - 7, ''MM''), ''MON-YYYY'', ''NLS_DATE_LANGUAGE=English'')) from dual'
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Accounting Period'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'TMS_CLOSE_PERIODS'
,p_cHeight=>1
,p_colspan=>4
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(355328276289366699)
,p_name=>'P61_READY'
,p_item_sequence=>32
,p_item_default=>'N'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(355328276289366755)
,p_name=>'P61_RESOLUTION'
,p_is_required=>true
,p_item_sequence=>25
,p_item_plug_id=>wwv_flow_imp.id(355328276289366666)
,p_item_default=>'REQUIRED'
,p_prompt=>'Resolution'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''Required'' d, ''REQUIRED'' r from dual',
'union all select ''Recommended'', ''RECOMMENDED'' from dual',
'union all select ''All'', ''ALL'' from dual'))
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(355328276289367699)
,p_name=>'P61_RUN_ID'
,p_item_sequence=>36
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(355328276289366700)
,p_name=>'P61_RUN_PERIOD'
,p_item_sequence=>33
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(355328276289366756)
,p_name=>'P61_RUN_RESOLUTION'
,p_item_sequence=>35
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(355328276289366701)
,p_name=>'P61_RUN_SOURCE'
,p_item_sequence=>34
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(355328276289366698)
,p_name=>'P61_TXN_TYPE'
,p_item_sequence=>31
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(332682561127142361)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Export Accepted Summary to XLSX'
,p_static_id=>'export-accepted-summary-xlsx'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_run_id varchar2(32):=upper(apex_util.get_session_state(''P61_RUN_ID''));',
'  l_period varchar2(15); l_source varchar2(30); l_resolution varchar2(20);',
'  l_sql varchar2(32767); l_context apex_exec.t_context; l_export apex_data_export.t_export;',
'  l_open boolean:=false; l_filename varchar2(255);',
'begin',
'  if l_run_id is null or not regexp_like(l_run_id,''^[0-9A-F]{32}$'',''c'') then',
'    raise_application_error(-20163,''Run Analysis before exporting the summary.'');',
'  end if;',
'  begin',
'    select c001,c002,c003 into l_period,l_source,l_resolution',
'    from apex_collections where collection_name=''P61RUN_''||l_run_id and seq_id=1;',
'  exception when no_data_found then',
'    raise_application_error(-20163,''This run has expired. Run Analysis again.'');',
'  end;',
'  if l_source not in (''ADG'')',
'    or not regexp_like(l_period,''^(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)-[0-9]{4}$'',''c'')',
'    or l_resolution not in (''REQUIRED'',''RECOMMENDED'',''ALL'') then',
'    raise_application_error(-20163,''Invalid accepted run. Run Analysis again.'');',
'  end if;',
'  l_sql:=q''~select s.organization_code "Org Code", s.organization_name "Inventory Organization",',
'       case when :R in (''REQUIRED'',''ALL'') then s.unprocessed_material_count end "Unprocessed Material",',
'       case when :R in (''REQUIRED'',''ALL'') then s.uncosted_material_wsm_count end "Uncosted Material/WSM",',
'       case when :R in (''REQUIRED'',''ALL'') then s.pending_wip_costing_count end "Pending WIP Costing",',
'       case when :R in (''REQUIRED'',''ALL'') then s.pending_wsm_interface_count end "Pending WSM Interface",',
'       case when :R in (''REQUIRED'',''ALL'') then s.pending_lcm_interface_count end "Pending LCM Interface",',
'       case when :R in (''REQUIRED'',''ALL'') then s.unprocessed_shipping_count end "Unprocessed Shipping Transactions",',
'       case when :R in (''RECOMMENDED'',''ALL'') then s.pending_receiving_count end "Pending Receiving",',
'       case when :R in (''RECOMMENDED'',''ALL'') then s.pending_material_count end "Pending Material",',
'       case when :R in (''RECOMMENDED'',''ALL'') then s.pending_shop_floor_move_count end "Pending Shop Floor Move",',
'       case when :R in (''RECOMMENDED'',''ALL'') then s.incomplete_work_orders_count end "Incomplete Work Orders",',
'       s.total_count "Total"',
'  from table(xxme_inv_pending_period_pkg.get_summary(:P,:L,:R)) s',
' where s.total_count>0 order by s.organization_name,s.organization_code~'';',
'  l_sql:=replace(l_sql,'':P'',dbms_assert.enquote_literal(l_period));',
'  l_sql:=replace(l_sql,'':L'',dbms_assert.enquote_literal(l_source));',
'  l_sql:=replace(l_sql,'':R'',dbms_assert.enquote_literal(l_resolution));',
'  l_context:=apex_exec.open_query_context(p_location=>apex_exec.c_location_local_db,',
'    p_sql_query=>l_sql,p_auto_bind_items=>false); l_open:=true;',
'  l_filename:=''Inventory_Pending_''||l_period||''_''||l_source||''_''||l_resolution;',
'  l_export:=apex_data_export.export(p_context=>l_context,p_format=>apex_data_export.c_format_xlsx,p_file_name=>l_filename);',
'  apex_exec.close(l_context); l_open:=false;',
'  apex_data_export.download(p_export=>l_export);',
'exception when apex_application.e_stop_apex_engine then raise;',
'  when others then if l_open then apex_exec.close(l_context); end if; raise;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(332682561127142360)
,p_internal_uid=>120061000000000052
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(355328276289366705)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Initialize AJAX Panes'
,p_static_id=>'initialize-ajax-panes'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  procedure put(p_name varchar2,p_value varchar2) is',
'  begin',
'    apex_util.set_session_state(p_name=>p_name,p_value=>p_value,p_commit=>false);',
'  end;',
'begin',
'  -- Every full render starts idle. Do not delete collections belonging to other tabs.',
'  put(''P61_RUN_ID'',null); put(''P61_READY'',''N'');',
'  put(''P61_ORG_ID'',null); put(''P61_TXN_TYPE'',null);',
'  put(''P61_RUN_PERIOD'',null); put(''P61_RUN_SOURCE'',null); put(''P61_RUN_RESOLUTION'',null);',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>120061000000000040
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(355328276289366707)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'P61_SET_CONTEXT'
,p_static_id=>'p61-set-context'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_action varchar2(20) := apex_application.g_x01;',
'  l_period varchar2(15) := upper(trim(apex_application.g_x02));',
'  l_source varchar2(30) := upper(trim(apex_application.g_x03));',
'  l_org_text varchar2(30) := apex_application.g_x04;',
'  l_type varchar2(80) := apex_application.g_x05;',
'  l_resolution varchar2(20) := upper(trim(apex_application.g_x06));',
'  l_previous_id varchar2(32) := upper(apex_application.g_x07);',
'  l_run_id varchar2(32); l_collection varchar2(255); l_org number;',
'  l_saved_period varchar2(15); l_saved_source varchar2(30); l_saved_resolution varchar2(20);',
'  l_created boolean := false;',
'  l_requested_type varchar2(80);',
'begin',
'  -- P61_SERVER_CONTEXT_V1: scalar inputs describe a request, not preapproved state.',
'  if l_action is null or l_action not in (''RUN'',''DETAIL'') then',
'    raise_application_error(-20166,''Unsupported report request.'');',
'  end if;',
'  if l_source is null or l_source not in (''ADG'') then',
'    raise_application_error(-20161,''Select an approved database source.'');',
'  end if;',
'  if l_period is null or not regexp_like(l_period,''^(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)-[0-9]{4}$'',''c'') then',
'    raise_application_error(-20162,''Select an accounting period.'');',
'  end if;',
'  if l_resolution is null or l_resolution not in (''REQUIRED'',''RECOMMENDED'',''ALL'') then',
'    raise_application_error(-20167,''Select Required, Recommended or All.'');',
'  end if;',
'  if l_action=''RUN'' then',
'    l_run_id:=rawtohex(sys_guid());',
'    l_collection:=''P61RUN_''||l_run_id;',
'    apex_collection.create_collection(p_collection_name=>l_collection);',
'    l_created:=true;',
'    apex_collection.add_member(p_collection_name=>l_collection,',
'      p_c001=>l_period,p_c002=>l_source,p_c003=>l_resolution,p_d001=>sysdate);',
'    -- Member 1 is immutable run context; member 2 is this run''s selected detail.',
'    apex_collection.add_member(p_collection_name=>l_collection,p_c050=>''DETAIL_SELECTION'');',
'    l_org:=null; l_type:=null;',
'  else',
'    if l_previous_id is null or not regexp_like(l_previous_id,''^[0-9A-F]{32}$'',''c'') then',
'      raise_application_error(-20163,''Run Analysis before selecting a count.'');',
'    end if;',
'    l_run_id:=l_previous_id; l_collection:=''P61RUN_''||l_run_id;',
'    begin',
'      select c001,c002,c003 into l_saved_period,l_saved_source,l_saved_resolution',
'      from apex_collections where collection_name=l_collection and seq_id=1;',
'    exception when no_data_found then',
'      raise_application_error(-20163,''This run has expired. Run Analysis again.'');',
'    end;',
'    if l_period<>l_saved_period or l_source<>l_saved_source or l_resolution<>l_saved_resolution then',
'      raise_application_error(-20163,''The selected count does not belong to this run. Run Analysis again.'');',
'    end if;',
'    if l_org_text is null or not regexp_like(l_org_text,''^[0-9]{1,18}$'',''c'') then',
'      raise_application_error(-20164,''Invalid inventory organization.'');',
'    end if;',
'    l_org:=to_number(l_org_text); l_requested_type:=l_type;',
'    if l_requested_type=''Total'' then',
'      l_type:=case l_resolution when ''REQUIRED'' then ''__TOTAL_REQUIRED__''',
'        when ''RECOMMENDED'' then ''__TOTAL_RECOMMENDED__'' else ''__TOTAL_ALL__'' end;',
'    elsif l_requested_type in (''Unprocessed Material'',''Uncosted Material/WSM'',''Pending WIP Costing'',''Pending WSM Interface'',''Pending LCM Interface'',''Unprocessed Shipping Transactions'',''Pending Receiving'',''Pending Material'',''Pending Shop Floor Move'','''
||'Incomplete Work Orders'') then',
'      l_type:=l_requested_type;',
'    else',
'      raise_application_error(-20165,''Invalid transaction category.'');',
'    end if;',
'    if l_org<=0 then raise_application_error(-20164,''Invalid inventory organization.''); end if;',
'    if (l_resolution=''REQUIRED'' and l_type in (''Pending Receiving'',''Pending Material'',''Pending Shop Floor Move'',''Incomplete Work Orders''))',
'      or (l_resolution=''RECOMMENDED'' and l_type in (''Unprocessed Material'',''Uncosted Material/WSM'',''Pending WIP Costing'',''Pending WSM Interface'',''Pending LCM Interface'',''Unprocessed Shipping Transactions'')) then',
'      raise_application_error(-20168,''Transaction type is outside the selected resolution.'');',
'    end if;',
'    apex_ir.reset_report(p_page_id=>61,p_region_static_id=>''pending-details'');',
'    apex_collection.update_member(p_collection_name=>l_collection,p_seq=>2,',
'      p_c001=>l_type,p_n001=>l_org,p_c050=>''DETAIL_SELECTION'');',
'  end if;',
'  -- Retire only this tab''s previous run after its replacement was accepted.',
'  if l_action=''RUN'' and regexp_like(l_previous_id,''^[0-9A-F]{32}$'',''c'') and l_previous_id<>l_run_id then',
'    if apex_collection.collection_exists(p_collection_name=>''P61RUN_''||l_previous_id) then',
'      apex_collection.delete_collection(p_collection_name=>''P61RUN_''||l_previous_id);',
'    end if;',
'  end if;',
'  apex_json.open_object;',
'  apex_json.write(''ok'',true); apex_json.write(''version'',''P61_SERVER_CONTEXT_V1'');',
'  apex_json.write(''action'',l_action); apex_json.write(''run_id'',l_run_id); apex_json.write(''ready'',''Y'');',
'  apex_json.write(''period'',l_period); apex_json.write(''source'',l_source); apex_json.write(''resolution'',l_resolution);',
'  apex_json.write(''org'',to_char(l_org,''FM99999999999999999990'')); apex_json.write(''type'',l_requested_type);',
'  apex_json.close_object;',
'exception when others then',
'  if l_created and apex_collection.collection_exists(p_collection_name=>l_collection) then',
'    apex_collection.delete_collection(p_collection_name=>l_collection);',
'  end if;',
'  apex_json.open_object; apex_json.write(''ok'',false);',
'  apex_json.write(''message'',case when sqlcode between -20999 and -20000 then substr(sqlerrm,12)',
'    else ''Unable to prepare the report. Check the APEX debug log.'' end);',
'  apex_json.close_object;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>120061000000000042
);
end;
/
prompt --application/end_environment
declare
  l_cnt number;
begin
  select count(*)
    into l_cnt
    from apex_application_pages
   where application_id = 128
     and page_id in (1, 10, 11, 20, 22, 23, 30, 41, 50, 61);
  if l_cnt <> 10 then
    rollback;
    apex_application_install.clear_all;
    raise_application_error(-20998, 'Aborted App 128 commit: expected 10 patched pages, found ' || l_cnt);
  end if;
  wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false)
  );
  commit;
  apex_application_install.clear_all;
end;
/
set verify on feedback on define on
prompt  ...done
