package schemas

import "list"
import "strings"

import posix "salotz.info/unix-env/posix"
import locale "salotz.info/unix-env/locale"
import gettext "salotz.info/unix-env/gettext"
import systemd "salotz.info/unix-env/systemd"
import ssh "salotz.info/unix-env/openssh"
import nocolor "salotz.info/unix-env/nocolor"
import x11 "salotz.info/unix-env/x11"
import defacto "salotz.info/unix-env/defacto"
import xdg "specifications.freedesktop.org/basedir:schemas"
import prj "github.com/numtide/prj-spec:schemas"

// salotz.027_env-nexps — UNIX environment variable name form.
// Values are out of scope (see RFC 032). Reserved catalogs are imported
// from external/env packages (plus XDG and PRJ Spec directory modules).

// POSIX form, minus underscore-only names (reserved for the platform).
#EnvName: posix.#Form & !~"^_+$"

// User-configured hidden (single leading underscore).
#HiddenUser: string & =~"^_[A-Z][A-Z0-9_]*$"

// Application-internal hidden (leading dunder).
#HiddenApp: string & =~"^__[A-Z][A-Z0-9_]*$"

#ReservedPrefix:
	xdg.#Prefix | systemd.#Prefix | ssh.#Prefix | prj.#Prefix | locale.#Prefix

#POSIXName:   posix.#Name
#LocaleName:  locale.#Name | gettext.#Name
#X11Name:     x11.#Name
#DeFactoName: defacto.#Name
#NoColor:     nocolor.#Name

// Anatomy of a name (leading/trailing underscores stripped before fields).
#Parsed: {
	raw: #EnvName

	_strippedLead:       strings.TrimLeft(raw, "_")
	leadingUnderscores:  len(raw) - len(_strippedLead)
	name:                strings.TrimRight(_strippedLead, "_")
	trailingUnderscores: len(_strippedLead) - len(name)
	fields:              strings.Split(name, "__")
	_firstWords:         strings.Split(fields[0], "_")
	_restFirst:          strings.Join(list.Drop(_firstWords, 1), "_")
	_restFields:         list.Slice(fields, 1, len(fields))
	_leafParts: [ for p in list.Concat([[_restFirst], _restFields]) if p != "" { p }]
	words: list.FlattenN([ for f in fields { strings.Split(f, "_") } ], 1)

	if len(fields) == 1 && len(_firstWords) == 1 {
		namespace: ""
		leaf:      name
	}
	if len(fields) > 1 || len(_firstWords) > 1 {
		namespace: _firstWords[0]
		leaf:      strings.Join(_leafParts, "__")
	}
}

_examples: {
	simple:  #EnvName & "MY_VARIABLE"
	fields:  #EnvName & "PREFIX__FIELD_A__FIELD_B"
	user:    #HiddenUser & "_IGNORED_VARIABLE"
	app:     #HiddenApp & "__IMPLEMENTATION_SPECIFIC_HIDDEN"
	posix:   #POSIXName & "HOME"
	locale:  #LocaleName & "LANG"
	prefix:  #ReservedPrefix & "XDG_"
	nocolor: #NoColor & "NO_COLOR"
	parsed:  #Parsed & {raw: "__MY_APP_THING__CURRENT_SESSION__SOCKET_PATH_"}
	single:  #Parsed & {raw: "EXAMPLE"}
	ns:      #Parsed & {raw: "NAMESPACE_EXAMPLE"}
}
