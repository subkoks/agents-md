# CLAUDE.md

Project guidance for Claude Code. The canonical contributor and agent rules for
this repository live in `AGENTS.md` — load them:

@AGENTS.md

## Cloud sessions (Claude Code on the web)

This repo is cloud-ready. A `SessionStart` hook (`.claude/settings.json` ->
`scripts/cloud-setup.sh`) bootstraps dependencies automatically in Anthropic
cloud sessions (`claude --remote`, `claude.ai/code`). It is cloud-guarded
(`CLAUDE_CODE_REMOTE=true`) and a no-op in local sessions.
