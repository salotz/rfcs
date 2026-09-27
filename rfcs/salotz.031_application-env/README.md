# Application Environment Registry

- nexp :: `salotz.031_application-env`
- long name :: Application Environment Registry
- executive summary ::
Defines environment-variable declaration tables for
[RFC 030](../salotz.030_application-info/README.md) application info documents
(`.appinfo/meta.toml`).
Products document shared and per-product env prefixes and variable maps
(`[env]` / `[products.<id>.env]`) with short- and long-form entries,
so humans, agents, and help tooling can discover what a product reads
without executing it or scraping prose.

## Motivation

Operators and agents need a stable answer to:

- Which **environment variables** does this application recognize?
- Which names are **defined by the product** vs **borrowed** (`HOME`, `XDG_*`, …)?
- What is a sensible **default**, and is the var **required**?

This is an extension to [RFC 030](../salotz.030_application-info/README.md).

## Goals

- Shared `[env]` and per-product `[products.<id>.env]`
- Short-form and long-form variable maps under `.vars`
- Lean field set with a focus on prose for complex descriptions (LLM first)
- Clear ownership flag: `external` (default false)

## Relationship to RFC 030

This RFC **depends on** RFC 030:

- Path remains `${PROJECT_ROOT}/.appinfo/meta.toml`
- Document `version`, `[project]`, and `[products.*]` stay core of 030
- `[env]` and `[products.<id>.env]` are **extension** tables under 030’s
  extension rule
- Core-only 030 consumers **MUST ignore** these tables

Authors **MAY** ship products without any env tables.
When env tables are present, this RFC’s rules apply.

## Config rules (normative)

### Location

| Table                 | Role                                                        |
|-----------------------|-------------------------------------------------------------|
| `[env]`               | Shared env for products in this file (e.g. client + server) |
| `[products.<id>.env]` | Additional prefix and/or vars for that product              |

Both may appear. Process environment remains a **single global namespace**.
Product-specific prefixes do **not** hide shared vars.

### `env_prefix`

Optional string on `[env]` and/or `[products.<id>.env]`.

A prefix the product owns for all specific envvars.
Write it without the trailing double-underscore.
Use it as documentation and as the expected first field of application-defined names:
`WUMPUS` implies `WUMPUS__*`, `WUMPUS_CLI` implies `WUMPUS_CLI__*`.
Name form follows [RFC 27](../salotz.027_env-nexps/README.md).

Multiple prefixes may coexist in one file (shared plus per-product).
They do not create nested environments; every name still lives in the single
global process env.

```toml
[env]
env_prefix = "WUMPUS"

[products.wumpus-cli.env]
env_prefix = "WUMPUS_CLI"
```

### Variable maps: `[env.vars]` and `[products.<id>.env.vars]`

Two **equivalent** authoring forms.
Keys are the **full** environment variable names ([RFC 27](../salotz.027_env-nexps/README.md) form **SHOULD**).

#### Short form

Key maps to a description string:

```toml
[env.vars]
WUMPUS__WORKSPACE_STYLE = "Workspace style to use."

[products.wumpus-cli.env.vars]
WUMPUS_CLI__CONFIG = "Configuration file for WUMPUS CLI"
```

#### Long form

Key is a **subtable** (single table, **not** array-of-tables):

```toml
[env.vars.WUMPUS__CATALOG]
description = "Path to the wumpus catalog config file."
long_description = "Absolute path preferred. When unset, derived under XDG_CONFIG_HOME."
default = "$XDG_CONFIG_HOME/wumpus/catalog.toml"
required = false
groups = ["config"]
# external defaults to false — omit for application-defined names

[env.vars.XDG_CONFIG_HOME]
description = "XDG base dir for user config; used when resolving default paths."
external = true
```

#### Long-form fields

| Key                | Required | Type                       | Default | Meaning                                                                                  |
|--------------------|----------|----------------------------|---------|------------------------------------------------------------------------------------------|
| `description`      | **MUST** | string                     | —       | One-line help (same role as the short-form string value).                                |
| `long_description` | optional | string                     | —       | Extended prose description.                                                              |
| `default`          | optional | string                     | —       | Default when unset                                                                       |
| `required`         | optional | bool                       | `false` | Descriptive unless a consumer enforces                                                   |
| `external`         | optional | bool                       | `false` | When `true`, the product **uses** this name but does **not** define it. Default `false`. |
| `groups`           | optional | array of string, or string | `[]`    | Optional app-defined labels.                                                             |

## Full example

Combines RFC 030 scaffolding with this extension:

```toml
version = "v0"

[project] # optional tree-level labels (RFC 030)
name = "wumpus"

# env vars shared across products, e.g. client and server
[env]
env_prefix = "WUMPUS"

# short form: name = description
[env.vars]
WUMPUS__WORKSPACE_STYLE = "Workspace style to use."

# long form: application-defined (external defaults to false — omit it)
[env.vars.WUMPUS__CATALOG]
description = "Path to the wumpus catalog config file."
long_description = "Absolute path preferred. When unset, derived under XDG_CONFIG_HOME."
default = "$XDG_CONFIG_HOME/wumpus/catalog.toml"
groups = ["config"]

# borrowed name
[env.vars.XDG_CONFIG_HOME]
description = "XDG base dir for user config; used when resolving default catalog/config paths."
external = true

[products.wumpus-cli]
name = "wumpus CLI"
command = "wumpus"
summary = "CLI client for wumpus"

[products.wumpus-cli.env]
# additional prefix for this product; names still live in the global env
env_prefix = "WUMPUS_CLI"

[products.wumpus-cli.env.vars]
WUMPUS_CLI__CONFIG = "Configuration file for WUMPUS CLI"

[products.wumpus-api]
name = "wumpus API server"
command = "wumpus-api"
summary = "HTTP API server for wumpus"

[products.wumpus-api.env]
env_prefix = "WUMPUS_API"

[products.wumpus-api.env.vars]
WUMPUS_API__DATABASE_URI = "Database connection URI"
```

## Open questions

1. Follow-on RFC for cross-cutting control semantics (`NO_COLOR`, `DEBUG`, …)?
3. JSON Schema / typify for env tables?

## Revision notes

- **v0 (draft):** Extracted from early RFC 030 drafts. Shared and per-product
  `[env]` / `[env.vars]`; short and long forms; `description` **MUST** on long
  form; optional `long_description`, `default`, `required`, `external`
  (default false), `groups`; forbid `[[env.vars.NAME]]` long form; no
  `secret` / `managed_by` / subcommand fields; prose-over-schema.
