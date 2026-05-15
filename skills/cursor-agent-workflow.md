---
name: cursor-agent-workflow
description: Use when structuring Cursor agent sessions, rules, subagents, hooks, and governance for reliable long-running tasks.
---

# Cursor Agent Workflow

## When to Use

- Setting up or tuning Cursor rules (lean vs full)
- Multi-step agent tasks with drift risk
- Subagent delegation (`/verifier`, `/test-runner`, etc.)
- Syncing canonical rules from agents-md

## Implementation Workflow

1. Identify canonical source: project `AGENTS.md` vs personal overlay vs `agents-md` sync.
2. Prefer lean always-on rules; attach full rules manually when needed.
3. Scope tasks: one concern per agent phase; bounded context.
4. Run `make check` / governance pipeline after rule changes.
5. Use subagents for review, tests, and CI — not for unrelated feature work.

## Hard Rules

- Do not hand-edit generated `dist/rules/*`; rebuild from `src/gotcha.md`.
- Read-only MCP first; mutating second; destructive = explicit approval.
- Same tool call >2× without progress → stop and re-plan.
- Feature branches only; never force-push protected branches.

## Done Criteria

- Rules validate; artifacts in sync with canonical.
- Task has clear done criteria; verifier or tests run when code changed.

## Related Skills

- `mcp-tools-and-servers.md`
- `debugging-protocol.md`
