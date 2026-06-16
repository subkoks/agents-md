#!/bin/bash
# Compute deterministic execution waves for a task DAG: each wave is the set of
# tasks whose dependencies are all satisfied by prior waves, so independent tasks
# run together. Detects cycles and dangling dependencies.
#
# Implements the scheduling core of docs/orchestration-dag-spec.md (parser +
# cycle checks + wave scheduler). Locking/budget/quality-gate are runtime concerns
# left to the orchestrator that consumes these waves.

set -euo pipefail

MANIFEST=""
FORMAT="text"

show_help() {
  cat <<'EOF'
Usage: scripts/dag-schedule.sh --manifest FILE [--format text|json]

Compute execution waves (topological levels) for a task DAG.

Manifest: tab-separated, lines `taskId<TAB>deps`, where deps is a comma-separated
list of taskIds or `-` for none. `#` comment lines and blanks are ignored.

Options:
  --manifest FILE  Task manifest TSV (required)
  --format FMT     Output format: text | json (default: text)
  -h, --help       Show this help

Exit codes:
  0 schedulable   2 usage error   3 missing/dangling dependency   4 cycle detected
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --manifest) MANIFEST="${2:-}"; shift 2 ;;
    --format) FORMAT="${2:-}"; shift 2 ;;
    -h|--help) show_help; exit 0 ;;
    *) printf '%s\n' "[ERR ] Unknown option: $1" >&2; show_help; exit 2 ;;
  esac
done

[[ -n "$MANIFEST" ]] || { printf '%s\n' "[ERR ] --manifest is required" >&2; exit 2; }
[[ -f "$MANIFEST" ]] || { printf '%s\n' "[ERR ] Manifest not found: $MANIFEST" >&2; exit 2; }
case "$FORMAT" in text|json) ;; *) printf '%s\n' "[ERR ] Invalid --format: $FORMAT" >&2; exit 2 ;; esac

# Emit one line per wave: "<index>\t<space-separated taskIds>".
# Exit 3 on dangling dep, 4 on cycle (awk exit propagates).
set +e
WAVES="$(awk -F'\t' '
  function trim(s){ gsub(/^[ \t\r]+|[ \t\r]+$/,"",s); return s }
  !/^[ \t]*#/ {
    id=trim($1)
    if(id=="") next
    if(!(id in seen)){ seen[id]=1; order[++n]=id; idcount++ }
    deps[id]=(NF>=2 ? trim($2) : "-")
  }
  END{
    # Build in-degree and reverse adjacency; validate dependencies exist.
    for(k=1;k<=n;k++){ indeg[order[k]]=0 }
    for(k=1;k<=n;k++){
      id=order[k]
      if(deps[id]=="-" || deps[id]=="") continue
      m=split(deps[id], d, ",")
      for(i=1;i<=m;i++){
        dep=trim(d[i]); if(dep=="" || dep=="-") continue
        if(!(dep in seen)){ printf("[ERR ] Dangling dependency: %s -> %s\n", id, dep) > "/dev/stderr"; derr=1; continue }
        indeg[id]++
        radj[dep]=radj[dep] id "\n"
      }
    }
    if(derr) exit 3

    remaining=idcount; wave=0
    for(;;){
      cnt=0; delete cur
      for(k=1;k<=n;k++){ id=order[k]; if(!(id in done) && indeg[id]==0){ cur[++cnt]=id } }
      if(cnt==0) break
      line=""
      for(j=1;j<=cnt;j++){ id=cur[j]; done[id]=1; line=line (j>1?" ":"") id }
      printf("%d\t%s\n", wave, line)
      for(j=1;j<=cnt;j++){
        id=cur[j]
        m=split(radj[id], dd, "\n")
        for(i=1;i<=m;i++){ x=trim(dd[i]); if(x!="") indeg[x]-- }
      }
      remaining-=cnt; wave++
    }
    if(remaining>0){ print "[ERR ] Cycle detected among unscheduled tasks" > "/dev/stderr"; exit 4 }
  }
' "$MANIFEST")"
awk_status=$?
set -e
[[ $awk_status -eq 0 ]] || exit "$awk_status"

if [[ "$FORMAT" == "json" ]]; then
  printf '{\n  "waves": [\n'
  first=1
  while IFS=$'\t' read -r idx tasks; do
    [[ -z "$idx" ]] && continue
    [[ "$first" -eq 1 ]] && first=0 || printf ',\n'
    printf '    ['
    tfirst=1
    for t in $tasks; do
      [[ "$tfirst" -eq 1 ]] && tfirst=0 || printf ', '
      printf '"%s"' "$t"
    done
    printf ']'
  done <<< "$WAVES"
  printf '\n  ]\n}\n'
else
  if [[ -z "$WAVES" ]]; then
    printf '%s\n' "[INFO] No tasks to schedule"
  else
    while IFS=$'\t' read -r idx tasks; do
      [[ -z "$idx" ]] && continue
      printf 'wave %s: %s\n' "$idx" "$tasks"
    done <<< "$WAVES"
  fi
fi
