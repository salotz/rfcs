package schemas

// salotz.029_glossary-format — parsed glossary structure (Markdown rendering
// and heading-anchor slug rules are out of scope).

#DefaultFilename: "glossary.md"

#Title: string & =~"^Glossary( \\(.+\\))?$"

#Term: {
	heading: string
	body:    string
	aliasOf?: string
}

#Glossary: {
	title:   #Title | *"Glossary"
	intro?:  string
	entries: [...#Term]
}

_examples: {
	file: #DefaultFilename & "glossary.md"
	g: #Glossary & {
		title: "Glossary"
		entries: [{
			heading: "operator"
			body:    "The human person controlling an agent-aided process."
		}, {
			heading: "project"
			body:    "A self-contained unit of work."
		}]
	}
}
