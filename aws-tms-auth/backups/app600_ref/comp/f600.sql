prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run this script using a SQL client connected to the database as
-- the owner (parsing schema) of the application or as a database user with the
-- APEX_ADMINISTRATOR_ROLE role.
--
-- This export file has been automatically generated. Modifying this file is not
-- supported by Oracle and can lead to unexpected application and/or instance
-- behavior now or in the future.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2026.04.07'
,p_release=>'26.2.0'
,p_default_workspace_id=>100789
,p_default_application_id=>600
,p_default_id_offset=>0
,p_default_owner=>'GL_ACCOUNTS'
);
end;
/
 
prompt APPLICATION 600 - EBS Customer OU Rollout Workbench
--
-- Application Export:
--   Application:     600
--   Name:            EBS Customer OU Rollout Workbench
--   Date and Time:   18:26 Thursday November 19, 2026
--   Exported By:     GL_ACCOUNTS
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     AUTHENTICATION: 10790380994518981
--     PAGE: 9999
--   Manifest End
--   Version:         26.2.0
--   Instance ID:     649767868204930
--

begin
  -- replace components
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/security/authentications/ebs_credentials
begin
wwv_flow_imp_shared.create_authentication(
 p_id=>wwv_flow_imp.id(10790380994518981)
,p_name=>'EBS Credentials'
,p_static_id=>'ebs-credentials'
,p_scheme_type=>'NATIVE_CUSTOM'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'authentication_function', 'xxcr_security_pkg.authenticate',
  'enable_legacy_attributes', 'N')).to_clob
,p_invalid_session_type=>'LOGIN'
,p_logout_url=>'f?p=&APP_ID.:9999:0'
,p_cookie_name=>'XXCR_APP600'
,p_cookie_path=>'/ords/'
,p_use_secure_cookie_yn=>'N'
,p_ras_mode=>0
);
end;
/
prompt --application/pages/delete_09999
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>9999);
end;
/
prompt --application/pages/page_09999
begin
wwv_flow_imp_page.create_page(
 p_id=>9999
,p_name=>'Sign In'
,p_alias=>'LOGIN'
,p_step_title=>'Sign In | EBS Customer OU Rollout Workbench'
,p_warn_on_unsaved_changes=>'N'
,p_first_item=>'AUTO_FIRST_ITEM'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>'.t-Login-region{max-width:31rem}.xxcr-login-note{margin:0 0 1.25rem;color:var(--ut-component-text-muted-color);line-height:1.55;font-size:.92rem}'
,p_step_template=>2102634289808461002
,p_page_template_options=>'#DEFAULT#'
,p_page_is_public_y_n=>'Y'
,p_protection_level=>'C'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(10821085521519245)
,p_plug_name=>'EBS Customer OU Rollout Workbench'
,p_static_id=>'ebs-login-card'
,p_title=>'EBS Customer OU Rollout Workbench'
,p_icon_css_classes=>'fa-database'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2675634334296186762
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>'<p class="xxcr-login-note">Sign in with your <strong>Oracle E-Business Suite</strong> username and password. Credentials are verified live over HTTPS against EBS and governed by App 600 Segregation of Duties roles.</p>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(10463944114915286)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(10821085521519245)
,p_button_name=>'LOGIN'
,p_static_id=>'login'
,p_show_as_disabled=>false
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4073839297780169708
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Sign In with EBS'
,p_button_position=>'NEXT'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(10463612300915284)
,p_name=>'P9999_PASSWORD'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(10821085521519245)
,p_prompt=>'EBS Password'
,p_placeholder=>'EBS Password'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_PASSWORD'
,p_cSize=>40
,p_cMaxlength=>256
,p_tag_attributes=>'autocomplete="current-password"'
,p_field_template=>2042262243893469891
,p_item_icon_css_classes=>'fa-key'
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'submit_when_enter_pressed', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(10463890394915286)
,p_name=>'P9999_USERNAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(10821085521519245)
,p_prompt=>'EBS Username'
,p_placeholder=>'EBS Username (e.g. FIRST.LAST)'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>40
,p_cMaxlength=>100
,p_tag_attributes=>'autocomplete="username"'
,p_field_template=>2042262243893469891
,p_item_icon_css_classes=>'fa-user'
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(10821189584519245)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Sign in with Oracle EBS Credentials'
,p_static_id=>'sign-in-with-ebs'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'  apex_authentication.login(',
'    p_username => upper(trim(:P9999_USERNAME)),',
'    p_password => :P9999_PASSWORD',
'  );',
'  :P9999_PASSWORD := null;',
'exception',
'  when others then',
'    :P9999_PASSWORD := null;',
'    raise;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(10463944114915286)
,p_internal_uid=>600099991
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false)
);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
