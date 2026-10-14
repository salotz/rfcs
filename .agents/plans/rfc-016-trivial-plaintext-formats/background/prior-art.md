# Prior art — RFC 016 (research 2026-10-08)

Plan-local notes.
Compress into RFC 016 if Q9 locks that way.
Do not treat this file as a questionnaire.

Conclusion: **no competing generic spec**.
The gap is a named, extension-backed *ceiling* for files that are only a
string or only a list of strings.

## Unix text and one record per line

POSIX: a *line* is zero or more non-newline characters **plus a
terminating newline**.
A *text file* is zero or more lines, no NUL, no line exceeding
`LINE_MAX`.
A file that does not end in newline is not a POSIX text file.
Practical consequence: `.list` should require a trailing `\n`.

Genre in the wild (line + `#` comments + blank lines ignored):

- [gitignore](https://git-scm.com/docs/gitignore) — one pattern/line;
  `#` comments; blanks ignored; trailing spaces significant unless
  escaped; `!` negation — already too rich, but the comment/blank
  skeleton matches `.list`
- Debian `/etc/apt/sources.list` and `*.list` — same skeleton, domain
  vocabulary. Famous extension collision
- `/etc/shells`, `/etc/hosts` (partial) — line records; `#` comments
- Generic `.list` — [file-extension.info](https://www.file-extension.info/format/list):
  no single standard; one item per line; MIME `text/plain`; `#` ignored
  by most owners

NUL-delimited lists: `find -print0` / `xargs -0`.
Honest upgrade when records may contain newlines.
Not POSIX text (contains NUL).

Takeaway: RFC 016 `.list` standardizes a de facto genre that never had a
generic spec.
Do not also be gitignore or APT.

## Delimiter-separated values

- [RFC 4180](https://www.rfc-editor.org/rfc/rfc4180.html) CSV /
  `text/csv` — CRLF records, comma fields, quoting.
  Too rich. Cite as the next step.
- IANA `text/tab-separated-values` (1993) — tab fields; tabs inside
  fields forbidden.
  Closer to trivial than CSV. Cite rather than fork.
- PATH: `:` Unix, `;` Windows — most common inline DSV.
- NestedText’s CSV/TSV critique: compact for tables; quoting as soon as
  fields contain the delimiter.
  Agrees with 016’s ceiling.

Do not specify CSV.

## Single-value files

- [djb envdir](https://cr.yp.to/daemontools/envdir.html) — filename =
  env name (`=` forbidden); **first line** = value; trailing SP/TAB
  stripped; NUL → newline; empty file = unset.
  Directory of string files = map.
  First-line-only ≠ whole-file `.str`.
- `.nvmrc`, `.node-version`, `.python-version`, `.ruby-version` — one
  version string, often one line.
  Exactly the `.str` use case.
- Kubernetes downward API / Docker secrets — newline handling is a
  frequent footgun.
- `/proc`, `/sys` — one value per file, often with trailing newline.

Takeaway: `.str` is real.
The design fight is trailing newline and first-line vs whole-file.

## Line-oriented structured text (too much for 016)

Non-goals / “use these instead”:

- JSON — types, quoting, no comments
- [JSON Lines](https://jsonlines.org/) — UTF-8, one JSON value per line,
  `\n` terminator, `.jsonl`.
  Blank line ≠ valid.
  Correct upgrade when a `.list` item needs structure
- YAML — optional quoting → type accidents (`on` → `true`, `3.10` → `3.1`)
- TOML / INI — typed scalars, noisy nested keys
- dotenv — `KEY=value`, quotes, expansion, inline `#`
- EditorConfig — INI + gitignore globs
- [NestedText](https://nestedtext.org/) — strings/lists/dicts only,
  comments, indentation.
  Philosophical sibling (“only strings,” schema outside the file) but
  **not trivial**.
  Cite as the step *up* from 016.
  Steal the “Really, Only Strings?” argument: types in the file grammar
  force quoting; validation belongs in the consumer.
- [TOON](https://toonformat.dev/) (2025–) — JSON data model, LLM-token
  packing. Not trivial.

## What 016 uniquely adds

Not another data language.
A named ceiling:

> files that are *only* a string, or *only* a list of strings, with
> comment rules boring enough that a reader can implement them from
> memory.

gitignore, APT, JSONL, CSV, envdir, dotenv each specialize that ceiling.
Nobody published the ceiling itself.

## References

- POSIX line / text file (e.g. [calum.org](https://calum.org/posts/what-is-a-text-file-according-to-posix))
- [RFC 4180](https://www.rfc-editor.org/rfc/rfc4180.html)
- IANA `text/tab-separated-values` (1993)
- [JSON Lines](https://jsonlines.org/)
- [gitignore](https://git-scm.com/docs/gitignore)
- [envdir](https://cr.yp.to/daemontools/envdir.html)
- [NestedText alternatives](https://nestedtext.org/en/latest/alternatives.html)
- Debian `sources.list(5)`
- [Generic `.list` convention](https://www.file-extension.info/format/list)
- [TOON](https://toonformat.dev/)
