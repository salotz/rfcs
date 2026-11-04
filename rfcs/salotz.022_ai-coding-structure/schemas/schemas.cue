package schemas

import rfc004 "salotz.info/rfcs/004_nexps:schemas"
import rfc029 "salotz.info/rfcs/029_glossary-format:schemas"

// salotz.022_ai-coding-structure — repository paths, ADR records, glossary placement.

#Bootloader:       "AGENTS.md"
#AgentsDir:        ".agents"
#DesignDir:        "design"
#ContributingDir:  "contributing"
#ContributingFile: "CONTRIBUTING.md"

#AgentsSubdir: "skills" | "plugins" | "agents" | "context"

#DesignFile:   "README.md" | "AGENTS.md" | "goals.md" | rfc029.#DefaultFilename
#DesignSubdir: "architecture" | "decisions"

// ADR filename fields: (index, name), e.g. 0001_decision-name.md
#ADRBasename: rfc004.#Segment
#ADRFilename: string & =~"^[0-9]+_.+\\.md$"

#ADRStatus: "Proposed" | "Accepted" | "Superseded" | "Deprecated"

#ISODate: string & =~"^[0-9]{4}-[0-9]{2}-[0-9]{2}$"

#ADR: {
	id:           string
	name:         string
	status:       #ADRStatus
	date:         #ISODate
	deciders?:    string
	context:      string
	decision:     string
	consequences: string
}

#ProcessFilename: string // e.g. releases.md, process_releases.md, role_engineer.md

_examples: {
	adrBase:  #ADRBasename & "0001_decision-name"
	adrFile:  #ADRFilename & "0001_decision-name.md"
	glossary: rfc029.#DefaultFilename & "glossary.md"
	adr:      #ADR & {
		id:           "0000"
		name:         "Long Name of Decision"
		status:       "Proposed"
		date:         "2026-01-01"
		context:      "forces at play"
		decision:     "the change"
		consequences: "positive and negative"
	}
}
