---
name: solana-sniper-bot-scripts-and-ops
description: Use when implementing sniper bot scripts, execution automation, and runtime controls for Solana token launches.
---

# Solana Sniper Bot Scripts and Ops

## When to Use

- Building sniper automation scripts for early token entries
- Operating a bot stack with retries, queues, and kill-switches
- Hardening bot execution under high volatility

## What This Skill Provides

- Script topology for sniper bots
- Runtime controls for safe automation
- Ops checklist for reliability and incident handling

## Script Topology

- `listener.ts|py`: event stream and candidate extraction
- `filter.ts|py`: liquidity/risk filters and denylist checks
- `executor.ts|py`: tx assembly, simulation, send, confirm
- `risk.ts|py`: position sizing, stop logic, max exposure
- `journal.ts|py`: structured logs, PnL snapshots, replay traces

## Runtime Controls

- Max concurrent orders
- Max slippage per trade
- Max notional per token/day
- Consecutive-failure circuit breaker
- Global emergency stop

## Hard Rules

- Simulate transactions when feasible before send.
- Enforce idempotency for retries to avoid duplicate fills.
- Block trading when liquidity or spread thresholds fail.
- Keep full event + tx logs for replay and debugging.

## Done Criteria

- Bot can resume after restart without orphaned state.
- Risk limits are enforced in code, not operator memory.
- Incident playbook exists for stuck tx, RPC failure, or abnormal fills.

## Related Skills

- `pumpfun-launch-and-trading-automation.md`
- `solana-security-and-audit.md`
- `solana-client-kit-and-wallets.md`
