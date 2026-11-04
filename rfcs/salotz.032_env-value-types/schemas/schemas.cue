package schemas

import rfc027 "salotz.info/rfcs/027_env-nexps:schemas"

// salotz.032_env-value-types — normative type names, policies, and tokens.
// Matching on the wire is case-insensitive; this schema validates canonical
// (and documented lowercase alias) spellings.

#TypeName: "boolean" | "enum" | "string" | "null" | "nullable-enum"

#Policy: "silent" | "warn" | "strict" | "required"

#DefaultPolicy: "warn"

#BooleanTrueToken:  "true" | "yes" | "on" | "1" | "t" | "y"
#BooleanFalseToken: "false" | "no" | "off" | "0" | "f" | "n"
#BooleanToken:      #BooleanTrueToken | #BooleanFalseToken
#BooleanCanonical:  "true" | "false"

#NullToken:     "null" | "none" | "nil"
#NullCanonical: "null"

// Canonical enum tokens SHOULD be lowercase kebab-case.
#EnumToken: string & =~"^[a-z0-9]+(-[a-z0-9]+)*$"

#Missing: "" // absent or empty string on the wire

#VariableDecl: {
	name:   rfc027.#EnvName
	type:   #TypeName
	policy: #Policy | *"warn"
	if policy != "required" {
		default: string | bool | null
	}
	values?:  [...#EnumToken]
	aliases?: {[canonical=#EnumToken]: [...string]}
}

_examples: {
	boolean: #TypeName & "boolean"
	policy:  #Policy & "warn"
	trueTok: #BooleanTrueToken & "yes"
	nullTok: #NullToken & "nil"
	enumTok: #EnumToken & "log-level"
	req:     #VariableDecl & {
		name:   "MYAPP__DATABASE_URL"
		type:   "string"
		policy: "required"
	}
	flag: #VariableDecl & {
		name:    "MYAPP__VERBOSE"
		type:    "boolean"
		policy:  "warn"
		default: false
	}
}
