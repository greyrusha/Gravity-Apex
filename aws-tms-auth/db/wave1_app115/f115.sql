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
,p_default_application_id=>115
,p_default_id_offset=>9156328499369442
,p_default_owner=>'GL_ACCOUNTS'
);
if wwv_flow.g_flow_id <> 115 then
  apex_application_install.clear_all;
  raise_application_error(-20999, 'Unexpected g_flow_id=' || nvl(to_char(wwv_flow.g_flow_id), 'NULL'));
end if;
end;
/
 
prompt APPLICATION 115 - TMS GBS Control Tower
--
-- Application Export:
--   Application:     115
--   Name:            TMS GBS Control Tower
--   Exported By:     GL_ACCOUNTS
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PAGE: 1
--     PAGE: 23
--     PAGE: 24
--     PAGE: 33
--     PAGE: 34
--   Manifest End
--   Version:         26.2.0
--   Instance ID:     649767868204930
--

begin
  -- replace components
  wwv_flow_imp.g_mode := 'REPLACE';
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
'.kpi-card-body.kpi-good {',
'    border-left-color: var(--tms-success-text, #15803d);',
'    background-color: var(--tms-success-bg, #f0fdf4);',
'}',
'.kpi-card-body.kpi-warn {',
'    border-left-color: var(--tms-warning-text, #b45309);',
'    background-color: var(--tms-warning-bg, #fffbeb);',
'}',
'.kpi-card-body.kpi-bad {',
'    border-left-color: #b91c1c;',
'    background-color: #fef2f2;',
'}',
'body.tms-dark-mode .kpi-card-body.kpi-good {',
'    background-color: var(--tms-success-bg, #243f32);',
'    color: var(--tms-text, #e4e8ed);',
'    border-left-color: var(--tms-success-text, #a0dfbc);',
'}',
'body.tms-dark-mode .kpi-card-body.kpi-warn {',
'    background-color: var(--tms-warning-bg, #403623);',
'    color: var(--tms-text, #e4e8ed);',
'    border-left-color: var(--tms-warning-text, #f0ce8f);',
'}',
'body.tms-dark-mode .kpi-card-body.kpi-bad {',
'    background-color: #422b30;',
'    color: var(--tms-text, #e4e8ed);',
'    border-left-color: #f1a3ab;',
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
'        sum(case when g.ledger_id=10001 then g.unposted_due_headers+g.error_status_headers+g.unbalanced_due_batches+g.interface_row_count else 0 end) ch_count,',
'        case',
'          when nvl(sum(g.error_status_headers+g.unbalanced_due_batches),0) > 0 then ''kpi-bad''',
'          when nvl(sum(g.unposted_due_headers+g.error_status_headers+g.unbalanced_due_batches+g.interface_row_count),0) > 0 then ''kpi-warn''',
'          else ''kpi-good''',
'        end card_color_class',
' from table(xxme_gl_summary_pkg.get_summary(:P1_PERIOD_NAME,:P1_DB_LINK)) g',
'), exceptions as (',
' select 200 application_id,x.* from table(xxme_ap_ar_detail_pkg.get_summary(200,:P1_PERIOD_NAME,:P1_DB_LINK)) x',
' union all',
' select 222 application_id,x.* from table(xxme_ap_ar_detail_pkg.get_summary(222,:P1_PERIOD_NAME,:P1_DB_LINK)) x',
'), modules as (',
' select 200 application_id from dual',
' union all',
' select 222 application_id from dual',
'), arap as (',
' select case m.application_id when 200 then 20 else 30 end display_sequence,',
'        case m.application_id when 200 then 20 else 30 end target_page,',
'        case m.application_id when 200 then ''P20_PERIOD_NAME'' else ''P30_PERIOD_NAME'' end target_item,',
'        case m.application_id when 200 then ''Payables SLA Exceptions'' else ''Receivables SLA Exceptions'' end card_title,',
'        case m.application_id when 200 then ''fa fa-file-text-o'' else ''fa fa-money'' end card_icon,',
'        nvl(sum(e.event_count),0) open_count,',
'        nvl(sum(case when e.ledger_id=1003 then e.event_count else 0 end),0) us_count,',
'        nvl(sum(case when e.ledger_id=5001 then e.event_count else 0 end),0) uk_count,',
'        nvl(sum(case when e.ledger_id=10001 then e.event_count else 0 end),0) ch_count,',
'        case',
'          when nvl(sum(case when e.severity=''RED'' then e.event_count else 0 end),0) > 0 then ''kpi-bad''',
'          when nvl(sum(e.event_count),0) > 0 then ''kpi-warn''',
'          else ''kpi-good''',
'        end card_color_class',
' from modules m',
' left join exceptions e',
'   on e.application_id=m.application_id and',
'      e.exception_type in (''PROCESSING/ACCOUNTING ERROR'',''ACCOUNTING NOT FINAL'',''NOT TRANSFERRED TO GL'',''UNPROCESSED EVENT'')',
' group by m.application_id',
'), all_cards as (',
' select display_sequence,target_page,target_item,card_title,card_icon,card_color_class,nvl(open_count,0) open_count,nvl(us_count,0) us_count,nvl(uk_count,0) uk_count,nvl(ch_count,0) ch_count,',
'        nvl(open_count,0)||'' Open GL items<br>US: ''||nvl(us_count,0)||'' | UK: ''||nvl(uk_count,0)||'' | CH: ''||nvl(ch_count,0) card_text from gl',
' union all',
' select display_sequence,target_page,target_item,card_title,card_icon,card_color_class,open_count,us_count,uk_count,ch_count,',
'        open_count||'' Open accounting exceptions<br>US: ''||us_count||'' | UK: ''||uk_count||'' | CH: ''||ch_count from arap',
' union all select 40,41,''P41_PERIOD_NAME'',''Inventory/Cost Management SLA'',''fa fa-database'',''kpi-neutral'',null,null,null,null,''Open dedicated Inventory/Cost Management SLA analysis'' from dual',
' union all select 50,50,''P50_PERIOD_NAME'',''AI Month-End Analyst'',''fa fa-comments'',''kpi-neutral'',null,null,null,null,''Ask month-end questions in plain language'' from dual',
' where apex_application_admin.get_build_option_status(p_application_id=>:APP_ID,p_build_option_name=>''FEATURE_AI'') = ''INCLUDE''',
' union all select 50,null,null,''AI Analyst'',''fa fa-comments'',''kpi-neutral'',null,null,null,null,''Reserved for future AI Analyst capability.'' from dual',
' where apex_application_admin.get_build_option_status(p_application_id=>:APP_ID,p_build_option_name=>''FEATURE_AI'') = ''EXCLUDE''',
')',
'select display_sequence,card_title,card_text,card_icon,card_color_class,open_count,us_count,uk_count,ch_count,',
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
,p_required_role=>wwv_flow_imp.id(9156329399484443)
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(983078933012277684)
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
 p_id=>wwv_flow_imp.id(983078933012277702)
,p_query_column_id=>1
,p_column_alias=>'AGING_BAR'
,p_column_display_sequence=>10
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(317992543199414948)
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
 p_id=>wwv_flow_imp.id(983078933012277682)
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
 p_id=>wwv_flow_imp.id(983078933012277683)
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
 p_id=>wwv_flow_imp.id(983078933012277701)
,p_query_column_id=>1
,p_column_alias=>'KPI_HTML'
,p_column_display_sequence=>10
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(983078933012277687)
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
 p_id=>wwv_flow_imp.id(983078933012277731)
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
 p_id=>wwv_flow_imp.id(983078933012277809)
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
 p_id=>wwv_flow_imp.id(983078933012277805)
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
 p_id=>wwv_flow_imp.id(983078933012277806)
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
 p_id=>wwv_flow_imp.id(983078933012277807)
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
 p_id=>wwv_flow_imp.id(983078933012277808)
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
 p_id=>wwv_flow_imp.id(983078933012277802)
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
 p_id=>wwv_flow_imp.id(983078933012277813)
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
 p_id=>wwv_flow_imp.id(983078933012277801)
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
 p_id=>wwv_flow_imp.id(983078933012277804)
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
 p_id=>wwv_flow_imp.id(983078933012277803)
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
 p_id=>wwv_flow_imp.id(983078933012277810)
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
 p_id=>wwv_flow_imp.id(983078933012277811)
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
 p_id=>wwv_flow_imp.id(983078933012277812)
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
 p_id=>wwv_flow_imp.id(983078933012277814)
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
 p_id=>wwv_flow_imp.id(983078933012277732)
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
 p_id=>wwv_flow_imp.id(983078933012277685)
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
 p_id=>wwv_flow_imp.id(983078933012277721)
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
 p_id=>wwv_flow_imp.id(983078933012277784)
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
 p_id=>wwv_flow_imp.id(983078933012277790)
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
 p_id=>wwv_flow_imp.id(983078933012277782)
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
 p_id=>wwv_flow_imp.id(983078933012277783)
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
 p_id=>wwv_flow_imp.id(983078933012277789)
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
 p_id=>wwv_flow_imp.id(983078933012277788)
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
 p_id=>wwv_flow_imp.id(983078933012277781)
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
 p_id=>wwv_flow_imp.id(983078933012277785)
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
 p_id=>wwv_flow_imp.id(983078933012277786)
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
 p_id=>wwv_flow_imp.id(983078933012277787)
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
 p_id=>wwv_flow_imp.id(983078933012277722)
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
 p_id=>wwv_flow_imp.id(983078933012277686)
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
 p_id=>wwv_flow_imp.id(983078933012277883)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(983078933012277682)
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
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(983078933012277882)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(983078933012277686)
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
 p_id=>wwv_flow_imp.id(983078933012277881)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(983078933012277682)
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
 p_id=>wwv_flow_imp.id(983078933012277982)
,p_name=>'P23_AS_OF_DATE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(983078933012277682)
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
 p_id=>wwv_flow_imp.id(983078933012277991)
,p_name=>'P23_BACK_URL'
,p_item_sequence=>130
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(983078933012277984)
,p_name=>'P23_COMPANY'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(983078933012277682)
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
 p_id=>wwv_flow_imp.id(983078933012277981)
,p_name=>'P23_DB_LINK'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(983078933012277682)
,p_item_default=>'ADG'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(983078933012277986)
,p_name=>'P23_GENERATED_BY'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(983078933012277682)
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
 p_id=>wwv_flow_imp.id(983078933012277985)
,p_name=>'P23_GENERATED_ON'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(983078933012277682)
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
 p_id=>wwv_flow_imp.id(983078933012277983)
,p_name=>'P23_LEDGER_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(983078933012277682)
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
 p_id=>wwv_flow_imp.id(983078933012277987)
,p_name=>'P23_ROW_COUNT'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(983078933012277682)
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
 p_id=>wwv_flow_imp.id(983078933012277990)
,p_name=>'P23_SELECTED_BUCKET'
,p_item_sequence=>120
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(983078933012277989)
,p_name=>'P23_SELECTED_VENDOR_ID'
,p_item_sequence=>110
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(983078933012277988)
,p_name=>'P23_SNAPSHOT_READY'
,p_item_sequence=>100
,p_item_default=>'N'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(983078933012278085)
,p_name=>'Analyze Aging with AI'
,p_static_id=>'analyze-aging-with-ai'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(983078933012277883)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(983078933012278086)
,p_event_id=>wwv_flow_imp.id(983078933012278085)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p23Controller.openAi();')).to_clob
,p_build_option_id=>wwv_flow_imp.id(1017112543199391948)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(983078933012278083)
,p_name=>'Close Detail'
,p_static_id=>'close-detail'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(983078933012277882)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(983078933012278084)
,p_event_id=>wwv_flow_imp.id(983078933012278083)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p23Controller.closeDetail();')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(983078933012278081)
,p_name=>'Close Page'
,p_static_id=>'close-page'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(983078933012277881)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(983078933012278082)
,p_event_id=>wwv_flow_imp.id(983078933012278081)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p23Controller.closePage();')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(983078933012278182)
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
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
,p_internal_uid=>896156623912686001
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(983078933012278181)
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
prompt --application/pages/delete_00024
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>24);
end;
/
prompt --application/pages/page_00024
begin
wwv_flow_imp_page.create_page(
 p_id=>24
,p_name=>'GL AP Reconciliation'
,p_alias=>'GL-AP-RECONCILIATION'
,p_step_title=>'GL/AP Reconciliation'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var p24Controller = (function ($) {',
'  ''use strict'';',
'  var busy=false, spinner=null, timerId=null, startedAt=null;',
'  function byId(id){return $(''#''+id);}',
'  function region(id){try{return apex.region(id);}catch(ignore){return null;}}',
'  function seconds(){return ((performance.now()-startedAt)/1000).toFixed(1)+'' s'';}',
'  function stop(){if(timerId){clearInterval(timerId);timerId=null;}if(spinner){spinner.remove();spinner=null;}}',
'  function setBusy(on){busy=on;byId(''run-gl-ap-recon'').prop(''disabled'',on);}',
'  function status(kind,title,body,timing){',
'    byId(''recon-status'').show();',
'    byId(''p24-status-panel'').removeAttr(''hidden'').removeClass(''p24-status--info p24-status--success p24-status--error'').addClass(''p24-status--''+kind);',
'    byId(''p24-status-title'').text(title);byId(''p24-status-body'').text(body||'''');byId(''p24-status-timing'').text(timing||'''');',
'  }',
'  function refresh(id){var r=region(id);if(r&&typeof r.refresh===''function''){r.refresh();}else{byId(id).trigger(''apexrefresh'');}}',
'  function highlightVarianceRows(){',
'    byId(''gl-ap-recon-report'').find(''.a-IRR-table tbody tr'').each(function(){',
'      $(this).toggleClass(''p24-variance-row'',$(this).find(''.p24-badge--variance'').length>0);',
'    });',
'  }',
'  function hideResults(){',
'    apex.item(''P24_REPORT_READY'').setValue(''N'',null,true);',
'    byId(''recon-kpis'').hide();byId(''gl-ap-recon-report'').hide();byId(''analyze-reconciliation-with-ai'').hide();closeDetail();',
'  }',
'  function populateKpis(s){',
'    byId(''p24-kpi-accounts'').text(s.account_count);',
'    byId(''p24-kpi-ap'').text(s.ap_total);',
'    byId(''p24-kpi-gl'').text(s.gl_total);',
'    byId(''p24-kpi-variance'').text(s.variance_total);',
'    byId(''p24-kpi-out'').text(s.out_of_balance);',
'  }',
'  function run(){',
'    if(busy||apex.item(''P24_CONTEXT_READY'').getValue()!==''Y''){return;}',
'    hideResults();setBusy(true);startedAt=performance.now();',
'    status(''info'',''Running GL/AP reconciliation'',''Retrieving GL balances and activity from TMS. This normally takes approximately 20-30 seconds.'',''Elapsed: 0.0 s'');',
'    timerId=setInterval(function(){byId(''p24-status-timing'').text(''Elapsed: ''+seconds());},250);',
'    try{spinner=apex.util.showSpinner(byId(''recon-status''));}catch(ignore){spinner=null;}',
'    apex.server.process(''P24_RUN_RECON'',{pageItems:''#P24_DB_LINK,#P24_AS_OF_DATE,#P24_LEDGER_ID,#P24_COMPANY''},{dataType:''json''}).then(function(result){',
'      stop();setBusy(false);',
'      if(!result||result.ok!==true){status(''error'',''Reconciliation failed'',(result&&result.message)||''Unable to run reconciliation.'');return;}',
'      apex.item(''P24_REPORT_READY'').setValue(''Y'',null,true);populateKpis(result.summary);',
'      byId(''recon-kpis'').show();byId(''gl-ap-recon-report'').show();byId(''analyze-reconciliation-with-ai'').show();refresh(''gl-ap-recon-report'');',
'      status(''success'',''Reconciliation complete'',result.summary.account_count+'' liability accounts evaluated.'',''Total: ''+seconds());',
'    },function(error){stop();setBusy(false);status(''error'',''Reconciliation failed'',(error&&error.message)||''Unable to run reconciliation.'');});',
'  }',
'  function drill(ccid){',
'    var account='''';',
'    byId(''gl-ap-recon-report'').find(''a'').each(function(){',
'      var href=this.getAttribute(''href'')||'''';',
'      if(href.indexOf(''drill(''+ccid+'')'')>=0){account=$.trim($(this).text());return false;}',
'    });',
'    apex.item(''P24_SELECTED_CCID'').setValue(String(ccid),null,true);',
'    byId(''p24-detail-selection'').text(account||''Selected liability account'');',
'    byId(''recon-detail-context'').show();byId(''recon-invoice-detail'').show();refresh(''recon-invoice-detail'');',
'    $(''html, body'').animate({scrollTop:byId(''recon-detail-context'').offset().top-12},200);',
'  }',
'  function closeDetail(){apex.item(''P24_SELECTED_CCID'').setValue('''',null,true);byId(''recon-detail-context'').hide();byId(''recon-invoice-detail'').hide();}',
'  function openAi(){',
'    if(busy||apex.item(''P24_REPORT_READY'').getValue()!==''Y''){return;}',
'    var target=''ap_recon_ai_''+Date.now(),child=window.open('''',target);',
'    if(!child){apex.message.showErrors([{type:''error'',location:''page'',message:''Allow pop-ups to open the AI Analyst in a new tab.'',unsafe:false}]);return;}',
unistr('    child.document.write(''<title>Opening AI Analyst</title><p style="font-family:sans-serif;padding:1rem">Opening AI Analyst\2026</p>'');'),
'    apex.server.process(''P24_GET_AI_URL'',{pageItems:''#P24_DB_LINK,#P24_AS_OF_DATE,#P24_LEDGER_ID,#P24_COMPANY,#P24_REPORT_READY''},{dataType:''json''}).then(function(result){',
'      if(!result||result.ok!==true||!result.url){child.close();apex.message.showErrors([{type:''error'',location:''page'',message:(result&&result.message)||''Unable to open the AI Analyst.'',unsafe:false}]);return;}',
'      child.location.replace(result.url);',
'    },function(error){child.close();apex.message.showErrors([{type:''error'',location:''page'',message:(error&&error.message)||''Unable to open the AI Analyst.'',unsafe:false}]);});',
'  }',
'  function closePage(){window.close();setTimeout(function(){if(!window.closed){apex.navigation.redirect(apex.item(''P24_BACK_URL'').getValue());}},250);}',
'  $(function(){',
'    hideResults();byId(''recon-status'').hide();byId(''p24-status-panel'').attr(''hidden'',''hidden'');',
'    $(document).on(''apexafterrefresh.p24'',''#gl-ap-recon-report'',highlightVarianceRows);',
'  });',
'  return {run:run,drill:drill,openAi:openAi,closeDetail:closeDetail,closePage:closePage};',
'})(apex.jQuery);'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#recon-kpis,#gl-ap-recon-report,#recon-detail-context,#recon-invoice-detail{display:none;}',
'#recon-status{position:relative;min-height:4rem;}',
'.p24-status{border-left:4px solid #2563eb;border-radius:.25rem;padding:.8rem 1rem;background:#eff6ff;}',
'.p24-status--success{border-left-color:#15803d;background:#f0fdf4;}',
'.p24-status--error{border-left-color:#b91c1c;background:#fef2f2;}',
'#p24-status-title{font-size:1rem;font-weight:700;margin:0 0 .25rem;}',
'#p24-status-body{margin:0;}#p24-status-timing{font-variant-numeric:tabular-nums;font-weight:600;margin-top:.35rem;}',
'.p24-kpis{display:grid;grid-template-columns:repeat(5,minmax(0,1fr));gap:1rem;padding:.25rem;}',
'.p24-kpi{border:1px solid var(--ut-component-border-color,#d9dce1);border-radius:.5rem;padding:1rem;background:var(--ut-component-background-color,#fff);}',
'.p24-kpi-label{font-size:.75rem;text-transform:uppercase;letter-spacing:.04em;color:#5f6368;}',
'.p24-kpi-value{font-size:1.35rem;font-weight:700;font-variant-numeric:tabular-nums;margin-top:.3rem;}',
'.p24-detail-banner{font-weight:600;padding:.35rem 0;}',
'.p24-status-badge{display:inline-block;border-radius:999px;padding:.15rem .55rem;font-weight:700;}',
'.p24-badge--balanced{background:#ecfdf3;color:#166534;}',
'.p24-badge--variance{background:#fee2e2;color:#991b1b;}',
'.p24-variance-row>td{background:#fff7ed!important;}',
'@media(max-width:900px){.p24-kpis{grid-template-columns:repeat(2,minmax(0,1fr));}}'))
,p_step_template=>4075783602716660119
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(9156329399484443)
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(984078933012277685)
,p_plug_name=>'GL AP Reconciliation Report'
,p_static_id=>'gl-ap-recon-report'
,p_title=>'GL/AP Reconciliation by Liability Account'
,p_region_name=>'gl-ap-recon-report'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>40
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select n001 gl_liab_ccid, c001 gl_liability_code, n002 ap_open_accounted_amount,',
'       c002 gl_period_name, n003 gl_closing_balance,',
'       to_number(c004,''99999999999999999999999999999999999999D99999999999999999999'',''NLS_NUMERIC_CHARACTERS=''''.,'''''') gl_period_payables_activity,',
'       to_number(c005,''99999999999999999999999999999999999999D99999999999999999999'',''NLS_NUMERIC_CHARACTERS=''''.,'''''') gl_period_revaluation_activity,',
'       to_number(c006,''99999999999999999999999999999999999999D99999999999999999999'',''NLS_NUMERIC_CHARACTERS=''''.,'''''') gl_period_non_payables_activity,',
'       n004 variance_amount, n005 ap_not_transferred_amount,',
'       to_number(c007,''99999999999999999999999999999999999999D99999999999999999999'',''NLS_NUMERIC_CHARACTERS=''''.,'''''') gl_ytd_payables_activity,',
'       to_number(c008,''99999999999999999999999999999999999999D99999999999999999999'',''NLS_NUMERIC_CHARACTERS=''''.,'''''') gl_ytd_revaluation_activity,',
'       to_number(c009,''99999999999999999999999999999999999999D99999999999999999999'',''NLS_NUMERIC_CHARACTERS=''''.,'''''') gl_ytd_non_payables_activity,',
'       case when abs(nvl(n004,0)) < 0.01',
'            then ''<span class="p24-status-badge p24-badge--balanced">Balanced</span>''',
'            else ''<span class="p24-status-badge p24-badge--variance">Variance</span>'' end status',
'  from apex_collections',
' where collection_name = ''P24_GL_AP_RECON''',
'   and :P24_REPORT_READY = ''Y'''))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P24_REPORT_READY'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'GL AP Reconciliation'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(984078933012277721)
,p_no_data_found_message=>'No liability accounts were returned for this snapshot.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>true
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_internal_uid=>897156623912685640
,p_ai_report_hint=>wwv_flow_string.join(wwv_flow_t_varchar2(
'GL/AP reconciliation for the selected snapshot, one row per full GL liability account. AP and GL balances are presented credit-positive in ledger functional currency.',
'VARIANCE_AMOUNT equals AP_OPEN_ACCOUNTED_AMOUNT minus GL_CLOSING_BALANCE. STATUS is Balanced when absolute variance is below 0.01; otherwise it is Variance. Highlight and prioritize non-zero variance rows.',
'Period activity columns describe only the resolved GL period. YTD activity columns are cumulative through that period. Do not mix period and YTD values. A null GL closing balance means no matching GL balance was returned and must not be silently trea'
||'ted as zero.',
'Prefer GL_LIABILITY_CODE over hidden GL_LIAB_CCID.'))
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277788)
,p_db_column_name=>'AP_NOT_TRANSFERRED_AMOUNT'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'AP Not Transferred'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'AP accounted amount associated with entries not transferred to GL for this liability account, in ledger functional currency.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277783)
,p_db_column_name=>'AP_OPEN_ACCOUNTED_AMOUNT'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'AP Open Balance'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'AP open trial-balance amount for this liability account in ledger functional currency, presented credit-positive.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277785)
,p_db_column_name=>'GL_CLOSING_BALANCE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'GL Closing Balance'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'GL closing balance for the liability account and resolved period in ledger functional currency, presented credit-positive. Null means no matching GL balance was returned; do not replace null with zero.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277782)
,p_db_column_name=>'GL_LIABILITY_CODE'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'GL Liability Account'
,p_column_link=>'javascript:p24Controller.drill(#GL_LIAB_CCID#);'
,p_column_linktext=>'#GL_LIABILITY_CODE#'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Full concatenated GL liability account combination. Use for display, filters, grouping, and account comparisons.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277781)
,p_db_column_name=>'GL_LIAB_CCID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'GL Liability CCID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical GL code combination ID used for drilldown. Prefer GL_LIABILITY_CODE in all business-facing output.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277784)
,p_db_column_name=>'GL_PERIOD_NAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'GL Period'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Oracle GL accounting period resolved from the reconciliation as-of date.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277791)
,p_db_column_name=>'GL_PERIOD_NON_PAYABLES_ACTIVITY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Period Non-Payables'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Net GL activity from sources other than Payables and revaluation for only the resolved accounting period, presented credit-positive.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277789)
,p_db_column_name=>'GL_PERIOD_PAYABLES_ACTIVITY'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Period Payables Activity'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Net GL Payables-source activity for only the resolved accounting period, presented credit-positive.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277790)
,p_db_column_name=>'GL_PERIOD_REVALUATION_ACTIVITY'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Period Revaluation'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Net GL revaluation activity for only the resolved accounting period, presented credit-positive.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277794)
,p_db_column_name=>'GL_YTD_NON_PAYABLES_ACTIVITY'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'YTD Non-Payables'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Cumulative GL activity from sources other than Payables and revaluation from fiscal-year start through the resolved period, presented credit-positive.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277792)
,p_db_column_name=>'GL_YTD_PAYABLES_ACTIVITY'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'YTD Payables Activity'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Cumulative GL Payables-source activity from fiscal-year start through the resolved period, presented credit-positive.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277793)
,p_db_column_name=>'GL_YTD_REVALUATION_ACTIVITY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'YTD Revaluation'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Cumulative GL revaluation activity from fiscal-year start through the resolved period, presented credit-positive.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277787)
,p_db_column_name=>'STATUS'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Reconciliation classification: Balanced when absolute variance is below 0.01, otherwise Variance. The displayed value contains harmless badge HTML.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277786)
,p_db_column_name=>'VARIANCE_AMOUNT'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Variance'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'AP_OPEN_ACCOUNTED_AMOUNT minus GL_CLOSING_BALANCE. Rank reconciliation issues by absolute variance, preserving the signed value.'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(984078933012277722)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'GL_LIABILITY_CODE:AP_OPEN_ACCOUNTED_AMOUNT:GL_PERIOD_NAME:GL_CLOSING_BALANCE:VARIANCE_AMOUNT:STATUS:AP_NOT_TRANSFERRED_AMOUNT:GL_PERIOD_PAYABLES_ACTIVITY:GL_PERIOD_REVALUATION_ACTIVITY:GL_PERIOD_NON_PAYABLES_ACTIVITY:GL_YTD_PAYABLES_ACTIVITY:GL_YTD_R'
||'EVALUATION_ACTIVITY:GL_YTD_NON_PAYABLES_ACTIVITY'
,p_sort_column_1=>'VARIANCE_AMOUNT'
,p_sort_direction_1=>'DESC'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(317992543199415948)
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
 p_id=>wwv_flow_imp.id(984078933012277682)
,p_plug_name=>'Reconciliation Context'
,p_static_id=>'recon-context'
,p_title=>'GL/AP Reconciliation Context'
,p_region_name=>'recon-context'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>'<p>Reconcile the selected local AP snapshot to TMS GL liability balances as of the same date.</p>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(984078933012277686)
,p_plug_name=>'Reconciliation Detail Context'
,p_static_id=>'recon-detail-context'
,p_title=>'Selected Liability Account'
,p_region_name=>'recon-detail-context'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>50
,p_location=>null
,p_plug_source=>'<div id="p24-detail-selection" class="p24-detail-banner"></div>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(984078933012277687)
,p_plug_name=>'Reconciliation Invoice Detail'
,p_static_id=>'recon-invoice-detail'
,p_title=>'AP Snapshot Invoices for Liability Account'
,p_region_name=>'recon-invoice-detail'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>60
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select invoice_num, invoice_date, supplier_name, supplier_number, min_due_date, max_due_date,',
'       invoice_amount, acct_invoice_amount, open_accounted_amount, invoice_id',
'  from xx_ap_trial_balance_snap',
' where :P24_REPORT_READY = ''Y''',
'   and db_link = :P24_DB_LINK and as_of_date = to_date(:P24_AS_OF_DATE,''YYYY-MM-DD'')',
'   and ledger_id = to_number(:P24_LEDGER_ID) and company_segment = :P24_COMPANY',
'   and gl_liab_ccid = to_number(:P24_SELECTED_CCID)'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P24_REPORT_READY,P24_DB_LINK,P24_AS_OF_DATE,P24_LEDGER_ID,P24_COMPANY,P24_SELECTED_CCID'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'AP Snapshot Invoice Detail'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(984078933012277731)
,p_no_data_found_message=>'No AP snapshot invoices were found for this liability account.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>true
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_internal_uid=>897156623912685650
,p_ai_report_hint=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Invoice-detail rows from the selected local AP snapshot for the GL liability account chosen in the reconciliation report.',
'OPEN_ACCOUNTED_AMOUNT is the remaining balance in ledger functional currency. INVOICE_AMOUNT is the original entered-currency value and ACCT_INVOICE_AMOUNT is the original ledger-currency value; do not describe original amounts as outstanding.',
'The full account is intentionally shown in the parent reconciliation region rather than repeated in this detail report. Prefer invoice and supplier business identifiers over hidden technical IDs.'))
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277808)
,p_db_column_name=>'ACCT_INVOICE_AMOUNT'
,p_display_order=>80
,p_column_identifier=>'H'
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
 p_id=>wwv_flow_imp.id(984078933012277807)
,p_db_column_name=>'INVOICE_AMOUNT'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Original Invoice Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Original invoice value in invoice currency, including any portion subsequently paid. It is not the remaining open balance.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277802)
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
,p_ai_column_hint=>'Date printed on the supplier invoice; this is not a due date or snapshot date.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277811)
,p_db_column_name=>'INVOICE_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Invoice ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical AP invoice identifier. Prefer INVOICE_NUM in business-facing output.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277801)
,p_db_column_name=>'INVOICE_NUM'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Invoice Number'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Supplier invoice number. Treat as text for exact or contains searches.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277806)
,p_db_column_name=>'MAX_DUE_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
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
 p_id=>wwv_flow_imp.id(984078933012277805)
,p_db_column_name=>'MIN_DUE_DATE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Earliest Due Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Earliest scheduled payment due date represented by this invoice.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277809)
,p_db_column_name=>'OPEN_ACCOUNTED_AMOUNT'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Open Accounted Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Remaining open AP balance at the snapshot date in ledger functional currency, credit-positive.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277803)
,p_db_column_name=>'SUPPLIER_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Supplier Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Supplier business name. Use contains-style searching and group by this value for supplier comparisons.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(984078933012277804)
,p_db_column_name=>'SUPPLIER_NUMBER'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Supplier Number'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Supplier account number. Use exact matching and do not confuse it with supplier name.'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(984078933012277732)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'INVOICE_NUM:INVOICE_DATE:SUPPLIER_NAME:SUPPLIER_NUMBER:MIN_DUE_DATE:MAX_DUE_DATE:INVOICE_AMOUNT:ACCT_INVOICE_AMOUNT:OPEN_ACCOUNTED_AMOUNT'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(984078933012277684)
,p_plug_name=>'Reconciliation KPIs'
,p_static_id=>'recon-kpis'
,p_title=>'Reconciliation Summary'
,p_region_name=>'recon-kpis'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>30
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="p24-kpis">',
'<div class="p24-kpi"><div class="p24-kpi-label">Liability Accounts</div><div id="p24-kpi-accounts" class="p24-kpi-value"></div></div>',
'<div class="p24-kpi"><div class="p24-kpi-label">AP Open Balance</div><div id="p24-kpi-ap" class="p24-kpi-value"></div></div>',
'<div class="p24-kpi"><div class="p24-kpi-label">GL Closing Balance</div><div id="p24-kpi-gl" class="p24-kpi-value"></div></div>',
'<div class="p24-kpi"><div class="p24-kpi-label">Net Variance</div><div id="p24-kpi-variance" class="p24-kpi-value"></div></div>',
'<div class="p24-kpi"><div class="p24-kpi-label">Accounts With Variance</div><div id="p24-kpi-out" class="p24-kpi-value"></div></div>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(984078933012277683)
,p_plug_name=>'Reconciliation Status'
,p_static_id=>'recon-status'
,p_title=>'Reconciliation Status'
,p_region_name=>'recon-status'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>20
,p_location=>null
,p_plug_source=>'<div id="p24-status-panel" class="p24-status p24-status--info" role="status" aria-live="polite" hidden><h3 id="p24-status-title"></h3><p id="p24-status-body"></p><div id="p24-status-timing"></div></div>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(984078933012277884)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(984078933012277682)
,p_button_name=>'ANALYZE_RECON_WITH_AI'
,p_static_id=>'analyze-reconciliation-with-ai'
,p_button_static_id=>'analyze-reconciliation-with-ai'
,p_show_as_disabled=>false
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Analyze Reconciliation with AI'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-sparkles'
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(984078933012277882)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(984078933012277682)
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
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(984078933012277883)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(984078933012277686)
,p_button_name=>'CLOSE_DETAIL'
,p_static_id=>'close-recon-detail'
,p_button_static_id=>'close-recon-detail'
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
 p_id=>wwv_flow_imp.id(984078933012277881)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(984078933012277682)
,p_button_name=>'RUN_RECON'
,p_static_id=>'run-gl-ap-recon'
,p_button_static_id=>'run-gl-ap-recon'
,p_show_as_disabled=>false
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Run GL/AP Reconciliation'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-play'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(984078933012277982)
,p_name=>'P24_AS_OF_DATE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(984078933012277682)
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
 p_id=>wwv_flow_imp.id(984078933012277989)
,p_name=>'P24_BACK_URL'
,p_item_sequence=>130
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(984078933012277984)
,p_name=>'P24_COMPANY'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(984078933012277682)
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
 p_id=>wwv_flow_imp.id(984078933012277986)
,p_name=>'P24_CONTEXT_READY'
,p_item_sequence=>100
,p_item_default=>'N'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(984078933012277981)
,p_name=>'P24_DB_LINK'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(984078933012277682)
,p_item_default=>'ADG'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(984078933012277985)
,p_name=>'P24_GENERATED_ON'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(984078933012277682)
,p_prompt=>'Snapshot Generated On'
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
 p_id=>wwv_flow_imp.id(984078933012277983)
,p_name=>'P24_LEDGER_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(984078933012277682)
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1017112567199391948)
,p_name=>'P24_LEDGER_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(984078933012277682)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select case to_char(:P24_LEDGER_ID)',
'         when ''1003'' then ''TEREX US''',
'         when ''5001'' then ''TEREX UK 120''',
'         when ''10001'' then ''TEREX CH''',
'         else ''Unknown Ledger''',
'       end from dual'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Ledger'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'N',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(984078933012277987)
,p_name=>'P24_REPORT_READY'
,p_item_sequence=>110
,p_item_default=>'N'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(984078933012277988)
,p_name=>'P24_SELECTED_CCID'
,p_item_sequence=>120
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(984078933012278087)
,p_name=>'Analyze Reconciliation with AI'
,p_static_id=>'analyze-reconciliation-with-ai'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(984078933012277884)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(984078933012278088)
,p_event_id=>wwv_flow_imp.id(984078933012278087)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p24Controller.openAi();')).to_clob
,p_build_option_id=>wwv_flow_imp.id(1017112543199391948)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(984078933012278085)
,p_name=>'Close Detail'
,p_static_id=>'close-detail'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(984078933012277883)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(984078933012278086)
,p_event_id=>wwv_flow_imp.id(984078933012278085)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p24Controller.closeDetail();')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(984078933012278083)
,p_name=>'Close Page'
,p_static_id=>'close-page'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(984078933012277882)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(984078933012278084)
,p_event_id=>wwv_flow_imp.id(984078933012278083)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p24Controller.closePage();')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(984078933012278081)
,p_name=>'Run Reconciliation'
,p_static_id=>'run-reconciliation'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(984078933012277881)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(984078933012278082)
,p_event_id=>wwv_flow_imp.id(984078933012278081)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p24Controller.run();')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(984078933012278183)
,p_process_sequence=>30
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'P24_GET_AI_URL'
,p_static_id=>'p24-get-ai-url'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare l_date date; l_count number; l_url varchar2(32767);',
'begin',
'  if :P24_REPORT_READY <> ''Y'' or :P24_DB_LINK not in (''ADG'')',
'     or not regexp_like(:P24_AS_OF_DATE,''^[0-9]{4}-[0-9]{2}-[0-9]{2}$'',''c'')',
'     or not regexp_like(:P24_LEDGER_ID,''^[0-9]{1,18}$'',''c'')',
'     or not regexp_like(:P24_COMPANY,''^[A-Z0-9_.-]{1,25}$'',''c'') then raise_application_error(-20251,''Run reconciliation before opening the AI Analyst.''); end if;',
'  select count(*) into l_count from apex_collections where collection_name=''P24_GL_AP_RECON'';',
'  if l_count=0 then raise_application_error(-20252,''No reconciliation results are available for AI analysis.''); end if;',
'  l_date:=to_date(:P24_AS_OF_DATE,''FXYYYY-MM-DD'');',
'  l_url:=apex_page.get_url(p_page=>50,p_clear_cache=>''50'',',
'    p_items=>''P50_DB_LINK,P50_PERIOD_NAME,P50_AP_SCOPE_AS_OF_DATE,P50_AP_LEDGER_ID,P50_AP_COMPANY,P50_AP_SOURCE_PAGE,P50_AP_RECON_READY'',',
'    p_values=>:P24_DB_LINK||'',''||upper(to_char(l_date,''MON-YYYY'',''NLS_DATE_LANGUAGE=English''))||'',''||:P24_AS_OF_DATE||'',''||:P24_LEDGER_ID||'',''||:P24_COMPANY||'',24,Y'');',
'  apex_json.open_object; apex_json.write(''ok'',true); apex_json.write(''url'',l_url); apex_json.close_object;',
'exception when others then apex_json.open_object; apex_json.write(''ok'',false); apex_json.write(''message'',case when sqlcode between -20999 and -20000 then substr(sqlerrm,12) else ''Unable to prepare the AI Analyst URL.'' end); apex_json.close_object;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
,p_internal_uid=>897156623912686002
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(984078933012278182)
,p_process_sequence=>20
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'P24_RUN_RECON'
,p_static_id=>'p24-run-recon'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_count number:=0; l_out number:=0; l_ap number:=0; l_gl number:=0; l_var number:=0;',
'begin',
'  if apex_collection.collection_exists(''P24_GL_AP_RECON'') then apex_collection.truncate_collection(''P24_GL_AP_RECON''); else apex_collection.create_collection(''P24_GL_AP_RECON''); end if;',
'  for r in (select * from table(xx_ap_trial_balance_pkg.get_ap_gl_reconciliation(',
'    to_number(:P24_LEDGER_ID),to_date(:P24_AS_OF_DATE,''YYYY-MM-DD''),:P24_COMPANY,:P24_DB_LINK,to_date(:P24_AS_OF_DATE,''YYYY-MM-DD'')))) loop',
'    apex_collection.add_member(p_collection_name=>''P24_GL_AP_RECON'',',
'      p_c001=>r.gl_liability_code,p_c002=>r.gl_period_name,p_c003=>r.gl_currency_code,',
'      p_c004=>to_char(r.gl_period_payables_activity,''TM9'',''NLS_NUMERIC_CHARACTERS=''''.,''''''),',
'      p_c005=>to_char(r.gl_period_revaluation_activity,''TM9'',''NLS_NUMERIC_CHARACTERS=''''.,''''''),',
'      p_c006=>to_char(r.gl_period_non_payables_activity,''TM9'',''NLS_NUMERIC_CHARACTERS=''''.,''''''),',
'      p_c007=>to_char(r.gl_ytd_payables_activity,''TM9'',''NLS_NUMERIC_CHARACTERS=''''.,''''''),',
'      p_c008=>to_char(r.gl_ytd_revaluation_activity,''TM9'',''NLS_NUMERIC_CHARACTERS=''''.,''''''),',
'      p_c009=>to_char(r.gl_ytd_non_payables_activity,''TM9'',''NLS_NUMERIC_CHARACTERS=''''.,''''''),',
'      p_n001=>r.gl_liab_ccid,p_n002=>r.ap_open_accounted_amount,p_n003=>r.gl_closing_balance,',
'      p_n004=>r.variance_amount,p_n005=>r.ap_not_transferred_amount);',
'    l_count:=l_count+1; l_ap:=l_ap+nvl(r.ap_open_accounted_amount,0); l_gl:=l_gl+nvl(r.gl_closing_balance,0); l_var:=l_var+nvl(r.variance_amount,0);',
'    if abs(nvl(r.variance_amount,0))>=0.01 then l_out:=l_out+1; end if;',
'  end loop;',
'  apex_json.open_object; apex_json.write(''ok'',true); apex_json.open_object(''summary'');',
'  apex_json.write(''account_count'',to_char(l_count,''FM999G999G990'')); apex_json.write(''out_of_balance'',to_char(l_out,''FM999G999G990''));',
'  apex_json.write(''ap_total'',to_char(l_ap,''FM999G999G999G990D00'')); apex_json.write(''gl_total'',to_char(l_gl,''FM999G999G999G990D00''));',
'  apex_json.write(''variance_total'',to_char(l_var,''FM999G999G999G990D00'')); apex_json.close_object; apex_json.close_object;',
'exception when others then',
'  if apex_collection.collection_exists(''P24_GL_AP_RECON'') then apex_collection.delete_collection(''P24_GL_AP_RECON''); end if;',
'  apex_json.open_object; apex_json.write(''ok'',false); apex_json.write(''message'',case when sqlcode between -20999 and -20000 then substr(sqlerrm,12) else ''Unable to run GL/AP reconciliation. Check the APEX debug log.'' end); apex_json.close_object;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>897156623912686001
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(984078933012278181)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Validate Reconciliation Context'
,p_static_id=>'validate-reconciliation-context'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare l_date date; l_count number; l_loaded_on timestamp;',
'begin',
'  :P24_BACK_URL:=apex_page.get_url(p_page=>22,p_clear_cache=>''22'');',
'  :P24_CONTEXT_READY:=''N''; :P24_REPORT_READY:=''N''; :P24_GENERATED_ON:=null;',
'  if apex_collection.collection_exists(''P24_GL_AP_RECON'') then apex_collection.delete_collection(''P24_GL_AP_RECON''); end if;',
'  :P24_DB_LINK:=upper(trim(:P24_DB_LINK)); :P24_COMPANY:=upper(trim(:P24_COMPANY));',
'  if :P24_DB_LINK not in (''ADG'')',
'     or not regexp_like(:P24_AS_OF_DATE,''^[0-9]{4}-[0-9]{2}-[0-9]{2}$'',''c'')',
'     or not regexp_like(:P24_LEDGER_ID,''^[0-9]{1,18}$'',''c'')',
'     or :P24_COMPANY is null or not regexp_like(:P24_COMPANY,''^[A-Z0-9_.-]{1,25}$'',''c'') then',
'    apex_error.add_error(p_message=>''Select a valid snapshot on Page 22 before opening reconciliation.'',p_display_location=>apex_error.c_inline_in_notification); return;',
'  end if;',
'  begin l_date:=to_date(:P24_AS_OF_DATE,''FXYYYY-MM-DD''); exception when others then apex_error.add_error(p_message=>''Select a valid snapshot date.'',p_display_location=>apex_error.c_inline_in_notification); return; end;',
'  select count(*),max(loaded_on) into l_count,l_loaded_on from xx_ap_trial_balance_snap',
'   where db_link=:P24_DB_LINK and as_of_date=l_date and ledger_id=to_number(:P24_LEDGER_ID) and company_segment=:P24_COMPANY;',
'  if l_count>0 then :P24_CONTEXT_READY:=''Y''; :P24_GENERATED_ON:=to_char(l_loaded_on,''DD-MON-YYYY HH24:MI:SS'');',
'  else apex_error.add_error(p_message=>''No snapshot is available for this combination. Return to Page 22 to generate it.'',p_display_location=>apex_error.c_inline_in_notification); end if;',
'exception when others then :P24_CONTEXT_READY:=''N''; apex_error.add_error(p_message=>''Unable to validate the snapshot context. Check the APEX debug log.'',p_display_location=>apex_error.c_inline_in_notification);',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>897156623912686000
);
end;
/
prompt --application/pages/delete_00033
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>33);
end;
/
prompt --application/pages/page_00033
begin
wwv_flow_imp_page.create_page(
 p_id=>33
,p_name=>'AR Aging Analysis'
,p_alias=>'AR-AGING-ANALYSIS'
,p_step_title=>'AR Aging Analysis'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var p33Controller=(function($){',
'  ''use strict'';',
'  function byId(id){return $(''#''+id);}',
'  function region(id){try{return apex.region(id);}catch(ignore){return null;}}',
'  function drill(customerId,bucketSequence,bucketLabel,customerName,customerNumber){',
'    apex.item(''P33_SELECTED_CUSTOMER_ID'').setValue(customerId?String(customerId):'''',null,true);',
'    apex.item(''P33_SELECTED_BUCKET_SEQUENCE'').setValue(bucketSequence?String(bucketSequence):'''',null,true);',
'    var customer=customerName?(customerName+(customerNumber?'' (''+customerNumber+'')'':'''')):''All customers'';',
'    var bucket=bucketLabel||(bucketSequence?apex.item(''P33_BUCKET_''+bucketSequence+''_LABEL'').getValue():''All aging buckets'');',
unistr('    byId(''p33-detail-selection'').text(customer+'' \2022 ''+bucket);'),
'    byId(''customer-detail-context'').show();byId(''customer-aging-detail'').show();',
'    var r=region(''customer-aging-detail'');if(r&&typeof r.refresh===''function''){r.refresh();}else{byId(''customer-aging-detail'').trigger(''apexrefresh'');}',
'    $(''html, body'').animate({scrollTop:byId(''customer-detail-context'').offset().top-12},200);',
'  }',
'  function closeDetail(){apex.item(''P33_SELECTED_CUSTOMER_ID'').setValue('''',null,true);apex.item(''P33_SELECTED_BUCKET_SEQUENCE'').setValue('''',null,true);byId(''customer-detail-context'').hide();byId(''customer-aging-detail'').hide();}',
'  function openAi(){if(apex.item(''P33_SNAPSHOT_READY'').getValue()!==''Y'')return;var target=''ar_aging_ai_''+Date.now(),child=window.open('''',target);if(!child){apex.message.showErrors([{type:''error'',location:''page'',message:''Allow pop-ups to open the AI A'
||'nalyst in a new tab.'',unsafe:false}]);return;}child.document.write(''<title>Opening AI Analyst</title><p style="font-family:sans-serif;padding:1rem">Opening AI Analyst...</p>'');apex.server.process(''P33_GET_AI_URL'',{pageItems:''#P33_SNAPSHOT_READY,#P33_'
||'DB_LINK,#P33_PERIOD_NAME,#P33_LEDGER_ID,#P33_COMPANY,#P33_AGING_BUCKET_ID''},{dataType:''json''}).then(function(result){if(!result||result.ok!==true||!result.url){child.close();apex.message.showErrors([{type:''error'',location:''page'',message:(result&&resu'
||'lt.message)||''Unable to open the AI Analyst.'',unsafe:false}]);return;}child.location.replace(result.url);},function(error){child.close();apex.message.showErrors([{type:''error'',location:''page'',message:(error&&error.message)||''Unable to open the AI Ana'
||'lyst.'',unsafe:false}]);});}',
'  function closePage(){window.close();setTimeout(function(){if(!window.closed){apex.navigation.redirect(apex.item(''P33_BACK_URL'').getValue());}},250);}',
'  $(function(){closeDetail();$(document).on(''click.p33'',''.p33-aging-drill'',function(){drill(null,$(this).attr(''data-seq''),$(this).attr(''data-label''));});});',
'  return{drill:drill,closeDetail:closeDetail,openAi:openAi,closePage:closePage};',
'})(apex.jQuery);'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#customer-detail-context,#customer-aging-detail{display:none;}',
'.p33-context-note{margin:.25rem 0 0;color:var(--ut-component-text-muted-color,#5f6368);}',
'.p33-kpis{display:grid;grid-template-columns:repeat(5,minmax(0,1fr));gap:1rem;padding:.25rem;}',
'.p33-kpi{border:1px solid var(--ut-component-border-color,#d9dce1);border-radius:.5rem;padding:1rem;background:var(--ut-component-background-color,#fff);}',
'.p33-kpi-label{font-size:.76rem;text-transform:uppercase;letter-spacing:.04em;color:#5f6368;}',
'.p33-kpi-value{font-size:1.42rem;font-weight:700;font-variant-numeric:tabular-nums;margin-top:.3rem;}',
'.p33-kpi--alert{border-left:4px solid #b91c1c;background:#fef2f2;}',
'.p33-aging-row{display:grid;grid-template-columns:12rem 1fr 11rem;gap:.75rem;align-items:center;min-width:38rem;}',
'.p33-aging-track{height:1.1rem;background:#eef0f3;border-radius:.25rem;overflow:hidden;}',
'.p33-aging-bar{display:block;height:100%;min-width:2px;background:#2563eb;border-radius:.25rem;}',
'.p33-aging-amount{text-align:right;font-variant-numeric:tabular-nums;font-weight:600;}',
'.p33-aging-drill{display:block;width:100%;border:0;background:transparent;padding:.45rem .25rem;cursor:pointer;text-align:inherit;border-radius:.3rem;}',
'.p33-aging-drill:hover,.p33-aging-drill:focus{background:#eff6ff;outline:2px solid transparent;}',
'.p33-detail-banner{display:flex;align-items:center;justify-content:space-between;gap:1rem;padding:.35rem 0;}',
'#p33-detail-selection{font-weight:600;}',
'.p33-control-exception{display:inline-block;padding:.15rem .45rem;border-radius:1rem;background:#fee2e2;color:#991b1b;font-weight:700;}',
'.p33-control-ok{display:inline-block;padding:.15rem .45rem;border-radius:1rem;background:#dcfce7;color:#166534;}',
'@media(max-width:1000px){.p33-kpis{grid-template-columns:repeat(2,minmax(0,1fr));}}'))
,p_step_template=>4075783602716660119
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(9156329399484443)
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(992705178578421778)
,p_plug_name=>'Snapshot Context'
,p_static_id=>'ar-aging-context'
,p_title=>'Snapshot Context'
,p_region_name=>'ar-aging-context'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>'<p class="p33-context-note">All summaries use Accounted Open Balance in ledger functional currency. Entered-currency balances are shown only in transaction detail and are never totaled across currencies.</p>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(992705178578421780)
,p_name=>'Aging Distribution'
,p_static_id=>'ar-aging-distribution'
,p_title=>'Aging Distribution'
,p_template=>4075786578761660127
,p_display_sequence=>30
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--noBorders'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'with a as (',
' select bucket_sequence,bucket_heading,sum(nvl(accounted_balance_asof,0)) amount',
' from xxme_ar_recon_v2_snap',
' where :P33_SNAPSHOT_READY=''Y'' and db_link_name=:P33_DB_LINK and ledger_id=to_number(:P33_LEDGER_ID)',
'   and company_segment=:P33_COMPANY and period_name=:P33_PERIOD_NAME and aging_bucket_id=to_number(:P33_AGING_BUCKET_ID)',
' group by bucket_sequence,bucket_heading',
'), b as (select a.*,max(abs(amount)) over() max_amount from a)',
'select ''<button type="button" class="p33-aging-drill" data-seq="''||bucket_sequence||''" data-label="''||apex_escape.html_attribute(bucket_heading)||''"><span class="p33-aging-row"><span>''||apex_escape.html(bucket_heading)||''</span>''||',
' ''<span class="p33-aging-track"><span class="p33-aging-bar" style="width:''||to_char(case when max_amount=0 then 0 else round(abs(amount)/max_amount*100,2) end,''FM990D00'',''NLS_NUMERIC_CHARACTERS=''''.,'''''')||''%"></span></span>''||',
' ''<span class="p33-aging-amount">''||to_char(amount,''FM999G999G999G990D00'')||''</span></span></button>'' aging_bar',
' from b order by bucket_sequence'))
,p_display_when_condition=>'P33_SNAPSHOT_READY'
,p_display_when_cond2=>'Y'
,p_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P33_SNAPSHOT_READY,P33_DB_LINK,P33_LEDGER_ID,P33_COMPANY,P33_PERIOD_NAME,P33_AGING_BUCKET_ID'
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
 p_id=>wwv_flow_imp.id(992705178578421798)
,p_query_column_id=>1
,p_column_alias=>'AGING_BAR'
,p_column_display_sequence=>10
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(992705178578421779)
,p_name=>'Snapshot KPIs'
,p_static_id=>'ar-aging-kpis'
,p_title=>'Snapshot Summary'
,p_template=>4075786578761660127
,p_display_sequence=>20
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#:t-Report--noBorders'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'with k as (',
'  select count(distinct customer_id) customer_count, count(*) open_item_count,',
'         nvl(sum(accounted_balance_asof),0) open_amount,',
'         nvl(sum(case when days_past_due > 0 then accounted_balance_asof else 0 end),0) past_due_amount,',
'         nvl(sum(case when control_account_flag = ''N'' then accounted_balance_asof else 0 end),0) exception_amount',
'    from xxme_ar_recon_v2_snap',
'   where :P33_SNAPSHOT_READY = ''Y'' and db_link_name=:P33_DB_LINK and ledger_id=to_number(:P33_LEDGER_ID)',
'     and company_segment=:P33_COMPANY and period_name=:P33_PERIOD_NAME and aging_bucket_id=to_number(:P33_AGING_BUCKET_ID)',
')',
'select ''<div class="p33-kpis">''||',
' ''<div class="p33-kpi"><div class="p33-kpi-label">Customers</div><div class="p33-kpi-value">''||to_char(customer_count,''FM999G999G990'')||''</div></div>''||',
' ''<div class="p33-kpi"><div class="p33-kpi-label">Open Items</div><div class="p33-kpi-value">''||to_char(open_item_count,''FM999G999G990'')||''</div></div>''||',
' ''<div class="p33-kpi"><div class="p33-kpi-label">AR Open Accounted</div><div class="p33-kpi-value">''||to_char(open_amount,''FM999G999G999G990D00'')||''</div></div>''||',
' ''<div class="p33-kpi"><div class="p33-kpi-label">Past Due Accounted</div><div class="p33-kpi-value">''||to_char(past_due_amount,''FM999G999G999G990D00'')||''</div></div>''||',
' ''<div class="p33-kpi p33-kpi--alert"><div class="p33-kpi-label">Outside Control Accounts</div><div class="p33-kpi-value">''||to_char(exception_amount,''FM999G999G999G990D00'')||''</div></div></div>'' kpi_html from k'))
,p_display_when_condition=>'P33_SNAPSHOT_READY'
,p_display_when_cond2=>'Y'
,p_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P33_SNAPSHOT_READY,P33_DB_LINK,P33_LEDGER_ID,P33_COMPANY,P33_PERIOD_NAME,P33_AGING_BUCKET_ID'
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
 p_id=>wwv_flow_imp.id(992705178578421797)
,p_query_column_id=>1
,p_column_alias=>'KPI_HTML'
,p_column_display_sequence=>10
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(992705178578421783)
,p_plug_name=>'Customer Aging Detail'
,p_static_id=>'customer-aging-detail'
,p_title=>'Customer Aging Detail'
,p_region_name=>'customer-aging-detail'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>60
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select class_code,trx_number,trx_date,due_date,days_past_due,bucket_heading,currency_code,',
' entered_balance_asof,accounted_balance_asof,account_segments,',
' case control_account_flag when ''Y'' then ''<span class="p33-control-ok">Control Account</span>'' else ''<span class="p33-control-exception">Outside Control Account</span>'' end control_account_status,',
' customer_number,customer_name,payment_schedule_id,customer_trx_id,receivable_ccid,org_id,bucket_sequence,control_account_flag',
' from table(xxme_ar_recon_v2_pkg.get_aging_detail(',
'   :P33_DB_LINK,to_number(:P33_LEDGER_ID),:P33_COMPANY,:P33_PERIOD_NAME,to_number(:P33_AGING_BUCKET_ID),',
'   case when :P33_SELECTED_CUSTOMER_ID is null then null else to_number(:P33_SELECTED_CUSTOMER_ID) end,',
'   case when :P33_SELECTED_BUCKET_SEQUENCE is null then null else to_number(:P33_SELECTED_BUCKET_SEQUENCE) end,null))',
' where :P33_SNAPSHOT_READY=''Y'''))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P33_SNAPSHOT_READY,P33_DB_LINK,P33_LEDGER_ID,P33_COMPANY,P33_PERIOD_NAME,P33_AGING_BUCKET_ID,P33_SELECTED_CUSTOMER_ID,P33_SELECTED_BUCKET_SEQUENCE'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P33_SNAPSHOT_READY'
,p_plug_display_when_cond2=>'Y'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>14
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Customer Aging Detail'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(992705178578422827)
,p_no_data_found_message=>'No open items match the selected customer and aging bucket.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>true
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_internal_uid=>933160000000686655
,p_ai_report_hint=>'Transaction-level AR aging drilldown for the customer and/or bucket selected on Page 33. ACCOUNTED_BALANCE_ASOF is ledger-functional. ENTERED_BALANCE_ASOF is transaction-currency and must remain grouped by CURRENCY_CODE. Prefer customer and transacti'
||'on business identifiers over hidden IDs.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578422030)
,p_db_column_name=>'ACCOUNTED_BALANCE_ASOF'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Accounted Open Balance'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Remaining open balance in ledger functional currency. Use this measure for totals, customer aging, and GL reconciliation.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578422031)
,p_db_column_name=>'ACCOUNT_SEGMENTS'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Receivable Account'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Full concatenated receivable account combination. Prefer this business-facing value over RECEIVABLE_CCID.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578422027)
,p_db_column_name=>'BUCKET_HEADING'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Aging Bucket'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Configured TMS aging bucket heading as of the snapshot date.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578422039)
,p_db_column_name=>'BUCKET_SEQUENCE'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Bucket Sequence'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden configured aging bucket sequence used for drilldown.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578422022)
,p_db_column_name=>'CLASS_CODE'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Transaction Class'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Receivables transaction class, such as invoice, debit memo, chargeback, or credit memo.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578422040)
,p_db_column_name=>'CONTROL_ACCOUNT_FLAG'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Control Flag'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical Y/N control-account indicator.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578422032)
,p_db_column_name=>'CONTROL_ACCOUNT_STATUS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Control Account Status'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Shows whether the receivable account natural account is in the finance-approved control-account configuration.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578422028)
,p_db_column_name=>'CURRENCY_CODE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Transaction Currency'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Transaction currency for ENTERED_BALANCE_ASOF. Never total entered balances across different currency codes.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578422034)
,p_db_column_name=>'CUSTOMER_NAME'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Customer Name'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Customer business name. Use contains-style searching and group by this value for customer comparisons.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578422033)
,p_db_column_name=>'CUSTOMER_NUMBER'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Customer Number'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Customer account number. Use exact matching and pair it with CUSTOMER_NAME in business-facing answers.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578422036)
,p_db_column_name=>'CUSTOMER_TRX_ID'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Customer Transaction ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical Receivables transaction identifier. Prefer transaction number.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578422026)
,p_db_column_name=>'DAYS_PAST_DUE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Days Past Due'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G990'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Calendar days past due as of the snapshot date. Positive values are overdue; zero or negative values are current.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578422025)
,p_db_column_name=>'DUE_DATE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Due Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Scheduled due date used by the configured aging bucket calculation.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578422029)
,p_db_column_name=>'ENTERED_BALANCE_ASOF'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Entered Open Balance'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Remaining open balance in transaction currency. Group by CURRENCY_CODE before totaling.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578422038)
,p_db_column_name=>'ORG_ID'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Organization ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical Receivables organization identifier. It is not the company code.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578422035)
,p_db_column_name=>'PAYMENT_SCHEDULE_ID'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Payment Schedule ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical AR payment schedule identifier.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578422037)
,p_db_column_name=>'RECEIVABLE_CCID'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Receivable CCID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical GL code combination identifier. Prefer the full receivable account combination.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578422024)
,p_db_column_name=>'TRX_DATE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Transaction Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Receivables transaction date. This is not the due date or snapshot date.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578422023)
,p_db_column_name=>'TRX_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Transaction Number'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Receivables transaction number. Treat as text and prefer it over hidden transaction IDs.'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(992705178578422828)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CLASS_CODE:TRX_NUMBER:TRX_DATE:DUE_DATE:DAYS_PAST_DUE:BUCKET_HEADING:CURRENCY_CODE:ENTERED_BALANCE_ASOF:ACCOUNTED_BALANCE_ASOF:ACCOUNT_SEGMENTS:CONTROL_ACCOUNT_STATUS'
,p_sort_column_1=>'DUE_DATE'
,p_sort_direction_1=>'ASC'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(992705178578421781)
,p_plug_name=>'Customer Aging Summary'
,p_static_id=>'customer-aging-summary'
,p_title=>'Customer Aging Summary'
,p_region_name=>'customer-aging-summary'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>40
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select customer_id,max(customer_number) customer_number,max(customer_name) customer_name,',
' sum(case when bucket_sequence=1 then accounted_balance_asof else 0 end) bucket_1_amount,',
' sum(case when bucket_sequence=2 then accounted_balance_asof else 0 end) bucket_2_amount,',
' sum(case when bucket_sequence=3 then accounted_balance_asof else 0 end) bucket_3_amount,',
' sum(case when bucket_sequence=4 then accounted_balance_asof else 0 end) bucket_4_amount,',
' sum(case when bucket_sequence=5 then accounted_balance_asof else 0 end) bucket_5_amount,',
' sum(case when bucket_sequence=6 then accounted_balance_asof else 0 end) bucket_6_amount,',
' sum(case when bucket_sequence=7 then accounted_balance_asof else 0 end) bucket_7_amount,',
' sum(accounted_balance_asof) total_amount,',
' sum(case when control_account_flag=''N'' then accounted_balance_asof else 0 end) control_exception_amount,',
' count(*) schedule_count',
' from xxme_ar_recon_v2_snap',
' where :P33_SNAPSHOT_READY=''Y'' and db_link_name=:P33_DB_LINK and ledger_id=to_number(:P33_LEDGER_ID)',
'   and company_segment=:P33_COMPANY and period_name=:P33_PERIOD_NAME and aging_bucket_id=to_number(:P33_AGING_BUCKET_ID)',
' group by customer_id'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P33_SNAPSHOT_READY,P33_DB_LINK,P33_LEDGER_ID,P33_COMPANY,P33_PERIOD_NAME,P33_AGING_BUCKET_ID'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P33_SNAPSHOT_READY'
,p_plug_display_when_cond2=>'Y'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>14
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Customer Aging Summary'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(992705178578422817)
,p_no_data_found_message=>'No customers are available for the selected snapshot.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>true
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_internal_uid=>933160000000686645
,p_ai_report_hint=>'Customer aging summary for the selected local AR snapshot. Every bucket amount and TOTAL_AMOUNT uses ACCOUNTED_BALANCE_ASOF in ledger functional currency. The seven bucket labels come from the configured TMS aging bucket and may vary by configuration'
||'. CONTROL_EXCEPTION_AMOUNT is the accounted balance outside approved control accounts. Each row represents one customer.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578421980)
,p_db_column_name=>'BUCKET_1_AMOUNT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'&P33_BUCKET_1_LABEL.'
,p_column_link=>'javascript:p33Controller.drill(#CUSTOMER_ID#,''1'','''',''#CUSTOMER_NAME!JS#'',''#CUSTOMER_NUMBER!JS#'');'
,p_column_linktext=>'#BUCKET_1_AMOUNT#'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Accounted open balance for the first configured aging bucket, in ledger functional currency.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578421981)
,p_db_column_name=>'BUCKET_2_AMOUNT'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'&P33_BUCKET_2_LABEL.'
,p_column_link=>'javascript:p33Controller.drill(#CUSTOMER_ID#,''2'','''',''#CUSTOMER_NAME!JS#'',''#CUSTOMER_NUMBER!JS#'');'
,p_column_linktext=>'#BUCKET_2_AMOUNT#'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Accounted open balance for the second configured aging bucket, in ledger functional currency.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578421982)
,p_db_column_name=>'BUCKET_3_AMOUNT'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'&P33_BUCKET_3_LABEL.'
,p_column_link=>'javascript:p33Controller.drill(#CUSTOMER_ID#,''3'','''',''#CUSTOMER_NAME!JS#'',''#CUSTOMER_NUMBER!JS#'');'
,p_column_linktext=>'#BUCKET_3_AMOUNT#'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Accounted open balance for the third configured aging bucket, in ledger functional currency.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578421983)
,p_db_column_name=>'BUCKET_4_AMOUNT'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'&P33_BUCKET_4_LABEL.'
,p_column_link=>'javascript:p33Controller.drill(#CUSTOMER_ID#,''4'','''',''#CUSTOMER_NAME!JS#'',''#CUSTOMER_NUMBER!JS#'');'
,p_column_linktext=>'#BUCKET_4_AMOUNT#'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Accounted open balance for the fourth configured aging bucket, in ledger functional currency.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578421984)
,p_db_column_name=>'BUCKET_5_AMOUNT'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'&P33_BUCKET_5_LABEL.'
,p_column_link=>'javascript:p33Controller.drill(#CUSTOMER_ID#,''5'','''',''#CUSTOMER_NAME!JS#'',''#CUSTOMER_NUMBER!JS#'');'
,p_column_linktext=>'#BUCKET_5_AMOUNT#'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Accounted open balance for the fifth configured aging bucket, in ledger functional currency.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578421985)
,p_db_column_name=>'BUCKET_6_AMOUNT'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'&P33_BUCKET_6_LABEL.'
,p_column_link=>'javascript:p33Controller.drill(#CUSTOMER_ID#,''6'','''',''#CUSTOMER_NAME!JS#'',''#CUSTOMER_NUMBER!JS#'');'
,p_column_linktext=>'#BUCKET_6_AMOUNT#'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Accounted open balance for the sixth configured aging bucket, in ledger functional currency.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578421986)
,p_db_column_name=>'BUCKET_7_AMOUNT'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'&P33_BUCKET_7_LABEL.'
,p_column_link=>'javascript:p33Controller.drill(#CUSTOMER_ID#,''7'','''',''#CUSTOMER_NAME!JS#'',''#CUSTOMER_NUMBER!JS#'');'
,p_column_linktext=>'#BUCKET_7_AMOUNT#'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Accounted open balance for the seventh configured aging bucket, in ledger functional currency.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578421988)
,p_db_column_name=>'CONTROL_EXCEPTION_AMOUNT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Outside Control Accounts'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Accounted open balance posted outside the finance-approved receivable control accounts.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578421977)
,p_db_column_name=>'CUSTOMER_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Customer ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical customer account identifier. Prefer customer name and customer number.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578421978)
,p_db_column_name=>'CUSTOMER_NAME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Customer Name'
,p_column_link=>'javascript:p33Controller.drill(#CUSTOMER_ID#,'''',''All aging buckets'',''#CUSTOMER_NAME!JS#'',''#CUSTOMER_NUMBER!JS#'');'
,p_column_linktext=>'#CUSTOMER_NAME#'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Customer business name. Use contains-style searching and group by this value for customer comparisons.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578421979)
,p_db_column_name=>'CUSTOMER_NUMBER'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Customer Number'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Customer account number. Use exact matching and pair it with CUSTOMER_NAME in business-facing answers.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578421989)
,p_db_column_name=>'SCHEDULE_COUNT'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Open Items'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G990'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Count of open AR payment-schedule rows represented by the customer summary.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(992705178578421987)
,p_db_column_name=>'TOTAL_AMOUNT'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Total Accounted Open'
,p_column_link=>'javascript:p33Controller.drill(#CUSTOMER_ID#,'''',''All aging buckets'',''#CUSTOMER_NAME!JS#'',''#CUSTOMER_NUMBER!JS#'');'
,p_column_linktext=>'#TOTAL_AMOUNT#'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Total accounted open balance for the customer across all configured aging buckets, in ledger functional currency.'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(992705178578422818)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CUSTOMER_NAME:CUSTOMER_NUMBER:BUCKET_1_AMOUNT:BUCKET_2_AMOUNT:BUCKET_3_AMOUNT:BUCKET_4_AMOUNT:BUCKET_5_AMOUNT:BUCKET_6_AMOUNT:BUCKET_7_AMOUNT:TOTAL_AMOUNT:CONTROL_EXCEPTION_AMOUNT:SCHEDULE_COUNT'
,p_sort_column_1=>'TOTAL_AMOUNT'
,p_sort_direction_1=>'DESC'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(992705178578421782)
,p_plug_name=>'Customer Detail Context'
,p_static_id=>'customer-detail-context'
,p_title=>'Selected Customer / Aging Bucket'
,p_region_name=>'customer-detail-context'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>50
,p_location=>null
,p_plug_source=>'<div class="p33-detail-banner"><span id="p33-detail-selection"></span></div>'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P33_SNAPSHOT_READY'
,p_plug_display_when_cond2=>'Y'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(317992543199424948)
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
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(992705178578421879)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(992705178578421778)
,p_button_name=>'ANALYZE_AGING_AI'
,p_static_id=>'analyze-aging-with-ai'
,p_button_static_id=>'analyze-aging-with-ai'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Analyze Aging with AI'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-sparkles'
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(992705178578421878)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(992705178578421782)
,p_button_name=>'CLOSE_DETAIL'
,p_static_id=>'close-detail'
,p_button_static_id=>'close-detail'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Close Detail'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-times'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(992705178578421877)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(992705178578421778)
,p_button_name=>'CLOSE_PAGE'
,p_static_id=>'close-page'
,p_button_static_id=>'close-page'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Close'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-times'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(992705178578422142)
,p_name=>'P33_AGING_BUCKET_ID'
,p_item_sequence=>100
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(992705178578422124)
,p_name=>'P33_AS_OF_DATE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(992705178578421778)
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
 p_id=>wwv_flow_imp.id(992705178578422146)
,p_name=>'P33_BACK_URL'
,p_item_sequence=>104
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(992705178578422147)
,p_name=>'P33_BUCKET_1_LABEL'
,p_item_sequence=>105
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(992705178578422148)
,p_name=>'P33_BUCKET_2_LABEL'
,p_item_sequence=>106
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(992705178578422149)
,p_name=>'P33_BUCKET_3_LABEL'
,p_item_sequence=>107
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(992705178578422150)
,p_name=>'P33_BUCKET_4_LABEL'
,p_item_sequence=>108
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(992705178578422151)
,p_name=>'P33_BUCKET_5_LABEL'
,p_item_sequence=>109
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(992705178578422152)
,p_name=>'P33_BUCKET_6_LABEL'
,p_item_sequence=>110
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(992705178578422153)
,p_name=>'P33_BUCKET_7_LABEL'
,p_item_sequence=>111
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(992705178578422126)
,p_name=>'P33_COMPANY'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(992705178578421778)
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
 p_id=>wwv_flow_imp.id(992705178578422122)
,p_name=>'P33_DB_LINK'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(992705178578421778)
,p_item_default=>'ADG'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(992705178578422128)
,p_name=>'P33_GENERATED_BY'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(992705178578421778)
,p_prompt=>'Generated By'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
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
 p_id=>wwv_flow_imp.id(992705178578422127)
,p_name=>'P33_GENERATED_ON'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(992705178578421778)
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
 p_id=>wwv_flow_imp.id(992705178578422125)
,p_name=>'P33_LEDGER_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(992705178578421778)
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
 p_id=>wwv_flow_imp.id(992705178578422123)
,p_name=>'P33_PERIOD_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(992705178578421778)
,p_prompt=>'Receivables Period'
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
 p_id=>wwv_flow_imp.id(992705178578422129)
,p_name=>'P33_ROW_COUNT'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(992705178578421778)
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
 p_id=>wwv_flow_imp.id(992705178578422145)
,p_name=>'P33_SELECTED_BUCKET_SEQUENCE'
,p_item_sequence=>103
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(992705178578422144)
,p_name=>'P33_SELECTED_CUSTOMER_ID'
,p_item_sequence=>102
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(992705178578422143)
,p_name=>'P33_SNAPSHOT_READY'
,p_item_sequence=>101
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(992705178578422179)
,p_name=>'Close Detail'
,p_static_id=>'close-detail'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(992705178578421878)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(992705178578422180)
,p_event_id=>wwv_flow_imp.id(992705178578422179)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p33Controller.closeDetail();')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(992705178578422177)
,p_name=>'Close Page'
,p_static_id=>'close-page'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(992705178578421877)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(992705178578422178)
,p_event_id=>wwv_flow_imp.id(992705178578422177)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p33Controller.closePage();')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(992705178578422181)
,p_name=>'Open Aging AI Analyst'
,p_static_id=>'open-aging-ai-analyst'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(992705178578421879)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(992705178578422182)
,p_event_id=>wwv_flow_imp.id(992705178578422181)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p33Controller.openAi();')).to_clob
,p_build_option_id=>wwv_flow_imp.id(1017112543199391948)
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(992705178578422278)
,p_process_sequence=>20
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'P33_GET_AI_URL'
,p_static_id=>'p33-get-ai-url'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare l_count number; l_asof date; l_url varchar2(32767);',
'begin',
' if :P33_SNAPSHOT_READY<>''Y'' or :P33_DB_LINK not in (''ADG'') or not regexp_like(:P33_PERIOD_NAME,''^[A-Z0-9 _./-]{1,30}$'') or not regexp_like(:P33_LEDGER_ID,''^[0-9]{1,18}$'') or not regexp_like(:P33_COMPANY,''^[A-Z0-9_.-]{1,25}$'') or not regexp_like(:P33'
||'_AGING_BUCKET_ID,''^[0-9]{1,18}$'') then raise_application_error(-20337,''Invalid AR aging context.''); end if;',
' select count(*),max(as_of_date) into l_count,l_asof from xxme_ar_recon_v2_snap where db_link_name=:P33_DB_LINK and ledger_id=to_number(:P33_LEDGER_ID) and company_segment=:P33_COMPANY and period_name=:P33_PERIOD_NAME and aging_bucket_id=to_number(:P'
||'33_AGING_BUCKET_ID);',
' if l_count=0 then raise_application_error(-20338,''The selected AR snapshot is no longer available.''); end if;',
' l_url:=apex_page.get_url(p_page=>50,p_clear_cache=>''50'',p_items=>''P50_DB_LINK,P50_PERIOD_NAME,P50_AR_SCOPE_AS_OF_DATE,P50_AR_LEDGER_ID,P50_AR_COMPANY,P50_AR_AGING_BUCKET_ID,P50_AR_SOURCE_PAGE,P50_AR_RECON_READY'',p_values=>:P33_DB_LINK||'',''||:P33_PER'
||'IOD_NAME||'',''||to_char(l_asof,''YYYY-MM-DD'')||'',''||:P33_LEDGER_ID||'',''||:P33_COMPANY||'',''||:P33_AGING_BUCKET_ID||'',33,N'');',
' apex_json.open_object;apex_json.write(''ok'',true);apex_json.write(''url'',l_url);apex_json.close_object;',
'exception when others then apex_json.open_object;apex_json.write(''ok'',false);apex_json.write(''message'',case when sqlcode between -20999 and -20000 then substr(sqlerrm,12) else ''Unable to prepare the AI Analyst URL.'' end);apex_json.close_object;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
,p_internal_uid=>933160000000686106
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(992705178578422277)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Validate AR Snapshot Context'
,p_static_id=>'validate-ar-snapshot-context'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
' l_db varchar2(128):=upper(trim(:P33_DB_LINK)); l_period varchar2(30):=upper(trim(:P33_PERIOD_NAME));',
' l_ledger_text varchar2(30):=trim(:P33_LEDGER_ID); l_company varchar2(25):=upper(trim(:P33_COMPANY)); l_bucket_text varchar2(30):=trim(:P33_AGING_BUCKET_ID);',
' l_ledger number; l_bucket number; l_count number; l_by varchar2(128); l_on timestamp; l_asof date;',
' l_b1 varchar2(120);l_b2 varchar2(120);l_b3 varchar2(120);l_b4 varchar2(120);l_b5 varchar2(120);l_b6 varchar2(120);l_b7 varchar2(120);',
'begin',
' :P33_BACK_URL:=apex_page.get_url(p_page=>32,p_clear_cache=>''32''); :P33_SNAPSHOT_READY:=''N'';',
' if l_db not in (''ADG'') or l_period is null or not regexp_like(l_period,''^[A-Z0-9 _./-]{1,30}$'')',
'    or not regexp_like(l_ledger_text,''^[0-9]{1,18}$'') or l_company is null or not regexp_like(l_company,''^[A-Z0-9_.-]{1,25}$'')',
'    or not regexp_like(l_bucket_text,''^[0-9]{1,18}$'') then',
'   apex_error.add_error(p_message=>''Select an available AR snapshot on Page 32 before opening Aging Analysis.'',p_display_location=>apex_error.c_inline_in_notification); return; end if;',
' l_ledger:=to_number(l_ledger_text);l_bucket:=to_number(l_bucket_text);',
' select count(*),max(loaded_by),max(loaded_at),max(as_of_date),',
'  max(case when bucket_sequence=1 then bucket_heading end),max(case when bucket_sequence=2 then bucket_heading end),max(case when bucket_sequence=3 then bucket_heading end),',
'  max(case when bucket_sequence=4 then bucket_heading end),max(case when bucket_sequence=5 then bucket_heading end),max(case when bucket_sequence=6 then bucket_heading end),max(case when bucket_sequence=7 then bucket_heading end)',
' into l_count,l_by,l_on,l_asof,l_b1,l_b2,l_b3,l_b4,l_b5,l_b6,l_b7',
' from xxme_ar_recon_v2_snap where db_link_name=l_db and ledger_id=l_ledger and company_segment=l_company and period_name=l_period and aging_bucket_id=l_bucket;',
' :P33_DB_LINK:=l_db;:P33_PERIOD_NAME:=l_period;:P33_LEDGER_ID:=to_char(l_ledger);:P33_COMPANY:=l_company;:P33_AGING_BUCKET_ID:=to_char(l_bucket);',
' :P33_AS_OF_DATE:=to_char(l_asof,''DD-MON-YYYY'');:P33_GENERATED_ON:=to_char(l_on,''DD-MON-YYYY HH24:MI:SS'');:P33_GENERATED_BY:=l_by;:P33_ROW_COUNT:=to_char(l_count,''FM999G999G999G990'');',
' :P33_BUCKET_1_LABEL:=nvl(l_b1,''Bucket 1'');:P33_BUCKET_2_LABEL:=nvl(l_b2,''Bucket 2'');:P33_BUCKET_3_LABEL:=nvl(l_b3,''Bucket 3'');:P33_BUCKET_4_LABEL:=nvl(l_b4,''Bucket 4'');',
' :P33_BUCKET_5_LABEL:=nvl(l_b5,''Bucket 5'');:P33_BUCKET_6_LABEL:=nvl(l_b6,''Bucket 6'');:P33_BUCKET_7_LABEL:=nvl(l_b7,''Bucket 7'');',
' if l_count>0 then :P33_SNAPSHOT_READY:=''Y''; else apex_error.add_error(p_message=>''The selected AR snapshot is no longer available. Return to Page 32 and run it again.'',p_display_location=>apex_error.c_inline_in_notification); end if;',
'exception when others then :P33_SNAPSHOT_READY:=''N''; apex_error.add_error(p_message=>''Unable to validate the selected AR snapshot. Check the APEX debug log.'',p_display_location=>apex_error.c_inline_in_notification);',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>933160000000686105
);
end;
/
prompt --application/pages/delete_00034
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>34);
end;
/
prompt --application/pages/page_00034
begin
wwv_flow_imp_page.create_page(
 p_id=>34
,p_name=>'GL AR Reconciliation'
,p_alias=>'GL-AR-RECONCILIATION'
,p_step_title=>'GL/AR Reconciliation'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var p34Controller=(function($){',
' ''use strict'';',
' var busy=false,spinner=null,timerId=null,startedAt=null;',
' function byId(id){return $(''#''+id);}',
' function region(id){try{return apex.region(id);}catch(ignore){return null;}}',
' function seconds(){return ((performance.now()-startedAt)/1000).toFixed(1)+'' s'';}',
' function stop(){if(timerId){clearInterval(timerId);timerId=null;}if(spinner){spinner.remove();spinner=null;}}',
' function setBusy(on){busy=on;byId(''run-gl-ar-recon'').prop(''disabled'',on);}',
' function status(kind,title,body,timing){byId(''recon-status'').show();byId(''p34-status-panel'').removeAttr(''hidden'').removeClass(''p34-status--info p34-status--success p34-status--error'').addClass(''p34-status--''+kind);byId(''p34-status-title'').text(title'
||');byId(''p34-status-body'').text(body||'''');byId(''p34-status-timing'').text(timing||'''');}',
' function refresh(id){var r=region(id);if(r&&typeof r.refresh===''function''){r.refresh();}else{byId(id).trigger(''apexrefresh'');}}',
' function highlight(){byId(''gl-ar-recon-report'').find(''.a-IRR-table tbody tr'').each(function(){$(this).toggleClass(''p34-variance-row'',$(this).find(''.p34-badge--variance'').length>0);});}',
' function closeDetail(){apex.item(''P34_SELECTED_CCID'').setValue('''',null,true);byId(''recon-detail-context'').hide();byId(''recon-customer-detail'').hide();}',
' function hideResults(){apex.item(''P34_REPORT_READY'').setValue(''N'',null,true);byId(''analyze-ar-reconciliation-with-ai'').hide();byId(''recon-kpis'').hide();byId(''gl-ar-recon-report'').hide();closeDetail();}',
' function populateKpis(x){byId(''p34-kpi-accounts'').text(x.account_count);byId(''p34-kpi-ar'').text(x.ar_total);byId(''p34-kpi-gl'').text(x.gl_total);byId(''p34-kpi-variance'').text(x.variance_total);byId(''p34-kpi-out'').text(x.out_of_balance);}',
' function run(){if(busy||apex.item(''P34_CONTEXT_READY'').getValue()!==''Y'')return;hideResults();setBusy(true);startedAt=performance.now();status(''info'',''Running GL/AR reconciliation'',''Retrieving GL balances from TMS. This normally takes approximately 2'
||'0-30 seconds.'',''Elapsed: 0.0 s'');timerId=setInterval(function(){byId(''p34-status-timing'').text(''Elapsed: ''+seconds());},250);try{spinner=apex.util.showSpinner(byId(''recon-status''));}catch(ignore){spinner=null;}apex.server.process(''P34_RUN_RECON'',{pag'
||'eItems:''#P34_DB_LINK,#P34_PERIOD_NAME,#P34_LEDGER_ID,#P34_COMPANY,#P34_AGING_BUCKET_ID''},{dataType:''json''}).then(function(result){stop();setBusy(false);if(!result||result.ok!==true){status(''error'',''Reconciliation failed'',(result&&result.message)||''Un'
||'able to run reconciliation.'');return;}apex.item(''P34_REPORT_READY'').setValue(''Y'',null,true);populateKpis(result.summary);byId(''recon-kpis'').show();byId(''gl-ar-recon-report'').show();byId(''analyze-ar-reconciliation-with-ai'').show();refresh(''gl-ar-recon'
||'-report'');status(''success'',''Reconciliation complete'',result.summary.account_count+'' receivable accounts evaluated.'',''Total: ''+seconds());},function(error){stop();setBusy(false);status(''error'',''Reconciliation failed'',(error&&error.message)||''Unable to'
||' run reconciliation.'');});}',
' function drill(ccid,account){apex.item(''P34_SELECTED_CCID'').setValue(String(ccid),null,true);byId(''p34-detail-selection'').text(account||''Selected receivable account'');byId(''recon-detail-context'').show();byId(''recon-customer-detail'').show();refresh('''
||'recon-customer-detail'');$(''html, body'').animate({scrollTop:byId(''recon-detail-context'').offset().top-12},200);}',
' function openAi(){if(apex.item(''P34_REPORT_READY'').getValue()!==''Y'')return;var target=''ar_recon_ai_''+Date.now(),child=window.open('''',target);if(!child){apex.message.showErrors([{type:''error'',location:''page'',message:''Allow pop-ups to open the AI Anal'
||'yst in a new tab.'',unsafe:false}]);return;}child.document.write(''<title>Opening AI Analyst</title><p style="font-family:sans-serif;padding:1rem">Opening AI Analyst...</p>'');apex.server.process(''P34_GET_AI_URL'',{pageItems:''#P34_REPORT_READY,#P34_DB_LI'
||'NK,#P34_PERIOD_NAME,#P34_LEDGER_ID,#P34_COMPANY,#P34_AGING_BUCKET_ID''},{dataType:''json''}).then(function(result){if(!result||result.ok!==true||!result.url){child.close();apex.message.showErrors([{type:''error'',location:''page'',message:(result&&result.me'
||'ssage)||''Unable to open the AI Analyst.'',unsafe:false}]);return;}child.location.replace(result.url);},function(error){child.close();apex.message.showErrors([{type:''error'',location:''page'',message:(error&&error.message)||''Unable to open the AI Analyst.'
||''',unsafe:false}]);});}',
' function closePage(){window.close();setTimeout(function(){if(!window.closed){apex.navigation.redirect(apex.item(''P34_BACK_URL'').getValue());}},250);}',
' $(function(){hideResults();byId(''recon-status'').hide();byId(''p34-status-panel'').attr(''hidden'',''hidden'');$(document).on(''apexafterrefresh.p34'',''#gl-ar-recon-report'',highlight);});',
' return{run:run,drill:drill,closeDetail:closeDetail,openAi:openAi,closePage:closePage};',
'})(apex.jQuery);'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#analyze-ar-reconciliation-with-ai,#recon-kpis,#gl-ar-recon-report,#recon-detail-context,#recon-customer-detail{display:none;}',
'#recon-status{position:relative;min-height:4rem;}',
'.p34-status{border-left:4px solid #2563eb;border-radius:.25rem;padding:.8rem 1rem;background:#eff6ff;}',
'.p34-status--success{border-left-color:#15803d;background:#f0fdf4;}',
'.p34-status--error{border-left-color:#b91c1c;background:#fef2f2;}',
'#p34-status-title{font-size:1rem;font-weight:700;margin:0 0 .25rem;}#p34-status-body{margin:0;}#p34-status-timing{font-variant-numeric:tabular-nums;font-weight:600;margin-top:.35rem;}',
'.p34-kpis{display:grid;grid-template-columns:repeat(5,minmax(0,1fr));gap:1rem;padding:.25rem;}',
'.p34-kpi{border:1px solid var(--ut-component-border-color,#d9dce1);border-radius:.5rem;padding:1rem;background:var(--ut-component-background-color,#fff);}',
'.p34-kpi-label{font-size:.75rem;text-transform:uppercase;letter-spacing:.04em;color:#5f6368;}.p34-kpi-value{font-size:1.35rem;font-weight:700;font-variant-numeric:tabular-nums;margin-top:.3rem;}',
'.p34-status-badge{display:inline-block;border-radius:999px;padding:.15rem .55rem;font-weight:700;}.p34-badge--balanced{background:#ecfdf3;color:#166534;}.p34-badge--variance{background:#fee2e2;color:#991b1b;}',
'.p34-variance-row>td{background:#fff7ed!important;}.p34-detail-banner{font-weight:600;padding:.35rem 0;}',
'.p34-control-exception{display:inline-block;padding:.15rem .45rem;border-radius:1rem;background:#fee2e2;color:#991b1b;font-weight:700;}.p34-control-ok{display:inline-block;padding:.15rem .45rem;border-radius:1rem;background:#dcfce7;color:#166534;}',
'@media(max-width:900px){.p34-kpis{grid-template-columns:repeat(2,minmax(0,1fr));}}'))
,p_step_template=>4075783602716660119
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(9156329399484443)
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(993705178578421781)
,p_plug_name=>'GL AR Reconciliation Report'
,p_static_id=>'gl-ar-recon-report'
,p_title=>'GL/AR Reconciliation by Receivable Account'
,p_region_name=>'gl-ar-recon-report'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>40
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select n001 receivable_ccid,c001 receivable_account,c002 natural_account,n002 ar_open_accounted_amount,',
' n003 gl_beginning_balance,n004 gl_period_net,',
' to_number(c007,''99999999999999999999999999999999999999D99999999999999999999'',''NLS_NUMERIC_CHARACTERS=''''.,'''''') gl_period_receivables_activity,',
' to_number(c008,''99999999999999999999999999999999999999D99999999999999999999'',''NLS_NUMERIC_CHARACTERS=''''.,'''''') gl_period_revaluation_activity,',
' to_number(c009,''99999999999999999999999999999999999999D99999999999999999999'',''NLS_NUMERIC_CHARACTERS=''''.,'''''') gl_period_non_receivables_activity,',
' n005 gl_ending_balance,',
' to_number(c005,''99999999999999999999999999999999999999D99999999999999999999'',''NLS_NUMERIC_CHARACTERS=''''.,'''''') variance_amount,c003 ar_loaded_at,c004 gl_retrieved_at,',
' to_number(c006,''99999999999999999999999999999999999999D99999999999999999999'',''NLS_NUMERIC_CHARACTERS=''''.,'''''') ar_not_transferred_amount,',
' case when abs(nvl(to_number(c005,''99999999999999999999999999999999999999D99999999999999999999'',''NLS_NUMERIC_CHARACTERS=''''.,''''''),0))<0.01 then ''<span class="p34-status-badge p34-badge--balanced">Balanced</span>'' else ''<span class="p34-status-badge p3'
||'4-badge--variance">Variance</span>'' end status',
' from apex_collections where collection_name=''P34_GL_AR_RECON'' and :P34_REPORT_READY=''Y'''))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P34_REPORT_READY'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>12
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'GL AR Reconciliation'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(993705178578422817)
,p_no_data_found_message=>'No receivable control accounts were returned for this snapshot.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>true
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_internal_uid=>934160000000686645
,p_ai_report_hint=>'AR-driven GL/AR reconciliation for the selected snapshot. Only full account combinations with a non-zero AR open accounted balance are included. GL_PERIOD_NET equals GL_PERIOD_RECEIVABLES_ACTIVITY plus GL_PERIOD_REVALUATION_ACTIVITY plus GL_PERIOD_NO'
||'N_RECEIVABLES_ACTIVITY. GL_ENDING_BALANCE equals GL_BEGINNING_BALANCE plus GL_PERIOD_NET. VARIANCE_AMOUNT equals AR_OPEN_ACCOUNTED_AMOUNT minus GL_ENDING_BALANCE; absolute variance below 0.01 is Balanced. AR_NOT_TRANSFERRED_AMOUNT is cumulative AR su'
||'bledger accounting not yet transferred to GL through the as-of date and is diagnostic only; do not subtract it from variance. Null GL balance is not zero. Rank issues by absolute variance and display the full RECEIVABLE_ACCOUNT rather than CCID.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578421986)
,p_db_column_name=>'AR_LOADED_AT'
,p_display_order=>140
,p_column_identifier=>'J'
,p_column_label=>'AR Snapshot Generated'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Timestamp when the selected local AR snapshot was generated.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578421991)
,p_db_column_name=>'AR_NOT_TRANSFERRED_AMOUNT'
,p_display_order=>130
,p_column_identifier=>'O'
,p_column_label=>'AR Not Transferred'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Cumulative AR subledger accounting with application ID 222 that was not transferred to GL through the snapshot as-of date. Diagnostic timing item only; it is not part of the variance formula.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578421980)
,p_db_column_name=>'AR_OPEN_ACCOUNTED_AMOUNT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'AR Open Accounted'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Open AR snapshot balance for this full account combination in ledger functional currency.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578421981)
,p_db_column_name=>'GL_BEGINNING_BALANCE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'GL Beginning Balance'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'GL beginning balance for this full account combination and period, debit-positive as returned by the package.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578421983)
,p_db_column_name=>'GL_ENDING_BALANCE'
,p_display_order=>90
,p_column_identifier=>'G'
,p_column_label=>'GL Ending Balance'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'GL ending balance for this full account combination and period. Null means no matching GL balance was returned.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578421982)
,p_db_column_name=>'GL_PERIOD_NET'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'GL Period Net'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden validation total. Equals Period Receivables Activity plus Period Revaluation plus Period Non-Receivables, using debit-positive signs.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578421990)
,p_db_column_name=>'GL_PERIOD_NON_RECEIVABLES_ACTIVITY'
,p_display_order=>80
,p_column_identifier=>'N'
,p_column_label=>'Period Non-Receivables'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Posted actual GL activity from all journal sources other than Receivables and Revaluation for this account and selected period, in ledger currency with debit-positive signs.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578421988)
,p_db_column_name=>'GL_PERIOD_RECEIVABLES_ACTIVITY'
,p_display_order=>60
,p_column_identifier=>'L'
,p_column_label=>'Period Receivables Activity'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Posted actual GL activity from journal source Receivables for this account and selected period, in ledger currency with debit-positive signs.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578421989)
,p_db_column_name=>'GL_PERIOD_REVALUATION_ACTIVITY'
,p_display_order=>70
,p_column_identifier=>'M'
,p_column_label=>'Period Revaluation'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Posted actual GL activity from journal source Revaluation for this account and selected period, in ledger currency with debit-positive signs.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578421987)
,p_db_column_name=>'GL_RETRIEVED_AT'
,p_display_order=>150
,p_column_identifier=>'K'
,p_column_label=>'GL Retrieved'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Timestamp when Page 34 retrieved the live GL balance.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578421979)
,p_db_column_name=>'NATURAL_ACCOUNT'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Natural Account'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Natural-account segment of the receivable account combination.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578421978)
,p_db_column_name=>'RECEIVABLE_ACCOUNT'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Receivable Account'
,p_column_link=>'javascript:p34Controller.drill(#RECEIVABLE_CCID#,''#RECEIVABLE_ACCOUNT!JS#'');'
,p_column_linktext=>'#RECEIVABLE_ACCOUNT#'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Full concatenated receivable account combination. This is the business-facing reconciliation key.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578421977)
,p_db_column_name=>'RECEIVABLE_CCID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Receivable CCID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical GL code combination identifier. Prefer the full receivable account combination.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578421985)
,p_db_column_name=>'STATUS'
,p_display_order=>110
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Balanced when absolute variance is below 0.01; otherwise Variance.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578421984)
,p_db_column_name=>'VARIANCE_AMOUNT'
,p_display_order=>100
,p_column_identifier=>'H'
,p_column_label=>'Variance'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'AR_OPEN_ACCOUNTED_AMOUNT minus GL_ENDING_BALANCE. Preserve the signed value and rank issues by absolute variance.'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(993705178578422818)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'RECEIVABLE_ACCOUNT:NATURAL_ACCOUNT:AR_OPEN_ACCOUNTED_AMOUNT:GL_BEGINNING_BALANCE:GL_PERIOD_RECEIVABLES_ACTIVITY:GL_PERIOD_REVALUATION_ACTIVITY:GL_PERIOD_NON_RECEIVABLES_ACTIVITY:GL_ENDING_BALANCE:VARIANCE_AMOUNT:STATUS:AR_NOT_TRANSFERRED_AMOUNT:AR_LO'
||'ADED_AT:GL_RETRIEVED_AT'
,p_sort_column_1=>'VARIANCE_AMOUNT'
,p_sort_direction_1=>'DESC'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(317992543199425948)
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
 p_id=>wwv_flow_imp.id(993705178578421778)
,p_plug_name=>'Reconciliation Context'
,p_static_id=>'recon-context'
,p_title=>'GL/AR Reconciliation Context'
,p_region_name=>'recon-context'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>'<p>Reconcile the selected local AR snapshot to TMS GL receivable control-account balances for the same ledger, company, and period.</p>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(993705178578421783)
,p_plug_name=>'Receivable Account Detail'
,p_static_id=>'recon-customer-detail'
,p_title=>'AR Open Items for Selected Receivable Account'
,p_region_name=>'recon-customer-detail'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>60
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select customer_name,customer_number,class_code,trx_number,trx_date,due_date,days_past_due,bucket_heading,currency_code,entered_balance_asof,accounted_balance_asof,',
' case control_account_flag when ''Y'' then ''<span class="p34-control-ok">Control Account</span>'' else ''<span class="p34-control-exception">Outside Control Account</span>'' end control_account_status,',
' payment_schedule_id,customer_id,customer_trx_id,receivable_ccid,org_id,bucket_sequence,control_account_flag',
' from xxme_ar_recon_v2_snap where :P34_REPORT_READY=''Y'' and db_link_name=:P34_DB_LINK and ledger_id=to_number(:P34_LEDGER_ID) and company_segment=:P34_COMPANY and period_name=:P34_PERIOD_NAME and aging_bucket_id=to_number(:P34_AGING_BUCKET_ID) and re'
||'ceivable_ccid=to_number(:P34_SELECTED_CCID)'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P34_REPORT_READY,P34_DB_LINK,P34_LEDGER_ID,P34_COMPANY,P34_PERIOD_NAME,P34_AGING_BUCKET_ID,P34_SELECTED_CCID'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P34_CONTEXT_READY'
,p_plug_display_when_cond2=>'Y'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>14
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'AR Open Items by Receivable Account'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(993705178578422827)
,p_no_data_found_message=>'No AR open items were found for the selected receivable account.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>true
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_internal_uid=>934160000000686655
,p_ai_report_hint=>'AR transaction detail supporting the full receivable account selected on Page 34. ACCOUNTED_BALANCE_ASOF is ledger-functional and reconciles to the account-level AR amount. ENTERED_BALANCE_ASOF is transaction-currency and must remain grouped by CURRE'
||'NCY_CODE.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422032)
,p_db_column_name=>'ACCOUNTED_BALANCE_ASOF'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Accounted Open Balance'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Remaining open balance in ledger functional currency. Use this measure for totals, customer aging, and GL reconciliation.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422029)
,p_db_column_name=>'BUCKET_HEADING'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Aging Bucket'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Configured TMS aging bucket heading as of the snapshot date.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422039)
,p_db_column_name=>'BUCKET_SEQUENCE'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Bucket Sequence'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden configured aging bucket sequence used for drilldown.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422024)
,p_db_column_name=>'CLASS_CODE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Transaction Class'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Receivables transaction class, such as invoice, debit memo, chargeback, or credit memo.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422040)
,p_db_column_name=>'CONTROL_ACCOUNT_FLAG'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Control Flag'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical Y/N control-account indicator.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422033)
,p_db_column_name=>'CONTROL_ACCOUNT_STATUS'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Control Account Status'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Shows whether the receivable account natural account is in the finance-approved control-account configuration.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422030)
,p_db_column_name=>'CURRENCY_CODE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Transaction Currency'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Transaction currency for ENTERED_BALANCE_ASOF. Never total entered balances across different currency codes.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422035)
,p_db_column_name=>'CUSTOMER_ID'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Customer ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical customer account identifier. Prefer customer name and customer number.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422022)
,p_db_column_name=>'CUSTOMER_NAME'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Customer Name'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Customer business name. Use contains-style searching and group by this value for customer comparisons.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422023)
,p_db_column_name=>'CUSTOMER_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Customer Number'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Customer account number. Use exact matching and pair it with CUSTOMER_NAME in business-facing answers.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422036)
,p_db_column_name=>'CUSTOMER_TRX_ID'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Customer Transaction ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical Receivables transaction identifier. Prefer transaction number.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422028)
,p_db_column_name=>'DAYS_PAST_DUE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Days Past Due'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G990'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Calendar days past due as of the snapshot date. Positive values are overdue; zero or negative values are current.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422027)
,p_db_column_name=>'DUE_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Due Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Scheduled due date used by the configured aging bucket calculation.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422031)
,p_db_column_name=>'ENTERED_BALANCE_ASOF'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Entered Open Balance'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Remaining open balance in transaction currency. Group by CURRENCY_CODE before totaling.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422038)
,p_db_column_name=>'ORG_ID'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Organization ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical Receivables organization identifier. It is not the company code.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422034)
,p_db_column_name=>'PAYMENT_SCHEDULE_ID'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Payment Schedule ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical AR payment schedule identifier.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422037)
,p_db_column_name=>'RECEIVABLE_CCID'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Receivable CCID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Hidden technical GL code combination identifier. Prefer the full receivable account combination.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422026)
,p_db_column_name=>'TRX_DATE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Transaction Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Receivables transaction date. This is not the due date or snapshot date.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(993705178578422025)
,p_db_column_name=>'TRX_NUMBER'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Transaction Number'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_ai_column_hint=>'Receivables transaction number. Treat as text and prefer it over hidden transaction IDs.'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(993705178578422828)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CUSTOMER_NAME:CUSTOMER_NUMBER:CLASS_CODE:TRX_NUMBER:TRX_DATE:DUE_DATE:DAYS_PAST_DUE:BUCKET_HEADING:CURRENCY_CODE:ENTERED_BALANCE_ASOF:ACCOUNTED_BALANCE_ASOF:CONTROL_ACCOUNT_STATUS'
,p_sort_column_1=>'DUE_DATE'
,p_sort_direction_1=>'ASC'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(993705178578421782)
,p_plug_name=>'Reconciliation Detail Context'
,p_static_id=>'recon-detail-context'
,p_title=>'Selected Receivable Account'
,p_region_name=>'recon-detail-context'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>50
,p_location=>null
,p_plug_source=>'<div class="p34-detail-banner"><span id="p34-detail-selection"></span></div>'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P34_CONTEXT_READY'
,p_plug_display_when_cond2=>'Y'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(993705178578421780)
,p_plug_name=>'Reconciliation KPIs'
,p_static_id=>'recon-kpis'
,p_title=>'Reconciliation Summary'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>30
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="p34-kpis">',
'<div class="p34-kpi"><div class="p34-kpi-label">Receivable Accounts</div><div id="p34-kpi-accounts" class="p34-kpi-value"></div></div>',
'<div class="p34-kpi"><div class="p34-kpi-label">AR Open Accounted</div><div id="p34-kpi-ar" class="p34-kpi-value"></div></div>',
'<div class="p34-kpi"><div class="p34-kpi-label">GL Ending Balance</div><div id="p34-kpi-gl" class="p34-kpi-value"></div></div>',
'<div class="p34-kpi"><div class="p34-kpi-label">Net Variance</div><div id="p34-kpi-variance" class="p34-kpi-value"></div></div>',
'<div class="p34-kpi"><div class="p34-kpi-label">Accounts With Variance</div><div id="p34-kpi-out" class="p34-kpi-value"></div></div>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(993705178578421779)
,p_plug_name=>'Reconciliation Status'
,p_static_id=>'recon-status'
,p_title=>'Reconciliation Status'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>20
,p_location=>null
,p_plug_source=>'<div id="p34-status-panel" class="p34-status p34-status--info" role="status" aria-live="polite" hidden><h3 id="p34-status-title"></h3><p id="p34-status-body"></p><div id="p34-status-timing"></div></div>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(993705178578421880)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(993705178578421778)
,p_button_name=>'ANALYZE_RECON_AI'
,p_static_id=>'analyze-ar-reconciliation-with-ai'
,p_button_static_id=>'analyze-ar-reconciliation-with-ai'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Analyze Reconciliation with AI'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-sparkles'
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(993705178578421878)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(993705178578421778)
,p_button_name=>'CLOSE_PAGE'
,p_static_id=>'close-page'
,p_button_static_id=>'close-page'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Close'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-times'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(993705178578421879)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(993705178578421782)
,p_button_name=>'CLOSE_DETAIL'
,p_static_id=>'close-recon-detail'
,p_button_static_id=>'close-recon-detail'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Close Detail'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-times'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(993705178578421877)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(993705178578421778)
,p_button_name=>'RUN_RECON'
,p_static_id=>'run-gl-ar-recon'
,p_button_static_id=>'run-gl-ar-recon'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Run GL/AR Reconciliation'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-play'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(993705178578422142)
,p_name=>'P34_AGING_BUCKET_ID'
,p_item_sequence=>100
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(993705178578422124)
,p_name=>'P34_AS_OF_DATE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(993705178578421778)
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
 p_id=>wwv_flow_imp.id(993705178578422146)
,p_name=>'P34_BACK_URL'
,p_item_sequence=>104
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(993705178578422126)
,p_name=>'P34_COMPANY'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(993705178578421778)
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
 p_id=>wwv_flow_imp.id(993705178578422143)
,p_name=>'P34_CONTEXT_READY'
,p_item_sequence=>101
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(993705178578422122)
,p_name=>'P34_DB_LINK'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(993705178578421778)
,p_item_default=>'ADG'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(993705178578422128)
,p_name=>'P34_GENERATED_BY'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(993705178578421778)
,p_prompt=>'Generated By'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
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
 p_id=>wwv_flow_imp.id(993705178578422127)
,p_name=>'P34_GENERATED_ON'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(993705178578421778)
,p_prompt=>'Snapshot Generated On'
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
 p_id=>wwv_flow_imp.id(993705178578422125)
,p_name=>'P34_LEDGER_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(993705178578421778)
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
 p_id=>wwv_flow_imp.id(993705178578422123)
,p_name=>'P34_PERIOD_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(993705178578421778)
,p_prompt=>'Receivables Period'
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
 p_id=>wwv_flow_imp.id(993705178578422144)
,p_name=>'P34_REPORT_READY'
,p_item_sequence=>102
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(993705178578422129)
,p_name=>'P34_ROW_COUNT'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(993705178578421778)
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
 p_id=>wwv_flow_imp.id(993705178578422145)
,p_name=>'P34_SELECTED_CCID'
,p_item_sequence=>103
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(993705178578422181)
,p_name=>'Close Detail'
,p_static_id=>'close-detail'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(993705178578421879)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(993705178578422182)
,p_event_id=>wwv_flow_imp.id(993705178578422181)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p34Controller.closeDetail();')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(993705178578422179)
,p_name=>'Close Page'
,p_static_id=>'close-page'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(993705178578421878)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(993705178578422180)
,p_event_id=>wwv_flow_imp.id(993705178578422179)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p34Controller.closePage();')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(993705178578422183)
,p_name=>'Open Reconciliation AI Analyst'
,p_static_id=>'open-reconciliation-ai-analyst'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(993705178578421880)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(993705178578422184)
,p_event_id=>wwv_flow_imp.id(993705178578422183)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p34Controller.openAi();')).to_clob
,p_build_option_id=>wwv_flow_imp.id(1017112543199391948)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(993705178578422177)
,p_name=>'Run Reconciliation'
,p_static_id=>'run-reconciliation'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(993705178578421877)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(993705178578422178)
,p_event_id=>wwv_flow_imp.id(993705178578422177)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'p34Controller.run();')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(993705178578422279)
,p_process_sequence=>30
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'P34_GET_AI_URL'
,p_static_id=>'p34-get-ai-url'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare l_count number; l_asof date; l_url varchar2(32767);',
'begin',
' if :P34_REPORT_READY<>''Y'' or :P34_DB_LINK not in (''ADG'') or not regexp_like(:P34_PERIOD_NAME,''^[A-Z0-9 _./-]{1,30}$'') or not regexp_like(:P34_LEDGER_ID,''^[0-9]{1,18}$'') or not regexp_like(:P34_COMPANY,''^[A-Z0-9_.-]{1,25}$'') or not regexp_like(:P34_A'
||'GING_BUCKET_ID,''^[0-9]{1,18}$'') then raise_application_error(-20339,''Invalid GL/AR reconciliation context.''); end if;',
' if not apex_collection.collection_exists(''P34_GL_AR_RECON'') then raise_application_error(-20340,''Run GL/AR reconciliation before opening the AI Analyst.''); end if;',
' select count(*) into l_count from apex_collections where collection_name=''P34_GL_AR_RECON'';',
' if l_count=0 then raise_application_error(-20341,''The GL/AR reconciliation has no rows to analyze.''); end if;',
' select max(as_of_date) into l_asof from xxme_ar_recon_v2_snap where db_link_name=:P34_DB_LINK and ledger_id=to_number(:P34_LEDGER_ID) and company_segment=:P34_COMPANY and period_name=:P34_PERIOD_NAME and aging_bucket_id=to_number(:P34_AGING_BUCKET_I'
||'D);',
' l_url:=apex_page.get_url(p_page=>50,p_clear_cache=>''50'',p_items=>''P50_DB_LINK,P50_PERIOD_NAME,P50_AR_SCOPE_AS_OF_DATE,P50_AR_LEDGER_ID,P50_AR_COMPANY,P50_AR_AGING_BUCKET_ID,P50_AR_SOURCE_PAGE,P50_AR_RECON_READY'',p_values=>:P34_DB_LINK||'',''||:P34_PER'
||'IOD_NAME||'',''||to_char(l_asof,''YYYY-MM-DD'')||'',''||:P34_LEDGER_ID||'',''||:P34_COMPANY||'',''||:P34_AGING_BUCKET_ID||'',34,Y'');',
' apex_json.open_object;apex_json.write(''ok'',true);apex_json.write(''url'',l_url);apex_json.close_object;',
'exception when others then apex_json.open_object;apex_json.write(''ok'',false);apex_json.write(''message'',case when sqlcode between -20999 and -20000 then substr(sqlerrm,12) else ''Unable to prepare the AI Analyst URL.'' end);apex_json.close_object;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
,p_internal_uid=>934160000000686107
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(993705178578422278)
,p_process_sequence=>20
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'P34_RUN_RECON'
,p_static_id=>'p34-run-recon'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare l_count number:=0;l_out number:=0;l_ar number:=0;l_gl number:=0;l_var number:=0;',
'begin',
' apex_region.reset(p_page_id=>34,p_static_id=>''gl-ar-recon-report'');',
' if apex_collection.collection_exists(''P34_GL_AR_RECON'') then apex_collection.truncate_collection(''P34_GL_AR_RECON'');else apex_collection.create_collection(''P34_GL_AR_RECON'');end if;',
' for r in(select * from table(xxme_ar_recon_v2_pkg.get_gl_reconciliation(:P34_DB_LINK,to_number(:P34_LEDGER_ID),:P34_COMPANY,:P34_PERIOD_NAME,to_number(:P34_AGING_BUCKET_ID))) where abs(nvl(ar_open_accounted_amount,0))>=0.005) loop',
'  apex_collection.add_member(p_collection_name=>''P34_GL_AR_RECON'',p_c001=>r.account_segments,p_c002=>r.natural_account,p_c003=>to_char(r.ar_loaded_at,''DD-MON-YYYY HH24:MI:SS''),p_c004=>to_char(r.gl_retrieved_at,''DD-MON-YYYY HH24:MI:SS''),p_c005=>to_cha'
||'r(r.variance_amount,''TM9'',''NLS_NUMERIC_CHARACTERS=''''.,''''''),p_c006=>to_char(r.ar_not_transferred_amount,''TM9'',''NLS_NUMERIC_CHARACTERS=''''.,''''''),p_c007=>to_char(r.gl_period_receivables_activity,''TM9'',''NLS_NUMERIC_CHARACTERS=''''.,''''''),p_c008=>to_char(r.gl'
||'_period_revaluation_activity,''TM9'',''NLS_NUMERIC_CHARACTERS=''''.,''''''),p_c009=>to_char(r.gl_period_non_receivables_activity,''TM9'',''NLS_NUMERIC_CHARACTERS=''''.,''''''),p_n001=>r.receivable_ccid,p_n002=>r.ar_open_accounted_amount,p_n003=>r.gl_beginning_balanc'
||'e,p_n004=>r.gl_period_net,p_n005=>r.gl_ending_balance);',
'  l_count:=l_count+1;l_ar:=l_ar+nvl(r.ar_open_accounted_amount,0);l_gl:=l_gl+nvl(r.gl_ending_balance,0);l_var:=l_var+nvl(r.variance_amount,0);if abs(nvl(r.variance_amount,0))>=0.01 then l_out:=l_out+1;end if;',
' end loop;',
' apex_json.open_object;apex_json.write(''ok'',true);apex_json.open_object(''summary'');apex_json.write(''account_count'',to_char(l_count,''FM999G999G990''));apex_json.write(''out_of_balance'',to_char(l_out,''FM999G999G990''));apex_json.write(''ar_total'',to_char(l'
||'_ar,''FM999G999G999G990D00''));apex_json.write(''gl_total'',to_char(l_gl,''FM999G999G999G990D00''));apex_json.write(''variance_total'',to_char(l_var,''FM999G999G999G990D00''));apex_json.close_object;apex_json.close_object;',
'exception when others then if apex_collection.collection_exists(''P34_GL_AR_RECON'') then apex_collection.delete_collection(''P34_GL_AR_RECON'');end if;apex_json.open_object;apex_json.write(''ok'',false);apex_json.write(''message'',case when sqlcode between '
||'-20999 and -20000 then substr(sqlerrm,12) else ''Unable to run GL/AR reconciliation. Check the APEX debug log.'' end);apex_json.close_object;end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>934160000000686106
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(993705178578422277)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Validate Reconciliation Context'
,p_static_id=>'validate-reconciliation-context'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare l_count number;l_by varchar2(128);l_on timestamp;l_asof date;',
'begin :P34_BACK_URL:=apex_page.get_url(p_page=>32,p_clear_cache=>''32'');:P34_CONTEXT_READY:=''N'';:P34_REPORT_READY:=''N'';',
' if apex_collection.collection_exists(''P34_GL_AR_RECON'') then apex_collection.delete_collection(''P34_GL_AR_RECON'');end if;',
' :P34_DB_LINK:=upper(trim(:P34_DB_LINK));:P34_PERIOD_NAME:=upper(trim(:P34_PERIOD_NAME));:P34_COMPANY:=upper(trim(:P34_COMPANY));',
' if :P34_DB_LINK not in (''ADG'') or not regexp_like(:P34_PERIOD_NAME,''^[A-Z0-9 _./-]{1,30}$'') or not regexp_like(:P34_LEDGER_ID,''^[0-9]{1,18}$'') or not regexp_like(:P34_COMPANY,''^[A-Z0-9_.-]{1,25}$'') or not regexp_like(:P34_AGING_BUCKET_ID,''^[0-9]{1,1'
||'8}$'') then apex_error.add_error(p_message=>''Select an available AR snapshot on Page 32 before opening reconciliation.'',p_display_location=>apex_error.c_inline_in_notification);return;end if;',
' select count(*),max(loaded_by),max(loaded_at),max(as_of_date) into l_count,l_by,l_on,l_asof from xxme_ar_recon_v2_snap where db_link_name=:P34_DB_LINK and ledger_id=to_number(:P34_LEDGER_ID) and company_segment=:P34_COMPANY and period_name=:P34_PERI'
||'OD_NAME and aging_bucket_id=to_number(:P34_AGING_BUCKET_ID);',
' :P34_AS_OF_DATE:=to_char(l_asof,''DD-MON-YYYY'');:P34_GENERATED_ON:=to_char(l_on,''DD-MON-YYYY HH24:MI:SS'');:P34_GENERATED_BY:=l_by;:P34_ROW_COUNT:=to_char(l_count,''FM999G999G999G990'');',
' if l_count>0 then :P34_CONTEXT_READY:=''Y'';else apex_error.add_error(p_message=>''The selected AR snapshot is no longer available. Return to Page 32 and run it again.'',p_display_location=>apex_error.c_inline_in_notification);end if;',
'exception when others then :P34_CONTEXT_READY:=''N'';apex_error.add_error(p_message=>''Unable to validate the AR snapshot context. Check the APEX debug log.'',p_display_location=>apex_error.c_inline_in_notification);end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>934160000000686105
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
   where application_id = 115
     and page_id in (1, 23, 24, 33, 34);
  if l_cnt <> 5 then
    rollback;
    apex_application_install.clear_all;
    raise_application_error(-20998, 'Aborted App 115 Wave 1 commit: expected 5 patched pages, found ' || l_cnt);
  end if;
  wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false)
  );
  commit;
  apex_application_install.clear_all;
end;
/
set verify on feedback on define on
prompt  ...done
