package refs

// Git ref names (git-check-ref-format), not revisions (gitrevisions(7)).
// SHAs, ranges (`main..topic`), and `HEAD~1` are in the revisions
// package. This package is names: branches, remotes,
// `origin/branch-name`, and `refs/heads/…`.
//
// The full check-ref-format grammar is not encoded. These patterns
// reject empty names, `..`, `//`, and a handful of illegal characters.

_remoteNamePattern: "[A-Za-z0-9._][A-Za-z0-9._-]*"
_refNamePattern:    "[A-Za-z0-9._][A-Za-z0-9._/-]*"

// Remote name (`origin`). No slash.
#RemoteName: string & =~"^\(_remoteNamePattern)$"

// Hierarchical ref name (`feat/foo`, `main`). Not `refs/heads/…`.
#RefName: string & =~"^\(_refNamePattern)$"
#RefName: !~"//"
#RefName: !~"\\.\\."

// Short branch name. Same charset as #RefName.
#BranchName: #RefName

// Remote-tracking shorthand: origin/main, origin/feat/foo.
#RemoteTracking: string & =~"^\(_remoteNamePattern)/\(_refNamePattern)$"
#RemoteTracking: !~"//"
#RemoteTracking: !~"\\.\\."

#RemoteTrackingStruct: {
	remote: #RemoteName
	name:   #RefName
}

#RemotesRefStruct: {
	remote: #RemoteName
	name:   #RefName
}
#HEAD: "HEAD"

#HeadsRef:   string & =~"^refs/heads/\(_refNamePattern)$"
#TagsRef:    string & =~"^refs/tags/\(_refNamePattern)$"
#RemotesRef: string & =~"^refs/remotes/\(_remoteNamePattern)/\(_refNamePattern)$"

#QualifiedRef: #HeadsRef | #TagsRef | #RemotesRef

_examples: {
	remote:   #RemoteName & "origin"
	branch:   #BranchName & "feat/foo"
	main:     #BranchName & "main"
	tracking: #RemoteTracking & "origin/main"
	nested:   #RemoteTracking & "origin/feat/foo"
	trackStruct: #RemoteTrackingStruct & {
		remote: "origin"
		name:   "main"
	}
	remotesStruct: #RemotesRefStruct & {
		remote: "origin"
		name:   "feat/foo"
	}
	head:    #HEAD & "HEAD"
	heads:   #HeadsRef & "refs/heads/feat/foo"
	tags:    #TagsRef & "refs/tags/v1.0.0"
	remotes: #RemotesRef & "refs/remotes/origin/main"
}
