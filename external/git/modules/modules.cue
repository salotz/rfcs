package modules

import (
	"salotz.info/git/config"
	"salotz.info/git/refs"
	"salotz.info/git/url"
	"salotz.info/unix/path"
)

// gitmodules(5): `.gitmodules` at the work-tree top.
// https://git-scm.com/docs/gitmodules
//
// On-disk syntax is git-config. `#File` is the parsed form: one
// `[submodule "<name>"]` per entry. `path` and `url` are required.
// `update` may not be `!command` (forbidden in this file).

#SectionName: "submodule"

// Subsection name (`git submodule add --name`). Any characters except
// newline, same as config.#Subsection, and not empty.
#Name: config.#Subsection & !=""

// Work-tree-relative path. Must not end with `/`. Unique within the file
// (uniqueness is not checked here).
#Path: path.#RelativeUnixPath
#Path: !~"/$"

// Clone URL, or `./` / `../` relative to the superproject origin.
#URL: url.#Remote

#Update: "checkout" | "rebase" | "merge" | "none"

// Remote branch to track, or `.` for “same name as the superproject”.
#Branch: refs.#BranchName | "."

#Ignore: "all" | "dirty" | "untracked" | "none"

#FetchRecurse: config.#Boolean | "on-demand"

#Shallow: config.#Boolean

#VariableName:
	"path" | "url" | "update" | "branch" |
	"fetchRecurseSubmodules" | "ignore" | "shallow"

#SubmoduleStruct: {
	name:                    #Name
	path:                    #Path
	url:                     #URL
	update?:                 #Update
	branch?:                 #Branch
	fetchRecurseSubmodules?: #FetchRecurse
	ignore?:                 #Ignore
	shallow?:                #Shallow
}

#File: {
	submodules: [...#SubmoduleStruct]
}
_examples: {
	path:    #Path & "include/foo"
	clone:   #URL & "git://foo.com/git/lib.git"
	rel:     #URL & "../lib.git"
	update:  #Update & "checkout"
	dot:     #Branch & "."
	branch:  #Branch & "main"
	ignore:  #Ignore & "dirty"
	recurse: #FetchRecurse & "on-demand"
	file: #File & {
		submodules: [{
			name: "libfoo"
			path: "include/foo"
			url:  "git://foo.com/git/lib.git"
		}, {
			name:    "libbar"
			path:    "include/bar"
			url:     "git://bar.com/git/lib.git"
			update:  "rebase"
			branch:  "."
			ignore:  "none"
			shallow: "true"
		}]
	}
}
