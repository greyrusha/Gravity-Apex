prompt --application/pages/page_00094
begin
--   Manifest
--     PAGE: 00094
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
 p_id=>94
,p_name=>'AI Provider Comparison'
,p_alias=>'AI-PROVIDER-COMPARISON'
,p_page_mode=>'MODAL'
,p_step_title=>'AI Provider Comparison'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>2103835248774687739
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(9156329399484443)
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
,p_dialog_title=>'AI Provider Comparison'
,p_dialog_height=>'820'
,p_dialog_width=>'1400'
,p_dialog_chained=>'N'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'25'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1038815488218695478)
,p_plug_name=>'Exact-Match Provider Comparison'
,p_static_id=>'exact-match-provider-comparison'
,p_title=>'Exact-Match Provider Comparison'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'',
'declare',
'    l_a number; l_b number; l_question clob; l_period varchar2(255); l_app number;',
'    procedure outp(p_text varchar2) is begin sys.htp.prn(p_text); end;',
'    procedure out_clob(p_text clob) is l_pos integer:=1; l_len integer:=dbms_lob.getlength(p_text); begin while l_pos<=l_len loop sys.htp.prn(dbms_lob.substr(p_text,240,l_pos)); l_pos:=l_pos+240; end loop; end;',
'    procedure render_run(p_run_id number) is',
'    begin',
'      for r in (select * from xxme_ai_p50_bench_log where run_id=p_run_id) loop',
unistr('        outp(''<section style="min-width:0"><h2>''||apex_escape.html(r.provider_name)||''</h2><p><strong>''||apex_escape.html(r.model_name)||''</strong><br>Run ''||r.run_id||'' \00B7 ''||to_char(r.elapsed_ms/1000,''FM9999990D00'')||'' sec<br>''||apex_escape.html(to_')
||'char(r.response_ts,''YYYY-MM-DD HH24:MI:SS''))||''</p><hr><div>'');',
'        out_clob(apex_markdown.to_html(r.response_text)); outp(''</div></section>'');',
'      end loop;',
'    end;',
'begin',
'    select to_number(c001),to_number(c002) into l_a,l_b from apex_collections where collection_name=''XXME_AI_COMPARE_SELECTION'' and seq_id=1;',
'    select question_text,period_name,application_id into l_question,l_period,l_app from xxme_ai_p50_bench_log where run_id=l_a;',
unistr('    outp(''<div class="t-Alert t-Alert--success"><div class="t-Alert-body"><strong>Exact context match</strong>: Application ''||l_app||'' \00B7 Period ''||apex_escape.html(l_period)||'' \00B7 identical question and recorded accounting context.</div></div>'');'),
'    outp(''<h3>Shared Question</h3><pre style="white-space:pre-wrap;font-family:inherit">''); out_clob(apex_escape.html_clob(l_question)); outp(''</pre>'');',
'    outp(''<div style="display:grid;grid-template-columns:minmax(0,1fr) minmax(0,1fr);gap:1.5rem;align-items:start">'');',
'    render_run(l_a); render_run(l_b); outp(''</div>'');',
'exception when no_data_found then outp(''<div class="t-Alert t-Alert--warning"><div class="t-Alert-body">No valid comparison selection is available. Return to Page 92 and select two matching responses.</div></div>'');',
'end;',
''))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
);
wwv_flow_imp.component_end;
end;
/
