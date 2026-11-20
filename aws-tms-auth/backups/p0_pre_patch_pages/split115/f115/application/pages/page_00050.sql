prompt --application/pages/page_00050
begin
--   Manifest
--     PAGE: 00050
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
,p_required_role=>wwv_flow_imp.id(9156329399484443)
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
,p_protection_level=>'C'
,p_page_component_map=>'03'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(192280162828710037)
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
 p_id=>wwv_flow_imp.id(1022082309100277677)
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
 p_id=>wwv_flow_imp.id(192279743234710033)
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
 p_id=>wwv_flow_imp.id(192306374899812197)
,p_plug_name=>'Breadcrumb'
,p_static_id=>'breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2534890969069732905
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_menu_id=>wwv_flow_imp.id(190034115494711636)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4075790987805660140
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(194267354825817760)
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
 p_id=>wwv_flow_imp.id(194391642880806845)
,p_query_column_id=>6
,p_column_alias=>'ACTIONS'
,p_column_display_sequence=>80
,p_column_heading=>'Actions'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(194391707368806846)
,p_query_column_id=>7
,p_column_alias=>'ATTRIBUTE_1'
,p_column_display_sequence=>90
,p_column_heading=>'Attribute 1'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(194391838802806847)
,p_query_column_id=>8
,p_column_alias=>'ATTRIBUTE_2'
,p_column_display_sequence=>100
,p_column_heading=>'Attribute 2'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(194391953466806848)
,p_query_column_id=>9
,p_column_alias=>'ATTRIBUTE_3'
,p_column_display_sequence=>110
,p_column_heading=>'Attribute 3'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(194391991281806849)
,p_query_column_id=>10
,p_column_alias=>'ATTRIBUTE_4'
,p_column_display_sequence=>120
,p_column_heading=>'Attribute 4'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(194391332093806842)
,p_query_column_id=>5
,p_column_alias=>'COMMENT_DATE'
,p_column_display_sequence=>50
,p_column_heading=>'Comment Date'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(194392176449806850)
,p_query_column_id=>11
,p_column_alias=>'COMMENT_MODIFIERS'
,p_column_display_sequence=>130
,p_column_heading=>'Comment Modifiers'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(194391221447806841)
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
 p_id=>wwv_flow_imp.id(194392222922806851)
,p_query_column_id=>12
,p_column_alias=>'ICON_MODIFIER'
,p_column_display_sequence=>140
,p_column_heading=>'Icon Modifier'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(194391480122806843)
,p_query_column_id=>13
,p_column_alias=>'MESSAGE_ROLE'
,p_column_display_sequence=>60
,p_column_heading=>'Message Role'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(194391515586806844)
,p_query_column_id=>14
,p_column_alias=>'PERIOD_NAME'
,p_column_display_sequence=>70
,p_column_heading=>'Period Name'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(194390932687806838)
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
 p_id=>wwv_flow_imp.id(194391165966806840)
,p_query_column_id=>3
,p_column_alias=>'USER_ICON'
,p_column_display_sequence=>30
,p_column_heading=>'User Icon'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(194390998011806839)
,p_query_column_id=>2
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>20
,p_column_heading=>'User Name'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(192284243556710078)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(192280162828710037)
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
 p_id=>wwv_flow_imp.id(194268721177817774)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(192279743234710033)
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
 p_id=>wwv_flow_imp.id(1044741990968593011)
,p_button_sequence=>15
,p_button_plug_id=>wwv_flow_imp.id(192279743234710033)
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
 p_id=>wwv_flow_imp.id(194268105307817768)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(192279743234710033)
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
 p_id=>wwv_flow_imp.id(89889172042826179)
,p_name=>'P50_ACTIVE_AI'
,p_item_sequence=>5
,p_item_plug_id=>wwv_flow_imp.id(192279743234710033)
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
 p_id=>wwv_flow_imp.id(194267221538817759)
,p_name=>'P50_AI_QUESTION'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(192279743234710033)
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
 p_id=>wwv_flow_imp.id(194390278863806831)
,p_name=>'P50_AI_QUESTION_SEQ_ID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(192279743234710033)
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1010078933012277785)
,p_name=>'P50_AP_AS_OF_DATE'
,p_item_sequence=>90
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1010078933012277784)
,p_name=>'P50_AP_COMPANY'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(192280162828710037)
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
 p_id=>wwv_flow_imp.id(1010078933012277783)
,p_name=>'P50_AP_LEDGER_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(192280162828710037)
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
 p_id=>wwv_flow_imp.id(1010078933012277787)
,p_name=>'P50_AP_RECON_READY'
,p_item_sequence=>85
,p_item_default=>'N'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1010078933012277782)
,p_name=>'P50_AP_SCOPE_AS_OF_DATE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(192280162828710037)
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
 p_id=>wwv_flow_imp.id(1010078933012277786)
,p_name=>'P50_AP_SOURCE_PAGE'
,p_item_sequence=>80
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1022082309100277780)
,p_name=>'P50_AR_AGING_BUCKET_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(1022082309100277677)
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1022082309100277779)
,p_name=>'P50_AR_COMPANY'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(1022082309100277677)
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
 p_id=>wwv_flow_imp.id(1022082309100277778)
,p_name=>'P50_AR_LEDGER_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(1022082309100277677)
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
 p_id=>wwv_flow_imp.id(1022082309100277782)
,p_name=>'P50_AR_RECON_READY'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(1022082309100277677)
,p_item_default=>'N'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1022082309100277777)
,p_name=>'P50_AR_SCOPE_AS_OF_DATE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(1022082309100277677)
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
 p_id=>wwv_flow_imp.id(1022082309100277781)
,p_name=>'P50_AR_SOURCE_PAGE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(1022082309100277677)
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(246282681911806146)
,p_name=>'P50_DB_LINK'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(192280162828710037)
,p_item_default=>'ADG'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_cHeight=>1
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1044741990968593010)
,p_name=>'P50_EXEC_CONTEXT_STATUS'
,p_item_sequence=>7
,p_item_plug_id=>wwv_flow_imp.id(192279743234710033)
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
 p_id=>wwv_flow_imp.id(192280224734710038)
,p_name=>'P50_PERIOD_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(192280162828710037)
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
,p_colspan=>4
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(194268224718817769)
,p_name=>'Click'
,p_static_id=>'click'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(194268105307817768)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(1044741990968593014)
,p_event_id=>wwv_flow_imp.id(194268224718817769)
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
 p_id=>wwv_flow_imp.id(194390625687806835)
,p_event_id=>wwv_flow_imp.id(194268224718817769)
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
 p_id=>wwv_flow_imp.id(1022082309100279162)
,p_event_id=>wwv_flow_imp.id(194268224718817769)
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
 p_id=>wwv_flow_imp.id(194268586064817772)
,p_event_id=>wwv_flow_imp.id(194268224718817769)
,p_event_result=>'TRUE'
,p_action_sequence=>100
,p_execute_on_page_init=>'N'
,p_static_id=>'native-clear'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P50_AI_QUESTION'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(194268676286817773)
,p_event_id=>wwv_flow_imp.id(194268224718817769)
,p_event_result=>'TRUE'
,p_action_sequence=>110
,p_execute_on_page_init=>'Y'
,p_static_id=>'native-set-focus'
,p_action=>'NATIVE_SET_FOCUS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P50_AI_QUESTION'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(194390713861806836)
,p_event_id=>wwv_flow_imp.id(194268224718817769)
,p_event_result=>'TRUE'
,p_action_sequence=>60
,p_execute_on_page_init=>'N'
,p_name=>'Refresh Answer'
,p_static_id=>'refresh-answer'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(194267354825817760)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'maintain_pagination', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(194390389129806833)
,p_event_id=>wwv_flow_imp.id(194268224718817769)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_name=>'Refresh Question'
,p_static_id=>'refresh-question'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(194267354825817760)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'maintain_pagination', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(194390884805806837)
,p_event_id=>wwv_flow_imp.id(194268224718817769)
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
 p_id=>wwv_flow_imp.id(194390510229806834)
,p_event_id=>wwv_flow_imp.id(194268224718817769)
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
 p_id=>wwv_flow_imp.id(194390298046806832)
,p_event_id=>wwv_flow_imp.id(194268224718817769)
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
 p_id=>wwv_flow_imp.id(194464181710588231)
,p_name=>'Close'
,p_static_id=>'close'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(192284243556710078)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(194464239858588232)
,p_event_id=>wwv_flow_imp.id(194464181710588231)
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
 p_id=>wwv_flow_imp.id(194268882801817775)
,p_name=>'New'
,p_static_id=>'new'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(194268721177817774)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(194269275335817779)
,p_event_id=>wwv_flow_imp.id(194268882801817775)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_static_id=>'native-clear'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P50_AI_QUESTION'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(194268942241817776)
,p_event_id=>wwv_flow_imp.id(194268882801817775)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-confirm'
,p_action=>'NATIVE_CONFIRM'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'message', 'Start a new conversation? The current session conversation will be cleared')).to_clob
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(194269058205817777)
,p_event_id=>wwv_flow_imp.id(194268882801817775)
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
 p_id=>wwv_flow_imp.id(194269157321817778)
,p_event_id=>wwv_flow_imp.id(194268882801817775)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_static_id=>'native-refresh'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(194267354825817760)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'maintain_pagination', 'N')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(194269351399817780)
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
 p_id=>wwv_flow_imp.id(1022082309100279163)
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
 p_id=>wwv_flow_imp.id(1044741990968593012)
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
 p_id=>wwv_flow_imp.id(1010078933012277881)
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
 p_id=>wwv_flow_imp.id(1044741990968593013)
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
 p_id=>wwv_flow_imp.id(1007183232099592080)
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
wwv_flow_imp.component_end;
end;
/
