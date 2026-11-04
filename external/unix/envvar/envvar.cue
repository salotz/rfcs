package envvar

// Environment variable names and POSIX sh parameter expansion.
//
// Names: POSIX XBD Chapter 8. Values may contain anything except NUL
// (CUE strings cannot hold NUL).
// https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap08.html
//
// Expansion: POSIX XCU 2.6.2 simple parameters only (`$name`, `${name}`).
// Operators (`${name:-word}`, `${#name}`, …), special parameters (`$?`,
// `$*`), command substitution, and arithmetic expansion are out of scope.
// Not bash/zsh.

_namePattern: "[A-Za-z_][A-Za-z0-9_]*"

// Shell identifier. Mixed case. Does not begin with a digit.
#Name: string & =~"^\(_namePattern)$"

// Names used by POSIX utilities: uppercase letters, digits, underscore;
// do not begin with a digit. Lowercase is reserved for applications.
#UtilityName: string & =~"^[A-Z_][A-Z0-9_]*$"

#Value: string

#BindingStruct: {
	name:   #Name
	value?: #Value
}

// Decomposed `$name` / `${name}`. `braces` selects the `${name}` form.
#ParameterStruct: {
	name:   #Name
	braces: bool
}

// $HOME
#DollarParameter: string & =~"^\\$\(_namePattern)$"

// ${HOME}
#BraceParameter: string & =~"^\\$\\{\(_namePattern)\\}$"

#Parameter: #DollarParameter | #BraceParameter

_examples: {
	name:    #Name & "HOME"
	mixed:   #Name & "http_proxy"
	utility: #UtilityName & "HOME"
	binding: #BindingStruct & {name: "HOME", value: "/home/salotz"}
	paramStruct: #ParameterStruct & {name: "HOME", braces: false}
	braceStruct: #ParameterStruct & {name: "PATH", braces: true}
	dollar:    #DollarParameter & "$HOME"
	brace:     #BraceParameter & "${PATH}"
	parameter: #Parameter & "$TMPDIR"
}
