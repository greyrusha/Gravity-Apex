-- Pre-Wave 3 backup of retired zero-dependency packages in GL_ACCOUNTS@APEXQ_AWS
-- Captured 2026-11-20 prior to running 26_xxme_retire_unused_pkgs.sql
set define off

-- =============================================================================
-- 1. XXME_POC_PASSWORD_RESET_PKG (Spec + Body)
-- =============================================================================

  CREATE OR REPLACE EDITIONABLE PACKAGE "GL_ACCOUNTS"."XXME_POC_PASSWORD_RESET_PKG" authid definer as
  procedure request_reset(
    p_user_name in varchar2,
    p_email     in varchar2,
    p_message   out varchar2
  );
end xxme_poc_password_reset_pkg;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GL_ACCOUNTS"."XXME_POC_PASSWORD_RESET_PKG" as
  c_workspace_name   constant varchar2(255) := 'GL_ACCOUNTS';
  c_workspace_id     constant number := 100789;
  c_default_password constant varchar2(100) := 'Welcome1';
  c_generic_message  constant varchar2(1000) :=
    'If the supplied details match an eligible account, the password is now Welcome1. Sign in and change it immediately.';

  procedure record_event(
    p_user_hash   in varchar2,
    p_source_ip   in varchar2,
    p_result_code in varchar2
  ) is
    pragma autonomous_transaction;
  begin
    insert into xxme_poc_pw_reset_audit(
      user_name_hash, source_ip, result_code
    ) values (
      p_user_hash, p_source_ip, p_result_code
    );
    commit;
  exception
    when others then
      rollback;
  end record_event;

  procedure request_reset(
    p_user_name in varchar2,
    p_email     in varchar2,
    p_message   out varchar2
  ) is
    l_user_name                     varchar2(100) := lower(trim(p_user_name));
    l_email                         varchar2(240) := lower(trim(p_email));
    l_user_hash                     varchar2(64);
    l_source_ip                     varchar2(128);
    l_workspace_id                  number;
    l_match_count                   number := 0;
    l_allowed_count                 number := 0;
    l_admin_count                   number := 0;
    l_recent_count                  number := 0;
    l_user_id                       number;
    l_workspace                     varchar2(255);
    l_actual_user_name              varchar2(100);
    l_first_name                    varchar2(255);
    l_last_name                     varchar2(255);
    l_old_web_password              varchar2(4000);
    l_email_address                 varchar2(240);
    l_start_date                    varchar2(255);
    l_end_date                      varchar2(255);
    l_employee_id                   varchar2(255);
    l_allow_access_to_schemas       varchar2(4000);
    l_person_type                   varchar2(255);
    l_default_schema                varchar2(255);
    l_groups                        varchar2(4000);
    l_developer_role                varchar2(4000);
    l_description                   varchar2(4000);
    l_account_expiry                date;
    l_account_locked                varchar2(10);
    l_failed_access_attempts        number;
    l_change_password_on_first_use  varchar2(10);
    l_first_password_use_occurred   varchar2(10);
  begin
    p_message := c_generic_message;
    begin
      l_source_ip := substr(nvl(owa_util.get_cgi_env('REMOTE_ADDR'), 'UNKNOWN'), 1, 128);
    exception
      when others then
        l_source_ip := 'UNKNOWN';
    end;
    select rawtohex(standard_hash(nvl(l_user_name, '<NULL>'), 'SHA256'))
      into l_user_hash
      from dual;

    if l_user_name is null or l_email is null or
       not regexp_like(l_user_name, '^[[:alnum:]._%+-]+@terex[.]com$', 'i') or
       not regexp_like(l_email, '^[[:alnum:]._%+-]+@terex[.]com$', 'i') then
      record_event(l_user_hash, l_source_ip, 'INVALID_INPUT');
      return;
    end if;

    select count(*)
      into l_recent_count
      from xxme_poc_pw_reset_audit
     where request_ts >= systimestamp - interval '15' minute
       and (user_name_hash = l_user_hash or source_ip = l_source_ip);

    if l_recent_count >= 5 then
      record_event(l_user_hash, l_source_ip, 'RATE_LIMITED');
      return;
    end if;

    l_workspace_id := apex_util.find_security_group_id(p_workspace => c_workspace_name);
    if l_workspace_id is null or l_workspace_id <> c_workspace_id then
      raise_application_error(-20060, 'Password reset service is unavailable.');
    end if;
    apex_util.set_security_group_id(p_security_group_id => l_workspace_id);

    select count(*)
      into l_match_count
      from apex_workspace_apex_users
     where workspace_id = c_workspace_id
       and lower(user_name) = l_user_name
       and lower(email) = l_email;

    select count(*)
      into l_allowed_count
      from xxme_poc_pw_reset_users
     where lower(user_name) = l_user_name
       and enabled_flag = 'Y';

    l_admin_count :=
      case
        when xx_tms_security_pkg.is_workspace_admin(l_user_name) then 1
        else 0
      end;

    if l_match_count <> 1 or l_allowed_count <> 1 then
      record_event(l_user_hash, l_source_ip, 'NO_MATCH');
      return;
    end if;

    if l_admin_count > 0 then
      record_event(l_user_hash, l_source_ip, 'ADMIN_BLOCKED');
      return;
    end if;

    l_user_id := apex_util.get_user_id(p_username => l_user_name);
    if l_user_id is null then
      record_event(l_user_hash, l_source_ip, 'NO_MATCH');
      return;
    end if;

    apex_util.fetch_user(
      p_user_id                       => l_user_id,
      p_workspace                     => l_workspace,
      p_user_name                     => l_actual_user_name,
      p_first_name                    => l_first_name,
      p_last_name                     => l_last_name,
      p_web_password                  => l_old_web_password,
      p_email_address                 => l_email_address,
      p_start_date                    => l_start_date,
      p_end_date                      => l_end_date,
      p_employee_id                   => l_employee_id,
      p_allow_access_to_schemas       => l_allow_access_to_schemas,
      p_person_type                   => l_person_type,
      p_default_schema                => l_default_schema,
      p_groups                        => l_groups,
      p_developer_role                => l_developer_role,
      p_description                   => l_description,
      p_account_expiry                => l_account_expiry,
      p_account_locked                => l_account_locked,
      p_failed_access_attempts        => l_failed_access_attempts,
      p_change_password_on_first_use  => l_change_password_on_first_use,
      p_first_password_use_occurred   => l_first_password_use_occurred
    );

    apex_util.edit_user(
      p_user_id                       => l_user_id,
      p_user_name                     => l_actual_user_name,
      p_first_name                    => l_first_name,
      p_last_name                     => l_last_name,
      p_web_password                  => c_default_password,
      p_new_password                  => c_default_password,
      p_email_address                 => l_email_address,
      p_start_date                    => l_start_date,
      p_end_date                      => l_end_date,
      p_employee_id                   => l_employee_id,
      p_allow_access_to_schemas       => l_allow_access_to_schemas,
      p_person_type                   => l_person_type,
      p_default_schema                => l_default_schema,
      p_group_ids                     => l_groups,
      p_developer_roles               => l_developer_role,
      p_description                   => l_description,
      p_account_expiry                => sysdate,
      p_account_locked                => 'N',
      p_failed_access_attempts        => 0,
      p_change_password_on_first_use  => 'Y',
      p_first_password_use_occurred   => 'N'
    );
    apex_util.unexpire_end_user_account(p_user_name => l_actual_user_name);
    apex_util.unexpire_workspace_account(p_user_name => l_actual_user_name);
    apex_util.unlock_account(p_user_name => l_actual_user_name);

    record_event(l_user_hash, l_source_ip, 'RESET');
  exception
    when others then
      record_event(l_user_hash, l_source_ip, 'ERROR');
      raise_application_error(-20061, 'Password reset is temporarily unavailable.');
  end request_reset;
end xxme_poc_password_reset_pkg;
/

-- =============================================================================
-- 2. XXINV128_RECON_V3_PKG (Spec + Body)
-- =============================================================================

  CREATE OR REPLACE EDITIONABLE PACKAGE "GL_ACCOUNTS"."XXINV128_RECON_V3_PKG" authid definer as
  procedure refresh_lookup;
  procedure check_orgs(p_ledger_id number, p_period_name varchar2, p_ou_id number);
  procedure run_reconciliation(p_ledger_id number, p_period_name varchar2,
                               p_ou_id number, p_org_ids varchar2 default null);
  procedure apply_scope(p_org_ids varchar2 default null);
  function current_collection(p_kind varchar2) return varchar2;
  function checked_collection(p_kind varchar2) return varchar2;
  function get_meta return clob;
end xxinv128_recon_v3_pkg;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GL_ACCOUNTS"."XXINV128_RECON_V3_PKG" as
  c_check constant varchar2(30) := 'INV128_V3_CHECK';
  c_state constant varchar2(30) := 'INV128_V3_STATE';
  type t_flags is table of boolean index by varchar2(100);
  type t_jsons is table of json_object_t index by varchar2(100);

  procedure app_guard is
  begin
    if nvl(v('APP_ID'), '0') <> '128' then
      raise_application_error(-20001, 'Inventory reconciliation is available in application 128 only.');
    end if;
  end;

  function key_of(p_n number) return varchar2 is
  begin
    return to_char(p_n, 'TM9', 'NLS_NUMERIC_CHARACTERS=''.,''');
  end;

  function stage_name(p_suffix varchar2) return varchar2 is
  begin
    return 'IV3_' || substr(rawtohex(sys_guid()), 1, 20) || p_suffix;
  end;

  procedure safe_drop(p_name varchar2) is
  begin
    if p_name is not null and apex_collection.collection_exists(p_name) then
      apex_collection.delete_collection(p_name);
    end if;
  exception when others then null;
  end;

  function pointer(p_context varchar2, p_col number) return varchar2 is
    l_value varchar2(4000);
  begin
    select case p_col when 1 then c001 when 2 then c002 when 3 then c003
                      when 4 then c004 when 5 then c005 when 6 then c006 end
      into l_value from apex_collections where collection_name = p_context and seq_id = 1;
    return l_value;
  exception when no_data_found then return null;
  end;

  function context_json(p_context varchar2) return json_object_t is
    l_json clob;
  begin
    select clob001 into l_json from apex_collections where collection_name = p_context and seq_id = 1;
    return json_object_t.parse(l_json);
  exception when no_data_found then return json_object_t();
  end;

  function check_valid return boolean is
  begin
    return pointer(c_check, 1) is not null
      and apex_collection.collection_exists(pointer(c_check, 1))
      and pointer(c_check, 2) = xxinv128_recon_v2_pkg.checked_collection('READINESS')
      and pointer(c_check, 3) = xxinv128_recon_v2_pkg.checked_collection('OWNERS');
  end;

  function capture_valid return boolean is
  begin
    return pointer(c_state, 1) is not null
      and apex_collection.collection_exists(pointer(c_state, 1))
      and pointer(c_state, 2) = xxinv128_recon_v2_pkg.current_collection('RAW')
      and pointer(c_state, 3) = xxinv128_recon_v2_pkg.current_collection('READINESS')
      and pointer(c_state, 4) = xxinv128_recon_v2_pkg.current_collection('OWNERS')
      and pointer(c_state, 5) = xxinv128_recon_v2_pkg.current_collection('RESULTS');
  end;

  function checked_collection(p_kind varchar2) return varchar2 is
  begin
    app_guard;
    if check_valid then
      return case upper(p_kind) when 'READINESS' then pointer(c_check, 1)
                               when 'OWNERS' then pointer(c_check, 3) end;
    end if;
    return null;
  end;

  function current_collection(p_kind varchar2) return varchar2 is
  begin
    app_guard;
    if capture_valid then
      return case upper(p_kind) when 'RAW' then pointer(c_state, 2)
        when 'READINESS' then pointer(c_state, 1) when 'OWNERS' then pointer(c_state, 4)
        when 'RESULTS' then pointer(c_state, 5) when 'EXCEPTIONS' then pointer(c_state, 6) end;
    end if;
    return null;
  end;

  procedure add_json(p_collection varchar2, p_json json_object_t) is
    l_seq number;
  begin
    l_seq := apex_collection.add_member(p_collection_name => p_collection,
      p_n001 => p_json.get_number('LEDGER_ID'), p_n002 => p_json.get_number('ORG_ID'),
      p_n003 => p_json.get_number('CCID'), p_clob001 => p_json.to_clob);
  end;

  -- Approved explicit exception: organization 129 / 000 is the reference item
  -- master. Self-master status in any other organization does not exclude it.
  function master_only(p_ready json_object_t) return boolean is
  begin
    return p_ready.get_number('ORG_ID') = 129;
  end;

  procedure annotate_readiness(p_source varchar2, p_target varchar2, p_ou number,
                               p_prefix varchar2, p_meta in out nocopy json_object_t) is
    j json_object_t;
    l_found number := 0; l_eligible number := 0; l_excluded number := 0; l_outside number := 0;
    l_ou_name varchar2(240); l_is_ou boolean; l_reason varchar2(240);
    l_eligible_ids t_flags; l_companies t_flags; l_company varchar2(100); l_codes varchar2(4000);
    l_ledger number; l_master_count number := 0; l_unassigned_count number := 0;
  begin
    apex_collection.create_collection(p_target);
    for r in (select clob001 from apex_collections where collection_name = p_source order by seq_id) loop
      j := json_object_t.parse(r.clob001);
      l_ledger := j.get_number('LEDGER_ID');
      j.put('MASTER_ONLY', case when master_only(j) then 'Y' else 'N' end);
      if master_only(j) then l_master_count := l_master_count + 1; end if;
      if j.get_number('OU_ID') is null then l_unassigned_count := l_unassigned_count + 1; end if;
      l_is_ou := nvl(j.get_number('OU_ID'), -1) = p_ou;
      if l_is_ou then l_found := l_found + 1; l_ou_name := j.get_string('OU_NAME');
      else l_outside := l_outside + 1; end if;
      -- Selected-period DORMANT classification precedes other exclusions.
      if j.get_string('READINESS_STATUS') = 'DORMANT' then l_reason := 'DORMANT';
      elsif master_only(j) then l_reason := 'MASTER ONLY';
      elsif not l_is_ou then l_reason := 'OUTSIDE SELECTED OU';
      else l_reason := null; end if;
      if l_is_ou and l_reason is null then
        j.put('ELIGIBLE', 'Y'); j.put_null('EXCLUSION_REASON'); l_eligible := l_eligible + 1;
        l_eligible_ids(key_of(j.get_number('ORG_ID'))) := true;
      else
        j.put('ELIGIBLE', 'N'); j.put('EXCLUSION_REASON', l_reason);
        if l_is_ou then l_excluded := l_excluded + 1; end if;
      end if;
      add_json(p_target, j);
    end loop;
    if l_found = 0 then raise_application_error(-20001, 'Select an operating unit belonging to the checked ledger.'); end if;
    p_meta.put(p_prefix || 'OU_ID', p_ou); p_meta.put(p_prefix || 'OU_NAME', l_ou_name);
    p_meta.put(p_prefix || 'OU_ORG_COUNT', l_found);
    p_meta.put(p_prefix || 'ELIGIBLE_ORG_COUNT', l_eligible);
    p_meta.put(p_prefix || 'EXCLUDED_ORG_COUNT', l_excluded);
    p_meta.put(p_prefix || 'OUTSIDE_OU_ORG_COUNT', l_outside);
    p_meta.put(p_prefix || 'MASTER_EXCLUDED_ORG_COUNT', l_master_count);
    p_meta.put(p_prefix || 'UNASSIGNED_ORG_COUNT', l_unassigned_count);
    -- Read-only live verification found zero mismatches between this cached
    -- first component and GCC.SEGMENT1 for all 667 distinct cached accounts.
    -- Display evidence only: never used to allocate or filter GL balances.
    for r in (select org_id, account, evidence, configured from xxinv128_val_acct_mv
               where ledger_id = l_ledger order by org_id, ccid) loop
      if l_eligible_ids.exists(key_of(r.org_id)) and r.configured = 'Y'
         and regexp_like(r.evidence,
           '(^|;[[:space:]]*)(ORG DEFAULT|ASSET SUBINVENTORY|WIP CLASS|WIP JOB)([[:space:]]*;|$)') then
        l_company := regexp_substr(r.account, '^[^.]+');
        if l_company is not null then l_companies(l_company) := true; end if;
      end if;
    end loop;
    l_company := l_companies.first;
    while l_company is not null loop
      l_codes := l_codes || case when l_codes is not null then ', ' end || l_company;
      l_company := l_companies.next(l_company);
    end loop;
    p_meta.put(p_prefix || 'COMPANY_CODES', l_codes);
    p_meta.put(p_prefix || 'COMPANY_CODES_STATUS', 'Observed confirmed setup mappings; not a GL allocation rule.');
  end;

  function explicit_scope(p_ids varchar2, p_ready varchar2) return varchar2 is
    l_seen t_flags; l_key varchar2(100); l_scope varchar2(32767);
    l_json clob; j json_object_t;
  begin
    if p_ids is null or upper(trim(p_ids)) = 'ALL' then
      for r in (select clob001 from apex_collections where collection_name = p_ready order by seq_id) loop
        j := json_object_t.parse(r.clob001);
        if j.get_string('ELIGIBLE') = 'Y' then l_seen(key_of(j.get_number('ORG_ID'))) := true; end if;
      end loop;
    else
      if not regexp_like(p_ids, '^[0-9]{1,18}(:[0-9]{1,18})*$') then
        raise_application_error(-20001, 'Select inventory organizations from the checked operating unit.');
      end if;
      for r in (select regexp_substr(p_ids, '[^:]+', 1, level) org_id from dual
                connect by regexp_substr(p_ids, '[^:]+', 1, level) is not null) loop
        l_key := key_of(to_number(r.org_id));
        begin
          select clob001 into l_json from apex_collections
           where collection_name = p_ready and n002 = to_number(l_key);
        exception when no_data_found then
          raise_application_error(-20001, 'An organization is outside the checked operating unit. Check organizations again.');
        end;
        j := json_object_t.parse(l_json);
        if nvl(j.get_string('ELIGIBLE'), 'N') <> 'Y' then
          raise_application_error(-20001, 'A selected organization is outside this operating unit or is excluded.');
        end if;
        l_seen(l_key) := true;
      end loop;
    end if;
    l_key := l_seen.first;
    while l_key is not null loop
      l_scope := l_scope || case when l_scope is not null then ':' end || l_key;
      l_key := l_seen.next(l_key);
    end loop;
    if l_scope is null then raise_application_error(-20001, 'This operating unit has no eligible inventory organizations for the selected period.'); end if;
    return l_scope;
  end;

  procedure publish_check(p_ready varchar2, p_ledger number, p_meta json_object_t) is
    l_seq number;
  begin
    if apex_collection.collection_exists(c_check) then
      apex_collection.update_member(p_collection_name => c_check, p_seq => 1,
        p_c001 => p_ready, p_c002 => xxinv128_recon_v2_pkg.checked_collection('READINESS'),
        p_c003 => xxinv128_recon_v2_pkg.checked_collection('OWNERS'), p_n001 => p_ledger,
        p_n002 => p_meta.get_number('CHECKED_OU_ID'), p_clob001 => p_meta.to_clob);
    else
      apex_collection.create_collection(c_check);
      l_seq := apex_collection.add_member(p_collection_name => c_check,
        p_c001 => p_ready, p_c002 => xxinv128_recon_v2_pkg.checked_collection('READINESS'),
        p_c003 => xxinv128_recon_v2_pkg.checked_collection('OWNERS'), p_n001 => p_ledger,
        p_n002 => p_meta.get_number('CHECKED_OU_ID'), p_clob001 => p_meta.to_clob);
    end if;
  end;

  procedure publish_capture(p_ready varchar2, p_exceptions varchar2, p_meta json_object_t) is
    l_seq number;
  begin
    if apex_collection.collection_exists(c_state) then
      apex_collection.update_member(p_collection_name => c_state, p_seq => 1,
        p_c001 => p_ready, p_c002 => xxinv128_recon_v2_pkg.current_collection('RAW'),
        p_c003 => xxinv128_recon_v2_pkg.current_collection('READINESS'),
        p_c004 => xxinv128_recon_v2_pkg.current_collection('OWNERS'),
        p_c005 => xxinv128_recon_v2_pkg.current_collection('RESULTS'), p_c006 => p_exceptions,
        p_n001 => p_meta.get_number('CAPTURED_LEDGER_ID'), p_n002 => p_meta.get_number('CAPTURED_OU_ID'),
        p_clob001 => p_meta.to_clob);
    else
      apex_collection.create_collection(c_state);
      l_seq := apex_collection.add_member(p_collection_name => c_state,
        p_c001 => p_ready, p_c002 => xxinv128_recon_v2_pkg.current_collection('RAW'),
        p_c003 => xxinv128_recon_v2_pkg.current_collection('READINESS'),
        p_c004 => xxinv128_recon_v2_pkg.current_collection('OWNERS'),
        p_c005 => xxinv128_recon_v2_pkg.current_collection('RESULTS'), p_c006 => p_exceptions,
        p_n001 => p_meta.get_number('CAPTURED_LEDGER_ID'), p_n002 => p_meta.get_number('CAPTURED_OU_ID'),
        p_clob001 => p_meta.to_clob);
    end if;
  end;

  procedure make_exceptions(p_ready varchar2, p_ou number, p_target varchar2,
                             p_meta in out nocopy json_object_t) is
    l_ready t_jsons; j json_object_t; rj json_object_t; x json_object_t; l_key varchar2(100);
    l_residual_count number := 0; l_residual number := 0; l_shared_count number := 0;
    l_amount number;
  begin
    apex_collection.create_collection(p_target);
    for r in (select clob001 from apex_collections where collection_name = p_ready) loop
      j := json_object_t.parse(r.clob001); l_ready(key_of(j.get_number('ORG_ID'))) := j;
    end loop;
    for r in (select clob001 from apex_collections
               where collection_name = xxinv128_recon_v2_pkg.current_collection('RAW') order by seq_id) loop
      j := json_object_t.parse(r.clob001);
      if j.get_string('ROW_TYPE') = 'ORG' then
        l_key := key_of(j.get_number('ORG_ID'));
        if l_ready.exists(l_key) then
          rj := l_ready(l_key);
          l_amount := nvl(j.get_number('UNROUNDED_WIP'), 0);
          if rj.get_number('OU_ID') = p_ou and rj.get_string('READINESS_STATUS') = 'DORMANT' and l_amount <> 0 then
            x := json_object_t(); x.put('EXCEPTION_TYPE', 'DORMANT RESIDUAL WIP');
            x.put('LEDGER_ID', j.get_number('LEDGER_ID')); x.put('CCID', j.get_number('CCID'));
            x.put('ACCOUNT', j.get_string('ACCOUNT')); x.put('ORG_ID', j.get_number('ORG_ID'));
            x.put('ORG_CODE', rj.get_string('ORG_CODE')); x.put('ORG_NAME', rj.get_string('ORG_NAME'));
            x.put('READINESS_STATUS', 'DORMANT'); x.put('EXCLUSION_REASON', 'DORMANT');
            x.put('WIP_VALUE', round(l_amount, 2)); add_json(p_target, x);
            l_residual_count := l_residual_count + 1; l_residual := l_residual + l_amount;
          end if;
        end if;
      end if;
    end loop;
    for r in (select clob001 from apex_collections
               where collection_name = xxinv128_recon_v2_pkg.current_collection('RESULTS') order by seq_id) loop
      j := json_object_t.parse(r.clob001);
      if j.get_string('ROW_TYPE') = 'ACCOUNT' and nvl(j.get_number('SELECTED_OWNER_COUNT'), 0) > 0
         and j.get_string('GL_SCOPE_STATUS') in ('PARTIAL OWNERSHIP', 'UNKNOWN OWNERSHIP') then
        x := json_object_t(); x.put('EXCEPTION_TYPE', 'SHARED GL');
        x.put('LEDGER_ID', j.get_number('LEDGER_ID')); x.put('CCID', j.get_number('CCID'));
        x.put('ACCOUNT', j.get_string('ACCOUNT')); x.put('GL_SCOPE_STATUS', j.get_string('GL_SCOPE_STATUS'));
        x.put('OWNER_COUNT', j.get_number('OWNER_COUNT')); x.put('SELECTED_OWNER_COUNT', j.get_number('SELECTED_OWNER_COUNT'));
        x.put('MISSING_OWNER_CODES', j.get_string('MISSING_OWNER_CODES'));
        x.put('FULL_LEDGER_GL_END_BALANCE', j.get_number('FULL_LEDGER_GL_END_BALANCE'));
        add_json(p_target, x); l_shared_count := l_shared_count + 1;
      end if;
    end loop;
    p_meta.put('EXCLUDED_RESIDUAL_COUNT', l_residual_count);
    p_meta.put('EXCLUDED_RESIDUAL_WIP', round(l_residual, 2));
    p_meta.put('SHARED_GL_EXCEPTION_COUNT', l_shared_count);
  end;

  function financial_meta return json_object_t is
    j json_object_t := json_object_t.parse(xxinv128_recon_v2_pkg.get_meta);
    l_keys json_key_list;
  begin
    l_keys := j.get_keys;
    for i in 1 .. l_keys.count loop
      if substr(l_keys(i), 1, 8) = 'CHECKED_' then j.remove(l_keys(i)); end if;
    end loop;
    j.put('ENGINE_VERSION', 'V3 OU WRAPPER');
    j.put('FINANCIAL_CAPTURE_SCOPE', 'FULL LEDGER');
    j.put('MASTER_ONLY_RULE_STATUS', 'Explicit organization 129 / 000 excluded; other item masters are not automatically excluded.');
    return j;
  end;

  procedure refresh_lookup is
    l_old_ready varchar2(4000);
  begin
    app_guard;
    l_old_ready := pointer(c_check, 1);
    -- DBMS_MVIEW refresh owns its transaction. Do not clear Check until both
    -- caches refresh successfully; preserve the independent captured results.
    xxinv128_recon_v2_pkg.refresh_lookup;
    if apex_collection.collection_exists(c_check) then
      apex_collection.delete_collection(c_check);
    end if;
    safe_drop(l_old_ready);
  end;

  procedure check_orgs(p_ledger_id number, p_period_name varchar2, p_ou_id number) is
    l_started number := dbms_utility.get_time;
    l_ready varchar2(30) := stage_name('R'); l_old_ready varchar2(4000);
    j json_object_t; v2meta json_object_t;
  begin
    savepoint inv128_v3_check_start; app_guard;
    if p_ou_id is null or p_ou_id <= 0 or p_ou_id <> trunc(p_ou_id) then
      raise_application_error(-20001, 'Select one operating unit.');
    end if;
    l_old_ready := pointer(c_check, 1);
    xxinv128_recon_v2_pkg.check_orgs(p_ledger_id, p_period_name);
    j := json_object_t();
    annotate_readiness(xxinv128_recon_v2_pkg.checked_collection('READINESS'), l_ready, p_ou_id, 'CHECKED_', j);
    v2meta := json_object_t.parse(xxinv128_recon_v2_pkg.get_meta);
    j.put('CHECKED_LEDGER_ID', p_ledger_id); j.put('CHECKED_PERIOD_NAME', p_period_name);
    j.put('CHECKED_AT', v2meta.get_string('CHECKED_AT'));
    j.put('CHECKED_LOOKUP_AT_UTC', v2meta.get_string('CHECKED_LOOKUP_AT_UTC'));
    j.put('CHECKED_ORG_COUNT', v2meta.get_number('CHECKED_ORG_COUNT'));
    j.put('CHECK_SECONDS', (dbms_utility.get_time - l_started) / 100);
    publish_check(l_ready, p_ledger_id, j); safe_drop(l_old_ready);
  exception when others then
    rollback to inv128_v3_check_start; safe_drop(l_ready); raise;
  end;

  procedure run_reconciliation(p_ledger_id number, p_period_name varchar2,
                               p_ou_id number, p_org_ids varchar2 default null) is
    l_started number := dbms_utility.get_time;
    l_ready varchar2(30) := stage_name('R'); l_exc varchar2(30) := stage_name('E');
    l_old_ready varchar2(4000); l_old_exc varchar2(4000); l_scope varchar2(32767);
    j json_object_t; checked json_object_t;
  begin
    savepoint inv128_v3_run_start; app_guard;
    if not check_valid then raise_application_error(-20001, 'Check inventory organizations for this operating unit before running.'); end if;
    checked := context_json(c_check);
    if p_ledger_id is null or p_period_name is null or p_ou_id is null
       or checked.get_number('CHECKED_LEDGER_ID') <> p_ledger_id
       or checked.get_string('CHECKED_PERIOD_NAME') <> p_period_name
       or checked.get_number('CHECKED_OU_ID') <> p_ou_id then
      raise_application_error(-20001, 'Ledger, period or operating unit changed. Check inventory organizations again.');
    end if;
    l_scope := explicit_scope(p_org_ids, pointer(c_check, 1));
    l_old_ready := pointer(c_state, 1); l_old_exc := pointer(c_state, 6);
    -- Explicit OU org IDs preserve V2's all-ledger owner denominator and all
    -- full-ledger observed-activity evidence. No early financial filter here.
    xxinv128_recon_v2_pkg.run_reconciliation(p_ledger_id, p_period_name, l_scope);
    j := financial_meta;
    annotate_readiness(xxinv128_recon_v2_pkg.current_collection('READINESS'), l_ready, p_ou_id, 'CAPTURED_', j);
    make_exceptions(l_ready, p_ou_id, l_exc, j);
    j.put('RUN_SECONDS', (dbms_utility.get_time - l_started) / 100);
    publish_capture(l_ready, l_exc, j); safe_drop(l_old_ready); safe_drop(l_old_exc);
  exception when others then
    rollback to inv128_v3_run_start; safe_drop(l_ready); safe_drop(l_exc); raise;
  end;

  procedure apply_scope(p_org_ids varchar2 default null) is
    l_exc varchar2(30) := stage_name('E'); l_old_exc varchar2(4000); l_scope varchar2(32767);
    j json_object_t; old_meta json_object_t; l_keys json_key_list; l_key varchar2(4000);
  begin
    savepoint inv128_v3_scope_start; app_guard;
    if not capture_valid then raise_application_error(-20001, 'Run reconciliation for an operating unit before changing scope.'); end if;
    old_meta := context_json(c_state);
    l_scope := explicit_scope(p_org_ids, pointer(c_state, 1)); l_old_exc := pointer(c_state, 6);
    xxinv128_recon_v2_pkg.apply_scope(l_scope); j := financial_meta;
    l_keys := old_meta.get_keys;
    for i in 1 .. l_keys.count loop
      l_key := l_keys(i);
      if l_key in ('CAPTURED_OU_ID', 'CAPTURED_OU_NAME', 'CAPTURED_OU_ORG_COUNT',
                   'CAPTURED_ELIGIBLE_ORG_COUNT', 'CAPTURED_EXCLUDED_ORG_COUNT',
                   'CAPTURED_OUTSIDE_OU_ORG_COUNT', 'CAPTURED_COMPANY_CODES',
                   'CAPTURED_COMPANY_CODES_STATUS', 'CAPTURED_MASTER_EXCLUDED_ORG_COUNT',
                   'CAPTURED_UNASSIGNED_ORG_COUNT', 'RUN_SECONDS') then
        j.put(l_key, old_meta.get(l_key));
      end if;
    end loop;
    make_exceptions(pointer(c_state, 1), old_meta.get_number('CAPTURED_OU_ID'), l_exc, j);
    publish_capture(pointer(c_state, 1), l_exc, j); safe_drop(l_old_exc);
  exception when others then
    rollback to inv128_v3_scope_start; safe_drop(l_exc); raise;
  end;

  function get_meta return clob is
    j json_object_t := json_object_t(); chk json_object_t; v2meta json_object_t;
    l_keys json_key_list; l_prefix varchar2(20);
  begin
    app_guard;
    if capture_valid then j := context_json(c_state); l_prefix := 'CAPTURED_'; end if;
    if check_valid then
      chk := context_json(c_check); l_keys := chk.get_keys;
      for i in 1 .. l_keys.count loop j.put(l_keys(i), chk.get(l_keys(i))); end loop;
      if l_prefix is null then l_prefix := 'CHECKED_'; end if;
    end if;
    if l_prefix is not null then
      j.put('ELIGIBLE_ORG_COUNT', j.get_number(l_prefix || 'ELIGIBLE_ORG_COUNT'));
      j.put('EXCLUDED_ORG_COUNT', j.get_number(l_prefix || 'EXCLUDED_ORG_COUNT'));
      j.put('COMPANY_CODES', j.get_string(l_prefix || 'COMPANY_CODES'));
    end if;
    v2meta := json_object_t.parse(xxinv128_recon_v2_pkg.get_meta);
    j.put('LOOKUP_REFRESHED_AT_UTC', v2meta.get_string('LOOKUP_REFRESHED_AT_UTC'));
    j.put('ENGINE_VERSION', 'V3 OU WRAPPER');
    return j.to_clob;
  end;
end xxinv128_recon_v3_pkg;
/

-- =============================================================================
-- 3. XXINV128_RECON_V1_PKG (Spec + Body)
-- =============================================================================

  CREATE OR REPLACE EDITIONABLE PACKAGE "GL_ACCOUNTS"."XXINV128_RECON_V1_PKG" authid definer as
  procedure refresh_lookup;
  procedure check_orgs(p_ledger_id number, p_period_name varchar2);
  procedure run_reconciliation(p_ledger_id number, p_period_name varchar2,
                               p_org_ids varchar2 default null);
  procedure apply_scope(p_org_ids varchar2 default null);
  function current_collection(p_kind varchar2) return varchar2;
  function checked_collection(p_kind varchar2) return varchar2;
  function get_meta return clob;
end xxinv128_recon_v1_pkg;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GL_ACCOUNTS"."XXINV128_RECON_V1_PKG" as
  c_check constant varchar2(30) := 'INV128_CHECK';
  c_state constant varchar2(30) := 'INV128_STATE';
  type t_json_map is table of json_object_t index by varchar2(100);
  type t_number_map is table of number index by varchar2(100);
  type t_string_map is table of varchar2(32767) index by varchar2(100);
  type t_flag_map is table of boolean index by varchar2(100);
  type t_names is table of varchar2(50) index by pls_integer;

  procedure app_guard is
  begin
    if nvl(v('APP_ID'), '0') <> '128' then
      raise_application_error(-20001, 'Inventory reconciliation is available in application 128 only.');
    end if;
  end;

  function utc_stamp return varchar2 is
  begin
    return to_char(systimestamp at time zone 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.FF3"Z"');
  end;

  function stage_name(p_suffix varchar2) return varchar2 is
  begin
    return 'INV128_' || to_char(systimestamp, 'YYYYMMDDHH24MISSFF6') || '_' || p_suffix;
  end;

  procedure drop_collection(p_name varchar2) is
  begin
    if p_name is not null and apex_collection.collection_exists(p_name) then
      apex_collection.delete_collection(p_name);
    end if;
  end;

  procedure safe_drop(p_name varchar2) is
  begin
    drop_collection(p_name);
  exception when others then null;
  end;

  function key_of(p_number number) return varchar2 is
  begin
    return nvl(to_char(p_number, 'TM9', 'NLS_NUMERIC_CHARACTERS=''.,'''), '~NULL');
  end;

  function json_null(p_json json_object_t, p_key varchar2) return boolean is
    e json_element_t;
  begin
    if not p_json.has(p_key) then return true; end if;
    e := p_json.get(p_key);
    return e is null or e.is_null;
  end;

  function check_value(p_column number) return varchar2 is
    l_value varchar2(4000);
  begin
    select case p_column when 1 then c001 when 2 then c002 when 3 then c003 when 4 then c004 when 5 then c005 end
      into l_value from apex_collections where collection_name = c_check and seq_id = 1;
    return l_value;
  exception when no_data_found then return null;
  end;

  function checked_collection(p_kind varchar2) return varchar2 is
  begin
    return case upper(p_kind) when 'READINESS' then check_value(1) when 'OWNERS' then check_value(2) end;
  end;

  function current_collection(p_kind varchar2) return varchar2 is
    l_value varchar2(4000);
  begin
    select case upper(p_kind) when 'RAW' then c001 when 'READINESS' then c002 when 'OWNERS' then c003
                             when 'RESULTS' then c004 end
      into l_value from apex_collections where collection_name = c_state and seq_id = 1;
    return l_value;
  exception when no_data_found then return null;
  end;

  procedure add_json(p_collection varchar2, p_json json_object_t,
                     p_ledger number, p_org number default null, p_ccid number default null,
                     p_signature varchar2 default null) is
    l_seq number;
  begin
    l_seq := apex_collection.add_member(p_collection_name => p_collection,
      p_c001 => p_signature, p_n001 => p_ledger, p_n002 => p_org, p_n003 => p_ccid,
      p_clob001 => p_json.to_clob);
  end;

  procedure resolve_period(p_ledger number, p_period varchar2,
                            p_prior out varchar2, p_currency out varchar2) is
  begin
    if p_ledger is null or p_ledger not in (1003, 5001, 10001) or p_ledger <> trunc(p_ledger)
       or p_period is null then
      raise_application_error(-20001, 'Select one supported ledger and an accounting period.');
    end if;
    select led.currency_code,
           (select max(g2.period_name) from apps.gl_periods@ADG g2
             where g2.period_set_name = gp.period_set_name and g2.period_type = gp.period_type
               and g2.adjustment_period_flag = 'N' and g2.end_date = gp.start_date - 1)
      into p_currency, p_prior
      from apps.gl_ledgers@ADG led, apps.gl_periods@ADG gp
     where led.ledger_id = p_ledger and gp.period_set_name = led.period_set_name
       and gp.period_type = led.accounted_period_type and gp.adjustment_period_flag = 'N'
       and gp.period_name = p_period;
  exception when no_data_found then
    raise_application_error(-20001, 'The period does not belong to the selected ledger calendar.');
  end;

  -- Proposed replacement only. No deployment or regeneration is performed here.
  -- Financial query branches are unchanged. CPCS presence is obtained by one
  -- all-remote, literal-scoped query and merged with metadata in PL/SQL.
  procedure load_readiness(p_ledger number, p_period varchar2, p_prior varchar2,
                            p_collection varchar2, p_live boolean default true) is
    type t_org_metadata is record (
      org_id number, org_code varchar2(30), org_name varchar2(240),
      ou_id number, ou_name varchar2(240), open_flag varchar2(1), close_date date,
      has_period number, prior_open_flag varchar2(1), prior_close_date date, has_prior_period number);
    r t_org_metadata;
    j json_object_t;
    l_status varchar2(30); l_reason varchar2(1000); l_inv varchar2(30); l_prior_inv varchar2(30);
    l_current t_number_map; l_previous t_number_map;
    l_cur_rows number; l_prior_rows number; l_org number; l_period varchar2(30); l_present number;
    l_key varchar2(100); l_sql varchar2(32767);
    l_presence sys_refcursor; l_metadata sys_refcursor;
    l_presence_open boolean := false; l_metadata_open boolean := false;
  begin
    apex_collection.create_collection(p_collection);
    -- All three objects below are on the same remote database. No local MV or
    -- local lookup is joined to CPCS; EXISTS can stop at the first matching row.
    l_sql := 'select /*+ DRIVING_SITE(o) */ distinct o.organization_id, o.period_name, '
      || 'case when exists (select 1 from apps.cst_period_close_summary@ADG c '
      || 'where c.organization_id = o.organization_id and c.acct_period_id = o.acct_period_id '
      || 'and rownum = 1) then 1 else 0 end has_summary '
      || 'from apps.org_acct_periods@ADG o, apps.hr_organization_information@ADG hoi '
      || 'where hoi.org_information_context = ''Accounting Information'' '
      || 'and hoi.org_information1 = ''' || key_of(p_ledger) || ''' '
      || 'and o.organization_id = hoi.organization_id '
      || 'and o.period_name in (''' || replace(p_period, '''', '''''') || ''', '''
      || replace(p_prior, '''', '''''') || ''')';
    open l_presence for l_sql; l_presence_open := true;
    loop
      fetch l_presence into l_org, l_period, l_present;
      exit when l_presence%notfound;
      l_key := key_of(l_org);
      if l_period = p_period then l_current(l_key) := l_present;
      elsif l_period = p_prior then l_previous(l_key) := l_present; end if;
    end loop;
    close l_presence; l_presence_open := false;

    if p_live then
      -- All organization/period metadata is live and remote on Run. The scope
      -- includes every organization assigned to the ledger, including dormant
      -- organizations without either selected accounting period.
      open l_metadata for
        select /*+ DRIVING_SITE(mp) */ distinct
               mp.organization_id, mp.organization_code, hou.name, od.operating_unit, ou.name,
               pc.open_flag, pc.close_date, nvl(pc.has_period, 0),
               pc.prior_open_flag, pc.prior_close_date, nvl(pc.has_prior_period, 0)
          from apps.mtl_parameters@ADG mp, apps.hr_organization_information@ADG hoi,
               apps.hr_all_organization_units@ADG hou,
               apps.org_organization_definitions@ADG od, apps.hr_operating_units@ADG ou,
               (select o.organization_id,
                       max(case when o.period_name = p_period then o.open_flag end) open_flag,
                       max(case when o.period_name = p_period then o.period_close_date end) close_date,
                       max(case when o.period_name = p_period then 1 else 0 end) has_period,
                       max(case when o.period_name = p_prior then o.open_flag end) prior_open_flag,
                       max(case when o.period_name = p_prior then o.period_close_date end) prior_close_date,
                       max(case when o.period_name = p_prior then 1 else 0 end) has_prior_period
                  from apps.org_acct_periods@ADG o, apps.hr_organization_information@ADG hi
                 where o.period_name in (p_period, p_prior)
                   and hi.org_information_context = 'Accounting Information'
                   and hi.org_information1 = to_char(p_ledger)
                   and hi.organization_id = o.organization_id
                 group by o.organization_id) pc
         where hoi.org_information_context = 'Accounting Information'
           and hoi.org_information1 = to_char(p_ledger)
           and mp.organization_id = hoi.organization_id and hou.organization_id = mp.organization_id
           and od.organization_id(+) = mp.organization_id
           and ou.organization_id(+) = od.operating_unit
           and pc.organization_id(+) = mp.organization_id
         order by mp.organization_code, mp.organization_id;
    else
      -- Check uses cached organization/period metadata only. This small local
      -- aggregation has no database-link join and no financial rows.
      open l_metadata for
        select org_id, max(org_code), max(org_name), max(ou_id), max(ou_name),
               max(case when period_name = p_period then open_flag end),
               max(case when period_name = p_period then period_close_date end),
               max(case when period_name = p_period then 1 else 0 end),
               max(case when period_name = p_prior then open_flag end),
               max(case when period_name = p_prior then period_close_date end),
               max(case when period_name = p_prior then 1 else 0 end)
          from xxinv128_org_period_mv where ledger_id = p_ledger
         group by org_id order by max(org_code), org_id;
    end if;
    l_metadata_open := true;
    loop
      fetch l_metadata into r;
      exit when l_metadata%notfound;
      l_key := key_of(r.org_id);
      l_cur_rows := case when l_current.exists(l_key) then l_current(l_key) else 0 end;
      l_prior_rows := case when l_previous.exists(l_key) then l_previous(l_key) else 0 end;
      l_inv := case when r.has_period = 0 then 'NO PERIOD'
                    when r.open_flag = 'N' and r.close_date is not null then 'CLOSED'
                    when r.open_flag = 'P' then 'CLOSING' else 'OPEN' end;
      l_prior_inv := case when r.has_prior_period = 0 then 'NO PERIOD'
                         when r.prior_open_flag = 'N' and r.prior_close_date is not null then 'CLOSED'
                         when r.prior_open_flag = 'P' then 'CLOSING' else 'OPEN' end;
      if r.has_period = 0 then
        l_status := 'DORMANT'; l_reason := 'No accounting period; residual WIP is retained.';
      elsif l_inv <> 'CLOSED' then
        l_status := 'OPEN'; l_reason := 'Inventory period is not fully closed; current balances are unavailable.';
      elsif l_cur_rows > 0 and l_prior_rows > 0 then
        l_status := 'READY'; l_reason := 'Inventory is closed and current/prior close summaries exist.';
      else
        l_status := 'AWAITING DATA';
        l_reason := case when l_cur_rows = 0 then 'Current close summary is missing. ' end
          || case when l_prior_rows = 0 then 'Prior close summary is missing.' end;
      end if;
      j := json_object_t();
      j.put('LEDGER_ID', p_ledger); j.put('PERIOD_NAME', p_period);
      j.put('ORG_ID', r.org_id); j.put('ORG_CODE', r.org_code); j.put('ORG_NAME', r.org_name);
      j.put('OU_ID', r.ou_id); j.put('OU_NAME', r.ou_name);
      j.put('INV_STATUS', l_inv); j.put('CURRENT_SUMMARY', case when l_cur_rows > 0 then 'Y' else 'N' end);
      j.put('PRIOR_INV_STATUS', l_prior_inv); j.put('PRIOR_PERIOD_NAME', p_prior);
      j.put('PRIOR_SUMMARY', case when l_prior_rows > 0 then 'Y' else 'N' end);
      j.put('READINESS_STATUS', l_status); j.put('REASON', trim(l_reason));
      -- Compatibility keys are now 0/1 availability indicators, not row counts.
      j.put('CURRENT_ROWS', l_cur_rows); j.put('PRIOR_ROWS', l_prior_rows);
      j.put('HAS_CURRENT_PERIOD', case when r.has_period = 1 then 'Y' else 'N' end);
      add_json(p_collection, j, p_ledger, r.org_id, null,
        key_of(r.org_id) || '|' || l_inv || '|' || l_prior_inv || '|' || key_of(l_cur_rows) || '|' || key_of(l_prior_rows)
        || '|' || r.org_code || '|' || r.org_name || '|' || key_of(r.ou_id) || '|' || r.ou_name);
    end loop;
    close l_metadata; l_metadata_open := false;
  exception when others then
    if l_presence_open then close l_presence; end if;
    if l_metadata_open then close l_metadata; end if;
    raise;
  end;

  procedure load_owners(p_ledger number, p_collection varchar2, p_live boolean default true) is
    j json_object_t;
  begin
    apex_collection.create_collection(p_collection);
    if not p_live then
      for r in (select ledger_id, ccid, account, org_id, org_code, org_name,
                       kind, bucket_ccid, evidence, configured, candidate_pair
                  from xxinv128_val_acct_mv where ledger_id = p_ledger
                 order by ccid, org_id)
      loop
        j := json_object_t(); j.put('LEDGER_ID', p_ledger); j.put('CCID', r.ccid); j.put('ACCOUNT', r.account);
        j.put('ORG_ID', r.org_id); j.put('ORG_CODE', r.org_code); j.put('ORG_NAME', r.org_name);
        j.put('KIND', r.kind); j.put('BUCKET_CCID', r.bucket_ccid);
        j.put('EVIDENCE', r.evidence); j.put('CANDIDATE_PAIR', r.candidate_pair); j.put('CONFIGURED', r.configured);
        -- Identical to the live signature: availability/mapping comparison must
        -- not fail just because one source represents KIND as a character.
        add_json(p_collection, j, p_ledger, r.org_id, r.ccid,
          key_of(r.org_id) || '|' || key_of(r.ccid) || '|'
          || key_of(case when r.kind = 'I' then 1 else 0 end) || '|' || r.evidence || '|' || r.account);
      end loop;
      return;
    end if;
    for r in (
      with orgs as (
        select distinct mp.organization_id, mp.organization_code, hou.name org_name
          from apps.mtl_parameters@ADG mp, apps.hr_organization_information@ADG hoi,
               apps.hr_all_organization_units@ADG hou
         where hoi.org_information_context = 'Accounting Information'
           and hoi.org_information1 = to_char(p_ledger)
           and mp.organization_id = hoi.organization_id and hou.organization_id = mp.organization_id),
      evidence as (
        select o.organization_id, decode(x.k, 1, mp.material_account, 2, mp.material_overhead_account,
                 3, mp.resource_account, 4, mp.outside_processing_account, mp.overhead_account) ccid,
               'ORG DEFAULT' evidence, 0 intransit, 0 candidate_pair
          from orgs o, apps.mtl_parameters@ADG mp, (select level k from dual@ADG connect by level <= 5) x
         where mp.organization_id = o.organization_id
        union all
        select o.organization_id, decode(x.k, 1, s.material_account, 2, s.material_overhead_account,
                 3, s.resource_account, 4, s.outside_processing_account, s.overhead_account),
               'ASSET SUBINVENTORY', 0, 0
          from orgs o, apps.mtl_secondary_inventories@ADG s,
               (select level k from dual@ADG connect by level <= 5) x
         where s.organization_id = o.organization_id and s.asset_inventory = 1
        union all
        select o.organization_id, decode(x.k, 1, w.material_account, 2, w.material_overhead_account,
                 3, w.resource_account, 4, w.outside_processing_account, w.overhead_account),
               'WIP CLASS', 0, 0
          from orgs o, apps.wip_accounting_classes@ADG w,
               (select level k from dual@ADG connect by level <= 5) x
         where w.organization_id = o.organization_id and w.class_type not in (4, 6, 7)
        union all
        select o.organization_id, decode(x.k, 1, w.material_account, 2, w.material_overhead_account,
                 3, w.resource_account, 4, w.outside_processing_account, w.overhead_account),
               'WIP JOB', 0, 0
          from orgs o, apps.wip_discrete_jobs@ADG w, apps.wip_accounting_classes@ADG a,
               (select level k from dual@ADG connect by level <= 5) x
         where w.organization_id = o.organization_id and a.organization_id = w.organization_id
           and a.class_code = w.class_code and a.class_type not in (4, 6, 7)
        union all
        select o.organization_id, mp.intransit_inv_account, 'ORG INTRANSIT DEFAULT', 1, 0
          from orgs o, apps.mtl_parameters@ADG mp where mp.organization_id = o.organization_id
        union all
        select o.organization_id, ip.intransit_inv_account, 'INTERORG PAIR CANDIDATE', 1, 1
          from orgs o, apps.mtl_interorg_parameters@ADG ip
         where o.organization_id in (ip.from_organization_id, ip.to_organization_id)),
      distinct_evidence as (
        select distinct organization_id, ccid, evidence, intransit, candidate_pair from evidence where ccid is not null),
      owners as (
        select organization_id, ccid, listagg(evidence, '; ') within group (order by evidence) evidence,
               max(intransit) intransit, max(candidate_pair) candidate_pair
          from distinct_evidence group by organization_id, ccid)
      select o.organization_id org_id, o.organization_code org_code, o.org_name, a.ccid,
             g.concatenated_segments account, a.evidence, a.candidate_pair,
             max(a.intransit) over (partition by a.ccid) intransit
        from owners a, orgs o, apps.gl_code_combinations_kfv@ADG g, apps.gl_code_combinations@ADG gb
       where o.organization_id = a.organization_id and g.code_combination_id = a.ccid
         and gb.code_combination_id = a.ccid and gb.account_type = 'A'
       order by a.ccid, o.organization_id)
    loop
      j := json_object_t(); j.put('LEDGER_ID', p_ledger); j.put('CCID', r.ccid); j.put('ACCOUNT', r.account);
      j.put('ORG_ID', r.org_id); j.put('ORG_CODE', r.org_code); j.put('ORG_NAME', r.org_name);
      j.put('KIND', case when r.intransit = 1 then 'I' else 'V' end);
      j.put('BUCKET_CCID', case when r.intransit = 1 then -2 else r.ccid end);
      j.put('EVIDENCE', r.evidence); j.put('CANDIDATE_PAIR', case when r.candidate_pair = 1 then 'Y' else 'N' end);
      j.put('CONFIGURED', 'Y');
      add_json(p_collection, j, p_ledger, r.org_id, r.ccid,
        key_of(r.org_id) || '|' || key_of(r.ccid) || '|' || key_of(r.intransit) || '|' || r.evidence || '|' || r.account);
    end loop;
  end;

  function same_signature(p_left varchar2, p_right varchar2) return boolean is
    l_count number;
  begin
    select count(*) into l_count from (
      (select c001 from apex_collections where collection_name = p_left
       minus select c001 from apex_collections where collection_name = p_right)
      union all
      (select c001 from apex_collections where collection_name = p_right
       minus select c001 from apex_collections where collection_name = p_left));
    return l_count = 0;
  end;

  function canonical_sql(p_ledger_id number, p_period_name varchar2) return varchar2 is
  l_period varchar2(30) := p_period_name;
  l_p       varchar2(32767);
  l_ids     varchar2(4000);
  l_ids_chr varchar2(4000);
  l_d1      date;
  l_d2      date;
  l_va      varchar2(32767);
  l_nat     varchar2(32767);
  l_sql     varchar2(32767);
  l_cur     sys_refcursor;
  l_led     varchar2(30);
  l_coa     number;
  l_seg     varchar2(30);
  l_prev    varchar2(60);
  l_coa_map varchar2(4000);
begin
  -- resolve ledger/period rows once, inline them as literals (keeps index ranges on XLA over the link)
  for r in (select /*+ DRIVING_SITE(led) */ led.ledger_id, led.currency_code, led.chart_of_accounts_id,
                   gp.period_name, gp.start_date, gp.end_date,
                   (select gp2.period_name from apps.gl_periods@ADG gp2
                     where gp2.period_set_name = gp.period_set_name and gp2.period_type = gp.period_type
                       and gp2.adjustment_period_flag = 'N' and gp2.end_date = gp.start_date - 1) prior_period_name,
                   (select max(s.application_column_name) from apps.fnd_segment_attribute_values@ADG s
                     where s.application_id = 101 and s.id_flex_code = 'GL#' and s.id_flex_num = led.chart_of_accounts_id
                       and s.segment_attribute_type = 'GL_ACCOUNT' and s.attribute_value = 'Y') natural_segment
              from apps.gl_ledgers@ADG led, apps.gl_periods@ADG gp
             where led.ledger_id = p_ledger_id
               and led.ledger_id in (1003, 5001, 10001)  -- allowed ledgers, enforced on the server
               and gp.period_set_name = led.period_set_name
               and gp.period_type = led.accounted_period_type
               and gp.adjustment_period_flag = 'N'
               and gp.period_name = l_period)
  loop
    if nvl(r.natural_segment, '?') <> 'SEGMENT3' then  -- GL ONLY rows match the natural account on SEGMENT3
      raise_application_error(-20001, 'Ledger ' || r.ledger_id || ': natural account is ' || r.natural_segment
                                      || ', not SEGMENT3. Adjust the natural account part of the query.');
    end if;
    l_p       := l_p || case when l_p is not null then ' union all ' end
              || 'select ' || r.ledger_id || ' ledger_id, ''' || r.period_name || ''' period_name, '''
              || r.prior_period_name || ''' prior_period_name, date ''' || to_char(r.start_date, 'YYYY-MM-DD')
              || ''' start_date, date ''' || to_char(r.end_date, 'YYYY-MM-DD') || ''' end_date, '''
              || r.currency_code || ''' currency_code from dual@ADG';
    l_ids     := l_ids || case when l_ids is not null then ',' end || r.ledger_id;
    l_ids_chr := l_ids_chr || case when l_ids_chr is not null then ',' end || '''' || r.ledger_id || '''';
    l_coa_map := l_coa_map || ', ''' || r.ledger_id || ''', ' || r.chart_of_accounts_id;
    l_d1     := least(nvl(l_d1, r.start_date), r.start_date);
    l_d2      := greatest(nvl(l_d2, r.end_date), r.end_date);
  end loop;

  if l_p is null then  -- no ledger/period match: return an empty result with the same columns
    l_p       := 'select to_number(null) ledger_id, cast(null as varchar2(15)) period_name, cast(null as varchar2(15)) prior_period_name,'
              || ' sysdate start_date, sysdate end_date, cast(null as varchar2(15)) currency_code from dual@ADG where 1 = 2';
    l_ids     := '-1';
    l_ids_chr := '''-1''';
    l_coa_map := ', ''-1'', -1';
    l_d1      := trunc(sysdate);
    l_d2      := trunc(sysdate);
  end if;

  -- valuation account set per ledger: every cost-element account of asset subinventories and standard WIP
  -- classes, plus intransit accounts; asset-type accounts only. V = valuation, I = intransit (I wins, so an
  -- account that is both goes to the intransit bucket together with its subinventory value)
  l_va := q'~select v.ledger_id_chr, v.ccid, min(v.kind) kind
                         from (select hoi.org_information1 ledger_id_chr,
                                      decode(x.k, 1, msi.material_account, 2, msi.material_overhead_account, 3, msi.resource_account,
                                                  4, msi.outside_processing_account, msi.overhead_account) ccid, 'V' kind
                                 from apps.hr_organization_information@ADG hoi, apps.mtl_secondary_inventories@ADG msi,
                                      (select level k from dual@ADG connect by level <= 5) x
                                where hoi.org_information_context = 'Accounting Information' and hoi.org_information1 in (#LEDGERS_CHR#)
                                  and msi.organization_id = hoi.organization_id and msi.asset_inventory = 1
                               union all
                               select hoi.org_information1,
                                      decode(x.k, 1, wac.material_account, 2, wac.material_overhead_account, 3, wac.resource_account,
                                                  4, wac.outside_processing_account, wac.overhead_account), 'V'
                                 from apps.hr_organization_information@ADG hoi, apps.wip_accounting_classes@ADG wac,
                                      (select level k from dual@ADG connect by level <= 5) x
                                where hoi.org_information_context = 'Accounting Information' and hoi.org_information1 in (#LEDGERS_CHR#)
                                  and wac.organization_id = hoi.organization_id and wac.class_type not in (4, 6, 7)
                               union all
                               select hoi.org_information1, mp.intransit_inv_account, 'I'
                                 from apps.hr_organization_information@ADG hoi, apps.mtl_parameters@ADG mp
                                where hoi.org_information_context = 'Accounting Information' and hoi.org_information1 in (#LEDGERS_CHR#)
                                  and mp.organization_id = hoi.organization_id
                               union all
                               select hoi.org_information1, mip.intransit_inv_account, 'I'
                                 from apps.hr_organization_information@ADG hoi, apps.mtl_interorg_parameters@ADG mip
                                where hoi.org_information_context = 'Accounting Information' and hoi.org_information1 in (#LEDGERS_CHR#)
                                  and hoi.organization_id in (mip.from_organization_id, mip.to_organization_id)) v,
                              apps.gl_code_combinations@ADG g
                        where g.code_combination_id = v.ccid
                          and g.account_type = 'A'
                        group by v.ledger_id_chr, v.ccid~';
  l_va := replace(regexp_replace(l_va, '\s+', ' '), '#LEDGERS_CHR#', l_ids_chr);

  -- inventory natural accounts per ledger (SEGMENT3 of the valuation accounts in the ledger's own chart of
  -- accounts; setups also point at accounts of other charts), resolved once and inlined as literals:
  -- p.ledger_id = .. and g.chart_of_accounts_id = .. and g.segment3 in (..)
  open l_cur for 'select /*+ DRIVING_SITE(g) */ distinct va.ledger_id_chr, g.chart_of_accounts_id, g.segment3 from ('
                 || l_va || ') va, apps.gl_code_combinations@ADG g where g.code_combination_id = va.ccid'
                 || ' and g.chart_of_accounts_id = decode(va.ledger_id_chr' || l_coa_map || ') order by 1, 2, 3';
  loop
    fetch l_cur into l_led, l_coa, l_seg;
    exit when l_cur%notfound;
    if l_prev is null or l_led || '/' || l_coa <> l_prev then
      l_nat := l_nat || case when l_prev is not null then ')) or ' end
            || '(p.ledger_id = ' || l_led || ' and g.chart_of_accounts_id = ' || l_coa || ' and g.segment3 in (''' || l_seg || '''';
    else
      l_nat := l_nat || ', ''' || l_seg || '''';
    end if;
    l_prev := l_led || '/' || l_coa;
  end loop;
  close l_cur;
  l_nat := case when l_nat is null then '1 = 2' else '(' || l_nat || ')))' end;

  l_sql := q'~select /*+ DRIVING_SITE(led) NO_MERGE(r) NO_PUSH_PRED(r) LEADING(r led cc mp) USE_HASH(led cc mp) */
       r.ledger_id ledger_id, r.ccid ccid, r.org_id org_id,
       r.onhand_val unrounded_onhand, r.intransit_val unrounded_intransit,
       r.wip_val unrounded_wip, r.wip_prior unrounded_wip_prior,
       r.mta_end unrounded_mta_end, r.mta_prior unrounded_mta_prior,
       r.sla_not_gl unrounded_sla,
       led.name                                             ledger_name,
       r.period_name,
       case r.ccid when -2 then 'INTRANSIT (intransit + shared stock/intransit accounts)'
                   when -3 then 'ORGS WITH THE PERIOD BUT NO CLOSE SUMMARY ROWS' else cc.concatenated_segments end account,
       case when r.ccid = -2 then 'INTRANSIT BUCKET' when r.ccid = -3 then 'ORG CHECK'
            when r.gl_only = 1 then 'GL ONLY' else 'INVENTORY SETUP' end account_setup,
       case when r.grp_org = 1 then '** ACCOUNT TOTAL **' else mp.organization_code end org_code,
       case when r.grp_org = 1 then 'ACCOUNT' else 'ORG' end row_type,
       case when r.grp_org = 0
            then case r.org_cpcs when 3 then 'OK'
                                 when 1 then 'NO PRIOR PERIOD CLOSE DATA'
                                 when 2 then decode(r.org_hp, 8, 'PERIOD OPEN - NO CURRENT CLOSE DATA', 'NO CURRENT PERIOD CLOSE DATA')
                                 else decode(r.org_hp, 8, 'PERIOD OPEN - NO CLOSE DATA', 4, 'NO CLOSE DATA',
                                             'DORMANT ORG - NO PERIOD') end
            when count(case when r.grp_org = 0 then 1 end) over (partition by r.ledger_id, r.ccid) > 0
            then case when sum(r.org_issue) over (partition by r.ledger_id, r.ccid) = 0 then 'OK'
                      else 'ORGS TO CHECK: ' || sum(r.org_issue) over (partition by r.ledger_id, r.ccid) end
       end close_data_check,
       -- layer 1: physical valuation at period end
       round(r.onhand_val, 2)                               onhand_value,
       round(r.intransit_val, 2)                            intransit_value,
       round(r.wip_val, 2)                                  wip_value,
       round(r.onhand_val + r.intransit_val + r.wip_val, 2) total_value,
       -- layer 2: subledger (cumulative MTA for on-hand/intransit, WIP value for WIP)
       round(r.mta_end, 2)                                  accounted_mta,
       round(r.onhand_val + r.intransit_val - r.mta_end, 2) value_vs_mta_diff,
       round(r.mta_prior + r.wip_prior, 2)                  subledger_prior,
       round(r.mta_end + r.wip_val, 2)                      subledger_end,
       round(r.mta_end + r.wip_val - r.mta_prior - r.wip_prior, 2) subledger_change,
       round(r.sla_not_gl, 2)                               sla_not_in_gl,
       -- layer 3: GL (account total rows only)
       case when r.grp_org = 1 then round(r.gl_cst_net, 2) end                gl_cost_mgmt_net,
       case when r.grp_org = 1 then round(r.gl_cst_unposted, 2) end           gl_cost_mgmt_unposted,
       case when r.grp_org = 1 then round(r.gl_net - r.gl_cst_net, 2) end     gl_other_sources_net,
       case when r.grp_org = 1 then round(r.gl_net, 2) end                    gl_period_net,
       case when r.grp_org = 1 then round(r.gl_end, 2) end                    gl_end_balance,
       case when r.grp_org = 1
            then round(r.mta_end + r.wip_val - r.mta_prior - r.wip_prior - r.gl_cst_net - r.sla_not_gl, 2) end activity_diff,
       case when r.grp_org = 1 then round(r.mta_end + r.wip_val - r.gl_end, 2) end subledger_vs_gl_diff
  from (select r0.*,
               case when r0.grp_org = 0 and r0.org_cpcs <> 3 and not (r0.org_cpcs = 0 and r0.org_hp = 0) then 1 else 0 end org_issue
          from (select /*+ NO_MERGE */ m.ledger_id, m.period_name, m.ccid, m.org_id,
                       grouping(m.org_id)     grp_org,
                       sum(m.onhand_val)      onhand_val,
                       sum(m.intransit_val)   intransit_val,
                       sum(m.wip_val)         wip_val,
                       sum(m.wip_prior)       wip_prior,
                       sum(m.mta_end)         mta_end,
                       sum(m.mta_prior)       mta_prior,
                       sum(m.sla_not_gl)      sla_not_gl,
                       sum(m.gl_net)          gl_net,
                       sum(m.gl_end)          gl_end,
                       sum(m.gl_cst_net)      gl_cst_net,
                       sum(m.gl_cst_unposted) gl_cst_unposted,
                       min(m.gl_only)         gl_only,
                       -- close data per org, taken before zero rows are dropped (1 = current, + 2 = prior period rows)
                       max(max(m.cpcs_code))  over (partition by m.ledger_id, m.org_id) org_cpcs,
                       -- org has the period: 4 = closed, 8 = open, 0 = no period (dormant org)
                       max(max(m.has_period)) over (partition by m.ledger_id, m.org_id) org_hp,
                       sum(abs(m.onhand_val) + abs(m.intransit_val) + abs(m.wip_val) + abs(m.wip_prior)
                           + abs(m.mta_end) + abs(m.mta_prior) + abs(m.sla_not_gl)) abs_val,
                       sum(abs(m.gl_net) + abs(m.gl_end) + abs(m.gl_cst_net) + abs(m.gl_cst_unposted)) abs_gl
                  from (-- classify every row's account once: I -> intransit bucket (-2); not configured -> GL ONLY
                        select /*+ NO_MERGE(m) NO_PUSH_PRED(m) LEADING(m va) USE_HASH(va) */
                               m.ledger_id, m.period_name, m.org_id,
                               case when va.kind = 'I' then -2 else m.ccid end ccid,
                               case when va.ccid is null and m.ccid > 0
                                     and (m.src in ('C', 'D', 'E')
                                          or abs(nvl(m.onhand_val, 0)) + abs(nvl(m.intransit_val, 0)) + abs(nvl(m.wip_val, 0))
                                           + abs(nvl(m.wip_prior, 0)) + abs(nvl(m.mta_end, 0)) + abs(nvl(m.mta_prior, 0)) = 0)
                                    then 1 else 0 end gl_only,
                               nvl(m.onhand_val, 0) onhand_val, nvl(m.intransit_val, 0) intransit_val,
                               nvl(m.wip_val, 0) wip_val, nvl(m.wip_prior, 0) wip_prior,
                               nvl(m.mta_end, 0) mta_end, nvl(m.mta_prior, 0) mta_prior, nvl(m.sla_not_gl, 0) sla_not_gl,
                               nvl(m.gl_net, 0) gl_net, nvl(m.gl_end, 0) gl_end, nvl(m.gl_cst_net, 0) gl_cst_net,
                               nvl(m.gl_cst_unposted, 0) gl_cst_unposted, m.cpcs_code, m.has_period
                          from (
                -- A. period close summary: on-hand by subinventory account; intransit as one bucket (ccid -2), current and prior period
                --    cpcs_code per org: 1 = current period summary exists, + 2 = prior period summary exists
                select c.ledger_id, c.period_name, c.organization_id org_id,
                       decode(x.k, 1, nvl(msi.material_account, mp.material_account), -2) ccid, 'A' src,
                       sum(decode(x.k, 1, c.oh_val, 0))                    onhand_val,
                       sum(decode(x.k, 2, c.it_val, 0))                    intransit_val,
                       0 wip_val, 0 wip_prior,
                       sum(decode(x.k, 1, c.oh_mta, c.it_mta))             mta_end,
                       sum(decode(x.k, 1, c.oh_mta_prior, c.it_mta_prior)) mta_prior,
                       0 sla_not_gl, 0 gl_net, 0 gl_end, 0 gl_cst_net, 0 gl_cst_unposted,
                       max(sign(c.org_cur_n) + 2 * sign(c.org_prior_n))   cpcs_code,
                       0 has_period
                  from (select /*+ NO_MERGE */ p.ledger_id, p.period_name, c.organization_id, c.subinventory_code,
                               sum(case when oap.period_name = p.period_name then c.rollback_onhand_value end)          oh_val,
                               sum(case when oap.period_name = p.period_name then c.rollback_intransit_value end)       it_val,
                               sum(case when oap.period_name = p.period_name then c.cumulative_onhand_mta end)          oh_mta,
                               sum(case when oap.period_name = p.period_name then c.cumulative_intransit_mta end)       it_mta,
                               sum(case when oap.period_name = p.prior_period_name then c.cumulative_onhand_mta end)    oh_mta_prior,
                               sum(case when oap.period_name = p.prior_period_name then c.cumulative_intransit_mta end) it_mta_prior,
                               sum(count(case when oap.period_name = p.period_name then 1 end))
                                   over (partition by p.ledger_id, c.organization_id)                                   org_cur_n,
                               sum(count(case when oap.period_name = p.prior_period_name then 1 end))
                                   over (partition by p.ledger_id, c.organization_id)                                   org_prior_n
                          from (#P#) p,
                               apps.hr_organization_information@ADG hoi,
                               apps.org_acct_periods@ADG oap,
                               apps.cst_period_close_summary@ADG c
                         where hoi.org_information_context = 'Accounting Information'
                           and hoi.org_information1 = to_char(p.ledger_id)
                           and oap.organization_id = hoi.organization_id
                           and oap.period_name in (p.period_name, p.prior_period_name)
                           and c.acct_period_id = oap.acct_period_id
                           and c.organization_id = oap.organization_id
                         group by p.ledger_id, p.period_name, c.organization_id, c.subinventory_code) c,
                       apps.mtl_parameters@ADG mp,
                       apps.mtl_secondary_inventories@ADG msi,
                       (select level k from dual@ADG connect by level <= 2) x
                 where mp.organization_id = c.organization_id
                   and msi.organization_id(+) = c.organization_id
                   and msi.secondary_inventory_name(+) = c.subinventory_code
                 group by c.ledger_id, c.period_name, c.organization_id,
                          decode(x.k, 1, nvl(msi.material_account, mp.material_account), -2)
                union all
                -- B. WIP value by cost element on the job's element accounts: cumulative WIP period balances up to
                --    period end / prior period end, all discrete jobs incl. residuals on closed jobs; expense
                --    (4), maintenance (6) and expense lot-based (7) classes excluded. WPB is read in one full scan.
                select b.ledger_id, b.period_name, b.organization_id,
                       decode(x.k, 1, b.a1, 2, b.a2, 3, b.a3, 4, b.a4, b.a5), 'B',
                       0, 0,
                       sum(decode(x.k, 1, b.e1, 2, b.e2, 3, b.e3, 4, b.e4, b.e5)),
                       sum(decode(x.k, 1, b.p1, 2, b.p2, 3, b.p3, 4, b.p4, b.p5)),
                       0, 0, 0, 0, 0, 0, 0, 0, 0
                  from (select /*+ NO_MERGE LEADING(p hoi oap w wdj wac) USE_HASH(w wdj wac) FULL(w) */
                               p.ledger_id, p.period_name, w.organization_id,
                               wdj.material_account a1, wdj.material_overhead_account a2, wdj.resource_account a3,
                               wdj.outside_processing_account a4, wdj.overhead_account a5,
                               sum(case when oap.period_start_date <= p.end_date  then w.mat end) e1,
                               sum(case when oap.period_start_date <= p.end_date  then w.moh end) e2,
                               sum(case when oap.period_start_date <= p.end_date  then w.res end) e3,
                               sum(case when oap.period_start_date <= p.end_date  then w.osp end) e4,
                               sum(case when oap.period_start_date <= p.end_date  then w.ovh end) e5,
                               sum(case when oap.period_start_date <  p.start_date then w.mat end) p1,
                               sum(case when oap.period_start_date <  p.start_date then w.moh end) p2,
                               sum(case when oap.period_start_date <  p.start_date then w.res end) p3,
                               sum(case when oap.period_start_date <  p.start_date then w.osp end) p4,
                               sum(case when oap.period_start_date <  p.start_date then w.ovh end) p5
                          from (#P#) p,
                               apps.hr_organization_information@ADG hoi,
                               apps.org_acct_periods@ADG oap,
                               (select w.acct_period_id, w.organization_id, w.wip_entity_id,
                                         nvl(w.pl_material_in,0) + nvl(w.tl_scrap_in,0) - nvl(w.pl_material_out,0) - nvl(w.tl_material_out,0)
                                       - nvl(w.tl_scrap_out,0) - nvl(w.pl_material_var,0) - nvl(w.tl_material_var,0) - nvl(w.tl_scrap_var,0) mat,
                                         nvl(w.pl_material_overhead_in,0) - nvl(w.pl_material_overhead_out,0) - nvl(w.tl_material_overhead_out,0)
                                       - nvl(w.pl_material_overhead_var,0) - nvl(w.tl_material_overhead_var,0) moh,
                                         nvl(w.pl_resource_in,0) + nvl(w.tl_resource_in,0) - nvl(w.pl_resource_out,0) - nvl(w.tl_resource_out,0)
                                       - nvl(w.pl_resource_var,0) - nvl(w.tl_resource_var,0) res,
                                         nvl(w.pl_outside_processing_in,0) + nvl(w.tl_outside_processing_in,0) - nvl(w.pl_outside_processing_out,0)
                                       - nvl(w.tl_outside_processing_out,0) - nvl(w.pl_outside_processing_var,0) - nvl(w.tl_outside_processing_var,0) osp,
                                         nvl(w.pl_overhead_in,0) + nvl(w.tl_overhead_in,0) - nvl(w.pl_overhead_out,0) - nvl(w.tl_overhead_out,0)
                                       - nvl(w.pl_overhead_var,0) - nvl(w.tl_overhead_var,0) ovh
                                  from apps.wip_period_balances@ADG w) w,
                               apps.wip_discrete_jobs@ADG wdj,
                               apps.wip_accounting_classes@ADG wac
                         where hoi.org_information_context = 'Accounting Information'
                           and hoi.org_information1 = to_char(p.ledger_id)
                           and oap.organization_id = hoi.organization_id
                           and oap.period_start_date <= p.end_date
                           and w.acct_period_id = oap.acct_period_id
                           and w.organization_id = oap.organization_id
                           and wdj.wip_entity_id = w.wip_entity_id
                           and wdj.organization_id = hoi.organization_id
                           and wac.organization_id = wdj.organization_id
                           and wac.class_code = wdj.class_code
                           and wac.class_type not in (4, 6, 7)
                         group by p.ledger_id, p.period_name, w.organization_id, wdj.material_account, wdj.material_overhead_account,
                                  wdj.resource_account, wdj.outside_processing_account, wdj.overhead_account) b,
                       (select level k from dual@ADG connect by level <= 5) x
                 group by b.ledger_id, b.period_name, b.organization_id, decode(x.k, 1, b.a1, 2, b.a2, 3, b.a3, 4, b.a4, b.a5)
                union all
                -- C. SLA (Cost Management, app 707) entries not in GL yet (draft, invalid, final not transferred), by org,
                --    on any asset account with an inventory natural account
                select /*+ LEADING(p h l g xte) INDEX(h XLA_AE_HEADERS_N5) USE_NL(l) USE_NL(g) USE_NL(xte) */
                       p.ledger_id, p.period_name, xte.security_id_int_1, l.code_combination_id, 'C',
                       0, 0, 0, 0, 0, 0,
                       sum(nvl(l.accounted_dr,0) - nvl(l.accounted_cr,0)),
                       0, 0, 0, 0, 0, 0
                  from (#P#) p,
                       apps.xla_ae_headers@ADG h,
                       apps.xla_ae_lines@ADG l,
                       apps.gl_code_combinations@ADG g,
                       xla.xla_transaction_entities@ADG xte
                 where h.application_id = 707
                   and h.ledger_id = p.ledger_id
                   and h.ledger_id in (#LEDGERS#)
                   and h.accounting_date between p.start_date and p.end_date
                   and h.accounting_date between #D1# and #D2#
                   and h.gl_transfer_status_code <> 'Y'
                   and h.balance_type_code = 'A'
                   and l.ae_header_id = h.ae_header_id
                   and l.application_id = 707
                   and g.code_combination_id = l.code_combination_id
                   and g.account_type = 'A'
                   and #NAT#
                   and xte.entity_id = h.entity_id
                   and xte.application_id = 707
                 group by p.ledger_id, p.period_name, xte.security_id_int_1, l.code_combination_id
                union all
                -- D. GL balances + posted Cost Management journals at account level (org -1), on every asset account
                --    with an inventory natural account (configured accounts and GL ONLY accounts)
                select p.ledger_id, p.period_name, -1, gb.code_combination_id, 'D',
                       0, 0, 0, 0, 0, 0, 0,
                       nvl(gb.period_net_dr,0) - nvl(gb.period_net_cr,0),
                       nvl(gb.begin_balance_dr,0) - nvl(gb.begin_balance_cr,0) + nvl(gb.period_net_dr,0) - nvl(gb.period_net_cr,0),
                       nvl((select sum(nvl(jl.accounted_dr,0) - nvl(jl.accounted_cr,0))
                          from apps.gl_je_lines@ADG jl, apps.gl_je_headers@ADG jh
                         where jl.code_combination_id = gb.code_combination_id
                           and jl.period_name = gb.period_name
                           and jl.ledger_id = gb.ledger_id
                           and jh.je_header_id = jl.je_header_id
                           and jh.je_source = 'Cost Management'
                           and jh.actual_flag = 'A'
                           and jh.status = 'P'), 0),
                       0, 0, 0
                  from (#P#) p,
                       apps.gl_code_combinations@ADG g,
                       apps.gl_balances@ADG gb
                 where #NAT#
                   and g.account_type = 'A'
                   and g.summary_flag = 'N'
                   and gb.code_combination_id = g.code_combination_id
                   and gb.ledger_id = p.ledger_id
                   and gb.period_name = p.period_name
                   and gb.actual_flag = 'A'
                   and gb.currency_code = p.currency_code
                   and gb.translated_flag is null
                   and gb.template_id is null
                   and (   nvl(gb.begin_balance_dr,0) - nvl(gb.begin_balance_cr,0) <> 0
                        or nvl(gb.period_net_dr,0) <> 0
                        or nvl(gb.period_net_cr,0) <> 0)
                union all
                -- E. Cost Management journals not posted yet, read from the journals (an account needs no GL_BALANCES row)
                select /*+ LEADING(p jh jl g) USE_NL(jl) USE_NL(g) */
                       p.ledger_id, p.period_name, -1, jl.code_combination_id, 'E',
                       0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                       sum(nvl(jl.accounted_dr,0) - nvl(jl.accounted_cr,0)),
                       0, 0
                  from (#P#) p,
                       apps.gl_je_headers@ADG jh,
                       apps.gl_je_lines@ADG jl,
                       apps.gl_code_combinations@ADG g
                 where jh.ledger_id = p.ledger_id
                   and jh.ledger_id in (#LEDGERS#)
                   and jh.period_name = p.period_name
                   and jh.period_name = '#PERIOD#'
                   and jh.je_source = 'Cost Management'
                   and jh.actual_flag = 'A'
                   and jh.status <> 'P'
                   and jl.je_header_id = jh.je_header_id
                   and g.code_combination_id = jl.code_combination_id
                   and g.account_type = 'A'
                   and #NAT#
                 group by p.ledger_id, p.period_name, jl.code_combination_id
                union all
                -- F. orgs that have the period but no close summary rows for it (ORG CHECK line, no amounts)
                select p.ledger_id, p.period_name, oap.organization_id, -3, 'F',
                       0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                       decode(oap.open_flag, 'N', 4, 8)
                  from (#P#) p,
                       apps.hr_organization_information@ADG hoi,
                       apps.org_acct_periods@ADG oap
                 where hoi.org_information_context = 'Accounting Information'
                   and hoi.org_information1 = to_char(p.ledger_id)
                   and oap.organization_id = hoi.organization_id
                   and oap.period_name = p.period_name
                   and not exists (select 1 from apps.cst_period_close_summary@ADG c
                                    where c.acct_period_id = oap.acct_period_id and c.organization_id = oap.organization_id)
                               ) m,
                               (#VA#) va
                         where va.ledger_id_chr(+) = to_char(m.ledger_id)
                           and va.ccid(+) = m.ccid
                       ) m
                 group by m.ledger_id, m.period_name, m.ccid, rollup(m.org_id)) r0
         where not (r0.grp_org = 0 and r0.org_id = -1)   -- GL is account level only
           and not (r0.grp_org = 1 and r0.ccid = -3)     -- ORG CHECK has no account total
           and (r0.abs_val <> 0 or r0.ccid = -3 or (r0.grp_org = 1 and r0.abs_gl <> 0))) r,  -- drop all-zero rows
       apps.gl_ledgers@ADG led,
       apps.gl_code_combinations_kfv@ADG cc,
       apps.mtl_parameters@ADG mp
 where led.ledger_id = r.ledger_id
   and cc.code_combination_id(+) = r.ccid
   and mp.organization_id(+) = r.org_id
 order by led.name, r.gl_only, cc.concatenated_segments nulls last, r.ccid desc, r.grp_org, mp.organization_code~';

  l_sql := replace(l_sql, '#VA#', l_va);
  l_sql := replace(l_sql, '#NAT#', l_nat);
  l_sql := replace(l_sql, '#P#', l_p);
  l_sql := replace(l_sql, '#LEDGERS#', l_ids);
  l_sql := replace(l_sql, '#PERIOD#', l_period);
  l_sql := replace(l_sql, '#D1#', 'date ''' || to_char(l_d1, 'YYYY-MM-DD') || '''');
  l_sql := replace(l_sql, '#D2#', 'date ''' || to_char(l_d2, 'YYYY-MM-DD') || '''');
  return l_sql;
end canonical_sql;

  procedure capture_raw(p_ledger number, p_period varchar2, p_collection varchar2) is
    l_cursor integer; l_n integer; l_count integer; l_desc dbms_sql.desc_tab2;
    l_number number; l_text varchar2(4000); j json_object_t;
  begin
    apex_collection.create_collection(p_collection);
    l_cursor := dbms_sql.open_cursor;
    dbms_sql.parse(l_cursor, canonical_sql(p_ledger, p_period), dbms_sql.native);
    dbms_sql.describe_columns2(l_cursor, l_count, l_desc);
    for i in 1 .. l_count loop
      if l_desc(i).col_type = 2 then dbms_sql.define_column(l_cursor, i, l_number);
      else dbms_sql.define_column(l_cursor, i, l_text, 4000); end if;
    end loop;
    l_n := dbms_sql.execute(l_cursor);
    while dbms_sql.fetch_rows(l_cursor) > 0 loop
      j := json_object_t();
      for i in 1 .. l_count loop
        if l_desc(i).col_type = 2 then
          dbms_sql.column_value(l_cursor, i, l_number);
          if l_number is null then j.put_null(l_desc(i).col_name); else j.put(l_desc(i).col_name, l_number); end if;
        else
          dbms_sql.column_value(l_cursor, i, l_text);
          if l_text is null then j.put_null(l_desc(i).col_name); else j.put(l_desc(i).col_name, l_text); end if;
        end if;
      end loop;
      add_json(p_collection, j, p_ledger, j.get_number('ORG_ID'), j.get_number('CCID'));
    end loop;
    dbms_sql.close_cursor(l_cursor);
  exception when others then
    if l_cursor is not null and dbms_sql.is_open(l_cursor) then dbms_sql.close_cursor(l_cursor); end if;
    raise;
  end;

  function normalize_scope(p_org_ids varchar2, p_ready varchar2) return varchar2 is
    l_scope varchar2(32767); l_id varchar2(100); l_n number;
    l_seen t_flag_map;
  begin
    if p_org_ids is null then return 'ALL'; end if;
    if not regexp_like(p_org_ids, '^[0-9]+(:[0-9]+)*$') then
      raise_application_error(-20001, 'Select inventory organizations from the checked list.');
    end if;
    for r in (select regexp_substr(p_org_ids, '[^:]+', 1, level) org_id from dual
              connect by regexp_substr(p_org_ids, '[^:]+', 1, level) is not null) loop
      l_id := key_of(to_number(r.org_id));
      select count(*) into l_n from apex_collections where collection_name = p_ready and n002 = to_number(l_id);
      if l_n <> 1 then raise_application_error(-20001, 'An organization is outside the checked ledger. Check organizations again.'); end if;
      l_seen(l_id) := true;
    end loop;
    l_id := l_seen.first;
    while l_id is not null loop
      l_scope := l_scope || case when l_scope is not null then ':' end || l_id;
      l_id := l_seen.next(l_id);
    end loop;
    return l_scope;
  end;

  function in_scope(p_scope varchar2, p_org number) return boolean is
  begin
    return p_scope = 'ALL' or instr(':' || p_scope || ':', ':' || key_of(p_org) || ':') > 0;
  end;

  procedure null_fields(p_json in out nocopy json_object_t, p_fields varchar2) is
  begin
    for r in (select regexp_substr(p_fields, '[^,]+', 1, level) field_name from dual
              connect by regexp_substr(p_fields, '[^,]+', 1, level) is not null) loop
      p_json.put_null(r.field_name);
    end loop;
  end;

  procedure exact_amounts(j in out nocopy json_object_t) is
    oh number := nvl(j.get_number('UNROUNDED_ONHAND'), 0);
    it number := nvl(j.get_number('UNROUNDED_INTRANSIT'), 0);
    wi number := nvl(j.get_number('UNROUNDED_WIP'), 0);
    wp number := nvl(j.get_number('UNROUNDED_WIP_PRIOR'), 0);
    me number := nvl(j.get_number('UNROUNDED_MTA_END'), 0);
    mp number := nvl(j.get_number('UNROUNDED_MTA_PRIOR'), 0);
  begin
    j.put('ONHAND_VALUE', oh); j.put('INTRANSIT_VALUE', it); j.put('WIP_VALUE', wi);
    j.put('TOTAL_VALUE', oh + it + wi); j.put('ACCOUNTED_MTA', me);
    j.put('VALUE_VS_MTA_DIFF', oh + it - me);
    j.put('SUBLEDGER_PRIOR', mp + wp); j.put('SUBLEDGER_END', me + wi);
    j.put('SUBLEDGER_CHANGE', me + wi - mp - wp);
    j.put('SLA_NOT_IN_GL', nvl(j.get_number('UNROUNDED_SLA'), 0));
  end;

  procedure readiness_amounts(j in out nocopy json_object_t, p_ready json_object_t) is
    l_current boolean := p_ready.get_string('INV_STATUS') = 'CLOSED' and p_ready.get_string('CURRENT_SUMMARY') = 'Y';
    l_prior boolean := p_ready.get_string('PRIOR_SUMMARY') = 'Y';
  begin
    j.put('READINESS_STATUS', p_ready.get_string('READINESS_STATUS'));
    j.put('CLOSE_DATA_CHECK', p_ready.get_string('READINESS_STATUS'));
    if p_ready.get_string('READINESS_STATUS') = 'DORMANT' then
      null_fields(j, 'ONHAND_VALUE,INTRANSIT_VALUE,ACCOUNTED_MTA,VALUE_VS_MTA_DIFF');
      j.put('TOTAL_VALUE', j.get_number('WIP_VALUE'));
      j.put('SUBLEDGER_END', j.get_number('WIP_VALUE'));
      j.put('SUBLEDGER_PRIOR', nvl(j.get_number('UNROUNDED_WIP_PRIOR'), 0));
      j.put('SUBLEDGER_CHANGE', j.get_number('WIP_VALUE') - nvl(j.get_number('UNROUNDED_WIP_PRIOR'), 0));
      -- No period exists; retain only the WPB residual shown by the canonical query.
    else
      if not l_current then
        null_fields(j, 'ONHAND_VALUE,INTRANSIT_VALUE,WIP_VALUE,TOTAL_VALUE,ACCOUNTED_MTA,VALUE_VS_MTA_DIFF,SUBLEDGER_END,SUBLEDGER_CHANGE,ACTIVITY_DIFF,SUBLEDGER_VS_GL_DIFF');
      end if;
      if not l_prior then null_fields(j, 'SUBLEDGER_PRIOR,SUBLEDGER_CHANGE,ACTIVITY_DIFF'); end if;
    end if;
  end;

  procedure augment_observed_owners(p_raw varchar2, p_ready varchar2, p_owners varchar2, p_ledger number) is
    l_seen t_flag_map; l_ready t_json_map;
    j json_object_t; x json_object_t; k varchar2(100); o varchar2(100);
  begin
    for r in (select clob001 from apex_collections where collection_name = p_ready) loop
      j := json_object_t.parse(r.clob001); l_ready(key_of(j.get_number('ORG_ID'))) := j;
    end loop;
    for r in (select clob001 from apex_collections where collection_name = p_owners) loop
      j := json_object_t.parse(r.clob001);
      l_seen(key_of(j.get_number('BUCKET_CCID')) || '/' || key_of(j.get_number('ORG_ID'))) := true;
    end loop;
    for r in (select clob001 from apex_collections where collection_name = p_raw order by seq_id) loop
      j := json_object_t.parse(r.clob001);
      if j.get_string('ROW_TYPE') = 'ORG' and nvl(j.get_number('CCID'), -999) <> -3 and j.get_number('ORG_ID') is not null then
        o := key_of(j.get_number('ORG_ID')); k := key_of(j.get_number('CCID')) || '/' || o;
        if not l_seen.exists(k) then
          l_seen(k) := true; x := json_object_t();
          x.put('LEDGER_ID', p_ledger); x.put('CCID', j.get_number('CCID'));
          x.put('BUCKET_CCID', j.get_number('CCID')); x.put('ACCOUNT', j.get_string('ACCOUNT'));
          x.put('ORG_ID', j.get_number('ORG_ID')); x.put('ORG_CODE', j.get_string('ORG_CODE'));
          if l_ready.exists(o) then x.put('ORG_NAME', l_ready(o).get_string('ORG_NAME')); else x.put_null('ORG_NAME'); end if;
          x.put('KIND', case when j.get_number('CCID') = -2 then 'I' else 'V' end);
          x.put('EVIDENCE', 'OBSERVED ACTIVITY'); x.put('CONFIGURED', 'N'); x.put('CANDIDATE_PAIR', 'N');
          add_json(p_owners, x, p_ledger, j.get_number('ORG_ID'), j.get_number('CCID'), 'OBSERVED|' || k);
        end if;
      end if;
    end loop;
  end;

  procedure derive_scope(p_ledger number, p_period varchar2, p_scope varchar2,
                         p_raw varchar2, p_ready varchar2, p_owners varchar2,
                         p_result varchar2, p_meta out clob) is
    l_ready t_json_map; l_accounts t_json_map; l_raw_accounts t_json_map;
    l_owner_seen t_flag_map; l_owner_count t_number_map; l_selected_count t_number_map;
    l_mapped_owner_exists t_flag_map;
    l_missing t_string_map; l_incomplete t_flag_map; l_cur_bad t_flag_map; l_prior_bad t_flag_map;
    l_org_account_seen t_flag_map; l_fields t_names;
    j json_object_t; a json_object_t; q json_object_t; meta json_object_t;
    l_key varchar2(100); l_owner_key varchar2(100); l_org_key varchar2(100); l_field varchar2(50);
    l_total_orgs number := 0; l_selected_orgs number := 0; l_ready_orgs number := 0; l_incomplete_orgs number := 0;
    l_partial_accounts number := 0; l_is_all boolean; l_allowed boolean; l_unknown_owner boolean;
    l_global_current_bad boolean := false; l_global_prior_bad boolean := false;
    l_amount number; l_totals t_number_map; l_bad_total t_flag_map;
    l_gl_fields constant varchar2(1000) := 'GL_COST_MGMT_NET,GL_COST_MGMT_UNPOSTED,GL_OTHER_SOURCES_NET,GL_PERIOD_NET,GL_END_BALANCE,ACTIVITY_DIFF,SUBLEDGER_VS_GL_DIFF';
    procedure count_owner(p_bucket varchar2, p_org number, p_org_code varchar2) is
      k varchar2(100) := p_bucket || '/' || key_of(p_org);
      o varchar2(100) := key_of(p_org);
      rd json_object_t;
    begin
      if not l_owner_seen.exists(k) then
        l_owner_seen(k) := true;
        if not l_owner_count.exists(p_bucket) then l_owner_count(p_bucket) := 0; l_selected_count(p_bucket) := 0; end if;
        l_owner_count(p_bucket) := l_owner_count(p_bucket) + 1;
        if in_scope(p_scope, p_org) then
          l_selected_count(p_bucket) := l_selected_count(p_bucket) + 1;
          if l_ready.exists(o) then
            rd := l_ready(o);
            if rd.get_string('READINESS_STATUS') not in ('READY', 'DORMANT') then l_incomplete(p_bucket) := true; end if;
            if rd.get_string('READINESS_STATUS') <> 'DORMANT' then
              if rd.get_string('INV_STATUS') <> 'CLOSED' or rd.get_string('CURRENT_SUMMARY') <> 'Y' then l_cur_bad(p_bucket) := true; end if;
              if rd.get_string('PRIOR_SUMMARY') <> 'Y' then l_prior_bad(p_bucket) := true; end if;
            end if;
          else
            l_incomplete(p_bucket) := true; l_cur_bad(p_bucket) := true; l_prior_bad(p_bucket) := true;
          end if;
        else
          l_missing(p_bucket) := substr(case when l_missing.exists(p_bucket) then l_missing(p_bucket) || ', ' end || p_org_code, 1, 32000);
        end if;
      end if;
    end;
    procedure add_amounts(p_target in out nocopy json_object_t, p_value json_object_t) is
    begin
      for i in 1 .. l_fields.count loop
        l_field := l_fields(i);
        if not json_null(p_value, l_field) then
          p_target.put(l_field, nvl(p_target.get_number(l_field), 0) + p_value.get_number(l_field));
        end if;
      end loop;
    end;
    function blank_account(p_source json_object_t) return json_object_t is
      x json_object_t;
    begin
      x := json_object_t.parse(p_source.to_clob);
      x.put('ROW_TYPE', 'ACCOUNT'); x.put('ORG_CODE', '** ACCOUNT TOTAL **'); x.put_null('ORG_ID');
      for i in 1 .. l_fields.count loop x.put(l_fields(i), 0); end loop;
      return x;
    end;
  begin
    l_fields(1):='ONHAND_VALUE'; l_fields(2):='INTRANSIT_VALUE'; l_fields(3):='WIP_VALUE';
    l_fields(4):='TOTAL_VALUE'; l_fields(5):='ACCOUNTED_MTA'; l_fields(6):='VALUE_VS_MTA_DIFF';
    l_fields(7):='SUBLEDGER_PRIOR'; l_fields(8):='SUBLEDGER_END'; l_fields(9):='SUBLEDGER_CHANGE';
    l_fields(10):='SLA_NOT_IN_GL';
    apex_collection.create_collection(p_result);
    for r in (select clob001 from apex_collections where collection_name = p_ready) loop
      j := json_object_t.parse(r.clob001); l_org_key := key_of(j.get_number('ORG_ID'));
      l_ready(l_org_key) := j; l_total_orgs := l_total_orgs + 1;
      if in_scope(p_scope, j.get_number('ORG_ID')) then
        l_selected_orgs := l_selected_orgs + 1;
        if j.get_string('READINESS_STATUS') = 'READY' then l_ready_orgs := l_ready_orgs + 1;
        elsif j.get_string('READINESS_STATUS') <> 'DORMANT' then l_incomplete_orgs := l_incomplete_orgs + 1; end if;
        if j.get_string('READINESS_STATUS') <> 'DORMANT' then
          if j.get_string('INV_STATUS') <> 'CLOSED' or j.get_string('CURRENT_SUMMARY') <> 'Y' then l_global_current_bad := true; end if;
          if j.get_string('PRIOR_SUMMARY') <> 'Y' then l_global_prior_bad := true; end if;
        end if;
      end if;
    end loop;
    l_is_all := l_selected_orgs = l_total_orgs;
    for r in (select clob001 from apex_collections where collection_name = p_owners) loop
      j := json_object_t.parse(r.clob001); l_key := key_of(j.get_number('BUCKET_CCID'));
      if nvl(j.get_string('CONFIGURED'), 'Y') = 'Y' then l_mapped_owner_exists(l_key) := true; end if;
      count_owner(l_key, j.get_number('ORG_ID'), j.get_string('ORG_CODE'));
    end loop;
    -- Observed full-ledger org activity also establishes a conservative owner,
    -- including historical mappings that are absent from current setup.
    for r in (select clob001 from apex_collections where collection_name = p_raw) loop
      j := json_object_t.parse(r.clob001);
      if j.get_string('ROW_TYPE') = 'ORG' and nvl(j.get_number('CCID'), -999) <> -3 and j.get_number('ORG_ID') is not null then
        count_owner(key_of(j.get_number('CCID')), j.get_number('ORG_ID'), j.get_string('ORG_CODE'));
      end if;
    end loop;
    for r in (select clob001 from apex_collections where collection_name = p_raw order by seq_id) loop
      j := json_object_t.parse(r.clob001); l_key := key_of(j.get_number('CCID'));
      if nvl(j.get_number('CCID'), -999) <> -3 then
        if j.get_string('ROW_TYPE') = 'ACCOUNT' then
          l_raw_accounts(l_key) := j;
        elsif j.get_number('ORG_ID') is not null and in_scope(p_scope, j.get_number('ORG_ID')) then
          l_org_key := key_of(j.get_number('ORG_ID'));
          exact_amounts(j);
          if l_ready.exists(l_org_key) then readiness_amounts(j, l_ready(l_org_key));
          else
            j.put('READINESS_STATUS', 'UNKNOWN ORGANIZATION');
            null_fields(j, 'ONHAND_VALUE,INTRANSIT_VALUE,WIP_VALUE,TOTAL_VALUE,ACCOUNTED_MTA,VALUE_VS_MTA_DIFF,SUBLEDGER_PRIOR,SUBLEDGER_END,SUBLEDGER_CHANGE');
            l_cur_bad(l_key) := true; l_prior_bad(l_key) := true; l_incomplete(l_key) := true;
          end if;
          if not l_accounts.exists(l_key) then l_accounts(l_key) := blank_account(j); end if;
          a := l_accounts(l_key); add_amounts(a, j); l_accounts(l_key) := a;
          l_org_account_seen(l_key) := true;
          j.put('GL_SCOPE_STATUS', 'ORG DETAIL');
          for i in 1 .. l_fields.count loop
            if not json_null(j, l_fields(i)) then j.put(l_fields(i), round(j.get_number(l_fields(i)), 2)); end if;
          end loop;
          add_json(p_result, j, p_ledger, j.get_number('ORG_ID'), j.get_number('CCID'));
        end if;
      end if;
    end loop;
    -- Include selected-owned accounts even when their physical amount is absent;
    -- include unowned GL context only for a full-ledger selection.
    l_key := l_raw_accounts.first;
    while l_key is not null loop
      if not l_accounts.exists(l_key) and
         (l_is_all or l_raw_accounts(l_key).get_string('ACCOUNT_SETUP') = 'GL ONLY'
                   or (l_selected_count.exists(l_key) and l_selected_count(l_key) > 0)) then
        l_accounts(l_key) := blank_account(l_raw_accounts(l_key));
      end if;
      l_key := l_raw_accounts.next(l_key);
    end loop;
    l_key := l_accounts.first;
    while l_key is not null loop
      a := l_accounts(l_key);
      a.put('SUBLEDGER_SCOPE_STATUS', case when l_org_account_seen.exists(l_key) then 'SELECTED ORGS'
                                         when a.get_string('ACCOUNT_SETUP') = 'GL ONLY' then 'CONTEXT ONLY'
                                         else 'NO CAPTURED ORG AMOUNTS' end);
      if l_raw_accounts.exists(l_key) then
        q := l_raw_accounts(l_key); a.put('FULL_LEDGER_GL_END_BALANCE', q.get_number('GL_END_BALANCE'));
      else a.put_null('FULL_LEDGER_GL_END_BALANCE'); end if;
      if l_cur_bad.exists(l_key) then
        null_fields(a, 'ONHAND_VALUE,INTRANSIT_VALUE,WIP_VALUE,TOTAL_VALUE,ACCOUNTED_MTA,VALUE_VS_MTA_DIFF,SUBLEDGER_END,SUBLEDGER_CHANGE');
      end if;
      if l_prior_bad.exists(l_key) then null_fields(a, 'SUBLEDGER_PRIOR,SUBLEDGER_CHANGE'); end if;
      a.put('OWNER_COUNT', case when l_owner_count.exists(l_key) then l_owner_count(l_key) else 0 end);
      a.put('SELECTED_OWNER_COUNT', case when l_selected_count.exists(l_key) then l_selected_count(l_key) else 0 end);
      if l_missing.exists(l_key) then a.put('MISSING_OWNER_CODES', l_missing(l_key)); else a.put_null('MISSING_OWNER_CODES'); end if;
      l_unknown_owner := not l_mapped_owner_exists.exists(l_key);
      if l_raw_accounts.exists(l_key) then
        q := l_raw_accounts(l_key);
        if q.get_string('ACCOUNT_SETUP') = 'GL ONLY' then l_unknown_owner := true; end if;
      end if;
      l_allowed := l_is_all or (not l_unknown_owner and l_owner_count.exists(l_key) and l_owner_count(l_key) > 0
                     and l_selected_count(l_key) = l_owner_count(l_key));
      if l_allowed then
        a.put('GL_SCOPE_STATUS', case when l_is_all then 'LEDGER TOTAL' else 'FULL OWNERSHIP' end);
        if l_raw_accounts.exists(l_key) then
          q := l_raw_accounts(l_key);
          for f in (select regexp_substr(l_gl_fields, '[^,]+', 1, level) field_name from dual
                    connect by regexp_substr(l_gl_fields, '[^,]+', 1, level) is not null) loop
            a.put(f.field_name, nvl(q.get_number(f.field_name), 0));
          end loop;
        else
          for f in (select regexp_substr(l_gl_fields, '[^,]+', 1, level) field_name from dual
                    connect by regexp_substr(l_gl_fields, '[^,]+', 1, level) is not null) loop a.put(f.field_name, 0); end loop;
        end if;
        if json_null(a, 'SUBLEDGER_CHANGE') then a.put_null('ACTIVITY_DIFF');
        else a.put('ACTIVITY_DIFF', a.get_number('SUBLEDGER_CHANGE') - a.get_number('GL_COST_MGMT_NET') - a.get_number('SLA_NOT_IN_GL')); end if;
        if json_null(a, 'SUBLEDGER_END') then a.put_null('SUBLEDGER_VS_GL_DIFF');
        else a.put('SUBLEDGER_VS_GL_DIFF', a.get_number('SUBLEDGER_END') - a.get_number('GL_END_BALANCE')); end if;
      else
        l_partial_accounts := l_partial_accounts + 1;
        a.put('GL_SCOPE_STATUS', case when l_unknown_owner then 'UNKNOWN OWNERSHIP' else 'PARTIAL OWNERSHIP' end);
        null_fields(a, l_gl_fields);
      end if;
      a.put('READINESS_STATUS', case when l_incomplete.exists(l_key) then 'INCOMPLETE' else 'READY' end);
      a.put('CLOSE_DATA_CHECK', case when l_incomplete.exists(l_key) then 'ORGS TO CHECK' else 'OK' end);
      for i in 1 .. l_fields.count loop
        if not json_null(a, l_fields(i)) then a.put(l_fields(i), round(a.get_number(l_fields(i)), 2)); end if;
      end loop;
      if not json_null(a, 'ACTIVITY_DIFF') then a.put('ACTIVITY_DIFF', round(a.get_number('ACTIVITY_DIFF'), 2)); end if;
      if not json_null(a, 'SUBLEDGER_VS_GL_DIFF') then a.put('SUBLEDGER_VS_GL_DIFF', round(a.get_number('SUBLEDGER_VS_GL_DIFF'), 2)); end if;
      add_json(p_result, a, p_ledger, null, a.get_number('CCID'));
      -- A summary must not silently SUM away unavailable amounts.
      for f in (select regexp_substr('TOTAL_VALUE,SUBLEDGER_END,ACTIVITY_DIFF,SUBLEDGER_VS_GL_DIFF,SLA_NOT_IN_GL,GL_END_BALANCE,GL_COST_MGMT_UNPOSTED', '[^,]+', 1, level) field_name from dual connect by level <= 7) loop
        if json_null(a, f.field_name) then l_bad_total(f.field_name) := true;
        else
          if not l_totals.exists(f.field_name) then l_totals(f.field_name) := 0; end if;
          l_totals(f.field_name) := l_totals(f.field_name) + a.get_number(f.field_name);
        end if;
      end loop;
      l_key := l_accounts.next(l_key);
    end loop;
    meta := json_object_t(); meta.put('CAPTURED_LEDGER_ID', p_ledger); meta.put('CAPTURED_PERIOD_NAME', p_period);
    meta.put('CAPTURED_ORG_IDS', p_scope); meta.put('SELECTED_ORG_COUNT', l_selected_orgs);
    meta.put('INCOMPLETE_ORG_COUNT', l_incomplete_orgs); meta.put('READY_ORG_COUNT', l_ready_orgs);
    meta.put('PARTIAL_ACCOUNT_COUNT', l_partial_accounts);
    for f in (select regexp_substr('TOTAL_VALUE,SUBLEDGER_END,ACTIVITY_DIFF,SUBLEDGER_VS_GL_DIFF,SLA_NOT_IN_GL,GL_END_BALANCE,GL_COST_MGMT_UNPOSTED', '[^,]+', 1, level) field_name from dual connect by level <= 7) loop
      if l_bad_total.exists(f.field_name) then meta.put_null(f.field_name);
      elsif l_totals.exists(f.field_name) then meta.put(f.field_name, l_totals(f.field_name));
      else meta.put(f.field_name, 0); end if;
    end loop;
    if l_global_current_bad then
      null_fields(meta, 'TOTAL_VALUE,SUBLEDGER_END,ACTIVITY_DIFF,SUBLEDGER_VS_GL_DIFF');
    elsif l_global_prior_bad then meta.put_null('ACTIVITY_DIFF'); end if;
    p_meta := meta.to_clob;
  end;

  procedure publish_check(p_ready varchar2, p_owners varchar2, p_ledger number, p_period varchar2, p_refreshed varchar2) is
    l_seq number;
  begin
    if apex_collection.collection_exists(c_check) then
      apex_collection.update_member(p_collection_name => c_check, p_seq => 1,
        p_c001 => p_ready, p_c002 => p_owners, p_c003 => p_period, p_c004 => utc_stamp, p_c005 => p_refreshed, p_n001 => p_ledger);
    else
      apex_collection.create_collection(c_check);
      l_seq := apex_collection.add_member(p_collection_name => c_check,
        p_c001 => p_ready, p_c002 => p_owners, p_c003 => p_period, p_c004 => utc_stamp, p_c005 => p_refreshed, p_n001 => p_ledger);
    end if;
  end;

  procedure publish_state(p_raw varchar2, p_ready varchar2, p_owners varchar2, p_result varchar2,
                           p_ledger number, p_period varchar2, p_scope varchar2, p_at varchar2, p_meta clob) is
    l_seq number;
  begin
    if apex_collection.collection_exists(c_state) then
      apex_collection.update_member(p_collection_name => c_state, p_seq => 1,
        p_c001 => p_raw, p_c002 => p_ready, p_c003 => p_owners, p_c004 => p_result,
        p_c005 => p_period, p_c006 => substr(p_scope, 1, 4000), p_c007 => p_at,
        p_n001 => p_ledger, p_clob001 => p_meta);
    else
      apex_collection.create_collection(c_state);
      l_seq := apex_collection.add_member(p_collection_name => c_state,
        p_c001 => p_raw, p_c002 => p_ready, p_c003 => p_owners, p_c004 => p_result,
        p_c005 => p_period, p_c006 => substr(p_scope, 1, 4000), p_c007 => p_at,
        p_n001 => p_ledger, p_clob001 => p_meta);
    end if;
  end;

  procedure refresh_lookup is
  begin
    app_guard;
    dbms_mview.refresh(list => 'XXINV128_ORG_PERIOD_MV,XXINV128_VAL_ACCT_MV', method => 'CC', atomic_refresh => true);
  end;

  procedure check_orgs(p_ledger_id number, p_period_name varchar2) is
    l_ready varchar2(255) := stage_name('CR'); l_owners varchar2(255) := stage_name('CO');
    l_old_ready varchar2(255); l_old_owners varchar2(255); l_prior varchar2(30); l_currency varchar2(30);
    l_refreshed varchar2(50); l_saved boolean := false;
  begin
    app_guard;
    resolve_period(p_ledger_id, p_period_name, l_prior, l_currency);
    -- Check uses cached organization/period metadata plus live CPCS existence;
    -- an explicit refresh button and the daily scheduler own MV refresh.
    select to_char(max(lookup_captured_at_utc), 'YYYY-MM-DD"T"HH24:MI:SS.FF3"Z"') into l_refreshed from xxinv128_org_period_mv;
    savepoint inv128_check_start; l_saved := true;
    l_old_ready := checked_collection('READINESS'); l_old_owners := checked_collection('OWNERS');
    load_readiness(p_ledger_id, p_period_name, l_prior, l_ready, false);
    load_owners(p_ledger_id, l_owners, false);
    publish_check(l_ready, l_owners, p_ledger_id, p_period_name, l_refreshed);
    safe_drop(l_old_ready); safe_drop(l_old_owners);
  exception when others then
    if l_saved then rollback to inv128_check_start; end if;
    safe_drop(l_ready); safe_drop(l_owners); raise;
  end;

  procedure run_reconciliation(p_ledger_id number, p_period_name varchar2, p_org_ids varchar2 default null) is
    l_ready varchar2(255) := stage_name('R'); l_owners varchar2(255) := stage_name('O');
    l_raw varchar2(255) := stage_name('D'); l_result varchar2(255) := stage_name('V');
    l_old_ready varchar2(255); l_old_owners varchar2(255); l_old_raw varchar2(255); l_old_result varchar2(255);
    l_prior varchar2(30); l_currency varchar2(30); l_scope varchar2(32767); l_checked_ledger number;
    l_meta clob;
    l_after_ready varchar2(255) := stage_name('AR'); l_after_owners varchar2(255) := stage_name('AO');
    l_checked_ready varchar2(255); l_checked_owners varchar2(255);
  begin
    savepoint inv128_run_start; app_guard;
    resolve_period(p_ledger_id, p_period_name, l_prior, l_currency);
    begin select n001 into l_checked_ledger from apex_collections where collection_name = c_check and seq_id = 1;
    exception when no_data_found then raise_application_error(-20001, 'Check organizations before running reconciliation.'); end;
    if l_checked_ledger <> p_ledger_id or check_value(3) <> p_period_name then
      raise_application_error(-20001, 'Ledger or period changed. Check organizations again.');
    end if;
    l_scope := normalize_scope(p_org_ids, checked_collection('READINESS'));
    l_checked_ready := checked_collection('READINESS'); l_checked_owners := checked_collection('OWNERS');
    load_readiness(p_ledger_id, p_period_name, l_prior, l_ready);
    load_owners(p_ledger_id, l_owners);
    if not same_signature(l_ready, checked_collection('READINESS')) or not same_signature(l_owners, checked_collection('OWNERS')) then
      raise_application_error(-20001, 'Organization readiness or account ownership changed. Refresh Lookup and Check Inventory Orgs again.');
    end if;
    capture_raw(p_ledger_id, p_period_name, l_raw);
    -- A multi-minute capture must not publish against ownership/readiness that
    -- changed while the financial query ran.
    load_readiness(p_ledger_id, p_period_name, l_prior, l_after_ready);
    load_owners(p_ledger_id, l_after_owners);
    if not same_signature(l_ready, l_after_ready) or not same_signature(l_owners, l_after_owners)
       or l_checked_ready <> checked_collection('READINESS') or l_checked_owners <> checked_collection('OWNERS') then
      raise_application_error(-20001, 'Organization readiness or account ownership changed during capture. Refresh Lookup and Check Inventory Orgs again.');
    end if;
    safe_drop(l_after_ready); safe_drop(l_after_owners);
    augment_observed_owners(l_raw, l_ready, l_owners, p_ledger_id);
    derive_scope(p_ledger_id, p_period_name, l_scope, l_raw, l_ready, l_owners, l_result, l_meta);
    l_old_ready := current_collection('READINESS'); l_old_owners := current_collection('OWNERS');
    l_old_raw := current_collection('RAW'); l_old_result := current_collection('RESULTS');
    publish_state(l_raw, l_ready, l_owners, l_result, p_ledger_id, p_period_name, l_scope, utc_stamp, l_meta);
    safe_drop(l_old_ready); safe_drop(l_old_owners); safe_drop(l_old_raw); safe_drop(l_old_result);
  exception when others then
    rollback to inv128_run_start;
    safe_drop(l_ready); safe_drop(l_owners); safe_drop(l_raw); safe_drop(l_result);
    safe_drop(l_after_ready); safe_drop(l_after_owners); raise;
  end;

  procedure apply_scope(p_org_ids varchar2 default null) is
    l_result varchar2(255) := stage_name('V'); l_old_result varchar2(255);
    l_raw varchar2(255); l_ready varchar2(255); l_owners varchar2(255); l_period varchar2(30);
    l_ledger number; l_scope varchar2(32767); l_at varchar2(50); l_meta clob;
  begin
    savepoint inv128_scope_start; app_guard;
    begin
      select c001, c002, c003, c004, c005, n001, c007
        into l_raw, l_ready, l_owners, l_old_result, l_period, l_ledger, l_at
        from apex_collections where collection_name = c_state and seq_id = 1;
    exception when no_data_found then raise_application_error(-20001, 'Run reconciliation before changing the captured organization scope.'); end;
    l_scope := normalize_scope(p_org_ids, l_ready);
    derive_scope(l_ledger, l_period, l_scope, l_raw, l_ready, l_owners, l_result, l_meta);
    publish_state(l_raw, l_ready, l_owners, l_result, l_ledger, l_period, l_scope, l_at, l_meta);
    safe_drop(l_old_result);
  exception when others then
    rollback to inv128_scope_start; safe_drop(l_result); raise;
  end;

  function get_meta return clob is
    j json_object_t := json_object_t(); l_clob clob; l_ledger number; l_at varchar2(50); l_n number;
  begin
    select to_char(max(lookup_captured_at_utc), 'YYYY-MM-DD"T"HH24:MI:SS.FF3"Z"') into l_at from xxinv128_org_period_mv;
    j.put('LOOKUP_REFRESHED_AT_UTC', l_at);
    begin
      select clob001, c007 into l_clob, l_at from apex_collections where collection_name = c_state and seq_id = 1;
      j := json_object_t.parse(l_clob); j.put('CAPTURED_AT', l_at);
      select to_char(max(lookup_captured_at_utc), 'YYYY-MM-DD"T"HH24:MI:SS.FF3"Z"') into l_at from xxinv128_org_period_mv;
      j.put('LOOKUP_REFRESHED_AT_UTC', l_at);
    exception when no_data_found then null; end;
    begin
      select n001 into l_ledger from apex_collections where collection_name = c_check and seq_id = 1;
      j.put('CHECKED_LEDGER_ID', l_ledger); j.put('CHECKED_PERIOD_NAME', check_value(3));
      j.put('CHECKED_AT', check_value(4));
      j.put('CHECKED_LOOKUP_AT_UTC', check_value(5));
      select count(*) into l_n from apex_collections where collection_name = checked_collection('READINESS');
      j.put('CHECKED_ORG_COUNT', l_n);
    exception when no_data_found then null; end;
    return j.to_clob;
  end;
end xxinv128_recon_v1_pkg;
/
