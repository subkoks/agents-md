# Editor Alignment Strategy

Canonical body is maintained in this repository and packaged into local, editor-labeled artifacts with minimal, explicit divergence.

## Canonical Source

- `src/gotcha.md` is the only canonical rule body.
- Artifact files are package targets, not authoring targets.

## Local Artifact Targets

- `dist/rules/windsurf.md`
- `dist/rules/claude.md`
- `dist/rules/codex.md`

## Allowed Divergence

Only artifact-specific concerns may differ:

- hook integration notes
- tool metadata and capabilities
- editor command routing references
- session/context maintenance notes

Everything else should remain semantically aligned with canonical behavior.

## Sync Procedure

1. Update `src/gotcha.md` first.
2. Run `scripts/validate-comprehensive.sh --strict`.
3. Run `scripts/check-local-drift.sh` (pre-build state).
4. Run `scripts/build-rule-artifacts.sh`.
5. Run `scripts/check-local-drift.sh --strict` (post-build state).

## Layering and Precedence Contract

Rule precedence is strict:

1. Project-local override files (additive constraints only).
2. Local packaged artifacts generated from canonical source.
3. Tool default behavior.

Project overrides should never copy full global rule bodies.

## Drift Policy

- Drift in behavior sections is a defect and should be corrected quickly.
- Drift in artifact-only formatting sections is acceptable when documented.
- Any intentional divergence must be captured in `CHANGELOG.md`.
- Artifact-only edits without canonical update should be rejected by pre-commit guard.
