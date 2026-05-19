# agents-md

**Reusable GOTCHA rule source → validated artifacts for Cursor, Claude Code, Codex, and Windsurf.**

[![CI](https://github.com/subkoks/agents-md/actions/workflows/ci.yml/badge.svg)](https://github.com/subkoks/agents-md/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Release](https://img.shields.io/github/v/release/subkoks/agents-md)](https://github.com/subkoks/agents-md/releases)

Cross-editor **agent governance**: cursor rules, `AGENTS.md`-compatible project instructions, drift-checked builds, and a growing skill pack. Compatible with the community **AGENTS.md** convention — this repo is not the standard itself and does not control `~/AGENTS.md`.

## 60-second quickstart

```bash
git clone https://github.com/subkoks/agents-md.git
cd agents-md

# Strict validation + artifact drift check
make check

# Build all editor artifacts from src/gotcha.md
./scripts/build-rule-artifacts.sh windsurf claude codex cursor cursor-lean

# Optional manual install: deploy Cursor artifacts to local Cursor config
make install-cursor-local
```

Project rule bodies live in `src/gotcha.md` (full) and `src/gotcha-lean.md` (default lean install). **Never edit `dist/rules/*` by hand** — rebuild with `scripts/build-rule-artifacts.sh`. For machine-wide behavior, keep `~/AGENTS.md` upstream.

## Who this is for

| Good fit | Not a fit |
| --- | --- |
| Vibe coders and indie builders using multiple AI editors | Teams that want a hosted SaaS product |
| Automation-heavy devs (scripts, bots, MCP, CI agents) | “Drop one file and never think about rules again” with zero maintenance |
| Maintainers who want **one rule source, many outputs** | Replacing your entire security/compliance program |
| Solana/crypto workflows (optional skill pack) | Non-technical users who will not run `make check` |

## Editor / output matrix

| Editor / runtime | Generated artifact | Typical deploy target |
| --- | --- | --- |
| **Cursor** (lean, always-on) | `dist/rules/cursor.lean.md` | `.cursor/rules/gotcha.mdc` |
| **Cursor** (full, manual) | `dist/rules/cursor.md` | `.cursor/rules/gotcha-full.mdc` |
| **Claude Code** | `dist/rules/claude.md` | Project `CLAUDE.md` or optional local copy |
| **Codex CLI** | `dist/rules/codex.md` | Project `AGENTS.md` or optional local copy |
| **Windsurf** | `dist/rules/windsurf.md` | Windsurf rules path per their docs |

Repo root **`AGENTS.md`** documents Cursor Cloud / agent dev commands for *this* governance repo. For your app repos, copy or adapt generated artifacts — do not treat `AGENTS.md` here as your product’s agent file unless you fork the pattern.

## GOTCHA (why this exists)

- **G**oals — task routing and workflow selection
- **O**rchestration — agent decision layer
- **T**ools — deterministic scripts and MCP
- **C**ontext — static reference in `docs/`
- **H**ard prompts — focused templates
- **A**rgs — runtime behavior (Auto Mode, Hard Stop, token discipline)

Push reliability into **scripts and CI**; keep flexibility in orchestration.

## Trust strip

| Control | What it does |
| --- | --- |
| **CI** | `lint` → `validate` → `build` → `security-scan` (TruffleHog on PRs) |
| **Drift** | `check-local-drift.sh` — canonical `src/gotcha.md` must match `dist/rules/*` |
| **License** | MIT — see [LICENSE](LICENSE) |
| **Secrets** | No credentials in rules; pre-commit + TruffleHog |
| **Governance** | `make governance-run` — validate → build → strict drift |

## Daily commands

```bash
make check              # strict validation + drift
make governance-run     # full pipeline
make health             # timestamped report in logs/health/
make skills-drift       # skills/registry.tsv vs skills/*.md
```

## Repository layout

```text
agents-md/
├── src/gotcha.md              # canonical full rules
├── src/gotcha-lean.md         # lean default
├── dist/rules/                # generated (gitignored)
├── scripts/                   # validate, build, drift, health
├── skills/                    # optional domain skills + registry.tsv
├── docs/                      # patterns, hooks, LLM citation, threat model
├── templates/
├── AGENTS.md                  # agent dev notes for this repo
└── CHANGELOG.md
```

## Skills

General-purpose and crypto/web3 skills live under [`skills/`](skills/README.md). Triggers are registered in `skills/registry.tsv`; run `make skills-drift` after adding skills.

## AI discoverability

For LLMs and search: [`llms.txt`](llms.txt) (repo index) and [`docs/llm-citation.md`](docs/llm-citation.md) (factual Q&A for citations). Keywords: cursor rules, AGENTS.md, cross-editor agent instructions, agent governance.

## FAQ

### How is this different from copying rules into `~/.cursor/rules`?

Within this repo, `src/gotcha.md` and `src/gotcha-lean.md` are the source for generated artifacts. They are not upstream of `~/AGENTS.md`; keep machine-wide rules in `~/AGENTS.md`.

### Does this replace AGENTS.md?

No. Many tools read project **`AGENTS.md`**. This project **generates** editor-specific files from one canonical body and stays compatible with that convention. Say “AGENTS.md-compatible,” not “we own AGENTS.md.”

### Cursor rules vs gotcha.md?

- **`gotcha-lean`** → small always-applied Cursor rule (`gotcha.mdc`).
- **Full `gotcha.md`** → larger reference (`gotcha-full.mdc` or manual @-mention).
Build with `./scripts/build-rule-artifacts.sh cursor cursor-lean`.

### What must run before a PR?

### Install Cursor rules (lean default)

From a clone of this repo (macOS or Linux):

```bash
git clone https://github.com/subkoks/agents-md.git
cd agents-md
./install.sh          # ~/.cursor/rules/gotcha.mdc (backs up existing)
./install.sh --full   # also installs gotcha-full.mdc for manual @gotcha-full
./install.sh --dry-run
```

Developers with a working tree can use `make install-cursor-local` instead (same destinations). This is a manual local install, not a global rules sync.

### Validate and build

```bash
make check
```

CI runs the same gates plus artifact rebuild verification.

### Where is marketing copy allowed?

README, `docs/`, `AGENTS.md`, skills — **not** inside `src/gotcha.md` / `src/gotcha-lean.md`.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Use feature branches; one logical change per PR; update [CHANGELOG.md](CHANGELOG.md) for user-visible releases.

## Versioning

Release history: [CHANGELOG.md](CHANGELOG.md) · Latest: [Releases](https://github.com/subkoks/agents-md/releases)

---

If this saves you time, **[star the repo](https://github.com/subkoks/agents-md)** and watch for releases. Forks and PRs welcome.
