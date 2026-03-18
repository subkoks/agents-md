#!/bin/bash
# Compare canonical rules against configured external wrappers.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CANONICAL="$PROJECT_ROOT/src/gotcha.md"

TARGETS=(
    "$HOME/.windsurf/rules/gotcha.md"
    "$HOME/.claude/CLAUDE.md"
    "$HOME/.codex/AGENTS.md"
)

WARNINGS=0

echo "🧭 Checking rule drift from canonical source"

echo "   canonical: $CANONICAL"

if [[ ! -f "$CANONICAL" ]]; then
    echo "❌ Canonical file missing"
    exit 1
fi

for target in "${TARGETS[@]}"; do
    if [[ ! -f "$target" ]]; then
        echo "⚠️  Missing target: $target"
        WARNINGS=$((WARNINGS + 1))
        continue
    fi

    if cmp -s "$CANONICAL" "$target"; then
        echo "✅ In sync: $target"
    else
        echo "⚠️  Drift detected: $target"
        WARNINGS=$((WARNINGS + 1))
    fi
done

echo ""
if [[ "$WARNINGS" -gt 0 ]]; then
    echo "⚠️  Drift check completed with $WARNINGS warning(s)"
    exit 0
fi

echo "✅ Drift check passed"
