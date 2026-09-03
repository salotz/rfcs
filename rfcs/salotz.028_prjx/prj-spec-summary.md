### Concepts

As a review the PRJ Spec defines the following concepts:

#### Project Root

Directory that is the "root" of the project. Sets a bounded scope over
what is considered the "project", anything outside of the project root
is not considered part of the project.

This is a bit of a tautological explanation but it is very simple. It's a boundary between directory levels where below has some meaning and above is excluded.

In practice, this is a "repository" managed by something like a version control system like git.

#### Config Home

A directory within the project root which contains configuration data
*about* the project but isn't directly project content.

#### Project ID

A unique ID assigned to a project to identify it on a host machine.

Folder names are not unique, and full absolute paths have path
dependence (e.g. it doesn't matter if its relative to
`/home/me/project` or `/mnt/drive/project`).

Unclear how this is assigned in practice.

According to the spec you can specify a `$PRJ_CONFIG_HOME/prj_id` file
to set the ID.

However, it is unclear how this makes it unique on a host machine that
could have multiple versions of it checked out.

#### Cache Home

A project local directory for caching data.

### Environment Variables

It also specifies the following environment variables:

#### `PRJ_ROOT`

An absolute path to the project root. There is no other way to set
this other than through specific tools figuring this out using their
own mechanism.

#### `PRJ_CONFIG_HOME`

Path (absolute or relative to `PRJ_ROOT` is unclear) to the config home in a project.

If not set then it defaults to `${PRJ_ROOT}/.config`.

#### `PRJ_ID`

The project ID in an environment variable.

If `PRJ_CONFIG_HOME` is set and the file `prj_id` exists in `PRJ_CONFIG_HOME` then it should be used.

#### `PRJ_CACHE_HOME`

Absolute path.

If `PRJ_ID` is set tools must set this to `${XDG_CACHE_HOME}/prj/${PRJ_ID}`.

Otherwise, `${PRJ_ROOT}/.cache`.
