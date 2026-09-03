# PRJX: Project Layout and Specification

- nexp :: `salotz.028_prjx`
- long name :: PRJX: Project Layout and Specification
- executive summary :: Extends project-local layout conventions beyond the PRJ Base Directory Spec under the name PRJX ("Project Spec Extended"). Defines project-root discovery (`PRJX_ROOT` / `.prjx-root`), portable vs host-local directories (`.config` / `.local`), fully qualified project and replica names, project IDs, XDG/XDGX integration under a `prjx/` namespace, and project-local environment variables prefixed `PRJX__`.

This RFC builds on the [PRJ Base Directory
Specification](https://github.com/numtide/prj-spec) and [RFC 27](../salotz.027_env-nexps/README.md) directly and takes
patterns from [RFC 24](../salotz.024_extended_xdg_base_directory/README.md).

In short we call this the PRJX, which roughly corresponds to something like "Project Spec Extended".

Quick Links:

- [Reference](./reference.md)
- [Glossary](./glossary.md)
- [Example (`wumpus`)](./wumpus/)

## Relationship to PRJ Spec

Originally this RFC was intended to be compatible with the [PRJ
Spec](https://github.com/numtide/prj-spec/tree/main).

However, the PRJ was never widely adopted and there is little actual
tooling (if any) that would benefit from this compatibility, while
adding complexity and some confusion to the interfaces in this RFC.

So to maintain consistency within this project we do not support the
PRJ directly. However, at many locations there is a direct and obvious
translation of variable names etc. if compatibility was desired.

See the [summary](./prj-spec-summary.md) for a summary of PRJ spec itself.

## Concepts

### Basic Project-ology

A **project** is considered a particular sub-tree of directories on a host machine.

Minimally this is the definition. In practice a project can have more
semantic meaning based on the context. Primarily it is the actual
piece of work that an operator is working on that is distinct both
from other projects and the files and directories on the host machine
not directly part of the work product.

A project then has a **project root** which is the absolute directory
path to the project sub-tree.

Projects often are organized on hosts in a particular way to keep them
organized or apply host policies and automation across them more
easily, but in principle the path up to the project root is completely
arbitrary to the project.

Projects should be organized such that they never make reference to
paths before the project root (the **project host path**).

To be specific, let's say we have a project with the **project name**
'wumpus'. The 'wumpus' project is at the following directory on the host: `/home/me/projects/wumpus`.

The "project host path" is then `/home/me/projects` and the project root path is `/home/me/projects/wumpus`.

The root path need not be the project name. It can also be: `/home/me/projects/wumpus__copy`

And there can be multiple replicas of it e.g.:

- `/home/me/projects/wumpus`
- `/home/me/projects/wumpus__copy`
- `/mnt/drive/projects/wumpus`

For instance worktrees with different git branches checked out.

In addition to the simple "project name" from before projects should
have a **fully qualified project name** (FQ Name) that can namespace projects as
well.

For instance you may have a project named "wumpus" already in your
personal work and then at work a coworker also names a project "wumpus".

If they coexist on your host machine you can separate them by file
directories (e.g. `/home/me/work` and `/home/me/personal`).

However, not all host resources are namespaced (e.g. running
containers and processes).

Thus each copy of a project that can use host global non-namespaced
resources must provide a mechanism for uniquely identifying and
disambiguating itself.

Thus a fully qualified project name for each might be `acme.wumpus`
for the work project and `me.wumpus` for the personal project.

In practice you will work on projects that don't provide namespacing
as well so we advise to create your own unique personal namespace for
FQ project names.

Expression of FQ names to different systems will vary. Each has
constraints and requirements on names and so we don't specify this in
this spec. The important thing is that there is a clear hierarchy of
namespaces that can be reused across those systems.

For instance if you are building and registering container images
locally for each project they would be `me.wumpus` and `acme.wumpus`
(using [RFC 4](../salotz.004_nexps.md) convention). If you are setting up a preview
environment the Kubernetes resources should each be in their own
namespaces like `me` and `acme`. And so on.

In addition to FQ project names you must distinguish between **project replicas**.

Project replicas are duplicates of the project in the same host. They
may be the same (copies) but they also may diverge in
content. Logically, they are the same project under different states.

Commonly, these are git worktrees checked out to different
branches. For instance you might have `main` and `bugfix-1` as the
directories:

- `/home/me/acme/wumpus__main`
- `/home/me/acme/wumpus__bugfix-1`

Each replica has a **replica distinguisher** which in combination with the FQ project name gives you the **fully qualified project replica name**.

For git worktrees the natural replica distinguisher is the branch
name, as this is guaranteed to be at least locally unique.

So the FQ replica names would be (using [RFC 4](../salotz.004_nexps.md) nexp notation):

- `acme.wumpus.main`
- `acme.wumpus.bugfix-1`


## Mechanisms

### Environment Variables

Some general considerations that all defined environment variables in this specification should follow.

Firstly, naming conventions should follow [RFC 27](../salotz.027_env-nexps/README.md).

Secondly, all names use the namespace `PRJX`, e.g. `PRJX_SCRATCH_HOME`.

Third, project specific environment variables use the prefix `PRJX__`. See [Project local environment variables](#project-local-environment-variables).

### Identifying Project Roots

As an operator you may understand that a project root is at the
following path: `/home/me/projects/wumpus`.

However, to software tools this is not obvious and must be
communicated directly or inferred via a set of rules and current
state.

The most common approach is to leverage common sentinel file/directory
markers that appear directly as a child of the project root, like
`.git` directories. Then a piece of software can determine if either
the current directory or a particular path is in a project (and which
project) by walking up the directory tree until it either hits the
host root `/` or a project root (directory with a `.git` folder in
it).

This works but is not generic over different kinds of projects that
might not use git or actually work over multiple git repositories.

In this proposal we specify an agnostic mechanism for identifying
projects similar to the common `.git` detection and additionally
overrides via environment variables.

Note that this is only concerned with identifying the true highest
root of a project. In large monorepo projects there may be numerous
other sub-project roots you want to identify to which this
specification is not concerned.

---


In order of precedence the following mechanisms can be used to
identify the project root:

1. `PRJX_ROOT` environment variable with absolute path.
2. Upwards search for closest sentinel file `.prjx-root`


If `PRJX_ROOT` is unset, set but empty, or is not a valid absolute path
then it should be ignored.

The `.prjx-root` file should be empty and all contents should be ignored.

Only the first `.prjx-root` file found walking upward from the starting
directory is recognized.

**Nested sentinels are not supported.** If a tree contains more than one
`.prjx-root` (for example a monorepo sub-tree that also has a marker),
tools still resolve a single root: the closest match when searching
upward, or `PRJX_ROOT` when set. Deeper markers are not treated as
nested project scopes; behavior is as if nesting did not exist.

In this document we refer to the project root as simply the
environment variable for simplicity,
e.g. `${PRJX_ROOT}/something_else`. Even if the root is discovered via
the sentinel file.

It is a possibility that the `PRJX_ROOT` is set after an initial
discovery of the `.prjx-root` to avoid expensive file system searches
for the root file, but not required behavior.

A project root is required. If there is no project root there is no project.

### Project Local Directories

Similar to the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir/latest/), [PRJ Spec](https://github.com/numtide/prj-spec), and [RFC 24](../salotz.024_extended_xdg_base_directory/README.md) this RFC defines
some top-level directories within a project.

These are:

- **config** (i.e. `.config`)
- **local** (i.e. `.local`)

#### Project config directory

The config directory defaults to `${PRJX_ROOT}/.config`.

It can be overridden by setting the environment variable
`PRJX_CONFIG_HOME`, which must be an absolute path.

The project config directory is used both for [project metadata](#project-metadata) as
well as being available for any project tooling to use if it supports
alternative locations in a repository.

The config directory is meant to be tracked with the rest of the
repository in remotes and does not contain host specific
configuration.

I.e. this is not gitignored.

#### Local directory

The local directory defaults to `${PRJX_ROOT}/.local`.

It can be overridden by setting the environment variable
`PRJX_LOCAL_CONFIG_HOME`, which must be an absolute path.

The local directory is a special directory that contains host-specific data.

As such it should not be tracked with the rest of the repository in remotes.

I.e. it should be gitignored.

The local directory can be used as the operator sees fit. However,
this RFC reserves some specific directories for specific use cases. See [Project host local directories](#project-host-local-directories).

### Project metadata

Under the `PRJX_CONFIG_HOME` directory developers are free to put their
own configuration data as they see fit. However, this RFC reserves the
file name `_project-meta.toml` to record portable project metadata.

Here we document the sections and information in this file.

#### Project name

As discussed in [Basic Project-ology](#basic-project-ology) there are a couple issues
surrounding the naming and unique identification of projects.

In the `_project-meta.toml` you can specify the project name and
namespace that would make up the fully-qualified project name:

```toml
[project]
name = "wumpus"
namespace = "acme"
```

This can be used to construct the FQ-name "acme.wumpus".

You can add additional parts to the namespace if you want to group
them further e.g.:

```toml
[project]
name = "wumpus"
namespace = "acme.engineering"
```

### Project host local directories

All host local data is under the local directory
(`${PRJX_LOCAL_CONFIG_HOME}`, default `${PRJX_ROOT}/.local`).

#### Host local config

You can override and add configuration that is host and replica
specific with the file `${PRJX_LOCAL_CONFIG_HOME}/_config.toml`
(default `.local/_config.toml`).

For instance in a particular replica you can hard code the replica
distinguisher with the following section:

```toml
[replica]
distinguisher = "test-bed"
```

You can override any of the sections in the
`.config/_project-meta.toml` file as well:

```toml
[project]

name = "wumpus-other"
namespace = "work"
```

**Merge rules:** host local `_config.toml` is **deep-merged** onto
portable `_project-meta.toml`. Nested tables are merged key-by-key;
values in the local file win on conflict. The local file does not
replace the portable file wholesale.

Every setting defined in `_project-meta.toml` is overridable this way,
including `[project]`, `[project.env-vars]`, and any future sections.
Omitted keys keep their portable values.

Additional configuration options are documented in the relevant sections below.

### Project ID

The **project ID** is a host-specific (and potentially dynamic and tool specific)
designation for a particular project replica. It is meant to uniquely
identify a project replica on a host.

In order of precedence the project ID is determined by:

1. The environment variable `PRJX_ID`
2. The value `replica.id` in `${PRJX_LOCAL_CONFIG_HOME}/_config.toml`
3. Combination of values from `replica.distinguisher` (from local config) and `project.name` and `project.namespace` (from merged project metadata)
4. Tool determined dynamically (e.g. git branch name)

Following the [PRJ Spec](https://github.com/numtide/prj-spec) the value must pass the regular expression `^[a-zA-Z0-9_-]{1,32}$`.

We recommend setting the project ID as
`{project.namespace}_{project.name}_{replica.distinguisher}` from the project metadata,
replacing `.` with `_` but otherwise following [nexp RFC 4](../salotz.004_nexps.md)
conventions.

If this is too long tools can follow the Kubernetes conventions of
truncation of the name and adding some random UUID to the end,
e.g. `too-long-namespace_my-nam-1ndfa2`.

Where `1ndfa2` was added by the tool automatically.

The `PRJX_ID` should be set when you need global resources (e.g. [XDG integration](#xdg-and-xdgx-integration)) in the
project, but is otherwise not required.

Note that it is up to the tool implementing the `PRJX_ID` to figure out
what the `replica.distinguisher` is when none is configured. Typically,
this is something like a git branch name, but also see [host local
configuration](#project-host-local-directories) for another option.

### XDG and XDGX integration

In addition to the project local directories this specification also
provides for utilizing the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir/latest/) and [XDGX (RFC 24)](../salotz.024_extended_xdg_base_directory/README.md) standards in
an organized manner.

This RFC provides a consistent subfolder for XDG style directories as
`prjx` under which tools place per-project data.

For each XDG / XDGX kind below, the **PRJX home** is the directory that
contains the `prjx` tree (or is that tree after override). Environment
variables override that PRJX home — that is, the folder corresponding to
defaults like `~/.cache/prjx` — **not** a single dynamic
`.../prjx/${PRJX_ID}` leaf. Leaves under the PRJX home remain tool- and
ID-dependent.

| Type        | Default PRJX home   | Env Var Override        | Spec |
|-------------|---------------------|-------------------------|------|
| host config | `~/.config/prjx`    | `PRJX_HOST_CONFIG_HOME` | XDG  |
| cache       | `~/.cache/prjx`     | `PRJX_CACHE_HOME`       | XDG  |
| share       | `~/.local/share/prjx` | `PRJX_DATA_HOME`      | XDG  |
| tmp         | `~/.local/tmp/prjx` | `PRJX_TMP_HOME`         | XDGX |
| scratch     | `~/.local/scratch/prjx` | `PRJX_SCRATCH_HOME` | XDGX |
| var         | `~/.local/var/prjx` | `PRJX_VAR_HOME`         | XDGX |

Under a PRJX home, tools choose subdirectory names. Common patterns:

- **Replica-scoped** leaf using `PRJX_ID`, e.g.
  `${PRJX_CACHE_HOME}/acme_wumpus_test-bed` (when `PRJX_CACHE_HOME`
  defaults to `~/.cache/prjx`).
- **Project-scoped** leaf using the FQ project name encoded as a
  filesystem-safe `namespace_name` (dots to underscores), **without**
  the replica distinguisher, e.g. `${PRJX_CACHE_HOME}/acme_wumpus` for
  data shared among all replicas of `acme.wumpus`.

`PRJX_ID` is required only when using replica-scoped leaves. Project-scoped
leaves need only enough metadata to form `namespace_name`.

For example with defaults:

- `~/.cache/prjx/acme_wumpus` — caches shared among all replicas
- `~/.cache/prjx/acme_wumpus_test-bed` — caches for a specific replica

Note that "host config" here is distinct from portable project
configuration in `${PRJX_CONFIG_HOME}` (default `${PRJX_ROOT}/.config`).

All directory *kinds* retain their meanings from their respective XDG /
XDGX specs; only the PRJX namespacing under them is added here.

### Project local environment variables

Projects often define and use their own environment variables to control behaviors of tooling.

These might be secrets, paths to host local resources, cloud project names, etc.

Projects should follow a naming schema which prefixes them with
`PRJX__` to keep these variables separate from other tools and host
local environment variables that may conflict.

This prefix also makes them easy to search through:

```console
$ env | grep PRJX__
PRJX__ENV_NAME=acme-prod
PRJX__DATA_PATH=/mnt/data/files
```

Furthermore, all environment variable leaf names should be specified
as part of the `.config/_project-meta.toml`. Each variable is declared
in the `project.env-vars` section. Values correspond to the groups
(comma separated) that each variable is a part of. An example:

```toml
[project.env-vars]

OP_SERVICE_ACCOUNT_TOKEN = "secrets"
PULUMI_ACCESS_TOKEN = "secrets,infra"
ENV_NAME = "integration-testing"
DATA_PATH = "functional-testing"
```

From this we can see the `OP_SERVICE_ACCOUNT_TOKEN` and
`PULUMI_ACCESS_TOKEN` are part of the `secrets` group and
`PULUMI_ACCESS_TOKEN` is also part of the `infra` grouping.

**Groups are normative for tools**, not documentation-only. A tool that
understands a group name should treat membership as the contract for
which variables to load or require for that group. The meaning of each
group name is defined by the tools (or project conventions) that
interpret it.

Typically not all environment variables are needed for all tasks you
may be performing in a project and some may be reserved only for
certain operator roles (like admins). Groups provide a way for tools
and operators to select the subset needed for a role or task.

You do not need to specify groups; instead you can use special markers:

| Marker | Meaning |
|--------|---------|
| `""` (empty string) | Default group |
| `"-"` | Required environment variable |
| `"*"` | Optional variable that does not belong to a named group |
| `"name"` or `"a,b"` | Member of the named group(s). **Assumed optional outside** any tool context that is actively interpreting those groups |

So if you don't want to come up with group tags for each variable you
can start with making them all optional:

```toml
[project.env-vars]

OP_SERVICE_ACCOUNT_TOKEN = "*"
PULUMI_ACCESS_TOKEN = "*"
ENV_NAME = "*"
DATA_PATH = "*"
```

Each variable defined in the TOML table corresponds to the `PRJX__`
prefixed environment variable in an actual process, e.g. the above
table would provide in a shell:

```console
$ env | grep PRJX__
PRJX__OP_SERVICE_ACCOUNT_TOKEN=...
PRJX__PULUMI_ACCESS_TOKEN=...
PRJX__ENV_NAME=...
PRJX__DATA_PATH=...
```

As with other metadata, `[project.env-vars]` may be extended or changed
in `${PRJX_LOCAL_CONFIG_HOME}/_config.toml` via deep merge.

---

Defining all environment variables is not required but is highly
recommended as it provides a single point of reference for new
contributors about which environment variables are expected in this
project.

Future extensions may be providing more metadata on each environment variable such as:

- help string
- tool managed or user/host managed

For example a tool like `fnox` may manage all the secrets and be
declared in `fnox.toml` but others may need to be manually set by
operators in their local configuration.
