set define off

create or replace package xx_tms_security_pkg authid definer as
  -- Returns true if the user is an enabled TMS Console Administrator (XX_TMS_USERS)
  -- or a legacy unlocked GL_ACCOUNTS workspace administrator.
  function is_workspace_admin(
    p_user_name in varchar2
  ) return boolean;

  -- Returns true if the user is an active Console Administrator in XX_TMS_USERS.
  function is_console_admin(
    p_user_name in varchar2 default null
  ) return boolean;

  -- Central per-application authorization check enforced by TMS Application Access.
  function can_access(
    p_user_name      in varchar2,
    p_application_id in number
  ) return boolean;

  -- Custom authentication callback for APEX apps configured with EBS Credentials.
  -- Verifies provisioning & access before authenticating against the configured non-SSO
  -- EBS local login URL (https://erptex.terex.com/OA_HTML/AppsLocalLogin.jsp via
  -- X-Service: AuthenticateUser/logout, or /OA_HTML/RF.jsp?function_id=mLogin if configured)
  -- and immediately ends the remote EBS session.
  function authenticate_ebs(
    p_username in varchar2,
    p_password in varchar2
  ) return boolean;
end xx_tms_security_pkg;
/

show errors package xx_tms_security_pkg
set define on
