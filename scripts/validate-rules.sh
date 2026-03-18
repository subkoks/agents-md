#!/bin/bash
# Validate canonical rules for structural quality and drift risks.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SOURCE="$PROJECT_ROOT/src/gotcha.md"

ERRORS=0
WARNINGS=0

echo "🔍 Validating canonical rules: $SOURCE"
echo ""

# Check file exists
if [[ ! -f "$SOURCE" ]]; then
    echo "❌ File not found"
    exit 1
fi

# Ensure required sections exist
REQUIRED_SECTIONS=(
    "## Operating Principles"
    "## Planning vs. Implementation"
    "## Code Style"
    "## Security"
    "## Testing"
    "## Tool Usage"
)

for section in "${REQUIRED_SECTIONS[@]}"; do
    if ! grep -qF "$section" "$SOURCE"; then
        echo "❌ Missing required section: $section"
        ERRORS=$((ERRORS + 1))
    fi
done

if [[ "$ERRORS" -eq 0 ]]; then
    echo "✅ Required sections present"
fi

# Check top-level title
if ! head -n 1 "$SOURCE" | grep -qE "^# "; then
    echo "❌ Missing top-level title"
    ERRORS=$((ERRORS + 1))
else
    echo "✅ Top-level title present"
fi

# Check for duplicate sections
SECTIONS=$(grep -E "^## " "$SOURCE" | sort | uniq -d)
if [[ -n "$SECTIONS" ]]; then
    echo "⚠️  Duplicate sections found:"
    echo "$SECTIONS"
    WARNINGS=$((WARNINGS + 1))
else
    echo "✅ No duplicate sections"
fi

# Check for TODO/FIXME
TODOS=$(grep -c "TODO\|FIXME" "$SOURCE" || true)
if [[ "$TODOS" -gt 0 ]]; then
    echo "⚠️  Found $TODOS TODO/FIXME items"
    WARNINGS=$((WARNINGS + 1))
else
    echo "✅ No TODO/FIXME items"
fi

# Check heading density
H2_COUNT=$(grep -c "^## " "$SOURCE" || true)
if [[ "$H2_COUNT" -lt 10 ]]; then
    echo "⚠️  Low number of H2 sections: $H2_COUNT"
    WARNINGS=$((WARNINGS + 1))
else
    echo "✅ H2 section count: $H2_COUNT"
fi

# Check file size (should be substantial)
SIZE=$(wc -c < "$SOURCE" | tr -d ' ')
if [[ "$SIZE" -lt 5000 ]]; then
    echo "⚠️  File size only $SIZE bytes (expected 5000+)"
    WARNINGS=$((WARNINGS + 1))
else
    echo "✅ File size: $SIZE bytes"
fi

# Check unresolved placeholder tokens
PLACEHOLDERS=$(grep -cE "\[(PROJECT_NAME|Rule Name|Section Name)\]" "$SOURCE" || true)
if [[ "$PLACEHOLDERS" -gt 0 ]]; then
    echo "⚠️  Found $PLACEHOLDERS unresolved placeholder token(s)"
    WARNINGS=$((WARNINGS + 1))
else
    echo "✅ No unresolved placeholders"
fi

# Summary
echo ""
if [[ "$ERRORS" -gt 0 ]]; then
    echo "❌ $ERRORS error(s), $WARNINGS warning(s)"
    exit 1
elif [[ "$WARNINGS" -gt 0 ]]; then
    echo "⚠️  $WARNINGS warning(s)"
    exit 0
else
    echo "✅ All checks passed"
    exit 0
fi
