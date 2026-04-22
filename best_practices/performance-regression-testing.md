# Performance Regression Testing

**Date:** 2026-04-12
**Category:** testing
**Status:** evaluating

## Decision

Use equivalence tests to guard correctness when rewriting function internals, and
`pytest-benchmark` to guard against performance regressions once CI is in place.

## Reasoning

- Unit tests verify correctness but not performance. A function can be rewritten
  to produce identical output while being 100x slower.
- Equivalence tests (comparing old vs new implementation on the same input) catch
  correctness regressions immediately and document the expected behavior.
- Performance benchmarks catch speed regressions, but require a fixture large
  enough to distinguish algorithmic differences and CI to run them automatically.

## Details

### Equivalence tests (adopt now)

When rewriting a function's internals, keep a copy of the old implementation in
the test file and assert the new version produces identical output:

```python
def _old_loop_implementation(adata, cfg):
    """Copy of the original code, frozen for comparison."""
    ...

def test_equivalence(adata, cfg):
    expected = _old_loop_implementation(adata, cfg)
    result = new_implementation(adata, cfg)
    np.testing.assert_allclose(result.values, expected.values, rtol=1e-12)
```

### Performance benchmarks (adopt when CI exists)

`pytest-benchmark` integrates into the existing pytest setup:

```python
def test_mean_expression_perf(adata, cfg, benchmark):
    benchmark(calculate_mean_expression, adata, cfg)
```

Key commands:

- `pytest --benchmark-save=baseline` — save results as JSON after a perf change
- `pytest --benchmark-compare=baseline` — compare current run against saved baseline
- `pytest --benchmark-max-time=5.0` — cap total benchmark duration in CI

### Fixture sizing

The real test dataset (e.g., `devel.h5ad` at 5961 cells) may be too small to
distinguish algorithmic differences — both the O(n^2) and O(n) versions complete
in milliseconds. For meaningful benchmarks, generate a synthetic fixture:

```python
@pytest.fixture(scope="session")
def large_adata():
    import anndata as ad
    X = sp.random(100_000, 1000, density=0.3, format="csr")
    obs = pd.DataFrame({"cell_type": ..., "perturbation": ...})
    return ad.AnnData(X=X, obs=obs)
```

Size it so the fast path takes ~0.5s and the slow path takes ~10s+ — enough to
detect a regression with statistical confidence.

## Action Items

- [x] Equivalence tests for `_calculate_mean_expression` and `calculate_logfc_all`
- [ ] Set up `pytest-benchmark` once CI pipeline exists
- [ ] Create synthetic large fixture for meaningful performance assertions
