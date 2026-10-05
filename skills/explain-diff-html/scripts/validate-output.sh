#!/bin/sh
# The command-line checks from step 7 of SKILL.md. What each check is, and why
# it exists, is in references/validation.md.
#
# Usage: sh validate-output.sh <drafted page> <short commit>
#
# Pass literal paths. A shell variable set in an earlier tool call is gone.
# Exits 0 when every pass/fail check passes, 1 when one fails, 2 on bad usage.

page=$1
sha=$2

if [ -z "$page" ] || [ -z "$sha" ]; then
  echo "usage: sh validate-output.sh <drafted page> <short commit>" >&2
  exit 2
fi

# A directory passes test -s, and step 8's $out is a directory, so require a
# regular file as well.
if [ ! -f "$page" ] || [ ! -s "$page" ]; then
  echo "FAIL: $page is not a non-empty file" >&2
  exit 1
fi

status=0

# Flatten, then strip anchors, so a linked reference still counts as a reference.
refs=$(tr '\n' ' ' < "$page" | sed -E 's#</?a[^>]*>##g; s/  +/ /g' \
  | grep -oE '(<code[^>]*>|class="filename"[^>]*>) *[^<]*\.[A-Za-z]+:[0-9]+' | wc -l | tr -d ' ')
links=$(grep -o 'class="srcref"' "$page" | wc -l | tr -d ' ')
echo "references=$refs linked=$links"

wrong=$(grep -o 'href="[^"]*/blob/[^"]*"' "$page" | grep -v "$sha")
if [ -n "$wrong" ]; then
  echo "FAIL: links that do not name $sha:"
  echo "$wrong"
  status=1
else
  echo "pass: no blob link names another commit"
fi

# GitHub renders Markdown, and the rendered view ignores a line anchor. Match
# every Markdown line link, whatever query it carries, then keep the bare ones.
md='href="[^"]*/blob/[^"]*\.(md|markdown)(\?[^"#]*)?#L[^"]*"'
bare=$(grep -oiE "$md" "$page" | grep -v 'plain=1')
if [ -n "$bare" ]; then
  echo "FAIL: Markdown links with a line anchor and no ?plain=1:"
  echo "$bare"
  status=1
else
  echo "pass: every Markdown line link carries ?plain=1"
fi

# Extract the quiz section by tracking <section> depth, so a nested section
# cannot end it early and id need not be the first attribute.
quiz() {
  tr '\n' ' ' < "$page" | awk '{
    if (!match($0, /<section[^>]*[ \t]id="quiz"[^>]*>/)) exit
    s = substr($0, RSTART + RLENGTH); depth = 1; out = ""
    while (depth > 0 && match(s, /<\/?section[ >]/)) {
      tag = substr(s, RSTART, RLENGTH)
      out = out substr(s, 1, RSTART - 1) " "
      s = substr(s, RSTART + RLENGTH)
      if (tag ~ /^<\//) depth--; else depth++
    }
    if (depth > 0) out = out s
    print out
  }' | sed -E 's/<[^>]+>/ /g; s/  +/ /g'
}

quiz_text=$(quiz)
if [ -z "$(printf '%s' "$quiz_text" | tr -d ' ')" ]; then
  echo "FAIL: no quiz section found, so the quiz checks read nothing"
  status=1
fi

positional=$(printf '%s\n' "$quiz_text" | grep -oEi 'the (first|second|third|last) option|the (former|latter)\b')
if [ -n "$positional" ]; then
  echo "FAIL: quiz text names an option by position:"
  echo "$positional"
  status=1
else
  echo "pass: no quiz option named by position"
fi

echo "advisory: ordinals in the quiz, read each one:"
printf '%s\n' "$quiz_text" | grep -oEi 'the (first|second|third|last|former|latter)\b[^.]{0,40}' || echo "  none"

exit $status
