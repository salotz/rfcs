# Decisions inbox — rfc-016-trivial-plaintext-formats

Plan-local Q&A only.
Durable outcome: rewritten RFC 016.
Do **not** cite `Q*` in the RFC body or top-level README.

Work-process: write under **Answer**.
Set Status to `locked` when you want the rewrite to treat it as final.
Proposed defaults are agent leans from the 2026-10-08 research — not locked.

## Open queue

| ID | Status | Topic |
|----|--------|--------|
| Q1 | proposed | Title: “Nearly Trivial” vs “Trivial” |
| Q2 | proposed | `.str` trailing-newline policy (A / B / C) |
| Q3 | proposed | `.list` comment rule |
| Q4 | proposed | List-line: keep slim / drop / split |
| Q5 | proposed | v0 format set (which maybes) |
| Q6 | proposed | `.list` extension: keep vs rename |
| Q7 | proposed | Values that look like comments (`#head`) |
| Q8 | proposed | Flat file vs directory |
| Q9 | proposed | Prior-art section in the RFC vs background-only |
| Q10 | proposed | Stay DRAFT |

## Locked

_(none yet)_

---

## Q1 — Title: “Nearly Trivial” vs “Trivial”

Current long name: Nearly Trivial Plaintext Formats.
nexp stays `salotz.016_trivial-plaintext-formats` either way
(renumbering/renaming the nexp is out of scope).

“Nearly” is honest because comments exist and the ceiling is a *genre*,
not a formal language.
“Trivial” is shorter and matches the nexp.

### Prompt

Keep **Nearly Trivial** in the title, or drop “Nearly”?

### Context

Index and RFC heading currently use Nearly Trivial.

### Answer

Keep "nearly" its charming.

### Notes

Agent lean: **keep Nearly Trivial**.

---

## Q2 — `.str` trailing-newline policy

The file body is the string.
No comments.
The fight is how editors’ trailing newline interacts with the value.

- **A (envdir-like):** value is the **first line**; trailing spaces/tabs
  stripped; rest of file ignored.
  Empty file = empty / unset.
- **B (whole-file):** entire decoded UTF-8 body is the value, including
  a trailing `\n` if present.
- **C (whole-file minus at most one trailing `\n`):** POSIX-friendly
  editors add a final newline; consumers strip **at most one** trailing
  `\n` so a file containing `hello\n` yields `hello`.
  Interior newlines stay.

envdir is A (prior art, not this RFC’s `.str`).
Version-pin files (`.nvmrc`, `.python-version`) are A or C depending on
the tool.
Kubernetes / Docker secret files hit this footgun constantly.

### Prompt

Pick A, B, or C for RFC 016 `.str`.

### Context

[background/prior-art.md](./background/prior-art.md) § single-value files.

### Answer

C

### Notes

Agent lean: **C**.
Document A as envdir, not `.str`.

---

## Q3 — `.list` comment rule

One record = one line = one **opaque string** (not a “token”).
Blank lines ignored (not empty-string items).
No inline comments (`foo#bar` is a value).

Two whole-line rules:

- **First non-whitespace:** a line whose first non-whitespace character
  is `#` is a comment (gitignore / `sources.list` style).
  Indented `# foo` is a comment.
- **Column 0 only:** `#` must be the first character.
  Indented `# foo` is a value.

### Prompt

First non-whitespace, or column 0 only?

### Answer

first non-whitespace

### Notes

Agent lean: **first non-whitespace, whole-line only**.

---

## Q4 — List-line (inline DSV)

The current RFC’s weakest part:
no extension, default `,` with fallback `:` when comma appears in values
(undetectable), no quoting (not CSV).

Options:

- **Drop from v0:** file formats only; mention PATH/CSV as prior art.
- **Keep slim:** non-file profile named `list-line`; **one** separator
  declared by the consumer; values MUST NOT contain the separator, `#`,
  or newline; no quoting; **no** autodetect `,` → `:`.
- **Split:** point at RFC 4180 / IANA TSV for files; define only a
  PATH-style `:` list for Unix names.

Default separators if slim: `,` for prose/CSV-ish, `:` Unix path-like,
`;` Windows path-like — chosen by the consumer, not sniffed.

### Prompt

Drop, keep slim, or split?

### Answer

Drop, separate RFC for interpreting single line string as list and can use a single .str file with that value

### Notes

Agent lean: **keep slim** (declared separator, no autodetect).

---

## Q5 — v0 format set (which maybes)

**Already in the sketch (recommend keep):**

- `.list` — line-oriented list of strings
- `.str` — single string file
- list-line — only if Q4 keeps it

**Maybes** (each yes/no; default none in v0):

- **`.set`** — `.list` plus uniqueness (maybe sorted).
  Tension: uniqueness is often a consumer invariant, not a format.
- **pairs / map** (`.pairs` or `.map`) — one `key<SEP>value` per line.
  Tension: SEP (`=` vs tab vs `:`); `=` collides with dotenv; tab is
  two-column TSV (cite IANA rather than fork).
- **envdir pattern** — directory of `.str` files; filename = key;
  empty file = unset.
  Proven (djb).
  Might be a **usage pattern** of `.str`, not a new extension.
- **NUL-list** (`.list0` / `.nlst`) — records separated by NUL; no
  comments.
  Needed for path lists; breaks “text file.”
- **TSV-of-strings** — cite IANA TSV in one paragraph; do not fork.

**Out (point elsewhere, not maybes):**
CSV (RFC 4180), JSON/JSONL, YAML/TOML/INI, NestedText, TOON, dotenv,
EditorConfig, RFC 029 glossaries, RFC 032 typed env values, `.int` /
`.bool` files, paragraph/folded records, MIME registration.

### Prompt

Which maybes (if any) land in this rewrite?
Default: **none** — document as deferred.

If you want a pairs/map format, also pick extension (`.pairs` vs `.map`)
and separator (tab vs first `=`).

### Answer

<!-- operator writes here -->

### Notes

Agent lean: **none of the maybes** in v0.
envdir as a short “usage pattern” paragraph under `.str` is optional
and cheap if you want it without a new extension.

---

## Q6 — `.list` extension: keep vs rename

`.list` collides with Debian APT `sources.list` / `*.list` and GNU Info
`.list`.
Those are **domain languages** on top of “line + `#` comments,” not a
generic string list.
In the wild, `.list` already means “generic one-item-per-line plaintext”
with no single spec.

Rename options: `.lines`, `.lst`.
Keeping `.list` matches the word people already use; a collision note is
enough if the RFC claims the *genre*, not exclusivity.

### Prompt

Keep `.list`, or rename (say to what)?

### Answer

<!-- operator writes here -->

### Notes

Agent lean: **keep `.list`**; document the APT/Info collision.

---

## Q7 — Values that look like comments

Under Q3, a line that parses as a comment is not a list item.
Encoding `#head` as a value needs escaping, which v0 wants to avoid.

- **Ignore-as-comment (gitignore):** such lines are comments; you cannot
  represent that value in `.list`; use JSON Lines.
- **Forbid / invalid:** producers MUST NOT emit a value that would parse
  as a comment; consumers that want a strict mode may reject rather than
  skip (usually the same as ignore for a comment-eating reader).

Empty-string items are the same class: forbidden in v0 (would need
escaping). `"foo\n\nbar"` is two items, not three.

Whitespace: **keep** leading and trailing (values are opaque).
Authors should not rely on trailing spaces.
Duplicates allowed (it is a list, not a set).

### Prompt

Confirm: no escaping; `#…` lines are comments; empty items out of scope;
whitespace kept.

### Answer

<!-- operator writes here -->

### Notes

Agent lean: **yes** — gitignore-style ignore-as-comment; say so; JSONL
is the upgrade.

---

## Q8 — Flat file vs directory

`contributing/README.md`: use a directory only when the RFC needs
supporting assets.

Default: stay **flat** (`rfcs/salotz.016_trivial-plaintext-formats.md`)
unless examples + prior-art push past ~400–500 lines.

### Prompt

Force flat, force directory, or “flat unless it grows”?

### Answer

<!-- operator writes here -->

### Notes

Agent lean: **flat unless it grows**.

---

## Q9 — Prior-art section in the RFC

Full notes live in [background/prior-art.md](./background/prior-art.md)
(plan-local; deleted at close-out).
The RFC can carry a **compressed informative appendix** (POSIX,
gitignore/APT, envdir, RFC 4180, JSON Lines, NestedText) so the
“cite, don’t clone” story survives the plan.

### Prompt

Compressed prior-art section **in** RFC 016, or only “when not to use
this” pointers without the survey?

### Answer

<!-- operator writes here -->

### Notes

Agent lean: **yes, compressed in-RFC**.
The survey is the thing this RFC never had.

---

## Q10 — Status

Index and RFC currently say DRAFT.
Promotion is a separate decision.

### Prompt

Stay DRAFT after this rewrite?

### Answer

<!-- operator writes here -->

### Notes

Agent lean: **yes, stay DRAFT**.

---

## Changelog

- 2026-10-09 — created Q1–Q10 as proposed defaults from 2026-10-08 research.
