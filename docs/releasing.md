# Releasing

How versions are cut for this repo. The "product" is the canonical rule bodies
(`src/gotcha*.md`), the generated artifacts (`dist/rules/*`), and the governance
scripts (`scripts/*.sh`, `install.sh`). Versioning follows [SemVer](https://semver.org/)
applied to **consumer-visible behavior**, not internal churn.

## What bumps which number

| Bump | When | Examples |
| --- | --- | --- |
| **MAJOR** (`x.0.0`) | Breaking change to rule semantics, artifact format, or a script's CLI/exit contract | Rename/remove a canonical section consumers rely on; change `dist/rules/*` layout; drop a script flag |
| **MINOR** (`x.y.0`) | Backward-compatible feature or additive rule content | New skill, new `make` target, new tests, new optional script flag, additive rule guidance |
| **PATCH** (`x.y.z`) | Fixes and internal-only changes with no consumer-visible behavior change | CI workflow tweaks, doc fixes, lint cleanup, dependency bumps |

Rule of thumb: if someone consuming the generated artifacts or running the scripts
would notice and might have to change something → MAJOR. If they get something new
but nothing breaks → MINOR. If they'd never notice → PATCH.

## Release checklist

1. **Green local mirror** — `make ci` (lint + check + skills-drift + test) passes.
2. **Rebuild artifacts** — `./scripts/build-rule-artifacts.sh windsurf claude codex cursor cursor-lean`
   then `make check` (strict drift must be clean; `dist/rules/*` is gitignored and
   regenerated, never hand-edited).
3. **Cut the changelog** — move everything under `## [Unreleased]` into a new
   `## [X.Y.Z] - YYYY-MM-DD` section; leave a fresh empty `[Unreleased]`.
4. **Commit** on a release branch — `chore(release): vX.Y.Z`.
5. **Tag** — `git tag vX.Y.Z && git push origin vX.Y.Z` (annotated tags preferred).
6. **Verify** — `release-notes.yml` publishes the GitHub release from the tag; confirm
   notes match the changelog section.

## Changelog flow

- Every user-visible PR adds an entry under `## [Unreleased]` (see `CONTRIBUTING.md`).
- `[Unreleased]` is the staging area; cutting a release renames it to the version.
- Keep entries grouped `Added` / `Changed` / `Fixed` / `Removed` (Keep a Changelog style).

## Hotfix

For an urgent PATCH off a release: branch from the tag, fix, bump PATCH, follow the
checklist from step 1. Forward-port the fix to `main` if it diverged.
