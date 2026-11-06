# Storage vocabulary

- nexp :: `salotz.034_storage-vocabulary`
- long name :: Storage vocabulary
- executive summary :: Controlled vocabulary for storage as a domain. Three kinds — block, filesystem, and object — which may layer on each other. Defines devices, pools, filesystems (block and virtual), shares, mounting (a filesystem to a path), and attachment (a block target to a host). Store, repository, and resource are an additional application-data vocabulary on those layers, not kinds of storage. Does not use volume (SAN, LVM, Docker, and Kubernetes all mean different things by it). Includes what partition tables, fstab, and similar configs map, and mappings from LVM, btrfs, Unraid, iSCSI, NFS, and related systems.

This RFC is a controlled vocabulary and a small schema for talking about **storage**.
Term headings follow [RFC 29](../salotz.029_glossary-format/README.md) so definitions are linkable.
Definitions appear in dependence order: each term uses only ordinary language and terms already defined.

The core of the model is the three kinds of storage (block, filesystem, object), the host objects that implement them (devices, pools, filesystems, shares), **mounting** (binding a filesystem tree to a path), and **attachment** (binding a block target to a host).

[Store](#store), [repository](#repository), and [resource](#resource) are an additional vocabulary.
They sit on the storage layers.
They are not kinds of storage.
See [Additional vocabulary](#additional-vocabulary).

CUE types for the entities live in [schemas](schemas/).

## Goals

- One vocabulary for **storage**: kinds (block, filesystem, object) and the host objects that implement them
- Definitions that compose: later terms are built only from earlier terms
- A place for **share**, **mounting**, and **attachment** that does not take over the word **volume**
- **Store**, **repository**, and **resource** as an additional vocabulary, not as storage kinds
- Mappings from common implementations, including terms that stay internal to those products
- A clear account of what partition tables, crypttab, initiator configs, fstab, and catalogs record

## Non-goals

- A host directory layout (where stores appear under a home directory)
- Snapshot, backup, or mount policy
- A projector or inventory tool
- Mandating names for particular disks or hosts
- Docker, Kubernetes, or CSI **volume** objects (runtime mounts into a workload).
  Those are extra mountings of paths that already sit on storage, not a kind of storage and not a term in this vocabulary.

## Etymology

**Volume** comes from Latin *volumen* (a roll of writing), then a bound book.
In computing it meant a unit of media you mount: a tape reel, a disk pack, a volume label on a pack or a DOS drive.
Storage arrays reused it for a LUN (a disk you present).
LVM reused it for a logical volume.
Windows reused it for a mounted filesystem.
Container runtimes reused it for the thing mounted into a container.
There is no through-line that this RFC can adopt without colliding with the others.
This vocabulary **does not use volume as a term**.
Vendor mappings below record what those products mean by it.

**Share** comes from holding something in common.
In filesystems it means a tree offered for use: an SMB share, an Unraid user share.
The through-line is a named tree that programs or people use, not a disk.
This RFC keeps **share** for that named tree.

**Attach** in SCSI, iSCSI, NVMe-oF, and CSI means making a [block target](#block-target) visible to a host.
**Mount** means binding a filesystem tree to a path.
This RFC follows that cut: [attachment](#attachment) is for blocks; [mounting](#mounting) is for filesystems.

## Terms

### storage

**Storage** is how data is addressed and presented, and the host objects that do that.

This RFC is a vocabulary for storage.

There are three **kinds** of storage:

- [block storage](#block-storage)
- [filesystem storage](#filesystem-storage)
- [object storage](#object-storage)

A kind is an interface, not a particular disk or product.
Implementations of one kind may sit on implementations of another.
That stacking is ordinary; see [Layering](#layering-of-kinds).

### block

A **block** is a fixed-size, addressable unit of storage (commonly 512 bytes or 4 KiB).

### block storage

**Block storage** is a kind of [storage](#storage): the interface that reads and writes [blocks](#block) by address.

### block target

A **block target** is anything that presents [block storage](#block-storage).

### device

A **device** is a physical [block target](#block-target) you can hold: one SSD, HDD, NVMe module, or similar.

A device has identity that survives moving it between machines (serial, and any fleet id you assign).
Kernel names (`nvme0n1`, `sda`) are not that identity.

### partition table

A **partition table** is data on a [device](#device) that records named byte ranges on that device.
It maps an identity (number, and optionally a UUID or label) to a byte range on the device.

A device may have no partition table.
The whole device is then one [block target](#block-target).
A table with a single partition is still a partition table; that is different from having none.

### partition

A **partition** is a [block target](#block-target) that is one region of a [device](#device) described by that device's [partition table](#partition-table).

### encoding mapping

An **encoding mapping** is a [block target](#block-target) derived from another block target by transforming [blocks](#block) (encryption, integrity, authenticity).

The usual case is encryption (LUKS).
The underlying [device](#device) or [partition](#partition) remains that device or partition.
An encoding mapping is a transform, not an [attachment](#attachment).

### attachment

An **attachment** is the binding that makes a [block target](#block-target) visible to a host as a local block target.

Typical cases: iSCSI login, NVMe-oF connect, Fibre Channel LUN mapping, attaching an EBS disk to an instance.
The remote presentation and the local node are both block targets; the attachment is the mapping between them.

A [device](#device) you can hold does not need attachment; it is already local.
[Encoding mappings](#encoding-mapping) are not attachments.

### pool

A **pool** is an aggregation of one or more **members** that presents storage capacity as a unit.

Each **member** is a [block target](#block-target) (a [device](#device), [partition](#partition), or [encoding mapping](#encoding-mapping)) with a role in the pool.
In prose: **data member**, **parity member**, **spare member**, **cache member**.
In a schema, that is a member plus a role field.

A pool with one member is still a pool.

A pool may present one or more [block targets](#block-target) assembled from members.
A pool may present one or more [filesystems](#filesystem) over those members.
The same members may be visible through more than one such entry point at once (several views of one aggregation).

### object storage

**Object storage** is a kind of [storage](#storage): the interface that stores named objects (blobs), not [blocks](#block) and not [filesystem storage](#filesystem-storage).

The kind is the API.
An implementation may sit on [block storage](#block-storage), on [filesystem storage](#filesystem-storage), or on purpose-built media.

### filesystem storage

**Filesystem storage** is a kind of [storage](#storage): the tree interface software uses (files, directories, paths, open, read, write, readdir).

### filesystem

A **filesystem** is anything that implements [filesystem storage](#filesystem-storage).

Classification is per how it is used, not per brand name.

### block filesystem

A **block filesystem** is a [filesystem](#filesystem) that lays files out as [blocks](#block) on a [block target](#block-target) of a [pool](#pool).

It has a filesystem identity (UUID, and optionally a filesystem label).
ext4, XFS, btrfs, and FAT used on a disk or on a pool-presented block target are block filesystems.

### virtual filesystem

A **virtual filesystem** is a [filesystem](#filesystem) whose backing is not a single [block filesystem](#block-filesystem).

It may merge or stack filesystems, speak a file protocol, or sit on [object storage](#object-storage) or another source.
NFS and SMB clients, FUSE mounts, overlayfs, mergerfs, Unraid shfs, and s3fs are virtual filesystems.

Some products show up as both, depending on use: the server side of NFS is often a [block filesystem](#block-filesystem); the client mount is a virtual filesystem.
Those are two filesystems, two [mountings](#mounting).

### share

A **share** is a named, discrete tree of files that a [pool](#pool) provides for use.

Its bytes reside on one or more [filesystems](#filesystem) of that pool.
When a share is [mounted](#mounting) on an operating system, it is rooted at a path and presented by a filesystem (block or virtual).
The path is the mounting.
The same share may be mounted at different paths on different hosts.

A share is a designated tree.

One filesystem may present many shares.
One share may be presented by a [virtual filesystem](#virtual-filesystem) over several [block filesystems](#block-filesystem) of the same pool.
Both are ordinary pools with more than one entry point.

### share name

A **share name** is the stable name of a [share](#share).
It identifies the share, not a [device](#device) and not a path.

### mounting

A **mounting** is the binding of a [share](#share) (or of a [filesystem](#filesystem) that presents one) to a path on a host, by mounting a filesystem.

This is not an [attachment](#attachment).
Attachment is for [block targets](#block-target).

## Layering of kinds

The three kinds are peers, not a single stack.

A [filesystem](#filesystem) may sit on [block storage](#block-storage) (ext4 on a disk).
A filesystem may sit on another filesystem (overlayfs, NFS client, mergerfs): [filesystem storage](#filesystem-storage) implemented on filesystem storage.
[Object storage](#object-storage) may sit on a filesystem, on blocks, or on its own devices.
A filesystem may sit on object storage (s3fs).
[Block storage](#block-storage) may sit on a file (a loop device) or be imported from elsewhere by [attachment](#attachment).

That circularity is the point of calling them kinds of storage rather than layers of one tower.
A given deployment picks a stack; the vocabulary does not.

## Additional vocabulary

The terms below are **not** kinds of [storage](#storage) and not host storage objects.
They are an application-data catalog: what dataset this is, and where copies live.

People often say "storage" when they mean this.
This RFC keeps the words so the contrast is explicit.
The definitions are normative for now.
They sit *on* [shares](#share) or [object storage](#object-storage); they do not extend the storage stack.

[RFC 35](../salotz.035_host-resource-store/README.md) places stores under directories in the [RFC 24](../salotz.024_extended_xdg_base_directory/README.md) style (`XDGX_STORE_HOME`, `XDGX_RESOURCE_HOME`).
That is layout, which this RFC lists as a non-goal.

### store

A **store** is an application-specific collection of [resources](#resource).

A [share](#share) may contain many stores.
Nix's store, DVC's store, and an application-named store (model weights, a database corpus) are stores.

A well-known directory of stores (for example a per-user `store` directory whose children are app-named stores) is a location for stores, not itself one store.

### repository

A **repository** (repo) is one location of a [store](#store).

The same store may have repositories on different [shares](#share), hosts, or [object storage](#object-storage).
Local disk, NFS, an external drive, and an S3 bucket can be repositories of one store.

A repository is how a store is materialized.
A repository may sit on a share (a path on a [filesystem](#filesystem)) or on object storage with no [filesystem](#filesystem).

### resource

A **resource** is a dataset with its own identity (a particular database release, a model bundle, a published ISO).

Resources live in a [store](#store).
A resource is materialized in one or more [repositories](#repository) of that store.

## Multiple entry points on one pool

The same [members](#pool) may be visible as more than one [pool](#pool) view.

Unraid's array is an aggregation of members (data members, parity members) with two entry points at once:

- User-facing: one pool view whose [filesystem](#filesystem) is a [virtual filesystem](#virtual-filesystem) (shfs) over the disks.
  Each user share is a [share](#share) on that view.
- Per disk: each data member can be treated as a one-member pool with its own [block filesystem](#block-filesystem) (`/mnt/diskN`).
  Disk shares, when you use them, are shares on those views.

Both views are true.
Placement policy (which disk, split level) is internal to Unraid.
This vocabulary does not special-case Unraid; a pool already allows multiple entry points on the same members.

A [virtual filesystem](#virtual-filesystem) that merges the same relative tree from several [block filesystems](#block-filesystem) (Unraid shfs, mergerfs, unionfs) is how one [share](#share) can span members.
overlayfs is the same class of object with a different merge rule (layers).

So both of these occur:

- One [filesystem](#filesystem) presents many [shares](#share) (typical designated btrfs subtrees).
- Several filesystems of one pool present one share via a virtual filesystem.

## Where configuration sits

These files do not introduce extra kinds of object.
They record mappings between objects already defined.

**Partition table** (on the [device](#device)):

- Maps partition identity to a byte range on that device.

**crypttab** (or equivalent):

- Maps an [encoding mapping](#encoding-mapping) identity to the underlying [block target](#block-target), plus how to decode (unlock).

**iSCSI / NVMe-oF initiator config**:

- Maps a remote LUN to a local [block target](#block-target).
- That row is an [attachment](#attachment).

**fstab** (and systemd mount units, autofs, and similar):

- Maps a [filesystem](#filesystem) identity (UUID or label), plus a [share](#share) selector when needed (for example a btrfs subvolume path), or a file-protocol source, to a path on this host.
- That row is a [mounting](#mounting).

**Share name registry** (inventory, not a mount table):

- Maps a [share name](#share-name) to a [share](#share) (which [pool](#pool), which tree).
- It does not assign paths.
  Paths come from mountings on each host.

**Store catalog**:

- Maps a [store](#store) to its [repositories](#repository).

**Resource catalog**:

- Maps a [resource](#resource) to a store, and which repositories currently hold it.

Runtime metadata (Docker named volumes, Kubernetes PersistentVolumes as used in a pod) is not a storage mapping.
It records extra [mountings](#mounting) into a workload.
This vocabulary does not name those objects.

## Mapping from implementation models

Vendor terms that do not map stay inside that product.
This vocabulary does not adopt **volume**.
Where a product uses that word, the table says what object we would name.

| Technology | Their term | Ours |
|---|---|---|
| SCSI / disks | Logical block | [Block](#block) |
| | Block device | [Block target](#block-target) |
| | Target, initiator | Roles in a [block](#block) protocol, not [attachment](#attachment) |
| GPT / DOS | Disk, drive | [Device](#device) |
| | Partition table | [Partition table](#partition-table) |
| | Partition | [Partition](#partition) |
| | PARTUUID, PARTLABEL | Partition identity |
| | Protective MBR, free space | Internal |
| LUKS, dm-integrity, dm-verity | Backing device | [Block target](#block-target) |
| | Mapping, `/dev/mapper/...` | [Encoding mapping](#encoding-mapping) |
| | Keyslot, header | Internal |
| LVM | PV | Member |
| | VG | [Pool](#pool) |
| | LV, logical volume | [Block target](#block-target) provided by the pool |
| mdadm | Component | Member |
| | Array `/dev/mdN` | [Pool](#pool) that presents one block target |
| | RAID level, superblock | Internal |
| ext4, XFS, FAT | Formatted block device | [Block filesystem](#block-filesystem) on a pool block target |
| | UUID, LABEL | Filesystem identity |
| | Mount point | [Mounting](#mounting) path |
| btrfs | Device in the FS | Member |
| | Multi-device btrfs | [Pool](#pool) that is one [filesystem](#filesystem) |
| | Subvolume (designated) | [Share](#share) |
| | Subvolume (snapshots, internals) | Internal |
| | `subvol=` | Share selector on a mounting |
| ZFS | Disk / vdev component | Member |
| | vdev layout | Internal |
| | zpool | [Pool](#pool) |
| | Dataset (designated) | [Share](#share) |
| | zvol | [Block target](#block-target) provided by the pool |
| Unraid | Disk | [Device](#device) and member |
| | Parity | Parity member |
| | Array | [Pool](#pool) (two entry points; see [above](#multiple-entry-points-on-one-pool)) |
| | Cache / named pool | [Pool](#pool) |
| | `/mnt/diskN` filesystem | [Block filesystem](#block-filesystem) of a member |
| | User share | [Share](#share), presented by a [virtual filesystem](#virtual-filesystem) |
| | Disk share | [Share](#share) only if designated |
| | Split level, included disks | Internal placement |
| | shfs | [Virtual filesystem](#virtual-filesystem) |
| mergerfs, overlayfs, unionfs | The merged or stacked mount | [Virtual filesystem](#virtual-filesystem) |
| FUSE / s3fs / gitfs | The FUSE mount | [Virtual filesystem](#virtual-filesystem) |
| | FUSE as a kernel mechanism | Internal |
| iSCSI | Target, initiator | Roles in a [block](#block) protocol |
| | LUN | [Block target](#block-target) (imported on the initiator) |
| | Login / attach | [Attachment](#attachment) |
| | "iSCSI volume" in vendor docs | [Block target](#block-target) |
| NVMe-oF, Fibre Channel | Namespace / LUN | [Block target](#block-target) |
| | Connect / attach | [Attachment](#attachment) |
| AWS EBS, Ceph RBD | Volume, image | [Block target](#block-target) |
| | Attach to instance / map | [Attachment](#attachment) |
| NFS, SMB | Export, share | The same [share](#share) offered via a file protocol |
| | Client mount | [Mounting](#mounting) through a [virtual filesystem](#virtual-filesystem) |
| Docker, Kubernetes | Bind mount, named volume, pod volume | Extra [mounting](#mounting) into a workload; internal to the runtime |
| | PVC, CSI as cluster objects | Internal to the orchestrator |
| | CSI attach of a block PV | [Attachment](#attachment) |
| | CSI mount / node publish | [Mounting](#mounting) |
| Nix, DVC | Store | [Store](#store) |
| DVC remote, Nix binary cache, extra clone of a store | Remote / cache / replica | [Repository](#repository) |
| UniProt dump, a model bundle | The dataset | [Resource](#resource) |
| S3, MinIO | Bucket / prefix | [Object storage](#object-storage); may hold a [repository](#repository) |

## Containment

A [pool](#pool) has members and provides [shares](#share) (via [filesystems](#filesystem)).

A share may contain many [stores](#store).

A store contains [resources](#resource) and may exist in many [repositories](#repository).

A repository sits on a share or on [object storage](#object-storage).

A [mounting](#mounting) binds a share (or a filesystem that presents one) to a path.

An [attachment](#attachment) binds a [block target](#block-target) to a host as a local block target.

## Worked examples

### One NVMe, GPT, btrfs

One [device](#device), a [partition table](#partition-table), three [partitions](#partition).
The system partition is the member of a one-member [pool](#pool).
That pool has one btrfs [block filesystem](#block-filesystem).
Several designated subtrees are [shares](#share), each [mounted](#mounting) by fstab (filesystem UUID plus subvolume selector to a path).

### Whole-disk data HDD, no partition table

One [device](#device), no [partition table](#partition-table), `mkfs` on the whole [block target](#block-target).
One-member [pool](#pool), one [block filesystem](#block-filesystem), one [share](#share).

### LUKS, LVM, and ext4

A [partition](#partition) becomes an [encoding mapping](#encoding-mapping) (crypttab), then a member of an LVM [pool](#pool).
The pool presents a [block target](#block-target) (LVM's LV).
ext4 [block filesystem](#block-filesystem) on that target.
One [share](#share), [mounted](#mounting) by fstab to a path.
No [attachment](#attachment): the device is local.

### iSCSI

A NAS pool presents a [block target](#block-target) (often an LVM LV) and exports it as a LUN.
Initiator config is an [attachment](#attachment): remote LUN to local block target.
From there the initiator looks like the LUKS/LVM or whole-disk examples: [block filesystem](#block-filesystem), [share](#share), fstab [mounting](#mounting).
iSCSI names the attachment, not the share; fstab names the mounting.

### NFS

The NAS already has a [share](#share).
NFS exports its [filesystem storage](#filesystem-storage) interface.
The client fstab line is a [mounting](#mounting) via a [virtual filesystem](#virtual-filesystem).
Same share, two paths, two hosts.
No [attachment](#attachment): nothing at the block kind is imported.

### Unraid user share

Data [devices](#device) are members of an array [pool](#pool); each has a [block filesystem](#block-filesystem).
A user share is one [share](#share).
shfs ([virtual filesystem](#virtual-filesystem)) merges the share directory from each member filesystem.
NFS may then export that share as in the previous example.

### Object store via FUSE

s3fs is a [virtual filesystem](#virtual-filesystem) over [object storage](#object-storage).
If you designate that tree as a [share](#share), software uses a named file tree through [filesystem storage](#filesystem-storage).
A [store](#store) may instead keep a [repository](#repository) on the object storage directly, with no filesystem.

## Schemas

CUE types for these entities are in [schemas](schemas/).
The CUE module is `salotz.info/rfcs/034_storage-vocabulary` (package `schemas`).

The schema is the vocabulary in types: kinds of [storage](#storage), every [block target](#block-target) form, [pool](#pool) members and presented targets, [filesystems](#filesystem) (block and virtual), [shares](#share), [mounting](#mounting), [attachment](#attachment), and the configuration mappings ([partition table](#partition-table), [share name](#share-name) registry, fstab (`salotz.info/unix/fstab`), store catalog, resource catalog).
Store, repository, and resource types are the additional vocabulary.

Mounting paths use `salotz.info/unix/path`. Host fields use `salotz.info/unix/hostname`.
Identity strings are otherwise implementation-defined.
The schema does not invent host paths or mount policy.

## Related RFCs

- [RFC 24](../salotz.024_extended_xdg_base_directory/README.md): `XDGX_*` user-local directories.
- [RFC 25](../salotz.025_host-domain-organization/README.md): host work layout (`~/tree`, `~/local`, scratch).
- [RFC 29](../salotz.029_glossary-format/README.md): glossary heading and cross-link conventions used for the terms above.
- [RFC 35](../salotz.035_host-resource-store/README.md): host directory layout for stores (`XDGX_STORE_HOME`, `XDGX_RESOURCE_HOME`).
