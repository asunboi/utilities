# Agent Operating Guide

These instructions apply to coding agents working in this repository. If a more
specific instruction appears in a subdirectory, follow the more specific rule for
that subtree.

## Read Order

Before changing files, read:

1. `AGENTS.md` at the repository root.
2. `.agent/CONTEXT.md` for project-specific context.
3. `.agent/CONVENTIONS.md` for style and workflow preferences.
4. `README.md`, `TODO.md`, `docs/devlog.md`, and `docs/changelog.md` when they
   exist and are relevant to the task.
5. Any referenced source material in `docs/refs/` that is directly relevant.

## Work Rules

- Start by checking the current repository state with `git status --short`.
- Prefer existing project patterns over new abstractions.
- Keep changes scoped to the user's request and avoid unrelated rewrites.
- Do not revert or overwrite user changes unless the user explicitly asks.
- Avoid committing secrets, credentials, large generated outputs, raw data, or
  machine-local paths unless the repository already expects them.
- Run the smallest relevant verification command before handing work back. If no
  practical verification exists, say that clearly.

## Agent Records

Use agent records to preserve information that should survive the current chat,
not to store full transcripts.

- `logs/interactions/YYYY-MM-DD.md`: append concise notes for meaningful agent
  sessions, especially when the run changes behavior, creates follow-up work, or
  uncovers context future agents need.
- `logs/decisions/YYYY-MM-DD-short-slug.md`: record decisions whose reasoning
  matters later, including alternatives considered and the chosen tradeoff.
- `docs/devlog.md`: keep implementation notes that are useful to maintainers.
- `docs/changelog.md`: keep user-facing changes when the project has a release
  or externally visible behavior change.
- `TODO.md`: keep open work that should not be lost between sessions.

Do not log secrets or private credentials. Summarize external content instead of
pasting long copyrighted text.

## Handoff

When finishing a task, report:

- What changed.
- Which files matter most.
- Which verification commands ran and their result.
- Any remaining risks or follow-up work.
