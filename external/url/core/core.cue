package core

import "net"

// URI and URL strings plus RFC 3986 components.
// https://www.rfc-editor.org/rfc/rfc3986
//
// RFC 3986 names vs this package:
//   URI-reference  URI / relative-ref     → #URIReference (#URL, net.URL)
//   URI            has a scheme           → #URI (#AbsoluteURL, net.AbsURL)
//   absolute-URI   URI with no fragment   → #AbsoluteURI (§4.3)
//   relative-ref   no scheme              → #RelativeRef
//   URL            informal locator       → #URL, kept as net.URL
//
// `net.URL` accepts relative and absolute forms. `net.AbsURL` requires a
// scheme. Neither is a filesystem path, git scp-style remote, or DNS name.
//
// Query and fragment are generic URI components (RFC 3986 §3.4, §3.5).
// They are allowed on every URI; a scheme may ignore them. They are not
// HTTPS-only. Component types below are the values *without* the `?` / `#`
// delimiters. This is not a URL parser: a string URL is not split into
// #URLStruct automatically.

#URL: string & net.URL

#AbsoluteURL: string & net.AbsURL

#URIReference: #URL
#URI:          #AbsoluteURL

// relative-ref = relative-part [ "?" query ] [ "#" fragment ]
#RelativeRef: #URIReference & !~"^\(_schemePattern):"

// absolute-URI = scheme ":" hier-part [ "?" query ]   — no fragment
#AbsoluteURI: #URI & !~"#"

// Network-path reference: //example.com/path
#NetworkPathRef: #RelativeRef & =~"^//"

// RFC 3986 Appendix A productions as regex fragments (no anchors).
//
// unreserved   ALPHA / DIGIT / "-" / "." / "_" / "~"
//              Characters that never need percent-encoding (§2.3).
// pct-encoded  "%" HEXDIG HEXDIG
//              A single percent-encoded octet, e.g. "%2F" for "/".
// sub-delims   "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="
//              Reserved as scheme-specific separators; allowed in many
//              components without encoding (§2.2).
// pchar        unreserved / pct-encoded / sub-delims / ":" / "@"
//              "Path character": one unit of a path segment (§3.3).
// query/frag   *( pchar / "/" / "?" )
//              Query (§3.4) and fragment (§3.5) share this grammar.
// userinfo     *( unreserved / pct-encoded / sub-delims / ":" )
//              User (and optional password) before "@" in the authority.
// reg-name     *( unreserved / pct-encoded / sub-delims )
//              Registered name: a host that is not an IP literal (§3.2.2).
// scheme       ALPHA *( ALPHA / DIGIT / "+" / "-" / "." )
_unreservedPattern:    "[A-Za-z0-9._~-]"
_pctEncodedPattern:    "%[0-9A-Fa-f]{2}"
_subDelimsPattern:     "[!$&'()*+,;=]"
_pcharPattern:         "(\(_unreservedPattern)|\(_pctEncodedPattern)|\(_subDelimsPattern)|[:@])"
_queryFragmentPattern: "(\(_pcharPattern)|[/?])*"
_userInfoPattern:      "(\(_unreservedPattern)|\(_pctEncodedPattern)|\(_subDelimsPattern)|:)*"
_regNamePattern:       "(\(_unreservedPattern)|\(_pctEncodedPattern)|\(_subDelimsPattern))*"
_schemePattern:        "[A-Za-z][A-Za-z0-9+.-]*"

// scheme = ALPHA *( ALPHA / DIGIT / "+" / "-" / "." )
#Scheme: string & =~"^\(_schemePattern)$"

// userinfo = *( unreserved / pct-encoded / sub-delims / ":" )
#UserInfo: string & =~"^\(_userInfoPattern)$"

// reg-name = *( unreserved / pct-encoded / sub-delims )
#RegName: string & =~"^\(_regNamePattern)$"

// host = IP-literal / IPv4address / reg-name. IP forms are not constrained here.
#Host: string

// port = *DIGIT in the ABNF; this is the component when present.
#Port: string & =~"^[0-9]+$"

// segment = *pchar ; segment-nz = 1*pchar
#Segment:   string & =~"^\(_pcharPattern)*$"
#SegmentNZ: string & =~"^\(_pcharPattern)+$"

// Path productions are several alternatives (abempty, absolute, rootless,
// empty). Nominal; not a closed parser.
#Path: string

// query / fragment = *( pchar / "/" / "?" ) — same grammar.
// Values only: do not include the leading "?" or "#".
#Query:    string & =~"^\(_queryFragmentPattern)$"
#Fragment: string & =~"^\(_queryFragmentPattern)$"

// "Slug" is not an RFC 3986 term. A non-empty path segment of unreserved
// characters (RFC 3986 §2.3: ALPHA / DIGIT / "-" / "." / "_" / "~"), which
// never require percent-encoding.
#Slug: string & =~"^\(_unreservedPattern)+$"

// Decomposed URI-reference. Optional fields omitted when absent.
// Not parsed from #URL. Applications can generate a string from this.
#URLStruct: {
	scheme?:   #Scheme
	userinfo?: #UserInfo
	host?:     #Host
	port?:     #Port
	path?:     #Path
	query?:    #Query
	fragment?: #Fragment
}

// Decomposed URI: #URLStruct with a required scheme.
#URIStruct: #URLStruct & {
	scheme: #Scheme
}

_examples: {
	urlRelative: #URL & "foo/bar"
	urlAbsolute: #URL & "https://example.com/x"
	uri:         #URI & "https://example.com/x"
	uriRef:      #URIReference & "foo/bar"
	relRef:      #RelativeRef & "../x"
	relNet:      #NetworkPathRef & "//cdn.example.com/lib.js"
	absURI:      #AbsoluteURI & "https://example.com/x"
	absHTTPS:    #AbsoluteURL & "https://example.com/x"
	absYerk:     #AbsoluteURL & "yerk://personal/yerk"
	absSSH:      #AbsoluteURL & "ssh://git@github.com/salotz/yerk.git"
	absFile:     #AbsoluteURL & "file:///home/salotz/src/yerk.git"
	absMailto:   #AbsoluteURL & "mailto:sam@hello.com"
	absTel:      #AbsoluteURL & "tel:+12025550123"

	schemeRFC: #Scheme & "https"

	userinfo:      #UserInfo & "git"
	userinfoPW:    #UserInfo & "user:token"
	regName:       #RegName & "github.com"
	port:          #Port & "443"
	segment:       #Segment & "yerk.git"
	segmentEmpty:  #Segment & ""
	segmentNZ:     #SegmentNZ & "feat"
	query:         #Query & "foo=1&bar=2"
	queryEmpty:    #Query & ""
	queryQ:        #Query & "q=a?/b"
	fragment:      #Fragment & "section-2"
	fragmentEmpty: #Fragment & ""
	slug:          #Slug & "my-page_1"
	slugDot:       #Slug & "v1.2"
	slugTilde:     #Slug & "~user"

	urlStruct: #URLStruct & {
		scheme:   "https"
		host:     "example.com"
		port:     "443"
		path:     "/repo.git"
		query:    "foo=1"
		fragment: "bar"
	}
	uriStruct: #URIStruct & {
		scheme: "https"
		host:   "example.com"
	}
	relStruct: #URLStruct & {
		path:  "../x"
		query: "v=1"
	}
}
