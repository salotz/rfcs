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

### 014: Project & Maintenance Intentions for OSS {#rfc-014}

- nexp :: `salotz.014_project-intent`
- status :: DRAFT

Proposal: [rfcs/salotz.014_project-intent.md](rfcs/salotz.014_project-intent.md)

Executive Summary:

> A proposal for a best practice that includes a clear statement of
> intent on open source projects (lifecycle phase + maintenance intent)
> so consumers better understand the current state and intentions of
> developers. Includes suggested vocabulary for common phases.

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
