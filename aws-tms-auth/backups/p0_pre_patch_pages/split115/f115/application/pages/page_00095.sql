prompt --application/pages/page_00095
begin
--   Manifest
--     PAGE: 00095
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
 p_id=>95
,p_name=>'Purge AI Conversation History'
,p_alias=>'PURGE-AI-CONVERSATION-HISTORY'
,p_page_mode=>'MODAL'
,p_step_title=>'Purge AI Conversation History'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>2103835248774687739
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(9156329399484443)
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
,p_dialog_title=>'Purge AI Conversation History'
,p_dialog_height=>'620'
,p_dialog_width=>'900'
,p_dialog_chained=>'N'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'25'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1038815488218695579)
,p_plug_name=>'Deletion Preview'
,p_static_id=>'deletion-preview'
,p_title=>'Deletion Preview'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>20
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'',
'declare',
'    l_total number; l_success number; l_error number; l_first timestamp with time zone; l_last timestamp with time zone;',
'    l_from_date date; l_to_date date;',
'    procedure outp(p_text varchar2) is begin sys.htp.prn(p_text); end;',
'begin',
'    if :P95_APPLICATION_ID is null or :P95_DATE_FROM is null or :P95_DATE_TO is null then',
'        outp(''<p>Select an application and both dates, then choose Preview.</p>''); return;',
'    end if;',
'    l_from_date:=coalesce(',
'        to_date(:P95_DATE_FROM default null on conversion error,''DD-MON-YYYY'',''NLS_DATE_LANGUAGE=English''),',
'        to_date(:P95_DATE_FROM default null on conversion error,''MM/DD/YYYY''),',
'        to_date(:P95_DATE_FROM default null on conversion error,''YYYY-MM-DD''));',
'    l_to_date:=coalesce(',
'        to_date(:P95_DATE_TO default null on conversion error,''DD-MON-YYYY'',''NLS_DATE_LANGUAGE=English''),',
'        to_date(:P95_DATE_TO default null on conversion error,''MM/DD/YYYY''),',
'        to_date(:P95_DATE_TO default null on conversion error,''YYYY-MM-DD''));',
'    if l_from_date is null or l_to_date is null then raise_application_error(-20045,''Enter valid From and Through dates.''); end if;',
'    select count(*),sum(case when status=''SUCCESS'' then 1 else 0 end),sum(case when status=''ERROR'' then 1 else 0 end),min(created_on),max(created_on)',
'      into l_total,l_success,l_error,l_first,l_last',
'      from xxme_ai_p50_bench_log',
'     where application_id=:P95_APPLICATION_ID',
'       and created_on>=from_tz(cast(l_from_date as timestamp),''America/New_York'')',
'       and created_on<from_tz(cast(l_to_date+1 as timestamp),''America/New_York'');',
'    outp(''<dl class="t-AVPList t-AVPList--leftAligned"><dt>Application</dt><dd>''||apex_escape.html(:P95_APPLICATION_ID)||''</dd><dt>Inclusive date range</dt><dd>''||apex_escape.html(:P95_DATE_FROM)||'' through ''||apex_escape.html(:P95_DATE_TO)||''</dd><d'
||'t>Matching conversations</dt><dd><strong>''||l_total||''</strong></dd><dt>Successful / Failed</dt><dd>''||nvl(l_success,0)||'' / ''||nvl(l_error,0)||''</dd><dt>First / Last recorded</dt><dd>''||nvl(to_char(l_first,''YYYY-MM-DD HH24:MI:SS''),''-'')||'' / ''||nvl(t'
||'o_char(l_last,''YYYY-MM-DD HH24:MI:SS''),''-'')||''</dd></dl>'');',
'exception when others then outp(''<div class="t-Alert t-Alert--danger"><div class="t-Alert-body">''||apex_escape.html(sqlerrm)||''</div></div>'');',
'end;',
''))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1038815488218695578)
,p_plug_name=>'Purge Selection'
,p_static_id=>'purge-selection'
,p_title=>'Purge Selection'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>'<div class="t-Alert t-Alert--warning"><div class="t-Alert-body"><strong>Permanent deletion.</strong> Select exactly one application and an inclusive date range. Deleted questions and answers cannot be recovered from the application.</div></div>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(1038815488218695599)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(1038815488218695578)
,p_button_name=>'DELETE_HISTORY'
,p_static_id=>'delete-history'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--danger'
,p_button_template_id=>4075790603270660137
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Delete Matching Conversations'
,p_button_position=>'CREATE'
,p_confirm_message=>'Permanently delete every recorded Page 50 conversation for the selected application and inclusive date range? This cannot be undone.'
,p_confirm_style=>'danger'
,p_icon_css_classes=>'fa-trash'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(1038815488218695598)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(1038815488218695578)
,p_button_name=>'PREVIEW_PURGE'
,p_static_id=>'preview-purge'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Preview Matching Conversations'
,p_button_position=>'CREATE'
,p_icon_css_classes=>'fa-search'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1038815488218695588)
,p_name=>'P95_APPLICATION_ID'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(1038815488218695578)
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
 p_id=>wwv_flow_imp.id(1038815488218695589)
,p_name=>'P95_DATE_FROM'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(1038815488218695578)
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
 p_id=>wwv_flow_imp.id(1038815488218695590)
,p_name=>'P95_DATE_TO'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(1038815488218695578)
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
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(1038815488218695608)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Purge Selected Conversation History'
,p_static_id=>'purge-selected-conversation-history'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'',
'declare',
'    l_from date; l_to date; l_deleted number;',
'begin',
'    raise_application_error(-20041,''AI administration is disabled pending App 400 role integration.'');',
'    if :P95_APPLICATION_ID is null or :P95_DATE_FROM is null or :P95_DATE_TO is null then raise_application_error(-20042,''Application, From Date, and Through Date are required.''); end if;',
'    l_from:=coalesce(',
'        to_date(:P95_DATE_FROM default null on conversion error,''DD-MON-YYYY'',''NLS_DATE_LANGUAGE=English''),',
'        to_date(:P95_DATE_FROM default null on conversion error,''MM/DD/YYYY''),',
'        to_date(:P95_DATE_FROM default null on conversion error,''YYYY-MM-DD''));',
'    l_to:=coalesce(',
'        to_date(:P95_DATE_TO default null on conversion error,''DD-MON-YYYY'',''NLS_DATE_LANGUAGE=English''),',
'        to_date(:P95_DATE_TO default null on conversion error,''MM/DD/YYYY''),',
'        to_date(:P95_DATE_TO default null on conversion error,''YYYY-MM-DD''));',
'    if l_from is null or l_to is null then raise_application_error(-20045,''Enter valid From and Through dates.''); end if;',
'    if l_to<l_from then raise_application_error(-20043,''Through Date cannot be earlier than From Date.''); end if;',
'    delete from xxme_ai_p50_bench_log',
'     where application_id=to_number(:P95_APPLICATION_ID)',
'       and created_on>=from_tz(cast(l_from as timestamp),''America/New_York'')',
'       and created_on<from_tz(cast(l_to+1 as timestamp),''America/New_York'');',
'    l_deleted:=sql%rowcount;',
'    if l_deleted=0 then raise_application_error(-20044,''No matching conversations were found. Nothing was deleted.''); end if;',
'    insert into xxme_ai_p50_purge_audit(application_id,date_from,date_through,deleted_count,deleted_by,apex_session_id)',
'    values(to_number(:P95_APPLICATION_ID),l_from,l_to,l_deleted,v(''APP_USER''),v(''APP_SESSION''));',
'    commit;',
'    apex_application.g_print_success_message:=l_deleted||'' recorded conversation(s) deleted. The purge action was audited.'';',
'end;',
''))
,p_process_clob_language=>'PLSQL'
,p_process_when_button_id=>wwv_flow_imp.id(1038815488218695599)
,p_internal_uid=>981170000000000530
);
wwv_flow_imp.component_end;
end;
/
