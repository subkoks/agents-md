# Orchestration DAG Spec

Implementation specification for multi-agent execution using dependency graphs, conflict controls, and quality gating.

## Objectives

- Execute independent tasks in parallel safely.
- Respect dependency order deterministically.
- Prevent file-level conflicts.
- Enforce budget and runtime guardrails.
- Add final integrated quality review.

## Task Model

```json
{
  "taskId": "task-auth-routes",
  "description": "Migrate auth middleware to API routes",
  "dependencies": ["task-schema-audit"],
  "ownerAgent": "backend",
  "estimatedCostUsd": 0.35,
  "targetFiles": ["src/api/auth.ts"],
  "retryLimit": 2
}
```

## Scheduling Model

- Build DAG from `dependencies`.
- Execute tasks in waves (all zero-in-degree tasks concurrently).
- Recompute eligible tasks after each completion.
- Abort on cycle detection with explicit graph error.

## Conflict and Locking Rules

- Pessimistic file locks at task start for `targetFiles`.
- Lock contention policy:
  - wait if dependency-related
  - reschedule if independent
  - fail if starvation threshold exceeded
- Lock metadata is logged for replay and postmortem.

## Budget and Time Guardrails

- `maxBudgetUsd` hard stop.
- `maxRunDuration` hard stop.
- Optional per-task token/cost ceiling.
- On breach:
  - cancel not-started tasks
  - finish in-flight tasks only if safe
  - emit partial completion report

## Retry Policy

- Retry only transient failures.
- Backoff strategy: linear or exponential (configurable).
- Stop retries early on deterministic validation errors.

## Quality Gate Phase

Run a final high-reasoning review after worker tasks finish:

- verify cross-task consistency
- detect missed integration edges
- detect security and regression risks
- return `pass|fail|pass_with_warnings`

On gate failure, route to fix tasks or rollback workflow.

## Event Log and Replay

Persist structured timeline:

```json
{
  "timestamp": "2026-03-18T22:00:00Z",
  "event": "task_completed",
  "taskId": "task-auth-routes",
  "agent": "backend",
  "costUsd": 0.29,
  "locks": ["src/api/auth.ts"]
}
```

Replay requirements:

- deterministic event order
- wave visualization
- lock contention trace
- budget burn chart

## Config Contract

```yaml
orchestration:
  maxConcurrentAgents: 4
  maxBudgetUsd: 5.0
  maxRunDuration: 45m
  retryLimit: 2
  qualityGate: true
  lockPolicy: pessimistic
```

## Wave scheduler (reference implementation)

`scripts/dag-schedule.sh` implements the deterministic core — DAG parsing, cycle
checks, and wave computation — independent of any live runtime:

```bash
scripts/dag-schedule.sh --manifest orchestration/tasks.example.tsv
# wave 0: schema-audit ui-theme
# wave 1: auth-routes
# wave 2: ui-login docs
# wave 3: e2e-tests
```

- Manifest is tab-separated `taskId<TAB>deps` (deps comma-separated or `-`); see
  [`orchestration/tasks.example.tsv`](../orchestration/tasks.example.tsv).
- Each wave lists tasks whose dependencies are all satisfied by earlier waves — an
  orchestrator runs a wave's tasks concurrently, then recomputes.
- `--format json` emits `{"waves": [[...], ...]}` for machine consumption.
- Exit codes: `3` dangling/missing dependency, `4` cycle detected.

Run it via `make dag`. Locking, budget/time guardrails, the quality-gate phase, and
event replay remain runtime concerns for the orchestrator that consumes these waves.

## Rollout Plan

1. [x] Implement DAG parser + cycle checks. (`scripts/dag-schedule.sh`)
2. [x] Implement wave scheduler. (locking remains a runtime concern)
3. [ ] Add budget/time guardrails.
4. [ ] Add quality-gate phase.
5. [ ] Add event replay and metrics summary.
