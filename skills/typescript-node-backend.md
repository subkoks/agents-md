---
name: typescript-node-backend
description: Use when building Node.js/TypeScript APIs, workers, and backend services with validation, auth, and observability.
---

# TypeScript Node Backend

## When to Use

- REST or RPC APIs (Express, Fastify, Hono)
- Background workers and queue consumers
- Webhook handlers and integration services

## Implementation Workflow

1. TypeScript strict, ESM, named exports.
2. Validate external input at boundaries with Zod.
3. Layer: routes → services → data access; no business logic in handlers alone.
4. Structured logging; correlation IDs for requests.
5. Health/readiness endpoints for deploy targets.

## Hard Rules

- Parameterized SQL; no string-concatenated queries.
- Secrets from env; rotateable config documented.
- Explicit error types; map to safe HTTP responses (no stack traces to clients).
- Timeouts on outbound HTTP and DB calls.

## Done Criteria

- Types on exported functions; `unknown` + guards at boundaries.
- Tests for critical paths and auth failures when logic is non-trivial.
- p95 latency considered for hot paths (indexes, caching where measured).

## Related Skills

- `debugging-protocol.md`
- `github-automation.md`
