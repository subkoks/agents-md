---
name: solana-anchor-program-dev
description: Use when designing or implementing Solana programs with Anchor, including accounts, PDAs, instruction handlers, and tests.
---

# Solana Anchor Program Dev

## When to Use

- New program or instruction design in Anchor
- Account schema / PDA modeling
- SPL token flows (mint, transfer, authority checks)
- Rust program tests and local validator workflows

## What This Skill Provides

- Instruction + account design patterns with explicit constraints
- PDA seed/bump conventions and authority models
- Error code and invariant strategy
- Test matrix for happy path + failure cases

## Implementation Workflow

1. Define instruction contract first: inputs, signer requirements, invariants.
2. Define account constraints using Anchor attributes; fail early.
3. Add explicit domain errors (`#[error_code]`) for each invariant class.
4. Implement CPI boundaries (token program/system program) with strict authority checks.
5. Build tests covering initialization, replay attempts, wrong signer, wrong mint, and arithmetic limits.

## Hard Rules

- Never trust client-provided account relationships; verify all relationships on-chain.
- Prefer deterministic PDA derivations with clear domain prefixes.
- Store version fields in long-lived account data.
- Validate token mint and decimals assumptions explicitly.

## Done Criteria

- All instruction invariants are encoded in account constraints or handler checks.
- Failure-path tests exist for each security-critical precondition.
- Upgrade/migration impact for account layout is documented.

## Related Skills

- `solana-security-and-audit.md`
- `solana-client-kit-and-wallets.md`
