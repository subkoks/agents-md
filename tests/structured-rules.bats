#!/usr/bin/env bats
# build-structured-rules.sh + query-rules.sh: structured rule artifacts behaviour.

load helpers/setup

setup() {
  SB="$(make_sandbox)"
  BUILD="$SB/scripts/build-structured-rules.sh"
  QUERY="$SB/scripts/query-rules.sh"
  JSON="$SB/dist/rules/gotcha.rules.json"
  TSV="$SB/dist/rules/gotcha.rules.tsv"
}

@test "build writes both artifacts with rules" {
  run "$BUILD"
  [ "$status" -eq 0 ]
  [ -f "$JSON" ]
  [ -f "$TSV" ]
  [ "$(grep -c '"id":' "$JSON")" -gt 0 ]
}

@test "json declares the schema and rule_count matches actual rules" {
  "$BUILD" >/dev/null
  grep -q '"schema": "gotcha-rules/v1"' "$JSON"
  local declared actual
  declared="$(grep -oE '"rule_count": [0-9]+' "$JSON" | grep -oE '[0-9]+')"
  actual="$(grep -c '"id":' "$JSON")"
  [ "$declared" -eq "$actual" ]
}

@test "generated ids are unique and well-formed" {
  "$BUILD" >/dev/null
  local total uniq
  total="$(grep -oE '"id": "[a-z0-9-]+-[0-9]{3}"' "$JSON" | wc -l | tr -d ' ')"
  uniq="$(grep -oE '"id": "[a-z0-9-]+-[0-9]{3}"' "$JSON" | LC_ALL=C sort -u | wc -l | tr -d ' ')"
  [ "$total" -gt 0 ]
  [ "$total" -eq "$uniq" ]
}

@test "generation is deterministic (--check passes after build)" {
  "$BUILD" >/dev/null
  run "$BUILD" --check
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "in sync"
}

@test "--check fails when an artifact is missing" {
  "$BUILD" >/dev/null
  rm -f "$JSON"
  run "$BUILD" --check
  [ "$status" -ne 0 ]
  echo "$output" | grep -q "Missing artifact"
}

@test "--check fails on drift (exit non-zero)" {
  "$BUILD" >/dev/null
  printf '\n' >> "$JSON"
  run "$BUILD" --check
  [ "$status" -ne 0 ]
  echo "$output" | grep -q "Drift detected"
}

@test "--stdout prints json and writes nothing" {
  rm -f "$JSON" "$TSV"
  run "$BUILD" --stdout
  [ "$status" -eq 0 ]
  echo "$output" | grep -q '"schema": "gotcha-rules/v1"'
  [ ! -f "$JSON" ]
  [ ! -f "$TSV" ]
}

@test "every hard-stop rule is critical severity" {
  "$BUILD" >/dev/null
  # column 2 = type, column 3 = severity
  run awk -F'\t' 'NR>1 && $2=="hard-stop" && $3!="critical"' "$TSV"
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "missing source aborts" {
  rm -f "$SB/src/gotcha.md"
  run "$BUILD"
  [ "$status" -ne 0 ]
  echo "$output" | grep -q "Rule source missing"
}

@test "query builds artifact on demand when absent" {
  rm -f "$JSON" "$TSV"
  run "$QUERY" --type hard-stop --format ids
  [ "$status" -eq 0 ]
  [ -f "$TSV" ]
  echo "$output" | grep -q "hard-stop-001"
}

@test "query --severity critical count equals hard-stop count" {
  "$BUILD" >/dev/null
  local crit hs
  crit="$("$QUERY" --severity critical --format count)"
  hs="$(awk -F'\t' 'NR>1 && $2=="hard-stop"' "$TSV" | wc -l | tr -d ' ')"
  [ "$crit" -eq "$hs" ]
  [ "$crit" -gt 0 ]
}

@test "query filters AND together" {
  "$BUILD" >/dev/null
  run "$QUERY" --type policy --grep secret --format ids
  [ "$status" -eq 0 ]
  [ -n "$output" ]
  # every matched id must be a policy rule in the tsv
  while read -r id; do
    [ -n "$id" ] || continue
    awk -F'\t' -v i="$id" 'NR>1 && $1==i && $2=="policy"{found=1} END{exit !found}' "$TSV"
  done <<< "$output"
}

@test "query with no matches exits 0" {
  "$BUILD" >/dev/null
  run "$QUERY" --grep zzzznotarule --format count
  [ "$status" -eq 0 ]
  [ "$output" -eq 0 ]
}
