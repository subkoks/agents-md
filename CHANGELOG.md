# Changelog

All notable changes to the GOTCHA framework agent rules.

## [Unreleased]

### Added

- Auto-merge workflow (`.github/workflows/auto-merge.yml`) — enables GitHub auto-merge on same-repo, non-draft PRs from owner/member/collaborator authors once all required status checks pass

### Changed

- Auto-merge workflow now also enables auto-merge on same-repo Dependabot PRs (`dependabot[bot]`), in addition to owner/member/collaborator authors

## [2.3.0] - 2026-05-15

### Added

- World-class upgrade pillars B–F: GitHub landing README, `llms.txt`, `docs/llm-citation.md`, nine general-purpose skills, `install.sh`, `docs/threat-model.md`
- **Prompt interpretation** rules in canonical gotcha (infer messy prompts; ship code/steps; no rewrite gatekeeping)

### Changed

- `CONTRIBUTING.md`, CI verifies `cursor.md` + `cursor.lean.md`, deduped legacy issue template markdown
- Refreshed `docs/agent-upgrade-roadmap.md` status

## [2.2.0] - 2026-05-15

### Added

- Root `AGENTS.md` with Cursor Cloud dev-environment instructions (commands, gotchas)
- Canonical `src/gotcha-lean.md` and generated `dist/rules/cursor.lean.md` artifact
- GOTCHA v2.0 rule bodies: expanded code quality, tool policy, Solana/crypto defaults, and AI agent patterns in `src/gotcha.md`

### Changed

- Validators (`validate-rules.sh`, `validate-comprehensive.sh`) accept v2 section headings and ignore prose "no TODOs" mentions
- Squash-merged governance and rules work from PRs #13–#15

### Fixed

- Removed duplicate `.github/PULL_REQUEST_TEMPLATE.md` index path that broke macOS case-sensitive checkouts (#13)
- Markdownlint table alignment in `AGENTS.md` (#14)

## [2.1.0] - 2026-04-19

### Added

- Three behavior-focused sections in `src/gotcha.md`: `Mission`, `Hard Stop`, and `Token / Cost Discipline`
- Consolidated `.github/workflows/ci.yml` with `lint`, `validate`, `build`, and `security-scan` jobs
- Pinned lint gates in CI: `shellcheck`, `actionlint`, `markdownlint-cli2`
- `.github/dependabot.yml` for weekly GitHub Actions updates
- Repo-level `.markdownlint-cli2.jsonc` configuration
- Pinned pre-commit hooks for trailing whitespace, YAML, merge conflicts, shellcheck, markdownlint, actionlint
- MIT `LICENSE`

### Changed

- Pinned every third-party GitHub Action (`actions/checkout`, `trufflesecurity/trufflehog`, `ludeeus/action-shellcheck`, `rhysd/actionlint`, `DavidAnson/markdownlint-cli2-action`) to an immutable commit SHA
- Added explicit per-job `permissions: contents: read` across all workflows (with `release-notes` keeping its own `contents: write` scope)
- Replaced bare `set -e` with `set -euo pipefail` in `validate-rules.sh`, `check-links.sh`, `recover-sync.sh`
- Hardened `scripts/sniper-journal-summary.sh` jq invocation with `--arg date`

### Fixed

- 17 `((VAR++))` Bash bugs that exited the script under `set -e` when the counter started at 0
- Redundant `((ERRORS++))` double-counting in `validate-comprehensive.sh`
- `file` command invocation when the binary is unavailable in minimal CI containers
- Deterministic ordering in `check-links.sh` and `check-skill-registry-drift.sh` via `LC_ALL=C sort`

### Removed

- Deprecated stub scripts `sync-all.sh`, `sync-to-windsurf.sh`, `check-rule-drift.sh`, `install-global-rule-hook.sh`
- Redundant `.github/workflows/quality.yml` and `.github/workflows/validate-rules.yml` (merged into `ci.yml`)
- `wrappers-list` Makefile target

## [2.0.0] - 2026-03-22

### Added (2.0.0)

- `scripts/build-rule-artifacts.sh` for repository-local artifact packaging
- `scripts/check-local-drift.sh` for canonical-to-artifact drift detection
- Local skill registry model in `skills/registry.tsv`

### Changed (2.0.0)

- Replaced home-directory sync workflow with repository-local governance flow
- Refactored `scripts/run-governance.sh` to validate/build/check local artifacts
- Refocused `scripts/validate-comprehensive.sh` on portable repo checks
- Updated `README.md`, templates, and CI workflows to use local artifact commands
- Updated `src/gotcha.md` to remove personal machine alignment references

## [1.0.0] - 2026-03-17

### Added (1.0.0)

- **Merged superfile** — Combined AGENTS.md, fullaccess.md, coding-conventions.md, performance.md into single gotcha.md (283 lines)
- **16 sections** — Complete agent operating system in one file
- **Auto Mode** — Overnight agent with full autonomy, hard stop capability
- **Execution Autonomy** — Streamlined permissions for routine tasks
- **Planning vs Implementation** — Dual-mode behavior rules
- **User Context & Environment** — Full machine specs, iTerm2 integration

### Changed (1.0.0)

- Removed Cursor AI (uninstalled)
- Removed Ollama (experimental, not in use)
- Updated machine specs with full details (CPU cores, RAM speed, GPU, SSD)
- Changed shell to iTerm2 (default terminal, integrated with Windsurf)

### Removed (1.0.0)

- `fullaccess.md` — Merged into gotcha.md
- `coding-conventions.md` — Merged into gotcha.md
- `performance.md` — Merged into gotcha.md

### Structure (1.0.0)

```text
1. GOTCHA Framework (6 layers)
2. Operating Principles
3. Execution Autonomy & Auto Mode
4. Operating Rules
5. Planning vs. Implementation
6. Code Style (General, TS/JS, Python, React/Next.js)
7. Error Handling
8. Git
9. Security
10. Testing
11. Performance
12. Debugging
13. Tool Usage
14. Project Structure Convention
15. User Context & Environment
16. Your Job
```

---

## [0.1.0] - 2026-02-06

### Added (0.1.0)

- Initial GOTCHA framework installation
- ATLAS workflow (`/build-app` command)
- Memory system (SQLite + daily logs)
- 6-layer agentic architecture
