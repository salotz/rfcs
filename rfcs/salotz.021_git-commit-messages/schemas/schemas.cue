package schemas

import trailers "salotz.info/git/trailers"

// salotz.021_git-commit-messages — WIP marker, issue trailers, domains.

#WIPPrefix:       "wip!"
#WIPSubject:      string & =~"^wip!.*"
#WIPTrailerValue: "true"
#WIPTrailerKey:   trailers.#Key & "WIP"
#IssueTrailerKey: trailers.#Key & ("Completes" | "Progresses" | "References")

// namespace/.../id — at least one namespace and a final ID (e.g. github/issues/123, jira/345).
#IssueRef: string & =~"^[^/[:space:]]+/[^/[:space:]]+(/[^/[:space:]]+)*$"

#StandardDomain: "src" | "docs" | "style" | "metadata" | "build" | "tests" | "deployment" | "artifacts"

// Projects MAY define additional domains that do not conflict with #StandardDomain.
#Domain: string

#WIPTrailer: trailers.#TrailerStruct & {
	key:   #WIPTrailerKey
	value: #WIPTrailerValue
}

#CompletesTrailer: trailers.#TrailerStruct & {
	key:   "Completes"
	value: #IssueRef
}

#ProgressesTrailer: trailers.#TrailerStruct & {
	key:   "Progresses"
	value: #IssueRef
}

#ReferencesTrailer: trailers.#TrailerStruct & {
	key:   "References"
	value: #IssueRef
}

#DomainTrailer: trailers.#TrailerStruct & {
	key:   trailers.#Key & "Domain"
	value: #Domain
}

// Parsed git trailers. Keys are repeatable except WIP.
#Trailers: {
	WIP?: #WIPTrailerValue
	Completes?: [...#IssueRef]
	Progresses?: [...#IssueRef]
	References?: [...#IssueRef]
	Domain?: [...#Domain]
}

#Commit: {
	subject:   string
	wip?:      bool
	trailers?: #Trailers
}

_examples: {
	wip:    #WIPSubject & "wip! some work to start on new feature"
	github: #IssueRef & "github/issues/123"
	jira:   #IssueRef & "jira/345"
	domain: #StandardDomain & "src"
	trailer: #Trailers & {Completes: ["github/issues/123"], Domain: ["src"]}
	wipT: #WIPTrailer & {key: "WIP", value: "true"}
	compT: #CompletesTrailer & {key: "Completes", value: "github/issues/123"}
	key: #IssueTrailerKey & "Progresses"
}
