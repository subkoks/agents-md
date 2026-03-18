# Debugging Workflows

Systematic approaches to finding and fixing bugs.

## Current Debugging Rules

From gotcha.md:
1. State symptom precisely before touching code
2. Read full error message and stack trace first
3. Form one specific hypothesis, test, iterate
4. Make one change at a time
5. Fix root causes, not symptoms
6. Run full tests after fix

## Enhancement Ideas

### Hypothesis Tracking Template

```markdown
## Bug: [Description]

**Symptom:** [What you observe]

### Hypothesis 1: [Title]
- **Reasoning:** [Why this could be the cause]
- **Test:** [How to verify]
- **Result:** [Pass/Fail/Pending]
- **Evidence:** [What you found]

### Hypothesis 2: [Title]
...

### Root Cause
[Final determination]

### Fix
[What was changed]

### Regression Test
[Test that prevents this bug]
```

### Auto-Isolation Script

When bug found, automatically create minimal reproduction:

```bash
# scripts/isolate-bug.sh
# Creates minimal project with just the bug

isolate-bug --file src/api/auth.ts --line 42 --output ~/bugs/auth-null-pointer/
```

Output:
- Minimal file with bug
- Required dependencies only
- Reproduction steps
- Expected vs actual behavior

### Root Cause Templates

Common patterns to check first:

| Pattern | Symptoms | Check |
|---------|----------|-------|
| Null pointer | Crash on access | Defensive checks, optional chaining |
| Race condition | Intermittent failure | Async timing, shared state |
| Off-by-one | Boundary errors | Loop conditions, array indices |
| Type mismatch | Silent corruption | Type guards, runtime validation |
| Missing await | Promise pending | Async/await chain |
| State leak | Memory growth | Event listeners, closures |
| Cache staleness | Inconsistent data | Cache invalidation |

### Regression Test Generation

After fix, auto-generate test:

```typescript
// Generated from bug fix in src/api/auth.ts:42
describe('auth null pointer bug', () => {
  it('should handle null user gracefully', () => {
    const result = authenticate(null);
    expect(result).toBe('unauthorized');
    // Previously: threw TypeError
  });
});
```

## Debugging Flowchart

```
Symptom observed
       ↓
Read error/trace
       ↓
Form hypothesis ──→ Test ──→ Pass? ──→ Fix ──→ Test suite ──→ Done
       ↓              ↓         ↓
       ↓           Fail?    Multiple hypotheses?
       ↓              ↓         ↓
       ↓         New hypothesis  Track all
       ↓              ↓
       ←──────────────┘
```

## Session Debugging Log

Track debugging across sessions:

```markdown
# Debug Log: auth-null-pointer

## 2026-03-17 02:15
- Symptom: TypeError on login
- Hypothesis: user object null
- Test: Add console.log
- Result: Confirmed null
- Next: Find where null comes from

## 2026-03-17 02:22
- Hypothesis: DB returns null for missing user
- Test: Check DB query
- Result: Query correct, returns undefined not null
- Next: Check type coercion

## 2026-03-17 02:30
- Root cause: undefined !== null check
- Fix: Use nullish coalescing
- Tests: All pass
- Status: Fixed
```
