#!/bin/bash
# Validate gotcha.md for common issues

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SOURCE="$PROJECT_ROOT/src/gotcha.md"

ERRORS=0
WARNINGS=0

echo "🔍 Validating: $SOURCE"
echo ""

# Check file exists
if [[ ! -f "$SOURCE" ]]; then
    echo "❌ File not found"
    exit 1
fi

# Check frontmatter
if ! head -n 3 "$SOURCE" | grep -q "trigger:"; then
    echo "❌ Missing frontmatter trigger"
    ERRORS=$((ERRORS + 1))
else
    echo "✅ Frontmatter present"
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

# Check minimum sections (should have at least 10)
SECTION_COUNT=$(grep -c "^## " "$SOURCE" || true)
if [[ "$SECTION_COUNT" -lt 10 ]]; then
    echo "❌ Only $SECTION_COUNT sections (expected 10+)"
    ERRORS=$((ERRORS + 1))
else
    echo "✅ $SECTION_COUNT sections found"
fi

# Check file size (should be substantial)
SIZE=$(wc -c < "$SOURCE" | tr -d ' ')
if [[ "$SIZE" -lt 5000 ]]; then
    echo "⚠️  File size only $SIZE bytes (expected 5000+)"
    WARNINGS=$((WARNINGS + 1))
else
    echo "✅ File size: $SIZE bytes"
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
