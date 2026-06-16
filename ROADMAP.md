# Roadmap

Direction for the GOTCHA governance framework. Organized **Now / Next / Later** —
themes, not calendar dates. Each item names an acceptance criterion so "done" is
unambiguous. Released history lives in [CHANGELOG.md](CHANGELOG.md); shipped
milestones are archived in [docs/agent-upgrade-roadmap.md](docs/agent-upgrade-roadmap.md).

> Status as of 2026-06-14: latest release **v2.3.0**. CI gates are green
> (`lint → validate → build → test → security-scan`).

---

## Now — in this cycle

Work that is committed and actively landing.

- [ ] **Script test suite** — bats-core tests under `tests/` exercise the build,
      drift, validation, skills-drift, install, and health scripts.
      *Done when:* `make test` is green and CI runs a `test` job on every PR.
- [ ] **Local CI mirror** — `make lint` / `make test` / `make ci` reproduce the
      GitHub pipeline locally. *Done when:* `make ci` runs lint + check + skills-drift + test in one command.
- [ ] **Release discipline** — documented SemVer policy and release checklist.
      *Done when:* [docs/releasing.md](docs/releasing.md) exists and `CHANGELOG.md`
      has no stale `[Unreleased]` backlog at release time.
- [ ] **Planning-doc truth-up** — roadmap and history reflect reality (no merged
      PRs listed as "in progress"). *Done when:* this file + the archive cite only
      current state.
- [x] **Config self-scan** — `scripts/security-scan.sh` ships seven detectors
      (critical→low), `terminal`/`json`/`markdown` output, safe `--fix` for
      auto-fixable findings, and a CI step blocking on `high+`.
      (spec: [docs/security-scan-spec.md](docs/security-scan-spec.md))

## Next — committed, not yet started

Specced in `docs/`, ready to pull into a cycle.

- [ ] **Harness reliability controls** — hook runtime profiles (`minimal|standard|strict`),
      env-driven hook disable list, pre-compact state capture, stop-phase telemetry.
      *Done when:* profiles toggle hooks without editing files and a session summary
      is persisted at end-of-turn. (spec: [docs/hook-reference.md](docs/hook-reference.md))
- [ ] **Config self-scan** — audit this repo's own `.claude/`, hooks, and MCP/tool
      permissions for dangerous defaults, graded `critical/high/medium/low/info`.
      *Done when:* a scan script emits JSON + markdown and an optional CI gate fails
      above a threshold. (spec: [docs/security-scan-spec.md](docs/security-scan-spec.md),
      [docs/threat-model.md](docs/threat-model.md))
- [ ] **Tool-integration patterns** — canonical guidance for tool chaining, fallback
      on primary-tool failure, and MCP capability discovery.
      *Done when:* patterns are captured in `docs/` and referenced from the rule body.
- [x] **Harness reliability controls** — cumulative hook runtime profiles
      (`minimal|standard|strict`), `DISABLED_HOOKS` env override, stop-phase
      session telemetry, and pre-compact state capture ship as editor-agnostic
      scripts with bats coverage.
      (docs: [docs/hook-runtime-profiles.md](docs/hook-runtime-profiles.md))
- [x] **Tool-integration patterns** — chaining, fallback on primary-tool failure,
      and capability-based resolution captured in
      [docs/tool-integration-patterns.md](docs/tool-integration-patterns.md) and
      referenced from the canonical rule body.

## Later — directional

Worth doing; sequencing not yet decided.

- [ ] **Multi-agent orchestration** — agent roles, handoff protocol, conflict
      resolution, DAG/wave scheduler, budget guardrails, final quality gate, session
      replay. (spec: [docs/orchestration-dag-spec.md](docs/orchestration-dag-spec.md))
- [ ] **Debugging workflows** — hypothesis tracking, auto-isolation/min-repro,
      root-cause templates, regression-test generation (partly in
      `skills/debugging-protocol.md`).
- [~] **Multi-agent orchestration** — the DAG parser + wave scheduler ship as
      `scripts/dag-schedule.sh` (cycle/dangling detection, `make dag`).
      *Remaining:* file locking, budget/time guardrails, quality-gate phase, and
      event replay — runtime concerns for an orchestrator that consumes the waves.
      (spec: [docs/orchestration-dag-spec.md](docs/orchestration-dag-spec.md))
- [x] **Debugging workflows** — hypothesis-tracking journal
      (`scripts/debug-journal.sh`), root-cause templates, minimal-repro and
      regression-test-first guidance in
      [docs/debugging-workflows.md](docs/debugging-workflows.md).
- [x] **LLM-native rules** — `scripts/build-structured-rules.sh` projects
      `src/gotcha.md` into a queryable `gotcha.rules.json`
      (schema `gotcha-rules/v1`) + `gotcha.rules.tsv`; `scripts/query-rules.sh`
      filters by type/severity/section/tag; built + drift-checked in CI and
      `make governance-run`.
      (docs: [docs/llm-native-rules.md](docs/llm-native-rules.md))

---

## Experiments

Need validation before promotion to **Next**.

- **LLM-native rules** — encode select rules as structured triggers/actions the agent
  can query, instead of prose.
- **Per-project rule versioning** — projects pin a `gotcha` version with local overrides.
- **Skill marketplace** — community-contributed rule modules under `skills/`.
- **Model routing strategy** — route tasks to models by complexity/cost, with a
  per-run budget cap.
- **Continuous learning loop** — capture recurring session patterns and promote
  high-confidence ones into rules.

---

## Won't Do

Considered and rejected.

- **Natural-language rules** — too ambiguous; interpreted differently each run.
- **Rule inheritance** — complexity without clear benefit.
- **Hot-reload rules** — risk of mid-task behavior change.
