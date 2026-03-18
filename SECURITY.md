# Security Policy

## Reporting

Report vulnerabilities privately by opening a confidential security report in GitHub Security Advisories.

If advisories are unavailable, contact the maintainer directly and include:

- impact summary
- affected files
- reproduction steps
- suggested remediation

## Scope

This repository primarily contains rules, docs, and scripts. Security-sensitive risks still include:

- command injection in shell scripts
- unsafe handling of local paths
- accidental secret leakage in docs
- unsafe automation defaults

## Handling Principles

- least privilege by default
- explicit handling for destructive actions
- no secret material committed
- deterministic scripts with safe fallbacks
