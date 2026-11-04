package revisions

import (
	"salotz.info/git/objects"
	"salotz.info/git/refs"
)

// gitrevisions(7): names for objects and revision ranges.
// https://git-scm.com/docs/gitrevisions
//
// Not a parser of the full extended SHA-1 grammar. `#Revision` is a
// single-object spelling (no `..` range). `#Range` is a set of commits.
// Nested suffixes (`origin/main~2^{commit}`) are allowed by the loose
// `#Revision` constraint; the tighter types match common surface forms.

#SHA1:                objects.#SHA1
#SHA256:              objects.#SHA256
#ObjectID:            objects.#ObjectID
#AbbreviatedObjectID: objects.#AbbreviatedObjectID
#ObjectName:          objects.#ObjectName

#HEAD: refs.#HEAD
#At:   "@"

#PseudoRef:
	#HEAD |
	"FETCH_HEAD" | "ORIG_HEAD" | "MERGE_HEAD" | "REBASE_HEAD" |
	"REVERT_HEAD" | "CHERRY_PICK_HEAD" | "BISECT_HEAD" | "AUTO_MERGE"

_upstreamWordPattern: "([uU][pP][sS][tT][rR][eE][aA][mM]|[uU])"
_pushWordPattern:     "([pP][uU][sS][hH]|[pP])"

// `master@{1}`, `@{1}`.
#ReflogOrdinal: string & =~"^([^@\n]+)?@\\{[0-9]+\\}$"

// `master@{yesterday}`, `HEAD@{1979-02-26 18:30:00}`. Not a date parser.
#AtDate: string & =~"@\\{.+}$"

// `@{-1}`: nth previously checked-out branch/commit.
#NthCheckout: string & =~"^@\\{-[0-9]+\\}$"

// `master@{upstream}`, `@{u}`. Case-insensitive word.
#Upstream: string & =~"^([^@\n]+)?@\\{\(_upstreamWordPattern)\\}$"

// `master@{push}`, `@{p}`.
#Push: string & =~"^([^@\n]+)?@\\{\(_pushWordPattern)\\}$"

// `v1.7.4.2-679-g3bee7fb`, optional `-dirty` / `-broken`.
#DescribeOutput: string & =~"-[0-9]+-g[0-9a-fA-F]{4,}(-dirty|-broken)?$"

// `HEAD^`, `HEAD^2`. Not `^{…}`, `^@`, `^!`, `^-`.
#Parent: (string & =~"\\^[0-9]+$") | (string & =~"\\^$")

// `master~3`, `HEAD~`.
#Ancestor: string & =~"~[0-9]*$"

// `v0.99.8^{commit}`, `v0.99.8^{}`, `HEAD^{/fix nasty bug}`.
#Peel: string & =~"\\^\\{[^}]*\\}$"

// `:/fix nasty bug`.
#MessageSearch: string & =~"^:/"

// `HEAD:README`, `master:./README`.
#TreePath: string & =~"^[^:\n]+:"

// `:README`, `:0:README` … `:3:README`. Not `:/…`.
#IndexPath: string & =~"^:([0-3]:)?"
#IndexPath: !~"^:/"
#IndexPath: !~"^:$"

// Single-object name. Dotted ranges are `#Range`. Spaces appear in
// `^{/text}` and reflog dates; newlines do not.
#Revision: string & !="" & !~"[\n\r]"
#Revision: !~"\\.\\."

// `^main` — exclude commits reachable from the rev.
#Exclude: string & =~"^\\^" & !~"[\n\r]"

// `main..topic`, `origin..`, `..origin`.
#TwoDotRange: string & =~"\\.\\." & !~"\\.\\.\\." & !~"[\n\r]"

// `main...topic` (symmetric difference).
#ThreeDotRange: string & =~"\\.\\.\\." & !~"[\n\r]"

// `HEAD^@` — all parents.
#AllParents: string & =~"\\^@$" & !~"[\n\r]"

// `HEAD^!` — the commit, excluding its parents.
#CommitOnly: string & =~"\\^!$" & !~"[\n\r]"

// `HEAD^-`, `HEAD^-2` — exclude the nth parent.
#ExcludeNthParent: string & =~"\\^-[0-9]*$" & !~"[\n\r]"

#Range:
	#Exclude |
	#TwoDotRange |
	#ThreeDotRange |
	#AllParents |
	#CommitOnly |
	#ExcludeNthParent

// `from` / `to` omitted for `..topic` / `main..`.
#TwoDotRangeStruct: {
	from?: #Revision
	to?:   #Revision
}

#ThreeDotRangeStruct: {
	a?: #Revision
	b?: #Revision
}

#TreePathStruct: {
	revision: #Revision
	path:     string
}

#IndexPathStruct: {
	stage?: 0 | 1 | 2 | 3
	path:   string
}
_examples: {
	sha:       #SHA1 & "dae86e1950b1277e545cee180551750029cfe735"
	abbrev:    #AbbreviatedObjectID & "dae86e"
	head:      #HEAD & "HEAD"
	at:        #At & "@"
	pseudo:    #PseudoRef & "MERGE_HEAD"
	ref:       #Revision & "main"
	qualified: #Revision & "refs/heads/main"
	parent:    #Parent & "HEAD^"
	parent2:   #Parent & "HEAD^2"
	tilde:     #Ancestor & "master~3"
	peel:      #Peel & "v0.99.8^{commit}"
	peelEmpty: #Peel & "v0.99.8^{}"
	peelMsg:   #Peel & "HEAD^{/fix nasty bug}"
	upstream:  #Upstream & "@{upstream}"
	u:         #Upstream & "@{u}"
	push:      #Push & "master@{push}"
	nth:       #ReflogOrdinal & "master@{1}"
	prev:      #NthCheckout & "@{-1}"
	when:      #AtDate & "master@{yesterday}"
	describe:  #DescribeOutput & "v1.7.4.2-679-g3bee7fb"
	dirty:     #DescribeOutput & "v1.7.4.2-679-g3bee7fb-dirty"
	msg:       #MessageSearch & ":/fix nasty bug"
	treePath:  #TreePath & "HEAD:README"
	index:     #IndexPath & ":0:README"
	stage0:    #IndexPath & ":README"
	two:       #TwoDotRange & "main..topic"
	omit:      #TwoDotRange & "origin.."
	three:     #ThreeDotRange & "main...topic"
	twoStruct: #TwoDotRangeStruct & {from: "main", to: "topic"}
	omitStruct: #TwoDotRangeStruct & {from: "origin"}
	threeStruct: #ThreeDotRangeStruct & {a: "main", b: "topic"}
	treeStruct: #TreePathStruct & {revision: "HEAD", path: "README"}
	indexStruct: #IndexPathStruct & {stage: 0, path: "README"}
	exclude: #Exclude & "^main"
	parents: #AllParents & "HEAD^@"
	only:    #CommitOnly & "HEAD^!"
	minus:   #ExcludeNthParent & "HEAD^-"
}
