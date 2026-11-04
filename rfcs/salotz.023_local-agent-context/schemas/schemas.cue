package schemas

import xdg "specifications.freedesktop.org/basedir:schemas"

// salotz.023_local-agent-context — host-local agent paths and overrides.

#LocalOverrideFile: ".agents.local.md"
#LocalOverrideDir:  ".agents.local"
#AgentsDir:         ".agents"
#DerivedNamespace:  "xagents"

// Discovery order, highest precedence first.
#DiscoveryPath: "~/<subdirs>/.agents" | "$XDG_CONFIG_HOME/agents" | "~/.agents"

#HostConfigFiles: "configuration.md" | "installations.md" | "shell.md"

#Placement: {
	xdgConfigAgents: "$XDG_CONFIG_HOME/agents"
	dotAgents:       "~/.agents"
	derivedCache:    "$XDG_CACHE_HOME/xagents"
	localOverride:   #LocalOverrideFile | #LocalOverrideDir
}

_examples: {
	override: #LocalOverrideFile & ".agents.local.md"
	ns:       #DerivedNamespace & "xagents"
	config:   xdg.#Var & "XDG_CONFIG_HOME"
	cache:    xdg.#Var & "XDG_CACHE_HOME"
}
