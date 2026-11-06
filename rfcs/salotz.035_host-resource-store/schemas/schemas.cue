package schemas

import (
	unixpath "salotz.info/unix/path"
	envvar "salotz.info/unix/envvar"
	dirshape "salotz.info/rfcs/033_dirshape:schemas"
)

// salotz.035_host-resource-store — store and resource directories.
// Prose: ../README.md
//
// Encodes the specification only (kinds, env vars, defaults, snapshot
// advice). Drive names, dataset names, and catalogs are additional
// suggestions and are not types here.

#XDGXVar: envvar.#UtilityName & (
		"XDGX_STORE_HOME" | "XDGX_RESOURCE_HOME")

#Kind: "store" | "resource"

#Role: "physical" | "logical"

#Directory: {
	kind:     #Kind
	role:     #Role
	default:  unixpath.#HomeRelativePath
	env:      #XDGXVar
	snapshot: bool
}

#Defaults: {
	store: #Directory & {
		kind:     "store"
		role:     "physical"
		default:  "~/.local/store"
		env:      "XDGX_STORE_HOME"
		snapshot: false
	}
	resource: #Directory & {
		kind:     "resource"
		role:     "logical"
		default:  "~/.local/resources"
		env:      "XDGX_RESOURCE_HOME"
		snapshot: true
	}
}

// Default grouping under ~/.local. Each kind may be relocated via its
// XDGX_* override; check those roots separately.
#LocalLayoutSpec: dirshape.#LayoutSpec & {
	entries: {
		store: {name: "store/", presence: "optional"}
		resources: {name: "resources/", presence: "optional"}
	}
}

_examples: {
	storeEnv: #XDGXVar & "XDGX_STORE_HOME"
	resEnv:   #XDGXVar & "XDGX_RESOURCE_HOME"
	store:    #Defaults.store
	resource: #Defaults.resource
	layout:   #LocalLayoutSpec
}
