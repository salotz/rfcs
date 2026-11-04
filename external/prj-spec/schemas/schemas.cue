package schemas

// PRJ Base Directory Specification
// https://github.com/numtide/prj-spec

#Prefix: "PRJ_"

#EnvVar: "PRJ_ROOT" | "PRJ_CONFIG_HOME" | "PRJ_ID" | "PRJ_CACHE_HOME"

#ProjectID: string & =~"^[a-zA-Z0-9_-]{1,32}$"

#AbsolutePath: string & =~"^/"

#IdFilename: "prj_id"

#Defaults: {
	configHome: "${PRJ_ROOT}/.config"
	cacheHomeWithID: "${XDG_CACHE_HOME}/prj/${PRJ_ID}"
	cacheHomeLocal:  "${PRJ_ROOT}/.cache"
}

_examples: {
	root: #EnvVar & "PRJ_ROOT"
	id:   #ProjectID & "acme_wumpus"
}
