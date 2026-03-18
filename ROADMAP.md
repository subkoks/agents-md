# Roadmap

Planned improvements and experiments for the GOTCHA framework.

---

## v1.1 — Auto Mode Enhancements

**Target:** Q2 2026

### Ideas (v1.1)

- [ ] **Progress logging** — Auto Mode writes progress to `~/.windsurf/data/logs/` every 5 minutes
- [ ] **Checkpoint system** — Save state before risky operations, auto-rollback on failure
- [ ] **Notification hooks** — Telegram/Discord webhook when Auto Mode completes or hits hard stop
- [ ] **Time limits** — Auto Mode timeout with summary of what was done
- [ ] **Task queue** — Queue multiple tasks for overnight execution

### Questions (v1.1)

- How to handle long-running tasks that span multiple sessions?
- What's the right granularity for progress logging?

---

## v1.2 — Tool Integration Patterns

**Target:** Q3 2026

### Ideas (v1.2)

- [ ] **MCP server registry** — Standardized way to register and discover MCP capabilities
- [ ] **Tool chaining rules** — Best practices for piping output between tools
- [ ] **Fallback patterns** — What to do when primary tool fails
- [ ] **Tool versioning** — Handle breaking changes in MCP servers gracefully

### Questions (v1.2)

- Should tools have explicit capability declarations?
- How to handle tool conflicts (multiple servers offering same feature)?

---

## v1.3 — Debugging Workflows

**Target:** Q3 2026

### Ideas (v1.3)

- [ ] **Hypothesis tracking** — Structured format for debugging hypotheses and results
- [ ] **Auto-isolation** — Automatically create minimal reproduction when bug found
- [ ] **Root cause templates** — Common root cause patterns to check first
- [ ] **Regression test generation** — Auto-generate test from bug fix

---

## v1.4 — Harness Reliability Controls

**Target:** Q3 2026

### Ideas (v1.4)

- [ ] **Hook runtime profiles** — Add `minimal|standard|strict` profiles to enable/disable expensive hooks without editing files
- [ ] **Hook disable list** — Add env-driven selective hook disable (`DISABLED_HOOKS=...`) for temporary suppression with traceability
- [ ] **Pre-compact state capture** — Persist state before compaction to reduce context-loss regressions
- [ ] **Stop-phase telemetry** — Persist session summary, extracted patterns, and cost metrics at end-of-turn/session
- [ ] **Quality-gate command** — Add explicit command/workflow that runs all local checks in one deterministic sequence

### Questions (v1.4)

- Which hooks should be strict-only vs always-on?
- What is acceptable overhead budget per hook phase?

---

## v1.5 — Security and Risk Scanning

**Target:** Q4 2026

### Ideas (v1.5)

- [ ] **Agent config scanner** — Audit rules/hooks/MCP/tool permissions for dangerous defaults
- [ ] **Severity model** — Grade findings with `critical/high/medium/low/info` and an overall score
- [ ] **Auto-fix class** — Auto-fix only safe classes (hardcoded secret references, wildcard permissions narrowing suggestions)
- [ ] **CI security gate** — Optional GitHub workflow that fails PRs above a configurable severity threshold
- [ ] **Threat report export** — JSON + markdown output for CI and documentation pipelines

### Questions (v1.5)

- Which finding classes should be block-on-merge?
- Should security scan run on each PR or only nightly?

---

## v2.0 — Multi-Agent Orchestration

**Target:** Q4 2026

### Ideas (v2.0)

- [ ] **Agent roles** — Specialized agents (frontend, backend, security, testing)
- [ ] **Handoff protocols** — How agents pass work to each other
- [ ] **Conflict resolution** — When multiple agents modify same files
- [ ] **Parallel execution** — Run independent tasks concurrently
- [ ] **Dependency graph scheduler** — Execute by DAG/waves instead of flat task lists
- [ ] **Budget guardrails** — Cost and runtime limits for multi-agent runs
- [ ] **Final quality gate** — Senior-agent pass over combined outputs before completion
- [ ] **Session replay** — Record orchestration timeline and replay for debugging/postmortems

### Questions (v2.0)

- How to maintain context across agent handoffs?
- What's the right level of specialization?
- How do we balance decomposition quality vs orchestration latency?
- When should quality-gate failure trigger partial rollback?

---

## Experiments

Ideas that need validation before committing to roadmap.

### LLM-Native Rules

Instead of markdown rules, encode rules as structured data that LLM can query:

```json
{
  "rule": "never_run_destructive_without_confirmation",
  "triggers": ["rm", "delete", "drop"],
  "action": "ask_confirmation",
  "exceptions": ["auto_mode"]
}
```

### Rule Versioning Per Project

Each project pins to a specific version of gotcha.md:

```yaml
# .agents-version
gotcha_version: "1.0.0"
overrides:
  - custom-rules.md
```

### Skill Marketplace

Community-contributed rule modules:

```
~/.agents/skills/
├── solana-dev/
├── react-native/
├── security-audit/
└── ...
```

### Model Routing Strategy

Route tasks to models by complexity and cost profile:

```yaml
model_routing:
  planning: high_reasoning_model
  worker_tasks: low_cost_model
  final_review: high_reasoning_model
  budget_usd_per_run: 5.00
```

### Continuous Learning Loop

Capture recurring patterns from sessions and promote validated ones:

```yaml
learning:
  observe_tool_usage: true
  extract_patterns_on_stop: true
  promote_threshold: high_confidence
```

---

## Won't Do

Ideas considered and rejected.

- **Natural language rules** — Too ambiguous, LLM interprets differently each time
- **Rule inheritance** — Adds complexity without clear benefit
- **Hot-reload rules** — Risk of mid-task behavior change
