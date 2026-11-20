prompt --application/shared_components/logic/application_processes/tms_set_appearance
begin
--   Manifest
--     APPLICATION PROCESS: TMS_SET_APPEARANCE
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.04.07'
,p_release=>'26.2.0'
,p_default_workspace_id=>100789
,p_default_application_id=>128
,p_default_id_offset=>9401733729708713
,p_default_owner=>'GL_ACCOUNTS'
);
wwv_flow_imp_shared.create_flow_process(
 p_id=>wwv_flow_imp.id(1282310000000201)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_name=>'TMS_SET_APPEARANCE'
,p_static_id=>'tms-set-appearance'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
' if :APP_ID<>128 or not apex_authentication.is_authenticated then raise_application_error(-20001,''Authentication required''); end if;',
' if apex_application.g_x01 not in (''light'',''dark'') or apex_application.g_x01 is null then raise_application_error(-20002,''Invalid appearance''); end if;',
' apex_theme.set_user_style(p_application_id=>128,p_user=>:APP_USER,p_theme_number=>42,p_id=>case apex_application.g_x01 when ''dark'' then 1282310000000102 else 1282310000000101 end);',
' apex_json.open_object;apex_json.write(''ok'',true);apex_json.close_object;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_security_scheme=>wwv_flow_imp.id(18558063129193156)
);
wwv_flow_imp.component_end;
end;
/
