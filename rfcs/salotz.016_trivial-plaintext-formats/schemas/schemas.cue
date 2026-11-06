package schemas

import dirshape "salotz.info/rfcs/033_dirshape:schemas"

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
	items: [...string]
}

// Files whose names end in .list / .str, relative to one injected root.
#PlaintextLayoutSpec: dirshape.#LayoutSpec & {
	entries: {
		list: {
			name:     "*.list"
			match:    "glob"
			presence: "optional"
		}
		str: {
			name:     "*.str"
			match:    "glob"
			presence: "optional"
		}
	}
}

_examples: {
	list: #ListFile & {items: ["alpha", "beta"]}
	line: #ListLine & {separator: ",", items: ["1", "2", "3", "hello"]}
	str:    #StringFile & "just a string"
	layout: #PlaintextLayoutSpec
}
