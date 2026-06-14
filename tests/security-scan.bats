#!/usr/bin/env bats
# security-scan.sh: detectors fire on malicious config, stay quiet on safe config,
# honor severity thresholds, and emit valid JSON.

load helpers/setup

setup() {
  SB="$(make_sandbox)"
  SCAN="$SB/scripts/security-scan.sh"
}

@test "clean repo: no findings, exit 0" {
  run "$SCAN"
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "No findings"
}

@test "SEC-PERM-001: wildcard Bash permission is critical and fails" {
  printf '{ "permissions": { "allow": ["Bash(*)"] } }\n' > "$SB/.claude/settings.json"
  run "$SCAN"
  [ "$status" -eq 1 ]
  echo "$output" | grep -q "SEC-PERM-001"
}

@test "SEC-PERM-001: bypassPermissions default mode is flagged" {
  printf '{ "defaultMode": "bypassPermissions" }\n' > "$SB/.claude/settings.json"
  run "$SCAN"
  [ "$status" -eq 1 ]
  echo "$output" | grep -q "SEC-PERM-001"
}

@test "SEC-CI-001: untrusted input inside a run block is flagged" {
  cat > "$SB/.github/workflows/evil.yml" <<'YML'
name: evil
on: [issues]
jobs:
  x:
    runs-on: ubuntu-latest
    steps:
      - run: echo "${{ github.event.issue.title }}"
YML
  run "$SCAN"
  [ "$status" -eq 1 ]
  echo "$output" | grep -q "SEC-CI-001"
}

@test "SEC-CI-001 guard: github.event in an if: condition is NOT flagged" {
  cat > "$SB/.github/workflows/safe.yml" <<'YML'
name: safe
on: [issues]
jobs:
  x:
    if: contains(github.event.issue.title, '@claude')
    runs-on: ubuntu-latest
    steps:
      - run: echo "static string only"
YML
  run "$SCAN" --min-severity high
  [ "$status" -eq 0 ]
  ! echo "$output" | grep -q "SEC-CI-001"
}

@test "SEC-SECRET-001: AWS-style key literal is flagged" {
  printf 'aws_key = "AKIA1234567890ABCDEF"\n' > "$SB/config.toml"
  run "$SCAN"
  [ "$status" -eq 1 ]
  echo "$output" | grep -q "SEC-SECRET-001"
}

@test "SEC-SECRET-001 guard: secrets.* reference is NOT flagged" {
  cat > "$SB/.github/workflows/ok.yml" <<'YML'
name: ok
on: [push]
jobs:
  x:
    runs-on: ubuntu-latest
    steps:
      - run: deploy --token "${{ secrets.DEPLOY_TOKEN }}"
YML
  run "$SCAN" --min-severity high
  [ "$status" -eq 0 ]
}

@test "--fail-on never exits 0 even with critical findings" {
  printf '{ "permissions": { "allow": ["Bash(*)"] } }\n' > "$SB/.claude/settings.json"
  run "$SCAN" --fail-on never
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "SEC-PERM-001"
}

@test "--format json emits valid, parseable JSON" {
  printf '{ "permissions": { "allow": ["Bash(*)"] } }\n' > "$SB/.claude/settings.json"
  run "$SCAN" --format json --fail-on never
  [ "$status" -eq 0 ]
  echo "$output" | python3 -c 'import json,sys; d=json.load(sys.stdin); assert d["count"]>=1'
}

@test "invalid --format exits 2" {
  run "$SCAN" --format bogus
  [ "$status" -eq 2 ]
}
