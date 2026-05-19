# OPEN_QUESTIONS.md

Decisions that block running the bootstrap. Resolve top-to-bottom.

> Convention: each question has a **default proposal** Claude can run with if the user says "go", and a **block reason** explaining why a wrong answer matters.

---

## Status: resolved (2026-05-07 — auto)

All Q1–Q13 were closed with **defaults aligned to `~/AGENTS.md` + inventory** (Intel `MacBookPro16,1`, `/usr/local`). Edits landed in `DECISIONS.md`, `bootstrap/Brewfile` (OrbStack), and pre-flight checkboxes in `bootstrap/install-order.md`.

| Q | Resolution |
|---|------------|
| Q1 | **Intel** — Homebrew `/usr/local`. If the next physical Mac is Apple Silicon, reopen Q1 and edit `DECISIONS.md` §1 + Milestone 2 in `install-order.md` before `brew bundle`. |
| Q2 | **OrbStack** — `cask "orbstack"` enabled in `bootstrap/Brewfile`. |
| Q3 | **1Password CLI (`op`)** — primary secrets manager. |
| Q4 | **FileVault ON** — recovery key in 1Password. |
| Q5 | **Drop `local/codexbar` tap** — manual CodexBar install if needed later. |
| Q6 | **Claude:** npm global CLI + `brew install --cask claude` desktop. |
| Q7 | **Codex:** official installer on new machine; migrate `~/.codex/AGENTS.md` + `config.toml` only; **never** migrate `auth.json`. |
| Q8 | **Fresh Postgres** — per-project seeds/migrations; explicit `pg_dump` only if a DB is irreplaceable. |
| Q9 | **No npm globals preinstalled** — on demand per project. |
| Q10 | **Pentest via `bootstrap/Brewfile.pentest` only** — opt-in. |
| Q11 | **Recreate `~/Projects/...` layout** — clone active remotes touched in last 60 days; cold storage for the rest. |
| Q12 | **`minimal` profile Day 1** — expand to `full` as needed. |
| Q13 | **New dotfiles repo** under `~/Projects/Current/Active/dotfiles/` — allowlist via `dotfiles-allowlist-auditor`. |

---

## 🚨 Q1 — Hardware target (Apple Silicon vs Intel) **[blocks Brewfile execution]**

**Block reason:** current machine is Intel `MacBookPro16,1` (`brew` at `/usr/local`). Several installed casks are Intel-specific (`codexbar-intel`, `dotnet-sdk` Intel build), and a few native dependencies in `brew leaves` rebuild differently on ARM. If the new machine is Apple Silicon, brew prefix moves to `/opt/homebrew`, Rosetta 2 may be needed, and a handful of casks need different names or are unavailable.

**Default proposal:** assume **Apple Silicon (M-series)**.
**If same Intel hardware:** keep `/usr/local`, skip Rosetta, keep `codexbar-intel` cask.
**If Apple Silicon:** change `/usr/local` → `/opt/homebrew`, drop `codexbar-intel`, install Rosetta 2 only if a specific Intel-only tool is required.

---

## Q2 — Container runtime **[blocks Brewfile commit on container line]**

**Block reason:** current state has `Docker Desktop.app` installed but **no `docker` CLI on PATH** (classified as DROP for the CLI, KEEP_LATER for the app). Three viable replacements; each implies different commands and resource overhead.

**Default proposal:** **OrbStack** (lighter, faster, drop-in `docker`/`docker compose`). Only switch back to Docker Desktop if a specific workflow needs Docker's UI.
**Alternatives:** Docker Desktop (heavy GUI), Colima (CLI-only Linux VM, lightest).

---

## Q3 — Secrets manager **[blocks live-trading + production deploys]**

**Block reason:** `~/AGENTS.md` requires "secrets stay in env vars sourced from a manager." Currently no manager is set up consistently. Live trading and production deploys are gated on this.

**Default proposal:** **1Password CLI (`op`)**. Falls back to Apple Keychain for local-only items.
**Alternatives:** Bitwarden CLI (`bw`), pass (gpg-based), Apple Keychain only.

---

## Q4 — FileVault state on new machine **[blocks first commit if data is sensitive]**

**Block reason:** inventory snapshot reports **FileVault is OFF** on the current machine. Default macOS install offers FileVault during setup; if the new machine holds wallet keys, repo signing keys, or any client data, FileVault should be on.

**Default proposal:** **FileVault ON**, recovery key stored in 1Password (or printed and stored offline).

---

## Q5 — `local/codexbar` tap **[blocks `brew bundle` if uncommented]**

**Block reason:** current Brewfile-style state has `local/codexbar` tap, which is a tap living only on the current machine's filesystem. `brew bundle` on the new machine will fail there.

**Default proposal:** **drop the tap and install CodexBar manually** from its upstream (or skip — it's a status-bar utility, not core). If keeping CodexBar matters, point `tap` at the public repo URL once known and replace `codexbar-intel` (Intel) with the appropriate variant.

---

## Q6 — Claude Code desktop / CLI install path **[blocks AI tooling milestone]**

**Block reason:** Claude Code can be installed multiple ways:
- npm global (`npm i -g @anthropic-ai/claude-code`)
- Native installer (downloaded from anthropic.com)
- Cask (`brew install --cask claude` for the desktop app)
The CLI and desktop are different products. Current setup has both `~/.claude/` (CLI) and `Claude.app` (desktop app shown in `/Applications`).

**Default proposal:** **CLI via npm global + desktop app via cask `claude`.** Validates with `claude --version` (CLI) and presence of `/Applications/Claude.app`.

---

## Q7 — Codex CLI install path **[blocks AI tooling milestone]**

**Block reason:** Codex CLI install paths vary (npm global, installer, or distro-specific). Current `codex` binary location is on PATH but not via `brew leaves`.

**Default proposal:** **install via the official OpenAI/Codex installer** (whichever the user is currently on); copy `~/.codex/AGENTS.md` and `~/.codex/config.toml` from the migrated rules; **do NOT migrate `~/.codex/auth.json`** (re-authenticate fresh on the new machine).

---

## Q8 — Postgres data: import or fresh? **[blocks projects-touching-DB milestone]**

**Block reason:** local Postgres 16 is running, but it's unclear which databases hold work-in-progress vs. throwaway local state.

**Default proposal:** **fresh Postgres** on new machine; per-project re-bootstrap from each repo's seed/migration scripts. If a specific local DB has unique data, dump it explicitly with `pg_dump -d <db> > <repo>/dumps/<db>-2026-05.sql` *before* wiping.

---

## Q9 — npm globals: re-install or skip? **[low blast radius]**

**Block reason:** `inventory/regenerate.txt` already classifies `~/.npm` and globals as REGENERATE. Question is which globals (if any) to re-install proactively vs. install on-demand per project.

**Default proposal:** **none preinstalled**. Re-install on-demand. Track recurring globals in `bootstrap/node_toolchain.md` over time.

---

## Q10 — Pentest tier: include in default Brewfile? **[low blast radius]**

**Block reason:** current `brew leaves` includes amass, exploitdb, feroxbuster, ffuf, gobuster, hashcat, hydra, john-jumbo, masscan, metasploit, nikto, nuclei, rustscan, sqlmap, subfinder. None are in `KEEP_NOW`. Pulling all would slow `brew bundle` significantly.

**Default proposal:** **opt-in via `bootstrap/Brewfile.pentest`** — `brew bundle --file=bootstrap/Brewfile.pentest` only when needed. Default Brewfile stays lean.

---

## Q11 — `~/Projects/` layout: keep current or restructure? **[medium blast radius]**

**Block reason:** `~/AGENTS.md` references `~/Projects/Current/Active/`, `~/Projects/Current/Backlog/`, `~/Projects/Experiments/`, `~/Projects/Learning/`, `~/Projects/Templates/`, `~/Projects/Archives/`. Bootstrap can recreate this layout or migrate as-is.

**Default proposal:** **recreate the layout, clone only repos that have a GitHub remote and were touched in the last 60 days.** The rest stays in a `~/Projects/cold-storage/` pulled lazily when needed.

---

## Q12 — Profile choice on Day 1 **[low blast radius]**

**Block reason:** Repo declares `profiles/minimal` and `profiles/full`; they're not yet populated.

**Default proposal:** **`minimal`** for Day 1, expand to `full` over Week 1 as actual workflows demand it.

---

## Q13 — Dotfiles repo: existing or new? **[medium blast radius]**

**Block reason:** dotfiles repo is allowlist-only per `NON_GOALS.md`. The user may already have one; or this bootstrap may be the trigger to create it.

**Default proposal:** **create a new `~/Projects/Current/Active/dotfiles/` repo** seeded by running `dotfiles-allowlist-auditor` skill against the inventory, then `chezmoi`/`stow` to install on the new machine.

---

## Notes for the user

- Each "default proposal" is what Claude will execute if you say `go on Q<n>` (or `go all` to accept defaults across the board).
- Anything you change here updates `DECISIONS.md` automatically before the bootstrap runs.
