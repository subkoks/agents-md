#!/usr/bin/env bats
# hook-profile.sh: cumulative profiles, DISABLED_HOOKS override, formats.

load helpers/setup

setup() {
  SB="$(make_sandbox)"
  HP="$SB/scripts/hook-profile.sh"
}

@test "minimal profile enables only minimal hooks" {
  run "$HP" --profile minimal
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "secret-guard"
  echo "$output" | grep -q "dispatcher"
  ! echo "$output" | grep -q "test-gate"
}

@test "standard profile adds standard hooks" {
  run "$HP" --profile standard
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "test-gate"
  echo "$output" | grep -q "checkpoint"
  ! echo "$output" | grep -q "audit-log"
}

@test "strict profile enables every hook" {
  run "$HP" --profile strict
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "audit-log"
  echo "$output" | grep -q "session-telemetry"
}

@test "DISABLED_HOOKS force-disables a named hook" {
  run env DISABLED_HOOKS="test-gate" "$HP" --profile strict
  [ "$status" -eq 0 ]
  ! echo "$output" | grep -q "^test-gate$"
  echo "$output" | grep -q "checkpoint"
}

@test "--list-all reports disabled hooks under minimal" {
  run "$HP" --profile minimal --list-all
  [ "$status" -eq 0 ]
  echo "$output" | grep -qE "test-gate.*disabled"
  echo "$output" | grep -qE "secret-guard.*enabled"
}

@test "--format json is parseable" {
  run "$HP" --profile standard --format json
  [ "$status" -eq 0 ]
  echo "$output" | python3 -c 'import json,sys; d=json.load(sys.stdin); assert d["profile"]=="standard"; assert len(d["hooks"])>=1'
}

@test "invalid profile exits 2" {
  run "$HP" --profile bogus
  [ "$status" -eq 2 ]
}

@test "missing manifest exits 1" {
  run "$HP" --profile standard --manifest "$SB/nope.tsv"
  [ "$status" -eq 1 ]
}
