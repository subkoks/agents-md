#!/bin/bash
# Persist a bounded session summary record at stop-phase (end of turn/session).
# Appends one JSON object per call to logs/telemetry/telemetry.jsonl so sessions
# can be replayed/analyzed without retaining full transcripts.
#
# See docs/hook-runtime-profiles.md.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

SESSION=""
TURNS="0"
TOOLS="0"
STATUS="ok"
NOTE=""
OUT_DIR="$PROJECT_ROOT/logs/telemetry"
ECHO_RECORD=0
NOTE_MAX=200

show_help() {
  cat <<'EOF'
Usage: scripts/session-telemetry.sh --session ID [OPTIONS]

Append a bounded session-summary record to logs/telemetry/telemetry.jsonl.

Options:
  --session ID    Session identifier (required)
  --turns N       Turn count (default: 0)
  --tools N       Tool-call count (default: 0)
  --status S      Outcome: ok | error | aborted (default: ok)
  --note TEXT     Short free-text note (truncated to 200 chars)
  --dir PATH      Output directory (default: logs/telemetry)
  --stdout        Also print the record to stdout
  -h, --help      Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --session) SESSION="${2:-}"; shift 2 ;;
    --turns) TURNS="${2:-}"; shift 2 ;;
    --tools) TOOLS="${2:-}"; shift 2 ;;
    --status) STATUS="${2:-}"; shift 2 ;;
    --note) NOTE="${2:-}"; shift 2 ;;
    --dir) OUT_DIR="${2:-}"; shift 2 ;;
    --stdout) ECHO_RECORD=1; shift ;;
    -h|--help) show_help; exit 0 ;;
    *) printf '%s\n' "[ERR ] Unknown option: $1" >&2; show_help; exit 2 ;;
  esac
done

[[ -n "$SESSION" ]] || { printf '%s\n' "[ERR ] --session is required" >&2; exit 2; }
case "$STATUS" in ok|error|aborted) ;; *) printf '%s\n' "[ERR ] Invalid --status: $STATUS" >&2; exit 2 ;; esac
[[ "$TURNS" =~ ^[0-9]+$ ]] || { printf '%s\n' "[ERR ] --turns must be a non-negative integer" >&2; exit 2; }
[[ "$TOOLS" =~ ^[0-9]+$ ]] || { printf '%s\n' "[ERR ] --tools must be a non-negative integer" >&2; exit 2; }

# Bound and sanitize the note (cap length, strip control chars, escape JSON).
NOTE="$(printf '%s' "$NOTE" | tr -d '\000-\037' | cut -c1-"$NOTE_MAX")"
json_escape() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }

TS="$(date -u +%FT%TZ)"
RECORD="$(printf '{"ts":"%s","session":"%s","turns":%s,"tools":%s,"status":"%s","note":"%s"}' \
  "$TS" "$(json_escape "$SESSION")" "$TURNS" "$TOOLS" "$STATUS" "$(json_escape "$NOTE")")"

mkdir -p "$OUT_DIR"
printf '%s\n' "$RECORD" >> "$OUT_DIR/telemetry.jsonl"

if [[ "$ECHO_RECORD" -eq 1 ]]; then
  printf '%s\n' "$RECORD"
else
  printf '%s\n' "[ OK ] Recorded session '$SESSION' -> $OUT_DIR/telemetry.jsonl"
fi
