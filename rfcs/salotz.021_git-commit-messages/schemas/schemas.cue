package schemas

// salotz.021_git-commit-messages — WIP marker, issue trailers, domains.

#WIPPrefix: "wip!"
#WIPSubject: string & =~"^wip!.*"
#WIPTrailerValue: "true"

#IssueTrailerKey: "Completes" | "Progresses" | "References"

// namespace/.../id — at least one namespace and a final ID (e.g. github/issues/123, jira/345).
#IssueRef: string & =~"^[^/[:space:]]+/[^/[:space:]]+(/[^/[:space:]]+)*$"

#StandardDomain: "src" | "docs" | "style" | "metadata" | "build" | "tests" | "deployment" | "artifacts"

// Projects MAY define additional domains that do not conflict with #StandardDomain.
#Domain: string

#Trailers: {
	WIP?:         #WIPTrailerValue
	Completes?:   [...#IssueRef]
	Progresses?:  [...#IssueRef]
	References?:  [...#IssueRef]
	Domain?:      [...#Domain]
}

#Commit: {
	subject:   string
	wip?:      bool
	trailers?: #Trailers
}

_examples: {
	wip:     #WIPSubject & "wip! some work to start on new feature"
	github:  #IssueRef & "github/issues/123"
	jira:    #IssueRef & "jira/345"
	domain:  #StandardDomain & "src"
	trailer: #Trailers & {Completes: ["github/issues/123"], Domain: ["src"]}
}
