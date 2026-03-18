# Tool Integration Patterns

Best practices for chaining MCP servers and deterministic tools.

## Current Tools

- **GitKraken MCP** — Git operations, GitLens integration
- **Supabase MCP** — Database, auth, storage
- **GitHub MCP** — Repository management, PRs, issues
- **Playwright MCP** — Browser automation, E2E testing
- **Solana MCP** — Blockchain development
- **Nansen MCP** — Wallet analytics, smart money tracking
- **Ollama MCP** — Local LLM inference

## Chaining Patterns

### Pattern 1: Sequential Chain

Output of tool A becomes input of tool B.

```
GitHub MCP (get PR files) → Supabase MCP (check schema impact) → GitKraken MCP (commit)
```

**Rules:**
- Verify output format before chaining
- Handle empty/null outputs gracefully
- Log intermediate results for debugging

### Pattern 2: Parallel Execution

Independent tools run concurrently.

```
Playwright MCP (run E2E tests) || Supabase MCP (run migrations)
```

**Rules:**
- Only for truly independent operations
- Aggregate results before proceeding
- Set timeout per tool

### Pattern 3: Fallback Chain

Try primary tool, fall back to secondary.

```
Nansen MCP (wallet analysis) → [fallback] → Solana MCP (basic lookup)
```

**Rules:**
- Define fallback explicitly
- Fallback should be simpler/faster
- Log which tool was used

### Pattern 4: Conditional Branching

Different tools based on condition.

```
if file_count > 10:
  GitHub MCP (batch commit)
else:
  GitKraken MCP (single commit)
```

**Rules:**
- Condition must be deterministic
- Both branches should achieve same goal
- Log branch decision

## Tool Registry Pattern

Standardized capability declaration per MCP server:

```yaml
# mcp-registry.yaml
gitkraken:
  capabilities:
    - git_commit
    - git_branch
    - git_push
    - git_stash
  rate_limit: 60/min
  
supabase:
  capabilities:
    - db_query
    - db_migrate
    - storage_upload
    - auth_verify
  requires:
    - project_id
```

## Error Handling

### Tool Unavailable

```python
try:
  result = mcp_call("gitkraken", "git_push")
except MCPUnavailable:
  fallback_to_shell("git push")
```

### Rate Limited

```python
try:
  result = mcp_call("github", "list_prs")
except RateLimited as e:
  wait(e.retry_after)
  retry()
```

### Output Format Mismatch

```python
result = mcp_call("playwright", "screenshot")
if not isinstance(result, bytes):
  log_error("Expected bytes, got", type(result))
  raise ToolOutputError
```

## Anti-Patterns

- **Blind chaining** — Assuming output format without verification
- **Nested calls** — Tool A calls Tool B inside Tool A (use sequential instead)
- **Implicit fallback** — Not documenting what happens on failure
- **Orphan results** — Tool output not used or logged
