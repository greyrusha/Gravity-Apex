set define off

create or replace package xx_tms_admin_pkg authid definer as
  procedure create_user(
    p_email             in  varchar2,
    p_first_name        in  varchar2,
    p_last_name         in  varchar2,
    p_temp_password     in  varchar2,
    p_application_codes in  varchar2,
    p_message           out varchar2
  );

  procedure reset_password(
    p_email         in  varchar2,
    p_temp_password in  varchar2,
    p_message       out varchar2
  );

  procedure set_account_locked(
    p_email      in  varchar2,
    p_locked_yn  in  varchar2,
    p_message    out varchar2
  );

  procedure set_user_applications(
    p_email             in  varchar2,
    p_application_codes in  varchar2,
    p_message           out varchar2
  );

  procedure set_user_application_access(
    p_email            in  varchar2,
    p_application_code in  varchar2,
    p_enabled_yn       in  varchar2,
    p_message          out varchar2
  );

  procedure save_application(
    p_application_code    in  varchar2,
    p_apex_application_id in  number,
    p_application_name    in  varchar2,
    p_access_mode         in  varchar2,
    p_enabled_yn          in  varchar2,
    p_message             out varchar2
  );

  procedure save_ebs_user(
    p_ebs_user_name       in  varchar2,
    p_local_user_email    in  varchar2 default null,
    p_full_name           in  varchar2 default null,
    p_enabled_yn          in  varchar2 default 'Y',
    p_is_console_admin_yn in  varchar2 default 'N',
    p_notes               in  varchar2 default null,
    p_message             out varchar2
  );

  procedure save_application_access_grid(
    p_application_code in  varchar2,
    p_all_users        in  apex_application_global.vc_arr2,
    p_checked_users    in  apex_application_global.vc_arr2,
    p_message          out varchar2
  );

  procedure save_auth_config(
    p_ebs_login_url in  varchar2,
    p_enabled_yn    in  varchar2 default 'Y',
    p_message       out varchar2
  );

  -- Entry point for the pre-created, on-demand scheduler worker.
  procedure run_pending_requests;
end xx_tms_admin_pkg;
/

show errors package xx_tms_admin_pkg
set define on
