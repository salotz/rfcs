package semver

// Semantic Versioning 2.0.0.
// https://semver.org/spec/v2.0.0.html
//
// `major.minor.patch` with optional prerelease and build. No leading
// zeros on numeric identifiers. The spec has no `v` prefix; `#Prefixed`
// is the common git-tag spelling.

_numPattern:             "0|[1-9][0-9]*"
_prereleaseIdentPattern: "0|[1-9][0-9]*|[1-9A-Za-z-][0-9A-Za-z-]*"
_buildIdentPattern:      "[0-9A-Za-z-]+"

_corePattern:       "(\(_numPattern))\\.(\(_numPattern))\\.(\(_numPattern))"
_prereleasePattern: "(\(_prereleaseIdentPattern))(\\.(\(_prereleaseIdentPattern)))*"
_buildPattern:      "(\(_buildIdentPattern))(\\.(\(_buildIdentPattern)))*"

#Core: string & =~"^\(_corePattern)$"

#Version: string & =~"^\(_corePattern)(-(\(_prereleasePattern)))?(\\+(\(_buildPattern)))?$"

// `v1.2.3` as used on git tags. Not SemVer 2.0.0.
#Prefixed: string & =~"^v(\(_corePattern)(-(\(_prereleasePattern)))?(\\+(\(_buildPattern)))?)$"

#Prerelease: string & =~"^\(_prereleasePattern)$"
#Build:      string & =~"^\(_buildPattern)$"

#VersionStruct: {
	major:       int & >=0
	minor:       int & >=0
	patch:       int & >=0
	prerelease?: #Prerelease
	build?:      #Build
}

_examples: {
	core:     #Core & "1.2.3"
	zero:     #Version & "0.0.1"
	pre:      #Version & "1.0.0-alpha"
	preDot:   #Version & "1.0.0-alpha.1"
	build:    #Version & "1.0.0+001"
	both:     #Version & "1.0.0-beta.2+exp.sha.5114f85"
	prefixed: #Prefixed & "v1.2.3"
	preTag:   #Prefixed & "v1.0.0-rc.1"
	ident:    #Prerelease & "alpha.1"
	struct: #VersionStruct & {
		major:      1
		minor:      2
		patch:      3
		prerelease: "alpha.1"
		build:      "exp.sha.5114f85"
	}
	release: #VersionStruct & {major: 2, minor: 0, patch: 0}
}
