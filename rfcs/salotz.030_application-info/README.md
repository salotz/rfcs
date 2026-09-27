# Application Info

- nexp :: `salotz.030_application-info`
- long name :: Application Info
- executive summary ::
Defines a static, machine- and human-readable **application info** document for software products:
context and usage metadata that operators,
agents, and tools can consume without scraping READMEs or CLI help strings.
The default path is `.appinfo/meta.toml` at the application project root.
The format is a small TOML core (`version`,
optional `[project]`, `[products.*]`) plus an open extension rule:
new concerns add their own top-level or per-product tables and define their own shape.
Environment-variable registries are specified separately in
[RFC 031](../salotz.031_application-env/README.md).
Complementary to jdx packslip (signed release / supply-chain install metadata) and RFC 28 PRJX project-management metadata (`.config/_project-meta.toml`),
not a replacement for either.


## Motivation

People and agents repeatedly hunt for the same facts about a program:

- What **products** does this tree ship?
- What **command** does each product expose, and what is it for?
- How can help generators and agents discover that
  without executing binaries or parsing prose?

Most software metadata is concerned about packaging and supply chain.
These are questions about **context and usage of the application**.

| Existing surface                            | Answers                                          | Leaves open                                 |
|---------------------------------------------|--------------------------------------------------|---------------------------------------------|
| README / `--help`                           | Humans, sometimes                                | Stable schema; drift                        |
| [RFC 27](../salotz.027_env-nexps/README.md) | Env **name form**                                | What this product reads (see [RFC 031](../salotz.031_application-env/README.md)) |
| [RFC 28](../salotz.028_prjx/README.md)      | Project id, `PRJX__*` leaves                     | Multi-product usage context                 |
| [packslip](https://packslip.dev/)           | Signed artifacts, platforms, install `bin` paths | Long-lived usage context                    |
| In-code help tables                         | Runtime truth if you run the build               | Discovery without that binary               |

## Goals

- Discoverable `.appinfo/` home with a single primary manifest
- Core schema: document version, optional project labels, **products**
- **Open extensions** at file top level and under each product—each
  extension specifies its own tables
- No pyproject-style `[tool.*]` dumping ground; tools that need private
  config use **their own files**
- Clear boundaries with packslip and PRJX

## Non-goals

- Signed releases, digests, archive layout (packslip)
- Mandating every repo ship the file
- Third-party tool configs (linters, CI YAML, editors)
- Environment-variable registries (see [RFC 031](../salotz.031_application-env/README.md))
- A mandatory shared vocabulary for unprefixed controls (`DEBUG`,
  `NO_COLOR`, ...).

## Design principles

1. **Usage context**, not project operations and not release packaging.
2. **Static TOML** — parse without executing the product.
3. **Core small; extend by adding named tables** — not by a `tool` sandbox.
4. **Products are first-class**; one project may ship many.
5. **Prose over schema** — structure maps and a few flags that pay for
   themselves; put the rest in descriptions. Humans and LLMs are primary
   readers; do not over-schematize.

## Path and filename

```text
${PROJECT_ROOT}/.appinfo/meta.toml
```

| Piece     | Choice      |
|-----------|-------------|
| Directory | `.appinfo/` |
| File      | `meta.toml` |

Additional files under `.appinfo/` are allowed later;
**this** RFC only defines the `.appinfo/` directory and requires `meta.toml` when the convention is adopted.

**Project root** is the tree that owns the products described.
Monorepos may use one root file and/or per-package `.appinfo/` directories.

### Why not other homes?

| Rejected | Reason |
|----------|--------|
| Root singleton files | LICENSE-style pollution of the project root |
| `.config/…` | Reserved for project / working-tree config (PRJX) |
| `.meta/` | Vague; confuses config vs metadata; crowded by Unity `*.meta` and unused “dotmeta” tool-config ideas |
| `application-info.toml` | Redundant with `.appinfo/` |
| `products.toml` alone | File also holds shared extensions and project labels |

## Relationship to packslip

[packslip](https://packslip.dev/) describes **signed release / install**
metadata (artifacts, digests, platforms, archive-relative `bin` paths).
Application info describes **stable usage context** in the source tree
(logical product names, commands, prose, extensions).

| Application info | packslip |
|------------------|----------|
| Source tree; long-lived usage | Per-release signed install metadata |
| Logical `command` + product prose | Artifact paths, digests, os/arch |
| Ordinary VCS trust | Sigstore / identity |

They complement; neither replaces the other. An optional packslip
resource pointing at application info is left open.

## Relationship to PRJX

Keep **`.config/_project-meta.toml`** for project management (namespace/name
for replicas, `[project.env-vars]` → `PRJX__*`, local merge). Do **not**
register product prefixes under `[project.env-vars]`.

| `_project-meta.toml` | `meta.toml` |
|----------------------|-------------|
| Checkout / project tooling identity | Products users run |
| `PRJX__*` project-local leaves | Product usage context (and extensions such as env in RFC 031) |
| Replica / layout hooks | Commands, summaries, usage extensions |

## Config file rules (normative)

### Document

- Encoding: UTF-8
- Format: TOML
- Path: `.appinfo/meta.toml` (see above)

### Header

```toml
version = "v0"
```

| Key       | Required   | Meaning                                                            |
|-----------|------------|--------------------------------------------------------------------|
| `version` | **SHOULD** | Document schema version for this RFC family. This draft is `"v0"`. |

### Extension rule

1. **Core** keys and tables are those defined in this RFC under
   [Core schema](#core-schema).
2. **Extensions** may add:
   - **top-level** tables (e.g. `[env]`, `[logging]`, `[signals]`), and/or
   - tables **under a product** (e.g. `[products.foo.env]`, `[products.foo.logging]`),
   - according to whatever RFC or convention defines that extension.
3. Each extension **defines its own** shape, required keys, and whether it
   appears at top level, per product, or both.
4. Implementations that only implement core **MUST ignore** unknown keys and
   unknown tables (forward compatibility).
5. Extensions **SHOULD** avoid claiming bare names that this RFC may need
   later for core; when in doubt, use a distinctive table name.
6. Experimental additions **SHOULD** use a clear prefix (e.g. `x-` in the
   table name) until standardized.

For an example of extension see the application environment registry in 
[RFC 031](../salotz.031_application-env/README.md).

### Core schema

#### `[project]` (optional)

Tree-level labels for the repository or package tree as a whole.

| Key       | Required | Type   | Meaning                 |
|-----------|----------|--------|-------------------------|
| `name`    | optional | string | Short project/tree name |
| `summary` | optional | string | One-line description    |
| `uri`     | optional | string | Canonical URI           |

```toml
[project]
name = "wumpus"
```

#### `[products.<product-id>]`

One table per **product**. `<product-id>` is a stable TOML key
(recommended: lowercase ASCII, digits, hyphens).

| Key           | Required   | Type   | Meaning                                                    |
|---------------|------------|--------|------------------------------------------------------------|
| `name`        | **SHOULD** | string | Human display name                                         |
| `command`     | **SHOULD** | string | Primary executable name as typed on PATH (no archive path) |
| `summary`     | **SHOULD** | string | One-line description                                       |
| `description` | optional   | string | Longer prose                                               |
| `uri`         | optional   | string | Product docs/homepage                                      |

```toml
[products.wumpus-cli]
name = "wumpus CLI"
command = "wumpus"
summary = "CLI client for wumpus"

[products.wumpus-api]
name = "wumpus API server"
command = "wumpus-api"
summary = "HTTP API server for wumpus"
```

`command` is the logical program name, not `bin/linux/amd64/...`.

Multiple commands per product are left to an extension or a later revision (e.g.
a nested table).
Core is one primary `command` per product.

### Full example (canonical)

```toml
version = "v0"

[project] # optional tree-level labels
name = "wumpus"
summary = "Wumpus client and API tooling"

[products.wumpus-cli]
name = "wumpus CLI"
command = "wumpus"
summary = "CLI client for wumpus"

[products.wumpus-api]
name = "wumpus API server"
command = "wumpus-api"
summary = "HTTP API server for wumpus"
```

Extensions (for example `[env]` from RFC 031) may appear in the same file;
core-only consumers ignore them.

## Open questions

1. Multiple commands per product in core vs extension?
2. JSON Schema / typify for consumers?

## Revision notes

- **v0 (draft):** `.appinfo/meta.toml`; top-level `version`; `[project]`;
  `[products.*]` with `command`; open extensions without `[tool.*]`;
  packslip/PRJX boundaries. Environment tables deferred to RFC 031.
