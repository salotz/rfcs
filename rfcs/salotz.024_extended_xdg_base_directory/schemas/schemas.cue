package schemas

import xdg "specifications.freedesktop.org/basedir:schemas"

// salotz.024_extended_xdg_base_directory — XDGX directories and env vars.

#XDGVar: xdg.#Var

#XDGXVar: "XDGX_OPT_HOME" | "XDGX_TMP_HOME" | "XDGX_SCRATCH_HOME" | "XDGX_VAR_HOME"

#Kind: "opt" | "tmp" | "scratch" | "var"

#Directory: {
	kind:     #Kind
	default:  string
	env:      #XDGXVar
	snapshot: bool
}

#Defaults: {
	opt: #Directory & {
		kind:     "opt"
		default:  "~/.local/opt"
		env:      "XDGX_OPT_HOME"
		snapshot: true
	}
	tmp: #Directory & {
		kind:     "tmp"
		default:  "~/.local/tmp"
		env:      "XDGX_TMP_HOME"
		snapshot: false
	}
	scratch: #Directory & {
		kind:     "scratch"
		default:  "~/.local/scratch"
		env:      "XDGX_SCRATCH_HOME"
		snapshot: false
	}
	var: #Directory & {
		kind:     "var"
		default:  "~/.local/var"
		env:      "XDGX_VAR_HOME"
		snapshot: true
	}
}

_examples: {
	xdgConfig: #XDGVar & "XDG_CONFIG_HOME"
	opt:       #XDGXVar & "XDGX_OPT_HOME"
	var:       #XDGXVar & "XDGX_VAR_HOME"
	dir:       #Defaults.var
}
