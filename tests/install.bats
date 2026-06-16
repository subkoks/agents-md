#!/usr/bin/env bats
# install.sh: dry-run writes nothing; real install targets a sandboxed $HOME only.

load helpers/setup

setup() {
  SB="$(make_sandbox)"
  build_sandbox_artifacts "$SB"
  INSTALL="$SB/install.sh"
  FAKE_HOME="$BATS_TEST_TMPDIR/home"
  mkdir -p "$FAKE_HOME"
}

@test "--dry-run installs nothing into HOME" {
  run env HOME="$FAKE_HOME" "$INSTALL" --dry-run
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "dry-run"
  [ ! -e "$FAKE_HOME/.cursor/rules/gotcha.mdc" ]
}

@test "real install writes lean rule into HOME" {
  run env HOME="$FAKE_HOME" "$INSTALL"
  [ "$status" -eq 0 ]
  [ -f "$FAKE_HOME/.cursor/rules/gotcha.mdc" ]
  cmp -s "$SB/dist/rules/cursor.lean.md" "$FAKE_HOME/.cursor/rules/gotcha.mdc"
}

@test "--full also writes the full rule" {
  run env HOME="$FAKE_HOME" "$INSTALL" --full
  [ "$status" -eq 0 ]
  [ -f "$FAKE_HOME/.cursor/rules/gotcha-full.mdc" ]
}

@test "second install backs up the existing target" {
  env HOME="$FAKE_HOME" "$INSTALL" >/dev/null
  run env HOME="$FAKE_HOME" "$INSTALL"
  [ "$status" -eq 0 ]
  run bash -c "ls \"$FAKE_HOME\"/.cursor/rules/gotcha.mdc.bak.* 2>/dev/null"
  [ "$status" -eq 0 ]
}

@test "unknown flag exits non-zero" {
  run env HOME="$FAKE_HOME" "$INSTALL" --nope
  [ "$status" -ne 0 ]
}
