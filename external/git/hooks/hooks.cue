package hooks

// githooks(5) hook program names.
// https://git-scm.com/docs/githooks
//
// Names as installed under `$GIT_DIR/hooks` or `core.hooksPath`.
// Git ignores a hook whose executable bit is not set. Template copies
// often have a `.sample` suffix; that suffix is not part of `#Name`.

#Names: [...string]
#Names: [
	"applypatch-msg",
	"pre-applypatch",
	"post-applypatch",
	"pre-commit",
	"pre-merge-commit",
	"prepare-commit-msg",
	"commit-msg",
	"post-commit",
	"pre-rebase",
	"post-checkout",
	"post-merge",
	"pre-push",
	"pre-receive",
	"update",
	"proc-receive",
	"post-receive",
	"post-update",
	"reference-transaction",
	"receive-report",
	"push-to-checkout",
	"pre-auto-gc",
	"post-rewrite",
	"sendemail-validate",
	"fsmonitor-watchman",
	"p4-changelist",
	"p4-prepare-changelist",
	"p4-post-changelist",
	"p4-pre-submit",
	"post-index-change",
]

#Name: or(#Names)

#SampleSuffix: ".sample"
#SampleName:   string & =~"\\.sample$"

_examples: {
	commit:  #Name & "pre-commit"
	push:    #Name & "pre-push"
	receive: #Name & "pre-receive"
	update:  #Name & "update"
	p4:      #Name & "p4-pre-submit"
	sample:  #SampleName & "pre-commit.sample"
}
