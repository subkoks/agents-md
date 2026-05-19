# FRESH_SETUP_BLUEPRINT.md

The top-level plan for rebuilding `black.terminal`'s macOS dev workstation on a fresh install. Read this first; everything else is a section that this document links into.

> **Framing:** *fresh install*, not *migration*. Runtime state regenerates. Only curated config crosses machines.

---

## 1. Mission

Bring the new Mac to a state where:

1. The first 5 active projects in `~/Projects/Current/Active/` build and run.
2. Claude Code CLI (with full MCP set) operates against the same rules + skills as today.
3. Cursor + Windsurf open with the same extensions and same rules.
4. No secrets crossed machines. No transcripts crossed machines. No runtime caches crossed machines.

End-state is testable via `bootstrap/post_install_checklist.md` — no "it should work."

## 2. Inputs (ground truth)

- `inventory/inventory.raw.md` — full read-only inventory of the current machine
- `inventory/inventory.normalized.md` — deduplicated index with normalization notes
- `inventory/classification.csv` — every item tagged KEEP_NOW / KEEP_LATER / REGENERATE / DROP + priority
- `inventory/keep-now.txt`, `inventory/regenerate.txt` — quick lists
- `DECISIONS.md` — what the new machine will run (editable)
- `NON_GOALS.md` — what this project refuses to do
- `OPEN_QUESTIONS.md` — decisions blocking execution

## 3. Hard rules

Lifted from `NON_GOALS.md`; if anything below drifts, treat as a bug:

- No `~/` as a git repo. Dotfiles are allowlist-only.
- No secrets in git (`.env*`, `auth.json`, wallet keys, OAuth tokens).
- No blind migration of runtime state (caches, sessions, language servers).
- No destructive ops (`rm -rf`, `git push --force`, mass DB writes) without explicit user approval.
- No skipping pre-commit hooks or signing.

## 4. Skills wired into this repo

The following skills should auto-trigger inside this repo:

| Skill | Role |
|---|---|
| `macos-migration-orchestrator` | top-level orchestrator (calls the next three) |
| `macos-dev-inventory` | inventory framing methodology |
| `dotfiles-allowlist-auditor` | safe "what to git, what to ignore" policy for dotfiles |
| `agent-runtime-garbage-scanner` | distinguishes runtime churn from real config |
| `macos-machine-inventory` | re-runs the read-only inventory script |
| `coding-rules` | language/style conventions check |
| `create-plan` | tightening structured plans when scope spikes |
| `systematic-debug` | root-cause framing if something goes sideways during install |
| `dotfiles-allowlist-auditor` (again, paired) | review allowlist additions for hidden runtime garbage |
| `github-full-access-engineer` | GitHub repo bootstrap, branch protections, secrets management |

All ten are activated in `~/.claude/skills/` (verified). They auto-discover by SKILL.md frontmatter; nothing further required.

## 5. Decision-table at-a-glance

Full version in `DECISIONS.md`. Key choices:

| Area | Choice | Rationale |
|---|---|---|
| Hardware | **Intel** (`MacBookPro16,1`, `/usr/local`) — Q1 resolved 2026-05-07 | Matches `~/AGENTS.md` + inventory; change before install if target Mac is ARM |
| Shell | Zsh + oh-my-zsh + Powerlevel10k | Current setup; muscle memory |
| Brew prefix | `/opt/homebrew` (ARM) or `/usr/local` (Intel) | Per Q1 |
| Node | 22 LTS via nvm (not brew) | Single source of truth |
| Python | 3.13 via pyenv (not brew); uv + pipx | Single source of truth |
| Editors | Cursor (primary) + Windsurf (secondary) | Active tooling |
| Browsers | Brave (daily) + Google Chrome Dev (dev-browser MCP) | Per AGENTS.md |
| Container | **OrbStack** — Q2 resolved 2026-05-07 (`bootstrap/Brewfile`) | Lighter than Docker Desktop |
| Postgres / Redis | Brew services, started on install | Already in active use |
| Pentest tier | Opt-in `Brewfile.pentest` | Default Brewfile stays lean |
| Secrets | 1Password CLI default — gated on Q3 | Aligns with AGENTS.md |
| AI canonical tree | `~/.cursor/skills` + `agents` + `rules` | Other editors symlink in |

## 6. Milestone overview

Detailed in `bootstrap/install-order.md`. Order is deliberate — earlier steps unblock later ones.

| # | Milestone | Skills used | Verify path |
|---|---|---|---|
| 0 | macOS first-boot setup | — | `fdesetup status`, iCloud sync off |
| 1 | Xcode CLT | — | `xcode-select -p` |
| 2 | Rosetta 2 (ARM only) | — | `arch -x86_64 uname -m` |
| 3 | Homebrew | — | `brew doctor` |
| 4 | Brewfile bundle | `dotfiles-allowlist-auditor` | `brew bundle check` + services started + `psql` on PATH |
| 5 | Shell + fonts | — | p10k loads, MesloLGS NF visible |
| 6 | Runtimes (nvm + pyenv) | — | `node v22`, `python 3.13` |
| 7 | Browsers | — | Brave + Chrome Dev present |
| 8 | Editors (Cursor, Windsurf) | — | extensions list count matches snapshot |
| 9 | Dotfiles allowlist clone | `dotfiles-allowlist-auditor` | `~/AGENTS.md` + zsh dotfiles present |
| 10 | Project repos clone + BSELA build | `github-full-access-engineer` | `gh auth status`, BSELA `dist/server.js` |
| 11 | AI tooling install | `macos-migration-orchestrator`, `agent-runtime-garbage-scanner` | `claude --version`, `claude mcp list` |
| 12 | Final verification gauntlet | — | `bootstrap/post_install_checklist.md` |

**Critical correction from the original plan:** Milestone order is *brew → runtimes → editors+browsers → projects → AI tooling*, **not** *editors → AI tooling → projects*. The `bsela` MCP server depends on a project being cloned and built; the `chrome-devtools` MCP server depends on a browser cask. Wrong order silently breaks MCP registration.

## 7. PATH-mismatch fixes (the ones the inventory caught)

Bake these into the new install so we don't reproduce today's gaps:

| Today's gap | Fix in bootstrap |
|---|---|
| `psql` missing despite postgresql@16 service | Brewfile uses `link: true`; Milestone 4 verifies `psql --version` and falls back to `PATH="$(brew --prefix postgresql@16)/bin:$PATH"` if keg-only |
| `docker` CLI missing despite Docker Desktop installed | Q2 forces a single container runtime choice; Milestone 4 verifies `docker --version` after install |
| `mas`, `cargo`, `rustup`, `go`, `bun` "missing" warnings | None of these are KEEP_NOW; install on demand. Documented in `python_toolchain.md` / `node_toolchain.md` / `OPEN_QUESTIONS.md`. |
| FileVault Off (current state) | Q4 default: ON; recovery key into 1Password |

## 8. Day 1 — 90-minute checklist

Minimum gate to call Day 1 done. All blocks in `bootstrap/post_install_checklist.md`:

- [ ] **Block 0** — system (macOS version, FileVault, SIP)
- [ ] **Block 1** — Homebrew (brew doctor clean, bundle satisfied)
- [ ] **Block 2** — Postgres + Redis services started, `psql`/`redis-cli` work
- [ ] **Block 3** — `node 22`, `python 3.13`, single binary on PATH each
- [ ] **Block 4** — zsh + p10k + Nerd Font visible
- [ ] **Block 5** — Cursor opens, signs in, one extension restored end-to-end
- [ ] **Block 7** (partial) — `~/AGENTS.md` and zsh dotfiles in place
- [ ] **Block 9** — `claude --version` + `gh auth status` green
- [ ] **Block 10** (partial) — at least 4 MCP servers connected (`filesystem`, `postgres`, `memory`, `sequential-thinking`)
- [ ] **Block 12** — secret-leak negative checks all pass

If any of those fail: stop, capture the failure, open `OPEN_QUESTIONS.md` entry, fix root cause.

## 9. Week 1 completion

On top of Day 1:

- [ ] All Cursor + Windsurf extensions restored (Block 5 full)
- [ ] All AI rules / skills / agents restored via canonical cursor tree (Block 7 + 8 full)
- [ ] All MCP servers connected or in known re-auth state (Block 10 full)
- [ ] At least 5 active project repos cloned + bootstrapped (Block 11)
- [ ] BSELA MCP server built and registered (Block 10 + 11)
- [ ] Pentest tier installed if Q10 = yes
- [ ] Container runtime per Q2 working (`docker run hello-world` or equivalent)
- [ ] Secrets manager set up per Q3
- [ ] Dotfiles repo committed and applied per Q13
- [ ] All `OPEN_QUESTIONS.md` items resolved or tracked

## 10. Execution mode

- Run Claude Code CLI from inside `~/Projects/macos-bootstrap-2026/` so relative paths and skill triggers resolve correctly.
- Keep sessions single-purpose: this repo only. Switching projects mid-bootstrap costs more than it saves.
- After blueprint exists (now), execution splits into milestones (brew → runtimes → editors → projects → AI). Each milestone is its own short Claude session, opened with: *"Run Milestone N from `bootstrap/install-order.md`. Stop and report on first failed verify."*
- Capture every milestone's stdout: `script /tmp/milestone-N.log` wrapper recommended. Helps post-mortem if a verify fails on Day 2.

## 11. What this blueprint will NOT do (worth restating)

- Will not transfer transcript / session state between machines.
- Will not migrate `~/.codex/auth.json`, `~/.claude/.credentials*`, OAuth tokens.
- Will not commit anything matching the `.gitignore` patterns in this repo's root.
- Will not enable live-trading, real-money operations, or wallet signing automatically.
- Will not push branches, force-push, or amend commits without explicit user request (per `~/AGENTS.md` Hard Stop).

## 12. Next actions (handed back to user)

1. **Review** `DECISIONS.md` — especially §1 if the new Mac is not Intel.
2. **Skim** `OPEN_QUESTIONS.md` resolution table — reopen only if target hardware or container choice changes.
3. **Edit** `NON_GOALS.md` to add anything else this project should refuse.
4. **Push** this repo to GitHub (suggested: `subkoks/macos-bootstrap-2026`, private). Then on the new Mac, after Milestone 1, clone this repo and run `bootstrap/install-order.md` from inside it.
