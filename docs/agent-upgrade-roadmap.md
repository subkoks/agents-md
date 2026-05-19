# Agent upgrade roadmap (status)

Historical planning doc. **Completed items** are archived here; active backlog lives in [ROADMAP.md](../ROADMAP.md) and GitHub issues.

## Completed (v2.x)

- Unified reusable artifact stack: `src/gotcha.md` + `src/gotcha-lean.md` with generated `dist/rules/*`
- Comprehensive validation and strict drift checks (`make check`, governance pipeline)
- Cursor lean + full artifacts (`cursor.lean.md`, `cursor.md`) and explicit manual install flow
- Skills pack with registry (`skills/registry.tsv`)
- v2.2.0 release: `AGENTS.md`, `CHANGELOG.md`, tag `v2.2.0`
- World-class upgrade pillars (in flight): GitHub landing, `llms.txt`, general skills, `install.sh`, trust/CI hygiene

## In progress / tracked elsewhere

| Initiative | Tracking |
| --- | --- |
| GitHub README conversion (Pillar B) | PR #17 |
| AI discoverability `llms.txt` (Pillar C) | PR #18 |
| General skills expansion (Pillar D) | PR #19 |
| `install.sh` onboarding (Pillar E) | PR #20 |
| CONTRIBUTING, threat model, CI cursor verify (Pillar F) | open PR |

## Future themes (not scheduled)

- v2.3+ tool integration patterns in canonical rules
- v2.4 debugging workflows (partially covered by `skills/debugging-protocol.md` after Pillar D)
- v2.5 harness reliability controls
- v2.6 security/risk scanning hooks
- v3.0 multi-agent orchestration spec

## Reference docs (current)

- [hook-reference.md](hook-reference.md)
- [agent-patterns.md](agent-patterns.md)
- [threat-model.md](threat-model.md)

When this file conflicts with `README.md` or `CHANGELOG.md`, trust those sources first.
