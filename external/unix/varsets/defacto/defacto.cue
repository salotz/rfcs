package defacto

import "salotz.info/unix/envvar"

// Unprefixed de facto environment names collected for RFC 27.
// Not a single upstream spec; treated as global vocabulary to avoid.

#Identity: envvar.#Name
#Identity:
	"UID" | "EUID" | "GID" | "GROUPS" | "HOSTNAME" | "HOST" |
	"HOSTTYPE" | "OSTYPE" | "MACHTYPE"

#SearchPath: envvar.#Name
#SearchPath:
	"INFOPATH" | "LD_LIBRARY_PATH" | "LD_PRELOAD" | "LIBRARY_PATH" |
	"CPATH" | "PKG_CONFIG_PATH" | "PYTHONPATH" | "GOPATH" | "NODE_PATH"

#Terminal: envvar.#Name
#Terminal: "COLORTERM" | "WAYLAND_DISPLAY" | "BROWSER" | "TERMINAL"

#Locale: envvar.#Name
#Locale: "TZDIR"

#Temp: envvar.#Name
#Temp: "TMP" | "TEMP"

#Shell: envvar.#Name
#Shell:
	"HISTCONTROL" | "HISTFILESIZE" | "PROMPT_COMMAND" | "BASH_ENV" |
	"SHLVL" | "_"

#Build: envvar.#Name
#Build: "CXX" | "CPP" | "CXXFLAGS" | "CPPFLAGS" | "MAKELEVEL" | "DESTDIR" | "PREFIX"

#Proxy: envvar.#Name
#Proxy:
	"http_proxy" | "https_proxy" | "ftp_proxy" | "all_proxy" | "no_proxy" |
	"HTTP_PROXY"

#Runtime: envvar.#Name
#Runtime:
	"DEBUG" | "VERBOSE" | "DRY_RUN" | "TRACE" | "LOG_LEVEL" |
	"FORCE_COLOR" | "CI" | "NODE_ENV"

#PaaS: envvar.#Name
#PaaS: "PORT" | "DATABASE_URL" | "REDIS_URL"

#Session: envvar.#Name
#Session: "SESSION_MANAGER" | "DBUS_SESSION_BUS_ADDRESS"

#Names: [...envvar.#Name]
#Names: [
	"UID", "EUID", "GID", "GROUPS", "HOSTNAME", "HOST",
	"HOSTTYPE", "OSTYPE", "MACHTYPE",
	"INFOPATH", "LD_LIBRARY_PATH", "LD_PRELOAD", "LIBRARY_PATH",
	"CPATH", "PKG_CONFIG_PATH", "PYTHONPATH", "GOPATH", "NODE_PATH",
	"COLORTERM", "WAYLAND_DISPLAY", "BROWSER", "TERMINAL",
	"TZDIR",
	"TMP", "TEMP",
	"HISTCONTROL", "HISTFILESIZE", "PROMPT_COMMAND", "BASH_ENV",
	"SHLVL", "_",
	"CXX", "CPP", "CXXFLAGS", "CPPFLAGS", "MAKELEVEL", "DESTDIR", "PREFIX",
	"http_proxy", "https_proxy", "ftp_proxy", "all_proxy", "no_proxy",
	"HTTP_PROXY",
	"DEBUG", "VERBOSE", "DRY_RUN", "TRACE", "LOG_LEVEL",
	"FORCE_COLOR", "CI", "NODE_ENV",
	"PORT", "DATABASE_URL", "REDIS_URL",
	"SESSION_MANAGER", "DBUS_SESSION_BUS_ADDRESS",
]

#Name: or(#Names) & envvar.#Name
