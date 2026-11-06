package schemas

// salotz.033_dirshape — directory and filename layout requirements.
//
// Two layers (RFC 033):
//
//	#LayoutSpec / #NodeSpec  — what authors write (defaults, multi-segment names)
//	#Layout    / #Node       — fully expanded IL (no defaults, one-segment names)
//
// Expansion spec → IL is a compiler/tool, not CUE unification of these
// types. A filesystem walk emits IL. v1 checkers interpret `match: "exact"`
// only; extra files on disk are allowed. One injected root; `entries` are
// its children. The layout struct is open for future metadata (anchor, …).
//
// Spec directory `name` MUST end in `/`. IL `name` never has a slash
// (one `readdir` segment, or the glob/pattern string). Map keys on IL
// equal `name`. Spec `entries` / `children` keys are author labels only.

#KindNames: ["file", "directory"]
#Kind: or(#KindNames)

#PresenceNames: ["required", "optional"]
#Presence: or(#PresenceNames)

#MatchNames: ["exact", "glob", "pattern"]
#Match: or(#MatchNames)

// Unique match (`1`) or unbounded (`"many"`). Later: other positive ints.
#Cardinality: 1 | "many"

// Spec `name`: POSIX relative path. Components separated by `/`.
// Directory names MUST end in `/` (not part of the IL name).
// Rejects empty, absolute, empty components, and `.` / `..` components.
#NodeSpecName: string & =~"^[^/]+(/[^/]+)*/?$" & !~"(^|/)\\.\\.?(/|$)"

// IL `name`: one path segment (literal basename, or the glob/pattern string).
#NodeName: string & =~"^[^/]+$" & !~"^\\.\\.?$"

// Author frontend. Defaults apply only here.
//
//	kind         — "file", unless trailing `/` on name or `children` is present
//	presence     — "required"
//	match        — "exact"
//	cardinality  — 1 when match is exact; "many" when glob or pattern
//	children     — omitted
//
// `name` may contain `/`. Preceding components are implicit directories
// (compiler). Child names are relative to this node. Labels on `entries`
// / `children` are not the on-disk name and are dropped in IL.
//
// Authors SHOULD set `match: "glob"` when this node's last segment is a
// glob. A compiler MAY infer `glob` from `*`, `?`, or `[` in a segment.
// It MUST NOT infer `pattern`. Brace groups (`{a,b}`) are spec sugar a
// compiler expands to sibling leaves; these types do not expand them.
#NodeSpec: {
	name:     #NodeSpecName
	kind:     #Kind | *"file"
	presence: #Presence | *"required"
	match:    #Match | *"exact"
	children?: {[string]: #NodeSpec}

	if name =~ "/$" {
		kind: "directory"
	}
	if children != _|_ {
		kind: "directory"
	}
	if kind == "directory" {
		name: =~"/$"
	}
	if kind == "file" {
		name: !~"/$"
	}
	if match == "exact" {
		cardinality: 1
	}
	if match != "exact" {
		cardinality: #Cardinality | *"many"
	}
}

#LayoutSpec: {
	entries: {[string]: #NodeSpec}
	...
}

// Fully expanded node. No defaults. No `/` in `name`. No trailing slash.
// For every `match`, the key in the parent map equals `name`.
#Node: {
	name:        #NodeName
	kind:        #Kind
	presence:    #Presence
	match:       #Match
	cardinality: #Cardinality

	if match == "exact" {
		cardinality: 1
	}
	if kind == "directory" {
		children?: [key=string]: #Node & {name: key}
	}
}

#Layout: {
	entries: [key=string]: #Node & {name: key}
	...
}

_examples: {
	shorthandFile: #NodeSpec & {
		name: ".config/myconfig/meta.toml"
	}
	shorthandDir: #NodeSpec & {
		name: ".config/myconfig/"
	}
	childrenForceDir: #NodeSpec & {
		name: "design/"
		children: {
			decisions: {name: "decisions/"}
		}
	}
	optionalFile: #NodeSpec & {
		name:     "NOTES.md"
		presence: "optional"
	}
	globLeaf: #NodeSpec & {
		name:  "*.md"
		match: "glob"
	}
	globOne: #NodeSpec & {
		name:        "*.config.toml"
		match:       "glob"
		presence:    "optional"
		cardinality: 1
	}
	globDir: #NodeSpec & {
		name:  "specs/*/"
		match: "glob"
	}
	// Mid-path glob: last segment is exact; compiler marks `*` as glob.
	midGlob: #NodeSpec & {
		name: "specs/*/spec.toml"
	}
	patternLeaf: #NodeSpec & {
		name:  "^[0-9]+_.+\\.md$"
		match: "pattern"
	}
	fullFile: #NodeSpec & {
		name:        "meta.toml"
		kind:        "file"
		presence:    "required"
		match:       "exact"
		cardinality: 1
	}

	specCompact: #LayoutSpec & {
		entries: {
			meta: {name: ".config/myconfig/meta.toml"}
		}
	}
	specFull: #LayoutSpec & {
		entries: {
			myconfig: {
				name:        ".config/myconfig/"
				kind:        "directory"
				presence:    "required"
				match:       "exact"
				cardinality: 1
				children: {
					meta: {
						name:        "meta.toml"
						kind:        "file"
						presence:    "required"
						match:       "exact"
						cardinality: 1
					}
				}
			}
		}
	}
	appinfo: #LayoutSpec & {
		entries: {
			appinfo: {
				name: ".appinfo/"
				children: {
					meta: {name: "meta.toml"}
				}
			}
		}
	}
	empty: #LayoutSpec & {
		entries: {}
	}

	ilExpanded: #Layout & {
		entries: {
			".config": {
				name:        ".config"
				kind:        "directory"
				presence:    "required"
				match:       "exact"
				cardinality: 1
				children: {
					myconfig: {
						name:        "myconfig"
						kind:        "directory"
						presence:    "required"
						match:       "exact"
						cardinality: 1
						children: {
							"meta.toml": {
								name:        "meta.toml"
								kind:        "file"
								presence:    "required"
								match:       "exact"
								cardinality: 1
							}
						}
					}
				}
			}
		}
	}
	ilGlob: #Layout & {
		entries: {
			"*": {
				name:        "*"
				kind:        "file"
				presence:    "optional"
				match:       "glob"
				cardinality: "many"
			}
		}
	}
	ilGlobOne: #Layout & {
		entries: {
			"*.config.toml": {
				name:        "*.config.toml"
				kind:        "file"
				presence:    "optional"
				match:       "glob"
				cardinality: 1
			}
		}
	}
	ilMidGlob: #Layout & {
		entries: {
			specs: {
				name:        "specs"
				kind:        "directory"
				presence:    "required"
				match:       "exact"
				cardinality: 1
				children: {
					"*": {
						name:        "*"
						kind:        "directory"
						presence:    "required"
						match:       "glob"
						cardinality: "many"
						children: {
							"spec.toml": {
								name:        "spec.toml"
								kind:        "file"
								presence:    "required"
								match:       "exact"
								cardinality: 1
							}
						}
					}
				}
			}
		}
	}
	ilEmptyDir: #Layout & {
		entries: {
			".agents": {
				name:        ".agents"
				kind:        "directory"
				presence:    "required"
				match:       "exact"
				cardinality: 1
			}
		}
	}
}
