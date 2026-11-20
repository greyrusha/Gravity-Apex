prompt --application/pages/page_00098
begin
--   Manifest
--     PAGE: 00098
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
 p_id=>98
,p_name=>'Knowledge Test and Publish'
,p_alias=>'KNOWLEDGE-TEST-PUBLISH'
,p_step_title=>'Knowledge Test and Publish'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>4075783602716660119
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(18558063129193156)
,p_required_patch=>wwv_flow_imp.id(1026514276929100661)
,p_protection_level=>'C'
,p_page_component_map=>'03'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1078217221948404790)
,p_plug_name=>'Candidate Readiness'
,p_static_id=>'km-candidate-readiness'
,p_title=>'Candidate Readiness'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="t-Alert t-Alert--info t-Alert--horizontal"><div class="t-Alert-wrap">',
'<div class="t-Alert-icon"><span class="t-Icon fa fa-flask" aria-hidden="true"></span></div>',
'<div class="t-Alert-content">Prepare and test the human-readable candidate before publication. Vectors are never displayed. The currently published revision remains active until publication succeeds.</div>',
'</div></div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(1078217221948404799)
,p_name=>'Candidate Summary'
,p_static_id=>'km-candidate-summary'
,p_title=>'Candidate Summary'
,p_template=>2103954283454391425
,p_display_sequence=>20
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select r.version_no, r.title, r.revision_state, r.validation_status,',
'       r.validation_message, r.is_mandatory, r.priority,',
'       s.source_name, i.edit_mode,',
'       (select count(*) from xxme_ai_km_chunks c where c.revision_id=r.revision_id) chunk_count,',
'       (select count(*) from xxme_ai_km_tests t where t.revision_id=r.revision_id and t.is_required=''Y'' and t.test_status=''PASSED'') required_passed,',
'       (select count(*) from xxme_ai_km_tests t where t.revision_id=r.revision_id and t.is_required=''Y'' and t.test_status=''FAILED'') required_failed',
'  from xxme_ai_km_revisions r',
'  join xxme_ai_km_items i on i.item_id=r.item_id',
'  join xxme_ai_km_sources s on s.source_id=i.source_id',
' where r.revision_id=:P98_REVISION_ID',
'   and r.item_id=:P98_ITEM_ID'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P98_ITEM_ID,P98_REVISION_ID'
,p_lazy_loading=>false
,p_query_row_template=>2542081983073888486
,p_query_num_rows=>5
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'SHOW_ALL'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1078217221948404809)
,p_query_column_id=>10
,p_column_alias=>'CHUNK_COUNT'
,p_column_display_sequence=>100
,p_column_heading=>'Chunks'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1078217221948404808)
,p_query_column_id=>9
,p_column_alias=>'EDIT_MODE'
,p_column_display_sequence=>90
,p_column_heading=>'Edit Mode'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1078217221948404805)
,p_query_column_id=>6
,p_column_alias=>'IS_MANDATORY'
,p_column_display_sequence=>60
,p_column_heading=>'Mandatory'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1078217221948404806)
,p_query_column_id=>7
,p_column_alias=>'PRIORITY'
,p_column_display_sequence=>70
,p_column_heading=>'Priority'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1078217221948404811)
,p_query_column_id=>12
,p_column_alias=>'REQUIRED_FAILED'
,p_column_display_sequence=>120
,p_column_heading=>'Required Failed'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1078217221948404810)
,p_query_column_id=>11
,p_column_alias=>'REQUIRED_PASSED'
,p_column_display_sequence=>110
,p_column_heading=>'Required Passed'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1078217221948404802)
,p_query_column_id=>3
,p_column_alias=>'REVISION_STATE'
,p_column_display_sequence=>30
,p_column_heading=>'State'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1078217221948404807)
,p_query_column_id=>8
,p_column_alias=>'SOURCE_NAME'
,p_column_display_sequence=>80
,p_column_heading=>'Source'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1078217221948404801)
,p_query_column_id=>2
,p_column_alias=>'TITLE'
,p_column_display_sequence=>20
,p_column_heading=>'Title'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1078217221948404804)
,p_query_column_id=>5
,p_column_alias=>'VALIDATION_MESSAGE'
,p_column_display_sequence=>50
,p_column_heading=>'Validation Message'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1078217221948404803)
,p_query_column_id=>4
,p_column_alias=>'VALIDATION_STATUS'
,p_column_display_sequence=>40
,p_column_heading=>'Validation'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1078217221948404800)
,p_query_column_id=>1
,p_column_alias=>'VERSION_NO'
,p_column_display_sequence=>10
,p_column_heading=>'Version'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(1078217221948404839)
,p_name=>'Persisted Test Evidence'
,p_static_id=>'km-persisted-test-evidence'
,p_title=>'Persisted Test Evidence'
,p_template=>2103954283454391425
,p_display_sequence=>50
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select test_id, dbms_lob.substr(question,1000,1) question,',
'       expected_text, is_required, test_status, top_k,',
'       json_value(result_json,''$[0].title'' returning varchar2(500) null on error) top_result_title,',
'       json_value(result_json,''$[0].content'' returning varchar2(1000) null on error) top_result_content,',
'       json_value(result_json,''$[0].similarity'' returning number null on error) top_similarity,',
'       error_message, run_by, run_on',
'  from xxme_ai_km_tests',
' where revision_id=:P98_REVISION_ID',
' order by run_on desc, test_id desc'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P98_REVISION_ID'
,p_lazy_loading=>false
,p_query_row_template=>2542081983073888486
,p_query_num_rows=>50
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'SHOW_ALL'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1078217221948404849)
,p_query_column_id=>10
,p_column_alias=>'ERROR_MESSAGE'
,p_column_display_sequence=>100
,p_column_heading=>'Error'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1078217221948404842)
,p_query_column_id=>3
,p_column_alias=>'EXPECTED_TEXT'
,p_column_display_sequence=>30
,p_column_heading=>'Expected Outcome'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1078217221948404843)
,p_query_column_id=>4
,p_column_alias=>'IS_REQUIRED'
,p_column_display_sequence=>40
,p_column_heading=>'Required'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1078217221948404841)
,p_query_column_id=>2
,p_column_alias=>'QUESTION'
,p_column_display_sequence=>20
,p_column_heading=>'Question'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1078217221948404850)
,p_query_column_id=>11
,p_column_alias=>'RUN_BY'
,p_column_display_sequence=>110
,p_column_heading=>'Run By'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1078217221948404851)
,p_query_column_id=>12
,p_column_alias=>'RUN_ON'
,p_column_display_sequence=>120
,p_column_heading=>'Run On'
,p_column_format=>'DD-MON-YYYY HH24:MI:SS'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1078217221948404840)
,p_query_column_id=>1
,p_column_alias=>'TEST_ID'
,p_column_display_sequence=>10
,p_column_heading=>'Test'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1078217221948404844)
,p_query_column_id=>5
,p_column_alias=>'TEST_STATUS'
,p_column_display_sequence=>50
,p_column_heading=>'Result'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1078217221948404845)
,p_query_column_id=>6
,p_column_alias=>'TOP_K'
,p_column_display_sequence=>60
,p_column_heading=>'Top K'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1078217221948404847)
,p_query_column_id=>8
,p_column_alias=>'TOP_RESULT_CONTENT'
,p_column_display_sequence=>80
,p_column_heading=>'Top Result Content'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1078217221948404846)
,p_query_column_id=>7
,p_column_alias=>'TOP_RESULT_TITLE'
,p_column_display_sequence=>70
,p_column_heading=>'Top Result'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1078217221948404848)
,p_query_column_id=>9
,p_column_alias=>'TOP_SIMILARITY'
,p_column_display_sequence=>90
,p_column_heading=>'Similarity'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(1078217221948404819)
,p_name=>'Readable Candidate Chunks'
,p_static_id=>'km-readable-candidate-chunks'
,p_title=>'Readable Candidate Chunks'
,p_template=>2103954283454391425
,p_display_sequence=>30
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select chunk_no, chunk_title, dbms_lob.substr(chunk_content,3200,1) chunk_content,',
'       activation_status, embedding_model, embedded_on, validation_message',
'  from xxme_ai_km_chunks',
' where revision_id=:P98_REVISION_ID',
' order by chunk_no'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P98_REVISION_ID'
,p_lazy_loading=>false
,p_query_row_template=>2542081983073888486
,p_query_num_rows=>50
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'SHOW_ALL'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1078217221948404823)
,p_query_column_id=>4
,p_column_alias=>'ACTIVATION_STATUS'
,p_column_display_sequence=>40
,p_column_heading=>'Status'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1078217221948404822)
,p_query_column_id=>3
,p_column_alias=>'CHUNK_CONTENT'
,p_column_display_sequence=>30
,p_column_heading=>'Human-readable Content'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1078217221948404820)
,p_query_column_id=>1
,p_column_alias=>'CHUNK_NO'
,p_column_display_sequence=>10
,p_column_heading=>'Chunk'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1078217221948404821)
,p_query_column_id=>2
,p_column_alias=>'CHUNK_TITLE'
,p_column_display_sequence=>20
,p_column_heading=>'Title'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1078217221948404825)
,p_query_column_id=>6
,p_column_alias=>'EMBEDDED_ON'
,p_column_display_sequence=>60
,p_column_heading=>'Embedded On'
,p_column_format=>'DD-MON-YYYY HH24:MI'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1078217221948404824)
,p_query_column_id=>5
,p_column_alias=>'EMBEDDING_MODEL'
,p_column_display_sequence=>50
,p_column_heading=>'Embedding Model'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1078217221948404826)
,p_query_column_id=>7
,p_column_alias=>'VALIDATION_MESSAGE'
,p_column_display_sequence=>70
,p_column_heading=>'Message'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1078217221948404829)
,p_plug_name=>'Run Representative Test'
,p_static_id=>'km-run-representative-test'
,p_title=>'Run Representative Test'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>40
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>'<p>Ask a representative question and record the expected human-readable outcome. Required tests gate publication.</p>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(1078217221948404890)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(1078217221948404790)
,p_button_name=>'PREPARE_CANDIDATE'
,p_static_id=>'prepare-km-candidate'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Prepare Candidate'
,p_button_position=>'CREATE'
,p_icon_css_classes=>'fa-cogs'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(1078217221948404892)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(1078217221948404790)
,p_button_name=>'PUBLISH_REVISION'
,p_static_id=>'publish-km-revision'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--success'
,p_button_template_id=>4075790603270660137
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Publish Revision'
,p_button_position=>'CREATE'
,p_confirm_message=>'Publish this tested revision and atomically replace the active retrieval representation?'
,p_confirm_style=>'warning'
,p_icon_css_classes=>'fa-check'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(1078217221948404891)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(1078217221948404829)
,p_button_name=>'RUN_TEST'
,p_static_id=>'run-km-test'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Run and Save Test'
,p_button_position=>'CREATE'
,p_icon_css_classes=>'fa-play'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1078217221948404903)
,p_name=>'P98_EXPECTED_TEXT'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(1078217221948404829)
,p_prompt=>'Expected Human-readable Outcome'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>80
,p_cMaxlength=>1000
,p_cHeight=>4
,p_field_template=>wwv_flow_imp.id(1672985690212569356)
,p_item_template_options=>'#DEFAULT#'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1078217221948404904)
,p_name=>'P98_IS_REQUIRED'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(1078217221948404829)
,p_item_default=>'Y'
,p_prompt=>'Publication Gate'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Required;Y,Informational;N'
,p_cHeight=>1
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(1672985690212569356)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1078217221948404900)
,p_name=>'P98_ITEM_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(1078217221948404790)
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1078217221948404902)
,p_name=>'P98_QUESTION'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(1078217221948404829)
,p_prompt=>'Representative Question'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>80
,p_cHeight=>4
,p_field_template=>wwv_flow_imp.id(1672985690212569356)
,p_item_template_options=>'#DEFAULT#'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1078217221948404901)
,p_name=>'P98_REVISION_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(1078217221948404790)
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1078217221948404905)
,p_name=>'P98_TOP_K'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(1078217221948404829)
,p_item_default=>'5'
,p_prompt=>'Top Results'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>5
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(1672985690212569356)
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'right',
  'virtual_keyboard', 'numeric')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(1078217221948404990)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Prepare Knowledge Candidate'
,p_static_id=>'prepare-knowledge-candidate'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare l_count number;',
'begin',
'  raise_application_error(-20200,''AI administration is disabled pending App 400 role integration.'');',
'  select count(*) into l_count from xxme_ai_km_revisions where revision_id=:P98_REVISION_ID and item_id=:P98_ITEM_ID;',
'  if l_count<>1 then raise_application_error(-20205,''The selected revision does not belong to this knowledge item.''); end if;',
'  xxme_ai_km_pkg.prepare_revision(:P98_REVISION_ID);',
'  commit;',
'  apex_application.g_print_success_message:=''Candidate validated, chunked, and embedded.'';',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_process_when_button_id=>wwv_flow_imp.id(1078217221948404890)
,p_internal_uid=>1014353499250103268
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(1078217221948404992)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Publish Tested Knowledge Revision'
,p_static_id=>'publish-tested-knowledge-revision'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare l_count number;',
'begin',
'  raise_application_error(-20204,''AI administration is disabled pending App 400 role integration.'');',
'  select count(*) into l_count from xxme_ai_km_revisions where revision_id=:P98_REVISION_ID and item_id=:P98_ITEM_ID;',
'  if l_count<>1 then raise_application_error(-20205,''The selected revision does not belong to this knowledge item.''); end if;',
'  xxme_ai_km_pkg.publish_revision(:P98_REVISION_ID);',
'  commit;',
'  apex_application.g_print_success_message:=''Knowledge revision published and activated.'';',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_process_when_button_id=>wwv_flow_imp.id(1078217221948404892)
,p_internal_uid=>1014353499250103270
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(1078217221948404991)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Run Persisted Knowledge Test'
,p_static_id=>'run-persisted-knowledge-test'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare l_test_id number; l_count number;',
'begin',
'  raise_application_error(-20201,''AI administration is disabled pending App 400 role integration.'');',
'  select count(*) into l_count from xxme_ai_km_revisions where revision_id=:P98_REVISION_ID and item_id=:P98_ITEM_ID;',
'  if l_count<>1 then raise_application_error(-20205,''The selected revision does not belong to this knowledge item.''); end if;',
'  if :P98_QUESTION is null or :P98_EXPECTED_TEXT is null then raise_application_error(-20202,''Question and expected outcome are required.''); end if;',
'  if to_number(:P98_TOP_K default null on conversion error) not between 1 and 12 then raise_application_error(-20203,''Top Results must be from 1 through 12.''); end if;',
'  xxme_ai_km_pkg.run_revision_test(',
'    p_revision_id=>:P98_REVISION_ID, p_question=>:P98_QUESTION,',
'    p_expected_text=>:P98_EXPECTED_TEXT, p_is_required=>:P98_IS_REQUIRED,',
'    p_top_k=>to_number(:P98_TOP_K), p_test_id=>l_test_id);',
'  commit;',
'  apex_application.g_print_success_message:=''Test ''||l_test_id||'' completed and saved.'';',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_process_when_button_id=>wwv_flow_imp.id(1078217221948404891)
,p_internal_uid=>1014353499250103269
);
wwv_flow_imp.component_end;
end;
/
