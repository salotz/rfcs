package pathspec

import "salotz.info/git/attributes"

// Pathspec (gitglossary(7) “pathspec”).
// https://git-scm.com/docs/gitglossary#Documentation/glossary-content.txt-aiddefpathspecapathspec
//
// A pathspec is a path, a glob, or a magic `:` form. This is not a
// matcher. `:` alone means “there is no pathspec”.

// Long-form magic words inside `:(…)`. `attr` takes a following
// `:` and requirements, so it is not in this closed set.
#MagicWord: "top" | "literal" | "icase" | "glob" | "exclude"

#LongMagicWord: #MagicWord | "attr"

#MagicWords: [...#MagicWord]
#MagicWords: ["top", "literal", "icase", "glob", "exclude"]

// Short-form signature letters: `/` = top, `!` / `^` = exclude.
#ShortMagic: "/" | "!" | "^"

// `:(attr:…)` requirements are gitattributes settings.
#AttributeRequirement: attributes.#Setting

// Any non-empty pathspec string, including magic forms. No newline.
#Pathspec: string & !="" & !~"[\n\r]"

// `:` — empty pathspec, not combined with others.
#Empty: ":"

// `:(glob)Documentation/*.html`, `:(top,literal)foo`.
#LongForm: #Pathspec & =~"^:\\("

// `:!foo`, `:/Documentation`, `:^bar`. Optional terminating colon
// before the pattern.
#ShortForm: #Pathspec & =~"^:[/!^]"

#Top:        #Pathspec & (=~"^:\\(top\\)" | =~"^:/")
#Literal:    #Pathspec & =~"^:\\(literal\\)"
#IgnoreCase: #Pathspec & =~"^:\\(icase\\)"
#Glob:       #Pathspec & =~"^:\\(glob\\)"
#Exclude:    #Pathspec & (=~"^:\\(exclude\\)" | =~"^:[!^]")
#Attribute:  #Pathspec & =~"^:\\(attr:"

// Decomposed pathspec. `path` is the pattern after magic. `attr`
// is only used with attribute magic.
#PathspecStruct: {
	magic: [...#LongMagicWord]
	attr?: [...#AttributeRequirement]
	path: string
}

// No leading magic. `*` and `?` may match `/` (fnmatch without
// FNM_PATHNAME) unless glob magic is used.
#Plain: #Pathspec & !~"^:"

_examples: {
	plain:    #Plain & "Documentation/*.jpg"
	empty:    #Empty & ":"
	longGlob: #Glob & ":(glob)Documentation/*.html"
	longTop:  #Top & ":(top)README"
	shortTop: #Top & ":/README"
	exclude:  #Exclude & ":(exclude)*.o"
	bang:     #Exclude & ":!*.o"
	caret:    #Exclude & ":^*.o"
	literal:  #Literal & ":(literal)foo*"
	icase:    #IgnoreCase & ":(icase)readme"
	attr:     #Attribute & ":(attr:text eol=lf)*.c"
	combo:    #LongForm & ":(top,glob)src/**/*.go"
	req:      #AttributeRequirement & "-text"
	word:     #MagicWord & "glob"
	specStruct: #PathspecStruct & {
		magic: ["top", "glob"]
		path: "src/**/*.go"
	}
	attrStruct: #PathspecStruct & {
		magic: ["attr"]
		attr: ["text", "eol=lf"]
		path: "*.c"
	}
}
