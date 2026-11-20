prompt --application/pages/page_00072
begin
--   Manifest
--     PAGE: 00072
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
 p_id=>72
,p_name=>'Fixed Assets Accounting Bridge'
,p_alias=>'FIXED-ASSETS-BRIDGE'
,p_page_mode=>'MODAL'
,p_step_title=>'Fixed Assets Accounting Bridge'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code_onload=>'(function(){const $=apex.jQuery;function decorate(){document.querySelectorAll(''.fa72-activity'').forEach(el=>el.classList.toggle(''fa72-negative'',el.textContent.trim()===''NEGATIVE DEPRECIATION''));}function explainSlaLink(){const help="MAPPED: GL line r'
||'eferences resolve consistently to SLA depreciation for the selected FA book, ledger and period, with one accounting class. REVIEW MAPPING: references are missing, unresolved or span conflicting books, ledgers, periods or accounting classes. A GL line'
||' may summarize multiple assets; posting status is checked separately.";document.querySelectorAll(''#fa72-gl-lines th'').forEach(th=>{const link=th.querySelector(''a'');if((link?link.textContent:th.textContent).trim()===''SLA Link Status''){th.title=help;if'
||'(link){link.title=help;link.setAttribute(''aria-label'',''SLA Link Status. ''+help);}}});}$(''#fa72-assets'').on(''apexafterrefresh'',decorate);$(''#fa72-gl-lines'').on(''apexafterrefresh'',explainSlaLink);decorate();explainSlaLink();})();'
,p_inline_css=>'.fa72-context h2{margin-top:0}.fa72-subtle{font-size:12px;opacity:.8}.fa72-stage{width:100%;border-collapse:collapse;margin:12px 0}.fa72-stage th,.fa72-stage td{padding:9px 12px;border-bottom:1px solid var(--ut-component-border-color,#ddd)}.fa72-stag'
||'e td:not(:first-child),.fa72-stage th:not(:first-child){text-align:right}.fa72-status{padding:6px 10px;border-radius:4px;display:inline-block;font-weight:600}.fa72-good{background:#e6f4eb;color:#185c37}.fa72-warn{background:#fff1d6;color:#704500}.fa7'
||'2-negative{background:#fff1d6;color:#704500;font-weight:600;padding:3px 6px;border-radius:3px}.fa72-diff{font-weight:600}#fa72-assets .a-IRR-tableContainer,#fa72-gl-lines .a-IRR-tableContainer{max-height:420px;overflow:auto}#fa72-assets .a-IRR-header'
||',#fa72-gl-lines .a-IRR-header{font-weight:700;text-align:center}'
,p_step_template=>2103835248774687739
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(18558063129193156)
,p_dialog_title=>'Fixed Assets Accounting Bridge'
,p_dialog_height=>'850'
,p_dialog_width=>'1450'
,p_dialog_chained=>'N'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(15400188370111723)
,p_plug_name=>'Actual GL Journal Lines'
,p_static_id=>'actual-gl-journal-lines'
,p_region_name=>'fa72-gl-lines'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>30
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select l.*,(select cc.concatenated_segments from apps.gl_code_combinations_kfv@ADG cc where cc.code_combination_id=l.code_combination_id) account_code from (select j.ledger_id,j.book_type_code,j.period_name,j.je_header_id,j.journal_name,j.batch_name,'
||'j.status,',
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
' and (:P72_LEDGER_ID is null or bc.set_of_books_id=:P72_LEDGER_ID)',
' and (:P72_BOOK_TYPE_CODE is null or bc.book_type_code=:P72_BOOK_TYPE_CODE)',
' and dp.book_type_code=bc.book_type_code and dp.period_name=:P72_PERIOD_NAME',
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
' and (:P72_LEDGER_ID is null or bc.set_of_books_id=:P72_LEDGER_ID)',
' and (:P72_BOOK_TYPE_CODE is null or bc.book_type_code=:P72_BOOK_TYPE_CODE)',
' and dp.book_type_code=bc.book_type_code and dp.period_name=:P72_PERIOD_NAME',
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
' and m.je_line_num (+)=jl.je_line_num) l',
'order by je_header_id,je_line_num'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P72_LEDGER_ID,P72_BOOK_TYPE_CODE,P72_PERIOD_NAME'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(15403299931111723)
,p_no_data_found_message=>'No rows for this book and period.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_fixed_header=>'REGION'
,p_fixed_header_max_height=>420
,p_lazy_loading=>true
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:XLSX'
,p_enable_mail_download=>'N'
,p_internal_uid=>15403299931111723
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15404366869111723)
,p_db_column_name=>'ACCOUNTED_CR'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'GL Credit'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15404222754111723)
,p_db_column_name=>'ACCOUNTED_DR'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'GL Debit'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15404457861111723)
,p_db_column_name=>'ACCOUNTING_CLASS_CODE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Accounting Class'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15404617244111723)
,p_db_column_name=>'ACCOUNT_CODE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Account'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15403840117111723)
,p_db_column_name=>'BATCH_NAME'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Batch'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15403452486111723)
,p_db_column_name=>'BOOK_TYPE_CODE'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'FA Book'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15404126525111723)
,p_db_column_name=>'CODE_COMBINATION_ID'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Account Combination ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15403686863111723)
,p_db_column_name=>'JE_HEADER_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Journal ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15404042804111723)
,p_db_column_name=>'JE_LINE_NUM'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Line'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15403763507111723)
,p_db_column_name=>'JOURNAL_NAME'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Journal'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15403334405111723)
,p_db_column_name=>'LEDGER_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Ledger ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15404577741111723)
,p_db_column_name=>'MAPPING_STATUS'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'SLA Link Status'
,p_column_html_expression=>'<span class="fa72-sla-link" tabindex="0" title="MAPPED: GL line references resolve consistently to SLA depreciation for the selected FA book, ledger and period, with one accounting class. REVIEW MAPPING: references are missing, unresolved or span con'
||'flicting books, ledgers, periods or accounting classes. A GL line may summarize multiple assets; posting status is checked separately." aria-label="#MAPPING_STATUS#. MAPPED: GL line references resolve consistently to SLA depreciation for the selected'
||' FA book, ledger and period, with one accounting class. REVIEW MAPPING: references are missing, unresolved or span conflicting books, ledgers, periods or accounting classes. A GL line may summarize multiple assets; posting status is checked separatel'
||'y.">#MAPPING_STATUS#</span>'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15403545537111723)
,p_db_column_name=>'PERIOD_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Period'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15403975088111723)
,p_db_column_name=>'STATUS'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Posting Status'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(15404797619111723)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'fa72-gl-lines-primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>25
,p_report_columns=>'JOURNAL_NAME:STATUS:JE_LINE_NUM:ACCOUNT_CODE:ACCOUNTING_CLASS_CODE:ACCOUNTED_DR:ACCOUNTED_CR:MAPPING_STATUS'
,p_sort_column_1=>'JE_HEADER_ID'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'JE_LINE_NUM'
,p_sort_direction_2=>'ASC'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(15400057446111723)
,p_plug_name=>'Asset Details'
,p_static_id=>'asset-details'
,p_region_name=>'fa72-assets'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>20
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT a.ledger_id,',
'       a.book_type_code,',
'       a.period_name,',
'       a.asset_id,',
'       a.asset_number,',
'       a.deprn_run_date,',
'       a.fa_deprn_amount,',
'       a.fa_catchup_amount,',
'       CASE WHEN a.fa_deprn_amount > 0 THEN a.fa_deprn_amount ELSE 0 END positive_deprn,',
'       CASE WHEN a.fa_deprn_amount < 0 THEN a.fa_deprn_amount ELSE 0 END negative_deprn,',
'       CASE WHEN a.fa_deprn_amount < 0 THEN ''NEGATIVE DEPRECIATION''',
'            WHEN a.fa_deprn_amount > 0 THEN ''POSITIVE DEPRECIATION''',
'            ELSE ''ZERO DEPRECIATION'' END activity_type,',
'       NVL(s.sla_expense_dr, 0) sla_expense_dr,',
'       NVL(s.sla_expense_cr, 0) sla_expense_cr,',
'       NVL(s.sla_expense_net, 0) sla_expense_net,',
'       NVL(s.posted_linked_sla_net, 0) posted_linked_sla_net,',
'       a.fa_deprn_amount - NVL(s.sla_expense_net, 0) fa_sla_difference,',
'       NVL(s.sla_expense_net, 0) - NVL(s.posted_linked_sla_net, 0) sla_posted_link_difference,',
'       NVL(s.sla_expense_lines, 0) sla_expense_lines,',
'       NVL(s.sla_period_mismatch_lines, 0) sla_period_mismatch_lines,',
'       NVL(s.posted_linked_lines, 0) posted_linked_lines,',
'       NVL(s.sla_expense_lines, 0) - NVL(s.posted_linked_lines, 0) unlinked_expense_lines',
'  FROM (SELECT bc.set_of_books_id ledger_id,',
'               ds.book_type_code,',
'               dp.period_name,',
'               ds.asset_id,',
'               ad.asset_number,',
'               MAX(ds.deprn_run_date) deprn_run_date,',
'               SUM(ds.deprn_amount - NVL(ds.deprn_adjustment_amount, 0)) fa_deprn_amount,',
'               SUM(NVL(ds.deprn_adjustment_amount, 0)) fa_catchup_amount',
'          FROM apps.fa_book_controls@ADG bc,',
'               apps.fa_deprn_periods@ADG dp,',
'               apps.fa_deprn_summary@ADG ds,',
'               apps.fa_additions_b@ADG ad',
'         WHERE bc.set_of_books_id IN (1003, 5001, 10001)',
'           AND bc.set_of_books_id = :P72_LEDGER_ID',
'           AND bc.book_type_code = :P72_BOOK_TYPE_CODE',
'           AND bc.date_ineffective IS NULL',
'           AND dp.book_type_code = bc.book_type_code',
'           AND dp.period_name = :P72_PERIOD_NAME',
'           AND ds.book_type_code = dp.book_type_code',
'           AND ds.period_counter = dp.period_counter',
'           AND ds.deprn_source_code = ''DEPRN''',
'           AND ad.asset_id (+) = ds.asset_id',
'         GROUP BY bc.set_of_books_id, ds.book_type_code, dp.period_name,',
'                  ds.asset_id, ad.asset_number) a,',
'       (SELECT q.ledger_id, q.book_type_code, q.asset_id,',
'               COUNT(*) sla_expense_lines,',
'               SUM(q.sla_period_mismatch) sla_period_mismatch_lines,',
'               SUM(q.accounted_dr) sla_expense_dr,',
'               SUM(q.accounted_cr) sla_expense_cr,',
'               SUM(q.accounted_dr - q.accounted_cr) sla_expense_net,',
'               SUM(q.posted_link) posted_linked_lines,',
'               SUM(CASE WHEN q.posted_link = 1 THEN q.accounted_dr - q.accounted_cr ELSE 0 END) posted_linked_sla_net',
'          FROM (SELECT te.ledger_id,',
'                       te.source_id_char_1 book_type_code,',
'                       te.source_id_int_1 asset_id,',
'                       CASE WHEN ah.period_name = dp.period_name THEN 0 ELSE 1 END sla_period_mismatch,',
'                       al.accounted_dr,',
'                       al.accounted_cr,',
'                       -- EXISTS counts an SLA line once even when references repeat or GL is summarized.',
'                       CASE WHEN EXISTS',
'                         (SELECT 1',
'                            FROM apps.gl_import_references@ADG ir,',
'                                 apps.gl_je_lines@ADG jl,',
'                                 apps.gl_je_headers@ADG jh',
'                           WHERE ir.gl_sl_link_id = al.gl_sl_link_id',
'                             AND ir.gl_sl_link_table = al.gl_sl_link_table',
'                             AND jl.je_header_id = ir.je_header_id',
'                             AND jl.je_line_num = ir.je_line_num',
'                             AND jh.je_header_id = jl.je_header_id',
'                             AND jh.ledger_id = te.ledger_id',
'                             AND jh.period_name = :P72_PERIOD_NAME',
'                             AND jh.je_source = ''Assets''',
'                             AND jh.je_category = ''Depreciation''',
'                             AND jh.actual_flag = ''A''',
'                             AND jh.status = ''P'') THEN 1 ELSE 0 END posted_link',
'                  FROM apps.fa_book_controls@ADG bc,',
'                       apps.fa_deprn_periods@ADG dp,',
'                       apps.xla_transaction_entities@ADG te,',
'                       apps.xla_ae_headers@ADG ah,',
'                       (SELECT application_id, ae_header_id, ae_line_num,',
'                               NVL(accounted_dr, 0) accounted_dr,',
'                               NVL(accounted_cr, 0) accounted_cr,',
'                               gl_sl_link_id, gl_sl_link_table',
'                          FROM apps.xla_ae_lines@ADG',
'                         WHERE application_id = 140',
'                           AND accounting_class_code = ''EXPENSE'') al',
'                 WHERE bc.set_of_books_id IN (1003, 5001, 10001)',
'                   AND bc.set_of_books_id = :P72_LEDGER_ID',
'                   AND bc.book_type_code = :P72_BOOK_TYPE_CODE',
'                   AND bc.date_ineffective IS NULL',
'                   AND dp.book_type_code = bc.book_type_code',
'                   AND dp.period_name = :P72_PERIOD_NAME',
'                   AND te.application_id = 140',
'                   AND te.ledger_id = bc.set_of_books_id',
'                   AND te.entity_code = ''DEPRECIATION''',
'                   AND te.source_id_char_1 = dp.book_type_code',
'                   AND te.source_id_int_2 = dp.period_counter',
'                   AND ah.application_id = te.application_id',
'                   AND ah.entity_id = te.entity_id',
'                   AND ah.ledger_id = te.ledger_id',
'                   AND ah.accounting_entry_status_code = ''F''',
'                   AND al.application_id = ah.application_id',
'                   AND al.ae_header_id = ah.ae_header_id) q',
'         GROUP BY q.ledger_id, q.book_type_code, q.asset_id) s',
' WHERE s.ledger_id (+) = a.ledger_id',
'   AND s.book_type_code (+) = a.book_type_code',
'   AND s.asset_id (+) = a.asset_id',
' ORDER BY CASE WHEN a.fa_deprn_amount < 0 THEN 0 ELSE 1 END,',
'          a.fa_deprn_amount, a.asset_number, a.asset_id'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P72_LEDGER_ID,P72_BOOK_TYPE_CODE,P72_PERIOD_NAME'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(15400921190111723)
,p_no_data_found_message=>'No rows for this book and period.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_fixed_header=>'REGION'
,p_fixed_header_max_height=>420
,p_lazy_loading=>true
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:XLSX'
,p_enable_mail_download=>'N'
,p_internal_uid=>15400921190111723
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15402092671111723)
,p_db_column_name=>'ACTIVITY_TYPE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Activity'
,p_column_html_expression=>'<span class="fa72-activity">#ACTIVITY_TYPE#</span>'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15401361576111723)
,p_db_column_name=>'ASSET_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Asset ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15401497393111723)
,p_db_column_name=>'ASSET_NUMBER'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Asset'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15401192521111723)
,p_db_column_name=>'BOOK_TYPE_CODE'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'FA Book'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15401526378111723)
,p_db_column_name=>'DEPRN_RUN_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Depreciation Run'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH24:MI:SS'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15401789578111723)
,p_db_column_name=>'FA_CATCHUP_AMOUNT'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'FA Catch-up'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15401626389111723)
,p_db_column_name=>'FA_DEPRN_AMOUNT'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'FA Net Depreciation'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15402586143111723)
,p_db_column_name=>'FA_SLA_DIFFERENCE'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'FA vs SLA Difference'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15401012155111723)
,p_db_column_name=>'LEDGER_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Ledger ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15401985999111723)
,p_db_column_name=>'NEGATIVE_DEPRN'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Negative Depreciation'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15401227195111723)
,p_db_column_name=>'PERIOD_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Period'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15401899232111723)
,p_db_column_name=>'POSITIVE_DEPRN'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Positive Depreciation'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15402829121111723)
,p_db_column_name=>'POSTED_LINKED_LINES'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Posted-linked Lines'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15402426637111723)
,p_db_column_name=>'POSTED_LINKED_SLA_NET'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Posted-linked SLA Expense'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15402275368111723)
,p_db_column_name=>'SLA_EXPENSE_CR'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'SLA Expense Credit'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15402143581111723)
,p_db_column_name=>'SLA_EXPENSE_DR'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'SLA Expense Debit'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15402770734111723)
,p_db_column_name=>'SLA_EXPENSE_LINES'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'SLA Expense Lines'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15402390778111723)
,p_db_column_name=>'SLA_EXPENSE_NET'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'SLA Net Expense'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15403083933111723)
,p_db_column_name=>'SLA_PERIOD_MISMATCH_LINES'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Accounting-period Mismatch Lines'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15402629478111723)
,p_db_column_name=>'SLA_POSTED_LINK_DIFFERENCE'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'SLA vs Posted-link Difference'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15402973197111723)
,p_db_column_name=>'UNLINKED_EXPENSE_LINES'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Unlinked Expense Lines'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(15403177613111723)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'fa72-assets-primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>25
,p_report_columns=>'ASSET_NUMBER:ACTIVITY_TYPE:FA_DEPRN_AMOUNT:SLA_EXPENSE_DR:SLA_EXPENSE_CR:SLA_EXPENSE_NET:POSTED_LINKED_SLA_NET:FA_SLA_DIFFERENCE:SLA_POSTED_LINK_DIFFERENCE:UNLINKED_EXPENSE_LINES'
,p_sort_column_1=>'FA_DEPRN_AMOUNT'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'ASSET_NUMBER'
,p_sort_direction_2=>'ASC'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(15399985153111723)
,p_plug_name=>'FA to SLA to GL Bridge'
,p_static_id=>'fa-to-sla-to-gl-bridge'
,p_region_name=>'fa72-bridge'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>10
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
' function f(v number) return varchar2 is begin return case when v is null then ''&mdash;'' else to_char(v,''FM999G999G999G999G990D00'') end;end;',
' procedure stage(label varchar2,dr number,cr number,net number) is begin htp.p(''<tr><th scope="row">''||apex_escape.html(label)||''</th><td>''||f(dr)||''</td><td>''||f(cr)||''</td><td>''||f(net)||''</td></tr>'');end;',
'begin',
' for r in (select r.*,',
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
'       NVL(dp.period_name, NVL(UPPER(TRIM(REPLACE(:P72_PERIOD_NAME, ''''''''))),',
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
'           AND dp2.period_name     = NVL(UPPER(TRIM(REPLACE(:P72_PERIOD_NAME, ''''''''))),',
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
'                          AND dp3.period_name = NVL(UPPER(TRIM(REPLACE(:P72_PERIOD_NAME, ''''''''))),',
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
'                                          AND dp4.period_name = NVL(UPPER(TRIM(REPLACE(:P72_PERIOD_NAME, ''''''''))),',
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
'                 WHERE h.period_name = NVL(UPPER(TRIM(REPLACE(:P72_PERIOD_NAME, ''''''''))),',
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
'   AND (cast(null as varchar2(30)) IS NULL OR bc.book_class = UPPER(TRIM(REPLACE(cast(null as varchar2(30)), ''''''''))))',
'   -- ledger filter: whole numeric tokens only (separators: comma, semicolon, colon, space)',
'   AND (TRIM(REPLACE(:P72_LEDGER_ID, '''''''')) IS NULL',
'        OR bc.set_of_books_id IN (SELECT TO_NUMBER(CASE WHEN REGEXP_LIKE(t.tok, ''^[0-9]{1,15}$'') THEN t.tok END)',
'                                    FROM (SELECT REGEXP_SUBSTR(REPLACE(:P72_LEDGER_ID, ''''''''), ''[^,;: ]+'', 1, LEVEL) tok',
'                                            FROM dual@ADG',
'                                         CONNECT BY REGEXP_SUBSTR(REPLACE(:P72_LEDGER_ID, ''''''''), ''[^,;: ]+'', 1, LEVEL) IS NOT NULL) t))',
'   -- outer join: a book without the requested period still shows as PERIOD NOT FOUND',
'   AND dp.book_type_code (+) = bc.book_type_code',
'   AND dp.period_name    (+) = NVL(UPPER(TRIM(REPLACE(:P72_PERIOD_NAME, ''''''''))),',
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
' and (:P72_LEDGER_ID is null or bc.set_of_books_id=:P72_LEDGER_ID)',
' and (:P72_BOOK_TYPE_CODE is null or bc.book_type_code=:P72_BOOK_TYPE_CODE)',
' and dp.book_type_code=bc.book_type_code and dp.period_name=:P72_PERIOD_NAME',
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
' and (:P72_LEDGER_ID is null or bc.set_of_books_id=:P72_LEDGER_ID)',
' and (:P72_BOOK_TYPE_CODE is null or bc.book_type_code=:P72_BOOK_TYPE_CODE)',
' and dp.book_type_code=bc.book_type_code and dp.period_name=:P72_PERIOD_NAME',
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
' and (:P72_LEDGER_ID is null or bc.set_of_books_id=:P72_LEDGER_ID)',
' and (:P72_BOOK_TYPE_CODE is null or bc.book_type_code=:P72_BOOK_TYPE_CODE)',
' and dp.book_type_code=bc.book_type_code and dp.period_name=:P72_PERIOD_NAME',
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
' and q.ledger_id=:P72_LEDGER_ID and q.book_type_code=:P72_BOOK_TYPE_CODE) r) loop',
' htp.p(''<div class="fa72-context"><h2>''||apex_escape.html(r.book_type_code)||'' &middot; ''||apex_escape.html(r.period_name)||''</h2><p>''||apex_escape.html(r.ledger_name)||'' &middot; ''||apex_escape.html(r.currency_code)||'' &middot; Close status: ''||apex'
||'_escape.html(r.close_status)||''</p>'');',
' htp.p(''<span class="fa72-status ''||case when r.reconciliation_status=''MATCHED'' then ''fa72-good'' else ''fa72-warn'' end||''">''||apex_escape.html(r.reconciliation_status)||''</span>'');',
' htp.p(''<table class="fa72-stage" aria-label="FA to SLA to GL amount bridge"><thead><tr><th>Stage</th><th>Positive / Debit</th><th>Negative / Credit</th><th>Net amount</th></tr></thead><tbody>'');',
' stage(''FA depreciation excluding catch-up'',r.fa_positive_deprn,abs(r.fa_negative_deprn),r.fa_deprn_amount);',
' stage(''Final SLA depreciation expense'',r.sla_expense_dr,r.sla_expense_cr,r.sla_expense_net);',
' stage(''Posted GL depreciation expense'',r.gl_posted_expense_dr,r.gl_posted_expense_cr,r.gl_posted_expense_net);',
' stage(''FA minus posted GL expense'',null,null,r.fa_vs_gl_expense_diff);',
' htp.p(''</tbody></table>'');',
' if r.reconciliation_status=''MATCHED'' and nvl(r.fa_negative_deprn,0)<0 and round(r.fa_vs_gl_dr_diff-2*r.fa_negative_deprn,2)=0 and r.gl_shared_groups=0 then',
' htp.p(''<p><strong>Explained: negative depreciation.</strong> Negative depreciation totals ''||f(r.fa_negative_deprn)||'' ''||apex_escape.html(r.currency_code)||''. It credits expense and debits the asset reserve. The whole-journal debit total of ''||f(r.'
||'gl_journal_dr_total)||'' therefore exceeds net FA depreciation by ''||f(-r.fa_vs_gl_dr_diff)||''. The net expense comparison above matches.</p>'');',
' end if;',
' htp.p(''<p class="fa72-subtle">FA catch-up excluded from this depreciation bridge: ''||f(r.fa_catchup_amount)||''. GL lines inspected: ''||r.gl_line_count||''; mapping issues: ''||r.gl_mapping_issues||''; SLA expense lines without an FA asset row: ''||r.orp'
||'han_asset_lines||''; expense lines not linked to posted GL: ''||r.sla_unlinked_lines||''; accounting-period mismatches: ''||r.sla_period_mismatch_lines||''.</p>'');',
' if r.gl_mapping_issues>0 or r.orphan_asset_lines>0 or r.sla_unlinked_lines>0 or r.sla_period_mismatch_lines>0 then htp.p(''<p class="fa72-status fa72-warn">Review the unmapped, shared, unposted, or period-mismatched entries below. A complete reconcil'
||'iation cannot be established.</p>'');end if;',
' htp.p(''<p class="fa72-subtle">GL journals can summarize multiple assets. Asset amounts below show SLA expense linked to posted GL; actual GL line totals are listed separately. Negative asset costs require a separate business review.</p></div>'');',
' end loop;',
'end;'))
,p_plug_source_type=>'NATIVE_PLSQL'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(15400306008111723)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(15399985153111723)
,p_button_name=>'CLOSE_BRIDGE'
,p_static_id=>'close-bridge'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4075790603270660137
,p_button_image_alt=>'Back to Fixed Assets'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-arrow-left'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15400774650111723)
,p_name=>'P72_BOOK_TYPE_CODE'
,p_item_sequence=>20
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15400624678111723)
,p_name=>'P72_LEDGER_ID'
,p_item_sequence=>10
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15400877747111723)
,p_name=>'P72_PERIOD_NAME'
,p_item_sequence=>30
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(15400409446111723)
,p_name=>'Close accounting bridge'
,p_static_id=>'close-accounting-bridge'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(15400306008111723)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15400578105111723)
,p_event_id=>wwv_flow_imp.id(15400409446111723)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'apex.navigation.dialog.close(true);')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(15400238390111723)
,p_process_sequence=>5
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Validate Fixed Assets context'
,p_static_id=>'validate-fixed-assets-context'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare n number;begin',
' if :P72_LEDGER_ID is null or :P72_LEDGER_ID not in (''1003'',''5001'',''10001'') or :P72_BOOK_TYPE_CODE is null or :P72_PERIOD_NAME is null or length(:P72_PERIOD_NAME)>30 then raise_application_error(-20072,''Open an in-scope book from Fixed Assets.'');end '
||'if;',
' select count(*) into n from apps.fa_book_controls@ADG bc where bc.set_of_books_id in(1003,5001,10001) and bc.set_of_books_id=to_number(:P72_LEDGER_ID) and bc.book_type_code=:P72_BOOK_TYPE_CODE and bc.date_ineffective is null;',
' if n<>1 then raise_application_error(-20073,''The selected book does not belong to the selected ledger.'');end if;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>15400238390111723
);
wwv_flow_imp.component_end;
end;
/
