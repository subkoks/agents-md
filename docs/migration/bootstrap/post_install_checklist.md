# bootstrap/post_install_checklist.md

End-to-end verification gauntlet. Run this **after** all milestones in `install-order.md` complete. Every check should pass before declaring Day 1 done.

> Convention: `✅` means a green output is expected; `❌` means the absence of that line is the pass condition.

---

## Block 0 — System

```bash
sw_vers                                          # ✅ ProductVersion ≥ planning snapshot
uname -m                                         # ✅ arm64 (Apple Silicon) or x86_64 (Intel)
xcode-select -p                                  # ✅ /Library/Developer/CommandLineTools (or .../Xcode.app/...)
fdesetup status                                  # ✅ "FileVault is On." (if Q4 = on)
csrutil status                                   # ✅ "System Integrity Protection status: enabled."
```

## Block 1 — Homebrew

```bash
brew --version                                   # ✅ Homebrew 4.x
brew --prefix                                    # ✅ /opt/homebrew (ARM) or /usr/local (Intel)
brew doctor                                      # ✅ "Your system is ready to brew."
brew bundle check --file=bootstrap/Brewfile      # ✅ "The Brewfile's dependencies are satisfied."
brew leaves | wc -l                              # ✅ matches Brewfile formula count (rough)
brew list --cask | wc -l                         # ✅ matches Brewfile cask count (rough)
```

## Block 2 — Services

```bash
brew services list | grep postgresql@16          # ✅ status: started
brew services list | grep redis                  # ✅ status: started
psql --version                                   # ✅ psql (PostgreSQL) 16.x
pg_isready                                       # ✅ accepting connections
redis-cli ping                                   # ✅ PONG
sqlite3 --version                                # ✅ 3.x
```

## Block 3 — Runtimes

```bash
node --version                                   # ✅ v22.x
which node                                       # ✅ ~/.nvm/versions/node/v22.x/bin/node
which -a node | wc -l                            # ✅ 1 (no brew node collision)

python --version                                 # ✅ Python 3.13.x
which python                                     # ✅ ~/.pyenv/shims/python
which -a python | head -2                        # ✅ pyenv shim first

npm --version                                    # ✅ matches Node 22 ships
command pnpm --version                           # ✅ 9.x or later
pip --version                                    # ✅ pip 24.x ... (python 3.13)
uv --version                                     # ✅ 0.x
pipx --version                                   # ✅ 1.x
```

## Block 4 — Shell + fonts

```bash
echo $SHELL                                      # ✅ /bin/zsh
zsh --version                                    # ✅ zsh 5.x
ls ~/.oh-my-zsh                                  # ✅ exists
ls ~/.oh-my-zsh/custom/themes/powerlevel10k     # ✅ exists
zsh -i -c 'echo $ZSH_THEME'                      # ✅ powerlevel10k/powerlevel10k
fc-list 2>/dev/null | grep -i meslo \
  || system_profiler SPFontsDataType | grep -i meslo  # ✅ at least one match
```

## Block 5 — Editors

```bash
test -d /Applications/Cursor.app                 # ✅
test -d /Applications/Windsurf.app               # ✅
code --version                                   # ✅ Cursor's `code` version
windsurf --version                               # ✅
code --list-extensions | wc -l                   # ✅ ≥ 19 (or your trimmed count)
windsurf --list-extensions | wc -l               # ✅ ≥ 19 (or 26 with Java)
```

## Block 6 — Browsers

```bash
test -d /Applications/Brave\ Browser.app         # ✅
test -d "/Applications/Google Chrome Dev.app"    # ✅
test -f "/Applications/Google Chrome Dev.app/Contents/MacOS/Google Chrome Dev"   # ✅
```

## Block 7 — Dotfiles + AGENTS.md restored

```bash
test -f ~/AGENTS.md                              # ✅
test -f ~/.zshrc                                 # ✅
test -f ~/.zshenv                                # ✅
test -f ~/.zprofile                              # ✅
test -f ~/.p10k.zsh                              # ✅
test -f ~/.claude/CLAUDE.md                      # ✅
test -f ~/.codex/AGENTS.md                       # ✅
test -f ~/.cursor/rules/gotcha.mdc               # ✅
test -f ~/.cursor/rules/gotcha-full.mdc          # ✅
test -f ~/.windsurf/rules/gotcha.md              # ✅
test -f ~/.codeium/windsurf/memories/global_rules.md  # ✅
```

## Block 8 — Skills + agents tree (canonical via cursor)

> **Threshold note:** the current machine's high counts (e.g. `~/.claude/skills/` = 30, `~/.agents/skills/` = 88) include *Anthropic-shipped community skills* synced from the upstream `awesome-claude-skills` repo. On a fresh install with **only** the canonical `~/.cursor/skills/` restore + symlinks (no community skills), the realistic count is **5–10 per editor root**. To reach the higher counts, also clone and sync `awesome-claude-skills` (or whatever upstream skills source is in active use) — track that as a Week-1 task, not Day 1.

```bash
ls ~/.cursor/skills/ | wc -l                     # ✅ ≥ canonical-only count (your private skills)
file ~/.claude/skills/macos-machine-inventory \
  | grep -q symbolic && echo OK                  # ✅ OK (symlink into cursor canonical)
file ~/.claude/skills/dotfiles-allowlist-auditor \
  | grep -q symbolic && echo OK                  # ✅ OK
ls ~/.claude/skills/ | wc -l                     # ✅ ≥ 5 (canonical only) or ≥ 30 (with community skills synced)
ls ~/.codex/skills/ | wc -l                      # ✅ ≥ 5 / ≥ 70
ls ~/.codeium/windsurf/skills/ | wc -l           # ✅ ≥ 5 / ≥ 27
ls ~/.agents/skills/ | wc -l                     # ✅ ≥ 5 / ≥ 88
```

## Block 9 — AI CLIs

```bash
claude --version                                  # ✅
codex --version                                   # ✅
gh --version                                      # ✅
gh auth status                                    # ✅ "Logged in to github.com"
git config --global user.email                    # ✅ subkoks@gmail.com
git config --global user.name                     # ✅ black.terminal
```

## Block 10 — MCP servers

```bash
claude mcp list 2>&1 | tee /tmp/mcp.out
grep -c '✓ Connected' /tmp/mcp.out                # ✅ ≥ 10 (rough; varies by which remotes are auth'd)
grep '✓ Connected' /tmp/mcp.out | grep -E 'filesystem|postgres|sequential-thinking|memory'
                                                  # ✅ all four
grep '✓ Connected' /tmp/mcp.out | grep -E 'github|chrome-devtools'
                                                  # ✅ both (need Milestone 7 + local install)
grep '✗\|! Needs authentication' /tmp/mcp.out     # ⚠️ acceptable for remote HTTP servers; trigger
                                                  #     a tool call on each to start OAuth
```

## Block 11 — Project repos

```bash
ls ~/Projects/Current/Active/ | head -20          # ✅ expected repos present
gh auth status                                    # ✅
test -f ~/Projects/Current/Active/BEST-Self-Enhancement-Learning-AI/mcp/dist/server.js
                                                  # ✅ BSELA built (required for bsela MCP)
```

## Block 12 — Secrets (negative checks)

```bash
test ! -f ~/.codex/auth.json && echo "auth.json absent (correct)"   # ✅
grep -r 'sk-ant\|sk-proj\|pk_live\|sk_live' \
  ~/Projects/macos-bootstrap-2026/ 2>/dev/null    # ❌ no matches (no api-keys committed)
git -C ~/Projects/macos-bootstrap-2026 ls-files | grep -E '\.env$|auth\.json|credentials' \
                                                  # ❌ no matches
```

## Block 13 — Common-PATH gotchas (the original "why broken" list)

These are the same gaps the inventory flagged on the old machine. The new machine should NOT reproduce them.

```bash
which docker                                      # ⚠️ depends on Q2 choice; if 'docker' chosen, ✅
which psql                                        # ✅ (Brewfile keg-link or PATH override applied)
which pg_isready                                  # ✅
which mas                                         # ⚠️ optional; install if MAS-managed apps used
which solana                                      # ⚠️ install per project demand
which cargo                                       # ⚠️ install via rustup on demand
which go                                          # ⚠️ install on demand
```

## Day 1 (90-minute) acceptance gate

Minimum to call Day 1 done:

- [ ] All checks in **Block 0–4** pass (system, brew, services, runtimes, shell)
- [ ] Cursor opens, signs in, runs an extension successfully (Block 5)
- [ ] `git`, `gh`, and at least one project repo cloned (Block 7, 11)
- [ ] Claude Code CLI works against at least one MCP server (Block 9, 10)
- [ ] No secret-leak red flags (Block 12)

Anything else can land in Week 1.

## Week 1 completion

Add these to the Day 1 set:

- [ ] All extensions in Cursor + Windsurf restored (Block 5)
- [ ] All AI rules / skills / agents restored from canonical cursor tree (Block 7, 8)
- [ ] All MCP servers connected or in known re-auth state (Block 10)
- [ ] Project bootstrap done for at least 5 active repos (Block 11)
- [ ] Pentest tier (`Brewfile.pentest`) installed if Q10 = yes
- [ ] Container runtime working per Q2 choice
- [ ] Secrets manager set up per Q3 choice
- [ ] Dotfiles repo committed and applied per Q13
- [ ] `OPEN_QUESTIONS.md` resolved or each remaining item has a tracking issue

## Recovery if a block fails

1. Don't cascade. Fix the failing block before moving to the next.
2. If a brew formula won't install, capture `brew install -v <name> 2>&1 | tee /tmp/brew-fail.log` and check `OPEN_QUESTIONS.md` Q1 first (architecture mismatch is the most common cause).
3. If MCP servers fail, run `claude mcp remove <name>` and re-add — usually faster than debugging the cached state.
4. Anything ambiguous → new entry in `OPEN_QUESTIONS.md`, do not improvise.
