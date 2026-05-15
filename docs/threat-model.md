# Threat model (lightweight)

Scope: **agents-md** repository and its install/sync scripts — not your application code or production infrastructure.

## Assets

| Asset | Risk if compromised |
| --- | --- |
| `src/gotcha.md` / `src/gotcha-lean.md` | Malicious rules steer all synced editors |
| `scripts/*.sh` | Arbitrary code execution when users run them |
| Generated `dist/rules/*` | Same as canonical if drift checks are skipped |
| `skills/*.md` | Misleading domain guidance (lower severity than rules) |
| User `~/.cursor/rules/*.mdc` | Local agent behavior override |

## Trust boundaries

1. **Upstream repo** — treat `main` and signed releases as trusted; verify PRs and CI before merge.
2. **Local clone** — contributors can modify canonical sources; run `make check` before sharing artifacts.
3. **Install target** — `install.sh` writes only under `~/.cursor/rules/` by default; backs up before overwrite.

## Threats and mitigations

| Threat | Mitigation |
| --- | --- |
| Tampered rule text merged without review | Branch protection, PR review, `make check` / drift CI |
| Secret committed to repo | TruffleHog on PRs; hooks/docs discourage `.env` in tree |
| Install script destructive overwrite | Timestamped backups; `--dry-run`; no `rm -rf` |
| Supply chain in GitHub Actions | Pinned action SHAs in workflows |
| Social engineering via skills | Skills are advisory; canonical rules separate |
| False sense of security from rules | Document: rules ≠ appsec program or compliance |

## Out of scope

- Security of target applications you build with agents
- MCP server implementations you add separately
- Live trading, wallet keys, or production deploy credentials

## Reporting

Use [GitHub Security Advisories](https://github.com/subkoks/agents-md/security/advisories/new) for vulnerabilities. Do not open public issues for exploit details.
