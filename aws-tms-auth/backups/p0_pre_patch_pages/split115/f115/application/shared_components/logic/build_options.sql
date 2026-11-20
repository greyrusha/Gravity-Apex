prompt --application/shared_components/logic/build_options
begin
--   Manifest
--     BUILD OPTIONS: 115
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.04.07'
,p_release=>'26.2.0'
,p_default_workspace_id=>100789
,p_default_application_id=>115
,p_default_id_offset=>9156328499369442
,p_default_owner=>'GL_ACCOUNTS'
);
wwv_flow_imp_shared.create_build_option(
 p_id=>wwv_flow_imp.id(190033405483711605)
,p_build_option_name=>'Commented Out'
,p_static_id=>'commented-out'
,p_build_option_status=>'EXCLUDE'
);
wwv_flow_imp_shared.create_build_option(
 p_id=>wwv_flow_imp.id(1017112543199391948)
,p_build_option_name=>'FEATURE_AI'
,p_static_id=>'feature-ai'
,p_build_option_status=>'EXCLUDE'
,p_build_option_comment=>'AWS POC 120 phase 1: AI pages, controls, and background preparation are installed but disabled.'
);
wwv_flow_imp.component_end;
end;
/
