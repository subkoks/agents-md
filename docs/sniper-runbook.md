# Sniper Bot Runbook

Operational runbook for Solana sniper bot execution, safety checks, and incident response.

## Scope

Use this runbook with:

- `skills/solana-sniper-bot-scripts-and-ops.md`
- `skills/pumpfun-launch-and-trading-automation.md`
- `scripts/sniper-config-template.yaml`

## Pre-Run Checklist

1. Use a dedicated trading wallet only.
2. Validate RPC primary + fallback health.
3. Confirm risk limits (`maxNotional*`, drawdown, kill-switch).
4. Validate denylist/watchlist sources.
5. Ensure logging/journal paths are writable.
6. Start in `paper` mode after strategy changes.

## Launch Procedure

1. Copy template to runtime config:

```bash
cp scripts/sniper-config-template.yaml sniper-config.yaml
```

1. Set environment values and secrets outside the repo.
2. Start listener only and verify event flow.
3. Enable execution with minimal size caps.
4. Monitor fills, failures, and slippage drift for first 20-50 trades.
5. Scale exposure only after fill-quality validation.

## Runtime Monitoring

Track continuously:

- success/fail transaction ratio
- median slippage by token
- RPC failover frequency
- net PnL and drawdown
- kill-switch trigger count

## Incident Playbooks

## A. Consecutive Tx Failures

- Action: pause new entries immediately.
- Check RPC status and mempool latency.
- Lower concurrency and increase cooldown.
- Resume only after simulation + send confirms stabilizing.

## B. Slippage Spike / Bad Fills

- Action: reduce position size and tighten filters.
- Increase liquidity thresholds.
- Disable aggressive preset until stability returns.

## C. Abnormal Drawdown

- Action: trigger global kill-switch.
- Stop all new execution.
- Export event journal and last 200 trades.
- Run postmortem before restart.

## D. Suspected Scam/Exploit Token Pattern

- Action: add mint to denylist and halt related strategy.
- Review authority, holder concentration, transfer anomalies.
- Re-enable only with explicit manual approval.

## Post-Run Review

- Compare thesis vs realized execution quality.
- Record strategy deltas and rejected hypotheses.
- Update config defaults only after 2+ stable sessions.

## Non-Negotiables

- Never run without hard risk caps.
- Never remove kill-switch protections for convenience.
- Never deploy strategy changes directly to full size.
