package gitignore

// gitignore(5) pattern lines.
// https://git-scm.com/docs/gitignore
//
// The same language is used by `.gitignore`, `$GIT_DIR/info/exclude`,
// and `core.excludesFile`. This is not a glob matcher and not a parser
// of a raw file blob: `#File` is a list of already-split lines.
//
// fnmatch(3) + FNM_PATHNAME, `**`, and trailing-backslash invalid
// patterns are not encoded. A trailing unescaped `\` never matches
// (gitignore(5)); that case is not rejected here.

// A blank line matches nothing; it is a separator.
#Blank: string & =~"^[ \t]*$"

// A line starting with `#` is a comment. `\#` begins a pattern, not
// a comment (first character is backslash).
#Comment: string & =~"^#.*$"

// One gitignore pattern. Not a comment, not blank, no newline.
#Pattern: string & !~"[\n\r]"
#Pattern: !~"^#"
#Pattern: !~"^[ \t]*$"

// Optional `!` prefix: re-include a previously excluded path.
// `\!` is a pattern that starts with a literal `!`, not this type.
#NegatedPattern: #Pattern & =~"^!"

// Trailing `/`: match directories only (`foo/`, `doc/frotz/`).
#DirectoryPattern: #Pattern & =~"/$"

// Slash at the beginning or middle: relative to the `.gitignore`
// file (or the working-tree root for exclude sources outside the
// tree). A slash *only* at the end is `#DirectoryPattern`, not this.
#AnchoredPattern: (#Pattern & =~"^/") | (#Pattern & =~"/.")

// `**` forms from gitignore(5). Other consecutive asterisks are
// ordinary `*`.
#LeadingDoubleStarPattern:  #Pattern & =~"^\\*\\*/"
#TrailingDoubleStarPattern: #Pattern & =~"/\\*\\*$"
#MiddleDoubleStarPattern:   #Pattern & =~"/\\*\\*/"

#Line: #Blank | #Comment | #Pattern

#File: [...#Line]

_examples: {
	star:      #Pattern & "*.o"
	class:     #Pattern & "*.[oa]"
	bang:      #NegatedPattern & "!foo.html"
	dir:       #DirectoryPattern & "foo/"
	anchored:  #AnchoredPattern & "/hello.*"
	middle:    #AnchoredPattern & "doc/frotz"
	leadStar:  #LeadingDoubleStarPattern & "**/foo"
	trailStar: #TrailingDoubleStarPattern & "abc/**"
	midStar:   #MiddleDoubleStarPattern & "a/**/b"
	hashPat:   #Pattern & "\\#todo"
	bangLit:   #Pattern & "\\!important!.txt"
	comment:   #Comment & "# ignore objects and archives"
	blank:     #Blank & ""
	spaces:    #Blank & "  "
	file: #File & ["*.o", "# generated", "!foo.html", ""]
}
