# Agent upgrade roadmap (shipped history)

Historical archive of completed upgrade work. **Active backlog lives in
[ROADMAP.md](../ROADMAP.md)** (Now / Next / Later); release detail is in
[CHANGELOG.md](../CHANGELOG.md). When this file conflicts with those, trust them first.

## Shipped

- **v2.3.0** — world-class upgrade pillars B–F: GitHub landing README, `llms.txt`,
  `docs/llm-citation.md`, nine general-purpose skills, `install.sh`,
  `docs/threat-model.md`; prompt-interpretation rules in canonical gotcha; CI verifies
  `cursor.md` + `cursor.lean.md`.
- **v2.2.0** — root `AGENTS.md` (Cursor Cloud dev notes); canonical `src/gotcha-lean.md`
  with generated `dist/rules/cursor.lean.md`; GOTCHA v2.0 rule bodies; validators accept
  v2 headings.
- **v2.1.0** — consolidated `ci.yml` (`lint`/`validate`/`build`/`security-scan`); pinned
  lint gates and third-party actions to commit SHAs; `dependabot.yml`; MIT `LICENSE`;
  pre-commit hooks.
- **v2.0.0 / v1.0.0** — unified reusable artifact stack (`src/gotcha.md` +
  `src/gotcha-lean.md` → `dist/rules/*`); comprehensive validation + strict drift checks;
  Cursor lean/full artifacts; skills pack with `skills/registry.tsv`.

## Engineering hardening (post-v2.3.0)

- Cloud-readiness for Claude Code on the web (`SessionStart` hook, `scripts/cloud-setup.sh`).
- CI auto-review + auto-merge workflows, gated by author association and Dependabot-aware.
- bats-core test suite (`tests/`) and `make lint`/`make test`/`make ci` aggregators.

## Reference docs (current)

- [hook-reference.md](hook-reference.md)
- [agent-patterns.md](agent-patterns.md)
- [threat-model.md](threat-model.md)
- [releasing.md](releasing.md)
