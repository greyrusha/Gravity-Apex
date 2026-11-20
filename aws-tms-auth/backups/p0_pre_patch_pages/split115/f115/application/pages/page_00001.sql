prompt --application/pages/page_00001
begin
--   Manifest
--     PAGE: 00001
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
'#R190046942772711880 .t-HeroRegion-icon {',
'  background-color: var(--tms-accent, #4840a8);',
'  color: var(--tms-on-accent, #fff);',
'}'))
,p_step_template=>4075783602716660119
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(9156329399484443)
,p_protection_level=>'C'
,p_page_component_map=>'13'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(192280613713710042)
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
 p_id=>wwv_flow_imp.id(190046942772711880)
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
 p_id=>wwv_flow_imp.id(193451227859245834)
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
 p_id=>wwv_flow_imp.id(193451311017245835)
,p_region_id=>wwv_flow_imp.id(193451227859245834)
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
 p_id=>wwv_flow_imp.id(193451420781245836)
,p_card_id=>wwv_flow_imp.id(193451311017245835)
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
 p_id=>wwv_flow_imp.id(192282840875710064)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(192280613713710042)
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
 p_id=>wwv_flow_imp.id(1007183232099592077)
,p_name=>'P1_AI_SERVICE_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(192280613713710042)
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
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(246282681911656137)
,p_name=>'P1_DB_LINK'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(192280613713710042)
,p_item_default=>'ADG'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_cHeight=>1
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(192280786011710043)
,p_name=>'P1_PERIOD_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(192280613713710042)
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
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(977906411218695080)
,p_name=>'Select AI Provider'
,p_static_id=>'select-ai-provider'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1_AI_SERVICE_ID'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(1007183232099592079)
,p_event_id=>wwv_flow_imp.id(977906411218695080)
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
,p_build_option_id=>wwv_flow_imp.id(1017112543199391948)
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(246282681911656139)
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
,p_process_when_button_id=>wwv_flow_imp.id(192282840875710064)
,p_internal_uid=>111000000000900003
);
wwv_flow_imp.component_end;
end;
/
