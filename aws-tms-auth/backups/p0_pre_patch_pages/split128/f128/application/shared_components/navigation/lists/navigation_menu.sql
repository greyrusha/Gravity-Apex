prompt --application/shared_components/navigation/lists/navigation_menu
begin
--   Manifest
--     LIST: Navigation Menu
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.04.07'
,p_release=>'26.2.0'
,p_default_workspace_id=>100789
,p_default_application_id=>128
,p_default_id_offset=>9401733729708713
,p_default_owner=>'GL_ACCOUNTS'
);
wwv_flow_imp_shared.create_list(
 p_id=>wwv_flow_imp.id(199436376416420357)
,p_name=>'Navigation Menu'
,p_static_id=>'navigation-menu'
,p_version_scn=>'SH256:eQV-Mrw-HEnmAV-xTRZA0ZymtzvsQCZHh213EEuO9MM'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(1047047221948404691)
,p_list_item_display_sequence=>9980
,p_list_item_link_text=>'AI Conversation Review'
,p_static_id=>'ai-conversation-review'
,p_list_item_link_target=>'f?p=&APP_ID.:92:&SESSION.::&DEBUG.:RP,92::'
,p_list_item_icon=>'fa-comments-o'
,p_security_scheme=>wwv_flow_imp.id(18558063129193156)
,p_required_patch=>wwv_flow_imp.id(1026514276929100661)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'92,93,94,95'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(1048217221948404488)
,p_list_item_display_sequence=>9970
,p_list_item_link_text=>'AI Knowledge Manager'
,p_static_id=>'ai-knowledge-manager'
,p_list_item_link_target=>'f?p=&APP_ID.:96:&SESSION.::&DEBUG.:RP,96::'
,p_list_item_icon=>'fa-book'
,p_required_patch=>wwv_flow_imp.id(1026514276929100661)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'96,97,98,99'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(201707637933520903)
,p_list_item_display_sequence=>70
,p_list_item_link_text=>'AI Month-End Analyst'
,p_static_id=>'ai-month-end-analyst'
,p_list_item_link_target=>'f?p=&APP_ID.:50:&SESSION.::&DEBUG.'
,p_list_text_06=>'_blank'
,p_required_patch=>wwv_flow_imp.id(1026514276929100661)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'50'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(15258726366524983)
,p_list_item_display_sequence=>55
,p_list_item_link_text=>'Fixed Assets'
,p_static_id=>'fixed-assets'
,p_list_item_link_target=>'f?p=&APP_ID.:71:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-building'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'71'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(200018492116445685)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'General Ledger'
,p_static_id=>'general-ledger'
,p_list_item_link_target=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.'
,p_list_text_06=>'_blank'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'10'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(993480666741987294)
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
 p_id=>wwv_flow_imp.id(1004946912307445785)
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
 p_id=>wwv_flow_imp.id(199447797927420580)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Home'
,p_static_id=>'home'
,p_list_item_link_target=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:1:::'
,p_list_item_link_attributes=>'target="tms_dashboard"'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(264745415640464899)
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
 p_id=>wwv_flow_imp.id(15421299320694280)
,p_list_item_display_sequence=>67
,p_list_item_link_text=>'Inventory Reconciliation'
,p_static_id=>'inventory-reconciliation'
,p_list_item_link_target=>'f?p=&APP_ID.:73:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-balance-scale'
,p_security_scheme=>wwv_flow_imp.id(18558063129193156)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'73'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(1287000000099999)
,p_list_item_display_sequence=>63
,p_list_item_link_text=>'Month-End Activity'
,p_static_id=>'month-end-activity'
,p_list_item_link_target=>'f?p=&APP_ID.:70:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-dashboard'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'70'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(201018647793131097)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Payables'
,p_static_id=>'payables'
,p_list_item_link_target=>'f?p=&APP_ID.:20:&SESSION.::&DEBUG.'
,p_list_text_06=>'_blank'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'20'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(264744415640464899)
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
 p_id=>wwv_flow_imp.id(201419254956110450)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'Receivables'
,p_static_id=>'receivables'
,p_list_item_link_target=>'f?p=&APP_ID.:30:&SESSION.::&DEBUG.'
,p_list_text_06=>'_blank'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'30'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(201432585182237110)
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
