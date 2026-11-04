package common

import (
	"salotz.info/url/core"
	"salotz.info/url/email"
	"salotz.info/url/urn"
)

// Well-known URI schemes and their string / struct forms.
//
// Hierarchical locator schemes use `scheme://` (RFC 3986). `mailto`
// (RFC 6068) and `tel` (RFC 3966) do not. `#MailtoURLStruct` and
// `#TelURLStruct` are the decomposed forms; `#HTTPURLStruct` and
// friends are `#URIStruct` with a fixed scheme.

#HTTPScheme:   "http"
#HTTPSScheme:  "https"
#SSHScheme:    "ssh"
#FileScheme:   "file"
#GitScheme:    "git"
#FTPScheme:    "ftp"
#FTPSScheme:   "ftps"
#MailtoScheme: "mailto"
#TelScheme:    "tel"

#WellKnownScheme:
	#HTTPScheme |
	#HTTPSScheme |
	#SSHScheme |
	#FileScheme |
	#GitScheme |
	#FTPScheme |
	#FTPSScheme |
	#MailtoScheme |
	#TelScheme |
	urn.#Scheme

#HTTPURL:  core.#AbsoluteURL & =~"^\(#HTTPScheme)://"
#HTTPSURL: core.#AbsoluteURL & =~"^\(#HTTPSScheme)://"
#SSHURL:   core.#AbsoluteURL & =~"^\(#SSHScheme)://"
#FileURL:  core.#AbsoluteURL & =~"^\(#FileScheme)://"

// git:// protocol (not a git SCP remote, not https://…/.git).
#GitSchemeURL: core.#AbsoluteURL & =~"^\(#GitScheme)://"

#FTPURL:  core.#AbsoluteURL & =~"^\(#FTPScheme)://"
#FTPSURL: core.#AbsoluteURL & =~"^\(#FTPSScheme)://"

// mailto: [ to ] [ "?" hfields ]  — RFC 6068. No `//`.
// https://www.rfc-editor.org/rfc/rfc6068
#MailtoURL: core.#URI & =~"^\(#MailtoScheme):"

// tel: telephone-subscriber  — RFC 3966. No `//`.
// https://www.rfc-editor.org/rfc/rfc3966
#TelURL: core.#URI & =~"^\(#TelScheme):"

// Visual separators in a telephone-subscriber: `-` `.` `(` `)`.
_phoneDigitPattern: "[0-9.()-]"

// Global number: `+` then digits (and visual separators).
#GlobalNumber: string & =~"^\\+\(_phoneDigitPattern)+$"

// Local number: digits, no leading `+`.
#LocalNumber: string & =~"^\(_phoneDigitPattern)+$"
#LocalNumber: !~"^\\+"

#TelephoneNumber: #GlobalNumber | #LocalNumber

#HTTPURLStruct: core.#URIStruct & {
	scheme: #HTTPScheme
}

#HTTPSURLStruct: core.#URIStruct & {
	scheme: #HTTPSScheme
}

#SSHURLStruct: core.#URIStruct & {
	scheme: #SSHScheme
}

#FileURLStruct: core.#URIStruct & {
	scheme: #FileScheme
}

#GitSchemeURLStruct: core.#URIStruct & {
	scheme: #GitScheme
}

#FTPURLStruct: core.#URIStruct & {
	scheme: #FTPScheme
}

#FTPSURLStruct: core.#URIStruct & {
	scheme: #FTPSScheme
}

// Decomposed mailto. `to` may be empty when headers carry recipients
// (`mailto:?to=sam@hello.com`). Extra header fields are not modelled.
#MailtoURLStruct: {
	scheme: #MailtoScheme
	to: [...email.#Address]
	cc?: [...email.#Address]
	bcc?: [...email.#Address]
	subject?: string
	body?:    string
}

// Decomposed tel. Common parameters only (`ext`, `phone-context`).
#TelURLStruct: {
	scheme:        #TelScheme
	number:        #TelephoneNumber
	extension?:    string
	phoneContext?: string
}

_examples: {
	schemeHTTP:   #HTTPScheme & "http"
	schemeHTTPS:  #HTTPSScheme & "https"
	schemeSSH:    #SSHScheme & "ssh"
	schemeFile:   #FileScheme & "file"
	schemeGit:    #GitScheme & "git"
	schemeFTP:    #FTPScheme & "ftp"
	schemeFTPS:   #FTPSScheme & "ftps"
	schemeMailto: #MailtoScheme & "mailto"
	schemeTel:    #TelScheme & "tel"
	wellKnown:    #WellKnownScheme & "https"
	wellKnownURN: #WellKnownScheme & "urn"
	wellMailto:   #WellKnownScheme & "mailto"
	wellTel:      #WellKnownScheme & "tel"

	http:       #HTTPURL & "http://example.com/repo.git"
	https:      #HTTPSURL & "https://github.com/salotz/yerk.git"
	httpsPort:  #HTTPSURL & "https://example.com:8443/repo.git"
	httpsQuery: #HTTPSURL & "https://example.com/repo.git?foo=1#bar"
	ssh:        #SSHURL & "ssh://git@github.com/salotz/yerk.git"
	sshPort:    #SSHURL & "ssh://git@github.com:22/salotz/yerk.git"
	file:       #FileURL & "file:///home/salotz/src/yerk.git"
	gitScheme:  #GitSchemeURL & "git://git.kernel.org/pub/scm/git/git.git"
	ftp:        #FTPURL & "ftp://example.com/repo.git"
	ftps:       #FTPSURL & "ftps://example.com/repo.git"

	mailto:     #MailtoURL & "mailto:sam@hello.com"
	mailtoPlus: #MailtoURL & "mailto:sam+accounting@hello.com"
	mailtoQ:    #MailtoURL & "mailto:sam@hello.com?subject=Hello"
	mailtoTo:   #MailtoURL & "mailto:?to=sam@hello.com"
	mailtoMany: #MailtoURL & "mailto:sam@hello.com,other@hello.com"

	tel:      #TelURL & "tel:+12025550123"
	telSep:   #TelURL & "tel:+1-202-555-0123"
	telLocal: #TelURL & "tel:7042"
	global:   #GlobalNumber & "+12025550123"
	local:    #LocalNumber & "7042"

	httpsStruct: #HTTPSURLStruct & {
		scheme: "https"
		host:   "github.com"
		path:   "/salotz/yerk.git"
	}
	sshStruct: #SSHURLStruct & {
		scheme:   "ssh"
		userinfo: "git"
		host:     "github.com"
		path:     "/salotz/yerk.git"
	}
	fileStruct: #FileURLStruct & {
		scheme: "file"
		path:   "/home/salotz/src/yerk.git"
	}
	mailtoStruct: #MailtoURLStruct & {
		scheme: "mailto"
		to: ["sam@hello.com"]
		subject: "Hello"
	}
	mailtoPlusStruct: #MailtoURLStruct & {
		scheme: "mailto"
		to: ["sam+accounting@hello.com"]
	}
	mailtoCc: #MailtoURLStruct & {
		scheme: "mailto"
		to: ["sam@hello.com"]
		cc: ["other@hello.com"]
		body: "Hi"
	}
	telStruct: #TelURLStruct & {
		scheme: "tel"
		number: "+12025550123"
	}
	telExt: #TelURLStruct & {
		scheme:       "tel"
		number:       "7042"
		phoneContext: "example.com"
		extension:    "123"
	}
}
