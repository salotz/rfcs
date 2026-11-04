This folder contains documentation of the specific work processes and
quality control that goes into this project.

## RFC File Layout Convention

Each RFC lives in a **directory** named after its nexp, with `README.md`
as the proposal document. Additional assets go alongside the README:
implementation advice, format summaries, examples, glossaries, and
machine-readable schemas.

CUE schemas for validating data that follows an RFC live in `schemas/`
inside that RFC directory. Each RFC is its own CUE module
(`schemas/cue.mod`, path `salotz.info/rfcs/<number>_<short-name>`).

Third-party standards that RFCs cite (Keep a Changelog, XDG Base
Directory, PRJ Spec, …) have their own modules under [external/](../external/).

When one schema imports another, declare it in `schemas/cue.mod/module.cue`
`deps` (module path + version). Local checkouts without a registry use
`cue.mod/local-module.cue` `replaceWith` relative paths to the other
module root (sibling RFC `schemas/` or `external/…`). That file is
gitignored per module (`cue.mod/.gitignore`); it is not published.

Use a directory even for short RFCs so schemas and later supporting files
have a stable home.

## Editing

See [editing.md](editing.md) for the editor checklist (links, metadata,
spelling/grammar, and index updates).
