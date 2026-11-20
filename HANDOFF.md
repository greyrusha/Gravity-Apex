# Engineering Handoff — EBS Customer OU Rollout Workbench (`App 600`)

**Phase 1 Status:** Complete & Live | **Application:** Oracle APEX `26.2` (`App 600` / `CUST-ROLLOUT`) | **Phase 2 (EBS Target API Load):** Deferred pending business cleansing & Target OU/BSV sign-off

---

## 1. Environment & Runtime Quick Reference

| Item | Value / Configuration |
| :--- | :--- |
| **APEX Application** | **App `600`** (`Alias: CUST-ROLLOUT`, `Name: EBS Customer OU Rollout Workbench`, `mmdVersion: 26.2.0+3479`) |
| **Runtime URL** | http://awndb010.terex.local:7779/ords/r/gl_accounts/cust-rollout/ |
| **Target Host Database** | AWS Oracle AI Database 26ai (`23.26.1.0.0`) — `AWNDB010.terex.local:1526/QTRXAPX` |
| **SQLcl Connection / Schema** | Saved connection `APEXQ_AWS` · Workspace & Parsing Schema: `GL_ACCOUNTS` |
| **Source EBS System** | Oracle EBS R12.2 Production Data Guard over read-only DB link `@ADG` (`/*+ DRIVING_SITE(...) */` mandatory on every `@ADG` query) |
| **Namespace Isolation** | Strictly standalone `XXCR_*` DB objects and `App 600` — **never** modify `App 500`, `CNV_*`, or `XXDC_*` |
| **Active Project (`PROJECT_ID = 1`)** | `AU_AWP_17001_ROLLOUT` — Source OU `14474` (`Terex Australia Pty Ltd`, Ledger `17001`), Segment 7 filter `^1[0-9]{3}$` (AWP / Aerials `1000–1999`), Target OU & Target BSV `NULL` (`TBD` early cleansing mode) |
| **Provisioned EBS Users** | `ARTUR.RUSHEVICH` (`ROLLOUT_ADMIN`), `CAMERON.BURRY` (`ROLLOUT_ADMIN`), `APEX.CONV` (Global: `DATA_STEWARD`; Project `1` override in `XXCR_PROJECT_ACCESS`: `ROLLOUT_ADMIN`) |

---

## 2. Current Progress (Phase 1 — 100% Complete & Live)

### Live Health & Verification Baseline
- **Database Objects:** `0` invalid `XXCR%` objects; `0` `USER_ERRORS`.
- **APEX Build & Runtime Integrity:** `0` compile errors on `apex import -id 600`; all `29` dynamic SQL queries across App `600` verified clean via `DBMS_SQL.PARSE`.
- **Staged Baseline (`Project 1: AU_AWP_17001_ROLLOUT`):**
  - `1,626` Customers
  - `6,094` Sites (`1,479` Sales Currencies, `6,050` RPS flags)
  - `7,142` Site Uses (`1,051` AWP-Genie Reps, `2,585` Tax Refs/ABNs, `1,665` Statement Cycles)
  - `10,651` Contacts (`133` Mobiles)
  - `2,133` Multi-Currency Credit Limit rows (`XXCR_STG_PROFILE_AMTS`)
  - `449` OU Account Relationships (`XXCR_STG_ACCT_RELATES`)
  - `39` Masked Payment & Receipt Instrument rows (`XXCR_STG_PAYMENT_INSTR`, `0` raw bank/card PII)
  - Reference Caches: `46` cached EBS OUs (`XXCR_EBS_OU_CACHE`), `2,610` cached EBS LOV rows across 17 domains (`XXCR_EBS_REF_LOVS`)

### Delivered Phase 1 Capabilities
1. **3-Stream `@ADG` Extraction + Tier 1 & Tier 2 API Completeness (`XXCR_ROLLOUT_PKG`):**
   - Extracts Customers, Sites, Site Uses, and Contacts active via 24-month/Open AR, Open Sales Orders, or Active Service/Warranty Contracts in a single `/*+ DRIVING_SITE */` pass.
   - `enrich_project_api_data` populates Tier 1 & Tier 2 OU-striped TCA/IBY attributes: `RA_ADDRESSES_HZ` Site DFFs, `RA_SITE_USES_HZ` `AWP - GENIE` Rep DFF (`TGT_AWP_GENIE_REP`), Site `TAX_REFERENCE`, Multi-Currency `HZ_CUST_PROFILE_AMTS`, `HZ_CUST_ACCT_RELATE_ALL`, masked `IBY_EXTERNAL_PAYERS_ALL` / `RA_CUST_RECEIPT_METHODS`, Mobile/Fax `HZ_CONTACT_POINTS`, and sibling `STMTS`/`DUN`/`LEGAL` site uses.
2. **Multi-Project Concurrency & SoD Security (`XXCR_SECURITY_PKG`, `Page 0`, `Page 1`, `Page 80`):**
   - Concurrent project workspace switching via global `P0_PROJECT_ID` switcher.
   - Live EBS credential verification against `/OA_HTML/RF.jsp?function_id=mLogin` over HTTPS Basic Auth + immediate `mLogout` (zero passwords or tokens persisted).
   - 4-role Maker-Checker Segregation of Duties (`ROLLOUT_ADMIN`, `FINANCE_APPROVER`, `DATA_STEWARD`, `VIEWER`), per-project role overrides (`XXCR_PROJECT_ACCESS`), anti-lockout admin guard, and `XXCR_ACCESS_AUDIT` trail.
3. **5-Layer Typo-Proof Editing & 4-Stage Validation (`Page 10`, `Page 15`, `Page 50`):**
   - Read-only `displayOnly` Interactive Grid columns, cached `@ADG` Popup LOVs, pre-save row validators (`validate_cust_row`, `validate_site_row`, `validate_site_use_row`, `validate_contact_row`, `validate_prof_amt_row`), `BIU` triggers + hard `CHECK` constraints, modal Guided Edit Drawer (`Page 15`), and exhaustive 4-stage `validate_project` (`VAL-101..VAL-403`) with Finance Checker `ACK_YN` warning sign-off.
4. **Activity-Ranked Deduplication & Connected 8-Tab `.xlsx` Round-Trip (`Page 40`, `Page 10`):**
   - Ranks Customer, Site, Site-Use, and Contact duplicate groups by `Open AR > 24m Trx + Open SO > Primary Flag > Credit Limit` with 1-click dormant duplicate (`$0-AR` / `0-Open-SO`) auto-exclusion and reversible cascade exclusions.
   - Streams an ECMA-376 OpenXML Connected 8-Tab `.xlsx` workbook (plus hidden `9_EBS_LOVs` dropdowns, cascading `INDEX/MATCH` exclusion formulas, conditional strikethrough) via `generate_connected_xlsx`, and parses modified uploads via header-driven `APEX_DATA_PARSER` (`process_excel_upload`) with cross-project `0_Rollout_Summary!B1` guard (`ORA-20401`).

---

## 3. Key Architectural Decisions & EBS R12.2 TCA Rules

1. **OU Credit Profiles Reside on `BILL_TO` Site Uses:** In Terex Multi-OU EBS (`HZ_CUSTOMER_PROFILES` / `HZ_CUST_PROFILE_AMTS`), account-level rows (`SITE_USE_ID IS NULL`) hold global `0.01` / `1` placeholders, whereas Operating-Unit credit limits, profile classes, collectors, statement cycles, AutoCash/grouping rules, and fallback payment terms live on **`BILL_TO` Site-Use rows (`SITE_USE_ID = HZ_CUST_SITE_USES_ALL.SITE_USE_ID`)**.
2. **`MACHINES` vs. `AFTERMARKET` Account Split Protection:** Distinct `HZ_CUST_ACCOUNTS.ACCOUNT_NAME` business streams (`MACHINES` for Capital vs. `AFTERMARKET` for Parts & Service) are intentional splits—even under separate `PARTY_ID`s—and are never collapsed as duplicates.
3. **Shared `HZ_LOCATIONS` Protection (`REUSE_PARTY_SITE` -> `NEW_ADDRESS`):** Staged sites start in `REUSE_PARTY_SITE` mode with a baseline SHA-256 address hash (`SRC_ADDR_HASH`). If any street/city/state/postal/country column is modified, `XXCR_STG_SITES_BIU_TRG` automatically switches `ADDRESS_MODE` to `NEW_ADDRESS` so shared source OU locations are never altered in place.
4. **Flexible `TBD` Target OU / Target BSV Early Cleansing:** `XXCR_PROJECTS` allows `NULL` Target OU and Target BSV during extraction, deduplication, and Excel cleansing; Stage-3 Target OU/BSV COA validations activate once target values are saved.
5. **Masked-Only `IBY` Payment Instruments:** `XXCR_STG_PAYMENT_INSTR` stores only masked bank/card strings (`MASKED_BANK_ACCOUNT_NUM`, `MASKED_CC_NUMBER`) and assignment metadata—never raw bank account or credit card numbers.
6. **Intentional Exclusion of Tier 3 Global TCA & `ZX` Tax Profiles:** `ZX_PARTY_TAX_PROFILE`, `ZX_REGISTRATIONS`, and `RA_CUSTOMERS_HZ` account header DFFs are excluded from staging because `EXTEND_OU` + `REUSE_PARTY_SITE` automatically share global `PARTY_ID` / `PARTY_SITE_ID` / `CUST_ACCOUNT_ID` setups (documented in `Page 90: About This App`).
7. **Internal HTTP Session Cookie vs. Outbound HTTPS EBS Auth:** Outbound EBS `mLogin` credential validation enforces `^https://` (`https://erpdev4tex.terex.com`), while `authentications.apx` omits `secure: true` (`COOKIE_SECURE = 'No'`) on `XXCR_APP600` because users access ORDS over internal HTTP `:7779`.

---

## 4. Open Bugs, Operational Guardrails & Deferred Phase-2 Backlog

### Open Runtime Bugs
- **None (`0` known open runtime bugs).** Recently resolved issues:
  - `Page 15` immediate auto-close on open &rarr; fixed by explicit `fireOnInit: false` on `act-cancel` and `Page 10` refresh actions.
  - `Page 90` render crash & navigation freeze &rarr; fixed `ORA-00904: "ENABLED_FLAG"` to `XXCR_EBS_REF_LOVS.ACTIVE_YN` and set all 7 columns on `live-dict-ig` to `displayOnly`.
  - `Page 15` invalid column identifier &rarr; fixed `TGT_DFF_AWP_GENIE_REP` to `TGT_AWP_GENIE_REP`.
  - `Page 80` per-project role override save/display &rarr; added auto-load of `XXCR_PROJECT_ACCESS`, enhanced `P80_ACC_USERNAME` LOV (`having count(*) > 0`), updated `XXCR_SECURITY_PKG.resolve_active_project` fallback for null `P0_PROJECT_ID`, and aligned `Page 1` Extract button to `@can-admin-project`.

### Compile Status
- **0 Errors / 0 Warnings:** App `600` in [applications/cust-rollout/cust-rollout](file:///C:/Dev/Gravity-Apex/applications/cust-rollout/cust-rollout/application.apx) now uses canonical per-LOV files under `shared-components/lovs/` (`boolean.apx` + 22 `lov-*.apx` files) with the legacy empty `lovs.apx` placeholder retired, resulting in **0 errors and 0 warnings** (`Validation successful.`) on `apex validate`.

### Mandatory Development & Deployment Guardrails
1. **SQLcl Connection for `apex import`:** Always connect via `sqlcl_run('conn -name APEXQ_AWS')` — **never** use the MCP `connect` tool before `apex import`, as it forces JDBC `autoCommit = true` (`ORA-17274`).
2. **APEXlang Dynamic Actions:** Always declare `fireOnInit: false` explicitly on `cancelDialog`, `closeDialog`, `refresh`, and click actions (omitting it defaults `EXECUTE_ON_PAGE_INIT` to `'Yes'`).
3. **Interactive Grid Read-Only Columns:** Always set `type: displayOnly` alongside `queryOnly: true`, keep `allowedOperations: [ update ]`, and pair `whereClause` with `type: tableView`.
4. **Local Shell Restriction:** PowerShell (`run_command`) is blocked by Windows OS policy in this workspace; use `read_file` / `write_file` / `edit_file` and `sqlcl` MCP tools exclusively.

### Deferred Phase-2 Items & Business Triage
1. **Target EBS R12.2 TCA/IBY Public API Execution Engine:** Calling `HZ_CUST_ACCOUNT_V2PUB`, `HZ_CUST_ACCOUNT_SITE_V2PUB`, `HZ_CUSTOMER_PROFILE_V2PUB`, `HZ_CUST_ACCOUNT_ROLE_V2PUB`, `HZ_CONTACT_POINT_V2PUB`, and `IBY_FNDCPT_SETUP_PUB` to create Target OU records is deferred until Target OU/BSV setup and business cleansing complete.
2. **Guided Edit Drawer Scope (`Page 15`):** Modal drawer covers Tabs 1–4 (`CUSTOMER`, `SITE`, `SITE_USE`, `CONTACT`); Tabs 5–7 (`Multi-Currency Credit`, `Account Relationships`, `Payment & Receipt Instruments`) are maintained inline via LOV-constrained Interactive Grids or via the Connected 8-Tab `.xlsx`.
3. **Cutover Review for Manual `NEW_ACCT` / `NEW_ADDRESS` Rows:** Any row manually switched from `EXTEND_OU` / `REUSE_PARTY_SITE` to `NEW_ACCT` or `NEW_ADDRESS` requires manual `ZX` Party/Site Tax Profile and account-header review at cutover.
4. **Project `1` Business Cleansing Backlog:** `4,468` duplicate candidates (`Page 40`) and `4,504` validation rows (`10` errors, `4,494` warnings on `Page 50`) await Data Steward / Finance Approver triage and Target OU/BSV assignment.

---

## 5. Exact Repository File Paths

### Governance & Workspace Rules
| File | Purpose |
| :--- | :--- |
| [AGENTS.md](file:///C:/Dev/Gravity-Apex/AGENTS.md) | Root APEX `26.2` & EBS development governance rules |
| [ebs-tca-rollout.md](file:///C:/Dev/Gravity-Apex/.agents/rules/ebs-tca-rollout.md) | Codified Terex Multi-OU TCA & APEXlang `26.x` / SQLcl traps (Rules `1`–`6`) |
| [blitz-environment.md](file:///C:/Dev/Gravity-Apex/.claude/rules/blitz-environment.md) | Blitz Report EBS instance connection template (`.claude/rules/` & `.agents/rules/`) |
| [.gitignore](file:///C:/Dev/Gravity-Apex/.gitignore) | Repository ignores for OS/editor/log/temp/env/scratch artifacts |

### Database DDL & PL/SQL (`sql/`)
| File | Purpose |
| :--- | :--- |
| [01_xxcr_tables.sql](file:///C:/Dev/Gravity-Apex/sql/01_xxcr_tables.sql) | Baseline DDL for all `XXCR_*` project, staging, duplicate, validation, Excel delta, and security tables |
| [02_xxcr_packages.sql](file:///C:/Dev/Gravity-Apex/sql/02_xxcr_packages.sql) | Core engine `XXCR_ROLLOUT_PKG` (`@ADG` extraction, enrichment, LOV cache, dedup, 4-stage validation, pre-save validators, 8-tab `.xlsx` generator & `APEX_DATA_PARSER` importer) |
| [03_xxcr_site_activity_dups.sql](file:///C:/Dev/Gravity-Apex/sql/03_xxcr_site_activity_dups.sql) | Migration adding Site / Site-Use Open AR, 24m AR counts, Open SO counts, `DUP_ROLE`, and `DUP_COUNT` |
| [04_xxcr_multi_project_and_security.sql](file:///C:/Dev/Gravity-Apex/sql/04_xxcr_multi_project_and_security.sql) | `XXCR_SECURITY_PKG` & security tables (EBS `mLogin`/`mLogout` HTTPS auth, 4-role SoD, per-project overrides, audit) |
| [05_xxcr_lovs_and_constraints.sql](file:///C:/Dev/Gravity-Apex/sql/05_xxcr_lovs_and_constraints.sql) | `XXCR_EBS_REF_LOVS` cache table, data normalization, `CHECK` constraints, and `BIU` validation triggers |
| [06_xxcr_api_completeness_tier1_tier2.sql](file:///C:/Dev/Gravity-Apex/sql/06_xxcr_api_completeness_tier1_tier2.sql) | Tier 1 & Tier 2 TCA/IBY columns, child tables (`XXCR_STG_PROFILE_AMTS`, `XXCR_STG_ACCT_RELATES`, `XXCR_STG_PAYMENT_INSTR`), constraints, and triggers |

### Oracle APEX `26.2` Application `600` (`applications/cust-rollout/cust-rollout/`)
| File | Purpose |
| :--- | :--- |
| [apexlang.json](file:///C:/Dev/Gravity-Apex/applications/cust-rollout/cust-rollout/.apex/apexlang.json) | APEXlang metadata (`mmdVersion: 26.2.0+3479`) |
| [application.apx](file:///C:/Dev/Gravity-Apex/applications/cust-rollout/cust-rollout/application.apx) | Root App `600` (`CUST-ROLLOUT`) definition |
| [default.json](file:///C:/Dev/Gravity-Apex/applications/cust-rollout/cust-rollout/deployments/default.json) | Deployment configuration (`GL_ACCOUNTS` workspace, App `600`, parsing schema `GL_ACCOUNTS`) |
| [page-groups.apx](file:///C:/Dev/Gravity-Apex/applications/cust-rollout/cust-rollout/page-groups.apx) | Application page group definitions (`Administration`) |
| [authentications.apx](file:///C:/Dev/Gravity-Apex/applications/cust-rollout/cust-rollout/shared-components/authentications.apx) | `@ebs-credentials` scheme & `XXCR_APP600` cookie config |
| [authorizations.apx](file:///C:/Dev/Gravity-Apex/applications/cust-rollout/cust-rollout/shared-components/authorizations.apx) | `7` `NOCACHE` SoD & project-scoped authorization schemes |
| [breadcrumb.apx](file:///C:/Dev/Gravity-Apex/applications/cust-rollout/cust-rollout/shared-components/breadcrumbs/breadcrumb.apx) | Shared navigation breadcrumb definition |
| [build-options.apx](file:///C:/Dev/Gravity-Apex/applications/cust-rollout/cust-rollout/shared-components/build-options.apx) | Application build options (`Commented Out`) |
| [component-settings.apx](file:///C:/Dev/Gravity-Apex/applications/cust-rollout/cust-rollout/shared-components/component-settings.apx) | Application-level component & item settings |
| [navigation-menu.apx](file:///C:/Dev/Gravity-Apex/applications/cust-rollout/cust-rollout/shared-components/lists/navigation-menu.apx) | Top-level left sidebar navigation menu |
| [navigation-bar.apx](file:///C:/Dev/Gravity-Apex/applications/cust-rollout/cust-rollout/shared-components/lists/navigation-bar.apx) | Header navigation bar (user badge, About link, Sign Out) |
| [boolean.apx](file:///C:/Dev/Gravity-Apex/applications/cust-rollout/cust-rollout/shared-components/lovs/boolean.apx) | Standard `BOOLEAN` Yes/No shared LOV |
| [lov-yn.apx](file:///C:/Dev/Gravity-Apex/applications/cust-rollout/cust-rollout/shared-components/lovs/lov-yn.apx) | `INCLUDE_YN` LOV (plus 21 sibling `lov-*.apx` static and `XXCR_EBS_REF_LOVS` domain LOV files under `shared-components/lovs/`) |
| [static-files.apx](file:///C:/Dev/Gravity-Apex/applications/cust-rollout/cust-rollout/shared-components/static-files.apx) | App icon static file manifest (`icons/app-icon-*.png`) |
| [theme.apx](file:///C:/Dev/Gravity-Apex/applications/cust-rollout/cust-rollout/shared-components/themes/universal-theme/theme.apx) | Universal Theme (`42`) configuration |
| [supporting-objects.apx](file:///C:/Dev/Gravity-Apex/applications/cust-rollout/cust-rollout/supporting-objects/supporting-objects.apx) | Supporting objects manifest |
| [p00000-global-page.apx](file:///C:/Dev/Gravity-Apex/applications/cust-rollout/cust-rollout/pages/p00000-global-page.apx) | Global `P0_PROJECT_ID` active project & SoD role switcher (`Pages 1, 10, 40, 50`) |
| [p00001-home.apx](file:///C:/Dev/Gravity-Apex/applications/cust-rollout/cust-rollout/pages/p00001-home.apx) | `1. Scope, Extract & Remap` (multi-project KPIs, TBD Target OU/BSV, `@ADG` extract, bulk remapping) |
| [p00010-customers-sites.apx](file:///C:/Dev/Gravity-Apex/applications/cust-rollout/cust-rollout/pages/p00010-customers-sites.apx) | `2. Customer Master Workbench` (8 tabs covering all 7 TCA/IBY entities + Connected 8-Tab `.xlsx` Upload/Deltas) |
| [p00015-edit-record.apx](file:///C:/Dev/Gravity-Apex/applications/cust-rollout/cust-rollout/pages/p00015-edit-record.apx) | `Guided Edit Record Drawer` (modal form drawer for Tabs 1–4 with frozen EBS banner & Popup LOVs) |
| [p00020-site-uses-contacts.apx](file:///C:/Dev/Gravity-Apex/applications/cust-rollout/cust-rollout/pages/p00020-site-uses-contacts.apx) | Legacy bookmark redirect to unified `Page 10` |
| [p00030-excel-roundtrip.apx](file:///C:/Dev/Gravity-Apex/applications/cust-rollout/cust-rollout/pages/p00030-excel-roundtrip.apx) | Legacy bookmark redirect to unified `Page 10` |
| [p00040-find-duplicates.apx](file:///C:/Dev/Gravity-Apex/applications/cust-rollout/cust-rollout/pages/p00040-find-duplicates.apx) | `3. Find Duplicates` (activity-ranked survivor review & 1-click dormant auto-exclude) |
| [p00050-validation-phase.apx](file:///C:/Dev/Gravity-Apex/applications/cust-rollout/cust-rollout/pages/p00050-validation-phase.apx) | `4. Validation & Triage` (4-stage findings & Finance Checker `ACK_YN` warning sign-off) |
| [p00080-security-admin.apx](file:///C:/Dev/Gravity-Apex/applications/cust-rollout/cust-rollout/pages/p00080-security-admin.apx) | `5. Security, Roles & SoD` (EBS user provisioning, per-project overrides, SoD matrix, HTTPS origin config, audit log) |
| [p00090-about.apx](file:///C:/Dev/Gravity-Apex/applications/cust-rollout/cust-rollout/pages/p00090-about.apx) | `About This App` (7-tab guide, Tier 1/2 API coverage, Tier 3 Global TCA/`ZX` exclusion note, live 14-table dictionary) |
| [p09999-login.apx](file:///C:/Dev/Gravity-Apex/applications/cust-rollout/cust-rollout/pages/p09999-login.apx) | `Sign In` (EBS credentials login page) |
