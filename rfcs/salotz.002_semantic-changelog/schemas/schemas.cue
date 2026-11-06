package schemas

import (
	kac "keepachangelog.com/keep-a-changelog/1.1.0:schemas"
	datetime "salotz.info/std/datetime"
	trailers "salotz.info/git/trailers"
	dirshape "salotz.info/rfcs/033_dirshape:schemas"
)

// salotz.002_semantic-changelog — Growth versioning, changelog sections,
// and git trailers for semantic change metadata.

// B.R.G with optional R (B.G), e.g. "0.0", "0.0.0", "1.2.3".
#Version: string & =~"^[0-9]+\\.[0-9]+(\\.[0-9]+)?$"

#VersionParts: {
	breakage:    int & >=0
	regression?: int & >=0
	growth:      int & >=0
}

#ISODate: datetime.#Date

#ChangeCategory: "growth" | "breakage" | "regression"

#GrowthKind:     "feature" | "relaxed" | "repair" | "performance" | "clarity" | "robustness"
#BreakageKind:   "stricter" | "stingier" | "replaced" | "rename" | "removal"
#RegressionKind: "hamstring" | "deprecation" | "pollution" | "noisier"

#ChangeKind: #GrowthKind | #BreakageKind | #RegressionKind

#ChangeFull: string & =~"^(growth/(feature|relaxed|repair|performance|clarity|robustness)|breakage/(stricter|stingier|replaced|rename|removal)|regression/(hamstring|deprecation|pollution|noisier))$"

#Audience: "users" | "contributors"

#TrailerKey: trailers.#Key & ("Change" | "Change-Full" | "Audience")

#ChangelogSection: "Improvements" | "Breakages" | "Regressions"

#ChangeTrailer: trailers.#TrailerStruct & {
	key:   "Change"
	value: #ChangeCategory
}

#ChangeFullTrailer: trailers.#TrailerStruct & {
	key:   "Change-Full"
	value: #ChangeFull
}

#AudienceTrailer: trailers.#TrailerStruct & {
	key:   "Audience"
	value: #Audience
}

// Parsed git trailers. All three keys are repeatable.
#Trailers: {
	Change?: [...#ChangeCategory]
	"Change-Full"?: [...#ChangeFull]
	Audience?: [...#Audience]
}

#ChangelogEntry: {
	version:  #Version | "Unreleased"
	date?:    #ISODate
	yanked?:  bool
	summary?: string
	improvements?: [...string]
	breakages?: [...string]
	regressions?: [...string]
}

// CHANGELOG.md at the injected project root.
#ChangelogLayoutSpec: dirshape.#LayoutSpec & {
	entries: {
		changelog: {name: kac.#Filename}
	}
}

_examples: {
	version: #Version & "0.2.0"
	short:   #Version & "0.0"
	parts: #VersionParts & {breakage: 0, growth: 2}
	category: #ChangeCategory & "growth"
	full:     #ChangeFull & "growth/performance"
	audience: #Audience & "users"
	trailers: #Trailers & {Change: ["growth"], Audience: ["contributors"]}
	changeT: #ChangeTrailer & {key: "Change", value: "growth"}
	unreleased: #ChangelogEntry & {version: "Unreleased"}
	released: #ChangelogEntry & {version: "0.2.0", date: "2026-08-01"}
	kacFile: kac.#Filename & "CHANGELOG.md"
	layout:  #ChangelogLayoutSpec
}
