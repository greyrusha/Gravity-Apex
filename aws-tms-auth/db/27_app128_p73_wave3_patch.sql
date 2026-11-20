prompt --application/set_environment
set define off verify off feedback off
set autocommit off
begin
  if user <> 'GL_ACCOUNTS' or sys_context('USERENV', 'CURRENT_SCHEMA') <> 'GL_ACCOUNTS' then
    raise_application_error(-20997, 'ABORT: Wave 3 Page 73 patch must run as GL_ACCOUNTS, got ' || user);
  end if;
end;
/
whenever sqlerror continue none
begin
  apex_application_install.clear_all;
  wwv_flow_imp.import_begin (
   p_version_yyyy_mm_dd=>'2026.04.07'
  ,p_release=>'26.2.0'
  ,p_default_workspace_id=>100789
  ,p_default_application_id=>128
  ,p_default_id_offset=>9401733729708713
  ,p_default_owner=>'GL_ACCOUNTS'
  );
  if wwv_flow.g_flow_id <> 128 then
    apex_application_install.clear_all;
    raise_application_error(-20999, 'Unexpected g_flow_id=' || nvl(to_char(wwv_flow.g_flow_id), 'NULL'));
  end if;
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/
prompt --application/pages/delete_00073
begin
  wwv_flow_imp_page.remove_page(p_flow_id=>wwv_flow.g_flow_id, p_page_id=>73);
end;
/
prompt --application/pages/page_00073
begin
wwv_flow_imp_page.create_page(
 p_id=>73
,p_name=>'Inventory Reconciliation'
,p_alias=>'INVENTORY-RECONCILIATION'
,p_step_title=>'Inventory Reconciliation'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function inv73AssessOwnerScope(ownerRows, selectedIds) {',
'const selected = new Set(Array.from(selectedIds || [], String));',
'const accounts = new Map(), intransitMembers = new Set();',
'const confirmedSetupEvidence = new Set([''ORG DEFAULT'',''ASSET SUBINVENTORY'',''WIP CLASS'',''WIP JOB'',''ORG INTRANSIT DEFAULT'']);',
'for (const source of ownerRows || []) {',
'const ccid = String(source.CCID), org = String(source.ORG_ID);',
'if (String(source.BUCKET_CCID) === ''-2'') intransitMembers.add(org);',
'if (!accounts.has(ccid)) accounts.set(ccid,{account:source.ACCOUNT,ccid,kinds:new Set(),members:new Map(),intransit:false});',
'const group = accounts.get(ccid);',
'group.kinds.add(source.KIND);',
'group.intransit = group.intransit || source.KIND === ''I'' || String(source.BUCKET_CCID) === ''-2'';',
'if (!group.members.has(org)) group.members.set(org,{...source,evidence:new Set(),configuredEvidence:new Set(),candidateOnly:false});',
'const member = group.members.get(org);',
'for (const evidence of String(source.EVIDENCE || '''').split('';'').map(value=>value.trim()).filter(Boolean)) {member.evidence.add(evidence);if(source.CONFIGURED===''Y'')member.configuredEvidence.add(evidence);}',
'member.candidateOnly = member.evidence.size > 0 && [...member.evidence].every(value=>value === ''INTERORG PAIR CANDIDATE'');',
'}',
'const selectedIntransit = [...intransitMembers].filter(org=>selected.has(org));',
'const unknownIntransitAccounts = [...accounts.values()].filter(group=>group.intransit&&/^[0-9]+$/.test(group.ccid)&&group.ccid!==''0''&&![...group.members.values()].some(member=>[...member.configuredEvidence].some(evidence=>confirmedSetupEvidence.has(e'
||'vidence))));',
'return {',
'groups:[...accounts.values()].filter(group=>group.members.size>1).sort((a,b)=>String(a.account).localeCompare(String(b.account))),',
'intransitMembers,',
'unknownIntransitAccounts,',
'selectedIntransitCount:selectedIntransit.length,',
'intransitComplete:intransitMembers.size > 0 && selectedIntransit.length === intransitMembers.size',
'};',
'}',
'if (typeof module !== ''undefined'' && module.exports) module.exports = inv73AssessOwnerScope;',
'function inv73EligibleOrgIds(readinessRows, ouId) {',
'return new Set((readinessRows||[]).filter(row=>row.ELIGIBLE===''Y''&&String(row.OU_ID)===String(ouId)).map(row=>String(row.ORG_ID)));',
'}',
'if (typeof module !== ''undefined'' && module.exports) module.exports.eligibleOrgIds = inv73EligibleOrgIds;',
'function inv73AssessSelectionGate(readinessRows, selectedIds) {',
'const selected=new Set(Array.from(selectedIds||[],String));',
'const rows=new Map((readinessRows||[]).map(row=>[String(row.ORG_ID),row]));',
'const groups=new Map();',
'for(const id of selected){',
'const row=rows.get(id);if(!row)continue;',
'const ids=[...new Set(String(row.OWNERSHIP_GROUP_IDS||'''').split('':'').filter(Boolean))].sort();',
'if(ids.length<2&&row.OWNERSHIP_BLOCKED!==''Y''&&row.OWNERSHIP_STATUS!==''SHARED'')continue;',
'const key=ids.length?ids.join('':''):''MISSING:''+id;',
'if(!groups.has(key))groups.set(key,{ids,selectedCodes:[],missing:[],permanentBlock:false,blockerCodes:row.OWNERSHIP_BLOCKER_CODES||'''',invalid:!ids.length});',
'const group=groups.get(key);group.selectedCodes.push(String(row.ORG_CODE||id));',
'group.permanentBlock=group.permanentBlock||row.OWNERSHIP_BLOCKED===''Y'';',
'}',
'const problems=[],blockedSelectedIds=new Set();',
'for(const group of groups.values()){',
'group.missing=group.ids.filter(id=>!selected.has(id)).map(id=>{const row=rows.get(id);return {id,code:row?String(row.ORG_CODE||id):id,eligible:Boolean(row&&row.ELIGIBLE===''Y''),reason:row&&row.ELIGIBLE!==''Y''?(row.EXCLUSION_REASON||row.READINESS_STATUS'
||'||''Outside eligible OU scope''):''''};});',
'if(group.missing.length||group.permanentBlock||group.invalid){problems.push(group);if(group.permanentBlock)group.ids.forEach(id=>{if(selected.has(id))blockedSelectedIds.add(id);});}',
'}',
'return {blocked:problems.length>0,problems,blockedSelectedIds};',
'}',
'if (typeof module !== ''undefined'' && module.exports) module.exports.selectionGate=inv73AssessSelectionGate;',
'',
'function inv73CreateOnhandController() {',
'const byId=id=>document.getElementById(id),esc=value=>apex.util.escapeHTML(value==null?'''':String(value));',
'let capture='''',page=1,total=0,rows=[],orgRows=new Map(),subRows=new Map(),openAccounts=new Set(),openOrgs=new Set(),orgPages=new Map(),subPages=new Map(),childRequests=new Map(),generation=0,listRequest=0,pending=false;',
unistr('const amount=(row,key)=>row[key+''_DISPLAY'']==null?''\2014'':String(row[key+''_DISPLAY'']);'),
'const key=(ccid,org)=>String(ccid)+(org==null||org===''''?'''':'':''+String(org));',
'const notice=(text,error)=>{const el=byId(''inv73-stock-message'');el.hidden=!text;el.textContent=text||'''';el.classList.toggle(''inv73-error'',Boolean(error));};',
'const orgValue=()=>byId(''inv73-stock-org'').value||'''';',
'async function request(action,ccid,org,requestedPage){',
'const pin=capture,serial=generation;',
'const response=await apex.server.process(''P73_ONHAND'',{x01:action,x02:pin,x03:ccid==null?'''':String(ccid),x04:org==null?orgValue():String(org),x05:String(requestedPage||1),x06:byId(''inv73-stock-all'').checked?''Y'':''N''},{dataType:''json''});',
'if(serial!==generation||pin!==capture)return null;',
'if(!response||response.ok!==true)throw Error(response&&response.message||''Unable to read the captured on-hand detail.'');',
'if(response.capture_collection!==pin)throw Error(''The capture changed. Reload the successful capture before viewing detail.'');',
'return response;',
'}',
'function focusControl(selector){const root=byId(''inv73-stock-view''),el=root&&root.querySelector?root.querySelector(selector):null;if(el&&!el.disabled)el.focus();}',
'function focusSelector(el){const data=el&&el.dataset;if(!data)return null;if(data.stockAccount)return ''[data-stock-account="''+data.stockAccount+''"]'';if(data.stockOrg)return ''[data-stock-org="''+data.stockOrg+''"][data-ccid="''+data.ccid+''"]'';if(data.sto'
||'ckPage)return ''[data-stock-page="''+data.stockPage+''"][data-ccid="''+data.ccid+''"][data-org="''+(data.org||'''')+''"][data-stock-direction="''+data.stockDirection+''"]'';return null;}',
'function pageControls(kind,ccid,org,current,count){if(count<=25)return '''';return ''<tr class="inv73-stock-detail"><td colspan="5"><button type="button" class="t-Button t-Button--small" data-stock-page="''+kind+''" data-stock-direction="prev" data-ccid="'
||unistr('''+esc(ccid)+''" data-org="''+esc(org||'''')+''" data-page="''+(current-1)+''" ''+(current===1?''disabled'':'''')+''>Previous ''+(kind===''ORGS''?''orgs'':''subinventories'')+''</button> <span>''+((current-1)*25+1)+''\2013''+Math.min(current*25,count)+'' of ''+count+''</span> <butt')
||'on type="button" class="t-Button t-Button--small" data-stock-page="''+kind+''" data-stock-direction="next" data-ccid="''+esc(ccid)+''" data-org="''+esc(org||'''')+''" data-page="''+(current+1)+''" ''+(current*25>=count?''disabled'':'''')+''>Next ''+(kind===''ORGS''?''or'
||'gs'':''subinventories'')+''</button></td></tr>'';}',
'function render(){',
'const body=byId(''inv73-stock-rows''),restoreFocus=focusSelector(document.activeElement);',
'body.innerHTML=rows.length?rows.map(row=>{',
'const ccid=String(row.CCID),open=openAccounts.has(ccid),unavailable=row.COMPARISON_STATUS!==''AVAILABLE'';',
'const basis=String(row.BASIS_STATUS||''''),uses=[/WIP/.test(basis)?''WIP'':'''',/INTRANSIT/.test(basis)?''intransit'':''''].filter(Boolean);',
unistr('const context=unavailable&&row.GL_END_BALANCE==null&&row.FULL_LEDGER_GL_END_BALANCE_DISPLAY!=null?''<span class="inv73-stock-caption">Account GL: ''+esc(row.FULL_LEDGER_GL_END_BALANCE_DISPLAY)+''<br>Context only \2014 ''+(uses.length?''includes ''+esc(uses.joi')
||'n('' and ''))+''.'':''full account; not a comparable on-hand balance.'')+''</span>'':'''';',
unistr('let html=''<tr><td><button type="button" class="inv73-stock-expand" data-stock-account="''+esc(ccid)+''" aria-expanded="''+open+''"><span aria-hidden="true">''+(open?''\25BE'':''\25B8'')+''</span><span class="inv73-account">''+esc(row.ACCOUNT)+''</span></button><span cla')
||'ss="inv73-stock-caption">''+esc(row.COMPARISON_REASON||row.BASIS_STATUS||'''')+''</span></td><td>''+esc(row.SELECTED_ORG_CODES||row.OWNER_ORG_CODES||'''')+(Number(row.OWNER_COUNT)>1?''<span class="inv73-stock-caption">Combined captured owners</span>'':'''')+''</'
||'td><td class="inv73-stock-num">''+esc(amount(row,''ONHAND_VALUE''))+''</td><td class="inv73-stock-num">''+esc(amount(row,''GL_END_BALANCE''))+context+''</td><td class="inv73-stock-num ''+(unavailable?''inv73-stock-unavailable'':'''')+''">''+esc(amount(row,''ONHAND_V'
||'S_GL_DIFF''))+(unavailable?''<span class="inv73-stock-caption">Unavailable</span>'':'''')+''</td></tr>'';',
'if(open){const children=orgRows.get(ccid);html+=children?children.rows.map(org=>{',
'const childKey=key(ccid,org.ORG_ID),childOpen=openOrgs.has(childKey);let nested=''<tr class="inv73-stock-detail"><td><button type="button" class="inv73-stock-expand" data-stock-org="''+esc(org.ORG_ID)+''" data-ccid="''+esc(ccid)+''" aria-expanded="''+child'
||unistr('Open+''"><span aria-hidden="true">''+(childOpen?''\25BE'':''\25B8'')+''</span><span>Org ''+esc(org.ORG_CODE)+''<span class="inv73-stock-caption">''+esc(org.ORG_NAME)+''</span></span></button></td><td>Org valuation</td><td class="inv73-stock-num">''+esc(amount(org,''ONHAN')
||'D_VALUE''))+''</td><td colspan="2" class="inv73-stock-caption">GL and difference stay on the account total.</td></tr>'';',
unistr('if(childOpen){const subs=subRows.get(childKey);nested+=subs?(subs.rows.length?subs.rows.map(sub=>''<tr class="inv73-stock-detail inv73-stock-sub"><td>\21B3 ''+esc(sub.SUBINVENTORY_CODE)+''</td><td>Subinventory</td><td class="inv73-stock-num">''+esc(amount(su')
||unistr('b,''ONHAND_VALUE''))+''</td><td colspan="2" class="inv73-stock-caption">\2014</td></tr>'').join(''''):''<tr class="inv73-stock-detail inv73-stock-sub"><td colspan="5">No current captured subinventory value rows.</td></tr>'')+pageControls(''SUBS'',ccid,org.ORG_ID,s')
||unistr('ubPages.get(childKey)||1,subs.total):''<tr class="inv73-stock-detail"><td colspan="5">Loading captured subinventories\2026</td></tr>'';}'),
'return nested;',
unistr('}).join('''')+pageControls(''ORGS'',ccid,'''',orgPages.get(ccid)||1,children.total):''<tr class="inv73-stock-detail"><td colspan="5">Loading captured org values\2026</td></tr>'';}'),
'return html;',
unistr('}).join(''''):''<tr><td colspan="5">''+(pending?''Loading captured account view\2026'':capture?''No accounts match this local view. Unavailable comparisons and zero-stock GL residuals are retained by the default view.'':''Run reconciliation to capture on-hand acc')
||'ount balances.'')+''</td></tr>'';',
unistr('byId(''inv73-stock-count'').textContent=capture?(rows.length?((page-1)*25+1)+''\2013''+((page-1)*25+rows.length)+'' of ''+total+'' account rows'':''0 account rows''):''No capture'';'),
'byId(''inv73-stock-prev'').disabled=pending||page<=1;byId(''inv73-stock-next'').disabled=pending||page*25>=total;',
'byId(''inv73-stock-view-note'').textContent=(orgValue()?''View filter only: accounts involving the selected org keep all captured owners and the full account GL. '':'''')+(byId(''inv73-stock-all'').checked?''Showing all captured stock accounts.'':''Showing diff'
||'erences over 1.00, unavailable comparisons, and zero-stock GL residuals.'');',
'if(restoreFocus)focusControl(restoreFocus);',
'}',
'async function load(){const serial=++listRequest;if(!capture){rows=[];total=0;pending=false;render();return;}pending=true;rows=[];render();try{const response=await request(''ACCOUNTS'',null,null,page);if(!response||serial!==listRequest)return;rows=resp'
||'onse.rows||[];total=Number(response.total||0);notice('''');}catch(error){if(serial===listRequest)notice(error.message,true);}finally{if(serial===listRequest){pending=false;render();}}}',
'async function loadChildren(action,ccid,org,requestedPage){const requestKey=action+'':''+key(ccid,org),serial=(childRequests.get(requestKey)||0)+1;childRequests.set(requestKey,serial);try{const response=await request(action,ccid,org,requestedPage);if(!'
||'response||childRequests.get(requestKey)!==serial)return;if(action===''ORGS''){orgRows.set(String(ccid),response);orgPages.set(String(ccid),requestedPage||1);}else{subRows.set(key(ccid,org),response);subPages.set(key(ccid,org),requestedPage||1);}notice('
||''''');render();}catch(error){if(childRequests.get(requestKey)===serial)notice(error.message,true);}}',
'byId(''inv73-stock-org'').addEventListener(''change'',()=>{page=1;openAccounts.clear();openOrgs.clear();load();});',
'byId(''inv73-stock-all'').addEventListener(''change'',()=>{page=1;openAccounts.clear();openOrgs.clear();load();});',
'byId(''inv73-stock-prev'').addEventListener(''click'',()=>{if(page>1){page--;load();}});byId(''inv73-stock-next'').addEventListener(''click'',()=>{if(page*25<total){page++;load();}});',
'apex.jQuery(document).on(''click'',''[data-stock-account]'',function(){const selector=focusSelector(this),ccid=this.dataset.stockAccount;if(openAccounts.has(ccid))openAccounts.delete(ccid);else{openAccounts.add(ccid);if(!orgRows.has(ccid))loadChildren(''O'
||'RGS'',ccid,null,1);}render();focusControl(selector);});',
'apex.jQuery(document).on(''click'',''[data-stock-org]'',function(){const selector=focusSelector(this),childKey=key(this.dataset.ccid,this.dataset.stockOrg);if(openOrgs.has(childKey))openOrgs.delete(childKey);else{openOrgs.add(childKey);if(!subRows.has(ch'
||'ildKey))loadChildren(''SUBS'',this.dataset.ccid,this.dataset.stockOrg,1);}render();focusControl(selector);});',
'apex.jQuery(document).on(''click'',''[data-stock-page]'',function(){loadChildren(this.dataset.stockPage,this.dataset.ccid,this.dataset.org,Number(this.dataset.page));});',
'return {refresh:load,setSnapshot(pointer,orgs){const changed=pointer!==capture;if(!changed)return false;capture=pointer||'''';generation++;listRequest++;pending=false;rows=[];total=0;page=1;orgRows.clear();subRows.clear();openAccounts.clear();openOrgs.'
||unistr('clear();orgPages.clear();subPages.clear();childRequests.clear();byId(''inv73-stock-org'').innerHTML=''<option value="">All captured orgs</option>''+(orgs||[]).map(org=>''<option value="''+esc(org.ORG_ID)+''">''+esc(org.ORG_CODE)+'' \00B7 ''+esc(org.ORG_NAME)+''</op')
||'tion>'').join('''');byId(''inv73-stock-org'').value='''';byId(''inv73-stock-all'').checked=false;notice('''');render();return true;}};',
'}',
'',
'const inv73PickerSelection=(()=>{',
'const id=row=>String(row.ORG_ID),sort=(a,b)=>String(a).localeCompare(String(b),undefined,{numeric:true});',
'function groups(rows,ouId){',
'const all=new Map((rows||[]).map(row=>[id(row),row]));',
'const eligible=new Set((rows||[]).filter(row=>row.ELIGIBLE===''Y''&&String(row.OU_ID)===String(ouId)).map(id)),result=new Map();',
'for(const row of rows||[]){',
'if(!eligible.has(id(row)))continue;',
'const raw=String(row.OWNERSHIP_GROUP_IDS||''''),valid=/^[0-9]+(:[0-9]+)*$/.test(raw)&&raw.split('':'').includes(id(row));',
'const ids=[...new Set((valid?raw.split('':''):raw.split('':'').filter(value=>/^[0-9]+$/.test(value))).concat(id(row)))].sort(sort),key=ids.join('':'');',
'if(result.has(key))continue;',
'const members=ids.filter(value=>eligible.has(value)).map(value=>all.get(value)).sort((a,b)=>sort(a.ORG_CODE,b.ORG_CODE));',
'const blocked=!valid||ids.some(value=>!eligible.has(value))||members.some(member=>member.OWNERSHIP_BLOCKED===''Y'');',
'const blockers=[...new Set(members.map(member=>member.OWNERSHIP_BLOCKER_CODES).filter(Boolean))].join(''; '')||ids.filter(value=>!eligible.has(value)).map(value=>{const owner=all.get(value);return owner?String(owner.ORG_CODE)+'' (''+(owner.EXCLUSION_REAS'
||'ON||''outside eligible OU'')+'')'':value+'' (metadata unavailable)'';}).join('', '');',
'result.set(key,{id:id(members[0]),key,ids,members,blocked,ready:!blocked&&ids.every(value=>all.get(value)&&all.get(value).READINESS_STATUS===''READY''),blockers:blockers||(!valid?''Fresh ownership check required'':'''')});',
'}',
'return [...result.values()].sort((a,b)=>sort(a.members[0].ORG_CODE,b.members[0].ORG_CODE));',
'}',
'function toggle(rows,ouId,selected,orgId,checked){',
'const values=groups(rows,ouId),eligible=new Set(values.flatMap(group=>group.members.map(id))),next=new Set([...selected].filter(value=>eligible.has(String(value))).map(String));',
'const group=values.find(value=>value.members.some(row=>id(row)===String(orgId)));',
'if(group)group.members.forEach(row=>checked?next.add(id(row)):next.delete(id(row)));',
'return next;',
'}',
'function bulk(rows,ouId,action){return new Set(groups(rows,ouId).filter(group=>action===''all''||action===''ready''&&group.ready).flatMap(group=>group.members.map(id)));}',
'function include(rows,ouId,selected,orgIds){let next=new Set(selected);for(const value of orgIds)next=toggle(rows,ouId,next,value,true);return next;}',
'function filteredGroups(values,query){const term=String(query||'''').trim().toLocaleLowerCase();return values.filter(group=>!term||group.members.some(row=>(String(row.ORG_CODE)+'' ''+String(row.ORG_NAME||'''')).toLocaleLowerCase().includes(term)));}',
'return {groups,toggle,bulk,include,filteredGroups};',
'})();',
'if(typeof module!==''undefined''&&module.exports)module.exports=inv73PickerSelection;',
'',
'function inv73CreatePickerController(options){',
'const byId=id=>document.getElementById(id),esc=value=>apex.util.escapeHTML(value==null?'''':String(value));',
'const root=byId(''inv73-picker''),search=byId(''inv73-picker-search''),toggle=byId(''inv73-picker-toggle'');',
'let open=true,checkKey='''',announcement='''';',
'const codes=group=>group.members.map(row=>String(row.ORG_CODE)).join('' + '');',
'function focus(selector,fallback){const target=root.querySelector&&root.querySelector(selector);if(target&&!target.disabled)target.focus();else if(fallback)toggle.focus();}',
'function announce(text){announcement=text||'''';byId(''inv73-picker-message'').textContent=announcement;}',
'function setDisabled(value){if(root.querySelectorAll)root.querySelectorAll(''input,button'').forEach(el=>el.disabled=Boolean(value));}',
'function render(){',
'const state=options.snapshot(),checked=state.checked,selection=state.selected,active=document.activeElement&&document.activeElement.dataset;',
'const restore=active&&active.inv73PickerOrg?''[data-inv73-picker-org="''+active.inv73PickerOrg+''"]'':active&&active.inv73PickerRemove?''[data-inv73-picker-remove="''+active.inv73PickerRemove+''"]'':null;',
'if(checkKey!==String(checked?state.key:'''')){checkKey=String(checked?state.key:'''');search.value='''';open=true;announce('''');}',
'root.hidden=!checked;',
'const values=inv73PickerSelection.groups(checked?state.rows:[],state.ou),visible=inv73PickerSelection.filteredGroups(values,search.value);',
'const selectedGroups=values.filter(group=>group.members.some(row=>selection.has(String(row.ORG_ID))));',
'byId(''inv73-picker-chips'').innerHTML=selectedGroups.length?selectedGroups.map(group=>{',
'const members=group.members.filter(row=>selection.has(String(row.ORG_ID))),partial=members.length!==group.members.length;',
unistr('return ''<button type="button" class="inv73-picker-chip" data-inv73-picker-remove="''+esc(group.id)+''" aria-label="Remove ''+esc(codes(group))+(group.members.length>1?'' active group'':'''')+''" title="''+esc(members.map(row=>row.ORG_CODE+'' \00B7 ''+row.ORG_NAME).')
||unistr('join('' / ''))+''">''+esc(members.map(row=>row.ORG_CODE).join('' + ''))+(partial?'' \00B7 incomplete group'':'''')+(group.blocked?'' \00B7 Blocked'':'''')+''<span aria-hidden="true">\00D7</span></button>'';'),
'}).join(''''):''<span class="inv73-muted">No Inventory Orgs selected.</span>'';',
'byId(''inv73-picker-rows'').innerHTML=visible.length?visible.map(group=>{',
'const count=group.members.filter(row=>selection.has(String(row.ORG_ID))).length,states=[...new Set(group.members.map(row=>row.READINESS_STATUS||''UNKNOWN''))];',
'const names=group.members.map(row=>row.ORG_NAME).join('' / ''),status=group.blocked?''Blocked'':states.join('' + '');',
'return ''<label class="inv73-picker-row"><input type="checkbox" class="inv73-org-check" data-inv73-picker-org="''+esc(group.id)+''" value="''+esc(group.id)+''" ''+(count===group.members.length?''checked '':'''')+''aria-label="Select ''+esc(codes(group))+(group.m'
||unistr('embers.length>1?'' active owner group'':'''')+''"><span class="inv73-picker-name"><strong>''+esc(codes(group))+''</strong> \00B7 ''+esc(names)+(group.ids.length>1?''<span class="inv73-picker-secondary">Shared active owners \00B7 select or remove together</span>'':'''')+')
||'(group.blocked?''<span class="inv73-picker-secondary inv73-picker-blocker">Required active owners: ''+esc(group.blockers)+''</span>'':'''')+''</span><span class="inv73-badge inv73-''+(group.ready?''good'':''warn'')+''">''+esc(status)+''</span></label>'';',
'}).join(''''):''<div class="inv73-picker-empty">No matching Inventory Orgs. Search does not change the selection.</div>'';',
'const rows=byId(''inv73-picker-rows'');if(rows.querySelectorAll)rows.querySelectorAll(''[data-inv73-picker-org]'').forEach(input=>{const group=values.find(value=>value.id===input.dataset.inv73PickerOrg),count=group.members.filter(row=>selection.has(Strin'
||'g(row.ORG_ID))).length;input.indeterminate=count>0&&count<group.members.length;});',
unistr('byId(''inv73-picker-matches'').textContent=visible.length+'' of ''+values.length+'' org group''+(values.length===1?'''':''s'')+'' shown \00B7 search keeps your selection'';'),
'byId(''inv73-picker-menu'').hidden=!open;toggle.setAttribute(''aria-expanded'',String(open));toggle.textContent=open?''Close org picker'':''Change selection'';',
'byId(''inv73-picker-message'').textContent=announcement;setDisabled(state.busy||!checked);if(restore)focus(restore,false);',
'}',
'toggle.addEventListener(''click'',()=>{const state=options.snapshot();if(state.busy||!state.checked)return;open=!open;render();if(open)search.focus();else toggle.focus();});',
'search.addEventListener(''input'',()=>render());',
'root.addEventListener(''keydown'',event=>{if(event.key===''Escape''&&open){event.preventDefault();open=false;render();toggle.focus();}else if(event.key===''Enter''&&event.target===search)event.preventDefault();});',
'apex.jQuery(document).on(''click'',''[data-inv73-picker-remove]'',function(){const state=options.snapshot();if(state.busy||!state.checked)return;const group=inv73PickerSelection.groups(state.rows,state.ou).find(value=>value.id===this.dataset.inv73PickerR'
||'emove);if(!group)return;announce(''Removed ''+codes(group)+(group.members.length>1?'' together.'':''.''));options.change(inv73PickerSelection.toggle(state.rows,state.ou,state.selected,group.id,false));focus(''[data-inv73-picker-remove="''+group.id+''"]'',true)'
||';});',
'return {render,announce,setDisabled};',
'}',
'',
'const inv73ReportWording=(()=>{',
'const rows={',
'ACCOUNT:[''Account total'',''Combined amount for the selected Inventory Orgs. Org breakdown rows explain this same total; do not add both levels together.'',''neutral''],',
'ORG:[''Org breakdown'',''This Inventory Org contributes to its account total. This is not an additional balance.'',''neutral''],',
'LEDGER:[''Ledger total'',''Combined ledger total. Do not add account totals or org breakdown rows to it again.'',''neutral''],',
'TOTAL:[''Ledger total'',''Combined ledger total. Do not add account totals or org breakdown rows to it again.'',''neutral'']',
'};',
'const close={',
'OK:[''No close-data issues found'',''The captured close-data check found no missing or open-period data for this row. This does not mean the balance agrees with GL.'',''good''],',
'READY:[''Closed; close data available'',''The Inventory period is closed and current and prior close summaries are available. This does not mean reconciled to GL.'',''good''],',
unistr('OPEN:[''Inventory period open \2014 provisional'',''The Inventory period is not fully closed. Treat available balances as provisional.'',''warn''],'),
'''AWAITING DATA'':[''Close summary missing'',''The Inventory period is closed but a required current or prior close summary is missing.'',''warn''],',
'DORMANT:[''No period for this org'',''No Inventory period exists for this org and selected period.'',''neutral''],',
'''DORMANT ORG - NO PERIOD'':[''No period for this org'',''No Inventory period exists for this org and selected period.'',''neutral''],',
'''UNKNOWN ORGANIZATION'':[''Org status unavailable'',''The Inventory Org could not be matched to readiness information.'',''warn''],',
'INCOMPLETE:[''Close data incomplete'',''Required close data is missing or the Inventory period is still open.'',''warn''],',
'''ORGS TO CHECK'':[''Close data incomplete'',''One or more selected Inventory Orgs have missing close data or an open Inventory period.'',''warn''],',
'''CURRENT DATA UNAVAILABLE'':[''Current close data unavailable'',''The current Inventory period is not fully closed or its close summary is unavailable.'',''warn''],',
'''NO PRIOR PERIOD CLOSE DATA'':[''Prior close data missing'',''Prior-period close data is unavailable.'',''warn''],',
'''PERIOD OPEN - NO CURRENT CLOSE DATA'':[''Period open; current close data missing'',''The Inventory period remains open and current close data is unavailable.'',''warn''],',
'''NO CURRENT PERIOD CLOSE DATA'':[''Current close data missing'',''Current-period inventory close data is unavailable.'',''warn''],',
'''PERIOD OPEN - NO CLOSE DATA'':[''Period open; close data missing'',''The Inventory period remains open and close data is unavailable.'',''warn''],',
'''NO CLOSE DATA'':[''Close data missing'',''Required inventory close data is unavailable.'',''warn'']',
'};',
'const gl={',
'''GL not loaded for this diagnostic'':[''GL not included in this view'',''Standalone WIP, monthly activity and Intransit views do not load GL balances.'',''neutral''],',
unistr('''PARTIAL OWNERSHIP'':[''GL unavailable \2014 other orgs referenced'',''Some recorded account owners or references are outside this run, so the full-account GL comparison is withheld. These can include dormant or historical references; the selected active org')
||' group may still be valid.'',''warn''],',
unistr('''UNKNOWN OWNERSHIP'':[''GL unavailable \2014 owners unconfirmed'',''Account ownership could not be confirmed, so the full-account GL comparison is withheld.'',''warn''],'),
'''FULL OWNERSHIP'':[''All recorded account orgs included'',''The run includes every recorded account owner. This describes GL coverage, not whether the balances agree. Any GL amount is for the whole account.'',''good''],',
'''LEDGER TOTAL'':[''Whole-ledger GL balance'',''GL covers the whole ledger account or intransit bucket. It is not allocated between Inventory Orgs or valuation types.'',''neutral''],',
'''ORG DETAIL'':[''See account total for GL'',''GL is not allocated to this Inventory Org. Read any available GL balance on the account total row.'',''neutral'']',
'};',
'function describe(field,value){',
'const code=String(value==null?'''':value).trim(),map=field===''ROW_TYPE''?rows:field===''GL_SCOPE_STATUS''?gl:close;',
'if(field===''ORG_CODE'')return {label:code===''** ACCOUNT TOTAL **''?''All selected orgs'':code===''** LEDGER TOTAL **''?''All ledger orgs'':code,detail:code===''** ACCOUNT TOTAL **''?''Combined amount for the selected Inventory Orgs.'':''Inventory organization.'',t'
||'one:''neutral''};',
'let item=map[code];',
'if(!item&&field===''CLOSE_DATA_CHECK''){',
'if(/^(Closed Inventory; (WIP balances through period end|no qualifying WIP balance rows)|Closing WIP account total; org rows are its breakdown)$/.test(code))item=[code,''Available closing WIP data; GL is not loaded for this view.'',''good''];',
'else if(/^(Monthly activity(; not a closing WIP balance| account total; org rows are its breakdown)|No activity matched the business report filters)$/.test(code))item=[code,''Activity within the selected transaction-date window, not a closing WIP bala'
||'nce.'',''neutral''];',
'}',
unistr('if(!item&&field!==''ROW_TYPE''&&field!==''GL_SCOPE_STATUS''&&/^ORGS TO CHECK:\005Cs*\005Cd+$/.test(code))item=[''Close data incomplete \2014 ''+code.split('':'')[1].trim()+'' org(s)'',''One or more selected Inventory Orgs have missing close data or an open Inventory period')
||'.'',''warn''];',
'if(!item)item=[code||''Not available'',''Status returned by the capture: ''+(code||''not available'')+''.'',field===''ROW_TYPE''?''neutral'':''warn''];',
'return {label:item[0],detail:item[1],tone:item[2]};',
'}',
'return {describe};',
'})();',
'if(typeof module!==''undefined''&&module.exports)module.exports=inv73ReportWording;',
'',
'const inv73DiagnosticKinds={wip:''WIP'',transit:''INTRANSIT'',accounting:''ACCOUNTING''};',
'const inv73DiagnosticLabels={WIP:''WIP closing valuation'',WIP_ACTIVITY:''WIP monthly activity'',INTRANSIT:''Intransit'',ACCOUNTING:''Cumulative accounting''};',
'function inv73DiagnosticKind(tab,view){return tab===''wip''?view:inv73DiagnosticKinds[tab];}',
'function inv73DiagnosticPointer(response,kind){return response[({WIP:''wip_collection'',WIP_ACTIVITY:''wip_activity_collection'',INTRANSIT:''intransit_collection'',ACCOUNTING:''capture_collection''})[kind]]||'''';}',
'function inv73RenderDiagnostics(meta,busy,view) {',
'const captured=meta.CAPTURED_LEDGER_ID!=null;',
'Object.keys(inv73DiagnosticKinds).forEach(tab=>{',
'const panel=document.getElementById(''inv73-panel-''+tab),kind=inv73DiagnosticKind(tab,view),loaded=meta[kind+''_LOADED'']===''Y'',label=inv73DiagnosticLabels[kind];',
'const button=panel.querySelector(''[data-inv73-diagnostics]'');button.disabled=busy||!captured;button.dataset.inv73Diagnostics=kind;button.textContent=(loaded?''Reload '':''Load '')+label;',
unistr('panel.querySelector(''[data-inv73-diagnostics-status]'').textContent=loaded?label+'' loaded'':captured?''Not loaded \2014 select Load to retrieve this view'':''Run reconciliation first'';'),
unistr('panel.querySelector(''[data-inv73-diagnostics-time]'').textContent=loaded?''Captured ''+(meta[kind+''_CAPTURED_AT'']||'''')+(meta[kind+''_SECONDS'']!=null?'' \00B7 ''+Number(meta[kind+''_SECONDS'']).toFixed(2)+''s'':''''):'''';'),
'panel.querySelector(''[data-inv73-diagnostics-basis]'').textContent=(meta[kind+''_BASIS'']||({WIP:''Closing WIP valuation at the selected Inventory period end.'',WIP_ACTIVITY:''Monthly accounting activity from month start through month end. This is movement'
||', not the closing WIP balance.'',INTRANSIT:''EBS Back Dated Intransit report: Total Cost by Inventory Org. The report supplies no GL account.'',ACCOUNTING:''Cumulative accounting and GL diagnostics. Loading this view can take several minutes.''})[kind])+('
||'kind===''WIP_ACTIVITY''&&meta[kind+''_DATE_FROM'']?'' Transaction dates: ''+meta[kind+''_DATE_FROM'']+'' to ''+meta[kind+''_DATE_TO'']+''.'':'''');',
'document.getElementById(''inv73-report-''+tab).hidden=!loaded;',
'const missing=Number(meta[kind+''_MISSING_ORG_COUNT'']||0),mismatch=Number(meta[kind+''_PERIOD_MISMATCH_ROWS'']||0),note=panel.querySelector(''[data-inv73-diagnostics-availability]'');note.hidden=!loaded||(!missing&&!mismatch);note.textContent=[missing?mis'
||'sing+(kind===''WIP''?'' selected org(s) lack closed Inventory or required close-summary data; closing valuation is unavailable.'':'' selected org(s) have no source rows. Missing data is unavailable, not assumed to be zero.''):'''',mismatch?mismatch+'' activit'
||'y row(s) use an accounting period different from the selected month. Add Period Name from Actions to review.'':''''].filter(Boolean).join('' '');',
'});',
'document.querySelectorAll(''[data-inv73-wip-view]'').forEach(button=>{button.disabled=busy;button.setAttribute(''aria-pressed'',String(button.dataset.inv73WipView===view));});',
'}',
''))
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(function () {',
'''use strict'';',
'const $ = apex.jQuery, tabs = [''stock'',''wip'',''transit'',''accounting''];',
'const byId = id => document.getElementById(id);',
'const esc = value => apex.util.escapeHTML(value == null ? '''' : String(value));',
'let data = {meta:{},readiness:[],owners:[],token:''''}, selected = new Set(), busy = false, busyAction = '''', selectionCheckKey = '''', activeTab = ''stock'', wipView=''WIP'', timer, started,primaryPin='''';',
'const opened = new Set();',
'const stock=inv73CreateOnhandController();',
'const ledger = () => String(apex.item(''P73_LEDGER_ID'').getValue() || '''');',
'const period = () => String(apex.item(''P73_PERIOD_NAME'').getValue() || '''');',
'const ou = () => String(apex.item(''P73_OU_ID'').getValue() || '''');',
'const orgId = row => String(row.ORG_ID);',
'const matchingCheck = () => Boolean(data.token && ledger() && period() && ou() && String(data.meta.CHECKED_LEDGER_ID) === ledger() && data.meta.CHECKED_PERIOD_NAME === period() && String(data.meta.CHECKED_OU_ID) === ou());',
'const eligibleIds = () => inv73EligibleOrgIds(data.readiness,ou());',
'const eligibleRows = () => {const eligible=eligibleIds();return data.readiness.filter(row=>eligible.has(orgId(row)));};',
'const selectionGate = () => inv73AssessSelectionGate(data.readiness,selected);',
'const normalize = value => String(value || '''').split('':'').filter(Boolean).sort((a,b) => Number(a)-Number(b)).join('':'');',
'const normalizeScope = value => String(value || '''')===''ALL''?''ALL'':normalize(value);',
'const scope = () => normalize([...selected].join('':''));',
'const picker=inv73CreatePickerController({snapshot:()=>({rows:data.readiness,ou:ou(),checked:matchingCheck(),selected,busy,key:data.token}),change:value=>{if(busy||!matchingCheck())return;selected=value;renderReadiness();renderCapture();}});',
unistr('const money = value => value == null ? ''\2014'' : Number(value).toLocaleString(undefined,{minimumFractionDigits:2,maximumFractionDigits:2});'),
'function badge(text, kind) { return ''<span class="inv73-badge inv73-''+kind+''">''+esc(text)+''</span>''; }',
'function readinessKind(status) { return status === ''READY'' ? ''good'' : status === ''DORMANT'' ? ''neutral'' : ''warn''; }',
'function message(text, error) {',
'const el=byId(''inv73-operation''); el.hidden=!text; el.textContent=text || '''';',
'el.classList.toggle(''inv73-error'',Boolean(error));',
'}',
'function setBusy(value, action) {',
'busy=value; busyAction=value?action:''''; byId(''inv73-workflow'').setAttribute(''aria-busy'',String(value));',
'apex.item(''P73_LEDGER_ID'').disable(); apex.item(''P73_PERIOD_NAME'').disable();',
'apex.item(''P73_OU_ID'').disable();',
'if(!value){apex.item(''P73_LEDGER_ID'').enable();apex.item(''P73_PERIOD_NAME'').enable();apex.item(''P73_OU_ID'').enable();}',
'if(timer)clearInterval(timer);',
'const timerLabel=action===''check''?''Check'':action===''run''?''Run'':action===''lookup''?''Lookup refresh'':action===''diagnostics''?''Diagnostics'':''Operation'';',
unistr('if(value){started=Date.now();byId(''inv73-timer'').textContent=timerLabel+'' \00B7 0s elapsed'';timer=setInterval(()=>{byId(''inv73-timer'').textContent=timerLabel+'' \00B7 ''+Math.floor((Date.now()-started)/1000)+''s elapsed'';},1000);}'),
'else if(started){byId(''inv73-timer'').textContent=Math.round((Date.now()-started)/1000)+''s elapsed'';started=null;}',
unistr('byId(''inv73-check'').textContent=value&&action===''check''?''Checking Inventory Orgs\2026'':''Check Inventory Orgs'';'),
unistr('byId(''inv73-refresh-lookup'').textContent=value&&action===''lookup''?''Refreshing Lookup\2026'':''Refresh Lookup'';'),
'controls();',
'}',
'function ownersByAccount() {',
'return inv73AssessOwnerScope(data.owners,selected).groups.filter(group=>[...group.members.keys()].some(id=>selected.has(id)));',
'}',
'function controls() {',
'const checked=matchingCheck(),gate=selectionGate();',
'inv73RenderDiagnostics(data.meta,busy,wipView);',
'byId(''inv73-check'').disabled=busy || !ledger() || !period() || !ou();',
'byId(''inv73-refresh-lookup'').disabled=busy;picker.setDisabled(busy||!checked);',
'byId(''inv73-run'').disabled=busy || !checked || !selected.size || gate.blocked;',
unistr('byId(''inv73-run'').textContent=busy&&busyAction===''run''?''Running\2026'':''Run Reconciliation''+(checked?'' \00B7 ''+selected.size+'' selected org''+(selected.size===1?'''':''s''):'''');'),
'document.querySelectorAll(''[data-inv73-select],.inv73-org-check,[data-inv73-include],[data-inv73-include-intransit],[data-inv73-required-group],[data-inv73-deselect-blocked]'').forEach(el=>el.disabled=busy || !checked);',
'byId(''inv73-selection-count'').textContent=selected.size+'' of ''+eligibleRows().length+'' eligible orgs selected'';',
'byId(''inv73-run-note'').textContent=checked?(gate.blocked?''Complete the required active-owner groups or deselect blocked groups before Run.'':selected.size?''One OU only. Dormant references are not required; missing close data remains provisional.'':''Sel'
||'ect at least one eligible Inventory Org.''):''A matching ledger, period, and OU check is required.'';',
'const captured=data.meta.CAPTURED_LEDGER_ID != null;',
'const stale=captured && (String(data.meta.CAPTURED_LEDGER_ID)!==ledger() || data.meta.CAPTURED_PERIOD_NAME!==period() || String(data.meta.CAPTURED_OU_ID)!==ou() || (checked && normalizeScope(scope())!==normalizeScope(data.meta.CAPTURED_ORG_IDS)));',
'byId(''inv73-stale'').hidden=!stale;',
'const banner=byId(''inv73-selection-gate'');banner.hidden=!checked||!gate.blocked;',
unistr('banner.innerHTML=checked&&gate.blocked?''<strong>Run blocked \2014 active Inventory Org owners of shared valuation accounts must reconcile together.</strong>''+gate.problems.map(group=>''<p>''+esc([...new Set(group.selectedCodes)].join('', ''))+'' requires ''+(g')
||'roup.invalid?''a fresh ownership check'':group.permanentBlock?esc(group.blockerCodes||group.missing.map(row=>row.code+(row.reason?'' (''+row.reason+'')'':'''')).join('', '')):esc(group.missing.map(row=>row.code).join('', '')))+''. ''+(group.permanentBlock?''This ac'
||'tive-owner group includes an org outside the eligible OU scope. Deselect the whole group to run other orgs.'':''Select the required group explicitly or deselect its selected members.'')+''</p>'').join('''')+(gate.blockedSelectedIds.size?''<button type="butto'
||unistr('n" class="t-Button t-Button--small" data-inv73-deselect-blocked ''+(busy?''disabled'':'''')+''>Deselect blocked groups \00B7 ''+gate.blockedSelectedIds.size+'' selected org(s)</button>'':''''):'''';'),
'}',
'function ownershipCell(row){',
unistr('const dormant=row.OWNERSHIP_DORMANT_CODES?''<span class="inv73-orgname">Dormant: ''+esc(row.OWNERSHIP_DORMANT_CODES)+'' \00B7 not required</span>'':'''';'),
unistr('const exempt=row.OWNERSHIP_EXEMPT_CODES?''<span class="inv73-orgname">Master/exempt: ''+esc(row.OWNERSHIP_EXEMPT_CODES)+'' \00B7 not required</span>'':'''';'),
'if(row.OWNERSHIP_STATUS===''EXCLUSIVE'')return ''<span title="One confirmed active owner. GL coverage is assessed separately.">''+badge(''Active only'',''neutral'')+''</span>''+dormant+exempt;',
'if(row.OWNERSHIP_STATUS!==''SHARED'')return ''<span class="inv73-muted">No confirmed mapping</span>''+dormant+exempt;',
'const ids=String(row.OWNERSHIP_GROUP_IDS||'''').split('':'').filter(Boolean),eligible=eligibleIds();',
'const canExpand=ids.length>0&&row.OWNERSHIP_BLOCKED!==''Y''&&ids.every(id=>eligible.has(id));',
'const missing=ids.some(id=>!selected.has(id));',
unistr('return badge(''Shared \00B7 ''+(row.OWNERSHIP_GROUP_SIZE||row.GROUP_SIZE||ids.length)+'' active'',''warn'')+''<span class="inv73-orgname inv73-owner-codes" title="''+esc(row.OWNERSHIP_GROUP_CODES||'''')+''">''+esc(row.OWNERSHIP_GROUP_CODES||'''')+''</span>''+dormant+exe')
||'mpt+(row.OWNERSHIP_BLOCKED===''Y''?''<details class="inv73-owner-detail"><summary>Blocked active group</summary>''+esc(row.OWNERSHIP_BLOCKER_CODES||''An active owner is outside the eligible OU scope'')+''</details>'':canExpand&&missing?''<button type="button"'
||' class="t-Button t-Button--small" data-inv73-required-group="''+esc(orgId(row))+''">Select required group</button>'':'''');',
'}',
'function renderReadiness() {',
'const checked=matchingCheck(), eligible=eligibleIds();',
'const rows=checked?[...eligibleRows()].sort((a,b)=>String(a.ORG_CODE).localeCompare(String(b.ORG_CODE),undefined,{numeric:true})):[];',
'const allRows=checked?data.readiness:[], excluded=allRows.filter(row=>String(row.OU_ID)===ou()&&row.ELIGIBLE!==''Y'');',
'const assessment=inv73AssessOwnerScope(checked?data.owners:[],selected);',
'const groups=assessment.groups.filter(group=>[...group.members.keys()].some(id=>selected.has(id)));',
'const unknown=assessment.unknownIntransitAccounts.length>0;',
'const company=checked?data.meta.CHECKED_COMPANY_CODES:null;',
'byId(''inv73-company'').textContent=company?(Array.isArray(company)?company.join('', ''):String(company)):''Available after Check'';',
unistr('byId(''inv73-lookup-context'').textContent=data.meta.LOOKUP_REFRESHED_AT_UTC?''Refreshed ''+data.meta.LOOKUP_REFRESHED_AT_UTC+'' UTC \00B7 Daily at 03:00 Eastern Time. Refresh near close when statuses or account mappings change.'':''Refresh Lookup, then Check I')
||'nventory Orgs.'';',
'byId(''inv73-selection-tools'').hidden=!checked;byId(''inv73-readiness-details'').hidden=!checked;picker.render();',
unistr('byId(''inv73-check-context'').textContent=checked?(data.meta.CHECKED_OU_NAME||''Operating unit'')+'' \00B7 ''+data.meta.CHECKED_PERIOD_NAME+'' \00B7 ''+rows.length+'' eligible orgs \00B7 ''+excluded.length+'' excluded. READY means close data is available.'':''Select a ledger')
||', period, and operating unit, then check Inventory Orgs.'';',
'const counts=rows.reduce((acc,row)=>(acc[row.READINESS_STATUS]=(acc[row.READINESS_STATUS]||0)+1,acc),{});',
'byId(''inv73-readiness-counts'').innerHTML=Object.entries(counts).map(([status,count])=>badge(count+'' ''+status,readinessKind(status))).join('' '');',
'byId(''inv73-excluded-details'').hidden=!checked||!excluded.length;',
'byId(''inv73-excluded-count'').textContent=excluded.length+'' excluded orgs in this OU'';',
unistr('byId(''inv73-excluded-list'').innerHTML=excluded.map(row=>''<p><strong>''+esc(row.ORG_CODE)+''</strong> ''+esc(row.ORG_NAME)+'' \2014 ''+esc(row.EXCLUSION_REASON||row.READINESS_STATUS)+''</p>'').join('''');'),
'byId(''inv73-readiness'').innerHTML=rows.length?rows.map(row=>{',
'const shares=groups.filter(group=>group.members.has(orgId(row))).length;',
'return ''<tr><td><strong>''+esc(row.ORG_CODE)+''</strong><span class="inv73-orgname">''+esc(row.ORG_NAME)+''</span></td><td>''+badge(row.READINESS_STATUS,readinessKind(row.READINESS_STATUS))+''</td><td>''+ownershipCell(row)+''</td><td>''+esc(data.meta.CHECKED_'
||'PERIOD_NAME)+''<span class="inv73-orgname">''+esc(row.INV_STATUS)+''</span></td><td>''+esc(row.PRIOR_PERIOD_NAME||''Prior period'')+''<span class="inv73-orgname">''+esc(row.PRIOR_INV_STATUS||''Unavailable'')+''</span></td><td>Current: ''+esc(row.CURRENT_SUMMARY)'
||'+''<span class="inv73-orgname">Prior: ''+esc(row.PRIOR_SUMMARY)+''</span></td><td>''+esc(row.REASON)+(shares?''<span class="inv73-orgname">''+shares+'' account coverage check(s)</span>'':'''')+''</td></tr>'';',
'}).join(''''):''<tr><td colspan="7" class="inv73-empty">''+(checked?''No eligible Inventory Orgs in this OU and period. Review excluded orgs.'':''Check Inventory Orgs to see eligible organizations in this operating unit.'')+''</td></tr>'';',
'const missingGroups=groups.filter(group=>[...group.members.keys()].some(id=>!selected.has(id)));',
unistr('byId(''inv73-shared-count'').textContent=checked?groups.length+'' relevant account checks''+(missingGroups.length?'' \00B7 ''+missingGroups.length+'' with missing owners'':''''):''Not checked'';'),
'byId(''inv73-shared-count'').className=''inv73-badge ''+(missingGroups.length?''inv73-warn'':''inv73-neutral'');',
'byId(''inv73-shared-list'').className=groups.length?'''':''inv73-empty'';',
'byId(''inv73-shared-list'').innerHTML=groups.length?groups.map(group=>{',
'const members=[...group.members.values()], missingEligible=members.filter(row=>eligible.has(orgId(row))&&!selected.has(orgId(row)));',
'const missing=members.filter(row=>!selected.has(orgId(row))), external=missing.filter(row=>!eligible.has(orgId(row)));',
unistr('const coverage=group.intransit?(unknown?''Unavailable \2014 ownership unconfirmed'':assessment.intransitComplete?''Intransit owner scope included'':''Unavailable \2014 incomplete intransit scope''):missing.length?''Unavailable \2014 partial org scope'':''All owners selec')
||unistr('ted \2014 GL compared once'';'),
'const kinds=[...group.kinds].map(kind=>kind===''V''?''Stock / WIP'':kind===''I''?''Intransit / shared intransit'':''Valuation reference'');',
'return ''<div class="inv73-shared-row"><div><div class="inv73-account">''+esc(group.account)+''</div><p class="inv73-muted">''+esc(kinds.join('' / ''))+''</p></div><ul>''+members.map(row=>{const ready=allRows.find(item=>orgId(item)===orgId(row));const label='
||'selected.has(orgId(row))?''Selected'':eligible.has(orgId(row))?''Not selected'':String(ready&&ready.OU_ID)===ou()?''Excluded'':''Outside OU'';return ''<li>''+esc(row.ORG_CODE)+'' ''+badge(label,label===''Selected''?''neutral'':''warn'')+(row.candidateOnly?'' ''+badge(''C'
||unistr('andidate reference'',''warn''):'''')+''<span class="inv73-orgname">''+esc(row.ORG_NAME)+(ready&&ready.OU_NAME?'' \00B7 ''+esc(ready.OU_NAME):'''')+''</span>''+(row.candidateOnly?''<span class="inv73-orgname">Network reference is a conservative scope check, not proven ')
||'ownership.</span>'':'''')+''</li>'';}).join('''')+''</ul><div><strong>''+esc(coverage)+''</strong><p>''+(group.intransit?''Every owner in the full intransit bucket is assessed.'':''GL is compared once for the combined account; it is never allocated between orgs.'')'
||'+(external.length?'' ''+external.length+'' owner/reference org(s) are outside the eligible OU scope and cannot be added to this run.'':'''')+''</p>''+(missingEligible.length?''<button type="button" class="t-Button t-Button--small" data-inv73-include="''+esc(gr'
||'oup.ccid)+''">Include eligible sharing orgs</button>'':'''')+''</div></div>'';',
'}).join(''''):checked?''No shared-account warning is relevant to the selected orgs.'':''Relevant account warnings appear after Check and org selection.'';',
unistr('byId(''inv73-coverage'').textContent=missingGroups.length?''Missing owners prevent scoped GL comparison. Selected-org amounts remain available; the overall Subledger\2013GL Difference is unavailable.'':'''';'),
'const relevantIntransit=[...assessment.intransitMembers].some(id=>selected.has(id));',
'const eligibleMissing=[...assessment.intransitMembers].filter(id=>eligible.has(id)&&!selected.has(id));',
'const outside=[...assessment.intransitMembers].filter(id=>!eligible.has(id));',
unistr('byId(''inv73-intransit-coverage'').innerHTML=checked&&relevantIntransit?''<strong>Intransit: ''+assessment.selectedIntransitCount+'' / ''+assessment.intransitMembers.size+'' reference orgs selected.</strong> ''+(unknown?''Unavailable \2014 ownership unconfirmed. ')
||unistr('Full-ledger comparison is outside this one-OU run.'':assessment.intransitComplete?''Intransit owner scope included.'':''GL comparison unavailable \2014 incomplete intransit scope.'')+(outside.length?'' ''+outside.length+'' reference org(s) cannot be selected in ')
||'this OU.'':'''')+(eligibleMissing.length?'' <button type="button" class="t-Button t-Button--small" data-inv73-include-intransit>Include eligible intransit orgs</button>'':'''')+'' Network references and observed activity do not prove configured ownership. In'
||'cluding known references does not resolve unknown ownership.'':'''';',
'controls();',
'}',
'function renderCapture() {',
'const meta=data.meta,captured=meta.CAPTURED_LEDGER_ID!=null,unavailableStockCount=Number(meta.ONHAND_UNAVAILABLE_ACCOUNT_COUNT??meta.STOCK_UNAVAILABLE_ACCOUNT_COUNT??0),partial=unavailableStockCount>0,missing=Number(meta.REPORT_MISSING_ORG_COUNT||0),'
||'incomplete=Number(meta.INCOMPLETE_ORG_COUNT||0)>0||missing>0;',
unistr('const ledgerNames={''1003'':''TEREX US \00B7 USD'',''5001'':''TEREX UK 120 \00B7 GBP'',''10001'':''TEREX CH \00B7 EUR''};'),
unistr('byId(''inv73-capture-title'').textContent=captured?(ledgerNames[String(meta.CAPTURED_LEDGER_ID)]||meta.CAPTURED_LEDGER_ID)+'' \00B7 ''+(meta.CAPTURED_OU_NAME||''Operating unit'')+'' \00B7 ''+meta.CAPTURED_PERIOD_NAME+'' \00B7 ''+meta.SELECTED_ORG_COUNT+'' selected org''+(Nu')
||'mber(meta.SELECTED_ORG_COUNT)===1?'''':''s''):''No reconciliation capture'';',
unistr('byId(''inv73-capture-status'').textContent=!captured?''Not run'':incomplete?''Incomplete \00B7 Provisional'':partial?''Stock comparisons unavailable'':''Capture complete'';'),
'byId(''inv73-capture-status'').className=''inv73-badge ''+(!captured?''inv73-neutral'':incomplete||partial?''inv73-warn'':''inv73-good'');',
unistr('byId(''inv73-capture-time'').textContent=captured?''Captured ''+(meta.CAPTURED_AT||'''')+'' \00B7 APEX session collection''+(meta.CAPTURED_COMPANY_CODES?'' \00B7 Company ''+meta.CAPTURED_COMPANY_CODES:''''):'''';'),
unistr('byId(''inv73-report-source'').textContent=captured?''On-hand source: ''+(meta.REPORT_SOURCE_LABEL||(meta.SOURCE_MODE===''LEGACY''?''Previous valuation engine'':''EBS Back Dated Inventory report''))+'' \00B7 ''+(meta.REPORT_ROW_COUNT==null?'''':meta.REPORT_ROW_COUNT+'' ')
||unistr('available report rows \00B7 '')+(meta.SOURCE_MODE===''LEGACY''?''Previous capture; run again to use the EBS report.'':meta.REPORT_SOURCE_FRESHNESS||''Load time not recorded in the EBS reporting table.''):''On-hand source: EBS Back Dated Inventory report. Run to ')
||'capture the selected scope.'';',
unistr('document.querySelectorAll(''[data-inv73-metric]'').forEach(el=>{const key=el.dataset.inv73Metric,value=captured?meta[key+''_DISPLAY'']:null;el.textContent=value==null?''\2014'':String(value);byId(''inv73-workflow'').querySelector(''[data-inv73-note="''+key+''"]'').t')
||unistr('extContent=!captured?''Run to capture'':value==null?''Unavailable \00B7 incomplete stock comparison'':key===''ONHAND_VALUE''?''Full captured scope \00B7 stock only'':key===''STOCK_GL_END_BALANCE''?''Same stock accounts \00B7 GL counted once'':''Full captured scope \00B7 ledger c')
||'urrency'';});',
'const note=byId(''inv73-capture-note'');note.hidden=!captured||(!incomplete&&!partial);note.textContent=[missing?''No report rows for selected org(s): ''+(meta.REPORT_MISSING_ORG_CODES||missing)+''. This is not assumed to mean zero stock. On-hand totals a'
||'re unavailable; results are incomplete and provisional.'':'''',Number(meta.INCOMPLETE_ORG_COUNT||0)>0?meta.INCOMPLETE_ORG_COUNT+'' selected org(s) have incomplete close data. Results are provisional.'':'''',partial?unavailableStockCount+'' stock comparison(s'
||') unavailable. Review each account reason.'':''''].filter(Boolean).join('' '');',
'const seconds=value=>value==null?null:Number(value).toFixed(2)+''s'';',
unistr('byId(''inv73-step-times'').textContent=[meta.CHECK_SECONDS!=null?''Last Check: ''+seconds(meta.CHECK_SECONDS):'''',meta.RUN_SECONDS!=null?''Captured Run: ''+seconds(meta.RUN_SECONDS):''''].filter(Boolean).join('' \00B7 '');'),
'const residuals=(data.exceptions||[]).filter(row=>row.EXCEPTION_TYPE===''DORMANT RESIDUAL WIP'');',
'byId(''inv73-residual-details'').hidden=!captured||!residuals.length;',
unistr('byId(''inv73-residual-count'').textContent=residuals.length+'' excluded residual WIP item(s) \00B7 ''+money(meta.EXCLUDED_RESIDUAL_WIP);'),
unistr('byId(''inv73-residual-list'').innerHTML=residuals.map(row=>''<p><strong>''+esc(row.ORG_CODE)+''</strong> ''+esc(row.ORG_NAME)+'' \00B7 <span class="inv73-account">''+esc(row.ACCOUNT)+''</span> \00B7 WIP ''+money(row.WIP_VALUE)+''<span class="inv73-orgname">''+esc(row.EX')
||'CLUSION_REASON||''Excluded from eligible OU scope'')+''</span></p>'').join('''');',
'controls();',
'}',
'function refreshReports() {opened.clear();showTab(activeTab,false);}',
'function decorate() {document.querySelectorAll(''.inv73-status'').forEach(el=>{const code=el.dataset.inv73Code??el.textContent.trim(),field=el.dataset.inv73Field||''CLOSE_DATA_CHECK'',wording=field===''ROW_TYPE''&&code===''ORG''&&el.closest(''#inv73-report-tr'
||'ansit'')?{label:''Org valuation'',detail:''This org\''s report value. There is no account total or GL allocation.'',tone:''neutral''}:inv73ReportWording.describe(field,code);el.dataset.inv73Code=code;el.textContent=wording.label;el.title=wording.detail;el.se'
||'tAttribute(''aria-label'',wording.label+''. ''+wording.detail);el.className=''inv73-status''+([''ROW_TYPE'',''ORG_CODE''].includes(field)?'''':'' inv73-badge inv73-''+wording.tone);});}',
'function showTab(tab,focus) {',
'activeTab=tabs.includes(tab)?tab:''stock'';',
'tabs.forEach(key=>{const el=byId(''inv73-panel-''+key);if(el){el.hidden=key!==activeTab;el.setAttribute(''role'',''tabpanel'');el.setAttribute(''aria-labelledby'',''inv73-tab-''+key);}byId(''inv73-tab-''+key).setAttribute(''aria-selected'',String(key===activeTab))'
||';byId(''inv73-tab-''+key).tabIndex=key===activeTab?0:-1;});',
'if(focus)byId(''inv73-tab-''+activeTab).focus();',
'$(window).trigger(''apexwindowresized'');',
'if(data.meta.CAPTURED_LEDGER_ID!=null&&!opened.has(activeTab)&&(activeTab===''stock''||data.meta[inv73DiagnosticKind(activeTab,wipView)+''_LOADED'']===''Y'')){opened.add(activeTab);if(activeTab===''stock'')stock.refresh();else apex.region(''inv73-report-''+act'
||'iveTab).refresh();}',
'}',
'async function getState(resetSelection) {',
'const response=await apex.server.process(''P73_STATE'',{}, {dataType:''json''});',
'if(!response||response.ok!==true)throw Error(response&&response.message||''Unable to read the captured page state.'');',
'const nativeChanged=[''P73_CAPTURE_COLL'',''P73_WIP_COLL'',''P73_INTRANSIT_COLL''].some((item,index)=>String(apex.item(item).getValue()||'''')!==String([response.capture_collection,inv73DiagnosticPointer(response,wipView),response.intransit_collection][index'
||']||'''')),captureChanged=primaryPin!==String(response.primary_collection||'''');',
'primaryPin=String(response.primary_collection||'''');',
'if(captureChanged)tabs.forEach(tab=>{const region=byId(''inv73-report-''+tab);if(region)region.style.visibility=''hidden'';});',
'apex.item(''P73_CAPTURE_COLL'').setValue(response.capture_collection||'''');',
'apex.item(''P73_WIP_COLL'').setValue(inv73DiagnosticPointer(response,wipView));',
'apex.item(''P73_INTRANSIT_COLL'').setValue(response.intransit_collection||'''');',
'data=response;',
'const eligible=eligibleIds(),nextSelectionKey=matchingCheck()?String(data.token):'''';',
'if(resetSelection)selected=new Set(eligible);',
'else if(nextSelectionKey!==selectionCheckKey&&matchingCheck()){selected=data.meta.CAPTURED_ORG_IDS&&data.meta.CAPTURED_ORG_IDS!==''ALL''&&String(data.meta.CAPTURED_LEDGER_ID)===ledger()&&data.meta.CAPTURED_PERIOD_NAME===period()&&String(data.meta.CAPTU'
||'RED_OU_ID)===ou()?new Set(String(data.meta.CAPTURED_ORG_IDS).split('':'').filter(id=>eligible.has(id))):new Set(eligible);}',
'else selected=new Set([...selected].filter(id=>eligible.has(id)));',
'selectionCheckKey=nextSelectionKey;',
'renderReadiness();renderCapture();',
'const stockChanged=stock.setSnapshot(primaryPin,response.onhand_orgs||[]);',
'if(captureChanged)refreshReports();else if(nativeChanged){tabs.filter(tab=>tab!==''stock'').forEach(tab=>opened.delete(tab));showTab(activeTab,false);}else if(stockChanged&&activeTab===''stock'')stock.refresh();',
'return captureChanged;',
'}',
'byId(''inv73-check'').addEventListener(''click'',async()=>{',
'if(busy||!ledger()||!period()||!ou())return;',
'setBusy(true,''check'');message(''Checking the cached org/period and account lookups, with live close-summary availability. Previous successful results remain available.'');',
'try {const response=await apex.server.process(''P73_CHECK'',{x01:ledger(),x02:period(),x03:ou()},{dataType:''json'',timeout:0});if(!response||!response.ok)throw Error(response&&response.message||''Readiness check failed.'');await getState(true);message(''El'
||'igible Inventory Orgs are ready for selection. Review account coverage warnings, then run reconciliation.'');}',
'catch(error){message((error.message||''Readiness check failed.'')+'' The previous successful check and reconciliation capture remain available.'',true);}',
'finally{setBusy(false);}',
'});',
'byId(''inv73-refresh-lookup'').addEventListener(''click'',async()=>{',
'if(busy)return;',
'setBusy(true,''lookup'');message(''Refreshing org/period and account lookups. The previous successful reconciliation capture remains available.'');',
'try {const response=await apex.server.process(''P73_REFRESH_LOOKUP'',{}, {dataType:''json'',timeout:0});if(!response||!response.ok)throw Error(response&&response.message||''Org/period and account lookup refresh failed.'');selected.clear();await getState(fa'
||'lse);message(''Org/period and account lookups refreshed. Select ledger, period, and OU, then Check Inventory Orgs before running.'');}',
'catch(error){message((error.message||''Org/period and account lookup refresh failed.'')+'' The previous successful check and reconciliation capture remain available.'',true);}',
'finally{setBusy(false);}',
'});',
'byId(''inv73-run'').addEventListener(''click'',async()=>{',
'if(busy||!matchingCheck()||!selected.size||selectionGate().blocked)return;',
'const runScope=scope();let published=false,confirmedFailure=false;setBusy(true,''run'');message(''Capturing EBS Back Dated Inventory and relevant GL balances for ''+selected.size+'' org(s). Previous results remain visible.'');',
'try {const response=await apex.server.process(''P73_RUN'',{x01:data.token,x02:ledger(),x03:period(),x04:runScope,x05:ou()},{dataType:''json'',timeout:0});if(!response||response.ok!==true){confirmedFailure=Boolean(response&&response.ok===false);throw Erro'
||'r(response&&response.message||''The Run response could not be confirmed.'');}published=true;apex.item(''P73_CCID'').setValue('''');byId(''inv73-account-context'').hidden=true;const captureChanged=await getState(false);message(''OU reconciliation capture compl'
||'eted. Review completeness and GL-scope labels before interpreting differences.'');try{if(!captureChanged)refreshReports();}catch(error){message(''Reconciliation capture completed, but a report could not refresh. Reload the page to view the successful c'
||'apture.'',true);}}',
'catch(error){message(published?''Reconciliation capture completed, but the page could not reload its state. Reload the page to view the successful capture.'':confirmedFailure?(error.message||''Reconciliation failed.'')+'' The previous successful capture r'
||'emains available.'':''Run could not be confirmed; reload to check the latest successful capture. The displayed results remain pinned to their original capture.'',true);}',
'finally{setBusy(false);}',
'});',
'$(document).on(''click'',''[data-inv73-diagnostics]'',async function(){',
'if(busy||data.meta.CAPTURED_LEDGER_ID==null)return;',
'const kind=this.dataset.inv73Diagnostics;if(!Object.hasOwn(inv73DiagnosticLabels,kind))return;',
'setBusy(true,''diagnostics'');message(''Loading ''+inv73DiagnosticLabels[kind]+'' for the captured scope.''+(kind===''ACCOUNTING''?'' This can take several minutes.'':''''));',
'let published=false,failed=false;',
'try{const response=await apex.server.process(''P73_DIAGNOSTICS'',{x01:kind}, {dataType:''json'',timeout:0});if(!response||response.ok!==true){failed=Boolean(response&&response.ok===false);throw Error(response&&response.message||''Diagnostics response not '
||'confirmed.'');}published=true;await getState(false);message(inv73DiagnosticLabels[kind]+'' loaded. The on-hand capture is unchanged.'');}',
'catch(error){message(published?''Diagnostics completed; reload to display the successful state.'':failed?(error.message||''Diagnostics failed.'')+'' Previous captures remain available.'':''Diagnostics could not be confirmed. Reload to check the latest succe'
||'ssful state.'',true);}',
'finally{setBusy(false);}',
'});',
'$(document).on(''click'',''[data-inv73-wip-view]'',function(){',
'const next=this.dataset.inv73WipView;if(busy||![''WIP'',''WIP_ACTIVITY''].includes(next)||next===wipView)return;',
'wipView=next;apex.item(''P73_WIP_COLL'').setValue(inv73DiagnosticPointer(data,wipView));opened.delete(''wip'');',
'byId(''inv73-report-wip'').style.visibility=''hidden'';controls();if(activeTab===''wip'')showTab(''wip'',false);',
'});',
'$(''#P73_LEDGER_ID,#P73_PERIOD_NAME,#P73_OU_ID'').on(''change'',()=>{if(busy)return;selected.clear();data.token='''';selectionCheckKey='''';message('''');renderReadiness();renderCapture();});',
'$(document).on(''change'',''.inv73-org-check'',function(){if(busy||!matchingCheck())return;selected=inv73PickerSelection.toggle(data.readiness,ou(),selected,this.value,this.checked);picker.announce(this.checked?''Selected the eligible active owner group.'''
||':''Removed the eligible active owner group.'');renderReadiness();renderCapture();});',
'$(document).on(''click'',''[data-inv73-select]'',function(){if(busy||!matchingCheck())return;const action=this.dataset.inv73Select;selected=inv73PickerSelection.bulk(data.readiness,ou(),action);picker.announce(action===''ready''?''Selected complete READY gr'
||'oups only. Groups with non-READY or unavailable active owners were left out.'':action===''all''?''All eligible orgs selected. Review any blocked groups before Run.'':''Selection cleared.'');renderReadiness();renderCapture();});',
'$(document).on(''click'',''[data-inv73-include]'',function(){if(busy||!matchingCheck())return;const group=ownersByAccount().find(g=>g.ccid===this.dataset.inv73Include);if(group)selected=inv73PickerSelection.include(data.readiness,ou(),selected,group.memb'
||'ers.keys());renderReadiness();renderCapture();});',
'$(document).on(''click'',''[data-inv73-include-intransit]'',function(){if(busy||!matchingCheck())return;selected=inv73PickerSelection.include(data.readiness,ou(),selected,inv73AssessOwnerScope(data.owners,selected).intransitMembers);renderReadiness();ren'
||'derCapture();});',
'$(document).on(''click'',''[data-inv73-required-group]'',function(){if(busy||!matchingCheck())return;const row=data.readiness.find(item=>orgId(item)===this.dataset.inv73RequiredGroup),eligible=eligibleIds();if(!row||row.OWNERSHIP_BLOCKED===''Y'')return;con'
||'st ids=String(row.OWNERSHIP_GROUP_IDS||'''').split('':'').filter(Boolean);if(!ids.length||!ids.every(id=>eligible.has(id)))return;ids.forEach(id=>selected.add(id));renderReadiness();renderCapture();});',
'$(document).on(''click'',''[data-inv73-deselect-blocked]'',function(){if(busy||!matchingCheck())return;const remove=selectionGate().blockedSelectedIds;remove.forEach(id=>selected.delete(id));renderReadiness();renderCapture();message(''Deselected ''+remove.'
||'size+'' org(s) from blocked ownership groups. Other selected orgs are unchanged.'');});',
'$(document).on(''click'',''[data-inv73-tab]'',function(){showTab(this.dataset.inv73Tab,false);});',
'$(document).on(''keydown'',''[data-inv73-tab]'',function(event){if(![''ArrowLeft'',''ArrowRight'',''Home'',''End''].includes(event.key))return;event.preventDefault();let index=tabs.indexOf(this.dataset.inv73Tab);index=event.key===''Home''?0:event.key===''End''?tabs.'
||'length-1:(index+(event.key===''ArrowRight''?1:tabs.length-1))%tabs.length;showTab(tabs[index],true);});',
'tabs.filter(tab=>tab!==''stock'').forEach(tab=>$(''#inv73-report-''+tab).on(''apexafterrefresh'',function(){this.style.visibility='''';decorate();}));',
'showTab(''stock'',false);controls();',
'getState(false).catch(error=>message(error.message,true));',
'})();',
''))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.inv73-intro h1{margin:0 0 6px}.inv73-intro p{margin:6px 0}.inv73-muted{font-size:12px;color:var(--ut-body-text-color,#333);opacity:.75}.inv73-toolbar{display:flex;align-items:center;gap:10px;flex-wrap:wrap;margin:12px 0}.inv73-toolbar .inv73-push{ma'
||'rgin-left:auto}.inv73-badge{display:inline-block;padding:3px 7px;border-radius:4px;font-size:11px;font-weight:600;white-space:nowrap}.inv73-good{background:#e6f4eb;color:#185c37}.inv73-warn{background:#fff1d6;color:#704500}.inv73-neutral{background:v'
||'ar(--ut-component-background-color,#eef0f3);color:var(--ut-body-text-color,#333)}.inv73-error{background:#fde5e7;color:#9d1521}.inv73-message{padding:12px 16px;margin:12px 0;border-left:3px solid var(--ut-palette-primary,#bb2834);background:var(--ut-'
||'component-background-color,#f5f6fa)}.inv73-message[hidden],.inv73-panel[hidden],#inv73-workflow [hidden]{display:none!important}.inv73-scroll{overflow:auto;max-height:390px}.inv73-table{width:100%;min-width:950px;border-collapse:collapse;font-size:12'
||'px}.inv73-table th,.inv73-table td{padding:10px 12px;border-bottom:1px solid var(--ut-component-border-color,#ddd);vertical-align:top;text-align:left}.inv73-table th{position:sticky;top:0;background:var(--ut-region-header-background-color,#edf2f6);z-'
||'index:1;font-weight:600}.inv73-table td:first-child{min-width:190px}.inv73-table label{display:flex;gap:8px;align-items:flex-start}.inv73-table input{margin-top:3px}.inv73-orgname{display:block;font-size:11px;opacity:.75;margin-top:3px}.inv73-shared{'
||'border:1px solid var(--ut-component-border-color,#ddd);margin:14px 0}#inv73-shared-list{max-height:430px;overflow:auto}.inv73-shared-header{padding:12px 14px;background:var(--ut-region-header-background-color,#f7f4ed);display:flex;gap:10px;flex-wrap:'
||'wrap;align-items:center}.inv73-shared-header h3{margin:0;font-size:15px}.inv73-shared-row{display:grid;grid-template-columns:minmax(220px,1fr) minmax(220px,1fr) minmax(250px,1.3fr);gap:16px;padding:12px 14px;border-top:1px solid var(--ut-component-bo'
||'rder-color,#ddd)}.inv73-account{font:12px Consolas,monospace;overflow-wrap:anywhere}.inv73-shared-row p{margin:4px 0;font-size:12px}.inv73-shared-row ul{margin:0;padding-left:17px;font-size:12px}.inv73-shared-foot{padding:10px 14px;font-size:11px;opa'
||'city:.75}.inv73-cards{display:grid;grid-template-columns:repeat(5,minmax(0,1fr));gap:12px;margin:16px 0}.inv73-card{border:1px solid var(--ut-component-border-color,#ddd);background:var(--ut-region-background-color,#fff);padding:16px 14px;min-height:'
||'108px;border-radius:4px}.inv73-card-label{font-size:12px;min-height:32px;display:block}.inv73-card-value{font-size:23px;font-weight:600;display:block;font-variant-numeric:tabular-nums;overflow-wrap:anywhere}.inv73-card-note{font-size:10px;opacity:.75'
||';display:block;margin-top:6px}.inv73-context{display:flex;align-items:center;gap:12px;flex-wrap:wrap;margin:15px 0}.inv73-context strong{font-size:15px}.inv73-tabs{display:flex;gap:4px;border-bottom:1px solid var(--ut-component-border-color,#ddd);mar'
||'gin-top:16px;overflow:auto}.inv73-tab{border:0;border-bottom:3px solid transparent;background:transparent;color:inherit;padding:13px 17px;white-space:nowrap;font:inherit;cursor:pointer}.inv73-tab[aria-selected=true]{border-color:var(--ut-palette-prim'
||'ary,#bb2834);font-weight:600}.inv73-diff{color:var(--ut-palette-danger,#a31625);font-weight:600}#inv73-filters .apex-item-group--popup-lov,#inv73-filters .apex-item-select{min-height:50px}.inv73-panel .a-IRR-header{background:var(--ut-region-header-b'
||'ackground-color,#edf2f6);text-align:center;font-weight:600}.inv73-panel .a-IRR-headerLink{font-weight:600;color:inherit}#inv73-workflow [aria-busy=true]{opacity:.7}.inv73-empty{padding:20px;opacity:.75}.inv73-timer{font-variant-numeric:tabular-nums;f'
||'ont-size:12px}.inv73-meta{font-size:12px;opacity:.8}.inv73-coverage{margin-top:7px;font-size:12px}.inv73-coverage strong{color:#9a6000}@media(max-width:1050px){.inv73-cards{grid-template-columns:repeat(3,minmax(0,1fr))}.inv73-shared-row{grid-template'
||'-columns:1fr}}@media(max-width:600px){.inv73-cards{grid-template-columns:1fr 1fr}.inv73-card-value{font-size:20px}.inv73-toolbar .inv73-push{margin-left:0}}',
'/* Preserve readable card context text at the default page scale. */',
'.inv73-card-note{font-size:11px}',
'/* V3 keeps one-OU decisions compact; report behavior remains native. */',
'.inv73-company{margin:2px 0 12px}.inv73-lookup-details{margin:6px 0 10px;font-size:12px}.inv73-lookup-details summary,.inv73-excluded summary,.inv73-shared summary{cursor:pointer}.inv73-excluded{padding:9px 12px;margin:10px 0;border:1px solid var(--u'
||'t-component-border-color,#ddd);font-size:12px}.inv73-excluded p{margin:8px 0}#inv73-excluded-list,#inv73-residual-list{max-height:220px;overflow:auto}.inv73-shared .inv73-coverage{padding:8px 14px;margin:0}.inv73-table{min-width:800px}.inv73-scroll{m'
||'ax-height:340px}',
'.inv73-owner-codes{max-width:160px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}.inv73-owner-detail{font-size:11px;margin-top:5px;max-width:170px}.inv73-owner-detail summary{cursor:pointer}.inv73-gate p{margin:7px 0;font-size:12px}.inv73'
||'-gate{border-left-color:#a31625}.inv73-table{min-width:930px}',
'/* Stock-only comparison and local paginated Account > Org > Subinventory tree. */',
'.inv73-picker{margin:15px 0;padding:16px;border:1px solid var(--ut-component-border-color,#ddd);border-radius:6px;background:var(--ut-region-background-color,#fff)}.inv73-picker-head{display:flex;align-items:center;justify-content:space-between;gap:1'
||'2px;flex-wrap:wrap}.inv73-picker-head h2{font-size:18px;margin:0}.inv73-picker-chips{display:flex;flex-wrap:wrap;gap:7px;margin:12px 0}.inv73-picker-chip{display:inline-flex;align-items:center;gap:10px;max-width:100%;padding:7px 10px;min-height:36px;'
||'border:1px solid var(--ut-component-border-color,#ddd);border-radius:5px;background:var(--ut-component-background-color,#f5f6fa);color:var(--ut-body-text-color,#333);font:inherit;font-size:12px;text-align:left;cursor:pointer}.inv73-picker-chip span{f'
||'ont-size:17px;opacity:.7}.inv73-picker-menu{border:1px solid var(--ut-component-border-color,#ddd);border-radius:5px;padding:12px;margin-top:12px}.inv73-picker-search-label{display:block;font-size:12px;margin-bottom:5px}.inv73-picker-search{width:100'
||'%;min-height:40px;background:var(--ut-component-background-color,#fff);color:var(--ut-body-text-color,#333)}.inv73-picker-rows{max-height:320px;overflow:auto}.inv73-picker-row{display:flex;align-items:center;gap:12px;padding:11px 6px;min-height:48px;'
||'border-bottom:1px solid var(--ut-component-border-color,#ddd);cursor:pointer;font-size:13px}.inv73-picker-row:last-child{border-bottom:0}.inv73-picker-row:hover{background:var(--ut-component-background-color,#f5f6fa)}.inv73-picker-row input{width:18p'
||'x;height:18px;flex:0 0 auto;margin:0;accent-color:var(--ut-palette-primary,#51449a)}.inv73-picker-row:focus-within{outline:2px solid var(--ut-palette-primary,#51449a);outline-offset:-2px}.inv73-picker-name{flex:1;min-width:0}.inv73-picker-secondary{d'
||'isplay:block;font-size:11px;opacity:.8;margin-top:3px}.inv73-picker-blocker{color:var(--ut-palette-warning,#805613);opacity:1}.inv73-picker-empty{padding:15px 4px;font-size:12px}.inv73-picker-message{font-size:12px;min-height:18px;margin-top:8px}.inv'
||'73-readiness-details{margin:15px 0}.inv73-readiness-details>summary{padding:9px 0;cursor:pointer;font-size:13px}.inv73-readiness-details>summary span{margin-left:8px}.inv73-picker-chip:focus-visible{outline:2px solid var(--ut-palette-primary,#51449a)'
||';outline-offset:2px}@media(max-width:600px){.inv73-picker{padding:12px}.inv73-picker-row{align-items:flex-start}.inv73-picker-row input{margin-top:2px}.inv73-picker-row>.inv73-badge{max-width:115px;white-space:normal}}@media(pointer:coarse){.inv73-pi'
||'cker-chip{min-height:44px}.inv73-picker-search{font-size:16px}}',
'.inv73-stock-cards{grid-template-columns:repeat(3,minmax(0,1fr))}.inv73-stock-toolbar{display:flex;flex-wrap:wrap;justify-content:space-between;align-items:center;gap:12px;margin:12px 0}.inv73-stock-toolbar h2{font-size:18px;margin:0}.inv73-stock-too'
||'lbar>div{display:flex;align-items:center;gap:16px;flex-wrap:wrap}.inv73-stock-toolbar label{font-size:12px;display:flex;gap:7px;align-items:center}.inv73-stock-toolbar select{background:var(--ut-component-background-color,#fff);color:var(--ut-body-te'
||'xt-color,#333);padding:6px;border:1px solid var(--ut-component-border-color,#ddd);max-width:280px}.inv73-stock-scroll{overflow:auto;max-height:580px;border:1px solid var(--ut-component-border-color,#ddd)}.inv73-stock-table{width:100%;border-collapse:'
||'collapse;font-size:12px;min-width:850px}.inv73-stock-table th,.inv73-stock-table td{padding:12px 10px;text-align:left;vertical-align:top;border-bottom:1px solid var(--ut-component-border-color,#ddd)}.inv73-stock-table th{background:var(--ut-region-he'
||'ader-background-color,#edf2f6);font-weight:600;position:sticky;top:0;z-index:1}.inv73-stock-table th:first-child{width:34%}.inv73-stock-table .inv73-stock-num{text-align:right;white-space:nowrap;font-variant-numeric:tabular-nums}.inv73-stock-expand{d'
||'isplay:flex;gap:8px;border:0;background:transparent;color:var(--ut-link-text-color,#51449a);font:inherit;text-align:left;padding:0;cursor:pointer}.inv73-stock-expand:focus-visible{outline:2px solid var(--ut-palette-primary,#51449a);outline-offset:4px'
||'}.inv73-stock-caption{display:block;font-size:11px;opacity:.75;margin-top:4px;white-space:normal}.inv73-stock-detail{background:var(--ut-component-background-color,#f5f6fa)}.inv73-stock-detail td:first-child{padding-left:28px}.inv73-stock-sub td:firs'
||'t-child{padding-left:48px}.inv73-stock-unavailable{color:var(--ut-palette-warning,#805613)}@media(max-width:650px){.inv73-stock-cards{grid-template-columns:1fr}}',
'',
'/* Plain-language report descriptions and status guidance. */',
'.inv73-report-guide{margin:8px 0 14px;font-size:12px;max-width:1050px}.inv73-report-guide summary{cursor:pointer;font-weight:600}.inv73-report-guide p{margin:8px 0}.inv73-status.inv73-badge{white-space:normal;line-height:1.45}',
'.inv73-wip-views{display:flex;gap:.5rem;margin-bottom:.75rem}',
'.inv73-wip-views [aria-pressed="true"]{box-shadow:inset 0 -3px 0 var(--ut-palette-primary,#3067b1);font-weight:700}',
''))
,p_step_template=>4075783602716660119
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(18558063129193156)
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(15421947847694280)
,p_plug_name=>'Cumulative Accounting'
,p_static_id=>'cumulative-accounting'
,p_region_name=>'inv73-report-accounting'
,p_parent_plug_id=>wwv_flow_imp.id(15421835186694280)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select * from (select j.* from apex_collections c,json_table(c.clob001,''$'' columns (',
'LEDGER_NAME varchar2(500) path ''$.LEDGER_NAME'' null on error,',
'PERIOD_NAME varchar2(500) path ''$.PERIOD_NAME'' null on error,',
'ACCOUNT varchar2(4000) path ''$.ACCOUNT'' null on error,',
'ACCOUNT_SETUP varchar2(500) path ''$.ACCOUNT_SETUP'' null on error,',
'ORG_CODE varchar2(500) path ''$.ORG_CODE'' null on error,',
'ROW_TYPE varchar2(500) path ''$.ROW_TYPE'' null on error,',
'CLOSE_DATA_CHECK varchar2(500) path ''$.CLOSE_DATA_CHECK'' null on error,',
'ONHAND_VALUE number path ''$.ONHAND_VALUE'' null on error,',
'INTRANSIT_VALUE number path ''$.INTRANSIT_VALUE'' null on error,',
'WIP_VALUE number path ''$.WIP_VALUE'' null on error,',
'TOTAL_VALUE number path ''$.TOTAL_VALUE'' null on error,',
'ACCOUNTED_MTA number path ''$.ACCOUNTED_MTA'' null on error,',
'VALUE_VS_MTA_DIFF number path ''$.VALUE_VS_MTA_DIFF'' null on error,',
'SUBLEDGER_PRIOR number path ''$.SUBLEDGER_PRIOR'' null on error,',
'SUBLEDGER_END number path ''$.SUBLEDGER_END'' null on error,',
'SUBLEDGER_CHANGE number path ''$.SUBLEDGER_CHANGE'' null on error,',
'SLA_NOT_IN_GL number path ''$.SLA_NOT_IN_GL'' null on error,',
'GL_COST_MGMT_NET number path ''$.GL_COST_MGMT_NET'' null on error,',
'GL_COST_MGMT_UNPOSTED number path ''$.GL_COST_MGMT_UNPOSTED'' null on error,',
'GL_OTHER_SOURCES_NET number path ''$.GL_OTHER_SOURCES_NET'' null on error,',
'GL_PERIOD_NET number path ''$.GL_PERIOD_NET'' null on error,',
'GL_END_BALANCE number path ''$.GL_END_BALANCE'' null on error,',
'ACTIVITY_DIFF number path ''$.ACTIVITY_DIFF'' null on error,',
'SUBLEDGER_VS_GL_DIFF number path ''$.SUBLEDGER_VS_GL_DIFF'' null on error,',
'LEDGER_ID number path ''$.LEDGER_ID'' null on error,',
'CCID number path ''$.CCID'' null on error,',
'ORG_ID number path ''$.ORG_ID'' null on error,',
'GL_SCOPE_STATUS varchar2(500) path ''$.GL_SCOPE_STATUS'' null on error,',
'OWNER_COUNT number path ''$.OWNER_COUNT'' null on error,',
'SELECTED_OWNER_COUNT number path ''$.SELECTED_OWNER_COUNT'' null on error,',
'MISSING_OWNER_CODES varchar2(4000) path ''$.MISSING_OWNER_CODES'' null on error,',
'READINESS_STATUS varchar2(500) path ''$.READINESS_STATUS'' null on error,',
'FULL_LEDGER_GL_END_BALANCE number path ''$.FULL_LEDGER_GL_END_BALANCE'' null on error',
')) j where c.collection_name=:P73_CAPTURE_COLL and c.collection_name in (xxinv128_diag_pkg.current_collection(''ACCOUNTING''))) where 1=1'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P73_CAPTURE_COLL'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(15422089861694280)
,p_no_data_found_message=>'No captured rows for this view. Select a ledger and period, check Inventory Orgs, and run reconciliation.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_fixed_header=>'REGION'
,p_fixed_header_max_height=>550
,p_lazy_loading=>true
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:XLSX'
,p_enable_mail_download=>'N'
,p_internal_uid=>15422089861694280
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15422415341694280)
,p_db_column_name=>'ACCOUNT'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Account'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15423394475694280)
,p_db_column_name=>'ACCOUNTED_MTA'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Accounted Mta'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15422506575694280)
,p_db_column_name=>'ACCOUNT_SETUP'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Account Category'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15424418371694280)
,p_db_column_name=>'ACTIVITY_DIFF'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Activity Difference'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15424783718694280)
,p_db_column_name=>'CCID'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Ccid'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15422875903694280)
,p_db_column_name=>'CLOSE_DATA_CHECK'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Inventory close data'
,p_column_html_expression=>'<span class="inv73-status" data-inv73-field="CLOSE_DATA_CHECK">#CLOSE_DATA_CHECK#</span>'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_help_text=>'Inventory period and close-summary availability. Available close data does not mean the balance agrees with GL.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15425476893694280)
,p_db_column_name=>'FULL_LEDGER_GL_END_BALANCE'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Full Ledger GL Balance (Context Only)'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_help_text=>'Full ledger account balance for context only. It is not allocated to an org or valuation basis.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15423967125694280)
,p_db_column_name=>'GL_COST_MGMT_NET'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Gl Cost Mgmt Net'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15424046344694280)
,p_db_column_name=>'GL_COST_MGMT_UNPOSTED'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Cost Management Unposted'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15424393464694280)
,p_db_column_name=>'GL_END_BALANCE'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'GL End Balance'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15424165921694280)
,p_db_column_name=>'GL_OTHER_SOURCES_NET'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Gl Other Sources Net'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15424262560694280)
,p_db_column_name=>'GL_PERIOD_NET'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Gl Period Net'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15424996092694280)
,p_db_column_name=>'GL_SCOPE_STATUS'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'GL balance availability'
,p_column_html_expression=>'<span class="inv73-status" data-inv73-field="GL_SCOPE_STATUS">#GL_SCOPE_STATUS#</span>'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_help_text=>'Full-account GL coverage for this selection. Other recorded owners, including dormant or historical references, can withhold the comparison. GL is not allocated to org detail or to WIP alone.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15423055715694280)
,p_db_column_name=>'INTRANSIT_VALUE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Intransit Value'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15424699919694280)
,p_db_column_name=>'LEDGER_ID'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Ledger Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15422232662694280)
,p_db_column_name=>'LEDGER_NAME'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Ledger Name'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15425250910694280)
,p_db_column_name=>'MISSING_OWNER_CODES'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Unselected Owners'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15422987510694280)
,p_db_column_name=>'ONHAND_VALUE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Onhand Value'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15422639636694280)
,p_db_column_name=>'ORG_CODE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Inventory Org'
,p_column_html_expression=>'<span class="inv73-status" data-inv73-field="ORG_CODE">#ORG_CODE#</span>'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15424810154694280)
,p_db_column_name=>'ORG_ID'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Org Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15425090988694280)
,p_db_column_name=>'OWNER_COUNT'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Account Owners'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15422382558694280)
,p_db_column_name=>'PERIOD_NAME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Period Name'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15425376345694280)
,p_db_column_name=>'READINESS_STATUS'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Inventory Readiness'
,p_column_html_expression=>'<span class="inv73-status" data-inv73-field="READINESS_STATUS">#READINESS_STATUS#</span>'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15422707185694280)
,p_db_column_name=>'ROW_TYPE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Amount represents'
,p_column_html_expression=>'<span class="inv73-status" data-inv73-field="ROW_TYPE">#ROW_TYPE#</span>'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_help_text=>'Account total combines the selected Inventory Orgs. Org breakdown rows show contributions to that same total. Do not add both levels together.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15425124886694280)
,p_db_column_name=>'SELECTED_OWNER_COUNT'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Selected Owners'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15423880581694280)
,p_db_column_name=>'SLA_NOT_IN_GL'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'SLA Awaiting Transfer'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15423788749694280)
,p_db_column_name=>'SUBLEDGER_CHANGE'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Subledger Change'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15423683898694280)
,p_db_column_name=>'SUBLEDGER_END'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Subledger End Balance'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15423595480694280)
,p_db_column_name=>'SUBLEDGER_PRIOR'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Subledger Prior'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15424567488694280)
,p_db_column_name=>'SUBLEDGER_VS_GL_DIFF'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>unistr('Subledger\2013GL Difference')
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15423242500694280)
,p_db_column_name=>'TOTAL_VALUE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Total Inventory Value'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15423453834694280)
,p_db_column_name=>'VALUE_VS_MTA_DIFF'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Value Vs Mta Diff'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15423158432694280)
,p_db_column_name=>'WIP_VALUE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'WIP value'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(15422132589694280)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'inv73-accounting'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>25
,p_report_columns=>'ROW_TYPE:ACCOUNT:ACCOUNT_SETUP:CLOSE_DATA_CHECK:TOTAL_VALUE:SUBLEDGER_END:GL_END_BALANCE:SLA_NOT_IN_GL:GL_COST_MGMT_UNPOSTED:ACTIVITY_DIFF:SUBLEDGER_VS_GL_DIFF'
,p_sort_column_1=>'ACCOUNT'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'ROW_TYPE'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'ORG_CODE'
,p_sort_direction_3=>'ASC'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(15421835186694280)
,p_plug_name=>'Cumulative Accounting Panel'
,p_static_id=>'cumulative-accounting-panel'
,p_region_name=>'inv73-panel-accounting'
,p_region_css_classes=>'inv73-panel'
,p_region_template_options=>'#DEFAULT#:t-Region--noBorder:t-Region--hideHeader'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>70
,p_plug_item_display_point=>'ABOVE'
,p_plug_source=>'<div class="inv73-diagnostics"><strong data-inv73-diagnostics-status>Not loaded</strong><p data-inv73-diagnostics-basis></p><button type="button" class="t-Button" data-inv73-diagnostics>Load this view</button><span class="inv73-meta" data-inv73-diagn'
||'ostics-time></span><p class="inv73-warning" data-inv73-diagnostics-availability hidden></p></div><details class="inv73-report-guide"><summary>How to read these rows</summary><p><strong>Account total</strong> combines the selected Inventory Orgs. <str'
||'ong>Org breakdown</strong> shows each org''s contribution to that same amount. Do not add the total and breakdown together.</p><p><strong>Inventory close data</strong> tells you whether the Inventory period is closed and the required close summaries a'
||'re available. It does not mean the balance agrees with GL.</p><p><strong>GL balance availability</strong> tells you whether the whole-account GL balance can be used for this selection. Other recorded owners, including dormant or historical references'
||', can prevent the GL comparison even when your active org selection is valid. GL is shown only at account total level.</p></details>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(15429315056694316)
,p_plug_name=>'Intransit'
,p_static_id=>'intransit'
,p_region_name=>'inv73-report-transit'
,p_parent_plug_id=>wwv_flow_imp.id(15429295815694316)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select * from (select j.* from apex_collections c,json_table(c.clob001,''$'' columns (',
'LEDGER_NAME varchar2(500) path ''$.LEDGER_NAME'' null on error,',
'PERIOD_NAME varchar2(500) path ''$.PERIOD_NAME'' null on error,',
'ACCOUNT varchar2(4000) path ''$.ACCOUNT'' null on error,',
'ACCOUNT_SETUP varchar2(500) path ''$.ACCOUNT_SETUP'' null on error,',
'ORG_CODE varchar2(500) path ''$.ORG_CODE'' null on error,',
'ROW_TYPE varchar2(500) path ''$.ROW_TYPE'' null on error,',
'CLOSE_DATA_CHECK varchar2(500) path ''$.CLOSE_DATA_CHECK'' null on error,',
'ONHAND_VALUE number path ''$.ONHAND_VALUE'' null on error,',
'INTRANSIT_VALUE number path ''$.INTRANSIT_VALUE'' null on error,',
'WIP_VALUE number path ''$.WIP_VALUE'' null on error,',
'TOTAL_VALUE number path ''$.TOTAL_VALUE'' null on error,',
'ACCOUNTED_MTA number path ''$.ACCOUNTED_MTA'' null on error,',
'VALUE_VS_MTA_DIFF number path ''$.VALUE_VS_MTA_DIFF'' null on error,',
'SUBLEDGER_PRIOR number path ''$.SUBLEDGER_PRIOR'' null on error,',
'SUBLEDGER_END number path ''$.SUBLEDGER_END'' null on error,',
'SUBLEDGER_CHANGE number path ''$.SUBLEDGER_CHANGE'' null on error,',
'SLA_NOT_IN_GL number path ''$.SLA_NOT_IN_GL'' null on error,',
'GL_COST_MGMT_NET number path ''$.GL_COST_MGMT_NET'' null on error,',
'GL_COST_MGMT_UNPOSTED number path ''$.GL_COST_MGMT_UNPOSTED'' null on error,',
'GL_OTHER_SOURCES_NET number path ''$.GL_OTHER_SOURCES_NET'' null on error,',
'GL_PERIOD_NET number path ''$.GL_PERIOD_NET'' null on error,',
'GL_END_BALANCE number path ''$.GL_END_BALANCE'' null on error,',
'ACTIVITY_DIFF number path ''$.ACTIVITY_DIFF'' null on error,',
'SUBLEDGER_VS_GL_DIFF number path ''$.SUBLEDGER_VS_GL_DIFF'' null on error,',
'LEDGER_ID number path ''$.LEDGER_ID'' null on error,',
'CCID number path ''$.CCID'' null on error,',
'ORG_ID number path ''$.ORG_ID'' null on error,',
'GL_SCOPE_STATUS varchar2(500) path ''$.GL_SCOPE_STATUS'' null on error,',
'OWNER_COUNT number path ''$.OWNER_COUNT'' null on error,',
'SELECTED_OWNER_COUNT number path ''$.SELECTED_OWNER_COUNT'' null on error,',
'MISSING_OWNER_CODES varchar2(4000) path ''$.MISSING_OWNER_CODES'' null on error,',
'READINESS_STATUS varchar2(500) path ''$.READINESS_STATUS'' null on error,',
'FULL_LEDGER_GL_END_BALANCE number path ''$.FULL_LEDGER_GL_END_BALANCE'' null on error',
')) j where c.collection_name=:P73_INTRANSIT_COLL and c.collection_name in (xxinv128_diag_pkg.current_collection(''INTRANSIT''))) where 1=1'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P73_INTRANSIT_COLL'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(15429411191694316)
,p_no_data_found_message=>'No captured rows for this view. Select a ledger and period, check Inventory Orgs, and run reconciliation.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_fixed_header=>'REGION'
,p_fixed_header_max_height=>550
,p_lazy_loading=>true
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:XLSX'
,p_enable_mail_download=>'N'
,p_internal_uid=>15429411191694316
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15429881575694316)
,p_db_column_name=>'ACCOUNT'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Account'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15430765256694325)
,p_db_column_name=>'ACCOUNTED_MTA'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Accounted Mta'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15429975934694316)
,p_db_column_name=>'ACCOUNT_SETUP'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Account Category'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15431823754694325)
,p_db_column_name=>'ACTIVITY_DIFF'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Activity Difference'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15432194192694339)
,p_db_column_name=>'CCID'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Ccid'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15430296332694316)
,p_db_column_name=>'CLOSE_DATA_CHECK'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Data availability'
,p_column_html_expression=>'<span class="inv73-status" data-inv73-field="CLOSE_DATA_CHECK">#CLOSE_DATA_CHECK#</span>'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_help_text=>'Availability of business Intransit report rows and costs. Missing report data is not assumed to be zero; load time and completeness are not recorded.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15432841495694339)
,p_db_column_name=>'FULL_LEDGER_GL_END_BALANCE'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Full Ledger GL Balance (Context Only)'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_help_text=>'Full ledger account balance for context only. It is not allocated to an org or valuation basis.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15431348965694325)
,p_db_column_name=>'GL_COST_MGMT_NET'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Gl Cost Mgmt Net'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15431470340694325)
,p_db_column_name=>'GL_COST_MGMT_UNPOSTED'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Cost Management Unposted'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15431741575694325)
,p_db_column_name=>'GL_END_BALANCE'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'GL Balance (Account Context Only)'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_help_text=>'Whole-account or combined intransit-bucket GL context. This is not a WIP-only or intransit-only comparison.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15431588469694325)
,p_db_column_name=>'GL_OTHER_SOURCES_NET'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Gl Other Sources Net'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15431604581694325)
,p_db_column_name=>'GL_PERIOD_NET'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Gl Period Net'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15432348190694339)
,p_db_column_name=>'GL_SCOPE_STATUS'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'GL balance availability'
,p_column_html_expression=>'<span class="inv73-status" data-inv73-field="GL_SCOPE_STATUS">#GL_SCOPE_STATUS#</span>'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_help_text=>'GL is not loaded in this standalone diagnostic view. No GL allocation or dedicated reconciliation is implied.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15430426049694325)
,p_db_column_name=>'INTRANSIT_VALUE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Intransit Value'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15432073296694339)
,p_db_column_name=>'LEDGER_ID'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Ledger Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15429615363694316)
,p_db_column_name=>'LEDGER_NAME'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Ledger Name'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15432608894694339)
,p_db_column_name=>'MISSING_OWNER_CODES'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Unselected Owners'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15430373606694316)
,p_db_column_name=>'ONHAND_VALUE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Onhand Value'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15430063327694316)
,p_db_column_name=>'ORG_CODE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Inventory Org'
,p_column_html_expression=>'<span class="inv73-status" data-inv73-field="ORG_CODE">#ORG_CODE#</span>'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15432281946694339)
,p_db_column_name=>'ORG_ID'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Org Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15432418531694339)
,p_db_column_name=>'OWNER_COUNT'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Account Owners'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15429757020694316)
,p_db_column_name=>'PERIOD_NAME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Period Name'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15432747436694339)
,p_db_column_name=>'READINESS_STATUS'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Inventory Readiness'
,p_column_html_expression=>'<span class="inv73-status" data-inv73-field="READINESS_STATUS">#READINESS_STATUS#</span>'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15430122031694316)
,p_db_column_name=>'ROW_TYPE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Amount represents'
,p_column_html_expression=>'<span class="inv73-status" data-inv73-field="ROW_TYPE">#ROW_TYPE#</span>'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_help_text=>'Org valuation is this org''s report Total Cost. This view has no account-total rows or GL allocation.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15432582830694339)
,p_db_column_name=>'SELECTED_OWNER_COUNT'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Selected Owners'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15431253614694325)
,p_db_column_name=>'SLA_NOT_IN_GL'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'SLA Awaiting Transfer'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15431104881694325)
,p_db_column_name=>'SUBLEDGER_CHANGE'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Subledger Change'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15431095850694325)
,p_db_column_name=>'SUBLEDGER_END'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Subledger End Balance'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15430989250694325)
,p_db_column_name=>'SUBLEDGER_PRIOR'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Subledger Prior'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15431931658694339)
,p_db_column_name=>'SUBLEDGER_VS_GL_DIFF'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>unistr('Cumulative Subledger\2013GL Difference (Diagnostic)')
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15430630609694325)
,p_db_column_name=>'TOTAL_VALUE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Total Inventory Value'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15430878198694325)
,p_db_column_name=>'VALUE_VS_MTA_DIFF'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Value Vs Mta Diff'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15430540156694325)
,p_db_column_name=>'WIP_VALUE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'WIP value'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(15429587993694316)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'inv73-transit'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>25
,p_report_columns=>'ROW_TYPE:ACCOUNT:ORG_CODE:CLOSE_DATA_CHECK:INTRANSIT_VALUE:GL_SCOPE_STATUS'
,p_sort_column_1=>'ACCOUNT'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'ROW_TYPE'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'ORG_CODE'
,p_sort_direction_3=>'ASC'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(15429295815694316)
,p_plug_name=>'Intransit Panel'
,p_static_id=>'intransit-panel'
,p_region_name=>'inv73-panel-transit'
,p_region_css_classes=>'inv73-panel'
,p_region_template_options=>'#DEFAULT#:t-Region--noBorder:t-Region--hideHeader'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>60
,p_plug_item_display_point=>'ABOVE'
,p_plug_source=>'<div class="inv73-diagnostics"><strong data-inv73-diagnostics-status>Not loaded</strong><p data-inv73-diagnostics-basis></p><button type="button" class="t-Button" data-inv73-diagnostics>Load this view</button><span class="inv73-meta" data-inv73-diagn'
||'ostics-time></span><p class="inv73-warning" data-inv73-diagnostics-availability hidden></p></div><details class="inv73-report-guide"><summary>How to read these rows</summary><p><strong>Org valuation</strong> is this Inventory Org''s Total Cost from th'
||'e EBS Back Dated Intransit report. Each row stands on its own; this view has no account-total rows. Transfer and export costs remain separate from Total Cost.</p><p><strong>Data availability</strong> tells you whether report rows and costs are availa'
||'ble. No report rows is unavailable, not an assumed zero. The reporting table does not record its load time or completeness.</p><p><strong>GL is not included.</strong> The business report supplies no GL account, so GL cannot be allocated to these org '
||'values.</p></details>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(15421171173694280)
,p_plug_name=>'Inventory Readiness and Capture'
,p_static_id=>'inventory-readiness-and-capture'
,p_region_name=>'inv73-controls'
,p_region_template_options=>'#DEFAULT#:t-Region--noBorder:t-Region--hideHeader'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>30
,p_plug_item_display_point=>'ABOVE'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div id="inv73-workflow">',
unistr('<div class="inv73-company"><strong>Company:</strong> <span id="inv73-company">Available after Check</span><span class="inv73-muted"> \00B7 configured account mapping</span></div>'),
'<details class="inv73-lookup-details"><summary>Org/period and account lookups</summary><div class="inv73-toolbar"><span id="inv73-lookup-context" class="inv73-meta">Refresh time is unavailable.</span><button type="button" class="t-Button t-Button--sm'
||'all inv73-push" id="inv73-refresh-lookup">Refresh Lookup</button></div></details>',
'<div class="inv73-toolbar"><strong>1. Check Inventory Orgs</strong><span class="inv73-muted">One operating unit per run.</span><button type="button" class="t-Button t-Button--hot inv73-push" id="inv73-check">Check Inventory Orgs</button></div>',
'<div id="inv73-operation" class="inv73-message" role="status" aria-live="polite" hidden></div>',
'<div id="inv73-check-context" class="inv73-meta">Select a ledger, period, and operating unit, then check Inventory Orgs.</div>',
'<section id="inv73-picker" class="inv73-picker" aria-label="Inventory Org selection" hidden>',
'<div class="inv73-picker-head"><h2>Inventory Orgs</h2><span id="inv73-selection-count" class="inv73-muted" aria-live="polite"></span></div>',
'<div id="inv73-picker-chips" class="inv73-picker-chips" aria-label="Selected Inventory Orgs"></div>',
'<button type="button" class="t-Button t-Button--small" id="inv73-picker-toggle" aria-expanded="true" aria-controls="inv73-picker-menu">Close org picker</button>',
'<div id="inv73-picker-menu" class="inv73-picker-menu">',
'<label for="inv73-picker-search" class="inv73-picker-search-label">Search Inventory Orgs</label><input id="inv73-picker-search" type="search" class="apex-item-text inv73-picker-search" placeholder="Search org code or name" autocomplete="off" aria-con'
||'trols="inv73-picker-rows">',
'<div class="inv73-toolbar" id="inv73-selection-tools" hidden><button type="button" class="t-Button t-Button--small" data-inv73-select="all">All eligible</button><button type="button" class="t-Button t-Button--small" data-inv73-select="ready">READY on'
||'ly</button><button type="button" class="t-Button t-Button--small" data-inv73-select="none">Clear</button><span id="inv73-picker-matches" class="inv73-muted"></span></div>',
'<div id="inv73-picker-rows" class="inv73-picker-rows"></div>',
'</div><div id="inv73-picker-message" class="inv73-picker-message" role="status" aria-live="polite"></div>',
'</section>',
'<details id="inv73-readiness-details" class="inv73-readiness-details" hidden><summary>Readiness &amp; account details <span id="inv73-readiness-counts"></span></summary>',
'<details id="inv73-excluded-details" class="inv73-excluded" hidden><summary><span id="inv73-excluded-count">Excluded organizations</span></summary><div id="inv73-excluded-list"></div></details>',
'<div class="inv73-scroll"><table class="inv73-table" aria-label="Eligible Inventory organization readiness within the operating unit"><thead><tr><th>Inventory Org</th><th>Readiness</th><th>Account Ownership</th><th>Current Period</th><th>Prior Period'
||'</th><th>Close Summaries</th><th>Reason</th></tr></thead><tbody id="inv73-readiness"><tr><td colspan="7" class="inv73-empty">Check Inventory Orgs to see eligible organizations in this operating unit.</td></tr></tbody></table></div>',
'<details class="inv73-shared" aria-label="Relevant valuation account warnings"><summary class="inv73-shared-header"><strong>Account coverage warnings</strong><span id="inv73-shared-count" class="inv73-badge inv73-neutral">Not checked</span></summary>'
||'<div id="inv73-shared-list" class="inv73-empty">Relevant account warnings appear after Check and org selection.</div><div id="inv73-coverage" class="inv73-coverage"></div><div id="inv73-intransit-coverage" class="inv73-coverage"></div><div class="inv'
||'73-shared-foot">Only accounts relevant to selected orgs are shown. Owners outside this OU and excluded orgs remain part of the GL coverage assessment. They cannot be added to this run.</div></details>',
'</details>',
'<div id="inv73-selection-gate" class="inv73-message inv73-gate" role="alert" hidden></div>',
'<div class="inv73-toolbar"><span id="inv73-run-note" class="inv73-muted">A matching readiness check and at least one eligible org are required.</span><button type="button" class="t-Button t-Button--hot inv73-push" id="inv73-run" disabled>Run Reconcil'
||'iation</button><span id="inv73-timer" class="inv73-timer" aria-live="polite"></span></div>',
'<div id="inv73-step-times" class="inv73-meta"></div>',
'<div id="inv73-stale" class="inv73-message" role="status" hidden>Filters or org selection changed. These results remain the previous successful capture. Run again to replace them.</div>',
'<div class="inv73-context"><strong id="inv73-capture-title">No reconciliation capture</strong><span id="inv73-capture-status" class="inv73-badge inv73-neutral">Not run</span><span id="inv73-capture-time" class="inv73-meta"></span></div>',
'<p id="inv73-report-source" class="inv73-muted">On-hand source: EBS Back Dated Inventory report. Run reconciliation to capture the selected scope.</p>',
'<div class="inv73-cards inv73-stock-cards">',
unistr('<div class="inv73-card"><span class="inv73-card-label">On-hand Valuation</span><span class="inv73-card-value" data-inv73-metric="ONHAND_VALUE">\2014</span><span class="inv73-card-note" data-inv73-note="ONHAND_VALUE">Run to capture</span></div>'),
unistr('<div class="inv73-card"><span class="inv73-card-label">GL on the Same Stock Accounts</span><span class="inv73-card-value" data-inv73-metric="STOCK_GL_END_BALANCE">\2014</span><span class="inv73-card-note" data-inv73-note="STOCK_GL_END_BALANCE">Run to cap')
||'ture</span></div>',
unistr('<div class="inv73-card"><span class="inv73-card-label">On-hand Valuation \2212 GL</span><span class="inv73-card-value" data-inv73-metric="ONHAND_VS_GL_DIFF">\2014</span><span class="inv73-card-note" data-inv73-note="ONHAND_VS_GL_DIFF">Run to capture</span></')
||'div>',
'</div>',
'<div id="inv73-capture-note" class="inv73-message" hidden></div>',
'<details id="inv73-residual-details" class="inv73-excluded" hidden><summary><span id="inv73-residual-count">Excluded residual WIP</span></summary><div id="inv73-residual-list"></div></details>',
'<div id="inv73-account-context" class="inv73-toolbar" hidden><strong>Organization Detail account:</strong><span id="inv73-account-name" class="inv73-account"></span><button type="button" class="t-Button t-Button--small" id="inv73-clear-account">Clear'
||' account filter</button></div>',
'<div class="inv73-tabs" role="tablist" aria-label="Reconciliation balance basis"><button type="button" id="inv73-tab-stock" class="inv73-tab" role="tab" aria-selected="true" aria-controls="inv73-panel-stock" data-inv73-tab="stock">On-hand vs GL</butt'
||'on><button type="button" id="inv73-tab-wip" class="inv73-tab" role="tab" aria-selected="false" aria-controls="inv73-panel-wip" data-inv73-tab="wip">WIP</button><button type="button" id="inv73-tab-transit" class="inv73-tab" role="tab" aria-selected="f'
||'alse" aria-controls="inv73-panel-transit" data-inv73-tab="transit">Intransit</button><button type="button" id="inv73-tab-accounting" class="inv73-tab" role="tab" aria-selected="false" aria-controls="inv73-panel-accounting" data-inv73-tab="accounting"'
||'>Cumulative Accounting</button></div>',
'</div>',
''))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(15420974292694280)
,p_plug_name=>'Inventory Reconciliation'
,p_static_id=>'inventory-reconciliation'
,p_region_name=>'inv73-intro'
,p_region_template_options=>'#DEFAULT#:t-Region--noBorder:t-Region--hideHeader'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_plug_source=>'<div class="inv73-intro"><h1>Inventory Reconciliation</h1><p>Select one ledger, period, and operating unit. Check eligible orgs, choose your selection, then run.</p></div>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(15432933852694339)
,p_plug_name=>'On-hand vs GL'
,p_static_id=>'on-hand-vs-gl'
,p_region_name=>'inv73-panel-stock'
,p_region_css_classes=>'inv73-panel'
,p_region_template_options=>'#DEFAULT#:t-Region--noBorder:t-Region--hideHeader'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>40
,p_plug_item_display_point=>'ABOVE'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div id="inv73-stock-view">',
'<div class="inv73-stock-toolbar"><h2>On-hand accounts to review</h2><div><label>View org <select id="inv73-stock-org" aria-label="View accounts involving an Inventory Org"><option value="">All captured orgs</option></select></label><label><input type'
||'="checkbox" id="inv73-stock-all"> Show all accounts</label></div></div>',
'<p id="inv73-stock-view-note" class="inv73-muted">Differences over 1.00, unavailable comparisons, and zero-stock GL residuals remain visible.</p>',
'<div id="inv73-stock-message" class="inv73-message" role="status" hidden></div>',
'<div class="inv73-stock-scroll"><table class="inv73-stock-table" aria-label="Captured on-hand account valuation and General Ledger comparison"><thead><tr><th>Account</th><th>Org owner(s)</th><th class="inv73-stock-num">On-hand Valuation</th><th class'
||unistr('="inv73-stock-num">GL Closing Balance</th><th class="inv73-stock-num">Valuation \2212 GL</th></tr></thead><tbody id="inv73-stock-rows"><tr><td colspan="5">Run reconciliation to capture on-hand account balances.</td></tr></tbody></table></div>'),
'<div class="inv73-stock-toolbar"><span id="inv73-stock-count" class="inv73-muted">No capture</span><div><button type="button" class="t-Button t-Button--small" id="inv73-stock-prev" disabled>Previous</button><button type="button" class="t-Button t-But'
||'ton--small" id="inv73-stock-next" disabled>Next</button></div></div>',
unistr('<p class="inv73-muted">Expand Account \2192 Inventory Org \2192 Subinventory. GL and difference appear once at account level. View filters do not change the captured scope or the three cards.</p>'),
'</div>',
''))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(15421051005694280)
,p_plug_name=>'Reconciliation Filters'
,p_static_id=>'reconciliation-filters'
,p_region_name=>'inv73-filters'
,p_region_template_options=>'#DEFAULT#:t-Region--noBorder:t-Region--hideHeader'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>20
,p_plug_item_display_point=>'ABOVE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(15425624636694280)
,p_plug_name=>'Work in Process'
,p_static_id=>'work-in-process'
,p_region_name=>'inv73-report-wip'
,p_parent_plug_id=>wwv_flow_imp.id(15425507157694280)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2103954283454391425
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select * from (select j.* from apex_collections c,json_table(c.clob001,''$'' columns (',
'LEDGER_NAME varchar2(500) path ''$.LEDGER_NAME'' null on error,',
'PERIOD_NAME varchar2(500) path ''$.PERIOD_NAME'' null on error,',
'ACCOUNT varchar2(4000) path ''$.ACCOUNT'' null on error,',
'ACCOUNT_SETUP varchar2(500) path ''$.ACCOUNT_SETUP'' null on error,',
'ORG_CODE varchar2(500) path ''$.ORG_CODE'' null on error,',
'ROW_TYPE varchar2(500) path ''$.ROW_TYPE'' null on error,',
'CLOSE_DATA_CHECK varchar2(500) path ''$.CLOSE_DATA_CHECK'' null on error,',
'ONHAND_VALUE number path ''$.ONHAND_VALUE'' null on error,',
'INTRANSIT_VALUE number path ''$.INTRANSIT_VALUE'' null on error,',
'WIP_VALUE number path ''$.WIP_VALUE'' null on error,',
'TOTAL_VALUE number path ''$.TOTAL_VALUE'' null on error,',
'ACCOUNTED_MTA number path ''$.ACCOUNTED_MTA'' null on error,',
'VALUE_VS_MTA_DIFF number path ''$.VALUE_VS_MTA_DIFF'' null on error,',
'SUBLEDGER_PRIOR number path ''$.SUBLEDGER_PRIOR'' null on error,',
'SUBLEDGER_END number path ''$.SUBLEDGER_END'' null on error,',
'SUBLEDGER_CHANGE number path ''$.SUBLEDGER_CHANGE'' null on error,',
'SLA_NOT_IN_GL number path ''$.SLA_NOT_IN_GL'' null on error,',
'GL_COST_MGMT_NET number path ''$.GL_COST_MGMT_NET'' null on error,',
'GL_COST_MGMT_UNPOSTED number path ''$.GL_COST_MGMT_UNPOSTED'' null on error,',
'GL_OTHER_SOURCES_NET number path ''$.GL_OTHER_SOURCES_NET'' null on error,',
'GL_PERIOD_NET number path ''$.GL_PERIOD_NET'' null on error,',
'GL_END_BALANCE number path ''$.GL_END_BALANCE'' null on error,',
'ACTIVITY_DIFF number path ''$.ACTIVITY_DIFF'' null on error,',
'SUBLEDGER_VS_GL_DIFF number path ''$.SUBLEDGER_VS_GL_DIFF'' null on error,',
'LEDGER_ID number path ''$.LEDGER_ID'' null on error,',
'CCID number path ''$.CCID'' null on error,',
'ORG_ID number path ''$.ORG_ID'' null on error,',
'GL_SCOPE_STATUS varchar2(500) path ''$.GL_SCOPE_STATUS'' null on error,',
'OWNER_COUNT number path ''$.OWNER_COUNT'' null on error,',
'SELECTED_OWNER_COUNT number path ''$.SELECTED_OWNER_COUNT'' null on error,',
'MISSING_OWNER_CODES varchar2(4000) path ''$.MISSING_OWNER_CODES'' null on error,',
'READINESS_STATUS varchar2(500) path ''$.READINESS_STATUS'' null on error,',
'FULL_LEDGER_GL_END_BALANCE number path ''$.FULL_LEDGER_GL_END_BALANCE'' null on error',
')) j where c.collection_name=:P73_WIP_COLL and c.collection_name in (xxinv128_diag_pkg.current_collection(''WIP''),xxinv128_diag_pkg.current_collection(''WIP_ACTIVITY''))) where 1=1'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P73_WIP_COLL'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(15425702706694280)
,p_no_data_found_message=>'No captured rows for this view. Select a ledger and period, check Inventory Orgs, and run reconciliation.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_fixed_header=>'REGION'
,p_fixed_header_max_height=>550
,p_lazy_loading=>true
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:XLSX'
,p_enable_mail_download=>'N'
,p_internal_uid=>15425702706694280
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15426144568694299)
,p_db_column_name=>'ACCOUNT'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Account'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15427037049694299)
,p_db_column_name=>'ACCOUNTED_MTA'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Accounted Mta'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15426207922694299)
,p_db_column_name=>'ACCOUNT_SETUP'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Account Category'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15428134676694308)
,p_db_column_name=>'ACTIVITY_DIFF'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Activity Difference'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15428427648694308)
,p_db_column_name=>'CCID'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Ccid'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15426526852694299)
,p_db_column_name=>'CLOSE_DATA_CHECK'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Data availability'
,p_column_html_expression=>'<span class="inv73-status" data-inv73-field="CLOSE_DATA_CHECK">#CLOSE_DATA_CHECK#</span>'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_help_text=>'Closing valuation requires closed Inventory and current close-summary data. Monthly activity uses the business report transaction-date filters; it is not a closing balance.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15429180822694316)
,p_db_column_name=>'FULL_LEDGER_GL_END_BALANCE'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Full Ledger GL Balance (Context Only)'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_help_text=>'Full ledger account balance for context only. It is not allocated to an org or valuation basis.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15427636636694308)
,p_db_column_name=>'GL_COST_MGMT_NET'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Gl Cost Mgmt Net'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15427733407694308)
,p_db_column_name=>'GL_COST_MGMT_UNPOSTED'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Cost Management Unposted'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15428085512694308)
,p_db_column_name=>'GL_END_BALANCE'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'GL Balance (Account Context Only)'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_help_text=>'Whole-account or combined intransit-bucket GL context. This is not a WIP-only or intransit-only comparison.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15427802500694308)
,p_db_column_name=>'GL_OTHER_SOURCES_NET'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Gl Other Sources Net'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15427991845694308)
,p_db_column_name=>'GL_PERIOD_NET'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Gl Period Net'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15428684768694308)
,p_db_column_name=>'GL_SCOPE_STATUS'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'GL balance availability'
,p_column_html_expression=>'<span class="inv73-status" data-inv73-field="GL_SCOPE_STATUS">#GL_SCOPE_STATUS#</span>'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_help_text=>'GL is not loaded in this standalone diagnostic view. No GL allocation or dedicated reconciliation is implied.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15426798003694299)
,p_db_column_name=>'INTRANSIT_VALUE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Intransit Value'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15428328587694308)
,p_db_column_name=>'LEDGER_ID'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Ledger Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15425960524694299)
,p_db_column_name=>'LEDGER_NAME'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Ledger Name'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15428911665694316)
,p_db_column_name=>'MISSING_OWNER_CODES'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Unselected Owners'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15426603255694299)
,p_db_column_name=>'ONHAND_VALUE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Onhand Value'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15426318227694299)
,p_db_column_name=>'ORG_CODE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Inventory Org'
,p_column_html_expression=>'<span class="inv73-status" data-inv73-field="ORG_CODE">#ORG_CODE#</span>'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15428557409694308)
,p_db_column_name=>'ORG_ID'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Org Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15428740792694308)
,p_db_column_name=>'OWNER_COUNT'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Account Owners'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15426074003694299)
,p_db_column_name=>'PERIOD_NAME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Period Name'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15429041999694316)
,p_db_column_name=>'READINESS_STATUS'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Inventory Readiness'
,p_column_html_expression=>'<span class="inv73-status" data-inv73-field="READINESS_STATUS">#READINESS_STATUS#</span>'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15426491231694299)
,p_db_column_name=>'ROW_TYPE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Amount represents'
,p_column_html_expression=>'<span class="inv73-status" data-inv73-field="ROW_TYPE">#ROW_TYPE#</span>'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_help_text=>'Account total combines the selected Inventory Orgs. Org breakdown rows show contributions to that same total. Do not add both levels together.'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15428885375694308)
,p_db_column_name=>'SELECTED_OWNER_COUNT'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Selected Owners'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15427508356694308)
,p_db_column_name=>'SLA_NOT_IN_GL'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'SLA Awaiting Transfer'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15427438142694308)
,p_db_column_name=>'SUBLEDGER_CHANGE'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Subledger Change'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15427312464694299)
,p_db_column_name=>'SUBLEDGER_END'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Subledger End Balance'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15427296450694299)
,p_db_column_name=>'SUBLEDGER_PRIOR'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Subledger Prior'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15428236047694308)
,p_db_column_name=>'SUBLEDGER_VS_GL_DIFF'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>unistr('Cumulative Subledger\2013GL Difference (Diagnostic)')
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15426917544694299)
,p_db_column_name=>'TOTAL_VALUE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Total Inventory Value'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15427126325694299)
,p_db_column_name=>'VALUE_VS_MTA_DIFF'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Value Vs Mta Diff'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15426899591694299)
,p_db_column_name=>'WIP_VALUE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999G999G999G999G999G999G999G990D00'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_help_text=>'Closing valuation: end-of-period WIP balance. Monthly activity: accounting movement during the selected month. These are separate measures.'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(15425882616694280)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'inv73-wip'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>25
,p_report_columns=>'ROW_TYPE:ACCOUNT:ORG_CODE:CLOSE_DATA_CHECK:WIP_VALUE:GL_SCOPE_STATUS'
,p_sort_column_1=>'ACCOUNT'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'ROW_TYPE'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'ORG_CODE'
,p_sort_direction_3=>'ASC'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(15425507157694280)
,p_plug_name=>'Work in Process Panel'
,p_static_id=>'work-in-process-panel'
,p_region_name=>'inv73-panel-wip'
,p_region_css_classes=>'inv73-panel'
,p_region_template_options=>'#DEFAULT#:t-Region--noBorder:t-Region--hideHeader'
,p_plug_template=>4075786578761660127
,p_plug_display_sequence=>50
,p_plug_item_display_point=>'ABOVE'
,p_plug_source=>'<div role="group" aria-label="WIP view" class="inv73-wip-views"><button type="button" class="t-Button" data-inv73-wip-view="WIP" aria-pressed="true">Closing valuation</button><button type="button" class="t-Button" data-inv73-wip-view="WIP_ACTIVITY" a'
||'ria-pressed="false">Monthly activity</button></div><div class="inv73-diagnostics"><strong data-inv73-diagnostics-status>Not loaded</strong><p data-inv73-diagnostics-basis></p><button type="button" class="t-Button" data-inv73-diagnostics>Load this vie'
||'w</button><span class="inv73-meta" data-inv73-diagnostics-time></span><p class="inv73-warning" data-inv73-diagnostics-availability hidden></p></div><details class="inv73-report-guide"><summary>How to read these rows</summary><p><strong>Closing valuat'
||'ion</strong> is the WIP balance through the selected Inventory period end. It requires closed Inventory and the required current close-summary data. <strong>Monthly activity</strong> is movement from the first through the last day of the selected mon'
||'th, following the business report filters; it is not the closing balance.</p><p><strong>Account total</strong> combines the selected Inventory Orgs. <strong>Org breakdown</strong> shows each org''s contribution to that same amount. Do not add the tota'
||'l and breakdown together.</p><p><strong>Data availability</strong> describes availability or the monthly activity basis. <strong>GL is not included</strong> in either WIP view; these amounts are not standalone comparisons with GL.</p></details>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15437151896694365)
,p_name=>'P73_CAPTURE_COLL'
,p_item_sequence=>210
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15437067470694365)
,p_name=>'P73_CCID'
,p_item_sequence=>200
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15421641128694280)
,p_name=>'P73_CHECK_LEDGER'
,p_item_sequence=>110
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15437337848694365)
,p_name=>'P73_CHECK_OU'
,p_item_sequence=>220
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15421727001694280)
,p_name=>'P73_CHECK_PERIOD'
,p_item_sequence=>120
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15421595238694280)
,p_name=>'P73_CHECK_TOKEN'
,p_item_sequence=>100
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15437531410694365)
,p_name=>'P73_INTRANSIT_COLL'
,p_item_sequence=>240
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15421300838694280)
,p_name=>'P73_LEDGER_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(15421051005694280)
,p_prompt=>'Ledger *'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'TMS_APPROVED_LEDGERS'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'Select ledger'
,p_cHeight=>1
,p_colspan=>4
,p_grid_label_column_span=>0
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15437211230694365)
,p_name=>'P73_OU_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(15421051005694280)
,p_prompt=>'Operating Unit *'
,p_placeholder=>'Select one operating unit'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>'select max(ou_name) d,to_char(ou_id) r from xxinv128_org_period_mv where ledger_id=to_number(:P73_LEDGER_ID default null on conversion error) and ou_id is not null group by ou_id order by max(ou_name)'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'Select operating unit'
,p_lov_cascade_parent_items=>'P73_LEDGER_ID'
,p_ajax_items_to_submit=>'P73_LEDGER_ID'
,p_ajax_optimize_refresh=>'Y'
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_grid_label_column_span=>0
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'case_sensitive', 'N',
  'display_as', 'POPUP',
  'fetch_on_search', 'N',
  'initial_fetch', 'FIRST_ROWSET',
  'manual_entry', 'N',
  'match_type', 'CONTAINS',
  'min_chars', '0',
  'multiple', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15421415537694280)
,p_name=>'P73_PERIOD_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(15421051005694280)
,p_prompt=>'Inventory reconciliation period *'
,p_placeholder=>'Select current or historical period'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>'select period_name d,period_name r from xxinv128_org_period_mv where ledger_id=to_number(:P73_LEDGER_ID default null on conversion error) and period_start_date<=trunc(sysdate) group by period_name order by max(period_start_date) desc'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'Select period'
,p_lov_cascade_parent_items=>'P73_LEDGER_ID'
,p_ajax_items_to_submit=>'P73_LEDGER_ID'
,p_ajax_optimize_refresh=>'Y'
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_grid_label_column_span=>0
,p_field_template=>1612549609962752680
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'case_sensitive', 'N',
  'display_as', 'POPUP',
  'fetch_on_search', 'N',
  'initial_fetch', 'FIRST_ROWSET',
  'manual_entry', 'N',
  'match_type', 'CONTAINS',
  'min_chars', '0',
  'multiple', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15437417466694365)
,p_name=>'P73_WIP_COLL'
,p_item_sequence=>230
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(15436601417694365)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'P73_CHECK'
,p_static_id=>'p73-check'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare l_ledger number:=to_number(apex_application.g_x01 default null on conversion error);l_period varchar2(30):=trim(apex_application.g_x02);l_ou number:=to_number(apex_application.g_x03 default null on conversion error);begin',
'if xx_tms_security_pkg.can_access(:APP_USER,:APP_ID) then null;else raise_application_error(-20730,''You are not authorized to use Inventory Reconciliation.'');end if;',
'if l_ledger not in (1003,5001,10001) or l_ledger is null or l_period is null or length(l_period)>30 or l_ou is null then raise_application_error(-20731,''Select one approved ledger, a period, and one operating unit.'');end if;',
'xxinv128_report_pkg.check_orgs(l_ledger,l_period,l_ou);',
'apex_util.set_session_state(''P73_CHECK_TOKEN'',rawtohex(sys_guid()),p_commit=>false);',
'apex_util.set_session_state(''P73_CHECK_LEDGER'',to_char(l_ledger),p_commit=>false);',
'apex_util.set_session_state(''P73_CHECK_PERIOD'',l_period,p_commit=>false);',
'apex_util.set_session_state(''P73_CHECK_OU'',to_char(l_ou),p_commit=>false);',
'apex_json.open_object;apex_json.write(''ok'',true);apex_json.close_object;',
'exception when others then apex_json.open_object;apex_json.write(''ok'',false);apex_json.write(''message'',case when sqlcode between -20999 and -20000 then substr(sqlerrm,12) else ''Inventory Reconciliation could not complete. The previous successful capt'
||'ure is preserved. Check the APEX debug log.'' end);apex_json.close_object;end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>15436601417694365
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(15437756748694365)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'P73_DIAGNOSTICS'
,p_static_id=>'p73-diagnostics'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'if xx_tms_security_pkg.can_access(:APP_USER,:APP_ID) then null;else raise_application_error(-20730,''You are not authorized to use Inventory Reconciliation.'');end if;',
'if apex_application.g_x01 is null or apex_application.g_x01 not in (''WIP'',''WIP_ACTIVITY'',''INTRANSIT'',''ACCOUNTING'') then raise_application_error(-20734,''Choose a supported diagnostic view.'');end if;',
'xxinv128_diag_pkg.load(apex_application.g_x01);',
'apex_json.open_object;apex_json.write(''ok'',true);apex_json.close_object;',
'exception when others then apex_json.open_object;apex_json.write(''ok'',false);apex_json.write(''message'',case when sqlcode between -20999 and -20000 then substr(sqlerrm,12) else ''Inventory Reconciliation could not complete. The previous successful capt'
||'ure is preserved. Check the APEX debug log.'' end);apex_json.close_object;end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>15437756748694365
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(15437618038694365)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'P73_ONHAND'
,p_static_id=>'p73-onhand'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_action varchar2(20):=upper(trim(apex_application.g_x01));',
'  l_capture varchar2(255):=apex_application.g_x02;',
'  l_ccid number:=to_number(apex_application.g_x03 default null on conversion error);',
'  l_org number:=to_number(apex_application.g_x04 default null on conversion error);',
'  l_page number:=to_number(apex_application.g_x05 default null on conversion error);',
'  l_show_all varchar2(1):=nvl(apex_application.g_x06,''N'');',
'  l_collection varchar2(255);l_org_collection varchar2(255);l_rows clob;l_total number;',
'begin',
'  if xx_tms_security_pkg.can_access(:APP_USER,:APP_ID) then null;else raise_application_error(-20730,''You are not authorized to use Inventory Reconciliation.'');end if;',
'  if l_capture is null or xxinv128_report_pkg.current_collection(''ONHAND_ACCOUNTS'') is null or l_capture<>xxinv128_report_pkg.current_collection(''ONHAND_ACCOUNTS'') then raise_application_error(-20736,''The capture changed. Reload the successful captur'
||'e before viewing detail.'');end if;',
'  if l_action not in (''ACCOUNTS'',''ORGS'',''SUBS'') or l_action is null or l_page is null or l_page<1 or l_page<>trunc(l_page) or l_page>100000 or l_show_all not in (''Y'',''N'') then raise_application_error(-20737,''The requested local report view is invalid'
||'.'');end if;',
'  if apex_application.g_x04 is not null and not regexp_like(apex_application.g_x04,''^[0-9]{1,18}$'',''c'') then raise_application_error(-20737,''The requested Inventory Org view is invalid.'');end if;',
'  if l_action in (''ORGS'',''SUBS'') and (l_ccid is null or l_ccid=0 or l_ccid<>trunc(l_ccid)) then raise_application_error(-20737,''Select a valid captured stock account.'');end if;',
'  if l_action=''SUBS'' and l_org is null then raise_application_error(-20737,''Select a valid captured Inventory Org.'');end if;',
'  l_collection:=xxinv128_report_pkg.current_collection(case l_action when ''ACCOUNTS'' then ''ONHAND_ACCOUNTS'' when ''ORGS'' then ''ONHAND_ORGS'' else ''ONHAND_SUBINVENTORIES'' end);',
'  l_org_collection:=xxinv128_report_pkg.current_collection(''ONHAND_ORGS'');',
'  if l_collection is null then raise_application_error(-20736,''This capture has no requested on-hand detail. Run reconciliation again.'');end if;',
'  select nvl(max(total_rows),0),json_arrayagg(payload format json order by rn returning clob)',
'    into l_total,l_rows',
'    from (',
'      select c.clob001 payload,row_number() over(order by j.account,j.org_code,j.subinventory_code,c.seq_id) rn,count(*) over() total_rows',
'        from apex_collections c,json_table(c.clob001,''$'' columns(',
'          ccid number path ''$.CCID'',org_id number path ''$.ORG_ID'',account varchar2(4000) path ''$.ACCOUNT'',',
'          org_code varchar2(100) path ''$.ORG_CODE'',subinventory_code varchar2(100) path ''$.SUBINVENTORY_CODE'',',
'          onhand_value number path ''$.ONHAND_VALUE'',gl_end_balance number path ''$.GL_END_BALANCE'',',
'          onhand_vs_gl_diff number path ''$.ONHAND_VS_GL_DIFF'',comparison_status varchar2(100) path ''$.COMPARISON_STATUS'')) j',
'       where c.collection_name=l_collection',
'         and ((l_action=''ACCOUNTS''',
'               and (l_org is null or exists(select 1 from apex_collections oc,json_table(oc.clob001,''$'' columns(ccid number path ''$.CCID'',org_id number path ''$.ORG_ID'')) oj where oc.collection_name=l_org_collection and oj.ccid=j.ccid and oj.org_id=l_'
||'org))',
'               and (l_show_all=''Y'' or j.comparison_status is null or j.comparison_status<>''AVAILABLE'' or j.onhand_value is null or j.gl_end_balance is null or j.onhand_vs_gl_diff is null or abs(j.onhand_vs_gl_diff)>1 or (j.onhand_value=0 and j.gl_end'
||'_balance<>0)))',
'           or (l_action=''ORGS'' and j.ccid=l_ccid)',
'           or (l_action=''SUBS'' and j.ccid=l_ccid and j.org_id=l_org))',
'    ) where rn between (l_page-1)*25+1 and l_page*25;',
'  if xxinv128_report_pkg.current_collection(''ONHAND_ACCOUNTS'') is null or l_capture<>xxinv128_report_pkg.current_collection(''ONHAND_ACCOUNTS'') then raise_application_error(-20736,''The capture changed. Reload the successful capture before viewing deta'
||'il.'');end if;',
'  apex_json.open_object;apex_json.write(''ok'',true);apex_json.write(''capture_collection'',l_capture);apex_json.write(''action'',l_action);apex_json.write(''page'',l_page);apex_json.write(''page_size'',25);apex_json.write(''total'',l_total);apex_json.write_raw('
||'''rows'',nvl(l_rows,to_clob(''[]'')));apex_json.close_object;',
'exception when others then',
'  apex_json.open_object;apex_json.write(''ok'',false);apex_json.write(''message'',case when sqlcode between -20999 and -20000 then substr(sqlerrm,12) else ''Unable to read captured on-hand data. Reload the successful capture.'' end);apex_json.close_object;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>15437618038694365
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(15436919216694365)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'P73_REFRESH_LOOKUP'
,p_static_id=>'p73-refresh-lookup'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'if xx_tms_security_pkg.can_access(:APP_USER,:APP_ID) then null;else raise_application_error(-20730,''You are not authorized to use Inventory Reconciliation.'');end if;',
'xxinv128_report_pkg.refresh_lookup;',
'apex_util.set_session_state(''P73_CHECK_TOKEN'',null,p_commit=>false);',
'apex_util.set_session_state(''P73_CHECK_LEDGER'',null,p_commit=>false);',
'apex_util.set_session_state(''P73_CHECK_PERIOD'',null,p_commit=>false);',
'apex_util.set_session_state(''P73_CHECK_OU'',null,p_commit=>false);',
'apex_json.open_object;apex_json.write(''ok'',true);apex_json.close_object;',
'exception when others then apex_json.open_object;apex_json.write(''ok'',false);apex_json.write(''message'',case when sqlcode between -20999 and -20000 then substr(sqlerrm,12) else ''Inventory Reconciliation could not complete. The previous successful capt'
||'ure is preserved. Check the APEX debug log.'' end);apex_json.close_object;end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>15436919216694365
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(15436734435694365)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'P73_RUN'
,p_static_id=>'p73-run'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare l_ledger number:=to_number(apex_application.g_x02 default null on conversion error);l_period varchar2(30):=trim(apex_application.g_x03);l_orgs varchar2(4000):=trim(apex_application.g_x04);l_ou number:=to_number(apex_application.g_x05 default '
||'null on conversion error);begin',
'if xx_tms_security_pkg.can_access(:APP_USER,:APP_ID) then null;else raise_application_error(-20730,''You are not authorized to use Inventory Reconciliation.'');end if;',
'if l_ledger not in (1003,5001,10001) or l_ledger is null or l_period is null or length(l_period)>30 or l_ou is null then raise_application_error(-20731,''Select one approved ledger, a period, and one operating unit.'');end if;',
'if apex_application.g_x01 is null or apex_application.g_x01<>apex_util.get_session_state(''P73_CHECK_TOKEN'') or to_char(l_ledger)<>apex_util.get_session_state(''P73_CHECK_LEDGER'') or l_period<>apex_util.get_session_state(''P73_CHECK_PERIOD'') or to_char('
||'l_ou)<>apex_util.get_session_state(''P73_CHECK_OU'') then raise_application_error(-20732,''Check Inventory Orgs for this ledger, period, and operating unit before running.'');end if;',
'if l_orgs is null or (l_orgs<>''ALL'' and not regexp_like(l_orgs,''^[0-9]{1,18}(:[0-9]{1,18})*$'',''c'')) then raise_application_error(-20733,''Select at least one Inventory Org.'');end if;',
'xxinv128_report_pkg.run_reconciliation(l_ledger,l_period,l_ou,case when l_orgs=''ALL'' then null else l_orgs end);',
'apex_json.open_object;apex_json.write(''ok'',true);apex_json.close_object;',
'exception when others then apex_json.open_object;apex_json.write(''ok'',false);apex_json.write(''message'',case when sqlcode between -20999 and -20000 then substr(sqlerrm,12) else ''Inventory Reconciliation could not complete. The previous successful capt'
||'ure is preserved. Check the APEX debug log.'' end);apex_json.close_object;end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>15436734435694365
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(15436852393694365)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'P73_STATE'
,p_static_id=>'p73-state'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare l_rows clob;l_owners clob;l_exceptions clob;l_stock_orgs clob;l_meta clob;l_capture varchar2(255);l_primary varchar2(255);l_wip varchar2(255);l_transit varchar2(255);begin',
'if xx_tms_security_pkg.can_access(:APP_USER,:APP_ID) then null;else raise_application_error(-20730,''You are not authorized to use Inventory Reconciliation.'');end if;',
'if not apex_collection.collection_exists(p_collection_name=>''INV128_P73_IR_V11_01'') then',
'for r in (select reg.region_id, case reg.static_id when ''inv73-report-accounting'' then ''inv73-accounting'' when ''inv73-report-wip'' then ''inv73-wip'' when ''inv73-report-transit'' then ''inv73-transit'' end as report_alias',
'from apex_application_page_regions reg where reg.application_id=to_number(:APP_ID) and reg.page_id=73 and reg.source_type_code=''DYNAMIC_QUERY'' and reg.static_id in (''inv73-report-accounting'',''inv73-report-wip'',''inv73-report-transit'')) loop',
'apex_ir.reset_report(p_page_id=>73,p_region_id=>r.region_id,p_report_alias=>r.report_alias);',
'end loop;',
'apex_collection.create_collection(p_collection_name=>''INV128_P73_IR_V11_01'');',
'end if;',
'select json_mergepatch(xxinv128_report_pkg.get_meta,xxinv128_diag_pkg.get_meta returning clob) into l_meta from dual;',
'l_primary:=xxinv128_report_pkg.current_collection(''ONHAND_ACCOUNTS'');',
'l_capture:=xxinv128_diag_pkg.current_collection(''ACCOUNTING'');',
'l_wip:=xxinv128_diag_pkg.current_collection(''WIP'');',
'l_transit:=xxinv128_diag_pkg.current_collection(''INTRANSIT'');',
'apex_util.set_session_state(''P73_CAPTURE_COLL'',l_capture,p_commit=>false);',
'apex_util.set_session_state(''P73_WIP_COLL'',l_wip,p_commit=>false);',
'apex_util.set_session_state(''P73_INTRANSIT_COLL'',l_transit,p_commit=>false);',
'select json_arrayagg(c.clob001 format json returning clob) into l_rows from apex_collections c where c.collection_name=xxinv128_report_pkg.checked_collection(''READINESS'');',
'select json_arrayagg(c.clob001 format json returning clob) into l_owners from apex_collections c where c.collection_name=xxinv128_report_pkg.checked_collection(''OWNERS'');',
'select json_arrayagg(c.clob001 format json returning clob) into l_exceptions from apex_collections c where c.collection_name=xxinv128_report_pkg.current_collection(''EXCEPTIONS'');',
'select json_arrayagg(json_object(''ORG_ID'' value org_id,''ORG_CODE'' value org_code,''ORG_NAME'' value org_name returning clob) format json order by org_code returning clob) into l_stock_orgs from (select j.org_id,max(j.org_code) org_code,max(j.org_name) '
||'org_name from apex_collections c,json_table(c.clob001,''$'' columns(org_id number path ''$.ORG_ID'',org_code varchar2(100) path ''$.ORG_CODE'',org_name varchar2(500) path ''$.ORG_NAME'')) j where c.collection_name=xxinv128_report_pkg.current_collection(''ONHA'
||'ND_ORGS'') group by j.org_id);',
'apex_json.open_object;apex_json.write(''ok'',true);apex_json.write(''token'',apex_util.get_session_state(''P73_CHECK_TOKEN''));apex_json.write(''capture_collection'',l_capture);apex_json.write(''primary_collection'',l_primary);apex_json.write(''wip_collection'','
||'l_wip);apex_json.write(''wip_activity_collection'',xxinv128_diag_pkg.current_collection(''WIP_ACTIVITY''));apex_json.write(''intransit_collection'',l_transit);apex_json.write_raw(''meta'',nvl(l_meta,to_clob(''{}'')));apex_json.write_raw(''readiness'',nvl(l_rows,'
||'to_clob(''[]'')));apex_json.write_raw(''owners'',nvl(l_owners,to_clob(''[]'')));apex_json.write_raw(''exceptions'',nvl(l_exceptions,to_clob(''[]'')));apex_json.write_raw(''onhand_orgs'',nvl(l_stock_orgs,to_clob(''[]'')));apex_json.close_object;',
'exception when others then apex_json.open_object;apex_json.write(''ok'',false);apex_json.write(''message'',case when sqlcode between -20999 and -20000 then substr(sqlerrm,12) else ''Inventory Reconciliation could not complete. The previous successful capt'
||'ure is preserved. Check the APEX debug log.'' end);apex_json.close_object;end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>15436852393694365
);
end;
/
prompt --application/end_environment
begin
  wwv_flow_imp.import_end(p_auto_install_sup_obj => false);
  commit;
  apex_application_install.clear_all;
end;
/
whenever sqlerror continue none
set verify on feedback on define on
prompt  ...done
