package schemas

import (
	rfc004 "salotz.info/rfcs/004_nexps:schemas"
	dirshape "salotz.info/rfcs/033_dirshape:schemas"
)

// salotz.020_repo-issue-tracker — in-repo tickets and attachment layout.
// issues.toml key names are not specified by the RFC; only the file's
// existence at the project root is.

#IssuesDirName:      "issues" | ".issues"
#TicketsDirName:     "tickets"
#AttachmentsDirName: "attachments"
#ConfigFilename:     "issues.toml"

#IssueID: rfc004.#Segment

// <issue_id>.issue.<schema>
#TicketFilename: string & =~"^.+\\.issue\\.[A-Za-z0-9]+$"

// Sidecar folder named <issue_id>.d under attachments/
#AttachmentDirName: string & =~"^.+\\.d$"

// Injected root is the project root. `issues/` and `.issues/` are the
// two names tools probe; both are optional on disk.
#IssuesLayoutSpec: dirshape.#LayoutSpec & {
	entries: {
		config: {name: #ConfigFilename}
		issues: {
			name:     "issues/"
			presence: "optional"
			children: {
				tickets: {
					name: "tickets/"
					children: {
						ticket: {
							name:     "^.+\\.issue\\.[A-Za-z0-9]+$"
							match:    "pattern"
							presence: "optional"
						}
					}
				}
				attachments: {
					name:     "attachments/"
					presence: "optional"
					children: {
						sidecar: {
							name:     "*.d/"
							match:    "glob"
							presence: "optional"
						}
					}
				}
			}
		}
		hiddenIssues: {
			name:     ".issues/"
			presence: "optional"
			children: {
				tickets: {
					name: "tickets/"
					children: {
						ticket: {
							name:     "^.+\\.issue\\.[A-Za-z0-9]+$"
							match:    "pattern"
							presence: "optional"
						}
					}
				}
				attachments: {
					name:     "attachments/"
					presence: "optional"
					children: {
						sidecar: {
							name:     "*.d/"
							match:    "glob"
							presence: "optional"
						}
					}
				}
			}
		}
	}
}

_examples: {
	id:     #IssueID & "000002_issue-key"
	toml:   #TicketFilename & "0.issue.toml"
	named:  #TicketFilename & "000002_issue-key.issue.txt"
	json:   #TicketFilename & "my-important-issue.issue.json"
	attach: #AttachmentDirName & "0.d"
	layout: #IssuesLayoutSpec
}
