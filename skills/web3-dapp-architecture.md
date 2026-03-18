---
name: web3-dapp-architecture
description: Use when designing production web3 app architecture across frontend, indexing, transactions, risk controls, and observability.
---

# Web3 dApp Architecture

## When to Use

- Designing a new crypto/web3 product
- Refactoring a brittle dApp stack
- Defining transaction, indexing, and state consistency flows

## What This Skill Provides

- Reference architecture for app, chain adapters, indexer, and risk layer
- Read/write path separation patterns
- Failure and reorg handling strategy
- Production readiness checklist

## Architecture Baseline

- **UI/API layer:** deterministic state machine for transaction status.
- **Chain adapter layer:** isolated per-chain modules (Solana/EVM/etc).
- **Indexer/data layer:** denormalized query models; raw on-chain events retained.
- **Risk layer:** slippage, nonce/replay, stale price, and allowance guards.
- **Ops layer:** metrics, traces, alerting, and incident runbooks.

## Hard Rules

- Separate chain write actions from read/index paths.
- Always have degraded mode if indexer lags.
- Handle chain reorg/fork semantics explicitly.
- Never hide failed state transitions; persist and expose reason codes.

## Done Criteria

- Every critical flow has an idempotent retry path.
- Transaction state model covers dropped/replaced/reverted outcomes.
- Observability includes per-chain success rate and latency distributions.

## Related Skills

- `solana-client-kit-and-wallets.md`
- `onchain-trading-and-flow-analysis.md`
