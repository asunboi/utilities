# Inline Version History in Docstrings

**Date:** 2026-04-12
**Category:** pattern
**Status:** adopted

## Decision

When a function has gone through multiple implementation approaches (especially
for performance), add a short "Evolution" block to its docstring listing each
version with its commit hash and failure mode.

## Reasoning

- An intern or future contributor seeing a sparse matmul might think "this could
  be simpler with a loop" without knowing the loop was the previous version that
  took 4 hours on production data.
- Git blame shows *what* changed but not *what was tried and rejected*. The
  evolution block captures the rejected approaches in one glanceable block.
- Commit hashes let anyone `git show <hash>` to see the full diff of each version.

## Details

Format — one line per version, in the function's docstring:

```python
def calculate_mean_expression(...):
    """Calculate mean expression per group via sparse matmul.

    Evolution:
      v1 (pre-7e96aba): .toarray() + pandas groupby — OOM at 3.4M cells (136 GB dense)
      v2 (7e96aba): per-group loop with sparse slicing — safe but O(n_groups x n_cells)
      v3 (current): sparse weight-matrix matmul — O(nnz) single pass
    See .agent/CONSTRAINTS.md.
    """
```

Rules:

- **Include the commit hash** for each version — makes it verifiable
- **State the specific failure mode**, not just "was slow" — give memory in GB,
  runtime in hours, or asymptotic complexity
- **Keep it to one line per version** — this is a reference, not a narrative
- **Point to the constraints file** if one exists for this code
- **Only add this for functions with 2+ rewrites** for the same class of issue,
  not every routine change
