# Changelog

All notable changes to the GOTCHA framework agent rules.

## [Unreleased]

### Added

- GitHub project scaffolding: issue templates, PR template, CI quality workflow, release-notes workflow, and `CODEOWNERS`
- New validation scripts:
  - `scripts/check-links.sh`
  - `scripts/check-rule-drift.sh`
- New architecture documents:
  - `docs/goals-manifest.md`
  - `docs/editor-alignment-strategy.md`
  - `docs/hook-portability-spec.md`
- Governance docs: `CONTRIBUTING.md`, `SECURITY.md`
- Crypto/Web3/Solana skill pack:
  - `skills/` with 12 domain skills (Solana Anchor, client kits, security, EVM contracts, DeFi, meme ops, flow analysis, trading risk, pump.fun automation, terminal workflows, sniper scripts)
  - Runtime layer: `scripts/sniper-config-template.yaml`, `scripts/pumpfun-bot-checklist.sh`, `scripts/sniper-journal-summary.sh`
  - Operations runbook: `docs/sniper-runbook.md`
- Specification docs:
  - `docs/security-scan-spec.md`
  - `docs/orchestration-dag-spec.md`

### Changed (Unreleased)

- Hardened `scripts/validate-rules.sh` to validate actual structure and required sections
- Improved `scripts/sync-to-windsurf.sh` with safer output and `DRY_RUN` support
- Upgraded `README.md` to document quality gates, alignment targets, and GitHub-ready workflows
- Refined `src/gotcha.md` with explicit layer boundaries and external alignment guidance

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
