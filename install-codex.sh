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
