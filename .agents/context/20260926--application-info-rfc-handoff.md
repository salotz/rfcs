# Handoff: Application Info (RFC 030) + Application Env (RFC 031)

**Date:** 2026-09-26  
**Status:** **Split done.** RFC 030 is scaffolding-only; RFC 031 holds env registry norms.  
**Supersedes (for next steps):** earlier ideation-only  
[`.agents/context/20260926--app-env-var-registry-handoff.md`](20260926--app-env-var-registry-handoff.md)  
(keep that file for provenance / journal IDs)

## One-line state

**RFC 030** = scaffolding for `.appinfo/meta.toml` (project + products + extension rules).  
**RFC 031** = application **environment variable** declaration tables in that same file.  
Env is **not** normative core of 030.

## Artifacts in tree

| Path | Notes |
|------|--------|
| `rfcs/salotz.030_application-info/README.md` | Scaffolding-only draft |
| `rfcs/salotz.031_application-env/README.md` | Env registry extension draft |
| Top-level `README.md` § 030 / § 031 | Index rows |

## Decisions locked (do not re-litigate without reason)

### Problem / layering

- Goal: **machine- and human-readable context & usage** of the **application**.
- **Not** packslip (signed **release** install metadata).
- **Not** PRJX `.config/_project-meta.toml` (**project management**).
- Three layers:

  ```text
  Cross-cutting controls (DEBUG, NO_COLOR, …)  → future RFC (was “B”)
  Application product usage (appinfo + env)    → 030 scaffold + 031 env
  Project-local PRJX__*                        → RFC 28 already
  ```

- **Do not** put product `APP__*` under `[project.env-vars]`.

### Path and filename

| Choice | Value |
|--------|--------|
| Directory | **`.appinfo/`** |
| File | **`meta.toml`** |
| Full path | `${PROJECT_ROOT}/.appinfo/meta.toml` |

### Document model

- TOML, UTF-8, static
- Top-level **`version = "v0"`**
- **No `[tool.*]`**
- Extensions: top-level and/or per-product; each extension defines its shape
- Core parsers **MUST ignore** unknown keys/tables
- **Prose over schema**

### 030 core only

- `version`, optional `[project]`, `[products.*]` (`name`, `command`, `summary`, …)
- Env only as pointer / extension sketch → 031

### 031 env rules

| Topic | Decision |
|-------|----------|
| Location | Top-level `[env]` **and/or** `[products.<id>.env]` |
| `env_prefix` | Optional; screaming prefix **without** trailing dunder |
| Namespace | Process env is **global** |
| Short form | `NAME = "description string"` |
| Long form | **`[env.vars.NAME]`** — **not** `[[env.vars.NAME]]` |
| **`description`** | **MUST** on long form |
| **`long_description`**, **`default`**, **`required`**, **`groups`** | optional |
| **`external`** | optional bool, **default `false`** |
| Dropped | `commands`, `global`, fine `scope`, `defined_by`, `managed_by`, `secret`, secret values |

## Work remaining (optional follow-ons)

- [ ] Cross-cutting controls RFC (original B)
- [ ] Example `.appinfo/meta.toml` checked into RFC dirs
- [ ] JSON Schema / typify — only if needed
- [ ] Monorepo discovery algorithm (nearest `.appinfo` walk-up)
- [ ] packslip optional resource → appinfo
- [ ] Multiple `command`s per product
- [ ] Optional product `kind` in 030 core

## Related paths

- Drafts: [030](../../rfcs/salotz.030_application-info/README.md) · [031](../../rfcs/salotz.031_application-env/README.md)
- [027](../../rfcs/salotz.027_env-nexps/README.md) · [028](../../rfcs/salotz.028_prjx/README.md)
- Editing: [contributing/editing.md](../../contributing/editing.md)
