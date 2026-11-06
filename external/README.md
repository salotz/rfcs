# External standards

CUE schemas for **third-party** standards that RFCs cite or extend.

Each spec is its own CUE module, versioned in the directory tree when
the upstream version is known. RFC schemas import these instead of
re-encoding the same types.

## File formats

| Spec                                                           | Path                                                      | Module                                |
|----------------------------------------------------------------|-----------------------------------------------------------|---------------------------------------|
| [Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/) | [keep-a-changelog/1.1.0](keep-a-changelog/1.1.0/) | `keepachangelog.com/keep-a-changelog` |

## Directories

| Spec | Path | Module |
|------|------|--------|
| [XDG Base Directory](https://specifications.freedesktop.org/basedir/latest/) | [xdg-base-directory](xdg-base-directory/schemas/) | `specifications.freedesktop.org/basedir` |
| [PRJ Spec](https://github.com/numtide/prj-spec) | [prj-spec](prj-spec/schemas/) | `github.com/numtide/prj-spec` |

## Unix

One module, [`unix/`](unix/), path `salotz.info/unix`.

| Package           | Import                             | Covers                                                                   |
|-------------------|------------------------------------|--------------------------------------------------------------------------|
| `path`            | `salotz.info/unix/path`            | Lexical Unix paths, tilde and `$HOME` / `${HOME}` expansion              |
| `fstab`           | `salotz.info/unix/fstab`           | [fstab(5)](https://man7.org/linux/man-pages/man5/fstab.5.html) records (`#Record`, `#RecordStruct`) and tables (`#Table`); `UUID=`/`LABEL=` tags |
| `envvar`          | `salotz.info/unix/envvar`          | Env var names (`#Name`, `#UtilityName`) and POSIX sh `$name` / `${name}` |
| `varsets/all`     | `salotz.info/unix/varsets/all`     | Union of every varset; `#ApplicationName` excludes them                  |
| `varsets/posix`   | `salotz.info/unix/varsets/posix`   | POSIX/SUS Chapter 8 names and name form                                  |
| `varsets/locale`  | `salotz.info/unix/varsets/locale`  | `LANG`, `LC_*`                                                           |
| `varsets/gettext` | `salotz.info/unix/varsets/gettext` | GNU gettext `LANGUAGE`                                                   |
| `varsets/systemd` | `salotz.info/unix/varsets/systemd` | `SYSTEMD_*`, service invocation vars                                     |
| `varsets/openssh` | `salotz.info/unix/varsets/openssh` | `SSH_*`                                                                  |
| `varsets/nocolor` | `salotz.info/unix/varsets/nocolor` | [no-color.org](https://no-color.org/) `NO_COLOR`                         |
| `varsets/x11`     | `salotz.info/unix/varsets/x11`     | X Window System names                                                    |
| `varsets/defacto` | `salotz.info/unix/varsets/defacto` | Unprefixed de facto names                                                |

## Scalars (`std`)

One module, [`std/`](std/), path `salotz.info/std`. Shared identifiers, timestamps, and encodings — not `common`, which is already a URL-scheme package.

Other names considered: `salotz.info/scalar`, `salotz.info/data`, or three tiny modules (`id`, `time`, `encoding`).

| Package | Import | Covers |
|---------|--------|--------|
| `id` | `salotz.info/std/id` | UUID (RFC 9562, v1–v8), ULID, KSUID, TypeID, NanoID, xid |
| `datetime` | `salotz.info/std/datetime` | ISO 8601 date/time, RFC 3339 (`time.Time`), Unix time, ISO duration |
| `encoding` | `salotz.info/std/encoding` | Hex, Base64/Base32 (RFC 4648), MD5/SHA-1/SHA-2 hex digests |

## Media types, HTTP, SemVer

| Spec | Path | Module |
|------|------|--------|
| Media types ([RFC 6838](https://www.rfc-editor.org/rfc/rfc6838)) | [mime](mime/) | `salotz.info/mime` |
| HTTP methods, status, headers ([RFC 9110](https://www.rfc-editor.org/rfc/rfc9110)) | [http](http/) | `salotz.info/http` |
| [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html) | [semver](semver/) | `salotz.info/semver` |

`salotz.info/mime` covers `type/subtype`, Content-Type lines, and subtype **namespaces** (RFC 6838 registration trees): standards (no prefix), vendor (`vnd.`), personal/vanity (`prs.`), unregistered (`x.`), plus the deprecated RFC 2046 experimental prefix (`x-`). Structured syntax suffixes (`+json`, `+xml`, …) are RFC 6839.

## URLs

One module, [`url/`](url/), path `salotz.info/url`. Lexical types, not product identity (`yerk://…` stays in the consuming app).

Decomposed forms use a `Struct` suffix (`#URLStruct`, `#AddressStruct`) so applications can generate strings from JSON-shaped records. String types stay unsuffixed (`#URL`, `#Address`).

| Package | Import | Covers |
|---------|--------|--------|
| `core` | `salotz.info/url/core` | [RFC 3986](https://www.rfc-editor.org/rfc/rfc3986) URI/URL, components, slug, `#URLStruct` (CUE `net`) |
| `urn` | `salotz.info/url/urn` | [RFC 8141](https://www.rfc-editor.org/rfc/rfc8141) URN, UUID URN |
| `email` | `salotz.info/url/email` | addr-spec / mailbox (RFC 5321/5322 subset, RFC 5233 plus-addressing) |
| `common` | `salotz.info/url/common` | Well-known schemes: http(s), ssh, file, git, ftp(s), mailto ([RFC 6068](https://www.rfc-editor.org/rfc/rfc6068)), tel ([RFC 3966](https://www.rfc-editor.org/rfc/rfc3966)) |

## Git

One module, [`git/`](git/), path `salotz.info/git`.

| Package | Import | Covers |
|---------|--------|--------|
| `url` | `salotz.info/git/url` | Clone remotes ([git-clone URLs](https://git-scm.com/docs/git-clone#_git_urls)): scheme, SCP, host path |
| `refs` | `salotz.info/git/refs` | Ref names ([git-check-ref-format](https://git-scm.com/docs/git-check-ref-format)), not gitrevisions(7) |
| `objects` | `salotz.info/git/objects` | Object types and SHA-1 / SHA-256 names |
| `revisions` | `salotz.info/git/revisions` | [gitrevisions(7)](https://git-scm.com/docs/gitrevisions) object names and ranges |
| `gitignore` | `salotz.info/git/gitignore` | [gitignore(5)](https://git-scm.com/docs/gitignore) pattern lines |
| `config` | `salotz.info/git/config` | [git-config(1)](https://git-scm.com/docs/git-config) sections, values, includeIf |
| `attributes` | `salotz.info/git/attributes` | [gitattributes(5)](https://git-scm.com/docs/gitattributes) names and settings |
| `hooks` | `salotz.info/git/hooks` | [githooks(5)](https://git-scm.com/docs/githooks) hook names |
| `modules` | `salotz.info/git/modules` | [gitmodules(5)](https://git-scm.com/docs/gitmodules) |
| `mailmap` | `salotz.info/git/mailmap` | [gitmailmap(5)](https://git-scm.com/docs/gitmailmap) |
| `pathspec` | `salotz.info/git/pathspec` | Pathspec magic (`:(glob)`, `:(exclude)`, `:(attr:…)`) |
| `trailers` | `salotz.info/git/trailers` | [git-interpret-trailers(1)](https://git-scm.com/docs/git-interpret-trailers) |

## Check

CUE `0.17.1` is pinned in [`mise.toml`](mise.toml). Each module has `*:vet` / `*:fmt` so it can move to its own repository.

```sh
mise install
mise run vet
mise run fmt
mise run unix:vet
```
