package email

import "salotz.info/unix/hostname"

// Unix mailbox names: local aliases and `user@host` where host may be
// a single-label nodename (`sam@laptop`).
//
// Internet addr-spec (`sam@hello.com`) lives in `salotz.info/url/email`
// (RFC 5321/5322). This package does not import it: a local mailbox
// is not an Internet address, and short hostnames fail that domain
// grammar (two DNS labels).

_localPattern: "[A-Za-z0-9._+-]+"
_hostPattern:  "[A-Za-z0-9]([A-Za-z0-9.-]*[A-Za-z0-9])?"

// `/etc/aliases`, `mail` local part, plus-addressing. Not a POSIX
// login name (those are `path.#LoginName`).
#LocalMailbox: string & =~"^\(_localPattern)$"

// `user@host` — host is a unix hostname (nodename or FQDN).
#Address: string & =~"^\(_localPattern)@\(_hostPattern)$"

#AddressStruct: {
	localPart: #LocalMailbox
	host:      hostname.#Hostname
}

_examples: {
	root:  #LocalMailbox & "root"
	plus:  #LocalMailbox & "sam+cron"
	dots:  #LocalMailbox & "mailer-daemon"
	short: #Address & "sam@laptop"
	fqdn:  #Address & "sam@laptop.example.com"
	struct: #AddressStruct & {
		localPart: "sam"
		host:      "laptop"
	}
	structFQDN: #AddressStruct & {
		localPart: "sam+cron"
		host:      "mail.example.com"
	}
}
