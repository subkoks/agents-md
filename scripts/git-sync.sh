#!/bin/bash
# Safe SSH git sync: rebase pull, stage tracked changes, commit, push.
#
# Usage: ./scripts/git-sync.sh [optional commit message]
#   - No message  -> commit message is an ISO-8601 timestamp.
#   - Stages tracked changes only (git add -u); untracked files are ignored.
#   - Pull uses --rebase --autostash so local work is never lost on divergence.
#   - Push uses the existing (SSH) remote; HTTPS remotes are rejected.

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

branch="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$branch" == "HEAD" ]]; then
  echo "ERROR: detached HEAD; checkout a branch before syncing." >&2
  exit 1
fi

case "$branch" in
  main|master)
    if [[ "${ALLOW_PROTECTED_PUSH:-}" != "1" ]]; then
      echo "ERROR: refusing to push directly to protected branch '$branch'." >&2
      echo "       Use a feature branch, or set ALLOW_PROTECTED_PUSH=1 to override." >&2
      exit 1
    fi ;;
esac

remote_url="$(git remote get-url origin)"
if [[ "$remote_url" != git@github.com:* && "$remote_url" != ssh://git@github.com/* ]]; then
  echo "ERROR: origin is not an SSH remote: $remote_url" >&2
  echo "       Fix with: git remote set-url origin git@github.com:subkoks/<repo>.git" >&2
  exit 1
fi

echo "==> [1/4] pull --rebase --autostash ($branch)"
git pull --rebase --autostash origin "$branch"

echo "==> [2/4] stage tracked changes"
git add -u

if git diff --cached --quiet; then
  echo "    nothing to commit; pushing existing commits (if any)."
else
  msg="${1:-chore: sync $(date +%Y-%m-%dT%H:%M:%S%z)}"
  echo "==> [3/4] commit: $msg"
  git commit -m "$msg"
fi

echo "==> [4/4] push origin $branch"
git push origin "$branch"

echo "[DONE] synced $branch -> $remote_url"
