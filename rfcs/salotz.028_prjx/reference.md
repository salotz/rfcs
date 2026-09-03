# Reference

Succinct reference for mechanisms defined in the main [README](./README.md).

## Sentinel files

| File | Location | Purpose |
|------|----------|---------|
| `.prjx-root` | Direct child of project root | Marks the project root. Contents ignored (should be empty). Closest match walking upward wins. Nested sentinels are not supported. |
| `_project-meta.toml` | `${PRJX_CONFIG_HOME}/` (default `${PRJX_ROOT}/.config/`) | Portable project metadata. Tracked in VCS. |
| `_config.toml` | `${PRJX_LOCAL_CONFIG_HOME}/` (default `${PRJX_ROOT}/.local/`) | Host- and replica-specific overrides. Deep-merged onto portable metadata. Not tracked in VCS. |

## Environment variables

### Spec-defined (`PRJX_`)

| Variable | Meaning | Notes |
|----------|---------|-------|
| `PRJX_ROOT` | Absolute path to project root | Highest precedence for root discovery; ignored if unset, empty, or not absolute. |
| `PRJX_CONFIG_HOME` | Absolute path to portable project config dir | Default: `${PRJX_ROOT}/.config`. |
| `PRJX_LOCAL_CONFIG_HOME` | Absolute path to host-local project dir | Default: `${PRJX_ROOT}/.local`. |
| `PRJX_ID` | Project replica ID on this host | Used for replica-scoped XDG/XDGX leaves. Must match `^[a-zA-Z0-9_-]{1,32}$`. |
| `PRJX_HOST_CONFIG_HOME` | Override of host-config PRJX home | Default: `~/.config/prjx`. |
| `PRJX_CACHE_HOME` | Override of cache PRJX home | Default: `~/.cache/prjx`. |
| `PRJX_DATA_HOME` | Override of share/data PRJX home | Default: `~/.local/share/prjx`. |
| `PRJX_TMP_HOME` | Override of tmp PRJX home (XDGX) | Default: `~/.local/tmp/prjx`. |
| `PRJX_SCRATCH_HOME` | Override of scratch PRJX home (XDGX) | Default: `~/.local/scratch/prjx`. |
| `PRJX_VAR_HOME` | Override of var PRJX home (XDGX) | Default: `~/.local/var/prjx`. |

PRJX home overrides replace the `.../prjx` directory itself, not a
dynamic `.../prjx/${PRJX_ID}` leaf.

### Project-local (`PRJX__`)

| Pattern | Meaning |
|---------|---------|
| `PRJX__<LEAF>` | Project-defined variable. Leaf names are declared in `[project.env-vars]` of `_project-meta.toml` (mergeable from local config). |

Naming follows [RFC 27](../salotz.027_env-nexps/README.md): `PRJX` namespace, single `_` within symbols, `__` between fields.

## Default directories

### Inside the project

| Directory | Default | Tracked? | Override |
|-----------|---------|----------|----------|
| config | `${PRJX_ROOT}/.config` | yes | `PRJX_CONFIG_HOME` |
| local | `${PRJX_ROOT}/.local` | no (gitignore) | `PRJX_LOCAL_CONFIG_HOME` |

### Host XDG / XDGX PRJX homes

| Type | Default PRJX home | Env override |
|------|-------------------|--------------|
| host config | `~/.config/prjx` | `PRJX_HOST_CONFIG_HOME` |
| cache | `~/.cache/prjx` | `PRJX_CACHE_HOME` |
| share / data | `~/.local/share/prjx` | `PRJX_DATA_HOME` |
| tmp | `~/.local/tmp/prjx` | `PRJX_TMP_HOME` |
| scratch | `~/.local/scratch/prjx` | `PRJX_SCRATCH_HOME` |
| var | `~/.local/var/prjx` | `PRJX_VAR_HOME` |

Leaves under a PRJX home (tool-chosen):

| Scope | Typical leaf | Needs |
|-------|--------------|--------|
| Project-shared | `{namespace}_{name}` | FQ project name |
| Replica-specific | `{PRJX_ID}` or `{namespace}_{name}_{distinguisher}` | `PRJX_ID` (or composition) |

## Project root discovery (precedence)

1. `PRJX_ROOT` (absolute path)
2. Upward search for closest `.prjx-root`

Nested `.prjx-root` markers are not nested scopes; only one root is resolved.

## Project ID resolution (precedence)

1. `PRJX_ID` environment variable
2. `replica.id` in `${PRJX_LOCAL_CONFIG_HOME}/_config.toml`
3. Compose from `project.namespace` + `project.name` + `replica.distinguisher` (merged metadata)
4. Tool-determined dynamically (e.g. git branch name)

Recommended composition:

```text
{namespace}_{name}_{distinguisher}
```

with `.` replaced by `_`. Truncate and append a short unique suffix if longer than 32 characters.

If no distinguisher is configured, the tool decides how to form the ID.

## Metadata merge

`${PRJX_LOCAL_CONFIG_HOME}/_config.toml` is **deep-merged** onto
`${PRJX_CONFIG_HOME}/_project-meta.toml`. Local values win per key.
All portable sections are overridable, including `[project.env-vars]`.

## `.config/_project-meta.toml` reference

Portable metadata. Reserved filename under the config directory.

```toml
[project]
name = "wumpus"                 # project name
namespace = "acme"              # may contain dots, e.g. "acme.engineering"
# FQ name => "acme.wumpus"

[project.env-vars]
# leaf = "group" | "group-a,group-b" | "" | "-" | "*"
OP_SERVICE_ACCOUNT_TOKEN = "secrets"
PULUMI_ACCESS_TOKEN = "secrets,infra"
ENV_NAME = "integration-testing"
DATA_PATH = "functional-testing"
# ""  => default group
# "-" => required
# "*" => optional, ungrouped
# named group(s) => normative for tools; optional outside those group contexts
```

Each `leaf` corresponds to process env var `PRJX__<leaf>`.

Groups are normative for tools that interpret them.

## `.local/_config.toml` reference

Host- and replica-specific. Gitignored with the rest of the local dir.
Deep-merged onto portable metadata.

```toml
[replica]
distinguisher = "test-bed"   # used when composing PRJX_ID
# id = "acme_wumpus_test-bed"  # optional explicit ID (precedence over composition)

[project]
# optional overrides of portable metadata for this host/replica
name = "wumpus-other"
namespace = "work"

# [project.env-vars] may also be extended or overridden here
```
