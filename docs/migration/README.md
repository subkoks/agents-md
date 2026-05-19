# macos-bootstrap-2026

Fresh-install plan + execution scripts for rebuilding a macOS dev workstation from evidence — **not a blind migration**.

## Mission

Rebuild on a fresh macOS install while:

- Regenerating runtime state (caches, sessions, transcripts, logs).
- Migrating only curated config (rules, allowlisted dotfiles, key project repos).
- Verifying every install milestone with a concrete pass/fail check.
- Never committing secrets and never tracking `~/` as a git repo.

## Inputs (ground truth)

Frozen snapshot of the current machine, captured 2026-05-05:

| File | Purpose |
|---|---|
| `inventory/inventory.raw.md` | Full read-only inventory output |
| `inventory/inventory.normalized.md` | Deduplicated, normalized index + policy |
| `inventory/classification.csv` | Per-item KEEP_NOW / KEEP_LATER / REGENERATE / DROP + priority |
| `inventory/keep-now.txt` | Critical day-1 list |
| `inventory/regenerate.txt` | Runtime paths to recreate, never migrate |
| `DECISIONS.md` | What the new machine will run (editable by user) |
| `NON_GOALS.md` | What this project refuses to do (editable by user) |

## Deliverables

| File | Status | Purpose |
|---|---|---|
| `FRESH_SETUP_BLUEPRINT.md` | drafted | End-to-end plan, milestones, Day-1 / Week-1 checklists |
| `bootstrap/install-order.md` | drafted | Ordered install steps with verify commands |
| `bootstrap/Brewfile` | drafted | `brew bundle` source-of-truth |
| `bootstrap/node_toolchain.md` | drafted | nvm + Node 22 + pnpm policy |
| `bootstrap/python_toolchain.md` | drafted | pyenv + Python 3.13 + uv + pipx policy |
| `bootstrap/editors.md` | drafted | Cursor + Windsurf + extensions |
| `bootstrap/ai_tooling.md` | drafted | Per-root migrate/regen table for ~/.claude, ~/.cursor, etc. |
| `bootstrap/post_install_checklist.md` | drafted | Final pass/fail gate |
| `OPEN_QUESTIONS.md` | resolved (2026-05-07) | Q1–Q13 closed; see resolution table at top of file |

## How to use

1. Skim `DECISIONS.md` — defaults are set for Intel + OrbStack + 1Password; override if your target Mac differs.
2. Edit `NON_GOALS.md` to add anything else this project should refuse.
3. `OPEN_QUESTIONS.md` is resolved (2026-05-07); reopen only if hardware or runtime choices change.
4. On the new Mac: follow `bootstrap/install-order.md` step by step.
5. After each milestone: run the matching block in `bootstrap/post_install_checklist.md`.

## Repo layout

```
.
├── README.md
├── DECISIONS.md
├── NON_GOALS.md
├── OPEN_QUESTIONS.md
├── FRESH_SETUP_BLUEPRINT.md
├── inventory/                  # frozen evidence from current machine
├── bootstrap/                  # actionable install plan
│   ├── install-order.md
│   ├── Brewfile
│   ├── node_toolchain.md
│   ├── python_toolchain.md
│   ├── editors.md
│   ├── ai_tooling.md
│   └── post_install_checklist.md
└── profiles/                   # optional: minimal vs full variants
```

## Hard rules (also in `NON_GOALS.md`)

- **No `~/` as a git repo.** Dotfiles are allowlist-only.
- **No secrets in git.** `.env*`, `auth.json`, wallet keys — all gitignored.
- **No blind migration.** Runtime state (caches, sessions, transcripts) regenerates.
- **Verify after every milestone.** No "should work" — show the passing command.
