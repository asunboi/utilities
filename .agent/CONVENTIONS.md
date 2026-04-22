# Project Conventions

Use this file for conventions that should guide agents across the repository.

## Repository Hygiene

- Keep template files reusable and project-agnostic.
- Keep project-specific facts in `.agent/CONTEXT.md`, `README.md`, or docs under
  `docs/`, not in generic templates.
- Prefer small, reviewable changes over broad reshaping.
- Preserve empty scaffold directories with `.gitkeep` or a focused README.
- Keep generated outputs, local caches, raw data, and bulky artifacts out of git
  unless there is an explicit reason to version them.

## Documentation

- `README.md` should explain how a human uses the project.
- `TODO.md` should hold active or deferred work.
- `docs/devlog.md` should summarize implementation notes by date.
- `docs/changelog.md` should record user-facing changes.
- `docs/refs/` should hold source notes, reference material, or links that
  inform future work.

## Agent Notes

- Prefer dated Markdown files for durable agent records.
- Keep interaction logs concise: goal, changed files, verification, and follow-up.
- Keep decision records focused on context, options, decision, and consequences.
- Do not duplicate long chat transcripts in the repository.
