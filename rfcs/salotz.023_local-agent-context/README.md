# Local Agent Context

- nexp :: `salotz.023_local-agent-context`
- long name :: Local Agent Context
- executive summary :: Provides a standard for specifying local AI agent context injection. Includes standardization of Linux-style home directories, bootloading guidance for tools, `xagents` placement under XDG/XDGX paths for agent-derived resources, and mechanisms for local overrides of git repo context (`.agents.local`).

## Goals

The goal of this RFC is to provide a common structure for defining local context to provide to coding agents.

By "local" this document means context that is derived from the current host computer and not from git repositories or otherwise remotely fetched content.

For instance agents may install software or write configuration. You may have preferences for how this occurs that the agent would otherwise not know. This specification provides a means for communicating that to agents.

Additionally, if you have remote content (git repos) that have policy and context, you may want to augment that with local preferences (e.g. installation locations, additional temporary working directories, etc.).

This RFC is oriented towards host-wide or sub-domain context on the host, not project-specific repository layout.
For project-specific standards see
[RFC 22: AI Coding Repository Structures](../salotz.022_ai-coding-structure/README.md).

## Configuration Directories

### Directory locations and precedence

The primary locations for local "home" configuration are, in order of preference and descending precedence when closer paths apply:

- `~/<subdirs>/.agents` (directory-local context closer to the working tree)
- `$XDG_CONFIG_HOME/agents` (i.e. `~/.config/agents`) or equivalents on non-Linux systems
- `~/.agents`

You should not use a bare `~/AGENTS.md` unless it is required by your tools.

Additional `.agents/` directories can be placed at any level of the directory tree and take precedence the closer they are to the current working remote directories.

### Guidelines for bootloading context in tools

Some tools will default to or require the `~/.agents` directory for installation of resources like skills or plugins (for example Goose).
This is a welcome pattern that supports a single configuration of standard components that work across many coding agents (such as skills).

Users should not fight these tools and try to force them to install to `~/.config/agents`.
Instead, use both.
Let plugin or skill managers install to `~/.agents` as they wish, and install your operator-specific context under `~/.config/agents`.

For instance you may have a standard host-wide `AGENTS.md` that you track in your "dotfiles" repository and want available on a new host.
Prefer installing these files to `~/.config/agents` and keep them separate from tool state in `~/.agents`.

If tools automatically read `~/AGENTS.md`, `~/.agents/AGENTS.md`, or a tool-specific path (e.g. `~/.config/goose/AGENTS.md` or `~/.config/goose/.goosehints`), consider providing a link or inlining (if the tool supports it) your host-wide bootloader at `~/.config/agents/AGENTS.md`.

For example with Goose, write this to `~/.config/goose/AGENTS.md`:

```markdown
@~/.config/agents/AGENTS.md
```

This uses the somewhat common `@` inlining hint, which pastes the contents of the referenced file directly into the context loaded when reading the file (rather than requiring a tool call to read the other file).

<!-- TODO: This side note implies a separate RFC with guidelines for tool authors on where to install generic agent resources, which is otherwise not standardized. We should write a new RFC that does this. -->

As a side note, a top-level user-home folder `~/.agents` is undesirable in general; host-wide data should follow something like the XDG standards and install managed plugins and skills (e.g. goose install plugins) to `$XDG_DATA_HOME/agents` (`~/.local/share/agents`).
Alas, we cannot control the behavior of a large number of third-party tools, so the situation remains as is.
If you are writing tools that install plugins, consider using `~/.local/share/agents` instead of `~/.agents`.

### RFC 22 compatibility

This RFC is compatible with
[RFC 22](../salotz.022_ai-coding-structure/README.md), which mandates a
similar `.agents` directory in remote-sourced directories. To support
local context in remote directories, use the `.agents.local.md` file
and/or the `.agents.local/` directory.

### Only HOME is required

Because of the challenges of indexing arbitrary depths of context directories, this specification only requires explicit discovery of the "home" context and context directories one level above the current project.

Implementations and users are then encouraged to explicitly chain context references upward in the directory hierarchy.

For example, on a machine a user might configure the home directory with:

```
~/.config/agents
├── configuration.md
├── installations.md
└── shell.md
```

Where they set preferences for configuration, installing new packages, and shell preferences.

This should be referenced by your in-repo context that refers to this RFC.

Additionally, for a project at the location `~/dev/projects/my-project`
you can have the possible configuration:

```
~/dev
└── projects
    ├── .agents
    │   └── projects.md
    └── my-project
        ├── .agents
        │   └── context
        │       └── project-details.md
        ├── .agents.local.md
        └── AGENTS.md
```

### Project precedence

Precedence favors the local configuration closest to the project.
For instance, if the home context in `~/.agents/context/installation.md` recommends installing ad hoc tools into `~/opt`, but a project or directory-local context (e.g. `~/dev/projects/.agents/projects.md`) recommends installing in `~/software`, the agent should obey the `~/dev/projects/.agents/projects.md` advice.

When there are contradictions, agents should explicitly ask for feedback and make the conflict clear to the user before taking action.

## Agent-Derived Resources

A common pattern is for agents to fetch or generate additional resources on a host for use within multiple projects.

For instance an agent skill might cache repositories on the host to avoid excessive network calls. Or an agent might provide an outline of a user's host machine resources for later reference.

This is similar to classical software, which has long had standards for organizing this data. One can look at the POSIX standards for system-wide directories under `/` or the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir/latest/) as examples.

We leverage the additional level of specification for user-local layouts from the XDG Base Directory Specification extension in [RFC 24](../salotz.024_extended_xdg_base_directory/README.md).

Under RFC 24, agents should use a subdirectory in the appropriate locations with the name `xagents` (for "eXtended Agents"). This avoids using the plain word `agents`, which is ambiguous despite some efforts at standardization elsewhere.

For example you might have skills that use the cache directory like this:

```
/home/salotz/.cache/xagents
├── papers
│   ├── d5np00041f.pdf
│   ├── HSA-Runtime-1.2.pdf
│   └── mmc2.pdf
└── repos
    └── rfcs
```

Otherwise agents should utilize the meanings of the directories from the other specifications. Many of them will not be for agent actions, but for generated software.

Note that the `xagents` directories are specifically for agent-generated resources, as opposed to operator-authored resources in `AGENTS.md` and `.agents` directories.

### Motivation

The utility of such organization is:

#### Namespace Pollution

By providing sub-namespaces it limits the "pollution" of common "namespaces" like a user's `$HOME` directory with dozens or hundreds of application-specific directories (e.g. `.emacs`, `.tmux.conf`, etc.).

Pollution of common namespaces can make tool usage complex. For instance, if you wanted the disk usage of all configuration or cache directories, you would need to distinguish content directories in `$HOME` from configuration directories that hold cache data.

#### Content Indexing

Create clear expectations for where to look for specific kinds of information, which will have vastly different indexing requirements.

For instance you may want PDFs stored in a content repository under `~/.local/share` to be indexed by system-wide search, but not cached data (`~/.cache`) or operational data (`~/.local/var`).

#### Storage Needs

Different types of data have different storage needs.

For example you would want regular snapshotting of configuration directories (`~/.config`) but not of cached data (`~/.cache`).

Users should be able to easily configure filesystems to match these requirements using the standardized directories.

This is difficult or impossible if all applications use their own custom directories for this content, which can lead to system stability problems if left unconfigured.

## Template Context

Drop the following snippet into your remote repo context (per RFC 22, recommended path: `.agents/context/local-agent-context.md`) so that agents and humans can easily adhere to this standard.

```markdown
# Local Agent Context (per RFC 23)

This project uses local (host-specific) agent context.

## Discovery Order (highest precedence first)
- `~/<subdirs>/.agents` (closer to the working tree wins)
- `$XDG_CONFIG_HOME/agents` (e.g. `~/.config/agents`) or platform equivalents
- `~/.agents`

Do not rely on a bare `~/AGENTS.md` unless a tool requires it.

## Precedence
Precedence favors the local configuration closest to the project.

For example, if the home context in `~/.agents/context/installation.md` recommends installing tools into `~/opt` but a project or directory-local context (e.g. `~/dev/projects/.agents/projects.md`) recommends `~/software`, the agent must obey the closer context.

When there are contradictions, agents should explicitly ask for feedback and make it clear to the user before taking action.

## Local Overrides for Remote Repos
- Use `.agents.local.md` (single file) or `.agents.local/` (directory) next to the repo's `.agents/` or `AGENTS.md`.
- These take precedence over repo context for local preferences (install locations, temp dirs, shell prefs, etc.).

## Recommended Placement
- Home-level preferences: `~/.config/agents/{configuration,installations,shell}.md`
- Per-parent-dir: `~/dev/projects/.agents/` (applies to projects under it)
- Per-project local override: `<project>/.agents.local.md`

## Agent-Derived Resources
Use `xagents/` under XDG/XDGX locations (see RFC 24), e.g. `~/.cache/xagents`, not plain `agents/` for generated caches and similar data.

## Chaining
Explicitly reference upward context files from repo `AGENTS.md` / `.agents/context/*.md` so agents discover them.
```

