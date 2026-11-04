package path

// Lexical Unix filesystem paths. Not URLs. Not Windows paths.
// Path math is string form only; this is not a path.Join implementation.
//
// Home expansion is POSIX sh tilde expansion (XCU 2.6.1) plus the
// `$HOME` / `${HOME}` parameter forms (XCU 2.6.2). `~user` is a different
// user's home; `~/…` is the current user.

// Absolute Unix path (lexical).
#AbsUnixPath: string & =~"^/"

// Current-user home-relative path: "~" or "~/…".
#HomeRelativePath: string & =~"^~(/.*)?$"

// POSIX tilde expansion for another login: "~user" or "~user/…".
#TildeUserPath: string & =~"^~[A-Za-z_][A-Za-z0-9_-]+(/.*)?$"

#LoginName: string & =~"^[A-Za-z_][A-Za-z0-9_-]*$"

// Decomposed `~user` / `~user/rest`. `path` is the part after `~user/`,
// without a leading slash; omitted for `~user` alone.
#TildeUserPathStruct: {
	user:  #LoginName
	path?: string
}
#TildePath: #HomeRelativePath | #TildeUserPath

// $HOME or $HOME/…
#HomeDollarPath: string & =~"^\\$HOME(/.*)?$"

// ${HOME} or ${HOME}/…
#HomeBracePath: string & =~"^\\$\\{HOME\\}(/.*)?$"

#HomeParameterPath: #HomeDollarPath | #HomeBracePath

#HomeExpansionPath: #TildePath | #HomeParameterPath

// Relative Unix path: non-empty, not absolute, not tilde, not $HOME.
#RelativeUnixPath: string & !="" & !~"^/" & !~"^~" & !~"^\\$HOME" & !~"^\\$\\{HOME\\}"

// Path as written in host config: absolute, home expansion, or relative.
#HostPath: #AbsUnixPath | #HomeExpansionPath | #RelativeUnixPath

_examples: {
	abs:       #AbsUnixPath & "/home/salotz/tree"
	home:      #HomeRelativePath & "~/tree/personal"
	homeOnly:  #HomeRelativePath & "~"
	tildeUser: #TildeUserPath & "~salotz/tree"
	tildeStruct: #TildeUserPathStruct & {user: "salotz", path: "tree"}
	tildeUserOnly: #TildeUserPathStruct & {user: "salotz"}
	dollar:   #HomeDollarPath & "$HOME/tree"
	brace:    #HomeBracePath & "${HOME}/tree"
	rel:      #RelativeUnixPath & "devel/yerk"
	hostAbs:  #HostPath & "/opt/yerk"
	hostHome: #HostPath & "~/tree"
	hostVar:  #HostPath & "$HOME/tree"
	hostRel:  #HostPath & "devel/yerk"
}
