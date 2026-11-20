prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror continue none
--------------------------------------------------------------------------------
--
-- Surgical Component Patch for Application 300 (AWP Alpine IC Inventory Reconciliation)
--   1. Ensures "TMS Application Access" (900300001) is set at app level.
--   2. Replaces Authentication Scheme 41428683429848494 in-place with
--      "EBS Credentials" (xx_tms_security_pkg.authenticate_ebs, cookie TMS_APP300).
--   3. Replaces Page 9999 (Login Page) with TMS (Windows) wording,
--      @terex.com Page Validation (900309996), legacy cookie mapping,
--      and uppercase username normalization (900309995).
--
--------------------------------------------------------------------------------
begin
apex_application_install.clear_all;
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2026.04.07'
,p_release=>'26.2.0'
,p_default_workspace_id=>100789
,p_default_application_id=>300
,p_default_id_offset=>8575481219563463
,p_default_owner=>'GL_ACCOUNTS'
);
if wwv_flow.g_flow_id <> 300 then
  raise_application_error(-20999, 'Unexpected g_flow_id=' || nvl(to_char(wwv_flow.g_flow_id), 'NULL'));
end if;

-- APPLICATION 300 - AWP Alpine IC Inventory Reconciliation
-- replace components in-place without dropping the live application
wwv_flow_imp.g_mode := 'REPLACE';

--application/shared_components/security/authorizations/tms_application_access
wwv_flow_imp_shared.create_security_scheme(
 p_id=>wwv_flow_imp.id(900300001)
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
,p_security_scheme=>to_char(wwv_flow_imp.id(900300001))
);
--application/shared_components/security/authentications/ebs_credentials
wwv_flow_imp_shared.create_authentication(
 p_id=>wwv_flow_imp.id(41428683429848494)
,p_name=>'EBS Credentials'
,p_static_id=>'ebs-credentials'
,p_scheme_type=>'NATIVE_CUSTOM'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'authentication_function', 'xx_tms_security_pkg.authenticate_ebs',
  'enable_legacy_attributes', 'N')).to_clob
,p_invalid_session_type=>'LOGIN'
,p_logout_url=>'f?p=&APP_ID.:9999:0'
,p_cookie_name=>'TMS_APP300'
,p_cookie_path=>'/ords/'
,p_use_secure_cookie_yn=>'Y'
,p_ras_mode=>0
);
--application/pages/delete_09999
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>9999);
--application/pages/page_09999
wwv_flow_imp_page.create_page(
 p_id=>9999
,p_name=>'Login Page'
,p_alias=>'LOGIN'
,p_step_title=>'AWP Alpine IC Inventory Reconciliation - Log In'
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
 p_id=>wwv_flow_imp.id(41434872179848594)
,p_plug_name=>'AWP Alpine IC Inventory Reconciliation'
,p_static_id=>'awp-alpine-ic-inventory-reconciliation'
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
 p_id=>wwv_flow_imp.id(41436398544848609)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(41434872179848594)
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
 p_id=>wwv_flow_imp.id(41435723036848606)
,p_name=>'P9999_PASSWORD'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(41434872179848594)
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
 p_id=>wwv_flow_imp.id(41436174522848609)
,p_name=>'P9999_REMEMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(41434872179848594)
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
 p_id=>wwv_flow_imp.id(41435307646848605)
,p_name=>'P9999_USERNAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(41434872179848594)
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
 p_id=>wwv_flow_imp.id(900309996)
,p_validation_name=>'Reject Email Username'
,p_static_id=>'reject-email-username'
,p_validation_sequence=>10
,p_validation=>'instr(nvl(:P9999_USERNAME, ''-''), ''@'') = 0'
,p_validation2=>'PLSQL'
,p_validation_type=>'EXPRESSION'
,p_error_message=>'Enter your TMS (Windows) username (FIRST.LAST), not your @terex.com email address.'
,p_always_execute=>'N'
,p_associated_item=>wwv_flow_imp.id(41435307646848605)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(41440576414848619)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_SESSION_STATE'
,p_process_name=>'Clear Page(s) Cache'
,p_static_id=>'clear-page-s-cache'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'type', 'CLEAR_CACHE_CURRENT_PAGE')).to_clob
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>32865095195285156
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(41440136829848619)
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
,p_internal_uid=>32864655610285156
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(41436815695848613)
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
,p_internal_uid=>32861334476285150
);
wwv_flow_imp_shared.create_invokeapi_comp_param(
 p_id=>wwv_flow_imp.id(41437835531848617)
,p_page_process_id=>wwv_flow_imp.id(41436815695848613)
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
 p_id=>wwv_flow_imp.id(41438349564848617)
,p_page_process_id=>wwv_flow_imp.id(41436815695848613)
,p_page_id=>9999
,p_name=>'p_set_persistent_auth'
,p_direction=>'IN'
,p_data_type=>'BOOLEAN'
,p_has_default=>true
,p_display_sequence=>3
,p_value_type=>'API_DEFAULT'
);
wwv_flow_imp_shared.create_invokeapi_comp_param(
 p_id=>wwv_flow_imp.id(41437286421848616)
,p_page_process_id=>wwv_flow_imp.id(41436815695848613)
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
 p_id=>wwv_flow_imp.id(41438691066848617)
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
,p_internal_uid=>32863209847285154
);
wwv_flow_imp_shared.create_invokeapi_comp_param(
 p_id=>wwv_flow_imp.id(41439766613848619)
,p_page_process_id=>wwv_flow_imp.id(41438691066848617)
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
 p_id=>wwv_flow_imp.id(41439211036848617)
,p_page_process_id=>wwv_flow_imp.id(41438691066848617)
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
 p_id=>wwv_flow_imp.id(900309995)
,p_process_sequence=>5
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Normalize EBS Username'
,p_static_id=>'normalize-ebs-username'
,p_process_sql_clob=>':P9999_USERNAME := upper(trim(:P9999_USERNAME));'
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>900309995
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
