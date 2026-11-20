prompt --application/shared_components/security/authorizations/tms_application_access
begin
--   Manifest
--     SECURITY SCHEME: TMS Application Access
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.04.07'
,p_release=>'26.2.0'
,p_default_workspace_id=>100789
,p_default_application_id=>128
,p_default_id_offset=>9401733729708713
,p_default_owner=>'GL_ACCOUNTS'
);
wwv_flow_imp_shared.create_security_scheme(
 p_id=>wwv_flow_imp.id(18558063129193156)
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
wwv_flow_imp.component_end;
end;
/
