#!/bin/bash
# Backward-compatible wrapper for local Windsurf artifact build.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "[WARN] scripts/sync-to-windsurf.sh is deprecated."
echo "[WARN] Building local artifact: dist/rules/windsurf.md"

"$SCRIPT_DIR/build-rule-artifacts.sh" windsurf "$@"
