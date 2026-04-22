# Review Prompt

Use this prompt when asking an agent to review a change.

```
Goal: Review [branch, diff, PR, or files].

Focus on:
- Correctness and behavioral regressions.
- Missing tests or verification.
- Data loss, security, privacy, or operational risks.
- Maintainability issues that materially affect future work.

Please lead with findings ordered by severity, include precise file references,
and keep summary comments secondary.
```
