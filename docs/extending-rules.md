# Extending Rules

Guide for adding new rules to gotcha.md.

## When to Add Rules

Add new rules when:
1. **Repeated mistakes** — Same issue occurs multiple times
2. **New tool integration** — MCP server or script needs usage patterns
3. **Domain-specific patterns** — Project type has unique conventions
4. **Safety improvements** — Near-miss incidents need guardrails

## When NOT to Add Rules

Don't add rules when:
1. **One-off situation** — Single occurrence doesn't need a rule
2. **Already covered** — Existing rule handles it
3. **Too specific** — Rule applies to one project only (use project AGENTS.md instead)
4. **Preference, not pattern** — Personal preference doesn't need enforcement

## Process for Adding Rules

### 1. Document the Pattern

Create a file in `ideas/`:

```markdown
# [Rule Name]

## Problem
[What problem does this solve?]

## Solution
[What rule addresses it?]

## Examples
[Concrete examples of the rule in action]

## Trade-offs
[What are the downsides?]
```

### 2. Test the Rule

Apply the rule manually for a few sessions. Does it help? Does it cause friction?

### 3. Add to gotcha.md

Find the appropriate section and add the rule:

```markdown
## [Section Name]

- [Existing rules...]
- **New rule** — [Rule description]
```

Keep it concise. One line if possible.

### 4. Update CHANGELOG.md

```markdown
## [Unreleased]

### Added
- [Section]: [New rule description]
```

### 5. Sync

```bash
./scripts/run-governance.sh
```

## Rule Format

Good rules are:
- **Actionable** — Tell what to do, not what to avoid
- **Specific** — Clear when it applies
- **Concise** — One line in markdown
- **Justified** — Reason is clear from context

### Bad Examples

```
Don't write bad code
Always be careful
Think before acting
```

### Good Examples

```
Run `npm test` before declaring success
Use `Array<T>` over `T[]` for readability
Check `git status` before committing
```

## Rule Categories

| Category | Section | Example |
|----------|---------|---------|
| Behavior | Operating Principles | "Be direct, no preamble" |
| Permission | Execution Autonomy | "Ask before destructive commands" |
| Process | Operating Rules | "Check workflows first" |
| Code | Code Style | "Use named constants" |
| Safety | Security | "Validate all input" |
| Quality | Testing | "Run full suite after fixes" |

## Deprecating Rules

Rules become obsolete. To deprecate:

1. Comment out in gotcha.md with reason
2. Note in CHANGELOG.md under "Deprecated"
3. Remove after 2 weeks if no issues

```markdown
<!-- DEPRECATED: No longer needed since [reason]
- Old rule here
-->
```

## Rule Conflicts

If new rule conflicts with existing:

1. Check which is more general
2. Specific overrides general
3. If equal priority, ask user which to keep
4. Document the decision in CHANGELOG.md
