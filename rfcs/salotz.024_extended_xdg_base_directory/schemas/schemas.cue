package schemas

import (
	unixpath "salotz.info/unix/path"
	envvar "salotz.info/unix/envvar"
	dirshape "salotz.info/rfcs/033_dirshape:schemas"
	xdg "specifications.freedesktop.org/basedir:schemas"
)

// salotz.024_extended_xdg_base_directory — XDGX directories and env vars.

#XDGVar: xdg.#Var

#XDGXVar: envvar.#UtilityName & (
		"XDGX_OPT_HOME" | "XDGX_TMP_HOME" | "XDGX_SCRATCH_HOME" | "XDGX_VAR_HOME")

#Kind: "opt" | "tmp" | "scratch" | "var"

#Directory: {
	kind:     #Kind
	default:  unixpath.#HomeRelativePath
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

// Default grouping under ~/.local. Each kind may be relocated via its
// XDGX_* override; check those roots separately.
#LocalLayoutSpec: dirshape.#LayoutSpec & {
	entries: {
		opt: {name: "opt/", presence: "optional"}
		tmp: {name: "tmp/", presence: "optional"}
		scratch: {name: "scratch/", presence: "optional"}
		var: {name: "var/", presence: "optional"}
	}
}

_examples: {
	xdgConfig: #XDGVar & "XDG_CONFIG_HOME"
	opt:       #XDGXVar & "XDGX_OPT_HOME"
	var:       #XDGXVar & "XDGX_VAR_HOME"
	dir:       #Defaults.var
	layout:    #LocalLayoutSpec
}
