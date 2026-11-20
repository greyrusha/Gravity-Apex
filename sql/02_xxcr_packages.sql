-- =============================================================================
-- 02_xxcr_packages.sql
-- Oracle APEX 26.2 Customer Rollout Workbench (XXCR_ROLLOUT_PKG)
-- Target Schema: GL_ACCOUNTS on APEXQ_AWS (Oracle AI Database 26ai)
-- Source EBS DB Link: @ADG (using /*+ DRIVING_SITE(...) */ for all remote SQL)
-- =============================================================================

create or replace package xxcr_rollout_pkg as

  -- Normalization & Hash Helpers
  function normalize_party_name(p_name in varchar2) return varchar2 deterministic;

  function normalize_address_key(
    p_country in varchar2,
    p_addr1   in varchar2,
    p_city    in varchar2,
    p_state   in varchar2,
    p_postal  in varchar2
  ) return varchar2 deterministic;

  function compute_addr_hash(
    p_country  in varchar2,
    p_addr1    in varchar2,
    p_addr2    in varchar2,
    p_addr3    in varchar2,
    p_addr4    in varchar2,
    p_city     in varchar2,
    p_state    in varchar2,
    p_province in varchar2,
    p_county   in varchar2,
    p_postal   in varchar2
  ) return varchar2 deterministic;

  function remap_gl_bsv(
    p_concat_segs in varchar2,
    p_new_bsv     in varchar2
  ) return varchar2 deterministic;

  -- Project & OU Metadata Management
  procedure refresh_ou_cache;
  procedure refresh_ebs_ref_lovs;
  procedure sync_project_metadata(p_project_id in number);

  -- Immediate Pre-Save Row Validators (Returns NULL when valid, or error message text)
  function validate_cust_row(
    p_include_yn         in varchar2,
    p_action_code        in varchar2,
    p_tgt_party_name     in varchar2,
    p_tgt_account_number in varchar2,
    p_cust_class         in varchar2,
    p_profile_class      in varchar2,
    p_collector          in varchar2,
    p_payment_term       in varchar2,
    p_credit_curr        in varchar2,
    p_overall_limit      in varchar2,
    p_trx_limit          in varchar2
  ) return varchar2;

  function validate_site_row(
    p_include_yn  in varchar2,
    p_country     in varchar2,
    p_address1    in varchar2,
    p_city        in varchar2,
    p_postal_code in varchar2,
    p_sales_curr  in varchar2 default null,
    p_rps_hold    in varchar2 default null
  ) return varchar2;

  function validate_site_use_row(
    p_include_yn      in varchar2,
    p_primary_flag    in varchar2,
    p_location_code   in varchar2,
    p_profile_class   in varchar2,
    p_collector       in varchar2,
    p_payment_term    in varchar2,
    p_credit_curr     in varchar2,
    p_overall_limit   in varchar2,
    p_trx_limit       in varchar2,
    p_warehouse_code  in varchar2,
    p_order_type      in varchar2,
    p_price_list      in varchar2,
    p_tax_code        in varchar2,
    p_gl_rec          in varchar2,
    p_gl_rev          in varchar2,
    p_gl_tax          in varchar2,
    p_stmt_cycle      in varchar2 default null,
    p_dunning_set     in varchar2 default null,
    p_autocash_rule   in varchar2 default null,
    p_grouping_rule   in varchar2 default null
  ) return varchar2;

  function validate_prof_amt_row(
    p_include_yn      in varchar2,
    p_currency_code   in varchar2,
    p_overall_limit   in varchar2,
    p_trx_limit       in varchar2
  ) return varchar2;

  function validate_contact_row(
    p_include_yn   in varchar2,
    p_primary_flag in varchar2,
    p_first_name   in varchar2,
    p_last_name    in varchar2,
    p_email        in varchar2
  ) return varchar2;
  procedure seed_default_project(p_project_id out number);
  procedure create_project(
    p_project_code    in  varchar2,
    p_project_name    in  varchar2,
    p_src_org_id      in  number,
    p_tgt_org_id      in  number   default null,
    p_tgt_bsv         in  varchar2 default null,
    p_awp_seg7_re     in  varchar2 default '^1[0-9]{3}$',
    p_active_months   in  number   default 24,
    p_description     in  varchar2 default null,
    p_new_project_id  out number
  );
  procedure update_target_scope(
    p_project_id in number,
    p_tgt_org_id in number default null,
    p_tgt_bsv    in varchar2 default null
  );

  -- Core Extract & Tier 1/2 Public API Enrichment from @ADG (100% DRIVING_SITE remote execution)
  procedure extract_project_data(p_project_id in number);
  procedure enrich_project_api_data(p_project_id in number);
  procedure refresh_site_activity(p_project_id in number);

  -- Data Manipulation, Mapping & Delta Tracking
  procedure apply_mapping_rules(p_project_id in number);

  procedure bulk_manipulate_data(
    p_project_id      in number,
    p_new_bsv         in varchar2 default null,
    p_payment_term    in varchar2 default null,
    p_warehouse_code  in varchar2 default null,
    p_order_type      in varchar2 default null,
    p_price_list      in varchar2 default null,
    p_tax_code        in varchar2 default null,
    p_only_included   in varchar2 default 'Y'
  );

  procedure sync_deltas(p_project_id in number);

  procedure cascade_exclusions(
    p_project_id in number,
    p_import_id  in number default null
  );

  -- "Find Duplicates" Engine & Resolution
  procedure find_duplicates(p_project_id in number);

  procedure resolve_duplicate(
    p_dup_id in number,
    p_action in varchar2,
    p_note   in varchar2 default null
  );

  procedure auto_exclude_dormant_duplicates(
    p_project_id   in number,
    p_excluded_cnt out number
  );

  -- 4-Stage Validation Engine
  procedure validate_project(p_project_id in number);

  -- Connected Multi-Tab .xlsx Workbook Generator (Live Cross-Sheet Formulas)
  function generate_connected_xlsx(p_project_id in number) return blob;

  -- Excel Upload & Cell-Level Delta Application (via APEX_DATA_PARSER)
  procedure process_excel_upload(
    p_project_id   in number,
    p_file_name    in varchar2,
    p_mime_type    in varchar2,
    p_file_blob    in blob,
    p_target_sheet in varchar2 default 'AUTO',
    p_import_id    out number
  );

end xxcr_rollout_pkg;
/

create or replace package body xxcr_rollout_pkg as

  ------------------------------------------------------------------------------
  -- 1. Normalization & Hash Helpers
  ------------------------------------------------------------------------------
  function normalize_party_name(p_name in varchar2) return varchar2 deterministic is
    l_res varchar2(400);
  begin
    if p_name is null then
      return null;
    end if;
    l_res := upper(trim(p_name));
    -- Remove common legal entity suffixes and punctuation
    l_res := regexp_replace(l_res, '[^A-Z0-9 ]', ' ');
    l_res := regexp_replace(
      ' ' || l_res || ' ',
      ' (PTY|LTD|LIMITED|INC|INCORPORATED|LLC|CORP|CORPORATION|GMBH|SRL|SPA|SA|BV|NV|PLC|CO|COMPANY|AUSTRALIA|US|USA|UK) ',
      ' '
    );
    l_res := regexp_replace(
      ' ' || l_res || ' ',
      ' (PTY|LTD|LIMITED|INC|INCORPORATED|LLC|CORP|CORPORATION|GMBH|SRL|SPA|SA|BV|NV|PLC|CO|COMPANY) ',
      ' '
    );
    l_res := trim(regexp_replace(l_res, '\s+', ' '));
    return substr(l_res, 1, 360);
  end normalize_party_name;

  function normalize_address_key(
    p_country in varchar2,
    p_addr1   in varchar2,
    p_city    in varchar2,
    p_state   in varchar2,
    p_postal  in varchar2
  ) return varchar2 deterministic is
    l_addr varchar2(300);
    l_city varchar2(100);
    l_post varchar2(60);
  begin
    l_addr := upper(nvl(p_addr1, ''));
    l_addr := regexp_replace(l_addr, '[^A-Z0-9 ]', ' ');
    l_addr := regexp_replace(' ' || l_addr || ' ', ' (STREET|STR) ', ' ST ');
    l_addr := regexp_replace(' ' || l_addr || ' ', ' (ROAD) ', ' RD ');
    l_addr := regexp_replace(' ' || l_addr || ' ', ' (AVENUE|AVE) ', ' AVE ');
    l_addr := regexp_replace(' ' || l_addr || ' ', ' (DRIVE|DR) ', ' DR ');
    l_addr := regexp_replace(' ' || l_addr || ' ', ' (BOULEVARD|BLVD) ', ' BLVD ');
    l_addr := regexp_replace(' ' || l_addr || ' ', ' (SUITE|STE|UNIT|APT) ', ' ');
    l_addr := trim(regexp_replace(l_addr, '\s+', ' '));

    l_city := trim(regexp_replace(upper(nvl(p_city, '')), '[^A-Z0-9 ]', ''));
    l_post := trim(regexp_replace(upper(nvl(p_postal, '')), '[^A-Z0-9]', ''));

    return substr(upper(trim(nvl(p_country, 'XX'))) || '|' || l_post || '|' || l_city || '|' || l_addr, 1, 400);
  end normalize_address_key;

  function compute_addr_hash(
    p_country  in varchar2,
    p_addr1    in varchar2,
    p_addr2    in varchar2,
    p_addr3    in varchar2,
    p_addr4    in varchar2,
    p_city     in varchar2,
    p_state    in varchar2,
    p_province in varchar2,
    p_county   in varchar2,
    p_postal   in varchar2
  ) return varchar2 deterministic is
    l_raw varchar2(2000);
    l_hash varchar2(64);
  begin
    l_raw := upper(trim(p_country))  || '|' ||
             upper(trim(p_addr1))    || '|' ||
             upper(trim(p_addr2))    || '|' ||
             upper(trim(p_addr3))    || '|' ||
             upper(trim(p_addr4))    || '|' ||
             upper(trim(p_city))     || '|' ||
             upper(trim(p_state))    || '|' ||
             upper(trim(p_province)) || '|' ||
             upper(trim(p_county))   || '|' ||
             upper(trim(p_postal));
    select standard_hash(l_raw, 'SHA256') into l_hash from dual;
    return l_hash;
  end compute_addr_hash;

  function remap_gl_bsv(
    p_concat_segs in varchar2,
    p_new_bsv     in varchar2
  ) return varchar2 deterministic is
    l_dot_pos pls_integer;
  begin
    if p_concat_segs is null or trim(p_new_bsv) is null then
      return p_concat_segs;
    end if;
    l_dot_pos := instr(p_concat_segs, '.');
    if l_dot_pos > 1 then
      return trim(p_new_bsv) || substr(p_concat_segs, l_dot_pos);
    else
      return p_concat_segs;
    end if;
  end remap_gl_bsv;

  ------------------------------------------------------------------------------
  -- 2. Project & OU Metadata Management
  ------------------------------------------------------------------------------
  procedure refresh_ou_cache is
    type t_ou_tab is table of xxcr_ebs_ou_cache%rowtype;
    l_tab t_ou_tab;
  begin
    select /*+ driving_site(hou) */
           hou.organization_id,
           hou.name,
           hou.short_code,
           hou.set_of_books_id,
           gl.name,
           gl.currency_code,
           gl.chart_of_accounts_id,
           hou.default_legal_context_id,
           xep.name,
           systimestamp
      bulk collect into l_tab
      from apps.hr_operating_units@adg hou
      left join apps.gl_ledgers@adg gl
        on gl.ledger_id = hou.set_of_books_id
      left join apps.xle_entity_profiles@adg xep
        on xep.legal_entity_id = hou.default_legal_context_id
     where nvl(hou.date_to, sysdate + 1) >= sysdate;

    delete from xxcr_ebs_ou_cache;
    forall i in 1 .. l_tab.count
      insert into xxcr_ebs_ou_cache values l_tab(i);
  end refresh_ou_cache;

  procedure refresh_ebs_ref_lovs is
    type r_lov is record (
      domain_code   varchar2(40),
      org_id        number,
      return_value  varchar2(240),
      display_value varchar2(500),
      extra_info    varchar2(240)
    );
    type t_lov_tab is table of r_lov;
    l_lovs t_lov_tab;
  begin
    select domain_code, org_id, return_value, display_value, extra_info
      bulk collect into l_lovs
      from (
        -- 1. Payment Terms
        select /*+ driving_site(b) */
               'PAYMENT_TERM' as domain_code,
               cast(null as number) as org_id,
               substr(t.name, 1, 240) as return_value,
               substr(t.name || case when t.description is not null then ' — ' || t.description end, 1, 500) as display_value,
               to_char(b.term_id) as extra_info
          from apps.ra_terms_b@adg b,
               apps.ra_terms_tl@adg t
         where t.term_id = b.term_id
           and t.language = 'US'
           and trunc(sysdate) between nvl(b.start_date_active, trunc(sysdate)) and nvl(b.end_date_active, trunc(sysdate))
        union all
        -- 2. Collectors
        select /*+ driving_site(c) */
               'COLLECTOR',
               null,
               substr(c.name, 1, 240),
               substr(c.name || case when c.description is not null then ' — ' || c.description end, 1, 500),
               to_char(c.collector_id)
          from apps.ar_collectors@adg c
         where c.status = 'A'
           and nvl(c.inactive_date, trunc(sysdate) + 1) >= trunc(sysdate)
        union all
        -- 3. Customer Profile Classes
        select /*+ driving_site(pc) */
               'PROFILE_CLASS',
               null,
               substr(pc.name, 1, 240),
               substr(pc.name || case when pc.description is not null then ' — ' || pc.description end, 1, 500),
               to_char(pc.profile_class_id)
          from apps.hz_cust_profile_classes@adg pc
         where nvl(pc.status, 'A') = 'A'
        union all
        -- 4. Customer Classes
        select /*+ driving_site(l) */
               'CUSTOMER_CLASS',
               null,
               substr(l.lookup_code, 1, 240),
               substr(l.lookup_code || ' — ' || l.meaning, 1, 500),
               null
          from apps.ar_lookups@adg l
         where l.lookup_type = 'CUSTOMER CLASS'
           and l.enabled_flag = 'Y'
           and trunc(sysdate) between nvl(l.start_date_active, trunc(sysdate)) and nvl(l.end_date_active, trunc(sysdate))
        union all
        -- 5. Currencies
        select /*+ driving_site(fc) */
               'CURRENCY',
               null,
               substr(fc.currency_code, 1, 240),
               substr(fc.currency_code, 1, 500),
               to_char(fc.precision)
          from apps.fnd_currencies@adg fc
         where fc.enabled_flag = 'Y'
           and fc.currency_flag = 'Y'
           and trunc(sysdate) between nvl(fc.start_date_active, trunc(sysdate)) and nvl(fc.end_date_active, trunc(sysdate))
        union all
        -- 6. Countries (ISO Territory Codes)
        select /*+ driving_site(ft) */
               'COUNTRY',
               null,
               substr(ft.territory_code, 1, 240),
               substr(ft.territory_code || ' — ' || ft.territory_short_name, 1, 500),
               null
          from apps.fnd_territories_tl@adg ft
         where ft.language = 'US'
        union all
        -- 7. Inventory Warehouses
        select /*+ driving_site(mp) */
               'WAREHOUSE',
               null,
               substr(mp.organization_code, 1, 240),
               substr(mp.organization_code || ' — ' || hou.name, 1, 500),
               to_char(mp.organization_id)
          from apps.mtl_parameters@adg mp,
               apps.hr_all_organization_units@adg hou
         where hou.organization_id = mp.organization_id
           and nvl(hou.date_to, trunc(sysdate) + 1) >= trunc(sysdate)
        union all
        -- 8. OM Order Types (Distinct Active Names)
        select /*+ driving_site(ot) */
               'ORDER_TYPE',
               null,
               substr(ott.name, 1, 240),
               substr(ott.name || case when max(ott.description) is not null then ' — ' || max(ott.description) end, 1, 500),
               to_char(min(ot.transaction_type_id))
          from apps.oe_transaction_types_all@adg ot,
               apps.oe_transaction_types_tl@adg ott
         where ott.transaction_type_id = ot.transaction_type_id
           and ott.language = 'US'
           and ot.transaction_type_code = 'ORDER'
           and trunc(sysdate) between nvl(ot.start_date_active, trunc(sysdate)) and nvl(ot.end_date_active, trunc(sysdate))
         group by ott.name
        union all
        -- 9. QP Price Lists (Distinct Active Names)
        select /*+ driving_site(plb) */
               'PRICE_LIST',
               null,
               substr(plt.name, 1, 240),
               substr(plt.name, 1, 500),
               to_char(min(plb.list_header_id))
          from apps.qp_list_headers_b@adg plb,
               apps.qp_list_headers_tl@adg plt
         where plt.list_header_id = plb.list_header_id
           and plt.language = 'US'
           and plb.list_type_code = 'PRL'
           and plb.active_flag = 'Y'
           and trunc(sysdate) between nvl(plb.start_date_active, trunc(sysdate)) and nvl(plb.end_date_active, trunc(sysdate))
         group by plt.name
        union all
        -- 10. FOB Lookup Codes
        select /*+ driving_site(l) */
               'FOB',
               null,
               substr(l.lookup_code, 1, 240),
               substr(l.lookup_code || ' — ' || l.meaning, 1, 500),
               null
          from apps.ar_lookups@adg l
         where l.lookup_type = 'FOB'
           and l.enabled_flag = 'Y'
        union all
        -- 11. Freight Terms
        select /*+ driving_site(ol) */
               'FREIGHT_TERM',
               null,
               substr(ol.lookup_code, 1, 240),
               substr(ol.lookup_code || ' — ' || ol.meaning, 1, 500),
               null
          from apps.oe_lookups@adg ol
         where ol.lookup_type = 'FREIGHT_TERMS'
           and ol.enabled_flag = 'Y'
        union all
        -- 12. Active Tax Classification Codes on Customer Site Uses
        select /*+ driving_site(su) */
               'TAX_CODE',
               null,
               substr(su.tax_code, 1, 240),
               substr(su.tax_code, 1, 500),
               null
          from apps.hz_cust_site_uses_all@adg su
         where su.status = 'A'
           and su.tax_code is not null
         group by su.tax_code
        union all
        -- 13. AR Statement Cycles
        select /*+ driving_site(sc) */
               'STATEMENT_CYCLE',
               null,
               substr(sc.name, 1, 240),
               substr(sc.name || case when sc.description is not null then ' — ' || sc.description end, 1, 500),
               to_char(sc.statement_cycle_id)
          from apps.ar_statement_cycles@adg sc
         where sc.status = 'A'
        union all
        -- 14. AR AutoCash Rule Hierarchies
        select /*+ driving_site(ah) */
               'AUTOCASH_RULE',
               null,
               substr(ah.hierarchy_name, 1, 240),
               substr(ah.hierarchy_name || case when ah.description is not null then ' — ' || ah.description end, 1, 500),
               to_char(ah.autocash_hierarchy_id)
          from apps.ar_autocash_hierarchies@adg ah
         where ah.status = 'A'
        union all
        -- 15. AR AutoInvoice Grouping Rules
        select /*+ driving_site(gr) */
               'GROUPING_RULE',
               null,
               substr(gr.name, 1, 240),
               substr(gr.name || case when gr.description is not null then ' — ' || gr.description end, 1, 500),
               to_char(gr.grouping_rule_id)
          from apps.ra_grouping_rules@adg gr
        union all
        -- 16. AR Dunning Letter Sets
        select /*+ driving_site(dl) */
               'DUNNING_SET',
               null,
               substr(dl.name, 1, 240),
               substr(dl.name || case when dl.description is not null then ' — ' || dl.description end, 1, 500),
               to_char(dl.dunning_letter_set_id)
          from apps.ar_dunning_letter_sets@adg dl
         where dl.status = 'A'
        union all
        -- 17. AR Active Receipt Methods
        select /*+ driving_site(rm) */
               'RECEIPT_METHOD',
               null,
               substr(rm.name, 1, 240),
               substr(rm.name, 1, 500),
               to_char(rm.receipt_method_id)
          from apps.ar_receipt_methods@adg rm
         where trunc(sysdate) between rm.start_date and nvl(rm.end_date, trunc(sysdate))
      );

    delete from xxcr_ebs_ref_lovs;
    forall i in 1 .. l_lovs.count
      insert into xxcr_ebs_ref_lovs (
        domain_code, org_id, return_value, display_value, extra_info, active_yn, updated_at
      ) values (
        l_lovs(i).domain_code, l_lovs(i).org_id, l_lovs(i).return_value,
        l_lovs(i).display_value, l_lovs(i).extra_info, 'Y', systimestamp
      );
  end refresh_ebs_ref_lovs;

  function lov_exists(p_domain in varchar2, p_val in varchar2) return boolean is
    l_cnt pls_integer;
    l_v   varchar2(240) := upper(trim(p_val));
  begin
    if l_v is null then
      return true;
    end if;
    select count(*)
      into l_cnt
      from xxcr_ebs_ref_lovs
     where domain_code = p_domain
       and upper(return_value) = l_v
       and active_yn = 'Y';
    if l_cnt > 0 then
      return true;
    end if;

    -- Also allow historical EBS source values already extracted on staged records
    if p_domain = 'CUSTOMER_CLASS' then
      select count(*) into l_cnt from xxcr_stg_customers where upper(src_customer_class_code) = l_v and rownum = 1;
    elsif p_domain = 'PROFILE_CLASS' then
      select count(*) into l_cnt from xxcr_stg_customers where upper(src_profile_class_name) = l_v and rownum = 1;
      if l_cnt = 0 then
        select count(*) into l_cnt from xxcr_stg_site_uses where upper(src_profile_class_name) = l_v and rownum = 1;
      end if;
    elsif p_domain = 'COLLECTOR' then
      select count(*) into l_cnt from xxcr_stg_customers where upper(src_collector_name) = l_v and rownum = 1;
      if l_cnt = 0 then
        select count(*) into l_cnt from xxcr_stg_site_uses where upper(src_collector_name) = l_v and rownum = 1;
      end if;
    elsif p_domain = 'PAYMENT_TERM' then
      select count(*) into l_cnt from xxcr_stg_customers where upper(src_payment_term_name) = l_v and rownum = 1;
      if l_cnt = 0 then
        select count(*) into l_cnt from xxcr_stg_site_uses where upper(src_payment_term_name) = l_v and rownum = 1;
      end if;
    elsif p_domain = 'ORDER_TYPE' then
      select count(*) into l_cnt from xxcr_stg_site_uses where upper(src_order_type_name) = l_v and rownum = 1;
    elsif p_domain = 'PRICE_LIST' then
      select count(*) into l_cnt from xxcr_stg_site_uses where upper(src_price_list_name) = l_v and rownum = 1;
    elsif p_domain = 'WAREHOUSE' then
      select count(*) into l_cnt from xxcr_stg_site_uses where upper(src_warehouse_code) = l_v and rownum = 1;
    elsif p_domain = 'STATEMENT_CYCLE' then
      select count(*) into l_cnt from xxcr_stg_site_uses where upper(src_statement_cycle_name) = l_v and rownum = 1;
    elsif p_domain = 'AUTOCASH_RULE' then
      select count(*) into l_cnt from xxcr_stg_site_uses where upper(src_autocash_rule_name) = l_v and rownum = 1;
    elsif p_domain = 'GROUPING_RULE' then
      select count(*) into l_cnt from xxcr_stg_site_uses where upper(src_grouping_rule_name) = l_v and rownum = 1;
    elsif p_domain = 'DUNNING_SET' then
      select count(*) into l_cnt from xxcr_stg_site_uses where upper(src_dunning_letter_set) = l_v and rownum = 1;
    end if;
    return l_cnt > 0;
  end lov_exists;

  function valid_gl_9seg(p_gl in varchar2) return boolean is
  begin
    if trim(p_gl) is null then
      return true;
    end if;
    return regexp_like(trim(p_gl), '^[^.\s]+(\.[^.\s]+){8}$');
  end valid_gl_9seg;

  function parse_num_clean(p_str in varchar2, p_out out number) return boolean is
    l_clean varchar2(200) := replace(replace(trim(p_str), ',', ''), '$', '');
  begin
    if l_clean is null then
      p_out := null;
      return true;
    end if;
    p_out := to_number(l_clean);
    return true;
  exception
    when others then
      p_out := null;
      return false;
  end parse_num_clean;

  function validate_cust_row(
    p_include_yn         in varchar2,
    p_action_code        in varchar2,
    p_tgt_party_name     in varchar2,
    p_tgt_account_number in varchar2,
    p_cust_class         in varchar2,
    p_profile_class      in varchar2,
    p_collector          in varchar2,
    p_payment_term       in varchar2,
    p_credit_curr        in varchar2,
    p_overall_limit      in varchar2,
    p_trx_limit          in varchar2
  ) return varchar2 is
    l_ovr number;
    l_trx number;
  begin
    if upper(trim(nvl(p_include_yn, 'X'))) not in ('Y', 'N') then
      return 'Include must be Y or N.';
    end if;
    if upper(trim(nvl(p_action_code, 'X'))) not in ('EXTEND_OU', 'NEW_ACCT', 'SKIP') then
      return 'Action must be EXTEND_OU or NEW_ACCT.';
    end if;
    if upper(trim(p_include_yn)) = 'Y' and trim(p_tgt_party_name) is null then
      return 'Target Party Name is required for included customers.';
    end if;
    if not parse_num_clean(p_overall_limit, l_ovr) or (l_ovr is not null and l_ovr < 0) then
      return 'Overall Credit Limit must be a non-negative number.';
    end if;
    if not parse_num_clean(p_trx_limit, l_trx) or (l_trx is not null and l_trx < 0) then
      return 'Order Credit Limit must be a non-negative number.';
    end if;
    if l_ovr is not null and l_trx is not null and l_ovr > 0 and l_trx > l_ovr then
      return 'Order Credit Limit (' || l_trx || ') cannot exceed Overall Credit Limit (' || l_ovr || ').';
    end if;
    if not lov_exists('CUSTOMER_CLASS', p_cust_class) then
      return 'Customer Class "' || trim(p_cust_class) || '" is not an active EBS Customer Class.';
    end if;
    if not lov_exists('PROFILE_CLASS', p_profile_class) then
      return 'Profile Class "' || trim(p_profile_class) || '" is not an active EBS Customer Profile Class.';
    end if;
    if not lov_exists('COLLECTOR', p_collector) then
      return 'Collector "' || trim(p_collector) || '" is not an active EBS AR Collector.';
    end if;
    if not lov_exists('PAYMENT_TERM', p_payment_term) then
      return 'Payment Term "' || trim(p_payment_term) || '" is not an active EBS Payment Term.';
    end if;
    if not lov_exists('CURRENCY', p_credit_curr) then
      return 'Credit Currency "' || trim(p_credit_curr) || '" is not an enabled ISO Currency in EBS.';
    end if;
    return null;
  end validate_cust_row;

  function validate_site_row(
    p_include_yn  in varchar2,
    p_country     in varchar2,
    p_address1    in varchar2,
    p_city        in varchar2,
    p_postal_code in varchar2,
    p_sales_curr  in varchar2 default null,
    p_rps_hold    in varchar2 default null
  ) return varchar2 is
  begin
    if upper(trim(nvl(p_include_yn, 'X'))) not in ('Y', 'N') then
      return 'Site Include must be Y or N.';
    end if;
    if trim(p_rps_hold) is not null and upper(trim(p_rps_hold)) not in ('Y', 'N') then
      return 'Denied Party Hold (TREX_RP_SCREENING) must be Y, N, or blank.';
    end if;
    if not lov_exists('CURRENCY', p_sales_curr) then
      return 'Sales Currency "' || trim(p_sales_curr) || '" is not an enabled EBS Currency.';
    end if;
    if upper(trim(p_include_yn)) = 'Y' then
      if trim(p_country) is null or not lov_exists('COUNTRY', p_country) then
        return 'Country "' || trim(p_country) || '" must be a valid 2-letter EBS ISO Country Code (e.g. AU, US, GB).';
      end if;
      if trim(p_address1) is null then
        return 'Address Line 1 is required for included sites.';
      end if;
      if trim(p_city) is null then
        return 'City is required for included sites.';
      end if;
    end if;
    return null;
  end validate_site_row;

  function validate_site_use_row(
    p_include_yn      in varchar2,
    p_primary_flag    in varchar2,
    p_location_code   in varchar2,
    p_profile_class   in varchar2,
    p_collector       in varchar2,
    p_payment_term    in varchar2,
    p_credit_curr     in varchar2,
    p_overall_limit   in varchar2,
    p_trx_limit       in varchar2,
    p_warehouse_code  in varchar2,
    p_order_type      in varchar2,
    p_price_list      in varchar2,
    p_tax_code        in varchar2,
    p_gl_rec          in varchar2,
    p_gl_rev          in varchar2,
    p_gl_tax          in varchar2,
    p_stmt_cycle      in varchar2 default null,
    p_dunning_set     in varchar2 default null,
    p_autocash_rule   in varchar2 default null,
    p_grouping_rule   in varchar2 default null
  ) return varchar2 is
    l_ovr number;
    l_trx number;
  begin
    if upper(trim(nvl(p_include_yn, 'X'))) not in ('Y', 'N') then
      return 'Site Use Include must be Y or N.';
    end if;
    if upper(trim(nvl(p_primary_flag, 'N'))) not in ('Y', 'N') then
      return 'Primary Flag must be Y or N.';
    end if;
    if upper(trim(p_include_yn)) = 'Y' and trim(p_location_code) is null then
      return 'Location Code is required for included site uses.';
    end if;
    if not parse_num_clean(p_overall_limit, l_ovr) or (l_ovr is not null and l_ovr < 0) then
      return 'Overall Credit Limit must be a non-negative number.';
    end if;
    if not parse_num_clean(p_trx_limit, l_trx) or (l_trx is not null and l_trx < 0) then
      return 'Order Credit Limit must be a non-negative number.';
    end if;
    if l_ovr is not null and l_trx is not null and l_ovr > 0 and l_trx > l_ovr then
      return 'Order Credit Limit (' || l_trx || ') cannot exceed Overall Credit Limit (' || l_ovr || ').';
    end if;
    if not lov_exists('PROFILE_CLASS', p_profile_class) then
      return 'Profile Class "' || trim(p_profile_class) || '" is not an active EBS Profile Class.';
    end if;
    if not lov_exists('COLLECTOR', p_collector) then
      return 'Collector "' || trim(p_collector) || '" is not an active EBS Collector.';
    end if;
    if not lov_exists('PAYMENT_TERM', p_payment_term) then
      return 'Payment Term "' || trim(p_payment_term) || '" is not an active EBS Payment Term.';
    end if;
    if not lov_exists('CURRENCY', p_credit_curr) then
      return 'Credit Currency "' || trim(p_credit_curr) || '" is not an enabled EBS Currency.';
    end if;
    if not lov_exists('WAREHOUSE', p_warehouse_code) then
      return 'Warehouse "' || trim(p_warehouse_code) || '" is not a valid EBS Inventory Organization.';
    end if;
    if not lov_exists('ORDER_TYPE', p_order_type) then
      return 'Order Type "' || trim(p_order_type) || '" is not an active EBS OM Order Type.';
    end if;
    if not lov_exists('PRICE_LIST', p_price_list) then
      return 'Price List "' || trim(p_price_list) || '" is not an active EBS QP Price List.';
    end if;
    if not lov_exists('STATEMENT_CYCLE', p_stmt_cycle) then
      return 'Statement Cycle "' || trim(p_stmt_cycle) || '" is not an active EBS AR Statement Cycle.';
    end if;
    if not lov_exists('DUNNING_SET', p_dunning_set) then
      return 'Dunning Letter Set "' || trim(p_dunning_set) || '" is not an active EBS AR Dunning Letter Set.';
    end if;
    if not lov_exists('AUTOCASH_RULE', p_autocash_rule) then
      return 'AutoCash Rule "' || trim(p_autocash_rule) || '" is not an active EBS AR AutoCash Hierarchy.';
    end if;
    if not lov_exists('GROUPING_RULE', p_grouping_rule) then
      return 'Grouping Rule "' || trim(p_grouping_rule) || '" is not a valid EBS AR AutoInvoice Grouping Rule.';
    end if;
    if not valid_gl_9seg(p_gl_rec) then
      return 'Receivable GL Account must have exactly 9 dot-separated segments (e.g. 010.0000.12100.000...).';
    end if;
    if not valid_gl_9seg(p_gl_rev) then
      return 'Revenue GL Account must have exactly 9 dot-separated segments.';
    end if;
    if not valid_gl_9seg(p_gl_tax) then
      return 'Tax GL Account must have exactly 9 dot-separated segments.';
    end if;
    return null;
  end validate_site_use_row;

  function validate_prof_amt_row(
    p_include_yn      in varchar2,
    p_currency_code   in varchar2,
    p_overall_limit   in varchar2,
    p_trx_limit       in varchar2
  ) return varchar2 is
    l_ovr number;
    l_trx number;
  begin
    if upper(trim(nvl(p_include_yn, 'X'))) not in ('Y', 'N') then
      return 'Include must be Y or N.';
    end if;
    if trim(p_currency_code) is null or not lov_exists('CURRENCY', p_currency_code) then
      return 'Currency "' || trim(p_currency_code) || '" must be a valid enabled EBS Currency.';
    end if;
    if not parse_num_clean(p_overall_limit, l_ovr) or (l_ovr is not null and l_ovr < 0) then
      return 'Overall Credit Limit must be a non-negative number.';
    end if;
    if not parse_num_clean(p_trx_limit, l_trx) or (l_trx is not null and l_trx < 0) then
      return 'Order Credit Limit must be a non-negative number.';
    end if;
    if l_ovr is not null and l_trx is not null and l_ovr > 0 and l_trx > l_ovr then
      return 'Order Credit Limit (' || l_trx || ') cannot exceed Overall Credit Limit (' || l_ovr || ').';
    end if;
    return null;
  end validate_prof_amt_row;

  function validate_contact_row(
    p_include_yn   in varchar2,
    p_primary_flag in varchar2,
    p_first_name   in varchar2,
    p_last_name    in varchar2,
    p_email        in varchar2
  ) return varchar2 is
  begin
    if upper(trim(nvl(p_include_yn, 'X'))) not in ('Y', 'N') then
      return 'Contact Include must be Y or N.';
    end if;
    if upper(trim(nvl(p_primary_flag, 'N'))) not in ('Y', 'N') then
      return 'Primary Flag must be Y or N.';
    end if;
    if upper(trim(p_include_yn)) = 'Y' and trim(p_last_name) is null and trim(p_email) is null then
      return 'Included Contacts must have at least a Last Name or an Email Address.';
    end if;
    if trim(p_email) is not null and not regexp_like(trim(p_email), '^[^@\s]+@[^@\s]+\.[^@\s]+$') then
      return 'Email Address "' || trim(p_email) || '" is not a valid email format (user@domain.com).';
    end if;
    return null;
  end validate_contact_row;

  procedure sync_project_metadata(p_project_id in number) is
  begin
    for r in (
      select p.project_id,
             p.src_org_id,
             p.tgt_org_id,
             src.operating_unit_name as src_ou_name,
             src.ledger_id           as src_ledger_id,
             src.ledger_name         as src_ledger_name,
             src.currency_code       as src_currency_code,
             src.chart_of_accounts_id as src_coa_id,
             tgt.operating_unit_name as tgt_ou_name,
             tgt.ledger_id           as tgt_ledger_id,
             tgt.ledger_name         as tgt_ledger_name,
             tgt.currency_code       as tgt_currency_code,
             tgt.chart_of_accounts_id as tgt_coa_id,
             tgt.legal_entity_id     as tgt_le_id,
             tgt.legal_entity_name   as tgt_le_name
        from xxcr_projects p
        left join xxcr_ebs_ou_cache src on src.org_id = p.src_org_id
        left join xxcr_ebs_ou_cache tgt on tgt.org_id = p.tgt_org_id
       where p.project_id = p_project_id
    ) loop
      update xxcr_projects
         set src_ou_name           = nvl(r.src_ou_name, src_ou_name),
             src_ledger_id         = nvl(r.src_ledger_id, src_ledger_id),
             src_ledger_name       = nvl(r.src_ledger_name, src_ledger_name),
             src_currency_code     = nvl(r.src_currency_code, src_currency_code),
             src_coa_id            = nvl(r.src_coa_id, src_coa_id),
             tgt_ou_name           = case when r.tgt_org_id is null then null else r.tgt_ou_name end,
             tgt_ledger_id         = case when r.tgt_org_id is null then null else r.tgt_ledger_id end,
             tgt_ledger_name       = case when r.tgt_org_id is null then null else r.tgt_ledger_name end,
             tgt_currency_code     = case when r.tgt_org_id is null then null else r.tgt_currency_code end,
             tgt_coa_id            = case when r.tgt_org_id is null then null else r.tgt_coa_id end,
             tgt_legal_entity_id   = case when r.tgt_org_id is null then null else r.tgt_le_id end,
             tgt_legal_entity_name = case when r.tgt_org_id is null then null else r.tgt_le_name end,
             updated_at            = systimestamp
       where project_id = p_project_id;
    end loop;
  end sync_project_metadata;

  procedure update_target_scope(
    p_project_id in number,
    p_tgt_org_id in number default null,
    p_tgt_bsv    in varchar2 default null
  ) is
    l_bsv varchar2(30) := trim(p_tgt_bsv);
  begin
    update xxcr_projects
       set tgt_org_id = p_tgt_org_id,
           tgt_bsv    = l_bsv,
           updated_at = systimestamp
     where project_id = p_project_id;

    sync_project_metadata(p_project_id);

    update xxcr_stg_sites
       set tgt_org_id = p_tgt_org_id,
           updated_at = systimestamp
     where project_id = p_project_id;

    if l_bsv is not null then
      update xxcr_stg_site_uses
         set tgt_gl_rec_concat     = remap_gl_bsv(nvl(tgt_gl_rec_concat, src_gl_rec_concat), l_bsv),
             tgt_gl_rev_concat     = remap_gl_bsv(nvl(tgt_gl_rev_concat, src_gl_rev_concat), l_bsv),
             tgt_gl_tax_concat     = remap_gl_bsv(nvl(tgt_gl_tax_concat, src_gl_tax_concat), l_bsv),
             tgt_gl_freight_concat = remap_gl_bsv(nvl(tgt_gl_freight_concat, src_gl_freight_concat), l_bsv),
             updated_at            = systimestamp
       where project_id = p_project_id;
    else
      -- Target BSV is blank/TBD: restore Segment 1 back to each row's Source BSV while keeping Segment 2..9 edits
      update xxcr_stg_site_uses
         set tgt_gl_rec_concat     = case when src_gl_rec_concat is not null and instr(src_gl_rec_concat, '.') > 1
                                          then remap_gl_bsv(nvl(tgt_gl_rec_concat, src_gl_rec_concat), substr(src_gl_rec_concat, 1, instr(src_gl_rec_concat, '.') - 1))
                                          else nvl(tgt_gl_rec_concat, src_gl_rec_concat) end,
             tgt_gl_rev_concat     = case when src_gl_rev_concat is not null and instr(src_gl_rev_concat, '.') > 1
                                          then remap_gl_bsv(nvl(tgt_gl_rev_concat, src_gl_rev_concat), substr(src_gl_rev_concat, 1, instr(src_gl_rev_concat, '.') - 1))
                                          else nvl(tgt_gl_rev_concat, src_gl_rev_concat) end,
             tgt_gl_tax_concat     = case when src_gl_tax_concat is not null and instr(src_gl_tax_concat, '.') > 1
                                          then remap_gl_bsv(nvl(tgt_gl_tax_concat, src_gl_tax_concat), substr(src_gl_tax_concat, 1, instr(src_gl_tax_concat, '.') - 1))
                                          else nvl(tgt_gl_tax_concat, src_gl_tax_concat) end,
             tgt_gl_freight_concat = case when src_gl_freight_concat is not null and instr(src_gl_freight_concat, '.') > 1
                                          then remap_gl_bsv(nvl(tgt_gl_freight_concat, src_gl_freight_concat), substr(src_gl_freight_concat, 1, instr(src_gl_freight_concat, '.') - 1))
                                          else nvl(tgt_gl_freight_concat, src_gl_freight_concat) end,
             updated_at            = systimestamp
       where project_id = p_project_id;
    end if;

    sync_deltas(p_project_id);
    validate_project(p_project_id);
  end update_target_scope;

  procedure seed_default_project(p_project_id out number) is
    l_id number;
  begin
    select min(project_id) into l_id from xxcr_projects;
    if l_id is not null then
      p_project_id := l_id;
      return;
    end if;

    insert into xxcr_projects (
      project_code,
      project_name,
      description,
      db_link_name,
      src_org_id,
      tgt_org_id,
      tgt_bsv,
      filter_active_months,
      filter_open_ar_only,
      max_customers,
      status
    ) values (
      'AU_AWP_17001_ROLLOUT',
      'Australia AWP (Ledger 17001) to New OU Customer Rollout',
      'Extracts AWP customers, addresses, site uses, GL accounts, credit limits, and contacts from Terex Australia (OU 14474 / Ledger 17001) over @ADG. Target OU and Target BSV are optional until configured.',
      'ADG',
      14474,
      null,
      null,
      24,
      'N',
      null,
      'DRAFT'
    ) returning project_id into l_id;

    sync_project_metadata(l_id);
    p_project_id := l_id;
  end seed_default_project;

  procedure create_project(
    p_project_code    in  varchar2,
    p_project_name    in  varchar2,
    p_src_org_id      in  number,
    p_tgt_org_id      in  number   default null,
    p_tgt_bsv         in  varchar2 default null,
    p_awp_seg7_re     in  varchar2 default '^1[0-9]{3}$',
    p_active_months   in  number   default 24,
    p_description     in  varchar2 default null,
    p_new_project_id  out number
  ) is
    l_code  varchar2(50)  := upper(regexp_replace(trim(p_project_code), '[^A-Za-z0-9_-]+', '_'));
    l_name  varchar2(200) := trim(p_project_name);
    l_bsv   varchar2(30)  := trim(p_tgt_bsv);
    l_re    varchar2(60)  := nvl(trim(p_awp_seg7_re), '^1[0-9]{3}$');
    l_mths  number        := nvl(p_active_months, 24);
    l_cnt   pls_integer;
    l_id    number;
  begin
    if l_code is null or l_name is null or p_src_org_id is null then
      raise_application_error(-20410, 'Project Code, Project Name, and Source Operating Unit are required to create a conversion project.');
    end if;

    select count(*) into l_cnt from xxcr_projects where upper(project_code) = l_code;
    if l_cnt > 0 then
      raise_application_error(-20411, 'A conversion project with Project Code "' || l_code || '" already exists.');
    end if;

    insert into xxcr_projects (
      project_code,
      project_name,
      description,
      db_link_name,
      src_org_id,
      tgt_org_id,
      tgt_bsv,
      filter_active_months,
      filter_open_ar_only,
      filter_awp_seg7_re,
      max_customers,
      status
    ) values (
      l_code,
      l_name,
      nvl(trim(p_description), 'Concurrent Customer OU Rollout project extracted from Source OU ' || p_src_org_id || ' over @ADG.'),
      'ADG',
      p_src_org_id,
      p_tgt_org_id,
      l_bsv,
      l_mths,
      'N',
      l_re,
      null,
      'DRAFT'
    ) returning project_id into l_id;

    sync_project_metadata(l_id);

    begin
      xxcr_security_pkg.log_security_event(
        p_event_code => 'PROJECT_CREATED',
        p_project_id => l_id,
        p_details    => 'Code=' || l_code || '; SrcOrg=' || p_src_org_id || '; TgtOrg=' || nvl(to_char(p_tgt_org_id), 'TBD') || '; TgtBSV=' || nvl(l_bsv, 'TBD')
      );
    exception
      when others then
        null;
    end;

    p_new_project_id := l_id;
  end create_project;

  ------------------------------------------------------------------------------
  -- 3. Core Extract from @ADG (100% DRIVING_SITE Remote Execution)
  --    Extracts ALL Customers, Sites, Site Uses, GL Accounts & Contacts related
  --    to AWP (Segment 7 matching filter_awp_seg7_re, default ^1[0-9]{3}$)
  --    across AR (24M or Open AR), Open Sales Orders, and Active Service/Warranty
  --    Contracts in the Source Ledger / Operating Unit.
  ------------------------------------------------------------------------------
  procedure extract_project_data(p_project_id in number) is
    l_proj xxcr_projects%rowtype;

    type t_num_map is table of number index by varchar2(40);
    type t_str_map is table of varchar2(60) index by varchar2(40);
    type t_id_list is table of number index by pls_integer;

    l_cust_id_map     t_num_map; -- to_char(src_cust_account_id)  -> stg_cust_id
    l_site_id_map     t_num_map; -- to_char(src_cust_acct_site_id)-> stg_site_id
    l_su_scope_map    t_str_map; -- to_char(site_use_id)          -> scope_class
    l_cust_scope_map  t_str_map; -- to_char(cust_account_id)      -> scope_class
    l_seen_cust       t_num_map;
    l_seen_site       t_num_map;
    l_seen_su         t_num_map;

    l_cust_ids        t_id_list;
    l_site_ids        t_id_list;
    l_su_ids          t_id_list;

    type r_scope_remote is record (
      site_use_id         number,
      cust_acct_site_id   number,
      cust_account_id     number,
      bill_to_site_use_id number,
      bill_to_acct_site_id number,
      scope_class         varchar2(60)
    );
    type t_scope_remote_tab is table of r_scope_remote;
    l_scope_remote t_scope_remote_tab;

    type r_cust_remote is record (
      party_id             number,
      party_number         varchar2(30),
      party_name           varchar2(360),
      party_type           varchar2(30),
      tax_reference        varchar2(60),
      jgzz_fiscal_code     varchar2(60),
      duns_number_c        varchar2(30),
      cust_account_id      number,
      account_number       varchar2(30),
      account_name         varchar2(240),
      customer_type        varchar2(30),
      customer_class_code  varchar2(30),
      sales_channel_code   varchar2(30),
      profile_class_id     number,
      profile_class_name   varchar2(60),
      payment_term_id      number,
      payment_term_name    varchar2(60),
      credit_checking      varchar2(1),
      credit_hold          varchar2(1),
      collector_name       varchar2(100),
      credit_currency      varchar2(15),
      overall_credit_limit number,
      trx_credit_limit     number,
      open_ar_amt          number,
      trx_cnt_recent       number,
      last_trx_date        date
    );
    type t_cust_remote_tab is table of r_cust_remote;
    l_cust_remote t_cust_remote_tab;

    type r_site_remote is record (
      cust_account_id      number,
      account_number       varchar2(30),
      cust_acct_site_id    number,
      party_site_id        number,
      party_site_number    varchar2(30),
      party_site_name      varchar2(240),
      location_id          number,
      country              varchar2(60),
      address1             varchar2(240),
      address2             varchar2(240),
      address3             varchar2(240),
      address4             varchar2(240),
      city                 varchar2(60),
      state                varchar2(60),
      province             varchar2(60),
      county               varchar2(60),
      postal_code          varchar2(60),
      ece_tp_location_code varchar2(60),
      customer_category    varchar2(30)
    );
    type t_site_remote_tab is table of r_site_remote;
    l_site_remote t_site_remote_tab;

    type r_su_remote is record (
      cust_account_id       number,
      account_number        varchar2(30),
      cust_acct_site_id     number,
      site_use_id           number,
      site_use_code         varchar2(30),
      location_code         varchar2(40),
      primary_flag          varchar2(1),
      bill_to_site_use_id   number,
      bill_to_location_code varchar2(40),
      payment_term_id       number,
      payment_term_name     varchar2(60),
      salesrep_id           number,
      salesrep_name         varchar2(240),
      order_type_id         number,
      order_type_name       varchar2(100),
      price_list_id         number,
      price_list_name       varchar2(240),
      warehouse_id          number,
      warehouse_code        varchar2(10),
      fob_point             varchar2(30),
      freight_term          varchar2(30),
      tax_code              varchar2(50),
      tax_rounding_rule     varchar2(30),
      tax_header_level_flag varchar2(1),
      gl_id_rec             number,
      gl_rec_concat         varchar2(240),
      gl_id_rev             number,
      gl_rev_concat         varchar2(240),
      gl_id_tax             number,
      gl_tax_concat         varchar2(240),
      gl_id_freight         number,
      gl_freight_concat     varchar2(240),
      profile_class_name    varchar2(60),
      collector_name        varchar2(100),
      credit_checking       varchar2(1),
      credit_hold           varchar2(1),
      credit_currency       varchar2(15),
      overall_credit_limit  number,
      trx_credit_limit      number
    );
    type t_su_remote_tab is table of r_su_remote;
    l_su_remote t_su_remote_tab;

    type r_cnt_remote is record (
      cust_account_id      number,
      account_number       varchar2(30),
      cust_acct_site_id    number,
      cust_account_role_id number,
      rel_party_id         number,
      person_party_id      number,
      org_contact_id       number,
      first_name           varchar2(150),
      last_name            varchar2(150),
      job_title            varchar2(100),
      department           varchar2(60),
      primary_flag         varchar2(1),
      email_address        varchar2(320),
      phone_country_code   varchar2(10),
      phone_area_code      varchar2(10),
      phone_number         varchar2(40),
      phone_extension      varchar2(20)
    );
    type t_cnt_remote_tab is table of r_cnt_remote;
    l_cnt_remote t_cnt_remote_tab;

    l_max_cust      number;
    l_active_months number;
    l_cutoff_date   date;
    l_awp_re        varchar2(60);
    l_name_filter   varchar2(240);
    l_stg_cust_id   number;
    l_stg_site_id   number;
    l_addr_hash     varchar2(64);
    l_first         pls_integer;
    l_last          pls_integer;
    l_csv           varchar2(32767);
    l_sql           clob;

    function build_id_csv(p_list in t_id_list, p_from in pls_integer, p_to in pls_integer) return varchar2 is
      l_res varchar2(32767);
    begin
      for idx in p_from .. p_to loop
        if l_res is not null then
          l_res := l_res || ',';
        end if;
        l_res := l_res || to_char(p_list(idx));
      end loop;
      return l_res;
    end build_id_csv;
  begin
    sync_project_metadata(p_project_id);
    select * into l_proj from xxcr_projects where project_id = p_project_id;

    l_max_cust      := l_proj.max_customers; -- NULL means ALL qualifying customers
    l_active_months := nvl(l_proj.filter_active_months, 24);
    l_cutoff_date   := add_months(trunc(sysdate), -l_active_months);
    l_awp_re        := nvl(trim(l_proj.filter_awp_seg7_re), '^1[0-9]{3}$');
    l_name_filter   := upper(trim(l_proj.filter_cust_name_like));

    -- Clear prior staged data for this project before fresh extract
    delete from xxcr_val_errors    where project_id = p_project_id;
    delete from xxcr_duplicates    where project_id = p_project_id;
    delete from xxcr_stg_contacts  where project_id = p_project_id;
    delete from xxcr_stg_site_uses where project_id = p_project_id;
    delete from xxcr_stg_sites     where project_id = p_project_id;
    delete from xxcr_stg_customers where project_id = p_project_id;

    -- =========================================================================
    -- STEP 0: Single-Pass AWP Scope Discovery on @ADG (/*+ DRIVING_SITE(su) */)
    -- Finds ALL Site Uses, Sites, and Customers in Ledger 17001 / Source OU
    -- with AWP (Segment 7 matching l_awp_re, e.g. 1000-1999) activity in:
    --   1. AR Transactions (within l_active_months or Open AR)
    --   2. Open Sales Order Lines
    --   3. Active Service / Warranty Contracts
    -- =========================================================================
    select /*+ driving_site(su) */
           su.site_use_id,
           cas.cust_acct_site_id,
           cas.cust_account_id,
           su.bill_to_site_use_id,
           su_bt.cust_acct_site_id as bill_to_acct_site_id,
           case when x.other_cnt = 0 then 'AERIALS_ONLY' else 'SHARED' end
           || case when regexp_like(hp.party_name, '(^|[^A-Z])(TEREX|GENIE)([^A-Z]|$)', 'i') then ' / TEREX IC' end as scope_class
      bulk collect into l_scope_remote
      from (
        select su_id,
               sum(aer_cnt) as aerials_cnt,
               sum(oth_cnt) as other_cnt
          from (
            -- 1. AR Revenue Distributions (24M or Open AR) with Segment 7 matching AWP
            select decode(g.n, 1, t.bill_to_site_use_id, t.ship_to_site_use_id) as su_id,
                   sign(t.aer_lines) as aer_cnt,
                   sign(t.oth_lines) as oth_cnt
              from (
                select trx.customer_trx_id,
                       trx.bill_to_site_use_id,
                       trx.ship_to_site_use_id,
                       sum(case when regexp_like(cc.segment7, l_awp_re) then 1 else 0 end) as aer_lines,
                       sum(case when regexp_like(cc.segment7, '^[2-9]') then 1 else 0 end) as oth_lines
                  from apps.ra_customer_trx_all@adg trx,
                       (select customer_trx_id
                          from apps.ar_payment_schedules_all@adg
                         where status = 'OP'
                           and org_id = l_proj.src_org_id
                           and customer_trx_id is not null
                         group by customer_trx_id) op,
                       apps.ra_cust_trx_line_gl_dist_all@adg gd,
                       apps.gl_code_combinations@adg cc
                 where trx.org_id = l_proj.src_org_id
                   and op.customer_trx_id(+) = trx.customer_trx_id
                   and (trx.trx_date >= l_cutoff_date or op.customer_trx_id is not null)
                   and gd.customer_trx_id = trx.customer_trx_id
                   and gd.account_class = 'REV'
                   and gd.account_set_flag = 'N'
                   and cc.code_combination_id = gd.code_combination_id
                 group by trx.customer_trx_id, trx.bill_to_site_use_id, trx.ship_to_site_use_id
              ) t,
              (select 1 as n from sys.dual@adg union all select 2 from sys.dual@adg) g
            union all
            -- 2. Open Sales Order Lines with Item Sales / COGS Segment 7 matching AWP
            select decode(g.n, 1, l.invoice_to_org_id, l.ship_to_org_id) as su_id,
                   case when regexp_like(nvl(cs.segment7, ss.segment7), l_awp_re) then 1 else 0 end as aer_cnt,
                   case when regexp_like(nvl(cs.segment7, ss.segment7), '^[2-9]') then 1 else 0 end as oth_cnt
              from apps.oe_order_lines_all@adg l,
                   apps.mtl_system_items_b@adg msi,
                   apps.gl_code_combinations@adg cs,
                   apps.gl_code_combinations@adg ss,
                   (select 1 as n from sys.dual@adg union all select 2 from sys.dual@adg) g
             where l.org_id = l_proj.src_org_id
               and l.open_flag = 'Y'
               and nvl(l.cancelled_flag, 'N') = 'N'
               and msi.organization_id(+) = l.ship_from_org_id
               and msi.inventory_item_id(+) = l.inventory_item_id
               and cs.code_combination_id(+) = msi.cost_of_sales_account
               and ss.code_combination_id(+) = msi.sales_account
            union all
            -- 3. Active Service & Warranty Contracts with Item COGS Segment 7 matching AWP
            select decode(g.n, 1, k.bill_to_site_use_id, k.ship_to_site_use_id) as su_id,
                   sign(k.aer_cnt) as aer_cnt,
                   sign(k.oth_cnt) as oth_cnt
              from (
                select h.id,
                       h.bill_to_site_use_id,
                       h.ship_to_site_use_id,
                       sum(case when regexp_like(cc.segment7, l_awp_re) then 1 else 0 end) as aer_cnt,
                       sum(case when regexp_like(cc.segment7, '^[2-9]') then 1 else 0 end) as oth_cnt
                  from apps.okc_k_headers_all_b@adg h,
                       apps.okc_statuses_b@adg st,
                       apps.okc_k_items@adg ki,
                       apps.csi_item_instances@adg cii,
                       apps.mtl_system_items_b@adg msi,
                       apps.gl_code_combinations@adg cc
                 where h.authoring_org_id = l_proj.src_org_id
                   and h.scs_code in ('SERVICE', 'WARRANTY')
                   and st.code = h.sts_code
                   and st.ste_code in ('ACTIVE', 'SIGNED', 'ENTERED', 'HOLD')
                   and nvl(h.end_date, sysdate) >= trunc(sysdate)
                   and ki.dnz_chr_id = h.id
                   and ki.jtot_object1_code = 'OKX_CUSTPROD'
                   and cii.instance_id = to_number(ki.object1_id1)
                   and msi.inventory_item_id(+) = cii.inventory_item_id
                   and msi.organization_id(+) = cii.last_vld_organization_id
                   and cc.code_combination_id(+) = msi.cost_of_sales_account
                 group by h.id, h.bill_to_site_use_id, h.ship_to_site_use_id
              ) k,
              (select 1 as n from sys.dual@adg union all select 2 from sys.dual@adg) g
          )
         where su_id is not null
         group by su_id
        having sum(aer_cnt) > 0
      ) x
      join apps.hz_cust_site_uses_all@adg su
        on su.site_use_id = x.su_id
      join apps.hz_cust_acct_sites_all@adg cas
        on cas.cust_acct_site_id = su.cust_acct_site_id
      join apps.hz_cust_accounts@adg ca
        on ca.cust_account_id = cas.cust_account_id
      join apps.hz_parties@adg hp
        on hp.party_id = ca.party_id
      left join apps.hz_cust_site_uses_all@adg su_bt
        on su_bt.site_use_id = su.bill_to_site_use_id
       and su_bt.org_id = l_proj.src_org_id
     where (l_name_filter is null or upper(hp.party_name) like '%' || l_name_filter || '%' or upper(ca.account_number) like '%' || l_name_filter || '%');

    -- Build deduplicated ID lists in memory (respecting optional l_max_cust cap if set)
    for i in 1 .. l_scope_remote.count loop
      declare
        l_cid_key varchar2(40) := to_char(l_scope_remote(i).cust_account_id);
        l_sid_key varchar2(40) := to_char(l_scope_remote(i).cust_acct_site_id);
        l_uid_key varchar2(40) := to_char(l_scope_remote(i).site_use_id);
      begin
        if not l_seen_cust.exists(l_cid_key) then
          if l_max_cust is null or l_cust_ids.count < l_max_cust then
            l_seen_cust(l_cid_key) := 1;
            l_cust_ids(l_cust_ids.count + 1) := l_scope_remote(i).cust_account_id;
            l_cust_scope_map(l_cid_key) := l_scope_remote(i).scope_class;
          end if;
        elsif l_scope_remote(i).scope_class like 'SHARED%' then
          l_cust_scope_map(l_cid_key) := l_scope_remote(i).scope_class;
        end if;

        if l_seen_cust.exists(l_cid_key) then
          if not l_seen_site.exists(l_sid_key) then
            l_seen_site(l_sid_key) := 1;
            l_site_ids(l_site_ids.count + 1) := l_scope_remote(i).cust_acct_site_id;
          end if;
          if not l_seen_su.exists(l_uid_key) then
            l_seen_su(l_uid_key) := 1;
            l_su_ids(l_su_ids.count + 1) := l_scope_remote(i).site_use_id;
            l_su_scope_map(l_uid_key) := l_scope_remote(i).scope_class;
          end if;
          -- Also include referenced Bill-To site use & site if present in same OU
          if l_scope_remote(i).bill_to_site_use_id is not null and l_scope_remote(i).bill_to_acct_site_id is not null then
            if not l_seen_site.exists(to_char(l_scope_remote(i).bill_to_acct_site_id)) then
              l_seen_site(to_char(l_scope_remote(i).bill_to_acct_site_id)) := 1;
              l_site_ids(l_site_ids.count + 1) := l_scope_remote(i).bill_to_acct_site_id;
            end if;
            if not l_seen_su.exists(to_char(l_scope_remote(i).bill_to_site_use_id)) then
              l_seen_su(to_char(l_scope_remote(i).bill_to_site_use_id)) := 1;
              l_su_ids(l_su_ids.count + 1) := l_scope_remote(i).bill_to_site_use_id;
              l_su_scope_map(to_char(l_scope_remote(i).bill_to_site_use_id)) := l_scope_remote(i).scope_class;
            end if;
          end if;
        end if;
      end;
    end loop;

    if l_cust_ids.count = 0 then
      update xxcr_projects
         set status = 'EXTRACTED',
             last_extract_at = systimestamp
       where project_id = p_project_id;
      return;
    end if;

    -- =========================================================================
    -- STEP 1: Batch-Extract AWP Customers & Account Profiles (@ADG DRIVING_SITE)
    -- =========================================================================
    l_first := 1;
    while l_first <= l_cust_ids.count loop
      l_last := least(l_first + 499, l_cust_ids.count);
      l_csv  := build_id_csv(l_cust_ids, l_first, l_last);

      l_sql := replace(to_clob(q'~
        select /*+ driving_site(hca) */
               hp.party_id,
               hp.party_number,
               hp.party_name,
               hp.party_type,
               hp.tax_reference,
               hp.jgzz_fiscal_code,
               hp.duns_number_c,
               hca.cust_account_id,
               hca.account_number,
               hca.account_name,
               hca.customer_type,
               hca.customer_class_code,
               hca.sales_channel_code,
               hcp.profile_class_id,
               hcpc.name as profile_class_name,
               hcp.standard_terms as payment_term_id,
               rt.name as payment_term_name,
               hcp.credit_checking,
               hcp.credit_hold,
               ac.name as collector_name,
               hcpa.currency_code as credit_currency,
               hcpa.overall_credit_limit,
               hcpa.trx_credit_limit,
               nvl(ar_act.open_ar_amt, 0) as open_ar_amt,
               nvl(ar_act.trx_cnt, 0) as trx_cnt_recent,
               ar_act.last_trx_date
          from apps.hz_cust_accounts@adg hca
          join apps.hz_parties@adg hp
            on hp.party_id = hca.party_id
          left join apps.hz_customer_profiles@adg hcp
            on hcp.cust_account_id = hca.cust_account_id
           and hcp.site_use_id is null
           and hcp.status = 'A'
          left join apps.hz_cust_profile_classes@adg hcpc
            on hcpc.profile_class_id = hcp.profile_class_id
          left join apps.ra_terms_tl@adg rt
            on rt.term_id = hcp.standard_terms
           and rt.language = 'US'
          left join apps.ar_collectors@adg ac
            on ac.collector_id = hcp.collector_id
          left join (
            select cust_account_id,
                   max(currency_code) keep (dense_rank first order by decode(currency_code, :src_curr, 1, 2), cust_acct_profile_amt_id) as currency_code,
                   max(overall_credit_limit) keep (dense_rank first order by decode(currency_code, :src_curr, 1, 2), cust_acct_profile_amt_id) as overall_credit_limit,
                   max(trx_credit_limit) keep (dense_rank first order by decode(currency_code, :src_curr, 1, 2), cust_acct_profile_amt_id) as trx_credit_limit
              from apps.hz_cust_profile_amts@adg
             where site_use_id is null
               and cust_account_id in (#IDS#)
             group by cust_account_id
          ) hcpa
            on hcpa.cust_account_id = hca.cust_account_id
          left join (
            select customer_id as cust_account_id,
                   sum(amount_due_remaining) as open_ar_amt,
                   count(distinct customer_trx_id) as trx_cnt,
                   max(trx_date) as last_trx_date
              from apps.ar_payment_schedules_all@adg
             where org_id = :src_org_id
               and customer_id in (#IDS#)
               and (trx_date >= :cutoff_dt or amount_due_remaining <> 0)
             group by customer_id
          ) ar_act
            on ar_act.cust_account_id = hca.cust_account_id
         where hca.cust_account_id in (#IDS#)
      ~'), '#IDS#', l_csv);

      execute immediate l_sql
        bulk collect into l_cust_remote
        using l_proj.src_currency_code, l_proj.src_currency_code, l_proj.src_currency_code,
              l_proj.src_org_id, l_cutoff_date;

      for i in 1 .. l_cust_remote.count loop
        insert into xxcr_stg_customers (
          project_id,
          include_yn,
          action_code,
          scope_class,
          src_party_id,
          src_party_number,
          src_party_name,
          src_party_type,
          src_tax_reference,
          src_jgzz_fiscal_code,
          src_duns_number,
          src_cust_account_id,
          src_account_number,
          src_account_name,
          src_customer_type,
          src_customer_class_code,
          src_sales_channel_code,
          src_profile_class_id,
          src_profile_class_name,
          src_payment_term_id,
          src_payment_term_name,
          src_credit_checking,
          src_credit_hold,
          src_collector_name,
          src_credit_currency,
          src_overall_credit_limit,
          src_trx_credit_limit,
          src_open_ar_amt,
          src_trx_cnt_recent,
          src_last_trx_date,
          tgt_account_number,
          tgt_party_name,
          tgt_account_name,
          tgt_tax_reference,
          tgt_customer_class_code,
          tgt_sales_channel_code,
          tgt_profile_class_name,
          tgt_payment_term_name,
          tgt_credit_checking,
          tgt_credit_hold,
          tgt_collector_name,
          tgt_credit_currency,
          tgt_overall_credit_limit,
          tgt_trx_credit_limit,
          norm_party_name,
          val_status
        ) values (
          p_project_id,
          'Y',
          'EXTEND_OU',
          l_cust_scope_map(to_char(l_cust_remote(i).cust_account_id)),
          l_cust_remote(i).party_id,
          l_cust_remote(i).party_number,
          l_cust_remote(i).party_name,
          l_cust_remote(i).party_type,
          l_cust_remote(i).tax_reference,
          l_cust_remote(i).jgzz_fiscal_code,
          l_cust_remote(i).duns_number_c,
          l_cust_remote(i).cust_account_id,
          l_cust_remote(i).account_number,
          l_cust_remote(i).account_name,
          l_cust_remote(i).customer_type,
          l_cust_remote(i).customer_class_code,
          l_cust_remote(i).sales_channel_code,
          l_cust_remote(i).profile_class_id,
          l_cust_remote(i).profile_class_name,
          l_cust_remote(i).payment_term_id,
          l_cust_remote(i).payment_term_name,
          l_cust_remote(i).credit_checking,
          l_cust_remote(i).credit_hold,
          l_cust_remote(i).collector_name,
          l_cust_remote(i).credit_currency,
          l_cust_remote(i).overall_credit_limit,
          l_cust_remote(i).trx_credit_limit,
          l_cust_remote(i).open_ar_amt,
          l_cust_remote(i).trx_cnt_recent,
          l_cust_remote(i).last_trx_date,
          l_cust_remote(i).account_number,
          l_cust_remote(i).party_name,
          l_cust_remote(i).account_name,
          l_cust_remote(i).tax_reference,
          l_cust_remote(i).customer_class_code,
          l_cust_remote(i).sales_channel_code,
          nvl(l_cust_remote(i).profile_class_name, 'DEFAULT'),
          l_cust_remote(i).payment_term_name,
          nvl(l_cust_remote(i).credit_checking, 'Y'),
          nvl(l_cust_remote(i).credit_hold, 'N'),
          l_cust_remote(i).collector_name,
          coalesce(l_cust_remote(i).credit_currency, l_proj.src_currency_code, l_proj.tgt_currency_code),
          l_cust_remote(i).overall_credit_limit,
          l_cust_remote(i).trx_credit_limit,
          normalize_party_name(l_cust_remote(i).party_name),
          'PENDING'
        ) returning stg_cust_id into l_stg_cust_id;

        l_cust_id_map(to_char(l_cust_remote(i).cust_account_id)) := l_stg_cust_id;
      end loop;

      l_first := l_last + 1;
    end loop;

    -- =========================================================================
    -- STEP 2: Batch-Extract AWP Customer Sites & Locations (@ADG DRIVING_SITE)
    -- =========================================================================
    l_first := 1;
    while l_first <= l_site_ids.count loop
      l_last := least(l_first + 499, l_site_ids.count);
      l_csv  := build_id_csv(l_site_ids, l_first, l_last);

      l_sql := replace(to_clob(q'~
        select /*+ driving_site(hcasa) */
               hcasa.cust_account_id,
               hca.account_number,
               hcasa.cust_acct_site_id,
               hcasa.party_site_id,
               hps.party_site_number,
               hps.party_site_name,
               hps.location_id,
               hl.country,
               hl.address1,
               hl.address2,
               hl.address3,
               hl.address4,
               hl.city,
               hl.state,
               hl.province,
               hl.county,
               hl.postal_code,
               hcasa.ece_tp_location_code,
               hcasa.customer_category_code
          from apps.hz_cust_acct_sites_all@adg hcasa
          join apps.hz_cust_accounts@adg hca
            on hca.cust_account_id = hcasa.cust_account_id
          join apps.hz_party_sites@adg hps
            on hps.party_site_id = hcasa.party_site_id
          join apps.hz_locations@adg hl
            on hl.location_id = hps.location_id
         where hcasa.cust_acct_site_id in (#IDS#)
      ~'), '#IDS#', l_csv);

      execute immediate l_sql bulk collect into l_site_remote;

      for i in 1 .. l_site_remote.count loop
        if l_cust_id_map.exists(to_char(l_site_remote(i).cust_account_id)) then
          l_stg_cust_id := l_cust_id_map(to_char(l_site_remote(i).cust_account_id));
          l_addr_hash := compute_addr_hash(
            l_site_remote(i).country,
            l_site_remote(i).address1,
            l_site_remote(i).address2,
            l_site_remote(i).address3,
            l_site_remote(i).address4,
            l_site_remote(i).city,
            l_site_remote(i).state,
            l_site_remote(i).province,
            l_site_remote(i).county,
            l_site_remote(i).postal_code
          );

          insert into xxcr_stg_sites (
            project_id,
            stg_cust_id,
            include_yn,
            site_ref_code,
            address_mode,
            src_cust_account_id,
            src_account_number,
            src_cust_acct_site_id,
            src_party_site_id,
            src_party_site_number,
            src_party_site_name,
            src_location_id,
            src_country,
            src_address1,
            src_address2,
            src_address3,
            src_address4,
            src_city,
            src_state,
            src_province,
            src_county,
            src_postal_code,
            src_ece_tp_location_code,
            src_customer_category,
            src_addr_hash,
            tgt_account_number,
            tgt_org_id,
            tgt_party_site_number,
            tgt_party_site_name,
            tgt_country,
            tgt_address1,
            tgt_address2,
            tgt_address3,
            tgt_address4,
            tgt_city,
            tgt_state,
            tgt_province,
            tgt_county,
            tgt_postal_code,
            tgt_ece_tp_location_code,
            tgt_customer_category,
            norm_address_key,
            addr_changed_yn,
            val_status
          ) values (
            p_project_id,
            l_stg_cust_id,
            'Y',
            'SITE-' || l_site_remote(i).cust_acct_site_id,
            'REUSE_PARTY_SITE',
            l_site_remote(i).cust_account_id,
            l_site_remote(i).account_number,
            l_site_remote(i).cust_acct_site_id,
            l_site_remote(i).party_site_id,
            l_site_remote(i).party_site_number,
            l_site_remote(i).party_site_name,
            l_site_remote(i).location_id,
            l_site_remote(i).country,
            l_site_remote(i).address1,
            l_site_remote(i).address2,
            l_site_remote(i).address3,
            l_site_remote(i).address4,
            l_site_remote(i).city,
            l_site_remote(i).state,
            l_site_remote(i).province,
            l_site_remote(i).county,
            l_site_remote(i).postal_code,
            l_site_remote(i).ece_tp_location_code,
            l_site_remote(i).customer_category,
            l_addr_hash,
            l_site_remote(i).account_number,
            l_proj.tgt_org_id,
            l_site_remote(i).party_site_number,
            l_site_remote(i).party_site_name,
            l_site_remote(i).country,
            l_site_remote(i).address1,
            l_site_remote(i).address2,
            l_site_remote(i).address3,
            l_site_remote(i).address4,
            l_site_remote(i).city,
            l_site_remote(i).state,
            l_site_remote(i).province,
            l_site_remote(i).county,
            l_site_remote(i).postal_code,
            l_site_remote(i).ece_tp_location_code,
            l_site_remote(i).customer_category,
            normalize_address_key(
              l_site_remote(i).country,
              l_site_remote(i).address1,
              l_site_remote(i).city,
              l_site_remote(i).state,
              l_site_remote(i).postal_code
            ),
            'N',
            'PENDING'
          ) returning stg_site_id into l_stg_site_id;

          l_site_id_map(to_char(l_site_remote(i).cust_acct_site_id)) := l_stg_site_id;
        end if;
      end loop;

      l_first := l_last + 1;
    end loop;

    -- =========================================================================
    -- STEP 3: Batch-Extract AWP Site Uses & GL Accounts (@ADG DRIVING_SITE)
    -- =========================================================================
    l_first := 1;
    while l_first <= l_su_ids.count loop
      l_last := least(l_first + 499, l_su_ids.count);
      l_csv  := build_id_csv(l_su_ids, l_first, l_last);

      l_sql := replace(to_clob(q'~
        select /*+ driving_site(hcsua) */
               hcasa.cust_account_id,
               hca.account_number,
               hcasa.cust_acct_site_id,
               hcsua.site_use_id,
               hcsua.site_use_code,
               hcsua.location as location_code,
               hcsua.primary_flag,
               hcsua.bill_to_site_use_id,
               hcsua_bt.location as bill_to_location_code,
               coalesce(hcsua.payment_term_id, hcp_su.standard_terms) as payment_term_id,
               coalesce(rt.name, rt_prof.name) as payment_term_name,
               hcsua.primary_salesrep_id,
               jrs.name as salesrep_name,
               hcsua.order_type_id,
               ott.name as order_type_name,
               hcsua.price_list_id,
               qlh.name as price_list_name,
               hcsua.warehouse_id,
               mp.organization_code as warehouse_code,
               hcsua.fob_point,
               hcsua.freight_term,
               hcsua.tax_code,
               hcsua.tax_rounding_rule,
               hcsua.tax_header_level_flag,
               hcsua.gl_id_rec,
               gcc_rec.concatenated_segments as gl_rec_concat,
               hcsua.gl_id_rev,
               gcc_rev.concatenated_segments as gl_rev_concat,
               hcsua.gl_id_tax,
               gcc_tax.concatenated_segments as gl_tax_concat,
               hcsua.gl_id_freight,
               gcc_frt.concatenated_segments as gl_freight_concat,
               hcpc_su.name as profile_class_name,
               ac_su.name as collector_name,
               hcp_su.credit_checking,
               hcp_su.credit_hold,
               hcpa_su.currency_code as credit_currency,
               hcpa_su.overall_credit_limit,
               hcpa_su.trx_credit_limit
          from apps.hz_cust_site_uses_all@adg hcsua
          join apps.hz_cust_acct_sites_all@adg hcasa
            on hcasa.cust_acct_site_id = hcsua.cust_acct_site_id
          join apps.hz_cust_accounts@adg hca
            on hca.cust_account_id = hcasa.cust_account_id
          left join apps.hz_cust_site_uses_all@adg hcsua_bt
            on hcsua_bt.site_use_id = hcsua.bill_to_site_use_id
          left join apps.ra_terms_tl@adg rt
            on rt.term_id = hcsua.payment_term_id
           and rt.language = 'US'
          left join apps.hz_customer_profiles@adg hcp_su
            on hcp_su.site_use_id = hcsua.site_use_id
           and hcp_su.status = 'A'
          left join apps.hz_cust_profile_classes@adg hcpc_su
            on hcpc_su.profile_class_id = hcp_su.profile_class_id
          left join apps.ar_collectors@adg ac_su
            on ac_su.collector_id = hcp_su.collector_id
          left join apps.ra_terms_tl@adg rt_prof
            on rt_prof.term_id = hcp_su.standard_terms
           and rt_prof.language = 'US'
          left join (
            select site_use_id,
                   max(currency_code) keep (
                     dense_rank first order by decode(currency_code, :src_curr, 1, 2), nvl(overall_credit_limit, -1) desc, cust_acct_profile_amt_id
                   ) as currency_code,
                   max(overall_credit_limit) keep (
                     dense_rank first order by decode(currency_code, :src_curr, 1, 2), nvl(overall_credit_limit, -1) desc, cust_acct_profile_amt_id
                   ) as overall_credit_limit,
                   max(trx_credit_limit) keep (
                     dense_rank first order by decode(currency_code, :src_curr, 1, 2), nvl(overall_credit_limit, -1) desc, cust_acct_profile_amt_id
                   ) as trx_credit_limit
              from apps.hz_cust_profile_amts@adg
             where site_use_id in (#IDS#)
             group by site_use_id
          ) hcpa_su
            on hcpa_su.site_use_id = hcsua.site_use_id
          left join apps.jtf_rs_salesreps@adg jrs
            on jrs.salesrep_id = hcsua.primary_salesrep_id
           and jrs.org_id = hcsua.org_id
          left join apps.oe_transaction_types_tl@adg ott
            on ott.transaction_type_id = hcsua.order_type_id
           and ott.language = 'US'
          left join apps.qp_list_headers_tl@adg qlh
            on qlh.list_header_id = hcsua.price_list_id
           and qlh.language = 'US'
          left join apps.mtl_parameters@adg mp
            on mp.organization_id = hcsua.warehouse_id
          left join apps.gl_code_combinations_kfv@adg gcc_rec
            on gcc_rec.code_combination_id = hcsua.gl_id_rec
          left join apps.gl_code_combinations_kfv@adg gcc_rev
            on gcc_rev.code_combination_id = hcsua.gl_id_rev
          left join apps.gl_code_combinations_kfv@adg gcc_tax
            on gcc_tax.code_combination_id = hcsua.gl_id_tax
          left join apps.gl_code_combinations_kfv@adg gcc_frt
            on gcc_frt.code_combination_id = hcsua.gl_id_freight
         where hcsua.site_use_id in (#IDS#)
      ~'), '#IDS#', l_csv);

      execute immediate l_sql
        bulk collect into l_su_remote
        using l_proj.src_currency_code, l_proj.src_currency_code, l_proj.src_currency_code;

      for i in 1 .. l_su_remote.count loop
        if l_site_id_map.exists(to_char(l_su_remote(i).cust_acct_site_id))
           and l_cust_id_map.exists(to_char(l_su_remote(i).cust_account_id)) then
          declare
            l_su_scope varchar2(60) := 'AERIALS_ONLY';
          begin
            if l_su_scope_map.exists(to_char(l_su_remote(i).site_use_id)) then
              l_su_scope := l_su_scope_map(to_char(l_su_remote(i).site_use_id));
            end if;
            insert into xxcr_stg_site_uses (
              project_id,
              stg_cust_id,
              stg_site_id,
              include_yn,
              scope_class,
              site_ref_code,
              src_account_number,
              src_site_use_id,
              src_site_use_code,
              src_location_code,
              src_primary_flag,
              src_bill_to_site_use_id,
              src_bill_to_location_code,
              src_payment_term_id,
              src_payment_term_name,
              src_salesrep_id,
              src_salesrep_name,
              src_order_type_id,
              src_order_type_name,
              src_price_list_id,
              src_price_list_name,
              src_warehouse_id,
              src_warehouse_code,
              src_fob_point,
              src_freight_term,
              src_tax_code,
              src_tax_rounding_rule,
              src_tax_header_level_flag,
              src_gl_id_rec,
              src_gl_rec_concat,
              src_gl_id_rev,
              src_gl_rev_concat,
              src_gl_id_tax,
              src_gl_tax_concat,
              src_gl_id_freight,
              src_gl_freight_concat,
              src_profile_class_name,
              src_collector_name,
              src_credit_checking,
              src_credit_hold,
              src_credit_currency,
              src_overall_credit_limit,
              src_trx_credit_limit,
              tgt_account_number,
              tgt_site_use_code,
              tgt_location_code,
              tgt_primary_flag,
              tgt_bill_to_location_code,
              tgt_payment_term_name,
              tgt_salesrep_name,
              tgt_order_type_name,
              tgt_price_list_name,
              tgt_warehouse_code,
              tgt_fob_point,
              tgt_freight_term,
              tgt_tax_code,
              tgt_tax_rounding_rule,
              tgt_tax_header_level_flag,
              tgt_gl_rec_concat,
              tgt_gl_rev_concat,
              tgt_gl_tax_concat,
              tgt_gl_freight_concat,
              tgt_profile_class_name,
              tgt_collector_name,
              tgt_credit_checking,
              tgt_credit_hold,
              tgt_credit_currency,
              tgt_overall_credit_limit,
              tgt_trx_credit_limit,
              val_status
            ) values (
              p_project_id,
              l_cust_id_map(to_char(l_su_remote(i).cust_account_id)),
              l_site_id_map(to_char(l_su_remote(i).cust_acct_site_id)),
              'Y',
              l_su_scope,
              'SITE-' || l_su_remote(i).cust_acct_site_id,
              l_su_remote(i).account_number,
              l_su_remote(i).site_use_id,
              l_su_remote(i).site_use_code,
              l_su_remote(i).location_code,
              l_su_remote(i).primary_flag,
              l_su_remote(i).bill_to_site_use_id,
              l_su_remote(i).bill_to_location_code,
              l_su_remote(i).payment_term_id,
              l_su_remote(i).payment_term_name,
              l_su_remote(i).salesrep_id,
              l_su_remote(i).salesrep_name,
              l_su_remote(i).order_type_id,
              l_su_remote(i).order_type_name,
              l_su_remote(i).price_list_id,
              l_su_remote(i).price_list_name,
              l_su_remote(i).warehouse_id,
              l_su_remote(i).warehouse_code,
              l_su_remote(i).fob_point,
              l_su_remote(i).freight_term,
              l_su_remote(i).tax_code,
              l_su_remote(i).tax_rounding_rule,
              l_su_remote(i).tax_header_level_flag,
              l_su_remote(i).gl_id_rec,
              l_su_remote(i).gl_rec_concat,
              l_su_remote(i).gl_id_rev,
              l_su_remote(i).gl_rev_concat,
              l_su_remote(i).gl_id_tax,
              l_su_remote(i).gl_tax_concat,
              l_su_remote(i).gl_id_freight,
              l_su_remote(i).gl_freight_concat,
              l_su_remote(i).profile_class_name,
              l_su_remote(i).collector_name,
              l_su_remote(i).credit_checking,
              l_su_remote(i).credit_hold,
              l_su_remote(i).credit_currency,
              l_su_remote(i).overall_credit_limit,
              l_su_remote(i).trx_credit_limit,
              l_su_remote(i).account_number,
              l_su_remote(i).site_use_code,
              l_su_remote(i).location_code,
              l_su_remote(i).primary_flag,
              l_su_remote(i).bill_to_location_code,
              l_su_remote(i).payment_term_name,
              l_su_remote(i).salesrep_name,
              l_su_remote(i).order_type_name,
              l_su_remote(i).price_list_name,
              l_su_remote(i).warehouse_code,
              l_su_remote(i).fob_point,
              l_su_remote(i).freight_term,
              l_su_remote(i).tax_code,
              l_su_remote(i).tax_rounding_rule,
              l_su_remote(i).tax_header_level_flag,
              remap_gl_bsv(l_su_remote(i).gl_rec_concat, l_proj.tgt_bsv),
              remap_gl_bsv(l_su_remote(i).gl_rev_concat, l_proj.tgt_bsv),
              remap_gl_bsv(l_su_remote(i).gl_tax_concat, l_proj.tgt_bsv),
              remap_gl_bsv(l_su_remote(i).gl_freight_concat, l_proj.tgt_bsv),
              l_su_remote(i).profile_class_name,
              l_su_remote(i).collector_name,
              l_su_remote(i).credit_checking,
              l_su_remote(i).credit_hold,
              l_su_remote(i).credit_currency,
              l_su_remote(i).overall_credit_limit,
              l_su_remote(i).trx_credit_limit,
              'PENDING'
            );
          end;
        end if;
      end loop;

      l_first := l_last + 1;
    end loop;

    -- Roll up Source OU Primary BILL_TO Credit Profile & Credit Limits onto Customer Accounts
    -- (In Terex Multi-OU EBS, OU-specific Credit Limits, Collectors, Terms & Profile Classes live on BILL_TO Site-Use Profiles)
    merge into xxcr_stg_customers c
    using (
      select stg_cust_id,
             max(src_profile_class_name)   keep (dense_rank first order by decode(src_primary_flag,'Y',1,2), nvl(src_overall_credit_limit,-1) desc, stg_site_use_id) as bt_prof_class,
             max(src_payment_term_name)    keep (dense_rank first order by decode(src_primary_flag,'Y',1,2), nvl(src_overall_credit_limit,-1) desc, stg_site_use_id) as bt_pay_term,
             max(src_collector_name)       keep (dense_rank first order by decode(src_primary_flag,'Y',1,2), nvl(src_overall_credit_limit,-1) desc, stg_site_use_id) as bt_collector,
             max(src_credit_checking)      keep (dense_rank first order by decode(src_primary_flag,'Y',1,2), nvl(src_overall_credit_limit,-1) desc, stg_site_use_id) as bt_cred_chk,
             max(src_credit_hold)          keep (dense_rank first order by decode(src_primary_flag,'Y',1,2), nvl(src_overall_credit_limit,-1) desc, stg_site_use_id) as bt_cred_hold,
             max(src_credit_currency)      keep (dense_rank first order by decode(src_primary_flag,'Y',1,2), nvl(src_overall_credit_limit,-1) desc, stg_site_use_id) as bt_curr,
             max(src_overall_credit_limit) keep (dense_rank first order by decode(src_primary_flag,'Y',1,2), nvl(src_overall_credit_limit,-1) desc, stg_site_use_id) as bt_overall_lim,
             max(src_trx_credit_limit)     keep (dense_rank first order by decode(src_primary_flag,'Y',1,2), nvl(src_overall_credit_limit,-1) desc, stg_site_use_id) as bt_trx_lim
        from xxcr_stg_site_uses
       where project_id = p_project_id
         and src_site_use_code = 'BILL_TO'
       group by stg_cust_id
    ) bt
       on (c.stg_cust_id = bt.stg_cust_id)
     when matched then update
       set c.src_profile_class_name   = coalesce(bt.bt_prof_class, c.src_profile_class_name),
           c.tgt_profile_class_name   = coalesce(bt.bt_prof_class, c.tgt_profile_class_name),
           c.src_payment_term_name    = coalesce(bt.bt_pay_term, c.src_payment_term_name),
           c.tgt_payment_term_name    = coalesce(bt.bt_pay_term, c.tgt_payment_term_name),
           c.src_collector_name       = coalesce(bt.bt_collector, c.src_collector_name),
           c.tgt_collector_name       = coalesce(bt.bt_collector, c.tgt_collector_name),
           c.src_credit_checking      = coalesce(bt.bt_cred_chk, c.src_credit_checking),
           c.tgt_credit_checking      = coalesce(bt.bt_cred_chk, c.tgt_credit_checking),
           c.src_credit_hold          = coalesce(bt.bt_cred_hold, c.src_credit_hold),
           c.tgt_credit_hold          = coalesce(bt.bt_cred_hold, c.tgt_credit_hold),
           c.src_credit_currency      = coalesce(bt.bt_curr, c.src_credit_currency),
           c.tgt_credit_currency      = coalesce(bt.bt_curr, c.tgt_credit_currency),
           c.src_overall_credit_limit = coalesce(bt.bt_overall_lim, c.src_overall_credit_limit),
           c.tgt_overall_credit_limit = coalesce(bt.bt_overall_lim, c.tgt_overall_credit_limit),
           c.src_trx_credit_limit     = coalesce(bt.bt_trx_lim, c.src_trx_credit_limit),
           c.tgt_trx_credit_limit     = coalesce(bt.bt_trx_lim, c.tgt_trx_credit_limit);

    -- =========================================================================
    -- STEP 4: Batch-Extract AWP Contacts, Roles & Contact Points (@ADG DRIVING_SITE)
    -- =========================================================================
    l_first := 1;
    while l_first <= l_site_ids.count loop
      l_last := least(l_first + 499, l_site_ids.count);
      l_csv  := build_id_csv(l_site_ids, l_first, l_last);

      l_sql := replace(to_clob(q'~
        select /*+ driving_site(hcasa) */
               hcasa.cust_account_id,
               max(hca.account_number) as account_number,
               hcasa.cust_acct_site_id,
               hcar.cust_account_role_id,
               hcar.party_id as rel_party_id,
               max(hr.subject_id) as person_party_id,
               max(hoc.org_contact_id) as org_contact_id,
               max(hp_per.person_first_name) as first_name,
               max(hp_per.person_last_name) as last_name,
               max(hoc.job_title) as job_title,
               max(hoc.department) as department,
               max(hcar.primary_flag) as primary_flag,
               max(case when hcp.contact_point_type = 'EMAIL' then hcp.email_address end)
                 keep (dense_rank first order by case when hcp.contact_point_type = 'EMAIL' then decode(hcp.primary_flag,'Y',1,2) else 9 end, hcp.contact_point_id) as email_address,
               max(case when hcp.contact_point_type = 'PHONE' then hcp.phone_country_code end)
                 keep (dense_rank first order by case when hcp.contact_point_type = 'PHONE' then decode(hcp.primary_flag,'Y',1,2) else 9 end, hcp.contact_point_id) as phone_country_code,
               max(case when hcp.contact_point_type = 'PHONE' then hcp.phone_area_code end)
                 keep (dense_rank first order by case when hcp.contact_point_type = 'PHONE' then decode(hcp.primary_flag,'Y',1,2) else 9 end, hcp.contact_point_id) as phone_area_code,
               max(case when hcp.contact_point_type = 'PHONE' then hcp.phone_number end)
                 keep (dense_rank first order by case when hcp.contact_point_type = 'PHONE' then decode(hcp.primary_flag,'Y',1,2) else 9 end, hcp.contact_point_id) as phone_number,
               max(case when hcp.contact_point_type = 'PHONE' then hcp.phone_extension end)
                 keep (dense_rank first order by case when hcp.contact_point_type = 'PHONE' then decode(hcp.primary_flag,'Y',1,2) else 9 end, hcp.contact_point_id) as phone_extension
          from apps.hz_cust_acct_sites_all@adg hcasa
          join apps.hz_cust_accounts@adg hca
            on hca.cust_account_id = hcasa.cust_account_id
          join apps.hz_cust_account_roles@adg hcar
            on hcar.cust_acct_site_id = hcasa.cust_acct_site_id
           and hcar.status = 'A'
          join apps.hz_relationships@adg hr
            on hr.party_id = hcar.party_id
           and hr.subject_type = 'PERSON'
           and hr.object_type = 'ORGANIZATION'
           and hr.directional_flag = 'F'
           and hr.status = 'A'
          join apps.hz_parties@adg hp_per
            on hp_per.party_id = hr.subject_id
          left join apps.hz_org_contacts@adg hoc
            on hoc.party_relationship_id = hr.relationship_id
          left join apps.hz_contact_points@adg hcp
            on hcp.owner_table_name = 'HZ_PARTIES'
           and hcp.owner_table_id = hcar.party_id
           and hcp.status = 'A'
           and hcp.contact_point_type in ('EMAIL', 'PHONE')
         where hcasa.cust_acct_site_id in (#IDS#)
         group by hcasa.cust_account_id, hcasa.cust_acct_site_id, hcar.cust_account_role_id, hcar.party_id
      ~'), '#IDS#', l_csv);

      execute immediate l_sql bulk collect into l_cnt_remote;

      for i in 1 .. l_cnt_remote.count loop
        if l_site_id_map.exists(to_char(l_cnt_remote(i).cust_acct_site_id))
           and l_cust_id_map.exists(to_char(l_cnt_remote(i).cust_account_id)) then
          insert into xxcr_stg_contacts (
            project_id,
            stg_cust_id,
            stg_site_id,
            include_yn,
            contact_ref_code,
            site_ref_code,
            contact_action,
            src_account_number,
            src_cust_account_role_id,
            src_rel_party_id,
            src_person_party_id,
            src_org_contact_id,
            src_first_name,
            src_last_name,
            src_job_title,
            src_department,
            src_primary_flag,
            src_responsibilities,
            src_email_address,
            src_phone_country_code,
            src_phone_area_code,
            src_phone_number,
            src_phone_extension,
            tgt_account_number,
            tgt_first_name,
            tgt_last_name,
            tgt_job_title,
            tgt_department,
            tgt_primary_flag,
            tgt_responsibilities,
            tgt_email_address,
            tgt_phone_country_code,
            tgt_phone_area_code,
            tgt_phone_number,
            tgt_phone_extension,
            norm_contact_key,
            val_status
          ) values (
            p_project_id,
            l_cust_id_map(to_char(l_cnt_remote(i).cust_account_id)),
            l_site_id_map(to_char(l_cnt_remote(i).cust_acct_site_id)),
            'Y',
            'CNT-' || l_cnt_remote(i).cust_account_role_id,
            'SITE-' || l_cnt_remote(i).cust_acct_site_id,
            'REUSE_PERSON',
            l_cnt_remote(i).account_number,
            l_cnt_remote(i).cust_account_role_id,
            l_cnt_remote(i).rel_party_id,
            l_cnt_remote(i).person_party_id,
            l_cnt_remote(i).org_contact_id,
            l_cnt_remote(i).first_name,
            l_cnt_remote(i).last_name,
            l_cnt_remote(i).job_title,
            l_cnt_remote(i).department,
            l_cnt_remote(i).primary_flag,
            'BILL_TO;STMTS',
            l_cnt_remote(i).email_address,
            l_cnt_remote(i).phone_country_code,
            l_cnt_remote(i).phone_area_code,
            l_cnt_remote(i).phone_number,
            l_cnt_remote(i).phone_extension,
            l_cnt_remote(i).account_number,
            l_cnt_remote(i).first_name,
            l_cnt_remote(i).last_name,
            l_cnt_remote(i).job_title,
            l_cnt_remote(i).department,
            l_cnt_remote(i).primary_flag,
            'BILL_TO;STMTS',
            l_cnt_remote(i).email_address,
            l_cnt_remote(i).phone_country_code,
            l_cnt_remote(i).phone_area_code,
            l_cnt_remote(i).phone_number,
            l_cnt_remote(i).phone_extension,
            upper(trim(nvl(l_cnt_remote(i).email_address, l_cnt_remote(i).first_name || ' ' || l_cnt_remote(i).last_name))),
            'PENDING'
          );
        end if;
      end loop;

      l_first := l_last + 1;
    end loop;

    -- Enrich Tier 1 & Tier 2 Public API Data Elements (DFFs, Site Tax Ref, Multi-Currency Credit,
    -- OU Account Relationships, Bill-To Profile Controls, IBY/AR Payment Instruments, Mobile/Fax, Sibling Site Uses)
    enrich_project_api_data(p_project_id);

    -- Populate per-Site-Use & rolled-up per-Site Open AR, 24m Trx & Open SO counts from @ADG
    refresh_site_activity(p_project_id);

    -- Apply cross-OU mapping rules, delta tracking, duplicate scan, and validation
    apply_mapping_rules(p_project_id);
    sync_deltas(p_project_id);
    find_duplicates(p_project_id);
    validate_project(p_project_id);

    update xxcr_projects
       set status = 'EXTRACTED',
           last_extract_at = systimestamp,
           updated_at = systimestamp
     where project_id = p_project_id;
  end extract_project_data;

  procedure enrich_project_api_data(p_project_id in number) is
    l_proj       xxcr_projects%rowtype;
    l_batch_size constant pls_integer := 800;
    l_first      pls_integer;
    l_last       pls_integer;
    l_csv        clob;
    l_sql        clob;

    type t_num_arr is table of number index by pls_integer;
    type t_id_map  is table of number index by varchar2(40);
    type t_str_map is table of varchar2(120) index by varchar2(40);

    l_cust_ids   t_num_arr;
    l_site_ids   t_num_arr;
    l_su_ids     t_num_arr;
    l_role_ids   t_num_arr;

    l_cust_map   t_id_map;
    l_cust_inc   t_str_map;
    l_cust_acct  t_str_map;
    l_site_map   t_id_map;
    l_site_inc   t_str_map;
    l_site_ref   t_str_map;
    l_site_cust  t_id_map;
    l_su_map     t_id_map;
    l_su_inc     t_str_map;
    l_su_ref     t_str_map;
    l_su_loc     t_str_map;
    l_role_map   t_id_map;

    -- Remote Bulk Fetch Record Types
    type r_sib_su is record (
      cust_account_id       number,
      account_number        varchar2(30),
      cust_acct_site_id     number,
      site_use_id           number,
      site_use_code         varchar2(30),
      location_code         varchar2(40),
      primary_flag          varchar2(1),
      bill_to_site_use_id   number,
      bill_to_location_code varchar2(40),
      payment_term_id       number,
      payment_term_name     varchar2(60),
      tax_code              varchar2(50),
      tax_reference         varchar2(60),
      ship_via              varchar2(30),
      gsa_indicator         varchar2(1)
    );
    type t_sib_su_tab is table of r_sib_su;
    l_sib_su     t_sib_su_tab;

    type r_site_dff is record (
      cust_acct_site_id number,
      dff_context       varchar2(30),
      sales_currency    varchar2(15),
      rps_hold_flag     varchar2(30),
      third_party_name  varchar2(150),
      pricing_cust_cat  varchar2(150),
      vertex_geocode    varchar2(150),
      ups_acct_num      varchar2(150),
      fedex_acct_num    varchar2(150),
      frt_pay_term      varchar2(150)
    );
    type t_site_dff_tab is table of r_site_dff;
    l_site_dff   t_site_dff_tab;

    type r_su_ext is record (
      site_use_id          number,
      tax_reference        varchar2(60),
      dff_context          varchar2(30),
      awp_genie_rep        varchar2(150),
      awp_util_rep         varchar2(150),
      eu_vat_val           varchar2(150),
      legacy_cust_num      varchar2(150),
      repository_id        varchar2(150),
      ship_via             varchar2(30),
      gsa_indicator        varchar2(1),
      send_statements      varchar2(1),
      statement_cycle_name varchar2(60),
      discount_terms       varchar2(1),
      override_terms       varchar2(1),
      dunning_letters      varchar2(1),
      dunning_letter_set   varchar2(60),
      autocash_rule_name   varchar2(60),
      grouping_rule_name   varchar2(60),
      credit_rating        varchar2(30),
      risk_code            varchar2(30),
      tolerance            number
    );
    type t_su_ext_tab is table of r_su_ext;
    l_su_ext     t_su_ext_tab;

    type r_prof_amt is record (
      cust_acct_prof_amt_id number,
      cust_acct_profile_id  number,
      cust_account_id       number,
      site_use_id           number,
      currency_code         varchar2(15),
      overall_credit_limit  number,
      trx_credit_limit      number,
      exchange_rate_type    varchar2(30),
      min_stmt_amt          number,
      min_dunning_amt       number
    );
    type t_prof_amt_tab is table of r_prof_amt;
    l_prof_amt   t_prof_amt_tab;

    type r_rel is record (
      cust_account_id       number,
      account_number        varchar2(30),
      party_name            varchar2(360),
      related_cust_acct_id  number,
      related_account_num   varchar2(30),
      related_party_name    varchar2(360),
      relationship_type     varchar2(30),
      bill_to_flag          varchar2(1),
      ship_to_flag          varchar2(1),
      reciprocal_flag       varchar2(1),
      comments              varchar2(240)
    );
    type t_rel_tab is table of r_rel;
    l_rel        t_rel_tab;

    type r_pmt is record (
      assignment_source  varchar2(30),
      assignment_level   varchar2(20),
      cust_account_id    number,
      site_use_id        number,
      instrument_type    varchar2(30),
      instrument_id      number,
      masked_display     varchar2(240),
      currency_code      varchar2(15),
      primary_flag       varchar2(1),
      order_of_pref      number,
      receipt_method_nm  varchar2(100)
    );
    type t_pmt_tab is table of r_pmt;
    l_pmt        t_pmt_tab;

    type r_cnt_ext is record (
      cust_account_role_id number,
      mobile_number        varchar2(60),
      fax_number           varchar2(60)
    );
    type t_cnt_ext_tab is table of r_cnt_ext;
    l_cnt_ext    t_cnt_ext_tab;

  begin
    select * into l_proj from xxcr_projects where project_id = p_project_id;

    -- Build fast lookup maps of currently staged Customers & Sites
    for r in (
      select stg_cust_id, src_cust_account_id, tgt_account_number, include_yn, scope_class
        from xxcr_stg_customers
       where project_id = p_project_id
         and src_cust_account_id is not null
    ) loop
      l_cust_ids(l_cust_ids.count + 1) := r.src_cust_account_id;
      l_cust_map(to_char(r.src_cust_account_id))  := r.stg_cust_id;
      l_cust_inc(to_char(r.src_cust_account_id))  := r.include_yn;
      l_cust_acct(to_char(r.src_cust_account_id)) := r.tgt_account_number;
    end loop;

    if l_cust_ids.count = 0 then
      return;
    end if;

    for r in (
      select stg_site_id, stg_cust_id, src_cust_acct_site_id, site_ref_code, include_yn
        from xxcr_stg_sites
       where project_id = p_project_id
         and src_cust_acct_site_id is not null
    ) loop
      l_site_ids(l_site_ids.count + 1) := r.src_cust_acct_site_id;
      l_site_map(to_char(r.src_cust_acct_site_id))  := r.stg_site_id;
      l_site_cust(to_char(r.src_cust_acct_site_id)) := r.stg_cust_id;
      l_site_ref(to_char(r.src_cust_acct_site_id))  := r.site_ref_code;
      l_site_inc(to_char(r.src_cust_acct_site_id))  := r.include_yn;
    end loop;

    -- =========================================================================
    -- STEP A (Tier 2 Item 9): Pull Sibling Secondary Site Uses (DELIVER_TO,
    --         SOLD_TO, INV, ACK, STMTS, DUN) on In-Scope Account Sites
    -- =========================================================================
    l_first := 1;
    while l_first <= l_site_ids.count loop
      l_last := least(l_first + l_batch_size - 1, l_site_ids.count);
      dbms_lob.createtemporary(l_csv, true);
      for k in l_first .. l_last loop
        if k > l_first then dbms_lob.writeappend(l_csv, 1, ','); end if;
        dbms_lob.writeappend(l_csv, length(to_char(l_site_ids(k))), to_char(l_site_ids(k)));
      end loop;

      l_sql := replace(to_clob(q'~
        select /*+ driving_site(su) */
               cas.cust_account_id,
               ca.account_number,
               cas.cust_acct_site_id,
               su.site_use_id,
               su.site_use_code,
               su.location as location_code,
               su.primary_flag,
               su.bill_to_site_use_id,
               su_bt.location as bill_to_location_code,
               su.payment_term_id,
               rt.name as payment_term_name,
               su.tax_code,
               su.tax_reference,
               su.ship_via,
               su.gsa_indicator
          from apps.hz_cust_site_uses_all@adg su
          join apps.hz_cust_acct_sites_all@adg cas on cas.cust_acct_site_id = su.cust_acct_site_id
          join apps.hz_cust_accounts@adg ca on ca.cust_account_id = cas.cust_account_id
          left join apps.hz_cust_site_uses_all@adg su_bt on su_bt.site_use_id = su.bill_to_site_use_id
          left join apps.ra_terms_tl@adg rt on rt.term_id = su.payment_term_id and rt.language = 'US'
         where su.cust_acct_site_id in (#IDS#)
           and su.status = 'A'
           and su.site_use_code not in ('BILL_TO', 'SHIP_TO')
      ~'), '#IDS#', l_csv);
      dbms_lob.freetemporary(l_csv);

      execute immediate l_sql bulk collect into l_sib_su;
      for i in 1 .. l_sib_su.count loop
        declare
          l_skey varchar2(40) := to_char(l_sib_su(i).cust_acct_site_id);
          l_ckey varchar2(40) := to_char(l_sib_su(i).cust_account_id);
          l_cnt  pls_integer;
        begin
          if l_site_map.exists(l_skey) and l_cust_map.exists(l_ckey) then
            select count(*) into l_cnt
              from xxcr_stg_site_uses
             where project_id = p_project_id
               and src_site_use_id = l_sib_su(i).site_use_id;
            if l_cnt = 0 then
              insert into xxcr_stg_site_uses (
                project_id, stg_cust_id, stg_site_id, include_yn, scope_class, site_ref_code,
                src_account_number, src_site_use_id, src_site_use_code, src_location_code,
                src_primary_flag, src_bill_to_site_use_id, src_bill_to_location_code,
                src_payment_term_id, src_payment_term_name, src_tax_code, src_tax_reference,
                src_ship_via, src_gsa_indicator,
                tgt_account_number, tgt_site_use_code, tgt_location_code, tgt_primary_flag,
                tgt_bill_to_location_code, tgt_payment_term_name, tgt_tax_code, tgt_tax_reference,
                tgt_ship_via, tgt_gsa_indicator, val_status
              ) values (
                p_project_id, l_cust_map(l_ckey), l_site_map(l_skey),
                case when l_cust_inc(l_ckey) = 'N' or l_site_inc(l_skey) = 'N' then 'N' else 'Y' end,
                'AERIALS_ONLY', l_site_ref(l_skey),
                l_sib_su(i).account_number, l_sib_su(i).site_use_id, l_sib_su(i).site_use_code,
                l_sib_su(i).location_code, nvl(l_sib_su(i).primary_flag, 'N'),
                l_sib_su(i).bill_to_site_use_id, l_sib_su(i).bill_to_location_code,
                l_sib_su(i).payment_term_id, l_sib_su(i).payment_term_name,
                l_sib_su(i).tax_code, l_sib_su(i).tax_reference,
                l_sib_su(i).ship_via, l_sib_su(i).gsa_indicator,
                l_cust_acct(l_ckey), l_sib_su(i).site_use_code, l_sib_su(i).location_code,
                nvl(l_sib_su(i).primary_flag, 'N'), l_sib_su(i).bill_to_location_code,
                l_sib_su(i).payment_term_name, l_sib_su(i).tax_code, l_sib_su(i).tax_reference,
                l_sib_su(i).ship_via, l_sib_su(i).gsa_indicator, 'VALID'
              );
            end if;
          end if;
        end;
      end loop;
      l_first := l_last + 1;
    end loop;

    -- Refresh Site-Use & Contact Role maps (including any newly added sibling site uses)
    for r in (
      select stg_site_use_id, src_site_use_id, site_ref_code, tgt_location_code, include_yn
        from xxcr_stg_site_uses
       where project_id = p_project_id
         and src_site_use_id is not null
    ) loop
      l_su_ids(l_su_ids.count + 1) := r.src_site_use_id;
      l_su_map(to_char(r.src_site_use_id)) := r.stg_site_use_id;
      l_su_ref(to_char(r.src_site_use_id)) := r.site_ref_code;
      l_su_loc(to_char(r.src_site_use_id)) := r.tgt_location_code;
      l_su_inc(to_char(r.src_site_use_id)) := r.include_yn;
    end loop;

    for r in (
      select stg_contact_id, src_cust_account_role_id
        from xxcr_stg_contacts
       where project_id = p_project_id
         and src_cust_account_role_id is not null
    ) loop
      l_role_ids(l_role_ids.count + 1) := r.src_cust_account_role_id;
      l_role_map(to_char(r.src_cust_account_role_id)) := r.stg_contact_id;
    end loop;

    -- =========================================================================
    -- STEP B (Tier 1 Item 2): Account-Site Custom DFFs (RA_ADDRESSES_HZ)
    -- =========================================================================
    l_first := 1;
    while l_first <= l_site_ids.count loop
      l_last := least(l_first + l_batch_size - 1, l_site_ids.count);
      dbms_lob.createtemporary(l_csv, true);
      for k in l_first .. l_last loop
        if k > l_first then dbms_lob.writeappend(l_csv, 1, ','); end if;
        dbms_lob.writeappend(l_csv, length(to_char(l_site_ids(k))), to_char(l_site_ids(k)));
      end loop;

      l_sql := replace(to_clob(q'~
        select /*+ driving_site(cas) */
               cas.cust_acct_site_id,
               cas.attribute_category,
               substr(trim(cas.attribute20), 1, 15),
               substr(trim(cas.attribute11), 1, 30),
               substr(trim(cas.attribute12), 1, 150),
               substr(trim(cas.attribute1),  1, 150),
               substr(trim(cas.attribute7),  1, 150),
               substr(trim(cas.attribute8),  1, 150),
               substr(trim(cas.attribute9),  1, 150),
               substr(trim(cas.attribute10), 1, 150)
          from apps.hz_cust_acct_sites_all@adg cas
         where cas.cust_acct_site_id in (#IDS#)
      ~'), '#IDS#', l_csv);
      dbms_lob.freetemporary(l_csv);

      execute immediate l_sql bulk collect into l_site_dff;
      forall i in 1 .. l_site_dff.count
        update xxcr_stg_sites
           set src_dff_context      = l_site_dff(i).dff_context,
               src_sales_currency   = l_site_dff(i).sales_currency,
               src_rps_hold_flag    = l_site_dff(i).rps_hold_flag,
               src_third_party_name = l_site_dff(i).third_party_name,
               src_pricing_cust_cat = l_site_dff(i).pricing_cust_cat,
               src_vertex_geocode   = l_site_dff(i).vertex_geocode,
               src_ups_acct_num     = l_site_dff(i).ups_acct_num,
               src_fedex_acct_num   = l_site_dff(i).fedex_acct_num,
               src_frt_pay_term     = l_site_dff(i).frt_pay_term,
               tgt_dff_context      = coalesce(tgt_dff_context,      l_site_dff(i).dff_context),
               tgt_sales_currency   = coalesce(tgt_sales_currency,   l_site_dff(i).sales_currency),
               tgt_rps_hold_flag    = coalesce(tgt_rps_hold_flag,    l_site_dff(i).rps_hold_flag),
               tgt_third_party_name = coalesce(tgt_third_party_name, l_site_dff(i).third_party_name),
               tgt_pricing_cust_cat = coalesce(tgt_pricing_cust_cat, l_site_dff(i).pricing_cust_cat),
               tgt_vertex_geocode   = coalesce(tgt_vertex_geocode,   l_site_dff(i).vertex_geocode),
               tgt_ups_acct_num     = coalesce(tgt_ups_acct_num,     l_site_dff(i).ups_acct_num),
               tgt_fedex_acct_num   = coalesce(tgt_fedex_acct_num,   l_site_dff(i).fedex_acct_num),
               tgt_frt_pay_term     = coalesce(tgt_frt_pay_term,     l_site_dff(i).frt_pay_term)
         where project_id = p_project_id
           and src_cust_acct_site_id = l_site_dff(i).cust_acct_site_id;

      l_first := l_last + 1;
    end loop;

    -- =========================================================================
    -- STEP C (Tier 1 Items 1 & 3 + Tier 2 Items 6 & 9): Site-Use Custom DFFs
    --         (AWP - GENIE), TAX_REFERENCE, SHIP_VIA, GSA & Bill-To Controls
    -- =========================================================================
    l_first := 1;
    while l_first <= l_su_ids.count loop
      l_last := least(l_first + l_batch_size - 1, l_su_ids.count);
      dbms_lob.createtemporary(l_csv, true);
      for k in l_first .. l_last loop
        if k > l_first then dbms_lob.writeappend(l_csv, 1, ','); end if;
        dbms_lob.writeappend(l_csv, length(to_char(l_su_ids(k))), to_char(l_su_ids(k)));
      end loop;

      l_sql := replace(to_clob(q'~
        select /*+ driving_site(su) */
               su.site_use_id,
               substr(trim(su.tax_reference), 1, 60),
               su.attribute_category,
               substr(trim(su.attribute10), 1, 150),
               substr(trim(su.attribute11), 1, 150),
               substr(trim(su.attribute2),  1, 150),
               substr(trim(su.attribute19), 1, 150),
               substr(trim(su.attribute20), 1, 150),
               substr(trim(su.ship_via),    1, 30),
               substr(trim(su.gsa_indicator), 1, 1),
               cp.send_statements,
               substr(sc.name, 1, 60),
               cp.discount_terms,
               cp.override_terms,
               cp.dunning_letters,
               substr(dl.name, 1, 60),
               substr(ah.hierarchy_name, 1, 60),
               substr(gr.name, 1, 60),
               cp.credit_rating,
               cp.risk_code,
               cp.tolerance
          from apps.hz_cust_site_uses_all@adg su
          left join apps.hz_customer_profiles@adg cp
            on cp.site_use_id = su.site_use_id and cp.status = 'A'
          left join apps.ar_statement_cycles@adg sc
            on sc.statement_cycle_id = cp.statement_cycle_id
          left join apps.ar_dunning_letter_sets@adg dl
            on dl.dunning_letter_set_id = cp.dunning_letter_set_id
          left join apps.ar_autocash_hierarchies@adg ah
            on ah.autocash_hierarchy_id = cp.autocash_hierarchy_id
          left join apps.ra_grouping_rules@adg gr
            on gr.grouping_rule_id = cp.grouping_rule_id
         where su.site_use_id in (#IDS#)
      ~'), '#IDS#', l_csv);
      dbms_lob.freetemporary(l_csv);

      execute immediate l_sql bulk collect into l_su_ext;
      forall i in 1 .. l_su_ext.count
        update xxcr_stg_site_uses
           set src_tax_reference        = l_su_ext(i).tax_reference,
               src_dff_context          = l_su_ext(i).dff_context,
               src_awp_genie_rep        = l_su_ext(i).awp_genie_rep,
               src_awp_util_rep         = l_su_ext(i).awp_util_rep,
               src_eu_vat_val           = l_su_ext(i).eu_vat_val,
               src_legacy_cust_num      = l_su_ext(i).legacy_cust_num,
               src_repository_id        = l_su_ext(i).repository_id,
               src_ship_via             = l_su_ext(i).ship_via,
               src_gsa_indicator        = l_su_ext(i).gsa_indicator,
               src_send_statements      = l_su_ext(i).send_statements,
               src_statement_cycle_name = l_su_ext(i).statement_cycle_name,
               src_discount_terms       = l_su_ext(i).discount_terms,
               src_override_terms       = l_su_ext(i).override_terms,
               src_dunning_letters      = l_su_ext(i).dunning_letters,
               src_dunning_letter_set   = l_su_ext(i).dunning_letter_set,
               src_autocash_rule_name   = l_su_ext(i).autocash_rule_name,
               src_grouping_rule_name   = l_su_ext(i).grouping_rule_name,
               src_credit_rating        = l_su_ext(i).credit_rating,
               src_risk_code            = l_su_ext(i).risk_code,
               src_tolerance            = l_su_ext(i).tolerance,
               tgt_tax_reference        = coalesce(tgt_tax_reference,        l_su_ext(i).tax_reference),
               tgt_dff_context          = coalesce(tgt_dff_context,          l_su_ext(i).dff_context),
               tgt_awp_genie_rep        = coalesce(tgt_awp_genie_rep,        l_su_ext(i).awp_genie_rep),
               tgt_awp_util_rep         = coalesce(tgt_awp_util_rep,         l_su_ext(i).awp_util_rep),
               tgt_eu_vat_val           = coalesce(tgt_eu_vat_val,           l_su_ext(i).eu_vat_val),
               tgt_legacy_cust_num      = coalesce(tgt_legacy_cust_num,      l_su_ext(i).legacy_cust_num),
               tgt_repository_id        = coalesce(tgt_repository_id,        l_su_ext(i).repository_id),
               tgt_ship_via             = coalesce(tgt_ship_via,             l_su_ext(i).ship_via),
               tgt_gsa_indicator        = coalesce(tgt_gsa_indicator,        l_su_ext(i).gsa_indicator),
               tgt_send_statements      = coalesce(tgt_send_statements,      l_su_ext(i).send_statements),
               tgt_statement_cycle_name = coalesce(tgt_statement_cycle_name, l_su_ext(i).statement_cycle_name),
               tgt_discount_terms       = coalesce(tgt_discount_terms,       l_su_ext(i).discount_terms),
               tgt_override_terms       = coalesce(tgt_override_terms,       l_su_ext(i).override_terms),
               tgt_dunning_letters      = coalesce(tgt_dunning_letters,      l_su_ext(i).dunning_letters),
               tgt_dunning_letter_set   = coalesce(tgt_dunning_letter_set,   l_su_ext(i).dunning_letter_set),
               tgt_autocash_rule_name   = coalesce(tgt_autocash_rule_name,   l_su_ext(i).autocash_rule_name),
               tgt_grouping_rule_name   = coalesce(tgt_grouping_rule_name,   l_su_ext(i).grouping_rule_name),
               tgt_credit_rating        = coalesce(tgt_credit_rating,        l_su_ext(i).credit_rating),
               tgt_risk_code            = coalesce(tgt_risk_code,            l_su_ext(i).risk_code),
               tgt_tolerance            = coalesce(tgt_tolerance,            l_su_ext(i).tolerance)
         where project_id = p_project_id
           and src_site_use_id = l_su_ext(i).site_use_id;

      l_first := l_last + 1;
    end loop;

    -- =========================================================================
    -- STEP D (Tier 1 Item 4): Multi-Currency Credit Limits -> XXCR_STG_PROFILE_AMTS
    -- =========================================================================
    l_first := 1;
    while l_first <= l_su_ids.count loop
      l_last := least(l_first + l_batch_size - 1, l_su_ids.count);
      dbms_lob.createtemporary(l_csv, true);
      for k in l_first .. l_last loop
        if k > l_first then dbms_lob.writeappend(l_csv, 1, ','); end if;
        dbms_lob.writeappend(l_csv, length(to_char(l_su_ids(k))), to_char(l_su_ids(k)));
      end loop;

      l_sql := replace(to_clob(q'~
        select /*+ driving_site(cp) */
               cpa.cust_acct_profile_amt_id,
               cp.cust_account_profile_id,
               cp.cust_account_id,
               cp.site_use_id,
               cpa.currency_code,
               cpa.overall_credit_limit,
               cpa.trx_credit_limit,
               cpa.exchange_rate_type,
               cpa.min_statement_amount,
               cpa.min_dunning_amount
          from apps.hz_customer_profiles@adg cp
          join apps.hz_cust_profile_amts@adg cpa
            on cpa.cust_account_profile_id = cp.cust_account_profile_id
         where cp.site_use_id in (#IDS#)
           and cp.status = 'A'
      ~'), '#IDS#', l_csv);
      dbms_lob.freetemporary(l_csv);

      execute immediate l_sql bulk collect into l_prof_amt;
      for i in 1 .. l_prof_amt.count loop
        declare
          l_ukey varchar2(40) := to_char(l_prof_amt(i).site_use_id);
          l_ckey varchar2(40) := to_char(l_prof_amt(i).cust_account_id);
          l_cnt  pls_integer;
        begin
          if l_su_map.exists(l_ukey) and l_cust_map.exists(l_ckey) then
            select count(*) into l_cnt
              from xxcr_stg_profile_amts
             where project_id = p_project_id
               and stg_site_use_id = l_su_map(l_ukey)
               and src_currency_code = l_prof_amt(i).currency_code;
            if l_cnt = 0 then
              insert into xxcr_stg_profile_amts (
                project_id, stg_cust_id, stg_site_use_id, include_yn, profile_level, site_ref_code,
                src_cust_acct_prof_amt_id, src_cust_acct_profile_id, src_account_number,
                src_site_use_id, src_location_code, src_currency_code,
                src_overall_credit_limit, src_trx_credit_limit, src_exchange_rate_type,
                src_min_stmt_amt, src_min_dunning_amt,
                tgt_account_number, tgt_location_code, tgt_currency_code,
                tgt_overall_credit_limit, tgt_trx_credit_limit, tgt_exchange_rate_type,
                tgt_min_stmt_amt, tgt_min_dunning_amt
              ) values (
                p_project_id, l_cust_map(l_ckey), l_su_map(l_ukey), l_su_inc(l_ukey), 'SITE_USE', l_su_ref(l_ukey),
                l_prof_amt(i).cust_acct_prof_amt_id, l_prof_amt(i).cust_acct_profile_id, l_cust_acct(l_ckey),
                l_prof_amt(i).site_use_id, l_su_loc(l_ukey), l_prof_amt(i).currency_code,
                l_prof_amt(i).overall_credit_limit, l_prof_amt(i).trx_credit_limit, l_prof_amt(i).exchange_rate_type,
                l_prof_amt(i).min_stmt_amt, l_prof_amt(i).min_dunning_amt,
                l_cust_acct(l_ckey), l_su_loc(l_ukey), l_prof_amt(i).currency_code,
                l_prof_amt(i).overall_credit_limit, l_prof_amt(i).trx_credit_limit, l_prof_amt(i).exchange_rate_type,
                l_prof_amt(i).min_stmt_amt, l_prof_amt(i).min_dunning_amt
              );
            end if;
          end if;
        end;
      end loop;
      l_first := l_last + 1;
    end loop;

    -- Stamp readable Multi-Currency Summary onto BILL_TO rows in XXCR_STG_SITE_USES
    update xxcr_stg_site_uses su
       set su.multi_curr_summary = (
             select substr(listagg(pa.tgt_currency_code || ': ' || nvl(to_char(pa.tgt_overall_credit_limit, 'FM999G999G990'), 'Unlim'), ' | ')
                      within group (order by pa.tgt_currency_code), 1, 240)
               from xxcr_stg_profile_amts pa
              where pa.stg_site_use_id = su.stg_site_use_id
                and pa.include_yn = 'Y'
           )
     where su.project_id = p_project_id;

    -- =========================================================================
    -- STEP E (Tier 1 Item 5): OU-Striped Account Relationships -> XXCR_STG_ACCT_RELATES
    -- =========================================================================
    l_first := 1;
    while l_first <= l_cust_ids.count loop
      l_last := least(l_first + l_batch_size - 1, l_cust_ids.count);
      dbms_lob.createtemporary(l_csv, true);
      for k in l_first .. l_last loop
        if k > l_first then dbms_lob.writeappend(l_csv, 1, ','); end if;
        dbms_lob.writeappend(l_csv, length(to_char(l_cust_ids(k))), to_char(l_cust_ids(k)));
      end loop;

      l_sql := replace(to_clob(q'~
        select /*+ driving_site(rel) */
               rel.cust_account_id,
               ca1.account_number,
               hp1.party_name,
               rel.related_cust_account_id,
               ca2.account_number,
               hp2.party_name,
               rel.relationship_type,
               nvl(rel.bill_to_flag, 'N'),
               nvl(rel.ship_to_flag, 'N'),
               nvl(rel.customer_reciprocal_flag, 'N'),
               substr(rel.comments, 1, 240)
          from apps.hz_cust_acct_relate_all@adg rel
          join apps.hz_cust_accounts@adg ca1 on ca1.cust_account_id = rel.cust_account_id
          join apps.hz_parties@adg hp1 on hp1.party_id = ca1.party_id
          join apps.hz_cust_accounts@adg ca2 on ca2.cust_account_id = rel.related_cust_account_id
          join apps.hz_parties@adg hp2 on hp2.party_id = ca2.party_id
         where rel.org_id = :org_id
           and rel.status = 'A'
           and rel.cust_account_id in (#IDS#)
      ~'), '#IDS#', l_csv);
      dbms_lob.freetemporary(l_csv);

      execute immediate l_sql bulk collect into l_rel using l_proj.src_org_id;
      for i in 1 .. l_rel.count loop
        declare
          l_ckey        varchar2(40) := to_char(l_rel(i).cust_account_id);
          l_rkey        varchar2(40) := to_char(l_rel(i).related_cust_acct_id);
          l_rel_stg_id  number       := null;
          l_rel_tgt_num varchar2(30) := l_rel(i).related_account_num;
          l_both_yn     varchar2(1)  := 'N';
          l_cnt         pls_integer;
        begin
          if l_cust_map.exists(l_ckey) then
            if l_cust_map.exists(l_rkey) then
              l_rel_stg_id  := l_cust_map(l_rkey);
              l_rel_tgt_num := l_cust_acct(l_rkey);
              l_both_yn     := 'Y';
            end if;
            select count(*) into l_cnt
              from xxcr_stg_acct_relates
             where project_id = p_project_id
               and src_cust_account_id = l_rel(i).cust_account_id
               and src_related_cust_acct_id = l_rel(i).related_cust_acct_id;
            if l_cnt = 0 then
              insert into xxcr_stg_acct_relates (
                project_id, stg_cust_id, related_stg_cust_id, include_yn,
                src_cust_account_id, src_account_number, src_party_name,
                src_related_cust_acct_id, src_related_account_num, src_related_party_name,
                src_relationship_type, src_bill_to_flag, src_ship_to_flag, src_reciprocal_flag, src_comments,
                tgt_account_number, tgt_related_account_num, tgt_relationship_type,
                tgt_bill_to_flag, tgt_ship_to_flag, tgt_reciprocal_flag, tgt_comments,
                both_in_scope_yn
              ) values (
                p_project_id, l_cust_map(l_ckey), l_rel_stg_id, l_cust_inc(l_ckey),
                l_rel(i).cust_account_id, l_rel(i).account_number, l_rel(i).party_name,
                l_rel(i).related_cust_acct_id, l_rel(i).related_account_num, l_rel(i).related_party_name,
                l_rel(i).relationship_type, l_rel(i).bill_to_flag, l_rel(i).ship_to_flag,
                l_rel(i).reciprocal_flag, l_rel(i).comments,
                l_cust_acct(l_ckey), l_rel_tgt_num,
                l_rel(i).relationship_type, l_rel(i).bill_to_flag, l_rel(i).ship_to_flag,
                l_rel(i).reciprocal_flag, l_rel(i).comments,
                l_both_yn
              );
            end if;
          end if;
        end;
      end loop;
      l_first := l_last + 1;
    end loop;

    -- =========================================================================
    -- STEP F (Tier 2 Item 7): OU-Striped Payment Instruments & Receipt Methods
    -- =========================================================================
    l_first := 1;
    while l_first <= l_cust_ids.count loop
      l_last := least(l_first + l_batch_size - 1, l_cust_ids.count);
      dbms_lob.createtemporary(l_csv, true);
      for k in l_first .. l_last loop
        if k > l_first then dbms_lob.writeappend(l_csv, 1, ','); end if;
        dbms_lob.writeappend(l_csv, length(to_char(l_cust_ids(k))), to_char(l_cust_ids(k)));
      end loop;

      l_sql := replace(to_clob(q'~
        select /*+ driving_site(iby) */
               'IBY_INSTRUMENT' as assignment_source,
               case when iby.acct_site_use_id is not null then 'SITE_USE' else 'ACCOUNT' end as assignment_level,
               iby.cust_account_id,
               iby.acct_site_use_id as site_use_id,
               piu.instrument_type,
               piu.instrument_id,
               substr(
                 case
                   when piu.instrument_type = 'BANKACCOUNT' then
                     'Bank: ' || coalesce(eba.masked_iban, eba.masked_bank_account_num, 'ID#' || piu.instrument_id)
                   when piu.instrument_type = 'CREDITCARD' then
                     nvl(cc.card_issuer_code, 'Card') || ': ' || nvl(cc.masked_cc_number, 'ID#' || piu.instrument_id)
                   else
                     piu.instrument_type || ' #' || piu.instrument_id
                 end, 1, 240
               ) as masked_display,
               eba.currency_code,
               case when piu.order_of_preference = 1 then 'Y' else 'N' end as primary_flag,
               piu.order_of_preference,
               cast(null as varchar2(100)) as receipt_method_nm
          from apps.iby_external_payers_all@adg iby
          join apps.iby_pmt_instr_uses_all@adg piu
            on piu.ext_pmt_party_id = iby.ext_payer_id
          left join apps.iby_ext_bank_accounts@adg eba
            on eba.ext_bank_account_id = piu.instrument_id and piu.instrument_type = 'BANKACCOUNT'
          left join apps.iby_creditcard@adg cc
            on cc.instrid = piu.instrument_id and piu.instrument_type = 'CREDITCARD'
         where iby.org_id = :org_id
           and iby.cust_account_id in (#IDS#)
           and trunc(sysdate) between piu.start_date and nvl(piu.end_date, trunc(sysdate))
        union all
        select /*+ driving_site(rm) */
               'AR_RECEIPT_METHOD',
               case when rm.site_use_id is not null then 'SITE_USE' else 'ACCOUNT' end,
               rm.customer_id,
               rm.site_use_id,
               'RECEIPT_METHOD',
               rm.receipt_method_id,
               substr('Receipt Method: ' || arm.name, 1, 240),
               null,
               nvl(rm.primary_flag, 'N'),
               null,
               substr(arm.name, 1, 100)
          from apps.ra_cust_receipt_methods@adg rm
          join apps.ar_receipt_methods@adg arm on arm.receipt_method_id = rm.receipt_method_id
         where rm.customer_id in (#IDS#)
           and trunc(sysdate) between rm.start_date and nvl(rm.end_date, trunc(sysdate))
      ~'), '#IDS#', l_csv);
      dbms_lob.freetemporary(l_csv);

      execute immediate l_sql bulk collect into l_pmt using l_proj.src_org_id;
      for i in 1 .. l_pmt.count loop
        declare
          l_ckey   varchar2(40) := to_char(l_pmt(i).cust_account_id);
          l_ukey   varchar2(40) := to_char(l_pmt(i).site_use_id);
          l_stg_su number       := null;
          l_sref   varchar2(60) := null;
          l_loc    varchar2(40) := null;
          l_inc    varchar2(1)  := 'Y';
          l_cnt    pls_integer;
        begin
          if l_cust_map.exists(l_ckey) then
            if l_pmt(i).site_use_id is not null then
              if l_su_map.exists(l_ukey) then
                l_stg_su := l_su_map(l_ukey);
                l_sref   := l_su_ref(l_ukey);
                l_loc    := l_su_loc(l_ukey);
                l_inc    := l_su_inc(l_ukey);
              else
                goto skip_pmt_row; -- Site use belongs to a different OU or out-of-scope site
              end if;
            else
              l_inc := l_cust_inc(l_ckey);
            end if;

            select count(*) into l_cnt
              from xxcr_stg_payment_instr
             where project_id = p_project_id
               and stg_cust_id = l_cust_map(l_ckey)
               and nvl(stg_site_use_id, -1) = nvl(l_stg_su, -1)
               and assignment_source = l_pmt(i).assignment_source
               and src_instrument_id = l_pmt(i).instrument_id;

            if l_cnt = 0 then
              insert into xxcr_stg_payment_instr (
                project_id, stg_cust_id, stg_site_use_id, include_yn,
                assignment_source, assignment_level, site_ref_code,
                src_cust_account_id, src_account_number, src_site_use_id, src_location_code,
                instrument_type, src_instrument_id, masked_account_or_method, currency_code,
                src_primary_flag, src_order_of_pref,
                tgt_account_number, tgt_location_code, tgt_primary_flag, tgt_order_of_pref, tgt_receipt_method_name
              ) values (
                p_project_id, l_cust_map(l_ckey), l_stg_su, l_inc,
                l_pmt(i).assignment_source, l_pmt(i).assignment_level, l_sref,
                l_pmt(i).cust_account_id, l_cust_acct(l_ckey), l_pmt(i).site_use_id, l_loc,
                l_pmt(i).instrument_type, l_pmt(i).instrument_id, l_pmt(i).masked_display, l_pmt(i).currency_code,
                l_pmt(i).primary_flag, l_pmt(i).order_of_pref,
                l_cust_acct(l_ckey), l_loc, l_pmt(i).primary_flag, l_pmt(i).order_of_pref, l_pmt(i).receipt_method_nm
              );
            end if;
          end if;
          <<skip_pmt_row>>
          null;
        end;
      end loop;
      l_first := l_last + 1;
    end loop;

    -- =========================================================================
    -- STEP G (Tier 2 Item 8): Contact MOBILE & FAX Numbers -> XXCR_STG_CONTACTS
    -- =========================================================================
    l_first := 1;
    while l_first <= l_role_ids.count loop
      l_last := least(l_first + l_batch_size - 1, l_role_ids.count);
      dbms_lob.createtemporary(l_csv, true);
      for k in l_first .. l_last loop
        if k > l_first then dbms_lob.writeappend(l_csv, 1, ','); end if;
        dbms_lob.writeappend(l_csv, length(to_char(l_role_ids(k))), to_char(l_role_ids(k)));
      end loop;

      l_sql := replace(to_clob(q'~
        select /*+ driving_site(car) */
               car.cust_account_role_id,
               substr(max(case when cp.phone_line_type = 'MOBILE' then
                 trim(nvl2(cp.phone_country_code, '+' || cp.phone_country_code || ' ', '') ||
                      nvl2(cp.phone_area_code, cp.phone_area_code || ' ', '') || cp.phone_number)
               end), 1, 60) as mobile_number,
               substr(max(case when cp.phone_line_type = 'FAX' then
                 trim(nvl2(cp.phone_country_code, '+' || cp.phone_country_code || ' ', '') ||
                      nvl2(cp.phone_area_code, cp.phone_area_code || ' ', '') || cp.phone_number)
               end), 1, 60) as fax_number
          from apps.hz_cust_account_roles@adg car
          join apps.hz_contact_points@adg cp
            on cp.owner_table_name = 'HZ_PARTIES'
           and cp.owner_table_id = car.party_id
           and cp.status = 'A'
           and cp.contact_point_type = 'PHONE'
           and cp.phone_line_type in ('MOBILE', 'FAX')
         where car.cust_account_role_id in (#IDS#)
         group by car.cust_account_role_id
      ~'), '#IDS#', l_csv);
      dbms_lob.freetemporary(l_csv);

      execute immediate l_sql bulk collect into l_cnt_ext;
      forall i in 1 .. l_cnt_ext.count
        update xxcr_stg_contacts
           set src_mobile_number = l_cnt_ext(i).mobile_number,
               src_fax_number    = l_cnt_ext(i).fax_number,
               tgt_mobile_number = coalesce(tgt_mobile_number, l_cnt_ext(i).mobile_number),
               tgt_fax_number    = coalesce(tgt_fax_number,    l_cnt_ext(i).fax_number)
         where project_id = p_project_id
           and src_cust_account_role_id = l_cnt_ext(i).cust_account_role_id;

      l_first := l_last + 1;
    end loop;
  end enrich_project_api_data;

  procedure refresh_site_activity(p_project_id in number) is
    l_proj          xxcr_projects%rowtype;
    l_active_months number;
    l_cutoff_date   date;

    type r_su_act is record (
      site_use_id    number,
      open_ar_amt    number,
      trx_cnt_recent number,
      open_so_cnt    number,
      last_act_date  date
    );
    type t_su_act_tab is table of r_su_act;
    l_su_act        t_su_act_tab;
  begin
    select * into l_proj from xxcr_projects where project_id = p_project_id;
    l_active_months := nvl(l_proj.filter_active_months, 24);
    l_cutoff_date   := add_months(trunc(sysdate), -l_active_months);

    update xxcr_stg_site_uses
       set src_open_ar_amt    = 0,
           src_trx_cnt_recent = 0,
           src_open_so_cnt    = 0,
           src_last_trx_date  = null
     where project_id = p_project_id;

    -- Single-pass remote aggregation on @ADG (/*+ driving_site(ps) */) for the Source OU (~1.5s total)
    select /*+ driving_site(su) */
           act.site_use_id,
           nvl(act.open_ar_amt, 0) as open_ar_amt,
           nvl(act.trx_cnt_recent, 0) as trx_cnt_recent,
           nvl(act.open_so_cnt, 0) as open_so_cnt,
           act.last_act_date
      bulk collect into l_su_act
      from (
        select su_id as site_use_id,
               round(sum(open_ar_amt), 2) as open_ar_amt,
               sum(trx_cnt) as trx_cnt_recent,
               sum(open_so_cnt) as open_so_cnt,
               max(last_dt) as last_act_date
          from (
            -- 1. Open AR Balances on BILL_TO Site Uses (uses AR_PAYMENT_SCHEDULES_N6 on STATUS)
            select ps.customer_site_use_id as su_id,
                   sum(ps.amount_due_remaining) as open_ar_amt,
                   0 as trx_cnt,
                   0 as open_so_cnt,
                   max(ps.trx_date) as last_dt
              from apps.ar_payment_schedules_all@adg ps
             where ps.status = 'OP'
               and ps.org_id = l_proj.src_org_id
               and ps.customer_site_use_id is not null
               and ps.amount_due_remaining <> 0
             group by ps.customer_site_use_id
            union all
            -- 2. Recent AR Invoices (24m) across BILL_TO and SHIP_TO Site Uses
            select decode(g.n, 1, trx.bill_to_site_use_id, trx.ship_to_site_use_id) as su_id,
                   0 as open_ar_amt,
                   count(distinct trx.customer_trx_id) as trx_cnt,
                   0 as open_so_cnt,
                   max(trx.trx_date) as last_dt
              from apps.ra_customer_trx_all@adg trx,
                   (select 1 as n from sys.dual@adg union all select 2 from sys.dual@adg) g
             where trx.org_id = l_proj.src_org_id
               and trx.trx_date >= l_cutoff_date
               and decode(g.n, 1, trx.bill_to_site_use_id, trx.ship_to_site_use_id) is not null
             group by decode(g.n, 1, trx.bill_to_site_use_id, trx.ship_to_site_use_id)
            union all
            -- 3. Open Sales Order Lines across INVOICE_TO and SHIP_TO Site Uses
            select decode(g.n, 1, l.invoice_to_org_id, l.ship_to_org_id) as su_id,
                   0 as open_ar_amt,
                   0 as trx_cnt,
                   count(distinct l.line_id) as open_so_cnt,
                   max(trunc(l.creation_date)) as last_dt
              from apps.oe_order_lines_all@adg l,
                   (select 1 as n from sys.dual@adg union all select 2 from sys.dual@adg) g
             where l.org_id = l_proj.src_org_id
               and l.open_flag = 'Y'
               and nvl(l.cancelled_flag, 'N') = 'N'
               and decode(g.n, 1, l.invoice_to_org_id, l.ship_to_org_id) is not null
             group by decode(g.n, 1, l.invoice_to_org_id, l.ship_to_org_id)
          )
         group by su_id
      ) act
      join apps.hz_cust_site_uses_all@adg su
        on su.site_use_id = act.site_use_id
       and su.org_id = l_proj.src_org_id;

    forall i in 1 .. l_su_act.count
      update xxcr_stg_site_uses
         set src_open_ar_amt    = l_su_act(i).open_ar_amt,
             src_trx_cnt_recent = l_su_act(i).trx_cnt_recent,
             src_open_so_cnt    = l_su_act(i).open_so_cnt,
             src_last_trx_date  = l_su_act(i).last_act_date
       where project_id = p_project_id
         and src_site_use_id = l_su_act(i).site_use_id;

    -- Roll up Site-Use Open AR, 24m Trx Count, Open SO Count, and Latest Activity Date onto Parent Sites
    merge into xxcr_stg_sites s
    using (
      select stg_site_id,
             round(sum(nvl(src_open_ar_amt, 0)), 2) as site_open_ar,
             sum(nvl(src_trx_cnt_recent, 0)) as site_trx_cnt,
             sum(nvl(src_open_so_cnt, 0)) as site_so_cnt,
             max(src_last_trx_date) as site_last_dt
        from xxcr_stg_site_uses
       where project_id = p_project_id
       group by stg_site_id
    ) su_tot
       on (s.stg_site_id = su_tot.stg_site_id)
     when matched then update
       set s.src_open_ar_amt    = su_tot.site_open_ar,
           s.src_trx_cnt_recent = su_tot.site_trx_cnt,
           s.src_open_so_cnt    = su_tot.site_so_cnt,
           s.src_last_trx_date  = su_tot.site_last_dt
     where s.project_id = p_project_id;

    update xxcr_stg_sites
       set src_open_ar_amt    = nvl(src_open_ar_amt, 0),
           src_trx_cnt_recent = nvl(src_trx_cnt_recent, 0),
           src_open_so_cnt    = nvl(src_open_so_cnt, 0)
     where project_id = p_project_id
       and src_open_ar_amt is null;
  end refresh_site_activity;

  ------------------------------------------------------------------------------
  -- 4. Data Manipulation, Cross-OU Mapping & Delta Tracking
  ------------------------------------------------------------------------------
  procedure apply_mapping_rules(p_project_id in number) is
    l_tgt_bsv varchar2(30);
  begin
    select tgt_bsv into l_tgt_bsv from xxcr_projects where project_id = p_project_id;

    if l_tgt_bsv is not null then
      update xxcr_stg_site_uses
         set tgt_gl_rec_concat     = remap_gl_bsv(nvl(tgt_gl_rec_concat, src_gl_rec_concat), l_tgt_bsv),
             tgt_gl_rev_concat     = remap_gl_bsv(nvl(tgt_gl_rev_concat, src_gl_rev_concat), l_tgt_bsv),
             tgt_gl_tax_concat     = remap_gl_bsv(nvl(tgt_gl_tax_concat, src_gl_tax_concat), l_tgt_bsv),
             tgt_gl_freight_concat = remap_gl_bsv(nvl(tgt_gl_freight_concat, src_gl_freight_concat), l_tgt_bsv)
       where project_id = p_project_id;
    end if;

    for r in (
      select rule_domain, src_value, tgt_value
        from xxcr_map_rules
       where project_id = p_project_id
         and active_yn = 'Y'
    ) loop
      if r.rule_domain = 'PAYMENT_TERM' then
        update xxcr_stg_customers
           set tgt_payment_term_name = r.tgt_value
         where project_id = p_project_id
           and src_payment_term_name = r.src_value;
        update xxcr_stg_site_uses
           set tgt_payment_term_name = r.tgt_value
         where project_id = p_project_id
           and src_payment_term_name = r.src_value;
      elsif r.rule_domain = 'WAREHOUSE' then
        update xxcr_stg_site_uses
           set tgt_warehouse_code = r.tgt_value
         where project_id = p_project_id
           and src_warehouse_code = r.src_value;
      elsif r.rule_domain = 'ORDER_TYPE' then
        update xxcr_stg_site_uses
           set tgt_order_type_name = r.tgt_value
         where project_id = p_project_id
           and src_order_type_name = r.src_value;
      elsif r.rule_domain = 'PRICE_LIST' then
        update xxcr_stg_site_uses
           set tgt_price_list_name = r.tgt_value
         where project_id = p_project_id
           and src_price_list_name = r.src_value;
      elsif r.rule_domain = 'SALESREP' then
        update xxcr_stg_site_uses
           set tgt_salesrep_name = r.tgt_value
         where project_id = p_project_id
           and src_salesrep_name = r.src_value;
      elsif r.rule_domain = 'TAX_CODE' then
        update xxcr_stg_site_uses
           set tgt_tax_code = r.tgt_value
         where project_id = p_project_id
           and src_tax_code = r.src_value;
      elsif r.rule_domain = 'PROFILE_CLASS' then
        update xxcr_stg_customers
           set tgt_profile_class_name = r.tgt_value
         where project_id = p_project_id
           and src_profile_class_name = r.src_value;
      end if;
    end loop;

    sync_deltas(p_project_id);
  end apply_mapping_rules;

  procedure bulk_manipulate_data(
    p_project_id      in number,
    p_new_bsv         in varchar2 default null,
    p_payment_term    in varchar2 default null,
    p_warehouse_code  in varchar2 default null,
    p_order_type      in varchar2 default null,
    p_price_list      in varchar2 default null,
    p_tax_code        in varchar2 default null,
    p_only_included   in varchar2 default 'Y'
  ) is
  begin
    if trim(p_new_bsv) is not null then
      update xxcr_projects
         set tgt_bsv = trim(p_new_bsv),
             updated_at = systimestamp
       where project_id = p_project_id;
    end if;

    update xxcr_stg_site_uses
       set tgt_gl_rec_concat     = case when trim(p_new_bsv) is not null then remap_gl_bsv(tgt_gl_rec_concat, trim(p_new_bsv)) else tgt_gl_rec_concat end,
           tgt_gl_rev_concat     = case when trim(p_new_bsv) is not null then remap_gl_bsv(tgt_gl_rev_concat, trim(p_new_bsv)) else tgt_gl_rev_concat end,
           tgt_gl_tax_concat     = case when trim(p_new_bsv) is not null then remap_gl_bsv(tgt_gl_tax_concat, trim(p_new_bsv)) else tgt_gl_tax_concat end,
           tgt_gl_freight_concat = case when trim(p_new_bsv) is not null then remap_gl_bsv(tgt_gl_freight_concat, trim(p_new_bsv)) else tgt_gl_freight_concat end,
           tgt_payment_term_name = coalesce(trim(p_payment_term), tgt_payment_term_name),
           tgt_warehouse_code    = coalesce(trim(p_warehouse_code), tgt_warehouse_code),
           tgt_order_type_name   = coalesce(trim(p_order_type), tgt_order_type_name),
           tgt_price_list_name   = coalesce(trim(p_price_list), tgt_price_list_name),
           tgt_tax_code          = coalesce(trim(p_tax_code), tgt_tax_code),
           updated_at            = systimestamp
     where project_id = p_project_id
       and (p_only_included = 'N' or include_yn = 'Y');

    if trim(p_payment_term) is not null then
      update xxcr_stg_customers
         set tgt_payment_term_name = trim(p_payment_term),
             updated_at            = systimestamp
       where project_id = p_project_id
         and (p_only_included = 'N' or include_yn = 'Y');
    end if;

    sync_deltas(p_project_id);
    validate_project(p_project_id);
  end bulk_manipulate_data;

  procedure cascade_exclusions(
    p_project_id in number,
    p_import_id  in number default null
  ) is
    c_acct_tag constant varchar2(40) := '[AUTO-EXCLUDED: Account]';
    c_site_tag constant varchar2(40) := '[AUTO-EXCLUDED: Site]';
  begin
    -- A. Restore children that were ONLY auto-excluded if parent Account/Site was re-enabled to 'Y'
    update xxcr_stg_sites s
       set s.include_yn = 'Y',
           s.user_notes = trim(replace(s.user_notes, c_acct_tag, '')),
           s.updated_at = systimestamp
     where s.project_id = p_project_id
       and s.include_yn = 'N'
       and instr(nvl(s.user_notes, '~'), c_acct_tag) > 0
       and exists (
         select 1 from xxcr_stg_customers c
          where c.stg_cust_id = s.stg_cust_id
            and c.include_yn = 'Y'
       );

    update xxcr_stg_site_uses su
       set su.include_yn = 'Y',
           su.user_notes = trim(replace(replace(su.user_notes, c_acct_tag, ''), c_site_tag, '')),
           su.updated_at = systimestamp
     where su.project_id = p_project_id
       and su.include_yn = 'N'
       and (instr(nvl(su.user_notes, '~'), c_acct_tag) > 0 or instr(nvl(su.user_notes, '~'), c_site_tag) > 0)
       and exists (
         select 1
           from xxcr_stg_sites s
           join xxcr_stg_customers c on c.stg_cust_id = s.stg_cust_id
          where s.stg_site_id = su.stg_site_id
            and s.include_yn = 'Y'
            and c.include_yn = 'Y'
       );

    update xxcr_stg_contacts ct
       set ct.include_yn = 'Y',
           ct.user_notes = trim(replace(replace(ct.user_notes, c_acct_tag, ''), c_site_tag, '')),
           ct.updated_at = systimestamp
     where ct.project_id = p_project_id
       and ct.include_yn = 'N'
       and (instr(nvl(ct.user_notes, '~'), c_acct_tag) > 0 or instr(nvl(ct.user_notes, '~'), c_site_tag) > 0)
       and exists (
         select 1 from xxcr_stg_customers c
          where c.stg_cust_id = ct.stg_cust_id
            and c.include_yn = 'Y'
       )
       and (
         ct.stg_site_id is null
         or exists (
           select 1 from xxcr_stg_sites s
            where s.stg_site_id = ct.stg_site_id
              and s.include_yn = 'Y'
         )
       );

    -- B. Cascade Account-Level Exclusions (INCLUDE_YN = 'N') -> Sites
    if p_import_id is not null then
      insert into xxcr_xls_deltas (
        import_id, project_id, sheet_name, entity_level, stg_row_id,
        record_key, column_name, old_value, new_value, change_type
      )
      select p_import_id, p_project_id, 'CASCADE_FROM_ACCOUNT', 'SITE', s.stg_site_id,
             s.site_ref_code, 'INCLUDE_YN', 'Y', 'N', 'CASCADE_EXCLUDE'
        from xxcr_stg_sites s
        join xxcr_stg_customers c on c.stg_cust_id = s.stg_cust_id
       where s.project_id = p_project_id
         and s.include_yn = 'Y'
         and c.include_yn = 'N';
    end if;

    update xxcr_stg_sites s
       set s.include_yn = 'N',
           s.user_notes = case
             when instr(nvl(s.user_notes, '~'), c_acct_tag) > 0 then s.user_notes
             else substr(trim(s.user_notes || ' ' || c_acct_tag), 1, 1000)
           end,
           s.updated_at = systimestamp
     where s.project_id = p_project_id
       and s.include_yn = 'Y'
       and exists (
         select 1 from xxcr_stg_customers c
          where c.stg_cust_id = s.stg_cust_id
            and c.include_yn = 'N'
       );

    -- C. Cascade Account-Level & Site-Level Exclusions -> Site Uses
    if p_import_id is not null then
      insert into xxcr_xls_deltas (
        import_id, project_id, sheet_name, entity_level, stg_row_id,
        record_key, column_name, old_value, new_value, change_type
      )
      select p_import_id, p_project_id, 'CASCADE_FROM_PARENT', 'SITE_USE', su.stg_site_use_id,
             su.site_ref_code || ':' || su.tgt_site_use_code, 'INCLUDE_YN', 'Y', 'N', 'CASCADE_EXCLUDE'
        from xxcr_stg_site_uses su
        join xxcr_stg_sites s on s.stg_site_id = su.stg_site_id
        join xxcr_stg_customers c on c.stg_cust_id = su.stg_cust_id
       where su.project_id = p_project_id
         and su.include_yn = 'Y'
         and (c.include_yn = 'N' or s.include_yn = 'N');
    end if;

    update xxcr_stg_site_uses su
       set su.include_yn = 'N',
           su.user_notes = case
             when exists (select 1 from xxcr_stg_customers c where c.stg_cust_id = su.stg_cust_id and c.include_yn = 'N') then
               case when instr(nvl(su.user_notes, '~'), c_acct_tag) > 0 then su.user_notes
                    else substr(trim(su.user_notes || ' ' || c_acct_tag), 1, 1000) end
             else
               case when instr(nvl(su.user_notes, '~'), c_site_tag) > 0 then su.user_notes
                    else substr(trim(su.user_notes || ' ' || c_site_tag), 1, 1000) end
           end,
           su.updated_at = systimestamp
     where su.project_id = p_project_id
       and su.include_yn = 'Y'
       and (
         exists (select 1 from xxcr_stg_customers c where c.stg_cust_id = su.stg_cust_id and c.include_yn = 'N')
         or exists (select 1 from xxcr_stg_sites s where s.stg_site_id = su.stg_site_id and s.include_yn = 'N')
       );

    -- D. Cascade Account-Level & Site-Level Exclusions -> Contacts
    if p_import_id is not null then
      insert into xxcr_xls_deltas (
        import_id, project_id, sheet_name, entity_level, stg_row_id,
        record_key, column_name, old_value, new_value, change_type
      )
      select p_import_id, p_project_id, 'CASCADE_FROM_PARENT', 'CONTACT', ct.stg_contact_id,
             ct.contact_ref_code, 'INCLUDE_YN', 'Y', 'N', 'CASCADE_EXCLUDE'
        from xxcr_stg_contacts ct
        join xxcr_stg_customers c on c.stg_cust_id = ct.stg_cust_id
        left join xxcr_stg_sites s on s.stg_site_id = ct.stg_site_id
       where ct.project_id = p_project_id
         and ct.include_yn = 'Y'
         and (c.include_yn = 'N' or (ct.stg_site_id is not null and s.include_yn = 'N'));
    end if;

    update xxcr_stg_contacts ct
       set ct.include_yn = 'N',
           ct.user_notes = case
             when exists (select 1 from xxcr_stg_customers c where c.stg_cust_id = ct.stg_cust_id and c.include_yn = 'N') then
               case when instr(nvl(ct.user_notes, '~'), c_acct_tag) > 0 then ct.user_notes
                    else substr(trim(ct.user_notes || ' ' || c_acct_tag), 1, 1000) end
             else
               case when instr(nvl(ct.user_notes, '~'), c_site_tag) > 0 then ct.user_notes
                    else substr(trim(ct.user_notes || ' ' || c_site_tag), 1, 1000) end
           end,
           ct.updated_at = systimestamp
     where ct.project_id = p_project_id
       and ct.include_yn = 'Y'
       and (
         exists (select 1 from xxcr_stg_customers c where c.stg_cust_id = ct.stg_cust_id and c.include_yn = 'N')
         or (
           ct.stg_site_id is not null
           and exists (select 1 from xxcr_stg_sites s where s.stg_site_id = ct.stg_site_id and s.include_yn = 'N')
         )
       );

    -- E. Cascade Account & Site-Use Exclusions -> Multi-Currency Credit, Account Relationships & Payment Instruments
    update xxcr_stg_profile_amts pa
       set pa.include_yn = 'N',
           pa.user_notes = case when instr(nvl(pa.user_notes, '~'), c_acct_tag) > 0 then pa.user_notes
                                else substr(trim(pa.user_notes || ' ' || c_acct_tag), 1, 1000) end
     where pa.project_id = p_project_id
       and pa.include_yn = 'Y'
       and (
         exists (select 1 from xxcr_stg_customers c where c.stg_cust_id = pa.stg_cust_id and c.include_yn = 'N')
         or (pa.stg_site_use_id is not null and exists (select 1 from xxcr_stg_site_uses su where su.stg_site_use_id = pa.stg_site_use_id and su.include_yn = 'N'))
       );

    update xxcr_stg_acct_relates rel
       set rel.include_yn = 'N',
           rel.user_notes = case when instr(nvl(rel.user_notes, '~'), c_acct_tag) > 0 then rel.user_notes
                                 else substr(trim(rel.user_notes || ' ' || c_acct_tag), 1, 1000) end
     where rel.project_id = p_project_id
       and rel.include_yn = 'Y'
       and (
         exists (select 1 from xxcr_stg_customers c where c.stg_cust_id = rel.stg_cust_id and c.include_yn = 'N')
         or (rel.related_stg_cust_id is not null and exists (select 1 from xxcr_stg_customers c2 where c2.stg_cust_id = rel.related_stg_cust_id and c2.include_yn = 'N'))
       );

    update xxcr_stg_payment_instr pmt
       set pmt.include_yn = 'N',
           pmt.user_notes = case when instr(nvl(pmt.user_notes, '~'), c_acct_tag) > 0 then pmt.user_notes
                                 else substr(trim(pmt.user_notes || ' ' || c_acct_tag), 1, 1000) end
     where pmt.project_id = p_project_id
       and pmt.include_yn = 'Y'
       and (
         exists (select 1 from xxcr_stg_customers c where c.stg_cust_id = pmt.stg_cust_id and c.include_yn = 'N')
         or (pmt.stg_site_use_id is not null and exists (select 1 from xxcr_stg_site_uses su where su.stg_site_use_id = pmt.stg_site_use_id and su.include_yn = 'N'))
       );
  end cascade_exclusions;

  procedure sync_deltas(p_project_id in number) is
    l_src_curr varchar2(15);
  begin
    select nvl(src_currency_code, 'AUD') into l_src_curr from xxcr_projects where project_id = p_project_id;

    -- 0. Cascade any Account or Site Exclusions / Re-inclusions across all child tables
    cascade_exclusions(p_project_id => p_project_id, p_import_id => null);

    -- 1. Customers Delta
    update xxcr_stg_customers
       set norm_party_name = normalize_party_name(tgt_party_name),
           modified_yn = case
             when nvl(tgt_account_number, '~')       <> nvl(src_account_number, '~')
               or nvl(tgt_party_name, '~')           <> nvl(src_party_name, '~')
               or nvl(tgt_account_name, '~')         <> nvl(src_account_name, '~')
               or nvl(tgt_tax_reference, '~')        <> nvl(src_tax_reference, '~')
               or nvl(tgt_customer_class_code, '~')  <> nvl(src_customer_class_code, '~')
               or nvl(tgt_profile_class_name, '~')   <> nvl(nvl(src_profile_class_name, 'DEFAULT'), '~')
               or nvl(tgt_payment_term_name, '~')    <> nvl(src_payment_term_name, '~')
               or nvl(tgt_credit_currency, '~')      <> nvl(nvl(src_credit_currency, l_src_curr), '~')
               or nvl(tgt_overall_credit_limit, -1)  <> nvl(src_overall_credit_limit, -1)
             then 'Y' else 'N' end,
           change_summary = trim(both ';' from
             case when nvl(tgt_account_number, '~') <> nvl(src_account_number, '~') then 'Acct#; ' end ||
             case when nvl(tgt_party_name, '~') <> nvl(src_party_name, '~') then 'Party Name; ' end ||
             case when nvl(tgt_payment_term_name, '~') <> nvl(src_payment_term_name, '~') then 'Payment Term; ' end ||
             case when nvl(tgt_credit_currency, '~') <> nvl(nvl(src_credit_currency, l_src_curr), '~') then 'Currency; ' end ||
             case when nvl(tgt_overall_credit_limit, -1) <> nvl(src_overall_credit_limit, -1) then 'Credit Limit; ' end
           )
     where project_id = p_project_id;

    -- 2. Sites & Address Change Detection (Auto-switch to NEW_ADDRESS when physical address modified!)
    for r in (
      select stg_site_id,
             src_party_site_id,
             src_addr_hash,
             tgt_country,
             tgt_address1,
             tgt_address2,
             tgt_address3,
             tgt_address4,
             tgt_city,
             tgt_state,
             tgt_province,
             tgt_county,
             tgt_postal_code,
             src_ece_tp_location_code,
             tgt_ece_tp_location_code,
             src_customer_category,
             tgt_customer_category
        from xxcr_stg_sites
       where project_id = p_project_id
    ) loop
      declare
        l_new_hash varchar2(64);
        l_addr_chg varchar2(1);
        l_mode     varchar2(30);
      begin
        l_new_hash := compute_addr_hash(
          r.tgt_country, r.tgt_address1, r.tgt_address2, r.tgt_address3, r.tgt_address4,
          r.tgt_city, r.tgt_state, r.tgt_province, r.tgt_county, r.tgt_postal_code
        );
        if r.src_party_site_id is null or l_new_hash <> nvl(r.src_addr_hash, '~') then
          l_addr_chg := 'Y';
          l_mode     := 'NEW_ADDRESS';
        else
          l_addr_chg := 'N';
          l_mode     := 'REUSE_PARTY_SITE';
        end if;

        update xxcr_stg_sites
           set norm_address_key = normalize_address_key(r.tgt_country, r.tgt_address1, r.tgt_city, r.tgt_state, r.tgt_postal_code),
               addr_changed_yn  = l_addr_chg,
               address_mode     = l_mode,
               modified_yn      = case when l_addr_chg = 'Y'
                                         or nvl(r.tgt_ece_tp_location_code, '~') <> nvl(r.src_ece_tp_location_code, '~')
                                         or nvl(r.tgt_customer_category, '~') <> nvl(r.src_customer_category, '~')
                                       then 'Y' else 'N' end,
               change_summary   = case when l_addr_chg = 'Y' then 'Physical Address Modified -> New Party Site'
                                       when nvl(r.tgt_customer_category, '~') <> nvl(r.src_customer_category, '~') then 'Category Modified'
                                       else null end
         where stg_site_id = r.stg_site_id;
      end;
    end loop;

    -- 3. Site Uses Delta
    update xxcr_stg_site_uses
       set modified_yn = case
             when nvl(tgt_gl_rec_concat, '~')        <> nvl(src_gl_rec_concat, '~')
               or nvl(tgt_gl_rev_concat, '~')        <> nvl(src_gl_rev_concat, '~')
               or nvl(tgt_gl_tax_concat, '~')        <> nvl(src_gl_tax_concat, '~')
               or nvl(tgt_gl_freight_concat, '~')    <> nvl(src_gl_freight_concat, '~')
               or nvl(tgt_payment_term_name, '~')    <> nvl(src_payment_term_name, '~')
               or nvl(tgt_salesrep_name, '~')        <> nvl(src_salesrep_name, '~')
               or nvl(tgt_order_type_name, '~')      <> nvl(src_order_type_name, '~')
               or nvl(tgt_price_list_name, '~')      <> nvl(src_price_list_name, '~')
               or nvl(tgt_warehouse_code, '~')       <> nvl(src_warehouse_code, '~')
               or nvl(tgt_tax_code, '~')             <> nvl(src_tax_code, '~')
               or nvl(tgt_profile_class_name, '~')   <> nvl(src_profile_class_name, '~')
               or nvl(tgt_collector_name, '~')       <> nvl(src_collector_name, '~')
               or nvl(tgt_overall_credit_limit, -1)  <> nvl(src_overall_credit_limit, -1)
               or nvl(tgt_trx_credit_limit, -1)      <> nvl(src_trx_credit_limit, -1)
             then 'Y' else 'N' end,
           change_summary = trim(both ';' from
             case when nvl(tgt_gl_rec_concat, '~') <> nvl(src_gl_rec_concat, '~') then 'GL Rec; ' end ||
             case when nvl(tgt_gl_rev_concat, '~') <> nvl(src_gl_rev_concat, '~') then 'GL Rev; ' end ||
             case when nvl(tgt_payment_term_name, '~') <> nvl(src_payment_term_name, '~') then 'Terms; ' end ||
             case when nvl(tgt_overall_credit_limit, -1) <> nvl(src_overall_credit_limit, -1) then 'Credit Limit; ' end ||
             case when nvl(tgt_trx_credit_limit, -1) <> nvl(src_trx_credit_limit, -1) then 'Order Limit; ' end ||
             case when nvl(tgt_warehouse_code, '~') <> nvl(src_warehouse_code, '~') then 'Warehouse; ' end ||
             case when nvl(tgt_order_type_name, '~') <> nvl(src_order_type_name, '~') then 'Order Type; ' end ||
             case when nvl(tgt_price_list_name, '~') <> nvl(src_price_list_name, '~') then 'Price List; ' end
           )
     where project_id = p_project_id;

    -- 4. Contacts Delta
    update xxcr_stg_contacts
       set norm_contact_key = upper(trim(nvl(tgt_email_address, tgt_first_name || ' ' || tgt_last_name))),
           contact_action   = case
             when src_person_party_id is null
               or upper(nvl(tgt_first_name, '~')) <> upper(nvl(src_first_name, '~'))
               or upper(nvl(tgt_last_name, '~'))  <> upper(nvl(src_last_name, '~'))
             then 'NEW_PERSON' else 'REUSE_PERSON' end,
           modified_yn      = case
             when nvl(tgt_first_name, '~')    <> nvl(src_first_name, '~')
               or nvl(tgt_last_name, '~')     <> nvl(src_last_name, '~')
               or nvl(tgt_email_address, '~') <> nvl(src_email_address, '~')
               or nvl(tgt_phone_number, '~')  <> nvl(src_phone_number, '~')
               or nvl(tgt_job_title, '~')     <> nvl(src_job_title, '~')
             then 'Y' else 'N' end
     where project_id = p_project_id;
  end sync_deltas;

  ------------------------------------------------------------------------------
  -- 5. "Find Duplicates" Engine (Activity-Ranked Survivor: Open AR > Trx/SO > Primary)
  ------------------------------------------------------------------------------
  procedure find_duplicates(p_project_id in number) is
  begin
    delete from xxcr_duplicates
     where project_id = p_project_id
       and resolution_action = 'OPEN';

    -- 5.1 Customer-Level Intra-Batch Duplicates (Ranked by Open AR > 24m Trx > Credit Limit)
    insert into xxcr_duplicates (
      project_id, entity_level, stg_row_id, account_number, site_ref_code,
      match_scope, match_rule, similarity_score,
      source_display, matched_display, matched_stg_id,
      dup_open_ar_amt, dup_activity_cnt, survivor_open_ar_amt, survivor_activity_cnt,
      resolution_action
    )
    select project_id, entity_level, stg_row_id, account_number, null,
           match_scope, match_rule, similarity_score,
           source_display, matched_display, matched_stg_id,
           dup_open_ar_amt, dup_activity_cnt, survivor_open_ar_amt, survivor_activity_cnt,
           'OPEN'
      from (
        with ranked_cust as (
          select c.*,
                 row_number() over (
                   order by abs(nvl(c.src_open_ar_amt, 0)) desc,
                            nvl(c.src_trx_cnt_recent, 0) desc,
                            nvl(c.tgt_overall_credit_limit, 0) desc,
                            nvl(c.src_last_trx_date, date '1900-01-01') desc,
                            c.stg_cust_id asc
                 ) as surv_rnk
            from xxcr_stg_customers c
           where c.project_id = p_project_id
             and c.include_yn = 'Y'
             and c.norm_party_name is not null
        )
        select p_project_id as project_id,
               'CUSTOMER' as entity_level,
               c1.stg_cust_id as stg_row_id,
               c1.tgt_account_number as account_number,
               'INTRA_BATCH' as match_scope,
               case
                 when c1.tgt_tax_reference is not null and c1.tgt_tax_reference = c2.tgt_tax_reference then 'EXACT_TAX_ID'
                 when c1.norm_party_name = c2.norm_party_name then 'EXACT_NORM_PARTY_NAME'
                 else 'FUZZY_PARTY_NAME'
               end as match_rule,
               case
                 when c1.tgt_tax_reference is not null and c1.tgt_tax_reference = c2.tgt_tax_reference then 100
                 else utl_match.jaro_winkler_similarity(c1.norm_party_name, c2.norm_party_name)
               end as similarity_score,
               c1.tgt_account_number || ' - ' || c1.tgt_party_name ||
                 case when c1.tgt_account_name is not null then ' (' || c1.tgt_account_name || ')' end as source_display,
               c2.tgt_account_number || ' - ' || c2.tgt_party_name ||
                 case when c2.tgt_account_name is not null then ' (' || c2.tgt_account_name || ')' end as matched_display,
               c2.stg_cust_id as matched_stg_id,
               nvl(c1.src_open_ar_amt, 0) as dup_open_ar_amt,
               nvl(c1.src_trx_cnt_recent, 0) as dup_activity_cnt,
               nvl(c2.src_open_ar_amt, 0) as survivor_open_ar_amt,
               nvl(c2.src_trx_cnt_recent, 0) as survivor_activity_cnt,
               row_number() over (partition by c1.stg_cust_id order by c2.surv_rnk asc) as rn
          from ranked_cust c1
          join ranked_cust c2
            on c2.surv_rnk < c1.surv_rnk
           -- Legitimate business stream split: NEVER collapse MACHINES vs AFTERMARKET (even across separate PARTY_IDs)
           and nvl(upper(trim(c1.tgt_account_name)), '~') = nvl(upper(trim(c2.tgt_account_name)), '~')
           and (
             (c1.tgt_tax_reference is not null and c1.tgt_tax_reference = c2.tgt_tax_reference)
             or utl_match.jaro_winkler_similarity(c1.norm_party_name, c2.norm_party_name) >= 88
           )
         where not exists (
           select 1 from xxcr_duplicates d
            where d.project_id = p_project_id
              and d.entity_level = 'CUSTOMER'
              and d.stg_row_id = c1.stg_cust_id
         )
      )
     where rn = 1;

    -- 5.2 Address / Site-Level Duplicates (Ranked by Open AR > 24m Trx + Open SO > Primary Site Use > Last Activity)
    insert into xxcr_duplicates (
      project_id, entity_level, stg_row_id, account_number, site_ref_code,
      match_scope, match_rule, similarity_score,
      source_display, matched_display, matched_stg_id,
      dup_open_ar_amt, dup_activity_cnt, survivor_open_ar_amt, survivor_activity_cnt,
      resolution_action
    )
    select project_id, entity_level, stg_row_id, account_number, site_ref_code,
           match_scope, match_rule, similarity_score,
           source_display, matched_display, matched_stg_id,
           dup_open_ar_amt, dup_activity_cnt, survivor_open_ar_amt, survivor_activity_cnt,
           'OPEN'
      from (
        with ranked_sites as (
          select s.*,
                 (select count(*)
                    from xxcr_stg_site_uses su
                   where su.stg_site_id = s.stg_site_id
                     and su.include_yn = 'Y'
                     and su.tgt_primary_flag = 'Y') as prim_su_cnt,
                 row_number() over (
                   partition by s.stg_cust_id
                   order by abs(nvl(s.src_open_ar_amt, 0)) desc,
                            (nvl(s.src_trx_cnt_recent, 0) + nvl(s.src_open_so_cnt, 0)) desc,
                            (select count(*)
                               from xxcr_stg_site_uses su
                              where su.stg_site_id = s.stg_site_id
                                and su.include_yn = 'Y'
                                and su.tgt_primary_flag = 'Y') desc,
                            nvl(s.src_last_trx_date, date '1900-01-01') desc,
                            s.stg_site_id asc
                 ) as surv_rnk
            from xxcr_stg_sites s
            join xxcr_stg_customers c on c.stg_cust_id = s.stg_cust_id
           where s.project_id = p_project_id
             and s.include_yn = 'Y'
             and c.include_yn = 'Y'
        )
        select p_project_id as project_id,
               'ADDRESS_SITE' as entity_level,
               s1.stg_site_id as stg_row_id,
               s1.tgt_account_number as account_number,
               s1.site_ref_code,
               'INTRA_BATCH' as match_scope,
               case
                 when s1.norm_address_key = s2.norm_address_key then 'EXACT_NORMALIZED_ADDRESS'
                 else 'FUZZY_POSTAL_ADDRESS'
               end as match_rule,
               utl_match.jaro_winkler_similarity(upper(s1.tgt_address1), upper(s2.tgt_address1)) as similarity_score,
               s1.site_ref_code || ' (PartySite ' || nvl(s1.tgt_party_site_number, 'NEW') || '): ' ||
                 s1.tgt_address1 || ', ' || s1.tgt_city || ' ' || s1.tgt_state || ' ' || s1.tgt_postal_code as source_display,
               s2.site_ref_code || ' (PartySite ' || nvl(s2.tgt_party_site_number, 'NEW') || '): ' ||
                 s2.tgt_address1 || ', ' || s2.tgt_city || ' ' || s2.tgt_state || ' ' || s2.tgt_postal_code as matched_display,
               s2.stg_site_id as matched_stg_id,
               nvl(s1.src_open_ar_amt, 0) as dup_open_ar_amt,
               nvl(s1.src_trx_cnt_recent, 0) + nvl(s1.src_open_so_cnt, 0) as dup_activity_cnt,
               nvl(s2.src_open_ar_amt, 0) as survivor_open_ar_amt,
               nvl(s2.src_trx_cnt_recent, 0) + nvl(s2.src_open_so_cnt, 0) as survivor_activity_cnt,
               row_number() over (partition by s1.stg_site_id order by s2.surv_rnk asc) as rn
          from ranked_sites s1
          join ranked_sites s2
            on s2.stg_cust_id = s1.stg_cust_id
           and s2.surv_rnk < s1.surv_rnk
           and nvl(s1.tgt_country, 'X') = nvl(s2.tgt_country, 'X')
           and nvl(upper(s1.tgt_city), 'X') = nvl(upper(s2.tgt_city), 'X')
           and nvl(s1.tgt_postal_code, 'X') = nvl(s2.tgt_postal_code, 'X')
           and (
             s1.norm_address_key = s2.norm_address_key
             or utl_match.jaro_winkler_similarity(upper(s1.tgt_address1), upper(s2.tgt_address1)) >= 92
           )
         where not exists (
           select 1 from xxcr_duplicates d
            where d.project_id = p_project_id
              and d.entity_level = 'ADDRESS_SITE'
              and d.stg_row_id = s1.stg_site_id
         )
      )
     where rn = 1;

    -- 5.3 Site-Use Duplicates (Same Customer + Same Site Use Code [BILL_TO / SHIP_TO] at Same Physical Address)
    insert into xxcr_duplicates (
      project_id, entity_level, stg_row_id, account_number, site_ref_code,
      match_scope, match_rule, similarity_score,
      source_display, matched_display, matched_stg_id,
      dup_open_ar_amt, dup_activity_cnt, survivor_open_ar_amt, survivor_activity_cnt,
      resolution_action
    )
    select project_id, entity_level, stg_row_id, account_number, site_ref_code,
           match_scope, match_rule, similarity_score,
           source_display, matched_display, matched_stg_id,
           dup_open_ar_amt, dup_activity_cnt, survivor_open_ar_amt, survivor_activity_cnt,
           'OPEN'
      from (
        with ranked_su as (
          select su.stg_site_use_id,
                 su.stg_cust_id,
                 su.stg_site_id,
                 su.site_ref_code,
                 su.tgt_account_number,
                 su.tgt_site_use_code,
                 su.tgt_location_code,
                 su.tgt_primary_flag,
                 su.tgt_overall_credit_limit,
                 nvl(su.src_open_ar_amt, 0) as open_ar_amt,
                 nvl(su.src_trx_cnt_recent, 0) + nvl(su.src_open_so_cnt, 0) as activity_cnt,
                 s.norm_address_key,
                 s.tgt_country,
                 s.tgt_address1,
                 s.tgt_city,
                 s.tgt_postal_code,
                 row_number() over (
                   partition by su.stg_cust_id, su.tgt_site_use_code
                   order by abs(nvl(su.src_open_ar_amt, 0)) desc,
                            (nvl(su.src_trx_cnt_recent, 0) + nvl(su.src_open_so_cnt, 0)) desc,
                            decode(nvl(su.tgt_primary_flag, 'N'), 'Y', 1, 0) desc,
                            nvl(su.tgt_overall_credit_limit, 0) desc,
                            nvl(su.src_last_trx_date, date '1900-01-01') desc,
                            su.stg_site_use_id asc
                 ) as surv_rnk
            from xxcr_stg_site_uses su
            join xxcr_stg_sites s on s.stg_site_id = su.stg_site_id
            join xxcr_stg_customers c on c.stg_cust_id = su.stg_cust_id
           where su.project_id = p_project_id
             and su.include_yn = 'Y'
             and s.include_yn = 'Y'
             and c.include_yn = 'Y'
        )
        select p_project_id as project_id,
               'SITE_USE' as entity_level,
               u1.stg_site_use_id as stg_row_id,
               u1.tgt_account_number as account_number,
               u1.site_ref_code,
               'INTRA_BATCH' as match_scope,
               case
                 when u1.stg_site_id = u2.stg_site_id then 'SAME_SITE_DUPLICATE_USE'
                 else 'SAME_ADDRESS_DUPLICATE_USE'
               end as match_rule,
               case
                 when u1.stg_site_id = u2.stg_site_id or u1.norm_address_key = u2.norm_address_key then 100
                 else utl_match.jaro_winkler_similarity(upper(u1.tgt_address1), upper(u2.tgt_address1))
               end as similarity_score,
               u1.tgt_site_use_code || ' Loc ' || u1.tgt_location_code || ' (' || u1.site_ref_code || '): ' ||
                 u1.tgt_address1 || ', ' || u1.tgt_city as source_display,
               u2.tgt_site_use_code || ' Loc ' || u2.tgt_location_code || ' (' || u2.site_ref_code || '): ' ||
                 u2.tgt_address1 || ', ' || u2.tgt_city as matched_display,
               u2.stg_site_use_id as matched_stg_id,
               u1.open_ar_amt as dup_open_ar_amt,
               u1.activity_cnt as dup_activity_cnt,
               u2.open_ar_amt as survivor_open_ar_amt,
               u2.activity_cnt as survivor_activity_cnt,
               row_number() over (partition by u1.stg_site_use_id order by u2.surv_rnk asc) as rn
          from ranked_su u1
          join ranked_su u2
            on u2.stg_cust_id = u1.stg_cust_id
           and u2.tgt_site_use_code = u1.tgt_site_use_code
           and u2.surv_rnk < u1.surv_rnk
           and (
             u1.stg_site_id = u2.stg_site_id
             or (
               nvl(u1.tgt_country, 'X') = nvl(u2.tgt_country, 'X')
               and nvl(upper(u1.tgt_city), 'X') = nvl(upper(u2.tgt_city), 'X')
               and nvl(u1.tgt_postal_code, 'X') = nvl(u2.tgt_postal_code, 'X')
               and (
                 u1.norm_address_key = u2.norm_address_key
                 or utl_match.jaro_winkler_similarity(upper(u1.tgt_address1), upper(u2.tgt_address1)) >= 92
               )
             )
           )
         where not exists (
           select 1 from xxcr_duplicates d
            where d.project_id = p_project_id
              and d.entity_level = 'SITE_USE'
              and d.stg_row_id = u1.stg_site_use_id
         )
      )
     where rn = 1;

    -- 5.4 Contact-Level Duplicates (Duplicate contact roles on the SAME Customer Site)
    insert into xxcr_duplicates (
      project_id, entity_level, stg_row_id, account_number, site_ref_code,
      match_scope, match_rule, similarity_score,
      source_display, matched_display, matched_stg_id,
      dup_open_ar_amt, dup_activity_cnt, survivor_open_ar_amt, survivor_activity_cnt,
      resolution_action
    )
    select project_id, entity_level, stg_row_id, account_number, site_ref_code,
           match_scope, match_rule, similarity_score,
           source_display, matched_display, matched_stg_id,
           0, 0, 0, 0, 'OPEN'
      from (
        with ranked_ct as (
          select ct.*,
                 row_number() over (
                   partition by ct.stg_cust_id, nvl(ct.stg_site_id, -1), ct.norm_contact_key
                   order by decode(nvl(ct.tgt_primary_flag, 'N'), 'Y', 1, 0) desc,
                            case when ct.tgt_email_address is not null then 1 else 0 end desc,
                            case when ct.tgt_phone_number is not null then 1 else 0 end desc,
                            ct.stg_contact_id asc
                 ) as surv_rnk
            from xxcr_stg_contacts ct
            join xxcr_stg_customers c on c.stg_cust_id = ct.stg_cust_id
            left join xxcr_stg_sites s on s.stg_site_id = ct.stg_site_id
           where ct.project_id = p_project_id
             and ct.include_yn = 'Y'
             and c.include_yn = 'Y'
             and (ct.stg_site_id is null or s.include_yn = 'Y')
             and ct.norm_contact_key is not null
        )
        select p_project_id as project_id,
               'CONTACT' as entity_level,
               ct1.stg_contact_id as stg_row_id,
               ct1.tgt_account_number as account_number,
               ct1.site_ref_code,
               'INTRA_BATCH' as match_scope,
               case
                 when ct1.tgt_email_address is not null and upper(ct1.tgt_email_address) = upper(ct2.tgt_email_address)
                 then 'EXACT_EMAIL_ADDRESS'
                 else 'SAME_CONTACT_ON_SITE'
               end as match_rule,
               100 as similarity_score,
               ct1.contact_ref_code || ' (' || ct1.site_ref_code || '): ' ||
                 trim(ct1.tgt_first_name || ' ' || ct1.tgt_last_name) || ' <' || nvl(ct1.tgt_email_address, ct1.tgt_phone_number) || '>' as source_display,
               ct2.contact_ref_code || ' (' || ct2.site_ref_code || '): ' ||
                 trim(ct2.tgt_first_name || ' ' || ct2.tgt_last_name) || ' <' || nvl(ct2.tgt_email_address, ct2.tgt_phone_number) || '>' as matched_display,
               ct2.stg_contact_id as matched_stg_id,
               ct1.surv_rnk
          from ranked_ct ct1
          join ranked_ct ct2
            on ct2.stg_cust_id = ct1.stg_cust_id
           and nvl(ct2.stg_site_id, -1) = nvl(ct1.stg_site_id, -1)
           and ct2.norm_contact_key = ct1.norm_contact_key
           and ct2.surv_rnk = 1
         where ct1.surv_rnk > 1
           and not exists (
             select 1 from xxcr_duplicates d
              where d.project_id = p_project_id
                and d.entity_level = 'CONTACT'
                and d.stg_row_id = ct1.stg_contact_id
           )
      );

    -- Stamp Duplicate Counts AND Explicit Dup Role (UNIQUE / SURVIVOR / DUPLICATE -> Survivor Ref) on Staging Rows
    update xxcr_stg_customers c
       set dup_count = (
             select count(*) from xxcr_duplicates d
              where d.project_id = p_project_id
                and d.entity_level = 'CUSTOMER'
                and (d.stg_row_id = c.stg_cust_id or d.matched_stg_id = c.stg_cust_id)
                and d.resolution_action = 'OPEN'
           ),
           dup_role = case
             when c.include_yn = 'N' then
               case when exists (
                 select 1 from xxcr_duplicates d
                  where d.project_id = p_project_id and d.entity_level = 'CUSTOMER'
                    and d.stg_row_id = c.stg_cust_id and d.resolution_action = 'EXCLUDE_DUPLICATE'
               ) then 'EXCLUDED (DUPLICATE)' else 'EXCLUDED' end
             when exists (
               select 1 from xxcr_duplicates d
                where d.project_id = p_project_id and d.entity_level = 'CUSTOMER'
                  and d.stg_row_id = c.stg_cust_id and d.resolution_action = 'OPEN'
             ) then (
               select 'DUPLICATE -> Acct ' || c_surv.tgt_account_number
                 from xxcr_duplicates d
                 join xxcr_stg_customers c_surv on c_surv.stg_cust_id = d.matched_stg_id
                where d.project_id = p_project_id and d.entity_level = 'CUSTOMER'
                  and d.stg_row_id = c.stg_cust_id and d.resolution_action = 'OPEN'
                fetch first 1 row only
             )
             when exists (
               select 1 from xxcr_duplicates d
                where d.project_id = p_project_id and d.entity_level = 'CUSTOMER'
                  and d.matched_stg_id = c.stg_cust_id and d.resolution_action = 'OPEN'
             ) then (
               select 'SURVIVOR (' || count(*) || ' dup)'
                 from xxcr_duplicates d
                where d.project_id = p_project_id and d.entity_level = 'CUSTOMER'
                  and d.matched_stg_id = c.stg_cust_id and d.resolution_action = 'OPEN'
             )
             else 'UNIQUE'
           end
     where c.project_id = p_project_id;

    update xxcr_stg_sites s
       set dup_count = (
             select count(*) from xxcr_duplicates d
              where d.project_id = p_project_id
                and d.entity_level = 'ADDRESS_SITE'
                and (d.stg_row_id = s.stg_site_id or d.matched_stg_id = s.stg_site_id)
                and d.resolution_action = 'OPEN'
           ),
           dup_role = case
             when s.include_yn = 'N' then
               case when exists (
                 select 1 from xxcr_duplicates d
                  where d.project_id = p_project_id and d.entity_level = 'ADDRESS_SITE'
                    and d.stg_row_id = s.stg_site_id and d.resolution_action = 'EXCLUDE_DUPLICATE'
               ) then 'EXCLUDED (DUPLICATE)' else 'EXCLUDED' end
             when exists (
               select 1 from xxcr_duplicates d
                where d.project_id = p_project_id and d.entity_level = 'ADDRESS_SITE'
                  and d.stg_row_id = s.stg_site_id and d.resolution_action = 'OPEN'
             ) then (
               select 'DUPLICATE -> ' || s_surv.site_ref_code
                 from xxcr_duplicates d
                 join xxcr_stg_sites s_surv on s_surv.stg_site_id = d.matched_stg_id
                where d.project_id = p_project_id and d.entity_level = 'ADDRESS_SITE'
                  and d.stg_row_id = s.stg_site_id and d.resolution_action = 'OPEN'
                fetch first 1 row only
             )
             when exists (
               select 1 from xxcr_duplicates d
                where d.project_id = p_project_id and d.entity_level = 'ADDRESS_SITE'
                  and d.matched_stg_id = s.stg_site_id and d.resolution_action = 'OPEN'
             ) then (
               select 'SURVIVOR (' || count(*) || ' dup)'
                 from xxcr_duplicates d
                where d.project_id = p_project_id and d.entity_level = 'ADDRESS_SITE'
                  and d.matched_stg_id = s.stg_site_id and d.resolution_action = 'OPEN'
             )
             else 'UNIQUE'
           end
     where s.project_id = p_project_id;

    update xxcr_stg_site_uses su
       set dup_count = (
             select count(*) from xxcr_duplicates d
              where d.project_id = p_project_id
                and d.entity_level = 'SITE_USE'
                and (d.stg_row_id = su.stg_site_use_id or d.matched_stg_id = su.stg_site_use_id)
                and d.resolution_action = 'OPEN'
           ),
           dup_role = case
             when su.include_yn = 'N' then
               case when exists (
                 select 1 from xxcr_duplicates d
                  where d.project_id = p_project_id and d.entity_level = 'SITE_USE'
                    and d.stg_row_id = su.stg_site_use_id and d.resolution_action = 'EXCLUDE_DUPLICATE'
               ) then 'EXCLUDED (DUPLICATE)' else 'EXCLUDED' end
             when exists (
               select 1 from xxcr_duplicates d
                where d.project_id = p_project_id and d.entity_level = 'SITE_USE'
                  and d.stg_row_id = su.stg_site_use_id and d.resolution_action = 'OPEN'
             ) then (
               select 'DUPLICATE -> ' || u_surv.site_ref_code || ' (Loc ' || u_surv.tgt_location_code || ')'
                 from xxcr_duplicates d
                 join xxcr_stg_site_uses u_surv on u_surv.stg_site_use_id = d.matched_stg_id
                where d.project_id = p_project_id and d.entity_level = 'SITE_USE'
                  and d.stg_row_id = su.stg_site_use_id and d.resolution_action = 'OPEN'
                fetch first 1 row only
             )
             when exists (
               select 1 from xxcr_duplicates d
                where d.project_id = p_project_id and d.entity_level = 'SITE_USE'
                  and d.matched_stg_id = su.stg_site_use_id and d.resolution_action = 'OPEN'
             ) then (
               select 'SURVIVOR (' || count(*) || ' dup)'
                 from xxcr_duplicates d
                where d.project_id = p_project_id and d.entity_level = 'SITE_USE'
                  and d.matched_stg_id = su.stg_site_use_id and d.resolution_action = 'OPEN'
             )
             else 'UNIQUE'
           end
     where su.project_id = p_project_id;

    update xxcr_stg_contacts ct
       set dup_count = (
             select count(*) from xxcr_duplicates d
              where d.project_id = p_project_id
                and d.entity_level = 'CONTACT'
                and (d.stg_row_id = ct.stg_contact_id or d.matched_stg_id = ct.stg_contact_id)
                and d.resolution_action = 'OPEN'
           ),
           dup_role = case
             when ct.include_yn = 'N' then 'EXCLUDED'
             when exists (
               select 1 from xxcr_duplicates d
                where d.project_id = p_project_id and d.entity_level = 'CONTACT'
                  and d.stg_row_id = ct.stg_contact_id and d.resolution_action = 'OPEN'
             ) then 'DUPLICATE'
             when exists (
               select 1 from xxcr_duplicates d
                where d.project_id = p_project_id and d.entity_level = 'CONTACT'
                  and d.matched_stg_id = ct.stg_contact_id and d.resolution_action = 'OPEN'
             ) then 'SURVIVOR'
             else 'UNIQUE'
           end
     where ct.project_id = p_project_id;

    update xxcr_projects
       set last_dup_scan_at = systimestamp,
           updated_at = systimestamp
     where project_id = p_project_id;
  end find_duplicates;

  procedure resolve_duplicate(
    p_dup_id in number,
    p_action in varchar2,
    p_note   in varchar2 default null
  ) is
    l_dup xxcr_duplicates%rowtype;
  begin
    select * into l_dup from xxcr_duplicates where dup_id = p_dup_id;

    update xxcr_duplicates
       set resolution_action = p_action,
           resolution_note   = p_note,
           resolved_by       = coalesce(sys_context('APEX$SESSION','APP_USER'), user),
           resolved_at       = systimestamp
     where dup_id = p_dup_id;

    if p_action = 'EXCLUDE_DUPLICATE' then
      if l_dup.entity_level = 'CUSTOMER' then
        update xxcr_stg_customers
           set include_yn  = 'N',
               action_code = 'SKIP',
               user_notes  = substr(trim(user_notes || ' [Excluded duplicate of Stg#' || l_dup.matched_stg_id || ']'), 1, 1000)
         where stg_cust_id = l_dup.stg_row_id;
      elsif l_dup.entity_level = 'ADDRESS_SITE' then
        update xxcr_stg_sites
           set include_yn = 'N',
               user_notes = substr(trim(user_notes || ' [Excluded duplicate site of Stg#' || l_dup.matched_stg_id || ']'), 1, 1000)
         where stg_site_id = l_dup.stg_row_id;
      elsif l_dup.entity_level = 'SITE_USE' then
        update xxcr_stg_site_uses
           set include_yn = 'N',
               user_notes = substr(trim(user_notes || ' [Excluded duplicate site use of Stg#' || l_dup.matched_stg_id || ']'), 1, 1000)
         where stg_site_use_id = l_dup.stg_row_id;
      elsif l_dup.entity_level = 'CONTACT' then
        update xxcr_stg_contacts
           set include_yn = 'N',
               user_notes = substr(trim(user_notes || ' [Excluded duplicate contact]'), 1, 1000)
         where stg_contact_id = l_dup.stg_row_id;
      end if;
      cascade_exclusions(p_project_id => l_dup.project_id, p_import_id => null);
    elsif p_action = 'REUSE_EXISTING' and l_dup.entity_level = 'ADDRESS_SITE' and l_dup.matched_stg_id is not null then
      for r_surv in (select src_party_site_id, src_party_site_number, src_location_id from xxcr_stg_sites where stg_site_id = l_dup.matched_stg_id) loop
        update xxcr_stg_sites
           set src_party_site_id     = r_surv.src_party_site_id,
               tgt_party_site_number = r_surv.src_party_site_number,
               src_location_id       = r_surv.src_location_id,
               address_mode          = 'REUSE_PARTY_SITE',
               addr_changed_yn       = 'N',
               user_notes            = substr(trim(user_notes || ' [Linked to Survivor PartySite ' || r_surv.src_party_site_number || ']'), 1, 1000)
         where stg_site_id = l_dup.stg_row_id;
      end loop;
    end if;

    find_duplicates(l_dup.project_id);
    validate_project(l_dup.project_id);
  end resolve_duplicate;

  procedure auto_exclude_dormant_duplicates(
    p_project_id   in number,
    p_excluded_cnt out number
  ) is
    l_cnt_sites pls_integer := 0;
    l_cnt_su    pls_integer := 0;
    l_cnt_ct    pls_integer := 0;
    l_user      varchar2(100) := coalesce(sys_context('APEX$SESSION','APP_USER'), user);
  begin
    -- 1. Exclude Dormant Duplicate Sites ($0 Open AR and 0 Open Sales Orders across the entire site)
    update xxcr_stg_sites s
       set s.include_yn = 'N',
           s.user_notes = substr(trim(s.user_notes || ' [Auto-Excluded: $0 AR / 0 Open SO duplicate site]'), 1, 1000),
           s.updated_at = systimestamp
     where s.project_id = p_project_id
       and s.include_yn = 'Y'
       and nvl(s.src_open_ar_amt, 0) = 0
       and nvl(s.src_open_so_cnt, 0) = 0
       and exists (
         select 1 from xxcr_duplicates d
          where d.project_id = p_project_id
            and d.entity_level = 'ADDRESS_SITE'
            and d.stg_row_id = s.stg_site_id
            and d.resolution_action = 'OPEN'
       );
    l_cnt_sites := sql%rowcount;

    update xxcr_duplicates d
       set d.resolution_action = 'EXCLUDE_DUPLICATE',
           d.resolution_note   = 'Auto-excluded duplicate site ($0 Open AR, 0 Open Sales Orders)',
           d.resolved_by       = l_user,
           d.resolved_at       = systimestamp
     where d.project_id = p_project_id
       and d.entity_level = 'ADDRESS_SITE'
       and d.resolution_action = 'OPEN'
       and exists (
         select 1 from xxcr_stg_sites s
          where s.stg_site_id = d.stg_row_id
            and s.include_yn = 'N'
       );

    -- Cascade site exclusions down to child Site Uses and Contacts first
    cascade_exclusions(p_project_id => p_project_id, p_import_id => null);

    -- 2. Exclude Remaining Dormant Duplicate Site Uses ($0 Open AR and 0 Open Sales Orders)
    update xxcr_stg_site_uses su
       set su.include_yn = 'N',
           su.user_notes = substr(trim(su.user_notes || ' [Auto-Excluded: $0 AR / 0 Open SO duplicate site use]'), 1, 1000),
           su.updated_at = systimestamp
     where su.project_id = p_project_id
       and su.include_yn = 'Y'
       and nvl(su.src_open_ar_amt, 0) = 0
       and nvl(su.src_open_so_cnt, 0) = 0
       and exists (
         select 1 from xxcr_duplicates d
          where d.project_id = p_project_id
            and d.entity_level = 'SITE_USE'
            and d.stg_row_id = su.stg_site_use_id
            and d.resolution_action = 'OPEN'
       );
    l_cnt_su := sql%rowcount;

    update xxcr_duplicates d
       set d.resolution_action = 'EXCLUDE_DUPLICATE',
           d.resolution_note   = 'Auto-excluded dormant duplicate site use ($0 Open AR, 0 Activity)',
           d.resolved_by       = l_user,
           d.resolved_at       = systimestamp
     where d.project_id = p_project_id
       and d.entity_level = 'SITE_USE'
       and d.resolution_action = 'OPEN'
       and exists (
         select 1 from xxcr_stg_site_uses su
          where su.stg_site_use_id = d.stg_row_id
            and su.include_yn = 'N'
       );

    -- 3. Exclude Duplicate Contact Roles on the Same Site
    update xxcr_stg_contacts ct
       set ct.include_yn = 'N',
           ct.user_notes = substr(trim(ct.user_notes || ' [Auto-Excluded: duplicate contact on site]'), 1, 1000),
           ct.updated_at = systimestamp
     where ct.project_id = p_project_id
       and ct.include_yn = 'Y'
       and exists (
         select 1 from xxcr_duplicates d
          where d.project_id = p_project_id
            and d.entity_level = 'CONTACT'
            and d.stg_row_id = ct.stg_contact_id
            and d.resolution_action = 'OPEN'
       );
    l_cnt_ct := sql%rowcount;

    update xxcr_duplicates d
       set d.resolution_action = 'EXCLUDE_DUPLICATE',
           d.resolution_note   = 'Auto-excluded duplicate contact role on site',
           d.resolved_by       = l_user,
           d.resolved_at       = systimestamp
     where d.project_id = p_project_id
       and d.entity_level = 'CONTACT'
       and d.resolution_action = 'OPEN'
       and exists (
         select 1 from xxcr_stg_contacts ct
          where ct.stg_contact_id = d.stg_row_id
            and ct.include_yn = 'N'
       );

    p_excluded_cnt := l_cnt_sites + l_cnt_su + l_cnt_ct;

    find_duplicates(p_project_id);
    validate_project(p_project_id);
  end auto_exclude_dormant_duplicates;

  ------------------------------------------------------------------------------
  -- 6. 4-Stage Validation Phase Engine
  ------------------------------------------------------------------------------
  procedure validate_project(p_project_id in number) is
    l_proj xxcr_projects%rowtype;
  begin
    select * into l_proj from xxcr_projects where project_id = p_project_id;

    delete from xxcr_val_errors where project_id = p_project_id;

    -- =========================================================================
    -- STAGE 1: Structural & Mandatory Field Validation
    -- =========================================================================
    -- 1.1 Customer Mandatory Fields
    insert into xxcr_val_errors (
      project_id, val_stage, entity_level, stg_row_id, account_number,
      column_name, invalid_value, severity, error_code, error_message, suggested_fix
    )
    select p_project_id, '1_STRUCTURAL', 'CUSTOMER', stg_cust_id, tgt_account_number,
           'TGT_PARTY_NAME', tgt_party_name, 'ERROR', 'VAL-101',
           'Party Name is mandatory for all included customers.',
           'Populate TGT_PARTY_NAME in Customer Grid or Excel Tab 1.'
      from xxcr_stg_customers
     where project_id = p_project_id
       and include_yn = 'Y'
       and trim(tgt_party_name) is null;

    -- 1.2 Site Mandatory Address Fields
    insert into xxcr_val_errors (
      project_id, val_stage, entity_level, stg_row_id, account_number, site_ref_code,
      column_name, invalid_value, severity, error_code, error_message, suggested_fix
    )
    select p_project_id, '1_STRUCTURAL', 'SITE', stg_site_id, tgt_account_number, site_ref_code,
           'TGT_ADDRESS1 / TGT_COUNTRY', nvl(tgt_country, 'NULL') || ' / ' || nvl(tgt_address1, 'NULL'),
           'ERROR', 'VAL-102',
           'Country (2-char ISO) and Address Line 1 are mandatory for every included Customer Site.',
           'Enter a valid 2-character Country code and Street Address 1.'
      from xxcr_stg_sites
     where project_id = p_project_id
       and include_yn = 'Y'
       and (trim(tgt_country) is null or length(trim(tgt_country)) <> 2 or trim(tgt_address1) is null);

    -- =========================================================================
    -- STAGE 2: Cross-Tab Referential & Hierarchy Rules
    -- =========================================================================
    -- 2.1 Customer with zero included Sites
    insert into xxcr_val_errors (
      project_id, val_stage, entity_level, stg_row_id, account_number,
      column_name, invalid_value, severity, error_code, error_message, suggested_fix
    )
    select p_project_id, '2_HIERARCHY', 'CUSTOMER', c.stg_cust_id, c.tgt_account_number,
           'SITES', '0 Included Sites', 'ERROR', 'VAL-201',
           'Customer has no included Sites to create in Target Operating Unit.',
           'Include at least one Site in Tab 2 or exclude this Customer.'
      from xxcr_stg_customers c
     where c.project_id = p_project_id
       and c.include_yn = 'Y'
       and not exists (
         select 1 from xxcr_stg_sites s
          where s.stg_cust_id = c.stg_cust_id
            and s.include_yn = 'Y'
       );

    -- 2.2 Multiple Primary Flags for the same Site Use Code under one Customer
    insert into xxcr_val_errors (
      project_id, val_stage, entity_level, stg_row_id, account_number, site_ref_code,
      column_name, invalid_value, severity, error_code, error_message, suggested_fix
    )
    select p_project_id, '2_HIERARCHY', 'SITE_USE', su.stg_site_use_id, su.tgt_account_number, su.site_ref_code,
           'TGT_PRIMARY_FLAG', su.tgt_site_use_code || ' (Primary=Y)', 'ERROR', 'VAL-202',
           'Multiple Primary ' || su.tgt_site_use_code || ' site uses found for Customer ' || su.tgt_account_number || ' in Target OU.',
           'Ensure only one site use per Site_Use_Code has Primary_Flag = ''Y'' per customer.'
      from xxcr_stg_site_uses su
     where su.project_id = p_project_id
       and su.include_yn = 'Y'
       and su.tgt_primary_flag = 'Y'
       and exists (
         select 1 from xxcr_stg_site_uses su2
          where su2.project_id = su.project_id
            and su2.stg_cust_id = su.stg_cust_id
            and su2.include_yn = 'Y'
            and su2.tgt_site_use_code = su.tgt_site_use_code
            and su2.tgt_primary_flag = 'Y'
            and su2.stg_site_use_id <> su.stg_site_use_id
       );

    -- 2.3 SHIP_TO referencing a Bill_To_Location_Code that is not included for that customer
    insert into xxcr_val_errors (
      project_id, val_stage, entity_level, stg_row_id, account_number, site_ref_code,
      column_name, invalid_value, severity, error_code, error_message, suggested_fix
    )
    select p_project_id, '2_HIERARCHY', 'SITE_USE', su.stg_site_use_id, su.tgt_account_number, su.site_ref_code,
           'TGT_BILL_TO_LOCATION_CODE', su.tgt_bill_to_location_code, 'WARNING', 'VAL-203',
           'SHIP_TO references Bill-To Location ''' || su.tgt_bill_to_location_code || ''' which is not in the included BILL_TO rows for this customer.',
           'Include the referenced BILL_TO site use or clear TGT_BILL_TO_LOCATION_CODE.'
      from xxcr_stg_site_uses su
     where su.project_id = p_project_id
       and su.include_yn = 'Y'
       and su.tgt_site_use_code = 'SHIP_TO'
       and su.tgt_bill_to_location_code is not null
       and not exists (
         select 1 from xxcr_stg_site_uses bt
          where bt.project_id = su.project_id
            and bt.stg_cust_id = su.stg_cust_id
            and bt.include_yn = 'Y'
            and bt.tgt_site_use_code = 'BILL_TO'
            and bt.tgt_location_code = su.tgt_bill_to_location_code
       );

    -- =========================================================================
    -- STAGE 3: Target Legal Entity, Ledger & Operating Unit EBS Rules
    -- =========================================================================
    -- 3.1 BILL_TO Missing Receivable GL Account
    insert into xxcr_val_errors (
      project_id, val_stage, entity_level, stg_row_id, account_number, site_ref_code,
      column_name, invalid_value, severity, error_code, error_message, suggested_fix
    )
    select p_project_id, '3_EBS_TARGET_RULES', 'SITE_USE', su.stg_site_use_id, su.tgt_account_number, su.site_ref_code,
           'TGT_GL_REC_CONCAT', su.tgt_gl_rec_concat, 'ERROR', 'VAL-301',
           'BILL_TO Site Use requires a valid Receivable GL Account (TGT_GL_REC_CONCAT).',
           'Populate TGT_GL_REC_CONCAT with a valid 9-segment account for Target Ledger ' || nvl(l_proj.tgt_ledger_name, '(TBD)') || '.'
      from xxcr_stg_site_uses su
     where su.project_id = p_project_id
       and su.include_yn = 'Y'
       and su.tgt_site_use_code = 'BILL_TO'
       and trim(su.tgt_gl_rec_concat) is null;

    -- 3.2 Target Legal Entity Balancing Segment Value (BSV) Mismatch on GL Accounts
    if l_proj.tgt_bsv is not null then
      insert into xxcr_val_errors (
        project_id, val_stage, entity_level, stg_row_id, account_number, site_ref_code,
        column_name, invalid_value, severity, error_code, error_message, suggested_fix
      )
      select p_project_id, '3_EBS_TARGET_RULES', 'SITE_USE', su.stg_site_use_id, su.tgt_account_number, su.site_ref_code,
             'TGT_GL_REC_CONCAT', su.tgt_gl_rec_concat, 'ERROR', 'VAL-302',
             'Receivable GL Account Balancing Segment ''' || substr(su.tgt_gl_rec_concat, 1, instr(su.tgt_gl_rec_concat, '.') - 1) ||
             ''' does not match Target Legal Entity BSV ''' || l_proj.tgt_bsv || '''.',
             'Run "Apply Target BSV Remapping" or update Segment 1 to ' || l_proj.tgt_bsv || '.'
        from xxcr_stg_site_uses su
       where su.project_id = p_project_id
         and su.include_yn = 'Y'
         and su.tgt_gl_rec_concat is not null
         and instr(su.tgt_gl_rec_concat, '.') > 1
         and substr(su.tgt_gl_rec_concat, 1, instr(su.tgt_gl_rec_concat, '.') - 1) <> l_proj.tgt_bsv;
    end if;

    -- 3.3BILL_TO Missing Payment Terms
    insert into xxcr_val_errors (
      project_id, val_stage, entity_level, stg_row_id, account_number, site_ref_code,
      column_name, invalid_value, severity, error_code, error_message, suggested_fix
    )
    select p_project_id, '3_EBS_TARGET_RULES', 'SITE_USE', su.stg_site_use_id, su.tgt_account_number, su.site_ref_code,
           'TGT_PAYMENT_TERM_NAME', su.tgt_payment_term_name, 'WARNING', 'VAL-303',
           'BILL_TO Site Use has no Payment Term specified (will inherit from Customer Profile).',
           'Specify a Target OU Payment Term on BILL_TO or verify Account Profile Payment Term.'
      from xxcr_stg_site_uses su
     where su.project_id = p_project_id
       and su.include_yn = 'Y'
       and su.tgt_site_use_code = 'BILL_TO'
       and trim(su.tgt_payment_term_name) is null;

    -- =========================================================================
    -- STAGE 4: TCA Shared-Object Protection & Duplicate Guards
    -- =========================================================================
    -- 4.1 Modified Shared Address Notification (Creates new HZ_PARTY_SITE instead of corrupting source OU)
    insert into xxcr_val_errors (
      project_id, val_stage, entity_level, stg_row_id, account_number, site_ref_code,
      column_name, invalid_value, severity, error_code, error_message, suggested_fix
    )
    select p_project_id, '4_SHARED_OBJECT_GUARD', 'SITE', s.stg_site_id, s.tgt_account_number, s.site_ref_code,
           'ADDRESS_MODE', s.tgt_address1 || ', ' || s.tgt_city, 'WARNING', 'VAL-401',
           'Physical address was modified from Source Party Site #' || s.src_party_site_number ||
           '. Mode switched to NEW_ADDRESS so Source OU address is not overwritten.',
           'Review and acknowledge if a new Party Site / Location is intended for the Target OU.'
      from xxcr_stg_sites s
     where s.project_id = p_project_id
       and s.include_yn = 'Y'
       and s.addr_changed_yn = 'Y'
       and s.src_party_site_id is not null;

    -- 4.2 Unresolved Duplicate Candidates Warning
    insert into xxcr_val_errors (
      project_id, val_stage, entity_level, stg_row_id, account_number, site_ref_code,
      column_name, invalid_value, severity, error_code, error_message, suggested_fix
    )
    select p_project_id, '4_SHARED_OBJECT_GUARD',
           decode(d.entity_level, 'ADDRESS_SITE', 'SITE', d.entity_level),
           d.stg_row_id, d.account_number, d.site_ref_code,
           'DUPLICATE_CHECK', d.match_rule || ' (' || d.similarity_score || '%)', 'WARNING', 'VAL-402',
           'Unresolved duplicate candidate (' || d.match_rule || ', Score ' || d.similarity_score || '%): ' || d.matched_display,
           'Open "Find Duplicates" tab and choose Exclude Duplicate, Reuse Existing, or Keep Both.'
      from xxcr_duplicates d
     where d.project_id = p_project_id
       and d.resolution_action = 'OPEN';

    -- 4.3 Restricted Party Screening / Denied Party Hold Compliance Warning (Tier 1 DFF TREX_RP_SCREENING = 'Y')
    insert into xxcr_val_errors (
      project_id, val_stage, entity_level, stg_row_id, account_number, site_ref_code,
      column_name, invalid_value, severity, error_code, error_message, suggested_fix
    )
    select p_project_id, '4_SHARED_OBJECT_GUARD', 'SITE', s.stg_site_id, s.tgt_account_number, s.site_ref_code,
           'TGT_RPS_HOLD_FLAG', s.tgt_rps_hold_flag, 'WARNING', 'VAL-403',
           'Site carries Denied Party Hold (TREX_RP_SCREENING = Y) in Source OU.',
           'Review with Trade Compliance whether this site should be excluded (INCLUDE_YN = N) or carried over on RPS Hold.'
      from xxcr_stg_sites s
     where s.project_id = p_project_id
       and s.include_yn = 'Y'
       and upper(trim(s.tgt_rps_hold_flag)) = 'Y';

    -- 4.4 Multi-Currency Credit Limit Guard (Order Limit > Overall Limit on XXCR_STG_PROFILE_AMTS)
    insert into xxcr_val_errors (
      project_id, val_stage, entity_level, stg_row_id, account_number, site_ref_code,
      column_name, invalid_value, severity, error_code, error_message, suggested_fix
    )
    select p_project_id, '3_EBS_TARGET_RULES', 'SITE_USE', pa.stg_site_use_id, pa.tgt_account_number, pa.site_ref_code,
           'MULTI_CURR_CREDIT_LIMIT', pa.tgt_currency_code || ': ' || pa.tgt_trx_credit_limit || ' > ' || pa.tgt_overall_credit_limit,
           'ERROR', 'VAL-305',
           'Multi-Currency Credit Limit (' || pa.tgt_currency_code || ') Order Limit (' || pa.tgt_trx_credit_limit ||
           ') exceeds Overall Credit Limit (' || pa.tgt_overall_credit_limit || ').',
           'Correct the currency row on Tab 5 (Multi-Currency Credit) so Order Limit <= Overall Limit.'
      from xxcr_stg_profile_amts pa
     where pa.project_id = p_project_id
       and pa.include_yn = 'Y'
       and pa.stg_site_use_id is not null
       and pa.tgt_overall_credit_limit > 0
       and pa.tgt_trx_credit_limit > pa.tgt_overall_credit_limit;

    -- =========================================================================
    -- Roll up Validation Status onto Staging Rows
    -- =========================================================================
    update xxcr_stg_contacts ct
       set val_error_count = (
             select count(*) from xxcr_val_errors e
              where e.project_id = p_project_id and e.entity_level = 'CONTACT' and e.stg_row_id = ct.stg_contact_id
           ),
           val_status = coalesce((
             select case
                      when sum(case when e.severity = 'ERROR' then 1 else 0 end) > 0 then 'ERROR'
                      when sum(case when e.severity = 'WARNING' and e.ack_yn = 'N' then 1 else 0 end) > 0 then 'WARNING'
                      else 'VALID'
                    end
               from xxcr_val_errors e
              where e.project_id = p_project_id and e.entity_level = 'CONTACT' and e.stg_row_id = ct.stg_contact_id
           ), 'VALID')
     where ct.project_id = p_project_id;

    update xxcr_stg_site_uses su
       set val_error_count = (
             select count(*) from xxcr_val_errors e
              where e.project_id = p_project_id and e.entity_level = 'SITE_USE' and e.stg_row_id = su.stg_site_use_id
           ),
           val_status = coalesce((
             select case
                      when sum(case when e.severity = 'ERROR' then 1 else 0 end) > 0 then 'ERROR'
                      when sum(case when e.severity = 'WARNING' and e.ack_yn = 'N' then 1 else 0 end) > 0 then 'WARNING'
                      else 'VALID'
                    end
               from xxcr_val_errors e
              where e.project_id = p_project_id and e.entity_level = 'SITE_USE' and e.stg_row_id = su.stg_site_use_id
           ), 'VALID')
     where su.project_id = p_project_id;

    update xxcr_stg_sites s
       set val_error_count = (
             select count(*) from xxcr_val_errors e
              where e.project_id = p_project_id and e.entity_level = 'SITE' and e.stg_row_id = s.stg_site_id
           ) + (
             select nvl(sum(su.val_error_count), 0) from xxcr_stg_site_uses su
              where su.stg_site_id = s.stg_site_id and su.include_yn = 'Y'
           ),
           val_status = case
             when exists (
               select 1 from xxcr_val_errors e
                where e.project_id = p_project_id and e.entity_level = 'SITE' and e.stg_row_id = s.stg_site_id and e.severity = 'ERROR'
             ) or exists (
               select 1 from xxcr_stg_site_uses su
                where su.stg_site_id = s.stg_site_id and su.include_yn = 'Y' and su.val_status = 'ERROR'
             ) then 'ERROR'
             when exists (
               select 1 from xxcr_val_errors e
                where e.project_id = p_project_id and e.entity_level = 'SITE' and e.stg_row_id = s.stg_site_id and e.severity = 'WARNING' and e.ack_yn = 'N'
             ) or exists (
               select 1 from xxcr_stg_site_uses su
                where su.stg_site_id = s.stg_site_id and su.include_yn = 'Y' and su.val_status = 'WARNING'
             ) then 'WARNING'
             else 'VALID'
           end
     where s.project_id = p_project_id;

    -- All-or-Nothing Hierarchy Rollup to Customer Level
    update xxcr_stg_customers c
       set val_error_count = (
             select count(*) from xxcr_val_errors e
              where e.project_id = p_project_id and e.entity_level = 'CUSTOMER' and e.stg_row_id = c.stg_cust_id
           ) + (
             select nvl(sum(s.val_error_count), 0) from xxcr_stg_sites s
              where s.stg_cust_id = c.stg_cust_id and s.include_yn = 'Y'
           ),
           val_status = case
             when exists (
               select 1 from xxcr_val_errors e
                where e.project_id = p_project_id and e.entity_level = 'CUSTOMER' and e.stg_row_id = c.stg_cust_id and e.severity = 'ERROR'
             ) or exists (
               select 1 from xxcr_stg_sites s
                where s.stg_cust_id = c.stg_cust_id and s.include_yn = 'Y' and s.val_status = 'ERROR'
             ) then 'ERROR'
             when exists (
               select 1 from xxcr_val_errors e
                where e.project_id = p_project_id and e.entity_level = 'CUSTOMER' and e.stg_row_id = c.stg_cust_id and e.severity = 'WARNING' and e.ack_yn = 'N'
             ) or exists (
               select 1 from xxcr_stg_sites s
                where s.stg_cust_id = c.stg_cust_id and s.include_yn = 'Y' and s.val_status = 'WARNING'
             ) then 'WARNING'
             else 'VALID'
           end
     where c.project_id = p_project_id;

    update xxcr_projects
       set last_validate_at = systimestamp,
           status = case when status = 'DRAFT' then 'VALIDATED' else status end,
           updated_at = systimestamp
     where project_id = p_project_id;
  end validate_project;

  ------------------------------------------------------------------------------
  -- 7. Connected Multi-Tab .xlsx Workbook Generator (OpenXML + Live Formulas)
  ------------------------------------------------------------------------------
  function xml_esc_text(p_val in varchar2) return varchar2 deterministic is
    l_s varchar2(32767);
  begin
    if p_val is null then
      return null;
    end if;
    l_s := regexp_replace(p_val, '[' || chr(1) || '-' || chr(8) || chr(11) || chr(12) || chr(14) || '-' || chr(31) || ']', '');
    l_s := replace(l_s, '&', '&amp;');
    l_s := replace(l_s, '<', '&lt;');
    l_s := replace(l_s, '>', '&gt;');
    l_s := replace(l_s, '"', '&quot;');
    l_s := replace(l_s, '''', '&apos;');
    return l_s;
  end xml_esc_text;

  function xml_esc_formula(p_val in varchar2) return varchar2 deterministic is
    l_s varchar2(32767);
  begin
    if p_val is null then
      return null;
    end if;
    l_s := replace(p_val, '&', '&amp;');
    l_s := replace(l_s, '<', '&lt;');
    l_s := replace(l_s, '>', '&gt;');
    return l_s;
  end xml_esc_formula;

  function clob_to_utf8_blob(p_clob in clob) return blob is
    l_blob         blob;
    l_dest_offset  integer := 1;
    l_src_offset   integer := 1;
    l_lang_context integer := dbms_lob.default_lang_ctx;
    l_warning      integer;
  begin
    dbms_lob.createtemporary(l_blob, true);
    dbms_lob.converttoblob(
      dest_lob     => l_blob,
      src_clob     => p_clob,
      amount       => dbms_lob.lobmaxsize,
      dest_offset  => l_dest_offset,
      src_offset   => l_src_offset,
      blob_csid    => nls_charset_id('AL32UTF8'),
      lang_context => l_lang_context,
      warning      => l_warning
    );
    return l_blob;
  end clob_to_utf8_blob;

  function generate_connected_xlsx(p_project_id in number) return blob is
    l_zip         blob;
    l_clob        clob;
    l_buf         varchar2(32767);
    l_proj        xxcr_projects%rowtype;
    l_cust_cnt    pls_integer := 0;
    l_site_cnt    pls_integer := 0;
    l_su_cnt      pls_integer := 0;
    l_ct_cnt      pls_integer := 0;
    l_cust_rng    pls_integer;
    l_site_rng    pls_integer;
    l_su_rng      pls_integer;
    l_ct_rng      pls_integer;
    l_row_num     pls_integer;
    l_rn          varchar2(15);

    procedure buf_init is
    begin
      dbms_lob.createtemporary(l_clob, true);
      l_buf := '';
    end buf_init;

    procedure buf_add(p_str in varchar2) is
    begin
      if p_str is null then
        return;
      end if;
      if lengthb(l_buf) + lengthb(p_str) > 31500 then
        dbms_lob.writeappend(l_clob, length(l_buf), l_buf);
        l_buf := p_str;
      else
        l_buf := l_buf || p_str;
      end if;
    end buf_add;

    procedure buf_push_zip(p_path in varchar2) is
      l_part_blob blob;
    begin
      if length(l_buf) > 0 then
        dbms_lob.writeappend(l_clob, length(l_buf), l_buf);
        l_buf := '';
      end if;
      l_part_blob := clob_to_utf8_blob(l_clob);
      apex_zip.add_file(
        p_zipped_blob => l_zip,
        p_file_name   => p_path,
        p_content     => l_part_blob
      );
      dbms_lob.freetemporary(l_part_blob);
      dbms_lob.freetemporary(l_clob);
    end buf_push_zip;

    procedure add_str(p_ref in varchar2, p_val in varchar2, p_style in pls_integer default 0) is
    begin
      if p_val is null then
        if p_style > 0 then
          buf_add('<c r="' || p_ref || '" s="' || p_style || '"/>');
        end if;
      else
        buf_add(
          '<c r="' || p_ref || '"' ||
          case when p_style > 0 then ' s="' || p_style || '"' end ||
          ' t="inlineStr"><is><t xml:space="preserve">' || xml_esc_text(p_val) || '</t></is></c>'
        );
      end if;
    end add_str;

    function fmt_num(p_val in number) return varchar2 is
      l_s varchar2(100);
    begin
      if p_val is null then
        return null;
      end if;
      l_s := rtrim(to_char(p_val, 'FM9999999999999999999990.9999999999', 'NLS_NUMERIC_CHARACTERS=''.,'''), '.');
      if l_s = '-0' then
        return '0';
      end if;
      return l_s;
    end fmt_num;

    procedure add_num(p_ref in varchar2, p_val in number, p_style in pls_integer default 0) is
    begin
      if p_val is null then
        if p_style > 0 then
          buf_add('<c r="' || p_ref || '" s="' || p_style || '"/>');
        end if;
      else
        buf_add(
          '<c r="' || p_ref || '"' ||
          case when p_style > 0 then ' s="' || p_style || '"' end ||
          ' t="n"><v>' || fmt_num(p_val) || '</v></c>'
        );
      end if;
    end add_num;

    procedure add_f_str(p_ref in varchar2, p_formula in varchar2, p_cached in varchar2, p_style in pls_integer default 3) is
    begin
      buf_add(
        '<c r="' || p_ref || '"' ||
        case when p_style > 0 then ' s="' || p_style || '"' end ||
        ' t="str"><f>' || xml_esc_formula(p_formula) || '</f><v>' || xml_esc_text(p_cached) || '</v></c>'
      );
    end add_f_str;

    procedure add_f_num(p_ref in varchar2, p_formula in varchar2, p_cached in number, p_style in pls_integer default 5) is
    begin
      buf_add(
        '<c r="' || p_ref || '"' ||
        case when p_style > 0 then ' s="' || p_style || '"' end ||
        ' t="n"><f>' || xml_esc_formula(p_formula) || '</f><v>' || fmt_num(nvl(p_cached, 0)) || '</v></c>'
      );
    end add_f_num;

  begin
    select * into l_proj from xxcr_projects where project_id = p_project_id;

    select count(*) into l_cust_cnt from xxcr_stg_customers    where project_id = p_project_id;
    select count(*) into l_site_cnt from xxcr_stg_sites        where project_id = p_project_id;
    select count(*) into l_su_cnt   from xxcr_stg_site_uses    where project_id = p_project_id;
    select count(*) into l_ct_cnt   from xxcr_stg_contacts     where project_id = p_project_id;

    l_cust_rng := greatest(l_cust_cnt + 200, 10);
    l_site_rng := greatest(l_site_cnt + 500, 10);
    l_su_rng   := greatest(l_su_cnt   + 500, 10);
    l_ct_rng   := greatest(l_ct_cnt   + 500, 10);

    -- 1. [Content_Types].xml
    buf_init;
    buf_add('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>');
    buf_add('<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">');
    buf_add('<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>');
    buf_add('<Default Extension="xml" ContentType="application/xml"/>');
    buf_add('<Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>');
    buf_add('<Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>');
    buf_add('<Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>');
    buf_add('<Override PartName="/xl/worksheets/sheet2.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>');
    buf_add('<Override PartName="/xl/worksheets/sheet3.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>');
    buf_add('<Override PartName="/xl/worksheets/sheet4.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>');
    buf_add('<Override PartName="/xl/worksheets/sheet5.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>');
    buf_add('<Override PartName="/xl/worksheets/sheet6.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>');
    buf_add('<Override PartName="/xl/worksheets/sheet7.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>');
    buf_add('<Override PartName="/xl/worksheets/sheet8.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>');
    buf_add('<Override PartName="/xl/worksheets/sheet9.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>');
    buf_add('</Types>');
    buf_push_zip('[Content_Types].xml');

    -- 2. _rels/.rels
    buf_init;
    buf_add('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>');
    buf_add('<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">');
    buf_add('<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>');
    buf_add('</Relationships>');
    buf_push_zip('_rels/.rels');

    -- 3. xl/_rels/workbook.xml.rels
    buf_init;
    buf_add('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>');
    buf_add('<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">');
    buf_add('<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/>');
    buf_add('<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet2.xml"/>');
    buf_add('<Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet3.xml"/>');
    buf_add('<Relationship Id="rId4" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet4.xml"/>');
    buf_add('<Relationship Id="rId5" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet5.xml"/>');
    buf_add('<Relationship Id="rId6" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet6.xml"/>');
    buf_add('<Relationship Id="rId7" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet7.xml"/>');
    buf_add('<Relationship Id="rId8" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet8.xml"/>');
    buf_add('<Relationship Id="rId9" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet9.xml"/>');
    buf_add('<Relationship Id="rId10" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>');
    buf_add('</Relationships>');
    buf_push_zip('xl/_rels/workbook.xml.rels');

    -- 4. xl/workbook.xml (fullCalcOnLoad="1" + _xlnm._FilterDatabase definedNames + hidden 9_EBS_LOVs sheet)
    buf_init;
    buf_add('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>');
    buf_add('<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">');
    buf_add('<workbookPr date1904="false"/>');
    buf_add('<bookViews><workbookView xWindow="0" yWindow="0" windowWidth="24000" windowHeight="15000"/></bookViews>');
    buf_add('<sheets>');
    buf_add('<sheet name="0_Rollout_Summary" sheetId="1" r:id="rId1"/>');
    buf_add('<sheet name="1_Customers" sheetId="2" r:id="rId2"/>');
    buf_add('<sheet name="2_Addresses_Sites" sheetId="3" r:id="rId3"/>');
    buf_add('<sheet name="3_Site_Uses_GL" sheetId="4" r:id="rId4"/>');
    buf_add('<sheet name="4_Contacts" sheetId="5" r:id="rId5"/>');
    buf_add('<sheet name="5_Multi_Curr_Credit" sheetId="6" r:id="rId6"/>');
    buf_add('<sheet name="6_Acct_Relationships" sheetId="7" r:id="rId7"/>');
    buf_add('<sheet name="7_Payment_Instr" sheetId="8" r:id="rId8"/>');
    buf_add('<sheet name="9_EBS_LOVs" sheetId="9" state="hidden" r:id="rId9"/>');
    buf_add('</sheets>');
    buf_add('<definedNames>');
    buf_add('<definedName name="_xlnm._FilterDatabase" localSheetId="1" hidden="1">''1_Customers''!$A$1:$W$' || greatest(l_cust_cnt + 1, 2) || '</definedName>');
    buf_add('<definedName name="_xlnm._FilterDatabase" localSheetId="2" hidden="1">''2_Addresses_Sites''!$A$1:$AB$' || greatest(l_site_cnt + 1, 2) || '</definedName>');
    buf_add('<definedName name="_xlnm._FilterDatabase" localSheetId="3" hidden="1">''3_Site_Uses_GL''!$A$1:$AT$' || greatest(l_su_cnt + 1, 2) || '</definedName>');
    buf_add('<definedName name="_xlnm._FilterDatabase" localSheetId="4" hidden="1">''4_Contacts''!$A$1:$X$' || greatest(l_ct_cnt + 1, 2) || '</definedName>');
    buf_add('</definedNames>');
    buf_add('<calcPr calcId="191029" fullCalcOnLoad="1"/>');
    buf_add('</workbook>');
    buf_push_zip('xl/workbook.xml');

    -- 5. xl/styles.xml
    --    s="0": Default
    --    s="1": Dark Navy Header (White Bold)
    --    s="2": Editable Include Y/N Input Cell (Soft Gold #FFF8E1, Bold Center, Thin Border)
    --    s="3": Connected Formula Cell (Soft Ice Blue #E8F0FE, Navy Text)
    --    s="4": Currency/Decimal (#,##0.00)
    --    s="5": Integer (#,##0)
    --    s="6": Key ID Column (Light Gray #F1F3F4)
    --    dxfId="0": Conditional Formatting for Excluded Rows (Soft Rose #FCE8E6 + Crimson Strikethrough)
    buf_init;
    buf_add('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>');
    buf_add('<styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">');
    buf_add('<numFmts count="2">');
    buf_add('<numFmt numFmtId="164" formatCode="#,##0.00"/>');
    buf_add('<numFmt numFmtId="165" formatCode="#,##0"/>');
    buf_add('</numFmts>');
    buf_add('<fonts count="5">');
    buf_add('<font><sz val="10"/><color rgb="FF202124"/><name val="Calibri"/></font>');
    buf_add('<font><b/><sz val="10"/><color rgb="FFFFFFFF"/><name val="Calibri"/></font>');
    buf_add('<font><b/><sz val="10"/><color rgb="FF1F1F1F"/><name val="Calibri"/></font>');
    buf_add('<font><b/><sz val="10"/><color rgb="FF174EA6"/><name val="Calibri"/></font>');
    buf_add('<font><sz val="10"/><color rgb="FF5F6368"/><name val="Calibri"/></font>');
    buf_add('</fonts>');
    buf_add('<fills count="6">');
    buf_add('<fill><patternFill patternType="none"/></fill>');
    buf_add('<fill><patternFill patternType="gray125"/></fill>');
    buf_add('<fill><patternFill patternType="solid"><fgColor rgb="FF1B365D"/></patternFill></fill>');
    buf_add('<fill><patternFill patternType="solid"><fgColor rgb="FFFFF8E1"/></patternFill></fill>');
    buf_add('<fill><patternFill patternType="solid"><fgColor rgb="FFE8F0FE"/></patternFill></fill>');
    buf_add('<fill><patternFill patternType="solid"><fgColor rgb="FFF1F3F4"/></patternFill></fill>');
    buf_add('</fills>');
    buf_add('<borders count="2">');
    buf_add('<border><left/><right/><top/><bottom/><diagonal/></border>');
    buf_add('<border><left style="thin"><color rgb="FFDADCE0"/></left><right style="thin"><color rgb="FFDADCE0"/></right><top style="thin"><color rgb="FFDADCE0"/></top><bottom style="thin"><color rgb="FFDADCE0"/></bottom><diagonal/></border>');
    buf_add('</borders>');
    buf_add('<cellStyleXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs>');
    buf_add('<cellXfs count="7">');
    buf_add('<xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0"/>');
    buf_add('<xf numFmtId="0" fontId="1" fillId="2" borderId="1" xfId="0" applyFont="1" applyFill="1" applyBorder="1"/>');
    buf_add('<xf numFmtId="0" fontId="2" fillId="3" borderId="1" xfId="0" applyFont="1" applyFill="1" applyBorder="1" applyAlignment="1"><alignment horizontal="center"/></xf>');
    buf_add('<xf numFmtId="0" fontId="3" fillId="4" borderId="1" xfId="0" applyFont="1" applyFill="1" applyBorder="1"/>');
    buf_add('<xf numFmtId="164" fontId="0" fillId="0" borderId="0" xfId="0" applyNumberFormat="1"/>');
    buf_add('<xf numFmtId="165" fontId="0" fillId="0" borderId="0" xfId="0" applyNumberFormat="1"/>');
    buf_add('<xf numFmtId="165" fontId="4" fillId="5" borderId="1" xfId="0" applyNumberFormat="1" applyFont="1" applyFill="1" applyBorder="1"/>');
    buf_add('</cellXfs>');
    buf_add('<cellStyles count="1"><cellStyle name="Normal" xfId="0" builtinId="0"/></cellStyles>');
    buf_add('<dxfs count="1">');
    buf_add('<dxf><font><strike/><color rgb="FFA50E0E"/></font><fill><patternFill><bgColor rgb="FFFCE8E6"/></patternFill></fill></dxf>');
    buf_add('</dxfs>');
    buf_add('</styleSheet>');
    buf_push_zip('xl/styles.xml');

    -- =========================================================================
    -- Sheet 1: 0_Rollout_Summary (Live Connected KPI Dashboard & Instructions)
    -- =========================================================================
    declare
      l_c_inc pls_integer;
      l_s_inc pls_integer;
      l_u_inc pls_integer;
      l_t_inc pls_integer;
    begin
      select count(*) into l_c_inc from xxcr_stg_customers where project_id = p_project_id and include_yn = 'Y';
      select count(*) into l_s_inc from xxcr_stg_sites s join xxcr_stg_customers c on c.stg_cust_id = s.stg_cust_id
       where s.project_id = p_project_id and s.include_yn = 'Y' and c.include_yn = 'Y';
      select count(*) into l_u_inc from xxcr_stg_site_uses u join xxcr_stg_sites s on s.stg_site_id = u.stg_site_id join xxcr_stg_customers c on c.stg_cust_id = u.stg_cust_id
       where u.project_id = p_project_id and u.include_yn = 'Y' and s.include_yn = 'Y' and c.include_yn = 'Y';
      select count(*) into l_t_inc from xxcr_stg_contacts t join xxcr_stg_customers c on c.stg_cust_id = t.stg_cust_id left join xxcr_stg_sites s on s.stg_site_id = t.stg_site_id
       where t.project_id = p_project_id and t.include_yn = 'Y' and c.include_yn = 'Y' and (t.stg_site_id is null or s.include_yn = 'Y');

      buf_init;
      buf_add('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>');
      buf_add('<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">');
      buf_add('<cols>');
      buf_add('<col min="1" max="1" width="32" customWidth="1"/>');
      buf_add('<col min="2" max="5" width="22" customWidth="1"/>');
      buf_add('</cols>');
      buf_add('<sheetData>');
      buf_add('<row r="1">');
      add_str('A1', 'EBS Customer OU Rollout — Connected Multi-Worksheet Workbook', 1);
      add_str('B1', l_proj.project_code, 1);
      add_str('C1', 'Source OU: ' || l_proj.src_ou_name, 1);
      add_str('D1', 'Target OU: ' || nvl(l_proj.tgt_ou_name, 'TBD') || ' | Target BSV: ' || nvl(l_proj.tgt_bsv, 'TBD'), 1);
      add_str('E1', to_char(systimestamp, 'YYYY-MM-DD HH24:MI'), 1);
      buf_add('</row>');

      buf_add('<row r="3">');
      add_str('A3', 'HOW CONNECTED CASCADING WORKS:', 2);
      add_str('B3', '1) Set Include (Y/N) = N on 1_Customers -> automatically flips Effective Include = N (and strikes out rows) across 2_Addresses_Sites, 3_Site_Uses_GL, and 4_Contacts.');
      buf_add('</row>');
      buf_add('<row r="4">');
      add_str('A4', 'SITE-LEVEL OVERRIDE:', 2);
      add_str('B4', '2) Set Site Include (Y/N) = N on 2_Addresses_Sites -> excludes ONLY that address/site and automatically cascades N to its child rows on 3_Site_Uses_GL and 4_Contacts.');
      buf_add('</row>');
      buf_add('<row r="5">');
      add_str('A5', 'ROUND-TRIP UPLOAD:', 2);
      add_str('B5', '3) Save this single .xlsx file and drop it onto Customer Master Workbench -> Tab 5 (Connected Excel Upload & Audit) in APEX -> all edits & cascaded exclusions apply automatically.');
      buf_add('</row>');

      buf_add('<row r="7">');
      add_str('A7', 'Connected Worksheet', 1);
      add_str('B7', 'Total Extracted Rows', 1);
      add_str('C7', 'Effective Included (Y)', 1);
      add_str('D7', 'Effective Excluded (N)', 1);
      add_str('E7', '% Included', 1);
      buf_add('</row>');

      buf_add('<row r="8">');
      add_str('A8', '1_Customers (Accounts & Profiles)', 3);
      add_f_num('B8', 'COUNTA(''1_Customers''!A2:A' || l_cust_rng || ')', l_cust_cnt, 5);
      add_f_num('C8', 'COUNTIF(''1_Customers''!B2:B' || l_cust_rng || ',"Y")', l_c_inc, 5);
      add_f_num('D8', 'COUNTIF(''1_Customers''!B2:B' || l_cust_rng || ',"N")', l_cust_cnt - l_c_inc, 5);
      add_f_num('E8', 'IF(B8=0,0,ROUND(C8*100/B8,2))', case when l_cust_cnt > 0 then round(l_c_inc * 100 / l_cust_cnt, 2) else 0 end, 4);
      buf_add('</row>');

      buf_add('<row r="9">');
      add_str('A9', '2_Addresses_Sites (Party & Acct Sites)', 3);
      add_f_num('B9', 'COUNTA(''2_Addresses_Sites''!A2:A' || l_site_rng || ')', l_site_cnt, 5);
      add_f_num('C9', 'COUNTIF(''2_Addresses_Sites''!C2:C' || l_site_rng || ',"Y")', l_s_inc, 5);
      add_f_num('D9', 'COUNTIF(''2_Addresses_Sites''!C2:C' || l_site_rng || ',"N")', l_site_cnt - l_s_inc, 5);
      add_f_num('E9', 'IF(B9=0,0,ROUND(C9*100/B9,2))', case when l_site_cnt > 0 then round(l_s_inc * 100 / l_site_cnt, 2) else 0 end, 4);
      buf_add('</row>');

      buf_add('<row r="10">');
      add_str('A10', '3_Site_Uses_GL (BILL_TO / SHIP_TO & GL)', 3);
      add_f_num('B10', 'COUNTA(''3_Site_Uses_GL''!A2:A' || l_su_rng || ')', l_su_cnt, 5);
      add_f_num('C10', 'COUNTIF(''3_Site_Uses_GL''!C2:C' || l_su_rng || ',"Y")', l_u_inc, 5);
      add_f_num('D10', 'COUNTIF(''3_Site_Uses_GL''!C2:C' || l_su_rng || ',"N")', l_su_cnt - l_u_inc, 5);
      add_f_num('E10', 'IF(B10=0,0,ROUND(C10*100/B10,2))', case when l_su_cnt > 0 then round(l_u_inc * 100 / l_su_cnt, 2) else 0 end, 4);
      buf_add('</row>');

      buf_add('<row r="11">');
      add_str('A11', '4_Contacts (Roles, Emails & Phones)', 3);
      add_f_num('B11', 'COUNTA(''4_Contacts''!A2:A' || l_ct_rng || ')', l_ct_cnt, 5);
      add_f_num('C11', 'COUNTIF(''4_Contacts''!C2:C' || l_ct_rng || ',"Y")', l_t_inc, 5);
      add_f_num('D11', 'COUNTIF(''4_Contacts''!C2:C' || l_ct_rng || ',"N")', l_ct_cnt - l_t_inc, 5);
      add_f_num('E11', 'IF(B11=0,0,ROUND(C11*100/B11,2))', case when l_ct_cnt > 0 then round(l_t_inc * 100 / l_ct_cnt, 2) else 0 end, 4);
      buf_add('</row>');

      buf_add('</sheetData>');
      buf_add('</worksheet>');
      buf_push_zip('xl/worksheets/sheet1.xml');
    end;

    -- =========================================================================
    -- Sheet 2: 1_Customers (Parent Account & Profile Master)
    -- =========================================================================
    buf_init;
    buf_add('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>');
    buf_add('<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">');
    buf_add('<sheetViews><sheetView rightToLeft="0" workbookViewId="0"><pane ySplit="1" topLeftCell="A2" activePane="bottomLeft" state="frozen"/><selection pane="bottomLeft" activeCell="A2" sqref="A2"/></sheetView></sheetViews>');
    buf_add('<cols>');
    buf_add('<col min="1" max="1" width="13" customWidth="1"/>');
    buf_add('<col min="2" max="2" width="15" customWidth="1"/>');
    buf_add('<col min="3" max="3" width="22" customWidth="1"/>');
    buf_add('<col min="4" max="6" width="18" customWidth="1"/>');
    buf_add('<col min="7" max="7" width="38" customWidth="1"/>');
    buf_add('<col min="8" max="16" width="19" customWidth="1"/>');
    buf_add('<col min="17" max="22" width="18" customWidth="1"/>');
    buf_add('<col min="23" max="23" width="32" customWidth="1"/>');
    buf_add('</cols>');
    buf_add('<sheetData>');
    buf_add('<row r="1">');
    add_str('A1', 'Stg Cust ID', 1);
    add_str('B1', 'Include (Y/N)', 1);
    add_str('C1', 'Rollout Status', 1);
    add_str('D1', 'Action', 1);
    add_str('E1', 'AWP Scope', 1);
    add_str('F1', 'Target Acct #', 1);
    add_str('G1', 'Target Party Name', 1);
    add_str('H1', 'Target Account Name', 1);
    add_str('I1', 'Tax Reference', 1);
    add_str('J1', 'Customer Class', 1);
    add_str('K1', 'Profile Class', 1);
    add_str('L1', 'Collector', 1);
    add_str('M1', 'Payment Term', 1);
    add_str('N1', 'Credit Currency', 1);
    add_str('O1', 'Overall Credit Limit', 1);
    add_str('P1', 'Order Credit Limit', 1);
    add_str('Q1', 'Open AR (AUD)', 1);
    add_str('R1', '24m Trx Cnt', 1);
    add_str('S1', 'Dup Role', 1);
    add_str('T1', 'Duplicates', 1);
    add_str('U1', 'Val Status', 1);
    add_str('V1', 'Modified', 1);
    add_str('W1', 'User Notes', 1);
    buf_add('</row>');

    l_row_num := 1;
    for r in (
      select *
        from xxcr_stg_customers
       where project_id = p_project_id
       order by stg_cust_id
    ) loop
      l_row_num := l_row_num + 1;
      l_rn := to_char(l_row_num);
      buf_add('<row r="' || l_rn || '">');
      add_num('A' || l_rn, r.stg_cust_id, 6);
      add_str('B' || l_rn, nvl(r.include_yn, 'Y'), 2);
      add_f_str(
        'C' || l_rn,
        'IF(UPPER(B' || l_rn || ')="N","EXCLUDED (Account)",IF(LEFT(S' || l_rn || ',9)="DUPLICATE","REVIEW DUPLICATE","INCLUDED"))',
        case when r.include_yn = 'N' then 'EXCLUDED (Account)' when r.dup_role like 'DUPLICATE%' then 'REVIEW DUPLICATE' else 'INCLUDED' end,
        3
      );
      add_str('D' || l_rn, r.action_code);
      add_str('E' || l_rn, r.scope_class, 6);
      add_str('F' || l_rn, r.tgt_account_number, case when r.action_code = 'EXTEND_OU' then 6 else 0 end);
      add_str('G' || l_rn, r.tgt_party_name);
      add_str('H' || l_rn, r.tgt_account_name);
      add_str('I' || l_rn, r.tgt_tax_reference);
      add_str('J' || l_rn, r.tgt_customer_class_code);
      add_str('K' || l_rn, r.tgt_profile_class_name);
      add_str('L' || l_rn, r.tgt_collector_name);
      add_str('M' || l_rn, r.tgt_payment_term_name);
      add_str('N' || l_rn, r.tgt_credit_currency);
      add_num('O' || l_rn, r.tgt_overall_credit_limit, 4);
      add_num('P' || l_rn, r.tgt_trx_credit_limit, 4);
      add_num('Q' || l_rn, r.src_open_ar_amt, 4);
      add_num('R' || l_rn, r.src_trx_cnt_recent, 5);
      add_str('S' || l_rn, nvl(r.dup_role, 'UNIQUE'), 6);
      add_num('T' || l_rn, r.dup_count, 5);
      add_str('U' || l_rn, r.val_status, 6);
      add_str('V' || l_rn, r.modified_yn, 6);
      add_str('W' || l_rn, r.user_notes);
      buf_add('</row>');
    end loop;
    buf_add('</sheetData>');
    buf_add('<autoFilter ref="A1:W' || greatest(l_row_num, 2) || '"/>');
    if l_row_num >= 2 then
      buf_add('<conditionalFormatting sqref="A2:W' || l_row_num || '"><cfRule type="expression" dxfId="0" priority="1"><formula>UPPER($B2)="N"</formula></cfRule></conditionalFormatting>');
      buf_add('<dataValidations count="8">');
      buf_add('<dataValidation type="list" allowBlank="1" showInputMessage="1" showErrorMessage="1" sqref="B2:B' || l_cust_rng || '"><formula1>"Y,N"</formula1></dataValidation>');
      buf_add('<dataValidation type="list" allowBlank="1" showInputMessage="1" showErrorMessage="1" sqref="D2:D' || l_cust_rng || '"><formula1>''9_EBS_LOVs''!$A$2:$A$3</formula1></dataValidation>');
      buf_add('<dataValidation type="list" allowBlank="1" showInputMessage="1" showErrorMessage="0" sqref="J2:J' || l_cust_rng || '"><formula1>''9_EBS_LOVs''!$B$2:$B$100</formula1></dataValidation>');
      buf_add('<dataValidation type="list" allowBlank="1" showInputMessage="1" showErrorMessage="0" sqref="K2:K' || l_cust_rng || '"><formula1>''9_EBS_LOVs''!$C$2:$C$100</formula1></dataValidation>');
      buf_add('<dataValidation type="list" allowBlank="1" showInputMessage="1" showErrorMessage="0" sqref="L2:L' || l_cust_rng || '"><formula1>''9_EBS_LOVs''!$D$2:$D$300</formula1></dataValidation>');
      buf_add('<dataValidation type="list" allowBlank="1" showInputMessage="1" showErrorMessage="0" sqref="M2:M' || l_cust_rng || '"><formula1>''9_EBS_LOVs''!$E$2:$E$1000</formula1></dataValidation>');
      buf_add('<dataValidation type="list" allowBlank="1" showInputMessage="1" showErrorMessage="1" sqref="N2:N' || l_cust_rng || '"><formula1>''9_EBS_LOVs''!$F$2:$F$100</formula1></dataValidation>');
      buf_add('<dataValidation type="decimal" operator="greaterThanOrEqual" allowBlank="1" showInputMessage="1" showErrorMessage="1" sqref="O2:P' || l_cust_rng || '"><formula1>0</formula1></dataValidation>');
      buf_add('</dataValidations>');
    end if;
    buf_add('</worksheet>');
    buf_push_zip('xl/worksheets/sheet2.xml');

    -- =========================================================================
    -- Sheet 3: 2_Addresses_Sites (Connected to 1_Customers via Stg Cust ID)
    -- =========================================================================
    buf_init;
    buf_add('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>');
    buf_add('<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">');
    buf_add('<sheetViews><sheetView rightToLeft="0" workbookViewId="0"><pane ySplit="1" topLeftCell="A2" activePane="bottomLeft" state="frozen"/><selection pane="bottomLeft" activeCell="A2" sqref="A2"/></sheetView></sheetViews>');
    buf_add('<cols>');
    buf_add('<col min="1" max="1" width="13" customWidth="1"/>');
    buf_add('<col min="2" max="3" width="17" customWidth="1"/>');
    buf_add('<col min="4" max="4" width="13" customWidth="1"/>');
    buf_add('<col min="5" max="7" width="20" customWidth="1"/>');
    buf_add('<col min="8" max="8" width="34" customWidth="1"/>');
    buf_add('<col min="9" max="9" width="26" customWidth="1"/>');
    buf_add('<col min="10" max="16" width="16" customWidth="1"/>');
    buf_add('<col min="17" max="17" width="12" customWidth="1"/>');
    buf_add('<col min="18" max="19" width="30" customWidth="1"/>');
    buf_add('<col min="20" max="24" width="15" customWidth="1"/>');
    buf_add('<col min="25" max="25" width="32" customWidth="1"/>');
    buf_add('</cols>');
    buf_add('<sheetData>');
    buf_add('<row r="1">');
    add_str('A1', 'Stg Site ID', 1);
    add_str('B1', 'Site Include (Y/N)', 1);
    add_str('C1', 'Effective Include', 1);
    add_str('D1', 'Stg Cust ID', 1);
    add_str('E1', 'Rollout Status', 1);
    add_str('F1', 'Site Ref Code', 1);
    add_str('G1', 'Target Acct #', 1);
    add_str('H1', 'Customer Party Name (Linked)', 1);
    add_str('I1', 'Dup Role', 1);
    add_str('J1', 'Duplicates', 1);
    add_str('K1', 'Open AR (AUD)', 1);
    add_str('L1', '24m Trx Cnt', 1);
    add_str('M1', 'Open SO Cnt', 1);
    add_str('N1', 'Last Activity Date', 1);
    add_str('O1', 'Address Mode', 1);
    add_str('P1', 'Party Site #', 1);
    add_str('Q1', 'Country', 1);
    add_str('R1', 'Address 1', 1);
    add_str('S1', 'Address 2', 1);
    add_str('T1', 'City', 1);
    add_str('U1', 'State', 1);
    add_str('V1', 'Postal Code', 1);
    add_str('W1', 'Customer Category', 1);
    add_str('X1', 'Sales Currency (DFF)', 1);
    add_str('Y1', 'Denied Party Hold (DFF)', 1);
    add_str('Z1', '3rd Party Cust Name (DFF)', 1);
    add_str('AA1', 'Val Status', 1);
    add_str('AB1', 'User Notes', 1);
    buf_add('</row>');

    l_row_num := 1;
    for r in (
      select s.*,
             c.include_yn as cust_include_yn,
             c.tgt_party_name as cust_party_name
        from xxcr_stg_sites s
        join xxcr_stg_customers c on c.stg_cust_id = s.stg_cust_id
       where s.project_id = p_project_id
       order by s.stg_site_id
    ) loop
      l_row_num := l_row_num + 1;
      l_rn := to_char(l_row_num);
      buf_add('<row r="' || l_rn || '">');
      add_num('A' || l_rn, r.stg_site_id, 6);
      add_str('B' || l_rn, case when instr(nvl(r.user_notes, '~'), '[AUTO-EXCLUDED: Account]') > 0 then 'Y' else nvl(r.include_yn, 'Y') end, 2);
      add_f_str(
        'C' || l_rn,
        'IF(IFERROR(UPPER(INDEX(''1_Customers''!$B$2:$B$' || l_cust_rng || ',MATCH(D' || l_rn || ',''1_Customers''!$A$2:$A$' || l_cust_rng || ',0))),"Y")="N","N",IF(UPPER(B' || l_rn || ')="N","N","Y"))',
        case when r.cust_include_yn = 'N' or r.include_yn = 'N' then 'N' else 'Y' end,
        3
      );
      add_num('D' || l_rn, r.stg_cust_id, 6);
      add_f_str(
        'E' || l_rn,
        'IF(IFERROR(UPPER(INDEX(''1_Customers''!$B$2:$B$' || l_cust_rng || ',MATCH(D' || l_rn || ',''1_Customers''!$A$2:$A$' || l_cust_rng || ',0))),"Y")="N","EXCLUDED (Account)",IF(UPPER(B' || l_rn || ')="N","EXCLUDED (Site)",IF(LEFT(I' || l_rn || ',9)="DUPLICATE","REVIEW DUPLICATE","INCLUDED")))',
        case when r.cust_include_yn = 'N' then 'EXCLUDED (Account)' when r.include_yn = 'N' then 'EXCLUDED (Site)' when r.dup_role like 'DUPLICATE%' then 'REVIEW DUPLICATE' else 'INCLUDED' end,
        3
      );
      add_str('F' || l_rn, r.site_ref_code, 6);
      add_str('G' || l_rn, r.tgt_account_number, 6);
      add_f_str(
        'H' || l_rn,
        'IFERROR(INDEX(''1_Customers''!$G$2:$G$' || l_cust_rng || ',MATCH(D' || l_rn || ',''1_Customers''!$A$2:$A$' || l_cust_rng || ',0)),"")',
        r.cust_party_name,
        3
      );
      add_str('I' || l_rn, nvl(r.dup_role, 'UNIQUE'), 6);
      add_num('J' || l_rn, r.dup_count, 5);
      add_num('K' || l_rn, nvl(r.src_open_ar_amt, 0), 4);
      add_num('L' || l_rn, nvl(r.src_trx_cnt_recent, 0), 5);
      add_num('M' || l_rn, nvl(r.src_open_so_cnt, 0), 5);
      add_str('N' || l_rn, to_char(r.src_last_trx_date, 'YYYY-MM-DD'), 6);
      add_str('O' || l_rn, r.address_mode, 6);
      add_str('P' || l_rn, r.tgt_party_site_number);
      add_str('Q' || l_rn, r.tgt_country);
      add_str('R' || l_rn, r.tgt_address1);
      add_str('S' || l_rn, r.tgt_address2);
      add_str('T' || l_rn, r.tgt_city);
      add_str('U' || l_rn, r.tgt_state);
      add_str('V' || l_rn, r.tgt_postal_code);
      add_str('W' || l_rn, r.tgt_customer_category);
      add_str('X' || l_rn, r.tgt_sales_currency);
      add_str('Y' || l_rn, r.tgt_rps_hold_flag);
      add_str('Z' || l_rn, r.tgt_third_party_name);
      add_str('AA' || l_rn, r.val_status, 6);
      add_str('AB' || l_rn, trim(replace(r.user_notes, '[AUTO-EXCLUDED: Account]', '')));
      buf_add('</row>');
    end loop;
    buf_add('</sheetData>');
    buf_add('<autoFilter ref="A1:AB' || greatest(l_row_num, 2) || '"/>');
    if l_row_num >= 2 then
      buf_add('<conditionalFormatting sqref="A2:AB' || l_row_num || '"><cfRule type="expression" dxfId="0" priority="1"><formula>$C2="N"</formula></cfRule></conditionalFormatting>');
      buf_add('<dataValidations count="4">');
      buf_add('<dataValidation type="list" allowBlank="1" showInputMessage="1" showErrorMessage="1" sqref="B2:B' || l_site_rng || '"><formula1>"Y,N"</formula1></dataValidation>');
      buf_add('<dataValidation type="list" allowBlank="1" showInputMessage="1" showErrorMessage="1" sqref="Q2:Q' || l_site_rng || '"><formula1>''9_EBS_LOVs''!$G$2:$G$300</formula1></dataValidation>');
      buf_add('<dataValidation type="list" allowBlank="1" showInputMessage="1" showErrorMessage="1" sqref="X2:X' || l_site_rng || '"><formula1>''9_EBS_LOVs''!$F$2:$F$100</formula1></dataValidation>');
      buf_add('<dataValidation type="list" allowBlank="1" showInputMessage="1" showErrorMessage="1" sqref="Y2:Y' || l_site_rng || '"><formula1>"Y,N"</formula1></dataValidation>');
      buf_add('</dataValidations>');
    end if;
    buf_add('</worksheet>');
    buf_push_zip('xl/worksheets/sheet3.xml');

    -- =========================================================================
    -- Sheet 4: 3_Site_Uses_GL (Connected to 1_Customers & 2_Addresses_Sites)
    -- =========================================================================
    buf_init;
    buf_add('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>');
    buf_add('<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">');
    buf_add('<sheetViews><sheetView rightToLeft="0" workbookViewId="0"><pane ySplit="1" topLeftCell="A2" activePane="bottomLeft" state="frozen"/><selection pane="bottomLeft" activeCell="A2" sqref="A2"/></sheetView></sheetViews>');
    buf_add('<cols>');
    buf_add('<col min="1" max="1" width="15" customWidth="1"/>');
    buf_add('<col min="2" max="3" width="18" customWidth="1"/>');
    buf_add('<col min="4" max="5" width="13" customWidth="1"/>');
    buf_add('<col min="6" max="9" width="20" customWidth="1"/>');
    buf_add('<col min="10" max="11" width="32" customWidth="1"/>');
    buf_add('<col min="12" max="14" width="14" customWidth="1"/>');
    buf_add('<col min="15" max="15" width="28" customWidth="1"/>');
    buf_add('<col min="16" max="32" width="18" customWidth="1"/>');
    buf_add('<col min="33" max="35" width="38" customWidth="1"/>');
    buf_add('<col min="36" max="37" width="24" customWidth="1"/>');
    buf_add('</cols>');
    buf_add('<sheetData>');
    buf_add('<row r="1">');
    add_str('A1', 'Stg Site Use ID', 1);
    add_str('B1', 'Site Use Include (Y/N)', 1);
    add_str('C1', 'Effective Include', 1);
    add_str('D1', 'Stg Cust ID', 1);
    add_str('E1', 'Stg Site ID', 1);
    add_str('F1', 'Rollout Status', 1);
    add_str('G1', 'AWP Scope', 1);
    add_str('H1', 'Site Ref Code', 1);
    add_str('I1', 'Target Acct #', 1);
    add_str('J1', 'Customer Party Name (Linked)', 1);
    add_str('K1', 'Site Address (Linked)', 1);
    add_str('L1', 'Site Use', 1);
    add_str('M1', 'Location Code', 1);
    add_str('N1', 'Primary', 1);
    add_str('O1', 'Dup Role', 1);
    add_str('P1', 'Duplicates', 1);
    add_str('Q1', 'Open AR (AUD)', 1);
    add_str('R1', '24m Trx Cnt', 1);
    add_str('S1', 'Open SO Cnt', 1);
    add_str('T1', 'Last Activity Date', 1);
    add_str('U1', 'Bill-To Location', 1);
    add_str('V1', 'Profile Class', 1);
    add_str('W1', 'Collector', 1);
    add_str('X1', 'Payment Term', 1);
    add_str('Y1', 'Credit Currency', 1);
    add_str('Z1', 'Overall Credit Limit', 1);
    add_str('AA1', 'Order Credit Limit', 1);
    add_str('AB1', 'Salesperson', 1);
    add_str('AC1', 'Order Type', 1);
    add_str('AD1', 'Price List', 1);
    add_str('AE1', 'Warehouse', 1);
    add_str('AF1', 'Tax Code', 1);
    add_str('AG1', 'Site Tax Ref (ABN)', 1);
    add_str('AH1', 'AWP - Genie Rep (DFF)', 1);
    add_str('AI1', 'Ship Via (Carrier)', 1);
    add_str('AJ1', 'Send Stmts', 1);
    add_str('AK1', 'Stmt Cycle', 1);
    add_str('AL1', 'Discount Terms', 1);
    add_str('AM1', 'AutoCash Rule', 1);
    add_str('AN1', 'Grouping Rule', 1);
    add_str('AO1', 'Multi-Curr Summary', 1);
    add_str('AP1', 'Receivable GL Account', 1);
    add_str('AQ1', 'Revenue GL Account', 1);
    add_str('AR1', 'Tax GL Account', 1);
    add_str('AS1', 'Val Status', 1);
    add_str('AT1', 'User Notes', 1);
    buf_add('</row>');

    l_row_num := 1;
    for r in (
      select su.*,
             c.include_yn as cust_include_yn,
             c.tgt_party_name as cust_party_name,
             s.include_yn as site_include_yn,
             s.tgt_address1 || ', ' || s.tgt_city as site_addr_disp
        from xxcr_stg_site_uses su
        join xxcr_stg_sites s on s.stg_site_id = su.stg_site_id
        join xxcr_stg_customers c on c.stg_cust_id = su.stg_cust_id
       where su.project_id = p_project_id
       order by su.stg_site_use_id
    ) loop
      l_row_num := l_row_num + 1;
      l_rn := to_char(l_row_num);
      buf_add('<row r="' || l_rn || '">');
      add_num('A' || l_rn, r.stg_site_use_id, 6);
      add_str('B' || l_rn, case when instr(nvl(r.user_notes, '~'), '[AUTO-EXCLUDED:') > 0 then 'Y' else nvl(r.include_yn, 'Y') end, 2);
      add_f_str(
        'C' || l_rn,
        'IF(IFERROR(UPPER(INDEX(''2_Addresses_Sites''!$C$2:$C$' || l_site_rng || ',MATCH(E' || l_rn || ',''2_Addresses_Sites''!$A$2:$A$' || l_site_rng || ',0))),"Y")="N","N",IF(UPPER(B' || l_rn || ')="N","N","Y"))',
        case when r.cust_include_yn = 'N' or r.site_include_yn = 'N' or r.include_yn = 'N' then 'N' else 'Y' end,
        3
      );
      add_num('D' || l_rn, r.stg_cust_id, 6);
      add_num('E' || l_rn, r.stg_site_id, 6);
      add_f_str(
        'F' || l_rn,
        'IF(IFERROR(UPPER(INDEX(''1_Customers''!$B$2:$B$' || l_cust_rng || ',MATCH(D' || l_rn || ',''1_Customers''!$A$2:$A$' || l_cust_rng || ',0))),"Y")="N","EXCLUDED (Account)",IF(IFERROR(UPPER(INDEX(''2_Addresses_Sites''!$B$2:$B$' || l_site_rng || ',MATCH(E' || l_rn || ',''2_Addresses_Sites''!$A$2:$A$' || l_site_rng || ',0))),"Y")="N","EXCLUDED (Site)",IF(UPPER(B' || l_rn || ')="N","EXCLUDED (Site Use)",IF(LEFT(O' || l_rn || ',9)="DUPLICATE","REVIEW DUPLICATE","INCLUDED"))))',
        case when r.cust_include_yn = 'N' then 'EXCLUDED (Account)' when r.site_include_yn = 'N' then 'EXCLUDED (Site)' when r.include_yn = 'N' then 'EXCLUDED (Site Use)' when r.dup_role like 'DUPLICATE%' then 'REVIEW DUPLICATE' else 'INCLUDED' end,
        3
      );
      add_str('G' || l_rn, r.scope_class, 6);
      add_str('H' || l_rn, r.site_ref_code, 6);
      add_str('I' || l_rn, r.tgt_account_number, 6);
      add_f_str(
        'J' || l_rn,
        'IFERROR(INDEX(''1_Customers''!$G$2:$G$' || l_cust_rng || ',MATCH(D' || l_rn || ',''1_Customers''!$A$2:$A$' || l_cust_rng || ',0)),"")',
        r.cust_party_name,
        3
      );
      add_f_str(
        'K' || l_rn,
        'IFERROR(INDEX(''2_Addresses_Sites''!$R$2:$R$' || l_site_rng || ',MATCH(E' || l_rn || ',''2_Addresses_Sites''!$A$2:$A$' || l_site_rng || ',0))&", "&INDEX(''2_Addresses_Sites''!$T$2:$T$' || l_site_rng || ',MATCH(E' || l_rn || ',''2_Addresses_Sites''!$A$2:$A$' || l_site_rng || ',0)),"")',
        r.site_addr_disp,
        3
      );
      add_str('L' || l_rn, r.tgt_site_use_code, 6);
      add_str('M' || l_rn, r.tgt_location_code);
      add_str('N' || l_rn, r.tgt_primary_flag);
      add_str('O' || l_rn, nvl(r.dup_role, 'UNIQUE'), 6);
      add_num('P' || l_rn, r.dup_count, 5);
      add_num('Q' || l_rn, nvl(r.src_open_ar_amt, 0), 4);
      add_num('R' || l_rn, nvl(r.src_trx_cnt_recent, 0), 5);
      add_num('S' || l_rn, nvl(r.src_open_so_cnt, 0), 5);
      add_str('T' || l_rn, to_char(r.src_last_trx_date, 'YYYY-MM-DD'), 6);
      add_str('U' || l_rn, r.tgt_bill_to_location_code);
      add_str('V' || l_rn, r.tgt_profile_class_name);
      add_str('W' || l_rn, r.tgt_collector_name);
      add_str('X' || l_rn, r.tgt_payment_term_name);
      add_str('Y' || l_rn, r.tgt_credit_currency);
      add_num('Z' || l_rn, r.tgt_overall_credit_limit, 4);
      add_num('AA' || l_rn, r.tgt_trx_credit_limit, 4);
      add_str('AB' || l_rn, r.tgt_salesrep_name);
      add_str('AC' || l_rn, r.tgt_order_type_name);
      add_str('AD' || l_rn, r.tgt_price_list_name);
      add_str('AE' || l_rn, r.tgt_warehouse_code);
      add_str('AF' || l_rn, r.tgt_tax_code);
      add_str('AG' || l_rn, r.tgt_tax_reference);
      add_str('AH' || l_rn, r.tgt_awp_genie_rep);
      add_str('AI' || l_rn, r.tgt_ship_via);
      add_str('AJ' || l_rn, r.tgt_send_statements);
      add_str('AK' || l_rn, r.tgt_statement_cycle_name);
      add_str('AL' || l_rn, r.tgt_discount_terms);
      add_str('AM' || l_rn, r.tgt_autocash_rule_name);
      add_str('AN' || l_rn, r.tgt_grouping_rule_name);
      add_str('AO' || l_rn, r.multi_curr_summary, 6);
      add_str('AP' || l_rn, r.tgt_gl_rec_concat);
      add_str('AQ' || l_rn, r.tgt_gl_rev_concat);
      add_str('AR' || l_rn, r.tgt_gl_tax_concat);
      add_str('AS' || l_rn, r.val_status, 6);
      add_str('AT' || l_rn, trim(replace(replace(r.user_notes, '[AUTO-EXCLUDED: Account]', ''), '[AUTO-EXCLUDED: Site]', '')));
      buf_add('</row>');
    end loop;
    buf_add('</sheetData>');
    buf_add('<autoFilter ref="A1:AT' || greatest(l_row_num, 2) || '"/>');
    if l_row_num >= 2 then
      buf_add('<conditionalFormatting sqref="A2:AT' || l_row_num || '"><cfRule type="expression" dxfId="0" priority="1"><formula>$C2="N"</formula></cfRule></conditionalFormatting>');
      buf_add('<dataValidations count="16">');
      buf_add('<dataValidation type="list" allowBlank="1" showInputMessage="1" showErrorMessage="1" sqref="B2:B' || l_su_rng || '"><formula1>"Y,N"</formula1></dataValidation>');
      buf_add('<dataValidation type="list" allowBlank="1" showInputMessage="1" showErrorMessage="1" sqref="N2:N' || l_su_rng || '"><formula1>"Y,N"</formula1></dataValidation>');
      buf_add('<dataValidation type="list" allowBlank="1" showInputMessage="1" showErrorMessage="0" sqref="V2:V' || l_su_rng || '"><formula1>''9_EBS_LOVs''!$C$2:$C$100</formula1></dataValidation>');
      buf_add('<dataValidation type="list" allowBlank="1" showInputMessage="1" showErrorMessage="0" sqref="W2:W' || l_su_rng || '"><formula1>''9_EBS_LOVs''!$D$2:$D$300</formula1></dataValidation>');
      buf_add('<dataValidation type="list" allowBlank="1" showInputMessage="1" showErrorMessage="0" sqref="X2:X' || l_su_rng || '"><formula1>''9_EBS_LOVs''!$E$2:$E$1000</formula1></dataValidation>');
      buf_add('<dataValidation type="list" allowBlank="1" showInputMessage="1" showErrorMessage="1" sqref="Y2:Y' || l_su_rng || '"><formula1>''9_EBS_LOVs''!$F$2:$F$100</formula1></dataValidation>');
      buf_add('<dataValidation type="decimal" operator="greaterThanOrEqual" allowBlank="1" showInputMessage="1" showErrorMessage="1" sqref="Z2:AA' || l_su_rng || '"><formula1>0</formula1></dataValidation>');
      buf_add('<dataValidation type="list" allowBlank="1" showInputMessage="1" showErrorMessage="0" sqref="AC2:AC' || l_su_rng || '"><formula1>''9_EBS_LOVs''!$H$2:$H$300</formula1></dataValidation>');
      buf_add('<dataValidation type="list" allowBlank="1" showInputMessage="1" showErrorMessage="0" sqref="AD2:AD' || l_su_rng || '"><formula1>''9_EBS_LOVs''!$I$2:$I$2500</formula1></dataValidation>');
      buf_add('<dataValidation type="list" allowBlank="1" showInputMessage="1" showErrorMessage="0" sqref="AE2:AE' || l_su_rng || '"><formula1>''9_EBS_LOVs''!$J$2:$J$350</formula1></dataValidation>');
      buf_add('<dataValidation type="list" allowBlank="1" showInputMessage="1" showErrorMessage="0" sqref="AF2:AF' || l_su_rng || '"><formula1>''9_EBS_LOVs''!$K$2:$K$200</formula1></dataValidation>');
      buf_add('<dataValidation type="list" allowBlank="1" showInputMessage="1" showErrorMessage="1" sqref="AJ2:AJ' || l_su_rng || '"><formula1>"Y,N"</formula1></dataValidation>');
      buf_add('<dataValidation type="list" allowBlank="1" showInputMessage="1" showErrorMessage="0" sqref="AK2:AK' || l_su_rng || '"><formula1>''9_EBS_LOVs''!$L$2:$L$50</formula1></dataValidation>');
      buf_add('<dataValidation type="list" allowBlank="1" showInputMessage="1" showErrorMessage="1" sqref="AL2:AL' || l_su_rng || '"><formula1>"Y,N"</formula1></dataValidation>');
      buf_add('<dataValidation type="list" allowBlank="1" showInputMessage="1" showErrorMessage="0" sqref="AM2:AM' || l_su_rng || '"><formula1>''9_EBS_LOVs''!$M$2:$M$50</formula1></dataValidation>');
      buf_add('<dataValidation type="list" allowBlank="1" showInputMessage="1" showErrorMessage="0" sqref="AN2:AN' || l_su_rng || '"><formula1>''9_EBS_LOVs''!$N$2:$N$100</formula1></dataValidation>');
      buf_add('</dataValidations>');
    end if;
    buf_add('</worksheet>');
    buf_push_zip('xl/worksheets/sheet4.xml');

    -- =========================================================================
    -- Sheet 5: 4_Contacts (Connected to 1_Customers & 2_Addresses_Sites)
    -- =========================================================================
    buf_init;
    buf_add('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>');
    buf_add('<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">');
    buf_add('<sheetViews><sheetView rightToLeft="0" workbookViewId="0"><pane ySplit="1" topLeftCell="A2" activePane="bottomLeft" state="frozen"/><selection pane="bottomLeft" activeCell="A2" sqref="A2"/></sheetView></sheetViews>');
    buf_add('<cols>');
    buf_add('<col min="1" max="1" width="15" customWidth="1"/>');
    buf_add('<col min="2" max="3" width="18" customWidth="1"/>');
    buf_add('<col min="4" max="5" width="13" customWidth="1"/>');
    buf_add('<col min="6" max="9" width="20" customWidth="1"/>');
    buf_add('<col min="10" max="10" width="32" customWidth="1"/>');
    buf_add('<col min="11" max="19" width="18" customWidth="1"/>');
    buf_add('<col min="20" max="22" width="20" customWidth="1"/>');
    buf_add('</cols>');
    buf_add('<sheetData>');
    buf_add('<row r="1">');
    add_str('A1', 'Stg Contact ID', 1);
    add_str('B1', 'Contact Include (Y/N)', 1);
    add_str('C1', 'Effective Include', 1);
    add_str('D1', 'Stg Cust ID', 1);
    add_str('E1', 'Stg Site ID', 1);
    add_str('F1', 'Rollout Status', 1);
    add_str('G1', 'Contact Ref Code', 1);
    add_str('H1', 'Site Ref Code', 1);
    add_str('I1', 'Target Acct #', 1);
    add_str('J1', 'Customer Party Name (Linked)', 1);
    add_str('K1', 'First Name', 1);
    add_str('L1', 'Last Name', 1);
    add_str('M1', 'Job Title', 1);
    add_str('N1', 'Department', 1);
    add_str('O1', 'Role Primary', 1);
    add_str('P1', 'Email Address', 1);
    add_str('Q1', 'Country Code', 1);
    add_str('R1', 'Area Code', 1);
    add_str('S1', 'Phone Number', 1);
    add_str('T1', 'Mobile Number', 1);
    add_str('U1', 'Fax Number', 1);
    add_str('V1', 'Duplicates', 1);
    add_str('W1', 'Val Status', 1);
    add_str('X1', 'User Notes', 1);
    buf_add('</row>');

    l_row_num := 1;
    for r in (
      select ct.*,
             c.include_yn as cust_include_yn,
             c.tgt_party_name as cust_party_name,
             s.include_yn as site_include_yn
        from xxcr_stg_contacts ct
        join xxcr_stg_customers c on c.stg_cust_id = ct.stg_cust_id
        left join xxcr_stg_sites s on s.stg_site_id = ct.stg_site_id
       where ct.project_id = p_project_id
       order by ct.stg_contact_id
    ) loop
      l_row_num := l_row_num + 1;
      l_rn := to_char(l_row_num);
      buf_add('<row r="' || l_rn || '">');
      add_num('A' || l_rn, r.stg_contact_id, 6);
      add_str('B' || l_rn, case when instr(nvl(r.user_notes, '~'), '[AUTO-EXCLUDED:') > 0 then 'Y' else nvl(r.include_yn, 'Y') end, 2);
      add_f_str(
        'C' || l_rn,
        'IF(IFERROR(UPPER(INDEX(''1_Customers''!$B$2:$B$' || l_cust_rng || ',MATCH(D' || l_rn || ',''1_Customers''!$A$2:$A$' || l_cust_rng || ',0))),"Y")="N","N",IF(AND(ISNUMBER(E' || l_rn || '),IFERROR(UPPER(INDEX(''2_Addresses_Sites''!$C$2:$C$' || l_site_rng || ',MATCH(E' || l_rn || ',''2_Addresses_Sites''!$A$2:$A$' || l_site_rng || ',0))),"Y")="N"),"N",IF(UPPER(B' || l_rn || ')="N","N","Y")))',
        case when r.cust_include_yn = 'N' or (r.stg_site_id is not null and r.site_include_yn = 'N') or r.include_yn = 'N' then 'N' else 'Y' end,
        3
      );
      add_num('D' || l_rn, r.stg_cust_id, 6);
      add_num('E' || l_rn, r.stg_site_id, 6);
      add_f_str(
        'F' || l_rn,
        'IF(IFERROR(UPPER(INDEX(''1_Customers''!$B$2:$B$' || l_cust_rng || ',MATCH(D' || l_rn || ',''1_Customers''!$A$2:$A$' || l_cust_rng || ',0))),"Y")="N","EXCLUDED (Account)",IF(AND(ISNUMBER(E' || l_rn || '),IFERROR(UPPER(INDEX(''2_Addresses_Sites''!$B$2:$B$' || l_site_rng || ',MATCH(E' || l_rn || ',''2_Addresses_Sites''!$A$2:$A$' || l_site_rng || ',0))),"Y")="N"),"EXCLUDED (Site)",IF(UPPER(B' || l_rn || ')="N","EXCLUDED (Contact)","INCLUDED")))',
        case when r.cust_include_yn = 'N' then 'EXCLUDED (Account)' when (r.stg_site_id is not null and r.site_include_yn = 'N') then 'EXCLUDED (Site)' when r.include_yn = 'N' then 'EXCLUDED (Contact)' else 'INCLUDED' end,
        3
      );
      add_str('G' || l_rn, r.contact_ref_code, 6);
      add_str('H' || l_rn, r.site_ref_code, 6);
      add_str('I' || l_rn, r.tgt_account_number, 6);
      add_f_str(
        'J' || l_rn,
        'IFERROR(INDEX(''1_Customers''!$G$2:$G$' || l_cust_rng || ',MATCH(D' || l_rn || ',''1_Customers''!$A$2:$A$' || l_cust_rng || ',0)),"")',
        r.cust_party_name,
        3
      );
      add_str('K' || l_rn, r.tgt_first_name);
      add_str('L' || l_rn, r.tgt_last_name);
      add_str('M' || l_rn, r.tgt_job_title);
      add_str('N' || l_rn, r.tgt_department);
      add_str('O' || l_rn, r.tgt_primary_flag);
      add_str('P' || l_rn, r.tgt_email_address);
      add_str('Q' || l_rn, r.tgt_phone_country_code);
      add_str('R' || l_rn, r.tgt_phone_area_code);
      add_str('S' || l_rn, r.tgt_phone_number);
      add_str('T' || l_rn, r.tgt_mobile_number);
      add_str('U' || l_rn, r.tgt_fax_number);
      add_num('V' || l_rn, r.dup_count, 5);
      add_str('W' || l_rn, r.val_status, 6);
      add_str('X' || l_rn, trim(replace(replace(r.user_notes, '[AUTO-EXCLUDED: Account]', ''), '[AUTO-EXCLUDED: Site]', '')));
      buf_add('</row>');
    end loop;
    buf_add('</sheetData>');
    buf_add('<autoFilter ref="A1:X' || greatest(l_row_num, 2) || '"/>');
    if l_row_num >= 2 then
      buf_add('<conditionalFormatting sqref="A2:X' || l_row_num || '"><cfRule type="expression" dxfId="0" priority="1"><formula>$C2="N"</formula></cfRule></conditionalFormatting>');
      buf_add('<dataValidations count="2">');
      buf_add('<dataValidation type="list" allowBlank="1" showInputMessage="1" showErrorMessage="1" sqref="B2:B' || l_ct_rng || '"><formula1>"Y,N"</formula1></dataValidation>');
      buf_add('<dataValidation type="list" allowBlank="1" showInputMessage="1" showErrorMessage="1" sqref="O2:O' || l_ct_rng || '"><formula1>"Y,N"</formula1></dataValidation>');
      buf_add('</dataValidations>');
    end if;
    buf_add('</worksheet>');
    buf_push_zip('xl/worksheets/sheet5.xml');

    -- =========================================================================
    -- Sheet 6: 5_Multi_Curr_Credit (HZ_CUST_PROFILE_AMTS — AUD / USD / NZD / EUR)
    -- =========================================================================
    buf_init;
    buf_add('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>');
    buf_add('<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">');
    buf_add('<sheetViews><sheetView rightToLeft="0" workbookViewId="0"><pane ySplit="1" topLeftCell="A2" activePane="bottomLeft" state="frozen"/><selection pane="bottomLeft" activeCell="A2" sqref="A2"/></sheetView></sheetViews>');
    buf_add('<cols><col min="1" max="13" width="20" customWidth="1"/></cols>');
    buf_add('<sheetData>');
    buf_add('<row r="1">');
    add_str('A1', 'Stg Prof Amt ID', 1);
    add_str('B1', 'Include (Y/N)', 1);
    add_str('C1', 'Target Acct #', 1);
    add_str('D1', 'Customer Party Name', 1);
    add_str('E1', 'Site Ref Code', 1);
    add_str('F1', 'Bill-To Location', 1);
    add_str('G1', 'Source Currency', 1);
    add_str('H1', 'Target Currency', 1);
    add_str('I1', 'Src Overall Limit', 1);
    add_str('J1', 'Target Overall Limit', 1);
    add_str('K1', 'Target Order Limit', 1);
    add_str('L1', 'Exchange Rate Type', 1);
    add_str('M1', 'User Notes', 1);
    buf_add('</row>');
    l_row_num := 1;
    for r in (
      select pa.*, c.tgt_party_name
        from xxcr_stg_profile_amts pa
        join xxcr_stg_customers c on c.stg_cust_id = pa.stg_cust_id
       where pa.project_id = p_project_id
       order by pa.tgt_account_number, pa.tgt_location_code, pa.tgt_currency_code
    ) loop
      l_row_num := l_row_num + 1;
      l_rn := to_char(l_row_num);
      buf_add('<row r="' || l_rn || '">');
      add_num('A' || l_rn, r.stg_prof_amt_id, 6);
      add_str('B' || l_rn, r.include_yn, 2);
      add_str('C' || l_rn, r.tgt_account_number, 6);
      add_str('D' || l_rn, r.tgt_party_name, 6);
      add_str('E' || l_rn, r.site_ref_code, 6);
      add_str('F' || l_rn, r.tgt_location_code, 6);
      add_str('G' || l_rn, r.src_currency_code, 6);
      add_str('H' || l_rn, r.tgt_currency_code);
      add_num('I' || l_rn, r.src_overall_credit_limit, 4);
      add_num('J' || l_rn, r.tgt_overall_credit_limit, 4);
      add_num('K' || l_rn, r.tgt_trx_credit_limit, 4);
      add_str('L' || l_rn, r.tgt_exchange_rate_type);
      add_str('M' || l_rn, r.user_notes);
      buf_add('</row>');
    end loop;
    buf_add('</sheetData>');
    if l_row_num >= 2 then
      buf_add('<dataValidations count="3">');
      buf_add('<dataValidation type="list" allowBlank="1" showInputMessage="1" showErrorMessage="1" sqref="B2:B' || greatest(l_row_num + 100, 10) || '"><formula1>"Y,N"</formula1></dataValidation>');
      buf_add('<dataValidation type="list" allowBlank="1" showInputMessage="1" showErrorMessage="1" sqref="H2:H' || greatest(l_row_num + 100, 10) || '"><formula1>''9_EBS_LOVs''!$F$2:$F$100</formula1></dataValidation>');
      buf_add('<dataValidation type="decimal" operator="greaterThanOrEqual" allowBlank="1" showInputMessage="1" showErrorMessage="1" sqref="J2:K' || greatest(l_row_num + 100, 10) || '"><formula1>0</formula1></dataValidation>');
      buf_add('</dataValidations>');
    end if;
    buf_add('</worksheet>');
    buf_push_zip('xl/worksheets/sheet6.xml');

    -- =========================================================================
    -- Sheet 7: 6_Acct_Relationships (HZ_CUST_ACCT_RELATE_ALL)
    -- =========================================================================
    buf_init;
    buf_add('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>');
    buf_add('<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">');
    buf_add('<sheetViews><sheetView rightToLeft="0" workbookViewId="0"><pane ySplit="1" topLeftCell="A2" activePane="bottomLeft" state="frozen"/><selection pane="bottomLeft" activeCell="A2" sqref="A2"/></sheetView></sheetViews>');
    buf_add('<cols><col min="1" max="12" width="22" customWidth="1"/></cols>');
    buf_add('<sheetData>');
    buf_add('<row r="1">');
    add_str('A1', 'Stg Relate ID', 1);
    add_str('B1', 'Include (Y/N)', 1);
    add_str('C1', 'Account #', 1);
    add_str('D1', 'Account Party Name', 1);
    add_str('E1', 'Related Account #', 1);
    add_str('F1', 'Related Party Name', 1);
    add_str('G1', 'Both In Scope', 1);
    add_str('H1', 'Relationship Type', 1);
    add_str('I1', 'Bill-To Allowed', 1);
    add_str('J1', 'Ship-To Allowed', 1);
    add_str('K1', 'Reciprocal Flag', 1);
    add_str('L1', 'User Notes', 1);
    buf_add('</row>');
    l_row_num := 1;
    for r in (
      select * from xxcr_stg_acct_relates
       where project_id = p_project_id
       order by tgt_account_number, tgt_related_account_num
    ) loop
      l_row_num := l_row_num + 1;
      l_rn := to_char(l_row_num);
      buf_add('<row r="' || l_rn || '">');
      add_num('A' || l_rn, r.stg_relate_id, 6);
      add_str('B' || l_rn, r.include_yn, 2);
      add_str('C' || l_rn, r.tgt_account_number, 6);
      add_str('D' || l_rn, r.src_party_name, 6);
      add_str('E' || l_rn, r.tgt_related_account_num, 6);
      add_str('F' || l_rn, r.src_related_party_name, 6);
      add_str('G' || l_rn, r.both_in_scope_yn, 6);
      add_str('H' || l_rn, r.tgt_relationship_type);
      add_str('I' || l_rn, r.tgt_bill_to_flag);
      add_str('J' || l_rn, r.tgt_ship_to_flag);
      add_str('K' || l_rn, r.tgt_reciprocal_flag);
      add_str('L' || l_rn, r.user_notes);
      buf_add('</row>');
    end loop;
    buf_add('</sheetData>');
    if l_row_num >= 2 then
      buf_add('<dataValidations count="2">');
      buf_add('<dataValidation type="list" allowBlank="1" showInputMessage="1" showErrorMessage="1" sqref="B2:B' || greatest(l_row_num + 100, 10) || '"><formula1>"Y,N"</formula1></dataValidation>');
      buf_add('<dataValidation type="list" allowBlank="1" showInputMessage="1" showErrorMessage="1" sqref="I2:K' || greatest(l_row_num + 100, 10) || '"><formula1>"Y,N"</formula1></dataValidation>');
      buf_add('</dataValidations>');
    end if;
    buf_add('</worksheet>');
    buf_push_zip('xl/worksheets/sheet7.xml');

    -- =========================================================================
    -- Sheet 8: 7_Payment_Instr (IBY_EXTERNAL_PAYERS_ALL & RA_CUST_RECEIPT_METHODS)
    -- =========================================================================
    buf_init;
    buf_add('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>');
    buf_add('<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">');
    buf_add('<sheetViews><sheetView rightToLeft="0" workbookViewId="0"><pane ySplit="1" topLeftCell="A2" activePane="bottomLeft" state="frozen"/><selection pane="bottomLeft" activeCell="A2" sqref="A2"/></sheetView></sheetViews>');
    buf_add('<cols><col min="1" max="12" width="22" customWidth="1"/></cols>');
    buf_add('<sheetData>');
    buf_add('<row r="1">');
    add_str('A1', 'Stg Pmt ID', 1);
    add_str('B1', 'Include (Y/N)', 1);
    add_str('C1', 'Assignment Source', 1);
    add_str('D1', 'Level', 1);
    add_str('E1', 'Target Acct #', 1);
    add_str('F1', 'Bill-To Location', 1);
    add_str('G1', 'Instrument Type', 1);
    add_str('H1', 'Masked Account / Receipt Method', 1);
    add_str('I1', 'Currency', 1);
    add_str('J1', 'Primary Flag', 1);
    add_str('K1', 'Preference Order', 1);
    add_str('L1', 'Target Receipt Method', 1);
    add_str('M1', 'User Notes', 1);
    buf_add('</row>');
    l_row_num := 1;
    for r in (
      select * from xxcr_stg_payment_instr
       where project_id = p_project_id
       order by tgt_account_number, tgt_location_code, src_order_of_pref nulls last
    ) loop
      l_row_num := l_row_num + 1;
      l_rn := to_char(l_row_num);
      buf_add('<row r="' || l_rn || '">');
      add_num('A' || l_rn, r.stg_pmt_id, 6);
      add_str('B' || l_rn, r.include_yn, 2);
      add_str('C' || l_rn, r.assignment_source, 6);
      add_str('D' || l_rn, r.assignment_level, 6);
      add_str('E' || l_rn, r.tgt_account_number, 6);
      add_str('F' || l_rn, r.tgt_location_code, 6);
      add_str('G' || l_rn, r.instrument_type, 6);
      add_str('H' || l_rn, r.masked_account_or_method, 6);
      add_str('I' || l_rn, r.currency_code, 6);
      add_str('J' || l_rn, r.tgt_primary_flag);
      add_num('K' || l_rn, r.tgt_order_of_pref, 5);
      add_str('L' || l_rn, r.tgt_receipt_method_name);
      add_str('M' || l_rn, r.user_notes);
      buf_add('</row>');
    end loop;
    buf_add('</sheetData>');
    if l_row_num >= 2 then
      buf_add('<dataValidations count="3">');
      buf_add('<dataValidation type="list" allowBlank="1" showInputMessage="1" showErrorMessage="1" sqref="B2:B' || greatest(l_row_num + 100, 10) || '"><formula1>"Y,N"</formula1></dataValidation>');
      buf_add('<dataValidation type="list" allowBlank="1" showInputMessage="1" showErrorMessage="1" sqref="J2:J' || greatest(l_row_num + 100, 10) || '"><formula1>"Y,N"</formula1></dataValidation>');
      buf_add('<dataValidation type="list" allowBlank="1" showInputMessage="1" showErrorMessage="0" sqref="L2:L' || greatest(l_row_num + 100, 10) || '"><formula1>''9_EBS_LOVs''!$P$2:$P$300</formula1></dataValidation>');
      buf_add('</dataValidations>');
    end if;
    buf_add('</worksheet>');
    buf_push_zip('xl/worksheets/sheet8.xml');

    -- =========================================================================
    -- Sheet 9: 9_EBS_LOVs (Hidden Reference Sheet for Excel Dropdown Lists)
    -- =========================================================================
    declare
      type t_str_list is table of varchar2(240) index by pls_integer;
      type t_col_matrix is table of t_str_list index by pls_integer;
      l_cols    t_col_matrix;
      l_max_row pls_integer := 2;

      procedure load_lov_col(p_col_idx in pls_integer, p_domain in varchar2) is
        l_idx pls_integer := 0;
      begin
        for r_l in (
          select return_value
            from xxcr_ebs_ref_lovs
           where domain_code = p_domain
             and active_yn = 'Y'
           order by return_value
        ) loop
          l_idx := l_idx + 1;
          l_cols(p_col_idx)(l_idx) := r_l.return_value;
        end loop;
        if l_idx + 1 > l_max_row then
          l_max_row := l_idx + 1;
        end if;
      end load_lov_col;
    begin
      l_cols(1)(1) := 'EXTEND_OU';
      l_cols(1)(2) := 'NEW_ACCT';
      l_max_row    := 3;

      load_lov_col(2,  'CUSTOMER_CLASS');
      load_lov_col(3,  'PROFILE_CLASS');
      load_lov_col(4,  'COLLECTOR');
      load_lov_col(5,  'PAYMENT_TERM');
      load_lov_col(6,  'CURRENCY');
      load_lov_col(7,  'COUNTRY');
      load_lov_col(8,  'ORDER_TYPE');
      load_lov_col(9,  'PRICE_LIST');
      load_lov_col(10, 'WAREHOUSE');
      load_lov_col(11, 'TAX_CODE');
      load_lov_col(12, 'STATEMENT_CYCLE');
      load_lov_col(13, 'AUTOCASH_RULE');
      load_lov_col(14, 'GROUPING_RULE');
      load_lov_col(15, 'DUNNING_SET');
      load_lov_col(16, 'RECEIPT_METHOD');

      buf_init;
      buf_add('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>');
      buf_add('<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">');
      buf_add('<sheetData>');
      buf_add('<row r="1">');
      add_str('A1', 'ACTION_CODE', 1);
      add_str('B1', 'CUSTOMER_CLASS', 1);
      add_str('C1', 'PROFILE_CLASS', 1);
      add_str('D1', 'COLLECTOR', 1);
      add_str('E1', 'PAYMENT_TERM', 1);
      add_str('F1', 'CURRENCY', 1);
      add_str('G1', 'COUNTRY', 1);
      add_str('H1', 'ORDER_TYPE', 1);
      add_str('I1', 'PRICE_LIST', 1);
      add_str('J1', 'WAREHOUSE', 1);
      add_str('K1', 'TAX_CODE', 1);
      add_str('L1', 'STATEMENT_CYCLE', 1);
      add_str('M1', 'AUTOCASH_RULE', 1);
      add_str('N1', 'GROUPING_RULE', 1);
      add_str('O1', 'DUNNING_SET', 1);
      add_str('P1', 'RECEIPT_METHOD', 1);
      buf_add('</row>');

      for r_i in 2 .. l_max_row loop
        l_rn := to_char(r_i);
        buf_add('<row r="' || l_rn || '">');
        if l_cols.exists(1)  and l_cols(1).exists(r_i - 1)  then add_str('A' || l_rn, l_cols(1)(r_i - 1));  end if;
        if l_cols.exists(2)  and l_cols(2).exists(r_i - 1)  then add_str('B' || l_rn, l_cols(2)(r_i - 1));  end if;
        if l_cols.exists(3)  and l_cols(3).exists(r_i - 1)  then add_str('C' || l_rn, l_cols(3)(r_i - 1));  end if;
        if l_cols.exists(4)  and l_cols(4).exists(r_i - 1)  then add_str('D' || l_rn, l_cols(4)(r_i - 1));  end if;
        if l_cols.exists(5)  and l_cols(5).exists(r_i - 1)  then add_str('E' || l_rn, l_cols(5)(r_i - 1));  end if;
        if l_cols.exists(6)  and l_cols(6).exists(r_i - 1)  then add_str('F' || l_rn, l_cols(6)(r_i - 1));  end if;
        if l_cols.exists(7)  and l_cols(7).exists(r_i - 1)  then add_str('G' || l_rn, l_cols(7)(r_i - 1));  end if;
        if l_cols.exists(8)  and l_cols(8).exists(r_i - 1)  then add_str('H' || l_rn, l_cols(8)(r_i - 1));  end if;
        if l_cols.exists(9)  and l_cols(9).exists(r_i - 1)  then add_str('I' || l_rn, l_cols(9)(r_i - 1));  end if;
        if l_cols.exists(10) and l_cols(10).exists(r_i - 1) then add_str('J' || l_rn, l_cols(10)(r_i - 1)); end if;
        if l_cols.exists(11) and l_cols(11).exists(r_i - 1) then add_str('K' || l_rn, l_cols(11)(r_i - 1)); end if;
        if l_cols.exists(12) and l_cols(12).exists(r_i - 1) then add_str('L' || l_rn, l_cols(12)(r_i - 1)); end if;
        if l_cols.exists(13) and l_cols(13).exists(r_i - 1) then add_str('M' || l_rn, l_cols(13)(r_i - 1)); end if;
        if l_cols.exists(14) and l_cols(14).exists(r_i - 1) then add_str('N' || l_rn, l_cols(14)(r_i - 1)); end if;
        if l_cols.exists(15) and l_cols(15).exists(r_i - 1) then add_str('O' || l_rn, l_cols(15)(r_i - 1)); end if;
        if l_cols.exists(16) and l_cols(16).exists(r_i - 1) then add_str('P' || l_rn, l_cols(16)(r_i - 1)); end if;
        buf_add('</row>');
      end loop;

      buf_add('</sheetData>');
      buf_add('</worksheet>');
      buf_push_zip('xl/worksheets/sheet9.xml');
    end;

    apex_zip.finish(p_zipped_blob => l_zip);
    return l_zip;
  end generate_connected_xlsx;

  ------------------------------------------------------------------------------
  -- 8. Excel Upload & Cell-Level Delta Application (Header-Driven + Cascading)
  ------------------------------------------------------------------------------
  procedure log_delta(
    p_import_id    in number,
    p_project_id   in number,
    p_sheet_name   in varchar2,
    p_entity_level in varchar2,
    p_stg_row_id   in number,
    p_record_key   in varchar2,
    p_col_name     in varchar2,
    p_old_val      in varchar2,
    p_new_val      in varchar2,
    p_change_type  in varchar2 default 'CELL_EDIT'
  ) is
  begin
    if nvl(trim(p_old_val), '~NULL~') <> nvl(trim(p_new_val), '~NULL~') then
      insert into xxcr_xls_deltas (
        import_id, project_id, sheet_name, entity_level, stg_row_id,
        record_key, column_name, old_value, new_value, change_type
      ) values (
        p_import_id, p_project_id, p_sheet_name, p_entity_level, p_stg_row_id,
        p_record_key, p_col_name, p_old_val, p_new_val, p_change_type
      );
    end if;
  end log_delta;

  procedure process_excel_upload(
    p_project_id   in number,
    p_file_name    in varchar2,
    p_mime_type    in varchar2,
    p_file_blob    in blob,
    p_target_sheet in varchar2 default 'AUTO',
    p_import_id    out number
  ) is
    l_import_id   number;
    l_rows_parsed number := 0;
    l_cells_mod   number := 0;
    l_new_rows    number := 0;

    type t_col_arr is varray(50) of varchar2(4000);
    type t_hdr_map is table of pls_integer index by varchar2(100);

    function norm_hdr(p_hdr in varchar2) return varchar2 is
    begin
      return trim(both '_' from regexp_replace(upper(nvl(p_hdr, '')), '[^A-Z0-9]+', '_'));
    end norm_hdr;

    function get_cell(
      p_cols in t_col_arr,
      p_map  in t_hdr_map,
      p_key1 in varchar2,
      p_key2 in varchar2 default null,
      p_key3 in varchar2 default null
    ) return varchar2 is
    begin
      if p_key1 is not null and p_map.exists(p_key1) then
        return trim(p_cols(p_map(p_key1)));
      elsif p_key2 is not null and p_map.exists(p_key2) then
        return trim(p_cols(p_map(p_key2)));
      elsif p_key3 is not null and p_map.exists(p_key3) then
        return trim(p_cols(p_map(p_key3)));
      end if;
      return null;
    end get_cell;

    function parse_yn(p_val in varchar2, p_default in varchar2 default 'Y') return varchar2 is
      l_v varchar2(30) := upper(trim(p_val));
    begin
      if l_v is null then
        return p_default;
      elsif l_v in ('N', 'NO', 'FALSE', '0') or l_v like 'N %' or l_v like 'EXCL%' then
        return 'N';
      elsif l_v in ('Y', 'YES', 'TRUE', '1', 'INCLUDED') then
        return 'Y';
      end if;
      return p_default;
    end parse_yn;

  begin
    -- Guard against uploading a Connected .xlsx workbook exported from a different Conversion Project
    declare
      l_active_code varchar2(50);
      l_file_code   varchar2(4000);
    begin
      select project_code into l_active_code from xxcr_projects where project_id = p_project_id;
      if lower(p_file_name) like '%.xlsx' then
        for r_sum in (
          select sheet_file_name
            from table(apex_data_parser.get_xlsx_worksheets(p_content => p_file_blob))
           where upper(sheet_display_name) like '0%SUMMARY%'
           fetch first 1 row only
        ) loop
          for r_b1 in (
            select col002
              from table(apex_data_parser.parse(
                     p_content         => p_file_blob,
                     p_file_name       => p_file_name,
                     p_xlsx_sheet_name => r_sum.sheet_file_name,
                     p_max_rows        => 1
                   ))
          ) loop
            l_file_code := trim(r_b1.col002);
          end loop;
        end loop;

        if l_file_code is not null and upper(l_file_code) <> upper(l_active_code) then
          raise_application_error(
            -20401,
            'Project Mismatch: Uploaded workbook belongs to project "' || l_file_code
            || '", whereas your Active Project in APEX is "' || l_active_code
            || '". Please switch your Active Project in the top bar before uploading.'
          );
        end if;
      end if;
    end;

    insert into xxcr_xls_imports (
      project_id, file_name, mime_type, file_blob, status
    ) values (
      p_project_id, p_file_name, p_mime_type, p_file_blob, 'PARSED'
    ) returning import_id into l_import_id;

    p_import_id := l_import_id;

    -- Iterate through worksheets in dependency order (Customers -> Sites -> Site Uses -> Contacts)
    for r_sheet in (
      select sheet_display_name, sheet_file_name, sheet_sequence
        from table(apex_data_parser.get_xlsx_worksheets(p_content => p_file_blob))
       where upper(sheet_display_name) not like '0%SUMMARY%'
         and upper(sheet_display_name) not like '9%LOV%'
      union all
      select 'CSV_DEFAULT' as sheet_display_name, null as sheet_file_name, 1 as sheet_sequence
        from dual
       where lower(p_file_name) like '%.csv'
       order by sheet_sequence
    ) loop
      declare
        l_hdrs t_col_arr;
        l_map  t_hdr_map;
        l_mode varchar2(30);
      begin
        -- Read Row 1 headers dynamically (COL001..COL050) so both Connected .xlsx and IG exports map cleanly
        for r_h in (
          select col001, col002, col003, col004, col005, col006, col007, col008, col009, col010,
                 col011, col012, col013, col014, col015, col016, col017, col018, col019, col020,
                 col021, col022, col023, col024, col025, col026, col027, col028, col029, col030,
                 col031, col032, col033, col034, col035, col036, col037, col038, col039, col040,
                 col041, col042, col043, col044, col045, col046, col047, col048, col049, col050
            from table(apex_data_parser.parse(
                   p_content         => p_file_blob,
                   p_file_name       => p_file_name,
                   p_xlsx_sheet_name => r_sheet.sheet_file_name,
                   p_max_rows        => 1
                 ))
        ) loop
          l_hdrs := t_col_arr(
            r_h.col001, r_h.col002, r_h.col003, r_h.col004, r_h.col005,
            r_h.col006, r_h.col007, r_h.col008, r_h.col009, r_h.col010,
            r_h.col011, r_h.col012, r_h.col013, r_h.col014, r_h.col015,
            r_h.col016, r_h.col017, r_h.col018, r_h.col019, r_h.col020,
            r_h.col021, r_h.col022, r_h.col023, r_h.col024, r_h.col025,
            r_h.col026, r_h.col027, r_h.col028, r_h.col029, r_h.col030,
            r_h.col031, r_h.col032, r_h.col033, r_h.col034, r_h.col035,
            r_h.col036, r_h.col037, r_h.col038, r_h.col039, r_h.col040,
            r_h.col041, r_h.col042, r_h.col043, r_h.col044, r_h.col045,
            r_h.col046, r_h.col047, r_h.col048, r_h.col049, r_h.col050
          );
          for idx in 1 .. 50 loop
            if norm_hdr(l_hdrs(idx)) is not null and not l_map.exists(norm_hdr(l_hdrs(idx))) then
              l_map(norm_hdr(l_hdrs(idx))) := idx;
            end if;
          end loop;
        end loop;

        if p_target_sheet <> 'AUTO' then
          l_mode := p_target_sheet;
        elsif l_map.exists('STG_PROF_AMT_ID') or upper(r_sheet.sheet_display_name) like '%MULTI%CURR%' then
          l_mode := 'MULTI_CURR';
        elsif l_map.exists('STG_RELATE_ID') or upper(r_sheet.sheet_display_name) like '%RELAT%' then
          l_mode := 'ACCT_RELATES';
        elsif l_map.exists('STG_PMT_ID') or upper(r_sheet.sheet_display_name) like '%PAYMENT%' then
          l_mode := 'PAYMENT_INSTR';
        elsif l_map.exists('STG_SITE_USE_ID') or upper(r_sheet.sheet_display_name) like '%SITE%USE%' then
          l_mode := 'SITE_USES';
        elsif l_map.exists('STG_CONTACT_ID') or upper(r_sheet.sheet_display_name) like '%CONTACT%' then
          l_mode := 'CONTACTS';
        elsif (l_map.exists('STG_SITE_ID') and not l_map.exists('STG_SITE_USE_ID') and not l_map.exists('STG_CONTACT_ID'))
           or upper(r_sheet.sheet_display_name) like '%ADDRESS%'
           or upper(r_sheet.sheet_display_name) like '2_SITES%' then
          l_mode := 'SITES';
        elsif l_map.exists('STG_CUST_ID') or upper(r_sheet.sheet_display_name) like '%CUST%' then
          l_mode := 'CUSTOMERS';
        else
          l_mode := null;
        end if;

        -- Process data rows of this worksheet
        if l_mode is not null then
          for r_data in (
            select line_number,
                   col001, col002, col003, col004, col005, col006, col007, col008, col009, col010,
                   col011, col012, col013, col014, col015, col016, col017, col018, col019, col020,
                   col021, col022, col023, col024, col025, col026, col027, col028, col029, col030,
                   col031, col032, col033, col034, col035, col036, col037, col038, col039, col040,
                   col041, col042, col043, col044, col045, col046, col047, col048, col049, col050
              from table(apex_data_parser.parse(
                     p_content         => p_file_blob,
                     p_file_name       => p_file_name,
                     p_xlsx_sheet_name => r_sheet.sheet_file_name,
                     p_skip_rows       => 1
                   ))
             where coalesce(trim(col001), trim(col002), trim(col004), trim(col006)) is not null
          ) loop
            declare
              l_cols t_col_arr := t_col_arr(
                r_data.col001, r_data.col002, r_data.col003, r_data.col004, r_data.col005,
                r_data.col006, r_data.col007, r_data.col008, r_data.col009, r_data.col010,
                r_data.col011, r_data.col012, r_data.col013, r_data.col014, r_data.col015,
                r_data.col016, r_data.col017, r_data.col018, r_data.col019, r_data.col020,
                r_data.col021, r_data.col022, r_data.col023, r_data.col024, r_data.col025,
                r_data.col026, r_data.col027, r_data.col028, r_data.col029, r_data.col030,
                r_data.col031, r_data.col032, r_data.col033, r_data.col034, r_data.col035,
                r_data.col036, r_data.col037, r_data.col038, r_data.col039, r_data.col040,
                r_data.col041, r_data.col042, r_data.col043, r_data.col044, r_data.col045,
                r_data.col046, r_data.col047, r_data.col048, r_data.col049, r_data.col050
              );
            begin
              if l_mode = 'CUSTOMERS' then
                declare
                  l_id        number       := to_number(get_cell(l_cols, l_map, 'STG_CUST_ID') default null on conversion error);
                  l_inc       varchar2(1)  := parse_yn(get_cell(l_cols, l_map, 'INCLUDE_Y_N', 'INCLUDE', 'INCLUDE_YN'), null);
                  l_act       varchar2(30) := upper(get_cell(l_cols, l_map, 'ACTION', 'ACTION_CODE'));
                  l_acct_no   varchar2(30) := get_cell(l_cols, l_map, 'TARGET_ACCT', 'TGT_ACCOUNT_NUMBER');
                  l_party_nm  varchar2(360):= get_cell(l_cols, l_map, 'TARGET_PARTY_NAME', 'TGT_PARTY_NAME');
                  l_acct_nm   varchar2(240):= get_cell(l_cols, l_map, 'TARGET_ACCOUNT_NAME', 'TGT_ACCOUNT_NAME');
                  l_tax_ref   varchar2(60) := get_cell(l_cols, l_map, 'TAX_REFERENCE', 'TGT_TAX_REFERENCE');
                  l_cust_cls  varchar2(30) := get_cell(l_cols, l_map, 'CUSTOMER_CLASS', 'TGT_CUSTOMER_CLASS_CODE');
                  l_prof_cls  varchar2(60) := get_cell(l_cols, l_map, 'PROFILE_CLASS', 'TGT_PROFILE_CLASS_NAME');
                  l_coll      varchar2(100):= get_cell(l_cols, l_map, 'COLLECTOR', 'TGT_COLLECTOR_NAME');
                  l_pay_term  varchar2(60) := get_cell(l_cols, l_map, 'PAYMENT_TERM', 'TGT_PAYMENT_TERM_NAME');
                  l_curr      varchar2(15) := get_cell(l_cols, l_map, 'CREDIT_CURRENCY', 'TGT_CREDIT_CURRENCY');
                  l_cred_lim  number       := to_number(replace(get_cell(l_cols, l_map, 'OVERALL_CREDIT_LIMIT', 'TGT_OVERALL_CREDIT_LIMIT'), ',', '') default null on conversion error);
                  l_trx_lim   number       := to_number(replace(get_cell(l_cols, l_map, 'ORDER_CREDIT_LIMIT', 'TGT_TRX_CREDIT_LIMIT'), ',', '') default null on conversion error);
                  l_notes     varchar2(1000):= get_cell(l_cols, l_map, 'USER_NOTES', 'NOTES');
                begin
                  if l_id is not null or l_acct_no is not null then
                    l_rows_parsed := l_rows_parsed + 1;
                    for r_cur in (
                      select * from xxcr_stg_customers
                       where project_id = p_project_id
                         and (stg_cust_id = l_id or (l_id is null and tgt_account_number = l_acct_no))
                       fetch first 1 row only
                    ) loop
                      log_delta(l_import_id, p_project_id, r_sheet.sheet_display_name, 'CUSTOMER', r_cur.stg_cust_id, r_cur.tgt_account_number, 'INCLUDE_YN', r_cur.include_yn, nvl(l_inc, r_cur.include_yn));
                      log_delta(l_import_id, p_project_id, r_sheet.sheet_display_name, 'CUSTOMER', r_cur.stg_cust_id, r_cur.tgt_account_number, 'TGT_PARTY_NAME', r_cur.tgt_party_name, nvl(l_party_nm, r_cur.tgt_party_name));
                      log_delta(l_import_id, p_project_id, r_sheet.sheet_display_name, 'CUSTOMER', r_cur.stg_cust_id, r_cur.tgt_account_number, 'TGT_ACCOUNT_NAME', r_cur.tgt_account_name, l_acct_nm);
                      log_delta(l_import_id, p_project_id, r_sheet.sheet_display_name, 'CUSTOMER', r_cur.stg_cust_id, r_cur.tgt_account_number, 'TGT_PAYMENT_TERM_NAME', r_cur.tgt_payment_term_name, l_pay_term);
                      log_delta(l_import_id, p_project_id, r_sheet.sheet_display_name, 'CUSTOMER', r_cur.stg_cust_id, r_cur.tgt_account_number, 'TGT_CREDIT_CURRENCY', r_cur.tgt_credit_currency, nvl(l_curr, r_cur.tgt_credit_currency));
                      log_delta(l_import_id, p_project_id, r_sheet.sheet_display_name, 'CUSTOMER', r_cur.stg_cust_id, r_cur.tgt_account_number, 'TGT_OVERALL_CREDIT_LIMIT', to_char(r_cur.tgt_overall_credit_limit), to_char(l_cred_lim));
                      log_delta(l_import_id, p_project_id, r_sheet.sheet_display_name, 'CUSTOMER', r_cur.stg_cust_id, r_cur.tgt_account_number, 'TGT_TRX_CREDIT_LIMIT', to_char(r_cur.tgt_trx_credit_limit), to_char(nvl(l_trx_lim, r_cur.tgt_trx_credit_limit)));

                      update xxcr_stg_customers
                         set include_yn               = nvl(l_inc, include_yn),
                             action_code              = case
                                                          when nvl(l_inc, include_yn) = 'N' then 'SKIP'
                                                          when nvl(l_inc, include_yn) = 'Y' and action_code = 'SKIP' then 'EXTEND_OU'
                                                          else nvl(l_act, action_code)
                                                        end,
                             tgt_account_number       = nvl(l_acct_no, tgt_account_number),
                             tgt_party_name           = nvl(l_party_nm, tgt_party_name),
                             tgt_account_name         = l_acct_nm,
                             tgt_tax_reference        = l_tax_ref,
                             tgt_customer_class_code  = l_cust_cls,
                             tgt_profile_class_name   = nvl(l_prof_cls, tgt_profile_class_name),
                             tgt_collector_name       = nvl(l_coll, tgt_collector_name),
                             tgt_payment_term_name    = l_pay_term,
                             tgt_credit_currency      = nvl(l_curr, tgt_credit_currency),
                             tgt_overall_credit_limit = l_cred_lim,
                             tgt_trx_credit_limit     = nvl(l_trx_lim, tgt_trx_credit_limit),
                             user_notes               = nvl(l_notes, user_notes),
                             updated_at               = systimestamp
                       where stg_cust_id = r_cur.stg_cust_id;
                    end loop;
                  end if;
                end;

              elsif l_mode = 'SITES' then
                declare
                  l_id       number        := to_number(get_cell(l_cols, l_map, 'STG_SITE_ID') default null on conversion error);
                  l_own_inc  varchar2(1)   := parse_yn(get_cell(l_cols, l_map, 'SITE_INCLUDE_Y_N', 'INCLUDE', 'INCLUDE_YN'), null);
                  l_ref      varchar2(60)  := get_cell(l_cols, l_map, 'SITE_REF_CODE');
                  l_ctry     varchar2(60)  := get_cell(l_cols, l_map, 'COUNTRY', 'TGT_COUNTRY');
                  l_addr1    varchar2(240) := get_cell(l_cols, l_map, 'ADDRESS_1', 'TGT_ADDRESS1');
                  l_addr2    varchar2(240) := get_cell(l_cols, l_map, 'ADDRESS_2', 'TGT_ADDRESS2');
                  l_city     varchar2(60)  := get_cell(l_cols, l_map, 'CITY', 'TGT_CITY');
                  l_state    varchar2(60)  := get_cell(l_cols, l_map, 'STATE', 'TGT_STATE');
                  l_postal   varchar2(60)  := get_cell(l_cols, l_map, 'POSTAL_CODE', 'TGT_POSTAL_CODE');
                  l_cat      varchar2(30)  := get_cell(l_cols, l_map, 'CUSTOMER_CATEGORY', 'TGT_CUSTOMER_CATEGORY');
                  l_scurr    varchar2(15)  := get_cell(l_cols, l_map, 'SALES_CURRENCY_DFF', 'TGT_SALES_CURRENCY');
                  l_rps      varchar2(30)  := get_cell(l_cols, l_map, 'DENIED_PARTY_HOLD_DFF', 'TGT_RPS_HOLD_FLAG');
                  l_3rd_nm   varchar2(150) := get_cell(l_cols, l_map, '3RD_PARTY_CUST_NAME_DFF', 'TGT_THIRD_PARTY_NAME');
                  l_notes    varchar2(1000):= get_cell(l_cols, l_map, 'USER_NOTES', 'NOTES');
                begin
                  if l_id is not null or l_ref is not null then
                    l_rows_parsed := l_rows_parsed + 1;
                    for r_cur in (
                      select * from xxcr_stg_sites
                       where project_id = p_project_id
                         and (stg_site_id = l_id or (l_id is null and site_ref_code = l_ref))
                       fetch first 1 row only
                    ) loop
                      log_delta(l_import_id, p_project_id, r_sheet.sheet_display_name, 'SITE', r_cur.stg_site_id, r_cur.site_ref_code, 'INCLUDE_YN', r_cur.include_yn, nvl(l_own_inc, r_cur.include_yn));
                      log_delta(l_import_id, p_project_id, r_sheet.sheet_display_name, 'SITE', r_cur.stg_site_id, r_cur.site_ref_code, 'TGT_ADDRESS1', r_cur.tgt_address1, nvl(l_addr1, r_cur.tgt_address1));
                      log_delta(l_import_id, p_project_id, r_sheet.sheet_display_name, 'SITE', r_cur.stg_site_id, r_cur.site_ref_code, 'TGT_CITY', r_cur.tgt_city, l_city);
                      log_delta(l_import_id, p_project_id, r_sheet.sheet_display_name, 'SITE', r_cur.stg_site_id, r_cur.site_ref_code, 'TGT_STATE', r_cur.tgt_state, l_state);
                      log_delta(l_import_id, p_project_id, r_sheet.sheet_display_name, 'SITE', r_cur.stg_site_id, r_cur.site_ref_code, 'TGT_POSTAL_CODE', r_cur.tgt_postal_code, l_postal);

                      update xxcr_stg_sites
                         set include_yn            = nvl(l_own_inc, include_yn),
                             tgt_country           = nvl(l_ctry, tgt_country),
                             tgt_address1          = nvl(l_addr1, tgt_address1),
                             tgt_address2          = l_addr2,
                             tgt_city              = l_city,
                             tgt_state             = l_state,
                             tgt_postal_code       = l_postal,
                             tgt_customer_category = l_cat,
                             tgt_sales_currency    = nvl(l_scurr, tgt_sales_currency),
                             tgt_rps_hold_flag     = nvl(l_rps, tgt_rps_hold_flag),
                             tgt_third_party_name  = nvl(l_3rd_nm, tgt_third_party_name),
                             user_notes            = case
                                                       when l_own_inc = 'N' then trim(replace(nvl(l_notes, user_notes), '[AUTO-EXCLUDED: Account]', ''))
                                                       else nvl(l_notes, user_notes)
                                                     end,
                             updated_at            = systimestamp
                       where stg_site_id = r_cur.stg_site_id;
                    end loop;
                  end if;
                end;

              elsif l_mode = 'SITE_USES' then
                declare
                  l_id        number        := to_number(get_cell(l_cols, l_map, 'STG_SITE_USE_ID') default null on conversion error);
                  l_own_inc   varchar2(1)   := parse_yn(get_cell(l_cols, l_map, 'SITE_USE_INCLUDE_Y_N', 'INCLUDE', 'INCLUDE_YN'), null);
                  l_prim      varchar2(1)   := parse_yn(get_cell(l_cols, l_map, 'PRIMARY', 'TGT_PRIMARY_FLAG'), null);
                  l_bt_loc    varchar2(40)  := get_cell(l_cols, l_map, 'BILL_TO_LOCATION', 'TGT_BILL_TO_LOCATION_CODE');
                  l_prof_cls  varchar2(60)  := get_cell(l_cols, l_map, 'PROFILE_CLASS', 'TGT_PROFILE_CLASS_NAME');
                  l_coll      varchar2(100) := get_cell(l_cols, l_map, 'COLLECTOR', 'TGT_COLLECTOR_NAME');
                  l_pay_term  varchar2(60)  := get_cell(l_cols, l_map, 'PAYMENT_TERM', 'TGT_PAYMENT_TERM_NAME');
                  l_curr      varchar2(15)  := get_cell(l_cols, l_map, 'CREDIT_CURRENCY', 'TGT_CREDIT_CURRENCY');
                  l_cred_lim  number        := to_number(replace(get_cell(l_cols, l_map, 'OVERALL_CREDIT_LIMIT', 'TGT_OVERALL_CREDIT_LIMIT'), ',', '') default null on conversion error);
                  l_trx_lim   number        := to_number(replace(get_cell(l_cols, l_map, 'ORDER_CREDIT_LIMIT', 'TGT_TRX_CREDIT_LIMIT'), ',', '') default null on conversion error);
                  l_srep      varchar2(240) := get_cell(l_cols, l_map, 'SALESPERSON', 'TGT_SALESREP_NAME');
                  l_ord_type  varchar2(100) := get_cell(l_cols, l_map, 'ORDER_TYPE', 'TGT_ORDER_TYPE_NAME');
                  l_plist     varchar2(240) := get_cell(l_cols, l_map, 'PRICE_LIST', 'TGT_PRICE_LIST_NAME');
                  l_whse      varchar2(10)  := get_cell(l_cols, l_map, 'WAREHOUSE', 'TGT_WAREHOUSE_CODE');
                  l_tax       varchar2(50)  := get_cell(l_cols, l_map, 'TAX_CODE', 'TGT_TAX_CODE');
                  l_tax_ref   varchar2(60)  := get_cell(l_cols, l_map, 'SITE_TAX_REF_ABN', 'TGT_TAX_REFERENCE');
                  l_genie_rep varchar2(150) := get_cell(l_cols, l_map, 'AWP_GENIE_REP_DFF', 'TGT_AWP_GENIE_REP');
                  l_ship_via  varchar2(30)  := get_cell(l_cols, l_map, 'SHIP_VIA_CARRIER', 'TGT_SHIP_VIA');
                  l_snd_stmt  varchar2(1)   := parse_yn(get_cell(l_cols, l_map, 'SEND_STMTS', 'TGT_SEND_STATEMENTS'), null);
                  l_stmt_cyc  varchar2(60)  := get_cell(l_cols, l_map, 'STMT_CYCLE', 'TGT_STATEMENT_CYCLE_NAME');
                  l_disc_trm  varchar2(1)   := parse_yn(get_cell(l_cols, l_map, 'DISCOUNT_TERMS', 'TGT_DISCOUNT_TERMS'), null);
                  l_acash     varchar2(60)  := get_cell(l_cols, l_map, 'AUTOCASH_RULE', 'TGT_AUTOCASH_RULE_NAME');
                  l_grule     varchar2(60)  := get_cell(l_cols, l_map, 'GROUPING_RULE', 'TGT_GROUPING_RULE_NAME');
                  l_gl_rec    varchar2(240) := get_cell(l_cols, l_map, 'RECEIVABLE_GL_ACCOUNT', 'TGT_GL_REC_CONCAT');
                  l_gl_rev    varchar2(240) := get_cell(l_cols, l_map, 'REVENUE_GL_ACCOUNT', 'TGT_GL_REV_CONCAT');
                  l_gl_tax    varchar2(240) := get_cell(l_cols, l_map, 'TAX_GL_ACCOUNT', 'TGT_GL_TAX_CONCAT');
                  l_notes     varchar2(1000):= get_cell(l_cols, l_map, 'USER_NOTES', 'NOTES');
                begin
                  if l_id is not null then
                    l_rows_parsed := l_rows_parsed + 1;
                    for r_cur in (
                      select * from xxcr_stg_site_uses
                       where project_id = p_project_id
                         and stg_site_use_id = l_id
                    ) loop
                      log_delta(l_import_id, p_project_id, r_sheet.sheet_display_name, 'SITE_USE', r_cur.stg_site_use_id, r_cur.site_ref_code || ':' || r_cur.tgt_site_use_code, 'INCLUDE_YN', r_cur.include_yn, nvl(l_own_inc, r_cur.include_yn));
                      log_delta(l_import_id, p_project_id, r_sheet.sheet_display_name, 'SITE_USE', r_cur.stg_site_use_id, r_cur.site_ref_code || ':' || r_cur.tgt_site_use_code, 'TGT_PAYMENT_TERM_NAME', r_cur.tgt_payment_term_name, l_pay_term);
                      log_delta(l_import_id, p_project_id, r_sheet.sheet_display_name, 'SITE_USE', r_cur.stg_site_use_id, r_cur.site_ref_code || ':' || r_cur.tgt_site_use_code, 'TGT_OVERALL_CREDIT_LIMIT', to_char(r_cur.tgt_overall_credit_limit), to_char(l_cred_lim));
                      log_delta(l_import_id, p_project_id, r_sheet.sheet_display_name, 'SITE_USE', r_cur.stg_site_use_id, r_cur.site_ref_code || ':' || r_cur.tgt_site_use_code, 'TGT_TRX_CREDIT_LIMIT', to_char(r_cur.tgt_trx_credit_limit), to_char(l_trx_lim));
                      log_delta(l_import_id, p_project_id, r_sheet.sheet_display_name, 'SITE_USE', r_cur.stg_site_use_id, r_cur.site_ref_code || ':' || r_cur.tgt_site_use_code, 'TGT_WAREHOUSE_CODE', r_cur.tgt_warehouse_code, l_whse);
                      log_delta(l_import_id, p_project_id, r_sheet.sheet_display_name, 'SITE_USE', r_cur.stg_site_use_id, r_cur.site_ref_code || ':' || r_cur.tgt_site_use_code, 'TGT_GL_REC_CONCAT', r_cur.tgt_gl_rec_concat, l_gl_rec);
                      log_delta(l_import_id, p_project_id, r_sheet.sheet_display_name, 'SITE_USE', r_cur.stg_site_use_id, r_cur.site_ref_code || ':' || r_cur.tgt_site_use_code, 'TGT_GL_REV_CONCAT', r_cur.tgt_gl_rev_concat, l_gl_rev);

                      update xxcr_stg_site_uses
                         set include_yn                = nvl(l_own_inc, include_yn),
                             tgt_primary_flag          = nvl(l_prim, tgt_primary_flag),
                             tgt_bill_to_location_code = l_bt_loc,
                             tgt_profile_class_name    = nvl(l_prof_cls, tgt_profile_class_name),
                             tgt_collector_name        = nvl(l_coll, tgt_collector_name),
                             tgt_payment_term_name     = l_pay_term,
                             tgt_credit_currency       = nvl(l_curr, tgt_credit_currency),
                             tgt_overall_credit_limit  = l_cred_lim,
                             tgt_trx_credit_limit      = l_trx_lim,
                             tgt_salesrep_name         = l_srep,
                             tgt_order_type_name       = l_ord_type,
                             tgt_price_list_name       = l_plist,
                             tgt_warehouse_code        = l_whse,
                             tgt_tax_code              = l_tax,
                             tgt_tax_reference         = nvl(l_tax_ref, tgt_tax_reference),
                             tgt_awp_genie_rep         = nvl(l_genie_rep, tgt_awp_genie_rep),
                             tgt_ship_via              = nvl(l_ship_via, tgt_ship_via),
                             tgt_send_statements       = nvl(l_snd_stmt, tgt_send_statements),
                             tgt_statement_cycle_name  = nvl(l_stmt_cyc, tgt_statement_cycle_name),
                             tgt_discount_terms        = nvl(l_disc_trm, tgt_discount_terms),
                             tgt_autocash_rule_name    = nvl(l_acash, tgt_autocash_rule_name),
                             tgt_grouping_rule_name    = nvl(l_grule, tgt_grouping_rule_name),
                             tgt_gl_rec_concat         = l_gl_rec,
                             tgt_gl_rev_concat         = l_gl_rev,
                             tgt_gl_tax_concat         = nvl(l_gl_tax, tgt_gl_tax_concat),
                             user_notes                = case
                                                           when l_own_inc = 'N' then trim(replace(replace(nvl(l_notes, user_notes), '[AUTO-EXCLUDED: Account]', ''), '[AUTO-EXCLUDED: Site]', ''))
                                                           else nvl(l_notes, user_notes)
                                                         end,
                             updated_at                = systimestamp
                       where stg_site_use_id = r_cur.stg_site_use_id;
                    end loop;
                  end if;
                end;

              elsif l_mode = 'CONTACTS' then
                declare
                  l_id        number        := to_number(get_cell(l_cols, l_map, 'STG_CONTACT_ID') default null on conversion error);
                  l_own_inc   varchar2(1)   := parse_yn(get_cell(l_cols, l_map, 'CONTACT_INCLUDE_Y_N', 'INCLUDE', 'INCLUDE_YN'), null);
                  l_fname     varchar2(150) := get_cell(l_cols, l_map, 'FIRST_NAME', 'TGT_FIRST_NAME');
                  l_lname     varchar2(150) := get_cell(l_cols, l_map, 'LAST_NAME', 'TGT_LAST_NAME');
                  l_title     varchar2(100) := get_cell(l_cols, l_map, 'JOB_TITLE', 'TGT_JOB_TITLE');
                  l_dept      varchar2(60)  := substr(get_cell(l_cols, l_map, 'DEPARTMENT', 'TGT_DEPARTMENT'), 1, 60);
                  l_prim      varchar2(1)   := parse_yn(get_cell(l_cols, l_map, 'ROLE_PRIMARY', 'TGT_PRIMARY_FLAG'), null);
                  l_email     varchar2(320) := get_cell(l_cols, l_map, 'EMAIL_ADDRESS', 'TGT_EMAIL_ADDRESS');
                  l_ctry_cd   varchar2(10)  := get_cell(l_cols, l_map, 'COUNTRY_CODE', 'TGT_PHONE_COUNTRY_CODE');
                  l_area_cd   varchar2(10)  := get_cell(l_cols, l_map, 'AREA_CODE', 'TGT_PHONE_AREA_CODE');
                  l_phone     varchar2(40)  := get_cell(l_cols, l_map, 'PHONE_NUMBER', 'TGT_PHONE_NUMBER');
                  l_mobile    varchar2(60)  := get_cell(l_cols, l_map, 'MOBILE_NUMBER', 'TGT_MOBILE_NUMBER');
                  l_fax       varchar2(60)  := get_cell(l_cols, l_map, 'FAX_NUMBER', 'TGT_FAX_NUMBER');
                  l_notes     varchar2(1000):= get_cell(l_cols, l_map, 'USER_NOTES', 'NOTES');
                begin
                  if l_id is not null then
                    l_rows_parsed := l_rows_parsed + 1;
                    for r_cur in (
                      select * from xxcr_stg_contacts
                       where project_id = p_project_id
                         and stg_contact_id = l_id
                    ) loop
                      log_delta(l_import_id, p_project_id, r_sheet.sheet_display_name, 'CONTACT', r_cur.stg_contact_id, r_cur.contact_ref_code, 'INCLUDE_YN', r_cur.include_yn, nvl(l_own_inc, r_cur.include_yn));
                      log_delta(l_import_id, p_project_id, r_sheet.sheet_display_name, 'CONTACT', r_cur.stg_contact_id, r_cur.contact_ref_code, 'TGT_EMAIL_ADDRESS', r_cur.tgt_email_address, l_email);
                      log_delta(l_import_id, p_project_id, r_sheet.sheet_display_name, 'CONTACT', r_cur.stg_contact_id, r_cur.contact_ref_code, 'TGT_PHONE_NUMBER', r_cur.tgt_phone_number, l_phone);

                      update xxcr_stg_contacts
                         set include_yn             = nvl(l_own_inc, include_yn),
                             tgt_first_name         = l_fname,
                             tgt_last_name          = nvl(l_lname, tgt_last_name),
                             tgt_job_title          = l_title,
                             tgt_department         = l_dept,
                             tgt_primary_flag       = nvl(l_prim, tgt_primary_flag),
                             tgt_email_address      = l_email,
                             tgt_phone_country_code = l_ctry_cd,
                             tgt_phone_area_code    = l_area_cd,
                             tgt_phone_number       = l_phone,
                             tgt_mobile_number      = nvl(l_mobile, tgt_mobile_number),
                             tgt_fax_number         = nvl(l_fax, tgt_fax_number),
                             user_notes             = case
                                                        when l_own_inc = 'N' then trim(replace(replace(nvl(l_notes, user_notes), '[AUTO-EXCLUDED: Account]', ''), '[AUTO-EXCLUDED: Site]', ''))
                                                        else nvl(l_notes, user_notes)
                                                      end,
                             updated_at             = systimestamp
                       where stg_contact_id = r_cur.stg_contact_id;
                    end loop;
                  end if;
                end;

              elsif l_mode = 'MULTI_CURR' then
                declare
                  l_id       number       := to_number(get_cell(l_cols, l_map, 'STG_PROF_AMT_ID') default null on conversion error);
                  l_inc      varchar2(1)  := parse_yn(get_cell(l_cols, l_map, 'INCLUDE_Y_N', 'INCLUDE', 'INCLUDE_YN'), null);
                  l_curr     varchar2(15) := get_cell(l_cols, l_map, 'TARGET_CURRENCY', 'TGT_CURRENCY_CODE');
                  l_ovr      number       := to_number(replace(get_cell(l_cols, l_map, 'TARGET_OVERALL_LIMIT', 'TGT_OVERALL_CREDIT_LIMIT'), ',', '') default null on conversion error);
                  l_trx      number       := to_number(replace(get_cell(l_cols, l_map, 'TARGET_ORDER_LIMIT', 'TGT_TRX_CREDIT_LIMIT'), ',', '') default null on conversion error);
                  l_notes    varchar2(1000):= get_cell(l_cols, l_map, 'USER_NOTES', 'NOTES');
                begin
                  if l_id is not null then
                    l_rows_parsed := l_rows_parsed + 1;
                    update xxcr_stg_profile_amts
                       set include_yn               = nvl(l_inc, include_yn),
                           tgt_currency_code        = nvl(l_curr, tgt_currency_code),
                           tgt_overall_credit_limit = l_ovr,
                           tgt_trx_credit_limit     = l_trx,
                           user_notes               = nvl(l_notes, user_notes)
                     where project_id = p_project_id
                       and stg_prof_amt_id = l_id;
                  end if;
                end;

              elsif l_mode = 'ACCT_RELATES' then
                declare
                  l_id       number       := to_number(get_cell(l_cols, l_map, 'STG_RELATE_ID') default null on conversion error);
                  l_inc      varchar2(1)  := parse_yn(get_cell(l_cols, l_map, 'INCLUDE_Y_N', 'INCLUDE', 'INCLUDE_YN'), null);
                  l_bt       varchar2(1)  := parse_yn(get_cell(l_cols, l_map, 'BILL_TO_ALLOWED', 'TGT_BILL_TO_FLAG'), null);
                  l_st       varchar2(1)  := parse_yn(get_cell(l_cols, l_map, 'SHIP_TO_ALLOWED', 'TGT_SHIP_TO_FLAG'), null);
                  l_rc       varchar2(1)  := parse_yn(get_cell(l_cols, l_map, 'RECIPROCAL_FLAG', 'TGT_RECIPROCAL_FLAG'), null);
                  l_notes    varchar2(1000):= get_cell(l_cols, l_map, 'USER_NOTES', 'NOTES');
                begin
                  if l_id is not null then
                    l_rows_parsed := l_rows_parsed + 1;
                    update xxcr_stg_acct_relates
                       set include_yn          = nvl(l_inc, include_yn),
                           tgt_bill_to_flag    = nvl(l_bt, tgt_bill_to_flag),
                           tgt_ship_to_flag    = nvl(l_st, tgt_ship_to_flag),
                           tgt_reciprocal_flag = nvl(l_rc, tgt_reciprocal_flag),
                           user_notes          = nvl(l_notes, user_notes)
                     where project_id = p_project_id
                       and stg_relate_id = l_id;
                  end if;
                end;

              elsif l_mode = 'PAYMENT_INSTR' then
                declare
                  l_id       number        := to_number(get_cell(l_cols, l_map, 'STG_PMT_ID') default null on conversion error);
                  l_inc      varchar2(1)   := parse_yn(get_cell(l_cols, l_map, 'INCLUDE_Y_N', 'INCLUDE', 'INCLUDE_YN'), null);
                  l_prim     varchar2(1)   := parse_yn(get_cell(l_cols, l_map, 'PRIMARY_FLAG', 'TGT_PRIMARY_FLAG'), null);
                  l_pref     number        := to_number(get_cell(l_cols, l_map, 'PREFERENCE_ORDER', 'TGT_ORDER_OF_PREF') default null on conversion error);
                  l_rmeth    varchar2(100) := get_cell(l_cols, l_map, 'TARGET_RECEIPT_METHOD', 'TGT_RECEIPT_METHOD_NAME');
                  l_notes    varchar2(1000):= get_cell(l_cols, l_map, 'USER_NOTES', 'NOTES');
                begin
                  if l_id is not null then
                    l_rows_parsed := l_rows_parsed + 1;
                    update xxcr_stg_payment_instr
                       set include_yn              = nvl(l_inc, include_yn),
                           tgt_primary_flag        = nvl(l_prim, tgt_primary_flag),
                           tgt_order_of_pref       = nvl(l_pref, tgt_order_of_pref),
                           tgt_receipt_method_name = nvl(l_rmeth, tgt_receipt_method_name),
                           user_notes              = nvl(l_notes, user_notes)
                     where project_id = p_project_id
                       and stg_pmt_id = l_id;
                  end if;
                end;
              end if;
            end;
          end loop;
        end if;
      end;
    end loop;

    -- Cascade Account & Site Exclusions across all child worksheets & log cascaded deltas
    cascade_exclusions(p_project_id => p_project_id, p_import_id => l_import_id);

    select count(*) into l_cells_mod from xxcr_xls_deltas where import_id = l_import_id;

    update xxcr_xls_imports
       set rows_parsed    = l_rows_parsed,
           cells_modified = l_cells_mod,
           new_rows_added = l_new_rows,
           status         = 'APPLIED'
     where import_id = l_import_id;

    sync_deltas(p_project_id);
    find_duplicates(p_project_id);
    validate_project(p_project_id);

    update xxcr_projects
       set last_xls_import_at = systimestamp,
           updated_at         = systimestamp
     where project_id = p_project_id;
  end process_excel_upload;

end xxcr_rollout_pkg;
/
