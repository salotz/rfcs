# Keep a Changelog — Format Summary

**Purpose**: Concise reference for the *file format and structure* from [Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/). This covers only layout rules that do not overlap the semantic-changelog RFC (no custom sections, no versioning scheme, no audiences, no trailers).

See the parent [Semantic Changelog RFC](README.md) for this project's adaptations.

## Recommended Filename

`CHANGELOG.md`

## Header

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
```

## Unreleased Section

```markdown
## [Unreleased]
```

Collect upcoming changes here; move to a versioned section on release.

## Version Sections

```markdown
## [1.0.0] - 2017-06-20
```

- Use `##`
- Format: `[X.Y.Z] - YYYY-MM-DD` (ISO 8601)
- Latest version first
- Every version must have a section
- Date is the release date

**Yanked releases**:

```markdown
## [0.0.5] - 2014-12-13 [YANKED]
```

## Structural Principles

- Written for humans
- One entry per version
- Group like changes together
- Make versions and sections linkable
- Show release date for each version
- Latest version at top

## Reference Links (Optional)

At bottom of file:

```markdown
[1.0.0]: https://.../compare/v0.9.0...v1.0.0
[Unreleased]: https://.../compare/v1.0.0...HEAD
```

## Notes for Agents

- Version heading pattern: `^##\s*\[([^\]]+)\]\s*-\s*(\d{4}-\d{2}-\d{2})`
- `[YANKED]` may appear in heading
- `[Unreleased]` has no date
- Do not assume standard headings carry this project's semantics

Full spec: https://keepachangelog.com/en/1.1.0/
