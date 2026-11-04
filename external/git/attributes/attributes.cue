package attributes

import "salotz.info/git/gitignore"

// gitattributes(5) path attributes.
// https://git-scm.com/docs/gitattributes
//
// On-disk lines are `pattern attr1 attr2 …`. `#File` is the parsed
// form, not a raw blob. Patterns follow gitignore(5) with two
// exceptions: negative patterns are forbidden, and a trailing `/`
// does not recurse into the directory (`path/**` instead).
//
// `builtin_*` is reserved. Macro attributes are Set-only.

_attributeNamePattern: "[A-Za-z0-9._][A-Za-z0-9._-]*"

#Blank:   gitignore.#Blank
#Comment: gitignore.#Comment

// Path pattern. Same charset as gitignore.#Pattern, no `!` prefix.
#Pattern: gitignore.#Pattern & !~"^!"

// Attribute name (git `attr_name_valid`): alphanumeric, `.`, `_`,
// `-`; not empty; does not start with `-`.
#Name: string & =~"^\(_attributeNamePattern)$"

// The four states on a path (gitattributes(5) DESCRIPTION).
#SetAttribute:         #Name
#UnsetAttribute:       string & =~"^-\(_attributeNamePattern)$"
#UnspecifiedAttribute: string & =~"^!\(_attributeNamePattern)$"
#ValueAttribute:       string & =~"^\(_attributeNamePattern)=[^ \t]+$"

#Setting:
	#SetAttribute |
	#UnsetAttribute |
	#UnspecifiedAttribute |
	#ValueAttribute

// Decomposed setting. `value` is set only when `state` is `"value"`.
#SettingStruct: {
	name:   #Name
	state:  "set" | "unset" | "unspecified" | "value"
	value?: string
}

#BuiltinNames: [...#Name]
#BuiltinNames: [
	"text", "eol", "crlf", "ident", "filter", "diff", "merge",
	"whitespace", "export-ignore", "export-subst", "delta",
	"encoding", "working-tree-encoding", "builtin_objectmode",
]

#BuiltinName: or(#BuiltinNames)

// Built-in macro: `binary` ≡ `-diff -merge -text`.
#BuiltinMacro: "binary"

#ReservedPrefix: "builtin_"
#ReservedName:   #Name & =~"^builtin_"

#TextValue: "auto"
#EOLValue:  "lf" | "crlf"

#AssignmentStruct: {
	pattern: #Pattern
	attributes: [...#Setting]
}

// `[attr]name` in a top-level attributes file.
#MacroDefinitionStruct: {
	name: #Name
	attributes: [...#Setting]
}

#Line: #Blank | #Comment | #AssignmentStruct | #MacroDefinitionStruct
#File: [...#Line]

_examples: {
	name:     #Name & "text"
	builtin:  #BuiltinName & "eol"
	macro:    #BuiltinMacro & "binary"
	reserved: #ReservedName & "builtin_objectmode"
	set:      #SetAttribute & "ident"
	unset:    #UnsetAttribute & "-text"
	unspec:   #UnspecifiedAttribute & "!diff"
	value:    #ValueAttribute & "eol=lf"
	auto:     #ValueAttribute & "text=auto"
	filter:   #ValueAttribute & "filter=lfs"
	pat:      #Pattern & "*.jpg"
	starDir:  #Pattern & "path/**"
	assignment: #AssignmentStruct & {
		pattern: "*.jpg"
		attributes: ["binary"]
	}
	macroDef: #MacroDefinitionStruct & {
		name: "binary"
		attributes: ["-diff", "-merge", "-text"]
	}
	settingSet: #SettingStruct & {
		name:  "ident"
		state: "set"
	}
	settingVal: #SettingStruct & {
		name:  "eol"
		state: "value"
		value: "lf"
	}
	comment: #Comment & "# generated"
	file: #File & [
		"# images",
		{
			pattern: "*.jpg"
			attributes: ["binary"]
		},
		{
			pattern: "*.sh"
			attributes: ["text", "eol=lf"]
		},
	]
}
