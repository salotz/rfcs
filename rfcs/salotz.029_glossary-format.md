# Glossary Format

- nexp :: `salotz.029_glossary-format`
- long name :: Glossary Format
- executive summary :: Defines a simple Markdown format for glossaries: a top-level `# Glossary` heading, one `## term` subheading per entry, short definition bodies, and in-document cross-links between terms. Prefer this over tables so definitions remain linkable. Originally specified inline in RFC 22; extracted here for reuse across RFCs, projects, and shared agent guidelines.

This RFC standardizes how glossaries are written in Markdown so that
humans and agents can reliably author, link, and extend term
definitions across projects and shared guideline sets.

It was first described under [RFC 22](./salotz.022_ai-coding-structure/README.md)
(design documentation) and matches the living example in shared
agent-guidelines glossaries. This document is the normative home for
the **format**; placement of glossary files within a repository layout
remains a concern of the consuming standard (for example RFC 22's
`design/glossary.md`).

## Goals

- One obvious structure for term definitions in Markdown
- Stable fragment links between related terms
- Easy incremental addition of entries without reformatting a table
- Reuse the same format in project design docs, RFCs, and shared
  guideline repositories

## Non-goals

- A formal vocabulary or ontology language (SKOS, etc.)
- Mandating *which* terms must exist in any given glossary
- Requiring a glossary in every repository or RFC
- Specifying tooling beyond ordinary Markdown heading anchors

## File name

When a single glossary file is used, name it `glossary.md` unless a
consuming standard requires otherwise.

Multiple glossaries may exist (for example project-local vs shared).
A glossary may link to other glossaries for terms defined elsewhere.

## Format

A glossary is a Markdown document of the following shape:

```markdown
# Glossary

Optional one-line intro describing scope or pointing at related
glossaries.

## term-a

Definition of term-a. May link to [term-b](#term-b).

## term-b

Similar to [term-a](#term-a), but different.
```

### Rules

1. **Document title** — Exactly one top-level heading: `# Glossary`
   (or `# Glossary` plus a short qualifier if several glossaries share
   a tree, e.g. `# Glossary (host)`). Prefer the bare title when there
   is a single file.

2. **One term per subheading** — Each term is a level-2 heading
   (`## ...`). Do not pack multiple terms into one heading.

3. **Heading text is the term** — Use the canonical term (or short
   phrase) as the heading. Prefer lowercase for ordinary nouns unless
   the term is a proper name, acronym, or spelled form that is
   conventionally capitalized (e.g. `PRJX`, `Integration Environment`).

4. **Definition body** — Immediately under the heading, write one or
   more short paragraphs. Lead with the definition; add examples or
   notes after.

5. **Cross-links** — When a definition uses another glossary term,
   link it with an in-document Markdown link to that term's heading
   anchor, e.g. `[project root](#project-root)`. This is the primary
   reason subheadings are required instead of tables.

6. **External references** — Links to other docs, RFCs, or glossaries
   are encouraged when a term is only summarized here.

7. **No table-as-glossary** — Do not use a Markdown table as the sole
   structure for the glossary. Tables hide per-term anchors and make
   cross-links awkward. (A table elsewhere as an *index* is fine.)

8. **Ordering** — No required order. Alphabetical is fine; thematic
   grouping is fine. Prefer consistency within one file.

9. **Aliases** — If a term has a common alias, mention it in the body
   (e.g. "Also called **FQ name**.") Optional extra headings that only
   redirect (for example `## FQ name` whose body is "See
   [fully qualified project name](#fully-qualified-project-name).")
   are allowed when the alias is searched often.

### Anchor expectations

Fragment identifiers follow ordinary Markdown heading slug rules used
by common renderers (GitHub, etc.): lowercase, spaces to hyphens,
punctuation stripped. Authors should pick heading text that yields
stable, readable anchors (prefer `## project root` → `#project-root`
over heavily punctuated titles).

## Placement (informative)

Consuming standards decide where the file lives. Common patterns:

| Context                         | Typical path              | Defined by                                           |
|---------------------------------|---------------------------|------------------------------------------------------|
| AI-oriented project design docs | `design/glossary.md`      | [RFC 22](./salotz.022_ai-coding-structure/README.md) |
| RFC supporting assets           | `rfcs/<nexp>/glossary.md` | individual RFCs                                      |
| Shared agent guidelines         | `shared/glossary.md`      | host/org guideline repos                             |

## Examples

### Minimal

```markdown
# Glossary

## operator

The human person controlling an agent-aided process.

## project

A self-contained unit of work, usually a directory on a
[host system](#host-system).

## host system

The machine and operating system where [projects](#project) and
primary compute live.
```

### With scope blurb and external link

```markdown
# Glossary

Terms for this RFC. See also the shared agent-guidelines glossary.

## project ID

Host-specific identifier for a project replica. Exposed as `PRJX_ID`.
Normative rules: [RFC 28](./salotz.028_project-local-layout/README.md).
```
