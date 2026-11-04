package schemas

// salotz.014_project-declarations — README declaration topics and vocabularies.
// Stances MAY be free text; the closed enums are the preferred vocabularies.

#Topic: "lifecycle phase" | "maintenance intent" | "authorship" | "contributions" | "support"

#LifecyclePhase: "stub" | "prototype" | "incubating" | "usable" | "mature" | "deprecated" | "superseded" | "retired" | "archival"

#MaintenanceIntent: "active" | "best-effort" | "minimal" | "security-only" | "ai-maintained" | "as-is" | "seeking-maintainer" | "handed-off" | "unmaintained"

#Authorship: "hand-written" | "ai-assisted" | "ai-authored" | "vibe-coded" | "mixed"

#Contributions: "welcome" | "limited" | "issues-only" | "closed" | "maintainer-only"

#Support: "community" | "none" | "commercial"

#Unspecified: "unspecified"

// topic → stance table. Extra topics are allowed. Prefer closed vocabularies.
#Declarations: {
	[topic=string]: string
}

#DeclarationRow: {
	topic:  string
	stance: string
}

_examples: {
	phase:  #LifecyclePhase & "usable"
	intent: #MaintenanceIntent & "best-effort"
	auth:   #Authorship & "ai-authored"
	table:  #Declarations & {
		"lifecycle phase":    "usable"
		"maintenance intent": "best-effort"
		authorship:           "ai-authored"
		contributions:        "limited"
	}
}
