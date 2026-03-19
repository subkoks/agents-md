#!/bin/bash
# Comprehensive validation including cross-editor compatibility and drift detection.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SOURCE="$PROJECT_ROOT/src/gotcha.md"

VERBOSE="${VERBOSE:-0}"
STRICT="${STRICT:-0}"

# Target definitions
TARGETS=(
    "windsurf:$HOME/.windsurf/rules/gotcha.md"
    "claude:$HOME/.claude/CLAUDE.md"
    "codex:$HOME/.codex/AGENTS.md"
)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ERRORS=0
WARNINGS=0

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
    ((WARNINGS++))
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
    ((ERRORS++))
}

log_verbose() {
    if [[ "$VERBOSE" == "1" ]]; then
        echo -e "${BLUE}🔍 $1${NC}"
    fi
}

show_help() {
    cat << EOF
Usage: $0 [OPTIONS]

Comprehensive validation of canonical rules and cross-editor compatibility.

OPTIONS:
    -h, --help      Show this help message
    -v, --verbose   Show detailed output
    -s, --strict    Treat warnings as errors

VALIDATION CHECKS:
    1. Canonical rule structure and quality
    2. Cross-editor compatibility
    3. Version drift detection
    4. Target accessibility
    5. Content integrity

EXAMPLES:
    $0                    # Standard validation
    $0 --verbose         # Detailed output
    $0 --strict          # Fail on warnings

EOF
}

validate_canonical() {
    log_info "Validating canonical rules: $SOURCE"

    if [[ ! -f "$SOURCE" ]]; then
        log_error "Canonical source not found: $SOURCE"
        return 1
    fi

    log_verbose "Source file exists"

    # Check required sections
    REQUIRED_SECTIONS=(
        "## System Boundaries"
        "## Operating Principles"
        "## Planning vs. Implementation"
        "## Code Style"
        "## Security"
        "## Testing"
        "## Tool Usage"
        "## External Alignment"
    )

    for section in "${REQUIRED_SECTIONS[@]}"; do
        if ! grep -qF "$section" "$SOURCE"; then
            log_error "Missing required section: $section"
        else
            log_verbose "Found section: $section"
        fi
    done

    # Check top-level title
    if ! head -n 1 "$SOURCE" | grep -qE "^# "; then
        log_error "Missing top-level title"
    else
        log_verbose "Top-level title present"
    fi

    # Check for duplicate sections
    SECTIONS=$(grep -E "^## " "$SOURCE" | sort | uniq -d)
    if [[ -n "$SECTIONS" ]]; then
        log_warning "Duplicate sections found: $SECTIONS"
    else
        log_verbose "No duplicate sections"
    fi

    # Check for TODO/FIXME
    TODOS=$(grep -c "TODO\|FIXME" "$SOURCE" || true)
    if [[ "$TODOS" -gt 0 ]]; then
        log_warning "Found $TODOS TODO/FIXME items"
    else
        log_verbose "No TODO/FIXME items"
    fi

    # Check heading density
    H2_COUNT=$(grep -c "^## " "$SOURCE" || true)
    if [[ "$H2_COUNT" -lt 10 ]]; then
        log_warning "Low number of H2 sections: $H2_COUNT"
    else
        log_verbose "H2 section count: $H2_COUNT"
    fi

    # Check file size
    SIZE=$(wc -c < "$SOURCE" | tr -d ' ')
    if [[ "$SIZE" -lt 5000 ]]; then
        log_warning "File size only $SIZE bytes (expected 5000+)"
    else
        log_verbose "File size: $SIZE bytes"
    fi

    # Check unresolved placeholders
    PLACEHOLDERS=$(grep -cE "\[(PROJECT_NAME|Rule Name|Section Name)\]" "$SOURCE" || true)
    if [[ "$PLACEHOLDERS" -gt 0 ]]; then
        log_warning "Found $PLACEHOLDERS unresolved placeholder token(s)"
    else
        log_verbose "No unresolved placeholders"
    fi

    # Check external alignment section accuracy
    if grep -q "Canonical source in this repo: \`src/gotcha.md\`" "$SOURCE"; then
        log_verbose "External alignment section accurate"
    else
        log_error "External alignment section missing or incorrect"
    fi

    log_success "Canonical validation completed"
}

validate_cross_editor_compatibility() {
    log_info "Checking cross-editor compatibility"

    # Diagnostic: Show environment info
    log_verbose "Environment: HOME=$HOME"
    log_verbose "Source file: $SOURCE"
    log_verbose "Source exists: $([[ -f "$SOURCE" ]] && echo "YES" || echo "NO")"

    local sync_count=0
    local compatible_count=0

    for target_entry in "${TARGETS[@]}"; do
        IFS=':' read -r name target <<< "$target_entry"
        ((sync_count++))

        log_verbose "Processing target: $name -> $target"
        log_verbose "Target directory: $(dirname "$target")"
        log_verbose "Target exists: $([[ -f "$target" ]] && echo "YES" || echo "NO")"

        if [[ ! -f "$target" ]]; then
            log_warning "Target missing: $name ($target)"
            log_verbose "Target directory exists: $([[ -d "$(dirname "$target")" ]] && echo "YES" || echo "NO")"
            continue
        fi

        # Check if files are identical
        if cmp -s "$SOURCE" "$target"; then
            log_success "In sync: $name"
            ((compatible_count++))
        else
            log_warning "Out of sync: $name"

            # Show differences in verbose mode
            if [[ "$VERBOSE" == "1" ]]; then
                log_verbose "Differences for $name:"
                diff -u "$target" "$SOURCE" | head -20 || true
            fi
        fi
    done

    log_verbose "Compatibility check completed: $compatible_count/$sync_count targets compatible"

    if [[ $compatible_count -eq $sync_count ]]; then
        log_success "All targets compatible ($compatible_count/$sync_count)"
    else
        log_warning "Partial compatibility ($compatible_count/$sync_count)"
    fi
}

validate_target_accessibility() {
    log_info "Checking target accessibility"

    for target_entry in "${TARGETS[@]}"; do
        IFS=':' read -r name target <<< "$target_entry"

        # Check directory exists
        local target_dir="$(dirname "$target")"
        if [[ -d "$target_dir" ]]; then
            log_verbose "Directory accessible: $name ($target_dir)"
        else
            log_warning "Target directory missing: $name ($target_dir)"
        fi

        # Check file permissions if exists
        if [[ -f "$target" ]]; then
            if [[ -r "$target" && -w "$target" ]]; then
                log_verbose "File permissions OK: $name"
            else
                log_warning "File permission issues: $name"
            fi
        fi
    done
}

validate_content_integrity() {
    log_info "Checking content integrity"

    # Check for encoding issues
    if file "$SOURCE" | grep -q "ASCII"; then
        log_verbose "Source file encoding: ASCII"
    elif file "$SOURCE" | grep -q "UTF-8"; then
        log_verbose "Source file encoding: UTF-8"
    else
        log_warning "Unexpected file encoding"
    fi

    # Check for line ending consistency
    if file "$SOURCE" | grep -q "CRLF"; then
        log_warning "Windows line endings detected (should be LF)"
    else
        log_verbose "Line endings: Unix LF"
    fi

    # Check for trailing whitespace
    TRAILING_WS=$(grep -cE "[[:space:]]+$" "$SOURCE" || true)
    if [[ "$TRAILING_WS" -gt 0 ]]; then
        log_warning "Found $TRAILING_WS lines with trailing whitespace"
    else
        log_verbose "No trailing whitespace"
    fi

    # Check for tab characters (should use spaces)
    TAB_COUNT=$(grep -cE $'\t' "$SOURCE" || true)
    if [[ "$TAB_COUNT" -gt 0 ]]; then
        log_warning "Found $TAB_COUNT tab characters (should use spaces)"
    else
        log_verbose "No tab characters"
    fi
}

detect_version_drift() {
    log_info "Detecting version drift"

    local source_hash=$(sha256sum "$SOURCE" | cut -d' ' -f1)
    log_verbose "Source hash: $source_hash"

    local drift_count=0

    for target_entry in "${TARGETS[@]}"; do
        IFS=':' read -r name target <<< "$target_entry"

        if [[ -f "$target" ]]; then
            local target_hash=$(sha256sum "$target" | cut -d' ' -f1)

            if [[ "$source_hash" != "$target_hash" ]]; then
                log_warning "Version drift detected: $name"
                log_verbose "  Target hash: $target_hash"
                ((drift_count++))
            else
                log_verbose "No drift: $name"
            fi
        fi
    done

    if [[ $drift_count -eq 0 ]]; then
        log_success "No version drift detected"
    else
        log_warning "Version drift in $drift_count targets"
    fi
}

validate_sync_scripts() {
    log_info "Validating sync scripts"

    local scripts=(
        "sync-all.sh"
        "sync-to-windsurf.sh"
        "validate-rules.sh"
        "check-rule-drift.sh"
        "check-links.sh"
    )

    for script in "${scripts[@]}"; do
        local script_path="$SCRIPT_DIR/$script"

        if [[ -f "$script_path" ]]; then
            if [[ -x "$script_path" ]]; then
                log_verbose "Script executable: $script"
            else
                log_warning "Script not executable: $script"
            fi

            # Basic syntax check
            if bash -n "$script_path" 2>/dev/null; then
                log_verbose "Script syntax OK: $script"
            else
                log_error "Script syntax error: $script"
            fi
        else
            log_warning "Script missing: $script"
        fi
    done
}

main() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -v|--verbose)
                VERBOSE=1
                shift
                ;;
            -s|--strict)
                STRICT=1
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done

    log_info "Starting comprehensive validation"
    log_verbose "Source: $SOURCE"
    log_verbose "Verbose mode: $VERBOSE"
    log_verbose "Strict mode: $STRICT"

    # Add diagnostic info at start
    log_verbose "Current working directory: $(pwd)"
    log_verbose "Available targets: ${#TARGETS[@]}"

    # Validate each function with error handling
    if ! validate_canonical; then
        log_error "Canonical validation failed"
        ((ERRORS++))
    fi

    if ! validate_cross_editor_compatibility; then
        log_error "Cross-editor compatibility check failed"
        ((ERRORS++))
    fi

    if ! validate_target_accessibility; then
        log_error "Target accessibility check failed"
        ((ERRORS++))
    fi

    if ! validate_content_integrity; then
        log_error "Content integrity check failed"
        ((ERRORS++))
    fi

    if ! detect_version_drift; then
        log_error "Version drift detection failed"
        ((ERRORS++))
    fi

    if ! validate_sync_scripts; then
        log_error "Sync scripts validation failed"
        ((ERRORS++))
    fi

    # Summary
    echo ""
    log_info "Validation summary:"
    log_verbose "  Errors: $ERRORS"
    log_verbose "  Warnings: $WARNINGS"

    if [[ "$ERRORS" -gt 0 ]]; then
        log_error "Validation failed: $ERRORS error(s), $WARNINGS warning(s)"
        exit 1
    elif [[ "$WARNINGS" -gt 0 && "$STRICT" == "1" ]]; then
        log_error "Validation failed in strict mode: $WARNINGS warning(s)"
        exit 1
    elif [[ "$WARNINGS" -gt 0 ]]; then
        log_warning "Validation completed with warnings: $WARNINGS warning(s)"
        exit 0
    else
        log_success "All validation checks passed"
        exit 0
    fi
}

main "$@"
