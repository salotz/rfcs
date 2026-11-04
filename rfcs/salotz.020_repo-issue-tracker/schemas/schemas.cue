package schemas

import rfc004 "salotz.info/rfcs/004_nexps:schemas"

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

#Layout: {
	config:      #ConfigFilename
	issuesDir:   #IssuesDirName
	tickets:     #TicketsDirName
	attachments: #AttachmentsDirName
}

_examples: {
	id:     #IssueID & "000002_issue-key"
	toml:   #TicketFilename & "0.issue.toml"
	named:  #TicketFilename & "000002_issue-key.issue.txt"
	json:   #TicketFilename & "my-important-issue.issue.json"
	attach: #AttachmentDirName & "0.d"
}
