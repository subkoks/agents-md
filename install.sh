#!/usr/bin/env bash
# Manually install agents-md Cursor lean rules (and optional full rules) with backups.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIST_LEAN="${SCRIPT_DIR}/dist/rules/cursor.lean.md"
DIST_FULL="${SCRIPT_DIR}/dist/rules/cursor.md"
CURSOR_RULES_DIR="${HOME}/.cursor/rules"
LEAN_DEST="${CURSOR_RULES_DIR}/gotcha.mdc"
FULL_DEST="${CURSOR_RULES_DIR}/gotcha-full.mdc"
INSTALL_FULL=0
DRY_RUN=0

usage() {
  cat <<'EOF'
Usage: ./install.sh [OPTIONS]

Manually install generated Cursor rule artifacts from this repository.

Options:
  --full       Also install full rules to gotcha-full.mdc (manual @mention)
  --dry-run    Print actions without writing files
  -h, --help   Show this help

Defaults:
  - Manually installs lean rules to ~/.cursor/rules/gotcha.mdc (alwaysApply)
  - Backs up existing targets with a timestamp suffix before overwrite
  - Runs artifact build if dist/rules/cursor.lean.md is missing
  - Does not read, write, or control ~/AGENTS.md

Supported: macOS and Linux (bash 4+).
EOF
}

log() { printf '%s\n' "$*"; }

backup_if_exists() {
  local target="$1"
  if [[ -f "$target" ]]; then
    local backup="${target}.bak.$(date +%Y%m%d%H%M%S)"
    if [[ "$DRY_RUN" -eq 1 ]]; then
      log "[dry-run] would backup: $target -> $backup"
    else
      cp -p "$target" "$backup"
      log "[ OK ] Backed up: $backup"
    fi
  fi
}

ensure_artifacts() {
  if [[ -f "$DIST_LEAN" ]]; then
    return 0
  fi
  log "[INFO] Building artifacts (cursor + cursor-lean)..."
  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "[dry-run] would run: ${SCRIPT_DIR}/scripts/build-rule-artifacts.sh cursor cursor-lean"
    return 0
  fi
  "${SCRIPT_DIR}/scripts/build-rule-artifacts.sh" cursor cursor-lean
}

install_file() {
  local src="$1"
  local dest="$2"
  if [[ ! -f "$src" ]]; then
    log "[ERR ] Missing source: $src (run make build-artifacts from repo root)"
    exit 1
  fi
  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "[dry-run] would install: $src -> $dest"
    return 0
  fi
  mkdir -p "$(dirname "$dest")"
  backup_if_exists "$dest"
  cp -p "$src" "$dest"
  log "[ OK ] Installed: $dest"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --full) INSTALL_FULL=1; shift ;;
    --dry-run) DRY_RUN=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) log "[ERR ] Unknown option: $1"; usage; exit 1 ;;
  esac
done

case "$(uname -s)" in
  Darwin|Linux) ;;
  *)
    log "[ERR ] Unsupported OS: $(uname -s). Use macOS or Linux."
    exit 1
    ;;
esac

ensure_artifacts
install_file "$DIST_LEAN" "$LEAN_DEST"

if [[ "$INSTALL_FULL" -eq 1 ]]; then
  install_file "$DIST_FULL" "$FULL_DEST"
fi

log "[DONE] Lean Cursor rules installed manually. Optional full: ./install.sh --full"
log "       Dev checkout alternative: make install-cursor-local"
