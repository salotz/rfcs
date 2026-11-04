package mime

// Media types (MIME types). RFC 2045 / RFC 6838.
// https://www.rfc-editor.org/rfc/rfc2045
// https://www.rfc-editor.org/rfc/rfc2046
// https://www.rfc-editor.org/rfc/rfc6838
// https://www.rfc-editor.org/rfc/rfc6839
//
// `#MediaType` is `type/subtype` without parameters. `#MediaTypeLine`
// is the Content-Type form with optional `; param=value`. This is not
// a multipart parser.
//
// Subtype namespaces are the RFC 6838 registration trees (`vnd.`,
// `prs.`, `x.`) plus the deprecated RFC 2046 `x-` experimental
// prefix. Type and subtype names are case-insensitive in the RFCs;
// these patterns do not fold case, but tree prefixes match either
// case.

// RFC 6838 / RFC 9110 tchar.
_tcharPattern: "[A-Za-z0-9!#$%&'*+.^_`|~-]"
_tokenPattern: "(\(_tcharPattern))+"

#Token: string & =~"^\(_tokenPattern)$"

// IANA top-level types plus `x-` (obsolete experimental, still seen).
#DiscreteType:
	"application" |
	"audio" |
	"font" |
	"image" |
	"model" |
	"text" |
	"video"

#CompositeType: "message" | "multipart"

#ExampleType: "example"

#TopLevelType: #DiscreteType | #CompositeType | #ExampleType | #Token

#Subtype: #Token

// Registration trees (RFC 6838 §3) plus deprecated RFC 2046 `x-`.
//
//	standards     — no prefix (`text/plain`, `application/json`)
//	vendor        — `vnd.` (`application/vnd.ms-excel`)
//	personal      — `prs.` (vanity tree)
//	unregistered  — `x.`  (RFC 6838 §3.4)
//	experimental  — `x-`  (RFC 2046; RFC 6838 deprecates this form)
#NamespaceNames: [
	"standards",
	"vendor",
	"personal",
	"unregistered",
	"experimental",
]
#Namespace: or(#NamespaceNames)

#RegistrationTreeNames: [
	"standards",
	"vendor",
	"personal",
	"unregistered",
]
#RegistrationTree: or(#RegistrationTreeNames)

// Subtype prefixes including the separator. Standards has none.
// Lowercase is the IANA conventional form.
#VendorPrefix:       "vnd."
#PersonalPrefix:     "prs."
#UnregisteredPrefix: "x."
#ExperimentalPrefix: "x-"

#TreePrefixes: {
	standards:    ""
	vendor:       #VendorPrefix
	personal:     #PersonalPrefix
	unregistered: #UnregisteredPrefix
	experimental: #ExperimentalPrefix
}

// Subtype after the tree prefix and before a structured-syntax `+suffix`.
#TreeName: #Token & !~"\\+"

// Prefix checks are complete regexes (`cue fmt` parenthesizes
// interpolations after `.`).
#VendorSubtype:       #Subtype & =~"^[vV][nN][dD]\\..+"
#PersonalSubtype:     #Subtype & =~"^[pP][rR][sS]\\..+"
#UnregisteredSubtype: #Subtype & =~"^[xX]\\..+"
#ExperimentalSubtype: #Subtype & =~"^[xX]-.+"
#StandardsSubtype:    #Subtype & !~"^[vV][nN][dD]\\." & !~"^[pP][rR][sS]\\." & !~"^[xX]\\." & !~"^[xX]-"

// `type/subtype`. Type and subtype are case-insensitive in the RFC;
// these patterns do not fold case.
#MediaType: string & =~"^(\(_tokenPattern))/(\(_tokenPattern))$"

#ParameterName:  #Token
#ParameterValue: string & !~"[\n\r]" & !=""

// `type/subtype` plus optional `; name=value` parameters (token or
// quoted-string values are not distinguished here).
#MediaTypeLine: string & =~"^(\(_tokenPattern))/(\(_tokenPattern))(;.*)?"

#MediaTypeStruct: {
	type:    #TopLevelType
	subtype: #Subtype
	parameters?: {
		[string]: #ParameterValue
	}
}

// Full `type/subtype` constrained to a registration tree. Exactly one
// `/` in `#MediaType`, so `/vnd.` is the subtype prefix.
#VendorMediaType:       #MediaType & =~"/[vV][nN][dD]\\..+"
#PersonalMediaType:     #MediaType & =~"/[pP][rR][sS]\\..+"
#UnregisteredMediaType: #MediaType & =~"/[xX]\\..+"
#ExperimentalMediaType: #MediaType & =~"/[xX]-.+"
#StandardsMediaType:    #MediaType & !~"/[vV][nN][dD]\\." & !~"/[pP][rR][sS]\\." & !~"/[xX]\\." & !~"/[xX]-"

// Generate `type/` + prefix(namespace) + name + optional `+suffix`.
#NamespacedMediaTypeStruct: {
	type:      #TopLevelType
	namespace: #Namespace
	name:      #TreeName
	suffix?:   #StructuredSuffix
	parameters?: {
		[string]: #ParameterValue
	}
}

#StandardsMediaTypeStruct: #NamespacedMediaTypeStruct & {
	namespace: "standards"
}
#VendorMediaTypeStruct: #NamespacedMediaTypeStruct & {
	namespace: "vendor"
}
#PersonalMediaTypeStruct: #NamespacedMediaTypeStruct & {
	namespace: "personal"
}
#UnregisteredMediaTypeStruct: #NamespacedMediaTypeStruct & {
	namespace: "unregistered"
}
#ExperimentalMediaTypeStruct: #NamespacedMediaTypeStruct & {
	namespace: "experimental"
}

// Structured syntax suffix (RFC 6838 §4.2.8 / RFC 6839): characters
// after the last `+` in the subtype (`application/problem+json` →
// `json`). Not every `+` type is IANA-registered.
#StructuredSuffix: #Token & !~"\\+"

#WellKnownStructuredSuffixes: [...#StructuredSuffix]
#WellKnownStructuredSuffixes: [
	"xml",
	"json",
	"ber",
	"der",
	"fastinfoset",
	"wbxml",
	"zip",
	"gzip",
	"cbor",
	"json-seq",
	"cbor-seq",
]
#WellKnownStructuredSuffix: or(#WellKnownStructuredSuffixes)

#JSONSuffix:    "json"
#XMLSuffix:     "xml"
#ZipSuffix:     "zip"
#GZipSuffix:    "gzip"
#CBORSuffix:    "cbor"
#JSONSeqSuffix: "json-seq"
#CBORSeqSuffix: "cbor-seq"

#SuffixMediaType: #MediaType & =~"\\+"

#WellKnownMediaTypes: [...#MediaType]
#WellKnownMediaTypes: [
	"application/json",
	"application/xml",
	"application/octet-stream",
	"application/pdf",
	"application/zip",
	"application/x-www-form-urlencoded",
	"application/problem+json",
	"text/plain",
	"text/html",
	"text/css",
	"text/javascript",
	"text/csv",
	"text/markdown",
	"image/png",
	"image/jpeg",
	"image/gif",
	"image/webp",
	"image/svg+xml",
	"audio/mpeg",
	"video/mp4",
	"font/woff2",
	"multipart/form-data",
	"multipart/mixed",
	"message/rfc822",
]

#WellKnownMediaType: or(#WellKnownMediaTypes)

#JSON:           "application/json"
#OctetStream:    "application/octet-stream"
#PlainText:      "text/plain"
#HTML:           "text/html"
#FormURLEncoded: "application/x-www-form-urlencoded"
#MultipartForm:  "multipart/form-data"

_examples: {
	json:  #MediaType & "application/json"
	plain: #MediaType & "text/plain"
	plus:  #MediaType & "application/vnd.api+json"
	well:  #WellKnownMediaType & "image/png"
	named: #JSON & "application/json"
	line:  #MediaTypeLine & "text/html; charset=UTF-8"
	token: #Token & "json"
	top:   #DiscreteType & "application"

	standards:    #StandardsMediaType & "application/json"
	vendor:       #VendorMediaType & "application/vnd.ms-excel"
	vendorPlus:   #VendorMediaType & "application/vnd.api+json"
	personal:     #PersonalMediaType & "application/prs.alvestrand.titrax-sheet"
	unreg:        #UnregisteredMediaType & "application/x.private"
	experimental: #ExperimentalMediaType & "application/x-www-form-urlencoded"
	suffix:       #SuffixMediaType & "application/problem+json"
	suffixJSON:   #WellKnownStructuredSuffix & "json"

	vendorSub: #VendorSubtype & "vnd.ms-excel"
	expSub:    #ExperimentalSubtype & "x-www-form-urlencoded"
	stdSub:    #StandardsSubtype & "plain"
	ns:        #Namespace & "vendor"
	prefix:    #VendorPrefix & "vnd."

	struct: #MediaTypeStruct & {
		type:    "text"
		subtype: "html"
		parameters: {
			charset: "UTF-8"
		}
	}
	form: #MediaTypeStruct & {
		type:    "multipart"
		subtype: "form-data"
		parameters: {
			boundary: "----WebKitFormBoundary"
		}
	}
	vendorStruct: #VendorMediaTypeStruct & {
		type:      "application"
		namespace: "vendor"
		name:      "api"
		suffix:    "json"
	}
	expStruct: #ExperimentalMediaTypeStruct & {
		type:      "application"
		namespace: "experimental"
		name:      "www-form-urlencoded"
	}
	stdStruct: #StandardsMediaTypeStruct & {
		type:      "application"
		namespace: "standards"
		name:      "problem"
		suffix:    "json"
	}
}
