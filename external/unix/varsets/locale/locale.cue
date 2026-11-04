package locale

import "salotz.info/unix/envvar"

// POSIX / ISO C locale environment variables.

#Prefix: "LC_"

#Names: [...envvar.#Name]
#Names: [
	"LANG", "LC_ALL", "LC_COLLATE", "LC_CTYPE", "LC_MESSAGES",
	"LC_MONETARY", "LC_NUMERIC", "LC_TIME",
]

#Name: or(#Names) & envvar.#Name
