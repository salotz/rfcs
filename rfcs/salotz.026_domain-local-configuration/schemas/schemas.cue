package schemas

import dirshape "salotz.info/rfcs/033_dirshape:schemas"

// salotz.026_domain-local-configuration — shared host-local `.local` dirs.

#LocalDirName: ".local"

#Layout: {
	parentLocal: #LocalDirName
	// Project-specific config is nested under the parent `.local` using
	// the primary project folder name (shared by worktrees).
	projectName: string
}

// Injected root is the parent of the project folders (e.g. ~/projects).
#ParentLayoutSpec: dirshape.#LayoutSpec & {
	entries: {
		local: {
			name: ".local/"
			children: {
				project: {
					name:     "*/"
					match:    "glob"
					presence: "optional"
				}
			}
		}
	}
}

_examples: {
	dir: #LocalDirName & ".local"
	layout: #Layout & {parentLocal: ".local", projectName: "widgets"}
	spec: #ParentLayoutSpec
}
