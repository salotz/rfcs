package locale

// POSIX locale names and BCP 47 language tags.
//
// POSIX: `language[_territory][.codeset][@modifier]`, plus `C` / `POSIX`.
// https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap07.html
//
// BCP 47 language tags (`en`, `en-US`, `zh-Hans`) are the Internet
// form (Accept-Language, HTML lang). They are not POSIX locale names.
// https://www.rfc-editor.org/rfc/rfc5646
//
// Env *names* (`LANG`, `LC_TIME`) stay in `varsets/locale`.
//
// `#Locale` is a complete regex: `cue fmt` parenthesizes interpolations
// after `.` / `@` and leaves them unclosed.

_languagePattern:  "[a-z]{2,3}"
_territoryPattern: "[A-Z]{2}"
_codesetPattern:   "[A-Za-z0-9][A-Za-z0-9._-]*"
_modifierPattern:  "[A-Za-z0-9][A-Za-z0-9._-]*"

#Language:  string & =~"^\(_languagePattern)$"
#Territory: string & =~"^\(_territoryPattern)$"
#Codeset:   string & =~"^\(_codesetPattern)$"
#Modifier:  string & =~"^\(_modifierPattern)$"

#C:     "C"
#POSIX: "POSIX"

// `C`, `POSIX`, `C.UTF-8`, `en_US`, `en_US.UTF-8`, `en_US.UTF-8@euro`.
#Locale: string & =~"^((C|POSIX)|[a-z]{2,3}(_[A-Z]{2})?)(\\.[A-Za-z0-9][A-Za-z0-9._-]*)?(@[A-Za-z0-9][A-Za-z0-9._-]*)?$"

#LocaleStruct: {
	language:   #Language | #C | #POSIX
	territory?: #Territory
	codeset?:   #Codeset
	modifier?:  #Modifier
}

// BCP 47 primary language plus optional script / region / variants.
// Not a full parser of grandfathered tags or extensions.
_scriptPattern: "[A-Z][a-z]{3}"
_regionPattern: "([A-Z]{2}|[0-9]{3})"

#LanguageTag: string & =~"^\(_languagePattern)(-\(_scriptPattern))?(-\(_regionPattern))?(-[A-Za-z0-9]{5,8}|-[0-9][A-Za-z0-9]{3})*$"

#LanguageTagStruct: {
	language: #Language
	script?:  string & =~"^\(_scriptPattern)$"
	region?:  string & =~"^\(_regionPattern)$"
	variants?: [...string]
}

_examples: {
	lang:      #Language & "en"
	territory: #Territory & "US"
	c:         #Locale & "C"
	posix:     #Locale & "POSIX"
	cUTF:      #Locale & "C.UTF-8"
	en:        #Locale & "en"
	enUS:      #Locale & "en_US"
	full:      #Locale & "en_US.UTF-8"
	euro:      #Locale & "de_DE.UTF-8@euro"
	codeset:   #Codeset & "UTF-8"
	locStruct: #LocaleStruct & {
		language:  "en"
		territory: "US"
		codeset:   "UTF-8"
	}
	cStruct: #LocaleStruct & {language: "C", codeset: "UTF-8"}
	tag:     #LanguageTag & "en-US"
	tagHans: #LanguageTag & "zh-Hans"
	tagStruct: #LanguageTagStruct & {
		language: "zh"
		script:   "Hans"
		region:   "CN"
	}
}
