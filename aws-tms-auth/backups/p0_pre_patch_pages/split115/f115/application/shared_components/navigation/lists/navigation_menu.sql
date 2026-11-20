prompt --application/shared_components/navigation/lists/navigation_menu
begin
--   Manifest
--     LIST: Navigation Menu
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.04.07'
,p_release=>'26.2.0'
,p_default_workspace_id=>100789
,p_default_application_id=>115
,p_default_id_offset=>9156328499369442
,p_default_owner=>'GL_ACCOUNTS'
);
wwv_flow_imp_shared.create_list(
 p_id=>wwv_flow_imp.id(190034642686711644)
,p_name=>'Navigation Menu'
,p_static_id=>'navigation-menu'
,p_version_scn=>'SH256:eQV-Mrw-HEnmAV-xTRZA0ZymtzvsQCZHh213EEuO9MM'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(1037645488218695978)
,p_list_item_display_sequence=>9980
,p_list_item_link_text=>'AI Conversation Review'
,p_static_id=>'ai-conversation-review'
,p_list_item_link_target=>'f?p=&APP_ID.:92:&SESSION.::&DEBUG.:RP,92::'
,p_list_item_icon=>'fa-comments-o'
,p_security_scheme=>wwv_flow_imp.id(9156329399484443)
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'92,93,94,95'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(1038815488218695775)
,p_list_item_display_sequence=>9970
,p_list_item_link_text=>'AI Knowledge Manager'
,p_static_id=>'ai-knowledge-manager'
,p_list_item_link_target=>'f?p=&APP_ID.:96:&SESSION.::&DEBUG.:RP,96::'
,p_list_item_icon=>'fa-book'
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'96,97,98,99'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(192305904203812190)
,p_list_item_display_sequence=>70
,p_list_item_link_text=>'AI Month-End Analyst'
,p_static_id=>'ai-month-end-analyst'
,p_list_item_link_target=>'f?p=&APP_ID.:50:&SESSION.::&DEBUG.'
,p_list_text_06=>'_blank'
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'50'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(15419602522381806)
,p_list_item_display_sequence=>55
,p_list_item_link_text=>'Fixed Assets'
,p_static_id=>'fixed-assets'
,p_list_item_link_target=>'f?p=&APP_ID.:71:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-building'
,p_security_scheme=>wwv_flow_imp.id(9156329399484443)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'71,72'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(190616758386736972)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'General Ledger'
,p_static_id=>'general-ledger'
,p_list_item_link_target=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.'
,p_list_text_06=>'_blank'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'10'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(984078933012278581)
,p_list_item_display_sequence=>68
,p_list_item_link_text=>'GL/AP Reconciliation'
,p_static_id=>'gl-ap-reconciliation'
,p_list_item_link_target=>'f?p=&APP_ID.:22:&SESSION.::&DEBUG.:RP,22::'
,p_list_item_icon=>'fa-balance-scale'
,p_list_text_06=>'_blank'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'22,23,24'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(995545178577737072)
,p_list_item_display_sequence=>69
,p_list_item_link_text=>'GL/AR Reconciliation'
,p_static_id=>'gl-ar-reconciliation'
,p_list_item_link_target=>'f?p=&APP_ID.:32:&SESSION.::&DEBUG.:RP,32::'
,p_list_item_icon=>'fa-balance-scale'
,p_list_text_06=>'_blank'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'32,33,34'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(190046064197711867)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Home'
,p_static_id=>'home'
,p_list_item_link_target=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:1:::'
,p_list_item_link_attributes=>'target="tms_dashboard"'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(255343681910756186)
,p_list_item_display_sequence=>65
,p_list_item_link_text=>'Inventory Pending Transactions'
,p_static_id=>'inventory-pending-transactions'
,p_list_item_link_target=>'f?p=&APP_ID.:61:&SESSION.::&DEBUG.'
,p_list_item_link_attributes=>'target="_blank" rel="noopener"'
,p_list_item_icon=>'fa-table'
,p_list_text_06=>'_blank'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'61'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(15235328007931754)
,p_list_item_display_sequence=>63
,p_list_item_link_text=>'Month-End Activity'
,p_static_id=>'month-end-activity'
,p_list_item_link_target=>'f?p=&APP_ID.:70:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-dashboard'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'70'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(191616914063422384)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Payables'
,p_static_id=>'payables'
,p_list_item_link_target=>'f?p=&APP_ID.:20:&SESSION.::&DEBUG.'
,p_list_text_06=>'_blank'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'20'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(255342681910756186)
,p_list_item_display_sequence=>60
,p_list_item_link_text=>'Period Status'
,p_static_id=>'period-status'
,p_list_item_link_target=>'f?p=&APP_ID.:60:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-calendar-check-o'
,p_list_text_06=>'_blank'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'60'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(192017521226401737)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'Receivables'
,p_static_id=>'receivables'
,p_list_item_link_target=>'f?p=&APP_ID.:30:&SESSION.::&DEBUG.'
,p_list_text_06=>'_blank'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'30'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(192030851452528397)
,p_list_item_display_sequence=>50
,p_list_item_link_text=>'Cost Management'
,p_static_id=>'subledger-accounting'
,p_list_item_link_target=>'f?p=&APP_ID.:41:&SESSION.::&DEBUG.'
,p_list_text_06=>'_blank'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'41'
);
wwv_flow_imp.component_end;
end;
/
