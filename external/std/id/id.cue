package id

// Unique identifier strings.
//
// UUID: RFC 9562 (was RFC 4122). Versions 1–8 share the 8-4-4-4-12
// hex form. Version-specific types constrain the version nibble and
// RFC 4122 variant (`8`, `9`, `a`, `b`).
// https://www.rfc-editor.org/rfc/rfc9562
//
// Other schemes (not UUIDs): ULID, KSUID, TypeID, NanoID, xid.
// These are lexical forms, not generators.

_hexPattern: "[0-9A-Fa-f]"

_uuidPattern: "\(_hexPattern){8}-\(_hexPattern){4}-\(_hexPattern){4}-\(_hexPattern){4}-\(_hexPattern){12}"

// Canonical UUID with hyphens. Mixed case allowed.
#UUID: string & =~"^\(_uuidPattern)$"

// 32 hex digits, no hyphens.
#UUIDHex: string & =~"^(\(_hexPattern)){32}$"

#UUIDVersion: 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8

// RFC 4122 / RFC 9562 variant nibble.
_variantPattern: "[89ABab]"

#UUIDv1: #UUID & =~"^(\(_hexPattern)){8}-(\(_hexPattern)){4}-1(\(_hexPattern)){3}-\(_variantPattern)(\(_hexPattern)){3}-(\(_hexPattern)){12}$"
#UUIDv3: #UUID & =~"^(\(_hexPattern)){8}-(\(_hexPattern)){4}-3(\(_hexPattern)){3}-\(_variantPattern)(\(_hexPattern)){3}-(\(_hexPattern)){12}$"
#UUIDv4: #UUID & =~"^(\(_hexPattern)){8}-(\(_hexPattern)){4}-4(\(_hexPattern)){3}-\(_variantPattern)(\(_hexPattern)){3}-(\(_hexPattern)){12}$"
#UUIDv5: #UUID & =~"^(\(_hexPattern)){8}-(\(_hexPattern)){4}-5(\(_hexPattern)){3}-\(_variantPattern)(\(_hexPattern)){3}-(\(_hexPattern)){12}$"
#UUIDv6: #UUID & =~"^(\(_hexPattern)){8}-(\(_hexPattern)){4}-6(\(_hexPattern)){3}-\(_variantPattern)(\(_hexPattern)){3}-(\(_hexPattern)){12}$"
#UUIDv7: #UUID & =~"^(\(_hexPattern)){8}-(\(_hexPattern)){4}-7(\(_hexPattern)){3}-\(_variantPattern)(\(_hexPattern)){3}-(\(_hexPattern)){12}$"
#UUIDv8: #UUID & =~"^(\(_hexPattern)){8}-(\(_hexPattern)){4}-8(\(_hexPattern)){3}-\(_variantPattern)(\(_hexPattern)){3}-(\(_hexPattern)){12}$"

#NilUUID: "00000000-0000-0000-0000-000000000000"
#MaxUUID: string & =~"^[fF]{8}-[fF]{4}-[fF]{4}-[fF]{4}-[fF]{12}$"

#UUIDStruct: {
	timeLow:  string & =~"^(\(_hexPattern)){8}$"
	timeMid:  string & =~"^(\(_hexPattern)){4}$"
	timeHi:   string & =~"^(\(_hexPattern)){4}$"
	clockSeq: string & =~"^(\(_hexPattern)){4}$"
	node:     string & =~"^(\(_hexPattern)){12}$"
	version?: #UUIDVersion
}

// Crockford base32 (no I, L, O, U). ULID and TypeID suffixes use this.
_crockfordPattern: "[0-9A-HJKMNP-TV-Z]"

// ULID: 26 Crockford characters. First 10 are a timestamp.
// https://github.com/ulid/spec
#ULID: string & =~"^(\(_crockfordPattern)){26}$"

#ULIDStruct: {
	timestamp:  string & =~"^(\(_crockfordPattern)){10}$"
	randomness: string & =~"^(\(_crockfordPattern)){16}$"
}

// KSUID: 27 base62 characters (20 bytes: 32-bit epoch + 16-byte payload).
// https://github.com/segmentio/ksuid
#KSUID: string & =~"^[0-9A-Za-z]{27}$"

// TypeID: `prefix_suffix`. Suffix is a UUID in Crockford base32 (26 chars).
// https://github.com/jetify-com/typeid
_typeIDPrefixPattern: "[a-z]([a-z_]{0,61}[a-z])?"

#TypeIDPrefix: string & =~"^\(_typeIDPrefixPattern)$"
#TypeIDSuffix: #ULID
#TypeID:       string & =~"^\(_typeIDPrefixPattern)_(\(_crockfordPattern)){26}$"

#TypeIDStruct: {
	prefix: #TypeIDPrefix
	suffix: #TypeIDSuffix
}

// NanoID default alphabet (`A-Za-z0-9_-`). Default size is 21.
// https://github.com/ai/nanoid
#NanoID:        string & =~"^[A-Za-z0-9_-]+$"
#NanoIDDefault: string & =~"^[A-Za-z0-9_-]{21}$"

// xid (rs/xid): 20 lowercase base32 characters.
// https://github.com/rs/xid
#XID: string & =~"^[0-9a-v]{20}$"

_examples: {
	uuid:    #UUID & "6ba7b810-9dad-11d1-80b4-00c04fd430c8"
	uuidHex: #UUIDHex & "6ba7b8109dad11d180b400c04fd430c8"
	v1:      #UUIDv1 & "6ba7b810-9dad-11d1-80b4-00c04fd430c8"
	v4:      #UUIDv4 & "550e8400-e29b-41d4-a716-446655440000"
	v7:      #UUIDv7 & "018f3e4b-0c2a-7000-8000-000000000000"
	nilID:   #NilUUID & "00000000-0000-0000-0000-000000000000"
	maxID:   #MaxUUID & "ffffffff-ffff-ffff-ffff-ffffffffffff"
	uuidStruct: #UUIDStruct & {
		timeLow:  "550e8400"
		timeMid:  "e29b"
		timeHi:   "41d4"
		clockSeq: "a716"
		node:     "446655440000"
		version:  4
	}

	ulid: #ULID & "01ARZ3NDEKTSV4RRFFQ69G5FAV"
	ulidStruct: #ULIDStruct & {
		timestamp:  "01ARZ3NDEK"
		randomness: "TSV4RRFFQ69G5FAV"
	}

	ksuid: #KSUID & "0ujsswThIGEVatdMzyadTn5mcOw"

	typeID: #TypeID & "user_01ARZ3NDEKTSV4RRFFQ69G5FAV"
	typeIDStruct: #TypeIDStruct & {
		prefix: "user"
		suffix: "01ARZ3NDEKTSV4RRFFQ69G5FAV"
	}

	nanoid: #NanoIDDefault & "V1StGXR8_Z5jdHi6B-myT"
	xid:    #XID & "9m4e2mr0ui3e8a215n4g"
}
