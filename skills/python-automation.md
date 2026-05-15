---
name: python-automation
description: Use when building Python scripts, bots, scrapers, cron jobs, or CLI tools for automation and data pipelines.
---

# Python Automation

## When to Use

- One-off or recurring automation (scraping, ETL, notifications)
- CLI tools with argparse/typer
- Async I/O (HTTP, WebSockets, Telegram)
- Scheduled jobs (cron, systemd, GitHub Actions)

## Implementation Workflow

1. Scaffold with `pyproject.toml`, Python 3.13+, `.venv`, `ruff`.
2. Define entry point and config (env vars, optional TOML).
3. Separate I/O boundaries: fetch → parse → persist → notify.
4. Add structured logging and exit codes for automation callers.
5. Document run commands and required env in module docstring or `--help`.

## Hard Rules

- Type hints on all public functions.
- `pathlib.Path` for filesystem; no bare `os.path` in new code.
- Secrets from environment only; never commit tokens or session strings.
- Idempotent writes where jobs may retry.
- Rate-limit external APIs; respect robots.txt and ToS.

## Done Criteria

- Script runs with `python -m` or documented CLI; non-zero exit on failure.
- Config documented; dry-run or `--dry-run` for destructive paths when applicable.
- Dependencies pinned in `pyproject.toml` or lockfile.

## Related Skills

- `telegram-bots-and-scrapers.md`
- `debugging-protocol.md`
