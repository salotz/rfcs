# Handoff: application environment-variable registry RFCs

**Date:** 2026-09-26  
**From:** yerk session (operator review of env help / RFC 28 registration)  
**For:** next session working in this RFCs repo (`salotz/rfcs`)  
**Status:** ideation only — no draft RFC files yet; open journal TODOs

## One-line answer to the operator question

Yes: **static configuration / machine-readable declaration of application environment variables** was an **open idea**, not something already specified. It sat as unfinished work after RFC 27 (env nexps) and RFC 28 (PRJX / project-local `PRJX__*`). It is **not** the same as yerk host `YERK__*` knobs, and **not** the same as PRJX `[project.env-vars]` (project-local leaves).

## Source TODOs (org)

Primary journal trail (job-examol):

| ID | Path | What |
|----|------|------|
| 2501 | `admin/org/notes/journal/20260902T000000==2501--journal__journal_job-examol.org` | Checklist after env RFCs: done 27 + project-local naming; **open** two RFCs below |
| 2502 | `admin/org/notes/journal/20260903T000001==2502--journal__journal_job-examol.org` | Same two TODOs restated; **punted** cross-cutting common-control vars (“no use at the moment”); grok share linked for discussion |
| 2499 | `admin/org/notes/journal/20260821T000000==2499--journal__journal_job-examol.org` | Split into (1) naming nexps (2) project layout + project-local env namespace; tables of common unprefixed controls + compiler vars |

Exact open items (quoted intent):

1. **RFC for specifying in a machine-readable format the environment variables and env variable namespaces used by the program.**
2. **RFC formalizing which cross-cutting env vars to respect** (e.g. `DEBUG`, `LOG_LEVEL`, `NO_COLOR`, etc.).

Operator framing in 2502: these are for **applications**, not **projects**.

Related but **different** ideation (do not fold into these RFCs without explicit scope):

- **yerk “staging local configuration”** — file placement of gitignored host locals (e.g. `.dvc/config.local`) into replicas on clone/worktree. Source: `notes/todo/ideas/20260925T115055--software-project-management-tool__dev_software_todo.org` § *Staging local configuration*. Product feature for yerk / RFC 26 domain-local config, not app-env registry.
- **RFC 28 `[project.env-vars]`** — declares **project-local** process leaves as `PRJX__<LEAF>` with group markers. Already shipped in `rfcs/salotz.028_prjx/`.

## What already exists (do not reinvent)

| RFC | Role |
|-----|------|
| [027 env-nexps](../../rfcs/salotz.027_env-nexps/README.md) | **Names only**: screaming snake, `_` words, `__` fields, leading `_` / `__`, top-level namespace word. |
| [027 unix-names.md](../../rfcs/salotz.027_env-nexps/unix-names.md) | Inventory of POSIX / XDG / de facto reserved names and prefixes — raw material for the cross-cutting RFC. |
| [028 prjx](../../rfcs/salotz.028_prjx/README.md) | Project layout + **`PRJX_*` spec vars** + **`PRJX__*` project-local leaves** via `[project.env-vars]` in `_project-meta.toml` / deep-merge `.local/_config.toml`. |
| [004 nexps](../../rfcs/salotz.004_nexps.md) | Parent name-expression idea. |
| [024 XDGX](../../rfcs/salotz.024_extended_xdg_base_directory/) | Extended base dirs (referenced by 028). |
| [026 domain-local configuration](../../rfcs/salotz.026_domain-local-configuration/) | Host/domain locals outside projects (staging story for yerk). |

RFC 28 already notes **future extensions** on project env-var *metadata* (not a full app registry):

- help string  
- tool-managed vs user/host-managed  

That is a natural **compatibility surface** with a richer app-env declaration format, but 028 should stay about **project** leaves under `PRJX__`, not general application product vars (`YERK__`, `FNOX__`, unprefixed controls, etc.).

## Layer map (keep these distinct in any new RFC)

```
┌─────────────────────────────────────────────────────────────┐
│ Process environment (global namespace)                       │
├──────────────────┬──────────────────┬───────────────────────┤
│ Cross-cutting    │ Application /    │ Project-local (PRJX)  │
│ unprefixed /     │ product prefix   │ PRJX__<LEAF>          │
│ de facto         │ APP__FIELD       │ declared in           │
│ DEBUG, NO_COLOR, │ (RFC 27 nexp)    │ [project.env-vars]    │
│ LOG_LEVEL, CI…   │                  │ (RFC 28)              │
│ → proposed RFC B │ → proposed RFC A │ already specified     │
└──────────────────┴──────────────────┴───────────────────────┘
         ↑                    ↑
    “respect these”     “declare what *this program*
     semantics          reads, scopes, defaults, help”
```

**yerk lesson (pilot, not normative):**

- Tool knobs: `YERK__CONFIG`, `YERK__CONFIG_DIR`, `YERK__CATALOG`, `YERK__WORKSPACE_*` — product CLI, **not** registered under `[project.env-vars]` (wrong prefix).
- Repo metadata `.config/_project-meta.toml` for **salotz.yerk**: `[project] name/namespace` only; **empty** `[project.env-vars]` for MVP (no required `PRJX__` leaves).
- Comprehensive help: single Go registry `internal/envvars` → `yerk --help` lists all affecting the product; subcommand help = top-level tool/platform vars that command uses + pointer to full list. Prefer comprehensive over selective docs; optional `--help-all` later if large.
- ADR 003 in yerk explicitly: do not put `YERK__*` in `[project.env-vars]`.

Use yerk as a **worked example** of “application static env registry for help/discovery,” not as the RFC schema itself.

## Suggested split for this RFCs session

Propose **two** drafts (names provisional; pick free nexp IDs — next after 029 is **030+**):

### A. Application env-var registry (machine-readable)

**Working title ideas:** Application Environment Variable Registry · Program Env Manifest · Env Declaration Format  

**Problem:** Programs need a single, tool- and human-readable place that lists which env vars they read, under which namespaces/prefixes, with enough metadata for help, validation, secret tooling, and agents.

**In scope (suggested):**

- Static declaration format (TOML preferred for consistency with PRJX meta; allow JSON/YAML export later if needed).
- Fields beyond bare name: summary/help, default (prose or literal), required vs optional, secret-ish grouping, which subcommands/surfaces read it, scope (global vs command), ownership (app vs platform vs inherited spec).
- How this relates to RFC 27 **names** (conformance) without redefining nexp syntax.
- How **application** registries differ from RFC 28 `[project.env-vars]` (prefix ownership: product `FOO__*` vs project `PRJX__*`).
- Emission into CLI `--help` / machine query (normative enough for tools; not mandating one language SDK).
- Optional: groups analogous to 028 env-var groups, if useful for apps.

**Out of scope (suggested):**

- Values / secret storage (fnox etc. consume the registry).
- Shell variables.
- Mandating every binary ship a file (best practice + interoperability).
- Replacing 028 project leaves.

**Seed from yerk `Var` shape (illustrative only):**

```text
Name, Scope (tool|prjx-spec|prjx-project|platform), Summary, Default,
Global bool, Commands []string
```

028 future: help string; tool-managed vs user-managed — align vocabulary if both RFCs touch metadata.

### B. Cross-cutting control environment variables

**Working title ideas:** Common Application Control Env Vars · Shared Process Controls  

**Problem:** Unprefixed / weakly namespaced controls collide and differ in semantics across tools; operators and apps still want a shared vocabulary.

**Candidate set from journals (2502 / 2499):**

| Name | Role (sketch) |
|------|----------------|
| `DEBUG` | Debug flag |
| `VERBOSE` | Verbose flag |
| `DRY_RUN` | Dry run |
| `TRACE` | Tracing |
| `LOG_LEVEL` | Log verbosity |
| `FORCE_COLOR` / `NO_COLOR` | Color (see no-color.org) |
| `CI` | Running in CI |

Also discussed: temp dirs (`TMPDIR`, `TEMP`, `TMP`, …) and **compiler** family (`CC`, `CFLAGS`, …) — possibly a **separate appendix** or third RFC; 027 `unix-names.md` already lists many POSIX/compiler names as “do not repurpose.”

**In scope (suggested):**

- Normative-or-best-practice semantics when an application **claims** to respect each name.
- Interaction with prefixed app vars (`MYAPP__LOG_LEVEL` vs `LOG_LEVEL`).
- Pointers to external specs (`NO_COLOR`, CI vendor vars) without forking them.
- Explicit non-goals: inventing new POSIX; requiring apps to implement all of them.

**Operator note (2502):** previously **punted** for lack of immediate need — re-open only if this session still wants it; otherwise draft A first and leave B as a thin stub + link from A.

## Non-goals for the handoff session

- Implementing yerk features (register/pull/push, local file staging, parallel status).
- Rewriting RFC 27/28 unless a clear cross-link or errata is required.
- Putting application product vars into `[project.env-vars]`.

## Concrete starting steps (RFCs repo)

1. Read 027 README + `unix-names.md`, 028 “Project local environment variables” + reference `[project.env-vars]`, and this handoff.
2. Confirm free nexp numbers in top-level [README.md](../../README.md) index (029 is glossary-format; use **030** / **031** unless index says otherwise).
3. Draft RFC A skeleton under `rfcs/salotz.030_…/` (or chosen id) with metadata block matching sibling RFCs; add index row per `contributing/editing.md`.
4. Optionally stub RFC B or a section “Related: cross-cutting controls (future)”.
5. Cross-link: 027 (names), 028 (project leaves only), this handoff path for provenance.
6. Do **not** require yerk to adopt the schema in the same change set; yerk remains a pilot consumer later.

## Provenance paths (absolute on operator host)

```text
Org journals:
  /home/salotz/tree/personal/admin/org/notes/journal/20260821T000000==2499--journal__journal_job-examol.org
  /home/salotz/tree/personal/admin/org/notes/journal/20260902T000000==2501--journal__journal_job-examol.org
  /home/salotz/tree/personal/admin/org/notes/journal/20260903T000001==2502--journal__journal_job-examol.org

yerk pilot (separate product repo):
  /home/salotz/tree/personal/devel/yerk/main/internal/envvars/envvars.go
  /home/salotz/tree/personal/devel/yerk/main/.config/_project-meta.toml
  /home/salotz/tree/personal/devel/yerk/main/design/decisions/003-config-xdg-and-env.md

This handoff:
  /home/salotz/tree/personal/devel/rfcs/.agents/context/20260926--app-env-var-registry-handoff.md
```

## Open questions for the author (not decided)

1. One RFC vs two? (Recommendation: **two**, A first.)
2. Declaration file location convention: in-repo (e.g. `.config/env-vars.toml`), XDG, beside binary, or embed-only?
3. Is the format **descriptive** (documentation/help) or **normative for loaders** (must refuse missing `-` required vars)?
4. Relationship to secret managers: declare leaves only, or also “managed by tool X”?
5. Should cross-cutting RFC **forbid** apps from inventing conflicting unprefixed names, or only define semantics when used?
6. Revisit 028 future metadata (help, tool-managed) as a **small 028 amendment** vs only in RFC A?

## Session prompt (paste-ready)

```text
Work in the RFCs repo. Read:
  .agents/context/20260926--app-env-var-registry-handoff.md
  rfcs/salotz.027_env-nexps/README.md
  rfcs/salotz.027_env-nexps/unix-names.md
  rfcs/salotz.028_prjx/README.md (project local environment variables)
  contributing/editing.md

Goal: draft RFC(s) for (1) machine-readable application env-var registry
and optionally (2) cross-cutting control env vars (DEBUG, LOG_LEVEL,
NO_COLOR, …). These are application-level, not PRJX [project.env-vars].
Do not register product prefixes under PRJX__. Use yerk internal/envvars
only as a pilot example. Update the top-level README index. Ask before
amending 027/028 normatively.
```
