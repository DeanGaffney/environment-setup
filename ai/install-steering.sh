#!/usr/bin/env bash
# Install shared AI steering into Cursor rules and Kiro steering.
# Edit ai/steering/*.md (frontmatter may include keys for both tools).
# This script strips the wrong keys per tool, then writes the files directly.
# Re-running overwrites previous installs completely.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SRC="$ROOT/steering"

mkdir -p "$HOME/.cursor/rules" "$HOME/.kiro/steering"

for f in "$SRC"/*.md; do
  name="$(basename "$f" .md)"

  # Remove any existing file/symlink first, so a stale symlink at the
  # destination doesn't cause the writes below to land on its target instead.
  rm -f "$HOME/.cursor/rules/${name}.mdc" "$HOME/.kiro/steering/${name}.md"

  # Cursor: drop Kiro-only keys
  sed -e '/^inclusion:/d' -e '/^fileMatchPattern:/d' "$f" >"$HOME/.cursor/rules/${name}.mdc"

  # Kiro: drop Cursor-only keys
  sed -e '/^description:/d' -e '/^alwaysApply:/d' -e '/^globs:/d' "$f" >"$HOME/.kiro/steering/${name}.md"

  echo "Installed $name"
done
