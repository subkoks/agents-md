# Goals Manifest

Routing matrix for mapping intent to the right project asset.

| Goal | Primary Asset | Secondary Asset | Output |
| --- | --- | --- | --- |
| Build/Refactor system | `docs/agent-patterns.md` | `docs/agent-upgrade-roadmap.md` | phase-based implementation plan |
| Rule updates | `src/gotcha.md` | `docs/extending-rules.md` | canonical rule diff + changelog entry |
| Code review | `docs/agent-patterns.md` | `docs/hook-reference.md` | risk-ranked findings |
| Security audit | `docs/hook-reference.md` | `docs/agent-database.md` | threat and control checklist |
| Hook design | `docs/hook-portability-spec.md` | `docs/hook-reference.md` | editor-aware hook contract |
| Debugging workflow | `ideas/debugging-workflows.md` | `docs/agent-patterns.md` | hypothesis-driven fix loop |
| Cross-editor sync | `docs/editor-alignment-strategy.md` | `scripts/check-rule-drift.sh` | drift report + sync actions |

## Routing Rules

- Pick one primary asset before edits.
- If a task crosses multiple layers, keep rule updates minimal and move detail to docs/workflows.
- If route is ambiguous, default to canonical source first (`src/gotcha.md` for behavior, `docs/*` for reference).
