# Session checkpoint — 2026-05-15

Resume here after machine restart.

## Repo state (`agents-md`)

- **Branch:** `main` (up to date with origin)
- **Latest release:** [v2.3.0](https://github.com/subkoks/agents-md/releases/tag/v2.3.0)
- **Merged PRs:** #17 (B) #18 (C) #19 (D) #20 (E) #21 (F) #22 (prompt interpretation)

## What shipped (world-class upgrade)

| Pillar | Deliverable |
| --- | --- |
| A | v2.2.0 — `AGENTS.md`, CHANGELOG |
| B | README landing, `docs/github-repo-metadata.md` |
| C | `llms.txt`, `docs/llm-citation.md` |
| D | 9 general skills + registry |
| E | `install.sh` + README install block |
| F | CONTRIBUTING, `docs/threat-model.md`, CI cursor artifacts, issue template dedupe |

## Personal rules (your machine)

- **`~/AGENTS.md`** — new **Prompt interpretation** section; version bumped to 2.1
- **Historical mirror:** `src/gotcha.md` + `src/gotcha-lean.md` (merged #22; no longer upstream of `~/AGENTS.md`)
- **Cursor deployed:** historical local install had written `~/.cursor/rules/gotcha.mdc` + `gotcha-full.mdc`
- **Codex:** `~/.codex/AGENTS.md` — prompt block added (older file layout)
- **Claude:** `~/.claude/CLAUDE.md` imports `@~/AGENTS.md`

## Quick commands after restart

```bash
cd ~/Projects/Current/Active/agents-md
git checkout main && git pull
make check
# optional: ./install.sh --dry-run
```

## Optional next (not started)

- Fix v2.3.0 GitHub release notes body if empty
- Refresh `docs/agent-upgrade-roadmap.md` to “all pillars merged”
- Sync Windsurf `~/.windsurf/rules/gotcha.md` from `dist/rules/windsurf.md`
- Growth: profile README pin, external post

## Chat reference

Cursor transcript: `c9796f7d-fb19-4510-b769-dd8209a099ac`
