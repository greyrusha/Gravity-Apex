prompt --application/shared_components/navigation/breadcrumbs/breadcrumb
begin
--   Manifest
--     MENU: Breadcrumb
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.04.07'
,p_release=>'26.2.0'
,p_default_workspace_id=>100789
,p_default_application_id=>115
,p_default_id_offset=>9156328499369442
,p_default_owner=>'GL_ACCOUNTS'
);
wwv_flow_imp_shared.create_menu(
 p_id=>wwv_flow_imp.id(190034115494711636)
,p_name=>'Breadcrumb'
,p_static_id=>'breadcrumb'
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(192306964579812201)
,p_short_name=>'AI Month-End Analyst'
,p_static_id=>'ai-month-end-analyst'
,p_link=>'f?p=&APP_ID.:50:&SESSION.::&DEBUG.'
,p_page_id=>50
,p_required_patch=>wwv_flow_imp.id(1017112543199391948)
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(194251760538775342)
,p_short_name=>'AP Active Holds'
,p_static_id=>'ap-active-holds'
,p_link=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.'
,p_page_id=>21
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(194327134135281519)
,p_short_name=>unistr('AR Unapplied Receipts \2014 Current')
,p_static_id=>'ar-unapplied-receipts-current'
,p_link=>'f?p=&APP_ID.:31:&SESSION.::&DEBUG.'
,p_page_id=>31
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(190617617524736998)
,p_short_name=>'General Ledger'
,p_static_id=>'general-ledger'
,p_link=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.'
,p_page_id=>10
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(194543423136070528)
,p_short_name=>'GL Unposted Journals'
,p_static_id=>'gl-unposted-journals'
,p_link=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.'
,p_page_id=>11
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(190034322659711639)
,p_short_name=>'Home'
,p_static_id=>'home'
,p_link=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.'
,p_page_id=>1
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(192025732337402115)
,p_short_name=>'Receivables'
,p_static_id=>'receivables'
,p_link=>'f?p=&APP_ID.:30:&SESSION.::&DEBUG.'
,p_page_id=>30
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(193434456173853205)
,p_short_name=>'Cost Management SLA'
,p_static_id=>'sla-analysis-test'
,p_link=>'f?p=&APP_ID.:41:&SESSION.::&DEBUG.'
,p_page_id=>41
);
wwv_flow_imp.component_end;
end;
/
