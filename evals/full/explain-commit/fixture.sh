#!/bin/bash
# Clone the upstream repository into the empty workspace. Commit 601c3d3 is the
# squash merge of its pull request 9, so a single-commit target needs no gh.
set -e
git clone -q https://github.com/malav2110/explain-diff-html.git .
git rev-parse --verify -q 601c3d3 >/dev/null
