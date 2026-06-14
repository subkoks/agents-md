#!/usr/bin/env bats
# check-skill-registry-drift.sh: registry vs skills/*.md alignment.

load helpers/setup

setup() {
  SB="$(make_sandbox)"
  SKILLS_DRIFT="$SB/scripts/check-skill-registry-drift.sh"
}

@test "registry and local skills are aligned in a clean checkout" {
  run "$SKILLS_DRIFT"
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "aligned"
}

@test "a new unregistered skill is reported as unmanaged" {
  printf '# Orphan skill\n' > "$SB/skills/zz-orphan-skill.md"
  run "$SKILLS_DRIFT"
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "Unmanaged local skill: local/zz-orphan-skill"
}

@test "missing registry aborts" {
  rm -f "$SB/skills/registry.tsv"
  run "$SKILLS_DRIFT"
  [ "$status" -ne 0 ]
  echo "$output" | grep -q "Registry not found"
}
