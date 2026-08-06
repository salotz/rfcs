# Local Agent Context

- nexp :: `salotz.023_local-agent-context`
- long name :: Local Agent Context
- executive summary :: Provides a standard for specifying local AI agent context injection. Includes standardization of standard linux style home directories and mechanisms for local overrides of git repo context.

## Goals

The goal of this RFC is to provide a common structure for defining local context to provide to coding agents.

By "local" this document means context that is derived from the current host computer and not from git repositories or otherwise remote fetched content.

For instance agents may act to install software or write configuration. You may have preferences for how this occurs that the agent would otherwise not know. This specification provides a means for communicating that to agents.

Additionally, if you have remote content (git repos) that have policy and context you may want to augment that with local preferences (e.g. installation locations, additional temporary working directories, etc.).

## Configuration Directories

The primary locations for local "home" configuration are in order of precedence and preference:

- `$XDG_CONFIG_HOME/agents` (i.e. `~/.config/agents`) or equivalents on non-linux systems
- `~/.agents`

You should not use a bare `~/AGENTS.md`.

Additional `.agents/` directories can be placed at any level of directories and take precedence the closer to the current working remote directories.

This RFC is compatible with RFC 22, which mandates a similar `.agents` directory in remote sourced directories. To support local context in remote directories use the `.agents.local.md` file and/or the `.agents.local` directory.

Because of the challenges of indexing arbitrary depths of context directories this specification only requires explicit discovery of the "home" context and context directories one level above the current project.

Implementations and users are encouraged then to explicitly chain context references upward in the directory hierarchy.

For example on a machine a user might configure the home directory with:

```
~/.config/agents
├── configuration.md
├── installations.md
└── shell.md
```

Where they set preferences for configuration, installing new packages, and shell preferences.

This should be referenced by your in repo context referring to this RFC.

Additionally for a project at the location `~/dev/projects/my-project`
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
