# Tool Integration Patterns

Provider-neutral guidance for composing deterministic tools and MCP servers
reliably. Companion to the canonical **Tool and Command Policy** in
`src/gotcha.md` and the hook contracts in
[hook-portability-spec.md](hook-portability-spec.md).

Principle: push reliability into deterministic glue (verify, fall back, log),
keep flexibility in orchestration. Never assume a tool's output shape — validate
it before chaining.

## Capability discovery

Before calling a tool, know what it offers and what it costs. Prefer an explicit
capability declaration over guessing:

```yaml
# capability record (one per server)
name: db
capabilities: [query, migrate, storage_upload]
requires: [project_id]
rate_limit: 60/min
transport: stdio        # prefer stdio/https; flag plain http (see security-scan SEC-MCP-001)
```

- Resolve the tool by capability, not by hardcoded name, where more than one
  server can satisfy a need.
- Treat missing capability as a planning error, surfaced early — not a runtime
  surprise mid-chain.

## Composition patterns

### Sequential chain

Output of A becomes input of B. Verify between stages.

```text
get_changed_files → assess_schema_impact → commit
```

- Verify output format and non-empty results before passing downstream.
- Log intermediate results so a mid-chain failure is diagnosable.

### Parallel execution

Run genuinely independent operations concurrently, then join.

```text
run_e2e_tests  ||  run_migrations   → aggregate → proceed
```

- Only for operations with no data dependency.
- Set a per-tool timeout; aggregate all results before the next step.

### Fallback chain

Try the primary; on failure use a simpler/faster secondary. Always explicit.

```text
rich_analysis  → [on failure] →  basic_lookup
```

- Define the fallback explicitly; never let it be implicit.
- The fallback should be simpler and cheaper, not an equal-cost retry.
- Log which path was taken so behavior is auditable.

### Conditional branching

Pick a tool by a deterministic condition; both branches reach the same goal.

```text
if changed_files > 10:  batch_commit
else:                   single_commit
```

## Error handling

| Failure | Response |
| --- | --- |
| Tool unavailable | Fall back to a documented alternative (e.g. shell `git push` if a Git MCP is down) |
| Rate limited | Honor `retry_after`; back off and retry, don't hammer |
| Output mismatch | Validate type/shape; on mismatch, fail loudly with context rather than chaining garbage |
| Timeout | Cancel, log, and either fall back or surface the blockage — never hang silently |

## Anti-patterns

- **Blind chaining** — assuming an output format without verifying it.
- **Nested calls** — tool A invoking tool B inside A; use an explicit sequential chain instead.
- **Implicit fallback** — not documenting what happens on failure.
- **Orphan results** — tool output neither used nor logged.
- **Name-coupled routing** — hardcoding a server name where capability-based resolution would survive a swap.

## Relationship to hooks

Routing hooks can select tools by capability; quality hooks gate risky tool calls;
audit hooks log which tool/branch ran. See
[hook-runtime-profiles.md](hook-runtime-profiles.md) for enabling these per profile.
