#!/bin/bash
# Build local rule artifacts from canonical source.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SOURCE="$PROJECT_ROOT/src/gotcha.md"
DIST_DIR="$PROJECT_ROOT/dist/rules"

DRY_RUN=0
VERBOSE=0
FORCE=0

TARGETS=(
  "windsurf:$DIST_DIR/windsurf.md"
  "claude:$DIST_DIR/claude.md"
  "codex:$DIST_DIR/codex.md"
)

log_info() {
  printf '%s\n' "[INFO] $1"
}

log_warn() {
  printf '%s\n' "[WARN] $1"
}

log_ok() {
  printf '%s\n' "[ OK ] $1"
}

log_verbose() {
  if [[ "$VERBOSE" -eq 1 ]]; then
    printf '%s\n' "[DBG ] $1"
  fi
}

show_help() {
  cat <<'EOF'
Usage: scripts/build-rule-artifacts.sh [OPTIONS] [TARGETS...]

Build local rule artifacts from src/gotcha.md into dist/rules.

Options:
  -h, --help      Show help
  -d, --dry-run   Preview changes without writing files
  -v, --verbose   Show detailed output
  -f, --force     Rebuild artifacts even when unchanged
  -l, --list      Show artifact status

Targets:
  windsurf        Build dist/rules/windsurf.md
  claude          Build dist/rules/claude.md
  codex           Build dist/rules/codex.md
  all             Build all targets (default)
EOF
}

validate_source() {
  if [[ ! -f "$SOURCE" ]]; then
    printf '%s\n' "[ERR ] Missing canonical source: $SOURCE" >&2
    exit 1
  fi
}

list_targets() {
  validate_source

  for target_entry in "${TARGETS[@]}"; do
    IFS=':' read -r name target <<< "$target_entry"

    if [[ ! -f "$target" ]]; then
      printf '%s\n' "- $name: missing ($target)"
      continue
    fi

    if cmp -s "$SOURCE" "$target"; then
      printf '%s\n' "- $name: in-sync ($target)"
    else
      printf '%s\n' "- $name: drift ($target)"
    fi
  done
}

build_target() {
  local name="$1"
  local target="$2"

  if [[ "$FORCE" -ne 1 && -f "$target" ]] && cmp -s "$SOURCE" "$target"; then
    log_ok "Already in sync: $name"
    return 0
  fi

  if [[ "$DRY_RUN" -eq 1 ]]; then
    log_info "DRY RUN: would write $target"
    return 0
  fi

  mkdir -p "$(dirname "$target")"
  cp "$SOURCE" "$target"
  log_ok "Built artifact: $name -> $target"
}

main() {
  local requested_targets=()

  while [[ $# -gt 0 ]]; do
    case "$1" in
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
        requested_targets+=("$1")
        shift
        ;;
      *)
        printf '%s\n' "[ERR ] Unknown option or target: $1" >&2
        show_help
        exit 1
        ;;
    esac
  done

  if [[ ${#requested_targets[@]} -eq 0 ]]; then
    requested_targets=("all")
  fi

  validate_source
  log_verbose "Source: $SOURCE"
  log_verbose "Dist dir: $DIST_DIR"

  local built_count=0

  for requested in "${requested_targets[@]}"; do
    if [[ "$requested" == "all" ]]; then
      for target_entry in "${TARGETS[@]}"; do
        IFS=':' read -r name target <<< "$target_entry"
        build_target "$name" "$target"
        built_count=$((built_count + 1))
      done
      continue
    fi

    for target_entry in "${TARGETS[@]}"; do
      IFS=':' read -r name target <<< "$target_entry"
      if [[ "$requested" == "$name" ]]; then
        build_target "$name" "$target"
        built_count=$((built_count + 1))
      fi
    done
  done

  if [[ "$DRY_RUN" -eq 1 ]]; then
    log_warn "DRY RUN complete"
  else
    log_ok "Build complete"
  fi
  log_info "Targets processed: $built_count"
}

main "$@"
