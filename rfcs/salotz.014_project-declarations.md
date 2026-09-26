# 014: Project Declarations

- nexp :: `salotz.014_project-declarations`
- long name :: Project Declarations
- executive summary :: A best practice for publishing short, structured
  project declarations so consumers and contributors can judge fitness,
  risk, and expected quality at a glance. Topics include lifecycle phase,
  maintenance intent, authorship method (e.g. AI-assisted or AI-authored),
  contribution stance, and support. Includes suggested vocabularies and a
  README table convention.


Projects benefit from stating a few high-signal facts up front: how far
along the work is, how it will be cared for, how it was produced, and
whether outside help is wanted. Without that, readers infer maturity from
star counts, commit recency, or polish of the README—signals that often
mislead.

This RFC proposes **project declarations**: a small set of named topics
with short stances, ideally shown as a table near the top of the README
(or equivalent front page), with optional prose underneath for nuance.

It does not require every project to declare every topic. Declare what
helps readers; omit or mark `unspecified` when silence is honest.

## Goals

- Give consumers a fast read on whether to depend on, fork, or ignore a
  project
- Give contributors a clear picture of welcome vs closed contribution
  surfaces
- Make authorship and process facts first-class (including heavy AI use)
  so expected quality and review depth are not a surprise
- Prefer a short vocabulary over freeform essays for the summary table
- Keep one RFC for the pattern rather than a family of intent RFCs

## Non-goals

- A formal maturity model, certification, or compliance scheme
- Replacing licenses, codes of conduct, or security policies
- Mandating particular lifecycle or maintenance choices
- Scoring projects or ranking stances as morally better
- Specifying forge badges, CI checks, or machine schemas (optional
  conventions may grow later)

## Placement

Put a **Declarations** section early in the README (or project home),
before deep install or architecture detail.

Recommended shape:

1. A compact table of `topic` → `stance`
2. Optional prose under the table (or short subsections) for nuance
3. Links out to longer docs (`contributing/`, `design/`, `SECURITY.md`)
   when a stance needs explanation

Example table:

| topic              | stance      |
|--------------------|-------------|
| lifecycle phase    | usable      |
| maintenance intent | best-effort |
| authorship         | ai-authored |
| contributions      | limited     |

Stances should be stable enough to skim. Prefer vocabulary from this RFC
when it fits; free text is fine when it does not. Use prose under the
table when a single stance word is not enough.

Projects that already use a "Status" blurb can keep it; declarations are
the structured companion, not a ban on prose.

## Topics

All topics are optional. Declare the rows that help readers; skip the
rest. Suggested vocabularies for each topic follow.

| topic              | question it answers                                 |
|--------------------|-----------------------------------------------------|
| lifecycle phase    | Where is this in its life as a product or artifact? |
| maintenance intent | How will stewards treat defects, changes, and time? |
| authorship         | How was the artifact primarily produced?            |
| contributions      | What outside participation is wanted?               |
| support            | Is help offered, and on what terms?                 |

## Lifecycle phase

Lifecycle phase describes **what the artifact is right now**, not how
hard the author is working. A project can be actively coded and still
`prototype`; it can be untouched for months and still `mature` if the
scope is done and the software is fit for its claims.

Choose **one** primary phase. If two seem true, pick the one a cautious
consumer should assume, and explain dual reality in prose under the table
(for example "usable core; experimental plugins").

### Suggested vocabulary

| stance       | meaning                                                                                                       |
|--------------|---------------------------------------------------------------------------------------------------------------|
| `stub`       | Name, intent, or skeleton only. Not for use.                                                                  |
| `prototype`  | Exploring shape or feasibility. APIs and storage may vanish. Success is learning, not adoption.               |
| `incubating` | Serious direction chosen; still forming scope, packaging, and guarantees. Early adopters should expect churn. |
| `usable`     | Can be used for real work with caveats. Docs, UX, or edge behavior may be rough; core claims should hold.     |
| `mature`     | Fit for the stated purpose with intentional scope. Changes are deliberate; compatibility is considered.       |
| `deprecated` | Discouraged for new use. May still run; migration path should be stated when known.                           |
| `superseded` | Replaced by a named successor. Prefer the successor for new work.                                             |
| `retired`    | End of life. No further care expected; archive or remove when appropriate.                                    |
| `archival`   | Preserved for reference or safekeeping (including mirrors of others' work). Not a living product line.        |

## Maintenance intent

Maintenance intent describes **how stewards expect to treat the project
over time**: defects, dependency drift, feature growth, review bandwidth,
and communication. It is independent of lifecycle phase. Examples:

- `mature` + `as-is` (done, will not chase ecosystem churn)
- `usable` + `active` (daily driver under care)
- `incubating` + `best-effort` (moving when time allows)
- `usable` + `ai-maintained` (humans set goals; agents do routine care)

Choose the intent that matches likely behavior over the next foreseeable
period, not aspirational staffing.

### Suggested vocabulary

| stance               | meaning                                                                                                                                                                                 |
|----------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `active`             | Stewards regularly develop, review, and respond. Issues and dependency care are in the normal loop.                                                                                     |
| `best-effort`        | Care happens when time and interest allow. No response-time promise. Useful patches may land slowly or not at all.                                                                      |
| `minimal`            | Aim is to keep the project alive: critical breaks, security when practical, little feature work.                                                                                        |
| `security-only`      | Only security-relevant fixes are in scope. No general bug or feature work.                                                                                                              |
| `ai-maintained`      | Routine maintenance is expected to be performed largely by AI agents (dependency bumps, refactors, fix attempts, doc sync) under human or policy oversight. Does not imply a human SLA. |
| `as-is`              | No commitment to maintain. Take it or fork it. May still accept cosmetic or trivial fixes at maintainer whim.                                                                           |
| `seeking-maintainer` | Current stewards want someone else to take ownership. Say how to apply or what "taking it" means.                                                                                       |
| `handed-off`         | Stewardship has already transferred. Say where responsibility lives now.                                                                                                                |
| `unmaintained`       | Explicit signal that nobody is caring for it. Stronger and clearer than silence.                                                                                                        |

### Notes

- **best-effort vs minimal** — `best-effort` is opportunistic and may
  include features; `minimal` is deliberately narrow.
- **as-is vs unmaintained** — `as-is` is a usage contract ("no promises");
  `unmaintained` is a stewardship fact ("no steward"). They often travel
  together; either alone is still useful.
- **seeking-maintainer vs handed-off** — `seeking-maintainer` is an open
  call; `handed-off` means the transfer already happened.
- **ai-maintained vs active** — `ai-maintained` centers agent labor for
  upkeep; humans may still set direction, merge, or veto. Pair with an
  authorship row when useful, and use prose if oversight is unusual.
- **security-only** — Still state how to report vulnerabilities if you
  can honor that path; otherwise prefer `as-is` or `unmaintained`.
- Maintenance intent is not a SLA. If you need SLAs, write them
  elsewhere and link them; keep the table skim-sized.

### Pairing with lifecycle (informative)

| lifecycle              | common intents                                                    |
|------------------------|-------------------------------------------------------------------|
| stub, prototype        | best-effort, as-is, ai-maintained                                 |
| incubating             | active, best-effort, ai-maintained                                |
| usable, mature         | active, best-effort, minimal, security-only, ai-maintained, as-is |
| deprecated, superseded | minimal, security-only, as-is, seeking-maintainer                 |
| retired, archival      | as-is, unmaintained, handed-off                                   |

These pairings are typical, not rules.

## Authorship

How the artifact was primarily produced. This is about **process
honesty**, not a ban or badge of purity.

| stance         | meaning                                                                                                                                                                                    |
|----------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `hand-written` | Primarily authored by people directly editing the implementation.                                                                                                                          |
| `ai-assisted`  | People direct the work; models help with substantial drafting or editing. Humans still read and own the result.                                                                            |
| `ai-authored`  | Implementation is largely produced by agents/models from specs, prompts, or tests. Maintainers may not be fluent in every line or even the implementation language.                        |
| `vibe-coded`   | Produced mainly by loose, conversational prompting with little durable spec, design doc, or systematic review. Higher variance; treat structure and edge behavior as suspect until proven. |
| `mixed`        | No single mode dominates; explain in prose under the table.                                                                                                                                |

**Why declare this.** Consumers and contributors calibrate review depth,
bug expectations, and whether "I don't know this language" is a known
operating mode versus an accident. Example: a Go tool built largely by
agents from design docs by an author who does not read Go should say
`ai-authored`—quality may be high where tests and specs are strong, and
odd where agents improvised.

Authorship is not a substitute for license or copyright identity.

## Contributions

| stance            | meaning                                                                                                    |
|-------------------|------------------------------------------------------------------------------------------------------------|
| `welcome`         | Patches and issues are encouraged under documented norms.                                                  |
| `limited`         | Small, scoped contributions may be considered; large redesigns or drive-by scope changes usually will not. |
| `issues-only`     | Reports and discussion yes; code from outsiders unlikely to be merged.                                     |
| `closed`          | Not accepting outside contribution; consumers may still fork under the license.                            |
| `maintainer-only` | Only listed maintainers push; external ideas via issue or fork.                                            |

Point to `CONTRIBUTING` (or `contributing/`) when `welcome` or
`limited`. Silence often reads as `welcome` on public forges; say
`closed` or `limited` when that default would waste people's time.

## Support

| stance       | meaning                              |
|--------------|--------------------------------------|
| `community`  | Best-effort help in listed channels. |
| `none`       | No support channel is offered.       |
| `commercial` | Paid support exists; link it.        |

## Writing good declarations

1. **Be slightly pessimistic.** A cautious consumer's reading is the
   useful one.
2. **Prefer update over nostalgia.** When the project stops moving or
   ships, change the table in the same change set when practical.
3. **Don't contradict the repo.** An `active` intent with years of
   silence should become `unmaintained` or `as-is` (and the lifecycle
   row should stay honest about what the artifact still is).
4. **Separate wish from fact.** Roadmap belongs in design docs; phase
   and intent describe the present.
5. **Use prose for nuance, vocabulary for skimming.** The table is the
   skim API; paragraphs under it carry exceptions and context.
6. **Link longer policy.** Contribution legalities, DCO/CLA, security
   contacts, and codes of conduct stay in their usual files.

## README convention

Minimal pattern:

```markdown
## Declarations

| topic              | stance      |
|--------------------|-------------|
| lifecycle phase    | usable      |
| maintenance intent | best-effort |
| authorship         | ai-authored |
| contributions      | limited     |

Vertical slice is usable for the documented commands. Maintenance is
opportunistic. Implementation is largely agent-written from design docs;
treat review and language-idiom expectations accordingly.
```

## Relationship to other signals

| signal                       | role vs declarations                                                            |
|------------------------------|---------------------------------------------------------------------------------|
| Semantic version / changelog | What changed; not steward intent                                                |
| LICENSE                      | Legal use; not maturity or care                                                 |
| CI / coverage badges         | Engineering hygiene snapshots                                                   |
| Commit dates                 | Weak proxy for maintenance; declarations should override inference when present |
| RFC 2 / 21 style commits     | History quality; orthogonal                                                     |

## Adoption

Adopting this RFC means:

1. Adding a Declarations table (or equivalent labeled key/value list) to
   the project front page
2. Declaring the topics that matter for your readers (any subset of the
   vocabulary above, plus free-text rows when needed)
3. Using vocabulary from this RFC when it fits, or clear free text when
   it does not
4. Updating stances when they stop being true

## Open questions

- Whether a tiny machine-readable companion (e.g. front matter,
  `_project-meta.toml` fields) should be recommended later
- Whether forges or agent tooling will want a fixed key set; this RFC
  stays document-first until then
