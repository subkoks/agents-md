# Bugbot — agents-md review rules

## Repository type

Governance and rules packaging — no runtime app. Focus on script safety, artifact integrity, and drift prevention.

## Blocking issues

- Never commit secrets, tokens, or live credentials in rules, scripts, or examples.
- Flag direct edits to `dist/rules/**` — artifacts must be regenerated via `scripts/build-rule-artifacts.sh`.
- Flag skill registry drift: new `skills/*.md` without registry updates (see `scripts/check-skill-registry-drift.sh`).
- Flag broken links in user-facing docs when `scripts/check-links.sh` would fail.
- Flag shell scripts without `shellcheck`-clean patterns (project uses `-e SC1091 -e SC2155`).

## Crypto / Solana skills (`skills/**`)

- Trading and sniper skills must include risk disclaimers and safeguards (slippage, caps, cooldowns) — flag removal of safety language.
- Security skills must not encourage unauthorized offensive testing.

## CI / GitHub Actions (`.github/**`)

- Flag workflow steps that echo secrets or use unpinned third-party actions without SHA pinning when touching security-sensitive workflows.
- `actionlint` expectations: valid YAML, no duplicate keys in rulesets.

## Docs-only PRs

- Non-blocking for typo-only markdown in `ideas/` or `drafts/` unless governance scripts break.

## Before merge

- Prefer green: `make check` or `make governance-run` when scripts/workflows change.
- Conventional commits; stage files by name, not `git add .`.
