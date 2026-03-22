#!/bin/bash
# Compare local skills with registry and detect unmanaged additions/conflicts.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
REGISTRY="$PROJECT_ROOT/skills/registry.tsv"

if [[ ! -f "$REGISTRY" ]]; then
  echo "❌ Registry not found: $REGISTRY"
  exit 1
fi

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

registry_ids="$tmp_dir/registry_ids.txt"
local_skill_ids="$tmp_dir/local_skill_ids.txt"
active_triggers="$tmp_dir/active_triggers.txt"

awk -F'\t' 'BEGIN{OFS="\t"} !/^#/ && NF>=4 {print $1}' "$REGISTRY" | sort -u > "$registry_ids"
awk -F'\t' 'BEGIN{OFS="\t"} !/^#/ && $2=="active" && NF>=4 {print $4}' "$REGISTRY" | sort > "$active_triggers"

while IFS= read -r file; do
  base_name="$(basename "$file" .md)"
  echo "local/$base_name"
done < <(find "$PROJECT_ROOT/skills" -maxdepth 1 -name "*.md" ! -name "README.md" 2>/dev/null | sort) | sort -u > "$local_skill_ids"

echo "🧭 Skill registry drift report"
echo "Registry: $REGISTRY"
echo "Local skills path: $PROJECT_ROOT/skills"

unmanaged_count=0
while IFS= read -r sid; do
  [[ -z "$sid" ]] && continue
  if ! grep -qxF "$sid" "$registry_ids"; then
    echo "⚠️  Unmanaged local skill: $sid"
    unmanaged_count=$((unmanaged_count + 1))
  fi
done < "$local_skill_ids"

missing_count=0
while IFS= read -r sid; do
  [[ -z "$sid" ]] && continue
  if [[ "$sid" != local/* ]]; then
    continue
  fi
  if ! grep -qxF "$sid" "$local_skill_ids"; then
    echo "⚠️  Registry local entry missing file: $sid"
    missing_count=$((missing_count + 1))
  fi
done < "$registry_ids"

conflict_count=0
while IFS= read -r trig; do
  [[ -z "$trig" ]] && continue
  echo "⚠️  Active trigger conflict: $trig"
  conflict_count=$((conflict_count + 1))
done < <(sort "$active_triggers" | uniq -d)

if [[ "$unmanaged_count" -eq 0 && "$missing_count" -eq 0 && "$conflict_count" -eq 0 ]]; then
  echo "✅ Registry and installed skills are aligned."
else
  echo "⚠️  Drift found: unmanaged=$unmanaged_count, missing=$missing_count, trigger_conflicts=$conflict_count"
fi

exit 0
