package fstab

import (
	"salotz.info/unix/hostname"
	"salotz.info/unix/path"
)

// fstab(5): static information about filesystems.
// https://man7.org/linux/man-pages/man5/fstab.5.html
//
// Six fields per record (fs_spec, fs_file, fs_vfstype, fs_mntops,
// fs_freq, fs_passno), separated by tabs or spaces. `#Table` is
// already-split lines, not a parser of a raw blob. Trailing comments
// on a record line are not encoded. Space and tab inside a field are
// written as octal escapes `\040` and `\011`; these types match the
// escaped spelling.
//
// freq and passno default to 0 when omitted (fstab(5), systemd).
// `/etc/mtab` and `/proc/mounts` share this 6-field layout;
// `/proc/self/mountinfo` does not.

#Filename: "fstab"
#Path:     "/etc/fstab"

#MtabPath:           "/etc/mtab"
#ProcMountsPath:     "/proc/mounts"
#ProcSelfMountsPath: "/proc/self/mounts"

// One on-disk field. No unescaped whitespace or newline.
#Field: string & !="" & !~"[ \t\n\r]"

#Spec: #Field // fs_spec

#Mountpoint: #Field // fs_file

#Type: #Field // fs_vfstype

// One mount option. No comma or whitespace (`defaults`, `pri=1`).
#Option: string & !="" & !~"[\n\r, \t]"

// Comma-separated options field (no spaces around commas).
#Options: string & =~"^[^, \t]+(,[^, \t]+)*$"

#FlagOption:  #Option & !~"="
#ValueOption: #Option & =~"="

#Freq: int & >=0 // fs_freq (dump(8))

#Passno: int & >=0 // fs_passno (fsck(8))

#FreqNone: 0

#PassnoNone:  0
#PassnoRoot:  1
#PassnoOther: 2

#None: "none"
#Auto: "auto"
#Swap: "swap"
#Root: "/"

// libmount TAG=value device specs. UUID values are blkid strings
// (FAT `AAAA-BBBB` is not RFC 9562). Prefer lowercase for RFC-shaped
// UUIDs (fstab(5)).
#TagNames: ["LABEL", "UUID", "PARTLABEL", "PARTUUID"]
#TagName: or(#TagNames)

#LABELSpec:     #Spec & =~"^LABEL=.+"
#UUIDSpec:      #Spec & =~"^UUID=.+"
#PARTLABELSpec: #Spec & =~"^PARTLABEL=.+"
#PARTUUIDSpec:  #Spec & =~"^PARTUUID=.+"
#TagSpec:       #LABELSpec | #UUIDSpec | #PARTLABELSpec | #PARTUUIDSpec

#TagStruct: {
	tag:   #TagName
	value: #Field
}

#PathSpec: path.#AbsUnixPath

#DevDiskByUUID:      #PathSpec & =~"^/dev/disk/by-uuid/.+"
#DevDiskByLabel:     #PathSpec & =~"^/dev/disk/by-label/.+"
#DevDiskByPARTUUID:  #PathSpec & =~"^/dev/disk/by-partuuid/.+"
#DevDiskByPARTLabel: #PathSpec & =~"^/dev/disk/by-partlabel/.+"
#DevDiskByID:        #PathSpec & =~"^/dev/disk/by-id/.+"
#DevDiskByPath:      #PathSpec & =~"^/dev/disk/by-path/.+"

// NFS `host:/path`. IPv6 host is bracketed in the string form.
#NFSSpec:     #Spec & =~"^[^[ \t\n\r:][^ \t\n\r:]*:/[^ \t\n\r]*$"
#NFSIPv6Spec: #Spec & =~"^\\[[^\\]]+\\]:/[^ \t\n\r]*$"
#NFSSpecAny:  #NFSSpec | #NFSIPv6Spec
#CIFSSpec:    #Spec & =~"^//[^/ \t\n\r]+/[^ \t\n\r]+$"

#NFSSpecStruct: {
	host: hostname.#Host
	path: path.#AbsUnixPath
}

#CIFSSpecStruct: {
	host:  hostname.#Host
	share: #Field
}

#AbsMountpoint:  path.#AbsUnixPath
#NoneMountpoint: #None

#FuseSubtype: #Type & =~"^fuse\\."

// Types named in fstab(5) plus common Linux vfstypes. Unknown
// types still unify with #Type.
#WellKnownTypeNames: [...#Type]
#WellKnownTypeNames: [
	"ext2", "ext3", "ext4", "xfs", "btrfs", "bcachefs", "f2fs", "jfs",
	"vfat", "msdos", "exfat", "ntfs", "ntfs3", "hfs", "hfsplus",
	"iso9660", "udf", "squashfs", "erofs", "tmpfs", "ramfs", "overlay",
	"sysfs", "proc", "devtmpfs", "devpts", "cgroup", "cgroup2",
	"debugfs", "securityfs", "pstore", "bpf", "efivarfs",
	"nfs", "nfs4", "cifs", "smb3", "9p", "fuse", "virtiofs", "zfs",
	"swap", "none", "auto",
]
#WellKnownType: or(#WellKnownTypeNames)

// Filesystem-independent flags from fstab(5) / mount(8). Key=value
// and fs-specific options still unify with #Option.
#WellKnownOptionNames: [...#Option]
#WellKnownOptionNames: [
	"defaults", "rw", "ro", "suid", "nosuid", "dev", "nodev",
	"exec", "noexec", "auto", "noauto", "user", "nouser", "users",
	"owner", "group", "async", "sync", "dirsync",
	"atime", "noatime", "relatime", "strictatime", "lazytime", "nodiratime",
	"_netdev", "nofail", "bind", "rbind", "move", "sw",
]
#WellKnownOption: or(#WellKnownOptionNames)

// Userspace options (`x-*`) are ignored by mount(8)/umount(8).
#UserspaceOption: #Option & =~"^x-"
#SystemdOption:   #Option & =~"^x-systemd\\."
#InitrdOption:    "x-initrd.mount"
#LibmountOption:  #Option & =~"^X-mount\\."

#SystemdOptionStems: [...string]
#SystemdOptionStems: [
	"automount", "device-timeout", "mount-timeout", "idle-timeout",
	"requires", "requires-mounts-for", "wants", "wants-mounts-for",
	"after", "before", "wanted-by", "required-by",
	"makefs", "growfs", "rw-only",
]
#SystemdOptionStem: or(#SystemdOptionStems)

// One record line: 4 required fields, optional freq, optional passno.
// Leading and trailing blanks allowed. Does not start with `#`.
#Record: string & =~"^[ \t]*[^ \t#\n\r][^ \t\n\r]*[ \t]+[^ \t\n\r]+[ \t]+[^ \t\n\r]+[ \t]+[^ \t\n\r]+([ \t]+[0-9]+([ \t]+[0-9]+)?)?[ \t]*$"

// Decomposed record. `options` has at least one entry. Omitted freq
// and passno mean the on-disk fields were absent (treat as 0).
#RecordStruct: {
	spec:       #Spec
	mountpoint: #Mountpoint
	type:       #Type
	options: [...#Option] & [_, ...]
	freq?:   #Freq
	passno?: #Passno
}

#Blank:   string & =~"^[ \t]*$"
#Comment: string & =~"^[ \t]*#.*$"

#Line: #Blank | #Comment | #Record | #RecordStruct

#Table: [...#Line]

#TableStruct: {
	records: [...#RecordStruct]
}

_examples: {
	path:     #Path & "/etc/fstab"
	filename: #Filename & "fstab"
	mtab:     #MtabPath & "/etc/mtab"
	proc:     #ProcMountsPath & "/proc/mounts"

	uuid:      #UUIDSpec & "UUID=3e6be9de-8139-11d1-9106-a43f08d823a6"
	label:     #LABELSpec & "LABEL=t-home2"
	partuuid:  #PARTUUIDSpec & "PARTUUID=5c94d684-3f2f-4b3e-9c1a-1d2e3f4a5b6c"
	fat:       #UUIDSpec & "UUID=AAAA-BBBB"
	dev:       #PathSpec & "/dev/sda1"
	byUUID:    #DevDiskByUUID & "/dev/disk/by-uuid/3e6be9de-8139-11d1-9106-a43f08d823a6"
	byLabel:   #DevDiskByLabel & "/dev/disk/by-label/t-home2"
	nfs:       #NFSSpec & "knuth.aeb.nl:/"
	nfsExport: #NFSSpec & "server:/export/home"
	nfs6:      #NFSIPv6Spec & "[fe80::1]:/export"
	cifs:      #CIFSSpec & "//nas/media"
	none:      #None & "none"
	tagStruct: #TagStruct & {
		tag:   "UUID"
		value: "3e6be9de-8139-11d1-9106-a43f08d823a6"
	}
	nfsStruct: #NFSSpecStruct & {
		host: "server"
		path: "/export"
	}
	cifsStruct: #CIFSSpecStruct & {
		host:  "nas"
		share: "media"
	}

	root:   #Root & "/"
	home:   #AbsMountpoint & "/home"
	swapMP: #NoneMountpoint & "none"

	ext4: #WellKnownType & "ext4"
	fuse: #FuseSubtype & "fuse.sshfs"
	auto: #Auto & "auto"
	swap: #Swap & "swap"

	defaults:  #WellKnownOption & "defaults"
	nofail:    #WellKnownOption & "nofail"
	netdev:    #WellKnownOption & "_netdev"
	bindOpt:   #WellKnownOption & "bind"
	systemdAM: #SystemdOption & "x-systemd.automount"
	timeout:   #SystemdOption & "x-systemd.device-timeout=10s"
	stem:      #SystemdOptionStem & "automount"
	initrd:    #InitrdOption & "x-initrd.mount"
	mkdir:     #LibmountOption & "X-mount.mkdir"
	pri:       #ValueOption & "pri=1"
	opts:      #Options & "defaults,noatime,nofail"

	freq0:     #FreqNone & 0
	passRoot:  #PassnoRoot & 1
	passOther: #PassnoOther & 2

	rec:      #Record & "LABEL=t-home2 /home ext4 defaults,auto_da_alloc 0 2"
	recUUID:  #Record & "UUID=3e6be9de-8139-11d1-9106-a43f08d823a6 / ext4 defaults 0 1"
	recShort: #Record & "tmpfs /tmp tmpfs defaults"
	recPad:   #Record & "  tmpfs  /tmp  tmpfs  defaults  0  0  "

	recStruct: #RecordStruct & {
		spec:       "UUID=3e6be9de-8139-11d1-9106-a43f08d823a6"
		mountpoint: "/"
		type:       "ext4"
		options: ["defaults"]
		freq:   0
		passno: 1
	}
	bind: #RecordStruct & {
		spec:       "/srv/data"
		mountpoint: "/mnt/data"
		type:       "none"
		options: ["bind"]
	}
	nfsRec: #RecordStruct & {
		spec:       "server:/export"
		mountpoint: "/mnt/nfs"
		type:       "nfs"
		options: ["defaults", "_netdev", "nofail"]
		freq:   0
		passno: 0
	}
	swapRec: #RecordStruct & {
		spec:       "/dev/sda2"
		mountpoint: "none"
		type:       "swap"
		options: ["sw"]
		freq:   0
		passno: 0
	}
	tmpfs: #RecordStruct & {
		spec:       "tmpfs"
		mountpoint: "/tmp"
		type:       "tmpfs"
		options: ["defaults"]
	}

	comment:  #Comment & "# <file system> <mount point> <type> <options> <dump> <pass>"
	indented: #Comment & "  # ignored"
	blank:    #Blank & ""
	spaces:   #Blank & "  "

	table: #Table & [
		"# /etc/fstab",
		"UUID=3e6be9de-8139-11d1-9106-a43f08d823a6 / ext4 defaults 0 1",
		"LABEL=t-home2 /home ext4 defaults,auto_da_alloc 0 2",
		{
			spec:       "tmpfs"
			mountpoint: "/tmp"
			type:       "tmpfs"
			options: ["defaults"]
		},
		"",
	]
	tableStruct: #TableStruct & {
		records: [{
			spec:       "UUID=3e6be9de-8139-11d1-9106-a43f08d823a6"
			mountpoint: "/"
			type:       "ext4"
			options: ["defaults"]
			freq:   0
			passno: 1
		}]
	}
}
