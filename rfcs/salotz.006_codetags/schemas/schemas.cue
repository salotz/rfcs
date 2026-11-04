package schemas

// salotz.006_codetags — comment tags, categories, and parsed tag form.

#Tag: string & =~"^[A-Z]+$"

#Category: "tasks" | "warnings" | "resolved" | "temporary" | "growth" | "statements" | "review"

#TaskTag:      "TODO" | "FIXME" | "TOREV" | "TODOC" | "REFACT" | "ASK"
#WarningTag:   "ALERT" | "BUG" | "HACK" | "WKRD" | "SMELL" | "UGLY" | "GOTCHA"
#ResolvedTag:  "REVD" | "WONTFIX" | "CANTFIX" | "DONTFIX"
#TemporaryTag: "DEBUG" | "QUEST"
#GrowthTag:    "STUB" | "SNIPPET" | "OPT" | "IDEA" | "TEST" | "REQ"
#StatementTag: "CREDIT" | "NOTE"
// REV appears in the review-flow examples; not listed in the category tables.
#ReviewTag: "TOREV" | "REV" | "REVD"

#StandardTag: #TaskTag | #WarningTag | #ResolvedTag | #TemporaryTag | #GrowthTag | #StatementTag | #ReviewTag

#CategoryOf: {
	tasks:      #TaskTag
	warnings:   #WarningTag
	resolved:   #ResolvedTag
	temporary:  #TemporaryTag
	growth:     #GrowthTag
	statements: #StatementTag
	review:     #ReviewTag
}

// Parsed code tag (language comment syntax is out of scope).
#Codetag: {
	tags: [...#StandardTag]
	positional?: [...string]
	keyword?: {[string]: string}
	comment?: string
}

_examples: {
	todo: #Codetag & {tags: ["TODO"], comment: "remove hard-coding"}
	multi: #Codetag & {tags: ["TODO", "GOTCHA"], comment: "copy objects first"}
	params: #Codetag & {
		tags:       ["TODO"]
		positional: ["paramA", "paramB"]
		keyword: {keyC: "paramC"}
		comment: "here is the comment"
	}
}
