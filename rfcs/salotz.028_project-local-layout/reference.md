# Reference

Succinct reference for mechanisms defined in the main [README](./README.md).

## Sentinel files

| File                 | Location                                                 | Purpose                                                                                      |
|----------------------|----------------------------------------------------------|----------------------------------------------------------------------------------------------|
| `.prjx-root`         | Direct child of project root                             | Marks the project root. Contents ignored (should be empty). First match walking upward wins. |
| `_project-meta.toml` | `${PRJX_CONFIG_HOME}/` (default `${PRJX_ROOT}/.config/`) | Portable project metadata. Tracked in VCS.                                                   |
| `_config.toml`       | `${PRJX_ROOT}/.local/`                                   | Host- and replica-specific overrides. Not tracked in VCS.                                    |

## Environment variables

### Spec-defined (`PRJX_`)

| Variable                | Meaning                             | Notes                                                                            |
|-------------------------|-------------------------------------|----------------------------------------------------------------------------------|
| `PRJX_ROOT`             | Absolute path to project root       | Highest precedence for root discovery; ignored if unset, empty, or not absolute. |
| `PRJX_CONFIG_HOME`      | Absolute path to project config dir | Default: `${PRJX_ROOT}/.config`.                                                 |
| `PRJX_ID`               | Project replica ID on this host     | Required for XDG/XDGX integration. Must match `^[a-zA-Z0-9_-]{1,32}$`.           |
| `PRJX_HOST_CONFIG_HOME` | Override base for host config       | Default base: `~/.config`. Project path: `$base/prjx/${PRJX_ID}`.                |
| `PRJX_CACHE_HOME`       | Override base for cache             | Default base: `~/.cache`.                                                        |
| `PRJX_DATA_HOME`        | Override base for shared data       | Default base: `~/.local/share`.                                                  |
| `PRJX_TMP_HOME`         | Override base for tmp (XDGX)        | Default base: `~/.local/tmp`.                                                    |
| `PRJX_SCRATCH_HOME`     | Override base for scratch (XDGX)    | Default base: `~/.local/scratch`.                                                |
| `PRJX_VAR_HOME`         | Override base for var (XDGX)        | Default base: `~/.local/var`.                                                    |

### Project-local (`PRJX__`)

| Pattern        | Meaning                                                                                            |
|----------------|----------------------------------------------------------------------------------------------------|
| `PRJX__<LEAF>` | Project-defined variable. Leaf names are declared in `[project.env-vars]` of `_project-meta.toml`. |

Naming follows [RFC 27](../salotz.027_env-nexps/README.md): `PRJX` namespace, single `_` within symbols, `__` between fields.

## Default directories

### Inside the project

| Directory | Default                | Tracked?       | Override           |
|-----------|------------------------|----------------|--------------------|
| config    | `${PRJX_ROOT}/.config` | yes            | `PRJX_CONFIG_HOME` |
| local     | `${PRJX_ROOT}/.local`  | no (gitignore) | —                  |

### Host XDG / XDGX (require `PRJX_ID`)

Resolved path: `${base}/prjx/${PRJX_ID}`

| Type         | Default `base`     | Env override            |
|--------------|--------------------|-------------------------|
| host config  | `~/.config`        | `PRJX_HOST_CONFIG_HOME` |
| cache        | `~/.cache`         | `PRJX_CACHE_HOME`       |
| share / data | `~/.local/share`   | `PRJX_DATA_HOME`        |
| tmp          | `~/.local/tmp`     | `PRJX_TMP_HOME`         |
| scratch      | `~/.local/scratch` | `PRJX_SCRATCH_HOME`     |
| var          | `~/.local/var`     | `PRJX_VAR_HOME`         |

## Project root discovery (precedence)

1. `PRJX_ROOT` (absolute path)
2. Upward search for `.prjx-root`

## Project ID resolution (precedence)

1. `PRJX_ID` environment variable
2. `replica.id` in `.local/_config.toml`
3. Compose from `project.namespace` + `project.name` + `replica.distinguisher`
4. Tool-determined dynamically (e.g. git branch name)

Recommended composition:

```text
{namespace}_{name}_{distinguisher}
```

with `.` replaced by `_`. Truncate and append a short unique suffix if longer than 32 characters.

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
# named group => optional outside that group's context
```

Each `leaf` corresponds to process env var `PRJX__<leaf>`.

## `.local/_config.toml` reference

Host- and replica-specific. Gitignored with the rest of `.local`.

```toml
[replica]
distinguisher = "test-bed"   # used when composing PRJX_ID
# id = "acme_wumpus_test-bed"  # optional explicit ID (precedence over composition)

[project]
# optional overrides of portable metadata for this host/replica
name = "wumpus-other"
namespace = "work"
```
