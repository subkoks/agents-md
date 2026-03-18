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

## Rollout Plan

1. Implement DAG parser + cycle checks.
2. Implement wave scheduler + locking.
3. Add budget/time guardrails.
4. Add quality-gate phase.
5. Add event replay and metrics summary.
