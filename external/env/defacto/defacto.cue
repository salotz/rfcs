package defacto

// Unprefixed de facto environment names collected for RFC 27.
// Not a single upstream spec; treated as global vocabulary to avoid.

#Identity:
	"UID" | "EUID" | "GID" | "GROUPS" | "HOSTNAME" | "HOST" |
	"HOSTTYPE" | "OSTYPE" | "MACHTYPE"

#SearchPath:
	"INFOPATH" | "LD_LIBRARY_PATH" | "LD_PRELOAD" | "LIBRARY_PATH" |
	"CPATH" | "PKG_CONFIG_PATH" | "PYTHONPATH" | "GOPATH" | "NODE_PATH"

#Terminal: "COLORTERM" | "WAYLAND_DISPLAY" | "BROWSER" | "TERMINAL"

#Locale: "TZDIR"

#Temp: "TMP" | "TEMP"

#Shell:
	"HISTCONTROL" | "HISTFILESIZE" | "PROMPT_COMMAND" | "BASH_ENV" |
	"SHLVL" | "_"

#Build: "CXX" | "CPP" | "CXXFLAGS" | "CPPFLAGS" | "MAKELEVEL" | "DESTDIR" | "PREFIX"

#Proxy:
	"http_proxy" | "https_proxy" | "ftp_proxy" | "all_proxy" | "no_proxy" |
	"HTTP_PROXY"

#Runtime:
	"DEBUG" | "VERBOSE" | "DRY_RUN" | "TRACE" | "LOG_LEVEL" |
	"FORCE_COLOR" | "CI" | "NODE_ENV"

#PaaS: "PORT" | "DATABASE_URL" | "REDIS_URL"

#Session: "SESSION_MANAGER" | "DBUS_SESSION_BUS_ADDRESS"

#Name:
	#Identity | #SearchPath | #Terminal | #Locale | #Temp | #Shell |
	#Build | #Proxy | #Runtime | #PaaS | #Session
