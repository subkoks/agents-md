#!/bin/bash
# Backward-compatible wrapper for local artifact builds.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "[WARN] scripts/sync-all.sh is deprecated."
echo "[WARN] Use scripts/build-rule-artifacts.sh instead."

"$SCRIPT_DIR/build-rule-artifacts.sh" "$@"
