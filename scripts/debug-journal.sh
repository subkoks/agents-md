#!/bin/bash
# Structured hypothesis tracking for systematic debugging. Records hypotheses and
# their outcomes per session so a debugging effort is auditable and resumable,
# and renders a markdown or JSON report.
#
# Implements the hypothesis-tracking workflow in docs/debugging-workflows.md.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

MODE=""
SESSION=""
HYPOTHESIS=""
TEST_PLAN=""
SEQ=""
RESULT=""
EVIDENCE=""
FORMAT="markdown"
OUT_DIR="$PROJECT_ROOT/logs/debug"

show_help() {
  cat <<'EOF'
Usage: scripts/debug-journal.sh <add|resolve|report> [OPTIONS]

Track debugging hypotheses and outcomes per session.

Modes:
  add       Record a new hypothesis (status: pending)
  resolve   Set the outcome of a hypothesis by sequence number
  report    Render the session journal (markdown default, or --format json)

Options:
  --session ID       Debug session identifier (required)
  --hypothesis TEXT  Hypothesis statement (add)
  --test TEXT        How the hypothesis will be tested (add)
  --seq N            Hypothesis sequence number (resolve)
  --result R         Outcome: confirmed | refuted (resolve)
  --evidence TEXT    What was found (resolve)
  --format FMT       report format: markdown | json (default: markdown)
  --dir PATH         Journal directory (default: logs/debug)
  -h, --help         Show this help
EOF
}

if [[ $# -gt 0 && "$1" != -* ]]; then MODE="$1"; shift; fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --session) SESSION="${2:-}"; shift 2 ;;
    --hypothesis) HYPOTHESIS="${2:-}"; shift 2 ;;
    --test) TEST_PLAN="${2:-}"; shift 2 ;;
    --seq) SEQ="${2:-}"; shift 2 ;;
    --result) RESULT="${2:-}"; shift 2 ;;
    --evidence) EVIDENCE="${2:-}"; shift 2 ;;
    --format) FORMAT="${2:-}"; shift 2 ;;
    --dir) OUT_DIR="${2:-}"; shift 2 ;;
    -h|--help) show_help; exit 0 ;;
    *) printf '%s\n' "[ERR ] Unknown option: $1" >&2; show_help; exit 2 ;;
  esac
done

case "$MODE" in add|resolve|report) ;; *) printf '%s\n' "[ERR ] Mode must be add|resolve|report" >&2; show_help; exit 2 ;; esac
[[ -n "$SESSION" ]] || { printf '%s\n' "[ERR ] --session is required" >&2; exit 2; }

# Sanitize session into a safe filename; strip tabs/newlines from free text.
slug="$(printf '%s' "$SESSION" | tr -c 'A-Za-z0-9_-' '_')"
JOURNAL="$OUT_DIR/$slug.tsv"
clean() { printf '%s' "$1" | tr '\t\n\r' '   '; }

case "$MODE" in
  add)
    [[ -n "$HYPOTHESIS" ]] || { printf '%s\n' "[ERR ] --hypothesis is required for add" >&2; exit 2; }
    mkdir -p "$OUT_DIR"
    local_seq=1
    if [[ -f "$JOURNAL" ]]; then
      local_seq=$(($(wc -l < "$JOURNAL" | tr -d ' ') + 1))
    fi
    printf '%s\t%s\t%s\t%s\t%s\t%s\n' \
      "$local_seq" "$(date -u +%FT%TZ)" "pending" "$(clean "$HYPOTHESIS")" "$(clean "$TEST_PLAN")" "" >> "$JOURNAL"
    printf '%s\n' "[ OK ] Recorded hypothesis #$local_seq in session '$SESSION'"
    ;;

  resolve)
    [[ -f "$JOURNAL" ]] || { printf '%s\n' "[ERR ] No journal for session '$SESSION'" >&2; exit 3; }
    [[ "$SEQ" =~ ^[0-9]+$ ]] || { printf '%s\n' "[ERR ] --seq must be a number" >&2; exit 2; }
    case "$RESULT" in confirmed|refuted) ;; *) printf '%s\n' "[ERR ] --result must be confirmed|refuted" >&2; exit 2 ;; esac
    grep -qE "^$SEQ"$'\t' "$JOURNAL" || { printf '%s\n' "[ERR ] No hypothesis #$SEQ in session '$SESSION'" >&2; exit 3; }
    tmp="$(mktemp)"
    awk -F'\t' -v seq="$SEQ" -v res="$RESULT" -v ev="$(clean "$EVIDENCE")" 'BEGIN{OFS="\t"}
      $1==seq { $3=res; $6=ev } { print }' "$JOURNAL" > "$tmp"
    mv "$tmp" "$JOURNAL"
    printf '%s\n' "[ OK ] Hypothesis #$SEQ -> $RESULT"
    ;;

  report)
    [[ -f "$JOURNAL" ]] || { printf '%s\n' "[INFO] No journal for session '$SESSION'" >&2; exit 3; }
    if [[ "$FORMAT" == "json" ]]; then
      esc() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }
      printf '{\n  "session": "%s",\n  "hypotheses": [\n' "$(esc "$SESSION")"
      first=1
      while IFS=$'\t' read -r seq ts status title test ev; do
        [[ -z "$seq" ]] && continue
        [[ "$first" -eq 1 ]] && first=0 || printf ',\n'
        printf '    {"seq":%s,"ts":"%s","status":"%s","hypothesis":"%s","test":"%s","evidence":"%s"}' \
          "$seq" "$ts" "$status" "$(esc "$title")" "$(esc "$test")" "$(esc "$ev")"
      done < "$JOURNAL"
      printf '\n  ]\n}\n'
    else
      printf '# Debug journal: %s\n\n' "$SESSION"
      printf '| # | Status | Hypothesis | Test | Evidence |\n| --- | --- | --- | --- | --- |\n'
      while IFS=$'\t' read -r seq ts status title test ev; do
        [[ -z "$seq" ]] && continue
        : "$ts"
        printf '| %s | %s | %s | %s | %s |\n' "$seq" "$status" "$title" "${test:-—}" "${ev:-—}"
      done < "$JOURNAL"
    fi
    ;;
esac
