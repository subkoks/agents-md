# Editor Alignment Strategy

Canonical body is maintained in this repository and synchronized into editor-specific wrappers with minimal, explicit divergence.

## Canonical Source

- `src/gotcha.md` is the only canonical rule body.

## Wrapper Targets

- `~/.windsurf/rules/gotcha.md`
- `~/.claude/CLAUDE.md`
- `~/.codex/AGENTS.md`

## Allowed Divergence

Only wrapper-specific concerns may differ:

- hook integration notes
- tool metadata and capabilities
- editor command routing references
- session/context maintenance notes

Everything else should remain semantically aligned with canonical behavior.

## Sync Procedure

1. Update `src/gotcha.md` first.
2. Run `scripts/validate-rules.sh`.
3. Run `scripts/check-rule-drift.sh`.
4. Run `scripts/sync-to-windsurf.sh`.
5. Apply equivalent wrapper sync for Claude/Codex if drift remains.

## Drift Policy

- Drift in behavior sections is a defect and should be corrected quickly.
- Drift in wrapper-only sections is acceptable when documented.
- Any intentional divergence must be captured in `CHANGELOG.md`.
