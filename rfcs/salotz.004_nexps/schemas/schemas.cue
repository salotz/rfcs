package schemas

import "list"
import "strings"

// salotz.004_nexps — namespaced expressions.
// '.' separates namespaces (refinements). '_' separates equal-priority
// fields in a name. '-' is intra-field whitespace. POSIX-filename compatible.

#Field: string & =~"^[A-Za-z0-9]+(-[A-Za-z0-9]+)*$"

// One namespace or name segment: fields joined by underscores.
#Segment: string & =~"^[A-Za-z0-9]+(-[A-Za-z0-9]+)*(_[A-Za-z0-9]+(-[A-Za-z0-9]+)*)*$"

// Fully qualified nexp: one or more '.'-separated segments.
#Nexp: string & =~"^[A-Za-z0-9]+(-[A-Za-z0-9]+)*(_[A-Za-z0-9]+(-[A-Za-z0-9]+)*)*(\\.[A-Za-z0-9]+(-[A-Za-z0-9]+)*(_[A-Za-z0-9]+(-[A-Za-z0-9]+)*)*)*$"

// Split a nexp into namespace segments, final name, and name fields.
#Parsed: {
	raw:        #Nexp
	segments:   strings.Split(raw, ".")
	name:       segments[len(segments)-1]
	namespaces: list.Slice(segments, 0, len(segments)-1)
	fields:     strings.Split(name, "_")
}

_examples: {
	simple: #Nexp & "namespace.name"
	rfc:    #Nexp & "salotz.002_semantic-changelog"
	fields: #Nexp & "format.namespace.field-1_field-2"
	field:  #Field & "field-1"
	parsed: #Parsed & {raw: "salotz.002_semantic-changelog"}
}
