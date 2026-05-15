# AGENTS.md

## Cursor Cloud specific instructions

This is a documentation/rules governance repo (no runtime services). The "application" is the set of bash scripts that validate, build, and check drift of canonical rule artifacts.

### Key commands

| Action | Command |
| --- | --- |
| Full governance pipeline | `make governance-run` |
| Strict validation + drift | `make check` |
| Build artifacts | `./scripts/build-rule-artifacts.sh` |
| Health check (with logs) | `make health` |
| Lint shell scripts | `shellcheck -e SC1091 -e SC2155 scripts/*.sh` |
| Lint markdown | `markdownlint-cli2 "**/*.md" "#dist" "#node_modules" "#CHANGELOG.md"` |
| Lint GitHub Actions | `actionlint` |
| Run all pre-commit hooks | `pre-commit run --all-files` |

### Gotchas

- `pre-commit install` requires `git config --unset-all core.hooksPath` first if `core.hooksPath` is set.
- shellcheck exclusions used by the project: `-e SC1091 -e SC2155` (see `.pre-commit-config.yaml`).
- Built artifacts go to `dist/rules/` (gitignored). Always regenerate via `scripts/build-rule-artifacts.sh` rather than editing directly.
- No language runtime dependencies (no npm/pip/cargo install needed). Only system tools: `bash`, `shellcheck`, `markdownlint-cli2`, `actionlint`, `pre-commit`.
- `make check` includes a strict drift check that fails if `dist/rules/` artifacts are missing. Run `./scripts/build-rule-artifacts.sh` first (or use `make governance-run` which builds then checks).
- Some pre-existing pre-commit failures exist in the repo (trailing whitespace in `ideas/`, duplicate YAML key in `.github/rulesets/code-review.yml`, git executable bits on two scripts). These are not caused by agent changes.
