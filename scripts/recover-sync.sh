#!/bin/bash
# Recovery script for rule sync issues and rollback procedures.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SOURCE="$PROJECT_ROOT/src/gotcha.md"

# Target definitions
TARGETS=(
    "windsurf:$PROJECT_ROOT/dist/rules/windsurf.md"
    "claude:$PROJECT_ROOT/dist/rules/claude.md"
    "codex:$PROJECT_ROOT/dist/rules/codex.md"
)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

show_help() {
    cat << 'EOF'
Usage: $0 [OPTIONS] [ACTION]

Recovery and rollback procedures for rule sync issues.

ACTIONS:
    status          Show current sync status
    backup          Create manual backups
    restore         Restore from backups
    reset           Force reset to canonical
    diagnose        Diagnose sync issues
    cleanup         Clean old backups

OPTIONS:
    -h, --help      Show this help message
    -t, --target    Target specific editor (windsurf|claude|codex)
    -b, --backup    Specify backup file to restore from
    -f, --force     Force action without confirmation

EXAMPLES:
    $0 status                    # Show current status
    $0 diagnose                  # Diagnose issues
    $0 backup                    # Create backups
    $0 restore --backup FILE     # Restore from specific backup
    $0 reset --force            # Force reset all targets
    $0 cleanup                   # Clean old backups

EOF
}

show_status() {
    log_info "Current sync status"
    echo ""

    for target_entry in "${TARGETS[@]}"; do
        IFS=':' read -r name target <<< "$target_entry"

        if [[ -f "$target" ]]; then
            if cmp -s "$SOURCE" "$target"; then
                echo -e "  ${GREEN}✅${NC} $name: In sync"
            else
                echo -e "  ${YELLOW}⚠️${NC} $name: Out of sync"
            fi
        else
            echo -e "  ${RED}❌${NC} $name: Missing"
        fi
    done
}

diagnose_issues() {
    log_info "Diagnosing sync issues"
    echo ""

    # Check source file
    if [[ ! -f "$SOURCE" ]]; then
        log_error "Canonical source missing: $SOURCE"
        return 1
    fi
    log_success "Canonical source exists"

    # Check each target
    local issues=0

    for target_entry in "${TARGETS[@]}"; do
        IFS=':' read -r name target <<< "$target_entry"

        echo ""
        log_info "Diagnosing $name..."

        # Check directory
        local target_dir="$(dirname "$target")"
        if [[ ! -d "$target_dir" ]]; then
            log_error "Directory missing: $target_dir"
            ((issues++))
        else
            log_success "Directory exists: $target_dir"
        fi

        # Check file
        if [[ -f "$target" ]]; then
            log_success "File exists: $target"

            # Check permissions
            if [[ -r "$target" && -w "$target" ]]; then
                log_success "File permissions OK"
            else
                log_error "File permission issues"
                ((issues++))
            fi

            # Check content
            if cmp -s "$SOURCE" "$target"; then
                log_success "Content matches canonical"
            else
                log_warning "Content differs from canonical"
                ((issues++))
            fi
        else
            log_error "File missing: $target"
            ((issues++))
        fi
    done

    echo ""
    if [[ $issues -eq 0 ]]; then
        log_success "No issues detected"
    else
        log_error "Found $issues issue(s)"
    fi
}

create_backups() {
    log_info "Creating backups"

    for target_entry in "${TARGETS[@]}"; do
        IFS=':' read -r name target <<< "$target_entry"

        if [[ -f "$target" ]]; then
            local backup="$target.backup.$(date +%Y%m%d_%H%M%S)"
            cp "$target" "$backup"
            log_success "Backup created: $name → $backup"
        else
            log_warning "No file to backup: $name"
        fi
    done
}

restore_from_backup() {
    local backup_file="$1"

    if [[ ! -f "$backup_file" ]]; then
        log_error "Backup file not found: $backup_file"
        return 1
    fi

    log_info "Restoring from backup: $backup_file"

    # Determine target from backup filename
    local target_name=""
    for target_entry in "${TARGETS[@]}"; do
        IFS=':' read -r name target <<< "$target_entry"
        if [[ "$backup_file" == *"$target"* ]]; then
            target_name="$name"
            break
        fi
    done

    if [[ -z "$target_name" ]]; then
        log_error "Cannot determine target for backup file"
        return 1
    fi

    # Find target path
    local target_path=""
    for target_entry in "${TARGETS[@]}"; do
        IFS=':' read -r name target <<< "$target_entry"
        if [[ "$name" == "$target_name" ]]; then
            target_path="$target"
            break
        fi
    done

    if [[ -z "$target_path" ]]; then
        log_error "Cannot find target path for: $target_name"
        return 1
    fi

    # Create directory if needed
    mkdir -p "$(dirname "$target_path")"

    # Restore
    cp "$backup_file" "$target_path"
    log_success "Restored: $target_name"
}

force_reset() {
    log_warning "Force resetting all targets to canonical"

    if [[ "$FORCE" != "1" ]]; then
        read -p "This will overwrite all target files. Continue? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Reset cancelled"
            return 0
        fi
    fi

    for target_entry in "${TARGETS[@]}"; do
        IFS=':' read -r name target <<< "$target_entry"

        log_info "Resetting $name..."

        # Create directory
        mkdir -p "$(dirname "$target")"

        # Copy canonical
        cp "$SOURCE" "$target"
        log_success "Reset complete: $name"
    done

    echo ""
    log_info "Local artifact reset complete"
}

cleanup_backups() {
    log_info "Cleaning old backups"

    local cleaned=0
    local cutoff_days=30

    for target_entry in "${TARGETS[@]}"; do
        IFS=':' read -r name target <<< "$target_entry"

        # Find old backup files
        find "$(dirname "$target")" -name "$(basename "$target").backup.*" -type f -mtime +$cutoff_days | while read backup; do
            rm "$backup"
            log_success "Removed old backup: $(basename "$backup")"
            ((cleaned++))
        done
    done

    if [[ $cleaned -eq 0 ]]; then
        log_info "No old backups to clean"
    else
        log_success "Cleaned $cleaned old backup files"
    fi
}

main() {
    local action=""
    local target=""
    local backup_file=""

    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -t|--target)
                target="$2"
                shift 2
                ;;
            -b|--backup)
                backup_file="$2"
                shift 2
                ;;
            -f|--force)
                FORCE=1
                shift
                ;;
            status|backup|restore|reset|diagnose|cleanup)
                action="$1"
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done

    case "$action" in
        status)
            show_status
            ;;
        diagnose)
            diagnose_issues
            ;;
        backup)
            create_backups
            ;;
        restore)
            if [[ -z "$backup_file" ]]; then
                log_error "Backup file required for restore"
                exit 1
            fi
            restore_from_backup "$backup_file"
            ;;
        reset)
            force_reset
            ;;
        cleanup)
            cleanup_backups
            ;;
        "")
            echo "Action required"
            show_help
            exit 1
            ;;
        *)
            log_error "Unknown action: $action"
            show_help
            exit 1
            ;;
    esac
}

main "$@"
