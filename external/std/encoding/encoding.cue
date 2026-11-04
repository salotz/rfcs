package encoding

// Hex, Base64/Base32, and hex-encoded message digests.
// https://www.rfc-editor.org/rfc/rfc4648
//
// Digests here are the *hex spelling* of the hash, not the raw bytes
// and not a hasher. Git object names re-export `#SHA1` / `#SHA256`.

_hexPattern: "[0-9A-Fa-f]"

// One or more hex digits. Mixed case allowed.
#Hex: string & =~"^(\(_hexPattern))+$"

// Even-length hex (whole octets).
#HexOctets: #Hex & =~"^((\(_hexPattern)){2})+$"

#MD5:    string & =~"^(\(_hexPattern)){32}$"
#SHA1:   string & =~"^(\(_hexPattern)){40}$"
#SHA256: string & =~"^(\(_hexPattern)){64}$"
#SHA384: string & =~"^(\(_hexPattern)){96}$"
#SHA512: string & =~"^(\(_hexPattern)){128}$"

#HashAlgorithm:
	"md5" |
	"sha1" |
	"sha256" |
	"sha384" |
	"sha512"

#Digest: #MD5 | #SHA1 | #SHA256 | #SHA384 | #SHA512

#DigestStruct: {
	algorithm: #HashAlgorithm
	hex:       #Digest
}

// RFC 4648 §4: standard Base64 with padding.
#Base64: string & =~"^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{4})?$"

// Standard Base64, padding omitted.
#Base64Raw: string & =~"^[A-Za-z0-9+/]*$"

// RFC 4648 §5: URL- and filename-safe alphabet (`-` `_`), with padding.
#Base64URL: string & =~"^([A-Za-z0-9_-]{4})*([A-Za-z0-9_-]{2}==|[A-Za-z0-9_-]{3}=|[A-Za-z0-9_-]{4})?$"

#Base64URLRaw: string & =~"^[A-Za-z0-9_-]*$"

// RFC 4648 §6: Base32 with padding. Alphabet A–Z and 2–7.
#Base32: string & =~"^([A-Za-z2-7]{8})*([A-Za-z2-7]{2}======|[A-Za-z2-7]{4}====|[A-Za-z2-7]{5}===|[A-Za-z2-7]{7}=|[A-Za-z2-7]{8})?$"

#Base32Raw: string & =~"^[A-Za-z2-7]*$"

_examples: {
	hex:    #Hex & "dae86e"
	octets: #HexOctets & "dae86e"
	md5:    #MD5 & "d41d8cd98f00b204e9800998ecf8427e"
	sha1:   #SHA1 & "dae86e1950b1277e545cee180551750029cfe735"
	sha256: #SHA256 & "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
	algo:   #HashAlgorithm & "sha256"
	digest: #DigestStruct & {
		algorithm: "sha1"
		hex:       "dae86e1950b1277e545cee180551750029cfe735"
	}
	b64:    #Base64 & "SGVsbG8="
	b64raw: #Base64Raw & "SGVsbG8"
	b64url: #Base64URL & "SGVsbG8="
	b32:    #Base32 & "JBSWY3DP"
}
