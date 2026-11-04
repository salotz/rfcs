package hostname

import "net"

// Unix / DNS host names and host:port.
//
// Labels are LDH (RFC 1123: letter, digit, hyphen; start and end on
// alnum; 1–63 chars). `#Hostname` is one or more labels (POSIX
// nodename may be a single label). `#FQDN` here requires a dot;
// CUE `net.FQDN` accepts `localhost` and is not used as the type.
//
// https://datatracker.ietf.org/doc/html/rfc1123
// https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap08.html

_labelPattern: "[A-Za-z0-9]([A-Za-z0-9-]{0,61}[A-Za-z0-9])?"

#Label: string & =~"^\(_labelPattern)$"

// One or more labels, 1–253 characters. Optional trailing dot.
#Hostname: string & =~"^\(_labelPattern)(\\.\(_labelPattern))*\\.?$"
#Hostname: =~"^.{1,253}$"

// At least two labels (`example.com`, `example.com.`).
#FQDN: #Hostname & =~"\\."

// Single label, no dot. `gethostname` on a typical workstation.
#Nodename: #Hostname & !~"\\."

#IPv4: string & net.IPv4
#IPv6: string & net.IPv6
#IP:   string & net.IP

// Name or address a host can be reached by.
#Host: #Hostname | #IP

#Port:       int & >=1 & <=65535
#PortString: string & =~"^[0-9]+$"

// `host:port`. IPv6 in brackets is not encoded here; use #HostPortStruct.
#HostPort: string & =~"^\(_labelPattern)(\\.\(_labelPattern))*:[0-9]+$"

#HostnameStruct: {
	labels: [...#Label]
}

#HostPortStruct: {
	host: #Host
	port: #Port
}

_examples: {
	label:    #Label & "example"
	node:     #Nodename & "laptop"
	host:     #Hostname & "laptop"
	fqdn:     #FQDN & "laptop.example.com"
	dot:      #FQDN & "example.com."
	ip4:      #IPv4 & "127.0.0.1"
	ip6:      #IPv6 & "::1"
	either:   #Host & "laptop"
	eitherIP: #Host & "127.0.0.1"
	port:     #Port & 443
	hp:       #HostPort & "example.com:443"
	hpStruct: #HostPortStruct & {host: "example.com", port: 443}
	nameStruct: #HostnameStruct & {
		labels: ["laptop", "example", "com"]
	}
}
