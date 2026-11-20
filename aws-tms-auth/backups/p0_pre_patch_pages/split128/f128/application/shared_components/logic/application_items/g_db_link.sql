prompt --application/shared_components/logic/application_items/g_db_link
begin
--   Manifest
--     APPLICATION ITEM: G_DB_LINK
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.04.07'
,p_release=>'26.2.0'
,p_default_workspace_id=>100789
,p_default_application_id=>128
,p_default_id_offset=>9401733729708713
,p_default_owner=>'GL_ACCOUNTS'
);
wwv_flow_imp_shared.create_flow_item(
 p_id=>wwv_flow_imp.id(255684415641364859)
,p_name=>'G_DB_LINK'
,p_protection_level=>'I'
);
wwv_flow_imp.component_end;
end;
/
