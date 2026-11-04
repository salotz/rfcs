package schemas

// salotz.026_domain-local-configuration — shared host-local `.local` dirs.

#LocalDirName: ".local"

#Layout: {
	parentLocal: #LocalDirName
	// Project-specific config is nested under the parent `.local` using
	// the primary project folder name (shared by worktrees).
	projectName: string
}

_examples: {
	dir:    #LocalDirName & ".local"
	layout: #Layout & {parentLocal: ".local", projectName: "widgets"}
}
