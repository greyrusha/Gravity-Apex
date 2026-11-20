prompt --application/shared_components/logic/application_items/g_ai_service_id
begin
--   Manifest
--     APPLICATION ITEM: G_AI_SERVICE_ID
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
 p_id=>wwv_flow_imp.id(89896499910905323)
,p_name=>'G_AI_SERVICE_ID'
,p_protection_level=>'I'
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
,p_version_scn=>'SH256:aj9-oAaLRAdtznbAIf4VGWqDeiA_2H1VrNM1_GTGdrE'
);
wwv_flow_imp.component_end;
end;
/
