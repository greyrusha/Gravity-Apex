set define off

create or replace package body xx_tms_admin_pkg as
  c_workspace  constant varchar2(30)   := 'GL_ACCOUNTS';
  c_job_name   constant varchar2(30)   := 'XX_TMS_ADMIN_WORKER';
  c_des3_which constant binary_integer := 1;

  procedure set_workspace is
    l_security_group_id number;
  begin
    l_security_group_id := apex_util.find_security_group_id(p_workspace => c_workspace);
    if l_security_group_id is null then
      raise_application_error(-20700, 'APEX workspace GL_ACCOUNTS was not found.');
    end if;
    apex_util.set_security_group_id(p_security_group_id => l_security_group_id);
  end set_workspace;

  function normalized_email(p_email varchar2) return varchar2 is
  begin
    return lower(trim(p_email));
  end normalized_email;

  function actor return varchar2 is
  begin
    return nvl(
      trim(coalesce(sys_context('APEX$SESSION', 'APP_USER'), apex_application.g_user)),
      user
    );
  end actor;

  procedure assert_workspace_admin(p_actor varchar2 default null) is
    l_actor varchar2(255) := nvl(trim(p_actor), actor);
  begin
    if not xx_tms_security_pkg.is_workspace_admin(l_actor) then
      raise_application_error(-20701,
        'TMS Console Administrator authorization is required.');
    end if;
  end assert_workspace_admin;

  procedure validate_target_email(p_email varchar2) is
  begin
    if not regexp_like(p_email, '^[[:alnum:]._%+-]+@terex[.]com$', 'i') then
      raise_application_error(-20702,
        'Managed local usernames must end exactly in @terex.com.');
    end if;
  end validate_target_email;

  procedure validate_password(p_email varchar2, p_password varchar2) is
    l_error varchar2(4000);
  begin
    if p_password is null then
      raise_application_error(-20703, 'A temporary password is required.');
    end if;
    if utl_raw.length(utl_i18n.string_to_raw(p_password, 'AL32UTF8')) > 1900 then
      raise_application_error(-20704, 'Temporary password is too long.');
    end if;
    l_error := apex_util.strong_password_validation(
      p_username         => p_email,
      p_password         => p_password,
      p_workspace_name   => c_workspace,
      p_use_strong_rules => false
    );
    if l_error is not null then
      raise_application_error(-20704,
        regexp_replace(l_error, '<[^>]+>', ' '));
    end if;
  end validate_password;

  procedure audit_action(
    p_actor_email      varchar2,
    p_target_email     varchar2,
    p_application_code varchar2,
    p_action_name      varchar2,
    p_action_status    varchar2,
    p_action_detail    varchar2,
    p_request_id       varchar2 default null
  ) is
    pragma autonomous_transaction;
    l_actor_email  varchar2(255) := substr(nvl(trim(p_actor_email), 'UNKNOWN'), 1, 255);
    l_target_email varchar2(255) := substr(trim(p_target_email), 1, 255);
  begin
    insert into xx_tms_admin_audit (
      actor_email, target_email, application_code, action_name,
      action_status, action_detail, request_id
    ) values (
      l_actor_email, l_target_email,
      upper(trim(p_application_code)), upper(trim(p_action_name)),
      upper(trim(p_action_status)), substr(p_action_detail, 1, 4000),
      p_request_id
    );
    commit;
  exception
    when others then
      rollback;
  end audit_action;

  function random_bytes(p_length pls_integer) return raw is
    l_result raw(2000);
  begin
    while nvl(utl_raw.length(l_result), 0) < p_length loop
      l_result := utl_raw.concat(l_result, sys_guid());
    end loop;
    return utl_raw.substr(l_result, 1, p_length);
  end random_bytes;

  function encrypt_password(p_plain raw, p_key raw, p_iv raw) return raw is
    l_pad      pls_integer := 8 - mod(utl_raw.length(p_plain), 8);
    l_pad_byte raw(1)      := hextoraw(lpad(to_char(l_pad, 'FMX'), 2, '0'));
    l_padded   raw(2000)   := p_plain;
  begin
    for i in 1 .. l_pad loop
      l_padded := utl_raw.concat(l_padded, l_pad_byte);
    end loop;
    return dbms_crypto.encrypt(
      src => l_padded,
      typ => dbms_crypto.encrypt_3des + dbms_crypto.chain_cbc + dbms_crypto.pad_none,
      key => p_key,
      iv  => p_iv
    );
  end encrypt_password;

  function decrypt_password(p_cipher raw, p_key raw, p_iv raw) return raw is
    l_padded   raw(2000);
    l_length   pls_integer;
    l_pad      pls_integer;
    l_pad_byte raw(1);
  begin
    l_padded := dbms_crypto.decrypt(
      src => p_cipher,
      typ => dbms_crypto.encrypt_3des + dbms_crypto.chain_cbc + dbms_crypto.pad_none,
      key => p_key,
      iv  => p_iv
    );
    l_length := utl_raw.length(l_padded);
    l_pad := to_number(rawtohex(utl_raw.substr(l_padded, l_length, 1)), 'XX');
    if l_pad < 1 or l_pad > 8 or l_pad > l_length then
      raise_application_error(-20724,
        'Temporary-password encryption padding is invalid.');
    end if;
    l_pad_byte := hextoraw(lpad(to_char(l_pad, 'FMX'), 2, '0'));
    for i in 0 .. l_pad - 1 loop
      if utl_raw.substr(l_padded, l_length - i, 1) <> l_pad_byte then
        raise_application_error(-20724,
          'Temporary-password encryption padding is invalid.');
      end if;
    end loop;
    return utl_raw.substr(l_padded, 1, l_length - l_pad);
  end decrypt_password;

  function normalize_application_codes(p_codes varchar2) return varchar2 is
    l_result varchar2(4000);
    l_code   varchar2(30);
    l_count  number;
    l_seen   varchar2(4000) := ':';
    l_parts  apex_t_varchar2 := apex_string.split(nvl(p_codes, ''), ':');
  begin
    for i in 1 .. l_parts.count loop
      l_code := upper(trim(l_parts(i)));
      if l_code is not null then
        if not regexp_like(l_code, '^[A-Z][A-Z0-9_]{0,29}$') then
          raise_application_error(-20705,
            'Invalid application code: ' || substr(l_code, 1, 100));
        end if;
        select count(*)
          into l_count
          from xx_tms_application
         where application_code = l_code
           and access_mode = 'CENTRAL'
           and enabled_yn = 'Y';
        if l_count <> 1 then
          raise_application_error(-20706,
            'Application ' || l_code || ' is not enabled for central maintenance.');
        end if;
        if instr(l_seen, ':' || l_code || ':') = 0 then
          l_seen := l_seen || l_code || ':';
          l_result := case when l_result is null then l_code
                           else l_result || ':' || l_code end;
        end if;
      end if;
    end loop;
    return l_result;
  end normalize_application_codes;

  procedure fetch_end_user(
    p_email                    in  varchar2,
    p_user_id                  out number,
    p_first_name               out varchar2,
    p_last_name                out varchar2,
    p_email_address            out varchar2,
    p_account_locked           out varchar2,
    p_is_admin                 out varchar2,
    p_is_application_developer out varchar2
  ) is
    l_email varchar2(255) := normalized_email(p_email);
  begin
    set_workspace;
    select apex_util.get_user_id(user_name), first_name, last_name, email,
           account_locked, is_admin, is_application_developer
      into p_user_id, p_first_name, p_last_name, p_email_address,
           p_account_locked, p_is_admin, p_is_application_developer
      from apex_workspace_apex_users
     where lower(user_name) = l_email;

    if upper(nvl(p_is_admin, 'NO')) = 'YES'
       or upper(nvl(p_is_application_developer, 'NO')) = 'YES' then
      raise_application_error(-20708,
        'Workspace administrators and application developers are read-only here.');
    end if;
  exception
    when no_data_found then
      raise_application_error(-20707, 'User account was not found.');
  end fetch_end_user;

  -- Resolves either an EBS username in XX_TMS_USERS or a @terex.com local account
  -- into the canonical lowercase key stored in XX_TMS_USER_ACCESS.
  procedure resolve_access_target(
    p_identifier     in  varchar2,
    p_access_key     out varchar2,
    p_alt_key        out varchar2,
    p_display_target out varchar2
  ) is
    l_ident         varchar2(255) := trim(p_identifier);
    l_ebs_user      xx_tms_users.ebs_user_name%type;
    l_local_email   xx_tms_users.local_user_email%type;
    l_console_admin xx_tms_users.is_console_admin_yn%type;
    l_user_id       number;
    l_first_name    varchar2(255);
    l_last_name     varchar2(255);
    l_email_addr    varchar2(255);
    l_locked        varchar2(30);
    l_is_admin      varchar2(30);
    l_is_dev        varchar2(30);
  begin
    if l_ident is null then
      raise_application_error(-20707, 'User account identifier is required.');
    end if;

    begin
      select ebs_user_name, local_user_email, is_console_admin_yn
        into l_ebs_user, l_local_email, l_console_admin
        from xx_tms_users
       where ebs_user_name = upper(l_ident)
          or local_user_email = lower(l_ident)
       order by case when ebs_user_name = upper(l_ident) then 0 else 1 end
       fetch first 1 row only;

      if l_console_admin = 'Y' then
        raise_application_error(-20708,
          'Console administrators have automatic application access and are read-only here.');
      end if;

      p_access_key     := lower(nvl(l_local_email, l_ebs_user));
      p_alt_key        := case when l_local_email is not null then lower(l_ebs_user) else null end;
      p_display_target := l_ebs_user;
    exception
      when no_data_found then
        validate_target_email(lower(l_ident));
        fetch_end_user(
          lower(l_ident),
          l_user_id, l_first_name, l_last_name, l_email_addr,
          l_locked, l_is_admin, l_is_dev
        );
        p_access_key     := lower(l_ident);
        p_alt_key        := null;
        p_display_target := p_access_key;
    end;
  end resolve_access_target;

  function group_id_list(p_user_name varchar2) return varchar2 is
    l_groups   varchar2(32767) := apex_util.get_groups_user_belongs_to(p_user_name);
    l_name     varchar2(255);
    l_ids      varchar2(4000);
    l_position pls_integer := 1;
    l_group_id number;
  begin
    loop
      l_name := trim(regexp_substr(l_groups, '[^,]+', 1, l_position));
      exit when l_name is null;
      begin
        l_group_id := apex_util.get_group_id(l_name);
        l_ids := case when l_ids is null then to_char(l_group_id)
                      else l_ids || ':' || to_char(l_group_id) end;
      exception
        when others then null;
      end;
      l_position := l_position + 1;
    end loop;
    return l_ids;
  end group_id_list;

  procedure apply_central_assignments(
    p_email             varchar2,
    p_application_codes varchar2,
    p_actor             varchar2,
    p_display_target    out varchar2
  ) is
    l_codes      varchar2(4000) := normalize_application_codes(p_application_codes);
    l_access_key varchar2(255);
    l_alt_key    varchar2(255);
    l_actor      varchar2(255)  := trim(p_actor);
  begin
    resolve_access_target(p_email, l_access_key, l_alt_key, p_display_target);

    if l_alt_key is not null then
      delete from xx_tms_user_access u
       where u.user_name = l_alt_key
         and exists (
           select 1
             from xx_tms_application a
            where a.application_code = u.application_code
              and a.access_mode = 'CENTRAL'
         );
    end if;

    delete from xx_tms_user_access u
     where u.user_name = l_access_key
       and exists (
         select 1
           from xx_tms_application a
          where a.application_code = u.application_code
            and a.access_mode = 'CENTRAL'
       )
       and (l_codes is null
            or instr(':' || l_codes || ':', ':' || u.application_code || ':') = 0);

    if l_codes is not null then
      for r in (
        select trim(column_value) as application_code
          from table(apex_string.split(l_codes, ':'))
      ) loop
        merge into xx_tms_user_access d
        using (
          select l_access_key       as user_name,
                 r.application_code as application_code
            from dual
        ) s
           on (d.user_name = s.user_name
               and d.application_code = s.application_code)
         when not matched then insert (
           user_name, application_code, granted_by
         ) values (
           s.user_name, s.application_code, l_actor
         );
      end loop;
    end if;
  end apply_central_assignments;

  procedure enqueue_request(
    p_request_type      varchar2,
    p_target_email      varchar2,
    p_first_name        varchar2,
    p_last_name         varchar2,
    p_application_codes varchar2,
    p_password          varchar2,
    p_actor             varchar2,
    p_request_id        out varchar2
  ) is
    l_key          raw(24) := random_bytes(24);
    l_iv           raw(8)  := random_bytes(8);
    l_plain        raw(2000);
    l_cipher       raw(2000);
    l_running      number;
    l_target_email varchar2(255) := normalized_email(p_target_email);
    l_actor        varchar2(255) := substr(trim(p_actor), 1, 255);
  begin
    p_request_id := rawtohex(sys_guid());
    if p_password is not null then
      l_plain := utl_i18n.string_to_raw(p_password, 'AL32UTF8');
      l_cipher := encrypt_password(l_plain, l_key, l_iv);
    end if;

    delete from xx_tms_admin_request
     where requested_on < systimestamp - interval '1' day;

    insert into xx_tms_admin_request (
      request_id, request_type, target_email, first_name, last_name,
      application_codes, password_cipher, password_iv, requested_by
    ) values (
      p_request_id, p_request_type, l_target_email,
      trim(p_first_name), trim(p_last_name), p_application_codes,
      l_cipher, case when l_cipher is not null then l_iv end,
      l_actor
    );

    if l_cipher is not null then
      insert into xx_tms_admin_key (request_id, key_value)
      values (p_request_id, l_key);
    end if;
    commit;

    begin
      dbms_scheduler.run_job(
        job_name            => c_job_name,
        use_current_session => false
      );
    exception
      when others then
        select count(*)
          into l_running
          from user_scheduler_running_jobs
         where job_name = c_job_name;
        if l_running = 0 then raise; end if;
    end;
  exception
    when others then
      delete from xx_tms_admin_request where request_id = p_request_id;
      commit;
      raise;
  end enqueue_request;

  procedure wait_for_request(
    p_request_id varchar2,
    p_message    out varchar2
  ) is
    l_status varchar2(12);
  begin
    for i in 1 .. 550 loop
      begin
        select request_status, result_message
          into l_status, p_message
          from xx_tms_admin_request
         where request_id = p_request_id;
      exception
        when no_data_found then
          raise_application_error(-20722,
            'Background account request could not be found.');
      end;

      if l_status in ('SUCCESS', 'ERROR') then
        delete from xx_tms_admin_request where request_id = p_request_id;
        commit;
        if l_status = 'ERROR' then
          raise_application_error(-20720,
            substr(nvl(p_message, 'Background account request failed.'), 1, 1800));
        end if;
        return;
      end if;
      dbms_session.sleep(0.1);
    end loop;
    raise_application_error(-20721,
      'The background account request is still running. Refresh before retrying.');
  end wait_for_request;

  procedure create_user(
    p_email             in  varchar2,
    p_first_name        in  varchar2,
    p_last_name         in  varchar2,
    p_temp_password     in  varchar2,
    p_application_codes in  varchar2,
    p_message           out varchar2
  ) is
    l_actor      varchar2(255) := actor;
    l_email      varchar2(255) := normalized_email(p_email);
    l_codes      varchar2(4000);
    l_request_id varchar2(32);
  begin
    assert_workspace_admin(l_actor);
    validate_target_email(l_email);
    if trim(p_first_name) is null or trim(p_last_name) is null then
      raise_application_error(-20709, 'First name and last name are required.');
    end if;
    set_workspace;
    if apex_util.get_user_id(l_email) is not null then
      raise_application_error(-20710,
        'User already exists. Maintain application assignments instead.');
    end if;
    validate_password(l_email, p_temp_password);
    l_codes := normalize_application_codes(p_application_codes);
    if l_codes is not null then
      raise_application_error(-20711,
        'Create the workspace account first, then assign application access separately.');
    end if;

    enqueue_request('CREATE_USER', l_email, p_first_name, p_last_name,
      null, p_temp_password, l_actor, l_request_id);
    wait_for_request(l_request_id, p_message);
  end create_user;

  procedure reset_password(
    p_email         in  varchar2,
    p_temp_password in  varchar2,
    p_message       out varchar2
  ) is
    l_actor        varchar2(255) := actor;
    l_email        varchar2(255) := normalized_email(p_email);
    l_request_id   varchar2(32);
    l_user_id      number;
    l_first_name   varchar2(255);
    l_last_name    varchar2(255);
    l_email_addr   varchar2(255);
    l_locked       varchar2(30);
    l_is_admin     varchar2(30);
    l_is_developer varchar2(30);
  begin
    assert_workspace_admin(l_actor);
    validate_target_email(l_email);
    fetch_end_user(l_email, l_user_id, l_first_name, l_last_name,
      l_email_addr, l_locked, l_is_admin, l_is_developer);
    validate_password(l_email, p_temp_password);
    enqueue_request('RESET_PASSWORD', l_email, null, null, null,
      p_temp_password, l_actor, l_request_id);
    wait_for_request(l_request_id, p_message);
  end reset_password;

  procedure set_account_locked(
    p_email      in  varchar2,
    p_locked_yn  in  varchar2,
    p_message    out varchar2
  ) is
    l_actor        varchar2(255) := actor;
    l_email        varchar2(255) := normalized_email(p_email);
    l_locked_yn    varchar2(1)   := upper(trim(p_locked_yn));
    l_request_id   varchar2(32);
    l_user_id      number;
    l_first_name   varchar2(255);
    l_last_name    varchar2(255);
    l_email_addr   varchar2(255);
    l_locked       varchar2(30);
    l_is_admin     varchar2(30);
    l_is_developer varchar2(30);
  begin
    assert_workspace_admin(l_actor);
    validate_target_email(l_email);
    if l_locked_yn is null or l_locked_yn not in ('Y', 'N') then
      raise_application_error(-20712, 'Locked flag must be Y or N.');
    end if;
    if l_locked_yn = 'Y' and l_email = normalized_email(l_actor) then
      raise_application_error(-20713, 'You cannot lock your own account.');
    end if;
    fetch_end_user(l_email, l_user_id, l_first_name, l_last_name,
      l_email_addr, l_locked, l_is_admin, l_is_developer);
    enqueue_request(
      case when l_locked_yn = 'Y' then 'LOCK_ACCOUNT' else 'UNLOCK_ACCOUNT' end,
      l_email, null, null, null, null, l_actor, l_request_id
    );
    wait_for_request(l_request_id, p_message);
  end set_account_locked;

  procedure set_user_applications(
    p_email             in  varchar2,
    p_application_codes in  varchar2,
    p_message           out varchar2
  ) is
    l_actor          varchar2(255) := actor;
    l_codes          varchar2(4000);
    l_display_target varchar2(255) := trim(p_email);
  begin
    assert_workspace_admin(l_actor);
    l_codes := normalize_application_codes(p_application_codes);
    apply_central_assignments(p_email, l_codes, l_actor, l_display_target);
    commit;
    p_message := case when l_codes is null
      then 'All centrally managed application access removed.'
      else 'Centrally managed application access set to: ' || l_codes || '.' end;
    audit_action(l_actor, l_display_target, null, 'SET_APPLICATIONS',
      'SUCCESS', p_message);
  exception
    when others then
      rollback;
      audit_action(l_actor, l_display_target, null, 'SET_APPLICATIONS',
        'ERROR', sqlerrm);
      raise;
  end set_user_applications;

  procedure set_user_application_access(
    p_email            in  varchar2,
    p_application_code in  varchar2,
    p_enabled_yn       in  varchar2,
    p_message          out varchar2
  ) is
    l_actor          varchar2(255) := actor;
    l_code           varchar2(30)  := upper(trim(p_application_code));
    l_enabled_yn     varchar2(1)   := upper(trim(p_enabled_yn));
    l_access_key     varchar2(255);
    l_alt_key        varchar2(255);
    l_display_target varchar2(255) := trim(p_email);
    l_count          number;
  begin
    assert_workspace_admin(l_actor);
    resolve_access_target(p_email, l_access_key, l_alt_key, l_display_target);
    if l_enabled_yn not in ('Y', 'N') then
      raise_application_error(-20712, 'Access Enabled must be Y or N.');
    end if;
    select count(*)
      into l_count
      from xx_tms_application
     where application_code = l_code
       and access_mode = 'CENTRAL'
       and enabled_yn = 'Y';
    if l_count <> 1 then
      raise_application_error(-20706,
        'Application ' || substr(l_code, 1, 100) ||
        ' is not enabled for central maintenance.');
    end if;

    if l_enabled_yn = 'Y' then
      if l_alt_key is not null then
        delete from xx_tms_user_access
         where user_name = l_alt_key
           and application_code = l_code;
      end if;

      merge into xx_tms_user_access d
      using (select l_access_key as user_name, l_code as application_code from dual) s
         on (d.user_name = s.user_name
             and d.application_code = s.application_code)
       when not matched then insert (user_name, application_code, granted_by)
         values (s.user_name, s.application_code, l_actor);
      p_message := 'Application access enabled.';
    else
      delete from xx_tms_user_access
       where user_name in (l_access_key, nvl(l_alt_key, l_access_key))
         and application_code = l_code;
      p_message := 'Application access disabled.';
    end if;
    commit;
    audit_action(l_actor, l_display_target, l_code, 'SET_APPLICATION_ACCESS',
      'SUCCESS', p_message);
  exception
    when others then
      rollback;
      audit_action(l_actor, l_display_target, l_code, 'SET_APPLICATION_ACCESS',
        'ERROR', sqlerrm);
      raise;
  end set_user_application_access;

  procedure save_application(
    p_application_code    in  varchar2,
    p_apex_application_id in  number,
    p_application_name    in  varchar2,
    p_access_mode         in  varchar2,
    p_enabled_yn          in  varchar2,
    p_message             out varchar2
  ) is
    l_actor             varchar2(255) := actor;
    l_code              varchar2(30)  := upper(trim(p_application_code));
    l_mode              varchar2(20)  := upper(trim(p_access_mode));
    l_enabled           varchar2(1)   := upper(trim(p_enabled_yn));
    l_live_name         varchar2(255);
    l_name              varchar2(255);
    l_count             number;
    l_existing_id       number;
    l_scheme_count      number;
    l_unprotected_pages number;
  begin
    assert_workspace_admin(l_actor);
    if not regexp_like(l_code, '^[A-Z][A-Z0-9_]{0,29}$') then
      raise_application_error(-20730,
        'Application Code must begin with a letter and contain only A-Z, 0-9, or underscore.');
    end if;
    if p_apex_application_id is null or p_apex_application_id = 400 then
      raise_application_error(-20731,
        'Select a governed application other than the administration console.');
    end if;
    if l_mode not in ('CENTRAL', 'LEGACY_READ_ONLY') then
      raise_application_error(-20732, 'Access Mode is invalid.');
    end if;
    if l_enabled not in ('Y', 'N') then
      raise_application_error(-20733, 'Enabled must be Y or N.');
    end if;

    select application_name
      into l_live_name
      from apex_applications
     where application_id = p_apex_application_id
       and workspace = c_workspace
       and owner = c_workspace;
    l_name := substr(nvl(trim(p_application_name), l_live_name), 1, 255);

    begin
      select apex_application_id
        into l_existing_id
        from xx_tms_application
       where application_code = l_code;
      if l_existing_id <> p_apex_application_id then
        raise_application_error(-20734,
          'An existing Application Code cannot be reassigned to another APEX application.');
      end if;
    exception
      when no_data_found then null;
    end;

    select count(*)
      into l_count
      from xx_tms_application
     where apex_application_id = p_apex_application_id
       and application_code <> l_code;
    if l_count > 0 then
      raise_application_error(-20735,
        'The selected APEX application is already registered under another code.');
    end if;

    if l_mode = 'CENTRAL' and l_enabled = 'Y' then
      select count(*)
        into l_scheme_count
        from apex_application_authorization
       where application_id = p_apex_application_id
         and authorization_scheme_name = 'TMS Application Access'
         and instr(lower(attributes), 'xx_tms_security_pkg.can_access') > 0;

      select count(*)
        into l_unprotected_pages
        from apex_application_pages
       where application_id = p_apex_application_id
         and page_id not in (0, 9998, 9999)
         and nvl(authorization_scheme, '-') <> 'TMS Application Access';

      if l_scheme_count <> 1 or l_unprotected_pages <> 0 then
        raise_application_error(-20736,
          'Central access cannot be enabled until TMS Application Access protects every business page.');
      end if;
    end if;

    merge into xx_tms_application d
    using (
      select l_code                as application_code,
             p_apex_application_id as apex_application_id,
             l_name                as application_name,
             l_mode                as access_mode,
             l_enabled             as enabled_yn
        from dual
    ) s
       on (d.application_code = s.application_code)
     when matched then update set
       d.application_name = s.application_name,
       d.access_mode      = s.access_mode,
       d.enabled_yn       = s.enabled_yn
     when not matched then insert (
       application_code, apex_application_id, application_name,
       access_mode, enabled_yn, created_by
     ) values (
       s.application_code, s.apex_application_id, s.application_name,
       s.access_mode, s.enabled_yn, l_actor
     );
    commit;
    p_message := case when l_enabled = 'Y' then
      'Application registered and enabled.' else
      'Application registered but disabled.' end;
    audit_action(l_actor, null, l_code, 'SAVE_APPLICATION',
      'SUCCESS', p_message || ' APEX application ' || p_apex_application_id || '.');
  exception
    when no_data_found then
      rollback;
      audit_action(l_actor, null, l_code, 'SAVE_APPLICATION',
        'ERROR', 'The selected application was not found in GL_ACCOUNTS.');
      raise_application_error(-20737,
        'The selected application was not found in GL_ACCOUNTS.');
    when others then
      rollback;
      audit_action(l_actor, null, l_code, 'SAVE_APPLICATION',
        'ERROR', sqlerrm);
      raise;
  end save_application;

  procedure save_ebs_user(
    p_ebs_user_name       in  varchar2,
    p_local_user_email    in  varchar2 default null,
    p_full_name           in  varchar2 default null,
    p_enabled_yn          in  varchar2 default 'Y',
    p_is_console_admin_yn in  varchar2 default 'N',
    p_notes               in  varchar2 default null,
    p_message             out varchar2
  ) is
    l_actor             varchar2(255) := actor;
    l_ebs_user          varchar2(100) := upper(trim(p_ebs_user_name));
    l_local_email       varchar2(255) := lower(trim(p_local_user_email));
    l_enabled           varchar2(1)   := upper(trim(nvl(p_enabled_yn, 'Y')));
    l_admin             varchar2(1)   := upper(trim(nvl(p_is_console_admin_yn, 'N')));
    l_ebs_email         varchar2(255);
    l_ebs_end_dated     varchar2(1)   := 'N';
    l_adg_warning       varchar2(255);
    l_dup_email         pls_integer;
    l_existing_admin_yn varchar2(1);
    l_other_admins      pls_integer;
  begin
    assert_workspace_admin(l_actor);

    if l_ebs_user is null or length(l_ebs_user) > 100
       or not regexp_like(l_ebs_user, '^[A-Z0-9][A-Z0-9._@-]*$', 'c') then
      raise_application_error(-20739,
        'EBS Username is required (uppercase letters, digits, ., _, @, or -).');
    end if;

    if l_local_email is not null
       and not regexp_like(l_local_email, '^[[:alnum:]._%+-]+@terex[.]com$', 'i') then
      raise_application_error(-20702,
        'Optional Local Bridge Email must end in @terex.com.');
    end if;

    if l_enabled not in ('Y', 'N') or l_admin not in ('Y', 'N') then
      raise_application_error(-20712, 'Enabled and Console Administrator flags must be Y or N.');
    end if;

    begin
      execute immediate
        'select lower(trim(email_address)),
                case when end_date is not null and end_date <= trunc(sysdate) then ''Y'' else ''N'' end
           from apps.fnd_user@ADG
          where upper(user_name) = :1
          fetch first 1 row only'
        into l_ebs_email, l_ebs_end_dated
        using l_ebs_user;
    exception
      when no_data_found then
        raise_application_error(-20740,
          'EBS user ' || l_ebs_user || ' was not found in TMS (FND_USER).');
      when others then
        if sqlcode = -20740 then
          raise;
        end if;
        l_adg_warning := ' (EBS FND_USER check unavailable; saved locally.)';
    end;

    if l_local_email is null
       and l_ebs_email is not null
       and regexp_like(l_ebs_email, '^[[:alnum:]._%+-]+@terex[.]com$', 'i') then
      select count(*)
        into l_dup_email
        from xx_tms_users
       where local_user_email = l_ebs_email
         and ebs_user_name <> l_ebs_user;
      if l_dup_email = 0 then
        l_local_email := l_ebs_email;
      end if;
    end if;

    if l_local_email is not null then
      select count(*)
        into l_dup_email
        from xx_tms_users
       where local_user_email = l_local_email
         and ebs_user_name <> l_ebs_user;
      if l_dup_email > 0 then
        raise_application_error(-20743,
          'Local Bridge Email ' || l_local_email || ' is already mapped to another EBS user.');
      end if;
    end if;

    if l_ebs_user = upper(trim(l_actor)) and (l_enabled = 'N' or l_admin = 'N') then
      raise_application_error(-20741,
        'You cannot disable or remove Console Administrator rights from your own account.');
    end if;

    begin
      select is_console_admin_yn
        into l_existing_admin_yn
        from xx_tms_users
       where ebs_user_name = l_ebs_user;
    exception
      when no_data_found then
        l_existing_admin_yn := 'N';
    end;

    if l_existing_admin_yn = 'Y' and (l_enabled = 'N' or l_admin = 'N') then
      select count(*)
        into l_other_admins
        from xx_tms_users
       where enabled_yn = 'Y'
         and is_console_admin_yn = 'Y'
         and ebs_user_name <> l_ebs_user;
      if l_other_admins = 0 then
        raise_application_error(-20742,
          'At least one enabled Console Administrator must remain.');
      end if;
    end if;

    merge into xx_tms_users t
    using (
      select l_ebs_user as ebs_user_name from dual
    ) s
       on (t.ebs_user_name = s.ebs_user_name)
     when matched then update set
       t.local_user_email    = coalesce(l_local_email, t.local_user_email),
       t.full_name           = coalesce(trim(p_full_name), t.full_name),
       t.email_address       = coalesce(l_ebs_email, l_local_email, t.email_address),
       t.enabled_yn          = l_enabled,
       t.is_console_admin_yn = l_admin,
       t.notes               = coalesce(trim(p_notes), t.notes),
       t.updated_on          = systimestamp,
       t.updated_by          = l_actor
     when not matched then insert (
       ebs_user_name, local_user_email, full_name, email_address,
       enabled_yn, is_console_admin_yn, notes,
       created_on, created_by, updated_on, updated_by
     ) values (
       l_ebs_user, l_local_email, substr(trim(p_full_name), 1, 255),
       coalesce(l_ebs_email, l_local_email),
       l_enabled, l_admin, substr(trim(p_notes), 1, 1000),
       systimestamp, l_actor, systimestamp, l_actor
     );

    commit;
    p_message := 'TMS user ' || l_ebs_user || ' saved (' ||
                 case when l_enabled = 'Y' then 'Enabled' else 'Disabled' end ||
                 case when l_admin = 'Y' then ', Console Administrator' else ', End User' end ||
                 ').' ||
                 case when l_ebs_end_dated = 'Y' then ' Warning: EBS FND_USER account is end-dated.' end ||
                 l_adg_warning;
    audit_action(l_actor, l_ebs_user, null, 'SAVE_EBS_USER', 'SUCCESS', p_message);
  exception
    when others then
      rollback;
      audit_action(l_actor, nvl(l_ebs_user, p_ebs_user_name), null, 'SAVE_EBS_USER',
        'ERROR', sqlerrm);
      raise;
  end save_ebs_user;

  procedure save_application_access_grid(
    p_application_code in  varchar2,
    p_all_users        in  apex_application_global.vc_arr2,
    p_checked_users    in  apex_application_global.vc_arr2,
    p_message          out varchar2
  ) is
    l_actor      varchar2(255) := actor;
    l_code       varchar2(30)  := upper(trim(p_application_code));
    l_changed    pls_integer   := 0;
    l_current    number;
    l_desired    boolean;
    l_msg        varchar2(4000);
    l_access_key varchar2(255);
    l_alt_key    varchar2(255);
    l_disp       varchar2(255);

    function is_checked(p_user varchar2) return boolean is
      l_target varchar2(255) := lower(trim(p_user));
    begin
      if p_checked_users.count > 0 then
        for j in 1 .. p_checked_users.count loop
          if lower(trim(p_checked_users(j))) = l_target then
            return true;
          end if;
        end loop;
      end if;
      return false;
    end is_checked;
  begin
    assert_workspace_admin(l_actor);
    if l_code is null then
      raise_application_error(-20830, 'Select an application.');
    end if;

    if p_all_users.count > 0 then
      for i in 1 .. p_all_users.count loop
        resolve_access_target(p_all_users(i), l_access_key, l_alt_key, l_disp);

        select count(*)
          into l_current
          from xx_tms_user_access
         where application_code = l_code
           and user_name in (l_access_key, nvl(l_alt_key, l_access_key));

        l_desired := is_checked(p_all_users(i));
        if (l_desired and l_current = 0) or (not l_desired and l_current > 0) then
          set_user_application_access(
            p_email            => p_all_users(i),
            p_application_code => l_code,
            p_enabled_yn       => case when l_desired then 'Y' else 'N' end,
            p_message          => l_msg
          );
          l_changed := l_changed + 1;
        end if;
      end loop;
    end if;

    p_message := case when l_changed = 0
      then 'No application access changes were required.'
      else l_changed || ' application access change(s) saved.' end;
  end save_application_access_grid;

  procedure save_auth_config(
    p_ebs_login_url in  varchar2,
    p_enabled_yn    in  varchar2 default 'Y',
    p_message       out varchar2
  ) is
    l_actor     varchar2(255) := actor;
    l_login_url varchar2(500);
    l_enabled   varchar2(1)   := upper(trim(nvl(p_enabled_yn, 'Y')));
  begin
    assert_workspace_admin(l_actor);
    l_login_url := trim(p_ebs_login_url);
    if regexp_like(l_login_url, '/OA_HTML/AppsLocalLogin[.]jsp[?]$', 'i') then
      l_login_url := substr(l_login_url, 1, length(l_login_url) - 1);
    end if;

    if l_login_url is null
       or not regexp_like(
         l_login_url,
         '^https://[A-Za-z0-9.-]+(:[0-9]+)?/OA_HTML/(AppsLocalLogin[.]jsp|RF[.]jsp[?]function_id=mLogin)$',
         'i'
       ) then
      raise_application_error(-20744,
        'EBS Local Login URL must be https://<host>/OA_HTML/AppsLocalLogin.jsp (root SSO URLs are not permitted).');
    end if;

    if l_enabled not in ('Y', 'N') then
      raise_application_error(-20712, 'Enabled flag must be Y or N.');
    end if;

    merge into xx_tms_auth_config t
    using (select 'DEFAULT' as config_code from dual) s
       on (t.config_code = s.config_code)
     when matched then update set
       t.ebs_login_url = l_login_url,
       t.enabled_yn    = l_enabled,
       t.updated_on    = systimestamp,
       t.updated_by    = l_actor
     when not matched then insert (
       config_code, ebs_login_url, enabled_yn, updated_on, updated_by
     ) values (
       'DEFAULT', l_login_url, l_enabled, systimestamp, l_actor
     );

    commit;
    p_message := 'EBS local login endpoint saved: ' || l_login_url ||
                 case when l_enabled = 'Y' then ' (Enabled).' else ' (Disabled).' end;
    audit_action(l_actor, null, 'APP_400', 'SAVE_AUTH_CONFIG', 'SUCCESS', p_message);
  exception
    when others then
      rollback;
      audit_action(l_actor, null, 'APP_400', 'SAVE_AUTH_CONFIG', 'ERROR', sqlerrm);
      raise;
  end save_auth_config;

  procedure process_one_request(p_request_id varchar2) is
    l_type                varchar2(30);
    l_email               varchar2(255);
    l_first_name          varchar2(255);
    l_last_name           varchar2(255);
    l_codes               varchar2(4000);
    l_cipher              raw(2000);
    l_iv                  raw(8);
    l_key                 raw(24);
    l_actor               varchar2(255);
    l_password            varchar2(2000);
    l_message             varchar2(4000);
    l_user_id             number;
    l_existing_first_name varchar2(255);
    l_existing_last_name  varchar2(255);
    l_email_address       varchar2(255);
    l_account_locked      varchar2(30);
    l_is_admin            varchar2(30);
    l_is_developer        varchar2(30);
    l_ebs_candidate       varchar2(100);
    l_dup_count           pls_integer;
  begin
    set_workspace;
    select r.request_type, r.target_email, r.first_name, r.last_name,
           r.application_codes, r.password_cipher, r.password_iv,
           r.requested_by, k.key_value
      into l_type, l_email, l_first_name, l_last_name,
           l_codes, l_cipher, l_iv, l_actor, l_key
      from xx_tms_admin_request r
      left join xx_tms_admin_key k on k.request_id = r.request_id
     where r.request_id = p_request_id
       and r.request_status = 'PENDING'
       for update of r.request_status;

    assert_workspace_admin(l_actor);
    validate_target_email(l_email);
    if l_cipher is not null then
      if l_key is null or l_iv is null then
        raise_application_error(-20723,
          'Temporary-password encryption material is incomplete.');
      end if;
      l_password := utl_i18n.raw_to_char(
        decrypt_password(l_cipher, l_key, l_iv), 'AL32UTF8');
    end if;

    delete from xx_tms_admin_key where request_id = p_request_id;
    update xx_tms_admin_request
       set request_status  = 'RUNNING',
           started_on      = systimestamp,
           password_cipher = null,
           password_iv     = null
     where request_id = p_request_id;
    commit;

    if l_type = 'CREATE_USER' then
      if apex_util.get_user_id(l_email) is not null then
        raise_application_error(-20710,
          'User already exists. Maintain application assignments instead.');
      end if;
      validate_password(l_email, l_password);
      l_codes := normalize_application_codes(l_codes);
      if l_codes is not null then
        raise_application_error(-20711,
          'Create the workspace account first, then assign application access separately.');
      end if;
      apex_util.create_user(
        p_user_name                    => l_email,
        p_first_name                   => trim(l_first_name),
        p_last_name                    => trim(l_last_name),
        p_email_address                => l_email,
        p_web_password                 => l_password,
        p_web_password_format          => 'CLEAR_TEXT',
        p_group_ids                    => null,
        p_developer_privs              => 'END_USER',
        p_default_schema               => c_workspace,
        p_account_locked               => 'N',
        p_change_password_on_first_use => 'Y',
        p_allow_app_building_yn        => 'N',
        p_allow_sql_workshop_yn        => 'N',
        p_allow_websheet_dev_yn        => 'N',
        p_allow_team_development_yn    => 'N',
        p_allow_data_reporter_yn       => 'N'
      );

      begin
        l_ebs_candidate := upper(substr(regexp_replace(l_email, '@terex[.]com$', '', 1, 1, 'i'), 1, 100));
        if regexp_like(l_ebs_candidate, '^[A-Z0-9][A-Z0-9._@-]*$', 'c') then
          select count(*)
            into l_dup_count
            from xx_tms_users
           where local_user_email = l_email
             and ebs_user_name <> l_ebs_candidate;

          if l_dup_count = 0 then
            merge into xx_tms_users t
            using (select l_ebs_candidate as ebs_user_name from dual) s
               on (t.ebs_user_name = s.ebs_user_name)
             when matched then update set
               t.local_user_email = coalesce(t.local_user_email, l_email),
               t.full_name        = coalesce(t.full_name, substr(trim(trim(l_first_name) || ' ' || trim(l_last_name)), 1, 255)),
               t.email_address    = coalesce(t.email_address, l_email),
               t.updated_on       = systimestamp,
               t.updated_by       = l_actor
             when not matched then insert (
               ebs_user_name, local_user_email, full_name, email_address,
               enabled_yn, is_console_admin_yn, notes,
               created_on, created_by, updated_on, updated_by
             ) values (
               l_ebs_candidate, l_email,
               substr(trim(trim(l_first_name) || ' ' || trim(l_last_name)), 1, 255),
               l_email, 'Y', 'N',
               'Auto-linked on local workspace user creation.',
               systimestamp, l_actor, systimestamp, l_actor
             );
          end if;
        end if;
      exception
        when others then null;
      end;

      commit;
      l_message := 'Workspace account created without application access; password change is required at next login.';
    elsif l_type = 'RESET_PASSWORD' then
      fetch_end_user(l_email, l_user_id, l_existing_first_name,
        l_existing_last_name, l_email_address, l_account_locked,
        l_is_admin, l_is_developer);
      validate_password(l_email, l_password);
      apex_util.reset_password(
        p_user_name                    => upper(l_email),
        p_new_password                 => l_password,
        p_change_password_on_first_use => true
      );
      commit;
      l_message := 'Temporary password set; change is required at next login.';
    elsif l_type in ('LOCK_ACCOUNT', 'UNLOCK_ACCOUNT') then
      fetch_end_user(l_email, l_user_id, l_existing_first_name,
        l_existing_last_name, l_email_address, l_account_locked,
        l_is_admin, l_is_developer);
      apex_util.edit_user(
        p_user_id         => l_user_id,
        p_user_name       => upper(l_email),
        p_first_name      => l_existing_first_name,
        p_last_name       => l_existing_last_name,
        p_email_address   => l_email_address,
        p_default_schema  => c_workspace,
        p_group_ids       => group_id_list(l_email),
        p_developer_roles => 'END_USER',
        p_account_locked  => case when l_type = 'LOCK_ACCOUNT' then 'Y' else 'N' end
      );
      commit;
      l_message := case when l_type = 'LOCK_ACCOUNT'
        then 'Workspace account locked.' else 'Workspace account unlocked.' end;
    else
      raise_application_error(-20714, 'Unsupported account request type.');
    end if;

    l_password := null;
    update xx_tms_admin_request
       set request_status    = 'SUCCESS',
           completed_on      = systimestamp,
           result_message    = substr(l_message, 1, 4000),
           first_name        = null,
           last_name         = null,
           application_codes = null
     where request_id = p_request_id;
    commit;
    audit_action(l_actor, l_email, null,
      l_type, 'SUCCESS', l_message, p_request_id);
  exception
    when others then
      l_message := sqlerrm;
      l_password := null;
      rollback;
      delete from xx_tms_admin_key where request_id = p_request_id;
      update xx_tms_admin_request
         set request_status    = 'ERROR',
             completed_on      = systimestamp,
             password_cipher   = null,
             password_iv       = null,
             first_name        = null,
             last_name         = null,
             application_codes = null,
             result_message    = substr(l_message, 1, 4000)
       where request_id = p_request_id;
      commit;
      audit_action(nvl(l_actor, 'UNKNOWN'), l_email, null,
        nvl(l_type, 'ACCOUNT_REQUEST'), 'ERROR', l_message, p_request_id);
  end process_one_request;

  procedure run_pending_requests is
    l_request_id varchar2(32);
  begin
    loop
      select min(request_id)
        into l_request_id
        from xx_tms_admin_request
       where request_status = 'PENDING';
      exit when l_request_id is null;
      process_one_request(l_request_id);
    end loop;
  end run_pending_requests;
end xx_tms_admin_pkg;
/

show errors package body xx_tms_admin_pkg
set define on
