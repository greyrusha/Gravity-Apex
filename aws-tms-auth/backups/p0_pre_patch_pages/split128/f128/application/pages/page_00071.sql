prompt --application/pages/page_00071
begin
--   Manifest
--     PAGE: 00071
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.04.07'
,p_release=>'26.2.0'
,p_default_workspace_id=>100789
,p_default_application_id=>128
,p_default_id_offset=>9401733729708713
,p_default_owner=>'GL_ACCOUNTS'
);
wwv_flow_imp_page.create_page(
 p_id=>71
,p_name=>'Fixed Assets Month-End Close'
,p_alias=>'FIXED-ASSETS'
,p_step_title=>'Fixed Assets Month-End Close'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(function(){const $=apex.jQuery;',
' function decorate(){const r=$(''#fa71-report'');r.find(''.fa71-status'').each(function(){const s=this.textContent.trim();this.className=''fa71-status fa71-badge ''+(s===''COMPLETE''||s===''COMPLETE (NO GL POSTING)''?''fa71-good'':[''GL NOT POSTED'',''NOT TRANSFERR'
||'ED TO GL'',''ANNUAL CALENDAR - CONFIRM SCOPE''].includes(s)?''fa71-warn'':''fa71-bad'');});',
' r.find(''.fa71-activity'').each(function(){if(this.textContent.trim())this.className=''fa71-activity fa71-badge fa71-note'';});',
' r.find(''.fa71-reconciliation'').each(function(){const s=this.textContent.trim();this.className=''fa71-reconciliation fa71-badge ''+(s===''MATCHED''?''fa71-good'':s===''DIFFERENCE''?''fa71-bad'':''fa71-warn'');});',
' r.find(''.fa71-indicator'').each(function(){this.classList.toggle(''fa71-warn'',/[1-9]/.test(this.textContent));this.classList.toggle(''fa71-badge'',/[1-9]/.test(this.textContent));});}',
' $(''#fa71-report'').on(''apexafterrefresh'',decorate);',
' $(document).on(''click'',''.fa71-refresh'',function(){apex.region(''fa71-report'').refresh();});decorate();})();'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#fa71-filters .apex-item-group--popup-lov,#fa71-filters .apex-item-multi,#fa71-filters .apex-item-select{min-height:76px}',
'#fa71-filters .apex-item-multi{padding-top:26px!important;padding-bottom:6px!important;align-content:flex-start}',
'#fa71-filters .apex-item-multi:has([data-value])>.apex-item-multi-item:last-child{flex:0 0 1px;min-width:1px;width:1px}',
'#fa71-filters .apex-item-multi:has([data-value])>.apex-item-multi-item:last-child input{width:1px!important;min-width:1px!important;padding:0}',
'#fa71-filters .a-Button--popupLOV{min-height:76px}',
'.fa71-intro h1{margin:0 0 8px}.fa71-intro p{margin:6px 0;color:var(--ut-body-text-color,#333)}',
'.fa71-muted{font-size:12px;opacity:.8}',
'.fa71-badge{display:inline-block;padding:4px 8px;border-radius:4px;font-weight:600;white-space:nowrap}',
'.fa71-good{background:#e6f4eb;color:#185c37}.fa71-warn{background:#fff1d6;color:#704500}.fa71-bad{background:#fde5e7;color:#9d1521}.fa71-note{background:var(--ut-component-background-color,#eef0f3);color:var(--ut-body-text-color,#333);font-size:11px}',
'#fa71-report .a-IRR-tableContainer{max-height:560px;overflow:auto;isolation:isolate}',
'#fa71-report .a-IRR-header:not(.a-IRR-header--group){position:sticky;top:0;z-index:2;background:var(--ut-region-header-background-color,#edf2f6);font-weight:700;text-align:center;border-bottom:2px solid var(--ut-component-border-color,#a5b5c1)}',
'#fa71-report .a-IRR-headerLink{color:inherit;font-weight:700}',
''))
,p_step_template=>4075783602716660119
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(18558063129193156)
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(15258152637524983)
,p_plug_name=>'Filters'
,p_static_id=>'filters'
,p_region_name=>'fa71-filters'
,p_region_template_options=>'#DEFAULT#:t-Region--noBorder:t-Region--hideHeader'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>20
,p_plug_item_display_point=>'ABOVE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(15258096844524983)
,p_plug_name=>'Fixed Assets'
,p_static_id=>'fixed-assets'
,p_region_name=>'fa71-intro'
,p_region_template_options=>'#DEFAULT#:t-Region--noBorder:t-Region--hideHeader'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_plug_source=>'<div class="fa71-intro"><h1>Fixed Assets Month-End Close</h1><p>Compare net FA depreciation with final SLA expense and posted GL expense, using expense debits minus credits.</p><p class="fa71-muted">Select a book or difference to open the accounting '
||'bridge and asset details. Unresolved GL mappings require review. Books with GL posting disabled are exempt from the SLA and GL checks.</p></div>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(15258208970524983)
,p_plug_name=>'Fixed Assets Close Status'
,p_static_id=>'fixed-assets-close-status'
,p_region_name=>'fa71-report'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>30
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select q.*,apex_page.get_url(p_page=>72,p_clear_cache=>''72'',p_items=>''P72_LEDGER_ID,P72_BOOK_TYPE_CODE,P72_PERIOD_NAME'',p_values=>to_char(q.ledger_id)||'',''||q.book_type_code||'',''||q.period_name) bridge_url from (select r.*,',
' case when r.close_status=''COMPLETE (NO GL POSTING)'' then ''NOT APPLICABLE''',
' when r.close_status=''ANNUAL CALENDAR - CONFIRM SCOPE'' then ''SCOPE REVIEW''',
' when r.period_status=''Not found'' then ''PERIOD NOT FOUND''',
' when r.gl_mapping_issues>0 or r.orphan_asset_lines>0 or r.sla_period_mismatch_lines>0 then ''MAPPING REVIEW''',
' when r.close_status<>''COMPLETE'' then ''PENDING CLOSE''',
' when r.sla_unlinked_lines>0 then ''POSTING COVERAGE REVIEW''',
' when r.fa_summary_rows=0 then ''NO FA DATA''',
' when r.fa_vs_gl_expense_diff is null then ''NO POSTED EXPENSE''',
' when r.fa_vs_gl_expense_diff<>0 or round(r.fa_deprn_amount-nvl(r.sla_expense_net,0),2)<>0 then ''DIFFERENCE''',
' else ''MATCHED'' end reconciliation_status',
' from (select q.*,s.sla_expense_dr,s.sla_expense_cr,s.sla_expense_net,',
' nvl(s.sla_expense_lines,0) sla_expense_lines,nvl(s.orphan_asset_lines,0) orphan_asset_lines,',
' nvl(s.sla_period_mismatch_lines,0) sla_period_mismatch_lines,nvl(s.sla_unlinked_lines,0) sla_unlinked_lines,',
' case when g.gl_mapping_issues=0 then g.gl_posted_expense_dr end gl_posted_expense_dr,',
' case when g.gl_mapping_issues=0 then g.gl_posted_expense_cr end gl_posted_expense_cr,',
' case when g.gl_mapping_issues=0 then g.gl_posted_expense_net end gl_posted_expense_net,',
' nvl(g.gl_line_count,0) gl_line_count,nvl(g.gl_mapping_issues,0) gl_mapping_issues,',
' nvl(g.gl_posted_expense_lines,0) gl_posted_expense_lines,',
' case when q.fa_summary_rows>0 and nvl(g.gl_mapping_issues,0)=0 and nvl(s.orphan_asset_lines,0)=0',
'  and nvl(s.sla_period_mismatch_lines,0)=0 and nvl(s.sla_unlinked_lines,0)=0',
'  and (nvl(g.gl_posted_expense_lines,0)>0 or (q.fa_nonzero_rows=0 and q.deprn_events=0))',
'  and q.close_status not in (''COMPLETE (NO GL POSTING)'',''ANNUAL CALENDAR - CONFIRM SCOPE'')',
'  then round(q.fa_deprn_amount-nvl(g.gl_posted_expense_net,0),2) end fa_vs_gl_expense_diff',
' from (SELECT /*+ DRIVING_SITE(bc) */',
'       gl.ledger_id,',
'       gl.name                                   ledger_name,',
'       gl.currency_code,',
'       bc.book_type_code,',
'       bc.book_class,',
'       bc.deprn_calendar,',
'       NVL(dp.period_name, NVL(UPPER(TRIM(REPLACE(:P71_PERIOD_NAME, ''''''''))),',
'                               TO_CHAR(ADD_MONTHS(SYSDATE, -1), ''MON-YYYY'', ''NLS_DATE_LANGUAGE=ENGLISH'')))  period_name,',
'       CASE WHEN dp.period_counter IS NULL        THEN ''Not found''',
'            WHEN dp.period_close_date IS NOT NULL THEN ''Closed''',
'            ELSE ''Open'' END                      period_status,',
'       dp.period_close_date,',
'       NVL(dp.deprn_run, ''N'')                    deprn_run,',
'       NVL(fa.fa_summary_rows, 0)                fa_summary_rows,',
'       NVL(fa.fa_nonzero_rows, 0)                fa_nonzero_rows,',
'       fa.fa_deprn_amount,',
'       fa.fa_catchup_amount,',
'       fa.fa_positive_deprn,fa.fa_negative_deprn,',
'       NVL(x.deprn_events, 0)                    deprn_events,',
'       NVL(x.unaccounted_events, 0)              unaccounted_events,',
'       NVL(x.entries_not_final, 0)               entries_not_final,',
'       NVL(x.entries_not_transferred, 0)         entries_not_transferred,',
'       NVL(j.gl_groups_expected, 0)              gl_groups_expected,',
'       NVL(j.gl_groups_missing, 0)               gl_groups_missing,',
'       NVL(j.gl_shared_groups, 0)                gl_shared_groups,',
'       NVL(j.gl_journals, 0)                     gl_journals,',
'       NVL(j.gl_unposted, 0)                     gl_unposted,',
'       j.gl_journal_dr_total,',
'       -- indicator only: FA period depreciation vs whole-journal debit total',
'       NVL(fa.fa_deprn_amount, 0) - NVL(j.gl_journal_dr_total, 0)  fa_vs_gl_dr_diff,',
'       j.gl_batch_names,',
'       CASE',
'         WHEN dp.period_counter IS NULL                   THEN NULL',
'         WHEN NVL(fa.fa_summary_rows, 0) = 0              THEN ''NO DEPRECIATION DATA''',
'         WHEN fa.fa_nonzero_rows = 0                      THEN ''ZERO DEPRECIATION''',
'         WHEN fa.fa_deprn_amount = 0                      THEN ''ZERO NET DEPRECIATION''',
'       END                                       activity_note,',
'       CASE',
'         WHEN ct.number_per_fiscal_year = 1               THEN ''ANNUAL CALENDAR - CONFIRM SCOPE''',
'         WHEN dp.period_counter IS NULL                   THEN ''PERIOD NOT FOUND''',
'         WHEN dp.period_close_date IS NULL                THEN ''NOT CLOSED''',
'         WHEN NVL(dp.deprn_run, ''N'') <> ''Y''               THEN ''NO DEPRN RUN''',
'         WHEN bc.gl_posting_allowed_flag <> ''YES''         THEN ''COMPLETE (NO GL POSTING)''',
'         WHEN NVL(x.unaccounted_events, 0) > 0            THEN ''UNACCOUNTED EVENTS''',
'         WHEN NVL(x.entries_not_final, 0) > 0             THEN ''ACCOUNTING NOT FINAL''',
'         WHEN NVL(x.entries_not_transferred, 0) > 0       THEN ''NOT TRANSFERRED TO GL''',
'         WHEN NVL(fa.fa_nonzero_rows, 0) > 0',
'          AND NVL(x.deprn_events, 0) = 0                  THEN ''NO ACCOUNTING EVENTS''',
'         WHEN NVL(j.gl_groups_missing, 0) > 0             THEN ''GL JOURNAL MISSING''',
'         WHEN NVL(fa.fa_nonzero_rows, 0) > 0',
'          AND NVL(j.gl_journals, 0) = 0                   THEN ''NO GL JOURNAL''',
'         WHEN NVL(j.gl_unposted, 0) > 0                   THEN ''GL NOT POSTED''',
'         ELSE ''COMPLETE''',
'       END                                       close_status',
'  FROM apps.fa_book_controls@ADG  bc,',
'       apps.gl_ledgers@ADG        gl,',
'       apps.fa_calendar_types@ADG ct,',
'       apps.fa_deprn_periods@ADG  dp,',
'       -- FA side: depreciation calculated for the period (in-scope books only)',
'       (SELECT ds.book_type_code, ds.period_counter,',
'               COUNT(*)                                                   fa_summary_rows,',
'               SUM(CASE WHEN ds.deprn_amount-NVL(ds.deprn_adjustment_amount,0)>0 THEN ds.deprn_amount-NVL(ds.deprn_adjustment_amount,0) ELSE 0 END) fa_positive_deprn,',
'               SUM(CASE WHEN ds.deprn_amount-NVL(ds.deprn_adjustment_amount,0)<0 THEN ds.deprn_amount-NVL(ds.deprn_adjustment_amount,0) ELSE 0 END) fa_negative_deprn,',
'               SUM(CASE WHEN ds.deprn_amount - NVL(ds.deprn_adjustment_amount, 0) <> 0',
'                        THEN 1 ELSE 0 END)                                fa_nonzero_rows,',
'               -- catch-up (deprn_adjustment_amount) is booked by the Adjustment journal, not Depreciation',
'               SUM(ds.deprn_amount - NVL(ds.deprn_adjustment_amount, 0))  fa_deprn_amount,',
'               SUM(NVL(ds.deprn_adjustment_amount, 0))                    fa_catchup_amount',
'          FROM apps.fa_deprn_summary@ADG ds,',
'               apps.fa_deprn_periods@ADG dp2,',
'               apps.fa_book_controls@ADG bc2',
'         WHERE bc2.set_of_books_id IN (1003, 5001, 10001)',
'           AND dp2.book_type_code  = bc2.book_type_code',
'           AND dp2.period_name     = NVL(UPPER(TRIM(REPLACE(:P71_PERIOD_NAME, ''''''''))),',
'                                         TO_CHAR(ADD_MONTHS(SYSDATE, -1), ''MON-YYYY'', ''NLS_DATE_LANGUAGE=ENGLISH''))',
'           AND ds.book_type_code   = dp2.book_type_code',
'           AND ds.period_counter   = dp2.period_counter',
'           AND ds.deprn_source_code = ''DEPRN''',
'         GROUP BY ds.book_type_code, ds.period_counter) fa,',
'       -- SLA side: depreciation events and entries in the book''s own ledger',
'       (SELECT te.ledger_id,',
'               te.source_id_char_1 book_type_code,',
'               te.source_id_int_2  period_counter,',
'               COUNT(DISTINCT e.event_id) deprn_events,',
'               COUNT(DISTINCT CASE WHEN e.event_status_code IN (''U'', ''I'') THEN e.event_id END) unaccounted_events,',
'               COUNT(DISTINCT CASE WHEN ah.accounting_entry_status_code <> ''F''',
'                                   THEN ah.ae_header_id END) entries_not_final,',
'               COUNT(DISTINCT CASE WHEN ah.accounting_entry_status_code = ''F''',
'                                    AND (NVL(ah.gl_transfer_status_code, ''N'') <> ''Y'' OR ah.group_id IS NULL)',
'                                   THEN ah.ae_header_id END) entries_not_transferred',
'          FROM apps.xla_transaction_entities@ADG te,',
'               apps.xla_events@ADG               e,',
'               apps.xla_ae_headers@ADG           ah',
'         WHERE te.application_id  = 140',
'           AND te.ledger_id       IN (1003, 5001, 10001)',
'           AND te.entity_code     = ''DEPRECIATION''',
'           AND EXISTS (SELECT 1',
'                         FROM apps.fa_deprn_periods@ADG dp3',
'                        WHERE dp3.book_type_code = te.source_id_char_1',
'                          AND dp3.period_counter = te.source_id_int_2',
'                          AND dp3.period_name = NVL(UPPER(TRIM(REPLACE(:P71_PERIOD_NAME, ''''''''))),',
'                                                    TO_CHAR(ADD_MONTHS(SYSDATE, -1), ''MON-YYYY'', ''NLS_DATE_LANGUAGE=ENGLISH'')))',
'           AND e.application_id  = 140',
'           AND e.entity_id       = te.entity_id',
'           -- outer join keeps events that have no accounting header yet',
'           AND ah.application_id (+) = 140',
'           AND ah.event_id       (+) = e.event_id',
'           AND ah.ledger_id      (+) = te.ledger_id',
'         GROUP BY te.ledger_id, te.source_id_char_1, te.source_id_int_2) x,',
'       -- GL side: every transferred SLA group must have a Depreciation journal in the period',
'       (SELECT g.ledger_id,',
'               g.book_type_code,',
'               g.period_counter,',
'               COUNT(DISTINCT g.group_id)                                          gl_groups_expected,',
'               COUNT(DISTINCT CASE WHEN gh.je_header_id IS NULL THEN g.group_id END) gl_groups_missing,',
'               COUNT(DISTINCT CASE WHEN g.books_in_group > 1 THEN g.group_id END)  gl_shared_groups,',
'               COUNT(gh.je_header_id)                                              gl_journals,',
'               SUM(CASE WHEN gh.status <> ''P'' THEN 1 ELSE 0 END)                   gl_unposted,',
'               SUM(gh.running_total_accounted_dr)                                  gl_journal_dr_total,',
'               LISTAGG(DISTINCT CASE WHEN gh.je_header_id IS NOT NULL',
'                                    THEN gh.batch_name || '' ['' || gh.batch_status || '']''',
'                               END, ''; '' ON OVERFLOW TRUNCATE ''...'' WITH COUNT)',
'                 WITHIN GROUP (ORDER BY gh.batch_name || '' ['' || gh.batch_status || '']'') gl_batch_names',
'          FROM (SELECT gg.ledger_id, gg.book_type_code, gg.period_counter, gg.group_id,',
'                       -- Count distinct books across the group''s periods, not book-period rows.',
'                       -- A second book outside the selected period still makes the total shared.',
'                       (SELECT COUNT(DISTINCT shared_te.source_id_char_1)',
'                          FROM apps.xla_transaction_entities@ADG shared_te,',
'                               apps.xla_ae_headers@ADG shared_ah',
'                         WHERE shared_te.application_id = 140',
'                           AND shared_te.ledger_id = gg.ledger_id',
'                           AND shared_te.entity_code = ''DEPRECIATION''',
'                           AND shared_ah.application_id = 140',
'                           AND shared_ah.entity_id = shared_te.entity_id',
'                           AND shared_ah.ledger_id = shared_te.ledger_id',
'                           AND shared_ah.accounting_entry_status_code = ''F''',
'                           AND shared_ah.gl_transfer_status_code = ''Y''',
'                           AND shared_ah.group_id = gg.group_id) books_in_group',
'                  FROM (SELECT DISTINCT te.ledger_id,',
'                               te.source_id_char_1 book_type_code,',
'                               te.source_id_int_2  period_counter,',
'                               ah.group_id',
'                          FROM apps.xla_transaction_entities@ADG te,',
'                               apps.xla_ae_headers@ADG           ah',
'                         WHERE te.application_id  = 140',
'                           AND te.ledger_id       IN (1003, 5001, 10001)',
'                           AND te.entity_code     = ''DEPRECIATION''',
'                           AND EXISTS (SELECT 1',
'                                         FROM apps.fa_deprn_periods@ADG dp4',
'                                        WHERE dp4.book_type_code = te.source_id_char_1',
'                                          AND dp4.period_counter = te.source_id_int_2',
'                                          AND dp4.period_name = NVL(UPPER(TRIM(REPLACE(:P71_PERIOD_NAME, ''''''''))),',
'                                                                    TO_CHAR(ADD_MONTHS(SYSDATE, -1), ''MON-YYYY'', ''NLS_DATE_LANGUAGE=ENGLISH'')))',
'                           AND ah.application_id  = 140',
'                           AND ah.entity_id       = te.entity_id',
'                           AND ah.ledger_id       = te.ledger_id',
'                           AND ah.accounting_entry_status_code = ''F''',
'                           AND ah.gl_transfer_status_code      = ''Y''',
'                           AND ah.group_id IS NOT NULL) gg) g,',
'               (SELECT b.group_id, h.ledger_id, h.je_header_id, h.status, h.running_total_accounted_dr,',
'                       b.name batch_name, b.status batch_status',
'                  FROM apps.gl_je_batches@ADG b,',
'                       apps.gl_je_headers@ADG h',
'                 WHERE h.period_name = NVL(UPPER(TRIM(REPLACE(:P71_PERIOD_NAME, ''''''''))),',
'                                           TO_CHAR(ADD_MONTHS(SYSDATE, -1), ''MON-YYYY'', ''NLS_DATE_LANGUAGE=ENGLISH''))',
'                   AND h.je_category = ''Depreciation''',
'                   AND h.je_source   = ''Assets''',
'                   AND h.actual_flag = ''A''',
'                   AND h.ledger_id   IN (1003, 5001, 10001)',
'                   AND b.je_batch_id = h.je_batch_id) gh',
'         WHERE gh.group_id  (+) = g.group_id',
'           AND gh.ledger_id (+) = g.ledger_id',
'         GROUP BY g.ledger_id, g.book_type_code, g.period_counter) j',
' WHERE gl.ledger_id         = bc.set_of_books_id',
'   -- App 128 ledger scope, enforced regardless of the filter',
'   AND bc.set_of_books_id  IN (1003, 5001, 10001)',
'   AND bc.date_ineffective IS NULL',
'   AND ct.calendar_type     = bc.deprn_calendar',
'   AND (:P71_BOOK_CLASS IS NULL OR bc.book_class = UPPER(TRIM(REPLACE(:P71_BOOK_CLASS, ''''''''))))',
'   -- ledger filter: whole numeric tokens only (separators: comma, semicolon, colon, space)',
'   AND (TRIM(REPLACE(:P71_LEDGER_IDS, '''''''')) IS NULL',
'        OR bc.set_of_books_id IN (SELECT TO_NUMBER(CASE WHEN REGEXP_LIKE(t.tok, ''^[0-9]{1,15}$'') THEN t.tok END)',
'                                    FROM (SELECT REGEXP_SUBSTR(REPLACE(:P71_LEDGER_IDS, ''''''''), ''[^,;: ]+'', 1, LEVEL) tok',
'                                            FROM dual@ADG',
'                                         CONNECT BY REGEXP_SUBSTR(REPLACE(:P71_LEDGER_IDS, ''''''''), ''[^,;: ]+'', 1, LEVEL) IS NOT NULL) t))',
'   -- outer join: a book without the requested period still shows as PERIOD NOT FOUND',
'   AND dp.book_type_code (+) = bc.book_type_code',
'   AND dp.period_name    (+) = NVL(UPPER(TRIM(REPLACE(:P71_PERIOD_NAME, ''''''''))),',
'                                   TO_CHAR(ADD_MONTHS(SYSDATE, -1), ''MON-YYYY'', ''NLS_DATE_LANGUAGE=ENGLISH''))',
'   AND fa.book_type_code (+) = dp.book_type_code',
'   AND fa.period_counter (+) = dp.period_counter',
'   AND x.ledger_id       (+) = bc.set_of_books_id',
'   AND x.book_type_code  (+) = dp.book_type_code',
'   AND x.period_counter  (+) = dp.period_counter',
'   AND j.ledger_id       (+) = bc.set_of_books_id',
'   AND j.book_type_code  (+) = dp.book_type_code',
'   AND j.period_counter  (+) = dp.period_counter',
' ORDER BY gl.ledger_id, bc.book_class, bc.book_type_code) q,(select te.ledger_id,te.source_id_char_1 book_type_code,dp.period_name,',
' count(*) sla_expense_lines,sum(nvl(xl.accounted_dr,0)) sla_expense_dr,',
' sum(nvl(xl.accounted_cr,0)) sla_expense_cr,',
' sum(nvl(xl.accounted_dr,0)-nvl(xl.accounted_cr,0)) sla_expense_net,',
' count(case when ah.period_name<>dp.period_name or ah.period_name is null then 1 end) sla_period_mismatch_lines,',
' count(case when not exists(select 1 from apps.gl_import_references@ADG ir,',
'  apps.gl_je_lines@ADG jl,apps.gl_je_headers@ADG jh',
'  where ir.gl_sl_link_id=xl.gl_sl_link_id and ir.gl_sl_link_table=xl.gl_sl_link_table',
'  and jl.je_header_id=ir.je_header_id and jl.je_line_num=ir.je_line_num',
'  and jh.je_header_id=jl.je_header_id and jh.ledger_id=te.ledger_id',
'  and jh.period_name=dp.period_name and jh.je_source=''Assets'' and jh.je_category=''Depreciation''',
'  and jh.actual_flag=''A'' and jh.status=''P'') then 1 end) sla_unlinked_lines,',
' count(case when not exists(select 1 from apps.fa_deprn_summary@ADG ds',
'  where ds.book_type_code=te.source_id_char_1 and ds.period_counter=te.source_id_int_2',
'  and ds.asset_id=te.source_id_int_1 and ds.deprn_source_code=''DEPRN'') then 1 end) orphan_asset_lines',
' from apps.fa_book_controls@ADG bc,apps.fa_deprn_periods@ADG dp,',
' apps.xla_transaction_entities@ADG te,apps.xla_ae_headers@ADG ah,apps.xla_ae_lines@ADG xl',
' where bc.set_of_books_id in (1003,5001,10001) and bc.date_ineffective is null',
' and (cast(null as number) is null or bc.set_of_books_id=cast(null as number))',
' and (cast(null as varchar2(30)) is null or bc.book_type_code=cast(null as varchar2(30)))',
' and dp.book_type_code=bc.book_type_code and dp.period_name=NVL(UPPER(TRIM(REPLACE(:P71_PERIOD_NAME, ''''''''))),TO_CHAR(ADD_MONTHS(SYSDATE,-1),''MON-YYYY'',''NLS_DATE_LANGUAGE=ENGLISH''))',
' and te.application_id=140 and te.entity_code=''DEPRECIATION''',
' and te.ledger_id=bc.set_of_books_id and te.source_id_char_1=bc.book_type_code',
' and te.source_id_int_2=dp.period_counter',
' and ah.application_id=te.application_id and ah.entity_id=te.entity_id',
' and ah.ledger_id=te.ledger_id and ah.accounting_entry_status_code=''F''',
' and xl.application_id=ah.application_id and xl.ae_header_id=ah.ae_header_id',
' and xl.accounting_class_code=''EXPENSE''',
' group by te.ledger_id,te.source_id_char_1,dp.period_name) s,(select ledger_id,book_type_code,period_name,count(*) gl_line_count,',
' count(case when mapping_status<>''MAPPED'' then 1 end) gl_mapping_issues,',
' count(case when mapping_status=''MAPPED'' and accounting_class_code=''EXPENSE'' and status=''P'' then 1 end) gl_posted_expense_lines,',
' sum(case when mapping_status=''MAPPED'' and accounting_class_code=''EXPENSE'' and status=''P'' then accounted_dr else 0 end) gl_posted_expense_dr,',
' sum(case when mapping_status=''MAPPED'' and accounting_class_code=''EXPENSE'' and status=''P'' then accounted_cr else 0 end) gl_posted_expense_cr,',
' sum(case when mapping_status=''MAPPED'' and accounting_class_code=''EXPENSE'' and status=''P'' then accounted_dr-accounted_cr else 0 end) gl_posted_expense_net',
' from (select j.ledger_id,j.book_type_code,j.period_name,j.je_header_id,j.journal_name,j.batch_name,j.status,',
' jl.je_line_num,jl.code_combination_id,nvl(jl.accounted_dr,0) accounted_dr,nvl(jl.accounted_cr,0) accounted_cr,',
' m.accounting_class_code,',
' case when m.reference_rows is not null and m.unresolved_refs=0 and m.class_count=1',
' and m.book_count=1 and m.period_count=1 and m.ledger_count=1',
' and m.min_application=140 and m.max_application=140',
' and m.min_entity=''DEPRECIATION'' and m.max_entity=''DEPRECIATION''',
' and m.ledger_id=j.ledger_id and m.book_type_code=j.book_type_code and m.period_counter=j.period_counter then ''MAPPED'' else ''REVIEW MAPPING'' end mapping_status',
' from (select distinct te.ledger_id,te.source_id_char_1 book_type_code,',
' dp.period_name,dp.period_counter,h.je_header_id,h.name journal_name,h.status,',
' b.name batch_name,b.je_batch_id',
' from apps.fa_book_controls@ADG bc,apps.fa_deprn_periods@ADG dp,',
' apps.xla_transaction_entities@ADG te,apps.xla_ae_headers@ADG ah,apps.gl_je_batches@ADG b,apps.gl_je_headers@ADG h',
' where bc.set_of_books_id in (1003,5001,10001) and bc.date_ineffective is null',
' and (cast(null as number) is null or bc.set_of_books_id=cast(null as number))',
' and (cast(null as varchar2(30)) is null or bc.book_type_code=cast(null as varchar2(30)))',
' and dp.book_type_code=bc.book_type_code and dp.period_name=NVL(UPPER(TRIM(REPLACE(:P71_PERIOD_NAME, ''''''''))),TO_CHAR(ADD_MONTHS(SYSDATE,-1),''MON-YYYY'',''NLS_DATE_LANGUAGE=ENGLISH''))',
' and te.application_id=140 and te.entity_code=''DEPRECIATION''',
' and te.ledger_id=bc.set_of_books_id and te.source_id_char_1=bc.book_type_code',
' and te.source_id_int_2=dp.period_counter',
' and ah.application_id=te.application_id and ah.entity_id=te.entity_id',
' and ah.ledger_id=te.ledger_id and ah.accounting_entry_status_code=''F''',
' and ah.group_id is not null and ah.gl_transfer_status_code=''Y''',
' and b.group_id=ah.group_id and h.je_batch_id=b.je_batch_id and h.ledger_id=te.ledger_id',
' and h.je_source=''Assets'' and h.je_category=''Depreciation'' and h.actual_flag=''A''',
' and h.period_name=dp.period_name) j,apps.gl_je_lines@ADG jl,(select ir.je_header_id,ir.je_line_num,count(*) reference_rows,',
' count(case when xl.ae_header_id is null or te.entity_id is null then 1 end) unresolved_refs,',
' count(distinct xl.accounting_class_code) class_count,min(xl.accounting_class_code) accounting_class_code,',
' count(distinct te.source_id_char_1) book_count,min(te.source_id_char_1) book_type_code,',
' count(distinct te.source_id_int_2) period_count,min(te.source_id_int_2) period_counter,',
' count(distinct te.ledger_id) ledger_count,min(te.ledger_id) ledger_id,',
' min(te.application_id) min_application,max(te.application_id) max_application,',
' min(te.entity_code) min_entity,max(te.entity_code) max_entity',
' from apps.gl_import_references@ADG ir,apps.xla_ae_lines@ADG xl,',
' apps.xla_ae_headers@ADG ah,apps.xla_transaction_entities@ADG te',
' where exists(select 1 from (select distinct te.ledger_id,te.source_id_char_1 book_type_code,',
' dp.period_name,dp.period_counter,h.je_header_id,h.name journal_name,h.status,',
' b.name batch_name,b.je_batch_id',
' from apps.fa_book_controls@ADG bc,apps.fa_deprn_periods@ADG dp,',
' apps.xla_transaction_entities@ADG te,apps.xla_ae_headers@ADG ah,apps.gl_je_batches@ADG b,apps.gl_je_headers@ADG h',
' where bc.set_of_books_id in (1003,5001,10001) and bc.date_ineffective is null',
' and (cast(null as number) is null or bc.set_of_books_id=cast(null as number))',
' and (cast(null as varchar2(30)) is null or bc.book_type_code=cast(null as varchar2(30)))',
' and dp.book_type_code=bc.book_type_code and dp.period_name=NVL(UPPER(TRIM(REPLACE(:P71_PERIOD_NAME, ''''''''))),TO_CHAR(ADD_MONTHS(SYSDATE,-1),''MON-YYYY'',''NLS_DATE_LANGUAGE=ENGLISH''))',
' and te.application_id=140 and te.entity_code=''DEPRECIATION''',
' and te.ledger_id=bc.set_of_books_id and te.source_id_char_1=bc.book_type_code',
' and te.source_id_int_2=dp.period_counter',
' and ah.application_id=te.application_id and ah.entity_id=te.entity_id',
' and ah.ledger_id=te.ledger_id and ah.accounting_entry_status_code=''F''',
' and ah.group_id is not null and ah.gl_transfer_status_code=''Y''',
' and b.group_id=ah.group_id and h.je_batch_id=b.je_batch_id and h.ledger_id=te.ledger_id',
' and h.je_source=''Assets'' and h.je_category=''Depreciation'' and h.actual_flag=''A''',
' and h.period_name=dp.period_name) sj where sj.je_header_id=ir.je_header_id)',
' and xl.gl_sl_link_id (+)=ir.gl_sl_link_id and xl.gl_sl_link_table (+)=ir.gl_sl_link_table',
' and ah.application_id (+)=xl.application_id and ah.ae_header_id (+)=xl.ae_header_id',
' and te.application_id (+)=ah.application_id and te.entity_id (+)=ah.entity_id',
' group by ir.je_header_id,ir.je_line_num) m',
' where jl.je_header_id=j.je_header_id and m.je_header_id (+)=jl.je_header_id',
' and m.je_line_num (+)=jl.je_line_num) group by ledger_id,book_type_code,period_name) g',
' where s.ledger_id (+)=q.ledger_id and s.book_type_code (+)=q.book_type_code and s.period_name (+)=q.period_name',
' and g.ledger_id (+)=q.ledger_id and g.book_type_code (+)=q.book_type_code and g.period_name (+)=q.period_name',
' ) r) q'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_PERIOD_NAME,P71_LEDGER_IDS,P71_BOOK_CLASS'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(15258367436524983)
,p_no_data_found_message=>'No books match the selected filters.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_fixed_header=>'REGION'
,p_fixed_header_max_height=>560
,p_lazy_loading=>true
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:XLSX'
,p_enable_mail_download=>'N'
,p_internal_uid=>15258367436524983
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15261706369524983)
,p_db_column_name=>'ACTIVITY_NOTE'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Activity Note'
,p_column_html_expression=>'<span class="fa71-activity">#ACTIVITY_NOTE#</span>'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15259562752524983)
,p_db_column_name=>'BOOK_CLASS'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Book Class'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15259418956524983)
,p_db_column_name=>'BOOK_TYPE_CODE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'FA Book'
,p_column_link=>'#BRIDGE_URL#'
,p_column_linktext=>'#BOOK_TYPE_CODE#'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15263238529525003)
,p_db_column_name=>'BRIDGE_URL'
,p_display_order=>420
,p_column_identifier=>'AP'
,p_column_label=>'Bridge Url'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15261841015524983)
,p_db_column_name=>'CLOSE_STATUS'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Close Status'
,p_column_html_expression=>'<span class="fa71-status">#CLOSE_STATUS#</span>'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15259359162524983)
,p_db_column_name=>'CURRENCY_CODE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Currency'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15259620579524983)
,p_db_column_name=>'DEPRN_CALENDAR'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Calendar'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15260527640524983)
,p_db_column_name=>'DEPRN_EVENTS'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Deprn Events'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15260091927524983)
,p_db_column_name=>'DEPRN_RUN'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Depreciation Run'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15260784043524983)
,p_db_column_name=>'ENTRIES_NOT_FINAL'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Entries Not Final'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15260808274524983)
,p_db_column_name=>'ENTRIES_NOT_TRANSFERRED'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Entries Not Transferred'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15260477298524983)
,p_db_column_name=>'FA_CATCHUP_AMOUNT'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'FA Catch-up'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15260332623524983)
,p_db_column_name=>'FA_DEPRN_AMOUNT'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'FA Net Depreciation'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15263495051525003)
,p_db_column_name=>'FA_NEGATIVE_DEPRN'
,p_display_order=>440
,p_column_identifier=>'AR'
,p_column_label=>'Fa Negative Deprn'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15260211937524983)
,p_db_column_name=>'FA_NONZERO_ROWS'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Fa Nonzero Rows'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15263324026525003)
,p_db_column_name=>'FA_POSITIVE_DEPRN'
,p_display_order=>430
,p_column_identifier=>'AQ'
,p_column_label=>'Fa Positive Deprn'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15260174028524983)
,p_db_column_name=>'FA_SUMMARY_ROWS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Fa Summary Rows'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15261535805524983)
,p_db_column_name=>'FA_VS_GL_DR_DIFF'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Net FA vs Gross Debits (Legacy)'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15263060020525003)
,p_db_column_name=>'FA_VS_GL_EXPENSE_DIFF'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'FA vs GL Difference'
,p_column_link=>'#BRIDGE_URL#'
,p_column_linktext=>'#FA_VS_GL_EXPENSE_DIFF#'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15261697566524983)
,p_db_column_name=>'GL_BATCH_NAMES'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'GL Batches'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15260924034524983)
,p_db_column_name=>'GL_GROUPS_EXPECTED'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Gl Groups Expected'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15261065340524983)
,p_db_column_name=>'GL_GROUPS_MISSING'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Gl Groups Missing'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15261230338524983)
,p_db_column_name=>'GL_JOURNALS'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Gl Journals'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15261403211524983)
,p_db_column_name=>'GL_JOURNAL_DR_TOTAL'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Whole Journal Debit Total'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15262739287524983)
,p_db_column_name=>'GL_LINE_COUNT'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Gl Line Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15262808412524983)
,p_db_column_name=>'GL_MAPPING_ISSUES'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'GL Mapping Issues'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15262525707524983)
,p_db_column_name=>'GL_POSTED_EXPENSE_CR'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Gl Posted Expense Cr'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15262484794524983)
,p_db_column_name=>'GL_POSTED_EXPENSE_DR'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Gl Posted Expense Dr'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15262967202524983)
,p_db_column_name=>'GL_POSTED_EXPENSE_LINES'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'Gl Posted Expense Lines'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15262601523524983)
,p_db_column_name=>'GL_POSTED_EXPENSE_NET'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Posted GL Net Expense'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15261175918524983)
,p_db_column_name=>'GL_SHARED_GROUPS'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Shared GL Groups'
,p_column_html_expression=>'<span class="fa71-indicator">#GL_SHARED_GROUPS#</span>'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15261387263524983)
,p_db_column_name=>'GL_UNPOSTED'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Gl Unposted'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15259144676524983)
,p_db_column_name=>'LEDGER_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Ledger Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15259203136524983)
,p_db_column_name=>'LEDGER_NAME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Ledger'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15262306037524983)
,p_db_column_name=>'ORPHAN_ASSET_LINES'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Orphan Asset Lines'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15259902941524983)
,p_db_column_name=>'PERIOD_CLOSE_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Period Close Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH24:MI:SS'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15259791905524983)
,p_db_column_name=>'PERIOD_NAME'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Period'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15259878540524983)
,p_db_column_name=>'PERIOD_STATUS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Period Status'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15263120539525003)
,p_db_column_name=>'RECONCILIATION_STATUS'
,p_display_order=>410
,p_column_identifier=>'AO'
,p_column_label=>'Reconciliation'
,p_column_html_expression=>'<span class="fa71-reconciliation">#RECONCILIATION_STATUS#</span>'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15262082613524983)
,p_db_column_name=>'SLA_EXPENSE_CR'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Sla Expense Cr'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15261923057524983)
,p_db_column_name=>'SLA_EXPENSE_DR'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Sla Expense Dr'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15262265840524983)
,p_db_column_name=>'SLA_EXPENSE_LINES'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Sla Expense Lines'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15262148156524983)
,p_db_column_name=>'SLA_EXPENSE_NET'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'SLA Net Expense'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15263549705525003)
,p_db_column_name=>'SLA_PERIOD_MISMATCH_LINES'
,p_display_order=>450
,p_column_identifier=>'AS'
,p_column_label=>'Sla Period Mismatch Lines'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15263616456525003)
,p_db_column_name=>'SLA_UNLINKED_LINES'
,p_display_order=>460
,p_column_identifier=>'AT'
,p_column_label=>'Sla Unlinked Lines'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15260604713524983)
,p_db_column_name=>'UNACCOUNTED_EVENTS'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Unaccounted Events'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(15258429503524983)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'fa-close-primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>25
,p_report_columns=>'LEDGER_NAME:BOOK_TYPE_CODE:PERIOD_NAME:CURRENCY_CODE:CLOSE_STATUS:FA_DEPRN_AMOUNT:SLA_EXPENSE_NET:GL_POSTED_EXPENSE_NET:FA_VS_GL_EXPENSE_DIFF:RECONCILIATION_STATUS'
,p_sort_column_1=>'LEDGER_NAME'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'BOOK_CLASS'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'BOOK_TYPE_CODE'
,p_sort_direction_3=>'ASC'
,p_break_on=>'LEDGER_NAME'
,p_break_enabled_on=>'LEDGER_NAME'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(15258522740524983)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(15258152637524983)
,p_button_name=>'REFRESH'
,p_static_id=>'refresh'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Refresh'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_button_css_classes=>'fa71-refresh'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15259005952524983)
,p_name=>'P71_BOOK_CLASS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(15258152637524983)
,p_item_default=>'CORPORATE'
,p_prompt=>'Book class'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Corporate;CORPORATE,Tax;TAX'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'All book classes'
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_grid_label_column_span=>0
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15258986276524983)
,p_name=>'P71_LEDGER_IDS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(15258152637524983)
,p_item_default=>'1003:5001:10001'
,p_prompt=>'Ledgers'
,p_placeholder=>'All in-scope ledgers'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>'select name d,to_char(ledger_id) r from apps.gl_ledgers@ADG where object_type_code=''L'' and ledger_id in (1003,5001,10001) order by name'
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_grid_label_column_span=>0
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'NOT_ENTERABLE',
  'initial_fetch', 'FIRST_ROWSET',
  'manual_entry', 'N',
  'multiple', 'Y')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15258807836524983)
,p_name=>'P71_PERIOD_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(15258152637524983)
,p_prompt=>'Period'
,p_placeholder=>'Previous month'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>'select dp.period_name d,dp.period_name r from apps.fa_deprn_periods@ADG dp,apps.fa_book_controls@ADG bc where bc.book_type_code=dp.book_type_code and bc.set_of_books_id in (1003,5001,10001) and bc.date_ineffective is null and dp.period_open_date>add_'
||'months(sysdate,-24) group by dp.period_name order by max(dp.period_counter) desc'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'Previous month'
,p_colspan=>4
,p_grid_label_column_span=>0
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'NOT_ENTERABLE',
  'initial_fetch', 'FIRST_ROWSET',
  'manual_entry', 'N',
  'multiple', 'N')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(15258690378524983)
,p_process_sequence=>5
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Normalize Fixed Assets filters'
,p_static_id=>'normalize-fixed-assets-filters'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare old_value varchar2(4000):=:P71_LEDGER_IDS; valid_value varchar2(4000);begin',
' select listagg(column_value,'':'') within group(order by column_value) into valid_value from (select distinct column_value from table(apex_string.split(old_value,'':'')) where column_value in (''1003'',''5001'',''10001''));',
' if old_value is not null and valid_value is null then valid_value:=''1003:5001:10001'';end if;',
' :P71_LEDGER_IDS:=valid_value;',
' if :P71_BOOK_CLASS is not null and :P71_BOOK_CLASS not in (''CORPORATE'',''TAX'') then :P71_BOOK_CLASS:=''CORPORATE'';end if;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>15258690378524983
);
wwv_flow_imp.component_end;
end;
/
