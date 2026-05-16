#!/usr/bin/env bash
# check-vendored-links.sh — validates that every relative Markdown
# link in a consumer's tree resolves after the canonical day-one
# setup: literal copy of starter/, then scripts/assemble.sh against
# the shared library. Catches link drift between starter scaffolding,
# vendored shared content, and the assemble step.
#
# Runs offline against a local fixture upstream — no network access,
# no real CalVer tag required.
#
# Usage: scripts/check-vendored-links.sh
#
# Exit codes:
#   0 — all relative links resolve
#   1 — one or more broken links (paths reported)
#   2 — invocation error

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
STARTER_DIR="$REPO_ROOT/starter"
ASSEMBLE="$REPO_ROOT/scripts/assemble.sh"

if [[ ! -d "$STARTER_DIR" ]]; then
  echo "$(basename "$0"): starter/ not found at $STARTER_DIR" >&2
  exit 2
fi
if [[ ! -x "$ASSEMBLE" ]]; then
  echo "$(basename "$0"): assemble.sh not found or not executable at $ASSEMBLE" >&2
  exit 2
fi

FIXTURE_VERSION="fixture-$$-$(date +%s)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# 1. Stand up a local fixture upstream where assemble.sh expects it.
#    assemble.sh uses $TMPDIR/shared-agent-rules-<VERSION>/ as the
#    worktree, skips its clone if the directory exists, and only
#    reads files under library/. Snapshot the current working-tree
#    library/ into a fresh git repo so uncommitted edits are
#    validated alongside committed ones.
export TMPDIR="$TMP"
WORKTREE="$TMP/shared-agent-rules-${FIXTURE_VERSION}"
mkdir -p "$WORKTREE"
cp -R "$REPO_ROOT/library" "$WORKTREE/"
git -C "$WORKTREE" init --quiet
git -C "$WORKTREE" add -A
git -C "$WORKTREE" \
  -c user.email=fixture@example.invalid \
  -c user.name=fixture \
  commit --quiet -m fixture
git -C "$WORKTREE" tag "$FIXTURE_VERSION" HEAD

# 2. Materialize a consumer tree from a literal starter/ copy.
CONSUMER="$TMP/consumer"
mkdir -p "$CONSUMER/docs/agents"
cp -r "$STARTER_DIR/." "$CONSUMER/"

# 3. Write the consumer's manifest. The fixture uses the example
#    manifest's defaults — only the uncommented modules are vendored.
#    This matches the day-one consumer experience: copy starter/,
#    run assemble against the example manifest. The assemble step's
#    link-strip pass (see scripts/assemble.sh) handles cross-references
#    to opt-in modules the example manifest skips by default, so
#    "all links resolve" means "the canonical day-one tree is
#    self-consistent."
{
  echo "shared_agent_rules:"
  echo "  source: local/fixture"
  echo "  version: ${FIXTURE_VERSION}"
  echo "spec_root_relpath: ../../../spec"
  echo "overlay_root: docs/agents/local/overlays/"
  echo "modules:"
  awk '
    /^modules:/ { in_modules=1; next }
    /^[a-zA-Z_]+:/ { in_modules=0 }
    in_modules && match($0, /^[[:space:]]*-[[:space:]]+/) {
      sub(/[[:space:]]*#.*$/, "");
      print "  " $0
    }
  ' "$STARTER_DIR/MANIFEST.example.yaml"
} > "$CONSUMER/docs/agents/shared.manifest.yaml"

# 4. Stub the vendored spec/ tree. Only one path is referenced by
#    library modules ({spec_root}/planning/task-plan.md); stub that
#    one. Add entries here if library/ grows new {spec_root} links.
mkdir -p "$CONSUMER/docs/spec/planning"
: > "$CONSUMER/docs/spec/planning/task-plan.md"

# 5. Run assemble against the consumer tree.
( cd "$CONSUMER" && "$ASSEMBLE" ) >/dev/null

# 6. Walk every .md in the assembled consumer tree and resolve links.
broken=0
total=0
while IFS= read -r -d '' md_file; do
  rel_md="${md_file#$CONSUMER/}"
  md_dir="$(dirname "$md_file")"

  while IFS= read -r target; do
    case "$target" in
      http://*|https://*|mailto:*|"#"*) continue ;;
    esac

    target_path="${target%%#*}"
    if [[ -z "$target_path" ]]; then continue; fi

    total=$((total + 1))

    if [[ "$target_path" == /* ]]; then
      resolved="$CONSUMER$target_path"
    else
      resolved="$md_dir/$target_path"
    fi

    if [[ ! -e "$resolved" ]]; then
      broken=$((broken + 1))
      echo "broken: $rel_md -> $target"
    fi
  done < <(
    grep -oE '\[[^]]*\]\([^)]+\)' "$md_file" \
      | sed -E 's/^\[[^]]*\]\(([^)]+)\)$/\1/'
  )
done < <(find "$CONSUMER" -name "*.md" -type f -print0)

if [[ $broken -gt 0 ]]; then
  echo
  echo "$(basename "$0"): $broken/$total link(s) broken after copy + assemble"
  exit 1
fi

echo "$(basename "$0"): $total relative link(s) all resolve"
