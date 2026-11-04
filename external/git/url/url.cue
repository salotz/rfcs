package url

import (
	"salotz.info/unix/path"
	"salotz.info/url/common"
)

// Git remotes as git-clone documents them.
// https://git-scm.com/docs/git-clone#_git_urls
//
// URL-shaped remotes use salotz.info/url/common (net.AbsURL plus a
// scheme prefix). Git also accepts SCP-style `user@host:path` and
// local filesystem paths, both of which fail net.AbsURL.

// SSH user "git" as used by GitHub, GitLab, and most forges.
#GitUser: "git"

// SCP-style remote: user@host:path. User is not always "git"
// (deploy keys, machine accounts).
#SCPRemote: string & =~"^[^/@\\s]+@[^:\\s]+:.+$"

// SCP-style remote whose user is git (git@host:path).
#GitUserSCPRemote: #SCPRemote & =~"^\(#GitUser)@"

#SCPUser: string & =~"^[^/@\\s]+$"
#SCPHost: string & =~"^[^:\\s]+$"
#SCPPath: string & !="" & !~"[\n\r]"

#SCPRemoteStruct: {
	user: #SCPUser
	host: #SCPHost
	path: #SCPPath
}

#GitUserSCPRemoteStruct: #SCPRemoteStruct & {
	user: #GitUser
}

// URL-shaped remotes from the generic URL module.
#SchemeRemote:
	common.#HTTPSURL |
	common.#HTTPURL |
	common.#SSHURL |
	common.#FileURL |
	common.#GitSchemeURL |
	common.#FTPURL |
	common.#FTPSURL

// Git remote as written.
#Remote: #SchemeRemote | #SCPRemote | path.#HostPath

_examples: {
	scp:       #SCPRemote & "deploy@github.com:salotz/yerk.git"
	gitUser:   #GitUserSCPRemote & "git@github.com:salotz/yerk.git"
	https:     #Remote & "https://github.com/salotz/yerk.git"
	ssh:       #Remote & "ssh://git@github.com/salotz/yerk.git"
	gitScheme: #Remote & "git://git.kernel.org/pub/scm/git/git.git"
	file:      #Remote & "file:///home/salotz/src/yerk.git"
	local:     #Remote & "/home/salotz/src/yerk.git"
	home:      #Remote & "~/src/yerk.git"
	rel:       #Remote & "../yerk.git"
	scpStruct: #SCPRemoteStruct & {
		user: "deploy"
		host: "github.com"
		path: "salotz/yerk.git"
	}
	gitUserStruct: #GitUserSCPRemoteStruct & {
		user: "git"
		host: "github.com"
		path: "salotz/yerk.git"
	}
}
