# Request For Comments (RFCs)

These are a collection of semi-standards for reference by people and agents accessible in a public manner for generic reference in projects.

The existence of an RFC does not mean that you need to adopt one or all of them and is just a description of a mini-standard that you may opt into.

They are numbered and titled and each has a brief executive summary description in this file and a fuller description in single files or directories (if supporting assets are necessary) under [rfcs](rfcs).

See the following RFCs for descriptions of standards relative to this
repository itself:

- [Name Expressions (nexps)](#rfc-004)
- [RFC Specifications](#rfc-003)

## Proposals

### 002: Semantic Changelog {#rfc-002}

- nexp :: `salotz.002_semantic-changelog`
- status :: DRAFT

Proposal: [rfcs/salotz.002_semantic-changelog/README.md](rfcs/salotz.002_semantic-changelog/README.md)

Executive Summary:

> A general-purpose format for semantic changelogs and git commit
> messages. Defines "Growth", "Breakage", and "Regression" change
> categories with specific sub-keywords, version numbering (B.R.G),
> and structured metadata via git trailers. Includes recommendations
> for both human-readable changelogs and machine-readable commit
> messages.

### 003: RFC Specifications {#rfc-003}

- nexp :: `salotz.003_rfc-specs`
- status :: DRAFT

Proposal: [rfcs/salotz.003_rfc-specs.md](rfcs/salotz.003_rfc-specs.md)

Executive Summary:

> Specifications for the required information for an RFC (nexp, long
> name, executive summary) and how to name/format proposals. This is
> the meta-specification for the RFC process itself.

### 004: Name Expressions (nexps) {#rfc-004}

- nexp :: `salotz.004_nexps`
- status :: DRAFT

Proposal: [rfcs/salotz.004_nexps.md](rfcs/salotz.004_nexps.md)

Executive Summary:

> A proposal that defines how to name digital document entities using
> a namespaced expression format (e.g. `format:namespace.field-1_field-2`).
> Uses dots for namespace separation and underscores/hyphens for fields.

### 006: Codetags {#rfc-006}

- nexp :: `salotz.006_codetags`
- status :: DRAFT

Proposal: [rfcs/salotz.006_codetags/README.md](rfcs/salotz.006_codetags/README.md)

Executive Summary:

> Tags that are added in comments to code that add semantic meaning to
> otherwise freeform comments, making them searchable by machine and
> available to tooling. Defines a standard set of codetags (TODO,
> FIXME, etc.) and categories (tasks, warnings, growth, etc.).

### 012: Errors as Information {#rfc-012}

- nexp :: `012_information-errors`
- status :: DRAFT

Proposal: [rfcs/salotz.012_information-errors.md](rfcs/salotz.012_information-errors.md)

Executive Summary:

> Errors in information systems (e.g. event logs) should provide
> actionable information rather than just operational severity
> categories. Maps error types to next actions for handlers.
> Inspired by Stuart Halloway.

### 014: Project Declarations {#rfc-014}

- nexp :: `salotz.014_project-declarations`
- status :: DRAFT

Proposal: [rfcs/salotz.014_project-declarations.md](rfcs/salotz.014_project-declarations.md)

Executive Summary:

> A best practice for publishing short, structured project declarations
> so consumers and contributors can judge fitness, risk, and expected
> quality at a glance. Topics include lifecycle phase, maintenance
> intent, authorship method (e.g. AI-assisted or AI-authored),
> contribution stance, and support. Includes suggested vocabularies and a
> README table convention.

### 016: Nearly Trivial Plaintext Formats {#rfc-016}

- nexp :: `salotz.016_trivial-plaintext-formats`
- status :: DRAFT

Proposal: [rfcs/salotz.016_trivial-plaintext-formats.md](rfcs/salotz.016_trivial-plaintext-formats.md)

Executive Summary:

> A small collection of nearly trivial plaintext formats along with file
> extensions. Includes a line-based list format (.list) and a single-string
> format (.str).

### 017: Bunker: User De-Militarized Zone {#rfc-017}

- nexp :: `salotz.017_bunker`
- status :: DRAFT

Proposal: [rfcs/salotz.017_bunker.md](rfcs/salotz.017_bunker.md)

Executive Summary:

> Introduces the concept of a `bunker` directory for user-only data in
> $HOME (e.g. `.$USER` or `.$USER.d`). Provides a safe space for
> customization and configuration that will not be touched by other
> programs.

### 020: In-Repo Issue Tracking Schema {#rfc-020}

- nexp :: `salotz.020_repo-issue-tracker`
- status :: DRAFT

Proposal: [rfcs/salotz.020_repo-issue-tracker.md](rfcs/salotz.020_repo-issue-tracker.md)

Executive Summary:

> Schema for including issue tracking sources with a project, without
> having to rely on outside forges.

### 021: Git Commit Message Behaviors {#rfc-021}

- nexp :: `salotz.021_git-commit-messages`
- status :: DRAFT

Proposal: [rfcs/salotz.021_git-commit-messages/README.md](rfcs/salotz.021_git-commit-messages/README.md)

Executive Summary:

> Standard behaviors and markup for git commit messages, including
> `wip!` prefix for work-in-progress commits, issue reference trailers
> (Completes/Progresses/References) with namespaced values, and
> project domains.


### 022: AI Coding Repository Structures {#rfc-022}

- nexp :: `salotz.022_ai-coding-structure`
- status :: DRAFT

Proposal: [rfcs/salotz.022_ai-coding-structure/README.md](rfcs/salotz.022_ai-coding-structure/README.md)

Executive Summary:

> Provides a standard for structuring repositories to make them useful
> for AI-enhanced coding. Includes standard naming and schemas for
> folders, filenames, and content of those files. The goal is to
> provide useful, incremental context for LLMs that are built up for a
> specific coding repository. Companion to RFC 23 for host-local
> context and overrides.

### 023: Local Agent Context {#rfc-023}

- nexp :: `salotz.023_local-agent-context`
- status :: DRAFT

Proposal: [rfcs/salotz.023_local-agent-context/README.md](rfcs/salotz.023_local-agent-context/README.md)

Executive Summary:

> Provides a standard for specifying local AI agent context injection.
> Includes standardization of Linux-style home directories, bootloading
> guidance for tools, `xagents` placement under XDG/XDGX paths for
> agent-derived resources, and mechanisms for local overrides of git
> repo context (`.agents.local`).


### 024: Extended XDG Base Directory Specification {#rfc-024}

- nexp :: `salotz.024_extended_xdg_base_directory`
- status :: DRAFT

Proposal: [rfcs/salotz.024_extended_xdg_base_directory/README.md](rfcs/salotz.024_extended_xdg_base_directory/README.md)

Executive Summary:

> This RFC extends the XDG Base Directory Specification with additional user-local directories and environment variables (prefixed `XDGX_`) for common use cases not covered by the base spec. It defines `~/.local/opt` (or `XDGX_OPT_HOME`) for ad-hoc user-managed software installs, `~/.local/tmp` (`XDGX_TMP_HOME`) as a user-local temporary directory distinct from the system `/tmp`, `~/.local/scratch` (`XDGX_SCRATCH_HOME`) for ephemeral batch-process scratch space, and `~/.local/var` for variable/persistent data akin to the FHS `/var`. Includes recommendations for snapshotting, cleanup policies, and usage to improve system organization, backup strategies, and performance.

### 025: Host Domain Organization {#rfc-025}

- nexp :: `salotz.025_host-domain-organization`
- status :: DRAFT

Proposal: [rfcs/salotz.025_host-domain-organization/README.md](rfcs/salotz.025_host-domain-organization/README.md)

Executive Summary:

> Provides guidelines for organizing project work on host systems. Distinguishes local (host-only) and remote (shared/persisted, e.g. git) work. Defines scratch space, domains (e.g. personal vs work contexts), inboxes, and staging ("outbox") areas. Recommends `~/scratch` and `~/local/work` for local; `~/tree/<domain>/` (with `devel/`, `projects/`, `admin/`) for remote work organized by domain; and inbox/outbox under `~/Downloads`, `~/local/`, or domain trees.

### 026: Domain Local Configuration {#rfc-026}

- nexp :: `salotz.026_domain-local-configuration`
- status :: DRAFT

Proposal: [rfcs/salotz.026_domain-local-configuration/README.md](rfcs/salotz.026_domain-local-configuration/README.md)

Executive Summary:

> Provides a standard mechanism for host-local, domain-scoped configuration using a `.local` directory alongside project trees (e.g. `~/tree/<domain>/...`). Enables sharing configuration across git worktrees or sub-projects without duplication. Complements tools like direnv for managing per-directory overrides that are intentionally not committed to remote repositories.

### 027: Environment Variable Name Expressions {#rfc-027}

- nexp :: `salotz.027_env-nexps`
- status :: DRAFT

Proposal: [rfcs/salotz.027_env-nexps/README.md](rfcs/salotz.027_env-nexps/README.md)

Executive Summary:

> Adapts name expressions (nexps) to UNIX-style environment variable names. Defines screaming-snake-case names with single underscores separating words and double underscores (dunders) separating fields, plus conventions for leading underscores to mark user-configured vs application-internal "hidden" variables. Covers names only, not values, and is designed to coexist with shell variables in the global environment namespace.

### 028: PRJX Project Layout and Specification {#rfc-028}

- nexp :: `salotz.028_prjx`
- status :: DRAFT

Proposal: [rfcs/salotz.028_prjx/README.md](rfcs/salotz.028_prjx/README.md)

Executive Summary:

> Extends project-local layout conventions beyond the PRJ Base Directory
> Spec under the name PRJX ("Project Spec Extended"). Defines project-root
> discovery (`PRJX_ROOT` / `.prjx-root`), portable vs host-local directories
> (`.config` / `.local`), fully qualified project and replica names, project
> IDs, XDG/XDGX integration under a `prjx/` namespace, and project-local
> environment variables prefixed `PRJX__`.

### 029: Glossary Format {#rfc-029}

- nexp :: `salotz.029_glossary-format`
- status :: DRAFT

Proposal: [rfcs/salotz.029_glossary-format.md](rfcs/salotz.029_glossary-format.md)

Executive Summary:

> Defines a simple Markdown format for glossaries: a top-level `# Glossary`
> heading, one `## term` subheading per entry, short definition bodies, and
> in-document cross-links between terms. Prefer this over tables so
> definitions remain linkable. Originally specified inline in RFC 22;
> extracted here for reuse across RFCs, projects, and shared agent guidelines.

### 030: Application Info {#rfc-030}

- nexp :: `salotz.030_application-info`
- status :: DRAFT

Proposal: [rfcs/salotz.030_application-info/README.md](rfcs/salotz.030_application-info/README.md)

Executive Summary:

> Defines a static, machine- and human-readable application info document for
> software products: context and usage metadata that operators, agents, and
> tools can consume without scraping READMEs or CLI help strings. The default
> path is `.appinfo/meta.toml` at the application project root. The format is
> a small TOML core (`version`, optional `[project]`, `[products.*]`) plus an
> open extension rule: new concerns add their own top-level or per-product
> tables and define their own shape—no `[tool.*]` namespace. Environment
> variable registries are specified in RFC 031. Complementary to jdx packslip
> (signed release / supply-chain install metadata) and RFC 28 PRJX
> project-management metadata (`.config/_project-meta.toml`), not a
> replacement for either.

### 031: Application Environment Registry {#rfc-031}

- nexp :: `salotz.031_application-env`
- status :: DRAFT

Proposal: [rfcs/salotz.031_application-env/README.md](rfcs/salotz.031_application-env/README.md)

Executive Summary:

> Defines environment-variable declaration tables for RFC 030 application
> info documents (`.appinfo/meta.toml`). Products document shared and
> per-product env prefixes and variable maps (`[env]` / `[products.<id>.env]`)
> with short- and long-form entries so humans, agents, and help tooling can
> discover what a product reads without executing it. Descriptive by default;
> name form follows RFC 27. Does not own project-local `PRJX__*` leaves
> (RFC 28).

### 032: Environment Variable Value Types {#rfc-032}

- nexp :: `salotz.032_env-value-types`
- status :: DRAFT

Proposal: [rfcs/salotz.032_env-value-types/README.md](rfcs/salotz.032_env-value-types/README.md)

Executive Summary:

> Defines a small type system and value grammar for environment variable
> strings. Normative type names are `boolean`, `enum`, `string`, `null`, and
> composite `nullable-enum`. Missing means absent or empty string (not typed
> null). Each variable has a single value policy (`silent` | `warn` |
> `strict` | `required`, default `warn`) plus a default when not required.
> Covers token matching, invalid-value handling, and a documentation table
> pattern (name, type, policy, default, canonical values, aliases). Name
> form stays in RFC 027; stand-alone.
