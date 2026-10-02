# Environment Variable Value Types

- nexp :: `salotz.032_env-value-types`
- long name :: Environment Variable Value Types
- executive summary ::
Defines a small **type system** and **value grammar** for environment
variable strings.
Normative type names are **`boolean`**, **`enum`**, **`string`**,
**`null`**, and the composite **`nullable-enum`** (enum or typed null;
not general algebraic unions).
On the wire, a value is **missing** (absent or empty string) or **set**
(non-empty body).
Empty means **explicit missing**, not typed `null`.
Each variable carries a single **value policy**—`silent`, `warn`,
`strict`, or `required` (default **`warn`**)—that covers missing and
invalid handling together; non-`required` variables also declare a
**default**.
Also covers token matching, reporting, and how to document variables in
technical docs.
Value-side counterpart to name form in
[RFC 027](../salotz.027_env-nexps/README.md).
Stand-alone: does not prescribe which control variables to honor.


## Motivation

Process environments expose a flat map of string names to string values.
Ecosystems disagree on basic questions:

- Is an empty string different from a missing variable?
- Is “set to anything” enough to mean true, or must the body be a real token?
- Which tokens mean true, false, or null?
- How are closed vocabularies matched and spelled?
- Can a variable be required?
- What happens when a value is garbage—warn, exit, or ignore?

Without shared answers, every product reinvents parsers and operators
learn conflicting dialects.
This RFC fixes a small **value types** layer—with **stable type names**
and a single **value policy** other documents can cite—so conventions
share one grammar.


## Goals

- Publish normative type names: `boolean`, `enum`, `string`, `null`,
  `nullable-enum`
- Align names and shapes with common schema / language practice where practical
- Treat **missing** uniformly: absent and empty string are the same
- Keep **missing** distinct from typed **`null`**
- Define one per-variable **value policy** (`silent` | `warn` | `strict` |
  `required`) for missing and invalid handling, with **defaults** when
  the policy is not `required`
- Define token grammars for `boolean`, `null`, and `enum`
- Require **reporting** of invalid set values except under `silent`
- Show how to document env values in technical documentation
- Stay **name-agnostic** and **stand-alone**


## Non-goals

- Environment variable **name** form (see [RFC 027](../salotz.027_env-nexps/README.md))
- Which product- or domain-specific variables exist, or how they are
  registered for discovery
- Deep schema languages or nested documents as env values
- Secret detection or redaction frameworks
- Mandating stderr, logging APIs, or language-specific warning modules
- Integer, number, or array encodings in v0
  (see [Deferred](#deferred); names reserved for alignment)
- First-class path, URI, or other domain interpretations of `string`
- General algebraic composition (`boolean | null`, `string | null`, …)
  — only `nullable-enum` is defined
- Overloading empty string as typed `null`
- Standardizing “presence-only” flags as a type — see
  [Counterexample: presence-only flags](#counterexample-presence-only-flags)
- Whitespace normalization rules (left to applications)
- A single process-wide “strict mode” switch that overrides every
  variable’s declared policy
- Standardization of existing environment variable de facto patterns
- A holistic treatment of how sets of environment variables work together
  as a product surface (later RFCs in the series)
- A complete standard for defining new application env sets end-to-end
  (this RFC is the type/policy layer only)


## Relationship to other work

Name spelling, fields, and prefixes live in
[RFC 027](../salotz.027_env-nexps/README.md).
Declaring what a product reads, and the machine-readable registry
fields for type/policy/default/enum values, is not in scope for this RFC.
See [RFC 031](../salotz.031_application-env/README.md) for a specific (recommended) implementation.
**Value types, token grammar, value policy, and validation** are this RFC.
Which cross-cutting controls to honor lives in separate control
conventions that **cite** this RFC by type name and policy (e.g. “type
`boolean`, `policy=warn`” or “type `nullable-enum`, `policy=required`”).

**Terminology:** this document specifies **types**, **grammars**,
**missing**, typed **`null`**, and **value policy** (including defaults).
Domain **semantics** (what a variable *does*) stay with the conventions
that define each variable.


## Design principles

1. **Cite types by name.** Other RFCs use `boolean`, `enum`, `string`,
   `null`, or `nullable-enum`.
2. **Missing is one thing.** Absent and `NAME=` are the same.
3. **One value policy per variable.** Choose `silent`, `warn`, `strict`,
   or `required`—not a vague global leniency story and not a separate
   “omission profile.”
4. **Null is explicit.** Typed `null` uses null literals—not empty string.
5. **Composition is listed, not freeform.** Only `nullable-enum` in this revision.
6. **Types are explicit.** Do not infer `boolean` from “any non-empty string.”
7. **Keep the system small.**
8. **Invalid is observable by default.** Ill-formed set values are reported
   unless the variable’s policy is `silent`.
9. **Explicit is better than implicit** (see also *The Zen of Python*,
   Tim Peters).
   Env values are layered through shells, dotenv, containers, and
   orchestrators; forcing **explicit** tokens for true/false/null and
   treating empty as missing makes overrides easier to reason about.


## Missing

This RFC collapses two wire states into one typed state **missing**:

| Environment state                               | Typed state                          |
|-------------------------------------------------|--------------------------------------|
| Variable **absent**                             | **missing**                          |
| Variable present with value `""` (empty string) | **missing**                          |
| Variable present with one or more characters    | **set** — parse as the declared type |

**Empty means explicit missing**, not typed `null`.
Writing `NAME=` in a dotenv file or shell clears the override so the
variable’s [value policy](#value-policy) applies—same as never setting it.

### Missing versus `null`

| Concept     | Wire                                           | Meaning             |
|-------------|------------------------------------------------|---------------------|
| **missing** | absent or `""`                                 | no value supplied   |
| **`null`**  | non-empty null literal (`null`, `none`, `nil`) | explicit typed null |

Some systems distinguish omitted keys from JSON `null`.
This RFC keeps that distinction **only** via typed `null` (and
`nullable-enum`), never via empty string.

### Why empty is missing (not null, not a third state)

- **Policy, not platform myth.** Language APIs can distinguish absent
  from `""` (e.g. Python `os.getenv` → `None` if missing, `""` if empty).
  This RFC **chooses** one configuration story: empty and absent are
  both **missing**.
- **Defaulting practice often collapses them.** POSIX-style shells treat
  *unset or null (empty)* the same in `${name:-default}` and
  `${name:=default}`, while `${name-default}` applies only when unset.
  See [POSIX XCU 2.6.2 Parameter Expansion](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_06_02).
- **Clearing overrides needs a portable spelling.** `NAME=` is the
  everyday “no value here” in dotenv, shell, and many deploy templates.
  Stealing empty for typed null would remove that tool.
- **Layers are lossy.** Merging env through Compose, dotenv, and
  orchestrators does not reliably preserve blank-vs-omit.[^compose-blank]
  Dotenv implementations likewise disagree on whether `NAME=` yields
  `""` or drops the key.[^dotenv-empty]
- **Null is a token.** Literals (`null`, `none`, `nil`) are explicit
  (**explicit is better than implicit**).

[^compose-blank]:
    Docker Compose has repeatedly shown that “blank” and “omitted”
    environment entries are not a stable, portable pair across versions and
    file forms: setting `VAR=` may fail to produce an empty value in the
    container
    ([docker/compose#4636](https://github.com/docker/compose/issues/4636));
    interpolation of an unset host variable can inject a blank and change
    application behavior
    ([docker/compose#3768](https://github.com/docker/compose/issues/3768));
    blank values may be dropped instead of passed through
    ([docker/compose#7955](https://github.com/docker/compose/issues/7955)).
    The point for this RFC is not to audit Compose, but to illustrate why
    config layers cannot be trusted to preserve a three-way
    absent / empty / set distinction—hence **missing** vs **non-empty body**
    only.
[^dotenv-empty]:
    Dotenv parsers differ on empty assignments; e.g. discussion of empty
    `NAME=` being removed rather than set to `""` in
    [bkeepers/dotenv#339](https://github.com/bkeepers/dotenv/issues/339).

### Empty strings as data

Under this RFC, a plain empty wire value is **never** a set `string`
(or any set value). It is **missing**.

If a domain truly needs an empty string as **data** (rare for env
config), do **not** rely on `NAME=`. Prefer one of:

1. **Avoid** — use missing + default
2. **Quoted empty sentinel** — document an application-specific encoding
   such as `''` or `""` (two quote characters) as the set value meaning
   empty string, decoded by the app after the type layer.

This RFC does **not** standardize a quoted-empty string encoding.
Empty-as-data stays **application-specific** when needed at all.
Owners who need it must document their own decode step.
For most variables, **missing is enough**; empty-as-data is usually a
misstep relative to how env is actually deployed.

### Read model

```text
wire_read(T)  =  missing  |  T
```

`T` is a base type or `nullable-enum`.
After the read, [value policy](#value-policy) turns `missing` or an
invalid `T` into a concrete outcome (default, warning, or exit).


## Value policy

Every recognized variable has a declared **type** and a single
**value policy**. The policy covers **both** missing and invalid set
values—there is no separate “leniency level” or process-wide omission
profile beside this field.

Recommended declaration field name: **`policy`**.

| Policy     | Missing                         | Set but invalid                                      |
|------------|---------------------------------|------------------------------------------------------|
| `silent`   | apply **default**               | ignore; apply **default**; report not required       |
| `warn`     | apply **default**               | apply **default**; **MUST** emit a user-facing warning |
| `strict`   | apply **default**               | **MUST** report and **exit** (or equivalent hard fail) |
| `required` | **MUST** report and **exit**    | **MUST** report and **exit**                         |

- Default **`policy`** when unspecified: **`warn`**.
- Every policy other than `required` **MUST** declare a **default**
  (canonical token form for typed values).
- `required` has no default; a valid set value is mandatory.
- **Invalid** means set (non-empty) but not accepted by the declared type
  grammar. Invalid is never the same as missing.

### Choosing a policy

Pick **one** policy per variable and document it. The four names are not
a severity ladder you stack—they are distinct missing/invalid contracts.

**`warn` (default).** Use for operator convenience knobs: log levels,
feature flags, color policy, optional paths with XDG-style fallbacks.
Missing and garbage both land on the declared default; garbage is
**visible** so typos are fixable without blocking startup. Most product
env vars should be `warn`.

**`strict`.** Use when a **wrong token must not become a quiet default**
(servers, safety-sensitive launch, anything where “we pretended you said
the default” is worse than exiting). **Missing still applies the
default**—`strict` is not a second spelling of `required`. Only
ill-formed **set** values hard-fail. Prefer `strict` over `warn` when
operators are expected to set the variable deliberately and a typo is
operationally dangerous.

**`required`.** Use when the process **cannot guess** a correct value:
secrets, connection URLs (`DATABASE_URL`), boot identity (`POD_NAME`,
tenant id), hard safety gates. There is **no default**. Absent and empty
are errors, same as garbage. Do not mark convenience knobs `required`
just to look serious—that forces deploy boilerplate for no safety gain.

**`silent`.** Same outcomes as `warn` (default on missing and on
invalid) but **without** a required user-facing warning on invalid
input. Reserve for small utility CLIs where warning noise is worse than
the risk. **Not recommended** for libraries, services, or anything
operators debug from logs alone—invalid config should not vanish.

Libraries that *read* env on behalf of a caller SHOULD document whether
`required` is enforced at the library boundary or deferred to the app,
and which defaults apply under `warn` / `strict` / `silent`.

| Policy     | Typical use |
|------------|-------------|
| `warn`     | **Default choice.** Convenience knobs; bad input visible, process continues. |
| `strict`   | Mission-critical surfaces: invalid tokens must not become defaults; missing still defaults. |
| `required` | Unguessable values (secrets, URLs, boot identity); no default. |
| `silent`   | Rare CLI-only cases; avoid in libraries and long-running services. |

### Outcomes (normative summary)

| Situation                     | `silent`           | `warn`                    | `strict`           | `required`         |
|-------------------------------|--------------------|---------------------------|--------------------|--------------------|
| **missing**                   | default            | default                   | default            | report + exit      |
| **set**, well-formed          | parsed value       | parsed value              | parsed value       | parsed value       |
| **set**, ill-formed (invalid) | default (quiet)    | default + **warning**     | report + exit      | report + exit      |

Reporting channels (stderr, logger, UI) are left to the application; this
RFC only requires that user-facing notice happens where the table says
**warning** or **report**.


## Value types

### Normative type names

The following identifiers are **normative**.
Other documents, registries, and implementations **MUST** use these
spellings (lowercase ASCII, as shown):

| Normative name  | Kind      | Section                           |
|-----------------|-----------|-----------------------------------|
| `boolean`       | base      | [`boolean`](#boolean)             |
| `enum`          | base      | [`enum`](#enum)                   |
| `string`        | base      | [`string`](#string)               |
| `null`          | base      | [`null`](#null)                   |
| `nullable-enum` | composite | [`nullable-enum`](#nullable-enum) |

Do not substitute synonyms in formal citations (`bool`, `str`,
`enumeration`, `enum | null` as the *name*, `Optional[Enum]`, …).
Prose MAY describe the composite as “nullable enum” in running text;
the **normative name** is `nullable-enum`.

**Naming note:** type-theory “option” / “maybe” usually means
`T ∪ null` *or* absent optional, which confuses **missing** with
**null** here. JSON Schema and many APIs say *nullable*.
`nullable-enum` is hyphenated, memorable, and distinct from plain
`enum`. Alternatives considered: `enum?`, `option-enum`, `maybe-enum`
— rejected as easier to confuse with missing-optionality.

An application assigns each recognized variable exactly one declared
type from the table (or documents a deliberate exception), plus a
[value policy](#value-policy) and a default when `policy` is not
`required`.

| Normative name  | When set  | Body meaning                                      |
|-----------------|-----------|---------------------------------------------------|
| `boolean`       | non-empty | true-token or false-token                         |
| `enum`          | non-empty | canonical token or explicit alias                 |
| `string`        | non-empty | opaque string; no further grammar here            |
| `null`          | non-empty | null-token only (rarely useful alone)             |
| `nullable-enum` | non-empty | null-token **or** enum token/alias                |

Only **set** values enter type-specific parsing.
**missing** and **invalid** outcomes follow [value policy](#value-policy).

### Composition rules (normative)

- **Defined composite:** `nullable-enum` only
- **Not defined:** `boolean | null`, `string | null`, free-form `A | B`

Rationale: `nullable-enum` covers closed vocabulary **or** explicit null.
`string | null` cannot be parsed reliably (null literals are valid
opaque strings). For three-valued logic around bools, use a small
`nullable-enum` or separate variables—not a second composite.

### Alignment with JSON Schema and languages (informative)

Environment values remain **strings on the wire**.

| This RFC         | JSON Schema (informative)           | Typical PL mapping (set case) |
|------------------|-------------------------------------|-------------------------------|
| `boolean`        | `"type": "boolean"`                 | `bool`                        |
| `string`         | `"type": "string"`                  | `str`                         |
| `enum`           | `"type": "string", "enum": [ ... ]` | string enum / sum             |
| `null`           | `"type": "null"`                    | `None` / `null` / `nil`       |
| `nullable-enum`  | enum strings ∪ null                 | `Enum \| None`                |
| missing          | omitted property                    | before value policy           |
| `required` miss  | bad request / startup error         | like `Required` keys          |

JSON Schema: [2020-12 core/validation](https://json-schema.org/draft/2020-12/json-schema-validation.html)
(informative alignment only—not a normative dependency).


### `boolean`

**Normative name:** `boolean`

**Definition:** when set, tokens decoding to **true** or **false**.
Non-listed tokens are **invalid**.
Presence alone is not `boolean`.
Null literals are **invalid** for plain `boolean`.

#### Tokens

Matching of alphabetic tokens is **case-insensitive**.
Documentation and emitters **SHOULD** use the **canonical** token
(including the casing shown).

| Decoded | Canonical | Accepted aliases           |
|---------|-----------|----------------------------|
| true    | `true`    | `yes`, `on`, `1`, `t`, `y` |
| false   | `false`   | `no`, `off`, `0`, `f`, `n` |

Aliases exist because operators use them in the field; **prefer
canonical** in docs, examples, and generated configs.
Digits are only `1` / `0` (not `+1`, `2`, …).
Typed variables keep `0`/`1` as boolean aliases without conflicting with
a future numeric type on a *different* variable.

**missing / invalid:** per variable [value policy](#value-policy)
(default under `silent` / `warn` / `strict`; exit under `required` or
under `strict` when invalid).


### `enum`

**Normative name:** `enum`

**Definition:** when set, a closed vocabulary of **canonical tokens**,
with optional **explicit aliases**.
Does **not** accept null literals (use [`nullable-enum`](#nullable-enum)).

#### Matching

1. Start from the set (non-missing) string value.
2. Match **case-insensitively** against canonical tokens and aliases.
3. Resolve aliases to exactly one canonical token.
4. If no match → invalid.

#### Canonical form

Canonical tokens **SHOULD** be spelled in **lowercase kebab-case**:
lowercase ASCII letters, digits, hyphens between words
(e.g. `auto`, `log-level` style *values*—not the env *name*).

Examples:

```text
never
always
auto
off
error
warn
info
debug
trace
```

Case-insensitive **input** is still accepted (`AUTO` → `auto`).
Docs and registries show the **canonical** lowercase kebab form.

This is the **value** spelling. Environment **names** remain
screaming-snake per [RFC 027](../salotz.027_env-nexps/README.md); do not
confuse name form with enum value form.

#### Aliases

Aliases **MUST** be listed explicitly (table, map, or registry field).
No prose-only aliases. No shared global alias table in this RFC—each
enum owns its map.

| Input (any case) | Canonical |
|------------------|-----------|
| `warning`        | `warn`    |

**Prefer `nullable-enum` over a homemade null member** when the intent
is typed null. A domain token that only looks nullish but means
something else remains a normal enum member.

**missing / invalid:** per [value policy](#value-policy).


### `string`

**Normative name:** `string`

**Definition:** when set, a **non-empty** opaque string.
No path/URL/list grammar here.

| Typed state | Result                                      |
|-------------|---------------------------------------------|
| missing     | per value policy (default or required exit) |
| set         | body as string                              |

Empty wire form is **missing**, not an empty string value.
See [Empty strings as data](#empty-strings-as-data).

**No string∪null composite.** The body `null` is the string `"null"`.
For closed set or null, use `nullable-enum`.
For “no string supplied,” use missing.

Domain use (path, host, label) is owner prose, not a separate type name.


### `null`

**Normative name:** `null`

**Definition:** when set, only null tokens.

| Decoded | Canonical | Aliases         |
|---------|-----------|-----------------|
| null    | `null`    | `none`, `nil`   |

Case-insensitive match. Prefer canonical `null` in docs.

Bare `null` alone is rare; null literals matter mainly inside
`nullable-enum`.

**missing / invalid:** per [value policy](#value-policy).


### `nullable-enum`

**Normative name:** `nullable-enum`

**Definition:** when set, either typed **null** (null tokens) **or** a
value of the variable’s **enum** vocabulary (canonical or alias).

#### Matching order

1. Set (non-missing) string value.
2. If it matches a [`null`](#null) token → **null**.
3. Else ordinary [`enum`](#enum) match for this variable.
4. Else → invalid.

Null tokens win over enum members.
**Owners MUST NOT** define enum canonical tokens or aliases that
case-insensitively equal `null`, `none`, or `nil`.

#### For / not for

- **For:** closed alternatives plus explicit “no selection” null
- **Not:** `string`∪null; free unions; empty string as null

**missing / invalid:** per [value policy](#value-policy).


## Counterexample: presence-only flags

Some de facto variables treat **any non-empty string** as “on” and
**ignore the body** (empty still counts as missing).
That is **not** a value type in this RFC.

Widely cited examples (legacy carve-outs only—not types here):

- [`NO_COLOR`](https://no-color.org/) — when present and non-empty,
  disable ANSI color; empty treated like unset
- [`FORCE_COLOR`](https://force-color.org/) — when present and non-empty,
  force color; joint behavior with `NO_COLOR` is not consistently
  defined upstream

| Example value      | Presence-only         | `boolean` (this RFC)                     |
|--------------------|-----------------------|------------------------------------------|
| absent / `""`      | off                   | missing → value policy (default or exit) |
| `true`, `1`        | on                    | true                                     |
| `no`, `false`, `0` | **on** (body ignored) | false                                    |
| `maybe`            | **on**                | **invalid** → value policy               |

New controls SHOULD use `boolean`, `enum`, `nullable-enum`, or `string`
with an explicit value policy.
Legacy globals MAY be carved out in a separate convention with explicit
resolution rules.

Presence-only flags make values like `NO_COLOR=no` mean **on** (disable
color), which is easy to misread and incompatible with `boolean` token
grammar—another reason new controls should not copy that pattern.


## Worked examples

### Documenting variables (recommended table)

Put the **declaration table first** in technical documentation so
readers see types and policy before narrative.

Columns (normative recommendation for human docs citing this RFC):

| Column               | Content                                                                                    |
|----------------------|--------------------------------------------------------------------------------------------|
| **Name**             | Full environment variable name                                                             |
| **Type**             | Normative type name (`boolean`, `enum`, `string`, `null`, `nullable-enum`)                 |
| **Policy**           | `silent`, `warn`, `strict`, or `required` (default of this field if omitted in prose: `warn`) |
| **Default**          | Canonical default when policy is not `required`; use `—` or `n/a` when `required`          |
| **Canonical values** | For `enum` / `nullable-enum`: closed list of canonical tokens (and `null` if nullable)     |
| **Aliases**          | Explicit alias map; omit column or cell if none. Human tables often show alias→canonical; machine registries (RFC 031) store canonical→`[alias, …]` |
| **Description**      | Short prose (optional but recommended)                                                     |

Illustrative product docs:

| Name | Type | Policy | Default | Canonical values | Aliases | Description |
|------|------|--------|---------|------------------|---------|-------------|
| `MYAPP__VERBOSE` | `boolean` | `warn` | `false` | `true`, `false` | true:`yes`,`on`,`1`,`t`,`y` · false:`no`,`off`,`0`,`f`,`n` | Extra stderr chatter |
| `MYAPP__LOG_LEVEL` | `enum` | `warn` | `info` | `off`, `error`, `warn`, `info`, `debug`, `trace` | `warning`→`warn` | Minimum log severity |
| `MYAPP__COLOR_WHEN` | `nullable-enum` | `warn` | `auto` | `never`, `always`, `auto`, plus typed `null` | — | Color policy; `null` = explicit null token if used |
| `MYAPP__DATABASE_URL` | `string` | `required` | — | — | — | SQLAlchemy-style URL |
| `MYAPP__CONFIG` | `string` | `warn` | `$XDG_CONFIG_HOME/myapp/config.toml` | — | — | Config path (domain: filesystem path) |
| `MYAPP__FEATURE_MODE` | `nullable-enum` | `strict` | `null` | `fast`, `safe`, plus typed `null` | — | Mode or explicit null; bad tokens fail startup |
| `MYAPP__POD_NAME` | `string` | `required` | — | — | — | Boot identity; must be set |

Alias cells may use a compact notation.
When the alias map is large, docs **SHOULD** move it to a **child table
or subsection** per enum rather than overcrowding the main declaration
table; a separate “Aliases” section is optional, not mandatory.
Machine-readable encoding of these columns is specified in
[RFC 031](../salotz.031_application-env/README.md)
(`type`, `policy`, structured `default` with `value` / `resolution`,
`values`, and `aliases` as canonical → alias list). This section remains
the **human docs** pattern; doc tables may keep alias→canonical cells
even though the registry inverts the map.

### Example evaluations

#### `boolean` (`policy=warn`, `default=false`)

```text
MYAPP__VERBOSE=          → missing → default false
MYAPP__VERBOSE=true      → true
MYAPP__VERBOSE=FALSE     → false
MYAPP__VERBOSE=y         → true
MYAPP__VERBOSE=null      → invalid → warning → default false
MYAPP__VERBOSE=maybe     → invalid → warning → default false
```

#### `enum` (`policy=warn`, `default=info`)

```text
MYAPP__LOG_LEVEL=info       → info
MYAPP__LOG_LEVEL=WARN       → warn  (case-fold → canonical)
MYAPP__LOG_LEVEL=warning    → warn  (alias)
MYAPP__LOG_LEVEL=null       → invalid (use nullable-enum) → warning → default info
MYAPP__LOG_LEVEL=sometimes  → invalid → warning → default info
```

#### `nullable-enum` (`policy=strict`, `default=null`)

```text
MYAPP__FEATURE_MODE=           → missing → default null
MYAPP__FEATURE_MODE=safe       → safe
MYAPP__FEATURE_MODE=null       → null
MYAPP__FEATURE_MODE=None       → null
MYAPP__FEATURE_MODE=sometimes  → invalid → report → exit
```

#### `string` (`policy=required`)

```text
MYAPP__DATABASE_URL=                 → missing → report → exit
MYAPP__DATABASE_URL=postgres://...   → string
```

#### `string` (`policy=warn`, opaque label)

```text
MYAPP__LABEL=null                    → string "null"  (not typed null)
MYAPP__LABEL=                        → missing → default (if any)
```

#### `null` alone (rare; `policy=warn`, `default=null`)

```text
MYAPP__ONLY_NULL=        → missing → default null
MYAPP__ONLY_NULL=null    → null
MYAPP__ONLY_NULL=true    → invalid → warning → default null
```

#### `required` vs `strict` on missing

```text
# policy=required, no default
MYAPP__POD_NAME=         → missing → report → exit

# policy=strict, default=auto
MYAPP__COLOR_WHEN=       → missing → default auto
MYAPP__COLOR_WHEN=maybe  → invalid → report → exit
```


## Guidance for authors of variable conventions

1. State the type by **normative name**.
2. State **`policy`**: `silent`, `warn`, `strict`, or `required`
   (assume `warn` only if you intentionally inherit the default).
3. If `policy` is not `required`, state **`default=`** in canonical form.
4. Publish a [documentation table](#documenting-variables-recommended-table).
5. For `enum` / `nullable-enum`, publish lowercase kebab **canonical**
   values and an explicit alias map; do not use `null`/`none`/`nil` as
   enum members under `nullable-enum`.
6. Prefer **`nullable-enum`** for closed set ∪ typed null.
7. For `string`, document domain use in prose; empty wire is missing.
8. Do not invent presence-only types; carve out legacy globals elsewhere.
9. Honor the policy table: warn or exit where required; do not invent a
   second, process-wide leniency switch that silently overrides declarations.


## Decisions locked for v0

Settled while completing this draft (not reopened without a revision):

1. **Empty-as-data.** No portable sentinel in this RFC. `NAME=` is always
   **missing**. Apps that truly need empty string data document their own
   encoding (see [Empty strings as data](#empty-strings-as-data)).
2. **`strict` vs `required`.** `strict` applies the **default** when
   missing and hard-fails only on **invalid** set values. `required` has
   no default and hard-fails on missing. Do not collapse the two names.
3. **Large alias tables.** Main docs table stays compact; large maps go
   in an optional child table/section—not a mandatory split for every enum.
4. **Default policy.** Unspecified `policy` means **`warn`**.


## Deferred

Out of scope for this revision; may appear in later RFCs or registry work:

1. **`integer`**, **`number`**, and array/list value forms (JSON
   Schema-aligned names reserved for consistency).


## Revision notes

- **v0.2:** Note RFC 031 registry details: `aliases` as canonical →
  alias arrays; structured `default` (`value` / `resolution`). Human docs
  table may still show alias→canonical. (RFC 031 later dropped string
  short-form vars; see 031 v0.3.)
- **v0.1:** RFC 031 registry fields now encode `type`, `policy`,
  `default`, enum `values`, and `aliases`. Deferred item on
  machine-readable registry encoding is closed; human docs table still
  lives here.
- **v0 (complete):** nexp `salotz.032_env-value-types`; types `boolean`,
  `enum`, `string`, `null`, composite **`nullable-enum`**; missing =
  absent or empty; single per-variable **value policy**
  (`silent` | `warn` | `strict` | `required`, default `warn`) with
  **defaults** when not `required`; `strict` ≠ `required` on missing;
  invalid set values follow policy (quiet / warn+default / exit); enum
  canonical **lowercase kebab-case**; boolean canonical `true`/`false`
  with aliases including `y`/`n`; null literals `null`/`none`/`nil`;
  documentation table pattern; empty-as-data left app-specific;
  presence-only counterexample with no-color.org / force-color.org
  citations; stand-alone. Ready for leaf RFCs to cite.

