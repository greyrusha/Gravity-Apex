prompt --application/pages/page_00096
begin
--   Manifest
--     PAGE: 00096
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
 p_id=>96
,p_name=>'AI Knowledge Manager'
,p_alias=>'AI-KNOWLEDGE-MANAGER'
,p_step_title=>'AI Knowledge Manager'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>4075783602716660119
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(18558063129193156)
,p_required_patch=>wwv_flow_imp.id(1026514276929100661)
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1048217221948404390)
,p_plug_name=>'Effective Human-Readable Knowledge'
,p_static_id=>'effective-knowledge'
,p_title=>'Effective Human-Readable Knowledge'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>20
,p_plug_item_display_point=>'ABOVE'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select k.item_id,',
'       k.title,',
'       k.source_name,',
'       k.ownership_code,',
'       k.edit_mode,',
'       k.domain_name,',
'       k.knowledge_type,',
'       k.lifecycle_status,',
'       k.is_mandatory,',
'       k.version_no,',
'       k.embedding_status,',
'       k.embedding_model,',
'       k.embedded_on,',
'       k.updated_by,',
'       k.updated_on,',
'       apex_page.get_url(',
'           p_page        => 97,',
'           p_clear_cache => ''97'',',
'           p_items       => ''P97_ITEM_ID'',',
'           p_values      => k.item_id',
'       ) open_url',
'  from xxme_ai_km_effective_v k',
' where (:P96_SOURCE_CODE is null or k.source_code = :P96_SOURCE_CODE)',
'   and (:P96_OWNERSHIP is null or k.ownership_code = :P96_OWNERSHIP)',
'   and (:P96_EDIT_MODE is null or k.edit_mode = :P96_EDIT_MODE)',
'   and (:P96_STATUS is null or k.lifecycle_status = :P96_STATUS)',
' order by k.title, k.item_id'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P96_SOURCE_CODE,P96_OWNERSHIP,P96_EDIT_MODE,P96_STATUS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'AI Knowledge Manager'
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#EEEEEE'
,p_prn_header_font_color=>'#000000'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'bold'
,p_prn_header_font_size=>'10'
,p_prn_body_bg_color=>'#FFFFFF'
,p_prn_body_font_color=>'#000000'
,p_prn_body_font_family=>'Helvetica'
,p_prn_body_font_weight=>'normal'
,p_prn_body_font_size=>'10'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(1048217221948404390)
,p_no_data_found_message=>'No effective human-readable knowledge matches the selected filters.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>true
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_internal_uid=>981170000000000650
,p_ai_search_mode=>'A'
,p_ai_report_hint=>'Read-only catalog of effective human-readable knowledge. Vectors and embedding values are intentionally excluded. Each row is one effective knowledge item.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1048217221948404454)
,p_db_column_name=>'DOMAIN_NAME'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Domain'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1048217221948404453)
,p_db_column_name=>'EDIT_MODE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Editability'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1048217221948404461)
,p_db_column_name=>'EMBEDDED_ON'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Embedded On'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'Y'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1048217221948404460)
,p_db_column_name=>'EMBEDDING_MODEL'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Embedding Model'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1048217221948404459)
,p_db_column_name=>'EMBEDDING_STATUS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Embedding Status'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1048217221948404457)
,p_db_column_name=>'IS_MANDATORY'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Mandatory'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1048217221948404449)
,p_db_column_name=>'ITEM_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1048217221948404455)
,p_db_column_name=>'KNOWLEDGE_TYPE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Type'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1048217221948404456)
,p_db_column_name=>'LIFECYCLE_STATUS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1048217221948404464)
,p_db_column_name=>'OPEN_URL'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Open Url'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1048217221948404452)
,p_db_column_name=>'OWNERSHIP_CODE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Ownership'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1048217221948404451)
,p_db_column_name=>'SOURCE_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Source'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1048217221948404450)
,p_db_column_name=>'TITLE'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Knowledge'
,p_column_link=>'#OPEN_URL#'
,p_column_linktext=>'#TITLE#'
,p_column_link_attr=>'class="t-Button t-Button--link"'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'Y'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1048217221948404462)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1048217221948404463)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'Y'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(1048217221948404458)
,p_db_column_name=>'VERSION_NO'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Version'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(1048217221948404479)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ITEM_ID:TITLE:SOURCE_NAME:OWNERSHIP_CODE:EDIT_MODE:DOMAIN_NAME:KNOWLEDGE_TYPE:LIFECYCLE_STATUS:IS_MANDATORY:VERSION_NO:EMBEDDING_STATUS:EMBEDDING_MODEL:EMBEDDED_ON:UPDATED_BY:UPDATED_ON:OPEN_URL'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1048217221948404391)
,p_plug_name=>'Knowledge Administration'
,p_static_id=>'knowledge-administration'
,p_region_template_options=>'#DEFAULT#:t-Region--hideHeader'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>5
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_display_condition_type=>'EXPRESSION'
,p_plug_display_when_condition=>'1 = 0'
,p_plug_display_when_cond2=>'PLSQL'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1048217221948404389)
,p_plug_name=>'Knowledge Filters'
,p_static_id=>'knowledge-filters'
,p_title=>'Knowledge Filters'
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
 p_id=>wwv_flow_imp.id(1048217221948404409)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(1048217221948404389)
,p_button_name=>'APPLY_FILTERS'
,p_static_id=>'apply-filters'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Filters'
,p_button_position=>'CREATE'
,p_icon_css_classes=>'fa-search'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(1048217221948404410)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(1048217221948404389)
,p_button_name=>'RESET_FILTERS'
,p_static_id=>'reset-filters'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Reset Filters'
,p_button_position=>'CREATE'
,p_button_redirect_url=>'f?p=&APP_ID.:96:&SESSION.::&DEBUG.:RP,96::'
,p_icon_css_classes=>'fa-undo'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(1048217221948404411)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(1048217221948404391)
,p_button_name=>'TEACH_NEW_KNOWLEDGE'
,p_static_id=>'teach-new-knowledge'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Teach New Knowledge'
,p_button_position=>'CREATE'
,p_button_redirect_url=>'f?p=&APP_ID.:97:&SESSION.::&DEBUG.:RP,97:P97_MODE:NEW'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1048217221948404401)
,p_name=>'P96_EDIT_MODE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(1048217221948404389)
,p_prompt=>'Editability'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Direct;DIRECT,Governed Source;GOVERNED_SOURCE,Override Only;OVERRIDE_ONLY,Tool Definition;TOOL_DEFINITION'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- All Edit Modes -'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1048217221948404400)
,p_name=>'P96_OWNERSHIP'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(1048217221948404389)
,p_prompt=>'Ownership'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Knowledge Manager;KM_OWNED,Application;APP_OWNED,External;EXTERNAL,APEX Tool;APEX_OWNED'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- All Ownership -'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1048217221948404399)
,p_name=>'P96_SOURCE_CODE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(1048217221948404389)
,p_prompt=>'Source'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'select source_name d, source_code r from xxme_ai_km_sources where is_enabled=''Y'' order by source_name'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- All Sources -'
,p_cHeight=>1
,p_colspan=>3
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1048217221948404402)
,p_name=>'P96_STATUS'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(1048217221948404389)
,p_prompt=>'Status'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Active;ACTIVE,Retired;RETIRED'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- All Statuses -'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp.component_end;
end;
/
