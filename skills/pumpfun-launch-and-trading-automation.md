---
name: pumpfun-launch-and-trading-automation
description: Use when building or operating pump.fun token discovery, buy/sell execution, and launch-phase automation pipelines on Solana.
---

# pump.fun Launch and Trading Automation

## When to Use

- Monitoring new pump.fun token launches
- Building automated buy/sell execution around bonding-curve events
- Creating launch-phase runbooks and risk controls

## What This Skill Provides

- Event-driven architecture for launch detection and execution
- Listener/buy/sell/trade-script separation pattern
- Cooldown, retry, and logging policies for unstable launch windows

## Practical Architecture

- **Listener:** subscribe to relevant on-chain program activity and extract mint + bonding-curve accounts.
- **Buy script:** validate token/mint context, create required ATAs, then execute buy with bounded slippage.
- **Sell script:** enforce profit/loss or timeout exits with position-size caps.
- **Trade orchestrator:** single controller for timing, retries, and state transitions.
- **Logging:** append-only trade journal + per-token event files.

## Hard Rules

- Separate signal detection from execution to avoid race-condition coupling.
- Use bounded slippage and max-position checks on every order.
- Add cooldown windows for cluster propagation during fresh launches.
- Persist every action with timestamp, signature, token, and reason code.

## Done Criteria

- Launch-to-trade pipeline is deterministic and restart-safe.
- Failed tx paths are retried or aborted by explicit policy.
- Trade logs are structured enough for postmortem analysis.

## Related Skills

- `onchain-trading-and-flow-analysis.md`
- `memecoin-trading-risk-playbook.md`
- `solana-client-kit-and-wallets.md`
