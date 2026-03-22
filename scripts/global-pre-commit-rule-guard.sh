#!/bin/bash
# Global optional guard for generated artifact files.

set -euo pipefail

CANONICAL_REL="src/gotcha.md"
ARTIFACT_PREFIX="dist/rules/"

WARN_ONLY="${RULE_GUARD_WARN_ONLY:-0}"
repo_root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
[[ -z "$repo_root" ]] && exit 0

mapfile -t staged < <(git diff --cached --name-only --diff-filter=ACMR)
[[ "${#staged[@]}" -eq 0 ]] && exit 0

canonical_staged=0
artifact_hits=()

for rel in "${staged[@]}"; do
  [[ "$rel" == "$CANONICAL_REL" ]] && canonical_staged=1
  [[ "$rel" == "$ARTIFACT_PREFIX"* ]] && artifact_hits+=("$rel")
done

[[ "${#artifact_hits[@]}" -eq 0 ]] && exit 0

message() {
  echo "Rule guard: generated artifact edit detected."
  printf "  - %s\n" "${artifact_hits[@]}"
  echo "Preferred flow: edit canonical then run scripts/run-governance.sh"
}

if [[ "$canonical_staged" -eq 1 ]]; then
  echo "Rule guard: canonical + artifact change detected (allowed)."
  exit 0
fi

if [[ "$WARN_ONLY" == "1" ]]; then
  message
  echo "WARN_ONLY enabled; commit continues."
  exit 0
fi

message
echo "Commit blocked. Set RULE_GUARD_WARN_ONLY=1 to warn-only."
exit 1
