# Debug Prompt

Use this prompt when asking an agent to investigate a bug.

```
Goal: Debug [brief symptom].

Context:
- Expected behavior:
- Actual behavior:
- Recent changes:
- Relevant files or commands:

Please:
1. Reproduce or narrow the issue before editing.
2. Identify the likely cause with file references.
3. Make the smallest reasonable fix.
4. Run relevant verification.
5. Summarize changed files, verification, and remaining risk.
```
