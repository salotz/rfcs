package urn

import (
	"salotz.info/std/id"
	"salotz.info/url/core"
)

// URN strings (RFC 8141) as a URI scheme.
// https://www.rfc-editor.org/rfc/rfc8141
//
// assigned-name = "urn" ":" NID ":" NSS
// Optional r-component (`?+`) and q-component (`?=`) are not encoded
// here. `#URNStruct` is nid + nss plus an optional fragment.

#Scheme: "urn"

// RFC 8141: scheme is case-insensitive. RE2 has no (?i).
_urnSchemePattern: "[uU][rR][nN]"
// NID = (alphanum) 0*30(ldh) (alphanum) — 2 to 32 characters
_nidPattern: "[A-Za-z0-9][A-Za-z0-9-]{0,30}[A-Za-z0-9]"
// pchar from RFC 3986, duplicated so this package does not import
// core's hidden fragments.
_unreservedPattern: "[A-Za-z0-9._~-]"
_pctEncodedPattern: "%[0-9A-Fa-f]{2}"
_subDelimsPattern:  "[!$&'()*+,;=]"
_pcharPattern:      "(\(_unreservedPattern)|\(_pctEncodedPattern)|\(_subDelimsPattern)|[:@])"
// NSS = pchar *(pchar / "/")
_nssPattern: "\(_pcharPattern)(\(_pcharPattern)|/)*"

#NID: string & =~"^\(_nidPattern)$"
#NSS: string & =~"^\(_nssPattern)$"

#URN: core.#URI & =~"^\(_urnSchemePattern):\(_nidPattern):\(_nssPattern)([?#].*)?$"

#UUID: id.#UUID

// urn:uuid:…
#UUIDURN: #URN & =~"^\(_urnSchemePattern):[uU][uU][iI][dD]:"

#URNStruct: {
	nid:       #NID
	nss:       #NSS
	fragment?: core.#Fragment
}

#UUIDURNStruct: {
	nid: "uuid"
	nss: #UUID
}

_examples: {
	scheme:  #Scheme & "urn"
	nid:     #NID & "isbn"
	nss:     #NSS & "0451450523"
	urn:     #URN & "urn:isbn:0451450523"
	urnUUID: #UUIDURN & "urn:uuid:6ba7b810-9dad-11d1-80b4-00c04fd430c8"
	urnFrag: #URN & "urn:example:foo#bar"
	uuid:    #UUID & "6ba7b810-9dad-11d1-80b4-00c04fd430c8"
	urnStruct: #URNStruct & {
		nid: "isbn"
		nss: "0451450523"
	}
	urnStructFrag: #URNStruct & {
		nid:      "example"
		nss:      "foo"
		fragment: "bar"
	}
	uuidStruct: #UUIDURNStruct & {
		nid: "uuid"
		nss: "6ba7b810-9dad-11d1-80b4-00c04fd430c8"
	}
}
