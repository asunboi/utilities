# Agent parallel merge strategy

## Problem

Agent instruction files (`AGENTS.md`, `TODO.md`, `CONTEXT.md`) are rewritten
frequently to accumulate context, reduce token usage, and preserve memory across
sessions. When multiple agents work in parallel — each on their own git worktree
or branch — these shared files are edited independently and conflict on merge.

This is a structural problem: the files have different edit patterns (some stable,
some high-churn) but are treated the same by git. The conflict rate in agent-heavy
workflows is well-documented; the AgenticFlict dataset found 27.67% of AI agent PRs
exhibit textual merge conflicts.

The pattern is compounded when agents run in parallel on the same day rather than
sequentially, since there is no natural ordering that would let each agent read the
other's output before writing.

---

## How major projects handle this

**OpenAI Codex** uses hierarchical scoping — 88 AGENTS.md files distributed through
the repo, one per package or crate. Each file is owned by a narrow scope, so fewer
agents ever touch the same file.

**Hugging Face Transformers** uses a symlink pattern — root `AGENTS.md` and
`CLAUDE.md` are stable symlinks pointing to `.ai/AGENTS.md`, with a `.ai/skills/`
subdirectory for modular capabilities. The entry point is stable; the content that
evolves lives in a contained location.

**General consensus** across projects: keep root files under ~60 lines pointing to
modular files. Stable conventions live in files that agents read but don't rewrite.
High-churn content lives in files structured to minimize conflict surface.

---

## Solution implemented in this template

Two complementary mechanisms:

### 1. `merge=union` for append-only files (`.gitattributes`)

Git's built-in `union` merge driver concatenates both sides of a conflict instead
of marking them with `<<<<<<<`/`>>>>>>>` markers. For files that agents only ever
append to (TODO lists, context notes), this is the correct behavior: both agents'
additions are kept, nothing is lost, and no manual resolution is required.

```
.agent/TODO.md merge=union
.agent/CONTEXT.md merge=union
```

The only edge case where union merge produces a wrong result is if two agents edit
the same existing line differently (e.g., both mark the same TODO item as done in
different ways). For append-only files this is rare in practice.

### 2. Per-worktree session files (`.agent/sessions/`)

Each agent writes in-progress notes, observations, and session-specific context to
a file named after its worktree or task:

```
.agent/sessions/
├── chore-qol.md
├── feature-eval.md
└── fix-oom.md
```

Conflicts are structurally impossible: each branch produces a unique filename that
does not exist on any other branch. When branches merge, all session files land in
`sessions/` alongside each other with no conflict. Periodically, a human or agent
consolidates session files into `TODO.md` as a review step.

---

## Resulting file roles

| File | Edit pattern | Conflict strategy |
|---|---|---|
| `.agent/AGENTS.md` | Read-only during sessions | No conflict possible |
| `.agent/CONVENTIONS.md` | Read-only during sessions | No conflict possible |
| `.agent/CONTEXT.md` | Occasionally updated | `merge=union` |
| `.agent/TODO.md` | Agents append suggestions | `merge=union` |
| `.agent/sessions/<name>.md` | Per-agent free-form notes | Unique filename |

The stable files (AGENTS.md, CONVENTIONS.md) should never be rewritten by an agent
during a normal session. If an agent needs to record something, it goes in the
session file or is appended to TODO.md. The stable files are updated only through
deliberate human review.

---

## Backfilling existing projects

For projects that predate this convention, `sync_template.sh` will add
`.gitattributes` and create `.agent/sessions/`. Existing `.agent/TODO.md` and
`.agent/CONTEXT.md` files are not overwritten since `sync_template.sh` does not
overwrite existing paths.

To apply the merge driver to an existing file retroactively, no migration is needed
— `.gitattributes` applies to all future merges regardless of file history.
