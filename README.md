# agents-md

Canonical source for AI agent rules — the GOTCHA framework superfile.

## Purpose

Single source of truth for all AI agent operating rules. Version controlled, regularly updated, synced to Windsurf.

## Structure

```
agents-md/
├── src/gotcha.md        # Canonical rules (sync to ~/.windsurf/rules/)
├── drafts/              # WIP experiments
├── ideas/               # Future enhancements
├── templates/           # Reusable templates
├── scripts/             # Sync & validation scripts
└── docs/                # Philosophy & guides
```

## Usage

### Sync to Windsurf

```bash
./scripts/sync-to-windsurf.sh
```

### Validate Rules

```bash
./scripts/validate-rules.sh
```

### Add New Idea

1. Create file in `ideas/` with descriptive name
2. Document the enhancement, rationale, examples
3. Review in ROADMAP.md
4. Implement → update src/gotcha.md → sync

## Version History

See [CHANGELOG.md](./CHANGELOG.md)

## Philosophy

The GOTCHA framework separates concerns into 6 layers:

- **G**oals — What needs to happen
- **O**rchestration — AI coordinating execution
- **T**ools — Deterministic scripts/MCP servers
- **C**ontext — Domain knowledge, references
- **H**ard prompts — Reusable instruction templates
- **A**rgs — Behavior settings, config

**Core principle:** Push reliability into code, flexibility into LLM.

## Sections

| Section | Purpose |
|---------|---------|
| Operating Principles | Direct delivery, no preamble |
| Execution Autonomy | What AI can do without asking |
| Auto Mode | Overnight agent full autonomy |
| Operating Rules | Workflows first, tools first |
| Planning vs Implementation | Dual-mode behavior |
| Code Style | TS/JS/Python/React conventions |
| Error Handling | Boundary handling, logging |
| Git | Branching, commits, staging |
| Security | OWASP, secrets, validation |
| Testing | When/how to write tests |
| Performance | Optimization rules |
| Debugging | Systematic methodology |
| Tool Usage | Shell, edits, search |
| Project Structure | Convention for new projects |
| User Context | Machine, environment, editors |

## Sync Target

```
src/gotcha.md → ~/.windsurf/rules/gotcha.md
```

## Related

- `~/AGENTS.md` — For other editors (Claude Code, Codex CLI)
- `~/.windsurf/workflows/` — ATLAS workflow and others
- `~/.windsurf/tools/memory/` — Memory system
