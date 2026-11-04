package posix

import "salotz.info/unix/envvar"

// POSIX / SUS environment variable names (XBD Chapter 8 and related
// utility tables). Names consist of uppercase letters, digits, and
// underscore, and do not begin with a digit. Lowercase is reserved
// for applications.

#Form: envvar.#UtilityName

#Names: [...envvar.#Name]
#Names: [
	"HOME", "PATH", "LOGNAME", "USER", "SHELL", "PWD", "OLDPWD",
	"TERM", "TZ", "TMPDIR", "EDITOR", "VISUAL", "PAGER", "IFS",
	"PS1", "PS2", "PS3", "PS4", "CDPATH", "MAIL", "MAILPATH",
	"MANPATH", "COLUMNS", "LINES", "ENV", "OPTARG", "OPTERR",
	"OPTIND", "MAKEFLAGS", "CC", "CFLAGS", "LDFLAGS", "ARFLAGS",
	"YACC", "YFLAGS", "LEX", "LFLAGS", "PRINTER", "LPDEST",
	"TERMCAP", "TERMINFO", "HISTFILE", "HISTSIZE", "FCEDIT", "MORE",
	"NPROC", "NLSPATH", "CHARSET", "DATEMSK", "DEAD", "EXINIT",
	"FC", "FFLAGS", "GET", "GFLAGS", "HISTORY", "LISTER",
	"MAILCHECK", "MAILER", "MAILRC", "MAKESHELL", "MBOX", "MSGVERB",
	"PPID", "PROJECTDIR", "PROCLANG", "RANDOM", "SECONDS",
]

#Name: or(#Names) & envvar.#Name
