package mailmap

// gitmailmap(5): `.mailmap` at the work-tree top.
// https://git-scm.com/docs/gitmailmap
//
// Names and emails are matched case-insensitively by Git; these
// patterns do not fold case. `#File` is a list of already-split lines.
// Emails are Git mailmap addresses (`<jane@laptop.(none)>`), not RFC 5322.

#Blank:   string & =~"^[ \t]*$"
#Comment: string & =~"^#.*$"

_wsPattern:    "[ \t]+"
_namePattern:  "[^<>#\n\r]+"
_emailPattern: "<[^<>\n\r]+>"

// `<jane@example.com>` including the brackets.
#Email: string & =~"^\(_emailPattern)$"

// Canonical or commit name. No angle brackets.
#Name: string & =~"^\(_namePattern)$"
#Name: !~"^[ \t]*$"

// `Proper Name <commit@email>`
#CommitEmailMapping: string & =~"^\(_namePattern)\(_wsPattern)\(_emailPattern)$"

// `<proper@email> <commit@email>`
#EmailMapping: string & =~"^\(_emailPattern)\(_wsPattern)\(_emailPattern)$"

// `Proper Name <proper@email> <commit@email>`
#NameEmailMapping: string & =~"^\(_namePattern)\(_wsPattern)\(_emailPattern)\(_wsPattern)\(_emailPattern)$"

// `Proper Name <proper@email> Commit Name <commit@email>`
#FullMapping: string & =~"^\(_namePattern)\(_wsPattern)\(_emailPattern)\(_wsPattern)\(_namePattern)\(_wsPattern)\(_emailPattern)$"

#Mapping:
	#CommitEmailMapping |
	#EmailMapping |
	#NameEmailMapping |
	#FullMapping

// Inner address (`jane@laptop.(none)`), not RFC 5322. Angle brackets
// are added when generating a #Email / mapping line.
#UnbracketedEmail: string & !="" & !~"[<>\n\r#]"

// Decomposed mapping. Which fields are set selects the line form.
#MappingStruct: {
	properName?:  #Name
	properEmail?: #UnbracketedEmail
	commitName?:  #Name
	commitEmail?: #UnbracketedEmail
}
#Line: #Blank | #Comment | #Mapping

#File: [...#Line]

_examples: {
	email:  #Email & "<joe@example.com>"
	name:   #Name & "Joe R. Developer"
	simple: #CommitEmailMapping & "Joe R. Developer <joe@example.com>"
	emails: #EmailMapping & "<proper@example.com> <commit@example.com>"
	both:   #NameEmailMapping & "Jane Doe <jane@example.com> <jane@laptop.(none)>"
	full:   #FullMapping & "Jane Doe <jane@example.com> Jane <bugs@example.com>"
	mapStruct: #MappingStruct & {
		properName:  "Jane Doe"
		properEmail: "jane@example.com"
		commitEmail: "jane@laptop.(none)"
	}
	comment: #Comment & "# canonical names"
	file: #File & [
		"Joe R. Developer <joe@example.com>",
		"Jane Doe <jane@example.com> <jane@laptop.(none)>",
		"Jane Doe <jane@example.com> Jane <bugs@example.com>",
		"",
	]
}
