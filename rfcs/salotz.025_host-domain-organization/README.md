# Host Domain Organization

- nexp :: `salotz.025_host-domain-organization`
- long name :: Host Domain Organization
- executive summary :: Provides guidelines for organizing project work on host systems. Distinguishes local (host-only) and remote (shared/persisted, e.g. git) work. Defines scratch space, domains (e.g. personal vs work contexts), inboxes, and staging ("outbox") areas. Recommends `~/scratch` and `~/local/work` for local; `~/tree/<domain>/` (with `devel/`, `projects/`, `admin/`) for remote work organized by domain; and inbox/outbox under `~/Downloads`, `~/local/`, or domain trees.

On a host system there are numerous methods for organizing programmatic organization of files.

However, there are no guidelines on how to organize actual project work.

This RFC provides some structure of the home directory organization towards this objective.

## Concepts

Firstly we define a few categories and terms to guide this process.

### Local and Remote Work

Firstly we distinguish between local and remote work.

Local work is content created on and for only the local host. It is not intended to be shared or persisted across different hosts.

Remote work is the opposite. It is shared and persisted across hosts.

Most commonly remote work is in the form of a git repository or collections of files fetched from a remote source. Local work is simply a directory on the local host without an equivalent remote copy.

### Scratch Space

Local work has project work and scratch work.

Scratch work includes ephemeral small tests. The content created in scratch work can effectively be thrown away at any time with no harm.

Project work is somewhere in between not wanting to let it be destroyed on reboot and not important enough to be saved remotely.

### Domains

Often a specific host is used for work in different contexts. For example you might use your laptop for doing work for employment as well as your own personal work.

We call these contexts "domains".

### Inbox and Staging

During your work you will obtain and generate content and data that needs to be handled, filed, and organized.

Most commonly on a host computer you will download files from the web into a downloads folder. This is an example of an inbox.

Less commonly you may generate some files that you then need to later send to someone or move to external storage at a later point. This is called a staging directory.

## Directory Organization

### Local Work

Local scratch space should be at `~/scratch`.

Local project work is at `~/local/work`.

If you have local resources that you reuse and does not have a
standard location under `~/.cache` or `~/.local` you can use
`~/local/resources` directory. 

For example VM or OS images.

The `~/local` and `~/scratch` directories should be backed up and snapshotted with the host machine.

When migrating to a new host (i.e. moving to a new laptop) you should generate bundles with `~/local` but not `~/scratch`.


### Remote Work

Most work should be remote work. As your work should be saved over time.

Remote work should be organized by domain.

All remote work should be saved under the `~/tree` directory.

In this directory each domain should have its own subdirectory.

For example if you have the domains `personal` and `work` you would have folders `~/tree/personal` and `~/tree/work` directories.

The organization of these directories is up to the operator. Except otherwise noted in this document.

Recommendations for organizing this directory are minimal.

- `devel` directory for software projects
- `projects` for more generic non-software projects
- `admin` for meta-content relevant to the domain

### Inbox and Staging

The primary inbox should be the `~/Downloads` folder. 

If you need an additional inbox to distinguish from this common web inbox you can use either:

- `~/local/inbox`
- `~/tree/<domain>/inbox`

Where domain inboxes are useful for at least sorting incoming information by domain.

For staging or "outbox" directories there is no external standard like `~/Downloads`. So the choice of outboxes mirror the inboxes:

- `~/local/outbox`
- `~/tree/<domain>/outbox`


## Summary

Putting it altogether you will have something like this:

```
~/
├── local
│   ├── inbox
│   ├── outbox
│   ├── resources
│   └── work
├── scratch
└── tree
    ├── personal
    │   ├── admin
    │   ├── devel
    │   ├── inbox
    │   ├── outbox
    │   └── projects
    └── work
        ├── admin
        ├── devel
        ├── inbox
        ├── outbox
        └── projects
```
