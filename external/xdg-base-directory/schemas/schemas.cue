package schemas

// XDG Base Directory Specification
// https://specifications.freedesktop.org/basedir/latest/

#Prefix: "XDG_"

#Var:
	"XDG_DATA_HOME" | "XDG_CONFIG_HOME" | "XDG_STATE_HOME" |
	"XDG_CACHE_HOME" | "XDG_RUNTIME_DIR" |
	"XDG_DATA_DIRS" | "XDG_CONFIG_DIRS"

#Directory: {
	env:     #Var
	default: string
}

#Defaults: {
	data: #Directory & {
		env:     "XDG_DATA_HOME"
		default: "$HOME/.local/share"
	}
	config: #Directory & {
		env:     "XDG_CONFIG_HOME"
		default: "$HOME/.config"
	}
	state: #Directory & {
		env:     "XDG_STATE_HOME"
		default: "$HOME/.local/state"
	}
	cache: #Directory & {
		env:     "XDG_CACHE_HOME"
		default: "$HOME/.cache"
	}
	runtime: #Directory & {
		env:     "XDG_RUNTIME_DIR"
		default: "" // set by the session; no portable home default
	}
	dataDirs: #Directory & {
		env:     "XDG_DATA_DIRS"
		default: "/usr/local/share/:/usr/share/"
	}
	configDirs: #Directory & {
		env:     "XDG_CONFIG_DIRS"
		default: "/etc/xdg"
	}
}

#BinDir: "$HOME/.local/bin"

_examples: {
	config: #Var & "XDG_CONFIG_HOME"
	cache:  #Defaults.cache
	bin:    #BinDir & "$HOME/.local/bin"
}
