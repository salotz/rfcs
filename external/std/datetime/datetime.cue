package datetime

import "time"

// Civil date and time as text. RFC 3339 / ISO 8601.
// https://www.rfc-editor.org/rfc/rfc3339
// https://www.iso.org/iso-8601-date-and-time-format.html
//
// `#DateTime` is CUE `time.Time` (RFC 3339 with a time zone). Date-only
// and time-only forms are not `time.Time`. Day-of-month is 01–31; this
// is not a calendar (29 Feb on a non-leap year still unifies).
//
// Time-of-day regexes are written as complete strings. `cue fmt`
// parenthesizes interpolations after `:` and leaves them unclosed.

_yearPattern:  "[0-9]{4}"
_monthPattern: "(0[1-9]|1[0-2])"
_dayPattern:   "(0[1-9]|[12][0-9]|3[01])"

// Calendar date: `YYYY-MM-DD`.
#Date: string & =~"^\(_yearPattern)-\(_monthPattern)-\(_dayPattern)$"

#Year:      string & =~"^\(_yearPattern)$"
#YearMonth: string & =~"^\(_yearPattern)-\(_monthPattern)$"

// `HH:MM` or `HH:MM:SS` with optional fraction.
#Time: string & =~"^([01][0-9]|2[0-3]):[0-5][0-9](:([0-5][0-9]|60)(\\.[0-9]+)?)?$"

#TimeOffset: string & =~"^(Z|[+-]([01][0-9]|2[0-3]):[0-5][0-9])$"

// RFC 3339 timestamp (`2020-01-02T03:04:05Z`).
#DateTime: time.Time
#RFC3339:  #DateTime

// Local date-time without an offset (`2020-01-02T03:04:05`).
#DateTimeLocal: string & =~"^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])T([01][0-9]|2[0-3]):[0-5][0-9]:([0-5][0-9]|60)(\\.[0-9]+)?$"

// Unix time as integer seconds / milliseconds since 1970-01-01T00:00:00Z.
#UnixTime:        int
#UnixMillisecond: int

// CUE `time.Duration`: Go duration string (`15s`, `1h30m`), not nanoseconds.
#Duration: time.Duration

// ISO 8601 duration (`P1Y2M3DT4H5M6S`, `PT15M`, `P7D`). Not a parser
// of every alternative (weeks mixed with Y/M, decimals on every field).
#ISODuration: string & =~"^P(([0-9]+Y)?([0-9]+M)?([0-9]+D)?(T([0-9]+H)?([0-9]+M)?([0-9]+(\\.[0-9]+)?S)?)?|[0-9]+W)$"
#ISODuration: !~"^P$"
#ISODuration: !~"^PT$"

#DateStruct: {
	year:  int & >=0 & <=9999
	month: int & >=1 & <=12
	day:   int & >=1 & <=31
}

#TimeStruct: {
	hour:      int & >=0 & <=23
	minute:    int & >=0 & <=59
	second?:   int & >=0 & <=60
	fraction?: string & =~"^[0-9]+$"
}

#DateTimeStruct: {
	year:      int & >=0 & <=9999
	month:     int & >=1 & <=12
	day:       int & >=1 & <=31
	hour:      int & >=0 & <=23
	minute:    int & >=0 & <=59
	second?:   int & >=0 & <=60
	fraction?: string
	offset?:   #TimeOffset
}

#ISODurationStruct: {
	years?:   int & >=0
	months?:  int & >=0
	weeks?:   int & >=0
	days?:    int & >=0
	hours?:   int & >=0
	minutes?: int & >=0
	seconds?: number & >=0
}

_examples: {
	date:      #Date & "2020-01-02"
	year:      #Year & "2020"
	yearMonth: #YearMonth & "2020-01"
	timeHM:    #Time & "15:04"
	timeHMS:   #Time & "15:04:05"
	timeFrac:  #Time & "15:04:05.123"
	offsetZ:   #TimeOffset & "Z"
	offset:    #TimeOffset & "-05:00"
	rfc:       #RFC3339 & "2020-01-02T03:04:05Z"
	rfcOff:    #DateTime & "2020-01-02T03:04:05-05:00"
	local:     #DateTimeLocal & "2020-01-02T03:04:05"
	unix:      #UnixTime & 1577923200
	dur:       #Duration & "15s"
	isoDur:    #ISODuration & "P1Y2M3DT4H5M6S"
	isoWeek:   #ISODuration & "P7D"
	isoMin:    #ISODuration & "PT15M"
	dateStruct: #DateStruct & {year: 2020, month: 1, day: 2}
	timeStruct: #TimeStruct & {hour: 15, minute: 4, second: 5}
	dtStruct: #DateTimeStruct & {
		year:   2020
		month:  1
		day:    2
		hour:   3
		minute: 4
		second: 5
		offset: "Z"
	}
	isoStruct: #ISODurationStruct & {hours: 1, minutes: 30}
}
