package schemas

// salotz.025_host-domain-organization — host home-directory layout.

#DomainName: string

#DomainSubdir: "devel" | "projects" | "admin" | "inbox" | "outbox"

#Paths: {
	scratch:        "~/scratch"
	localWork:      "~/local/work"
	localResources: "~/local/resources"
	localInbox:     "~/local/inbox"
	localOutbox:    "~/local/outbox"
	tree:           "~/tree"
	downloads:      "~/Downloads"
}

#DomainTree: {
	name:    #DomainName
	devel?:    bool | *true
	projects?: bool | *true
	admin?:    bool | *true
	inbox?:    bool
	outbox?:   bool
}

_examples: {
	scratch: #Paths.scratch & "~/scratch"
	sub:     #DomainSubdir & "devel"
	personal: #DomainTree & {name: "personal", inbox: true, outbox: true}
}
