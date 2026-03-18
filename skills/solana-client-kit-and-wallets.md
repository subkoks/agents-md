---
name: solana-client-kit-and-wallets
description: Use when building Solana client apps with modern RPC/tooling, wallet-standard integrations, and transaction orchestration.
---

# Solana Client Kit and Wallets

## When to Use

- Frontend/client integration for Solana apps
- Wallet connect/sign/send flows
- Transaction assembly, simulation, and confirmation strategy
- Migration away from legacy ad-hoc client code

## What This Skill Provides

- Wallet-standard-first connection model
- Transaction lifecycle pattern (build -> simulate -> sign -> send -> confirm)
- Priority fee and compute budget tuning guidance
- Robust UX states for pending/confirmed/finalized flows

## Implementation Workflow

1. Use one client abstraction consistently across app features.
2. Normalize wallet capabilities (sign message, sign tx, sign all tx) before use.
3. Simulate transactions before send for actionable error surfacing.
4. Add compute budget and priority fee controls where latency matters.
5. Track signature status until required commitment level.

## Hard Rules

- Never assume wallet supports every signing method.
- Surface simulation logs and decoded instruction errors to users/dev logs.
- Prevent duplicate submits with optimistic lock on in-flight signatures.
- Keep RPC endpoint strategy explicit (primary/fallback).

## Done Criteria

- Wallet disconnect/reconnect and account switch are handled cleanly.
- Failing transactions produce useful decoded error output.
- Retry policy is idempotent and signature-safe.

## Related Skills

- `web3-dapp-architecture.md`
- `solana-anchor-program-dev.md`
