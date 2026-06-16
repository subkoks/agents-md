#!/bin/bash
# Run strict governance pipeline in deterministic order.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> [1/6] strict validation"
"$SCRIPT_DIR/validate-comprehensive.sh" --strict

echo "==> [2/6] pre-build drift check"
"$SCRIPT_DIR/check-local-drift.sh"

echo "==> [3/6] build local artifacts"
"$SCRIPT_DIR/build-rule-artifacts.sh"

echo "==> [4/6] build structured rule artifacts"
"$SCRIPT_DIR/build-structured-rules.sh"

echo "==> [5/6] post-build strict drift check"
"$SCRIPT_DIR/check-local-drift.sh" --strict

echo "==> [6/6] structured rules drift check"
"$SCRIPT_DIR/build-structured-rules.sh" --check

echo "✅ governance pipeline complete"
