#!/bin/bash
# Backward-compatible wrapper for repo-local drift checks.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "[WARN] scripts/check-rule-drift.sh is deprecated."
echo "[WARN] Use scripts/check-local-drift.sh instead."

"$SCRIPT_DIR/check-local-drift.sh" "$@"
