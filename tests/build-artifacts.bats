#!/usr/bin/env bats
# build-rule-artifacts.sh: artifact generation, --list, --dry-run, bad targets.

load helpers/setup

setup() {
  SB="$(make_sandbox)"
  BUILD="$SB/scripts/build-rule-artifacts.sh"
}

@test "build produces all four rule artifacts" {
  run "$BUILD"
  [ "$status" -eq 0 ]
  [ -f "$SB/dist/rules/windsurf.md" ]
  [ -f "$SB/dist/rules/claude.md" ]
  [ -f "$SB/dist/rules/cursor.md" ]
  [ -f "$SB/dist/rules/cursor.lean.md" ]
}

@test "raw artifacts are byte-identical to canonical source" {
  run "$BUILD"
  [ "$status" -eq 0 ]
  cmp -s "$SB/src/gotcha.md" "$SB/dist/rules/windsurf.md"
  cmp -s "$SB/src/gotcha.md" "$SB/dist/rules/claude.md"
}

@test "cursor full artifact carries Cursor frontmatter" {
  run "$BUILD" cursor
  [ "$status" -eq 0 ]
  head -n 1 "$SB/dist/rules/cursor.md" | grep -qx -- "---"
  grep -q "alwaysApply: false" "$SB/dist/rules/cursor.md"
}

@test "--dry-run writes nothing" {
  run "$BUILD" --dry-run
  [ "$status" -eq 0 ]
  [ ! -e "$SB/dist/rules" ]
  echo "$output" | grep -q "DRY RUN"
}

@test "--list reports status for every target" {
  build_sandbox_artifacts "$SB"
  run "$BUILD" --list
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "windsurf: in-sync"
  echo "$output" | grep -q "claude: in-sync"
}

@test "unknown target exits non-zero" {
  run "$BUILD" bogus-target
  [ "$status" -ne 0 ]
}

@test "missing source aborts" {
  rm -f "$SB/src/gotcha.md"
  run "$BUILD"
  [ "$status" -ne 0 ]
  echo "$output" | grep -q "Missing rule source"
}
