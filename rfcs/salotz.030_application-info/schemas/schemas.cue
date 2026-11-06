package schemas

import (
	urlcore "salotz.info/url/core"
	dirshape "salotz.info/rfcs/033_dirshape:schemas"
)

// salotz.030_application-info — `.appinfo/meta.toml` core schema.
// Unknown top-level and per-product tables are allowed (open extensions).

#DirName:  ".appinfo"
#Filename: "meta.toml"
#Path:     ".appinfo/meta.toml"

#Version: "v0"

#Project: {
	name?:    string
	summary?: string
	uri?:     urlcore.#URL
}

// Recommended product-id form; map keys are not constrained to this.
#ProductID: string & =~"^[a-z0-9]+(-[a-z0-9]+)*$"

#Product: {
	name?:        string
	command?:     string
	summary?:     string
	description?: string
	uri?:         urlcore.#URL
	...
}

#AppInfo: {
	version?: #Version
	project?: #Project
	products?: {[string]: #Product}
	...
}

// Injected root is the application project root. Required when the
// convention is adopted.
#AppInfoLayoutSpec: dirshape.#LayoutSpec & {
	entries: {
		appinfo: {
			name: ".appinfo/"
			children: {
				meta: {name: #Filename}
			}
		}
	}
}

_examples: {
	layout: #AppInfoLayoutSpec
	doc: #AppInfo & {
		version: "v0"
		project: {
			name:    "wumpus"
			summary: "Wumpus client and API tooling"
			uri:     "https://example.com/wumpus"
		}
		products: {
			"wumpus-cli": {
				name:    "wumpus CLI"
				command: "wumpus"
				summary: "CLI client for wumpus"
			}
			"wumpus-api": {
				name:    "wumpus API server"
				command: "wumpus-api"
				summary: "HTTP API server for wumpus"
			}
		}
	}
}
