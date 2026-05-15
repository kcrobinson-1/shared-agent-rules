#!/usr/bin/env bash
# check-starter-links.sh — validates that every relative link in
# starter/ resolves after a literal copy. Catches the class of bug
# where a starter file's link assumes a different on-disk layout
# than the day-one copy produces.
#
# Usage: scripts/check-starter-links.sh
#
# Exit codes:
#   0 — all relative links resolve
#   1 — one or more broken links (paths reported)
#   2 — invocation error

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
STARTER_DIR="$REPO_ROOT/starter"

if [[ ! -d "$STARTER_DIR" ]]; then
  echo "check-starter-links.sh: starter/ not found at $STARTER_DIR" >&2
  exit 2
fi

# Copy starter/ to a temp dir mirroring what a consumer's day-one
# `cp -r starter/. <dest>/` produces.
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
cp -r "$STARTER_DIR/." "$TMP/"

broken=0
total=0
while IFS= read -r -d '' md_file; do
  rel_md="${md_file#$TMP/}"
  md_dir="$(dirname "$md_file")"

  # Extract URL portion of [text](url) markdown link patterns.
  while IFS= read -r target; do
    # Skip absolute URLs, mailto, anchors-only.
    case "$target" in
      http://*|https://*|mailto:*|"#"*) continue ;;
    esac

    # Strip anchor fragment if present
    target_path="${target%%#*}"
    if [[ -z "$target_path" ]]; then continue; fi

    total=$((total + 1))

    # Resolve against md_file's directory (treat absolute-from-root
    # paths as relative to the starter tree root).
    if [[ "$target_path" == /* ]]; then
      resolved="$TMP$target_path"
    else
      resolved="$md_dir/$target_path"
    fi

    if [[ ! -e "$resolved" ]]; then
      broken=$((broken + 1))
      echo "broken: starter/$rel_md -> $target"
    fi
  done < <(
    grep -oE '\[[^]]*\]\([^)]+\)' "$md_file" \
      | sed -E 's/^\[[^]]*\]\(([^)]+)\)$/\1/'
  )
done < <(find "$TMP" -name "*.md" -type f -print0)

if [[ $broken -gt 0 ]]; then
  echo
  echo "check-starter-links.sh: $broken/$total link(s) broken after literal copy"
  exit 1
fi

echo "check-starter-links.sh: $total relative link(s) all resolve"
