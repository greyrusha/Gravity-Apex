prompt -- 07_register_app126_tms.sql
prompt -- Registers Working Copy App 126 (AWP_ENHANCEMENTS) in XX_TMS_APPLICATION and copies AWP access assignments.
set define off
whenever sqlerror continue none

merge into xx_tms_application t
using (
  select 'AWP_ENHANCEMENTS' as application_code,
         126                as apex_application_id,
         'AWP Alpine IC Inventory Reconciliation - Sold Units DEV' as application_name,
         'CENTRAL'          as access_mode,
         'Y'                as enabled_yn
    from dual
) s
   on (t.application_code = s.application_code)
 when matched then
   update set
     t.apex_application_id = s.apex_application_id,
     t.application_name    = s.application_name,
     t.access_mode         = s.access_mode,
     t.enabled_yn          = s.enabled_yn
 when not matched then
   insert (
     application_code,
     apex_application_id,
     application_name,
     access_mode,
     enabled_yn,
     created_by
   ) values (
     s.application_code,
     s.apex_application_id,
     s.application_name,
     s.access_mode,
     s.enabled_yn,
     'MIGRATION'
   );

merge into xx_tms_user_access t
using (
  select ua.user_name,
         'AWP_ENHANCEMENTS' as application_code
    from xx_tms_user_access ua
   where ua.application_code = 'AWP'
) s
   on (t.user_name = s.user_name and t.application_code = s.application_code)
 when not matched then
   insert (
     user_name,
     application_code,
     granted_by
   ) values (
     s.user_name,
     s.application_code,
     'MIGRATION'
   );

commit;
set define on
