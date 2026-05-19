# NON_GOALS.md

> **STATUS: draft — review before executing.** Inferred from `~/AGENTS.md` Hard Stop rules + the dotfiles-allowlist policy. Anything missing should be added before running the bootstrap.

What this project explicitly **refuses** to do. These are hard rules — Claude/Codex/Cursor sessions in this repo should treat any drift as a bug.

---

## 1. No tracking `~/` as a git repo

The home directory is **not** under version control. Dotfiles migration is **allowlist-only** (see the `dotfiles-allowlist-auditor` skill). Anything outside the allowlist stays local.

**Why:** runtime junk, cache files, secrets, and editor state explode commit history and leak credentials.

## 2. No secrets in git

Refused, no exceptions:

- `.env`, `.env.*`, `*.env`, `.envrc`
- `~/.codex/auth.json`, `~/.claude/.credentials*`, OAuth tokens
- API keys (Anthropic, OpenAI, Supabase, RPC providers, exchanges)
- Wallet seeds, mnemonics, private keys, keystore JSON
- SSH private keys
- Personal data (full address, phone, scanned IDs)

Verified by `.gitignore` patterns and a pre-commit guard if added later.

## 3. No blind migration of runtime state

Refused targets:

- Sessions, transcripts, history JSONLs (`~/.claude/sessions`, `~/.codex/sessions`, `~/.continue/sessions`, etc.)
- Caches (`__pycache__`, `node_modules`, `.next`, `.turbo`, `.ruff_cache`, `.mypy_cache`)
- Editor / agent runtime DBs (`~/.codex/state_*.sqlite*`, `~/.codex/logs_*.sqlite*`)
- Compiled language servers (`~/.codeium/language-server*`)
- Temporary working dirs (`~/.codex/.tmp`, `~/.windsurf/data/`, `~/.windsurf/worktrees/`)

These **regenerate** on use; migration just slows the new machine down and risks corrupted state.

## 4. No destructive commands without explicit approval

Refused without an explicit `proceed` from the user (per `~/AGENTS.md` Hard Stop):

- `rm -rf` against anything outside this repo or `/tmp`
- `git push --force`, `git reset --hard`, branch deletion, history rewrite
- `brew uninstall --force` of system-relied formulae
- `dropdb`, `truncate`, mass `DELETE` against any DB
- Any `sudo` operation that touches system services or `/Library`
- Any wallet signing, fund transfer, or live-trading execution

## 5. No skipping hooks or signing

Refused:

- `--no-verify` on git commits
- `--no-gpg-sign`, `-c commit.gpgsign=false`
- Disabling pre-commit / CI checks "to ship faster"

If a hook fails, fix the hook or fix the code.

## 6. No mixed package managers for the same role

Refused:

- `brew install python` while pyenv is primary.
- `npm install -g <thing>` when a project's `package.json` should pin it.
- Manual `pip install` outside a `.venv` or pipx isolation.
- MacPorts, Fink, alternate Homebrew prefixes.

One manager per role. Brew for system, pyenv/nvm for runtimes, pnpm/uv/pipx for project + isolated app installs.

## 7. No unscoped automation

Refused:

- Cron jobs / `launchd` agents that touch the bootstrap repo without an explicit task on `OPEN_QUESTIONS.md`.
- Auto-run scripts during `brew bundle install` other than what's documented in `bootstrap/install-order.md`.
- AI agent loops that mutate state without a commit hook gate.

## 8. No surveillance-grade telemetry

Refused:

- Sending shell history, project paths, or transcripts to third parties beyond what the AI editors already do under their published policy.
- Background analytics enabled by default (`.aider/analytics.json` — explicit opt-in only).

## 9. No "let me upgrade everything" detours

When working in this repo, don't:

- Switch to OrbStack just because Docker Desktop "feels heavy" — that's an `OPEN_QUESTIONS.md` decision.
- Migrate Postgres data from old machine via `pg_dumpall` unless explicitly part of a project import.
- Replace nvm with mise unilaterally (mise stays as fallback per `DECISIONS.md`).

Drift from the plan = open a question, don't act.

## 10. No real-money trading from this repo

Refused unconditionally:

- Live wallet signing.
- Live exchange API key usage.
- pump.fun / raydium live trades.
- Stake.com bot trades against the real account.

Simulation, dry-run, and read-only data flows are fine. Live execution is **out of scope** for this bootstrap.
