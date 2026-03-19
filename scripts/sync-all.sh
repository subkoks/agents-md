#!/bin/bash
# Unified sync script for all editor targets from canonical source.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SOURCE="$PROJECT_ROOT/src/gotcha.md"

DRY_RUN="${DRY_RUN:-0}"
VERBOSE="${VERBOSE:-0}"
FORCE="${FORCE:-0}"

# Target definitions
TARGETS=(
    "windsurf:$HOME/.windsurf/rules/gotcha.md"
    "claude:$HOME/.claude/CLAUDE.md"
    "codex:$HOME/.codex/AGENTS.md"
)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

log_verbose() {
    if [[ "$VERBOSE" == "1" ]]; then
        echo -e "${BLUE}🔍 $1${NC}"
    fi
}

show_help() {
    cat << EOF
Usage: $0 [OPTIONS] [TARGETS...]

Sync canonical gotcha rules to all editor targets.

OPTIONS:
    -h, --help      Show this help message
    -d, --dry-run   Show what would be done without making changes
    -v, --verbose   Show detailed output
    -f, --force     Force sync even if targets are identical
    -l, --list      List available targets and their status

TARGETS:
    windsurf        Sync to Windsurf rules directory
    claude          Sync to Claude rules file
    codex           Sync to Codex rules file
    all             Sync to all targets (default)

EXAMPLES:
    $0                          # Sync to all targets
    $0 windsurf claude          # Sync only to specific targets
    $0 --dry-run --verbose      # Preview changes with details
    $0 --list                   # Show target status

EOF
}

check_source() {
    if [[ ! -f "$SOURCE" ]]; then
        log_error "Canonical source not found: $SOURCE"
        exit 1
    fi

    log_verbose "Source validated: $SOURCE"
}

backup_target() {
    local target="$1"
    local backup="$target.backup.$(date +%Y%m%d_%H%M%S)"

    if [[ "$DRY_RUN" == "1" ]]; then
        log_info "DRY_RUN: Would create backup: $backup"
        return
    fi

    cp "$target" "$backup"
    log_success "Backup created: $backup"
    echo "$backup"
}

sync_target() {
    local name="$1"
    local target="$2"

    log_info "Syncing to $name: $target"

    # Check if target directory exists
    local target_dir="$(dirname "$target")"
    if [[ "$DRY_RUN" != "1" && ! -d "$target_dir" ]]; then
        log_verbose "Creating directory: $target_dir"
        mkdir -p "$target_dir"
    fi

    # Handle existing target
    local backup=""
    if [[ -f "$target" ]]; then
        # Check if sync is needed
        if [[ "$FORCE" != "1" ]] && cmp -s "$SOURCE" "$target"; then
            log_success "Already in sync: $name"
            return 0
        fi

        backup=$(backup_target "$target")
    fi

    # Perform sync
    if [[ "$DRY_RUN" == "1" ]]; then
        log_info "DRY_RUN: Would copy $SOURCE → $target"
    else
        cp "$SOURCE" "$target"
        log_success "Synced: $name"

        # Show changes if backup exists
        if [[ -n "$backup" && -f "$backup" ]]; then
            log_verbose "Changes for $name:"
            diff -u "$backup" "$target" || true
        fi
    fi
}

list_targets() {
    echo "Available targets:"
    echo ""

    for target_entry in "${TARGETS[@]}"; do
        IFS=':' read -r name target <<< "$target_entry"
        local status="missing"

        if [[ -f "$target" ]]; then
            if cmp -s "$SOURCE" "$target" 2>/dev/null; then
                status="in-sync"
            else
                status="out-of-sync"
            fi
        fi

        case "$status" in
            "in-sync")
                echo -e "  ${GREEN}✅${NC} $name → $target"
                ;;
            "out-of-sync")
                echo -e "  ${YELLOW}⚠️${NC} $name → $target"
                ;;
            "missing")
                echo -e "  ${RED}❌${NC} $name → $target"
                ;;
        esac
    done
}

main() {
    # Parse arguments
    local targets_to_sync=()

    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -d|--dry-run)
                DRY_RUN=1
                shift
                ;;
            -v|--verbose)
                VERBOSE=1
                shift
                ;;
            -f|--force)
                FORCE=1
                shift
                ;;
            -l|--list)
                list_targets
                exit 0
                ;;
            windsurf|claude|codex|all)
                targets_to_sync+=("$1")
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done

    # Default to all targets if none specified
    if [[ ${#targets_to_sync[@]} -eq 0 ]]; then
        targets_to_sync=("all")
    fi

    log_info "Starting sync from canonical source"
    log_verbose "Source: $SOURCE"

    if [[ "$DRY_RUN" == "1" ]]; then
        log_warning "DRY RUN MODE - No changes will be made"
    fi

    check_source

    local sync_count=0
    local error_count=0

    # Process targets
    for target_name in "${targets_to_sync[@]}"; do
        if [[ "$target_name" == "all" ]]; then
            for target_entry in "${TARGETS[@]}"; do
                IFS=':' read -r name target <<< "$target_entry"
                if sync_target "$name" "$target"; then
                    ((sync_count++))
                else
                    ((error_count++))
                fi
            done
        else
            # Find matching target
            for target_entry in "${TARGETS[@]}"; do
                IFS=':' read -r name target <<< "$target_entry"
                if [[ "$name" == "$target_name" ]]; then
                    if sync_target "$name" "$target"; then
                        ((sync_count++))
                    else
                        ((error_count++))
                    fi
                    break
                fi
            done
        fi
    done

    # Summary
    echo ""
    if [[ "$DRY_RUN" == "1" ]]; then
        log_info "DRY RUN completed"
    else
        log_success "Sync completed"
    fi

    echo "  Targets synced: $sync_count"
    if [[ $error_count -gt 0 ]]; then
        echo "  Errors: $error_count"
        exit 1
    fi

    if [[ "$sync_count" -gt 0 && "$DRY_RUN" != "1" ]]; then
        echo ""
        log_info "Restart affected editors to load updated rules"
    fi
}

main "$@"
