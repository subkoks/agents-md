#!/bin/bash
# Sync canonical gotcha rules to Windsurf rules directory.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SOURCE="$PROJECT_ROOT/src/gotcha.md"
TARGET="$HOME/.windsurf/rules/gotcha.md"
DRY_RUN="${DRY_RUN:-0}"

echo "🔄 Sync start"
echo "   source: $SOURCE"
echo "   target: $TARGET"

# Check source exists
if [[ ! -f "$SOURCE" ]]; then
    echo "❌ Source not found: $SOURCE"
    exit 1
fi

# Create target directory if needed
mkdir -p "$(dirname "$TARGET")"

# Backup existing
BACKUP=""
if [[ -f "$TARGET" ]]; then
    BACKUP="$TARGET.backup.$(date +%Y%m%d_%H%M%S)"
    if [[ "$DRY_RUN" == "1" ]]; then
        echo "🧪 DRY_RUN=1 would create backup: $BACKUP"
    else
        cp "$TARGET" "$BACKUP"
        echo "📦 Backup: $BACKUP"
    fi
fi

# Copy
if [[ "$DRY_RUN" == "1" ]]; then
    echo "🧪 DRY_RUN=1 would copy canonical rules to target"
else
    cp "$SOURCE" "$TARGET"
    echo "✅ Synced: $SOURCE → $TARGET"
fi

# Show diff if backup exists
if [[ -n "$BACKUP" && -f "$BACKUP" ]]; then
    echo ""
    echo "Changes:"
    diff -u "$BACKUP" "$TARGET" || true
fi

echo ""
echo "Restart Windsurf to load updated rules."
