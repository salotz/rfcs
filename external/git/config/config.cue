package config

import (
	"salotz.info/git/url"
	"salotz.info/unix/path"
)

// git-config(1) configuration file.
// https://git-scm.com/docs/git-config#_configuration_file
//
// INI-like sections and variables, not a parser of on-disk text.
// `#File` is the already-split document. Comments (`#`, `;`) and
// line continuation (`\`) are syntax of the file, not of these types.
//
// Section and variable names are case-insensitive in Git; these
// patterns do not fold case. Subsection names are case-sensitive.

_sectionNamePattern:  "[A-Za-z0-9][A-Za-z0-9.-]*"
_variableNamePattern: "[A-Za-z][A-Za-z0-9-]*"

// `[core]`. Alphanumeric, `-`, and `.` only.
#SectionName: string & =~"^\(_sectionNamePattern)$"

// `filemode`. Alphanumeric and `-`; must start with a letter.
#VariableName: string & =~"^\(_variableNamePattern)$"

// `[section "subsection"]` inner name. Any characters except newline
// (and NUL, which CUE strings cannot hold).
#Subsection: string & !~"[\n\r]"

// `git config` `<name>`: last dot-separated segment is the variable;
// everything before the last dot is section plus optional subsection.
// `core.bare`, `remote.origin.url`, `url.https://github.com/.insteadOf`.
#Name:
	(string & =~"^\(_sectionNamePattern)\\.\(_variableNamePattern)$") |
	(string & =~"^\(_sectionNamePattern)\\..+\\.\(_variableNamePattern)$")

// Decomposed `git config` name. `subsection` omitted for two-level names.
#NameStruct: {
	section:     #SectionName
	subsection?: #Subsection
	variable:    #VariableName
}

// Deprecated `[section.subsection]` header form. Subsection is
// lowercased and compared case-sensitively; same charset as #SectionName.
#DeprecatedDottedSection: string & =~"^\(_sectionNamePattern)\\.\(_sectionNamePattern)$"

#BooleanTrue:  string & =~"^([tT][rR][uU][eE]|[yY][eE][sS]|[oO][nN]|1)$"
#BooleanFalse: string & =~"^([fF][aA][lL][sS][eE]|[nN][oO]|[oO][fF][fF]|0)$"
#Boolean:      #BooleanTrue | #BooleanFalse

// Decimal integer; optional `k`/`m`/`g` (2^10 / 2^20 / 2^30).
#Integer: string & =~"^[+-]?[0-9]+[kKmMgG]?$"

// `git config --type=path`: leading `~` / `~user` expansion.
#Path: path.#HostPath

// Value of `remote.<name>.url` / `remote.<name>.pushURL`.
#RemoteURL: url.#Remote

#NamedColor:
	"normal" | "black" | "red" | "green" | "yellow" |
	"blue" | "magenta" | "cyan" | "white" | "default"

#BrightColor:
	"brightblack" | "brightred" | "brightgreen" | "brightyellow" |
	"brightblue" | "brightmagenta" | "brightcyan" | "brightwhite"

#ColorAttribute:
	"bold" | "dim" | "ul" | "blink" | "reverse" | "italic" | "strike" |
	"nobold" | "nodim" | "noul" | "noblink" | "noreverse" | "noitalic" | "nostrike"

// Color slot value (`color.status.added`). Not a parser of the
// "fg bg attr…" list; Git also accepts `#rgb`, `#rrggbb`, and 0–255.
#Color: string & !="" & !~"[\n\r]"

// `git config --type`.
#Type: "bool" | "int" | "bool-or-int" | "path" | "expiry-date" | "color"

#Scope: "system" | "global" | "local" | "worktree"

// includeIf condition strings (`[includeIf "<condition>"]`).
// https://git-scm.com/docs/git-config#_conditional_includes
#GitDirCondition:             string & =~"^gitdir:"
#GitDirIgnoreCaseCondition:   string & =~"^gitdir/i:"
#WorktreeCondition:           string & =~"^worktree:"
#WorktreeIgnoreCaseCondition: string & =~"^worktree/i:"
#OnBranchCondition:           string & =~"^onbranch:"
#HasConfigRemoteURLCondition: string & =~"^hasconfig:remote\\.\\*\\.url:"
#HostnameCondition:           string & =~"^hostname:"

#IncludeIfCondition:
	#GitDirCondition |
	#GitDirIgnoreCaseCondition |
	#WorktreeCondition |
	#WorktreeIgnoreCaseCondition |
	#OnBranchCondition |
	#HasConfigRemoteURLCondition |
	#HostnameCondition

// One assignment. Omitted `value` is the boolean true shorthand
// (`name` with no `=`).
#VariableStruct: {
	name:   #VariableName
	value?: string
}

#SectionStruct: {
	name:        #SectionName
	subsection?: #Subsection
	variables: [...#VariableStruct]
}

#File: {
	sections: [...#SectionStruct]
}

// Built-in section names from git.git. Not closed over third-party
// tools (LFS, hub, …). Unknown sections still unify with #SectionName.
#WellKnownSectionNames: [...#SectionName]
#WellKnownSectionNames: [
	"add", "advice", "alias", "am", "apply", "blame", "branch",
	"browser", "bundle", "checkout", "clean", "clone", "color",
	"column", "commit", "commitgraph", "core", "credential", "diff",
	"difftool", "extensions", "feature", "fetch", "filter", "format",
	"fsck", "gc", "gitcvs", "gitweb", "gpg", "grep", "gui", "guitool",
	"help", "http", "i18n", "imap", "include", "includeIf", "index",
	"init", "instaweb", "interactive", "log", "lsrefs", "mailinfo",
	"mailmap", "maintenance", "man", "merge", "mergetool", "notes",
	"pack", "pager", "pretty", "protocol", "pull", "push", "rebase",
	"receive", "remote", "remotes", "repack", "rerere", "revert",
	"safe", "sendemail", "sequence", "showbranch", "sparse",
	"splitIndex", "ssh", "stash", "status", "submodule", "tag", "tar",
	"trace2", "transfer", "uploadarchive", "uploadpack", "url", "user",
	"versionsort", "web", "worktree",
]

#WellKnownSection: or(#WellKnownSectionNames)

_examples: {
	section:  #SectionName & "core"
	variable: #VariableName & "filemode"
	well:     #WellKnownSection & "includeIf"
	twoLevel: #Name & "user.email"
	remote:   #Name & "remote.origin.url"
	instead:  #Name & "url.https://github.com/.insteadOf"
	nameStruct: #NameStruct & {
		section:  "user"
		variable: "email"
	}
	nameRemote: #NameStruct & {
		section:    "remote"
		subsection: "origin"
		variable:   "url"
	}
	truth:  #Boolean & "true"
	off:    #BooleanFalse & "off"
	kbytes: #Integer & "10m"
	home:   #Path & "~/.gitconfig"
	clone:  #RemoteURL & "git@github.com:salotz/yerk.git"
	color:  #NamedColor & "red"
	gitdir: #GitDirCondition & "gitdir:~/src/"
	branch: #OnBranchCondition & "onbranch:main"
	hasURL: #HasConfigRemoteURLCondition & "hasconfig:remote.*.url:https://example.com/**"
	host:   #HostnameCondition & "hostname:dev.*"
	scope:  #Scope & "global"
	typ:    #Type & "bool"
	file: #File & {
		sections: [{
			name: "user"
			variables: [
				{name: "name", value: "salotz"},
				{name: "email", value: "s@example.com"},
			]
		}, {
			name:       "branch"
			subsection: "devel"
			variables: [
				{name: "remote", value: "origin"},
				{name: "merge", value: "refs/heads/devel"},
			]
		}, {
			name: "core"
			variables: [{name: "filemode", value: "false"}]
		}]
	}
}
