package schemas

import rfc004 "salotz.info/rfcs/004_nexps:schemas"
import rfc027 "salotz.info/rfcs/027_env-nexps:schemas"
import prj "github.com/numtide/prj-spec:schemas"

// salotz.028_prjx — project root, metadata TOML, IDs, and PRJX env vars.

#SentinelFilename:    ".prjx-root"
#ProjectMetaFilename: "_project-meta.toml"
#LocalConfigFilename: "_config.toml"

#AbsolutePath: prj.#AbsolutePath

#ProjectID: prj.#ProjectID

#FQName: rfc004.#Nexp

// Env name form follows RFC 27. Spec-defined names use PRJX_ (single field).
#SpecEnvVar: rfc027.#EnvName & (
	"PRJX_ROOT" | "PRJX_CONFIG_HOME" | "PRJX_LOCAL_CONFIG_HOME" | "PRJX_ID" |
	"PRJX_HOST_CONFIG_HOME" | "PRJX_CACHE_HOME" | "PRJX_DATA_HOME" |
	"PRJX_TMP_HOME" | "PRJX_SCRATCH_HOME" | "PRJX_VAR_HOME")

// Project-local leaves are PRJX__<LEAF>.
#ProjectEnvVar: rfc027.#EnvName & =~"^PRJX__[A-Z][A-Z0-9_]*$"

// "" default group; "-" required; "*" optional ungrouped; else comma-separated groups.
#EnvVarGroupSpec: string & =~"^$|^-$|^\\*$|^[A-Za-z0-9._-]+(,[A-Za-z0-9._-]+)*$"

#ProjectMeta: {
	project?: {
		name?:      string
		namespace?: string
		"env-vars"?: {
			[leaf=string]: #EnvVarGroupSpec
		}
	}
}

#LocalConfig: {
	replica?: {
		distinguisher?: string
		id?:            #ProjectID
	}
	project?: {
		name?:      string
		namespace?: string
		"env-vars"?: {
			[leaf=string]: #EnvVarGroupSpec
		}
	}
}

#XDGKind: "host config" | "cache" | "share" | "tmp" | "scratch" | "var"

_examples: {
	id:   #ProjectID & "acme_wumpus_test-bed"
	fq:   #FQName & "acme.wumpus.main"
	root: #SpecEnvVar & "PRJX_ROOT"
	leaf: #ProjectEnvVar & "PRJX__DATA_PATH"
	meta: #ProjectMeta & {
		project: {
			name:      "wumpus"
			namespace: "acme"
			"env-vars": {
				OP_SERVICE_ACCOUNT_TOKEN: "secrets"
				PULUMI_ACCESS_TOKEN:      "secrets,infra"
				ENV_NAME:                 "integration-testing"
				DATA_PATH:                "*"
			}
		}
	}
	local: #LocalConfig & {
		replica: {distinguisher: "test-bed"}
	}
}
