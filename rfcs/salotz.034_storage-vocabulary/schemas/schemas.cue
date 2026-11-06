package schemas

import (
	unixpath "salotz.info/unix/path"
	hostname "salotz.info/unix/hostname"
	fstab "salotz.info/unix/fstab"
)

// salotz.034_storage-vocabulary — entities and relations.
// Prose definitions: ../README.md
//
// Types follow the vocabulary: kinds, block-target forms, pool, filesystem,
// share, mounting, attachment, then the additional application-data catalog.
// Configuration types record mappings; they are not extra kinds of object.
// Identity strings are implementation-defined (serial, PARTUUID, mapper
// name, share name, UUID, …). The schema does not invent host paths or
// mount policy.

#Identity: string

#ShareName: string

#StorageKind: "block" | "filesystem" | "object"

// Addressable unit of block storage (commonly 512 or 4096 bytes).
// Not an inventory object.
#Block: {
	sizeBytes: int
}

#BlockTargetKind: "device" | "partition" | "encoding-mapping" | "pool-presented" | "attached"

// Anything that presents block storage. Concrete forms below.
#BlockTarget: {
	kind: #BlockTargetKind
	id:   #Identity
}

#Device: {
	serial?:  string
	fleetId?: string
}

#Partition: {
	number:      int
	partuuid?:   string
	partlabel?:  string
	device:      #Identity
	startByte?:  int
	lengthByte?: int
}

// Mapping on a device: partition identity → byte range.
// Absent when the whole device is the block target.
#PartitionTable: {
	device: #Identity
	partitions: [...#Partition]
}

#EncodingKind: "encryption" | "integrity" | "authenticity" | string

#EncodingMapping: {
	id:      #Identity
	backing: #Identity
	kind:    #EncodingKind
}

// Binding that makes a block target visible locally (iSCSI, NVMe-oF, EBS, …).
// Encoding mappings are transforms, not attachments.
#Attachment: {
	remote: #Identity
	local:  #Identity
	host?:  hostname.#Host
}

#MemberRole: "data" | "parity" | "spare" | "cache"

#Member: {
	role:   #MemberRole
	target: #BlockTarget
}

#Pool: {
	name: string
	members: [#Member, ...#Member]
	// Block targets assembled from members (LVM LV, zvol, md array, …).
	presented?: [...#BlockTarget]
}

#ObjectStorage: {
	id:       #Identity
	backing?: #Identity
}

#FilesystemKind: "block" | "virtual"

#Filesystem: {
	id:     #Identity
	kind:   #FilesystemKind
	uuid?:  string
	label?: string

	if kind == "block" {
		pool:        #Identity
		blockTarget: #Identity
	}

	if kind == "virtual" {
		backing: [...#Identity]
		pool?: #Identity
	}
}

#Share: {
	name: #ShareName
	pool: #Identity
	filesystems: [#Identity, ...#Identity]
	// Designated tree within those filesystems; not a host mount path.
	tree?: string
}

// Binding of a share or filesystem to a path on a host.
// Not an attachment (attachment is for block targets).
#Mounting: {
	path:        unixpath.#AbsUnixPath
	share?:      #ShareName
	filesystem?: #Identity
	selector?:   string
	host?:       hostname.#Host
}

// Additional vocabulary: application-data catalog, not a storage kind.

#Store: {
	name:         string
	application?: string
}

#RepositoryLocation: {
	kind: "share" | "object-storage"
	ref:  #Identity
	// Path on the share; omitted for object storage.
	path?: string
}

#Repository: {
	id:       #Identity
	store:    #Identity
	location: #RepositoryLocation
}

#Resource: {
	identity: string
	store:    #Identity
	repositories?: [...#Identity]
}

// Configuration mappings (not extra kinds).
// An fstab record maps a mounting (spec + mountpoint); it is not a
// kind of storage.

#FstabMapping: fstab.#RecordStruct
#FstabTable:   fstab.#Table

#ShareNameRegistryEntry: {
	name:  #ShareName
	pool:  #Identity
	tree?: string
}

#ShareNameRegistry: {
	entries: [...#ShareNameRegistryEntry]
}

#StoreCatalogEntry: {
	store: #Identity
	repositories: [...#Identity]
}

#StoreCatalog: {
	entries: [...#StoreCatalogEntry]
}

#ResourceCatalogEntry: {
	resource: #Identity
	store:    #Identity
	repositories: [...#Identity]
}

#ResourceCatalog: {
	entries: [...#ResourceCatalogEntry]
}

_examples: {
	kind: #StorageKind & "filesystem"
	block: #Block & {sizeBytes: 4096}

	device: #Device & {
		serial:  "S4EVNX0N800123"
		fleetId: "nvme-os"
	}

	ptable: #PartitionTable & {
		device: "nvme-os"
		partitions: [
			{number: 1, partuuid: "p1", device: "nvme-os"},
			{number: 2, partuuid: "p2", device: "nvme-os"},
			{number: 3, partuuid: "p3", device: "nvme-os"},
		]
	}

	luks: #EncodingMapping & {
		id:      "crypt-data"
		backing: "p3"
		kind:    "encryption"
	}

	attach: #Attachment & {
		remote: "iqn.2005-03.example:lun-1"
		local:  "sdb"
	}

	pool: #Pool & {
		name: "array"
		members: [
			{role: "data", target: {kind: "device", id: "disk2"}},
			{role: "data", target: {kind: "device", id: "disk4"}},
			{role: "parity", target: {kind: "device", id: "parity1"}},
		]
	}

	lvm: #Pool & {
		name: "vg0"
		members: [{
			role: "data"
			target: {kind: "encoding-mapping", id: "crypt-data"}
		}]
		presented: [{kind: "pool-presented", id: "vg0-root"}]
	}

	osfs: #Filesystem & {
		id:          "fs-os"
		kind:        "block"
		uuid:        "4f3a8c12-9b0e-4d21-a7c8-0e1f2a3b4c5d"
		pool:        "os"
		blockTarget: "p2"
	}

	disk2fs: #Filesystem & {
		id:          "fs-disk2"
		kind:        "block"
		pool:        "array"
		blockTarget: "disk2"
	}

	shfs: #Filesystem & {
		id:   "shfs"
		kind: "virtual"
		pool: "array"
		backing: ["fs-disk2", "fs-disk4"]
	}

	s3: #ObjectStorage & {id: "s3://bucket"}

	s3fs: #Filesystem & {
		id:   "s3fs"
		kind: "virtual"
		backing: ["s3://bucket"]
	}

	share: #Share & {
		name: "salotz"
		pool: "array"
		filesystems: ["shfs"]
	}

	mnt: #Mounting & {
		share:      "salotz"
		filesystem: "shfs"
		path:       "/mnt/user/salotz"
		host:       "nas"
	}

	fstabRec: #FstabMapping & {
		spec:       "UUID=4f3a8c12-9b0e-4d21-a7c8-0e1f2a3b4c5d"
		mountpoint: "/mnt/user/salotz"
		type:       "btrfs"
		options: ["defaults", "subvol=salotz"]
		freq:   0
		passno: 2
	}

	store: #Store & {name: "uniprot", application: "colabfold"}

	repo: #Repository & {
		id:    "uniprot-array"
		store: "uniprot"
		location: {kind: "share", ref: "salotz", path: "store/uniprot"}
	}

	repoS3: #Repository & {
		id:    "uniprot-s3"
		store: "uniprot"
		location: {kind: "object-storage", ref: "s3://bucket"}
	}

	resource: #Resource & {
		identity: "uniprot-2024_04"
		store:    "uniprot"
		repositories: ["uniprot-array", "uniprot-s3"]
	}

	names: #ShareNameRegistry & {
		entries: [{name: "salotz", pool: "array"}]
	}

	stores: #StoreCatalog & {
		entries: [{store: "uniprot", repositories: ["uniprot-array", "uniprot-s3"]}]
	}

	resources: #ResourceCatalog & {
		entries: [{
			resource: "uniprot-2024_04"
			store:    "uniprot"
			repositories: ["uniprot-array", "uniprot-s3"]
		}]
	}
}
