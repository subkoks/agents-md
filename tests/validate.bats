#!/usr/bin/env bats
# validate-rules.sh + validate-comprehensive.sh: pass on good source, fail on malformed.

load helpers/setup

setup() {
  SB="$(make_sandbox)"
  VALIDATE="$SB/scripts/validate-rules.sh"
  COMPREHENSIVE="$SB/scripts/validate-comprehensive.sh"
}

@test "validate-rules passes on canonical source" {
  run "$VALIDATE"
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "Required sections present"
}

@test "validate-rules fails when a required section is removed" {
  # Drop the Security heading the validator requires.
  sed -i.bak 's/^## Security/## Sekurity/' "$SB/src/gotcha.md"
  run "$VALIDATE"
  [ "$status" -ne 0 ]
  echo "$output" | grep -q "Missing required section"
}

@test "validate-rules fails when source file is absent" {
  rm -f "$SB/src/gotcha.md"
  run "$VALIDATE"
  [ "$status" -ne 0 ]
}

@test "validate-comprehensive --strict passes on a freshly built tree" {
  build_sandbox_artifacts "$SB"
  run "$COMPREHENSIVE" --strict
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "All validation checks passed"
}
