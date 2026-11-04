package schemas

// salotz.012_information-errors — error types mapped to handler next-actions.

#ErrorType: "unavailable" | "interrupted" | "incorrect" | "forbidden" | "unsupported" | "not_found" | "conflict" | "fault" | "busy"

#Error: {
	type:    #ErrorType
	message?: string
}

_examples: {
	t:     #ErrorType & "unavailable"
	error: #Error & {type: "busy", message: "try again later"}
}
