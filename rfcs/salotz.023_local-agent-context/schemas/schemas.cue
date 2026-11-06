package schemas

import (
	unixpath "salotz.info/unix/path"
	dirshape "salotz.info/rfcs/033_dirshape:schemas"
	xdg "specifications.freedesktop.org/basedir:schemas"
)

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
	dotAgents:       unixpath.#HomeRelativePath & "~/.agents"
	derivedCache:    "$XDG_CACHE_HOME/xagents"
	localOverride:   #LocalOverrideFile | #LocalOverrideDir
}

// Injected root is a repository / working tree.
#RepoOverrideLayoutSpec: dirshape.#LayoutSpec & {
	entries: {
		overrideFile: {name: #LocalOverrideFile, presence: "optional"}
		overrideDir: {name: ".agents.local/", presence: "optional"}
		agents: {name: ".agents/", presence: "optional"}
	}
}

// Injected root is $HOME.
#HomeAgentsLayoutSpec: dirshape.#LayoutSpec & {
	entries: {
		agents: {name: ".agents/", presence: "optional"}
	}
}

// Injected root is $XDG_CONFIG_HOME (default ~/.config).
#XDGConfigAgentsLayoutSpec: dirshape.#LayoutSpec & {
	entries: {
		agents: {
			name:     "agents/"
			presence: "optional"
			children: {
				configuration: {name: "configuration.md", presence: "optional"}
				installations: {name: "installations.md", presence: "optional"}
				shell: {name: "shell.md", presence: "optional"}
			}
		}
	}
}

// Injected root is $XDG_CACHE_HOME (default ~/.cache). Same basename
// under other XDG/XDGX homes.
#XagentsLayoutSpec: dirshape.#LayoutSpec & {
	entries: {
		xagents: {name: "xagents/", presence: "optional"}
	}
}

_examples: {
	override: #LocalOverrideFile & ".agents.local.md"
	ns:       #DerivedNamespace & "xagents"
	config:   xdg.#Var & "XDG_CONFIG_HOME"
	cache:    xdg.#Var & "XDG_CACHE_HOME"
	home:     #Placement.dotAgents
	repo:     #RepoOverrideLayoutSpec
	xdgCfg:   #XDGConfigAgentsLayoutSpec
	xagents:  #XagentsLayoutSpec
}
