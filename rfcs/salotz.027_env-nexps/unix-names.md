# Common names and prefixes in UNIX

# Unix-like environment variable names

Standards that specify names, plus common unprefixed de facto names.

POSIX utilities use uppercase letters, digits, and `_`, and must not start with a digit. Lowercase names are reserved for applications.

Do not reuse names from the POSIX table, well-known tool preferences (`EDITOR`, `PAGER`, `BROWSER`), unprefixed `*PATH` search paths (unless the variable really is a search path), or short generics (`PORT`, `DEBUG`, `TMP`, `HOME`, `USER`).

---

## Prefixed and simple standards

Standards that are either a single reserved name or a single prefix namespace. Avoid these prefixes and names entirely; individual members are not listed.

| Spec | Names / prefix | What it covers |
| --- | --- | --- |
| freedesktop.org XDG (Base Directory, Desktop/session, user-dirs) | `XDG_*` | Config, data, cache, state, runtime dirs; current desktop/session; user dirs (`XDG_*_DIR`) |
| systemd (own knobs) | `SYSTEMD_*` | Service manager knobs (not a stable public product API) |
| systemd (sets for services) | `JOURNAL_STREAM`, `INVOCATION_ID`, `LISTEN_PID`, `LISTEN_FDS` | Service invocation metadata (also re-exports POSIX identity and search-path vars) |
| OpenSSH | `SSH_*` | Auth socket, connection metadata |
| [no-color.org](https://no-color.org/) | `NO_COLOR` | Disable color when set |
| PRJ Spec | `PRJ_*` | Project-local root, id, and directory layout |

---

## POSIX / SUS (XBD Chapter 8 and related)

These have standard meaning if present. Do not use them for another purpose.

| Name         | Role                                    |
|--------------|-----------------------------------------|
| `HOME`       | Login home directory                    |
| `PATH`       | Command search path                     |
| `LOGNAME`    | Login name (System V style)             |
| `USER`       | Login name (BSD style)                  |
| `SHELL`      | User's shell                            |
| `PWD`        | Current working directory               |
| `OLDPWD`     | Previous working directory              |
| `TERM`       | Terminal type                           |
| `TZ`         | Timezone                                |
| `TMPDIR`     | Temporary files                         |
| `EDITOR`     | Preferred editor                        |
| `VISUAL`     | Preferred visual / full-screen editor   |
| `PAGER`      | Preferred pager                         |
| `IFS`        | Field splitting                         |
| `PS1`        | Primary prompt                          |
| `PS2`        | Secondary prompt                        |
| `PS3`        | `select` prompt                         |
| `PS4`        | Debug (`set -x`) prompt                 |
| `CDPATH`     | `cd` search path                        |
| `MAIL`       | Incoming mail file                      |
| `MAILPATH`   | Mail search path                        |
| `MANPATH`    | Manual page search path                 |
| `COLUMNS`    | Terminal width                          |
| `LINES`      | Terminal height                         |
| `ENV`        | Shell startup file                      |
| `OPTARG`     | `getopt` current option argument        |
| `OPTERR`     | `getopt` error reporting                |
| `OPTIND`     | `getopt` next argv index                |
| `MAKEFLAGS`  | Flags passed through `make`             |
| `CC`         | C compiler                              |
| `CFLAGS`     | C compiler flags                        |
| `LDFLAGS`    | Linker flags                            |
| `ARFLAGS`    | `ar` flags                              |
| `YACC`       | yacc program                            |
| `YFLAGS`     | yacc flags                              |
| `LEX`        | lex program                             |
| `LFLAGS`     | lex flags                               |
| `PRINTER`    | Default printer                         |
| `LPDEST`     | LP destination                          |
| `TERMCAP`    | Termcap entry                           |
| `TERMINFO`   | Terminfo database location              |
| `HISTFILE`   | History file                            |
| `HISTSIZE`   | History size                            |
| `FCEDIT`     | `fc` editor                             |
| `MORE`       | `more` options                          |
| `NPROC`      | Processor count (some utilities)        |
| `NLSPATH`    | Message catalog path                    |
| `CHARSET`    | Character set (some utilities)          |
| `DATEMSK`    | `getdate` mask                          |
| `DEAD`       | `mailx` dead-letter file                |
| `EXINIT`     | `ex` / `vi` init                        |
| `FC`         | Fortran compiler (legacy utility table) |
| `FFLAGS`     | Fortran flags                           |
| `GET`        | `get` utility                           |
| `GFLAGS`     | `get` flags                             |
| `HISTORY`    | History (some shells / utilities)       |
| `LISTER`     | Directory lister                        |
| `MAILCHECK`  | Mail check interval                     |
| `MAILER`     | Mailer program                          |
| `MAILRC`     | `mailx` rc file                         |
| `MAKESHELL`  | Shell used by `make`                    |
| `MBOX`       | Mailbox file                            |
| `MSGVERB`    | `fmtmsg` verbosity                      |
| `PPID`       | Parent process id (some shells)         |
| `PROJECTDIR` | SCCS project dir                        |
| `PROCLANG`   | Process language (rare)                 |
| `RANDOM`     | Random value (some shells)              |
| `SECONDS`    | Seconds since shell start (some shells) |

### Locale (POSIX / ISO C)

| Name          | Role                                                 |
|---------------|------------------------------------------------------|
| `LANG`        | Default locale                                       |
| `LC_ALL`      | Override all locale categories                       |
| `LC_COLLATE`  | Collation                                            |
| `LC_CTYPE`    | Character classification                             |
| `LC_MESSAGES` | Message language                                     |
| `LC_MONETARY` | Monetary formatting                                  |
| `LC_NUMERIC`  | Numeric formatting                                   |
| `LC_TIME`     | Time formatting                                      |
| `LANGUAGE`    | GNU gettext fallback (de facto, not POSIX Chapter 8) |

---

## X Window System

| Name | Role |
| --- | --- |
| `DISPLAY` | X server (`host:display.screen`) |
| `XAUTHORITY` | X authority file |
| `XENVIRONMENT` | Per-user X resources file |
| `XFILESEARCHPATH` | Xt file search path |
| `XAPPLRESDIR` | Application defaults directory |
| `XLOCALEDIR` | Locale files |
| `XMODIFIERS` | Input method modifiers |
| `XKEYSYMDB` | Keysym database |
| `XCMSDB` | Color name database |
| `XLOCAL` | Local connection type (some Unixes) |

---

## De facto unprefixed names

Not in the tables above, but still treated as global vocabulary. Do not use them for project-local knobs.

### Identity / session

| Name | Role |
| --- | --- |
| `UID` | User id |
| `EUID` | Effective user id |
| `GID` | Group id |
| `GROUPS` | Groups |
| `HOSTNAME` | Host name |
| `HOST` | Host name (some systems) |
| `HOSTTYPE` | Host / CPU type (bash) |
| `OSTYPE` | OS type (bash) |
| `MACHTYPE` | Machine type (bash) |

### Search paths

Often `*_PATH` with no product prefix.

| Name | Role |
| --- | --- |
| `INFOPATH` | Info pages |
| `LD_LIBRARY_PATH` | Dynamic linker |
| `LD_PRELOAD` | Preloaded libraries |
| `LIBRARY_PATH` | Link-time library search |
| `CPATH` | C include search |
| `PKG_CONFIG_PATH` | pkg-config |
| `PYTHONPATH` | Python modules |
| `GOPATH` | Go workspace |
| `NODE_PATH` | Node modules |

### Terminal / UI

| Name | Role |
| --- | --- |
| `COLORTERM` | Color-capable terminal |
| `WAYLAND_DISPLAY` | Wayland display |
| `BROWSER` | Web browser |
| `TERMINAL` | Preferred terminal emulator |

### Locale / i18n

| Name | Role |
| --- | --- |
| `TZDIR` | Zoneinfo directory |

### Temp / scratch

| Name | Role |
| --- | --- |
| `TMP` | Temp dir (DOS/Windows-ish, still seen) |
| `TEMP` | Temp dir (DOS/Windows-ish, still seen) |

### Shell / job control

| Name | Role |
| --- | --- |
| `HISTCONTROL` | History filtering |
| `HISTFILESIZE` | History file size |
| `PROMPT_COMMAND` | Command run before prompt (bash) |
| `BASH_ENV` | Non-interactive bash startup |
| `SHLVL` | Shell nesting level |
| `_` | Last argument / invoked command (bash and some shells) |

### Build / compile

Unprefixed on purpose.

| Name | Role |
| --- | --- |
| `CXX` | C++ compiler |
| `CPP` | C preprocessor |
| `CXXFLAGS` | C++ flags |
| `CPPFLAGS` | Preprocessor flags |
| `MAKELEVEL` | Make recursion depth |
| `DESTDIR` | Staged install root |
| `PREFIX` | Install prefix |

### Networking

Often lowercase. A special case.

| Name | Role |
| --- | --- |
| `http_proxy` | HTTP proxy |
| `https_proxy` | HTTPS proxy |
| `ftp_proxy` | FTP proxy |
| `all_proxy` | All-protocol proxy |
| `no_proxy` | Proxy exclusions |
| `HTTP_PROXY` | Uppercase variant (inconsistent) |

### Runtime / debug

Very common and collision-prone.

| Name | Role |
| --- | --- |
| `DEBUG` | Debug flag |
| `VERBOSE` | Verbose flag |
| `DRY_RUN` | Dry run |
| `TRACE` | Tracing |
| `LOG_LEVEL` | Log verbosity |
| `FORCE_COLOR` | Force color |
| `CI` | Running in CI |
| `NODE_ENV` | Node environment (`production` / `development`) |

### 12-factor / PaaS

| Name | Role |
| --- | --- |
| `PORT` | Listen port |
| `DATABASE_URL` | Database URL |
| `REDIS_URL` | Redis URL |

### Session bus / login leftovers

| Name | Role |
| --- | --- |
| `SESSION_MANAGER` | Session manager (X11) |
| `DBUS_SESSION_BUS_ADDRESS` | D-Bus session bus |
