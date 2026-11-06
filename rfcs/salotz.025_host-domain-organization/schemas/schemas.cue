package schemas

import (
	unixpath "salotz.info/unix/path"
	dirshape "salotz.info/rfcs/033_dirshape:schemas"
)

// salotz.025_host-domain-organization — host home-directory layout.

#DomainName: string

#DomainSubdir: "devel" | "projects" | "admin" | "inbox" | "outbox"

#Paths: {
	scratch:     unixpath.#HomeRelativePath & "~/scratch"
	localWork:   unixpath.#HomeRelativePath & "~/local/work"
	localMisc:   unixpath.#HomeRelativePath & "~/local/misc"
	localInbox:  unixpath.#HomeRelativePath & "~/local/inbox"
	localOutbox: unixpath.#HomeRelativePath & "~/local/outbox"
	tree:        unixpath.#HomeRelativePath & "~/tree"
	downloads:   unixpath.#HomeRelativePath & "~/Downloads"
}

#DomainTree: {
	name:      #DomainName
	devel?:    bool | *true
	projects?: bool | *true
	admin?:    bool | *true
	inbox?:    bool
	outbox?:   bool
}

// Injected root is $HOME.
#HomeLayoutSpec: dirshape.#LayoutSpec & {
	entries: {
		scratch: {name: "scratch/"}
		local: {
			name: "local/"
			children: {
				work: {name: "work/"}
				misc: {name: "misc/", presence: "optional"}
				inbox: {name: "inbox/", presence: "optional"}
				outbox: {name: "outbox/", presence: "optional"}
			}
		}
		tree: {
			name: "tree/"
			children: {
				domain: {
					name:     "*/"
					match:    "glob"
					presence: "optional"
					children: {
						devel: {name: "devel/", presence: "optional"}
						projects: {name: "projects/", presence: "optional"}
						admin: {name: "admin/", presence: "optional"}
						inbox: {name: "inbox/", presence: "optional"}
						outbox: {name: "outbox/", presence: "optional"}
					}
				}
			}
		}
		downloads: {name: "Downloads/", presence: "optional"}
	}
}

_examples: {
	scratch: #Paths.scratch
	sub:     #DomainSubdir & "devel"
	personal: #DomainTree & {name: "personal", inbox: true, outbox: true}
	layout: #HomeLayoutSpec
}
