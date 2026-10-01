---
name: pr-split-sample-repairs-from-rules
category: git-workflow
description: Use when adding sample repairs and rules: file separate PRs.
---

When both fixing existing sample files (mechanical repairs, verified against source) and adding new validation rules to prevent similar issues, file two separate PRs.

Repairs PR: mechanical fixes with source verification. Reviewers spot-check that changes match the source file at the cited commit. Easy to evaluate, high confidence per fix.

Validation PR: new checks and rules. Reviewers evaluate the rule itself separately from the examples it catches. Allows discussion of whether the constraint is correct and appropriate.

Benefits: reviewers focus on different concerns; changes can land independently if needed; if a validation rule proves too strict, reverting it doesn't require reverting the repairs.