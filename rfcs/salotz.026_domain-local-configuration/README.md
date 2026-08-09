# Domain Local Configuration

- nexp :: `salotz.026_domain-local-configuration`
- long name :: Domain Local Configuration
- executive summary :: Provides a standard mechanism for host-local, domain-scoped configuration using a `.local` directory alongside project trees (e.g. `~/tree/<domain>/...`). Enables sharing configuration across git worktrees or sub-projects without duplication. Complements tools like direnv for managing per-directory overrides that are intentionally not committed to remote repositories.

This RFC builds on concepts in [RFC 25](../salotz.025_host-domain-organization), but is not strictly dependent on it.

Primarily the concept of a "domain" of work on a host.

This RFC provides a standard mechanism for configuration of a directory of projects or domains.

For instance if you organize your software projects in a directory `~/tree/personal/devel` you may want to have host local configuration shared between each individual project.

## A motivating Example

Many software projects use a `.envrc.local` file and a system like [direnv](https://direnv.net/) for managing common configuration shared between operators on the project. These files are part of the remote content and cannot (in all cases) handle all local host preferences and configuration.

These systems also typically have a mechanism for providing local configuration. For instance a `.envrc.local` file which is intentionally ignored from being shared in the remote content.

This is useful, but often these per-repo configurations reuse common configuration that is applicable either host-wide, domain-wide, or directory-wide. Duplicating these configurations across all repo sub-directories is tedious and error prone.

A common pattern (especially in agentic code) is to create multiple git worktrees to work on features in parallel. In which case you need to duplicate these local configuration files each time.

This RFC aids in this kind of example, and likely others.

## Specification

For the sake of description assume we are working in a directory called `~/projects`, and we have projects called `widgets` and `thingies`.

In the `~/projects` directory there will be a standard `.local` directory (`~/projects/.local`). In that directory you can provide configuration scoped to the `~/projects` directory at the top level and project specific with the same names as the "primary" project folder.

For instance you can have `widgets` specific configuration in `~/projects/widgets`. If you then create worktrees for `widgets` (say `widgets__feat-a` and `widgets__feat-b`) they would all share configuration in the `~/projects/widgets` directory.

## direnv example

Here is an example using the `direnv` configuration previously mentioned. Sticking with the same repos mentioned above and the git worktree use case.

The remote `.envrc` file would look like this:

```sh
# Do the shared configuration. Should not reference host paths.
export APPTAINER_CACHE_PATH="/var/cache/widget-cache"

# load the local configuration if it exists
source_env_if_exists .envrc.local
```

Then the `.envrc.local` file:

```sh
source ../.local/widgets/.envrc.local
```

This references a shared configuration in the directory shared local configuration.

This might for instance configure:

```sh
export APPTAINER_CACHE_PATH="~/.local/cache/widget-cache"
```

Overriding the previously set path.


