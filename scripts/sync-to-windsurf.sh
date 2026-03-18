#!/bin/bash
# Sync gotcha.md to Windsurf rules directory

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SOURCE="$PROJECT_ROOT/src/gotcha.md"
TARGET="$HOME/.windsurf/rules/gotcha.md"

# Check source exists
if [[ ! -f "$SOURCE" ]]; then
    echo "❌ Source not found: $SOURCE"
    exit 1
fi

# Create target directory if needed
mkdir -p "$(dirname "$TARGET")"

# Backup existing
if [[ -f "$TARGET" ]]; then
    BACKUP="$TARGET.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$TARGET" "$BACKUP"
    echo "📦 Backup: $BACKUP"
fi

# Copy
cp "$SOURCE" "$TARGET"
echo "✅ Synced: $SOURCE → $TARGET"

# Show diff if backup exists
if [[ -n "$BACKUP" && -f "$BACKUP" ]]; then
    echo ""
    echo "Changes:"
    diff -u "$BACKUP" "$TARGET" || true
fi

echo ""
echo "Restart Windsurf to load updated rules."
