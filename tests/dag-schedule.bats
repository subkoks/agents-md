#!/usr/bin/env bats
# dag-schedule.sh: topological wave scheduling + cycle/dangling detection.

load helpers/setup

setup() {
  SB="$(make_sandbox)"
  DAG="$SB/scripts/dag-schedule.sh"
  M="$BATS_TEST_TMPDIR/tasks.tsv"
}

@test "linear chain schedules one task per wave" {
  printf 'a\t-\nb\ta\nc\tb\n' > "$M"
  run "$DAG" --manifest "$M"
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "^wave 0: a$"
  echo "$output" | grep -q "^wave 1: b$"
  echo "$output" | grep -q "^wave 2: c$"
}

@test "independent tasks share wave 0" {
  printf 'a\t-\nb\t-\nc\ta,b\n' > "$M"
  run "$DAG" --manifest "$M"
  [ "$status" -eq 0 ]
  echo "$output" | grep -qE "^wave 0: a b$"
  echo "$output" | grep -qE "^wave 1: c$"
}

@test "fan-in waits for all dependencies" {
  printf 'a\t-\nb\ta\nc\t-\nd\tb,c\n' > "$M"
  run "$DAG" --manifest "$M"
  [ "$status" -eq 0 ]
  # d only appears after both b and c are scheduled
  echo "$output" | tail -1 | grep -q "d"
}

@test "example manifest schedules cleanly" {
  run "$DAG" --manifest "$SB/orchestration/tasks.example.tsv"
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "^wave 0: schema-audit ui-theme$"
}

@test "cycle is detected (exit 4)" {
  printf 'a\tb\nb\ta\n' > "$M"
  run "$DAG" --manifest "$M"
  [ "$status" -eq 4 ]
  echo "$output" | grep -qi "cycle"
}

@test "dangling dependency is detected (exit 3)" {
  printf 'a\tghost\n' > "$M"
  run "$DAG" --manifest "$M"
  [ "$status" -eq 3 ]
  echo "$output" | grep -qi "dangling"
}

@test "--format json is valid and topologically sound" {
  printf 'a\t-\nb\ta\n' > "$M"
  run "$DAG" --manifest "$M" --format json
  [ "$status" -eq 0 ]
  echo "$output" | python3 -c 'import json,sys
d=json.load(sys.stdin); w=d["waves"]
assert w[0]==["a"] and w[1]==["b"]'
}

@test "comments and blank lines are ignored" {
  printf '# header\n\na\t-\nb\ta\n' > "$M"
  run "$DAG" --manifest "$M"
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "^wave 0: a$"
}

@test "missing --manifest exits 2" {
  run "$DAG"
  [ "$status" -eq 2 ]
}

@test "nonexistent manifest exits 2" {
  run "$DAG" --manifest "$SB/nope.tsv"
  [ "$status" -eq 2 ]
}
