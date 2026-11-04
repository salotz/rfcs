package schemas

// salotz.030_application-info — `.appinfo/meta.toml` core schema.
// Unknown top-level and per-product tables are allowed (open extensions).

#DirName:  ".appinfo"
#Filename: "meta.toml"
#Path:     ".appinfo/meta.toml"

#Version: "v0"

#Project: {
	name?:    string
	summary?: string
	uri?:     string
}

// Recommended product-id form; map keys are not constrained to this.
#ProductID: string & =~"^[a-z0-9]+(-[a-z0-9]+)*$"

#Product: {
	name?:        string
	command?:     string
	summary?:     string
	description?: string
	uri?:         string
	...
}

#AppInfo: {
	version?:  #Version
	project?:  #Project
	products?: {[string]: #Product}
	...
}

_examples: {
	doc: #AppInfo & {
		version: "v0"
		project: {name: "wumpus", summary: "Wumpus client and API tooling"}
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
