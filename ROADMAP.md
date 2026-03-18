# Roadmap

Planned improvements and experiments for the GOTCHA framework.

---

## v1.1 — Auto Mode Enhancements

**Target:** Q2 2026

### Ideas

- [ ] **Progress logging** — Auto Mode writes progress to `~/.windsurf/data/logs/` every 5 minutes
- [ ] **Checkpoint system** — Save state before risky operations, auto-rollback on failure
- [ ] **Notification hooks** — Telegram/Discord webhook when Auto Mode completes or hits hard stop
- [ ] **Time limits** — Auto Mode timeout with summary of what was done
- [ ] **Task queue** — Queue multiple tasks for overnight execution

### Questions

- How to handle long-running tasks that span multiple sessions?
- What's the right granularity for progress logging?

---

## v1.2 — Tool Integration Patterns

**Target:** Q3 2026

### Ideas

- [ ] **MCP server registry** — Standardized way to register and discover MCP capabilities
- [ ] **Tool chaining rules** — Best practices for piping output between tools
- [ ] **Fallback patterns** — What to do when primary tool fails
- [ ] **Tool versioning** — Handle breaking changes in MCP servers gracefully

### Questions

- Should tools have explicit capability declarations?
- How to handle tool conflicts (multiple servers offering same feature)?

---

## v1.3 — Debugging Workflows

**Target:** Q3 2026

### Ideas

- [ ] **Hypothesis tracking** — Structured format for debugging hypotheses and results
- [ ] **Auto-isolation** — Automatically create minimal reproduction when bug found
- [ ] **Root cause templates** — Common root cause patterns to check first
- [ ] **Regression test generation** — Auto-generate test from bug fix

---

## v2.0 — Multi-Agent Orchestration

**Target:** Q4 2026

### Ideas

- [ ] **Agent roles** — Specialized agents (frontend, backend, security, testing)
- [ ] **Handoff protocols** — How agents pass work to each other
- [ ] **Conflict resolution** — When multiple agents modify same files
- [ ] **Parallel execution** — Run independent tasks concurrently

### Questions

- How to maintain context across agent handoffs?
- What's the right level of specialization?

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

---

## Won't Do

Ideas considered and rejected.

- **Natural language rules** — Too ambiguous, LLM interprets differently each time
- **Rule inheritance** — Adds complexity without clear benefit
- **Hot-reload rules** — Risk of mid-task behavior change
