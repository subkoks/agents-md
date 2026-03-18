#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_FILE="${1:-${ROOT_DIR}/sniper-config.yaml}"

pass_count=0
warn_count=0
fail_count=0

pass() {
  printf 'PASS: %s\n' "$1"
  pass_count=$((pass_count + 1))
}

warn() {
  printf 'WARN: %s\n' "$1"
  warn_count=$((warn_count + 1))
}

fail() {
  printf 'FAIL: %s\n' "$1"
  fail_count=$((fail_count + 1))
}

check_cmd() {
  local cmd="$1"
  if command -v "$cmd" >/dev/null 2>&1; then
    pass "Dependency available: ${cmd}"
  else
    fail "Missing dependency: ${cmd}"
  fi
}

check_file() {
  local file="$1"
  if [[ -f "$file" ]]; then
    pass "Found file: ${file}"
  else
    fail "Missing file: ${file}"
  fi
}

check_grep() {
  local pattern="$1"
  local message="$2"
  if grep -Eq "$pattern" "$CONFIG_FILE"; then
    pass "$message"
  else
    fail "$message"
  fi
}

echo "Running pump.fun sniper preflight"
echo "Root: ${ROOT_DIR}"
echo "Config: ${CONFIG_FILE}"

echo
check_cmd awk
check_cmd grep
check_cmd sed

echo
check_file "${ROOT_DIR}/scripts/sniper-config-template.yaml"
check_file "${ROOT_DIR}/docs/sniper-runbook.md"
check_file "$CONFIG_FILE"

if [[ -f "$CONFIG_FILE" ]]; then
  echo
  check_grep '^profile:' 'Config contains profile'
  check_grep '^\s*chain:\s*solana' 'Config chain is Solana'
  check_grep '^\s*mode:\s*(live|paper)' 'Execution mode is declared'
  check_grep '^\s*maxSlippageBps:\s*[0-9]+' 'Risk maxSlippageBps is set'
  check_grep '^\s*maxNotionalPerTradeUsd:\s*[0-9]+' 'Risk maxNotionalPerTradeUsd is set'
  check_grep '^\s*maxDailyDrawdownPct:\s*[0-9]+' 'Risk maxDailyDrawdownPct is set'
  check_grep '^\s*killSwitchOnConsecutiveFailures:\s*[0-9]+' 'Kill-switch threshold is set'

  if grep -Eq '^\s*useDedicatedTradingWallet:\s*true' "$CONFIG_FILE"; then
    pass 'Dedicated trading wallet is enabled'
  else
    fail 'Dedicated trading wallet must be enabled (useDedicatedTradingWallet: true)'
  fi

  if grep -Eq '^\s*tradingWalletPubkey:\s*"REPLACE_ME"' "$CONFIG_FILE"; then
    fail 'Replace placeholder tradingWalletPubkey before live usage'
  elif grep -Eq '^\s*tradingWalletPubkey:\s*".+"' "$CONFIG_FILE"; then
    pass 'Trading wallet pubkey appears configured'
  else
    fail 'Trading wallet pubkey is missing or malformed'
  fi

  if grep -Eq '^\s*webhookUrl:\s*""' "$CONFIG_FILE"; then
    warn 'Alerts webhookUrl is empty (acceptable if alerts.enabled=false)'
  fi

  if grep -Eq '^\s*mode:\s*live' "$CONFIG_FILE"; then
    warn 'Execution mode is live; ensure dry run was completed'
  fi
fi

echo
printf 'Summary: PASS=%d WARN=%d FAIL=%d\n' "$pass_count" "$warn_count" "$fail_count"

if (( fail_count > 0 )); then
  exit 1
fi

exit 0
