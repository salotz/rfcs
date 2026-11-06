package schemas

import (
	rfc004 "salotz.info/rfcs/004_nexps:schemas"
	rfc029 "salotz.info/rfcs/029_glossary-format:schemas"
	datetime "salotz.info/std/datetime"
	dirshape "salotz.info/rfcs/033_dirshape:schemas"
)

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

#ISODate: datetime.#Date

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

// Injected root is the project / replica root. Not every component is
// required; AGENTS.md is the bootloader. contributing/ and
// CONTRIBUTING.md are mutually exclusive in prose (both optional here).
#RepoLayoutSpec: dirshape.#LayoutSpec & {
	entries: {
		bootloader: {name: #Bootloader}
		agents: {
			name:     ".agents/"
			presence: "optional"
			children: {
				skills: {name: "skills/", presence: "optional"}
				plugins: {name: "plugins/", presence: "optional"}
				agents: {name: "agents/", presence: "optional"}
				context: {name: "context/", presence: "optional"}
			}
		}
		design: {
			name:     "design/"
			presence: "optional"
			children: {
				readme: {name: "README.md"}
				agents: {name: "AGENTS.md", presence: "optional"}
				goals: {name: "goals.md"}
				glossary: {name: rfc029.#DefaultFilename, presence: "optional"}
				architecture: {name: "architecture/", presence: "optional"}
				decisions: {
					name:     "decisions/"
					presence: "optional"
					children: {
						adr: {
							name:     "^[0-9]+_.+\\.md$"
							match:    "pattern"
							presence: "optional"
						}
					}
				}
			}
		}
		contributingDir: {
			name:     "contributing/"
			presence: "optional"
			children: {
				readme: {name: "README.md"}
				agents: {name: "AGENTS.md", presence: "optional"}
			}
		}
		contributingFile: {
			name:     #ContributingFile
			presence: "optional"
		}
	}
}

_examples: {
	adrBase:  #ADRBasename & "0001_decision-name"
	adrFile:  #ADRFilename & "0001_decision-name.md"
	glossary: rfc029.#DefaultFilename & "glossary.md"
	date:     #ISODate & "2026-01-01"
	layout:   #RepoLayoutSpec
	adr: #ADR & {
		id:           "0000"
		name:         "Long Name of Decision"
		status:       "Proposed"
		date:         "2026-01-01"
		context:      "forces at play"
		decision:     "the change"
		consequences: "positive and negative"
	}
}
