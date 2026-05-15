---
name: mcp-tools-and-servers
description: Use when integrating MCP servers, designing tools, or wiring agents to external APIs via Model Context Protocol.
---

# MCP Tools and Servers

## When to Use

- Adding GitHub, filesystem, browser, or custom API access to agents
- Authoring new MCP servers (Python FastMCP or TypeScript SDK)
- Debugging tool schema mismatches or auth failures

## Implementation Workflow

1. Read tool descriptors/schemas before calling tools.
2. Prefer pagination and `minimal_output` when available.
3. Design tools: narrow inputs, stable JSON shapes, clear error messages.
4. Separate read vs write tools; gate destructive operations.
5. Log MCP invocations in dev; never log secrets or tokens.

## Hard Rules

- Validate parameters against schema; no guessing required fields.
- OAuth/tokens in env or host keychain — never in repo or prompts.
- Rate-limit and timeout external calls; return partial results with cursor when needed.
- Document each tool: purpose, side effects, idempotency.

## Done Criteria

- Server starts cleanly; tools listed and callable from host.
- Auth documented; failure modes return actionable errors.
- No secret leakage in tool responses or logs.

## Related Skills

- `github-automation.md`
- `cursor-agent-workflow.md`
