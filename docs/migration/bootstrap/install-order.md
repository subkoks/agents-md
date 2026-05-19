# bootstrap/install-order.md

End-to-end install order for the new macOS install. Each milestone has:

- **Goal** — what done looks like
- **Steps** — exact commands (idempotent where possible)
- **Verify** — pass/fail check before moving on

Stop at the first failing verify. Open an entry in `OPEN_QUESTIONS.md` instead of guessing.

---

## Pre-flight

Resolve before running anything:

- [x] `OPEN_QUESTIONS.md` Q1 — Apple Silicon vs Intel → **Intel** (`/usr/local`) — 2026-05-07
- [x] `OPEN_QUESTIONS.md` Q2 — container runtime choice → **OrbStack** — 2026-05-07
- [x] `OPEN_QUESTIONS.md` Q3 — secrets manager → **1Password CLI** — 2026-05-07
- [x] `OPEN_QUESTIONS.md` Q4 — FileVault on/off → **ON** — 2026-05-07
- [x] `OPEN_QUESTIONS.md` Q12 — minimal vs full profile → **minimal Day 1** — 2026-05-07

Decisions are recorded in `DECISIONS.md` + resolution table in `OPEN_QUESTIONS.md`. Proceed.

---

## Milestone 0 — macOS first-boot setup

**Goal:** clean macOS shell with Apple ID signed in, FileVault enabled (if Q4 = on), no iCloud Documents-and-Desktop sync to avoid mixing repo work into iCloud.

**Steps:**

1. Complete Setup Assistant (region, Apple ID, Touch ID).
2. **System Settings → Privacy & Security → FileVault** → turn on if Q4 = on. Save recovery key in 1Password.
3. **System Settings → Apple ID → iCloud → iCloud Drive → Options** → uncheck "Desktop & Documents Folders" (prevents `~/Projects` syncing).
4. **System Settings → General → Software Update** → install all pending updates, reboot.

**Verify:**

```bash
sw_vers                                                # ProductVersion ≥ snapshot at planning
fdesetup status                                        # "FileVault is On." (if Q4 = on)
ls ~/Library/Mobile\ Documents/com~apple~CloudDocs/ 2>/dev/null \
  | head -1 || echo "iCloud Drive desktop sync OFF"     # expect OFF
```

---

## Milestone 1 — Xcode Command Line Tools

**Goal:** `xcode-select -p` returns a valid path; `git`, `clang`, `make` available.

**Steps:**

```bash
xcode-select --install        # GUI prompt; click Install
# Wait for completion
```

**Verify:**

```bash
xcode-select -p               # /Library/Developer/CommandLineTools (or .../Xcode.app/...)
git --version                 # git version 2.x
clang --version | head -1     # Apple clang version ...
make --version | head -1
```

---

## Milestone 2 — Rosetta 2 (Apple Silicon only)

Skip if Q1 = Intel.

**Goal:** Intel binaries can run if a tool requires it.

**Steps:**

```bash
softwareupdate --install-rosetta --agree-to-license
```

**Verify:**

```bash
arch -x86_64 uname -m         # x86_64
```

---

## Milestone 3 — Homebrew

**Goal:** `brew` on PATH at the right prefix; `brew doctor` clean.

**Steps:**

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Apple Silicon shell init (Q1 = ARM):
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Intel shell init (Q1 = Intel):
# (no extra step; /usr/local/bin is already on PATH)
```

**Verify:**

```bash
brew --version                # Homebrew >= 4.x
brew --prefix                 # /opt/homebrew (ARM) or /usr/local (Intel)
brew doctor                   # "Your system is ready to brew."  (or only warnings, no errors)
```

---

## Milestone 4 — Brewfile bundle

**Goal:** every formula and cask in `bootstrap/Brewfile` is installed; services started.

**Steps:**

```bash
cd ~/Projects/macos-bootstrap-2026
brew bundle --file=bootstrap/Brewfile
# wait — first run can be 15–30 min; cask GUI prompts may appear
```

**Verify:**

```bash
brew bundle check --file=bootstrap/Brewfile        # "The Brewfile's dependencies are satisfied."
brew services list | grep -E 'postgresql@16|redis' # both: started

# CRITICAL: psql is keg-only — postgresql@16 ships its bins but they are NOT
# linked into $(brew --prefix)/bin by default. Add the PATH line directly to
# ~/.zshrc. Apply BEFORE Milestone 9 (dotfiles restore) so dotfiles can pick
# the line up; or restore dotfiles first and add the line idempotently below.
if ! command -v psql >/dev/null 2>&1; then
  PG_BIN="$(brew --prefix postgresql@16)/bin"
  LINE='export PATH="'"$PG_BIN"':$PATH"'
  grep -qF "$LINE" ~/.zshrc 2>/dev/null || echo "$LINE" >> ~/.zshrc
  exec zsh -l
fi
psql --version                # ✅ psql (PostgreSQL) 16.x
pg_isready                    # ✅ accepting connections
redis-cli ping                # ✅ PONG
```

If pentest tier is needed:

```bash
brew bundle --file=bootstrap/Brewfile.pentest
```

---

## Milestone 5 — Shell + fonts

**Goal:** Zsh + oh-my-zsh + Powerlevel10k + Nerd Font visible in Terminal.app.

**Steps:**

```bash
# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# zsh plugins (optional but in current setup)
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Restore curated zsh configs from dotfiles allowlist (see Milestone 9):
#   ~/.zshrc, ~/.zshenv, ~/.zprofile, ~/.p10k.zsh
```

**Set Terminal.app font:** Terminal → Settings → Pro (or your profile) → Text → Font → "MesloLGS NF" (installed by Brewfile).

**Verify:**

```bash
echo $SHELL                   # /bin/zsh
ls ~/.oh-my-zsh                # exists
ls ~/.oh-my-zsh/custom/themes/powerlevel10k/  # exists
zsh -i -c 'echo $ZSH_THEME'   # "powerlevel10k/powerlevel10k"
fc-list | grep -i meslo || system_profiler SPFontsDataType | grep -i meslo  # font visible
```

---

## Milestone 6 — Runtimes (nvm + pyenv)

See `bootstrap/node_toolchain.md` and `bootstrap/python_toolchain.md` for full detail.

**Goal:** Node 22 LTS via nvm; Python 3.13 via pyenv; both default for new shells.

**Steps (summary):**

```bash
# nvm (Brewfile installed it; ensure shell init)
mkdir -p ~/.nvm
# add to ~/.zshrc (or via dotfiles): see node_toolchain.md
exec zsh -l
nvm install --lts                    # Node 22 LTS
nvm alias default 22

# pyenv
pyenv install 3.13                   # specify exact: e.g. 3.13.x
pyenv global 3.13
```

**Verify:**

```bash
node --version                # v22.x
which node                    # ~/.nvm/versions/node/v22.x/bin/node
python --version              # Python 3.13.x
which python                  # ~/.pyenv/shims/python
pip --version                 # pip 24.x  ... (python 3.13)
uv --version
pipx --version
```

---

## Milestone 7 — Browsers

**Goal:** Google Chrome Dev installed (used by `chrome-devtools` MCP); Brave installed for daily use.

**Steps:** already done by Brewfile (`google-chrome-dev`, `brave-browser` casks). Open each once to complete first-run setup.

**Verify:**

```bash
ls /Applications/ | grep -E 'Brave|Chrome Dev'
ls "/Applications/Google Chrome Dev.app/Contents/MacOS/Google Chrome Dev"
```

---

## Milestone 8 — Editors

See `bootstrap/editors.md` for extension restore.

**Goal:** Cursor + Windsurf installed, signed in, extensions restored, settings synced.

**Steps:** already done by Brewfile (`cursor`, `windsurf` casks). Open each, sign in, run extension install loop from `bootstrap/editors.md`.

**Verify:**

```bash
code --version | head -1      # Cursor's `code` rebrand
windsurf --version | head -1
code --list-extensions | wc -l        # ~22 (current snapshot)
windsurf --list-extensions | wc -l    # ~26
```

---

## Milestone 9 — Dotfiles allowlist clone

**Goal:** curated dotfiles restored without polluting `$HOME` with runtime junk.

**Steps:** depends on whether Q13 produced a `dotfiles/` repo (e.g. via `chezmoi` or `stow`).

```bash
# Example with chezmoi (replace with your repo URL):
brew install chezmoi          # add to Brewfile if standardized
chezmoi init --apply git@github.com:subkoks/dotfiles.git
```

**Verify:**

```bash
ls -la ~/.zshrc ~/.zshenv ~/.zprofile ~/AGENTS.md
diff -q ~/AGENTS.md ~/.local/share/chezmoi/dot_AGENTS.md.tmpl 2>/dev/null \
  || echo "chezmoi managed: ok"
```

---

## Milestone 10 — Project repos

Clone only repos that have a GitHub remote and were touched in the last 60 days (per Q11 default).

**Goal:** `~/Projects/Current/Active/*` populated with cloneable repos and built where needed.

**Steps:**

```bash
gh auth login           # HTTPS, follow prompts; select existing SSH keys NO if not migrated
mkdir -p ~/Projects/Current/{Active,Backlog} ~/Projects/{Experiments,Learning,Templates,Archives}

# Clone active set (example — replace with your real list):
cd ~/Projects/Current/Active
gh repo clone subkoks/agents-md
gh repo clone subkoks/BEST-Self-Enhancement-Learning-AI    # provides bsela MCP
gh repo clone subkoks/macos-bootstrap-2026                  # this very repo on the new machine
# ... etc — use Q11 default to derive list

# Build BSELA MCP (required by Claude `bsela` MCP server)
cd ~/Projects/Current/Active/BEST-Self-Enhancement-Learning-AI/mcp
pnpm install
pnpm build
ls dist/server.js                    # verify produced
```

**Verify:**

```bash
gh auth status                       # logged in, token valid
ls ~/Projects/Current/Active/        # expected repos present
test -f ~/Projects/Current/Active/BEST-Self-Enhancement-Learning-AI/mcp/dist/server.js
```

---

## Milestone 11 — AI tooling

See `bootstrap/ai_tooling.md` for per-root migrate/regen detail.

**Goal:** Claude Code CLI, Codex CLI, MCP servers all wired up. Rules + skills restored from canonical `~/.cursor/skills/` tree (synced into other editor roots).

**Steps:**

```bash
# Claude Code CLI (per Q6 default — npm global)
npm i -g @anthropic-ai/claude-code
claude --version

# Codex CLI (per Q7 — installer; do NOT migrate auth.json)
# Follow the official installer, then:
codex --version

# Restore curated AI rules / skills (allowlist-only):
#   ~/AGENTS.md
#   ~/.claude/CLAUDE.md, ~/.claude/settings.json, ~/.claude/rules/, ~/.claude/skills/
#   ~/.codex/AGENTS.md, ~/.codex/config.toml, ~/.codex/skills/, ~/.codex/rules/
#   ~/.cursor/rules/, ~/.cursor/skills/, ~/.cursor/agents/, ~/.cursor/hooks/
#   ~/.windsurf/rules/, ~/.windsurf/skills/
#   ~/.codeium/windsurf/memories/, ~/.codeium/windsurf/skills/
# Each of the above is in inventory's KEEP_NOW config block.
# DO NOT migrate ~/.codex/auth.json — re-authenticate fresh.

# MCP server registration:
#   - stdio via npx -y: auto-regen on first use, no migration needed
#   - local stdio binaries: install GitHub MCP server (`~/.local/bin/github-mcp-server`)
#   - bsela MCP: depends on Milestone 10's `pnpm build`
#   - Remote HTTP: re-authenticate per server (Postman, Vercel, Supabase, GDrive, Gmail)
# See bootstrap/ai_tooling.md §MCP for the full table.
```

**Verify:**

```bash
claude --version
codex --version
claude mcp list 2>&1 | tee /tmp/mcp.out
grep -c '✓ Connected' /tmp/mcp.out    # expect ≥ count from inventory minus remote-auth pending
ls ~/.cursor/skills/ | wc -l           # ≥ canonical skill count
ls -la ~/.claude/skills/ | grep '^l' | wc -l    # symlinks intact
```

---

## Milestone 12 — Final verification gauntlet

Run `bootstrap/post_install_checklist.md` end-to-end. Every check must pass before declaring Day 1 complete.

---

## Recovery / rollback notes

- This bootstrap **does not** modify the old machine. The old machine remains a fallback.
- If a step fails, capture the failure (`script /tmp/bootstrap.log` wrapper recommended) and revert *only* the failing milestone's effects (uninstall the failing brew, remove the partial extension, etc.).
- `brew bundle --file=bootstrap/Brewfile` is idempotent — safe to re-run after fixing.
- If Postgres data import is in scope (Q8), do it from `pg_dump` snapshots taken **before** wiping the old machine.
