package schemas

import (
	unixpath "salotz.info/unix/path"
	dirshape "salotz.info/rfcs/033_dirshape:schemas"
)

// salotz.017_bunker — user-only directory under $HOME.

// Commonly named .$USER or .$USER.d
#BunkerDirName: string & =~"^\\.[A-Za-z0-9._-]+(\\.d)?$"

#Bunker: {
	name:     #BunkerDirName
	location: unixpath.#HomeExpansionPath
}

// Injected root is the user's home directory. The bunker basename is
// operator-specific; at most one matching directory is expected.
#HomeLayoutSpec: dirshape.#LayoutSpec & {
	entries: {
		bunker: {
			name:        "^\\.[A-Za-z0-9._-]+(\\.d)?$/"
			match:       "pattern"
			presence:    "optional"
			cardinality: 1
		}
	}
}

_examples: {
	dot:  #BunkerDirName & ".salotz"
	dotd: #BunkerDirName & ".salotz.d"
	home: #Bunker & {name: ".salotz", location: "$HOME"}
	tilde: #Bunker & {name: ".salotz.d", location: "~"}
	layout: #HomeLayoutSpec
}
