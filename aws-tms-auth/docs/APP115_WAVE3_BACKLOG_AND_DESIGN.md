# App 115 & App 128 — Wave 3 Backlog & Technical Specification

**Date:** 2026-11-20  
**Environment:** `APEXQ_AWS` (`QTRXAPX` — Oracle AI Database `23.26.1.0.0`, Oracle APEX `26.2.0`), Parsing Schema `GL_ACCOUNTS`  
**EBS Source:** Oracle EBS 12.2 Active Data Guard (`@ADG` → `PTRXI`, strictly read-only)  
**Applications in Scope:**
- **App `115`** — *TMS GBS Control Tower* (Live, `32` pages)
- **App `128`** — *TMS GBS Control Tower Enhancements* (Active Working Copy, `33` pages)

---

## 1. Non-Negotiable Scope & Safety Guardrails

1. **Zero Impact on App `127` & App `500`:** **NEVER** modify **App `127`** (*AP Creditor Ledger By Transaction*, `10` pages, `last_updated_on = '2026-10-09 09:13:51'`) or App `500` `CNV_*` objects (e.g., `CNV_PROJECT_RESET_PKG`).
2. **EBS `@ADG` Is Strictly Read-Only:** Never generate or execute DML/DDL against Oracle EBS base tables over `@ADG`. No live `@ADG` queries in APEX pages or page-level anonymous blocks (refactor into PL/SQL packages / local MVs per [AGENTS.md](file:///c:/Dev/Gravity-Apex/AGENTS.md)).
3. **SQLcl MCP Execution Safety:** **Never** include `WHENEVER SQLERROR EXIT` in SQL scripts executed via SQLcl MCP (use `whenever sqlerror continue none` and explicit verification queries).
4. **Change Control:** Generate all scripts as workspace files first and execute DDL/DML only after explicit user confirmation, with `set define off`, zero `USER_ERRORS`, and exact row/balance regression parity.

---

## 2. Already-Completed Baseline (`aws-tms-auth/db/99_deploy_all.sql` Steps `1–13`)

The following remediations are **already deployed** in `GL_ACCOUNTS@APEXQ_AWS` across Apps `128` and `115` and passed both DB smoke tests and the live embedded Chrome E2E verification run on `2026-11-20`:

| Phase | Script(s) in `aws-tms-auth/db/` | Summary of Completed Work |
|---|---|---|
| **Security Cutover** | `01`–`11` | Central `EBS Credentials` auth (`xx_tms_security_pkg.authenticate_ebs`) + App `400` (*TMS Administration Console*) authorization across Apps `115, 126, 128, 300, 400`; deleted public `Page 9998`; enabled app-level `TMS Application Access`; updated `Page 9999` with `TMS (Windows)` wording & `@terex.com` rejection validation; HTML-escaped `P62_ORG_NAME` & `P62_PERIOD_NAME` on `Page 62`. |
| **P0-2 & P0-3 Fixes** | `12`–`15` | Fixed `XX_AP_TRIAL_BALANCE_PKG.get_ap_aging_by_supplier` and `Page 23` (`Aging Distribution`) to age `open_accounted_amount` instead of `acct_invoice_amount`; implemented `AUTONOMOUS_TRANSACTION` + `FOR UPDATE NOWAIT` in `acquire_snapshot_lock` (`Page 22`); created Shared LOV `TMS_CLOSE_PERIODS` (`1 future + 1 current + 4 priors`) + `trunc(sysdate - 7, 'MM')` smart default across 8 pages (`1, 10, 11, 20, 30, 41, 50, 61`). |
| **Wave 1 (Stability, UX, Security)** | `16`–`18` | Added `WHEN NO_DATA_NEEDED` cursor cleanup + `BULK COLLECT LIMIT 500` across 9 `XXME_*` pipelined packages; fixed `Page 1` disappearing `0`-exception AP/AR cards (`from modules m` scaffold) and added dynamic severity CSS (`kpi-good`/`kpi-warn`); set `Value Protected = Yes` on 8 `P*_URL` items. |
| **Wave 2 (SQL Perf & Packaging)** | `19`–`22` | Full `@ADG` remote pushdown + future-period short-circuit + `hr_all_organization_units_tl@ADG` in `XXME_GL_SUMMARY_PKG`, `XXME_AP_AR_DETAIL_PKG`, `XXME_AP_AR_KPI_PKG`, `XXME_SLA_SUMMARY_PKG`; Fetch 3 `FULL(xah)` tuning on `Page 24`; consolidated `Pages 60, 61, 70, 71, 72` into `XXME_INV_PENDING_UI_PKG`, `XXME_PROCESS_MONITOR_PKG`, `XXME_FA_CLOSE_PKG` (eliminating `wsh_delivery_assignments_v` & `REPLACE` literal leaks). |

---

## 3. Executive Decision Summary (Items `1–11`)

| # | Area | Target Scope | Baseline Observation | Agreed Decision | Sub-Wave |
|---|---|---|---|---|---|
| **1** | **AR & AP Reconciliation Speed** | `Pages 32, 22 & 24` (`XXME_AR_RECON_V2_PKG`, `XX_AP_TRIAL_BALANCE_PKG`) | `Page 32` UK load: `42.7 s` (`797` rows); `Page 22` UK load: `23.3 s` (`20,926` rows); `Page 24`: `14.5 s`. | **Option 1A/1B + 1C (Keep ITD):** Tune `XXME_AR_RECON_V2_PKG` & `XX_AP_TRIAL_BALANCE_PKG` `populate_snapshot` (zero output change); keep `Page 24` Fetch 4 inception-to-date logic and switch to `GL_JE_LINES_N1` index access. | **3A** (DB Perf) |
| **2** | **Home Dashboard Initial Load** | `Page 1` (`MONTH_END_OVERVIEW`) | `~9.5 s` (`SEP-2026`) / `~16.7 s` (`OCT-2026`); 8 sequential `@ADG` round trips in 55-line inline SQL. | **Option A:** Move into `XXME_DASHBOARD_PKG.get_overview_cards`, validate period bounds once, combine AP (`200`) + AR (`222`) SLA pass, keep 100% live counts. | **3A + 3B** |
| **3** | **Remaining Inline `@ADG` SQL & Blocks** | `Pages 60, 62, 42` + Ledger LOVs (`22, 32, 70, 71, 73`) | `13 KB` inline SQL on `Page 60`; 72-line block (`Page 62`); 35-line block (`Page 42`); 4+ `@ADG` Ledger LOVs. | **Option A:** Refactor into `XXME_PERIOD_STATUS_PKG`, `XXME_INV_PENDING_UI_PKG`, `XXME_DB_SOURCE_PKG`, and Shared LOV `TMS_APPROVED_LEDGERS` (`0` `@ADG` SQL left in pages). | **3A + 3B** |
| **4** | **Process Monitor & FA Period LOV** | `Page 70` (`XXME_PROCESS_MONITOR_PKG`) & `Page 71` (`P71_PERIOD_NAME`) | `Page 70` scans 15+ yrs of `gl_je_headers@ADG` + 2 dead `NEVER` items; `Page 71` uses `@ADG` Popup LOV (`Previous month`). | **6-Month Bound + `TMS_CLOSE_PERIODS`:** Bound `Page 70` RV/RS to `6` months (`ADD_MONTHS(TRUNC(SYSDATE,'MM'), -5)`) & remove dead `P70_*_PERIOD` items; switch `P71_PERIOD_NAME` to `TMS_CLOSE_PERIODS` + `trunc(sysdate - 7, 'MM')`. | **3A + 3B** |
| **5** | **App `128` Exclusives (`Page 73`)** | `Page 73` (*Inventory Reconciliation*) | Exists only in App `128`; hardcodes numeric `reset_report` IDs & inline `@ADG` LOVs. | **Option A:** Keep `Page 73` **in App `128` only** (do not promote to App `115`), while fixing `reset_report` static-ID portability & `@ADG` LOVs inside App `128`. | **3B** (App `128`) |
| **6** | **Pipelined Cursor Cleanup** | `XXME_AR_RECON_V2_PKG` | `get_gl_reconciliation` lacks `WHEN NO_DATA_NEEDED`; `get_aging_*` lack `normalize_db_link`. | **Option A:** Fold 4-line `WHEN NO_DATA_NEEDED` + `normalize_db_link` polish into `XXME_AR_RECON_V2_PKG` alongside Item 1; leave `XXINV128_PERIOD_PENDING_PKG` untouched. | **3A** |
| **7** | **Hidden Item Protection** | Non-JS hidden items across `Apps 128 & 115` | Only `_URL` items locked; many `P*_DB_LINK` and URL-only drill items remain `Unrestricted`. | **Option A:** Script-scan JS/DA code; enable `Value Protected = Yes` strictly on zero-JS-write hidden items (`P*_DB_LINK`, `P42_*` drill context) and document the JS allowlist. | **3C** |
| **8** | **Security & Retired POC Cleanup** | `XXME_POC_PASSWORD_RESET_PKG` | `is_workspace_admin` already fixed; legacy `XXME_POC_PASSWORD_RESET_PKG` remains compiled. | **Option A:** Verify `0` references across all apps (including App `127`), archive & drop `XXME_POC_PASSWORD_RESET_PKG`; retain the 6 `XXME_POC_*` tables as historical audit logs. | **3A** |
| **9** | **APEX `26.2` Compat & App ID Portability** | `Apps 128 & 115` + `TMS_SET_APPEARANCE` | Internal compat `'26.1'` (`"26.1 to 26.2"` tier); `TMS_SET_APPEARANCE` hardcodes `115`/`128` & raw style IDs. | **Option A:** Retain APEX `26.2` max compat `'26.1'` (`"26.1 to 26.2"`) in both apps and make `TMS_SET_APPEARANCE` dynamic via `:APP_ID` + `apex_application_theme_styles`. | **3C** |
| **10** | **`.apx` Repository `apex validate`** | `Pages 70, 71, 73, 98, 99` | `23` pre-existing validation errors (`NOT_ENTERABLE` Popup LOVs & stale template `1672985690212569356`). | **Option A:** Fix remaining Popup LOV `displayAs` (`POPUP` / `inlinePopup`) and map `Pages 98–99` items to `@/optional-floating` (`1612549609962752680`) → **`0` errors**. | **3B / 3C** |
| **11** | **Excluded AI Module & Old `V1..V4` Copies** | `FEATURE_AI` (`Pages 50, 92–99`) & `XXINV128_RECON_V1..V4_PKG` | `FEATURE_AI = Exclude` (`XXME_AI_*` not deployed); 4 superseded `V1..V4` package copies in `GL_ACCOUNTS` (`XXINV128_REPORT_PKG` still depends on `V4_PKG` → `V2_PKG`). | **Keep Excluded + Archive/Drop `V1` & `V3`:** Leave `FEATURE_AI = Exclude` (track Oracle 26ai `APEX_AI`/Select AI as **Wave 4**); verify `0` deps, archive & drop `XXINV128_RECON_V1_PKG` & `V3_PKG` (keep `V4_PKG` & `V2_PKG` with `XXINV128_REPORT_PKG`). | **3A** / **Wave 4** |

---

## 4. Detailed Item-by-Item Root Causes & Approved Designs

### Item 1 — AR & AP Reconciliation Speed (`Pages 32, 22 & 24`)
* **1A. `Page 32` (`XXME_AR_RECON_V2_PKG.populate_snapshot`) — Baseline `42.7 s` (`797` UK rows):**
  * **Root Causes:**
    1. `selected AS (SELECT /*+ MATERIALIZE DRIVING_SITE(aps) ... */ ...)` pulls open payment schedules across `@ADG` into a local `SYS_TEMP_*` table on `APEXQ_AWS`, and then re-joins that local temp table back across `@ADG` five times (`target_app_after`, `cm_source_app_after`, `approved_adj_after`, `receivable_dist`, and outer `gcc`/`hca`/`hp`).
    2. `ar_payment_schedules_all` is driven globally across all Terex Operating Units before filtering `rcta.set_of_books_id = p.ledger_id`.
    3. `gcc.segment1 = c.company_segment` is applied at the very end after executing application/adjustment rollbacks for all companies in the ledger, and `_VL`/`_KFV` views (`ar_aging_bucket_lines_vl`, `gl_code_combinations_kfv`) add view overhead.
  * **Agreed Design:**
    * Remove local `MATERIALIZE` so the entire query executes inside a single `DRIVING_SITE` remote cursor on `@ADG`.
    * Pre-join `apps.ar_system_parameters_all@ADG` (`set_of_books_id = {LEDGER}`) to constrain `aps.org_id` to the ledger's Operating Units upfront.
    * Join `ra_cust_trx_line_gl_dist_all` → `apps.gl_code_combinations@ADG` (`segment1 = {COMPANY}`) *inside* `selected` before computing `target_app_after`, `cm_source_app_after`, and `approved_adj_after`.
    * Replace `ar_aging_bucket_lines_vl` and `gl_code_combinations_kfv` with base tables (`ar_aging_bucket_lines_b`/`_tl` with `language = 'US'` and `gl_code_combinations`).
    * Preserve **100% identical** column outputs, signs, and balances (verified by snapshot diff).

* **1B. `Page 22` (`XX_AP_TRIAL_BALANCE_PKG.populate_snapshot`) — Baseline `23.3 s` (`20,926` UK rows):**
  * **Already Fixed Prior to Wave 3:** `tb.gl_date < TRUNC(:p_snapshot_date) + 1`, `xte2.application_id = 200`, and grouped `aps_due` inline view are already in [13_xx_ap_trial_balance_pkg.pkb](file:///c:/Dev/Gravity-Apex/aws-tms-auth/db/13_xx_ap_trial_balance_pkg.pkb).
  * **Remaining Bottlenecks & Agreed Design:**
    * Move `apps.gl_code_combinations@ADG` (`segment1 = <company>`) **inside** the `xx` subquery so `xla_trial_balances@ADG` is pruned to the target company before `GROUP BY` and outer joins.
    * Remove rigid `use_nl(xx xte2 aia pvs pv) push_pred(aps_due)` hints that force `100,000+` random index lookups at `20k+` row scale, replace `gl_code_combinations_kfv` with base `gl_code_combinations`, and pass validated literal keys (`DBMS_ASSERT` / `TO_CHAR`) into the remote SQL for optimal standby cardinality estimates.
    * Preserve **100% identical** snapshot rows and `open_accounted_amount` totals.

* **1C. `Page 24` (`XX_AP_TRIAL_BALANCE_PKG.get_ap_gl_reconciliation` Fetch 4) — Baseline `14.5 s`:**
  * **Root Cause:** Hint `/*+ DRIVING_SITE(jl) LEADING(gl gp jh jl) USE_HASH(jl) FULL(jh) */` forces full scans of `gl_je_headers@ADG` and `gl_je_lines@ADG` across ledger history instead of probing the ~3–15 target liability CCIDs.
  * **Agreed Design:** Preserve the **inception-to-date** (`gp.end_date <= :p_period_end_date`) semantics for `GL_YTD_PAYABLES_ACTIVITY`, `GL_YTD_REVALUATION_ACTIVITY`, and `GL_YTD_NON_PAYABLES_ACTIVITY` so numbers never shift, and switch Fetch 4 to drive via `GL_JE_LINES_N1 (code_combination_id, period_name)` → `GL_JE_HEADERS_U1`.

---

### Item 2 — Home Dashboard (`Page 1`) Initial Load
* **Baseline:** `~9.5 s` (`SEP-2026`), `~16.7 s` (`OCT-2026`). `MONTH_END_OVERVIEW` executes 8 sequential `@ADG` round trips via 55 lines of inline SQL calling `xxme_gl_summary_pkg.get_summary` and two separate `xxme_ap_ar_detail_pkg.get_summary` calls (`200` and `222`). Additionally, `XLA_EVENTS_N3` scans unprocessed events globally before filtering `xte.ledger_id IN (1003, 5001, 10001)`.
* **Agreed Design (`Option A`):**
  * Create package `XXME_DASHBOARD_PKG` with `get_overview_cards(p_period_name IN VARCHAR2, p_db_link IN VARCHAR2, p_app_id IN NUMBER)`.
  * Validate period bounds **once** (`GL_PERIOD_STATUSES` on `@ADG` once, not 5×).
  * Query `XLA_EVENTS` / `XLA_AE_HEADERS` for `application_id IN (200, 222)` in a **single combined remote pass** (reducing `@ADG` round trips from 8 to 2 while keeping 100% real-time live figures).
  * Replace `Page 1` `MONTH_END_OVERVIEW` inline SQL with a clean `select ... from table(xxme_dashboard_pkg.get_overview_cards(:P1_PERIOD_NAME, :P1_DB_LINK, :APP_ID))` query preserving the 5-card grid and `kpi-good`/`kpi-warn`/`kpi-bad` styling.

---

### Item 3 — Remaining Inline `@ADG` SQL & Page Anonymous Blocks (`Pages 60, 62, 42` + Ledger LOVs)
* **`Page 60` (`Inventory Organization Details`):** Move the `13 KB` (`~190`-line) inline `@ADG` region query into `xxme_period_status_pkg.get_inv_org_details(p_ledger_id, p_month_offset, p_db_link)` with pre-computed literal date bounds and base tables (`mtl_parameters`, `hr_organization_information`, `hr_all_organization_units_tl`) replacing `org_organization_definitions@ADG` / `hr_operating_units@ADG`. Keep only badge/link formatting in the APEX report query.
* **`Page 62` (`Capture Pending Transaction Snapshot`):** Move the `72`-line `BEFORE_HEADER` anonymous PL/SQL block into `xxme_inv_pending_ui_pkg.capture_p62_snapshot(...)` validating org-to-ledger ownership against base `hr_organization_information@ADG` (`org_information_context = 'Accounting Information'`) instead of `org_organization_definitions@ADG`.
* **`Page 42` (`Resolve Organization Name`):** Replace the `35`-line `BEFORE_HEADER` dynamic SQL block with a 1-line call to `xxme_db_source_pkg.resolve_org_name(p_org_id, p_application_id, p_db_link)` reading `hr_all_organization_units_tl@ADG` (`language = 'US'`).
* **Shared Component LOV `TMS_APPROVED_LEDGERS`:** Define once locally (`TEREX US` → `1003`, `TEREX UK 120` → `5001`, `TEREX CH` → `10001`, ordered cleanly) and attach to `P22_LEDGER_ID`, `P32_LEDGER_ID`, `P70_CA_LEDGERS`, `P70_RS_LEDGERS`, `P70_RV_LEDGERS`, `P71_LEDGER_IDS` (Apps `128 & 115`), and `P73_LEDGER_ID` (App `128`), eliminating all remaining inline `@ADG` LOV queries.

---

### Item 4 — Process Monitor (`Page 70`) 6-Month Bound & Fixed Assets (`Page 71`) Period LOV
* **4A (`Page 70` — `XXME_PROCESS_MONITOR_PKG`):**
  * When `p_period_name IS NULL`, bound `get_revaluations` and `get_reversals` to our standardized **6-month** operational window (`b.creation_date >= ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -5)`) so Oracle avoids scanning 15+ years of `gl_je_headers@ADG` and `gl_je_batches@ADG` just to extract the top 3 monthly runs per ledger.
  * Remove the two dead, `NEVER`-rendered `P70_RS_PERIOD` and `P70_RV_PERIOD` items (which still carry inline `apps.gl_periods@ADG` LOV queries).
* **4B (`Page 71` — `P71_PERIOD_NAME` & `XXME_FA_CLOSE_PKG`):**
  * Convert `P71_PERIOD_NAME` from a `@ADG` `fa_deprn_periods` Popup LOV (`Previous month` null fallback) to a **Select List** bound to Shared LOV **`TMS_CLOSE_PERIODS`** (`1 future + 1 current + 4 priors`) with smart default `select upper(to_char(trunc(sysdate - 7, 'MM'), 'MON-YYYY', 'NLS_DATE_LANGUAGE=English')) from dual`, matching `Pages 1, 10, 11, 20, 30, 41, 61`.
  * Align `xxme_fa_close_pkg.get_close_status` fallback default with `TRUNC(l_now - 7, 'MM')`.

---

### Item 5 — Working Copy App `128` Exclusives (`Page 73` *Inventory Reconciliation*)
* **Promotion Status:** Keep `Page 73` (*Inventory Reconciliation*) and its Navigation Menu entry **exclusively in Working Copy App `128`** for now (`App 115` stays at `32` pages).
* **Portability & LOV Hygiene Inside App `128`:**
  * Fix `P73_STATE` process calls from raw numeric IDs (`apex_ir.reset_report(p_page_id=>73, p_region_id=>15421947847694280, p_report_id=>...)`) to portable static IDs (`p_region_static_id` / `p_report_alias`).
  * Switch `P73_LEDGER_ID` to `TMS_APPROVED_LEDGERS` and align `P73_PERIOD_NAME` away from live `gl_periods@ADG` (using `TMS_CLOSE_PERIODS` or, if UAT confirms historical close periods are needed on Page 73, local `xxinv128_org_period_mv`).

---

### Item 6 — Remaining Pipelined `NO_DATA_NEEDED` Cursor Cleanup
* `XX_AP_TRIAL_BALANCE_PKG` already handles `WHEN NO_DATA_NEEDED`, and `XXINV128_PERIOD_PENDING_PKG` uses implicit `FOR r IN (...)` cursors only (`open_for = 0`).
* Fold the 4-line `WHEN NO_DATA_NEEDED THEN IF l_cursor%ISOPEN THEN CLOSE l_cursor; END IF; RETURN;` handler into `XXME_AR_RECON_V2_PKG.get_gl_reconciliation`, and update `get_aging_detail` / `get_aging_by_customer` to call `normalize_db_link(p_db_link)` alongside Item 1.

---

### Item 7 — Hidden Item Session-State Protection (`Value Protected`)
* Perform a static JS/Dynamic Action write-scan across every page of `App 128` and `App 115` before editing any item.
* Enable `Value Protected = Yes` **only** on hidden items verified to have zero client-side `apex.item(...).setValue(...)` / `$s(...)` writes:
  * All `P*_DB_LINK` hidden items across `Pages 1, 10, 11, 20–24, 30–34, 41, 42, 60, 61` (plus removing legacy `P22_DB_LINK.setValue` on `Page 22`).
  * Pure server/URL-checksum-fed drill context items (`P23_SNAPSHOT_READY`, `P24_CONTEXT_READY`, `P24_LEDGER_ID`, `P33_AGING_BUCKET_ID`, `P33_BUCKET_1..7_LABEL`, `P33_SNAPSHOT_READY`, `P34_AGING_BUCKET_ID`, `P34_CONTEXT_READY`, `P41_RUN_SLA`, `P42_APPLICATION_ID`, `P42_ENTITY_CODE`, `P42_EXCEPTION_TYPE`, `P42_LEDGER_ID`, `P42_ORG_ID`, `P42_ORG_NAME`, `P42_RUN_PERIOD`, `P42_RUN_SLA`, `P42_SOURCE_PAGE`).
* Explicitly preserve `Value Protected = No` on active JS-controller hidden items (allowlist):
  * `Page 22`: `P22_REPORT_READY`, `P22_RUN_AS_OF_DATE`, `P22_RUN_COMPANY`, `P22_RUN_DB_LINK`, `P22_RUN_LEDGER_ID`
  * `Page 23`: `P23_SELECTED_BUCKET`, `P23_SELECTED_VENDOR_ID`
  * `Page 24`: `P24_REPORT_READY`, `P24_SELECTED_CCID`
  * `Page 32`: `P32_REPORT_READY`, `P32_RUN_AGING_BUCKET_ID`, `P32_RUN_COMPANY`, `P32_RUN_DB_LINK`, `P32_RUN_LEDGER_ID`, `P32_RUN_PERIOD_NAME`
  * `Page 33`: `P33_SELECTED_BUCKET_SEQUENCE`, `P33_SELECTED_CUSTOMER_ID`
  * `Page 34`: `P34_REPORT_READY`, `P34_SELECTED_CCID`
  * `Page 60`: `P60_INV_LEDGER_ID`
  * `Page 61`: `P61_ORG_ID`, `P61_READY`, `P61_RUN_ID`, `P61_RUN_PERIOD`, `P61_RUN_RESOLUTION`, `P61_RUN_SOURCE`, `P61_TXN_TYPE`
  * `Page 70`: `P70_ACTIVE_TAB`
  * `Page 73` (`App 128`): `P73_CAPTURE_COLL`, `P73_CCID`, `P73_INTRANSIT_COLL`, `P73_WIP_COLL`

---

### Item 8 — Security Package & Retired POC Object Cleanup
* Confirmed `xx_tms_security_pkg.is_workspace_admin` ([03_xx_tms_security_pkg.pkb](file:///c:/Dev/Gravity-Apex/aws-tms-auth/db/03_xx_tms_security_pkg.pkb#L513-L540)) already enforces `workspace_name = c_workspace`, `account_locked = 'NO'`, and `return l_count > 0` — no code change needed.
* Verify `0` references to `XXME_POC_PASSWORD_RESET_PKG` across `USER_DEPENDENCIES` and all workspace applications (including App `127`).
* Export full spec + body DDL backup of `XXME_POC_PASSWORD_RESET_PKG` into `aws-tms-auth/backups/` and **drop `XXME_POC_PASSWORD_RESET_PKG`** so the legacy hardcoded-password reset routine cannot be invoked directly.
* **Retain** all 6 `XXME_POC_*` tables (`XXME_POC_PW_RESET_USERS`, `XXME_POC_PW_RESET_AUDIT`, `XXME_POC_USER_ADMIN_AUDIT`, `XXME_POC_USER_ADMIN_KEY`, `XXME_POC_USER_ADMIN_REQ`, `XXME_POC_USER_LOAD`) untouched as historical audit records.

---

### Item 9 — APEX `26.2` Compatibility Mode (`"26.1 to 26.2"`) & Portable `TMS_SET_APPEARANCE`
* Verified against APEX `26.2.0` (`apexlang-26-2-inventory/assets/app/app.md`): the highest `compatibilityMode` / `p_compatibility_mode` enum value in APEX `26.2` is `'26.1'` (`"26.1 to 26.2"`). Both Apps `128` and `115` already use `'26.1'` (`"26.1 to 26.2"`), so `'26.1'` is retained (setting `'26.2'` would fail `apex validate`).
* Refactor `TMS_SET_APPEARANCE` (and verify its Light/Dark switcher in UI) to remove hardcoded application IDs (`115`/`128`) and raw style IDs (`1152310000000101`/`1282310000000101`), checking `apex_authentication.is_authenticated` and dynamically resolving `theme_style_id` from `apex_application_theme_styles` for `application_id = to_number(:APP_ID)` and `theme_number = 42`.

---

### Item 10 — `.apx` Repository `apex validate` Cleanliness (`0` Errors)
* Update remaining Popup LOV `display_as` metadata from legacy `'NOT_ENTERABLE'` → `'POPUP'` (`inlinePopup`, retaining `manual_entry = 'N'`) on `Pages 70, 71, 73` (`P70_CA_APPS`, `P70_CA_LEDGERS`, `P70_RS_LEDGERS`, `P70_RV_LEDGERS`, `P71_LEDGER_IDS`, `P73_OU_ID` — while `P70_RS_PERIOD`/`P70_RV_PERIOD` are removed in Item 4 and `P71_PERIOD_NAME`/`P73_LEDGER_ID` become Select Lists).
* Map the 6 stale field template IDs (`1672985690212569356`) on `Pages 98 & 99` to Universal Theme `@/optional-floating` (`1612549609962752680`).
* Gate Sub-Wave 3B on `apex validate` returning **`0` errors**.

---

### Item 11 — Excluded AI Module (`FEATURE_AI`) & Legacy `XXINV128_RECON_V1..V4_PKG` Copies
* **11A (`Pages 50, 92–99`):** Keep `Build Option: FEATURE_AI = Exclude` untouched in Wave 3.
* **Wave 4 Roadmap (Future Scope):** When AI capability is prioritized, replace the excluded legacy `XXME_AI_*` stub pages with Oracle AI Database 26ai `APEX_AI` / Select AI backed by `ANNOTATIONS (ai_context ...)` on local snapshot/MV tables rather than live `@ADG` queries.
* **11B (`XXINV128_RECON_V1_PKG` .. `V4_PKG`):** Dependency audit (`USER_DEPENDENCIES`, `APEX_APPLICATION_*`, `DBMS_SCHEDULER`) showed active `XXINV128_REPORT_PKG` references `XXINV128_RECON_V4_PKG`, which in turn references `XXINV128_RECON_V2_PKG`, whereas `XXINV128_RECON_V1_PKG` and `XXINV128_RECON_V3_PKG` have `0` external dependencies and `0` APEX references. Export full specs and bodies to `aws-tms-auth/backups/` and drop only `XXINV128_RECON_V1_PKG` and `XXINV128_RECON_V3_PKG` (preserving active `XXINV128_RECON_PKG`, `XXINV128_RECON_V4_PKG`, and `XXINV128_RECON_V2_PKG`). Leave App `500` `CNV_*` objects completely untouched.

---

## 5. Proposed Execution Sequence & Verification Gates

### Sub-Wave 3A — Database Packages, Performance Tuning & Legacy Retirement
1. **Capture Baselines (`APEXQ_AWS` / `GL_ACCOUNTS`):** Record before-timings, row counts, and exact `SUM(open_accounted_amount)` / `SUM(accounted_balance_asof)` / `GL_YTD_*` totals for `Pages 32, 22, 24, 1, 60, 70`.
2. **Dependency Audit & Archive:** Confirm `0` references for `XXME_POC_PASSWORD_RESET_PKG`, `XXINV128_RECON_V1_PKG`, and `XXINV128_RECON_V3_PKG` across all workspace apps (including App `127`) and archive DDL to `aws-tms-auth/backups/` (keeping `XXINV128_RECON_V4_PKG` & `V2_PKG` due to `XXINV128_REPORT_PKG` dependency).
3. **Author & Lint DB Scripts:**
   * Updated `XXME_AR_RECON_V2_PKG` (Items `1A + 6`)
   * Updated `13_xx_ap_trial_balance_pkg.pkb` (Items `1B + 1C`)
   * New `XXME_DASHBOARD_PKG` (Item `2`)
   * Extended `XXME_PERIOD_STATUS_PKG`, `XXME_INV_PENDING_UI_PKG`, `XXME_DB_SOURCE_PKG` (Item `3`)
   * Updated `XXME_PROCESS_MONITOR_PKG` & `XXME_FA_CLOSE_PKG` (Item `4`)
   * Retirement script for `XXME_POC_PASSWORD_RESET_PKG` + `XXINV128_RECON_V1_PKG` & `V3_PKG` (Items `8 + 11B`)
   * Run `lint_plsql.py` on all PL/SQL packages before deploy.
4. **Verify DB Gate:** Compile with `set define off`; confirm `USER_ERRORS = 0`, `INVALID = 0` for `XX*`, **100% exact row & balance parity**, and measured speedup across `Pages 32, 22, 24, 1, 60, 70`.

### Sub-Wave 3B & 3C — APEX Component Patches, `.apx` Sync & Browser Regression
1. **Generate Surgical Component Patches (`App 128` first, then `App 115`):**
   * Shared Component LOV `TMS_APPROVED_LEDGERS`
   * Updated `Pages 1, 22, 32, 42, 60, 62, 70, 71` (both Apps `128 & 115`)
   * Updated `Page 73` (`App 128` only)
   * Verified `Value Protected = Yes` hidden items (`Item 7`)
   * Compatibility mode `'26.1'` (`"26.1 to 26.2"`) verified, portable `TMS_SET_APPEARANCE`, Popup LOV `inlinePopup`, and `Pages 98–99` template cleanup (`Items 9 & 10`)
2. **Verify APEX & Repository Gates:**
   * Sync `.apx` files and pass `apex validate` with **`0` errors**.
   * Verify `APEX_APPLICATION_PAGE_REGIONS` and `APEX_APPLICATION_PAGE_ITEMS` have **`0` inline `@ADG` queries**.
   * Verify **App `115` (`32` pages)** vs **App `128` (`33` pages)** (`Page 73` stays `128`-only) and **App `127` untouched (`10` pages, `2026-10-09 09:13:51`)**.
   * Execute embedded browser UI regression suite covering Home `Page 1`, AP (`20–24`), AR (`30–34`), Period Status (`60–62`), Process Monitor (`70`), FA (`71–72`), Light/Dark toggle, and `Page 73` in App `128`.
