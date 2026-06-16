#!/bin/bash
# Resolve which hooks are enabled for a given runtime profile, without editing
# hook files. Profiles are cumulative: minimal ⊂ standard ⊂ strict. The
# DISABLED_HOOKS env var (comma-separated hook names) force-disables hooks for
# temporary, traceable suppression.
#
# See docs/hook-runtime-profiles.md and hooks/manifest.tsv.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

PROFILE="standard"
MANIFEST="$PROJECT_ROOT/hooks/manifest.tsv"
FORMAT="text"
LIST_ALL=0

show_help() {
  cat <<'EOF'
Usage: scripts/hook-profile.sh [OPTIONS]

Resolve enabled hooks for a runtime profile.

Options:
  --profile P     Profile tier: minimal | standard | strict (default: standard)
  --manifest F    Path to the hook manifest TSV (default: hooks/manifest.tsv)
  --format FMT    Output format: text | json (default: text)
  --list-all      List every hook with its enabled/disabled state
  -h, --help      Show this help

Environment:
  DISABLED_HOOKS  Comma-separated hook names to force-disable (e.g. "test-gate,audit-log")
EOF
}

profile_rank() {
  case "$1" in
    minimal) echo 0 ;; standard) echo 1 ;; strict) echo 2 ;;
    *) echo -1 ;;
  esac
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --profile) PROFILE="${2:-}"; shift 2 ;;
    --manifest) MANIFEST="${2:-}"; shift 2 ;;
    --format) FORMAT="${2:-}"; shift 2 ;;
    --list-all) LIST_ALL=1; shift ;;
    -h|--help) show_help; exit 0 ;;
    *) printf '%s\n' "[ERR ] Unknown option: $1" >&2; show_help; exit 2 ;;
  esac
done

[[ "$(profile_rank "$PROFILE")" -ge 0 ]] || { printf '%s\n' "[ERR ] Invalid --profile: $PROFILE" >&2; exit 2; }
case "$FORMAT" in text|json) ;; *) printf '%s\n' "[ERR ] Invalid --format: $FORMAT" >&2; exit 2 ;; esac
[[ -f "$MANIFEST" ]] || { printf '%s\n' "[ERR ] Manifest not found: $MANIFEST" >&2; exit 1; }

WANT_RANK="$(profile_rank "$PROFILE")"

is_disabled() {
  local name="$1"
  [[ -z "${DISABLED_HOOKS:-}" ]] && return 1
  local IFS=','
  local d
  for d in $DISABLED_HOOKS; do
    [[ "$(printf '%s' "$d" | tr -d '[:space:]')" == "$name" ]] && return 0
  done
  return 1
}

# Emits: name<TAB>category<TAB>mode<TAB>enabled(0|1)
resolve() {
  local name category min_profile mode deps enabled
  while IFS=$'\t' read -r name category min_profile mode deps; do
    [[ -z "$name" || "$name" == \#* ]] && continue
    : "$deps"
    enabled=0
    if [[ "$(profile_rank "$min_profile")" -ge 0 && "$(profile_rank "$min_profile")" -le "$WANT_RANK" ]] && ! is_disabled "$name"; then
      enabled=1
    fi
    printf '%s\t%s\t%s\t%s\n' "$name" "$category" "$mode" "$enabled"
  done < "$MANIFEST"
}

emit_text() {
  while IFS=$'\t' read -r name category mode enabled; do
    if [[ "$LIST_ALL" -eq 1 ]]; then
      [[ "$enabled" -eq 1 ]] && printf '%s\t%s\t%s\tenabled\n' "$name" "$category" "$mode" \
                              || printf '%s\t%s\t%s\tdisabled\n' "$name" "$category" "$mode"
    elif [[ "$enabled" -eq 1 ]]; then
      printf '%s\n' "$name"
    fi
  done
}

emit_json() {
  printf '{\n  "profile": "%s",\n  "hooks": [\n' "$PROFILE"
  local first=1 name category mode enabled b
  while IFS=$'\t' read -r name category mode enabled; do
    [[ "$LIST_ALL" -eq 0 && "$enabled" -ne 1 ]] && continue
    [[ "$enabled" -eq 1 ]] && b="true" || b="false"
    [[ "$first" -eq 1 ]] && first=0 || printf ',\n'
    printf '    {"name":"%s","category":"%s","mode":"%s","enabled":%s}' "$name" "$category" "$mode" "$b"
  done
  printf '\n  ]\n}\n'
}

if [[ "$FORMAT" == "json" ]]; then
  resolve | emit_json
else
  resolve | emit_text
fi
