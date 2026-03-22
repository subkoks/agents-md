#!/bin/bash
# Run strict governance pipeline in deterministic order.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> [1/4] strict validation"
"$SCRIPT_DIR/validate-comprehensive.sh" --strict

echo "==> [2/4] pre-build drift check"
"$SCRIPT_DIR/check-local-drift.sh"

echo "==> [3/4] build local artifacts"
"$SCRIPT_DIR/build-rule-artifacts.sh"

echo "==> [4/4] post-build strict drift check"
"$SCRIPT_DIR/check-local-drift.sh" --strict

echo "✅ governance pipeline complete"
