prompt --application/pages/page_00000
begin
--   Manifest
--     PAGE: 00000
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.04.07'
,p_release=>'26.2.0'
,p_default_workspace_id=>100789
,p_default_application_id=>128
,p_default_id_offset=>9401733729708713
,p_default_owner=>'GL_ACCOUNTS'
);
wwv_flow_imp_page.create_page(
 p_id=>0
,p_name=>'Global Page'
,p_reload_on_submit=>null
,p_warn_on_unsaved_changes=>null
,p_autocomplete_on_off=>'OFF'
,p_step_template=>4075783602716660119
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'D'
,p_page_component_map=>'14'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1017678062229078175)
,p_plug_name=>'Application Owner Support'
,p_static_id=>'app-owner-support'
,p_region_css_classes=>'u-hidden t-Region--hideHeader'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4504868307683981366
,p_plug_display_sequence=>9999
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<style id="xxme-app-owner-support-style">',
'.xxme-support-footer{margin-top:1.5rem;padding:.75rem 1rem;border-top:1px solid var(--ut-component-border-color,#d9dce1);text-align:center;}',
'.xxme-support-footer .xxme-support-note{margin-left:.5rem;color:var(--ut-component-text-muted-color,#5f6368);font-size:.8rem;}',
'@media(max-width:640px){.xxme-support-footer .xxme-support-note{display:block;margin:.35rem 0 0;}}',
'</style>',
'<div class="xxme-support-footer">',
'  <a id="xxme-support-mail-link" class="t-Button t-Button--small t-Button--link"',
'     href="mailto:artur.rushevich@terex.com"',
'     aria-label="Report an issue to the application owner"',
'     title="Report an issue to the application owner">',
'    <span class="t-Icon fa fa-envelope" aria-hidden="true"></span> Report an Issue',
'  </a>',
'  <span class="xxme-support-note">Opens your default email application.</span>',
'</div>',
'<script>',
'(function () {',
'  "use strict";',
'  var link = document.getElementById("xxme-support-mail-link");',
'  var root = link && link.closest(".u-hidden");',
'  var pageId = Number("&APP_PAGE_ID.");',
'  var appUser = "&APP_USER.";',
'  var pageNames = {',
'    1: "Month End Dashboard",',
'    10: "General Ledger",',
'    11: "GL Unposted Journals",',
'    20: "Payables Accounting Exceptions",',
'    21: "AP Active Holds - Current",',
'    22: "AP Trial Balance Snapshot",',
'    23: "AP Snapshot Analysis",',
'    24: "GL AP Reconciliation",',
'    30: "Receivables Accounting Exceptions",',
unistr('    31: "AR Unapplied Receipts \2014 Current",'),
'    32: "AR Open Balance Snapshot",',
'    33: "AR Aging Analysis",',
'    34: "GL AR Reconciliation",',
'    41: "Cost Management SLA",',
'    42: "SLA Accounting Errors",',
'    50: "AI Month-End Analyst",',
'    60: "Period Status",',
'    61: "Inventory Pending Transactions",',
'    92: "AI Conversation Review",',
'    93: "AI Conversation Detail",',
'    94: "AI Provider Comparison",',
'    95: "Purge AI Conversation History",',
'    96: "AI Knowledge Manager",',
'    97: "Knowledge Workspace",',
'    98: "Knowledge Test and Publish",',
'    99: "Knowledge History and Source Requests",',
'  };',
'  if (!root || !link || pageId === 9998 || pageId === 9999) {',
'    return;',
'  }',
'  var pageName = pageNames[pageId] || document.title || ("Page " + pageId);',
'  var subject = "[App 115 Support] Page " + pageId + " - " + pageName;',
'  var body = "User: " + appUser + "\r\n" +',
'             "Application: App 115 - TMS GBS Control Tower\r\n" +',
'             "Page: " + pageId + " - " + pageName + "\r\n\r\n" +',
'             "Please describe the issue:";',
'  link.href = "mailto:artur.rushevich@terex.com?subject=" + encodeURIComponent(subject) +',
'              "&body=" + encodeURIComponent(body);',
'  root.classList.remove("u-hidden");',
'}());',
'</script>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1017678062229078165)
,p_plug_name=>'Page Name'
,p_static_id=>'app-page-name'
,p_region_css_classes=>'u-hidden t-Region--hideHeader'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4504868307683981366
,p_plug_display_sequence=>1
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="t-BreadcrumbRegion t-BreadcrumbRegion--useRegionTitle">',
'  <div class="t-BreadcrumbRegion-body">',
'    <div class="t-BreadcrumbRegion-titleText">',
'      <h1 id="xxme-page-name-heading" class="t-BreadcrumbRegion-title"></h1>',
'    </div>',
'  </div>',
'</div>',
'<script>',
'document.addEventListener("DOMContentLoaded", function () {',
'apex.jQuery(function ($) {',
'  "use strict";',
'  var pageId = Number("&APP_PAGE_ID.");',
'  var heading = document.getElementById("xxme-page-name-heading");',
'  var root = document.getElementById("app-page-name") ||',
'    (heading && heading.closest(".u-hidden.t-Region--hideHeader"));',
'  var pageNames = {',
'    1: "Month End Dashboard",',
'    10: "General Ledger",',
'    11: "GL Unposted Journals",',
'    20: "Payables Accounting Exceptions",',
'    21: "AP Active Holds - Current",',
'    22: "AP Trial Balance Snapshot",',
'    23: "AP Snapshot Analysis",',
'    24: "GL AP Reconciliation",',
'    30: "Receivables Accounting Exceptions",',
'    31: "AR Unapplied Receipts - Current",',
'    32: "AR Open Balance Snapshot",',
'    33: "AR Aging Analysis",',
'    34: "GL AR Reconciliation",',
'    41: "Cost Management SLA",',
'    42: "SLA Accounting Errors",',
'    50: "AI Month-End Analyst",',
'    60: "Period Status",',
'    61: "Inventory Pending Transactions",',
'    92: "AI Conversation Review",',
'    93: "AI Conversation Detail",',
'    94: "AI Provider Comparison",',
'    95: "Purge AI Conversation History",',
'    96: "AI Knowledge Manager",',
'    97: "Knowledge Workspace",',
'    98: "Knowledge Test and Publish",',
'    99: "Knowledge History and Source Requests",',
'  };',
'  if (!root || !heading || pageId === 9998 || pageId === 9999) { return; }',
'  var hasVisibleHeading = $("h1").not("#xxme-page-name-heading").filter(function () {',
'    return $(this).is(":visible") && $.trim($(this).text()).length > 0;',
'  }).length > 0;',
'  if (hasVisibleHeading) { return; }',
'  heading.textContent = pageNames[pageId] || document.title || ("Page " + pageId);',
'  root.classList.remove("u-hidden");',
'});',
'}, { once: true });',
'</script>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1282310000000301)
,p_plug_name=>'Appearance actions'
,p_static_id=>'appearance-actions'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4504868307683981366
,p_plug_display_sequence=>9998
,p_plug_display_point=>'BEFORE_FOOTER'
,p_location=>null
,p_plug_source=>'<script defer src="#APP_FILES#appearance.js?v=99bb745118"></script>'
,p_plug_display_condition_type=>'USER_IS_NOT_PUBLIC_USER'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(202852832601954546)
,p_plug_name=>'Notice'
,p_static_id=>'poc-scope-notice'
,p_region_css_classes=>'t-Region--hideHeader'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4504868307683981366
,p_plug_display_sequence=>1
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_07'
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<style id="xxme-report-heading-weight">',
'.a-IRR-table thead th,',
'.a-IRR-table thead th *,',
'.a-IRR-header,',
'.a-IRR-headerLink,',
'.a-GV-table thead th,',
'.a-GV-table thead th *,',
'.a-GV-header,',
'.a-GV-headerLabel,',
'.t-Report-report thead th,',
'.t-Report-report thead th *,',
'.t-Report-colHead {',
'  font-weight: 700 !important;',
'}',
'</style>',
'<div style="',
'    display:flex;',
'    align-items:center;',
'    gap:10px;',
'    padding:7px 14px;',
'    border-left:5px solid #b86e00;',
'    background:#fff8e7;',
'    color:#3a2a12;',
'    font-size:0.9rem;',
'    line-height:1.3;',
'">',
'  <span class="fa fa-warning"',
'        aria-hidden="true"',
'        style="',
'            flex:0 0 auto;',
'            color:#b86e00;',
'            font-size:1.15rem;',
'        ">',
'  </span>',
'',
'  <span>',
unistr('    <strong>Proof of Concept \2014 Limited Scope:</strong>'),
'    Read-only dashboard for',
'    <strong>TEREX US</strong>,',
'    <strong>TEREX UK 120</strong>, and',
'    <strong>TEREX CH</strong>.',
'    Not an enterprise-wide TMS month-end status.',
'  </span>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp.component_end;
end;
/
