package schemas

// Keep a Changelog 1.1.0 — file layout only.
// https://keepachangelog.com/en/1.1.0/

#Filename: "CHANGELOG.md"

#ISODate: string & =~"^[0-9]{4}-[0-9]{2}-[0-9]{2}$"

// Heading versions are SemVer-like X.Y.Z; Unreleased has no date.
#SemVer: string & =~"^[0-9]+\\.[0-9]+\\.[0-9]+$"

#VersionLabel: #SemVer | "Unreleased"

#Section: "Added" | "Changed" | "Deprecated" | "Removed" | "Fixed" | "Security"

#Entry: {
	version: #VersionLabel
	if version != "Unreleased" {
		date: #ISODate
	}
	yanked?: bool
	added?: [...string]
	changed?: [...string]
	deprecated?: [...string]
	removed?: [...string]
	fixed?: [...string]
	security?: [...string]
}

#Changelog: {
	title: "Changelog"
	entries: [...#Entry]
}

_examples: {
	file: #Filename & "CHANGELOG.md"
	unreleased: #Entry & {version: "Unreleased"}
	released: #Entry & {version: "1.0.0", date: "2017-06-20"}
	yanked: #Entry & {version: "0.0.5", date: "2014-12-13", yanked: true}
	section: #Section & "Added"
}
