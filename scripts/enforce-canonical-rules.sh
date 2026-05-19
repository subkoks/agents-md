#!/bin/bash
# Reject commits that modify local artifacts without repository source update.

set -euo pipefail

SOURCE_REL="src/gotcha.md"
ARTIFACT_PREFIX="dist/rules/"

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -z "$repo_root" ]]; then
  exit 0
fi

staged=()
while IFS= read -r rel; do
  staged+=("$rel")
done < <(git diff --cached --name-only --diff-filter=ACMR)
if [[ "${#staged[@]}" -eq 0 ]]; then
  exit 0
fi

source_staged=0
artifact_hits=()

for rel in "${staged[@]}"; do
  if [[ "$rel" == "$SOURCE_REL" ]]; then
    source_staged=1
  fi

  if [[ "$rel" == "$ARTIFACT_PREFIX"* ]]; then
    artifact_hits+=("$rel")
  fi
done

if [[ "${#artifact_hits[@]}" -eq 0 ]]; then
  exit 0
fi

if [[ "$source_staged" -ne 1 ]]; then
  echo "❌ Rule guard: generated artifact edits detected without source update."
  printf "Artifact files staged:\n"
  printf "  - %s\n" "${artifact_hits[@]}"
  echo "Source required:"
  echo "  - $SOURCE_REL"
  echo "Use: ./scripts/run-governance.sh"
  exit 1
fi

echo "✅ Rule guard: source + artifact edit detected."
