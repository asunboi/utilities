I want to keep a docs/ or documentation/ folder in each of my projects, where i keep a changelog.md, etc. I want to keep track of where my ideas are coming from / what I was thinking when i made each of these changes, for example citing a paper for adding a new metric and the associated commits, or citing a repo for project structure changes or visualizations. what's the best way to organize this?dev

Here's a structure and workflow I'd recommend:

## Folder Layout

```
docs/
├── changelog.md          # high-level user-facing log
├── devlog.md             # your internal reasoning / idea trail
└── references/
    ├── index.md          # master reference list
    ├── papers/           # PDFs or .bib entries
    └── links.md          # repos, blog posts, SO answers, etc.
```

The key insight is splitting **what changed** (changelog) from **why you changed it** (devlog). These serve different audiences — future collaborators vs. future you.

---

## changelog.md

Keep this close to standard [Keep a Changelog](https://keepachangelog.com) format. Clean, terse, user-facing:

```markdown
## [Unreleased]

## [0.4.0] - 2026-03-15
### Added
- Fréchet Inception Distance (FID) metric for generative model eval [REF-003]
- Modular visualization pipeline [REF-007, REF-008]
```

The `[REF-XXX]` tags are the connective tissue — they link to your reference index.

---

## devlog.md

This is your scratchpad for *reasoning*. One entry per meaningful decision, not per commit:

```markdown
## 2026-03-14 — Adding FID metric

**Commits:** `a3f9c12`, `b81e004`
**Refs:** [REF-003]

Been getting poor signal from IS alone on the texture experiments. 
Heusel et al. argue FID is more sensitive to mode collapse, which matches
what I'm seeing in run #47. Tradeoff: needs a large enough sample 
(they recommend n≥2048) to be reliable.

Open question: should FID replace IS or run alongside it?
```

---

## references/index.md

A flat registry that everything else cites:

```markdown
| ID      | Type  | Title / Description                              | Link / Path                        |
|---------|-------|--------------------------------------------------|------------------------------------|
| REF-001 | paper | Attention Is All You Need — Vaswani et al. 2017  | papers/vaswani2017.pdf             |
| REF-002 | repo  | pytorch-lightning project layout                 | https://github.com/...             |
| REF-003 | paper | GANs Trained by a Two Time-Scale Update Rule...  | papers/heusel2017.pdf              |
| REF-007 | repo  | seaborn-style modular viz pattern                | https://github.com/...             |
```

---

## Workflow in Practice

1. **Make your change** — code, structure, whatever.
2. **Commit with a short ref tag** in the message: `feat: add FID metric [REF-003]`
3. **Write one devlog entry** — what you were thinking, what alternatives you ruled out, what's still uncertain.
4. **Update changelog.md** — one line, with the ref tag.

---

## A Few Practical Tips

- **Don't obsess over REF IDs being sequential** — gaps are fine, just keep the index authoritative.
- **Devlog entries age better than comments** — put the *why* here, not in code comments, so it survives refactors.
- **For papers**, store a local PDF + the DOI in the index. Links rot, DOIs don't.
- **For repos**, snapshot the specific commit hash you were looking at, not just the URL.
- If a decision involved a long thread (Slack, email, a GitHub issue), paste the key excerpt into the devlog entry rather than just linking to it.

The whole system is lightweight enough to maintain by hand but structured enough that you can grep your way back to any decision months later.