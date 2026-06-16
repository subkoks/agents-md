#!/bin/bash
# Query the structured rule artifact (dist/rules/gotcha.rules.tsv).
#
# Dependency-free (awk over the generated TSV) so it runs anywhere the build
# does. Builds the artifact on demand if it is missing.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TSV="$PROJECT_ROOT/dist/rules/gotcha.rules.tsv"

F_TYPE=""
F_SEV=""
F_SECTION=""
F_TAG=""
F_GREP=""
FORMAT="table"

show_help() {
  cat <<'EOF'
Usage: scripts/query-rules.sh [FILTERS] [--format table|tsv|count|ids]

Query structured GOTCHA rules. Filters AND together; all are case-insensitive
substring matches except --severity/--type which match exactly.

Filters:
  --type TYPE          hard-stop | policy | style | guideline
  --severity SEV       critical | high | medium | info
  --section TEXT       section/subsection name substring
  --tag TAG            tag slug substring
  --grep TEXT          rule text substring
  --format FMT         table (default) | tsv | count | ids

Examples:
  scripts/query-rules.sh --severity critical
  scripts/query-rules.sh --type policy --grep secret
  scripts/query-rules.sh --tag git --format ids
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) show_help; exit 0 ;;
    --type) F_TYPE="${2:-}"; shift 2 ;;
    --severity) F_SEV="${2:-}"; shift 2 ;;
    --section) F_SECTION="${2:-}"; shift 2 ;;
    --tag) F_TAG="${2:-}"; shift 2 ;;
    --grep) F_GREP="${2:-}"; shift 2 ;;
    --format) FORMAT="${2:-}"; shift 2 ;;
    *) printf '%s\n' "[ERR ] Unknown option: $1" >&2; show_help; exit 1 ;;
  esac
done

case "$FORMAT" in
  table|tsv|count|ids) ;;
  *) printf '%s\n' "[ERR ] Unknown format: $FORMAT" >&2; exit 1 ;;
esac

if [[ ! -f "$TSV" ]]; then
  "$SCRIPT_DIR/build-structured-rules.sh" >/dev/null
fi

# The tag column is not in the TSV; reconstruct a searchable haystack from
# section+subsection slugs for --tag (mirrors the JSON tag derivation).
awk -F'\t' \
  -v ftype="$F_TYPE" -v fsev="$F_SEV" -v fsection="$F_SECTION" \
  -v ftag="$F_TAG" -v fgrep="$F_GREP" -v fmt="$FORMAT" '
  function lc(s) { return tolower(s) }
  function slug(s,   r) {
    r = tolower(s); gsub(/[^a-z0-9]+/, "-", r)
    gsub(/^-+|-+$/, "", r); return r
  }
  NR == 1 { next }   # header
  {
    id = $1; type = $2; sev = $3; section = $4; subsection = $5; text = $6
    if (ftype != "" && type != ftype) next
    if (fsev  != "" && sev  != fsev)  next
    if (fsection != "" && index(lc(section " " subsection), lc(fsection)) == 0) next
    if (fgrep != "" && index(lc(text), lc(fgrep)) == 0) next
    if (ftag != "") {
      hay = slug(section) " " slug(subsection)
      if (index(hay, lc(ftag)) == 0) next
    }
    matched++
    if (fmt == "ids")  { print id; next }
    if (fmt == "tsv")  { print $0; next }
    if (fmt == "table") {
      loc = section
      if (subsection != "") loc = loc " / " subsection
      printf "%-26s %-9s %-9s %s\n", id, sev, type, text
      next
    }
  }
  END {
    matched = matched + 0
    if (fmt == "count") print matched
    else if (matched == 0) print "[INFO] no rules matched" > "/dev/stderr"
  }
' "$TSV"
