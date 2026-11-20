prompt --application/pages/page_00099
begin
--   Manifest
--     PAGE: 00099
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
 p_id=>99
,p_name=>'Knowledge History and Source Requests'
,p_alias=>'KNOWLEDGE-HISTORY-SOURCE-REQUESTS'
,p_step_title=>'Knowledge History and Source Requests'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>4075783602716660119
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(18558063129193156)
,p_required_patch=>wwv_flow_imp.id(1026514276929100661)
,p_protection_level=>'C'
,p_page_component_map=>'03'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(1088217221948404859)
,p_name=>'Audit Timeline'
,p_static_id=>'km-audit-timeline'
,p_title=>'Audit Timeline'
,p_template=>2103954283454391425
,p_display_sequence=>50
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select e.event_type, r.version_no, e.from_state, e.to_state, e.event_by, e.event_on',
'  from xxme_ai_km_events e',
'  left join xxme_ai_km_revisions r on r.revision_id=e.revision_id',
' where e.item_id=:P99_ITEM_ID',
' order by e.event_on desc, e.event_id desc'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P99_ITEM_ID'
,p_lazy_loading=>false
,p_query_row_template=>2542081983073888486
,p_query_num_rows=>100
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'SHOW_ALL'
,p_csv_output=>'Y'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404864)
,p_query_column_id=>5
,p_column_alias=>'EVENT_BY'
,p_column_display_sequence=>50
,p_column_heading=>'By'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404865)
,p_query_column_id=>6
,p_column_alias=>'EVENT_ON'
,p_column_display_sequence=>60
,p_column_heading=>'On'
,p_column_format=>'DD-MON-YYYY HH24:MI:SS'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404860)
,p_query_column_id=>1
,p_column_alias=>'EVENT_TYPE'
,p_column_display_sequence=>10
,p_column_heading=>'Event'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404862)
,p_query_column_id=>3
,p_column_alias=>'FROM_STATE'
,p_column_display_sequence=>30
,p_column_heading=>'From'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404863)
,p_query_column_id=>4
,p_column_alias=>'TO_STATE'
,p_column_display_sequence=>40
,p_column_heading=>'To'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404861)
,p_query_column_id=>2
,p_column_alias=>'VERSION_NO'
,p_column_display_sequence=>20
,p_column_heading=>'Version'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1088217221948404790)
,p_plug_name=>'History Actions'
,p_static_id=>'km-history-actions'
,p_title=>'History Actions'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="t-Alert t-Alert--info t-Alert--horizontal"><div class="t-Alert-wrap">',
'<div class="t-Alert-icon"><span class="t-Icon fa fa-history" aria-hidden="true"></span></div>',
'<div class="t-Alert-content">History is immutable. Rollback creates a new draft. Oracle rule requests use the approved source adapter; APEX tool definitions remain read-only here.</div>',
'</div></div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(1088217221948404819)
,p_name=>'Persisted Test Evidence'
,p_static_id=>'km-history-tests'
,p_title=>'Persisted Test Evidence'
,p_template=>2103954283454391425
,p_display_sequence=>30
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select t.test_id, r.version_no, dbms_lob.substr(t.question,1000,1) question,',
'       t.expected_text, t.is_required, t.test_status, t.top_k,',
'       json_value(t.result_json,''$[0].title'' returning varchar2(500) null on error) top_result_title,',
'       json_value(t.result_json,''$[0].content'' returning varchar2(1000) null on error) top_result_content,',
'       json_value(t.result_json,''$[0].similarity'' returning number null on error) top_similarity,',
'       t.error_message, t.run_by, t.run_on',
'  from xxme_ai_km_tests t',
'  join xxme_ai_km_revisions r on r.revision_id=t.revision_id',
' where r.item_id=:P99_ITEM_ID',
' order by t.run_on desc, t.test_id desc'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P99_ITEM_ID'
,p_lazy_loading=>false
,p_query_row_template=>2542081983073888486
,p_query_num_rows=>100
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'SHOW_ALL'
,p_csv_output=>'Y'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404830)
,p_query_column_id=>11
,p_column_alias=>'ERROR_MESSAGE'
,p_column_display_sequence=>110
,p_column_heading=>'Error'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404823)
,p_query_column_id=>4
,p_column_alias=>'EXPECTED_TEXT'
,p_column_display_sequence=>40
,p_column_heading=>'Expected Outcome'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404824)
,p_query_column_id=>5
,p_column_alias=>'IS_REQUIRED'
,p_column_display_sequence=>50
,p_column_heading=>'Required'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404822)
,p_query_column_id=>3
,p_column_alias=>'QUESTION'
,p_column_display_sequence=>30
,p_column_heading=>'Question'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404831)
,p_query_column_id=>12
,p_column_alias=>'RUN_BY'
,p_column_display_sequence=>120
,p_column_heading=>'Run By'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404832)
,p_query_column_id=>13
,p_column_alias=>'RUN_ON'
,p_column_display_sequence=>130
,p_column_heading=>'Run On'
,p_column_format=>'DD-MON-YYYY HH24:MI:SS'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404820)
,p_query_column_id=>1
,p_column_alias=>'TEST_ID'
,p_column_display_sequence=>10
,p_column_heading=>'Test'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404825)
,p_query_column_id=>6
,p_column_alias=>'TEST_STATUS'
,p_column_display_sequence=>60
,p_column_heading=>'Result'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404826)
,p_query_column_id=>7
,p_column_alias=>'TOP_K'
,p_column_display_sequence=>70
,p_column_heading=>'Top K'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404828)
,p_query_column_id=>9
,p_column_alias=>'TOP_RESULT_CONTENT'
,p_column_display_sequence=>90
,p_column_heading=>'Top Result Content'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404827)
,p_query_column_id=>8
,p_column_alias=>'TOP_RESULT_TITLE'
,p_column_display_sequence=>80
,p_column_heading=>'Top Result'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404829)
,p_query_column_id=>10
,p_column_alias=>'TOP_SIMILARITY'
,p_column_display_sequence=>100
,p_column_heading=>'Similarity'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404821)
,p_query_column_id=>2
,p_column_alias=>'VERSION_NO'
,p_column_display_sequence=>20
,p_column_heading=>'Version'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(1088217221948404799)
,p_name=>'Revision History'
,p_static_id=>'km-revision-history'
,p_title=>'Revision History'
,p_template=>2103954283454391425
,p_display_sequence=>20
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select revision_id, version_no, revision_state, title, is_mandatory, priority,',
'       validation_status, validation_message, source_version, source_synced_on,',
'       created_by, created_on, published_by, published_on, rollback_of_revision_id',
'  from xxme_ai_km_revisions',
' where item_id=:P99_ITEM_ID',
' order by version_no desc'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P99_ITEM_ID'
,p_lazy_loading=>false
,p_query_row_template=>2542081983073888486
,p_query_num_rows=>100
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'SHOW_ALL'
,p_csv_output=>'Y'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404810)
,p_query_column_id=>11
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>110
,p_column_heading=>'Created By'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404811)
,p_query_column_id=>12
,p_column_alias=>'CREATED_ON'
,p_column_display_sequence=>120
,p_column_heading=>'Created On'
,p_column_format=>'DD-MON-YYYY HH24:MI'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404804)
,p_query_column_id=>5
,p_column_alias=>'IS_MANDATORY'
,p_column_display_sequence=>50
,p_column_heading=>'Mandatory'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404805)
,p_query_column_id=>6
,p_column_alias=>'PRIORITY'
,p_column_display_sequence=>60
,p_column_heading=>'Priority'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404812)
,p_query_column_id=>13
,p_column_alias=>'PUBLISHED_BY'
,p_column_display_sequence=>130
,p_column_heading=>'Published By'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404813)
,p_query_column_id=>14
,p_column_alias=>'PUBLISHED_ON'
,p_column_display_sequence=>140
,p_column_heading=>'Published On'
,p_column_format=>'DD-MON-YYYY HH24:MI'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404800)
,p_query_column_id=>1
,p_column_alias=>'REVISION_ID'
,p_column_display_sequence=>10
,p_column_heading=>'Revision'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404802)
,p_query_column_id=>3
,p_column_alias=>'REVISION_STATE'
,p_column_display_sequence=>30
,p_column_heading=>'State'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404814)
,p_query_column_id=>15
,p_column_alias=>'ROLLBACK_OF_REVISION_ID'
,p_column_display_sequence=>150
,p_column_heading=>'Rollback Source'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404809)
,p_query_column_id=>10
,p_column_alias=>'SOURCE_SYNCED_ON'
,p_column_display_sequence=>100
,p_column_heading=>'Source Synced'
,p_column_format=>'DD-MON-YYYY HH24:MI'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404808)
,p_query_column_id=>9
,p_column_alias=>'SOURCE_VERSION'
,p_column_display_sequence=>90
,p_column_heading=>'Source Version'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404803)
,p_query_column_id=>4
,p_column_alias=>'TITLE'
,p_column_display_sequence=>40
,p_column_heading=>'Title'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404807)
,p_query_column_id=>8
,p_column_alias=>'VALIDATION_MESSAGE'
,p_column_display_sequence=>80
,p_column_heading=>'Message'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404806)
,p_query_column_id=>7
,p_column_alias=>'VALIDATION_STATUS'
,p_column_display_sequence=>70
,p_column_heading=>'Validation'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404801)
,p_query_column_id=>2
,p_column_alias=>'VERSION_NO'
,p_column_display_sequence=>20
,p_column_heading=>'Version'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(1088217221948404839)
,p_name=>'Source Requests'
,p_static_id=>'km-source-requests'
,p_title=>'Source Requests'
,p_template=>2103954283454391425
,p_display_sequence=>40
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select q.request_id, r.version_no candidate_version, s.source_name, s.source_code,',
'       q.request_state, dbms_lob.substr(q.requested_change,2000,1) requested_change,',
'       q.requested_by, q.requested_on, q.approved_by, q.approved_on,',
'       q.applied_on, q.synced_on, q.error_message,',
'       case when s.source_code=''APEX_TOOL_CONTRACT'' then ''Read-only: update through the APEX tool definition/export workflow''',
'            when s.source_code=''MONTH_END_RULES'' then ''Approved Oracle source adapter''',
'            else ''No in-page source adapter'' end workflow',
'  from xxme_ai_km_source_requests q',
'  join xxme_ai_km_revisions r on r.revision_id=q.candidate_revision_id',
'  join xxme_ai_km_items i on i.item_id=q.item_id',
'  join xxme_ai_km_sources s on s.source_id=i.source_id',
' where q.item_id=:P99_ITEM_ID',
' order by q.requested_on desc, q.request_id desc'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P99_ITEM_ID'
,p_lazy_loading=>false
,p_query_row_template=>2542081983073888486
,p_query_num_rows=>100
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'SHOW_ALL'
,p_csv_output=>'Y'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404850)
,p_query_column_id=>11
,p_column_alias=>'APPLIED_ON'
,p_column_display_sequence=>110
,p_column_heading=>'Applied On'
,p_column_format=>'DD-MON-YYYY HH24:MI'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404848)
,p_query_column_id=>9
,p_column_alias=>'APPROVED_BY'
,p_column_display_sequence=>90
,p_column_heading=>'Approved By'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404849)
,p_query_column_id=>10
,p_column_alias=>'APPROVED_ON'
,p_column_display_sequence=>100
,p_column_heading=>'Approved On'
,p_column_format=>'DD-MON-YYYY HH24:MI'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404841)
,p_query_column_id=>2
,p_column_alias=>'CANDIDATE_VERSION'
,p_column_display_sequence=>20
,p_column_heading=>'Candidate Version'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404852)
,p_query_column_id=>13
,p_column_alias=>'ERROR_MESSAGE'
,p_column_display_sequence=>130
,p_column_heading=>'Error'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404846)
,p_query_column_id=>7
,p_column_alias=>'REQUESTED_BY'
,p_column_display_sequence=>70
,p_column_heading=>'Requested By'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404845)
,p_query_column_id=>6
,p_column_alias=>'REQUESTED_CHANGE'
,p_column_display_sequence=>60
,p_column_heading=>'Requested Change'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404847)
,p_query_column_id=>8
,p_column_alias=>'REQUESTED_ON'
,p_column_display_sequence=>80
,p_column_heading=>'Requested On'
,p_column_format=>'DD-MON-YYYY HH24:MI'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404840)
,p_query_column_id=>1
,p_column_alias=>'REQUEST_ID'
,p_column_display_sequence=>10
,p_column_heading=>'Request'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404844)
,p_query_column_id=>5
,p_column_alias=>'REQUEST_STATE'
,p_column_display_sequence=>50
,p_column_heading=>'State'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404843)
,p_query_column_id=>4
,p_column_alias=>'SOURCE_CODE'
,p_column_display_sequence=>40
,p_column_heading=>'Source Code'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404842)
,p_query_column_id=>3
,p_column_alias=>'SOURCE_NAME'
,p_column_display_sequence=>30
,p_column_heading=>'Source'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404851)
,p_query_column_id=>12
,p_column_alias=>'SYNCED_ON'
,p_column_display_sequence=>120
,p_column_heading=>'Synced On'
,p_column_format=>'DD-MON-YYYY HH24:MI'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1088217221948404853)
,p_query_column_id=>14
,p_column_alias=>'WORKFLOW'
,p_column_display_sequence=>140
,p_column_heading=>'Workflow'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(1088217221948404902)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(1088217221948404790)
,p_button_name=>'APPLY_ORACLE_REQUEST'
,p_static_id=>'apply-km-oracle-request'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--success'
,p_button_template_id=>4075790603270660137
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply and Synchronize Oracle Rule'
,p_button_position=>'CREATE'
,p_confirm_message=>'Apply this approved change to the authoritative Oracle rule source and synchronize the candidate?'
,p_confirm_style=>'warning'
,p_icon_css_classes=>'fa-database'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(1088217221948404901)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(1088217221948404790)
,p_button_name=>'APPROVE_SOURCE_REQUEST'
,p_static_id=>'approve-km-source-request'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Approve Source Request'
,p_button_position=>'CREATE'
,p_icon_css_classes=>'fa-thumbs-up'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(1088217221948404900)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(1088217221948404790)
,p_button_name=>'CREATE_ROLLBACK_DRAFT'
,p_static_id=>'create-km-rollback-draft'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Create Rollback Draft'
,p_button_position=>'CREATE'
,p_icon_css_classes=>'fa-undo'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(1088217221948404903)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(1088217221948404790)
,p_button_name=>'RETIRE_DIRECT_ITEM'
,p_static_id=>'retire-km-direct-item'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--danger'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Retire Direct Knowledge'
,p_button_position=>'CREATE'
,p_confirm_message=>'Retire this directly managed knowledge item and deactivate its retrieval representation?'
,p_confirm_style=>'danger'
,p_icon_css_classes=>'fa-archive'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1088217221948404890)
,p_name=>'P99_ITEM_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(1088217221948404790)
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1088217221948404891)
,p_name=>'P99_ITEM_LOCK_VERSION'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(1088217221948404790)
,p_source=>'select lock_version from xxme_ai_km_items where item_id=:P99_ITEM_ID'
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1088217221948404893)
,p_name=>'P99_REQUEST_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(1088217221948404790)
,p_prompt=>'Source Request'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''Request ''||q.request_id||'' - ''||q.request_state||'' - ''||s.source_name d, q.request_id r',
'  from xxme_ai_km_source_requests q join xxme_ai_km_items i on i.item_id=q.item_id join xxme_ai_km_sources s on s.source_id=i.source_id',
' where q.item_id=:P99_ITEM_ID order by q.request_id desc'))
,p_lov_cascade_parent_items=>'P99_ITEM_ID'
,p_ajax_items_to_submit=>'P99_ITEM_ID'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>wwv_flow_imp.id(1672985690212569356)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1088217221948404892)
,p_name=>'P99_REVISION_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(1088217221948404790)
,p_prompt=>'Historical Revision'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''Version ''||version_no||'' - ''||title d, revision_id r',
'  from xxme_ai_km_revisions where item_id=:P99_ITEM_ID order by version_no desc'))
,p_lov_cascade_parent_items=>'P99_ITEM_ID'
,p_ajax_items_to_submit=>'P99_ITEM_ID'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_colspan=>4
,p_field_template=>wwv_flow_imp.id(1672985690212569356)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(1088217221948404992)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Apply Oracle Rule Request'
,p_static_id=>'apply-oracle-rule-request'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare l_count number;',
'begin',
'  raise_application_error(-20214,''AI administration is disabled pending App 400 role integration.'');',
'  select count(*) into l_count from xxme_ai_km_source_requests q join xxme_ai_km_items i on i.item_id=q.item_id join xxme_ai_km_sources s on s.source_id=i.source_id where q.request_id=:P99_REQUEST_ID and q.item_id=:P99_ITEM_ID and q.request_state=''AP'
||'PROVED'' and s.source_code=''MONTH_END_RULES'';',
'  if l_count<>1 then raise_application_error(-20215,''Only an approved Oracle month-end rule request can be applied here. APEX tool definitions are read-only.''); end if;',
'  xxme_ai_km_pkg.apply_month_end_rule_request(:P99_REQUEST_ID);',
'  commit;',
'  apex_application.g_print_success_message:=''Authoritative Oracle rule updated and candidate synchronized.'';',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_process_when_button_id=>wwv_flow_imp.id(1088217221948404902)
,p_internal_uid=>1024353499250103270
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(1088217221948404991)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Approve Source Request'
,p_static_id=>'approve-source-request'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare l_count number;',
'begin',
'  raise_application_error(-20212,''AI administration is disabled pending App 400 role integration.'');',
'  if :P99_REQUEST_ID is null then raise_application_error(-20213,''Select a source request.''); end if;',
'  select count(*) into l_count from xxme_ai_km_source_requests q join xxme_ai_km_items i on i.item_id=q.item_id join xxme_ai_km_sources s on s.source_id=i.source_id where q.request_id=:P99_REQUEST_ID and q.item_id=:P99_ITEM_ID and q.request_state=''SU'
||'BMITTED'' and s.source_code=''MONTH_END_RULES'';',
'  if l_count<>1 then raise_application_error(-20219,''Only a submitted Oracle month-end rule request can be approved here. APEX tool definitions are read-only.''); end if;',
'  xxme_ai_km_pkg.approve_source_request(:P99_REQUEST_ID);',
'  commit;',
'  apex_application.g_print_success_message:=''Source request approved.'';',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_process_when_button_id=>wwv_flow_imp.id(1088217221948404901)
,p_internal_uid=>1024353499250103269
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(1088217221948404990)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Create Rollback Draft'
,p_static_id=>'create-rollback-draft'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare l_revision_id number; l_count number;',
'begin',
'  raise_application_error(-20210,''AI administration is disabled pending App 400 role integration.'');',
'  if :P99_REVISION_ID is null then raise_application_error(-20211,''Select a historical revision.''); end if;',
'  select count(*) into l_count from xxme_ai_km_items where item_id=:P99_ITEM_ID and edit_mode in (''DIRECT'',''GOVERNED_SOURCE'');',
'  if l_count<>1 then raise_application_error(-20218,''This source is read-only in Knowledge Manager; use its governed source workflow.''); end if;',
'  xxme_ai_km_pkg.create_rollback_draft(:P99_ITEM_ID,:P99_REVISION_ID,:P99_ITEM_LOCK_VERSION,l_revision_id);',
'  commit;',
'  apex_application.g_print_success_message:=''Rollback draft ''||l_revision_id||'' created. It must be prepared, tested, and published.'';',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_process_when_button_id=>wwv_flow_imp.id(1088217221948404900)
,p_internal_uid=>1024353499250103268
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(1088217221948404993)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Retire Direct Knowledge'
,p_static_id=>'retire-direct-knowledge'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare l_count number;',
'begin',
'  raise_application_error(-20216,''AI administration is disabled pending App 400 role integration.'');',
'  select count(*) into l_count from xxme_ai_km_items where item_id=:P99_ITEM_ID and edit_mode=''DIRECT'' and lifecycle_status=''ACTIVE'';',
'  if l_count<>1 then raise_application_error(-20217,''Only active directly managed knowledge can be retired here.''); end if;',
'  xxme_ai_km_pkg.retire_item(:P99_ITEM_ID,:P99_ITEM_LOCK_VERSION);',
'  commit;',
'  apex_application.g_print_success_message:=''Knowledge item retired.'';',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_process_when_button_id=>wwv_flow_imp.id(1088217221948404903)
,p_internal_uid=>1024353499250103271
);
wwv_flow_imp.component_end;
end;
/
