#!/usr/bin/env bash
# Structural validation for the skill stack (see docs/specs/*frontier-orchestration*).
# Run from anywhere: paths are resolved relative to this script.
set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS_DIR="$ROOT/skills"
FAIL=0

fail() { echo "FAIL: $*"; FAIL=1; }
pass() { echo "  ok: $*"; }

EXPECTED_SKILLS="brainstorming mapping-work leading-implementation delegating-workstreams reviewing-work"

echo "== Skill presence and frontmatter =="
for skill in $EXPECTED_SKILLS; do
  md="$SKILLS_DIR/$skill/SKILL.md"
  if [ ! -f "$md" ]; then
    fail "$skill: missing SKILL.md"
    continue
  fi

  # Frontmatter: must open with '---' on line 1 and close before line 30.
  if [ "$(sed -n '1p' "$md")" != "---" ]; then
    fail "$skill: SKILL.md does not start with YAML frontmatter"
    continue
  fi
  fm="$(sed -n '2,30p' "$md" | sed '/^---$/q')"

  name="$(printf '%s\n' "$fm" | sed -n 's/^name:[[:space:]]*//p' | head -1)"
  desc="$(printf '%s\n' "$fm" | sed -n 's/^description:[[:space:]]*//p' | head -1)"

  [ "$name" = "$skill" ] || fail "$skill: frontmatter name '$name' does not match directory"
  [ -n "$desc" ] || fail "$skill: missing description"
  # Trigger-focused description: should say when the skill applies.
  case "$desc" in
    *"Use when"*|*"use when"*) : ;;
    *) fail "$skill: description is not trigger-focused (expected 'Use when ...')" ;;
  esac

  pass "$skill: frontmatter valid"
done

echo "== Unresolved placeholders in skills/ =="
if grep -rnE 'TODO|FIXME|TBD|\{\{[^}]*\}\}|XXX' "$SKILLS_DIR" >/dev/null 2>&1; then
  grep -rnE 'TODO|FIXME|TBD|\{\{[^}]*\}\}|XXX' "$SKILLS_DIR"
  fail "unresolved placeholders found in skills/"
else
  pass "no unresolved placeholders"
fi

echo "== Referenced files exist =="
for md in "$SKILLS_DIR"/*/SKILL.md; do
  dir="$(dirname "$md")"
  refs="$(grep -oE 'references/[A-Za-z0-9_-]+\.md' "$md" | sort -u)"
  for ref in $refs; do
    if [ -f "$dir/$ref" ]; then
      pass "$(basename "$dir"): $ref exists"
    else
      fail "$(basename "$dir"): referenced file $ref does not exist"
    fi
  done
done

echo "== Core skills are platform-neutral =="
# Core SKILL.md bodies may name harnesses when pointing at references/, but
# must not require running a harness-specific command.
for md in "$SKILLS_DIR"/*/SKILL.md; do
  skill="$(basename "$(dirname "$md")")"
  if grep -nE '`(codex|claude) ' "$md" >/dev/null 2>&1; then
    grep -nE '`(codex|claude) ' "$md"
    fail "$skill: core skill requires a platform-specific command"
  else
    pass "$skill: no platform-specific command required"
  fi
done

echo "== Skill bodies concise =="
for md in "$SKILLS_DIR"/*/SKILL.md; do
  skill="$(basename "$(dirname "$md")")"
  lines="$(wc -l < "$md" | tr -d ' ')"
  if [ "$lines" -gt 200 ]; then
    fail "$skill: SKILL.md is $lines lines (>200); too long to load selectively"
  else
    pass "$skill: $lines lines"
  fi
done

echo
if [ "$FAIL" -eq 0 ]; then
  echo "Structural validation: PASS"
else
  echo "Structural validation: FAIL"
fi
exit "$FAIL"
