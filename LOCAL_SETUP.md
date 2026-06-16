# Local Setup

Local-only setup notes for working on this repo. Not required for CI (which is
self-contained), but useful for day-to-day development.

## SSH-based GitHub access

All git operations use SSH, never HTTPS.

### One-time verification

```bash
ls -la ~/.ssh/id_ed25519        # key must exist (or id_rsa)
ssh-add -l                      # key loaded in the agent
ssh -T git@github.com           # expect: "Hi <user>! You've successfully authenticated"
git remote -v                   # must show git@github.com:subkoks/<repo>.git
```

If the key is missing, generate one and add it to GitHub:

```bash
ssh-keygen -t ed25519 -C "subkoks@gmail.com" -f ~/.ssh/id_ed25519
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub       # add this to https://github.com/settings/keys
```

### Force SSH for all GitHub remotes (recommended)

Add this block to `~/.gitconfig` so any HTTPS GitHub URL is rewritten to SSH
automatically — covers clones, submodules, and Go/package fetches:

```ini
[url "git@github.com:"]
    insteadOf = https://github.com/
```

Or apply it via CLI:

```bash
git config --global url."git@github.com:".insteadOf "https://github.com/"
```

## Helper scripts

| Script | Purpose |
| --- | --- |
| `./scripts/git-sync.sh [msg]` | rebase-pull, stage tracked changes, commit (timestamp if no `msg`), push via SSH |
| `./scripts/git-status.sh` | branch, remote, ahead/behind, short status, last 10 commits |

`git-sync.sh` refuses to run if `origin` is not an SSH remote, and refuses to
push directly to `main`/`master` unless `ALLOW_PROTECTED_PUSH=1` is set:

```bash
ALLOW_PROTECTED_PUSH=1 ./scripts/git-sync.sh "hotfix message"
```
