# Hook Runtime Profiles & Telemetry

Operational controls for enabling/disabling hooks without editing files, and for
capturing a bounded session summary at stop-phase. Implements the **Harness
reliability controls** roadmap item. Builds on the contracts in
[hook-portability-spec.md](hook-portability-spec.md) and [hook-reference.md](hook-reference.md).

## Profiles

Hooks are grouped into three cumulative tiers so you can dial reliability overhead
up or down per environment:

| Profile | Includes | Use for |
| --- | --- | --- |
| `minimal` | minimal-tier hooks only | fast/batch work, cost-sensitive runs |
| `standard` | minimal + standard | default day-to-day development |
| `strict` | minimal + standard + strict | release prep, audited/high-stakes work |

Each hook declares its lowest enabling tier in [`hooks/manifest.tsv`](../hooks/manifest.tsv)
(tab-separated: `name`, `category`, `min_profile`, `mode`, `dependencies`). A hook is
enabled when its `min_profile` rank ≤ the selected profile rank.

```bash
scripts/hook-profile.sh --profile standard            # enabled hook names, one per line
scripts/hook-profile.sh --profile strict --list-all   # every hook + enabled/disabled state
scripts/hook-profile.sh --profile minimal --format json
make hooks                                            # enabled hooks for the standard profile
```

## Temporary disable (`DISABLED_HOOKS`)

For traceable, temporary suppression (no file edits), set `DISABLED_HOOKS` to a
comma-separated list of hook names. Disabled hooks are removed from the resolved set
regardless of profile:

```bash
DISABLED_HOOKS="test-gate,audit-log" scripts/hook-profile.sh --profile strict
```

This keeps suppression explicit and greppable instead of commenting out hook files.

## Stop-phase telemetry

`scripts/session-telemetry.sh` persists one bounded JSON record per session to
`logs/telemetry/telemetry.jsonl`, so sessions can be analyzed or replayed without
retaining full transcripts:

```bash
scripts/session-telemetry.sh --session "$SID" --turns 12 --tools 34 --status ok --note "feature X"
```

Records are deliberately small: timestamp, session id, turn/tool counts, outcome, and a
note capped at 200 chars (control chars stripped, JSON-escaped). `logs/` is gitignored.

## Wiring into a runtime

These scripts are editor-agnostic building blocks, not a live hook runtime. To adopt:

1. Point your hook dispatcher at `hook-profile.sh --profile <tier>` to decide which
   hooks in `hooks/enabled/` to run (see the dispatcher pattern in `hook-reference.md`).
2. Call `session-telemetry.sh` from your editor's stop/end-of-turn hook.

## Status & follow-ups

Shipped: cumulative profiles, `DISABLED_HOOKS` override, and stop-phase telemetry, all
with bats coverage (`tests/hook-profile.bats`, `tests/session-telemetry.bats`).
Deferred: pre-compact state capture (persist working state before context compaction).
