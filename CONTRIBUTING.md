# Contributing

## Branching

- Use feature branches: `feature/*`, `fix/*`, `chore/*`, `docs/*`.
- Do not push directly to `main`/`master`.

## Commit Style

Use conventional format:

`type(scope): short description`

Examples:

- `docs(readme): add github workflow guidance`
- `chore(scripts): harden rule validation`

## Local Validation

Run before opening PR:

```bash
./scripts/validate-rules.sh
./scripts/check-links.sh
./scripts/check-local-drift.sh
```

## Pull Requests

- Use `.github/pull_request_template.md`.
- Keep one logical change per PR.
- Include risk and rollback notes.

## Documentation Expectations

- Keep rules concise and behavior-focused.
- Put long references in `docs/` rather than `src/gotcha.md`.
- Update `CHANGELOG.md` for user-visible changes.
