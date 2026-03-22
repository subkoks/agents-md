# Hook Routing Model

Defines where each hook belongs to avoid duplicated or conflicting automation.

## Global Hooks

Use only for safety and governance controls shared across all repos:

- canonical/artifact rule guard
- destructive-action safeguards
- minimal environment sanity checks

Do not put domain business logic in global hooks.

## Project Hooks

Use for repo-specific behavior:

- test/lint/build gates tied to that project
- schema/migration checks
- framework-specific policy

Project hooks can be stricter than global hooks.

## Editor-Specific Hooks

Use only for editor workflows:

- editor context refresh
- editor command helpers
- editor-specific rule packaging

Do not make editor-only hooks required for CLI-only workflows.

## Conflict Policy

- If the same behavior is implemented in multiple layers, keep one owner and remove duplicates.
- Preferred ownership order:
  1. project hook (if domain-specific)
  2. global hook (if generic safety)
  3. editor hook (if editor-only UX)

## Operational Rule

- Any hook that touches canonical rules must route through `scripts/run-governance.sh`.
