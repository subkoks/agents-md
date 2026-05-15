---
name: debugging-protocol
description: Use when investigating bugs, test failures, or unexpected behavior with a systematic reproduce-first methodology.
---

# Debugging Protocol

## When to Use

- Failing tests, runtime errors, flaky CI
- "Works on my machine" or regression after deploy
- Agent loops repeating the same failed fix

## Implementation Workflow

1. Read full error and stack trace; capture exact symptom.
2. Reproduce minimally (single test, smallest input).
3. One hypothesis → one change → verify.
4. Check logs, config, env, recent diffs, assumptions.
5. Fix root cause; run full relevant test suite.

## Hard Rules

- Do not claim "verified" without running the check.
- Same error or identical tool call twice → stop retrying; new plan.
- Revert bad hypotheses; do not stack speculative patches.
- State observed behavior before editing code.

## Done Criteria

- Reproduction steps documented (or linked issue).
- Fix has test or manual verification evidence.
- No unrelated drive-by refactors in the same change.

## Related Skills

- `cursor-agent-workflow.md`
- `typescript-node-backend.md`
- `python-automation.md`
