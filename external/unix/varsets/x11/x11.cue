package x11

import "salotz.info/unix/envvar"

// X Window System environment variables.

#Names: [...envvar.#Name]
#Names: [
	"DISPLAY", "XAUTHORITY", "XENVIRONMENT", "XFILESEARCHPATH",
	"XAPPLRESDIR", "XLOCALEDIR", "XMODIFIERS", "XKEYSYMDB",
	"XCMSDB", "XLOCAL",
]

#Name: or(#Names) & envvar.#Name
