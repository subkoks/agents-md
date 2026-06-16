# Security Scan Spec

Implementation specification for scanning agent configuration surfaces (rules, hooks, MCP, and tool permissions).

## Objectives

- Detect high-risk config patterns before execution.
- Produce deterministic, machine-readable findings.
- Support optional safe auto-fixes.
- Integrate with local scripts and CI gating.

## Scan Scope

- Rule files: `src/gotcha.md`, project `AGENTS.md` variants.
- Hook configuration and scripts: `hooks/*.json`, `hooks/**/*.sh`, runtime hook adapters.
- MCP definitions and tool allowlists.
- Workflow and command files that can trigger shell/network actions.

## Severity Model

| Severity | Meaning                                      | Default CI behavior |
| -------- | -------------------------------------------- | ------------------- |
| critical | Direct exploitation or secret exposure risk  | fail                |
| high     | Strong abuse path with limited preconditions | fail                |
| medium   | Meaningful weakness; needs remediation soon  | optional fail       |
| low      | Hardening improvement                        | warn                |
| info     | Non-blocking signal                          | report              |

## Finding Schema

```json
{
  "id": "SEC-HOOK-001",
  "title": "Unsafe wildcard Bash permission",
  "severity": "critical",
  "category": "permissions",
  "file": "path/to/file",
  "line": 12,
  "evidence": "Bash(*)",
  "rationale": "Unrestricted command execution",
  "fix": {
    "autoFixable": false,
    "suggested": "Scope allowlist to known commands"
  }
}
```

## Rule Categories

- Secrets and credential leakage
- Permission overreach (`*`, unrestricted mutable tools)
- Hook injection and unsafe interpolation
- MCP transport and command risk
- Prompt instruction abuse and hidden directives

## Auto-Fix Policy

Auto-fix only when safe and deterministic:

- convert hardcoded secret literals to env var references
- suggest narrowing wildcards to explicit patterns
- normalize known unsafe defaults to safer baseline values

Never auto-fix destructive command permissions or ambiguous behavior changes.

## CLI Contract

```bash
./scripts/security-scan.sh [--format terminal|json|markdown] [--min-severity medium] [--fail-on high] [--fix]
```

## CI Contract

- Workflow input: `min-severity`, `fail-on-findings`.
- Output artifacts:
  - `security-report.json`
  - `security-report.md`
- Optional PR annotation for `critical/high` findings.

## Rollout Plan

1. [x] Add scanner skeleton and schema validation. (`scripts/security-scan.sh`)
2. [x] Implement `critical/high` detectors first. (SEC-PERM-001, SEC-SECRET-001, SEC-CI-001)
3. [x] Add CI integration in report-only mode. (`ci.yml` → `security-scan` job step)
4. [x] Implement `medium/low` detectors and safe `--fix` auto-remediation.
       (SEC-MCP-001, SEC-HOOK-001, SEC-PROMPT-001, SEC-PROMPT-002; `--fix` strips hidden unicode)
5. [x] Enable fail thresholds in CI after baseline cleanup. (CI step now `--fail-on high`)

> v2 status: seven detectors across critical→low ship with `terminal`/`json`/`markdown`
> output, `--min-severity`/`--fail-on` thresholds, and bats coverage
> (`tests/security-scan.bats`, 16 tests). `--fix` applies only `autoFixable` findings
> (currently SEC-PROMPT-002 hidden-unicode stripping) and backs up each file to `.bak`;
> destructive/ambiguous fixes are never auto-applied (per Auto-Fix Policy above).
> CI runs the scanner blocking on `high+` in the `security-scan` job.
