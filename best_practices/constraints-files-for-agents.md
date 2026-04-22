# Constraints Files for Agents

**Date:** 2026-04-12
**Category:** workflow
**Status:** adopted

## Decision

When code has hard-won performance or correctness constraints that aren't obvious
from reading the code alone, document them in a dedicated `CONSTRAINTS.md` file in
the agent docs directory (`.agent/`). Add a 2-3 line pointer from the main agent
instructions file (CLAUDE.md / AGENTS.md).

## Reasoning

- AI agents don't have memory across sessions. Without explicit constraints, an
  agent will propose the "obvious" approach without knowing it was already tried
  and failed.
- The main CLAUDE.md / AGENTS.md shouldn't be bloated with constraint details —
  it's a reference doc for project structure. A pointer is enough to route agents
  to the constraints when they're touching the relevant code.

## Details

Each constraint entry in `CONSTRAINTS.md` should state:

1. **What not to do** — the specific pattern to avoid
2. **Why** — concrete failure mode with numbers (memory in GB, runtime in hours, data sizes)
3. **What to do instead** — the correct pattern with a pointer to where it lives in code
4. **Commit hash** — where the bad approach was removed, so anyone can `git show` the history

Example entry:

```markdown
## Never densify adata.X

`adata.X.toarray()` on the full expression matrix allocates `n_cells x n_genes x 8` bytes.
At 3.4M x 5000 this is 136 GB — instant OOM.

Introduced in the original implementation, removed in `7e96aba`.
```

The pointer in CLAUDE.md / AGENTS.md:

```markdown
## Performance Constraints

See `.agent/CONSTRAINTS.md` before modifying `_calculate_mean_expression` or
`calculate_logfc_all` in `plugins/perturbench/plugin.py`.
```

### When to write a constraint

- A function has been rewritten 2+ times for the same failure mode
- The "obvious" implementation fails non-obviously at production scale
- Multiple people or agents touch the same code
