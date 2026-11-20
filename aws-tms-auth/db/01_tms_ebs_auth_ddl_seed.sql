prompt -- 01_tms_ebs_auth_ddl_seed.sql
prompt -- Creates XX_TMS_AUTH_CONFIG and XX_TMS_USERS in GL_ACCOUNTS and seeds initial configuration and users.
set define off
whenever sqlerror continue none

declare
  l_cnt pls_integer;
begin
  select count(*)
    into l_cnt
    from user_tables
   where table_name = 'XX_TMS_AUTH_CONFIG';

  if l_cnt = 0 then
    execute immediate q'[
      create table xx_tms_auth_config (
        config_code   varchar2(30)  default 'DEFAULT'   not null,
        ebs_login_url varchar2(500)                     not null,
        enabled_yn    char(1)       default 'Y'         not null,
        updated_on    timestamp with time zone default systimestamp not null,
        updated_by    varchar2(255) default 'SYSTEM'    not null,
        constraint xx_tms_auth_config_pk  primary key (config_code),
        constraint xx_tms_auth_config_ck1 check (config_code = 'DEFAULT'),
        constraint xx_tms_auth_config_ck2 check (
          regexp_like(
            ebs_login_url,
            '^https://[A-Za-z0-9.-]+(:[0-9]+)?/OA_HTML/(AppsLocalLogin[.]jsp|RF[.]jsp[?]function_id=mLogin)$',
            'i'
          )
        ),
        constraint xx_tms_auth_config_ck3 check (enabled_yn in ('Y', 'N'))
      )
    ]';
  end if;

  select count(*)
    into l_cnt
    from user_tables
   where table_name = 'XX_TMS_USERS';

  if l_cnt = 0 then
    execute immediate q'[
      create table xx_tms_users (
        ebs_user_name       varchar2(100)                     not null,
        local_user_email    varchar2(255),
        full_name           varchar2(255),
        email_address       varchar2(255),
        enabled_yn          char(1)       default 'Y'         not null,
        is_console_admin_yn char(1)       default 'N'         not null,
        notes               varchar2(1000),
        created_on          timestamp with time zone default systimestamp not null,
        created_by          varchar2(255) default 'SYSTEM'    not null,
        updated_on          timestamp with time zone default systimestamp not null,
        updated_by          varchar2(255) default 'SYSTEM'    not null,
        constraint xx_tms_users_pk  primary key (ebs_user_name),
        constraint xx_tms_users_u1  unique (local_user_email),
        constraint xx_tms_users_ck1 check (
          ebs_user_name = upper(trim(ebs_user_name))
          and regexp_like(ebs_user_name, '^[A-Z0-9][A-Z0-9._@-]*$', 'c')
        ),
        constraint xx_tms_users_ck2 check (
          local_user_email is null
          or (
            local_user_email = lower(trim(local_user_email))
            and regexp_like(local_user_email, '^[[:alnum:]._%+-]+@terex[.]com$', 'i')
          )
        ),
        constraint xx_tms_users_ck3 check (
          email_address is null
          or email_address = lower(trim(email_address))
        ),
        constraint xx_tms_users_ck4 check (enabled_yn in ('Y', 'N')),
        constraint xx_tms_users_ck5 check (is_console_admin_yn in ('Y', 'N'))
      )
    ]';
  end if;
end;
/

merge into xx_tms_auth_config t
using (
  select 'DEFAULT'                                           as config_code,
         'https://erptex.terex.com/OA_HTML/AppsLocalLogin.jsp' as ebs_login_url,
         'Y'                                                 as enabled_yn
    from dual
) s
   on (t.config_code = s.config_code)
 when matched then
   update set
     t.ebs_login_url = nvl(t.ebs_login_url, s.ebs_login_url)
 when not matched then
   insert (
     config_code, ebs_login_url, enabled_yn, updated_on, updated_by
   ) values (
     s.config_code, s.ebs_login_url, s.enabled_yn, systimestamp, 'MIGRATION'
   );

merge into xx_tms_users t
using (
  select 'ARTUR.RUSHEVICH'     as ebs_user_name, 'artur.rushevich@terex.com'     as local_user_email, 'Artur Rushevich'     as full_name, 'Y' as enabled_yn, 'Y' as is_console_admin_yn, cast(null as varchar2(1000)) as notes from dual union all
  select 'JOHN.MULROE'         as ebs_user_name, 'john.mulroe@terex.com'         as local_user_email, 'John Mulroe'         as full_name, 'Y' as enabled_yn, 'N' as is_console_admin_yn, cast(null as varchar2(1000)) as notes from dual union all
  select 'AMBER.DIMARCO'       as ebs_user_name, 'amber.dimarco@terex.com'       as local_user_email, 'Amber Dimarco'       as full_name, 'Y' as enabled_yn, 'N' as is_console_admin_yn, cast(null as varchar2(1000)) as notes from dual union all
  select 'BENJAMIN.CZECH'      as ebs_user_name, 'benjamin.czech@terex.com'      as local_user_email, 'Benjamin Czech'      as full_name, 'Y' as enabled_yn, 'N' as is_console_admin_yn, cast(null as varchar2(1000)) as notes from dual union all
  select 'BRYAN.KEAN'          as ebs_user_name, 'bryan.kean@terex.com'          as local_user_email, 'Bryan Kean'          as full_name, 'Y' as enabled_yn, 'N' as is_console_admin_yn, cast(null as varchar2(1000)) as notes from dual union all
  select 'CAMERON.BURRY'       as ebs_user_name, 'cameron.burry@terex.com'       as local_user_email, 'Cameron Burry'       as full_name, 'Y' as enabled_yn, 'N' as is_console_admin_yn, cast(null as varchar2(1000)) as notes from dual union all
  select 'CARRIELYN.WEBER'     as ebs_user_name, 'carrielyn.weber@terex.com'     as local_user_email, 'Carrielyn Weber'     as full_name, 'Y' as enabled_yn, 'N' as is_console_admin_yn, 'EBS FND_USER end-dated as of initial migration; local bridge preserved until review.' as notes from dual union all
  select 'CATHERINE.GALLAGHER' as ebs_user_name, 'catherine.gallagher@terex.com' as local_user_email, 'Catherine Gallagher' as full_name, 'Y' as enabled_yn, 'N' as is_console_admin_yn, cast(null as varchar2(1000)) as notes from dual union all
  select 'CHRISTOPHER.WILSON'  as ebs_user_name, 'christopher.wilson@terex.com'  as local_user_email, 'Christopher Wilson'  as full_name, 'Y' as enabled_yn, 'N' as is_console_admin_yn, cast(null as varchar2(1000)) as notes from dual union all
  select 'DAVID.CAMPBELL'      as ebs_user_name, 'david.campbell@terex.com'      as local_user_email, 'David Campbell'      as full_name, 'Y' as enabled_yn, 'N' as is_console_admin_yn, cast(null as varchar2(1000)) as notes from dual union all
  select 'DAVID.WATTS'         as ebs_user_name, 'david.watts@terex.com'         as local_user_email, 'David Watts'         as full_name, 'Y' as enabled_yn, 'N' as is_console_admin_yn, cast(null as varchar2(1000)) as notes from dual union all
  select 'ELAINE.MCILWAINE'    as ebs_user_name, 'elaine.mcilwaine@terex.com'    as local_user_email, 'Elaine McIlwaine'    as full_name, 'Y' as enabled_yn, 'N' as is_console_admin_yn, cast(null as varchar2(1000)) as notes from dual union all
  select 'JENNIFER.DEVINE'     as ebs_user_name, 'jennifer.devine@terex.com'     as local_user_email, 'Jennifer Devine'     as full_name, 'Y' as enabled_yn, 'N' as is_console_admin_yn, cast(null as varchar2(1000)) as notes from dual union all
  select 'NIALL.CREEVY'        as ebs_user_name, 'niall.creevy@terex.com'        as local_user_email, 'Niall Creevy'        as full_name, 'Y' as enabled_yn, 'N' as is_console_admin_yn, cast(null as varchar2(1000)) as notes from dual union all
  select 'RICCARDO.BARGIGIA'   as ebs_user_name, 'riccardo.bargigia@terex.com'   as local_user_email, 'Riccardo Bairgigia'  as full_name, 'Y' as enabled_yn, 'N' as is_console_admin_yn, cast(null as varchar2(1000)) as notes from dual union all
  select 'SOPHIE.GORMAN'       as ebs_user_name, 'sophie.gorman@terex.com'       as local_user_email, 'Sophie Gorman'       as full_name, 'Y' as enabled_yn, 'N' as is_console_admin_yn, cast(null as varchar2(1000)) as notes from dual union all
  select 'STEVEN.STEWART'      as ebs_user_name, 'steven.stewart@terex.com'      as local_user_email, 'Steven Stewart'      as full_name, 'Y' as enabled_yn, 'N' as is_console_admin_yn, cast(null as varchar2(1000)) as notes from dual
) s
   on (t.ebs_user_name = s.ebs_user_name)
 when matched then
   update set
     t.local_user_email = coalesce(t.local_user_email, s.local_user_email),
     t.full_name        = coalesce(t.full_name, s.full_name),
     t.email_address    = coalesce(t.email_address, s.local_user_email),
     t.notes            = coalesce(t.notes, s.notes)
 when not matched then
   insert (
     ebs_user_name,
     local_user_email,
     full_name,
     email_address,
     enabled_yn,
     is_console_admin_yn,
     notes,
     created_on,
     created_by,
     updated_on,
     updated_by
   ) values (
     s.ebs_user_name,
     s.local_user_email,
     s.full_name,
     s.local_user_email,
     s.enabled_yn,
     s.is_console_admin_yn,
     s.notes,
     systimestamp,
     'MIGRATION',
     systimestamp,
     'MIGRATION'
   );

commit;
set define on
