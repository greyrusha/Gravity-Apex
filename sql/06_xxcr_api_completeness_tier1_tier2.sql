-- =============================================================================
-- 06_xxcr_api_completeness_tier1_tier2.sql
-- Tier 1 & Tier 2 Oracle EBS R12.2 Customer Public API Completeness Expansion
--   Tier 1:
--     1. Site-Use Custom DFFs (RA_SITE_USES_HZ: AWP - GENIE, AWP - UTILITIES,
--        EU VAT Validation, Legacy Customer No., Repository ID)
--     2. Account-Site Custom DFFs (RA_ADDRESSES_HZ: Sales Currency, Denied Party
--        Hold / TREX_RP_SCREENING, 3rd Party Customer Name, Pricing Customer Cat,
--        Vertex Geocode, UPS/FedEx Account #, Freight Payment Term)
--     3. Site-Use Tax Registration / ABN (HZ_CUST_SITE_USES_ALL.TAX_REFERENCE)
--     4. Multi-Currency Credit Limits (HZ_CUST_PROFILE_AMTS -> XXCR_STG_PROFILE_AMTS)
--     5. OU-Striped Customer Account Relationships (HZ_CUST_ACCT_RELATE_ALL ->
--        XXCR_STG_ACCT_RELATES)
--   Tier 2:
--     6. Bill-To Profile Statement, Discount, Override, Dunning, AutoCash &
--        Grouping Rule Controls (HZ_CUSTOMER_PROFILES)
--     7. OU-Striped Payment Instruments & Receipt Methods (IBY_EXTERNAL_PAYERS_ALL,
--        IBY_PMT_INSTR_USES_ALL, RA_CUST_RECEIPT_METHODS -> XXCR_STG_PAYMENT_INSTR)
--     8. Contact Mobile & Fax Numbers (HZ_CONTACT_POINTS: MOBILE, FAX)
--     9. Secondary Site-Use Types (DELIVER_TO, SOLD_TO, INV, ACK) & SHIP_VIA / GSA
-- Target Schema: GL_ACCOUNTS on APEXQ_AWS (Oracle AI Database 26ai)
-- =============================================================================

declare
  procedure add_col(p_tbl varchar2, p_col varchar2, p_def varchar2) is
    l_cnt number;
  begin
    select count(*)
      into l_cnt
      from user_tab_columns
     where table_name = upper(p_tbl)
       and column_name = upper(p_col);
    if l_cnt = 0 then
      execute immediate 'alter table ' || p_tbl || ' add (' || p_col || ' ' || p_def || ')';
    end if;
  end;
begin
  -- 1. XXCR_STG_SITES: Tier 1 Item 2 — Account-Site Custom DFFs (RA_ADDRESSES_HZ)
  add_col('xxcr_stg_sites', 'src_dff_context',       'varchar2(30)');
  add_col('xxcr_stg_sites', 'src_sales_currency',    'varchar2(15)');  -- ATTRIBUTE20 (TEREX_SALES_CURRENCY)
  add_col('xxcr_stg_sites', 'src_rps_hold_flag',     'varchar2(30)');  -- ATTRIBUTE11 (TREX_RP_SCREENING)
  add_col('xxcr_stg_sites', 'src_third_party_name',  'varchar2(150)'); -- ATTRIBUTE12 (TREX_3RD_PARTY_CUST_NAME)
  add_col('xxcr_stg_sites', 'src_pricing_cust_cat',  'varchar2(150)'); -- ATTRIBUTE1  (Pricing Customer Category)
  add_col('xxcr_stg_sites', 'src_vertex_geocode',    'varchar2(150)'); -- ATTRIBUTE7  (Vertex Geocode)
  add_col('xxcr_stg_sites', 'src_ups_acct_num',      'varchar2(150)'); -- ATTRIBUTE8  (UPS Account Number)
  add_col('xxcr_stg_sites', 'src_fedex_acct_num',    'varchar2(150)'); -- ATTRIBUTE9  (FEDEX Account Number)
  add_col('xxcr_stg_sites', 'src_frt_pay_term',      'varchar2(150)'); -- ATTRIBUTE10 (Freight Payment Term)

  add_col('xxcr_stg_sites', 'tgt_dff_context',       'varchar2(30)');
  add_col('xxcr_stg_sites', 'tgt_sales_currency',    'varchar2(15)');
  add_col('xxcr_stg_sites', 'tgt_rps_hold_flag',     'varchar2(30)');
  add_col('xxcr_stg_sites', 'tgt_third_party_name',  'varchar2(150)');
  add_col('xxcr_stg_sites', 'tgt_pricing_cust_cat',  'varchar2(150)');
  add_col('xxcr_stg_sites', 'tgt_vertex_geocode',    'varchar2(150)');
  add_col('xxcr_stg_sites', 'tgt_ups_acct_num',      'varchar2(150)');
  add_col('xxcr_stg_sites', 'tgt_fedex_acct_num',    'varchar2(150)');
  add_col('xxcr_stg_sites', 'tgt_frt_pay_term',      'varchar2(150)');

  -- 2. XXCR_STG_SITE_USES: Tier 1 Items 1 & 3 + Tier 2 Items 6 & 9
  add_col('xxcr_stg_site_uses', 'src_tax_reference',        'varchar2(60)');  -- HZ_CUST_SITE_USES_ALL.TAX_REFERENCE (ABN/GST)
  add_col('xxcr_stg_site_uses', 'tgt_tax_reference',        'varchar2(60)');
  add_col('xxcr_stg_site_uses', 'src_dff_context',          'varchar2(30)');
  add_col('xxcr_stg_site_uses', 'tgt_dff_context',          'varchar2(30)');
  add_col('xxcr_stg_site_uses', 'src_awp_genie_rep',        'varchar2(150)'); -- ATTRIBUTE10 (AWP - GENIE)
  add_col('xxcr_stg_site_uses', 'tgt_awp_genie_rep',        'varchar2(150)');
  add_col('xxcr_stg_site_uses', 'src_awp_util_rep',         'varchar2(150)'); -- ATTRIBUTE11 (AWP - UTILITIES)
  add_col('xxcr_stg_site_uses', 'tgt_awp_util_rep',         'varchar2(150)');
  add_col('xxcr_stg_site_uses', 'src_eu_vat_val',           'varchar2(150)'); -- ATTRIBUTE2  (EU VAT Validation)
  add_col('xxcr_stg_site_uses', 'tgt_eu_vat_val',           'varchar2(150)');
  add_col('xxcr_stg_site_uses', 'src_legacy_cust_num',      'varchar2(150)'); -- ATTRIBUTE19 (Legacy Customer No.)
  add_col('xxcr_stg_site_uses', 'tgt_legacy_cust_num',      'varchar2(150)');
  add_col('xxcr_stg_site_uses', 'src_repository_id',        'varchar2(150)'); -- ATTRIBUTE20 (REPOSITORY ID)
  add_col('xxcr_stg_site_uses', 'tgt_repository_id',        'varchar2(150)');

  -- Tier 2 Item 9: SHIP_VIA & GSA_INDICATOR
  add_col('xxcr_stg_site_uses', 'src_ship_via',             'varchar2(30)');
  add_col('xxcr_stg_site_uses', 'tgt_ship_via',             'varchar2(30)');
  add_col('xxcr_stg_site_uses', 'src_gsa_indicator',        'varchar2(1)');
  add_col('xxcr_stg_site_uses', 'tgt_gsa_indicator',        'varchar2(1)');

  -- Tier 2 Item 6: Bill-To Profile Operational Controls (HZ_CUSTOMER_PROFILES)
  add_col('xxcr_stg_site_uses', 'src_send_statements',      'varchar2(1)');
  add_col('xxcr_stg_site_uses', 'tgt_send_statements',      'varchar2(1)');
  add_col('xxcr_stg_site_uses', 'src_statement_cycle_name', 'varchar2(60)');
  add_col('xxcr_stg_site_uses', 'tgt_statement_cycle_name', 'varchar2(60)');
  add_col('xxcr_stg_site_uses', 'src_discount_terms',       'varchar2(1)');
  add_col('xxcr_stg_site_uses', 'tgt_discount_terms',       'varchar2(1)');
  add_col('xxcr_stg_site_uses', 'src_override_terms',       'varchar2(1)');
  add_col('xxcr_stg_site_uses', 'tgt_override_terms',       'varchar2(1)');
  add_col('xxcr_stg_site_uses', 'src_dunning_letters',      'varchar2(1)');
  add_col('xxcr_stg_site_uses', 'tgt_dunning_letters',      'varchar2(1)');
  add_col('xxcr_stg_site_uses', 'src_dunning_letter_set',   'varchar2(60)');
  add_col('xxcr_stg_site_uses', 'tgt_dunning_letter_set',   'varchar2(60)');
  add_col('xxcr_stg_site_uses', 'src_autocash_rule_name',   'varchar2(60)');
  add_col('xxcr_stg_site_uses', 'tgt_autocash_rule_name',   'varchar2(60)');
  add_col('xxcr_stg_site_uses', 'src_grouping_rule_name',   'varchar2(60)');
  add_col('xxcr_stg_site_uses', 'tgt_grouping_rule_name',   'varchar2(60)');
  add_col('xxcr_stg_site_uses', 'src_credit_rating',        'varchar2(30)');
  add_col('xxcr_stg_site_uses', 'tgt_credit_rating',        'varchar2(30)');
  add_col('xxcr_stg_site_uses', 'src_risk_code',            'varchar2(30)');
  add_col('xxcr_stg_site_uses', 'tgt_risk_code',            'varchar2(30)');
  add_col('xxcr_stg_site_uses', 'src_tolerance',            'number');
  add_col('xxcr_stg_site_uses', 'tgt_tolerance',            'number');
  add_col('xxcr_stg_site_uses', 'multi_curr_summary',       'varchar2(240)');

  -- 3. XXCR_STG_CONTACTS: Tier 2 Item 8 — Mobile & Fax Contact Points
  add_col('xxcr_stg_contacts', 'src_mobile_number',         'varchar2(60)');
  add_col('xxcr_stg_contacts', 'tgt_mobile_number',         'varchar2(60)');
  add_col('xxcr_stg_contacts', 'src_fax_number',            'varchar2(60)');
  add_col('xxcr_stg_contacts', 'tgt_fax_number',            'varchar2(60)');
end;
/

-- 4. Child Staging Table: Multi-Currency Credit Profile Amounts (Tier 1 Item 4)
--    Maps 1:1 to HZ_CUSTOMER_PROFILE_V2PUB.create_cust_profile_amt (cust_profile_amt_rec_type)
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_tables where table_name = 'XXCR_STG_PROFILE_AMTS';
  if l_cnt = 0 then
    execute immediate q'[
      create table xxcr_stg_profile_amts (
        stg_prof_amt_id           number generated by default on null as identity primary key,
        project_id                number        not null references xxcr_projects(project_id) on delete cascade,
        stg_cust_id               number        not null references xxcr_stg_customers(stg_cust_id) on delete cascade,
        stg_site_use_id           number        references xxcr_stg_site_uses(stg_site_use_id) on delete cascade,
        include_yn                varchar2(1)   default 'Y' not null,
        profile_level             varchar2(20)  not null, -- SITE_USE (Bill-To), ACCOUNT
        site_ref_code             varchar2(60),
        src_cust_acct_prof_amt_id number,
        src_cust_acct_profile_id  number,
        src_account_number        varchar2(30),
        src_site_use_id           number,
        src_location_code         varchar2(40),
        src_currency_code         varchar2(15)  not null,
        src_overall_credit_limit  number,
        src_trx_credit_limit      number,
        src_exchange_rate_type    varchar2(30),
        src_min_stmt_amt          number,
        src_min_dunning_amt       number,
        tgt_account_number        varchar2(30),
        tgt_location_code         varchar2(40),
        tgt_currency_code         varchar2(15)  not null,
        tgt_overall_credit_limit  number,
        tgt_trx_credit_limit      number,
        tgt_exchange_rate_type    varchar2(30),
        tgt_min_stmt_amt          number,
        tgt_min_dunning_amt       number,
        modified_yn               varchar2(1)   default 'N' not null,
        user_notes                varchar2(1000),
        updated_by                varchar2(100) default coalesce(sys_context('APEX$SESSION','APP_USER'), user),
        updated_at                timestamp with time zone default systimestamp,
        constraint xxcr_stg_pa_inc_ck  check (include_yn in ('Y', 'N')),
        constraint xxcr_stg_pa_lvl_ck  check (profile_level in ('SITE_USE', 'ACCOUNT')),
        constraint xxcr_stg_pa_ocl_ck  check (tgt_overall_credit_limit is null or tgt_overall_credit_limit >= 0),
        constraint xxcr_stg_pa_tcl_ck  check (tgt_trx_credit_limit is null or tgt_trx_credit_limit >= 0)
      )
    ]';
    execute immediate 'create index xxcr_stg_pa_n1 on xxcr_stg_profile_amts(project_id, stg_cust_id)';
    execute immediate 'create index xxcr_stg_pa_n2 on xxcr_stg_profile_amts(project_id, stg_site_use_id)';
  end if;
end;
/

-- 5. Child Staging Table: OU-Striped Customer Account Relationships (Tier 1 Item 5)
--    Maps 1:1 to HZ_CUST_ACCOUNT_V2PUB.create_cust_acct_relate (cust_acct_relate_rec_type)
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_tables where table_name = 'XXCR_STG_ACCT_RELATES';
  if l_cnt = 0 then
    execute immediate q'[
      create table xxcr_stg_acct_relates (
        stg_relate_id             number generated by default on null as identity primary key,
        project_id                number        not null references xxcr_projects(project_id) on delete cascade,
        stg_cust_id               number        not null references xxcr_stg_customers(stg_cust_id) on delete cascade,
        related_stg_cust_id       number        references xxcr_stg_customers(stg_cust_id) on delete set null,
        include_yn                varchar2(1)   default 'Y' not null,
        src_cust_account_id       number        not null,
        src_account_number        varchar2(30)  not null,
        src_party_name            varchar2(360),
        src_related_cust_acct_id  number        not null,
        src_related_account_num   varchar2(30)  not null,
        src_related_party_name    varchar2(360),
        src_relationship_type     varchar2(30),
        src_bill_to_flag          varchar2(1),
        src_ship_to_flag          varchar2(1),
        src_reciprocal_flag       varchar2(1),
        src_comments              varchar2(240),
        tgt_account_number        varchar2(30)  not null,
        tgt_related_account_num   varchar2(30)  not null,
        tgt_relationship_type     varchar2(30),
        tgt_bill_to_flag          varchar2(1)   default 'Y' not null,
        tgt_ship_to_flag          varchar2(1)   default 'N' not null,
        tgt_reciprocal_flag       varchar2(1)   default 'N' not null,
        tgt_comments              varchar2(240),
        both_in_scope_yn          varchar2(1)   default 'N' not null,
        modified_yn               varchar2(1)   default 'N' not null,
        user_notes                varchar2(1000),
        updated_by                varchar2(100) default coalesce(sys_context('APEX$SESSION','APP_USER'), user),
        updated_at                timestamp with time zone default systimestamp,
        constraint xxcr_stg_rel_inc_ck check (include_yn in ('Y', 'N')),
        constraint xxcr_stg_rel_bt_ck  check (tgt_bill_to_flag in ('Y', 'N')),
        constraint xxcr_stg_rel_st_ck  check (tgt_ship_to_flag in ('Y', 'N')),
        constraint xxcr_stg_rel_rc_ck  check (tgt_reciprocal_flag in ('Y', 'N'))
      )
    ]';
    execute immediate 'create index xxcr_stg_rel_n1 on xxcr_stg_acct_relates(project_id, stg_cust_id)';
    execute immediate 'create unique index xxcr_stg_rel_uk1 on xxcr_stg_acct_relates(project_id, src_cust_account_id, src_related_cust_acct_id)';
  end if;
end;
/

-- 6. Child Staging Table: OU-Striped Payment Instruments & Receipt Methods (Tier 2 Item 7)
--    Maps to IBY_FNDCPT_SETUP_PUB.set_payer_instr_assignment & ARP_CRM_PKG (RA_CUST_RECEIPT_METHODS)
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_tables where table_name = 'XXCR_STG_PAYMENT_INSTR';
  if l_cnt = 0 then
    execute immediate q'[
      create table xxcr_stg_payment_instr (
        stg_pmt_id                number generated by default on null as identity primary key,
        project_id                number        not null references xxcr_projects(project_id) on delete cascade,
        stg_cust_id               number        not null references xxcr_stg_customers(stg_cust_id) on delete cascade,
        stg_site_use_id           number        references xxcr_stg_site_uses(stg_site_use_id) on delete cascade,
        include_yn                varchar2(1)   default 'Y' not null,
        assignment_source         varchar2(30)  not null, -- IBY_INSTRUMENT, AR_RECEIPT_METHOD
        assignment_level          varchar2(20)  not null, -- ACCOUNT, SITE_USE
        site_ref_code             varchar2(60),
        src_cust_account_id       number        not null,
        src_account_number        varchar2(30)  not null,
        src_site_use_id           number,
        src_location_code         varchar2(40),
        instrument_type           varchar2(30)  not null, -- BANKACCOUNT, CREDITCARD, RECEIPT_METHOD
        src_instrument_id         number        not null,
        masked_account_or_method  varchar2(240) not null, -- Masked Bank Acct / IBAN / Receipt Method Name (Zero raw PII)
        currency_code             varchar2(15),
        src_primary_flag          varchar2(1),
        src_order_of_pref         number,
        tgt_account_number        varchar2(30),
        tgt_location_code         varchar2(40),
        tgt_primary_flag          varchar2(1),
        tgt_order_of_pref         number,
        tgt_receipt_method_name   varchar2(100),
        modified_yn               varchar2(1)   default 'N' not null,
        user_notes                varchar2(1000),
        updated_by                varchar2(100) default coalesce(sys_context('APEX$SESSION','APP_USER'), user),
        updated_at                timestamp with time zone default systimestamp,
        constraint xxcr_stg_pmt_inc_ck check (include_yn in ('Y', 'N')),
        constraint xxcr_stg_pmt_prm_ck check (tgt_primary_flag is null or tgt_primary_flag in ('Y', 'N'))
      )
    ]';
    execute immediate 'create index xxcr_stg_pmt_n1 on xxcr_stg_payment_instr(project_id, stg_cust_id)';
    execute immediate 'create index xxcr_stg_pmt_n2 on xxcr_stg_payment_instr(project_id, stg_site_use_id)';
  end if;
end;
/

-- 7. Update Row-Level Normalization & Immutable-Key Triggers
create or replace trigger xxcr_stg_sites_biu_trg
before insert or update on xxcr_stg_sites
for each row
begin
  :new.include_yn           := upper(trim(nvl(:new.include_yn, 'Y')));
  :new.tgt_country          := upper(trim(:new.tgt_country));
  :new.tgt_address1         := trim(:new.tgt_address1);
  :new.tgt_address2         := trim(:new.tgt_address2);
  :new.tgt_city             := trim(:new.tgt_city);
  :new.tgt_state            := trim(:new.tgt_state);
  :new.tgt_postal_code      := trim(:new.tgt_postal_code);
  :new.tgt_sales_currency   := upper(trim(:new.tgt_sales_currency));
  :new.tgt_rps_hold_flag    := upper(trim(:new.tgt_rps_hold_flag));
  :new.tgt_third_party_name := trim(:new.tgt_third_party_name);

  if updating then
    :new.site_ref_code      := :old.site_ref_code;
    :new.tgt_account_number := nvl(:new.tgt_account_number, :old.tgt_account_number);
  end if;
end;
/

create or replace trigger xxcr_stg_su_biu_trg
before insert or update on xxcr_stg_site_uses
for each row
begin
  :new.include_yn               := upper(trim(nvl(:new.include_yn, 'Y')));
  :new.tgt_primary_flag         := upper(trim(nvl(:new.tgt_primary_flag, 'N')));
  :new.tgt_location_code        := trim(:new.tgt_location_code);
  :new.tgt_tax_reference        := trim(:new.tgt_tax_reference);
  :new.tgt_profile_class_name   := trim(:new.tgt_profile_class_name);
  :new.tgt_collector_name       := trim(:new.tgt_collector_name);
  :new.tgt_payment_term_name    := trim(:new.tgt_payment_term_name);
  :new.tgt_credit_currency      := upper(trim(:new.tgt_credit_currency));
  :new.tgt_warehouse_code       := upper(trim(:new.tgt_warehouse_code));
  :new.tgt_order_type_name      := trim(:new.tgt_order_type_name);
  :new.tgt_price_list_name      := trim(:new.tgt_price_list_name);
  :new.tgt_fob_point            := trim(:new.tgt_fob_point);
  :new.tgt_freight_term         := trim(:new.tgt_freight_term);
  :new.tgt_ship_via             := trim(:new.tgt_ship_via);
  :new.tgt_gsa_indicator        := upper(trim(:new.tgt_gsa_indicator));
  :new.tgt_tax_code             := trim(:new.tgt_tax_code);
  :new.tgt_awp_genie_rep        := trim(:new.tgt_awp_genie_rep);
  :new.tgt_awp_util_rep         := trim(:new.tgt_awp_util_rep);
  :new.tgt_send_statements      := upper(trim(:new.tgt_send_statements));
  :new.tgt_statement_cycle_name := trim(:new.tgt_statement_cycle_name);
  :new.tgt_discount_terms       := upper(trim(:new.tgt_discount_terms));
  :new.tgt_override_terms       := upper(trim(:new.tgt_override_terms));
  :new.tgt_dunning_letters      := upper(trim(:new.tgt_dunning_letters));
  :new.tgt_dunning_letter_set   := trim(:new.tgt_dunning_letter_set);
  :new.tgt_autocash_rule_name   := trim(:new.tgt_autocash_rule_name);
  :new.tgt_grouping_rule_name   := trim(:new.tgt_grouping_rule_name);
  :new.tgt_gl_rec_concat        := trim(:new.tgt_gl_rec_concat);
  :new.tgt_gl_rev_concat        := trim(:new.tgt_gl_rev_concat);
  :new.tgt_gl_tax_concat        := trim(:new.tgt_gl_tax_concat);
  :new.tgt_gl_freight_concat    := trim(:new.tgt_gl_freight_concat);

  if updating then
    :new.scope_class        := :old.scope_class;
    :new.site_ref_code      := :old.site_ref_code;
    :new.tgt_site_use_code  := :old.tgt_site_use_code;
    :new.tgt_account_number := :old.tgt_account_number;
  end if;
end;
/

create or replace trigger xxcr_stg_cnt_biu_trg
before insert or update on xxcr_stg_contacts
for each row
begin
  :new.include_yn             := upper(trim(nvl(:new.include_yn, 'Y')));
  :new.tgt_primary_flag       := upper(trim(nvl(:new.tgt_primary_flag, 'N')));
  :new.tgt_first_name         := trim(:new.tgt_first_name);
  :new.tgt_last_name          := trim(:new.tgt_last_name);
  :new.tgt_job_title          := trim(:new.tgt_job_title);
  :new.tgt_department         := trim(:new.tgt_department);
  :new.tgt_email_address      := lower(trim(:new.tgt_email_address));
  :new.tgt_phone_country_code := trim(:new.tgt_phone_country_code);
  :new.tgt_phone_area_code    := trim(:new.tgt_phone_area_code);
  :new.tgt_phone_number       := trim(:new.tgt_phone_number);
  :new.tgt_mobile_number      := trim(:new.tgt_mobile_number);
  :new.tgt_fax_number         := trim(:new.tgt_fax_number);

  if updating then
    :new.contact_ref_code   := :old.contact_ref_code;
    :new.site_ref_code      := :old.site_ref_code;
    :new.tgt_account_number := :old.tgt_account_number;
  end if;
end;
/

create or replace trigger xxcr_stg_pa_biu_trg
before insert or update on xxcr_stg_profile_amts
for each row
begin
  :new.include_yn        := upper(trim(nvl(:new.include_yn, 'Y')));
  :new.tgt_currency_code := upper(trim(:new.tgt_currency_code));
  if updating then
    :new.profile_level      := :old.profile_level;
    :new.site_ref_code      := :old.site_ref_code;
    :new.src_currency_code  := :old.src_currency_code;
    :new.tgt_account_number := :old.tgt_account_number;
    if nvl(:new.tgt_overall_credit_limit, -1) != nvl(:old.tgt_overall_credit_limit, -1)
       or nvl(:new.tgt_trx_credit_limit, -1) != nvl(:old.tgt_trx_credit_limit, -1)
       or nvl(:new.tgt_currency_code, '~') != nvl(:old.tgt_currency_code, '~')
       or :new.include_yn != :old.include_yn then
      :new.modified_yn := 'Y';
    end if;
    :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'), user);
    :new.updated_at := systimestamp;
  end if;
end;
/

create or replace trigger xxcr_stg_rel_biu_trg
before insert or update on xxcr_stg_acct_relates
for each row
begin
  :new.include_yn          := upper(trim(nvl(:new.include_yn, 'Y')));
  :new.tgt_bill_to_flag    := upper(trim(nvl(:new.tgt_bill_to_flag, 'N')));
  :new.tgt_ship_to_flag    := upper(trim(nvl(:new.tgt_ship_to_flag, 'N')));
  :new.tgt_reciprocal_flag := upper(trim(nvl(:new.tgt_reciprocal_flag, 'N')));
  if updating then
    :new.src_account_number      := :old.src_account_number;
    :new.src_related_account_num := :old.src_related_account_num;
    if :new.tgt_bill_to_flag != :old.tgt_bill_to_flag
       or :new.tgt_ship_to_flag != :old.tgt_ship_to_flag
       or :new.tgt_reciprocal_flag != :old.tgt_reciprocal_flag
       or :new.include_yn != :old.include_yn then
      :new.modified_yn := 'Y';
    end if;
    :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'), user);
    :new.updated_at := systimestamp;
  end if;
end;
/

create or replace trigger xxcr_stg_pmt_biu_trg
before insert or update on xxcr_stg_payment_instr
for each row
begin
  :new.include_yn       := upper(trim(nvl(:new.include_yn, 'Y')));
  :new.tgt_primary_flag := upper(trim(:new.tgt_primary_flag));
  if updating then
    :new.assignment_source        := :old.assignment_source;
    :new.instrument_type          := :old.instrument_type;
    :new.masked_account_or_method := :old.masked_account_or_method;
    if nvl(:new.tgt_primary_flag, '~') != nvl(:old.tgt_primary_flag, '~')
       or nvl(:new.tgt_order_of_pref, -1) != nvl(:old.tgt_order_of_pref, -1)
       or nvl(:new.tgt_receipt_method_name, '~') != nvl(:old.tgt_receipt_method_name, '~')
       or :new.include_yn != :old.include_yn then
      :new.modified_yn := 'Y';
    end if;
    :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'), user);
    :new.updated_at := systimestamp;
  end if;
end;
/