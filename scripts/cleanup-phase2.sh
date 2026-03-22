#!/bin/bash
# Classify and optionally quarantine repository-local cleanup candidates.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

APPLY=0
RETENTION_DAYS="${RETENTION_DAYS:-30}"
TODAY="$(date +%F)"
STAMP="$(date +%Y%m%d_%H%M%S)"
QROOT="$PROJECT_ROOT/logs/quarantine/$TODAY/phase2-$STAMP"
MANIFEST="$QROOT/manifest.tsv"
RESTORE_SCRIPT="$QROOT/restore.sh"
TMP_CANDIDATES="$(mktemp)"
trap 'rm -f "$TMP_CANDIDATES"' EXIT

while [[ $# -gt 0 ]]; do
  case "$1" in
    --apply)
      APPLY=1
      shift
      ;;
    --retention-days)
      RETENTION_DAYS="${2:?Missing value for --retention-days}"
      shift 2
      ;;
    *)
      echo "Usage: $0 [--apply] [--retention-days N]"
      exit 1
      ;;
  esac
done

add_candidate() {
  local kind="$1"
  local reason="$2"
  local path="$3"
  [[ -e "$path" || -L "$path" ]] || return 0
  printf "%s\t%s\t%s\n" "$kind" "$reason" "$path" >> "$TMP_CANDIDATES"
}

# Backup artifact scan on repository-safe roots
safe_roots=(
  "$PROJECT_ROOT/docs"
  "$PROJECT_ROOT/scripts"
  "$PROJECT_ROOT/skills"
  "$PROJECT_ROOT/dist"
  "$PROJECT_ROOT/logs"
)

for root in "${safe_roots[@]}"; do
  [[ -d "$root" ]] || continue
  while IFS= read -r file; do
    add_candidate "backup" "backup-artifact" "$file"
  done < <(find "$root" -type f \( -name "*.backup*" -o -name "*.bak" -o -name "*~" \) 2>/dev/null | sort)
done

# Duplicate generated artifact versions
if [[ -d "$PROJECT_ROOT/dist/extensions" ]]; then
  while IFS= read -r ext; do
    name="$(basename "$ext")"
    base="$(echo "$name" | sed -E 's/-[0-9].*$//')"
    version="$(echo "$name" | sed -E 's/^.*-([0-9][0-9A-Za-z\.\-]*)-(darwin-[^-]+|universal)$/\1/')"
    if [[ "$base" != "$name" ]]; then
      echo -e "$base\t$version\t$ext"
    fi
  done < <(find "$PROJECT_ROOT/dist/extensions" -mindepth 1 -maxdepth 1 -type d | sort) \
    | sort -t$'\t' -k1,1 -k2,2V \
    | awk -F'\t' '
      {
        key=$1
        entries[key]=entries[key] ? entries[key] ORS $0 : $0
        count[key]++
      }
      END {
        for (k in count) {
          if (count[k] > 1) {
            n=split(entries[k], arr, ORS)
            for (i=1; i<n; i++) {
              split(arr[i], parts, "\t")
              print parts[3]
            }
          }
        }
      }' | while IFS= read -r stale_ext; do
          [[ -n "$stale_ext" ]] && add_candidate "extension" "duplicate-version" "$stale_ext"
        done
fi

# Obsolete repository artifacts
if [[ -d "$PROJECT_ROOT/logs" ]]; then
  while IFS= read -r file; do
    add_candidate "stale" "old-log" "$file"
  done < <(find "$PROJECT_ROOT/logs" -type f -mtime +"$RETENTION_DAYS" 2>/dev/null | sort)
fi
if [[ -d "$PROJECT_ROOT/dist" ]]; then
  while IFS= read -r file; do
    add_candidate "stale" "old-dist-artifact" "$file"
  done < <(find "$PROJECT_ROOT/dist" -type f -mtime +"$RETENTION_DAYS" 2>/dev/null | sort)
fi

sort -u "$TMP_CANDIDATES" -o "$TMP_CANDIDATES"
count="$(wc -l < "$TMP_CANDIDATES" | tr -d ' ')"
echo "Candidates: $count"

if [[ "$count" -eq 0 ]]; then
  echo "No candidates found."
  exit 0
fi

if [[ "$APPLY" -ne 1 ]]; then
  echo "Dry-run listing:"
  sed -n '1,200p' "$TMP_CANDIDATES"
  echo "Re-run with --apply to quarantine candidates."
  exit 0
fi

mkdir -p "$QROOT"
printf "timestamp\tkind\treason\tsource\tdestination\n" > "$MANIFEST"

cat > "$RESTORE_SCRIPT" <<'EOF'
#!/bin/bash
set -euo pipefail
manifest="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/manifest.tsv"
tail -n +2 "$manifest" | while IFS=$'\t' read -r _ts _kind _reason src dst; do
  if [[ -e "$dst" || -L "$dst" ]]; then
    mkdir -p "$(dirname "$src")"
    mv "$dst" "$src"
    echo "restored: $src"
  fi
done
EOF
chmod +x "$RESTORE_SCRIPT"

while IFS=$'\t' read -r kind reason src; do
  rel="${src#$PROJECT_ROOT/}"
  dst="$QROOT/$rel"
  mkdir -p "$(dirname "$dst")"
  if [[ -e "$src" || -L "$src" ]]; then
    mv "$src" "$dst"
    printf "%s\t%s\t%s\t%s\t%s\n" "$(date -u +%FT%TZ)" "$kind" "$reason" "$src" "$dst" >> "$MANIFEST"
    echo "quarantined: $src"
  fi
done < "$TMP_CANDIDATES"

echo "✅ Quarantine created: $QROOT"
echo "Manifest: $MANIFEST"
echo "Restore script: $RESTORE_SCRIPT"
