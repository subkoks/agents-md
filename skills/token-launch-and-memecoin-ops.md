---
name: token-launch-and-memecoin-ops
description: Use when planning token launch operations, memecoin deployment flow, liquidity bootstrapping, and post-launch controls.
---

# Token Launch and Memecoin Ops

## When to Use

- Launching a new token or memecoin
- Designing liquidity and distribution mechanics
- Setting launch-day and first-week operating playbooks

## What This Skill Provides

- Launch checklist (technical + operational)
- Liquidity and market-microstructure planning
- Bot/Sybil and sniper mitigation patterns
- Post-launch monitoring and incident playbook

## Launch Checklist

1. Finalize tokenomics and verify supply math under edge cases.
2. Lock mint/freeze authorities or define transparent governance path.
3. Define LP strategy (initial depth, concentration, and top-up triggers).
4. Prepare anti-abuse controls (rate limits, max tx/wallet where applicable).
5. Set launch telemetry dashboards before opening trading.

## Meme Trading Ops Metrics

- Netflow (buy - sell) over 5m/1h/24h windows
- Unique buyers vs sellers ratio
- Smart-money participation trend
- Holder concentration changes
- LP depth and slippage bands

## Hard Rules

- Do not launch without authority and emergency control documentation.
- Publish immutable addresses and critical params before hype window.
- Track concentration risk continuously in first 72 hours.
- Define explicit halt/escalation criteria for abnormal market behavior.

## Done Criteria

- Launch runbook includes owner, timing, and rollback actions.
- Real-time dashboards and alerts are live before first trade.
- Team has a pre-written incident response template.

## Related Skills

- `onchain-trading-and-flow-analysis.md`
- `solana-security-and-audit.md`
