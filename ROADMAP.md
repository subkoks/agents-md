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

## Later — directional

Worth doing; sequencing not yet decided.

- [ ] **Multi-agent orchestration** — agent roles, handoff protocol, conflict
      resolution, DAG/wave scheduler, budget guardrails, final quality gate, session
      replay. (spec: [docs/orchestration-dag-spec.md](docs/orchestration-dag-spec.md))
- [ ] **Debugging workflows** — hypothesis tracking, auto-isolation/min-repro,
      root-cause templates, regression-test generation (partly in
      `skills/debugging-protocol.md`).

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
