#!/usr/bin/env bats
# debug-journal.sh: hypothesis tracking add/resolve/report.

load helpers/setup

setup() {
  SB="$(make_sandbox)"
  DJ="$SB/scripts/debug-journal.sh"
  DIR="$BATS_TEST_TMPDIR/debug"
}

@test "add records a hypothesis and assigns sequence numbers" {
  run "$DJ" add --session b1 --hypothesis "null user" --test "log it" --dir "$DIR"
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "#1"
  run "$DJ" add --session b1 --hypothesis "db undefined" --dir "$DIR"
  echo "$output" | grep -q "#2"
}

@test "resolve sets status and evidence" {
  "$DJ" add --session b1 --hypothesis "null user" --dir "$DIR" >/dev/null
  run "$DJ" resolve --session b1 --seq 1 --result confirmed --evidence "was null" --dir "$DIR"
  [ "$status" -eq 0 ]
  run "$DJ" report --session b1 --dir "$DIR"
  echo "$output" | grep -q "confirmed"
  echo "$output" | grep -q "was null"
}

@test "report markdown renders a table" {
  "$DJ" add --session b1 --hypothesis "h1" --dir "$DIR" >/dev/null
  run "$DJ" report --session b1 --dir "$DIR"
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "# Debug journal: b1"
  echo "$output" | grep -q "| # | Status |"
}

@test "report json is valid" {
  "$DJ" add --session b1 --hypothesis "h1" --test "t1" --dir "$DIR" >/dev/null
  "$DJ" resolve --session b1 --seq 1 --result refuted --dir "$DIR" >/dev/null
  run "$DJ" report --session b1 --format json --dir "$DIR"
  [ "$status" -eq 0 ]
  echo "$output" | python3 -c 'import json,sys; d=json.load(sys.stdin); assert d["hypotheses"][0]["status"]=="refuted"'
}

@test "resolve with bad result exits 2" {
  "$DJ" add --session b1 --hypothesis "h1" --dir "$DIR" >/dev/null
  run "$DJ" resolve --session b1 --seq 1 --result maybe --dir "$DIR"
  [ "$status" -eq 2 ]
}

@test "resolve unknown seq exits 3" {
  "$DJ" add --session b1 --hypothesis "h1" --dir "$DIR" >/dev/null
  run "$DJ" resolve --session b1 --seq 9 --result confirmed --dir "$DIR"
  [ "$status" -eq 3 ]
}

@test "report on missing session exits 3" {
  run "$DJ" report --session ghost --dir "$DIR"
  [ "$status" -eq 3 ]
}

@test "invalid mode exits 2" {
  run "$DJ" frobnicate --session b1 --dir "$DIR"
  [ "$status" -eq 2 ]
}

@test "session name is sanitized into a safe filename" {
  run "$DJ" add --session "weird/../name" --hypothesis "h" --dir "$DIR"
  [ "$status" -eq 0 ]
  # no path traversal: only a single sanitized file under DIR
  run bash -c "ls \"$DIR\" | wc -l"
  [ "$(echo "$output" | tr -d ' ')" -eq 1 ]
}
