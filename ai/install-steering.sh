#!/usr/bin/env bash
# Install shared AI steering into Cursor rules and Kiro steering.
# Edit ai/steering/*.md (frontmatter may include keys for both tools).
# This script strips the wrong keys per tool, then symlinks the results.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SRC="$ROOT/steering"
OUT="$ROOT/.installed"

mkdir -p "$OUT/cursor" "$OUT/kiro" "$HOME/.cursor/rules" "$HOME/.kiro/steering"

for f in "$SRC"/*.md; do
  name="$(basename "$f" .md)"

  # Cursor: drop Kiro-only keys
  sed -e '/^inclusion:/d' -e '/^fileMatchPattern:/d' "$f" >"$OUT/cursor/${name}.mdc"
  ln -sfn "$OUT/cursor/${name}.mdc" "$HOME/.cursor/rules/${name}.mdc"

  # Kiro: drop Cursor-only keys
  sed -e '/^description:/d' -e '/^alwaysApply:/d' -e '/^globs:/d' "$f" >"$OUT/kiro/${name}.md"
  ln -sfn "$OUT/kiro/${name}.md" "$HOME/.kiro/steering/${name}.md"

  echo "Installed $name"
done
