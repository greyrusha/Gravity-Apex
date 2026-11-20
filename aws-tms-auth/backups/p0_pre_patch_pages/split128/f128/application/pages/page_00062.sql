prompt --application/pages/page_00062
begin
--   Manifest
--     PAGE: 00062
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
 p_id=>62
,p_name=>'Inventory Pending Transaction Details'
,p_alias=>'INVENTORY-PENDING-TRANSACTION-DETAILS'
,p_page_mode=>'MODAL'
,p_step_title=>'Inventory Pending Transaction Details'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>2103835248774687739
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(18558063129193156)
,p_dialog_title=>'Inventory Pending Transaction Details'
,p_dialog_height=>'750'
,p_dialog_width=>'1200'
,p_dialog_chained=>'N'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'03'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1286062000000030)
,p_plug_name=>'Breadcrumb'
,p_static_id=>'breadcrumb'
,p_title=>'Pending Transaction Details'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2534890969069732905
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_menu_id=>wwv_flow_imp.id(199435849224420349)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4075790987805660140
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1286062000000031)
,p_plug_name=>'Selected Inventory Organization'
,p_static_id=>'inventory-detail-context'
,p_title=>'Selected Inventory Organization'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="t-Alert t-Alert--info t-Alert--horizontal" role="note">',
'  <div class="t-Alert-wrap">',
'    <div class="t-Alert-icon"><span class="t-Icon fa fa-info-circle" aria-hidden="true"></span></div>',
'    <div class="t-Alert-content">',
'      Required pending transactions captured for inventory organization &P62_ORG_NAME!HTML. in &P62_PERIOD_NAME!HTML..',
'      Reopen this detail window to refresh the operational results.',
'    </div>',
'  </div>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(1286062000000032)
,p_name=>'Required Pending Transaction Details'
,p_static_id=>'inventory-pending-detail-report'
,p_title=>'Required Pending Transaction Details'
,p_template=>2103954283454391425
,p_display_sequence=>20
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select c001 period_name,',
'       d001 schedule_close_date,',
'       c002 organization_name,',
'       c003 transaction_type,',
'       d002 transaction_date,',
'       c004 resolution,',
'       c005 transaction_ref,',
'       c006 transaction_ref_id,',
'       c007 transaction_type_name,',
'       c008 item',
'  from apex_collections',
' where collection_name = ''P62DTL_'' || :P62_SNAPSHOT_ID',
' order by seq_id'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P62_SNAPSHOT_ID'
,p_lazy_loading=>true
,p_query_row_template=>2542081983073888486
,p_query_num_rows=>50
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No required pending transactions remain for this inventory organization.'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'TOP_AND_BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1286062000000042)
,p_query_column_id=>10
,p_column_alias=>'ITEM'
,p_column_display_sequence=>100
,p_column_heading=>'Item'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1286062000000035)
,p_query_column_id=>3
,p_column_alias=>'ORGANIZATION_NAME'
,p_column_display_sequence=>30
,p_column_heading=>'Inventory Organization'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1286062000000033)
,p_query_column_id=>1
,p_column_alias=>'PERIOD_NAME'
,p_column_display_sequence=>10
,p_column_heading=>'Inventory Period'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1286062000000038)
,p_query_column_id=>6
,p_column_alias=>'RESOLUTION'
,p_column_display_sequence=>60
,p_column_heading=>'Resolution'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1286062000000034)
,p_query_column_id=>2
,p_column_alias=>'SCHEDULE_CLOSE_DATE'
,p_column_display_sequence=>20
,p_column_heading=>'Scheduled Close Date'
,p_column_format=>'DD-MON-YYYY'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1286062000000037)
,p_query_column_id=>5
,p_column_alias=>'TRANSACTION_DATE'
,p_column_display_sequence=>50
,p_column_heading=>'Transaction Date'
,p_column_format=>'DD-MON-YYYY HH24:MI'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1286062000000039)
,p_query_column_id=>7
,p_column_alias=>'TRANSACTION_REF'
,p_column_display_sequence=>70
,p_column_heading=>'Reference Type'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1286062000000040)
,p_query_column_id=>8
,p_column_alias=>'TRANSACTION_REF_ID'
,p_column_display_sequence=>80
,p_column_heading=>'Transaction Reference'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1286062000000036)
,p_query_column_id=>4
,p_column_alias=>'TRANSACTION_TYPE'
,p_column_display_sequence=>40
,p_column_heading=>'Pending Transaction Category'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1286062000000041)
,p_query_column_id=>9
,p_column_alias=>'TRANSACTION_TYPE_NAME'
,p_column_display_sequence=>90
,p_column_heading=>'Transaction Type'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(1286062000000043)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(1286062000000031)
,p_button_name=>'BACK_TO_PERIOD_STATUS'
,p_static_id=>'back-to-period-status'
,p_show_as_disabled=>false
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Back to Period Status'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-arrow-left'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1286062000000044)
,p_name=>'P62_LEDGER_ID'
,p_item_sequence=>40
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1286062000000050)
,p_name=>'P62_MONTH_OFFSET'
,p_item_sequence=>30
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1286062000000048)
,p_name=>'P62_ORG_ID'
,p_item_sequence=>20
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1286062000000049)
,p_name=>'P62_ORG_NAME'
,p_item_sequence=>25
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1286062000000047)
,p_name=>'P62_PERIOD_NAME'
,p_item_sequence=>10
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1286062000000051)
,p_name=>'P62_SNAPSHOT_ID'
,p_item_sequence=>50
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(1286062000000045)
,p_name=>'Back to Period Status'
,p_static_id=>'back-to-period-status'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(1286062000000043)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(1286062000000046)
,p_event_id=>wwv_flow_imp.id(1286062000000045)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'Restore Period Status State'
,p_static_id=>'restore-period-status-state'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'apex.navigation.dialog.close(true);')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(1286062000000052)
,p_process_sequence=>5
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Capture Pending Transaction Snapshot'
,p_static_id=>'capture-pending-transaction-snapshot'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_period varchar2(15) := upper(trim(apex_util.get_session_state(''P62_PERIOD_NAME'')));',
'  l_org_text varchar2(30) := trim(apex_util.get_session_state(''P62_ORG_ID''));',
'  l_offset_text varchar2(10) := trim(apex_util.get_session_state(''P62_MONTH_OFFSET''));',
'  l_ledger_text varchar2(30) := trim(apex_util.get_session_state(''P62_LEDGER_ID''));',
'  l_org number;',
'  l_offset number;',
'  l_ledger number;',
'  l_snapshot_id varchar2(32);',
'  l_collection_name varchar2(255);',
'begin',
'  if l_period is null or not regexp_like(l_period, ''^(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)-[0-9]{4}$'', ''c'') then',
'    raise_application_error(-20182, ''Select a valid inventory period from Period Status.'');',
'  end if;',
'  if l_org_text is null or not regexp_like(l_org_text, ''^[0-9]{1,18}$'', ''c'') then',
'    raise_application_error(-20183, ''Select a valid inventory organization from Period Status.'');',
'  end if;',
'  if l_offset_text is null or not regexp_like(l_offset_text, ''^-?[0-9]+$'', ''c'') then',
'    raise_application_error(-20184, ''The selected month is invalid.'');',
'  end if;',
'  if l_ledger_text is null or not regexp_like(l_ledger_text, ''^[0-9]{1,18}$'', ''c'') then',
'    raise_application_error(-20185, ''The selected ledger is invalid.'');',
'  end if;',
'  l_org := to_number(l_org_text);',
'  l_offset := to_number(l_offset_text);',
'  l_ledger := to_number(l_ledger_text);',
'  if l_ledger not in (1003, 5001, 10001) then',
'    raise_application_error(-20185, ''The selected ledger is outside the Page 60 scope.'');',
'  end if;',
'  if l_offset not in (-3, -2, -1, 0, 1, 2, 3)',
'     or l_period <> upper(to_char(add_months(trunc(sysdate, ''MM''), l_offset), ''MON-YYYY'', ''NLS_DATE_LANGUAGE=English'')) then',
'    raise_application_error(-20184, ''The selected month does not match Period Status.'');',
'  end if;',
'  declare n number; begin',
'    select /*+ DRIVING_SITE(ood) */ count(*) into n from apps.org_organization_definitions@ADG ood',
'    where ood.organization_id=l_org and ood.set_of_books_id=l_ledger and nvl(ood.disable_date,sysdate)>=sysdate;',
'    if n<>1 then raise_application_error(-20185, ''The selected organization does not belong to the selected ledger.''); end if;',
'  end;',
'  l_snapshot_id := rawtohex(sys_guid());',
'  l_collection_name := ''P62DTL_'' || l_snapshot_id;',
'  apex_collection.create_collection(p_collection_name=>l_collection_name);',
'  for r in (',
'    select period_name, schedule_close_date, organization_name,',
'           transaction_type, transaction_date, resolution, transaction_ref,',
'           transaction_ref_id, transaction_type_name, item',
'      from table(xxinv128_period_pending_pkg.get_required_details(l_period, l_org))',
'  ) loop',
'    apex_collection.add_member(',
'      p_collection_name=>l_collection_name,',
'      p_c001=>r.period_name,',
'      p_d001=>r.schedule_close_date,',
'      p_c002=>r.organization_name,',
'      p_c003=>r.transaction_type,',
'      p_d002=>r.transaction_date,',
'      p_c004=>r.resolution,',
'      p_c005=>r.transaction_ref,',
'      p_c006=>r.transaction_ref_id,',
'      p_c007=>r.transaction_type_name,',
'      p_c008=>r.item);',
'  end loop;',
'  apex_util.set_session_state(',
'    p_name=>''P62_SNAPSHOT_ID'',',
'    p_value=>l_snapshot_id,',
'    p_commit=>false);',
'exception',
'  when others then',
'    if l_collection_name is not null and apex_collection.collection_exists(l_collection_name) then',
'      apex_collection.delete_collection(l_collection_name);',
'    end if;',
'    apex_util.set_session_state(p_name=>''P62_SNAPSHOT_ID'', p_value=>null, p_commit=>false);',
'    raise;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>1286062000000052
);
wwv_flow_imp.component_end;
end;
/
