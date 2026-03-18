#!/bin/bash
# Validate local markdown file links and references.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

ERRORS=0
WARNINGS=0

echo "🔗 Checking markdown links in $PROJECT_ROOT"

while IFS= read -r file; do
    while IFS= read -r link; do
        target="${link#./}"
        if [[ "$target" == /* || "$target" == http* || "$target" == mailto:* || "$target" == \#* ]]; then
            continue
        fi

        clean_target="${target%%\#*}"
        if [[ -z "$clean_target" ]]; then
            continue
        fi

        absolute_target="$PROJECT_ROOT/$clean_target"
        if [[ ! -e "$absolute_target" ]]; then
            echo "❌ Broken link in ${file#$PROJECT_ROOT/}: $link"
            ERRORS=$((ERRORS + 1))
        fi
    done < <(grep -oE "\]\(([^)]+)\)" "$file" | sed -E "s/^\]\((.*)\)$/\1/" || true)
done < <(find "$PROJECT_ROOT" -type f -name "*.md")

if [[ "$ERRORS" -gt 0 ]]; then
    echo "❌ Link check failed with $ERRORS error(s), $WARNINGS warning(s)"
    exit 1
fi

echo "✅ Link check passed"
