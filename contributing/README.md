This folder contains documentation of the specific work processes and
quality control that goes into this project.

## RFC File Layout Convention

- Use a **directory** (containing `README.md` plus any supporting files)
  only when the RFC needs additional assets beyond a single document.
  Examples of supporting files: `implementation-advice.md`,
  format summary documents, examples, etc.

- Use a **single flat `.md` file** for simple RFCs that are self-contained
  in one document.

Current examples:
- Directories: `salotz.002_semantic-changelog/`, `salotz.006_codetags/`,
  `salotz.021_git-commit-messages/`
- Flat files: most others (e.g. `salotz.003_rfc-specs.md`)

This convention keeps the tree simple while allowing complexity when needed.
