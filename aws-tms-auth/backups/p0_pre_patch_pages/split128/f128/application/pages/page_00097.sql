prompt --application/pages/page_00097
begin
--   Manifest
--     PAGE: 00097
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
 p_id=>97
,p_name=>'Knowledge Workspace'
,p_alias=>'KNOWLEDGE-WORKSPACE'
,p_step_title=>'Knowledge Workspace'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>4075783602716660119
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(18558063129193156)
,p_required_patch=>wwv_flow_imp.id(1026514276929100661)
,p_protection_level=>'C'
,p_page_component_map=>'25'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1048217221948404491)
,p_plug_name=>'Draft Difference and Preview'
,p_static_id=>'draft-difference-preview'
,p_title=>'Draft Difference and Preview'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>30
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'    l_effective_title varchar2(500);',
'    l_effective       clob;',
'    l_draft_title     varchar2(500);',
'    l_draft           clob;',
'begin',
'    if :P97_ITEM_ID is not null then',
'        begin',
'            select title, content into l_effective_title, l_effective',
'              from xxme_ai_km_effective_v where item_id = :P97_ITEM_ID;',
'        exception when no_data_found then null; end;',
'    end if;',
'    if :P97_REVISION_ID is not null then',
'        begin',
'            select title, content into l_draft_title, l_draft',
'              from xxme_ai_km_revisions',
'             where revision_id = :P97_REVISION_ID',
'               and item_id = :P97_ITEM_ID;',
'        exception when no_data_found then null; end;',
'    end if;',
'    sys.htp.prn(''<div class="row"><div class="col col-6"><h3>Effective revision</h3><pre class="km-diff">''||',
'        apex_escape.html(nvl(l_effective_title,''No effective revision'')||chr(10)||dbms_lob.substr(l_effective,30000,1))||''</pre></div>'');',
'    sys.htp.prn(''<div class="col col-6"><h3>Working draft</h3><pre class="km-diff">''||',
'        apex_escape.html(nvl(l_draft_title,''No saved draft'')||chr(10)||dbms_lob.substr(l_draft,30000,1))||''</pre></div></div>'');',
'end;',
''))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1048217221948404492)
,p_plug_name=>'Draft Editor'
,p_static_id=>'draft-editor'
,p_title=>'Draft Editor'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>40
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_display_condition_type=>'EXPRESSION'
,p_plug_display_when_condition=>':P97_CAN_EDIT = ''Y'''
,p_plug_display_when_cond2=>'PLSQL'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1048217221948404490)
,p_plug_name=>'Effective Knowledge'
,p_static_id=>'effective-knowledge-preview'
,p_title=>'Effective Knowledge'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>20
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'    l_title   varchar2(500);',
'    l_content clob;',
'begin',
'    if :P97_ITEM_ID is null then',
'        sys.htp.prn(''<p class="u-textMuted">The effective preview will be available after this draft is published.</p>'');',
'    else',
'      select title, content into l_title, l_content',
'        from xxme_ai_km_effective_v',
'       where item_id = :P97_ITEM_ID;',
'      sys.htp.prn(''<h3>''||apex_escape.html(l_title)||''</h3><pre class="km-preview">''||apex_escape.html(dbms_lob.substr(l_content,32000,1))||''</pre>'');',
'    end if;',
'exception',
'    when no_data_found then',
'        sys.htp.prn(''<p class="u-textMuted">No effective published revision is available.</p>'');',
'end;',
''))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1048217221948404489)
,p_plug_name=>'Knowledge Summary'
,p_static_id=>'knowledge-summary'
,p_title=>'Knowledge Summary'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'    procedure outp(p_text varchar2) is begin sys.htp.prn(p_text); end;',
'begin',
'    if :P97_MODE = ''NEW'' then',
'        outp(''<div class="t-Alert t-Alert--info"><div class="t-Alert-body"><strong>Teach new knowledge.</strong> New items are created as human-readable Knowledge Manager drafts. No vector is exposed or activated until the governed publish workflow s'
||'ucceeds.</div></div>'');',
'    else',
'      for r in (',
'        select k.*, i.created_by, i.created_on',
'          from xxme_ai_km_effective_v k',
'          join xxme_ai_km_items i on i.item_id = k.item_id',
'         where k.item_id = :P97_ITEM_ID',
'    ) loop',
'        outp(''<dl class="t-AVPList t-AVPList--leftAligned">'');',
'        outp(''<dt>Source</dt><dd>''||apex_escape.html(r.source_name||'' (''||r.source_code||'')'')||''</dd>'');',
'        outp(''<dt>Ownership / Editability</dt><dd>''||apex_escape.html(r.ownership_code||'' / ''||r.edit_mode)||''</dd>'');',
'        outp(''<dt>Status / Mandatory / Version</dt><dd>''||apex_escape.html(r.lifecycle_status||'' / ''||r.is_mandatory||'' / ''||r.version_no)||''</dd>'');',
'        outp(''<dt>Embedding</dt><dd>''||apex_escape.html(r.embedding_status||'' / ''||nvl(r.embedding_model,''-'')||'' / ''||nvl(to_char(r.embedded_on,''YYYY-MM-DD HH24:MI:SS TZH:TZM''),''-'') )||''</dd>'');',
'        outp(''<dt>Created</dt><dd>''||apex_escape.html(r.created_by||'' / ''||to_char(r.created_on,''YYYY-MM-DD HH24:MI:SS TZH:TZM''))||''</dd>'');',
'        outp(''<dt>Last Updated</dt><dd>''||apex_escape.html(r.updated_by||'' / ''||to_char(r.updated_on,''YYYY-MM-DD HH24:MI:SS TZH:TZM''))||''</dd>'');',
'        outp(''<dt>Published</dt><dd>''||apex_escape.html(nvl(r.published_by,''-'')||'' / ''||nvl(to_char(r.published_on,''YYYY-MM-DD HH24:MI:SS TZH:TZM''),''-''))||''</dd>'');',
'        outp(''</dl>'');',
'        if r.edit_mode = ''TOOL_DEFINITION'' then',
'            outp(''<div class="t-Alert t-Alert--warning"><div class="t-Alert-body">This APEX agent tool contract is read-only here. Change the corresponding tool definition, then synchronize and re-embed it.</div></div>'');',
'        elsif r.edit_mode = ''OVERRIDE_ONLY'' then',
'            outp(''<div class="t-Alert t-Alert--warning"><div class="t-Alert-body">The authoritative source is externally controlled. It cannot be edited here; use a governed override with explicit provenance and precedence.</div></div>'');',
'        elsif r.edit_mode = ''GOVERNED_SOURCE'' then',
'            outp(''<div class="t-Alert t-Alert--info"><div class="t-Alert-body">Edits create a candidate revision. The authoritative Oracle source must be approved, updated, synchronized, and re-embedded before publication.</div></div>'');',
'        end if;',
'      end loop;',
'    end if;',
'end;',
''))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1048217221948404493)
,p_plug_name=>'Retirement Action'
,p_static_id=>'retirement-action'
,p_title=>'Retirement Action'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>50
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>'<p>Retiring an item preserves its complete history but removes its active retrieval representation.</p>'
,p_plug_display_condition_type=>'EXPRESSION'
,p_plug_display_when_condition=>':P97_CAN_RETIRE = ''Y'''
,p_plug_display_when_cond2=>'PLSQL'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(1048217221948404509)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(1048217221948404489)
,p_button_name=>'BACK_TO_BROWSE'
,p_static_id=>'back-to-browse'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Back to Browse'
,p_button_position=>'CREATE'
,p_button_redirect_url=>'f?p=&APP_ID.:96:&SESSION.::&DEBUG.:RP,96::'
,p_icon_css_classes=>'fa-arrow-left'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(1048217221948404513)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(1048217221948404489)
,p_button_name=>'OPEN_HISTORY'
,p_static_id=>'open-knowledge-history'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Version History and Audit'
,p_button_position=>'CREATE'
,p_button_redirect_url=>'f?p=&APP_ID.:99:&SESSION.::&DEBUG.:RP,99:P99_ITEM_ID:&P97_ITEM_ID.'
,p_button_condition=>'P97_ITEM_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_icon_css_classes=>'fa-history'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(1048217221948404512)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(1048217221948404489)
,p_button_name=>'OPEN_TEST_PUBLISH'
,p_static_id=>'open-test-publish'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Test and Publish'
,p_button_position=>'CREATE'
,p_button_redirect_url=>'f?p=&APP_ID.:98:&SESSION.::&DEBUG.:RP,98:P98_ITEM_ID,P98_REVISION_ID:&P97_ITEM_ID.,&P97_REVISION_ID.'
,p_button_condition=>'P97_REVISION_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_icon_css_classes=>'fa-flask'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(1048217221948404511)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(1048217221948404493)
,p_button_name=>'RETIRE_ITEM'
,p_static_id=>'retire-item'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--danger'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Retire Knowledge Item'
,p_button_position=>'CREATE'
,p_confirm_message=>'Retire this knowledge item and deactivate its current retrieval representation? Version and audit history will be retained.'
,p_confirm_style=>'danger'
,p_icon_css_classes=>'fa-archive'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(1048217221948404510)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(1048217221948404492)
,p_button_name=>'SAVE_DRAFT'
,p_static_id=>'save-draft'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save Draft'
,p_button_position=>'CREATE'
,p_icon_css_classes=>'fa-save'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1048217221948404504)
,p_name=>'P97_CAN_EDIT'
,p_item_sequence=>60
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1048217221948404505)
,p_name=>'P97_CAN_RETIRE'
,p_item_sequence=>70
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1048217221948404540)
,p_name=>'P97_CLOSE_IMPACT'
,p_is_required=>true
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_imp.id(1048217221948404492)
,p_prompt=>'Close Impact'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_colspan=>3
,p_display_when=>'P97_EDIT_MODE'
,p_display_when2=>'GOVERNED_SOURCE'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1048217221948404539)
,p_name=>'P97_CONDITION_TYPE'
,p_is_required=>true
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_imp.id(1048217221948404492)
,p_prompt=>'Condition Type'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_display_when=>'P97_EDIT_MODE'
,p_display_when2=>'GOVERNED_SOURCE'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1048217221948404523)
,p_name=>'P97_CONTENT'
,p_is_required=>true
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(1048217221948404492)
,p_prompt=>'Human-Readable Knowledge'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>80
,p_cHeight=>18
,p_colspan=>12
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'Y',
  'character_counter', 'Y',
  'resizable', 'Y',
  'trim_spaces', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1048217221948404542)
,p_name=>'P97_DISPLAY_SEQUENCE'
,p_is_required=>true
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_imp.id(1048217221948404492)
,p_prompt=>'Display Sequence'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_display_when=>'P97_EDIT_MODE'
,p_display_when2=>'GOVERNED_SOURCE'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1048217221948404520)
,p_name=>'P97_DOMAIN_NAME'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(1048217221948404492)
,p_prompt=>'Domain'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1048217221948404506)
,p_name=>'P97_EDIT_MODE'
,p_item_sequence=>80
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1048217221948404543)
,p_name=>'P97_ENABLED_FLAG'
,p_is_required=>true
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_imp.id(1048217221948404492)
,p_prompt=>'Enabled'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Yes;Y,No;N'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_display_when=>'P97_EDIT_MODE'
,p_display_when2=>'GOVERNED_SOURCE'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1048217221948404525)
,p_name=>'P97_IS_MANDATORY'
,p_is_required=>true
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(1048217221948404492)
,p_item_default=>'N'
,p_prompt=>'Mandatory'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:No;N,Yes;Y'
,p_cHeight=>1
,p_colspan=>3
,p_read_only_when=>'P97_EDIT_MODE'
,p_read_only_when2=>'GOVERNED_SOURCE'
,p_read_only_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1048217221948404499)
,p_name=>'P97_ITEM_ID'
,p_item_sequence=>10
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1048217221948404502)
,p_name=>'P97_ITEM_LOCK_VERSION'
,p_item_sequence=>40
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1048217221948404521)
,p_name=>'P97_KNOWLEDGE_TYPE'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(1048217221948404492)
,p_prompt=>'Knowledge Type'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1048217221948404524)
,p_name=>'P97_METADATA_JSON'
,p_item_sequence=>60
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1048217221948404500)
,p_name=>'P97_MODE'
,p_item_sequence=>20
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1048217221948404526)
,p_name=>'P97_PRIORITY'
,p_is_required=>true
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(1048217221948404492)
,p_item_default=>'50'
,p_prompt=>'Priority'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_read_only_when=>'P97_EDIT_MODE'
,p_read_only_when2=>'GOVERNED_SOURCE'
,p_read_only_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'right',
  'virtual_keyboard', 'text')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1048217221948404541)
,p_name=>'P97_PRIORITY_ELIGIBLE'
,p_is_required=>true
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_imp.id(1048217221948404492)
,p_prompt=>'Priority Eligible'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Yes;Y,No;N'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_display_when=>'P97_EDIT_MODE'
,p_display_when2=>'GOVERNED_SOURCE'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1048217221948404528)
,p_name=>'P97_QUESTION_SCOPE'
,p_is_required=>true
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(1048217221948404492)
,p_prompt=>'Question Scope'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_display_when=>'P97_EDIT_MODE'
,p_display_when2=>'GOVERNED_SOURCE'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1048217221948404501)
,p_name=>'P97_REVISION_ID'
,p_item_sequence=>30
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1048217221948404503)
,p_name=>'P97_REVISION_LOCK_VERSION'
,p_item_sequence=>50
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1048217221948404527)
,p_name=>'P97_RULE_CODE'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(1048217221948404492)
,p_prompt=>'Rule Code'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_colspan=>4
,p_display_when=>'P97_EDIT_MODE'
,p_display_when2=>'GOVERNED_SOURCE'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1048217221948404519)
,p_name=>'P97_SOURCE_KEY'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(1048217221948404492)
,p_prompt=>'Source Key'
,p_placeholder=>'Stable human-readable key'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>50
,p_colspan=>4
,p_read_only_when=>'P97_EDIT_MODE'
,p_read_only_when2=>'GOVERNED_SOURCE'
,p_read_only_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1048217221948404522)
,p_name=>'P97_TITLE'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(1048217221948404492)
,p_prompt=>'Title'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>80
,p_colspan=>12
,p_read_only_when=>'P97_EDIT_MODE'
,p_read_only_when2=>'GOVERNED_SOURCE'
,p_read_only_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(1048217221948404529)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load Knowledge Workspace'
,p_static_id=>'load-knowledge-workspace'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'    l_authorized boolean := false;',
'    l_edit_mode  xxme_ai_km_items.edit_mode%type;',
'    l_status     xxme_ai_km_items.lifecycle_status%type;',
'begin',
'    :P97_CAN_EDIT := ''N'';',
'    :P97_CAN_RETIRE := ''N'';',
'    if :P97_MODE = ''NEW'' then',
'        :P97_EDIT_MODE := ''DIRECT'';',
'        :P97_SOURCE_KEY := null;',
'        :P97_DOMAIN_NAME := ''MONTH_END'';',
'        :P97_KNOWLEDGE_TYPE := ''POLICY'';',
'        :P97_TITLE := null;',
'        :P97_CONTENT := null;',
'        :P97_METADATA_JSON := null;',
'        :P97_IS_MANDATORY := ''N'';',
'        :P97_PRIORITY := 50;',
'        if l_authorized then :P97_CAN_EDIT := ''Y''; end if;',
'        return;',
'    end if;',
'    if :P97_ITEM_ID is null then',
'        raise_application_error(-20120,''Knowledge item is required.'');',
'    end if;',
'    select i.source_key, i.source_locator, i.domain_name, i.knowledge_type, i.lock_version,',
'           i.edit_mode, i.lifecycle_status',
'      into :P97_SOURCE_KEY, :P97_RULE_CODE, :P97_DOMAIN_NAME, :P97_KNOWLEDGE_TYPE, :P97_ITEM_LOCK_VERSION,',
'           l_edit_mode, l_status',
'      from xxme_ai_km_items i',
'     where i.item_id = :P97_ITEM_ID;',
'    begin',
'        select revision_id, lock_version, title, content, metadata_json, is_mandatory, priority',
'          into :P97_REVISION_ID, :P97_REVISION_LOCK_VERSION, :P97_TITLE, :P97_CONTENT,',
'               :P97_METADATA_JSON, :P97_IS_MANDATORY, :P97_PRIORITY',
'          from (',
'              select r.*',
'                from xxme_ai_km_revisions r',
'               where r.item_id = :P97_ITEM_ID',
'                 and r.revision_state in (''DRAFT'',''FAILED'')',
'               order by r.version_no desc',
'          )',
'         where rownum = 1;',
'    exception',
'        when no_data_found then',
'            :P97_REVISION_ID := null;',
'            :P97_REVISION_LOCK_VERSION := null;',
'            select title, content, metadata_json, is_mandatory, priority',
'              into :P97_TITLE, :P97_CONTENT, :P97_METADATA_JSON, :P97_IS_MANDATORY, :P97_PRIORITY',
'              from xxme_ai_km_effective_v',
'             where item_id = :P97_ITEM_ID;',
'    end;',
'    :P97_EDIT_MODE := l_edit_mode;',
'    if l_edit_mode = ''GOVERNED_SOURCE'' then',
'        :P97_QUESTION_SCOPE := json_value(:P97_METADATA_JSON,''$.question_scope'' returning varchar2(30) null on error);',
'        :P97_CONDITION_TYPE := json_value(:P97_METADATA_JSON,''$.condition_type'' returning varchar2(60) null on error);',
'        :P97_CLOSE_IMPACT := json_value(:P97_METADATA_JSON,''$.close_impact'' returning varchar2(30) null on error);',
'        :P97_PRIORITY_ELIGIBLE := json_value(:P97_METADATA_JSON,''$.priority_eligible'' returning varchar2(1) null on error);',
'        :P97_DISPLAY_SEQUENCE := json_value(:P97_METADATA_JSON,''$.display_sequence'' returning number null on error);',
'        :P97_ENABLED_FLAG := json_value(:P97_METADATA_JSON,''$.enabled_flag'' returning varchar2(1) null on error);',
'    end if;',
'    if l_authorized and l_status = ''ACTIVE'' and l_edit_mode in (''DIRECT'',''GOVERNED_SOURCE'') then',
'        :P97_CAN_EDIT := ''Y'';',
'        if l_edit_mode = ''DIRECT'' then :P97_CAN_RETIRE := ''Y''; end if;',
'    end if;',
'end;',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>981170000000000740
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(1048217221948404531)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Retire Knowledge Item'
,p_static_id=>'retire-knowledge-item'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    raise_application_error(-20123,''AI administration is disabled pending App 400 role integration.'');',
'    xxme_ai_km_pkg.retire_item(',
'        p_item_id               => :P97_ITEM_ID,',
'        p_expected_lock_version => :P97_ITEM_LOCK_VERSION',
'    );',
'    commit;',
'    apex_application.g_print_success_message := ''Knowledge item retired; history is retained and active retrieval is disabled.'';',
'end;',
''))
,p_process_clob_language=>'PLSQL'
,p_process_when_button_id=>wwv_flow_imp.id(1048217221948404511)
,p_internal_uid=>981170000000000742
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(1048217221948404530)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save Knowledge Draft'
,p_static_id=>'save-knowledge-draft'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'    l_item_id     number;',
'    l_revision_id number;',
'    l_request_id  number;',
'    l_request_count number;',
'    l_metadata    clob;',
'    l_edit_mode   xxme_ai_km_items.edit_mode%type;',
'    l_status      xxme_ai_km_items.lifecycle_status%type;',
'begin',
'    raise_application_error(-20121,''AI administration is disabled pending App 400 role integration.'');',
'    if :P97_MODE = ''NEW'' then',
'        l_metadata := :P97_METADATA_JSON;',
'        xxme_ai_km_pkg.create_curated_item(',
'            p_source_key        => :P97_SOURCE_KEY,',
'            p_domain_name       => :P97_DOMAIN_NAME,',
'            p_knowledge_type    => :P97_KNOWLEDGE_TYPE,',
'            p_title             => :P97_TITLE,',
'            p_content           => :P97_CONTENT,',
'            p_metadata_json     => l_metadata,',
'            p_is_mandatory      => :P97_IS_MANDATORY,',
'            p_priority          => :P97_PRIORITY,',
'            p_overrides_item_id => null,',
'            p_item_id           => l_item_id,',
'            p_revision_id       => l_revision_id',
'        );',
'        :P97_ITEM_ID := l_item_id;',
'        :P97_REVISION_ID := l_revision_id;',
'        :P97_MODE := null;',
'    else',
'        select edit_mode, lifecycle_status into l_edit_mode, l_status',
'          from xxme_ai_km_items where item_id = :P97_ITEM_ID;',
'        if l_status <> ''ACTIVE'' or l_edit_mode not in (''DIRECT'',''GOVERNED_SOURCE'') then',
'            raise_application_error(-20122,''This knowledge source is read-only in Knowledge Manager.'');',
'        end if;',
'        if l_edit_mode = ''GOVERNED_SOURCE'' then',
'            l_metadata := json_object(',
'                ''rule_code'' value :P97_RULE_CODE,',
'                ''question_scope'' value :P97_QUESTION_SCOPE,',
'                ''condition_type'' value :P97_CONDITION_TYPE,',
'                ''close_impact'' value :P97_CLOSE_IMPACT,',
'                ''priority_eligible'' value :P97_PRIORITY_ELIGIBLE,',
'                ''display_sequence'' value to_number(:P97_DISPLAY_SEQUENCE),',
'                ''enabled_flag'' value :P97_ENABLED_FLAG returning clob);',
'        else',
'            l_metadata := :P97_METADATA_JSON;',
'        end if;',
'        if :P97_REVISION_ID is null then',
'            xxme_ai_km_pkg.create_draft(',
'                p_item_id               => :P97_ITEM_ID,',
'                p_expected_lock_version => :P97_ITEM_LOCK_VERSION,',
'                p_title                 => :P97_TITLE,',
'                p_content               => :P97_CONTENT,',
'                p_metadata_json         => l_metadata,',
'                p_is_mandatory          => :P97_IS_MANDATORY,',
'                p_priority              => :P97_PRIORITY,',
'                p_revision_id           => l_revision_id',
'            );',
'            :P97_REVISION_ID := l_revision_id;',
'        else',
'            xxme_ai_km_pkg.update_draft(',
'                p_revision_id            => :P97_REVISION_ID,',
'                p_expected_revision_lock => :P97_REVISION_LOCK_VERSION,',
'                p_title                  => :P97_TITLE,',
'                p_content                => :P97_CONTENT,',
'                p_metadata_json          => l_metadata,',
'                p_is_mandatory           => :P97_IS_MANDATORY,',
'                p_priority               => :P97_PRIORITY',
'            );',
'        end if;',
'        l_revision_id := :P97_REVISION_ID;',
'        if l_edit_mode = ''GOVERNED_SOURCE'' then',
'            select count(*) into l_request_count',
'              from xxme_ai_km_source_requests',
'             where candidate_revision_id = l_revision_id',
'               and request_state in (''SUBMITTED'',''APPROVED'',''APPLYING'',''SYNCED'');',
'            if l_request_count = 0 then',
'                xxme_ai_km_pkg.create_source_request(',
'                    p_item_id => :P97_ITEM_ID,',
'                    p_candidate_revision_id => l_revision_id,',
'                    p_idempotency_key => lower(rawtohex(sys_guid())),',
'                    p_requested_change => to_clob(''Structured Knowledge Manager update for Oracle rule ''||:P97_RULE_CODE),',
'                    p_request_id => l_request_id);',
'            end if;',
'        end if;',
'    end if;',
'    commit;',
'    apex_application.g_print_success_message := ''Draft saved. Validate, test, and publish it through the governed activation workflow.'';',
'end;',
''))
,p_process_clob_language=>'PLSQL'
,p_process_when_button_id=>wwv_flow_imp.id(1048217221948404510)
,p_internal_uid=>981170000000000741
);
wwv_flow_imp.component_end;
end;
/
