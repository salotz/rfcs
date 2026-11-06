# Host Resource Store Directory Layout

- nexp :: `salotz.035_host-resource-store`
- long name :: Host Resource Store Directory Layout
- executive summary :: Defines a directory layout for host home directories for storing and organizing bulk data resources. Distinguishes a physical **store directory** on host-associated storage from a logical **resource directory** that applications use, so data from multiple mounted filesystems can be merged without rewriting application paths.

## Motivation

Like the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir/latest/) and [RFC 24](../salotz.024_extended_xdg_base_directory/README.md) (XDGX), this RFC aims to provide a standard location on a host for specific kinds of data not already covered in those standards.
Namely large sets of slowly changing data which we call **resource data**.

This kind of data is common in, for example, scientific or machine learning work.
You may have data sets of biological sequences downloaded from databases (multiple sequence alignment), model weights, and so on.
These kinds of datasets have a unique lifecycle and approach to management that differs significantly from other standards.

The closest option is the `XDG_DATA_HOME` (`~/.local/share`), however the match is not the correct one.
Data in `XDG_DATA_HOME` is tightly coupled to the applications which use it.
Often it is data generated from those applications.
It is also not typically meant to be shared with others or explicitly downloaded/loaded into that location.
Our opinion is that `XDG_DATA_HOME` is critical to the normal functioning of those applications, and as such should be included in snapshotted volumes along with the actual code, configuration etc.
At least logically, dependent on filesystems that support such backup support (like btrfs).

In comparison resource data is effectively static; changes come from upstream sources.
In this sense it is like a cache, in that you could simply redownload the data.
However, it differs from `XDG_CACHE_HOME` in a few ways as well:

1. Cached data is only for convenience and latency
2. Cached data becomes stale and can be automatically pruned
3. Cached data is *relatively* quick to rebuild
4. Cached data is organized on a per-application basis. Contracts between applications are implicit.

Resource data does not fit these characteristics:

1. Resource data is *expensive* to redownload (both in time and actual financial cost).
2. Resource data is usually required or optional for applications or specific features of applications.
3. Resource data is typically (but not always) managed with a separate set of applications than the ones using it (typically ad hoc or manually).
4. Resource data is timeless and cannot automatically be pruned
5. Resource data can be organized by application, but more often is used by many different applications.
6. Resource data should not be snapshotted alongside the operating system file tree, home directory, or local work files.
7. Resource data is often not solely stored in the co-packaged storage devices on a machine (i.e. comes over NFS, external hard drive, etc.).

These characteristics drive the need for the creation of a standard that supports these properties.

## Goals

In this RFC we provide a minimal mechanism for placement of resource data in a single tenant host for a home directory.

## Non-Goals

This RFC is not:

- Standards for data cataloguing
- Standard for names of resource data
- System for managing the merging of external data resources

## Relationship to other work

This RFC follows the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir/latest/) and [RFC 24](../salotz.024_extended_xdg_base_directory/README.md) (`XDGX_*`) pattern: named environment variables with defaults under `~/.local`, without specifying the tree below those roots.

It is the layout RFC that [RFC 34](../salotz.034_storage-vocabulary/README.md) deferred.
RFC 34 defines **store**, **repository**, and **resource** as an application-data vocabulary, not kinds of storage, and lists host directory layout as a non-goal.
This RFC places that vocabulary on the filesystem: `XDGX_STORE_HOME` is a location for stores (physical copies / repositories on host-associated storage); `XDGX_RESOURCE_HOME` is the logical tree applications walk.

It does not replace [RFC 25](../salotz.025_host-domain-organization/README.md) `~/local/misc`.
That path is a leftover bucket for host-local reusable files that have no XDG/`~/.local` home (for example VM images).
This RFC's `~/.local/resources` is the logical index of bulk datasets.

## Design Principles

The **Host Resource Store Directory Layout** ("XDGX-Resource-Layout" for short) supports the following principles:

- Provide a single location for all host co-packaged resource data
- Provide a location disjoint from the co-packaged data that logically indexes both host co-packaged data and external data.
- Applications should have a single logical location to look for any resource data

## Specification

This RFC introduces some new concepts:

- **resource data**: Large slowly changing sets of data used by applications.
- **store directory**: Directory that physically holds data on host-associated storage (i.e. drives attached on motherboard).
- **resource directory**: Directory for logical access of resource data by applications.

Resource data, as discussed above, is data that has the following properties:

1. It is large in volume and slow/expensive to move
2. Effectively immutable and new versions come at a very slow pace
3. Is not generated as part of the normal internal operations of an application
4. Stands alone as a dataset rather than as a child of only a single application
5. Often attached to a host through external means (network attached storage, external drives)

The store directory is referenced by the name `XDGX_STORE_HOME`.
This is also the name of the environment variable that can be used to customize this path location.
The default path is `~/.local/store` and may be referred by this alone in writing.

The resource directory is referenced by the name `XDGX_RESOURCE_HOME`.
This is also the name of the environment variable that can be used to customize this path location.
The default path is `~/.local/resources` and may be referred by this alone in writing.

The store and resource directories are distinguished by being, respectively, the physical and logical locations for resource data.
Resource data that lives in storage attached to the host (i.e. the same drive the rest of the host filesystem is on, or a separate drive packaged in the same device) should be placed in the store directory.

So for example if you download some model weights files onto your laptop's SSD for the model `wumpus` you would place them in `~/.local/store`.
For example: `~/.local/store/wumpus/weights.h5`.

However, applications which use this data should not look for it here.
Instead they should look in the resource directory instead.
Following the example assume the application can be configured to look where a specific environment variable points: `export WUMPUS_MODEL_WEIGHTS_DIR=~/.local/resources/wumpus`.

The difference being that the resources directory provides a cleaner and more logical listing of the available data resource "packages".
This level of indirection between resources path and the drive specific store path is because often data resources might be spread out on different devices.
A single resource dataset may be 10s or 100s of GBs (or more) and you may reference it through a network (NFS, parallel filesystem) or an external SSD used just to house this data.
Multiple datasets may be needed by single applications or workflows of applications and so you want to join all of these together.
Data may also move between different sources.

With this level of indirection you are free to change the "physical" location of data while maintaining a logically consistent organization without rewriting or reconfiguring your applications.

This indirection can be implemented by any means supported by your filesystem, most usually symlinks and not copy-on-write as resource data should not be mutated.
Resource data should also be made read-only by all users so that it is not silently mutated by misbehaving applications.

As an aside, this RFC doesn't say what is good or efficient to do with all this data just how to organize it given your choices.

### Additional Suggestions

In placeholder form the paths for a resource dataset:

- `~/.local/store/<drive-name>/<dataset-name>/<resource-item>`
- `~/.local/resources/<resource-set-name>/<resource-item>`

Like in the other XDG and XDGX standards the directories directly below the standard directories are not really standardized and so anything is fair game.
We leave it up to operators or other standards to impose this structure.

However, we suggest that each immediate subdirectory of a `<drive-name>` directory under the store be interpreted as the dataset name (`<dataset-name>`) that uniquely identifies that dataset.
Similarly for the resource directories except that the resource name (`<resource-set-name>`) be allowed to be different and operator configurable, however defaulting to the `<dataset-name>` unless there is good reason to change.

Files within a dataset are called individually "resource items" (`<resource-item>`) and can be discussed as relative to a dataset/resource-set.

Dataset names should be, ideally, globally unique.
However this is difficult to maintain without a single global namespace that doesn't exist.
We recommend operators maintain a **data catalog** which assigns unique names to all the datasets you would integrate together.

We also call for the development of a standard means of communicating fully-qualified preferred dataset names with datasets, e.g. `wumpus.co/model-weights_v3`.
This implies the existence of directories for the domain names (`wumpus.co`) as enclosing directories.
This name should always be used in the store, but the resources are free to rename them at their whim.

However, in practice because most data paths are injected to applications via environment variables or default paths there should be little reason to rename them in the resources folder.
If you prefer to use default directories in applications for data you can similarly link data sets from the store.
For example if by default the `wumpus` application automatically looks in `~/.wumpus/weights` you should link it to `~/.local/store/__home__/wumpus.co/model-weights_v3`.

When using a `<drive-name>` qualifier under the store we suggest that you maintain a catalog of unique names across all drives that may be used for this purpose.
If in the simple case you have only a single drive on your host machine you should use the token `__home__` to indicate this.

## Advice For Operators

We advise that the resource directory (`XDGX_RESOURCE_HOME`) is suitable for backup or snapshotting alongside the host system, home directory (preferable), and/or application data.

The store directory (`XDGX_STORE_HOME`) should not be backed up or snapshotted using normal host backup tools.
If you need backups or sources for resource data set them up as specifically resource directories in remote storage.
Not as part of an incremental backup system.

On filesystems like btrfs this means setting up a separate subvolume for `~/.local/store` and disabling snapshots for it.

## Schemas

CUE schemas for the store and resource directories and environment variables are in [schemas](schemas/).
The CUE module is `salotz.info/rfcs/035_host-resource-store` (package `schemas`).

Default paths use `salotz.info/unix/path`; env names use `salotz.info/unix/envvar`.
`#LocalLayoutSpec` is a [RFC 033](../salotz.033_dirshape/README.md) layout for the default `~/.local/{store,resources}` grouping.

The schema encodes this specification (directory kinds, env vars, defaults, snapshot advice).
It does not encode the [Additional Suggestions](#additional-suggestions) (drive names, dataset names, catalogs).

## Related RFCs

- [RFC 24](../salotz.024_extended_xdg_base_directory/README.md): `XDGX_*` user-local directories. This RFC adds `XDGX_STORE_HOME` and `XDGX_RESOURCE_HOME`.
- [RFC 25](../salotz.025_host-domain-organization/README.md): host work layout, including `~/local/misc` for leftover host-local files.
- [RFC 33](../salotz.033_dirshape/README.md): layout encoding used by the schema.
- [RFC 34](../salotz.034_storage-vocabulary/README.md): store / repository / resource vocabulary this layout sits on.
