#!/bin/bash
# Persist resumable working state before context compaction, and restore it after.
# Reduces context-loss regressions: a PreCompact hook calls `capture`; after
# compaction the agent reads `restore` to recover branch, HEAD, dirty files, and
# an optional note.
#
# See docs/hook-runtime-profiles.md.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

MODE="capture"
NOTE=""
SESSION=""
OUT_DIR="$PROJECT_ROOT/logs/state"
ECHO_RECORD=0
NOTE_MAX=500

show_help() {
  cat <<'EOF'
Usage: scripts/precompact-capture.sh [capture|restore] [OPTIONS]

Persist (capture) or recover (restore) resumable working state across a
context compaction boundary.

Modes:
  capture   Snapshot git state + note to logs/state/ (default)
  restore   Print the most recent snapshot (JSON) for resumption

Options:
  --note TEXT   Short context note to store (capture; truncated to 500 chars)
  --session ID  Session identifier to tag the snapshot (capture)
  --dir PATH    State directory (default: logs/state)
  --stdout      Also print the snapshot after capture
  -h, --help    Show this help

Exit codes:
  restore: 0 with JSON if a snapshot exists; 3 if none found
EOF
}

if [[ $# -gt 0 && "$1" != -* ]]; then
  MODE="$1"; shift
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --note) NOTE="${2:-}"; shift 2 ;;
    --session) SESSION="${2:-}"; shift 2 ;;
    --dir) OUT_DIR="${2:-}"; shift 2 ;;
    --stdout) ECHO_RECORD=1; shift ;;
    -h|--help) show_help; exit 0 ;;
    *) printf '%s\n' "[ERR ] Unknown option: $1" >&2; show_help; exit 2 ;;
  esac
done

case "$MODE" in capture|restore) ;; *) printf '%s\n' "[ERR ] Invalid mode: $MODE" >&2; exit 2 ;; esac

json_escape() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }

git_field() {
  # Safe git read that degrades to "unknown" outside a work tree.
  git -C "$PROJECT_ROOT" "$@" 2>/dev/null || true
}

LATEST="$OUT_DIR/latest.json"

if [[ "$MODE" == "restore" ]]; then
  if [[ ! -f "$LATEST" ]]; then
    printf '%s\n' "[INFO] No prior state snapshot in $OUT_DIR" >&2
    exit 3
  fi
  cat "$LATEST"
  exit 0
fi

# --- capture -----------------------------------------------------------------
NOTE="$(printf '%s' "$NOTE" | tr -d '\000-\037' | cut -c1-"$NOTE_MAX")"
TS="$(date -u +%FT%TZ)"
STAMP="$(date -u +%Y%m%d_%H%M%S)"
BRANCH="$(git_field rev-parse --abbrev-ref HEAD)"; BRANCH="${BRANCH:-unknown}"
HEAD_SHA="$(git_field rev-parse HEAD)"; HEAD_SHA="${HEAD_SHA:-unknown}"

# Collect changed/untracked paths (porcelain), bounded to keep the record small.
CHANGED_JSON="$(git_field status --porcelain \
  | head -100 \
  | awk '{ $1=$1; gsub(/\\/,"\\\\"); gsub(/"/,"\\\""); printf "%s\"%s\"", (NR>1?",":""), $0 }')"

mkdir -p "$OUT_DIR"
RECORD="$(printf '{"ts":"%s","session":"%s","branch":"%s","head":"%s","changed":[%s],"note":"%s"}' \
  "$TS" "$(json_escape "$SESSION")" "$(json_escape "$BRANCH")" "$HEAD_SHA" "$CHANGED_JSON" "$(json_escape "$NOTE")")"

printf '%s\n' "$RECORD" > "$OUT_DIR/precompact-$STAMP.json"
printf '%s\n' "$RECORD" > "$LATEST"

if [[ "$ECHO_RECORD" -eq 1 ]]; then
  printf '%s\n' "$RECORD"
else
  printf '%s\n' "[ OK ] Captured state -> $OUT_DIR/precompact-$STAMP.json (latest.json updated)"
fi
