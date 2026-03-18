---
name: evm-smart-contract-dev
description: Use when building or reviewing EVM smart contracts (Solidity), including upgradeability, access control, token logic, and testing.
---

# EVM Smart Contract Dev

## When to Use

- Building Solidity contracts
- Designing ERC-20/721/1155 token mechanics
- Implementing upgradeable proxy systems
- Writing invariant and fuzz tests

## What This Skill Provides

- Contract architecture patterns (core, adapters, interfaces)
- Access-control and pausable design rules
- Storage layout safety for upgrades
- Testing strategy: unit + fuzz + invariant + fork tests

## Hard Rules

- Minimize privileged roles; document all admin powers.
- Use explicit custom errors and fail-fast checks.
- Lock upgrade paths with timelock/governance where possible.
- Treat external calls as untrusted boundaries.

## Done Criteria

- Threat model covers reentrancy, oracle, and governance risks.
- Upgrade simulation includes storage compatibility validation.
- Tests include adversarial edge cases and invariant checks.

## Related Skills

- `defi-protocol-engineering.md`
- `web3-dapp-architecture.md`
