---
name: onchain-trading-and-flow-analysis
description: Use when analyzing who is buying/selling, smart-money behavior, holder flows, and trade quality for tokens including memecoins.
---

# Onchain Trading and Flow Analysis

## When to Use

- "Who is buying or selling this token?"
- Smart-money / fund behavior analysis
- Whale concentration and transfer activity tracking
- Meme coin momentum and exhaustion detection

## What This Skill Provides

- Practical analysis workflow from token discovery to trader-level drilldown
- Key signal set for trend confirmation vs exit liquidity risk
- Cross-check method to avoid single-metric bias

## Analysis Workflow

1. Confirm token identity and chain first.
2. Pull recent DEX trades and sort by value to identify dominant actors.
3. Check top-holder changes (24h/7d/30d) for accumulation/distribution.
4. Evaluate who bought/sold aggregates to classify net buyer cohorts.
5. Cross-check with transfer flows (DEX/CEX/non-exchange) for context.
6. Validate against price/volume regime change before conclusions.

## Core Signal Set

- Netflow trend and acceleration
- Buy/sell volume imbalance
- Smart-money participation delta
- Holder concentration drift
- Large transfer destination profile (CEX inflow vs self-custody)

## Hard Rules

- Never conclude from one timeframe; use multi-window confirmation.
- Separate narrative signals from execution signals.
- Treat sudden CEX inflows from large holders as elevated distribution risk.
- Explicitly label uncertainty when liquidity is thin.

## Done Criteria

- Thesis includes bullish and bearish invalidation levels.
- Evidence table ties each claim to one or more metrics.
- Risk section covers liquidity, concentration, and event risk.

## Related Skills

- `token-launch-and-memecoin-ops.md`
- `web3-dapp-architecture.md`
