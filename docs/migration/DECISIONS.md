# DECISIONS.md

> **STATUS: ready to execute — 2026-05-07.** Q1–Q13 resolved (see `OPEN_QUESTIONS.md` resolution log). Re-read §1 before `brew bundle` if the target machine is not Intel.

What the new macOS install will run. Default values are derived from the current setup (`inventory/`) plus `~/AGENTS.md` preferences. **Edit anything** before executing the bootstrap.

> Convention: each row is `Decision — Rationale`. Strike-through means rejected.

---

## 1. OS + hardware target

- **Target:** **Intel** — `MacBookPro16,1` class (matches current `~/AGENTS.md` + inventory). Homebrew prefix **`/usr/local`**. Rosetta **not** required for baseline Milestone 2.
- **If you later install on Apple Silicon:** edit this section first → `/opt/homebrew`, enable Rosetta only if an Intel-only tool demands it, re-verify cask names (`gpg-suite`, editors, etc.).
- **macOS version:** latest stable at install time (snapshot was 26.4.x).
- **Filesystem:** APFS default; **FileVault on** (recovery key in 1Password per Q4).

## 2. Shell + terminal

- **Shell:** Zsh (system default).
- **Prompt:** Powerlevel10k.
- **Terminal:** Apple Terminal.app primary; iTerm2 secondary; Warp installed but optional.
- **Font:** MesloLGS NF (P10k recommended) installed system-wide.

## 3. Package management

- **System:** Homebrew (`/opt/homebrew` on Apple Silicon, `/usr/local` on Intel).
- **Source of truth:** `bootstrap/Brewfile` — installed via `brew bundle --file=bootstrap/Brewfile`.
- **No mixed managers** for the same role (only brew for system packages).

## 4. Runtimes

| Runtime | Manager | Pin | Status |
|---|---|---|---|
| Node.js | nvm | 22 LTS | primary |
| Python | pyenv | 3.13 | primary |
| Ruby | system | (whatever ships) | not primary |
| Java | system | optional via brew if needed | optional |
| Deno | brew | latest | secondary |
| Rust | rustup | stable | install on demand, not preinstalled |
| Go | brew | latest | install on demand, not preinstalled |

`mise` is installed but **only as a fallback / secondary tool** — pyenv/nvm remain primary so existing project shims keep working.

## 5. JavaScript / TypeScript

- **Package manager:** `pnpm` via brew (use `command pnpm` in scripts to avoid shell-wrapper recursion).
- **Globals policy:** **regenerate** on new machine — do not migrate `~/.npm`, `~/.pnpm`. Rebuild from each project's `package.json`.
- **Node version selector:** per-project `.nvmrc` if needed; otherwise nvm default.

## 6. Python

- **Versions:** 3.13 default via pyenv; install 3.11 + 3.12 only if a project demands it.
- **Per-project envs:** `.venv` directories; **never** install into system Python.
- **Tooling:** `uv` for fast project deps; `pipx` for isolated CLI apps.

## 7. Services / data

- **PostgreSQL 16:** local via brew (`brew services start postgresql@16`).
- **Redis 8:** local via brew.
- **SQLite:** system + brew CLI.
- **Supabase:** CLI via brew; cloud projects untouched.
- **Container runtime:** **OrbStack** (`brew install --cask orbstack` via `bootstrap/Brewfile`). Use `docker` / `docker compose` from OrbStack; Docker Desktop not preinstalled.

## 8. Editors / IDEs

- **Primary code editor:** Cursor (cask).
- **Secondary:** Windsurf (cask).
- **Optional:** Xcode (App Store, only for macOS/iOS native work).
- **CLI launchers:** `code` (Cursor's `code` rebrand), `windsurf` — both verified after editor install.
- **Extensions:** see `bootstrap/editors.md` — restored from inventory's `code --list-extensions` and `windsurf --list-extensions` capture.

## 9. AI tooling stack

| Tool | Status | Notes |
|---|---|---|
| Claude Code (CLI) | keep | install via `npm i -g @anthropic-ai/claude-code` (or installer) |
| Codex CLI | keep | via brew or installer |
| Cursor | keep | cask |
| Windsurf | keep | cask |
| Codeium (legacy `~/.codeium/windsurf`) | regenerate-only | no migration of legacy state |
| Continue.dev | optional | install only if used in last 30 days |
| Aider | optional | not currently in active workflow |
| Ollama | not preinstalled | install on demand (per cleanup memory `cleanup_2026_04_16.md`) |
| LM Studio | not preinstalled | install on demand |

**Migrate (curated config only):** `~/AGENTS.md`, `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`, `~/.cursor/rules/`, `~/.windsurf/rules/`, `~/.codeium/windsurf/memories/`, the canonical `~/.cursor/skills/` tree, the canonical `~/.cursor/agents/` tree.
**Regenerate:** everything in `inventory/regenerate.txt`.

## 10. Browsers

- **Primary:** Brave Browser (cask).
- **Secondary:** Google Chrome Dev (cask) for dev tooling, `dev-browser` workflow.
- Safari stays system default for casual / Apple-ecosystem use.

## 11. Crypto / Solana

Per `~/AGENTS.md` Solana-first stance:
- **Default chain:** Solana.
- **SDK:** `@solana/kit` for new code; legacy `@solana/web3.js` only via `@solana/web3-compat`.
- **Wallets:** Phantom embedded for app dev; never store seed phrases in repos or `.env`.
- **Live trading:** **disabled by default** — explicit user gate required, separated simulation from execution.

## 12. Git identity + GitHub

- **Author:** `black.terminal <subkoks@gmail.com>` (system git config).
- **GitHub user:** `subkoks`.
- **Auth:** `gh auth login` (HTTPS + SSO). SSH key generated fresh on each machine; never migrated.
- **Default branch:** `main`. Force-push to main blocked.

## 13. Secrets / credentials

- **Manager:** **1Password CLI (`op`)** — primary; Apple Keychain acceptable for purely local items.
- **Repo policy:** every secret stays in env vars sourced from a manager — never committed.
- **Sensitive runtime files** (do not migrate): `~/.codex/auth.json`, `~/.claude/.credentials*`, OAuth tokens, RPC API keys, exchange API keys.

## 14. Backup / sync

- **Source repos:** GitHub remotes are canonical. Local `~/Projects/Current/Active/*` mirrored.
- **Dotfiles:** allowlist-only repo (separate from this bootstrap repo) — see `bootstrap/ai_tooling.md` and the `dotfiles-allowlist-auditor` skill.
- **Time Machine:** off the table for transferring runtime state to the new machine; useful only as a panic-button restore.

## 15. Profiles

Two profiles defined under `profiles/` (optional, populated later if useful):

- **minimal** — only what's needed for first-week productivity (Brewfile-min subset).
- **full** — everything in KEEP_NOW + KEEP_LATER.

Default is **minimal first**, expand to full when a real workflow needs an item.
