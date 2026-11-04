package schemas

// salotz.017_bunker — user-only directory under $HOME.

// Commonly named .$USER or .$USER.d
#BunkerDirName: string & =~"^\\.[A-Za-z0-9._-]+(\\.d)?$"

#Bunker: {
	name:     #BunkerDirName
	location: "$HOME" | string
}

_examples: {
	dot:  #BunkerDirName & ".salotz"
	dotd: #BunkerDirName & ".salotz.d"
}
