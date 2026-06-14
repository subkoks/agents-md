#!/usr/bin/env bash
# Shared helpers for the bats test suite.
#
# Tests must be hermetic: never mutate the working tree or the real $HOME.
# Read-only checks run against $REPO_ROOT directly; any test that writes
# artifacts, injects drift, or produces logs runs inside a per-test sandbox
# (a throwaway copy of the repo under $BATS_TEST_TMPDIR).

# Absolute path to the repository root (tests/helpers/ -> tests/ -> root).
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
export REPO_ROOT

# Create a hermetic copy of the repo for the current test and print its path.
# Excludes VCS, generated, and volatile dirs so the sandbox starts clean.
make_sandbox() {
  local sb="$BATS_TEST_TMPDIR/repo"
  rm -rf "$sb"
  mkdir -p "$sb"
  tar -cf - -C "$REPO_ROOT" \
    --exclude='./.git' \
    --exclude='./logs' \
    --exclude='./dist' \
    --exclude='./node_modules' \
    . | tar -xf - -C "$sb"
  printf '%s\n' "$sb"
}

# Build all rule artifacts inside a sandbox (populates dist/rules/).
build_sandbox_artifacts() {
  local sb="$1"
  "$sb/scripts/build-rule-artifacts.sh" >/dev/null
}
