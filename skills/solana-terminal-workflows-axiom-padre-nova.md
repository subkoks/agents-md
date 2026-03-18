---
name: solana-terminal-workflows-axiom-padre-nova
description: Use when designing execution workflows for browser/terminal-first Solana trading stacks (Axiom, Terminal/Padre, Nova-style flows).
---

# Solana Terminal Workflows (Axiom/Padre/Nova)

## When to Use

- Building terminal-style manual+semi-automated trading workflows
- Comparing execution settings across Axiom/Terminal(Now Padre)/Nova-style tooling
- Creating safe presets for fast memecoin market conditions

## What This Skill Provides

- Unified workflow model independent of brand/vendor
- Execution-setting baseline for speed vs fill quality
- Safety defaults for wallet separation and sizing

## Workflow Model

1. **Discovery:** watchlists, wallet tracking, and momentum scans.
2. **Qualification:** liquidity, holder concentration, and netflow checks.
3. **Execution preset:** slippage band, priority fee, size cap, exit plan.
4. **Order routing:** market/limit/conditional execution.
5. **Post-trade review:** fill quality, latency, and thesis validation.

## Preset Profiles

- **Conservative:** low-medium slippage, smaller size, single-chain focus.
- **Balanced:** adaptive slippage with strict max loss.
- **Aggressive:** faster routing/high priority fees with reduced capital fraction.

## Hard Rules

- Always use dedicated hot wallet for terminal trading.
- Validate token contract/mint before every first trade.
- Never run aggressive presets without hard daily drawdown limits.
- Track hidden costs: slippage, failed tx, priority fees.

## Done Criteria

- Presets are documented and reproducible.
- Each strategy includes explicit invalidation/exit logic.
- Cost model includes network + execution overhead.

## Related Skills

- `memecoin-trading-risk-playbook.md`
- `onchain-trading-and-flow-analysis.md`
