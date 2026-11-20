-- =============================================================================
-- 03_xxcr_site_activity_dups.sql
-- Adds Site & Site-Use Open AR, 24m Trx / Open SO Activity Counts, Last Activity
-- Date, and Activity-Ranked Duplicate Role (UNIQUE / SURVIVOR / DUPLICATE -> Ref)
-- Target Schema: GL_ACCOUNTS on APEXQ_AWS (Oracle AI Database 26ai)
-- =============================================================================

alter table xxcr_stg_customers add (
  dup_role              varchar2(120) default 'UNIQUE'
);

alter table xxcr_stg_sites add (
  src_open_ar_amt       number,
  src_trx_cnt_recent    number,
  src_open_so_cnt       number,
  src_last_trx_date     date,
  dup_role              varchar2(120) default 'UNIQUE'
);

alter table xxcr_stg_site_uses add (
  src_open_ar_amt       number,
  src_trx_cnt_recent    number,
  src_open_so_cnt       number,
  src_last_trx_date     date,
  dup_count             number default 0 not null,
  dup_role              varchar2(120) default 'UNIQUE'
);

alter table xxcr_stg_contacts add (
  dup_role              varchar2(120) default 'UNIQUE'
);

alter table xxcr_duplicates add (
  dup_open_ar_amt       number,
  dup_activity_cnt      number,
  survivor_open_ar_amt  number,
  survivor_activity_cnt number
);
