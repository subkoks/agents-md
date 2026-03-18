---
name: defi-protocol-engineering
description: Use when designing DeFi protocol mechanics (AMM, lending, staking, vaults), risk controls, and economic invariants.
---

# DeFi Protocol Engineering

## When to Use

- AMM/lending/vault protocol design
- Interest-rate or fee model changes
- Collateral and liquidation system reviews
- Economic attack-surface analysis

## What This Skill Provides

- Economic invariant modeling workflow
- Risk controls for liquidity, insolvency, and oracle failures
- Parameterization and guardrail framework
- Launch + monitoring checklist for protocol health

## Core Risk Controls

- Max utilization and circuit breakers
- Oracle freshness and deviation guards
- Liquidation incentives that avoid bad-debt spirals
- Emergency pause scope with least-privilege governance

## Hard Rules

- Define explicit insolvency handling paths.
- Simulate adversarial volatility regimes before launch.
- Treat governance parameter changes as production deployments.
- Keep protocol accounting deterministic and auditable.

## Done Criteria

- Invariants are testable and monitored post-deploy.
- Alert thresholds exist for insolvency precursors.
- Governance/guardian controls are documented and time-bounded.

## Related Skills

- `evm-smart-contract-dev.md`
- `solana-security-and-audit.md`
