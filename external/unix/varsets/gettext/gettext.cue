package gettext

import "salotz.info/unix/envvar"

// GNU gettext message-catalog language fallback (not POSIX Chapter 8).

#Names: [...envvar.#Name]
#Names: ["LANGUAGE"]

#Name: or(#Names) & envvar.#Name
