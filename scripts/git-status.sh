#!/bin/bash
# Quick git status + recent history overview.
#
# Usage: ./scripts/git-status.sh

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

branch="$(git rev-parse --abbrev-ref HEAD)"

echo "==> branch:  $branch"
echo "==> remote:  $(git remote get-url origin 2>/dev/null || echo '(none)')"

upstream="$(git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null || true)"
if [[ -n "$upstream" ]]; then
  ahead_behind="$(git rev-list --left-right --count "$upstream"...HEAD 2>/dev/null || echo '? ?')"
  behind="${ahead_behind%%[[:space:]]*}"
  ahead="${ahead_behind##*[[:space:]]}"
  echo "==> tracking: $upstream (ahead $ahead, behind $behind)"
else
  echo "==> tracking: (no upstream set)"
fi

echo
echo "==> status"
git status --short --branch

echo
echo "==> last 10 commits"
git --no-pager log --oneline --decorate -10
