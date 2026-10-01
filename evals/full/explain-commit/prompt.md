---
tags: [full]
max_turns: 150
timeout_seconds: 1800
allowed_tools: [Read, Glob, Grep, Skill, Agent, TodoWrite]
runs: 1
description: One end-to-end run against a small real commit, graded on the produced page.
---

Explain commit 601c3d3 in this repository as a self-contained HTML page I can
read to learn what changed and why. When the page is finished, also copy it
to `./page.html` in this directory so I can find it. If the home folder is not
writable here, write the page into this directory instead.
