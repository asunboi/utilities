# LaminDB: Not Worth Adopting for Our Use Case

**Date:** 2026-04-13
**Category:** tooling
**Status:** deprecated

## Decision

Do not adopt LaminDB for perturbench or STORM workflows. The adoption cost exceeds the benefit for a single researcher in a lab where you don't control others' workflows and most scripts aren't standardized.

## Reasoning

- **Lineage tracking requires full ecosystem adoption.** LaminDB only tracks what's explicitly registered via `artifact.save()`. Data received from HuggingFace, collaborators, or anyone not using LaminDB has no provenance — it's just an opaque blob with manually-attached metadata. The lineage graph is only valuable when every step in the pipeline goes through LaminDB.
- **Bottom-up adoption is unrealistic without lab lead mandate.** LaminDB is infrastructure, not a tool. Tools get adopted bottom-up because they help the individual. Infrastructure requires top-down mandate because the value is collective. Getting every collaborator to add `ln.track()` / `artifact.save()` / `ln.finish()` to their scripts won't happen organically.
- **STORM + Hydra already cover the core tracking needs.** Config hashing + Hydra `.hydra/` snapshots + per-seed directory isolation + structured output directories provide reproducibility and organization without an additional dependency. The existing `compute_run_hash()` + SHA-256 idempotency mechanism does what LaminDB's content hashing would do.
- **Early-stage community, rapidly changing API.** ~241 GitHub stars, ~3-4 core developers, no peer-reviewed paper, no independent case studies despite claiming Pfizer/Broad/Stanford logos. API has breaking changes across versions (Curator API rewritten, Lightning integration rewritten 3x). Risky dependency to pin on an HPC cluster.
- **Multi-user features require paid LaminHub ($480/month).** Access control, GUI catalog, and collaboration features are behind the paywall. Local SQLite is single-user only.

## Details

**What LaminDB does well (in the right context):**
- Native AnnData/h5ad support
- Biological ontology integration via bionty (CL, UBERON, EFO)
- Cross-experiment querying ("all results where dataset=X AND model=Y")
- Content-hash-based deduplication

**When it would be worth reconsidering:**
- Lab grows to 3+ people sharing outputs AND a lab lead mandates adoption
- Curating data for a public resource with ontology requirements (e.g., consortium atlas)
- Pipeline chain extends significantly upstream (FASTQ -> counts -> AnnData -> STORM -> training) and end-to-end provenance becomes critical

**The realistic alternative for cross-experiment querying:**
A post-hoc indexing script that walks `studies/` directories, parses Hydra configs and evaluation CSVs that already exist, and populates a lightweight SQLite database. Zero behavior change from anyone else. `sqlite3` + `pandas` + a manual trigger is sufficient.

**Overhead summary (if adopted):**
- Minimal: ~3 lines per script (`import ln`, `ln.track()`, `ln.finish()`) + `artifact.save()` per output
- Real cost: maintaining the instance/schema, agreeing on naming conventions, debugging registration failures on HPC, keeping up with API changes
- STORM's plugin `emit()` methods and `save.py` would need modification to weave in `artifact.save()` calls
