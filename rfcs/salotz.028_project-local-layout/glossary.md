# Glossary

Terms defined by this RFC. Drawn from the main [README](./README.md).

Format: [RFC 29: Glossary Format](../salotz.029_glossary-format.md)
(`## term` subheadings with cross-links). Placement of this file as
RFC supporting material follows that RFC's informative patterns; project
design glossaries are described in
[RFC 22](../salotz.022_ai-coding-structure/README.md#glossary).

## project

A particular sub-tree of directories on a host machine representing a
distinct piece of work, separate from other projects and from host
paths that are not part of the work product.

## project root

Absolute directory path to the [project](#project) sub-tree. Discovered
via `PRJX_ROOT` or the `.prjx-root` sentinel. See [project host
path](#project-host-path).

## project host path

The path *above* the [project root](#project-root) (e.g. `/home/me/projects`
when the root is `/home/me/projects/wumpus`). Projects must not depend on
paths outside the project root.

## project name

Short name of the [project](#project) (e.g. `wumpus`), stored as
`project.name` in [project metadata](#project-metadata).

## fully qualified project name

Namespaced project identity, typically `{namespace}.{name}` (e.g.
`acme.wumpus`). Also called **FQ name**. Built from `project.namespace`
and [project name](#project-name) in [project metadata](#project-metadata).

## project replica

A duplicate of a [project](#project) on the same host (e.g. a git
worktree). May share or diverge in content; logically the same project
under different state. Distinguished by a [replica
distinguisher](#replica-distinguisher).

## replica distinguisher

Token that distinguishes one [project replica](#project-replica) from
another (e.g. a git branch name, or `replica.distinguisher` in [host
local config](#host-local-config)).

## fully qualified project replica name

[Fully qualified project name](#fully-qualified-project-name) plus
[replica distinguisher](#replica-distinguisher) (e.g.
`acme.wumpus.bugfix-1`).

## project ID

Host-specific identifier for a [project replica](#project-replica), used
for global resources such as XDG/XDGX paths under a `prjx/` namespace.
Exposed as `PRJX_ID`. Must match `^[a-zA-Z0-9_-]{1,32}$`. See the main
README for resolution precedence.

## PRJX

"Project Spec Extended" — the short name of this layout specification
and the namespace for its environment variables (`PRJX_*`, `PRJX__*`).
Nexp: `salotz.028_project-local-layout`.

## config directory

Portable project configuration under `${PRJX_ROOT}/.config` (override:
`PRJX_CONFIG_HOME`). Tracked in version control. Holds [project
metadata](#project-metadata).

## local directory

Host-specific data under `${PRJX_ROOT}/.local`. Not tracked in version
control (gitignored). Holds [host local config](#host-local-config).

## project metadata

Portable metadata in `.config/_project-meta.toml` within the [config
directory](#config-directory): [project name](#project-name), namespace,
declared [project-local environment
variables](#project-local-environment-variables), and related fields.

## host local config

Host- and replica-specific overrides in `.local/_config.toml` within the
[local directory](#local-directory). May set `replica.distinguisher`,
`replica.id`, and overrides of [project metadata](#project-metadata)
sections.

## project-local environment variables

Process environment variables prefixed `PRJX__`, declared under
`[project.env-vars]` in [project metadata](#project-metadata). Leaf
names map to `PRJX__<LEAF>`. Group tags and markers document which
variables apply to which roles or tasks.

## env-var group

Tag(s) on a declared project-local environment variable (e.g. `secrets`,
`infra`) used by tools to select subsets of variables. Special markers:
`""` (default group), `"-"` (required), `"*"` (optional, ungrouped).
