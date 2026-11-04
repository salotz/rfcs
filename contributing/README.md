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

When one schema imports another, the dependency is wired locally with
a `cue.mod/pkg/` overlay (a symlink to the other module's
`schemas.cue`). CUE 0.15 has no module-replace for unpublished local
modules; the overlay is how imports resolve without a registry.

Use a directory even for short RFCs so schemas and later supporting files
have a stable home.

## Editing

See [editing.md](editing.md) for the editor checklist (links, metadata,
spelling/grammar, and index updates).
