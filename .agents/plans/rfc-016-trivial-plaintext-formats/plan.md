# Plan: resurrect RFC 016 (nearly trivial plaintext formats)

## Context

RFC 016 is a 2020 sketch (~40 lines) that never got a prior-art review or a
citable grammar.
The original problem statement still holds:

> This spec is more about being able to easily recognize when a file is
> truly simple and not actually more complex.

That is a **promise via extension** (and grammar):
`.list` means a list of strings, nothing else;
`.str` means one string, read as text, do not parse.
Without that promise, every consumer reinvents comment rules, empty-line
rules, trailing-newline rules, and quoting, and the file silently becomes
CSV, gitignore, dotenv, or YAML.

History:

- `777aef5` (2020-02-19) — first sketch (list file)
- `fa999a2` (2020-06-15) — add `.str`
- `9afe776` / `2345120` / `c52204b` (2026-08-01) — org→markdown, list-line, metadata

Research (2026-10-08): there is **no competing generic spec**.
gitignore, APT `.list`, JSON Lines, CSV, envdir, dotenv each specialize the
ceiling.
Nobody published the ceiling itself.
Notes: [background/prior-art.md](./background/prior-art.md).

Current path: `rfcs/salotz.016_trivial-plaintext-formats.md` (flat).
Status: DRAFT.
Index: top-level `README.md` § 016.

This plan is **RFC rewrite only**.
No parsers, no IANA registration, no status promotion unless a locked
decision says otherwise.

---

## Goals

1. Operator-locked answers in [decisions.md](./decisions.md) for the v0
   format set and the three design fights (`.str` newline, `.list`
   comments, list-line).
2. RFC 016 rewritten in post-2026 house style (see 014, 029, 032):
   motivation, goals, non-goals, common rules, per-format grammar,
   examples, non-examples, “when not to use this.”
3. Top-level index executive summary in sync.
4. Editing checklist (`contributing/editing.md`): links, metadata,
   spelling/grammar.
5. Stay DRAFT.

## Non-goals (this plan)

- Writing parsers, libraries, or test fixtures
- IANA media-type registration
- Changing RFC 032’s deferred array/list env encodings
- Cloning CSV, JSON Lines, YAML, NestedText, dotenv, or TOON
- Marking 016 as anything other than DRAFT (unless Q10 locks otherwise)
- Citing plan-local `Q*` ids in the RFC body

---

## What to keep from the sketch

- **Recognition framing:** format as a *ceiling* on complexity, not a
  kitchen-sink language.
- Distinguishing **data string** (`.str`) from **human prose** (`.txt`).
- `#` comments on list files (Unix convention).
- File extensions as the public contract.

## What the rewrite must add

The sketch has no goals/non-goals, no encoding/newline/empty-file rules,
underspecified comments, “tokens” vs strings, no whitespace/empty-item
rules, a broken list-line autodetect, undocumented extension collisions,
no examples, no “when not to use this,” and a stale index blurb.

---

## Design principles (proposed — lock or reject in Q1–Q10)

1. **Ceiling, not floor.**
   A listed format must remain parseable by a ~10-line reader.
   If you need quoting, types, or nesting, stop and use a real format.
2. **Strings only.**
   No integers, booleans, nulls, dates in the file grammar.
   Interpretation is the consumer’s job (NestedText lesson).
   RFC 032 covers typed env values; do not duplicate it.
3. **No escaping in v0** if at all possible.
   If a character is a delimiter, it is forbidden in values, or the
   format is the wrong choice.
4. **Unix text.**
   UTF-8, no BOM, LF.
   POSIX trailing newline required for multi-line text files.
   CRLF: tolerated on read, not produced.
5. **Comments are a format feature, not a universal.**
   `.list` has them; `.str` does not (the whole file is the value).
6. **Extension is the contract.**
   Filename suffix tells a human or agent which grammar to use.
   Do not sniff.
7. **Cite, don’t clone.**
   CSV, TSV, JSON Lines, gitignore, dotenv, envdir already exist.
   This RFC either *is* a tiny distinct grammar or *points at* the
   existing one.

### Common rules (proposed)

- Encoding: UTF-8, no BOM
- Newline: LF (`\n`). Readers MAY accept CRLF by stripping `\r`
- Trailing newline: required for `.list` (POSIX line). `.str` per Q2
- Empty file: `.list` → empty list. `.str` → empty string (this *is*
  data, unlike RFC 032 env empty-as-missing)
- Media type: `text/plain; charset=utf-8`
- Line length: no RFC-imposed `LINE_MAX`
- NUL: forbidden in all text formats here.
  NUL-delimited lists are a different format (Q5)

---

## Suggested RFC shape

Stay **flat** unless Q8 says otherwise.

```text
# 016: Nearly Trivial Plaintext Formats
- nexp / long name / executive summary

## Motivation
## Goals
## Non-goals
## Design principles
## Common rules (all formats in this RFC)
## Formats
  ### list file (`.list`)
  ### string file (`.str`)
  ### (optional new formats — Q5)
## Inline / non-file forms (if kept — Q4)
  ### list line
## Relationship to other RFCs
## Prior art (informative) — if Q9 keeps it in-RFC
## Deferred
## Examples
```

If the rewrite grows past ~400–500 lines, convert to a directory
(`README.md` plus optional `prior-art.md` / examples).
Default: stay flat.

### Relationship to other RFCs (to write into 016)

- **003** — keep nexp / long name / summary in sync with the index
- **004** — filenames/extensions as names; no change required
- **027** — PATH-like `:` is *names*; inline list is *values*.
  Cross-link delimiters; do not specify env names here
- **029** — if 016 grows a glossary, use 029
- **032** — typed env values; deferred array encoding.
  Do not define env arrays in 016
- **030 / 031** — no dependency now

---

## Phase 0 — Lock decisions

Operator reviews [decisions.md](./decisions.md).
Write under **Answer**; set Status to `locked` when ready.
Agent does not rewrite the RFC until the v0 format set and the three
design fights are locked (or explicitly accepted as proposed).

## Phase 1 — Rewrite RFC 016

Apply locked answers as prose (no `Q*` citations).
House style; examples and non-examples; “use CSV / JSON Lines /
NestedText instead” section.
Stay DRAFT.

## Phase 2 — Index and editing

Update `README.md` § 016.
Run `contributing/editing.md`:
links, metadata, spelling/grammar.

## Phase 3 — Close-out

Durable outcome is RFC 016.
Delete this plan folder.
Update owner [todo.md](../todo.md).

---

## Success criteria

- [ ] Q1–Q10 locked enough that the RFC has no TBD holes on the v0 set
- [ ] RFC 016 is citable as DRAFT (goals, non-goals, grammars, examples)
- [ ] Index blurb matches
- [ ] Editing checklist done
- [ ] Plan folder removable (no `Q*` in durable tree)

## Immediate next step

Operator: edit **Answer** under Q1–Q10 in [decisions.md](./decisions.md)
(accept proposed defaults or change them).
Say “decisions updated” / “go” in chat.
Agent will not start the rewrite until then.
