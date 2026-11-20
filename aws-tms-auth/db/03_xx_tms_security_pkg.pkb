set define off

create or replace package body xx_tms_security_pkg as
  c_workspace constant varchar2(30) := 'GL_ACCOUNTS';

  procedure set_workspace is
    l_security_group_id number;
  begin
    l_security_group_id := apex_util.find_security_group_id(p_workspace => c_workspace);
    if l_security_group_id is null then
      raise_application_error(-20700, 'APEX workspace GL_ACCOUNTS was not found.');
    end if;
    apex_util.set_security_group_id(p_security_group_id => l_security_group_id);
  end set_workspace;

  procedure clear_http_state is
  begin
    apex_web_service.clear_request_headers;
    apex_web_service.clear_request_cookies;
    apex_web_service.g_headers.delete;
    apex_web_service.g_response_cookies.delete;
  end clear_http_state;

  function normalized_user(p_user_name varchar2) return varchar2 is
  begin
    return lower(trim(p_user_name));
  end normalized_user;

  function is_public_or_blank(p_user_name varchar2) return boolean is
    l_upper varchar2(255) := upper(trim(p_user_name));
  begin
    return l_upper is null or l_upper in ('NOBODY', 'ANONYMOUS', 'APEX_PUBLIC_USER');
  end is_public_or_blank;

  function valid_ebs_username(p_username in varchar2) return boolean is
  begin
    return p_username is not null
       and length(p_username) <= 100
       and regexp_like(p_username, '^[A-Z0-9][A-Z0-9._@-]*$', 'c');
  end valid_ebs_username;

  function cookie_part_ok(
    p_value   in varchar2,
    p_is_name in boolean default false
  ) return boolean is
  begin
    return p_value is not null
       and length(p_value) <= 4000
       and instr(p_value, chr(10)) = 0
       and instr(p_value, chr(13)) = 0
       and instr(p_value, ';') = 0
       and instr(p_value, ',') = 0
       and not regexp_like(p_value, '[[:space:]]')
       and (not p_is_name or instr(p_value, '=') = 0);
  end cookie_part_ok;

  function encode_uri_component(p_val in varchar2) return varchar2 is
    l_raw  raw(32767);
    l_len  pls_integer;
    l_byte raw(1);
    l_code pls_integer;
    l_out  varchar2(32767);
  begin
    if p_val is null then
      return null;
    end if;

    l_raw := utl_i18n.string_to_raw(p_val, 'AL32UTF8');
    l_len := utl_raw.length(l_raw);
    for i in 1 .. l_len loop
      l_byte := utl_raw.substr(l_raw, i, 1);
      l_code := to_number(rawtohex(l_byte), 'XX');
      if (l_code between 65 and 90)
         or (l_code between 97 and 122)
         or (l_code between 48 and 57)
         or l_code in (45, 46, 95, 126) then
        l_out := l_out || utl_i18n.raw_to_char(l_byte, 'AL32UTF8');
      else
        l_out := l_out || '%' || upper(rawtohex(l_byte));
      end if;
    end loop;

    return l_out;
  end encode_uri_component;

  function unescape_js_string(p_val in varchar2) return varchar2 is
    l_len  pls_integer;
    l_pos  pls_integer := 1;
    l_next varchar2(1);
    l_hex  varchar2(4);
    l_out  varchar2(32767);
  begin
    if p_val is null then
      return null;
    end if;

    l_len := length(p_val);
    while l_pos <= l_len loop
      if substr(p_val, l_pos, 1) = '\' and l_pos < l_len then
        l_next := substr(p_val, l_pos + 1, 1);
        if l_next = 'x'
           and l_pos + 3 <= l_len
           and regexp_like(substr(p_val, l_pos + 2, 2), '^[0-9A-Fa-f]{2}$') then
          l_hex := '00' || substr(p_val, l_pos + 2, 2);
          l_out := l_out || unistr('\' || l_hex);
          l_pos := l_pos + 4;
        elsif l_next = 'u'
              and l_pos + 5 <= l_len
              and regexp_like(substr(p_val, l_pos + 2, 4), '^[0-9A-Fa-f]{4}$') then
          l_hex := substr(p_val, l_pos + 2, 4);
          l_out := l_out || unistr('\' || l_hex);
          l_pos := l_pos + 6;
        elsif l_next in ('\', '''', '"', '/') then
          l_out := l_out || l_next;
          l_pos := l_pos + 2;
        elsif l_next = 'n' then
          l_out := l_out || chr(10);
          l_pos := l_pos + 2;
        elsif l_next = 'r' then
          l_out := l_out || chr(13);
          l_pos := l_pos + 2;
        elsif l_next = 't' then
          l_out := l_out || chr(9);
          l_pos := l_pos + 2;
        else
          l_out := l_out || l_next;
          l_pos := l_pos + 2;
        end if;
      else
        l_out := l_out || substr(p_val, l_pos, 1);
        l_pos := l_pos + 1;
      end if;
    end loop;

    return l_out;
  end unescape_js_string;

  function js_field(
    p_body in varchar2,
    p_key  in varchar2
  ) return varchar2 is
  begin
    if p_body is null or p_key is null then
      return null;
    end if;

    if regexp_like(p_body, '(^|[,{[:space:]])[''"]?' || p_key || '[''"]?[[:space:]]*:[[:space:]]*''(([^''\\]|\\.)*)''', 'i') then
      return regexp_substr(p_body, '(^|[,{[:space:]])[''"]?' || p_key || '[''"]?[[:space:]]*:[[:space:]]*''(([^''\\]|\\.)*)''', 1, 1, 'i', 2);
    elsif regexp_like(p_body, '(^|[,{[:space:]])[''"]?' || p_key || '[''"]?[[:space:]]*:[[:space:]]*"(([^"\\]|\\.)*)"', 'i') then
      return regexp_substr(p_body, '(^|[,{[:space:]])[''"]?' || p_key || '[''"]?[[:space:]]*:[[:space:]]*"(([^"\\]|\\.)*)"', 1, 1, 'i', 2);
    else
      return regexp_substr(p_body, '(^|[,{[:space:]])[''"]?' || p_key || '[''"]?[[:space:]]*:[[:space:]]*([^,}' || chr(10) || chr(13) || '''"[:space:]]+)', 1, 1, 'i', 2);
    end if;
  end js_field;

  procedure decode_login(
    p_response   in  clob,
    p_user       out varchar2,
    p_token_name out varchar2,
    p_token      out varchar2
  ) is
    l_root json_object_t;
    l_data json_object_t;
  begin
    if p_response is null then
      raise_application_error(-20510, 'Invalid EBS login response');
    end if;

    if regexp_like(ltrim(dbms_lob.substr(p_response, 20, 1)), '^<') then
      select x.user_name, x.token_name, x.token_value
        into p_user, p_token_name, p_token
        from xmltable(
               '/response/data'
               passing xmltype(p_response)
               columns
                 user_name   varchar2(4000) path 'userName',
                 token_name  varchar2(4000) path 'accessTokenName',
                 token_value varchar2(4000) path 'accessToken'
             ) x;
    else
      l_root       := json_object_t.parse(p_response);
      l_data       := l_root.get_object('data');
      p_user       := l_data.get_string('userName');
      p_token_name := l_data.get_string('accessTokenName');
      p_token      := l_data.get_string('accessToken');
    end if;
  end decode_login;

  function get_app_code(p_application_id in number) return varchar2 is
    l_code varchar2(30);
  begin
    if p_application_id = 400 then
      return 'APP_400';
    end if;

    select application_code
      into l_code
      from xx_tms_application
     where apex_application_id = p_application_id;

    return l_code;
  exception
    when no_data_found then
      return case when p_application_id is not null then 'APP_' || to_char(p_application_id) end;
  end get_app_code;

  procedure audit_login(
    p_target_user      in varchar2,
    p_application_code in varchar2,
    p_action_status    in varchar2,
    p_action_detail    in varchar2
  ) is
    pragma autonomous_transaction;
    l_actor varchar2(255) := substr(nvl(trim(p_target_user), 'UNKNOWN'), 1, 255);
  begin
    insert into xx_tms_admin_audit (
      actor_email,
      target_email,
      application_code,
      action_name,
      action_status,
      action_detail
    ) values (
      l_actor,
      l_actor,
      substr(upper(trim(p_application_code)), 1, 30),
      'EBS_LOGIN',
      p_action_status,
      substr(p_action_detail, 1, 4000)
    );
    commit;
  exception
    when others then
      rollback;
  end audit_login;

  function validate_with_ebs(
    p_username in  varchar2,
    p_password in  varchar2,
    p_detail   out varchar2
  ) return boolean is
    l_login_url     xx_tms_auth_config.ebs_login_url%type;
    l_origin        varchar2(255);
    l_mode          varchar2(10) := 'LOCAL';
    l_req_body      varchar2(32767);
    l_response      clob;
    l_resp_vc       varchar2(8000);
    l_status        pls_integer;
    l_user          varchar2(4000);
    l_userid        varchar2(4000);
    l_auth_status   varchar2(4000);
    l_xsid          varchar2(4000);
    l_redir_url     varchar2(4000);
    l_err_code      varchar2(4000);
    l_token_name    varchar2(4000);
    l_token         varchar2(4000);
    l_cookie_header varchar2(32767);
    l_has_token     boolean := false;

    procedure append_cookie(p_name in varchar2, p_value in varchar2) is
    begin
      if not cookie_part_ok(p_name, true) or not cookie_part_ok(p_value) then
        raise_application_error(-20511, 'Invalid EBS cookie');
      end if;
      if l_cookie_header is not null then
        l_cookie_header := l_cookie_header || '; ';
      end if;
      l_cookie_header := l_cookie_header || p_name || '=' || p_value;
    end append_cookie;

    procedure collect_response_cookies is
      l_cookie_index pls_integer;
    begin
      l_cookie_index := apex_web_service.g_response_cookies.first;
      while l_cookie_index is not null loop
        if apex_web_service.g_response_cookies(l_cookie_index).name is not null
           and apex_web_service.g_response_cookies(l_cookie_index).value is not null then
          append_cookie(
            apex_web_service.g_response_cookies(l_cookie_index).name,
            apex_web_service.g_response_cookies(l_cookie_index).value
          );
          if upper(apex_web_service.g_response_cookies(l_cookie_index).name) <> 'JSESSIONID' then
            l_has_token := true;
          end if;
        end if;
        l_cookie_index := apex_web_service.g_response_cookies.next(l_cookie_index);
      end loop;
    end collect_response_cookies;

    procedure end_remote_session(p_mode in varchar2 default 'LOCAL') is
      l_logout_response clob;
    begin
      clear_http_state;
      if l_cookie_header is not null then
        if p_mode = 'LOCAL' and l_login_url is not null then
          apex_web_service.g_request_headers(1).name  := 'X-Service';
          apex_web_service.g_request_headers(1).value := 'logout';
          apex_web_service.g_request_headers(2).name  := 'Content-Type';
          apex_web_service.g_request_headers(2).value := 'application/x-www-form-urlencoded';
          apex_web_service.g_request_headers(3).name  := 'Cookie';
          apex_web_service.g_request_headers(3).value := l_cookie_header;
          l_logout_response := apex_web_service.make_rest_request(
            p_url              => l_login_url || '?',
            p_http_method      => 'POST',
            p_body             => 'username=' || encode_uri_component(p_username) || chr(38) || 'lang=US',
            p_transfer_timeout => 15
          );
        elsif p_mode = 'MLOGIN' and l_origin is not null then
          apex_web_service.g_request_headers(1).name  := 'Cookie';
          apex_web_service.g_request_headers(1).value := l_cookie_header;
          l_logout_response := apex_web_service.make_rest_request(
            p_url              => l_origin || '/OA_HTML/RF.jsp?function_id=mLogout',
            p_http_method      => 'GET',
            p_transfer_timeout => 15
          );
        end if;
      end if;
      l_logout_response := null;
      clear_http_state;
    exception
      when others then
        l_logout_response := null;
        clear_http_state;
    end end_remote_session;

    procedure scrub_locals is
    begin
      l_req_body      := null;
      l_response      := null;
      l_resp_vc       := null;
      l_xsid          := null;
      l_redir_url     := null;
      l_token_name    := null;
      l_token         := null;
      l_cookie_header := null;
    end scrub_locals;
  begin
    begin
      select ebs_login_url
        into l_login_url
        from xx_tms_auth_config
       where config_code = 'DEFAULT'
         and enabled_yn = 'Y';
    exception
      when no_data_found then
        p_detail := 'TMS EBS authentication endpoint is not configured or is disabled.';
        return false;
    end;

    l_login_url := trim(l_login_url);
    if regexp_like(l_login_url, '/OA_HTML/AppsLocalLogin[.]jsp[?]$', 'i') then
      l_login_url := substr(l_login_url, 1, length(l_login_url) - 1);
    end if;

    if regexp_like(l_login_url, '^https://[A-Za-z0-9.-]+(:[0-9]+)?/OA_HTML/AppsLocalLogin[.]jsp$', 'i') then
      l_mode := 'LOCAL';
      clear_http_state;
      apex_web_service.g_request_headers(1).name  := 'X-Service';
      apex_web_service.g_request_headers(1).value := 'AuthenticateUser';
      apex_web_service.g_request_headers(2).name  := 'Content-Type';
      apex_web_service.g_request_headers(2).value := 'application/x-www-form-urlencoded';

      l_req_body := 'username=' || encode_uri_component(p_username) ||
                    chr(38) || 'password=' || encode_uri_component(p_password);
      l_response := apex_web_service.make_rest_request(
        p_url              => l_login_url || '?',
        p_http_method      => 'POST',
        p_body             => l_req_body,
        p_transfer_timeout => 20
      );
      l_req_body := null;
      l_status   := apex_web_service.g_status_code;
      collect_response_cookies;

      if l_status in (301, 302, 303, 307, 308) then
        end_remote_session('LOCAL');
        scrub_locals;
        p_detail := 'EBS login endpoint redirected to SSO (HTTP ' || l_status || '). Verify AppsLocalLogin.jsp URL.';
        return false;
      end if;

      if l_status is null or l_status <> 200 then
        end_remote_session('LOCAL');
        scrub_locals;
        p_detail := 'EBS AppsLocalLogin.jsp returned HTTP ' || nvl(to_char(l_status), 'NULL') || '.';
        return false;
      end if;

      l_resp_vc     := dbms_lob.substr(l_response, 8000, 1);
      l_auth_status := unescape_js_string(js_field(l_resp_vc, 'status'));
      l_userid      := unescape_js_string(js_field(l_resp_vc, 'userid'));
      l_user        := unescape_js_string(js_field(l_resp_vc, 'username'));
      l_xsid        := unescape_js_string(js_field(l_resp_vc, 'xsid'));
      l_redir_url   := unescape_js_string(js_field(l_resp_vc, 'url'));
      l_err_code    := coalesce(
        unescape_js_string(js_field(l_resp_vc, 'errCode')),
        unescape_js_string(js_field(l_resp_vc, 'errorCode'))
      );

      if lower(nvl(l_auth_status, 'failed')) <> 'success' then
        end_remote_session('LOCAL');
        scrub_locals;
        p_detail := 'EBS AppsLocalLogin.jsp rejected credentials (' || nvl(l_err_code, 'FND_APPL_LOGIN_FAILED') || ').';
        return false;
      end if;

      if nvl(l_userid, '-1') in ('-1', '0')
         or not regexp_like(l_userid, '^[1-9][0-9]*$')
         or l_user is null
         or upper(l_user) <> upper(trim(p_username))
         or instr(lower(nvl(l_redir_url, '')), 'errcode=') > 0
         or ((l_xsid is null or l_xsid = '-1') and l_cookie_header is null) then
        end_remote_session('LOCAL');
        scrub_locals;
        p_detail := 'EBS AppsLocalLogin.jsp returned an unauthenticated or mismatched user session.';
        return false;
      end if;

      end_remote_session('LOCAL');
      scrub_locals;
      p_detail := 'Authenticated via EBS AppsLocalLogin.jsp (user_id=' || l_userid || ')';
      return true;
    elsif regexp_like(l_login_url, '^https://[A-Za-z0-9.-]+(:[0-9]+)?/OA_HTML/RF[.]jsp[?]function_id=mLogin$', 'i') then
      l_mode   := 'MLOGIN';
      l_origin := regexp_replace(l_login_url, '/OA_HTML/.*$', '', 1, 1, 'i');

      clear_http_state;
      apex_web_service.g_request_headers(1).name  := 'Accept';
      apex_web_service.g_request_headers(1).value := 'application/json, application/xml';

      l_response := apex_web_service.make_rest_request(
        p_url              => l_origin || '/OA_HTML/RF.jsp?function_id=mLogin',
        p_http_method      => 'GET',
        p_username         => p_username,
        p_password         => p_password,
        p_scheme           => 'Basic',
        p_transfer_timeout => 20
      );
      l_status := apex_web_service.g_status_code;
      collect_response_cookies;

      if l_status is null or l_status <> 200 then
        end_remote_session('MLOGIN');
        scrub_locals;
        p_detail := 'EBS /OA_HTML/RF.jsp?function_id=mLogin rejected credentials (HTTP ' || nvl(to_char(l_status), 'NULL') || ').';
        return false;
      end if;

      decode_login(l_response, l_user, l_token_name, l_token);

      if l_token is not null and l_token <> '-1' then
        if l_token_name is null then
          raise_application_error(-20512, 'Invalid EBS token response');
        end if;
        append_cookie(l_token_name, l_token);
        l_has_token := true;
      end if;

      if l_user is null
         or upper(l_user) <> upper(trim(p_username))
         or l_token = '-1'
         or not l_has_token then
        end_remote_session('MLOGIN');
        scrub_locals;
        p_detail := 'EBS mLogin returned an unauthenticated or mismatched user session.';
        return false;
      end if;

      end_remote_session('MLOGIN');
      scrub_locals;
      p_detail := 'Authenticated via EBS HTTPS mLogin';
      return true;
    else
      p_detail := 'TMS EBS login URL must be https://<host>/OA_HTML/AppsLocalLogin.jsp (SSO root URLs are not supported).';
      return false;
    end if;
  exception
    when others then
      p_detail := 'EBS local login verification failed: ' || substr(sqlerrm, 1, 500);
      end_remote_session(l_mode);
      scrub_locals;
      clear_http_state;
      return false;
  end validate_with_ebs;

  function is_console_admin(
    p_user_name in varchar2 default null
  ) return boolean is
    l_raw_user varchar2(255) := trim(nvl(
      p_user_name,
      coalesce(sys_context('APEX$SESSION', 'APP_USER'), apex_application.g_user)
    ));
    l_count    pls_integer;
  begin
    if is_public_or_blank(l_raw_user) then
      return false;
    end if;

    select count(*)
      into l_count
      from xx_tms_users
     where enabled_yn = 'Y'
       and is_console_admin_yn = 'Y'
       and (ebs_user_name = upper(l_raw_user)
            or local_user_email = lower(l_raw_user));

    return l_count > 0;
  exception
    when others then
      return false;
  end is_console_admin;

  function is_workspace_admin(
    p_user_name in varchar2
  ) return boolean is
    l_user_name varchar2(255) := normalized_user(p_user_name);
    l_count     pls_integer;
  begin
    if is_public_or_blank(p_user_name) then
      return false;
    end if;

    if is_console_admin(p_user_name) then
      return true;
    end if;

    set_workspace;
    select count(*)
      into l_count
      from apex_workspace_apex_users
     where workspace_name = c_workspace
       and lower(user_name) = l_user_name
       and upper(nvl(is_admin, 'NO')) = 'YES'
       and upper(nvl(account_locked, 'NO')) = 'NO';

    return l_count > 0;
  exception
    when others then
      return false;
  end is_workspace_admin;

  function can_access(
    p_user_name      in varchar2,
    p_application_id in number
  ) return boolean is
    l_raw_user         varchar2(255) := trim(p_user_name);
    l_ebs_user_name    xx_tms_users.ebs_user_name%type;
    l_local_user_email xx_tms_users.local_user_email%type;
    l_enabled_yn       xx_tms_users.enabled_yn%type;
    l_count            pls_integer;
  begin
    if is_public_or_blank(l_raw_user) or p_application_id is null then
      return false;
    end if;

    if is_workspace_admin(l_raw_user) then
      return true;
    end if;

    begin
      select ebs_user_name, local_user_email, enabled_yn
        into l_ebs_user_name, l_local_user_email, l_enabled_yn
        from xx_tms_users
       where ebs_user_name = upper(l_raw_user)
          or local_user_email = lower(l_raw_user)
       order by case when ebs_user_name = upper(l_raw_user) then 0 else 1 end
       fetch first 1 row only;

      if l_enabled_yn <> 'Y' then
        return false;
      end if;

      select count(*)
        into l_count
        from xx_tms_application a
        join xx_tms_user_access u
          on u.application_code = a.application_code
       where a.apex_application_id = p_application_id
         and a.enabled_yn = 'Y'
         and u.user_name in (
               lower(l_ebs_user_name),
               nvl(l_local_user_email, lower(l_ebs_user_name))
             );

      return l_count > 0;
    exception
      when no_data_found then
        if instr(l_raw_user, '@') = 0 then
          return false;
        end if;

        select count(*)
          into l_count
          from xx_tms_application a
          join xx_tms_user_access u
            on u.application_code = a.application_code
         where a.apex_application_id = p_application_id
           and a.enabled_yn = 'Y'
           and u.user_name = lower(l_raw_user);

        return l_count > 0;
    end;
  exception
    when others then
      return false;
  end can_access;

  function authenticate_ebs(
    p_username in varchar2,
    p_password in varchar2
  ) return boolean is
    l_app_id   number := apex_application.g_flow_id;
    l_ebs_user varchar2(32767) := upper(trim(p_username));
    l_app_code varchar2(30);
    l_cnt      pls_integer;
    l_detail   varchar2(4000);

    function has_app_authorization return boolean is
    begin
      if l_app_id = 400 then
        return is_console_admin(l_ebs_user);
      end if;
      return can_access(l_ebs_user, l_app_id);
    end has_app_authorization;
  begin
    l_app_code := get_app_code(l_app_id);

    if l_app_id is null or p_password is null or not valid_ebs_username(l_ebs_user) then
      audit_login(nvl(l_ebs_user, 'UNKNOWN'), l_app_code, 'DENIED', 'Invalid EBS username format or blank password.');
      return false;
    end if;

    select count(*)
      into l_cnt
      from xx_tms_users
     where ebs_user_name = l_ebs_user
       and enabled_yn = 'Y';

    if l_cnt <> 1 then
      audit_login(l_ebs_user, l_app_code, 'DENIED', 'User is not provisioned or is disabled in XX_TMS_USERS.');
      return false;
    end if;

    if not has_app_authorization then
      audit_login(
        l_ebs_user,
        l_app_code,
        'DENIED',
        case when l_app_id = 400 then 'User is not an enabled TMS Console Administrator.'
             else 'User is not authorized for APEX application ' || l_app_id || '.' end
      );
      return false;
    end if;

    if not validate_with_ebs(l_ebs_user, p_password, l_detail) then
      audit_login(l_ebs_user, l_app_code, 'DENIED', l_detail);
      return false;
    end if;

    -- Re-check local provisioning and app assignment in case access changed while EBS responded.
    select count(*)
      into l_cnt
      from xx_tms_users
     where ebs_user_name = l_ebs_user
       and enabled_yn = 'Y';

    if l_cnt <> 1 or not has_app_authorization then
      audit_login(l_ebs_user, l_app_code, 'DENIED', 'Authorization was revoked during EBS credential check.');
      return false;
    end if;

    audit_login(l_ebs_user, l_app_code, 'SUCCESS', l_detail);
    return true;
  exception
    when others then
      clear_http_state;
      audit_login(l_ebs_user, l_app_code, 'ERROR', sqlerrm);
      return false;
  end authenticate_ebs;
end xx_tms_security_pkg;
/

show errors package body xx_tms_security_pkg
set define on
