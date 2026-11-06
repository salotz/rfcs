# Dirshape: Filesystem Layout Requirements

- nexp :: `salotz.033_dirshape`
- long name :: Dirshape: Filesystem Layout Requirements
- executive summary :: Reusable encodings and schemas for **directory and filename layout requirements**.

## Motivation

Many systems define requirements for files and directory layouts as well as schemas for file contents.
However whereas file contents get a lot of work done on schemas, the layout of files and directories is not similarly schematized.
This can cause a lot of friction for onboarding onto new systems because you cannot statically check layouts without specialized tools.

Some examples:
- RFC 030: `.appinfo/meta.toml` at a project root
- RFC 016: any file whose name ends in `.list` / `.str`
- RFC 022: `AGENTS.md`, `.agents/`, `design/decisions/<n>_<name>.md`
- RFC 028: `.prjx-root`, `.config/_project-meta.toml`
- gitignore(5): `.gitignore` in any directory, `$GIT_DIR/info/exclude`, `core.excludesFile`
- XDG: `$XDG_CONFIG_HOME/<app>/…` with a default `~/.config`


In this RFC we bring the first step in achieving static validation of file layouts by first coming up with a mechanism for both encoding filesystem layouts concretely as well as a schema format for writing requirement schemas to check against.

This RFC does not include in its scope the additional work of associating file contents with particular schemas.
It may be amended to include this or result in a separate RFC building on this one.

## Goals

1. Facilitate the specification of file layouts that matches the wide breadth of actual use cases.
You shouldn't have to change a desired layout because this specification does not allow it.
However, we don't want to allow for obviously terrible patterns at cost of complexity.

2. A compact human readable/writable schema "spec" optimized for brevity and clarity.

3. An unambiguous intermediate representation (IR) that the frontend spec system can expand to and to provide a target for extracting concrete schemas from existing file systems.

4. Root independence.
This spec says nothing about where file layouts must be rooted in a filesystem.
It is up to tools to inject roots for validation and generation.

5. Just a specification.
Not an implementation, although one will be provided separately.

## The Specification

The specification is written in the CUE language and uses its syntax to describe elements.
This is a very convenient format to write complex schemas and configuration in.
**However, CUE is not part of the specification.**

Schemas may be encoded as any compatible structured data system like json-schema, JSON, YAML, etc. which are natively supported import/export targets of CUE.

### Layers

| Layer         | CUE                        | Role                                     |
|---------------|----------------------------|------------------------------------------|
| dirshape-spec | `#LayoutSpec`, `#NodeSpec` | What authors write                       |
| dirshape-IR   | `#Layout`, `#Node`         | What checkers and a filesystem walk emit |

There are two workflows depending on your role:

1. Writing schemas.
You can write schemas in either dirshape-IR or in the more convenient dirshape-spec.
We highly recommend writing in dirshape-spec so that others can read and understand the spec from the spec alone.
After writing a spec you can statically generate the dirshape-IR for distribution, or generate it on the fly.
We recommend statically generating the IR and delivering it directly.

The associated schemas (in CUE) can be found in the [`schemas/`](schemas/) directory.
The CUE module is `salotz.info/rfcs/033_dirshape` (package `schemas`) and can be used in other CUE modules.

Positive fixtures live in the module under `_examples`.

Expansion spec → IR is a compiler/tool, not CUE unification of a spec into IR.

### dirshape-spec

The spec is composed of a Layout which is the root of the tree and Nodes which are either directories or leaf node files.

A layout is simply a mapping of entries to nodes.
Keys in `entries` and `children` are author labels only; they are not the on-disk name and they do not appear in the IR.
Each node only needs a single `name` field to be valid, which is the file or directory expected relative to its parent (the layout's injected root for top-level entries).

For example if you want to specify "a `config.toml` file in the anchor directory" you could write:

```cue
#MyLayoutSpec: #LayoutSpec & {
	entries: {
		config: name: "config.toml"
	}
}
```

The equivalent YAML of this would be like:

```yaml
entries:
  config:
    name: config.toml
```

The "anchor directory" is the root directory for the layout to be considered under.
This is arbitrary and not the "root" in the sense of the root of the entire filesystem (`/` on unix) and can be any rooting directory.
E.g. the anchor could be `~/projects/things` and the file path for the config would be `~/projects/things/config.toml`.

You can also specify other attributes:

- `kind`: `file` or `directory`, defaults to `file`
- `presence`: `required` (default) or `optional`
- `match`: how to match the file/dir name. `exact` (default), `glob`, or `pattern` (RE2 / CUE `=~`). See [Match](#match).
- `cardinality`: `1` (unique match) or `"many"` (unbounded). Defaults to `1` when `match` is `exact`, `"many"` when `glob` or `pattern`. See [Cardinality](#cardinality).

So if you want at most one optional file whose name ends in a suffix:

```cue
#MyLayoutSpec: #LayoutSpec & {
	entries: {
		config: {
			name:        "*.config.toml"
			presence:    "optional"
			match:       "glob"
			cardinality: 1
		}
	}
}
```

That is zero or one match; two matching files is an error.
Omit `cardinality` (or set `"many"`) if several `*.config.toml` files are allowed.

In the dirshape spec you can also put prefix directories in `name` (in the IR you must write those out as explicit nodes).

For example a file in a subdirectory `.config/config.toml`:

```cue
#MyLayoutSpec: #LayoutSpec & {
	entries: {
		config: name: ".config/config.toml"
	}
}
```

You can specify directories explicitly.
Directory `name`s MUST end in `/`. File `name`s MUST NOT.
A trailing `/` or a present `children` field infers `kind: "directory"`, and that inference still requires the slash on `name`.

```cue
#MyLayoutSpec: #LayoutSpec & {
	entries: {
		dotconfig: {
			name: ".config/"
			children: {
				config: name: "config.toml"
			}
		}
	}
}
```

`name: ".config"` with `kind: "directory"` is illegal; write `".config/"`.
`name: ".config/"` with `kind: "file"` is illegal.
`.config` as a file and `.config/` as a directory are the same on-disk basename: a compiler that sees both MUST reject the collision.

The `children` field nests nodes relative to this node.
Child `name`s may themselves contain `/`.
If two spec entries expand to the same path, the compiler merges them into one IR node when every field unifies; otherwise it is an error.
That merge is not CUE unification of different entry labels.

### dirshape-IR

The IR is fully expanded. No defaults. No `/` in `name`. No trailing slash.
`name` is one path segment: a `readdir` basename, or the glob/pattern string.
Map keys in `entries` and `children` **equal** `name`. A filesystem walk emits that shape.

All fields are required except `children`, which is omitted on files and on directories with no child constraints.

The first spec example compiles to:

```cue
#MyLayout: #Layout & {
	entries: {
		"config.toml": {
			name:         "config.toml"
			kind:         "file"
			presence:     "required"
			match:        "exact"
			cardinality:  1
		}
	}
}
```

Prefix directories in a spec `name` become explicit IR nodes:

```cue
#MyLayout: #Layout & {
	entries: {
		".config": {
			name:         ".config"
			kind:         "directory"
			presence:     "required"
			match:        "exact"
			cardinality:  1
			children: {
				"config.toml": {
					name:         "config.toml"
					kind:         "file"
					presence:     "required"
					match:        "exact"
					cardinality:  1
				}
			}
		}
	}
}
```

In YAML:

```yaml
entries:
  .config:
    name: .config
    kind: directory
    presence: required
    match: exact
    cardinality: 1
    children:
      config.toml:
        name: config.toml
        kind: file
        presence: required
        match: exact
        cardinality: 1
```

Every spec compiles unambiguously to one IR tree. The IR types are not a subset of the spec types (spec allows multi-segment names and trailing `/`; IR does not).

### Match

| `match`   | `name` segment         |
|-----------|------------------------|
| `exact`   | Literal basename       |
| `glob`    | Glob, any segment      |
| `pattern` | Regex (RE2 / CUE `=~`) |

The requirement of RE2 for the regex pattern is for interoperability with CUE.

Globs may appear in any segment, including non-final ones (e.g. `specs/*/spec.toml`).
Brace groups (`{spec.toml,things.md}`) are spec sugar: a compiler expands them to sibling leaves. They are not IR nodes.

Authors SHOULD set `match: "glob"` when a segment is a glob. A compiler MAY infer `glob` from `*`, `?`, or `[` in a segment. It MUST NOT infer `pattern`.

v1 checkers MAY accept glob/pattern in the spec, compile them into IR with `match` set, then refuse to evaluate them rather than treat `*` as a literal filename.

### Cardinality

`cardinality` is `1` or `"many"`. Other positive integers are reserved for later.

| `match` | `cardinality` | `presence` | Means |
|---------|---------------|------------|--------|
| exact | `1` | required | this one path must exist |
| exact | `1` | optional | this one path may exist |
| glob/pattern | `1` | required | exactly one match; two+ is an error |
| glob/pattern | `1` | optional | zero or one match; two+ is an error |
| glob/pattern | `"many"` | required | at least one match; more is fine |
| glob/pattern | `"many"` | optional | zero or more matches |

`exact` + `"many"` is illegal. `"many"` means unbounded, not “at least two”.

### Checking

v1: the application injects **one** root directory. Compile the spec to IR. For each `match: "exact"` node, test existence relative to that root. Extra files and directories on disk are **allowed**; a layout is a constraint, not an inventory.

`$GIT_DIR` vs a work tree, or `$XDG_CONFIG_HOME` vs a project, is two invocations (or the app resolves the directory, then checks). This RFC does not name those roots.

A layout does **not** describe file contents. Consuming schemas keep `#File` / document types beside `#LayoutSpec`.

## Illegal spec (normative)

A spec is invalid if any of the following hold. Compilers MUST reject these rather than guess.

- `name` empty, absolute (leading `/`), or with a `""`, `.`, or `..` component
- `children` present and `kind` is `file` (after inference)
- Trailing `/` combined with `kind: "file"`
- `kind: "directory"` (after inference) and `name` does not end in `/`
- `match: "exact"` with `cardinality` other than `1`
- Two expansions of the same path that do not unify

## Schemas

CUE types `#LayoutSpec`, `#NodeSpec`, `#Layout`, and `#Node` live under [`schemas/`](schemas/) (module `salotz.info/rfcs/033_dirshape`, package `schemas`). `_examples` in that package are the positive fixtures `cue vet` checks.

This document is the prose contract those types must match. Expansion is **not** implemented as CUE unification of spec into IR. These types constrain documents at each layer; a compiler/tool walks spec → IR.
