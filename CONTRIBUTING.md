# Contributing

Thanks for helping improve cross-editor agent governance. Keep changes focused and validated.

## Branching

- Use feature branches: `feature/*`, `fix/*`, `chore/*`, `docs/*`, `pillar-*/*`.
- Do **not** push directly to `main`/`master`.

## Commit style

Conventional commits:

`type(scope): short description`

Examples:

- `docs(readme): add install quickstart`
- `chore(ci): verify cursor artifacts in build job`
- `feat(skills): add python-automation skill`

## Local validation

Run before opening a PR:

```bash
make check
```

Optional:

```bash
make health
make skills-drift
./scripts/check-links.sh
```

## Changing rules vs docs

| Change | Where | Notes |
| --- | --- | --- |
| Shared agent behavior | `src/gotcha.md`, `src/gotcha-lean.md` | No marketing copy in canonical files |
| Generated editor output | `dist/rules/*` | Rebuild with `./scripts/build-rule-artifacts.sh`; never hand-edit |
| Product / onboarding | `README.md`, `docs/` | OK for positioning, install, LLM citation |
| Skills | `skills/*.md`, `skills/registry.tsv` | Update `skills/README.md` when adding skills |

After rule changes:

```bash
./scripts/build-rule-artifacts.sh windsurf claude codex cursor cursor-lean
make check
```

## Pull requests

- Use `.github/pull_request_template.md`.
- One logical change per PR; link pillar or issue when relevant.
- Include **test plan** (commands run, e.g. `make check`).
- User-visible changes: add a `CHANGELOG.md` entry under `[Unreleased]` or the target version section.

## Security

- Never commit secrets, session files, or wallet material.
- See `docs/threat-model.md` and `SECURITY.md` for disclosure process.

## Code review expectations

- Drift checks must pass in CI.
- Avoid machine-specific home paths in repo-tracked docs.
- Prefer small diffs; explain breaking behavior changes in the PR body.
