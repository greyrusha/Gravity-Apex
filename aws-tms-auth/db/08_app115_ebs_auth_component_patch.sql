prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror continue none
--------------------------------------------------------------------------------
--
-- Surgical Component Patch for Application 115 (TMS GBS Control Tower)
--   1. Ensures "TMS Application Access" (9156329399484443) is set at app level.
--   2. Replaces Authentication Scheme 190033714320711622 in-place with
--      "EBS Credentials" (xx_tms_security_pkg.authenticate_ebs, cookie TMS_APP115).
--   3. Deletes unauthenticated Page 9998 (Reset Password).
--   4. Replaces Page 9999 (Login Page) with TMS (Windows) wording,
--      @terex.com Page Validation (247763488118695094), and legacy cookie mapping.
--   5. Replaces Page 62 to HTML-escape P62_ORG_NAME and P62_PERIOD_NAME.
--
--------------------------------------------------------------------------------
begin
apex_application_install.clear_all;
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2026.04.07'
,p_release=>'26.2.0'
,p_default_workspace_id=>100789
,p_default_application_id=>115
,p_default_id_offset=>9156328499369442
,p_default_owner=>'GL_ACCOUNTS'
);
if wwv_flow.g_flow_id <> 115 then
  raise_application_error(-20999, 'Unexpected g_flow_id=' || nvl(to_char(wwv_flow.g_flow_id), 'NULL'));
end if;

-- APPLICATION 115 - TMS GBS Control Tower
-- replace components in-place without dropping the live application
wwv_flow_imp.g_mode := 'REPLACE';

--application/shared_components/security/authorizations/tms_application_access
wwv_flow_imp_shared.create_security_scheme(
 p_id=>wwv_flow_imp.id(9156329399484443)
,p_name=>'TMS Application Access'
,p_static_id=>'tms-application-access'
,p_scheme_type=>'NATIVE_FUNCTION_BODY'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'plsql_function_body', wwv_flow_string.join(wwv_flow_t_varchar2(
    'begin',
    '    return xx_tms_security_pkg.can_access(:APP_USER, :APP_ID);',
    'end;')))).to_clob
,p_error_message=>'You are not authorized to access this application.'
,p_caching=>'BY_USER_BY_PAGE_VIEW'
);
wwv_flow_imp.set_security_scheme(
 p_flow_id=>wwv_flow.g_flow_id
,p_security_scheme=>to_char(wwv_flow_imp.id(9156329399484443))
);
--application/shared_components/security/authentications/ebs_credentials
wwv_flow_imp_shared.create_authentication(
 p_id=>wwv_flow_imp.id(190033714320711622)
,p_name=>'EBS Credentials'
,p_static_id=>'ebs-credentials'
,p_scheme_type=>'NATIVE_CUSTOM'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'authentication_function', 'xx_tms_security_pkg.authenticate_ebs',
  'enable_legacy_attributes', 'N')).to_clob
,p_invalid_session_type=>'LOGIN'
,p_logout_url=>'f?p=&APP_ID.:9999:0'
,p_cookie_name=>'TMS_APP115'
,p_cookie_path=>'/ords/'
,p_use_secure_cookie_yn=>'Y'
,p_ras_mode=>0
);
--application/pages/delete_09998
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>9998);
--application/pages/delete_09999
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>9999);
--application/pages/page_09999
wwv_flow_imp_page.create_page(
 p_id=>9999
,p_name=>'Login Page'
,p_alias=>'LOGIN'
,p_step_title=>'TMS GBS Control Tower - Log In'
,p_warn_on_unsaved_changes=>'N'
,p_first_item=>'AUTO_FIRST_ITEM'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>2104585595298951431
,p_page_template_options=>'#DEFAULT#'
,p_page_is_public_y_n=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'12'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(190039970919711811)
,p_plug_name=>'TMS GBS Control Tower'
,p_static_id=>'tms-month-end-control-tower'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2677585639786677191
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Sign in with your <strong>TMS (Windows)</strong> username (<strong>FIRST.LAST</strong>) and password.</p>',
'<p>Application access is governed centrally in the TMS Administration Console.</p>'))
,p_region_image=>'#APP_FILES#icons/app-icon-512.png'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(190041528500711842)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(190039970919711811)
,p_button_name=>'LOGIN'
,p_static_id=>'login'
,p_show_as_disabled=>false
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Sign In'
,p_button_position=>'NEXT'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(190040801555711837)
,p_name=>'P9999_PASSWORD'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(190039970919711811)
,p_prompt=>'TMS (Windows) Password'
,p_placeholder=>'TMS (Windows) Password'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_PASSWORD'
,p_cSize=>40
,p_cMaxlength=>256
,p_tag_attributes=>'autocomplete="current-password"'
,p_label_alignment=>'RIGHT'
,p_field_template=>2044213549383960320
,p_item_icon_css_classes=>'fa-key'
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'submit_when_enter_pressed', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(190041283588711840)
,p_name=>'P9999_REMEMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(190039970919711811)
,p_prompt=>'Remember username'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SINGLE_CHECKBOX'
,p_label_alignment=>'RIGHT'
,p_display_when=>'apex_authentication.persistent_cookies_enabled'
,p_display_when2=>'PLSQL'
,p_display_when_type=>'EXPRESSION'
,p_field_template=>2044213549383960320
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(190040401875711833)
,p_name=>'P9999_USERNAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(190039970919711811)
,p_prompt=>'TMS (Windows) Username'
,p_placeholder=>'FIRST.LAST'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>40
,p_cMaxlength=>100
,p_tag_attributes=>'autocomplete="username"'
,p_label_alignment=>'RIGHT'
,p_field_template=>2044213549383960320
,p_item_icon_css_classes=>'fa-user'
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(247763488118695094)
,p_validation_name=>'Reject Email Username'
,p_static_id=>'reject-email-username'
,p_validation_sequence=>10
,p_validation=>'instr(nvl(:P9999_USERNAME, ''-''), ''@'') = 0'
,p_validation2=>'PLSQL'
,p_validation_type=>'EXPRESSION'
,p_error_message=>'Enter your TMS (Windows) username (FIRST.LAST), not your @terex.com email address.'
,p_always_execute=>'N'
,p_associated_item=>wwv_flow_imp.id(190040401875711833)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(190045611208711865)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_SESSION_STATE'
,p_process_name=>'Clear Page(s) Cache'
,p_static_id=>'clear-page-s-cache'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'type', 'CLEAR_CACHE_CURRENT_PAGE')).to_clob
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>13072123167427735
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(190045195036711864)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Get Username Cookie'
,p_static_id=>'get-username-cookie'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_cookie_user varchar2(255) := trim(apex_authentication.get_login_username_cookie);',
'begin',
'  if l_cookie_user is not null and instr(l_cookie_user, ''@'') > 0 then',
'    select max(ebs_user_name)',
'      into l_cookie_user',
'      from xx_tms_users',
'     where local_user_email = lower(l_cookie_user)',
'       and enabled_yn = ''Y'';',
'  elsif l_cookie_user is not null then',
'    l_cookie_user := upper(l_cookie_user);',
'  end if;',
'  :P9999_USERNAME := l_cookie_user;',
'  :P9999_REMEMBER := case when :P9999_USERNAME is not null then ''Y'' end;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>13071706995427734
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(190041965194711850)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_INVOKE_API'
,p_process_name=>'Login'
,p_static_id=>'login'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'package', 'APEX_AUTHENTICATION',
  'package_method', 'LOGIN',
  'type', 'PLSQL_PACKAGE')).to_clob
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>13068477153427720
);
wwv_flow_imp_shared.create_invokeapi_comp_param(
 p_id=>wwv_flow_imp.id(190042977227711862)
,p_page_process_id=>wwv_flow_imp.id(190041965194711850)
,p_page_id=>9999
,p_name=>'p_password'
,p_direction=>'IN'
,p_data_type=>'VARCHAR2'
,p_has_default=>false
,p_display_sequence=>2
,p_value_type=>'ITEM'
,p_value=>'P9999_PASSWORD'
);
wwv_flow_imp_shared.create_invokeapi_comp_param(
 p_id=>wwv_flow_imp.id(190043447253711862)
,p_page_process_id=>wwv_flow_imp.id(190041965194711850)
,p_page_id=>9999
,p_name=>'p_set_persistent_auth'
,p_direction=>'IN'
,p_data_type=>'BOOLEAN'
,p_has_default=>true
,p_display_sequence=>3
,p_value_type=>'API_DEFAULT'
);
wwv_flow_imp_shared.create_invokeapi_comp_param(
 p_id=>wwv_flow_imp.id(190042402582711858)
,p_page_process_id=>wwv_flow_imp.id(190041965194711850)
,p_page_id=>9999
,p_name=>'p_username'
,p_direction=>'IN'
,p_data_type=>'VARCHAR2'
,p_has_default=>false
,p_display_sequence=>1
,p_value_type=>'ITEM'
,p_value=>'P9999_USERNAME'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(190043865873711862)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_INVOKE_API'
,p_process_name=>'Set Username Cookie'
,p_static_id=>'set-username-cookie'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'package', 'APEX_AUTHENTICATION',
  'package_method', 'SEND_LOGIN_USERNAME_COOKIE',
  'type', 'PLSQL_PACKAGE')).to_clob
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>13070377832427732
);
wwv_flow_imp_shared.create_invokeapi_comp_param(
 p_id=>wwv_flow_imp.id(190044826742711862)
,p_page_process_id=>wwv_flow_imp.id(190043865873711862)
,p_page_id=>9999
,p_name=>'p_consent'
,p_direction=>'IN'
,p_data_type=>'BOOLEAN'
,p_has_default=>false
,p_display_sequence=>2
,p_value_type=>'ITEM'
,p_value=>'P9999_REMEMBER'
);
wwv_flow_imp_shared.create_invokeapi_comp_param(
 p_id=>wwv_flow_imp.id(190044349286711862)
,p_page_process_id=>wwv_flow_imp.id(190043865873711862)
,p_page_id=>9999
,p_name=>'p_username'
,p_direction=>'IN'
,p_data_type=>'VARCHAR2'
,p_has_default=>false
,p_display_sequence=>1
,p_value_type=>'EXPRESSION'
,p_value_language=>'PLSQL'
,p_value=>'upper( trim( :P9999_USERNAME ) )'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(247763488118695093)
,p_process_sequence=>5
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Normalize EBS Username'
,p_static_id=>'normalize-ebs-username'
,p_process_sql_clob=>':P9999_USERNAME := upper(trim(:P9999_USERNAME));'
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>190117999900000015
);
--application/pages/delete_00062
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>62);
--application/pages/page_00062
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
,p_required_role=>wwv_flow_imp.id(9156329399484443)
,p_dialog_title=>'Inventory Pending Transaction Details'
,p_dialog_height=>'750'
,p_dialog_width=>'1200'
,p_dialog_chained=>'N'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'03'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(462000000000000620)
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
,p_menu_id=>wwv_flow_imp.id(190034115494711636)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4075790987805660140
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(462000000000000621)
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
 p_id=>wwv_flow_imp.id(462000000000000622)
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
 p_id=>wwv_flow_imp.id(462000000000000639)
,p_query_column_id=>10
,p_column_alias=>'ITEM'
,p_column_display_sequence=>100
,p_column_heading=>'Item'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(462000000000000632)
,p_query_column_id=>3
,p_column_alias=>'ORGANIZATION_NAME'
,p_column_display_sequence=>30
,p_column_heading=>'Inventory Organization'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(462000000000000630)
,p_query_column_id=>1
,p_column_alias=>'PERIOD_NAME'
,p_column_display_sequence=>10
,p_column_heading=>'Inventory Period'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(462000000000000635)
,p_query_column_id=>6
,p_column_alias=>'RESOLUTION'
,p_column_display_sequence=>60
,p_column_heading=>'Resolution'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(462000000000000631)
,p_query_column_id=>2
,p_column_alias=>'SCHEDULE_CLOSE_DATE'
,p_column_display_sequence=>20
,p_column_heading=>'Scheduled Close Date'
,p_column_format=>'DD-MON-YYYY'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(462000000000000634)
,p_query_column_id=>5
,p_column_alias=>'TRANSACTION_DATE'
,p_column_display_sequence=>50
,p_column_heading=>'Transaction Date'
,p_column_format=>'DD-MON-YYYY HH24:MI'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(462000000000000636)
,p_query_column_id=>7
,p_column_alias=>'TRANSACTION_REF'
,p_column_display_sequence=>70
,p_column_heading=>'Reference Type'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(462000000000000637)
,p_query_column_id=>8
,p_column_alias=>'TRANSACTION_REF_ID'
,p_column_display_sequence=>80
,p_column_heading=>'Transaction Reference'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(462000000000000633)
,p_query_column_id=>4
,p_column_alias=>'TRANSACTION_TYPE'
,p_column_display_sequence=>40
,p_column_heading=>'Pending Transaction Category'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(462000000000000638)
,p_query_column_id=>9
,p_column_alias=>'TRANSACTION_TYPE_NAME'
,p_column_display_sequence=>90
,p_column_heading=>'Transaction Type'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(462000000000000640)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(462000000000000621)
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
 p_id=>wwv_flow_imp.id(462000000000000653)
,p_name=>'P62_LEDGER_ID'
,p_item_sequence=>40
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(462000000000000652)
,p_name=>'P62_MONTH_OFFSET'
,p_item_sequence=>30
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(462000000000000651)
,p_name=>'P62_ORG_ID'
,p_item_sequence=>20
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(462000000000000654)
,p_name=>'P62_ORG_NAME'
,p_item_sequence=>25
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(462000000000000650)
,p_name=>'P62_PERIOD_NAME'
,p_item_sequence=>10
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(462000000000000655)
,p_name=>'P62_SNAPSHOT_ID'
,p_item_sequence=>50
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(462000000000000641)
,p_name=>'Back to Period Status'
,p_static_id=>'back-to-period-status'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(462000000000000640)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(462000000000000642)
,p_event_id=>wwv_flow_imp.id(462000000000000641)
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
 p_id=>wwv_flow_imp.id(462000000000000656)
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
,p_internal_uid=>462000000000000656
);
--application/end_environment
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false)
);
apex_application_install.clear_all;
end;
/
commit;
set verify on feedback on define on
prompt  ...done
