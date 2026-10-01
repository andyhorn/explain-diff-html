---
type: llm
focus: { source: file, path: page.html }
weight: 2
---

You are judging an HTML page that explains a code change to a reader who wants
to learn from it. Judge the content, not the styling.

PASS when all of these hold:
- The page has four sections in this order: Background, Intuition, Code
  walkthrough, Quiz.
- The code walkthrough follows the path the change takes through the system
  (where it is entered, what it flows through, where its effect lands) rather
  than listing files alphabetically or in diff order.
- Every statement about why the change was made is either tied to something in
  the record (a commit message, a comment, a document) or is clearly marked as
  the author's own inference.
- The page explains and never judges: no verdict on whether the change is
  correct, no findings, no suggested fixes.
- Each `file:line` reference names a full path from the repository root.

FAIL when any of them does not hold. Name which one.
