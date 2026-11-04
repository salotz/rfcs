package systemd

// systemd environment variables: reserved prefix plus names systemd
// sets for services (invocation metadata).

#Prefix: "SYSTEMD_"

#ServiceName: "JOURNAL_STREAM" | "INVOCATION_ID" | "LISTEN_PID" | "LISTEN_FDS"
