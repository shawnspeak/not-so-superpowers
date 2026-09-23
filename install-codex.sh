#!/usr/bin/env bash
# Install the skill stack for Codex CLI, which discovers skills from
# .agents/skills/ (project) or ~/.agents/skills/ (user). Copies by default;
# --link symlinks instead so a `git pull` here updates every install.
#
# Usage: ./install-codex.sh [--link] [target-dir]
#   target-dir defaults to ~/.agents/skills
set -eu

ROOT="$(cd "$(dirname "$0")" && pwd)"
LINK=0
TARGET="$HOME/.agents/skills"

for arg in "$@"; do
  case "$arg" in
    --link) LINK=1 ;;
    -h|--help) sed -n '2,7p' "$0"; exit 0 ;;
    *) TARGET="$arg" ;;
  esac
done

mkdir -p "$TARGET"

# Prune what an earlier install left behind: symlinks into this repo's
# skills/ (dangling once a skill is removed upstream) and copies of skills
# this stack no longer ships.
REMOVED_SKILLS="mapping-work"
for entry in "$TARGET"/*; do
  [ -e "$entry" ] || [ -L "$entry" ] || continue
  name="$(basename "$entry")"
  stale=0
  if [ -L "$entry" ]; then
    case "$(readlink "$entry")" in "$ROOT/skills/"*) stale=1 ;; esac
  fi
  case " $REMOVED_SKILLS " in *" $name "*) stale=1 ;; esac
  if [ "$stale" -eq 1 ]; then
    rm -rf "$entry"
    [ -d "$ROOT/skills/$name" ] || echo "removed stale $entry"
  fi
done

for dir in "$ROOT"/skills/*/; do
  skill="$(basename "$dir")"
  dest="$TARGET/$skill"
  rm -rf "$dest"
  if [ "$LINK" -eq 1 ]; then
    ln -s "${dir%/}" "$dest"
    echo "linked $dest -> ${dir%/}"
  else
    cp -R "$dir" "$dest"
    echo "copied $skill -> $dest"
  fi
done

echo "Done: $(ls "$TARGET" | wc -l | tr -d ' ') skills in $TARGET"
