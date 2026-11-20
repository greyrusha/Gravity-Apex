prompt --application/pages/page_00092
begin
--   Manifest
--     PAGE: 00092
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
 p_id=>92
,p_name=>'AI Conversation Review'
,p_alias=>'AI-CONVERSATION-REVIEW'
,p_step_title=>'AI Conversation Review'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>4075783602716660119
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(9156329399484443)
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
,p_protection_level=>'C'
,p_page_component_map=>'25'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1038815488218695280)
,p_plug_name=>'Compare Recorded Responses'
,p_static_id=>'compare-recorded-responses'
,p_title=>'Compare Recorded Responses'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>30
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>'<p>These response selectors are independent of the date, provider, status, and question-list filters above. Select the first successful run; the matching-response list refreshes automatically. The second run may use the same or a different provider o'
||'r model, but the application, question, period, database source, and accounting scope must match. Agent-policy metadata does not restrict comparison.</p>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1038815488218695279)
,p_plug_name=>'Recorded Page 50 Conversations'
,p_static_id=>'recorded-conversations'
,p_title=>'Recorded Page 50 Conversations'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>20
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'',
'declare',
'    l_rows number := 0;',
'    l_url  varchar2(4000);',
'    l_from_date date;',
'    l_to_date   date;',
'    procedure outp(p_text varchar2) is begin sys.htp.prn(p_text); end;',
'begin',
'    l_from_date:=coalesce(',
'        to_date(:P92_DATE_FROM default null on conversion error,''DD-MON-YYYY'',''NLS_DATE_LANGUAGE=English''),',
'        to_date(:P92_DATE_FROM default null on conversion error,''MM/DD/YYYY''),',
'        to_date(:P92_DATE_FROM default null on conversion error,''YYYY-MM-DD''));',
'    l_to_date:=coalesce(',
'        to_date(:P92_DATE_TO default null on conversion error,''DD-MON-YYYY'',''NLS_DATE_LANGUAGE=English''),',
'        to_date(:P92_DATE_TO default null on conversion error,''MM/DD/YYYY''),',
'        to_date(:P92_DATE_TO default null on conversion error,''YYYY-MM-DD''));',
'    outp(''<div class="t-Report-wrap"><div class="t-Report-tableWrap"><table class="t-Report-report" role="table">'');',
'    outp(''<thead><tr><th>Run</th><th>Recorded</th><th>Provider / Model</th><th>User</th><th>Period</th><th>Status</th><th>Seconds</th><th>Question</th><th>Review</th></tr></thead><tbody>'');',
'    for r in (',
'        select run_id, created_on, provider_name, model_name, app_user, period_name,',
'               status, round(elapsed_ms/1000,2) seconds,',
'               dbms_lob.substr(question_text,350,1) question_preview',
'          from xxme_ai_p50_bench_log',
'         where application_id = :P92_APPLICATION_ID',
'           and (l_from_date is null or created_on >= from_tz(cast(l_from_date as timestamp),''America/New_York''))',
'           and (l_to_date is null or created_on < from_tz(cast(l_to_date+1 as timestamp),''America/New_York''))',
'           and (:P92_PROVIDER is null or provider_name = :P92_PROVIDER)',
'           and (:P92_STATUS is null or status = :P92_STATUS)',
'           and (:P92_SEARCH is null or instr(upper(dbms_lob.substr(question_text,32767,1)),upper(:P92_SEARCH)) > 0)',
'         order by run_id desc',
'         fetch first 200 rows only',
'    ) loop',
'        l_rows := l_rows + 1;',
'        l_url := apex_page.get_url(p_page=>93,p_clear_cache=>''93'',p_items=>''P93_RUN_ID'',p_values=>r.run_id);',
'        outp(''<tr>'');',
'        outp(''<td>''||r.run_id||''</td>'');',
'        outp(''<td>''||apex_escape.html(to_char(r.created_on,''YYYY-MM-DD HH24:MI:SS''))||''</td>'');',
'        outp(''<td>''||apex_escape.html(r.provider_name||'' / ''||r.model_name)||''</td>'');',
'        outp(''<td>''||apex_escape.html(r.app_user)||''</td>'');',
'        outp(''<td>''||apex_escape.html(r.period_name)||''</td>'');',
'        outp(''<td><span class="t-Badge ''||case r.status when ''SUCCESS'' then ''t-Badge--success'' else ''t-Badge--danger'' end||''">''||apex_escape.html(r.status)||''</span></td>'');',
'        outp(''<td class="u-textEnd">''||to_char(r.seconds,''FM9999990D00'')||''</td>'');',
'        outp(''<td>''||apex_escape.html(r.question_preview)||''</td>'');',
'        outp(''<td><a class="t-Button t-Button--small" href="''||apex_escape.html_attribute(l_url)||''">Review</a></td>'');',
'        outp(''</tr>'');',
'    end loop;',
'    if l_rows = 0 then outp(''<tr><td colspan="9">No recorded conversations match the selected filters.</td></tr>''); end if;',
'    outp(''</tbody></table></div></div>'');',
'    if l_rows = 200 then outp(''<p class="u-textMuted">Showing the newest 200 matching runs. Narrow the date range to see a smaller result set.</p>''); end if;',
'end;',
''))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1038815488218695278)
,p_plug_name=>'Review Filters'
,p_static_id=>'review-filters'
,p_title=>'Review Filters'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(1038815488218695298)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(1038815488218695278)
,p_button_name=>'APPLY_FILTERS'
,p_static_id=>'apply-filters'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Refresh Conversation List'
,p_button_position=>'CREATE'
,p_icon_css_classes=>'fa-search'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(1038815488218695310)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(1038815488218695280)
,p_button_name=>'COMPARE_RESPONSES'
,p_static_id=>'compare-responses'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Compare Responses'
,p_button_position=>'CREATE'
,p_icon_css_classes=>'fa-columns'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(1038815488218695300)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(1038815488218695278)
,p_button_name=>'PURGE_HISTORY'
,p_static_id=>'purge-history'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--danger'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Delete Conversation History'
,p_button_position=>'CREATE'
,p_icon_css_classes=>'fa-trash'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(1038815488218695299)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(1038815488218695278)
,p_button_name=>'RESET_FILTERS'
,p_static_id=>'reset-filters'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Reset Filters'
,p_button_position=>'CREATE'
,p_button_redirect_url=>'f?p=&APP_ID.:92:&SESSION.::&DEBUG.:RP,92::'
,p_icon_css_classes=>'fa-undo'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(1038815488218695319)
,p_branch_name=>'Open Comparison'
,p_branch_action=>'f?p=&APP_ID.:94:&SESSION.::&DEBUG.:RP,94::'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(1038815488218695310)
,p_branch_sequence=>10
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(1038815488218695320)
,p_branch_name=>'Open Purge Dialog'
,p_branch_action=>'f?p=&APP_ID.:95:&SESSION.::&DEBUG.:RP,95::'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(1038815488218695300)
,p_branch_sequence=>20
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1038815488218695288)
,p_name=>'P92_APPLICATION_ID'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(1038815488218695278)
,p_item_default=>'117'
,p_prompt=>'Application'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''Application ''||l.application_id||'' - ''||nvl(a.application_name,''Unknown'') d, l.application_id r',
'  from (select distinct application_id from xxme_ai_p50_bench_log) l',
'  left join apex_applications a on a.application_id=l.application_id',
' order by l.application_id'))
,p_cHeight=>1
,p_colspan=>4
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1038815488218695308)
,p_name=>'P92_COMPARE_RUN_A'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(1038815488218695280)
,p_prompt=>'First Response'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''Run ''||run_id||'' - ''||provider_name||'' / ''||model_name||'' - ''||substr(dbms_lob.substr(question_text,180,1),1,180) d, run_id r',
'  from xxme_ai_p50_bench_log',
' where application_id=:P92_APPLICATION_ID and status=''SUCCESS''',
' order by run_id desc'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- Select First Response -'
,p_lov_cascade_parent_items=>'P92_APPLICATION_ID'
,p_cHeight=>1
,p_colspan=>6
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1038815488218695309)
,p_name=>'P92_COMPARE_RUN_B'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(1038815488218695280)
,p_prompt=>'Matching Response'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''Run ''||b.run_id||'' - ''||b.provider_name||'' / ''||b.model_name d, b.run_id r',
'  from xxme_ai_p50_bench_log a',
'  join xxme_ai_p50_bench_log b on b.application_id=a.application_id',
'   and b.run_id<>a.run_id and b.status=''SUCCESS''',
'   and nvl(b.period_name,''-'')=nvl(a.period_name,''-'')',
'   and nvl(b.db_link_name,''-'')=nvl(a.db_link_name,''-'')',
'   and dbms_lob.compare(b.question_text,a.question_text)=0',
'   and nvl(json_value(b.context_json,''$.ap_scope_as_of_date'' returning varchar2(100) null on error),''-'')=nvl(json_value(a.context_json,''$.ap_scope_as_of_date'' returning varchar2(100) null on error),''-'')',
'   and nvl(json_value(b.context_json,''$.ap_ledger_id'' returning varchar2(100) null on error),''-'')=nvl(json_value(a.context_json,''$.ap_ledger_id'' returning varchar2(100) null on error),''-'')',
'   and nvl(json_value(b.context_json,''$.ap_company'' returning varchar2(100) null on error),''-'')=nvl(json_value(a.context_json,''$.ap_company'' returning varchar2(100) null on error),''-'')',
'   and nvl(json_value(b.context_json,''$.ar_scope_as_of_date'' returning varchar2(100) null on error),''-'')=nvl(json_value(a.context_json,''$.ar_scope_as_of_date'' returning varchar2(100) null on error),''-'')',
'   and nvl(json_value(b.context_json,''$.ar_ledger_id'' returning varchar2(100) null on error),''-'')=nvl(json_value(a.context_json,''$.ar_ledger_id'' returning varchar2(100) null on error),''-'')',
'   and nvl(json_value(b.context_json,''$.ar_company'' returning varchar2(100) null on error),''-'')=nvl(json_value(a.context_json,''$.ar_company'' returning varchar2(100) null on error),''-'')',
'   and nvl(json_value(b.context_json,''$.ar_aging_bucket_id'' returning varchar2(100) null on error),''-'')=nvl(json_value(a.context_json,''$.ar_aging_bucket_id'' returning varchar2(100) null on error),''-'')',
' where a.run_id=:P92_COMPARE_RUN_A',
' order by b.run_id desc'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- Select Matching Response -'
,p_lov_cascade_parent_items=>'P92_COMPARE_RUN_A'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1038815488218695289)
,p_name=>'P92_DATE_FROM'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(1038815488218695278)
,p_item_default=>'select trunc(sysdate)-30 from dual'
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'From Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1038815488218695290)
,p_name=>'P92_DATE_TO'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(1038815488218695278)
,p_item_default=>'select trunc(sysdate) from dual'
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Through Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1038815488218695291)
,p_name=>'P92_PROVIDER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(1038815488218695278)
,p_prompt=>'Provider'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'select distinct provider_name d, provider_name r from xxme_ai_p50_bench_log where application_id=:P92_APPLICATION_ID order by 1'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- All Providers -'
,p_lov_cascade_parent_items=>'P92_APPLICATION_ID'
,p_cHeight=>1
,p_colspan=>4
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1038815488218695293)
,p_name=>'P92_SEARCH'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(1038815488218695278)
,p_prompt=>'Question Contains'
,p_placeholder=>'Search the first 32,767 characters of the question'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>40
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'Y',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1038815488218695292)
,p_name=>'P92_STATUS'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(1038815488218695278)
,p_prompt=>'Status'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Success;SUCCESS,Error;ERROR'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- All Statuses -'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(1038815488218695318)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Validate and Store Comparison'
,p_static_id=>'validate-and-store-comparison'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'',
'declare',
'    l_count number;',
'begin',
'    select count(*) into l_count',
'      from xxme_ai_p50_bench_log a',
'      join xxme_ai_p50_bench_log b on b.run_id=:P92_COMPARE_RUN_B',
'     where a.run_id=:P92_COMPARE_RUN_A',
'       and a.application_id=b.application_id',
'       and a.run_id<>b.run_id',
'       and a.status=''SUCCESS'' and b.status=''SUCCESS''',
'       and nvl(a.period_name,''-'')=nvl(b.period_name,''-'')',
'       and nvl(a.db_link_name,''-'')=nvl(b.db_link_name,''-'')',
'       and dbms_lob.compare(a.question_text,b.question_text)=0',
'       and nvl(json_value(a.context_json,''$.ap_scope_as_of_date'' returning varchar2(100) null on error),''-'')=nvl(json_value(b.context_json,''$.ap_scope_as_of_date'' returning varchar2(100) null on error),''-'')',
'       and nvl(json_value(a.context_json,''$.ap_ledger_id'' returning varchar2(100) null on error),''-'')=nvl(json_value(b.context_json,''$.ap_ledger_id'' returning varchar2(100) null on error),''-'')',
'       and nvl(json_value(a.context_json,''$.ap_company'' returning varchar2(100) null on error),''-'')=nvl(json_value(b.context_json,''$.ap_company'' returning varchar2(100) null on error),''-'')',
'       and nvl(json_value(a.context_json,''$.ar_scope_as_of_date'' returning varchar2(100) null on error),''-'')=nvl(json_value(b.context_json,''$.ar_scope_as_of_date'' returning varchar2(100) null on error),''-'')',
'       and nvl(json_value(a.context_json,''$.ar_ledger_id'' returning varchar2(100) null on error),''-'')=nvl(json_value(b.context_json,''$.ar_ledger_id'' returning varchar2(100) null on error),''-'')',
'       and nvl(json_value(a.context_json,''$.ar_company'' returning varchar2(100) null on error),''-'')=nvl(json_value(b.context_json,''$.ar_company'' returning varchar2(100) null on error),''-'')',
'       and nvl(json_value(a.context_json,''$.ar_aging_bucket_id'' returning varchar2(100) null on error),''-'')=nvl(json_value(b.context_json,''$.ar_aging_bucket_id'' returning varchar2(100) null on error),''-'');',
'    if l_count<>1 then',
'        raise_application_error(-20040,''Select two different successful runs with exactly matching application, question, period, database source, and accounting context.'');',
'    end if;',
'    apex_collection.create_or_truncate_collection(''XXME_AI_COMPARE_SELECTION'');',
'    apex_collection.add_member(p_collection_name=>''XXME_AI_COMPARE_SELECTION'',p_c001=>:P92_COMPARE_RUN_A,p_c002=>:P92_COMPARE_RUN_B);',
'end;',
''))
,p_process_clob_language=>'PLSQL'
,p_process_when_button_id=>wwv_flow_imp.id(1038815488218695310)
,p_internal_uid=>981170000000000240
);
wwv_flow_imp.component_end;
end;
/
