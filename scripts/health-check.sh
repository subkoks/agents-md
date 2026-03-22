#!/bin/bash
# Unified health check with timestamped logs.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
LOG_DIR="$PROJECT_ROOT/logs/health"
STAMP="$(date +%Y%m%d_%H%M%S)"
LOG_FILE="$LOG_DIR/health-$STAMP.log"

mkdir -p "$LOG_DIR"
exec > >(tee "$LOG_FILE") 2>&1

echo "== health-check started: $(date -u +%FT%TZ)"
echo "== log file: $LOG_FILE"

run_step() {
  local name="$1"
  shift
  echo ""
  echo "-- $name"
  if "$@"; then
    echo "OK: $name"
  else
    echo "FAIL: $name"
    return 1
  fi
}

run_step "validate rules" "$SCRIPT_DIR/validate-rules.sh"
run_step "check markdown links" "$SCRIPT_DIR/check-links.sh"
run_step "validate comprehensive" "$SCRIPT_DIR/validate-comprehensive.sh"
run_step "build artifacts (dry-run)" "$SCRIPT_DIR/build-rule-artifacts.sh" --dry-run
run_step "local drift check" "$SCRIPT_DIR/check-local-drift.sh"
run_step "skills registry drift" "$SCRIPT_DIR/check-skill-registry-drift.sh"

echo ""
echo "-- local script syntax"
syntax_failures=0
while IFS= read -r script; do
  if bash -n "$script"; then
    echo "OK: $script"
  else
    echo "FAIL: $script"
    syntax_failures=$((syntax_failures + 1))
  fi
done < <(find "$SCRIPT_DIR" -maxdepth 1 -name "*.sh" -type f | sort)

if [[ "$syntax_failures" -gt 0 ]]; then
  echo ""
  echo "FAIL: local script syntax checks failed ($syntax_failures)"
  exit 1
fi

echo ""
echo "== health-check finished: $(date -u +%FT%TZ)"
