# bootstrap/ai_tooling.md

How to bring AI tooling back on the new Mac without migrating runtime garbage.

Rule: **canonical = `~/.cursor/`**. Every other editor's skills/rules/agents are symlinks back into the cursor tree. This eliminates drift across editors and keeps a single source-of-truth in git.

> Companion skills: `dotfiles-allowlist-auditor`, `agent-runtime-garbage-scanner`, `macos-migration-orchestrator`.

---

## Per-root migrate / regenerate table

Columns:

- **Path** — canonical location
- **Action** — `migrate` (copy from current machine via dotfiles allowlist) or `regenerate` (let the tool recreate on first use) or `mixed` (split per subpath)
- **Reason** — what the path holds and why migration matters or doesn't
- **Regen command** — how to recreate if dropped
- **Risk** — what breaks if classified wrong

### `~/.claude/` (Claude Code CLI)

| Subpath | Action | Reason | Regen / restore command | Risk |
|---|---|---|---|---|
| `CLAUDE.md` | migrate | imports `~/AGENTS.md`; tiny, curated | restore from dotfiles | medium — without it, Claude misses global rules |
| `settings.json` | migrate | model defaults, statusLine, hook config | restore from dotfiles | medium — UX regress on first launch |
| `settings.local.json` | migrate | machine-local overrides only | restore from dotfiles | low |
| `rules/` | migrate | path-scoped rule files | restore from dotfiles | medium — context loss on path-matched work |
| `skills/` (symlinks) | regenerate | symlinks into `~/.cursor/skills/` | restore via Milestone 11 once `~/.cursor/skills/` is restored | low — symlinks can be recreated |
| `agents/` (symlinks) | regenerate | same; symlinks into `~/.cursor/agents/` | same | low |
| `plugins/` | mixed | curated config in here = migrate; build outputs = regen | restore the plugin source from its repo | medium |
| `mcp.json` (project-local) | migrate | per-project MCP config | restore | medium |
| `statusline-command.sh` | migrate | custom statusline script | restore from dotfiles | low |
| `keybindings.json` | migrate | custom shortcuts | restore | low |
| `projects/` | regenerate | per-session transcripts, memory caches | drop on migration | none — recreate on first session |
| `sessions/`, `history.jsonl`, `tasks/`, `telemetry/`, `cache/`, `shell-snapshots/`, `paste-cache/`, `file-history/`, `session-env/`, `mcp-needs-auth-cache.json` | regenerate | runtime / transcript / cache | drop | none |
| `.credentials*`, `auth.json` (if any) | **NEVER MIGRATE** | secret material | re-auth in Claude Code on new machine | **high — credential leak via git** |

### `~/.cursor/` (canonical AI tree)

| Subpath | Action | Reason | Regen / restore command | Risk |
|---|---|---|---|---|
| `rules/` (`gotcha.mdc`, `gotcha-full.mdc`, etc.) | migrate | per-path active rules | restore from dotfiles + `make sync-cursor` from `agents-md` | high — affects every Cursor session |
| `skills/` | migrate | canonical skills tree (others symlink here) | restore from `~/Projects/Current/Active/awesome-claude-skills` source if present, or from dotfiles snapshot | high — every editor's skills break without this |
| `agents/` | migrate | canonical subagent definitions | restore from dotfiles | high — same as skills |
| `hooks/`, `hooks.json` | migrate | custom IDE hooks | restore | medium |
| `mcp.json` | migrate | per-IDE MCP server registrations | restore | medium |
| `cli-config.json` | migrate | Cursor CLI configuration | restore | medium |
| `extensions/` | regenerate | downloaded VSIX bundles, large, cached | reinstall via `cursor --install-extension` loop in `bootstrap/editors.md` | low |
| `skills-cursor/` | migrate | sync-manifest source for cursor-specific skill packaging | restore | medium |
| `statusline.sh` | migrate | custom statusline | restore | low |
| `README.md` | migrate | tiny doc | restore | low |
| `projects/`, `plans/`, `ai-tracking/`, `debug-logs/`, `.ruff_cache` | regenerate | runtime / cache / per-project state | drop | none |
| `argv.json`, `ide_state.json` | regenerate | local UI state | drop | none |

### `~/.codex/` (Codex CLI)

| Subpath | Action | Reason | Regen / restore command | Risk |
|---|---|---|---|---|
| `AGENTS.md` | migrate | global rules (271 lines, mirrors `~/AGENTS.md`) | restore from dotfiles | high |
| `config.toml` | migrate | model + provider config | restore | high — Codex CLI fails without it |
| `rules/`, `skills/`, `agents/`, `hooks/`, `memories/`, `plugins/` | migrate | curated config (also symlinked into other editors) | restore | high |
| `auth.json` | **NEVER MIGRATE** | OAuth tokens / API keys | `codex login` (re-authenticate on new machine) | **high — credential leak** |
| `models_cache.json`, `cache/`, `.tmp`, `tmp`, `log/`, `logs_*.sqlite*`, `state_*.sqlite*`, `history.jsonl`, `session_index.jsonl`, `sessions/`, `archived_sessions/`, `vendor/`, `vendor_imports/` | regenerate | runtime caches and transcripts | drop | none |

### `~/.windsurf/` + `~/.codeium/`

| Subpath | Action | Reason | Regen / restore command | Risk |
|---|---|---|---|---|
| `~/.windsurf/rules/`, `~/.windsurf/skills/`, `~/.windsurf/settings.json` | migrate | curated rules + symlinks | restore from dotfiles | medium |
| `~/.windsurf/extensions/` | regenerate | VSIX cache | reinstall via `windsurf --install-extension` loop | low |
| `~/.windsurf/plans/`, `worktrees/`, `data/`, `context/`, `args/` | regenerate | runtime state | drop | none |
| `~/.windsurf/workflows/` | migrate | curated workflows | restore | medium |
| `~/.codeium/windsurf/memories/global_rules.md` | migrate | global rules (158 lines) | restore | medium |
| `~/.codeium/windsurf/skills/` | migrate | symlinks into cursor canonical | restore | medium |
| `~/.codeium/language-server*` | regenerate | downloaded LSP binary | drop; re-downloaded on first use | low |

### `~/.agents/`, `~/.continue/`, `~/.aider/`

| Path | Action | Reason | Notes |
|---|---|---|---|
| `~/.agents/skills/` | migrate (symlinks) | mirrors `~/.cursor/skills/` | symlinks recreate after cursor canonical restored |
| `~/.continue/agents/`, `config.json`, `config.yaml`, `mcpServers/`, `skills/`, `.env` | mixed | configs migrate; `.env` only if it holds non-secret tooling vars; reauth API keys | restore configs from dotfiles |
| `~/.continue/sessions/`, `logs/`, `index/`, `dev_data/`, `.migrations/` | regenerate | runtime | drop |
| `~/.aider/analytics.json`, `caches/`, `installs.json` | regenerate | runtime, opt-in telemetry — leave off by default | drop |

---

## Skill / agent / rule sync architecture

```
~/.cursor/skills/<skill-name>          ← canonical (only place actually edited)
~/.claude/skills/<skill-name>          → symlink to canonical
~/.codex/skills/<skill-name>           → symlink to canonical (or codex-flavored variant)
~/.codeium/windsurf/skills/<name>      → symlink to canonical
~/.agents/skills/<name>                → symlink to canonical
```

Same pattern for `agents/`, `rules/` (via per-editor wrappers), and `hooks/`.

**Restore order on new machine:**

1. Clone `~/Projects/Current/Active/agents-md/` (canonical body source).
2. Clone any `awesome-claude-skills` mirror you maintain.
3. Restore `~/.cursor/skills/` from dotfiles snapshot.
4. Re-create the symlinks in the four other editor roots:

```bash
for editor in claude codex agents codeium/windsurf; do
  for skill in ~/.cursor/skills/*; do
    name=$(basename "$skill")
    target="$HOME/.${editor}/skills/$name"
    mkdir -p "$(dirname "$target")"
    [ -e "$target" ] || ln -s "$skill" "$target"
  done
done
```

1. Re-run `cd ~/Projects/Current/Active/agents-md && make sync-cursor` to regenerate the per-editor wrappers.

---

## MCP servers

Snapshot from `claude mcp list` (current machine, 17 servers). Categorized by what migration requires.

### A) `npx -y` stdio (auto-regen, no migration needed)

| Server | Trigger | Notes |
|---|---|---|
| `filesystem` | `npx -y @modelcontextprotocol/server-filesystem ~/Projects` | Path arg may need updating per machine |
| `postgres` | `npx -y @modelcontextprotocol/server-postgres postgresql://localhost:5432/postgres` | Requires Postgres running (Milestone 4) |
| `supabase` | `npx -y mcp-remote https://mcp.supabase.com/mcp` | re-auth happens via mcp-remote |
| `ollama` | `npx -y ollama-mcp` | Only useful if Ollama installed on new machine |
| `firecrawl` | `npx -y firecrawl-mcp` | Needs `FIRECRAWL_API_KEY` env var (set via secrets manager Q3) |
| `memory` | `npx -y @modelcontextprotocol/server-memory` | Per-project memory; auto-regen |
| `sequential-thinking` | `npx -y @modelcontextprotocol/server-sequential-thinking` | Stateless |
| `chrome-devtools` | `npx -y chrome-devtools-mcp@latest --executablePath=/Applications/Google Chrome Dev.app/Contents/MacOS/Google Chrome Dev --userDataDir=...` | **Depends on Milestone 7** (Chrome Dev cask). Userdata path is per-machine. |

**Action:** none — these auto-install on first invocation. Just ensure their dependencies (Postgres, Chrome Dev, env vars) are in place per the install order.

### B) Local stdio binaries (need explicit install)

| Server | Path | How to install on new machine |
|---|---|---|
| `github` | `~/.local/bin/github-mcp-server` | **Preferred:** download release tarball from `https://github.com/github/github-mcp-server/releases`, extract binary into `~/.local/bin/`. **Alternate** (requires `brew install go` first, NOT in default Brewfile): `go install github.com/github/github-mcp-server/cmd/github-mcp-server@latest`. Then add `export PATH="$HOME/.local/bin:$PATH"` to `~/.zshrc` if missing. |
| `bsela` | `~/Projects/Current/Active/BEST-Self-Enhancement-Learning-AI/mcp/dist/server.js` | **Depends on Milestone 10** (clone repo + `pnpm build`). `claude mcp` can only register once `dist/server.js` exists. |

**Action:**

1. After Milestone 10 finishes, build BSELA: `cd ~/Projects/Current/Active/BEST-Self-Enhancement-Learning-AI/mcp && pnpm install && pnpm build`.
2. Install GitHub MCP server binary (release tarball or `go install github.com/github/github-mcp-server/cmd/github-mcp-server@latest`).
3. Re-register both:

```bash
claude mcp add github stdio "$HOME/.local/bin/github-mcp-server" stdio
claude mcp add bsela  stdio "node $HOME/Projects/Current/Active/BEST-Self-Enhancement-Learning-AI/mcp/dist/server.js"
```

### C) Remote HTTP / SSE (need re-auth)

| Server | URL | Notes |
|---|---|---|
| `claude.ai Postman` | `https://mcp.postman.com/minimal` | Was already "needs authentication" on snapshot — re-auth required. |
| `claude.ai Vercel` | `https://mcp.vercel.com` | OAuth flow on first call |
| `claude.ai Supabase` | `https://mcp.supabase.com/mcp` | OAuth |
| `claude.ai Google Drive` | `https://drivemcp.googleapis.com/mcp/v1` | Google OAuth |
| `claude.ai Gmail` | `https://gmailmcp.googleapis.com/mcp/v1` | Google OAuth |
| `nansen` | `https://mcp.nansen.ai/ra/mcp` | API token |
| `greptile` | `https://api.greptile.com/mcp` | API token |

**Action:** for each, run `claude mcp add <name> http <url>` (or per current `~/.claude/mcp.json` schema), then trigger a tool call to initiate the OAuth flow. **Never migrate the OAuth tokens themselves.**

---

## Verification

After AI tooling milestone:

```bash
# CLI presence
claude --version && codex --version

# Skills tree intact
test -d ~/.cursor/skills/macos-migration-orchestrator
ls ~/.claude/skills/ | wc -l           # ≥ 30 (current snapshot)
file ~/.claude/skills/macos-migration-orchestrator   # symbolic link to ...

# Rules visible
test -f ~/.claude/CLAUDE.md
test -f ~/.codex/AGENTS.md
test -f ~/.cursor/rules/gotcha.mdc

# MCP — at least the local + npx-stdio servers should connect
claude mcp list 2>&1 | tee /tmp/mcp.out
grep -c '✓ Connected' /tmp/mcp.out     # ≥ A-tier count after Milestone 4 + 7 + 10
grep '✗\|! Needs authentication' /tmp/mcp.out   # only C-tier items expected here pre-auth

# No secrets migrated
test ! -f ~/.codex/auth.json && echo "auth.json correctly absent (will re-auth)"
```

---

## Things that are easy to get wrong

1. **Don't `cp -r` between machines.** Use `chezmoi`, `stow`, or a dotfiles repo. The allowlist guards against accidental migration of `sessions/`, `cache/`, `auth.json`.
2. **Don't migrate VSIX caches.** `~/.cursor/extensions/` and `~/.windsurf/extensions/` rebuild themselves; copying them just bloats the new disk and pins old versions.
3. **Don't migrate compiled language servers.** `~/.codeium/language-server*` is platform/version specific. Let Windsurf re-download on first launch.
4. **MCP order matters.** `chrome-devtools` MCP fails until Chrome Dev is installed (Milestone 7). `bsela` MCP fails until the repo is cloned and built (Milestone 10). Register MCP servers AFTER their dependencies exist.
5. **Re-auth, don't carry tokens.** Every OAuth/API token regenerates fresh on the new machine.
