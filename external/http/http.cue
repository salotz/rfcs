package http

import "salotz.info/mime"

// HTTP/1.1 message tokens: methods, status codes, header fields.
// RFC 9110. PATCH is RFC 5789.
// https://www.rfc-editor.org/rfc/rfc9110
// https://www.rfc-editor.org/rfc/rfc5789
//
// Field names are case-insensitive on the wire; these types do not
// fold case. This is not a frame parser.

_tcharPattern: "[A-Za-z0-9!#$%&'*+.^_`|~-]"
_tokenPattern: "(\(_tcharPattern))+"

#Token: string & =~"^\(_tokenPattern)$"

#MethodNames: [...string]
#MethodNames: [
	"GET", "HEAD", "POST", "PUT", "DELETE",
	"CONNECT", "OPTIONS", "TRACE", "PATCH",
]

#Method: or(#MethodNames)

// Extension method (WebDAV `PROPFIND`, …).
#MethodToken: #Token

#GET:     "GET"
#HEAD:    "HEAD"
#POST:    "POST"
#PUT:     "PUT"
#DELETE:  "DELETE"
#CONNECT: "CONNECT"
#OPTIONS: "OPTIONS"
#TRACE:   "TRACE"
#PATCH:   "PATCH"

#Version: "HTTP/1.0" | "HTTP/1.1" | "HTTP/2" | "HTTP/3"

#StatusCode: int & >=100 & <=599

#StatusCodeString: string & =~"^[1-5][0-9]{2}$"

#Informational: #StatusCode & >=100 & <=199
#Successful:    #StatusCode & >=200 & <=299
#Redirection:   #StatusCode & >=300 & <=399
#ClientError:   #StatusCode & >=400 & <=499
#ServerError:   #StatusCode & >=500 & <=599

#Continue:             100
#SwitchingProtocols:   101
#OK:                   200
#Created:              201
#Accepted:             202
#NoContent:            204
#PartialContent:       206
#MovedPermanently:     301
#Found:                302
#SeeOther:             303
#NotModified:          304
#TemporaryRedirect:    307
#PermanentRedirect:    308
#BadRequest:           400
#Unauthorized:         401
#Forbidden:            403
#NotFound:             404
#MethodNotAllowed:     405
#Conflict:             409
#Gone:                 410
#UnsupportedMediaType: 415
#UnprocessableEntity:  422
#TooManyRequests:      429
#InternalServerError:  500
#NotImplemented:       501
#BadGateway:           502
#ServiceUnavailable:   503
#GatewayTimeout:       504

#WellKnownStatusCodes: [...#StatusCode]
#WellKnownStatusCodes: [
	100, 101, 200, 201, 202, 204, 206,
	301, 302, 303, 304, 307, 308,
	400, 401, 403, 404, 405, 409, 410, 415, 422, 429,
	500, 501, 502, 503, 504,
]

#WellKnownStatusCode: or(#WellKnownStatusCodes)

#ReasonPhrase: string & !~"[\n\r]"

#StatusStruct: {
	code:    #StatusCode
	reason?: #ReasonPhrase
}

#FieldName:  #Token
#FieldValue: string & !~"[\n\r]"

#WellKnownFieldNames: [...#FieldName]
#WellKnownFieldNames: [
	"Accept", "Accept-Encoding", "Accept-Language",
	"Authorization", "Cache-Control", "Connection", "Content-Encoding",
	"Content-Length", "Content-Type", "Cookie", "Date", "ETag",
	"Host", "If-Modified-Since", "If-None-Match", "Location",
	"Origin", "Referer", "Set-Cookie", "Transfer-Encoding",
	"User-Agent", "WWW-Authenticate", "X-Request-ID",
]

#WellKnownFieldName: or(#WellKnownFieldNames)

#ContentType: mime.#MediaTypeLine

#FieldStruct: {
	name:  #FieldName
	value: #FieldValue
}

#RequestStruct: {
	method:  #MethodToken
	target:  string & !="" & !~"[\n\r]"
	version: #Version
	headers?: [...#FieldStruct]
}

#ResponseStruct: {
	version: #Version
	status:  #StatusCode
	reason?: #ReasonPhrase
	headers?: [...#FieldStruct]
}

_examples: {
	get:      #Method & "GET"
	patch:    #PATCH & "PATCH"
	custom:   #MethodToken & "PROPFIND"
	ver:      #Version & "HTTP/1.1"
	ok:       #OK & 200
	notFound: #NotFound & 404
	class:    #Successful & 201
	codeStr:  #StatusCodeString & "204"
	status: #StatusStruct & {code: 404, reason: "Not Found"}
	field: #WellKnownFieldName & "Content-Type"
	ct:    #ContentType & "application/json; charset=utf-8"
	header: #FieldStruct & {name: "Host", value: "example.com"}
	req: #RequestStruct & {
		method:  "GET"
		target:  "/yerk"
		version: "HTTP/1.1"
		headers: [
			{name: "Host", value: "example.com"},
			{name: "Accept", value: "application/json"},
		]
	}
	resp: #ResponseStruct & {
		version: "HTTP/1.1"
		status:  200
		reason:  "OK"
		headers: [
			{name: "Content-Type", value: "application/json"},
		]
	}
}
