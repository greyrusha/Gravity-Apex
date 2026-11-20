-- 99_deploy_all.sql
-- Master TMS EBS Auth & Security Hardening deployment script for GL_ACCOUNTS on APEXQ_AWS
-- Run from SQLcl connected to APEXQ_AWS (note relative paths from c:\Dev\ebs-sla if using sqlcl_ebs).
whenever sqlerror continue none
set define off

prompt === Step 1: Create XX_TMS_AUTH_CONFIG & XX_TMS_USERS + seed initial rows ===
@../Gravity-Apex/aws-tms-auth/db/01_tms_ebs_auth_ddl_seed.sql

prompt === Step 2: Deploy XX_TMS_SECURITY_PKG spec and body ===
@../Gravity-Apex/aws-tms-auth/db/02_xx_tms_security_pkg.pks
@../Gravity-Apex/aws-tms-auth/db/03_xx_tms_security_pkg.pkb

prompt === Step 3: Deploy XX_TMS_ADMIN_PKG spec and body ===
@../Gravity-Apex/aws-tms-auth/db/04_xx_tms_admin_pkg.pks
@../Gravity-Apex/aws-tms-auth/db/05_xx_tms_admin_pkg.pkb

prompt === Step 4: Verify zero PL/SQL compilation errors ===
select name, type, line, position, text
  from user_errors
 where name in ('XX_TMS_SECURITY_PKG', 'XX_TMS_ADMIN_PKG')
 order by name, type, sequence;

prompt === Step 5: Deploy App 400 + Page 9999 & Register App 126 ===
apex validate -input ../Gravity-Apex/aws-tms-auth/apex/app400/tms-admin-console
apex validate -input ../Gravity-Apex/aws-tms-auth/apex/app300/awp-alpine-ic
@../Gravity-Apex/aws-tms-auth/db/f400.sql
@../Gravity-Apex/aws-tms-auth/db/07_register_app126_tms.sql

prompt === Step 6: Apply Surgical Security Component Patches (128, 115, 300, 126, 400) ===
@../Gravity-Apex/aws-tms-auth/db/06_app128_ebs_auth_component_patch.sql
@../Gravity-Apex/aws-tms-auth/db/08_app115_ebs_auth_component_patch.sql
@../Gravity-Apex/aws-tms-auth/db/09_app300_ebs_auth_component_patch.sql
@../Gravity-Apex/aws-tms-auth/db/10_app126_ebs_auth_component_patch.sql
@../Gravity-Apex/aws-tms-auth/db/11_app400_p9999_patch.sql

prompt === Step 7: Post-deploy verification ===
select application_id, application_name, alias, is_working_copy, main_application_id,
       authentication_scheme, authorization_scheme, authorize_public_pages
  from apex_applications
 where application_id in (115, 126, 128, 300, 400)
 order by application_id;

select application_id, authentication_scheme_name, cookie_name, cookie_secure, cookie_path
  from apex_application_auth
 where application_id in (115, 126, 128, 300, 400)
   and is_current_authentication = 'Y'
 order by application_id;

select application_id, page_id, validation_name, validation_type_code, error_message
  from apex_application_page_val
 where application_id in (115, 126, 128, 300, 400)
   and page_id = 9999
 order by application_id;

prompt === Step 8: Deploy P0-2 & P0-3 Fixes (AP Trial Balance Pkg + Pages Patch 128 & 115) ===
@../Gravity-Apex/aws-tms-auth/db/12_xx_ap_trial_balance_pkg.pks
@../Gravity-Apex/aws-tms-auth/db/13_xx_ap_trial_balance_pkg.pkb
@../Gravity-Apex/aws-tms-auth/db/14_app128_p0_2_p0_3_patch.sql
@../Gravity-Apex/aws-tms-auth/db/15_app115_p0_2_p0_3_patch.sql

prompt === Step 9: Post-deploy verification (P0-2 & P0-3) ===
select name, type, line, position, text
  from user_errors
 where name = 'XX_AP_TRIAL_BALANCE_PKG'
 order by type, sequence;

select application_id, page_id, process_name,
       case when lower(process_source) like '%acquire_snapshot_lock%' then 1 else 0 end as has_pkg_lock,
       case when lower(process_source) like '%for update%' then 1 else 0 end as has_raw_for_update
  from apex_application_page_proc
 where application_id in (115, 128)
   and page_id = 22
   and process_name = 'P22_LOAD_SNAPSHOT'
 order by application_id;

select application_id, page_id, region_name,
       case when lower(region_source) like '%open_accounted_amount%' then 1 else 0 end as has_open_amt,
       case when lower(region_source) like '%acct_invoice_amount%' then 1 else 0 end as has_acct_inv_amt
  from apex_application_page_regions
 where application_id in (115, 128)
   and page_id = 23
   and region_name = 'Aging Distribution'
 order by application_id;

select application_id,
       list_of_values_name,
       lov_type,
       source_type_code,
       return_column_name,
       display_column_name,
       default_sort_column_name,
       default_sort_direction
  from apex_application_lovs
 where application_id in (115, 128)
   and list_of_values_name = 'TMS_CLOSE_PERIODS'
 order by application_id;

select application_id,
       count(*) as period_item_cnt,
       sum(case when lov_named_lov = 'TMS_CLOSE_PERIODS' then 1 else 0 end) as shared_lov_cnt,
       sum(case when item_default like '%trunc(sysdate - 7, ''MM'')%' then 1 else 0 end) as smart_default_cnt
  from apex_application_page_items
 where application_id in (115, 128)
   and page_id in (1, 10, 11, 20, 30, 41, 50, 61)
   and item_name like '%PERIOD_NAME'
 group by application_id
 order by application_id;

prompt === Step 10: Deploy Wave 1 Stability, UX & Security Quick Wins (XXME_* + Apps 128 & 115) ===
set define off
@../Gravity-Apex/aws-tms-auth/db/16_xxme_pipelined_cursor_fixes.sql
@../Gravity-Apex/aws-tms-auth/db/17_app128_wave1_patch.sql
@../Gravity-Apex/aws-tms-auth/db/18_app115_wave1_patch.sql

prompt === Step 11: Post-deploy verification (Wave 1) ===
select name, type, line, position, text
  from user_errors
 where name like 'XX%'
 order by name, type, sequence;

select object_name, object_type, status
  from user_objects
 where object_name like 'XX%'
   and status <> 'VALID'
 order by object_type, object_name;

select application_id,
       page_id,
       item_name,
       item_protection_level,
       dbms_lob.substr(attributes, 200, 1) as attrs_snippet
  from apex_application_page_items
 where application_id in (115, 128)
   and item_name in (
     'P10_GL_UNPOSTED_URL','P20_ACTIVE_HOLDS_URL','P23_BACK_URL','P24_BACK_URL',
     'P30_AR_UNAPPLIED_URL','P33_BACK_URL','P34_BACK_URL','P42_RETURN_URL'
   )
 order by application_id, page_id, item_name;

select application_id,
       case when lower(dbms_lob.substr(region_source, 4000, 1)) like '%from modules m%' then 1 else 0 end as has_module_scaffold,
       case when lower(dbms_lob.substr(region_source, 4000, 1)) like '%''kpi-good''%' then 1 else 0 end as has_dynamic_status
  from apex_application_page_regions
 where application_id in (115, 128)
   and page_id = 1
   and region_name = 'MONTH_END_OVERVIEW'
 order by application_id;

select application_id, application_name, pages, to_char(last_updated_on, 'YYYY-MM-DD HH24:MI:SS') as last_updated_on
  from apex_applications
 where application_id = 127;

prompt === Step 12: Deploy Wave 2 SQL Performance Tuning & Package Consolidation (XXME_* + Apps 128 & 115) ===
set define off
@../Gravity-Apex/aws-tms-auth/db/19_xxme_sla_gl_perf_tuning.sql
@../Gravity-Apex/aws-tms-auth/db/13_xx_ap_trial_balance_pkg.pkb
@../Gravity-Apex/aws-tms-auth/db/20_xxme_wave2_page_pkgs.sql
@../Gravity-Apex/aws-tms-auth/db/21_app128_wave2_perf_patch.sql
@../Gravity-Apex/aws-tms-auth/db/22_app115_wave2_perf_patch.sql

prompt === Step 13: Post-deploy verification (Wave 2) ===
select name, type, line, position, text
  from user_errors
 where name like 'XX%'
 order by name, type, sequence;

select object_name, object_type, status
  from user_objects
 where object_name like 'XX%'
   and status <> 'VALID'
 order by object_type, object_name;

select application_id,
       count(*) as patched_pages
  from apex_application_pages
 where application_id in (115, 128)
   and page_id in (60, 61, 70, 71, 72)
 group by application_id
 order by application_id;

select application_id,
       sum(case when dbms_lob.instr(lower(region_source), 'wsh_delivery_assignments_v') > 0 then 1 else 0 end) as wsh_view_refs
  from apex_application_page_regions
 where application_id in (115, 128)
 group by application_id
 order by application_id;

select application_id, application_name, pages, to_char(last_updated_on, 'YYYY-MM-DD HH24:MI:SS') as last_updated_on
  from apex_applications
 where application_id = 127;
