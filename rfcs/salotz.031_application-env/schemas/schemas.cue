package schemas

import (
	rfc027 "salotz.info/rfcs/027_env-nexps:schemas"
	rfc030 "salotz.info/rfcs/030_application-info:schemas"
	rfc032 "salotz.info/rfcs/032_env-value-types:schemas"
)

// salotz.031_application-env — env registry tables on RFC 030 appinfo docs.

#AppInfoLayoutSpec: rfc030.#AppInfoLayoutSpec

#TypeName: rfc032.#TypeName
#Policy:   rfc032.#Policy

#DefaultValue: bool | string | number

#DefaultTable: {
	value:       #DefaultValue
	resolution?: string
} | {
	resolution: string
	value?:     #DefaultValue
}

#Default: #DefaultValue | #DefaultTable

// Prefix without a trailing dunder (WUMPUS, not WUMPUS__).
#EnvPrefix: rfc027.#EnvName & !~"__$"

#EnvVar: {
	description:       string
	long_description?: string
	type?:             #TypeName
	policy:            #Policy | *"warn"
	external?:         bool
	groups?: [...string] | string
	values?: [...string]
	aliases?: {[canonical=string]: [...string]}
	if policy != "required" {
		default?: #Default
	}
}

#EnvTable: {
	env_prefix?: #EnvPrefix
	vars?: {[name=rfc027.#EnvName]: #EnvVar}
}

#Product: rfc030.#Product & {
	env?: #EnvTable
}

#AppInfo: rfc030.#AppInfo & {
	env?: #EnvTable
	products?: {[string]: #Product}
}

_examples: {
	prefix: #EnvPrefix & "WUMPUS"
	flag: #EnvVar & {
		description: "Extra stderr chatter."
		type:        "boolean"
		policy:      "warn"
		default:     false
	}
	required: #EnvVar & {
		description: "Database connection URI."
		type:        "string"
		policy:      "required"
	}
	resolved: #EnvVar & {
		description: "Path to the wumpus catalog config file."
		type:        "string"
		default: {resolution: "Uses ${XDG_CONFIG_HOME}/wumpus/catalog.toml when available."}
	}
	layout: #AppInfoLayoutSpec
	doc: #AppInfo & {
		version: "v0"
		env: {
			env_prefix: "WUMPUS"
			vars: {
				WUMPUS__VERBOSE: {
					description: "Extra stderr chatter."
					type:        "boolean"
					default:     false
				}
			}
		}
	}
}
