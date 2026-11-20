-- =============================================================================
-- 26_xxme_retire_unused_pkgs.sql
-- Purpose : Wave 3 Item 8 + Item 11 - Verify zero DB/APEX references and retire
--           unused legacy packages:
--             1. XXME_POC_PASSWORD_RESET_PKG  (Item 8)
--             2. XXINV128_RECON_V1_PKG        (Item 11)
--             3. XXINV128_RECON_V3_PKG        (Item 11)
--
-- IMPORTANT SAFETY NOTES:
--   - Do NOT drop XXINV128_RECON_V4_PKG or XXINV128_RECON_V2_PKG:
--     XXINV128_REPORT_PKG calls XXINV128_RECON_V4_PKG -> XXINV128_RECON_V2_PKG.
--   - Keep the 6 XXME_POC_* tables intact.
--   - Archive DDL of the 3 retired packages into backups/wave3_pre_patch_db/
--     BEFORE executing this script (Stage 2 pre-drop backup step).
-- =============================================================================
set define off
set serveroutput on size unlimited
whenever sqlerror continue none

declare
  type t_pkg_list is table of varchar2(128);
  l_targets t_pkg_list := t_pkg_list(
    'XXME_POC_PASSWORD_RESET_PKG',
    'XXINV128_RECON_V1_PKG',
    'XXINV128_RECON_V3_PKG'
  );
  l_pkg         varchar2(128);
  l_exists      number;
  l_dep_cnt     number;
  l_src_cnt     number;
  l_apex_cnt    number;
  l_blocker_cnt number := 0;
  l_details     varchar2(4000);
begin
  dbms_output.put_line('=== Wave 3 Package Retirement Pre-Drop Guard ===');

  for i in 1 .. l_targets.count loop
    l_pkg := l_targets(i);

    select count(*)
      into l_exists
      from user_objects uo
     where uo.object_name=l_pkg
       and uo.object_type in ('PACKAGE','PACKAGE BODY');

    if l_exists = 0 then
      dbms_output.put_line('[SKIP] ' || l_pkg || ' does not exist in schema.');
      continue;
    end if;

    -- 1. Hard PL/SQL / View dependencies (excluding self spec/body)
    select count(*),
           substr(listagg(ud.type || ':' || ud.name, ', ') within group (order by ud.type, ud.name), 1, 3500)
      into l_dep_cnt, l_details
      from user_dependencies ud
     where ud.referenced_name=l_pkg
       and ud.name<>l_pkg;

    -- 2. Dynamic / string mentions in USER_SOURCE (excluding target packages themselves)
    select count(*)
      into l_src_cnt
      from user_source us
     where upper(us.text) like '%' || l_pkg || '%'
       and us.name not in ('XXME_POC_PASSWORD_RESET_PKG','XXINV128_RECON_V1_PKG','XXINV128_RECON_V3_PKG');

    -- 3. APEX metadata references across workspace applications (CLOB/VARCHAR columns)
    select sum(cnt)
      into l_apex_cnt
      from (
        select count(*) cnt from apex_application_page_regions where dbms_lob.instr(upper(region_source), l_pkg) > 0
        union all
        select count(*) cnt from apex_application_page_proc where dbms_lob.instr(upper(process_source), l_pkg) > 0
        union all
        select count(*) cnt from apex_application_page_da_acts where instr(upper(attribute_01), l_pkg) > 0 or instr(upper(attribute_02), l_pkg) > 0 or instr(upper(attribute_03), l_pkg) > 0
        union all
        select count(*) cnt from apex_application_page_items where instr(upper(lov_definition), l_pkg) > 0 or instr(upper(item_source), l_pkg) > 0 or instr(upper(item_default), l_pkg) > 0
        union all
        select count(*) cnt from apex_application_page_comp where instr(upper(computation), l_pkg) > 0
        union all
        select count(*) cnt from apex_application_page_val where instr(upper(validation_expression1), l_pkg) > 0
        union all
        select count(*) cnt from apex_application_processes where dbms_lob.instr(upper(process), l_pkg) > 0
        union all
        select count(*) cnt from apex_application_lovs where instr(upper(list_of_values_query), l_pkg) > 0
        union all
        select count(*) cnt from apex_application_auth where instr(upper(attribute_01), l_pkg) > 0 or instr(upper(attribute_02), l_pkg) > 0
      );

    if nvl(l_dep_cnt,0) > 0 or nvl(l_src_cnt,0) > 0 or nvl(l_apex_cnt,0) > 0 then
      l_blocker_cnt := l_blocker_cnt + 1;
      dbms_output.put_line('[BLOCKED] ' || l_pkg ||
        ' deps=' || nvl(l_dep_cnt,0) ||
        ' src='  || nvl(l_src_cnt,0) ||
        ' apex=' || nvl(l_apex_cnt,0) ||
        case when l_details is not null then ' (' || l_details || ')' end);
    else
      dbms_output.put_line('[OK] ' || l_pkg || ': 0 USER_DEPENDENCIES, 0 USER_SOURCE, 0 APEX refs.');
    end if;
  end loop;

  if l_blocker_cnt > 0 then
    raise_application_error(-20080, 'Aborting retirement: ' || l_blocker_cnt || ' target package(s) still have active references.');
  end if;

  for i in 1 .. l_targets.count loop
    l_pkg := l_targets(i);
    select count(*)
      into l_exists
      from user_objects uo
     where uo.object_name=l_pkg
       and uo.object_type in ('PACKAGE','PACKAGE BODY');

    if l_exists > 0 then
      execute immediate 'drop package ' || dbms_assert.simple_sql_name(l_pkg);
      dbms_output.put_line('[DROPPED] ' || l_pkg);
    end if;
  end loop;
end;
/
