prompt --application/shared_components/navigation/breadcrumbs/breadcrumb
begin
--   Manifest
--     MENU: Breadcrumb
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.04.07'
,p_release=>'26.2.0'
,p_default_workspace_id=>100789
,p_default_application_id=>128
,p_default_id_offset=>9401733729708713
,p_default_owner=>'GL_ACCOUNTS'
);
wwv_flow_imp_shared.create_menu(
 p_id=>wwv_flow_imp.id(199435849224420349)
,p_name=>'Breadcrumb'
,p_static_id=>'breadcrumb'
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(201708698309520914)
,p_short_name=>'AI Month-End Analyst'
,p_static_id=>'ai-month-end-analyst'
,p_link=>'f?p=&APP_ID.:50:&SESSION.::&DEBUG.'
,p_page_id=>50
,p_required_patch=>wwv_flow_imp.id(1026514276929100661)
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(203653494268484055)
,p_short_name=>'AP Active Holds'
,p_static_id=>'ap-active-holds'
,p_link=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.'
,p_page_id=>21
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(203728867864990232)
,p_short_name=>unistr('AR Unapplied Receipts \2014 Current')
,p_static_id=>'ar-unapplied-receipts-current'
,p_link=>'f?p=&APP_ID.:31:&SESSION.::&DEBUG.'
,p_page_id=>31
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(200019351254445711)
,p_short_name=>'General Ledger'
,p_static_id=>'general-ledger'
,p_link=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.'
,p_page_id=>10
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(203945156865779241)
,p_short_name=>'GL Unposted Journals'
,p_static_id=>'gl-unposted-journals'
,p_link=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.'
,p_page_id=>11
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(199436056389420352)
,p_short_name=>'Home'
,p_static_id=>'home'
,p_link=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.'
,p_page_id=>1
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(201427466067110828)
,p_short_name=>'Receivables'
,p_static_id=>'receivables'
,p_link=>'f?p=&APP_ID.:30:&SESSION.::&DEBUG.'
,p_page_id=>30
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(202836189903561918)
,p_short_name=>'Cost Management SLA'
,p_static_id=>'sla-analysis-test'
,p_link=>'f?p=&APP_ID.:41:&SESSION.::&DEBUG.'
,p_page_id=>41
);
wwv_flow_imp.component_end;
end;
/
