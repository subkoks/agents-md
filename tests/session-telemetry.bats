#!/usr/bin/env bats
# session-telemetry.sh: bounded JSONL session records at stop-phase.

load helpers/setup

setup() {
  SB="$(make_sandbox)"
  TEL="$SB/scripts/session-telemetry.sh"
  OUT="$BATS_TEST_TMPDIR/telemetry"
}

@test "records a session as one valid JSON line" {
  run "$TEL" --session s1 --turns 3 --tools 7 --status ok --dir "$OUT"
  [ "$status" -eq 0 ]
  [ -f "$OUT/telemetry.jsonl" ]
  run python3 -c 'import json;d=json.load(open("'"$OUT"'/telemetry.jsonl"));assert d["session"]=="s1" and d["turns"]==3'
  [ "$status" -eq 0 ]
}

@test "appends one line per call" {
  "$TEL" --session s1 --dir "$OUT" >/dev/null
  "$TEL" --session s2 --dir "$OUT" >/dev/null
  run wc -l < "$OUT/telemetry.jsonl"
  [ "$(echo "$output" | tr -d ' ')" -eq 2 ]
}

@test "missing --session exits 2" {
  run "$TEL" --turns 1 --dir "$OUT"
  [ "$status" -eq 2 ]
}

@test "invalid --status exits 2" {
  run "$TEL" --session s1 --status weird --dir "$OUT"
  [ "$status" -eq 2 ]
}

@test "non-numeric --turns exits 2" {
  run "$TEL" --session s1 --turns abc --dir "$OUT"
  [ "$status" -eq 2 ]
}

@test "long note is truncated and stays valid JSON" {
  longnote="$(printf 'x%.0s' {1..500})"
  run "$TEL" --session s1 --note "$longnote" --dir "$OUT" --stdout
  [ "$status" -eq 0 ]
  echo "$output" | python3 -c 'import json,sys
for line in sys.stdin:
  line=line.strip()
  if line.startswith("{"):
    d=json.loads(line); assert len(d["note"])<=200; break'
}
