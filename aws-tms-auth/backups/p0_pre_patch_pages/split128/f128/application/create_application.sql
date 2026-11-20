prompt --application/create_application
begin
--   Manifest
--     FLOW: 128
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.04.07'
,p_release=>'26.2.0'
,p_default_workspace_id=>100789
,p_default_application_id=>128
,p_default_id_offset=>9401733729708713
,p_default_owner=>'GL_ACCOUNTS'
);
wwv_imp_workspace.create_flow(
 p_id=>wwv_flow.g_flow_id
,p_owner=>nvl(wwv_flow_application_install.get_schema,'GL_ACCOUNTS')
,p_name=>nvl(wwv_flow_application_install.get_application_name,'TMS GBS Control Tower (Working Copy: TMS GBS Control Tower Enhancements)')
,p_alias=>nvl(wwv_flow_application_install.get_application_alias,'GBS-CONTROL-TOWER128')
,p_page_view_logging=>'YES'
,p_page_protection_enabled_y_n=>'Y'
,p_checksum_salt=>'098AEDBFB8FDA624546FC63B43C6F32075B7C19D43B97E5DCE707BCA693F04BD'
,p_bookmark_checksum_function=>'SH512'
,p_compatibility_mode=>'26.1'
,p_flow_language=>'en'
,p_flow_language_derived_from=>'FLOW_PRIMARY_LANGUAGE'
,p_allow_feedback_yn=>'Y'
,p_date_format=>'DS'
,p_timestamp_format=>'DS'
,p_timestamp_tz_format=>'DS'
,p_flow_image_prefix=>nvl(wwv_flow_application_install.get_image_prefix,'')
,p_authentication_id=>wwv_flow_imp.id(199435448050420335)
,p_application_tab_set=>1
,p_logo_type=>'T'
,p_logo_text=>'TMS GBS Control Tower'
,p_proxy_server=>nvl(wwv_flow_application_install.get_proxy,'')
,p_no_proxy_domains=>nvl(wwv_flow_application_install.get_no_proxy_domains,'')
,p_flow_version=>'Release 1.0'
,p_flow_status=>'AVAILABLE'
,p_browser_cache=>'N'
,p_browser_frame=>'D'
,p_allow_bots=>'Y'
,p_runtime_api_usage=>'T'
,p_security_scheme=>wwv_flow_imp.id(18558063129193156)
,p_authorize_batch_job=>'N'
,p_rejoin_existing_sessions=>'N'
,p_csv_encoding=>'Y'
,p_substitution_string_01=>'APP_NAME'
,p_substitution_value_01=>'TMS GBS Control Tower'
,p_file_prefix=>nvl(wwv_flow_application_install.get_static_app_file_prefix,'')
,p_files_version=>2461278235023
,p_version_scn=>'11218580007296'
,p_print_server_type=>'NATIVE'
,p_file_storage=>'DB'
,p_is_pwa=>'Y'
,p_pwa_is_installable=>'Y'
,p_pwa_manifest_display=>'browser'
,p_pwa_manifest_orientation=>'any'
,p_pwa_is_push_enabled=>'N'
,p_working_copy_created_on=>to_date('20261006111649','YYYYMMDDHH24MISS')
,p_working_copy_created_by=>'GL_ACCOUNTS'
,p_working_copy_name=>'TMS GBS Control Tower Enhancements'
,p_theme_id=>42
,p_home_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.'
,p_login_url=>'f?p=&APP_ID.:LOGIN:&SESSION.::&DEBUG.'
,p_theme_style_by_user_pref=>false
,p_built_with_love=>false
,p_global_page_id=>0
,p_navigation_list_id=>wwv_flow_imp.id(199436376416420357)
,p_navigation_list_position=>'SIDE'
,p_navigation_list_template_id=>2471166859590295591
,p_nav_list_template_options=>'#DEFAULT#:js-defaultCollapsed:js-navCollapsed--hidden:t-TreeNav--styleA'
,p_nav_bar_type=>'LIST'
,p_nav_bar_list_id=>wwv_flow_imp.id(199437086368420421)
,p_nav_bar_list_template_id=>2850970698196720012
,p_nav_bar_template_options=>'#DEFAULT#'
);
wwv_flow_imp.component_end;
end;
/
