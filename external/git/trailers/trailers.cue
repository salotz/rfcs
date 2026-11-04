package trailers

// git-interpret-trailers(1) commit-message trailers.
// https://git-scm.com/docs/git-interpret-trailers
//
// A trailer is a `key: value` pair. The key is ASCII alphanumeric
// characters and hyphens. Git writes a colon plus one space. This is
// not a commit-message parser; `#Block` is the trailer list only.

_keyPattern: "[A-Za-z0-9]([A-Za-z0-9-]*[A-Za-z0-9])?"

#Key: string & =~"^\(_keyPattern)$"

// Common keys from Git itself, the Linux kernel, and GitHub.
// Unknown keys still unify with #Key.
#WellKnownKeys: [...#Key]
#WellKnownKeys: [
	"Signed-off-by",
	"Acked-by",
	"Reviewed-by",
	"Tested-by",
	"Reported-by",
	"Suggested-by",
	"Co-authored-by",
	"Helped-by",
	"Cc",
	"Fixes",
	"Link",
]

#WellKnownKey: or(#WellKnownKeys)

// Separator in `--trailer key:value` / `--trailer key=value`.
#Separator: ":" | "="

// Canonical line as interpret-trailers emits it: `key: value`.
#Line: string & =~"^\(_keyPattern): "

#TrailerStruct: {
	key:   #Key
	value: string
}

#Block: [...#TrailerStruct]
_examples: {
	key:   #Key & "Signed-off-by"
	well:  #WellKnownKey & "Co-authored-by"
	cc:    #WellKnownKey & "Cc"
	sep:   #Separator & ":"
	line:  #Line & "Signed-off-by: Alice <alice@example.com>"
	acked: #Line & "Acked-by: Bob <bob@example.com>"
	trailer: #TrailerStruct & {key: "Reviewed-by", value: "Z"}
	block: #Block & [
		{key: "Signed-off-by", value: "Alice <alice@example.com>"},
		{key: "Signed-off-by", value: "Bob <bob@example.com>"},
	]
}
