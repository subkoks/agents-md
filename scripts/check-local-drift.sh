#!/bin/bash
# Check drift between canonical rules and local artifacts.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CANONICAL="$PROJECT_ROOT/src/gotcha.md"

STRICT=0
VERBOSE=0

TARGETS=(
  "$PROJECT_ROOT/dist/rules/windsurf.md"
  "$PROJECT_ROOT/dist/rules/claude.md"
  "$PROJECT_ROOT/dist/rules/codex.md"
)

show_help() {
  cat <<'EOF'
Usage: scripts/check-local-drift.sh [--strict] [--verbose]

Checks whether local artifacts under dist/rules match src/gotcha.md.

Options:
  --strict   Exit non-zero when drift or missing artifacts are found
  --verbose  Enable verbose logging output
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --strict)
      STRICT=1
      shift
      ;;
    --verbose)
      VERBOSE=1
      shift
      ;;
    -h|--help)
      show_help
      exit 0
      ;;
    *)
      printf '%s\n' "Unknown option: $1" >&2
      show_help
      exit 1
      ;;
  esac
done

if [[ ! -f "$CANONICAL" ]]; then
  printf '%s\n' "[ERR ] Canonical file missing: $CANONICAL" >&2
  exit 1
fi

warnings=0
printf '%s\n' "[INFO] Canonical: $CANONICAL"

if [[ "$VERBOSE" -eq 1 ]]; then
  printf '%s\n' "[INFO] Strict mode: $STRICT"
  printf '%s\n' "[INFO] Targets: ${#TARGETS[@]}"
fi

for target in "${TARGETS[@]}"; do
  if [[ "$VERBOSE" -eq 1 ]]; then
    printf '%s\n' "[INFO] Checking target: $target"
  fi

  if [[ ! -f "$target" ]]; then
    printf '%s\n' "[WARN] Missing artifact: $target"
    warnings=$((warnings + 1))
    continue
  fi

  if cmp -s "$CANONICAL" "$target"; then
    printf '%s\n' "[ OK ] In sync: $target"
  else
    printf '%s\n' "[WARN] Drift detected: $target"
    warnings=$((warnings + 1))
  fi
done

if [[ "$warnings" -gt 0 ]]; then
  printf '%s\n' "[WARN] Drift check completed with $warnings warning(s)"
  if [[ "$STRICT" -eq 1 ]]; then
    exit 1
  fi
  exit 0
fi

printf '%s\n' "[ OK ] No drift detected"
