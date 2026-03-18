---
name: solana-security-and-audit
description: Use when auditing Solana/Anchor programs for exploit paths, privilege escalation, account validation flaws, and economic manipulation risks.
---

# Solana Security and Audit

## When to Use

- Pre-deploy security review
- Post-incident root-cause analysis
- Feature changes affecting authority, custody, or pricing logic
- External audit prep

## What This Skill Provides

- Structured Solana threat-model checklist
- Critical vulnerability classes specific to account-model programs
- Audit workflow with reproducible evidence requirements
- Remediation and regression-validation protocol

## High-Risk Classes

- Missing signer/authority validation
- Unsafe account relationship assumptions
- PDA seed collision or privilege confusion
- CPI authority misuse and token program trust errors
- Integer overflow/underflow or precision drift in economics
- Reinitialization/state-reset bugs
- Oracle/price manipulation and stale data usage

## Audit Workflow

1. Map trust boundaries: users, signers, PDAs, external programs, oracles.
2. Enumerate instruction invariants and verify each in code.
3. Validate account constraints against runtime relationships.
4. Review all CPIs for authority and destination correctness.
5. Run negative tests for each critical precondition.
6. Confirm fixes with regression tests and no-new-risk review.

## Hard Rules

- Every privileged action must bind to explicit authority checks.
- Never accept unchecked account graphs from client inputs.
- Use fail-closed behavior for missing/invalid oracle data.
- Treat economic assumptions as attack surfaces, not business logic only.

## Done Criteria

- Findings list includes severity, exploit path, and proof-of-concept conditions.
- Each critical/high issue has remediation and test evidence.
- Final report includes residual risk and monitoring recommendations.

## Related Skills

- `solana-anchor-program-dev.md`
- `token-launch-and-memecoin-ops.md`
