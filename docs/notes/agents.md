if my template repository looks like this, and i want to integrate coding agents, such as adding an [AGENTS.md](http://AGENTS.md) at the root level, but I also want them to log changes etc. in files like [interaction.md](http://interaction.md) or a interaction folder with {date}.md files, what's the best way to organize that? when working with coding agents, what other organizational principles, files, etc. should I include / what am I missing?

Great structure to build on. Here's how I'd extend it for coding agent integration:

```
.
├── .github
│   ├── ISSUE_TEMPLATE
│   └── workflows
├── .agent                          ← agent-specific config (hidden, like .github)
│   ├── AGENTS.md                   ← agent instructions & rules
│   ├── CONTEXT.md                  ← persistent project context agents should always read
│   ├── CONVENTIONS.md              ← code style, naming, patterns for this project
│   └── prompts/                    ← reusable prompt templates
│       ├── debug.md
│       └── review.md
├── logs                            ← agent activity (gitignore or commit, your call)
│   ├── interactions/
│   │   ├── 2026-04-03.md
│   │   └── 2026-04-01.md
│   └── decisions/                  ← *why* choices were made (very valuable over time)
│       └── 2026-04-03-auth-approach.md
├── debug
├── documents
├── figures
├── notebooks
├── raw_data
├── src
├── web
├── .gitignore
├── AGENTS.md                       ← root-level symlink or short pointer to .agent/AGENTS.md
├── CHANGELOG.md                    ← human+agent maintained, structured change history
├── README.md
└── TODO.md
```

---

## Key files and what goes in them

**`AGENTS.md`** (root) — the entry point agents look for first. Keep it short and redirect:

```markdown
# Agent Instructions
See `.agent/` for full context. Start with CONTEXT.md, then CONVENTIONS.md.
- Do not modify raw_data/
- Log all sessions to logs/interactions/YYYY-MM-DD.md
- Record architectural decisions in logs/decisions/
```

**`.agent/CONTEXT.md`** — the most important file. Answers: _what is this project, what stage is it in, what are the live constraints?_ Agents lose memory between sessions; this is their memory.

**`.agent/CONVENTIONS.md`** — language versions, formatting rules, preferred libraries, patterns to follow or avoid. Saves enormous amounts of correction back-and-forth.

**`logs/interactions/{date}.md`** — per-session log. A good agent entry looks like:

```markdown
## 2026-04-03 — Refactored data pipeline
- Changed: src/pipeline.py — switched from pandas to polars for perf
- Reason: memory ceiling hit on large raw_data files
- Follow-up needed: update notebooks that import old pipeline
```

**`logs/decisions/`** — separate from interactions. This is your _architecture decision record (ADR)_ folder. When an agent (or you) makes a non-obvious choice, it gets a file. Invaluable when you return to a project months later.

**`CHANGELOG.md`** — structured, cumulative. Unlike interaction logs (verbose, session-based), this is the clean summary history. Agents should append to it on meaningful changes.

---

## What you're missing / worth considering

|Gap|Recommendation|
|---|---|
|No explicit "do not touch" boundaries|Add a `CODEOWNERS`-style note in AGENTS.md listing protected paths (`raw_data/`, `.github/`)|
|No test scaffold|Even empty `tests/` signals to agents where tests belong and that they're expected|
|No environment spec|Add `.python-version`, `requirements.txt` or `pyproject.toml` if not already — agents will guess wrong without it|
|No task tracking agents can update|Consider `TODO.md` → structured format, or add `tasks/` with per-feature files|
|`.gitignore` probably missing `logs/` decision|Decide: do you want agent logs in version control? Interactions = maybe no; decisions = yes|

---

## On `AGENTS.md` placement

Many tools (Claude, Codex, Cursor) look for `AGENTS.md` or `CLAUDE.md` at the **root** specifically. Keep a minimal one there and use it to point into `.agent/` for detail — best of both worlds.