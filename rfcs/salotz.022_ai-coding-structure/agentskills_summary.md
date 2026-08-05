# Agent Skills Summary (from agentskills.io)

This document provides a self-contained summary of the [Agent Skills](https://agentskills.io) open format. It enables AI agents to discover, load, activate, and execute specialized capabilities via portable, version-controlled skill directories **without needing to visit the website**.

Agent Skills package procedural knowledge, domain expertise, workflows, and resources (scripts, references, templates) so agents can use them on-demand with minimal context overhead.

**Official resources**:
- Home/Overview: https://agentskills.io/home
- Specification: https://agentskills.io/specification
- Quickstart: https://agentskills.io/skill-creation/quickstart
- Best practices, evaluation, scripts, client integration: see `/llms.txt` or the site.

## Core Concept: Progressive Disclosure

Agents load skills in three stages to keep context small:

1. **Discovery / Catalog** (~50-100 tokens per skill): At session start, load only `name` + `description` from every available skill. This tells the agent *when* a skill might apply.
2. **Activation / Instructions** (< 5000 tokens recommended): When a task matches a skill's description, load the full `SKILL.md` body.
3. **Execution / Resources**: Load scripts, references, or assets **only** when the instructions explicitly reference them (via relative paths).

**Rule of thumb**: Keep the main `SKILL.md` under ~500 lines. Move detailed material to separate files and tell the agent exactly when to load them (e.g., "Read `references/api-errors.md` only on non-200 responses").

## Skill Directory Structure

A skill is any directory containing a file named exactly `SKILL.md`:

```
my-skill/
├── SKILL.md          # Required: YAML frontmatter + Markdown instructions
├── scripts/          # Optional: executable scripts (self-contained where possible)
├── references/       # Optional: detailed docs, forms, domain files (e.g. REFERENCE.md)
├── assets/           # Optional: templates, images, data files, schemas
└── ...               # Any supporting files
```

**Common discovery locations** (agents should scan these):
- Project: `<project>/.agents/skills/<skill-name>/` (cross-client convention)
- Project: `<project>/.<client>/skills/<skill-name>/` (client-specific)
- User: `~/.agents/skills/<skill-name>/`
- User: `~/.<client>/skills/<skill-name>/`

Additional locations may include ancestor dirs up to git root, XDG paths, or `.claude/skills/` for compatibility. Agents list skills from all scanned scopes.

Within each skills dir, discover subdirectories that contain a `SKILL.md`.

## `SKILL.md` Format

YAML frontmatter followed by Markdown body. No other restrictions on the body—write whatever helps the agent succeed.

### Frontmatter Fields

| Field           | Required | Constraints / Notes |
|-----------------|----------|---------------------|
| `name`          | Yes      | 1-64 chars. Lowercase letters, digits, hyphens only. Must not start/end with hyphen or contain `--`. **Must exactly match the parent directory name**. |
| `description`   | Yes      | 1-1024 chars. Non-empty. Must describe **what** the skill does **and when** to use it. Use imperative phrasing ("Use when...", "Activate for..."). Include specific keywords. Be explicit/pushy about contexts (even if user doesn't name the domain). |
| `license`       | No       | Short name or reference to bundled LICENSE file. |
| `compatibility` | No       | Max 500 chars. Environment requirements (e.g. "Requires Python 3.14+ and uv", "Designed for Claude Code", "Needs git, docker, internet"). Most skills omit this. |
| `metadata`      | No       | Map of string→string for extra info (author, version, etc.). Use reasonably unique keys. |
| `allowed-tools` | No       | Experimental. Space-separated list of pre-approved tools (e.g. `Bash(git:*) Read`). Support varies by client. |

**Minimal example**:
```markdown
---
name: roll-dice
description: Roll dice using a random number generator. Use when asked to roll a die (d6, d20, etc.), roll dice, or generate a random dice roll.
---

To roll a die, run:
```bash
echo $((RANDOM % <sides> + 1))
```
Replace `<sides>` with the number of sides.
```

**Good description traits** (for reliable activation):
- Imperative ("Use this when the user asks to...").
- Focus on user intent, not internals.
- List trigger contexts explicitly.
- Concise but specific enough to avoid false positives/negatives.

## How Agents Use Skills (Lifecycle)

1. **Startup**: Scan locations → read every `SKILL.md` frontmatter → build catalog of (name, description).
2. **Task processing**: Match user intent / prompt against descriptions. Decide which (if any) to activate.
3. **Activation**: Read the full `SKILL.md` (frontmatter + body) into context.
4. **Execution**: Follow body instructions. Run commands/scripts with relative paths (resolved from skill root). Load referenced files only as needed.
5. **Observation**: Many clients expose which skills were activated (tool calls, logs). Use for debugging.

**Relative paths**: Always use paths relative to the skill directory root (e.g. `scripts/foo.py`, `references/REFERENCE.md`). The agent runs commands from the skill root context.

## Scripts (`scripts/`)

- One-off commands: `uvx`, `npx`, `bunx`, `deno run`, `go run`, `pipx run` (pin versions).
- Bundled scripts: Make them self-contained.
  - Python: PEP 723 inline metadata (`# /// script` block with `dependencies`).
  - Deno/Bun: Inline `npm:` / direct version imports.
  - Ruby: `bundler/inline`.
- Run via: `uv run scripts/xxx.py`, `bash scripts/xxx.sh`, `python3 scripts/xxx.py`, etc.

**Design scripts for agents** (critical):
- Never use interactive prompts, TTY, or confirmation menus (will hang).
- Provide `--help` with usage, flags, and examples.
- Write clear error messages (what failed, expected values, suggested fixes).
- Prefer structured output (JSON/CSV/TSV on stdout) over free text.
- Diagnostics → stderr; data → stdout.
- Support idempotency, dry-run (`--dry-run`), explicit flags for destructive ops.
- Use meaningful exit codes + document them.
- Keep output bounded or paginatable (agents may truncate long output).
- Document prerequisites in `SKILL.md` or `compatibility`.

List available scripts in `SKILL.md` and give exact invocation examples.

## References & Assets

- `references/`: `REFERENCE.md`, `FORMS.md`, domain files. Instruct agents **when** to read them.
- `assets/`: Templates, diagrams, lookup tables, schemas.
- Always reference with relative paths and explicit load conditions.

## Validation

Use the official `skills-ref` tool:
```bash
skills-ref validate ./my-skill
```
It validates frontmatter, naming conventions, etc.

## Best Practices (for Creating / Evaluating Skills)

- Ground skills in **real** project expertise, runbooks, actual tasks, code history, failures—not generic LLM knowledge.
- Extract patterns from real executions + corrections.
- Iterate: Run → review traces/outputs → revise.
- Spend context wisely: Only include what the agent would get wrong without the instruction. Omit known basics.
- Scope coherently (like a good function): not too narrow (many skills load), not too broad.
- Use progressive disclosure for large content.
- Calibrate prescriptiveness: freedom + "why" for flexible tasks; exact steps for fragile ones.
- Provide defaults (not menus of options).
- Favor reusable procedures over one-off answers.
- High-value patterns:
  - **Gotchas** section (environment-specific facts that defy assumptions).
  - Output templates (concrete Markdown/JSON structures).
  - Explicit checklists for multi-step workflows.
  - Validation loops ("do X, run validator, fix, repeat").
  - Plan-validate-execute (especially for batch/destructive work).
- Bundle repeated helper logic into tested scripts.
- For descriptions: test with realistic "should trigger" and "near-miss should-not" queries (multiple runs, train/validation split to avoid overfitting).

## Evaluation & Iteration (for Skill Quality)

- Test cases: prompt + expected_output + optional input files. Store in `evals/evals.json`.
- Run each case **with** and **without** the skill (or vs. prior version) in clean workspaces.
- Capture timing/tokens.
- Add assertions (verifiable statements) after first runs.
- Grade with evidence (PASS/FAIL + quotes).
- Aggregate pass rates, deltas, stddev.
- Human review for qualities assertions miss.
- Iterate in `iteration-N/` dirs until satisfied or no more gains.

## Client / Agent Integration Notes

- Support at least project + user scopes and the `.agents/skills/` convention.
- Implement the three-tier loading strictly.
- Provide observability (which skills were considered/activated, tool use logs).
- For file-reading models: they can read `SKILL.md` directly.
- Otherwise expose a `Skill` tool or inject content programmatically.
- Handle nondeterminism (run evals multiple times).
- See full client guide for adding support: https://agentskills.io/client-implementation/adding-skills-support

## Quickstart Example (Dice Roller)

See the official quickstart for a minimal working skill. The key is a precise `description` that matches user intent, plus clear instructions the agent can follow (e.g., shell commands with placeholders).

## Summary for Agents Working on Projects

When you see a project using this RFC (AI Coding Repository Structures):
- Look for skills under `.agents/skills/`, `contributing/`, or similar (per project conventions).
- Treat `contributing/*.md` (or `process_*.md`, `role_*.md`) as candidates for exposure as Agent Skills.
- Use the progressive disclosure model when loading project context.
- Prefer loading only metadata first, then full instructions on demand.
- When authoring or improving skills/processes, follow the best practices above for reliability.

This format makes specialized knowledge portable across many agents (VS Code + Copilot, Claude Code, Cursor, Goose, OpenHands, Gemini CLI, etc.—see client showcase for the growing list).

**Keep this summary updated** by re-fetching key pages from agentskills.io when the standard evolves. The core ideas (progressive disclosure, strict name/desc constraints, self-contained scripts, gotchas + validation) are stable and agent-critical.