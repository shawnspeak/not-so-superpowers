#!/usr/bin/env bash
# Install the skill stack for Codex CLI, which discovers skills from
# .agents/skills/ (project) or ~/.agents/skills/ (user). Copies by default;
# --link symlinks instead so a `git pull` here updates every install.
#
# Usage: ./install-codex.sh [--link] [target-dir]
#   target-dir defaults to ~/.agents/skills
set -eu

# Resolve the repository even when this script is invoked through a symlink.
src="$0"
while [ -L "$src" ]; do
  dir="$(cd "$(dirname "$src")" && pwd)"
  src="$(readlink "$src")"
  case "$src" in /*) ;; *) src="$dir/$src" ;; esac
done
ROOT="$(cd "$(dirname "$src")" && pwd -P)"
LINK=0
TARGET="$HOME/.agents/skills"

for arg in "$@"; do
  case "$arg" in
    --link) LINK=1 ;;
    -h|--help) sed -n '2,7p' "$src"; exit 0 ;;
    -*) echo "unknown option: $arg" >&2; exit 2 ;;
    *) TARGET="$arg" ;;
  esac
done

mkdir -p "$TARGET"
TARGET="$(cd "$TARGET" && pwd -P)"
case "$TARGET/" in
  "$ROOT/skills/"*)
    echo "refusing to install into this repository's own skills/: $TARGET" >&2
    exit 2 ;;
esac

# Where a symlink points, as a physical path, so links made through a
# symlinked or relative path still compare equal to this repository.
link_target() {
  t="$(readlink "$1")"
  case "$t" in /*) ;; *) t="$(dirname "$1")/$t" ;; esac
  d="$(cd "$(dirname "$t")" 2>/dev/null && pwd -P)" || { printf '%s\n' "$t"; return; }
  printf '%s/%s\n' "$d" "$(basename "$t")"
}

# True when $1/SKILL.md is byte-identical to a version this repository
# committed, so a user's own skill that shares a removed name is left alone.
shipped_copy() {
  [ -f "$1/SKILL.md" ] || return 1
  blob="$(git hash-object "$1/SKILL.md" 2>/dev/null)" || return 1
  git -C "$ROOT" log --all --no-abbrev --format= --raw \
    -- "skills/$(basename "$1")/SKILL.md" 2>/dev/null | grep -q " $blob "
}

# Prune what an earlier install left behind: symlinks into this repo's
# skills/ (dangling once a skill is removed upstream) and unmodified copies
# of skills this stack no longer ships.
REMOVED_SKILLS="mapping-work"
for entry in "$TARGET"/*; do
  [ -e "$entry" ] || [ -L "$entry" ] || continue
  name="$(basename "$entry")"
  stale=0
  if [ -L "$entry" ]; then
    case "$(link_target "$entry")" in "$ROOT/skills/"*) stale=1 ;; esac
  else
    case " $REMOVED_SKILLS " in
      *" $name "*)
        if shipped_copy "$entry"; then
          stale=1
        else
          echo "left $entry: not an unmodified copy from this repository"
        fi ;;
    esac
  fi
  if [ "$stale" -eq 1 ]; then
    rm -rf "$entry"
    [ -d "$ROOT/skills/$name" ] || echo "removed stale $entry"
  fi
done

count=0
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
  count=$((count + 1))
done

echo "Done: $count skills installed in $TARGET"
