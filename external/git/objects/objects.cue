package objects

import "salotz.info/std/encoding"

// Git objects: types and object names (hash identifiers).
// https://git-scm.com/docs/git-hash-object
// https://git-scm.com/docs/gitglossary
//
// `extensions.objectFormat` is `sha1` (40 hex) or `sha256` (64 hex).
// An abbreviated name is a unique leading substring (at least 4 hex
// digits). This is not a uniqueness check against a repository.

#Type: "blob" | "tree" | "commit" | "tag"

#HashAlgorithm: "sha1" | "sha256"

_hexPattern: "[0-9A-Fa-f]"

// Full object names. Hex spelling from salotz.info/std/encoding.
#SHA1:     encoding.#SHA1
#SHA256:   encoding.#SHA256
#ObjectID: #SHA1 | #SHA256

// Unique prefix; 4–63 hex. 40 hex is #SHA1, not this type.
#AbbreviatedObjectID: string & =~"^(\(_hexPattern)){4,63}$"
#AbbreviatedObjectID: !~"^(\(_hexPattern)){40}$"

// Written name: full or abbreviated.
#ObjectName: #ObjectID | #AbbreviatedObjectID

#ZeroSHA1:   "0000000000000000000000000000000000000000"
#ZeroSHA256: "0000000000000000000000000000000000000000000000000000000000000000"
#ZeroID:     #ZeroSHA1 | #ZeroSHA256

_examples: {
	kind:   #Type & "commit"
	algo:   #HashAlgorithm & "sha256"
	sha1:   #SHA1 & "dae86e1950b1277e545cee180551750029cfe735"
	sha256: #SHA256 & "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
	abbrev: #AbbreviatedObjectID & "dae86e"
	name:   #ObjectName & "dae86e1950b1277e545cee180551750029cfe735"
	zero:   #ZeroSHA1 & "0000000000000000000000000000000000000000"
	blob:   #Type & "blob"
	tree:   #Type & "tree"
	tag:    #Type & "tag"
}
