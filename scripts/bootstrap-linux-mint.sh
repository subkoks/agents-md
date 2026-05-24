#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

SRC_CODEX="$PROJECT_ROOT/dist/rules/codex.md"
SRC_CLAUDE="$PROJECT_ROOT/dist/rules/claude.md"
SRC_CURSOR_LEAN="$PROJECT_ROOT/dist/rules/cursor.lean.md"
SRC_CURSOR_FULL="$PROJECT_ROOT/dist/rules/cursor.md"

HOME_AGENTS="$HOME/AGENTS.md"
CODEX_AGENTS="$HOME/.codex/AGENTS.md"
CLAUDE_FILE="$HOME/.claude/CLAUDE.md"
CURSOR_RULES_DIR="$HOME/.cursor/rules"
PROJECT_TEMPLATE_DEST="$HOME/Templates/AGENTS.project-template.md"
NON_CRYPTO_REGISTRY="$PROJECT_ROOT/dist/skills/registry.non-crypto.tsv"

timestamp() {
  date +%Y%m%d%H%M%S
}

log() {
  printf '%s\n' "$*"
}

backup_if_exists() {
  local target="$1"
  if [[ -f "$target" ]]; then
    cp -p "$target" "${target}.bak.$(timestamp)"
    log "[ OK ] Backup created: ${target}.bak.*"
  fi
}

install_with_backup() {
  local src="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  backup_if_exists "$dest"
  cp -p "$src" "$dest"
  log "[ OK ] Installed: $dest"
}

build_non_crypto_registry() {
  local src="$PROJECT_ROOT/skills/registry.tsv"
  mkdir -p "$(dirname "$NON_CRYPTO_REGISTRY")"

  awk -F'\t' '
    BEGIN {
      OFS="\t"
    }
    NR == 1 {
      print $0
      next
    }
    {
      line = tolower($0)
      if (line ~ /solana|crypto|web3|defi|evm|memecoin|pumpfun|onchain|token-launch|sniper/) {
        next
      }
      print $0
    }
  ' "$src" > "$NON_CRYPTO_REGISTRY"

  log "[ OK ] Built non-crypto registry: $NON_CRYPTO_REGISTRY"
}

main() {
  log "[INFO] Building rule artifacts..."
  "$PROJECT_ROOT/scripts/build-rule-artifacts.sh" all

  if [[ ! -f "$SRC_CODEX" || ! -f "$SRC_CLAUDE" || ! -f "$SRC_CURSOR_LEAN" || ! -f "$SRC_CURSOR_FULL" ]]; then
    log "[ERR ] Missing built artifacts in dist/rules/"
    exit 1
  fi

  log "[INFO] Installing Codex and Claude rule files..."
  install_with_backup "$SRC_CODEX" "$HOME_AGENTS"
  install_with_backup "$SRC_CLAUDE" "$CLAUDE_FILE"

  if install_with_backup "$SRC_CODEX" "$CODEX_AGENTS" 2>/dev/null; then
    :
  else
    log "[WARN] Could not write $CODEX_AGENTS (permission restricted in this environment)."
  fi

  log "[INFO] Installing Cursor rules..."
  install_with_backup "$SRC_CURSOR_LEAN" "$CURSOR_RULES_DIR/gotcha.mdc"
  install_with_backup "$SRC_CURSOR_FULL" "$CURSOR_RULES_DIR/gotcha-full.mdc"

  log "[INFO] Installing project template..."
  install_with_backup "$PROJECT_ROOT/templates/project-agents.md" "$PROJECT_TEMPLATE_DEST"

  log "[INFO] Generating non-crypto skills registry..."
  build_non_crypto_registry

  log "[DONE] Linux Mint baseline initialized."
  log "       Rules: $HOME_AGENTS, $CLAUDE_FILE, $CURSOR_RULES_DIR/"
  log "       Template: $PROJECT_TEMPLATE_DEST"
  log "       Registry: $NON_CRYPTO_REGISTRY"
}

main "$@"
