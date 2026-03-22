#!/bin/bash
# Reject commits that modify local artifacts without canonical source update.

set -euo pipefail

CANONICAL_REL="src/gotcha.md"
ARTIFACT_PREFIX="dist/rules/"

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -z "$repo_root" ]]; then
  exit 0
fi

mapfile -t staged < <(git diff --cached --name-only --diff-filter=ACMR)
if [[ "${#staged[@]}" -eq 0 ]]; then
  exit 0
fi

canonical_staged=0
artifact_hits=()

for rel in "${staged[@]}"; do
  if [[ "$rel" == "$CANONICAL_REL" ]]; then
    canonical_staged=1
  fi

  if [[ "$rel" == "$ARTIFACT_PREFIX"* ]]; then
    artifact_hits+=("$rel")
  fi
done

if [[ "${#artifact_hits[@]}" -eq 0 ]]; then
  exit 0
fi

if [[ "$canonical_staged" -ne 1 ]]; then
  echo "❌ Rule guard: generated artifact edits detected without canonical update."
  printf "Artifact files staged:\n"
  printf "  - %s\n" "${artifact_hits[@]}"
  echo "Canonical required:"
  echo "  - $CANONICAL_REL"
  echo "Use: ./scripts/run-governance.sh"
  exit 1
fi

echo "✅ Rule guard: canonical + artifact edit detected."
