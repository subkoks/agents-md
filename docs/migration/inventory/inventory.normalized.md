# Inventory 2026-05-05 - Normalized Migration Classification

Source: `/Users/black.terminal/Projects/inventory-2026-05-05.md`

Scope:
- Read-only normalization and classification package.
- Deduplicated cross-section duplicates (apps, CLIs, runtimes, services, configs, state paths).
- Converted visible encoding artifacts to ASCII in this output (for example tree glyphs and checkmark symbols from raw command output).
- Resolved mismatches into notes only (no assumptions, no deletions).

## Normalization notes

- `code` launcher points to Cursor (`/usr/local/bin/code` -> Cursor version context), not VS Code stock binary.
- `windsurf` launcher exists and is versioned separately from `/Applications/Windsurf.app` metadata.
- `docker-desktop` cask exists, but `docker` is not on PATH in source inventory.
- `postgresql@16` service is running, but `psql` and `pg_isready` are reported missing on PATH.
- `warp` appears as both app and cask with different version formats.
- `codexbar` appears as app (`CodexBar`) and cask (`codexbar-intel`) with version mismatch.
- `repobar` appears as app (`RepoBar`) and cask (`repobar`) with aligned version family.
- `nvm` is listed as brew formula and shell-managed runtime helper; CLI detection can be context dependent.
- `nano` output in source was terminal control bytes from launching interactive mode; kept as uncertainty note in CSV.
- npm global tree characters and MCP status glyphs were mojibake in source; interpreted as plain text package/status entries.

## Deduplicated inventory index (high-signal)

### Apps (selected)
- Cursor
- Windsurf
- Claude
- Codex
- Warp
- Docker Desktop
- Brave Browser
- Google Chrome Dev
- Telegram
- Discord
- Spotify
- GitHub Desktop
- iTerm2
- NordVPN
- VMware Fusion
- VLC
- Tor Browser
- The Unarchiver
- qBittorrent
- Perplexity
- Gambler.Bot
- Greptile Fix
- Claude Code URL Handler

### CLIs and package managers (selected)
- brew
- git
- gh
- node
- npm
- pnpm
- yarn
- python / python3 / pip / pip3 / uv / pipx
- pyenv / nvm / mise
- ripgrep / fd / fzf / bat / eza / zoxide / tmux
- jq / wget / curl / openssl / gpg / ffmpeg / tesseract / yt-dlp / fswatch
- codex / claude / dev-browser / firecrawl-cli / pre-commit / supabase

### Runtimes
- Node.js 22 via nvm
- Python 3.13 via pyenv
- Ruby system runtime
- Java runtime
- Deno runtime
- Lua runtime

### Services
- postgresql@16 (started)
- redis (started)

### Config and state roots (migration-relevant)
- `~/.zshrc`, `~/.zprofile`, `~/.zshenv`, `~/.bashrc`, `~/.bash_profile`
- `~/AGENTS.md`
- `~/.claude/*`
- `~/.cursor/*`
- `~/.codex/*`
- `~/.windsurf/*`
- `~/.codeium/windsurf/*`
- `~/.agents/skills/*`
- `~/.continue/*`

## Classification policy

- `KEEP_NOW`: required immediately after migration for active day-1 workflow.
- `KEEP_LATER`: useful but not required for initial cutover.
- `REGENERATE`: runtime/cache/session/log/generated state; recreate on new machine.
- `DROP`: low-value legacy/duplicate/noise candidate.

## Priority policy

- `critical`: blocks dev baseline if absent.
- `important`: materially improves workflow but non-blocking.
- `optional`: convenience or niche usage.

## Output files produced

- `/Users/black.terminal/Projects/inventory-2026-05-05.classification.csv`
- `/Users/black.terminal/Projects/inventory-2026-05-05.keep-now.txt`
- `/Users/black.terminal/Projects/inventory-2026-05-05.regenerate.txt`
