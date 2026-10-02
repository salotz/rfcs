# Application Environment Registry

- nexp :: `salotz.031_application-env`
- long name :: Application Environment Registry
- executive summary ::
Defines environment-variable declaration tables for
[RFC 030](../salotz.030_application-info/README.md) application info documents
(`.appinfo/meta.toml`).
Products document shared and per-product env prefixes and variable maps
(`[env]` / `[products.<id>.env]`) as per-name subtables so humans, agents,
and help tooling can discover what a product reads without executing it or
scraping prose.
Entries MAY carry value metadata from
[RFC 032](../salotz.032_env-value-types/README.md):
`type`, `policy`, `default` (literal or structured), and for enums
canonical `values` plus `aliases` (canonical → alias list).

## Motivation

Operators and agents need a stable answer to:

- Which **environment variables** does this application recognize?
- Which names are **defined by the product** vs **borrowed** (`HOME`, `XDG_*`, …)?
- What **type** and **value policy** apply, and what is the **default**?
- For closed vocabularies, which **canonical values** and **aliases** are accepted?

This is an extension to [RFC 030](../salotz.030_application-info/README.md).
Value **types**, **token grammar**, and **policy** semantics are defined by
[RFC 032](../salotz.032_env-value-types/README.md).
This RFC defines a machine-readable **registry** format that in part
implements RFC 032 conventions.

## Goals

- Shared `[env]` and per-product `[products.<id>.env]`
- One variable-map shape under `.vars`: **per-name subtables** only
- Lean field set with a focus on prose for complex descriptions (LLM first)
- Clear ownership flag: `external` (default false)
- Optional value metadata aligned with RFC 032:
  `type`, `policy`, `default`, enum `values` / `aliases`
- Structured `default` when the fallback is not a simple literal
  (`value` and/or `resolution`)

## Relationship to RFC 030

This RFC **depends on** RFC 030:

- Path remains `${PROJECT_ROOT}/.appinfo/meta.toml`
- Document `version`, `[project]`, and `[products.*]` stay core of 030
- `[env]` and `[products.<id>.env]` are **extension** tables under 030’s
  extension rule
- Core-only 030 consumers **MUST ignore** these tables

Authors **MAY** ship products without any env tables.
When env tables are present, this RFC’s rules apply.

## Relationship to RFC 032

[RFC 032](../salotz.032_env-value-types/README.md) defines the **value**
layer: normative type names (`boolean`, `enum`, `string`, `null`,
`nullable-enum`), missing vs set, value policy (`silent` | `warn` |
`strict` | `required`), defaults, token matching, and the human
documentation table pattern.

This RFC maps those concepts onto registry fields so
`.appinfo/meta.toml` can carry the same facts machines already need from
prose tables. When an entry declares `type` and/or `policy`,
consumers **MUST** interpret them per RFC 032. Name form remains
[RFC 027](../salotz.027_env-nexps/README.md).

| Concern                        | Owner          |
|--------------------------------|----------------|
| Env **name** form              | RFC 027        |
| Product env **registry** shape | This RFC (031) |
| Value **types** and **policy** | RFC 032        |

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

Each recognized variable is a **subtable** keyed by the **full** environment
variable name ([RFC 27](../salotz.027_env-nexps/README.md) form **SHOULD**).
Use a single table per name (**not** array-of-tables).

```toml
[env.vars.WUMPUS__CATALOG]
description = "Path to the wumpus catalog config file."
long_description = "Absolute path preferred. When unset, derived under XDG_CONFIG_HOME."
type = "string"
policy = "warn"
default = { resolution = "Uses ${XDG_CONFIG_HOME}/wumpus/catalog.toml when available." }
groups = ["config"]
# external defaults to false — omit for application-defined names

[env.vars.WUMPUS__LOG_LEVEL]
description = "Minimum log severity."
type = "enum"
policy = "warn"
default = "info"
values = ["off", "error", "warn", "info", "debug", "trace"]

[env.vars.WUMPUS__LOG_LEVEL.aliases]
warn = ["warning"]

[env.vars.WUMPUS__VERBOSE]
description = "Extra stderr chatter."
type = "boolean"
policy = "warn"
default = false

[env.vars.WUMPUS_API__DATABASE_URI]
description = "Database connection URI."
type = "string"
policy = "required"
# no default — required has none

[env.vars.XDG_CONFIG_HOME]
description = "XDG base dir for user config; used when resolving default paths."
external = true
type = "string"
policy = "warn"
default = { resolution = "Platform / XDG Base Directory default when unset." }
```

**No string-valued short form.** Do **not** write:

```toml
# INVALID under this RFC
[env.vars]
WUMPUS__VERBOSE = "Extra stderr chatter."
```

A bare string under `.vars` cannot carry type, policy, or default without
implied magic; earlier drafts tried flag-shaped defaults and it was too
easy to mis-declare paths and URLs as booleans. Every variable is a
subtable; set fields explicitly.

#### Fields

| Key                | Required | Type                                  | Default | Meaning                                                                                  |
|--------------------|----------|---------------------------------------|---------|------------------------------------------------------------------------------------------|
| `description`      | **MUST** | string                                | —       | One-line help.                                                                           |
| `long_description` | optional | string                                | —       | Extended prose description.                                                              |
| `type`             | **SHOULD** | string                              | —       | RFC 032 normative type name: `boolean`, `enum`, `string`, `null`, or `nullable-enum`.    |
| `policy`           | optional | string                                | `warn`  | RFC 032 value policy: `silent`, `warn`, `strict`, or `required`.                         |
| `default`          | optional | scalar or table                       | —       | Literal and/or resolution prose when `policy` is not `required` (RFC 032).               |
| `values`           | optional | array of string                       | —       | Canonical tokens for `enum` / `nullable-enum` (lowercase kebab-case **SHOULD**).         |
| `aliases`          | optional | table string → array of string        | —       | Canonical token → list of aliases for `enum` / `nullable-enum`.                          |
| `external`         | optional | bool                                  | `false` | When `true`, the product **uses** this name but does **not** define it. Default `false`. |
| `groups`           | optional | array of string, or string            | `[]`    | Optional app-defined labels.                                                             |

#### Value metadata rules (normative)

These rules apply when the corresponding fields are present.
`policy` alone has a default when omitted (`warn`).
**`type` and `default` are never implied** as boolean/`false`—authors set
them when they matter.
Semantics for types and policies are defined by
[RFC 032](../salotz.032_env-value-types/README.md);
this section only constrains the registry encoding.

1. **`type`.** When set, **MUST** be exactly one of the RFC 032 normative
   names: `boolean`, `enum`, `string`, `null`, `nullable-enum`.
   Do not use synonyms (`bool`, `str`, …).
   Authors **SHOULD** set `type` on every entry. When omitted, consumers
   **MUST NOT** invent a type (in particular **MUST NOT** assume
   `boolean`).
2. **`policy`.** When set, **MUST** be one of `silent`, `warn`, `strict`,
   `required`. When omitted, consumers **MUST** treat the policy as
   `warn` (RFC 032 default).
3. **`default`.** Declares what applies when the variable is missing
   (and, under some policies, when set but invalid)—see RFC 032.
   Two **equivalent** encodings:

   | Form | Example | Meaning |
   |------|---------|---------|
   | **Shorthand scalar** | `default = "info"` or `default = false` | Same as `{ value = ... }` |
   | **Table** | `default = { value = "info" }` or `default = { resolution = "..." }` | Explicit fields |

   Table fields:

   | Key            | Type   | Meaning |
   |----------------|--------|---------|
   | `value`        | scalar | Literal default when it is a simple, documentable value. Prefer native TOML types where they match the env type (`false`/`true` for `boolean`; strings for enum tokens and opaque strings). **Omit** when there is no single literal (use `resolution` only) and **MUST omit** when `policy` is `required`. |
   | `resolution`   | string | Prose describing how the default is obtained when it is not a simple literal—other env vars, XDG paths, platform conventions, derived paths, etc. LLM- and operator-oriented; not a mini-expression language. |

   Rules:

   - When `policy` is `required`, authors **MUST NOT** set `default`
     (neither shorthand nor table).
   - When `policy` is not `required` and `default` is set, the table form
     **MUST** include at least one of `value` or `resolution`.
   - Prefer **shorthand** (or `{ value = ... }` only) when the default is
     a simple literal (`false`, `"info"`, `"auto"`).
   - Prefer **`resolution`** (alone or with an optional illustrative
     `value`) when the fallback depends on the environment or other
     variables—e.g. paths under `${XDG_CONFIG_HOME}`, platform user dirs,
     or “derived from sibling config.”
   - Do **not** pretend a path template is a wire literal if the process
     actually resolves it through other env vars; put that story in
     `resolution`.
   - There is **no** implied default (including no implied `false` for
     booleans). Authors **SHOULD** set `default` when `policy` is not
     `required` (RFC 032 **MUST** at the value layer; the registry remains
     descriptive unless a consumer enforces completeness).
   - Shorthand `default = "…"` / `default = false` is **exactly**
     equivalent to `default = { value = "…" }` / `default = { value = false }`.

4. **`values`.** Canonical closed vocabulary for `enum` and
   `nullable-enum`.
   - When `type` is `enum` or `nullable-enum`, authors **SHOULD** list
     every canonical token.
   - Tokens **SHOULD** be lowercase kebab-case per RFC 032.
   - For `nullable-enum`, list only the **enum** members; typed `null`
     comes from RFC 032 null tokens (`null`, `none`, `nil`) and **MUST
     NOT** appear as an ordinary enum member or alias key/entry.
   - For `boolean`, `string`, and `null`, omit `values` (boolean and
     null token sets are fixed by RFC 032).

5. **`aliases`.** Table whose **keys are canonical tokens** and whose
   **values are arrays of alias strings** that resolve to that canonical.
   Orientation is **canonical → aliases** (many aliases, one canonical)—
   the inverse of some prose tables that list alias → canonical.

   ```toml
   [env.vars.WUMPUS__LOG_LEVEL.aliases]
   warn = ["warning"]
   # debug = ["dbg", "verbose"]   # multiple aliases per canonical
   ```

   - Each key **MUST** be a canonical token listed in `values` (for
     `enum` / `nullable-enum`).
   - Each array entry is one alias spelling; omit canons that have no
     aliases (do not write empty arrays).
   - Aliases **MUST** be explicit here or nowhere—no prose-only aliases
     in the registry sense.
   - Encode as a subtable (`[env.vars.NAME.aliases]`) or an inline table
     of arrays when small.
   - Case-insensitive matching on the wire is defined by RFC 032; store
     aliases in the preferred documented spelling.
   - Boolean and null fixed aliases stay in RFC 032; do not re-list them
     unless a product documents an **additional** product-specific alias
     (rare; prefer not to).

6. **No `required` bool.** Older drafts used `required = true|false`.
   That flag is **removed**. Express obligation with
   `policy = "required"` (and omit `default`).

7. **Descriptive by default.** Registry fields document intent.
   Runtime enforcement of `policy`, defaults, and token grammars is a
   consumer/runtime concern unless a product states otherwise.

#### Mapping to the RFC 032 documentation table

| RFC 032 docs column  | Registry field                                                                  |
|----------------------|---------------------------------------------------------------------------------|
| Name                 | Table key under `.vars`                                                         |
| Type                 | `type` (no implied default)                                                     |
| Policy               | `policy` (default `warn` if omitted)                                            |
| Default              | `default` shorthand scalar, or `default.value` / `default.resolution`           |
| Canonical values     | `values`                                                                        |
| Aliases              | `aliases` (registry: canonical → `[alias, …]`; docs tables often invert the arrow) |
| Description          | `description` / `long_description`                                              |

## Full example

Combines RFC 030 scaffolding with this extension and RFC 032 value fields:

```toml
version = "v0"

[project] # optional tree-level labels (RFC 030)
name = "wumpus"

# env vars shared across products, e.g. client and server
[env]
env_prefix = "WUMPUS"

[env.vars.WUMPUS__WORKSPACE_STYLE]
description = "Workspace style to use."
type = "enum"
policy = "warn"
default = "default"
values = ["default", "compact", "wide"]

[env.vars.WUMPUS__CATALOG]
description = "Path to the wumpus catalog config file."
long_description = "Absolute path preferred. When unset, derived under XDG_CONFIG_HOME."
type = "string"
policy = "warn"
default = { resolution = "Uses ${XDG_CONFIG_HOME}/wumpus/catalog.toml when available." }
groups = ["config"]

[env.vars.WUMPUS__LOG_LEVEL]
description = "Minimum log severity."
type = "enum"
policy = "warn"
default = "info"   # shorthand for { value = "info" }
values = ["off", "error", "warn", "info", "debug", "trace"]

[env.vars.WUMPUS__LOG_LEVEL.aliases]
warn = ["warning"]

[env.vars.WUMPUS__VERBOSE]
description = "Extra stderr chatter."
type = "boolean"
policy = "warn"
default = false

[env.vars.XDG_CONFIG_HOME]
description = "XDG base dir for user config; used when resolving default catalog/config paths."
external = true
type = "string"
policy = "warn"
default = { resolution = "Platform / XDG Base Directory default when unset." }

[products.wumpus-cli]
name = "wumpus CLI"
command = "wumpus"
summary = "CLI client for wumpus"

[products.wumpus-cli.env]
# additional prefix for this product; names still live in the global env
env_prefix = "WUMPUS_CLI"

[products.wumpus-cli.env.vars.WUMPUS_CLI__DEBUG]
description = "Enable CLI debug output."
type = "boolean"
policy = "warn"
default = false

[products.wumpus-cli.env.vars.WUMPUS_CLI__CONFIG]
description = "Configuration file for WUMPUS CLI"
type = "string"
policy = "warn"
default = { resolution = "Uses ${XDG_CONFIG_HOME}/wumpus/cli.toml when available." }

[products.wumpus-api]
name = "wumpus API server"
command = "wumpus-api"
summary = "HTTP API server for wumpus"

[products.wumpus-api.env]
env_prefix = "WUMPUS_API"

[products.wumpus-api.env.vars.WUMPUS_API__DATABASE_URI]
description = "Database connection URI"
type = "string"
policy = "required"
```

## Open questions

1. Follow-on RFC for cross-cutting control semantics (`NO_COLOR`, `DEBUG`, …)?
2. JSON Schema / typify for env tables (including RFC 032 field enums,
   structured `default`, and `aliases` arrays)?
3. Allow `default.value` to carry a non-wire “template string” for display
   while `resolution` remains authoritative—or keep templates only inside
   `resolution` prose?

## Revision notes

- **v0.3 (draft):** Remove string-valued short form entirely. Only
  per-name subtables under `.vars`. Drop implied `type=boolean` /
  `default=false` sugar; authors set `type` and `default` explicitly.
  `policy` still defaults to `warn` when omitted (RFC 032).
- **v0.2 (draft):** `aliases` orientation is **canonical → array of
  aliases** (e.g. `warn = ["warning"]`). `default` accepts a shorthand
  scalar or a table with `value` and/or `resolution` for non-literal
  fallbacks. Boolean defaults use native TOML `false`/`true` where
  applicable. (Short-form flag sugar from this revision is withdrawn in
  v0.3.)
- **v0.1 (draft):** Adopt RFC 032 value metadata on variable entries:
  optional `type`, `policy` (default `warn`), refined `default`, enum
  `values` and `aliases`. Remove boolean `required` in favor of
  `policy = "required"`. Cite RFC 032 for semantics; keep registry
  descriptive by default. Expand examples (boolean, enum, required string).
- **v0 (draft):** Extracted from early RFC 030 drafts. Shared and per-product
  `[env]` / `[env.vars]`; short and long forms; `description` **MUST**;
  optional `long_description`, `default`, `required`, `external`
  (default false), `groups`; forbid `[[env.vars.NAME]]`; no
  `secret` / `managed_by` / subcommand fields; prose-over-schema.
