#!/bin/bash
# Dry-run or apply prune for old phase2 quarantine batches.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

APPLY=0
DAYS="${DAYS:-7}"
ROOT="$PROJECT_ROOT/logs/quarantine"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --apply)
      APPLY=1
      shift
      ;;
    --days)
      DAYS="${2:?Missing value for --days}"
      shift 2
      ;;
    *)
      echo "Usage: $0 [--apply] [--days N]"
      exit 1
      ;;
  esac
done

[[ -d "$ROOT" ]] || { echo "No quarantine root: $ROOT"; exit 0; }

targets_file="$(mktemp)"
trap 'rm -f "$targets_file"' EXIT
find "$ROOT" -type d -name 'phase2-*' -mtime +"$DAYS" | sort > "$targets_file"
count="$(wc -l < "$targets_file" | tr -d ' ')"
echo "Phase2 batches older than $DAYS days: $count"

if [[ "$count" -eq 0 ]]; then
  exit 0
fi

sed -n '1,200p' "$targets_file"

if [[ "$APPLY" -ne 1 ]]; then
  echo "Dry run only. Re-run with --apply to delete."
  exit 0
fi

while IFS= read -r d; do
  [[ -z "$d" ]] && continue
  rm -rf "$d"
  echo "deleted: $d"
done < "$targets_file"
