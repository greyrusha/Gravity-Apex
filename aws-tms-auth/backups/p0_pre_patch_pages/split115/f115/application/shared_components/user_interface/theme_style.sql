prompt --application/shared_components/user_interface/theme_style
begin
--   Manifest
--     THEME STYLE: 42
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.04.07'
,p_release=>'26.2.0'
,p_default_workspace_id=>100789
,p_default_application_id=>115
,p_default_id_offset=>9156328499369442
,p_default_owner=>'GL_ACCOUNTS'
);
wwv_flow_imp_shared.create_theme_style(
 p_id=>wwv_flow_imp.id(1152310000000102)
,p_theme_id=>42
,p_name=>'Dark mode'
,p_static_id=>'tms-dark-mode'
,p_css_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#THEME_FILES#css/Vita-Dark#MIN#.css?v=#APEX_VERSION#',
'#APP_FILES#appearance.css?v=856a037a29'))
,p_css_classes=>'tms-dark-mode'
,p_is_public=>true
,p_is_accessible=>true
,p_theme_roller_read_only=>true
);
wwv_flow_imp_shared.create_theme_style(
 p_id=>wwv_flow_imp.id(1152310000000101)
,p_theme_id=>42
,p_name=>'Light mode'
,p_static_id=>'tms-modern-finance'
,p_css_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#THEME_FILES#css/Vita#MIN#.css?v=#APEX_VERSION#',
'#APP_FILES#appearance.css?v=856a037a29'))
,p_css_classes=>'tms-modern-finance'
,p_is_public=>true
,p_is_accessible=>true
,p_theme_roller_read_only=>true
);
wwv_flow_imp.component_end;
end;
/
