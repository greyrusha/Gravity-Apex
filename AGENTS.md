# AGENTS.md — Oracle APEX & EBS Development Workspace

Read by **OpenAI Codex** and **Google Antigravity** (IDE v1.20.3+, 2.0 app, CLI) at session start.
Global APEX & DB skills are installed at `C:\Users\artur.rushevich\.gemini\antigravity\skills\` (and workspace overrides live in `.agents/skills/`).

---

## 1. Project context

| Item | Value |
|---|---|
| APEX version | 26.2 (APEXlang-capable, mmdVersion 26.2.0+3479) |
| Database | Oracle AI Database 26ai (APEX host) |
| Source system | Oracle E-Business Suite 12.2, reached via DB link |
| Data access pattern | Materialized views / views over the DB link. Do not query EBS live from APEX pages. |
| Primary use cases | EBS Customer OU Rollout Workbench (App 600 / XXCR_*), SLA/GL reporting dashboards, Select AI |

Edit this table if the environment changes.

---

## 2. Available skills

Load skills by **progressive disclosure**: read the skill's `SKILL.md` first, then open **only** the reference file the routing table points to. Do not bulk-read whole skill folders.

### `apex`: Oracle APEX app development (APEXlang)
- Global install: `C:\Users\artur.rushevich\.gemini\antigravity\skills\apex\` (or `.agents/skills/apex/` if workspace-installed)
- Entry: `C:\Users\artur.rushevich\.gemini\antigravity\skills\apex\SKILL.md`
- Version router: `C:\Users\artur.rushevich\.gemini\antigravity\skills\apex\apexlang-router\SKILL.md` → APEX `26.2`
- Start with (APEX 26.2):
  - `C:\Users\artur.rushevich\.gemini\antigravity\skills\apex\apexlang-26-2-inventory\SKILL.md`
  - `C:\Users\artur.rushevich\.gemini\antigravity\skills\apex\apexlang-26-2-example-applications\SKILL.md`
  - `C:\Users\artur.rushevich\.gemini\antigravity\skills\apex\apexlang-compile\SKILL.md`
  - `C:\Users\artur.rushevich\.gemini\antigravity\skills\apex\apexlang-deploy\SKILL.md`
- **Use for:** generating or changing APEX apps, pages, regions, items, processes, shared components.

### `db`: Oracle Database (SQL, PL/SQL, SQLcl, ORDS, vectors)
- Global install: `C:\Users\artur.rushevich\.gemini\antigravity\skills\db\` (or `.agents/skills/db/` if workspace-installed)
- Entry: `C:\Users\artur.rushevich\.gemini\antigravity\skills\db\SKILL.md`
- Routing folders: `admin/` `agent/` `appdev/` `architecture/` `backup-recovery/` `containers/` `data-guard/` `design/` `devops/` `frameworks/` `features/` `migrations/` `monitoring/` `ords/` `performance/` `plsql/` `security/` `sql-dev/` `sqlcl/` `vecdb/`
- **Use for:** PL/SQL packages behind APEX pages, SQL tuning, MV refresh design, ORDS REST, SQLcl/Liquibase deployment, vector search.

### `annotate` (optional): 26ai table/column annotations for Select AI
- Entry: `.agents/skills/annotate/SKILL.md`
- **Use for:** generating `ANNOTATIONS (ai_context ...)` scripts so natural-language queries understand EBS-derived tables.

### Which skill to use
| Task | Skill(s) |
|---|---|
| New APEX app or page | `apex` → `apexlang-26-2-inventory` |
| PL/SQL API or package for a page | `db` → `plsql/` |
| Slow report or IG query | `db` → `performance/` |
| MV over the EBS DB link | `db` → `design/` + `performance/` |
| REST endpoint for the app | `db` → `ords/` |
| Export, deploy or version an app | `db` → `sqlcl/` + `devops/` |
| Natural-language querying prep | `annotate`, then `db` → `features/` |

---

## 3. APEX & 26ai Rules

1. **EBS is read-only.** Never generate DML against EBS base tables (`GL_*`, `XLA_*`, `AP_*`, `AR_*`, etc.) or over the DB link. Writes to EBS go through public EBS APIs only, and only when explicitly asked.
2. **No DDL or DML execution without confirmation.** Generate scripts as files. Run them only after the user approves.
3. **APEX 26.2 only.** Do not use deprecated APIs or pre-26.2 component syntax. Prefer APEXlang output over hand-edited export files.
4. **Business logic goes in PL/SQL packages**, not in page-level anonymous blocks.
5. **Bind variables only.** No string-concatenated SQL in dynamic content.
6. **Mark version-specific behavior** (19c vs 26ai) whenever a feature depends on the DB release.
7. If a skill file named here is missing, stop and tell the user to run the setup in Section 4. Do not improvise from memory.

---

## 4. Setup (human: run once per repository)

### Install into the workspace (recommended: serves Codex and Antigravity at once)

**Linux / macOS**
```bash
cd <your-apex-repo>
git clone --depth 1 https://github.com/oracle/skills.git /tmp/oracle-skills
mkdir -p .agents/skills
cp -r /tmp/oracle-skills/apex .agents/skills/apex
cp -r /tmp/oracle-skills/db   .agents/skills/db

# optional: annotate skill
git clone --depth 1 https://github.com/ainielse/annotate.git /tmp/annotate
cp -r /tmp/annotate/.github/skills/annotate .agents/skills/annotate

rm -rf /tmp/oracle-skills /tmp/annotate
```

**Windows (PowerShell)**
```powershell
cd <your-apex-repo>
git clone --depth 1 https://github.com/oracle/skills.git $env:TEMP\oracle-skills
New-Item -ItemType Directory -Force .agents\skills | Out-Null
Copy-Item -Recurse $env:TEMP\oracle-skills\apex .agents\skills\apex
Copy-Item -Recurse $env:TEMP\oracle-skills\db   .agents\skills\db

# optional: annotate skill
git clone --depth 1 https://github.com/ainielse/annotate.git $env:TEMP\annotate
Copy-Item -Recurse $env:TEMP\annotate\.github\skills\annotate .agents\skills\annotate
Remove-Item -Recurse -Force $env:TEMP\oracle-skills, $env:TEMP\annotate
```

Commit `.agents/skills/` and this `AGENTS.md` so the whole team gets the same setup.

### Resulting layout
```
<repo>/
├── AGENTS.md
└── .agents/
    └── skills/
        ├── apex/
        │   ├── SKILL.md
        │   └── apexlang-router/
        ├── db/
        │   └── SKILL.md  (+ routing folders)
        └── annotate/      (optional)
```

### Global install (alternative: all projects on this machine)
| Agent | Global skills path |
|---|---|
| Codex | `~/.agents/skills/` (legacy: `~/.codex/skills/`) |
| Antigravity 2.0 app | `~/.gemini/antigravity/skills/` (and `~/.gemini/config/skills/`) |
| Antigravity CLI | `~/.gemini/antigravity-cli/skills/` |

The global paths differ per tool, so a global install means copying the skills twice. The workspace install avoids that.

### Verify
- **Codex:** restart Codex, then prompt `$apex list the APEXlang workflows you can run`.
- **Antigravity:** reopen the workspace, then type `/apex` in the prompt panel.
- If a skill doesn't load, check that the file is named exactly `SKILL.md` and restart the agent.

### Update
Re-run the clone-and-copy step. Oracle updates the repo frequently, and `apexlang` is updated with new APEX releases.

---

## 5. Oracle E-Business Suite (EBS) Custom Code & Blitz Report AI Rules

This workspace (and global Antigravity configuration) is also equipped with the **Enginatics Oracle EBS AI Development & Business Process Framework** (`.agents/skills/`).

### Non-Negotiable EBS Working Rules
1. **Environment & Data Safety:**
   - **Never** run DDL/DML, compile packages, or run upload tests on a production EBS database.
   - Never hard-code passwords in files, scripts, or markdown. Always use saved SQLcl connections (via the `sqlcl` MCP server) or `$APPS_PWD` environment variables.
   - Check `.claude/rules/blitz-environment.md` (or `.agents/rules/blitz-environment.md`) for instance connection details, responsibility IDs, and test user initialization (`fnd_global.apps_initialize` + `mo_global.init`). If not yet configured for the target dev/Vision instance, follow the `blitz-environment-setup` skill.
2. **Closed-Loop Development Workflow (`development-workflow`):**
   - **Baseline first:** Before changing an existing PL/SQL package, view, SLA logic, Blitz Report, or Blitz Upload, inspect its current definition and capture baseline behavior/output on the development instance.
   - **Deploy & Compile:** When compiling PL/SQL via SQLcl MCP or SQL*Plus, always `set define off`, compile package specification (`.pks`) before body (`.pkb`), and immediately check `DBA_ERRORS` / `USER_ERRORS` (`show errors`).
   - **Static Linting:** Run `Enginatics_AI_Skills/plugins/blitz-report-ai-skills/scripts/lint_plsql.py` on custom/upload PL/SQL packages and `lint_upload_xml.py` on Blitz Upload XML files before declaring work complete.
   - **Verify & Compare:** Test changes on the development instance with realistic `fnd_global.apps_initialize(user_id, resp_id, resp_appl_id)` context, verify row counts/values and execution plans, and report concrete metrics.
3. **EBS SQL & PL/SQL Coding Standards (`coding-standards`):**
   - **Formatting:** Lowercase SQL keywords, table names, aliases, and column names; `and`/`or` at the **end** of lines in `WHERE` clauses; compact commas (`a,b,c`) in `SELECT`/`GROUP BY`/`ORDER BY` lists; no space around `=` in predicates (`aia.vendor_id=aps.vendor_id`); 2-space indentation; explicit table aliases on every column.
   - **EBS Base Tables vs Views:** Query base tables (`_all` / `_b` / `_tl` with `language=userenv('lang')`) rather than heavy multi-org/MLS views (`_v`) in performance-critical SQL, applying MOAC security (`mo_global.check_access`) or explicit org filters where appropriate.
   - **Public APIs Only for Writes:** Never perform direct `INSERT`/`UPDATE`/`DELETE` on Oracle EBS transactional base tables when an open interface table or standard public API (`*_PUB`, `*_API`) exists.
   - **Continuous Learning:** Whenever an EBS trap or bug is discovered and fixed, codify a 1–2 sentence prevention rule in the matching `.agents/rules/` / `.claude/rules/` file.
