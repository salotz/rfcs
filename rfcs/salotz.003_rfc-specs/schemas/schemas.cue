package schemas

import (
	rfc004 "salotz.info/rfcs/004_nexps:schemas"
	dirshape "salotz.info/rfcs/033_dirshape:schemas"
)

// salotz.003_rfc-specs — required RFC metadata and nexp naming.

// handle.XXX_short-name
// XXX is digits and/or capital letters (typically 001-999).
// short-name is optional; further underscore-separated fields are allowed.
#RFCNexp: rfc004.#Nexp & =~"^[a-zA-Z0-9]+\\.[0-9A-Z]+(_[A-Za-z0-9]+(-[A-Za-z0-9]+)*)*$"

#RFC: {
	nexp:                #RFCNexp
	"long name":         string
	"executive summary": string
}

// Injected root is one RFC directory (`rfcs/<nexp>/`). README.md is
// the proposal; schemas/ holds the CUE module.
#ProposalLayoutSpec: dirshape.#LayoutSpec & {
	entries: {
		readme: {name: "README.md"}
		schemas: {
			name:     "schemas/"
			presence: "optional"
		}
	}
}

_examples: {
	nexp: #RFCNexp & "salotz.003_rfc-specs"
	parsed: rfc004.#Parsed & {raw: "salotz.012_information-errors"}
	rfc: #RFC & {
		nexp:                "salotz.003_rfc-specs"
		"long name":         "RFC Specifications"
		"executive summary": "Meta-specification for the RFC process itself."
	}
	layout: #ProposalLayoutSpec
}
