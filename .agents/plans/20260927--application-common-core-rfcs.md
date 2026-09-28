# Plan: Application Common Core RFCs

**Date:** 2026-09-27  
**Status:** planning only (no normative RFC drafts yet)  
**Repo:** `salotz/rfcs`  
**Hold:** do not draft leaf control RFCs until **032 value semantics** is settled enough to cite

## One-line intent

Define a small **application common core**: shared env-var **value
rules**, leaf **control** standards (color, temp, logging, debug), and
a **namespaced “on-standard” profile** so apps can opt into coherent
behavior without relying only on abused globals.

This is standards-body shaped work kept as salotz RFCs for now; it can
spin out later if it ever needs a wider home.

## Why this exists

- RFC 027 defines **name form**, not values or which controls to honor.
- RFC 031 declares what a product reads; it does not define cross-cutting
  **semantics** (open question → answered by this series).
- Informal globals (`NO_COLOR`, `DEBUG`, `LOG_LEVEL`, `TMPDIR`, …) are
  real operator vocabulary but inconsistent in **values**, **precedence**,
  and **collision** when many tools share one environment.
- A single mega-RFC is hard to cite; prefer **foundation + leaf + core**.

## Numbering (this wave)

| # | Working nexp | Title (working) | Role |
|---|--------------|-----------------|------|
| **032** | `salotz.032_env-values` | Environment variable value semantics | Foundation: types, empty, invalid, reporting |
| **033** | `salotz.033_color-env` | Terminal color environment variables | One color RFC: NO_COLOR + FORCE_COLOR + preferred policy var |
| **034** | `salotz.034_temp-env` | Temporary directory environment variables | `TMPDIR` / `TEMP` / `TMP` |
| **035** | `salotz.035_log-env` | Logging environment variables | `LOG_LEVEL` (and core-prefixed twin) |
| **036** | `salotz.036_debug-env` | Debug-mode environment variables | `DEBUG` as boolean (and core-prefixed twin) |
| **037** | `salotz.037_app-common-core` | Application common core | Namespace, adherence, which leaves to use, prefixed best-practice names |

**Not in this wave (tracked elsewhere / later):**

- Distributed tracing / `OTEL_*` / bare `TRACE` (too app-specific; omit)
- `LOG_FILE` / `LOG_FORMAT` (app-specific)
- Scratch-dir globals (optional later)
- Deep `XDGX_TMP_HOME` binding (brief aside in 034 only)
- TTY capability / interactivity overrides (Rich `TTY_*`) — org idea note; after 032/033

**Depends on existing RFCs:** 027 (names), 024 (XDGX aside), 031 (registry / `external`).

## Dependency order

```text
027 name form
    → 032 values
         → 033 color
         → 034 temp
         → 035 logging
         → 036 debug
              → 037 application common core
031 registry examples updated when 037 lands
```

**Writing order:** 032 → (033–036 as ready) → 037 → README index + 031 cross-links.

## Research anchors (already done)

### Color

- [no-color.org](https://no-color.org/): non-empty `NO_COLOR` → no ANSI **color**; empty ≡ unset; CLI/config may re-enable; styles ≠ color.
- [force-color.org](https://force-color.org/): non-empty `FORCE_COLOR` → force color; sample applies force after NO_COLOR (joint behavior **undefined** upstream).
- **Rich:** `NO_COLOR` wins over `FORCE_COLOR`; also library-only `TTY_COMPATIBLE` / `TTY_INTERACTIVE`.
- **Chalk / supports-color / Node:** overload `FORCE_COLOR` as **depth levels** `0|1|2|3` (and treat `0` as off). **This series rejects that overload** (see 033 appendix intent).
- CLICOLOR family: deprecated / omit for new work.
- Bare `COLOR` is a poor global name (RFC 027 collision hygiene).

### Temp

- Python `tempfile`: `TMPDIR` → `TEMP` → `TMP` → OS defaults (OS defaults **out of scope** for the env RFC).
- Win32 `GetTempPath`: `TMP` → `TEMP` → `USERPROFILE` → Windows directory (aside for operators; implement Python order in portable apps).
- RFC 024 `XDGX_TMP_HOME`: layout/policy; not part of tempfile chain.

### Logging

- De facto `LOG_LEVEL`; no single IETF vocab.
- Convergent ladder: `off` < `error` < `warn` < `info` < `debug` < `trace` (+ aliases `warning`, `fatal`/`critical` → fold carefully).
- `OTEL_LOG_LEVEL` is SDK-internal — not app `LOG_LEVEL`.

### Debug

- Bare `DEBUG` is ubiquitous and overloaded (Node `debug` = namespace filter).
- Series choice: **boolean debug mode**, not filter syntax.
- Bool token sets differ (OTel strict `true`; Go ParseBool; systemd; strtobool). **032 owns the allow-list.**

### Prefixed “per-app” controls (prior art)

There is **no** widely adopted multi-vendor “common core prefix” for
`DEBUG` / `LOG_LEVEL` / color policy analogous to XDG for dirs.

Closest fragments:

- **[clig.dev](https://clig.dev/)** (Command Line Interface Guidelines): honor `NO_COLOR`; suggests optional **`MYAPP_NO_COLOR`** so users can disable color **for one program** when globals are wrong. Same idea as our best-practice prefixed twins; not a full core namespace.
- **no-color.org / force-color.org**: global presence flags only.
- **Product prefixes in the wild**: `RUST_LOG`, `JAVA_TOOL_OPTIONS`, `NODE_DEBUG`, `G_MESSAGES_DEBUG` — ecosystem silos, not a shared application core.
- **12-factor**: config in env; orthogonal knobs; no shared control vocabulary.
- **XDG / freedesktop**: directories and desktop keys, not CLI debug/log/color policy.
- **OpenCLI** etc.: CLI surface description, not process env control semantics.
- **RFC 027 + 031 + this series**: our answer — names, registry, then common core.

**Conclusion:** prefixed per-app escapes are **acknowledged best practice**
(clig), but a **named common-core namespace** with parallel leaves
(`<CORE>__LOG_LEVEL`, …) appears **novel** as a mini-standard. That is
fine for RFC-stage work.

---

## RFC 032 — Environment variable value semantics

**Working nexp:** `salotz.032_env-values`

### Problem

Values are strings. Ecosystems disagree on empty vs unset, bools,
enums, and how to report garbage. Leaf RFCs must not each invent this.

### Goals

- Type catalog used by 033–036 and 037
- Empty / unset rules
- Invalid value policy and **reporting** (when, where, how loud)
- Distinguish **presence flags** vs **booleans** vs **enums**
- Name-agnostic (027 owns form)

### Non-goals (v0)

- Full schema DSL / JSON Schema for all env
- List/int deep design can be stubbed if not needed by leaves
- Secret redaction framework

### Types (checklist)

1. Unset / empty (lean: empty ≡ unset)
2. Presence flag (non-empty ⇒ set) — color legacy
3. Boolean (token allow-list; **not** presence)
4. Enum (case-insensitive canonical tokens; optional aliases later)
5. Path (non-empty string)

### Invalid values (must specify)

- Only when set and non-empty but not in grammar
- Default lean for optional controls: **warn once + fallback default**
- Channel lean: CLI → stderr; libraries → documented warn hook / log
- No universal “Python warnings” requirement; define **message fields**
  (name, value, expected grammar, fallback)
- Do not spam per log line

### Workshop later (do not block the plan on tokens)

- Exact bool tokens (`true/false/1/0/yes/no/on/off` ± Go `t`/`f`)
- Hard-fail vs warn-fallback profiles

---

## RFC 033 — Terminal color environment variables

**Working nexp:** `salotz.033_color-env`  
**Depends:** 032

### One RFC, three layers

1. **Adopt** `NO_COLOR` (no-color.org) — presence → policy `never` for color
2. **Adopt** `FORCE_COLOR` (force-color.org) — presence → policy `always`
3. **Preferred policy var** — enum only: `never` | `always` | `auto`

### Policy model

| Token | Meaning |
|-------|---------|
| `never` | no ANSI **color** (non-color styles may remain) |
| `always` | emit color even if not a TTY |
| `auto` | color when stream/terminal warrants |

- **Default:** `auto`
- **Invalid preferred var:** per 032 → lean warn + `auto`
- **Enum only** (no bool/enum hybrid). Aliases only if 032 makes them clean; v0 can be canonical tokens alone.

### Preferred global name

**Not** bare `COLOR` (027 hygiene, bad example).

Working candidate: **`COLOR_WHEN`** (GNU `--color=WHEN` parallel).  
Final name locked in draft with collision check. Common-core prefixed
twin defined in **037** (e.g. `<CORE>__COLOR_WHEN`).

### Resolution order (draft)

1. App CLI / config (`--color=always|never|auto`)
2. Preferred policy var if valid (`COLOR_WHEN` or chosen name)
3. Else legacy: non-empty `NO_COLOR` → `never`; else non-empty `FORCE_COLOR` → `always`; else `auto`
4. If **both** NO_COLOR and FORCE_COLOR non-empty → **`never`** + warn once (Rich-compatible; safer disable)
5. Under `auto` only: TTY + `TERM` / `COLORTERM` capability heuristics

### FORCE_COLOR: presence only

- Non-empty ⇒ force **on** (force-color.org)
- Empty ≡ unset
- **Numeric / level forms are non-conforming** for this RFC
- Depth and gamut are **not** this variable’s job

### Capability vs preference (normative stance)

**Preference** (user wants color or not) is `never|always|auto` plus legacy flags.

**Capability** (what the sink can render: basic ANSI, 256, truecolor, …)
should come from the **terminal/environment signals and library
detection** (`TERM`, `COLORTERM`, OS, stream kind). Applications should
**pick the best rendering the sink supports** under an `always`/`auto`
preference that allows color.

Explicit depth knobs, if ever needed, are **separate concerns** (separate
names, feature-oriented enums — not a fake severity ladder bolted onto
`FORCE_COLOR`).

### Appendix intent: “levels on FORCE_COLOR” (keep polite)

Include a short **appendix / non-normative rationale** (not a rant in the
mainline):

- Some Node stacks (notably **chalk** / **supports-color**, and Node’s
  own tty color-depth docs) reuse `FORCE_COLOR` for **color depth**
  values `0–3`, and treat `0` as disable.
- That collides with force-color.org **presence** semantics (`0` is
  non-empty ⇒ enable).
- A small integer “level” is a poor model for terminal color:
  - It is not the same kind of scale as log severity.
  - Gamuts and protocols (16 vs 256 vs truecolor, and other attributes)
    are **different features with tradeoffs**, not a total order everyone
    climbs.
  - Operators usually want: honor my preference, then **auto-negotiate
    the best the terminal supports**.
- If an application needs an explicit depth or feature ceiling, it should
  use **dedicated** variables or config (feature enums), not overload the
  force-color switch.
- This RFC therefore **ignores** level-shaped `FORCE_COLOR` values as a
  depth API; presence still means “force color on” under the adoption
  reading, and implementations may **warn** when the value looks like a
  bare depth integer so operators can migrate.

(Political tone: describe conflict and recommendation; do not mock
ecosystems in the normative sections.)

### Out of scope here

- Theming / palette
- CLICOLOR*
- TTY_COMPATIBLE (future)
- chalk levels as API

---

## RFC 034 — Temporary directory environment variables

**Working nexp:** `salotz.034_temp-env`  
**Depends:** 032 (path/empty) lightly

### Normative env order (Python `tempfile`)

1. `TMPDIR`
2. `TEMP`
3. `TMP`

First set and non-empty wins.

### Asides only

- OS defaults if all unset: not specified here
- Windows `GetTempPath` order differs; portable implementers keep Python
  order; operators set `TEMP`/`TMP` (and optionally `TMPDIR`)
- `XDGX_TMP_HOME` (024): may be pointed at via `TMPDIR`; not in chain
- Scratch: no new globals in this wave

### Common-core twin

037 defines optional `<CORE>__TMPDIR` (or similar) as best-practice
override when global temp vars are hostile or shared incorrectly.
Exact leaf name workshopped in 037.

---

## RFC 035 — Logging environment variables

**Working nexp:** `salotz.035_log-env`  
**Depends:** 032 enum

### Scope

- **`LOG_LEVEL` only** for unprefixed app logs
- No `LOG_FILE` / `LOG_FORMAT` in v0

### Draft enum

`off` < `error` < `warn` < `info` < `debug` < `trace`

- Default: `info`
- Threshold semantics
- Aliases via 032 (`warning`→`warn`; `fatal`/`critical`→`error` lean)
- Unknown: 032 invalid policy
- Not `OTEL_LOG_LEVEL`

### Common-core twin

`<CORE>__LOG_LEVEL` in 037.

---

## RFC 036 — Debug-mode environment variables

**Working nexp:** `salotz.036_debug-env`  
**Depends:** 032 bool

### Scope

- **`DEBUG`** = boolean **debug mode** (extra diagnostics, etc.)
- Unset/empty → false
- Independent of `LOG_LEVEL` (often paired in practice; not required)
- Node-style `DEBUG=ns1,ns2` filters: **non-conforming** here
- Invalid: 032 policy (lean warn + false)

### Common-core twin

`<CORE>__DEBUG` in 037.

---

## RFC 037 — Application common core

**Working nexp:** `salotz.037_app-common-core`  
**Depends:** 032–036, 027, 031  
**Working title alternatives to workshop:** Application Common Core;
Application Control Profile; CXE / AppCore (prefix branding TBD)

### Problem

Even with good leaf standards, **globals collide**: one tool’s `DEBUG=*`
filter, another’s boolean; CI sets `FORCE_COLOR`; operators need
**per-app** on-standard knobs without forking semantics.

### Goals

1. **Define a namespace / prefix** for common-core leaves  
   (workshop name: something short, unlikely, RFC 027-friendly —
   candidates later; placeholder `<CORE>` or e.g. `APPCORE`, `CXE`,
   `SALOTZ_ACC` — **do not lock in this plan**).
2. **How to advertise adherence**  
   - prose + machine: RFC 031 `[env]` / `external` + optional
     `groups = ["app-common-core"]`  
   - optional core version pin / “implements 037 + leaves”  
   - help text / `--help` discovery patterns (yerk lesson: registry)
3. **Which standalone standards to use**  
   table pointing at 033–036 (and 032 for parsing)
4. **Prefixed best-practice twins**  
   For each leaf, define `<CORE>__…` parallel names with **same value
   semantics** as the global standard, for:
   - forward “on-standard” apps
   - shared environments where globals are abused or conflicting
5. **Precedence** between global and prefixed twins (must be explicit)

### Prefixed twins (sketch; final names in 037)

| Concern | Global (compat / de facto) | Best-practice twin (core) |
|---------|----------------------------|---------------------------|
| Color policy | `COLOR_WHEN` (033) + `NO_COLOR` / `FORCE_COLOR` | `<CORE>__COLOR_WHEN` |
| Temp | `TMPDIR` / `TEMP` / `TMP` | `<CORE>__TMPDIR` (single path; skip re-implementing TEMP/TMP chain unless needed) |
| Log level | `LOG_LEVEL` | `<CORE>__LOG_LEVEL` |
| Debug | `DEBUG` | `<CORE>__DEBUG` |

clig’s `MYAPP_NO_COLOR` is the same *escape hatch* idea; common core
makes it **systematic** and aligned with 027 fielding (`__`).

### Precedence sketch (workshop in 037)

Lean options:

- **A:** CLI > `<CORE>__*` > globals > default  
  (prefixed is deliberate per-app override of globals)
- **B:** CLI > globals > `<CORE>__*` > default  
  (core only when globals unset — weaker escape hatch)

**Recommendation lean: A** so operators can fix one misbehaving global
profile per app. Document clearly.

Color legacy pair still resolved inside 033 **after** CLI and after
preferred vars (global `COLOR_WHEN` and `<CORE>__COLOR_WHEN` slot into
step 2 carefully — 037 specifies order between those two).

### Adherence levels (sketch)

- **Compat:** honor globals per 033–036
- **Core:** compat + prefixed twins + advertised registry
- **Library:** document caller responsibility

### Non-goals

- Replacing product prefixes (`WUMPUS__*`) for product-specific config
- Becoming a legal standards org
- Requiring all apps on earth to adopt the prefix

### Relationship map

```text
Process environment
├── Globals (de facto + 033–036): NO_COLOR, LOG_LEVEL, DEBUG, TMPDIR, …
├── Common core prefix (037): <CORE>__COLOR_WHEN, <CORE>__DEBUG, …
└── Product prefix (027/031): MYAPP__DATABASE_URL, …
```

---

## Cross-cutting decisions already leaned

| Topic | Lean |
|-------|------|
| Values before leaves | 032 first |
| Color both-legacy set | `never` + warn |
| FORCE_COLOR levels | reject as API; appendix explains |
| Capability | auto best-effort from terminal; not a 0–3 ladder on FORCE_COLOR |
| COLOR bare name | no; prefer `COLOR_WHEN` or core-prefixed |
| DEBUG | bool mode, not filters |
| LOG_* sinks/format | out |
| Tracing | out |
| Prefixed twins | yes, owned by 037 |
| Reporting invalid | 032; stderr/warn once |

## Open workshop items (do not block plan structure)

1. 032 bool/enum token tables  
2. Final `COLOR_WHEN` vs other policy name  
3. Final `<CORE>` prefix string and branding  
4. 037 precedence A vs B  
5. Whether `<CORE>__NO_COLOR` exists or only policy enum twin  
6. TTY capability RFC timing and names  

## Future: TTY capability

Org idea:  
`admin/org/notes/todo/ideas/20260927T202306--tty-capability-env-overrides__idea_devel_rfc.org`

- Generalize capability vs interactivity overrides (Rich prior art)
- After 032 + 033; may gain `<CORE>__*` twins under 037 rules

- [ ] Later: draft TTY env RFC when prioritized

## Deliverables when executing

1. Draft `rfcs/salotz.032_…` through `037_…` per editing.md  
2. Top-level README index entries  
3. Patch RFC 031 open question → point at 037  
4. Optional: short `unix-names.md` cross-links for new preferred names  
5. Link check for no-color.org, force-color.org, clig.dev (citation), Python tempfile  

## Explicitly discarded structure

- Separate RFCs only for no-color.org and force-color.org pages  
  → **folded into 033** with clear subsections + external links  
- Umbrella-before-core numbering  
  → **037 is the core/umbrella** after leaves  
- Old single “cross-cutting 032” mega-RFC and prior multi-handoff split  
  → **this plan file only**

## Session checklist

- [ ] Workshop and draft **032**
- [ ] Draft **033** (incl. polite appendix on FORCE_COLOR depth overload)
- [ ] Draft **034**, **035**, **036**
- [ ] Workshop prefix name; draft **037**
- [ ] Index + 031 links
- [ ] TTY idea remains backlog unless pulled in
