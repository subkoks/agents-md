#!/usr/bin/env bats
# precompact-capture.sh: snapshot/restore resumable state across compaction.

load helpers/setup

setup() {
  SB="$(make_sandbox)"
  PC="$SB/scripts/precompact-capture.sh"
  DIR="$BATS_TEST_TMPDIR/state"
}

@test "capture writes a snapshot and latest.json (valid JSON)" {
  run "$PC" capture --session s1 --note "checkpoint" --dir "$DIR"
  [ "$status" -eq 0 ]
  [ -f "$DIR/latest.json" ]
  run python3 -c 'import json;d=json.load(open("'"$DIR"'/latest.json"));assert d["session"]=="s1" and "branch" in d and "changed" in d'
  [ "$status" -eq 0 ]
}

@test "restore prints the latest snapshot" {
  "$PC" capture --session s1 --note "abc" --dir "$DIR" >/dev/null
  run "$PC" restore --dir "$DIR"
  [ "$status" -eq 0 ]
  echo "$output" | python3 -c 'import json,sys; d=json.load(sys.stdin); assert d["note"]=="abc"'
}

@test "restore with no prior state exits 3" {
  run "$PC" restore --dir "$DIR"
  [ "$status" -eq 3 ]
}

@test "long note is truncated and stays valid JSON" {
  longnote="$(printf 'y%.0s' {1..900})"
  run "$PC" capture --session s1 --note "$longnote" --dir "$DIR" --stdout
  [ "$status" -eq 0 ]
  echo "$output" | python3 -c 'import json,sys
for line in sys.stdin:
  line=line.strip()
  if line.startswith("{"):
    d=json.loads(line); assert len(d["note"])<=500; break'
}

@test "invalid mode exits 2" {
  run "$PC" bogus
  [ "$status" -eq 2 ]
}

@test "captures real git branch/head inside a repo" {
  git -C "$SB" init -q
  git -C "$SB" config user.email t@e.st
  git -C "$SB" config user.name tester
  git -C "$SB" add -A
  git -C "$SB" -c commit.gpgsign=false commit -qm init
  run "$PC" capture --dir "$DIR" --stdout
  [ "$status" -eq 0 ]
  echo "$output" | python3 -c 'import json,sys
for line in sys.stdin:
  line=line.strip()
  if line.startswith("{"):
    d=json.loads(line); assert d["branch"]!="unknown" and len(d["head"])>=7; break'
}
