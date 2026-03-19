# agents-md

Canonical source for a cross-editor agent operating system built on the GOTCHA framework.

## What This Repository Is

`agents-md` is the project-local control plane for high-quality agent behavior:

- canonical rule body (`src/gotcha.md`)
- pattern and ecosystem database (`docs/`)
- operational scripts (`scripts/`)
- reusable templates (`templates/`)
- roadmap and experiments (`ROADMAP.md`, `ideas/`)

This repo is intentionally editor-agnostic and aligns behavior across Windsurf, Claude, and Codex.

## Architecture (GOTCHA)

- **G**oals: explicit work routing and workflow selection
- **O**rchestration: the agent decision layer
- **T**ools: deterministic scripts and MCP operations
- **C**ontext: static reference material
- **H**ard prompts: focused task templates
- **A**rgs: runtime behavior settings

Core principle: push reliability into deterministic tooling, keep reasoning flexibility in orchestration.

## Repository Layout

```text
agents-md/
├── src/
│   └── gotcha.md
├── docs/
│   ├── agent-database.md
│   ├── agent-patterns.md
│   ├── agent-upgrade-roadmap.md
│   ├── hook-reference.md
│   └── ...
├── scripts/
│   ├── sync-to-windsurf.sh
│   ├── validate-rules.sh
│   ├── check-links.sh
│   ├── check-rule-drift.sh
│   ├── sniper-config-template.yaml
│   ├── pumpfun-bot-checklist.sh
│   └── sniper-journal-summary.sh
├── skills/
│   ├── README.md
│   ├── solana-anchor-program-dev.md
│   ├── solana-client-kit-and-wallets.md
│   ├── solana-security-and-audit.md
│   ├── evm-smart-contract-dev.md
│   ├── defi-protocol-engineering.md
│   ├── token-launch-and-memecoin-ops.md
│   ├── onchain-trading-and-flow-analysis.md
│   ├── memecoin-trading-risk-playbook.md
│   ├── pumpfun-launch-and-trading-automation.md
│   ├── solana-terminal-workflows-axiom-padre-nova.md
│   └── solana-sniper-bot-scripts-and-ops.md
├── templates/
├── ideas/
├── ROADMAP.md
└── CHANGELOG.md
```

## Quick Start

```bash
# Validate rules and check compatibility
./scripts/validate-comprehensive.sh

# Sync to all editors
./scripts/sync-all.sh

# Or sync to specific targets
./scripts/sync-all.sh windsurf claude

# Check current status
./scripts/sync-all.sh --list
```

## Quality Gates

- Comprehensive validation: `scripts/validate-comprehensive.sh`
  - Rule structure and integrity
  - Cross-editor compatibility
  - Version drift detection
  - Target accessibility
  - Content integrity
- Individual checks: `scripts/validate-rules.sh`, `scripts/check-links.sh`, `scripts/check-rule-drift.sh`
- Automated hooks: Pre-commit and CI/CD validation

All scripts degrade safely when optional dependencies are missing.

## External Alignment Targets

- `~/.windsurf/rules/gotcha.md`
- `~/.claude/CLAUDE.md`
- `~/.codex/AGENTS.md`
- `~/.codex/skills/coding-rules/`
- `~/.windsurf/context/*`, `~/.windsurf/workflows/*`, `~/.windsurf/hardprompts/*`

## GitHub-Ready Workflow

1. Run local validation:

```bash
./scripts/validate-comprehensive.sh
```

2. Create branch and commit logically grouped changes (pre-commit hooks run automatically).

3. Open PR using `.github/pull_request_template.md`.

4. CI automatically validates:
   - Rule structure and integrity
   - Cross-editor compatibility
   - Version drift detection
   - Security scanning
   - Target sync testing

5. Ensure all CI checks pass.

6. Merge and update `CHANGELOG.md`.

## Sniper Bot Quick Start

```bash
chmod +x scripts/pumpfun-bot-checklist.sh scripts/sniper-journal-summary.sh
cp scripts/sniper-config-template.yaml sniper-config.yaml
./scripts/pumpfun-bot-checklist.sh ./sniper-config.yaml
# After trading:
./scripts/sniper-journal-summary.sh ./logs/sniper-events.jsonl
```

## Core Documents

- `docs/agent-database.md`: curated inventory and source map
- `docs/agent-patterns.md`: normalized reusable patterns
- `docs/hook-reference.md`: hook behavior and portability notes
- `docs/editor-alignment-strategy.md`: wrapper and sync strategy by editor
- `docs/hook-portability-spec.md`: generic hook contract model
- `docs/goals-manifest.md`: task-to-asset routing matrix
- `docs/security-scan-spec.md`: config security scanner taxonomy and output schema
- `docs/orchestration-dag-spec.md`: dependency-graph orchestration and quality-gate contract
- `docs/sniper-runbook.md`: sniper bot preflight, runtime monitoring, and incident playbooks
- `skills/README.md`: crypto/web3/Solana skill index and trigger map

## Versioning

See `CHANGELOG.md` for release history and unreleased changes.
