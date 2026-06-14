#!/usr/bin/env bats
# health-check.sh: runs the full local check sequence and writes a timestamped log.

load helpers/setup

setup() {
  SB="$(make_sandbox)"
  build_sandbox_artifacts "$SB"
  HEALTH="$SB/scripts/health-check.sh"
}

@test "health check passes on a freshly built tree" {
  run "$HEALTH"
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "health-check finished"
}

@test "health check writes a timestamped log into logs/health" {
  run "$HEALTH"
  [ "$status" -eq 0 ]
  run bash -c "ls \"$SB\"/logs/health/health-*.log 2>/dev/null"
  [ "$status" -eq 0 ]
}
