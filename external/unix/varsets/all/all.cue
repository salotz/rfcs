package all

import "list"

import "salotz.info/unix/envvar"

import posix "salotz.info/unix/varsets/posix"

import locale "salotz.info/unix/varsets/locale"

import gettext "salotz.info/unix/varsets/gettext"

import systemd "salotz.info/unix/varsets/systemd"

import openssh "salotz.info/unix/varsets/openssh"

import nocolor "salotz.info/unix/varsets/nocolor"

import x11 "salotz.info/unix/varsets/x11"

import defacto "salotz.info/unix/varsets/defacto"

// Combined catalogs from every varset in this module.
// XDG (`XDG_`) and PRJ (`PRJ_`) are other modules; they are not included.

#Names: [...envvar.#Name]
#Names: list.Concat([
	posix.#Names,
	locale.#Names,
	gettext.#Names,
	nocolor.#Names,
	x11.#Names,
	defacto.#Names,
	systemd.#ServiceNames,
])

#Name: or(#Names) & envvar.#Name

#Prefix: locale.#Prefix | systemd.#Prefix | openssh.#Prefix

// Names that use a reserved prefix (including ones not in #Names, e.g. LC_FOO).
#PrefixedName: envvar.#Name & (=~"^LC_" | =~"^SYSTEMD_" | =~"^SSH_")

#Reserved: #Name | #PrefixedName

// Application-chosen names: a valid env var that is not catalogued and
// does not use a reserved prefix. CUE `!= (a|b)` does not exclude a
// disjunction; this uses the name list plus prefix regexes.
#ApplicationName:
	envvar.#Name &
	and([for n in #Names {!=n}]) &
	!~"^LC_" & !~"^SYSTEMD_" & !~"^SSH_"

_examples: {
	reservedHome:  #Name & "HOME"
	reservedLang:  #Name & "LANG"
	reservedProxy: #Name & "http_proxy"
	prefixed:      #PrefixedName & "SSH_AUTH_SOCK"
	app:           #ApplicationName & "YERK_CONFIG_DIR"
	appMixed:      #ApplicationName & "my_app_opt"
}
