# TODO

## Code quality enforcement (humans + agents)

Goal: enforce linting, formatting, and conventional commits for both humans and
agents — hard enforcement via tooling, soft enforcement via documented conventions.
Prototyped in `perturbench/src/storm`.

- **Layer 1 — pre-commit hooks (human-facing, automated)**
  - ruff lint + format already wired in storm via `.pre-commit-config.yaml`
  - add a `commit-msg` hook for conventional commits — use `commitizen` (Python,
    fits conda envs) or `conventional-pre-commit` (lightweight pre-commit hook)
  - "soft" vs "hard" is just whether the hook blocks or warns; humans can always
    bypass with `--no-verify` when they have a reason
  - add `.pre-commit-config.yaml` with both ruff and conventional commits to the
    foundry template so new projects start with this

- **Layer 2 — `AGENTS.md` + `.agent/CONVENTIONS.md` (agent-facing, advisory)**
  - agents read these files at session start and treat them as standing instructions
  - `AGENTS.md` → operational rules: "run ruff before committing", "use conventional
    commit format", "never use `git add -A`"
  - `.agent/CONVENTIONS.md` → style conventions: naming, file structure, preferred
    patterns
  - populate both in the foundry template with sensible defaults so agents are
    guided from project creation

- **Layer 3 — Claude Code hooks in `.claude/settings.json` (agent-facing, automated)**
  - Claude Code supports hooks that run shell commands on tool events (after file
    edit, before bash, etc.)
  - wire ruff to run automatically after every file write in agent sessions
  - optionally validate commit message format before it's submitted
  - commit `.claude/settings.json` to the repo so the hooks are shared across
    everyone using Claude Code on this project
  - add a template `.claude/settings.json` to foundry

- **Layer 4 — foundry template propagation**
  - all of the above should live in the foundry template so new projects have it
    from the start
  - use `sync_template.sh` to backfill existing projects that predate these additions
  - files to add to template:
    - `.pre-commit-config.yaml` (ruff + conventional commits)
    - `.agent/CONVENTIONS.md` (populated, not empty)
    - `.claude/settings.json` (ruff post-edit hook)
