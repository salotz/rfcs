# `wumpus` — PRJX example project

Illustrative layout for [RFC 28 (PRJX)](../README.md). Not a runnable
implementation; the files show where configuration lives and how names
compose.

## Layout

```text
wumpus/                         # project root
├── .prjx-root                  # sentinel (empty); discovers PRJX_ROOT
├── .config/                    # portable config (tracked)
│   └── _project-meta.toml      # name, namespace, declared PRJX__ env vars
├── .local/                     # host-local (gitignored)
│   └── _config.toml            # replica distinguisher / overrides
├── .gitignore-template         # shows that .local/ is ignored
├── src/
│   └── wumpus.py               # ordinary project content
└── README.md                   # this file
```

## Names in this example

| Concept | Value |
|---------|-------|
| `project.namespace` | `acme` |
| `project.name` | `wumpus` |
| FQ project name | `acme.wumpus` |
| `replica.distinguisher` | `test-bed` |
| FQ replica name | `acme.wumpus.test-bed` |
| Recommended `PRJX_ID` | `acme_wumpus_test-bed` |

## Features demonstrated

| RFC mechanism | Where shown |
|---------------|-------------|
| Root sentinel `.prjx-root` | `./.prjx-root` |
| Portable config dir | `./.config/` |
| Project metadata | `./.config/_project-meta.toml` |
| Declared `PRJX__` env vars + groups | `[project.env-vars]` in metadata |
| Host-local dir (gitignored) | `./.local/` + `.gitignore-template` |
| Replica distinguisher | `./.local/_config.toml` |
| Project content under root | `./src/wumpus.py` |

## Not demonstrated on disk (by design)

These depend on the host environment or tooling rather than files in
the example tree:

- `PRJX_ROOT` / `PRJX_ID` / `PRJX_CONFIG_HOME` env overrides
- XDG/XDGX paths under `~/{.config,.cache,.local/...}/prjx/${PRJX_ID}`
- Dynamic ID from git branch when `replica.distinguisher` is unset
- Actual process env with `PRJX__*` values populated

A tool implementing PRJX would resolve, for this tree:

```text
PRJX_ROOT = <abs path to this directory>
PRJX_CONFIG_HOME = ${PRJX_ROOT}/.config
PRJX_ID = acme_wumpus_test-bed
PRJX_CACHE_HOME default usage => ~/.cache/prjx/acme_wumpus_test-bed
```
