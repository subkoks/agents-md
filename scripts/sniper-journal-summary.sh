#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
JOURNAL_FILE="${1:-${ROOT_DIR}/logs/sniper-events.jsonl}"
DATE="${2:-$(date +%Y-%m-%d)}"
OUTPUT_FORMAT="${3:-table}" # table | json

usage() {
  cat <<EOF
Usage: $0 [JOURNAL_FILE] [DATE] [OUTPUT_FORMAT]

Arguments:
  JOURNAL_FILE   Path to jsonl journal (default: logs/sniper-events.jsonl)
  DATE           Date to summarize (YYYY-MM-DD, default: today)
  OUTPUT_FORMAT  table (default) | json

Examples:
  $0
  $0 logs/sniper-events.jsonl 2026-03-18
  $0 logs/sniper-events.jsonl 2026-03-18 json
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ ! -f "$JOURNAL_FILE" ]]; then
  echo "ERROR: Journal file not found: $JOURNAL_FILE"
  usage
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "ERROR: jq is required but not installed"
  exit 1
fi

# Extract events for the target date
events=$(mktemp)
trap 'rm -f "$events"' EXIT

jq -r --arg date "$DATE" '
  select(.timestamp | startswith($date)) |
  {
    type: .type,
    timestamp: .timestamp,
    token: .token // "",
    side: .side // "",
    amount: .amount // 0,
    priceUsd: .priceUsd // 0,
    valueUsd: .valueUsd // 0,
    slippageBps: .slippageBps // 0,
    status: .status // "",
    error: .error // ""
  }
' "$JOURNAL_FILE" > "$events"

if [[ ! -s "$events" ]]; then
  echo "No events found for date: $DATE"
  exit 0
fi

# Compute metrics
metrics=$(jq -s '
  map(select(.type == "trade")) as $trades |
  map(select(.type == "error")) as $errors |
  {
    totalTrades: ($trades | length),
    successfulTrades: ($trades | map(select(.status == "success")) | length),
    failedTrades: ($trades | map(select(.status == "failed")) | length),
    totalValueUsd: ($trades | map(.valueUsd) | add),
    totalSlippageBps: ($trades | map(.slippageBps) | add),
    avgSlippageBps: (
      if ($trades | length) > 0 then
        ($trades | map(.slippageBps) | add) / ($trades | length)
      else 0 end
    ),
    errors: ($errors | group_by(.error) | map({reason: .[0].error, count: length})),
    buyVolumeUsd: ($trades | map(select(.side == "buy") | .valueUsd) | add),
    sellVolumeUsd: ($trades | map(select(.side == "sell") | .valueUsd) | add),
    maxTradeValueUsd: (
      if ($trades | length) > 0 then
        ($trades | map(.valueUsd) | max)
      else 0 end
    ),
    minTradeValueUsd: (
      if ($trades | length) > 0 then
        ($trades | map(.valueUsd) | min)
      else 0 end
    )
  }
' "$events")

# Output
if [[ "$OUTPUT_FORMAT" == "json" ]]; then
  echo "$metrics"
else
  # Table format
  jq -r '
    "=== Sniper Summary for '"$DATE"' ===",
    "",
    "Trades:",
    "  Total:           \(.totalTrades)",
    "  Successful:      \(.successfulTrades)",
    "  Failed:          \(.failedTrades)",
    "",
    "Volume (USD):",
    "  Total:           \(.totalValueUsd | . * 100 | round / 100)",
    "  Buy:             \(.buyVolumeUsd | . * 100 | round / 100)",
    "  Sell:            \(.sellVolumeUsd | . * 100 | round / 100)",
    "",
    "Trade Size (USD):",
    "  Max:             \(.maxTradeValueUsd | . * 100 | round / 100)",
    "  Min:             \(.minTradeValueUsd | . * 100 | round / 100)",
    "",
    "Slippage (bps):",
    "  Total:           \(.totalSlippageBps)",
    "  Average:         \(.avgSlippageBps | . * 100 | round / 100)",
    "",
    "Errors:",
    (.errors | map("  \(.reason): \(.count)") | join("\n")),
    "",
    "Success Rate:     \(
      if (.totalTrades) > 0 then
        (.successfulTrades / .totalTrades * 100 | . * 100 | round / 100)
      else 0 end
    )%"
  ' "$metrics"
fi
