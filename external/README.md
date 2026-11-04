# External standards

CUE schemas for **third-party** standards that RFCs cite or extend.

Each spec is its own CUE module, versioned in the directory tree when
the upstream version is known. RFC schemas import these instead of
re-encoding the same types.

## File formats

| Spec | Path | Module |
|------|------|--------|
| [Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/) | [keep-a-changelog/1.1.0](keep-a-changelog/1.1.0/schemas/) | `keepachangelog.com/keep-a-changelog` |

## Directories

| Spec | Path | Module |
|------|------|--------|
| [XDG Base Directory](https://specifications.freedesktop.org/basedir/latest/) | [xdg-base-directory](xdg-base-directory/schemas/) | `specifications.freedesktop.org/basedir` |
| [PRJ Spec](https://github.com/numtide/prj-spec) | [prj-spec](prj-spec/schemas/) | `github.com/numtide/prj-spec` |

## Environment names

One module, [`env/`](env/), path `salotz.info/unix-env`. Each catalog is a package:

| Package | Import | Covers |
|---------|--------|--------|
| `posix` | `salotz.info/unix-env/posix` | POSIX/SUS Chapter 8 names and name form |
| `locale` | `salotz.info/unix-env/locale` | `LANG`, `LC_*` |
| `gettext` | `salotz.info/unix-env/gettext` | GNU gettext `LANGUAGE` |
| `systemd` | `salotz.info/unix-env/systemd` | `SYSTEMD_*`, service invocation vars |
| `openssh` | `salotz.info/unix-env/openssh` | `SSH_*` |
| `nocolor` | `salotz.info/unix-env/nocolor` | [no-color.org](https://no-color.org/) `NO_COLOR` |
| `x11` | `salotz.info/unix-env/x11` | X Window System names |
| `defacto` | `salotz.info/unix-env/defacto` | Unprefixed de facto names |
