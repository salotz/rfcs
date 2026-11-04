package email

// Email addresses (addr-spec) and mailboxes.
//
// Practical subset of RFC 5321 / RFC 5322: dot-atom local-part and
// LDH domain. Quoted-string local-parts, domain-literals, comments,
// folding whitespace, and SMTPUTF8 (RFC 6531) are out of scope.
//
// Plus addressing (RFC 5233 subaddressing): `sam+accounting@hello.com`.
// https://www.rfc-editor.org/rfc/rfc5321
// https://www.rfc-editor.org/rfc/rfc5322
// https://www.rfc-editor.org/rfc/rfc5233

// atext = ALPHA / DIGIT / "!" / "#" / "$" / "%" / "&" / "'" /
//         "*" / "+" / "-" / "/" / "=" / "?" / "^" / "_" / "`" /
//         "{" / "|" / "}" / "~"
_atextPattern:       "[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]"
_atextNoPlusPattern: "[A-Za-z0-9!#$%&'*/=?^_`{|}~-]"
// dot-atom-text = 1*atext *("." 1*atext)
_dotAtomPattern:       "\(_atextPattern)+(\\.\(_atextPattern)+)*"
_dotAtomNoPlusPattern: "\(_atextNoPlusPattern)+(\\.\(_atextNoPlusPattern)+)*"
// LDH label: letter or digit, then LDH, ending on alnum. Single char OK.
_domainLabelPattern: "[A-Za-z0-9]([A-Za-z0-9-]{0,61}[A-Za-z0-9])?"
_domainPattern:      "\(_domainLabelPattern)(\\.\(_domainLabelPattern))+"

// Local-part as dot-atom (plus is ordinary atext, so plus-addressing
// is included). No quoted-string.
#LocalPart: string & =~"^\(_dotAtomPattern)$"

// DNS-ish domain: at least two labels (`hello.com`). Not a bracketed
// domain-literal. `localhost` as a single label is not this type.
#Domain: string & =~"^\(_domainPattern)$"

// addr-spec = local-part "@" domain
#Address: string & =~"^\(_dotAtomPattern)@\(_domainPattern)$"

// RFC 5233: local-part contains a `+`. `user+tag@domain`.
#PlusAddress: #Address & =~"^[^+]+\\+"

// Display name in a mailbox. No angle brackets or newlines.
#DisplayName: string & !="" & !~"[<>\n\r]"

// `<sam@hello.com>` (RFC 5322 angle-addr, no CFWS).
#AngleAddress: string & =~"^<\(_dotAtomPattern)@\(_domainPattern)>$"

// mailbox = name-addr / addr-spec
// name-addr ≈ `Display Name <addr>` (no quoted display, no CFWS).
#Mailbox:
	#Address |
	(string & =~"^[^<>\n\r]+ <\(_dotAtomPattern)@\(_domainPattern)>$")

#AddressStruct: {
	localPart: #LocalPart
	domain:    #Domain
}

// user + tag @ domain. `user` and `tag` do not themselves contain `+`.
#PlusAddressStruct: {
	user:   string & =~"^\(_dotAtomNoPlusPattern)$"
	tag:    string & =~"^\(_atextPattern)+$"
	domain: #Domain
}

#MailboxStruct: {
	displayName?: #DisplayName
	address:      #Address
}

_examples: {
	local:   #LocalPart & "sam"
	plusLoc: #LocalPart & "sam+accounting"
	dots:    #LocalPart & "first.last"
	domain:  #Domain & "hello.com"
	coUk:    #Domain & "hello.co.uk"

	addr:    #Address & "sam@hello.com"
	plus:    #PlusAddress & "sam+accounting@hello.com"
	dotted:  #Address & "first.last@hello.com"
	tagDots: #PlusAddress & "first.last+invoices@hello.com"

	angle:   #AngleAddress & "<sam@hello.com>"
	display: #DisplayName & "Sam Hello"
	mbox:    #Mailbox & "sam@hello.com"
	named:   #Mailbox & "Sam Hello <sam@hello.com>"

	addrStruct: #AddressStruct & {
		localPart: "sam"
		domain:    "hello.com"
	}
	plusStruct: #PlusAddressStruct & {
		user:   "sam"
		tag:    "accounting"
		domain: "hello.com"
	}
	mboxStruct: #MailboxStruct & {
		displayName: "Sam Hello"
		address:     "sam@hello.com"
	}
	mboxBare: #MailboxStruct & {
		address: "sam+accounting@hello.com"
	}
}
