prompt --application/shared_components/security/authentications/ebs_credentials
begin
--   Manifest
--     AUTHENTICATION: EBS Credentials
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.04.07'
,p_release=>'26.2.0'
,p_default_workspace_id=>100789
,p_default_application_id=>128
,p_default_id_offset=>9401733729708713
,p_default_owner=>'GL_ACCOUNTS'
);
wwv_flow_imp_shared.create_authentication(
 p_id=>wwv_flow_imp.id(199435448050420335)
,p_name=>'EBS Credentials'
,p_static_id=>'ebs-credentials'
,p_scheme_type=>'NATIVE_CUSTOM'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'authentication_function', 'xx_tms_security_pkg.authenticate_ebs',
  'enable_legacy_attributes', 'N')).to_clob
,p_invalid_session_type=>'LOGIN'
,p_logout_url=>'f?p=&APP_ID.:9999:0'
,p_cookie_name=>'TMS_APP128'
,p_cookie_path=>'/ords/'
,p_use_secure_cookie_yn=>'Y'
,p_ras_mode=>0
);
wwv_flow_imp.component_end;
end;
/
