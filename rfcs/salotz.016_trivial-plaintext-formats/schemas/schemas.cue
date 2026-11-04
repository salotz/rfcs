package schemas

// salotz.016_trivial-plaintext-formats — .list / .str files and list lines.

#ListExtension:   "list"
#StringExtension: "str"

#ListLineSeparator: "," | ":"

// Parsed .list file: newline-separated items. '#' comments are stripped
// before this view.
#ListFile: {
	items: [...string]
}

// A .str file is exactly one string (the file contents as-is).
#StringFile: string

// A single list line split on the chosen separator.
#ListLine: {
	separator: #ListLineSeparator | *","
	items:     [...string]
}

_examples: {
	list: #ListFile & {items: ["alpha", "beta"]}
	line: #ListLine & {separator: ",", items: ["1", "2", "3", "hello"]}
	str:  #StringFile & "just a string"
}
