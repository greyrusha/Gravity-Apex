prompt --application/shared_components/logic/application_items/g_dashboard_ready
begin
--   Manifest
--     APPLICATION ITEM: G_DASHBOARD_READY
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.04.07'
,p_release=>'26.2.0'
,p_default_workspace_id=>100789
,p_default_application_id=>115
,p_default_id_offset=>9156328499369442
,p_default_owner=>'GL_ACCOUNTS'
);
wwv_flow_imp_shared.create_flow_item(
 p_id=>wwv_flow_imp.id(246282681911656147)
,p_name=>'G_DASHBOARD_READY'
,p_protection_level=>'I'
);
wwv_flow_imp.component_end;
end;
/
