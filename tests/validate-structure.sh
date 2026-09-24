#!/usr/bin/env bash
# Structural validation for the skill stack (design intent and conventions: CLAUDE.md).
# Run from anywhere: paths are resolved relative to this script.
set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS_DIR="$ROOT/skills"
FAIL=0

fail() { echo "FAIL: $*"; FAIL=1; }
pass() { echo "  ok: $*"; }

EXPECTED_SKILLS="routing-work brainstorming diagnosing triaging-findings leading-implementation delegating-workstreams reviewing-work"

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
  if ! printf '%s\n' "$fm" | grep -qx -- '---'; then
    fail "$skill: frontmatter is not closed by '---' within 30 lines"
    continue
  fi

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

# A skill directory missing from EXPECTED_SKILLS would ship unvalidated.
for dir in "$SKILLS_DIR"/*/; do
  skill="$(basename "$dir")"
  case " $EXPECTED_SKILLS " in
    *" $skill "*) : ;;
    *) fail "$skill: skill directory is not listed in EXPECTED_SKILLS" ;;
  esac
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

echo "== Cross-skill references resolve =="
# Any backticked bare lowercase token in a SKILL.md body is a skill name;
# it must be one of the expected skills (catches references to removed skills).
# The body is everything after the closing frontmatter delimiter.
XREF_FAIL=0
for md in "$SKILLS_DIR"/*/SKILL.md; do
  skill="$(basename "$(dirname "$md")")"
  for ref in $(awk 'BEGIN{n=0} /^---$/ && n<2 {n++; next} n>=2' "$md" \
      | grep -oE '`[a-z]+(-[a-z]+)*`' | tr -d '`' | sort -u); do
    case " $EXPECTED_SKILLS " in
      *" $ref "*) : ;;
      *) fail "$skill: references unknown skill '$ref'"; XREF_FAIL=1 ;;
    esac
  done
done
[ "$XREF_FAIL" -eq 0 ] && pass "cross-skill references resolve"

echo "== No references to removed skills =="
# install-codex.sh's REMOVED_SKILLS is the one list of removed skills; no
# file under skills/ may still name one, in frontmatter or body.
if ! grep -q '^REMOVED_SKILLS="' "$ROOT/install-codex.sh"; then
  fail "install-codex.sh: REMOVED_SKILLS not found"
fi
REMOVED_SKILLS="$(sed -n 's/^REMOVED_SKILLS="\(.*\)"$/\1/p' "$ROOT/install-codex.sh")"
REMOVED_FAIL=0
for gone in $REMOVED_SKILLS; do
  if grep -rnw -- "$gone" "$SKILLS_DIR" >/dev/null 2>&1; then
    grep -rnw -- "$gone" "$SKILLS_DIR"
    fail "skills/ still names removed skill '$gone'"; REMOVED_FAIL=1
  fi
done
[ "$REMOVED_FAIL" -eq 0 ] && pass "no removed skill is named"

echo "== Core skills are platform-neutral =="
# Core SKILL.md bodies may name harnesses when pointing at references/, but
# must not require running a harness-specific command: no backticked span
# that runs codex or claude, bare or behind a prefix (npx, env assignments).
PLATFORM_CMD='`([^`]*[^A-Za-z0-9_./`-])?(codex|claude)( [^`]*)?`'
for md in "$SKILLS_DIR"/*/SKILL.md; do
  skill="$(basename "$(dirname "$md")")"
  if grep -nE "$PLATFORM_CMD" "$md" >/dev/null 2>&1; then
    grep -nE "$PLATFORM_CMD" "$md"
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
