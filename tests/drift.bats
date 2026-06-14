#!/usr/bin/env bats
# check-local-drift.sh: the behaviour CI never asserts — drift must fail under --strict.

load helpers/setup

setup() {
  SB="$(make_sandbox)"
  build_sandbox_artifacts "$SB"
  DRIFT="$SB/scripts/check-local-drift.sh"
}

@test "clean artifacts pass (exit 0)" {
  run "$DRIFT" --strict
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "No drift detected"
}

@test "injected drift fails under --strict (exit non-zero)" {
  printf '\n<!-- injected drift -->\n' >> "$SB/dist/rules/claude.md"
  run "$DRIFT" --strict
  [ "$status" -ne 0 ]
  echo "$output" | grep -q "Drift detected"
}

@test "injected drift warns but exits 0 without --strict" {
  printf '\n<!-- injected drift -->\n' >> "$SB/dist/rules/windsurf.md"
  run "$DRIFT"
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "Drift detected"
}

@test "missing artifact is flagged under --strict" {
  rm -f "$SB/dist/rules/claude.md"
  run "$DRIFT" --strict
  [ "$status" -ne 0 ]
  echo "$output" | grep -q "Missing artifact"
}

@test "missing source aborts" {
  rm -f "$SB/src/gotcha.md"
  run "$DRIFT"
  [ "$status" -ne 0 ]
  echo "$output" | grep -q "Rule source missing"
}
