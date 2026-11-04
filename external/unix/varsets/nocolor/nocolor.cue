package nocolor

import "salotz.info/unix/envvar"

// https://no-color.org/ — when NO_COLOR is present (any value), disable color.

#Names: [...envvar.#Name]
#Names: ["NO_COLOR"]

#Name: or(#Names) & envvar.#Name
