package systemd

import "salotz.info/unix/envvar"

// systemd environment variables: reserved prefix plus names systemd
// sets for services (invocation metadata).

#Prefix: "SYSTEMD_"

#ServiceNames: [...envvar.#Name]
#ServiceNames: ["JOURNAL_STREAM", "INVOCATION_ID", "LISTEN_PID", "LISTEN_FDS"]

#ServiceName: or(#ServiceNames) & envvar.#Name
