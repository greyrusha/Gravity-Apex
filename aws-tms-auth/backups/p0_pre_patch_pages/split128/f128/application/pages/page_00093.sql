prompt --application/pages/page_00093
begin
--   Manifest
--     PAGE: 00093
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
 p_id=>93
,p_name=>'AI Conversation Detail'
,p_alias=>'AI-CONVERSATION-DETAIL'
,p_page_mode=>'MODAL'
,p_step_title=>'AI Conversation Detail'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>2103835248774687739
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(18558063129193156)
,p_required_patch=>wwv_flow_imp.id(1026514276929100661)
,p_dialog_title=>'AI Conversation Detail'
,p_dialog_height=>'760'
,p_dialog_width=>'1200'
,p_dialog_chained=>'N'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'25'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1048217221948404091)
,p_plug_name=>'Recorded Conversation'
,p_static_id=>'recorded-conversation-detail'
,p_title=>'Recorded Conversation'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'',
'declare',
'    procedure outp(p_text varchar2) is begin sys.htp.prn(p_text); end;',
'    procedure out_clob(p_text clob) is',
'        l_pos integer:=1; l_len integer:=dbms_lob.getlength(p_text);',
'    begin',
'        while l_pos<=l_len loop sys.htp.prn(dbms_lob.substr(p_text,240,l_pos)); l_pos:=l_pos+240; end loop;',
'    end;',
'begin',
'    for r in (select * from xxme_ai_p50_bench_log where run_id=:P93_RUN_ID) loop',
unistr('        outp(''<div class="t-Alert t-Alert--horizontal t-Alert--defaultIcons t-Alert--info"><div class="t-Alert-wrap"><div class="t-Alert-content"><div class="t-Alert-header"><h2 class="t-Alert-title">Run ''||r.run_id||'' \00B7 ''||apex_escape.html(r.provide')
||'r_name)||'' / ''||apex_escape.html(r.model_name)||''</h2></div>'');',
unistr('        outp(''<div class="t-Alert-body">Application ''||r.application_id||'' \00B7 ''||apex_escape.html(r.app_user)||'' \00B7 Period ''||apex_escape.html(r.period_name)||'' \00B7 ''||to_char(r.elapsed_ms/1000,''FM9999990D00'')||'' sec \00B7 ''||apex_escape.html(r.status)||''</d')
||'iv></div></div></div>'');',
'        outp(''<h3>Question <small>''||apex_escape.html(to_char(r.question_ts,''YYYY-MM-DD HH24:MI:SS''))||''</small></h3><div class="t-Region-body"><pre style="white-space:pre-wrap;font-family:inherit">'');',
'        out_clob(apex_escape.html_clob(r.question_text)); outp(''</pre></div>'');',
'        if r.status=''SUCCESS'' then',
'            outp(''<h3>AI Response <small>''||apex_escape.html(to_char(r.response_ts,''YYYY-MM-DD HH24:MI:SS''))||''</small></h3><div class="t-Region-body">'');',
'            out_clob(apex_markdown.to_html(r.response_text)); outp(''</div>'');',
'        else',
'            outp(''<h3>Error</h3><div class="t-Alert t-Alert--danger"><div class="t-Alert-body">''||apex_escape.html(r.error_code||'' - ''||r.error_message)||''</div></div>'');',
'        end if;',
'        outp(''<details><summary>Technical context</summary><dl><dt>Agent</dt><dd>''||apex_escape.html(r.agent_static_id)||''</dd><dt>Database source</dt><dd>''||apex_escape.html(r.db_link_name)||''</dd><dt>APEX session</dt><dd>''||apex_escape.html(r.apex_'
||'session_id)||''</dd></dl><pre style="white-space:pre-wrap">'');',
'        out_clob(apex_escape.html_clob(r.context_json)); outp(''</pre></details>'');',
'    end loop;',
'end;',
''))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1048217221948404092)
,p_name=>'P93_RUN_ID'
,p_is_required=>true
,p_item_sequence=>10
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp.component_end;
end;
/
