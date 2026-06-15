# Debugging Workflows

Systematic, hypothesis-driven debugging. Pairs the canonical **Debugging Protocol**
in `src/gotcha.md` with a concrete journal tool and reusable templates. See also
[`skills/debugging-protocol.md`](../skills/debugging-protocol.md).

Core loop (from the rule body): state the symptom precisely → read the full error
and trace → form **one** specific hypothesis → test it → one change at a time → fix
the root cause → run the full suite. Same error twice → stop, switch strategy.

## Hypothesis journal

`scripts/debug-journal.sh` makes the loop auditable and resumable across sessions:

```bash
debug-journal.sh add     --session login-bug --hypothesis "user object is null" --test "log user at entry"
debug-journal.sh add     --session login-bug --hypothesis "DB returns undefined" --test "inspect query"
debug-journal.sh resolve --session login-bug --seq 1 --result refuted   --evidence "user was defined"
debug-journal.sh resolve --session login-bug --seq 2 --result confirmed --evidence "query returns undefined"
debug-journal.sh report  --session login-bug              # markdown table (or --format json)
```

Entries persist to `logs/debug/<session>.tsv` (session name sanitized to a safe
filename). `report` renders the current state of every hypothesis. `resolve` requires
`confirmed`/`refuted`; reporting a missing session exits `3`.

## Root-cause templates

Common patterns to check first before deep investigation:

| Pattern | Symptoms | First check |
| --- | --- | --- |
| Null/undefined access | Crash on property access | defensive checks, optional chaining, `undefined !== null` |
| Race condition | Intermittent failure | async timing, shared mutable state |
| Off-by-one | Boundary errors | loop conditions, array indices |
| Type mismatch | Silent corruption | type guards, runtime validation (Zod) |
| Missing await | Promise left pending | the async/await chain |
| State/listener leak | Memory growth over time | event listeners, closures, cleanup |
| Cache staleness | Inconsistent reads | invalidation strategy |

## Minimal reproduction

Before fixing, isolate the smallest input that triggers the bug:

- Strip unrelated code paths until the failure still reproduces deterministically.
- Capture **expected vs. actual** explicitly — that pair becomes the regression test.
- Record the repro steps in the journal `--evidence` so the fix is verifiable.

## Regression test first

When a correct seam exists, write the failing test that reproduces the bug **before**
the fix (per the testing discipline), then make it pass:

```ts
// regression: auth returned crash on null user (was: TypeError)
it("returns unauthorized for a null user", () => {
  expect(authenticate(null)).toBe("unauthorized");
});
```

If no seam exists to exercise the real bug pattern, that absence is itself a finding —
the architecture is preventing the bug from being locked down; fix the seam, not the test.
