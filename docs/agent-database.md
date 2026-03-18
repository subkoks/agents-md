# Agent Database

Curated reference database of the highest-value agent rules, hooks, skills, workflows, and prompt assets currently active across Claude, Codex, and Windsurf.

## Purpose

This file is the working inventory for improving agent quality inside `agents-md`.
It records what exists, why it matters, what should be promoted, and where the source of truth currently lives.

## Source Map

- `~/.windsurf/rules/gotcha.md` — active rule — primary — core operating behavior for Windsurf sessions
- `~/.claude/CLAUDE.md` — active rule — aligned — mirrors the core operating model with hook/context guidance
- `~/.codex/AGENTS.md` — active rule — aligned — Codex-side version of the same conventions
- `~/.codex/skills/coding-rules/` — skill pack — high value — most concise stack and style rules with example patterns
- `~/.claude/hooks/dispatcher-hook.sh` — hook — high value — dynamic hook loading without restart
- `~/.claude/hooks/test-gate-hook.sh` — hook — high value — commit gate plus async post-edit verification loop
- `~/.claude/hooks/cc-hook.sh` — hook — high value — session checkpointing and resume workflow
- `~/.windsurf/workflows/build-app.md` — workflow — high value — ATLAS build discipline
- `~/.windsurf/context/tech-stack.md` — context — high value — canonical stack preferences
- `~/.windsurf/goals/manifest.md` — goals index — high value — simple goal-routing registry
- `~/.windsurf/hardprompts/*.md` — hard prompts — high value — small reusable review, audit, and refactor templates
- `~/.claude/skills/systematic-debugging/` — skill — high value — best debugging methodology asset found
- `~/.claude/skills/api-design-patterns/` — skill — high value — strong REST rules and examples
- `~/.claude/skills/security-checklist/` — skill — high value — practical hardening checklist
- `~/.claude/skills/senior-fullstack/` — skill — medium — broad but generic; useful more as category marker
- `~/.claude/skills/code-reviewer/` — skill — medium — useful coverage, but less dense than hardprompt plus checklist combo

## Best Assets by Category

### 1. Core Rule Layer

#### Primary Rule Set

- **Promote:** `src/gotcha.md`
- **External references:** `~/.windsurf/rules/gotcha.md`, `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`
- **Reason:** These three files are largely the same operating model. The right move is to keep one canonical rule body and maintain thin editor-specific wrappers only where behavior differs.

#### Core Behaviors Worth Preserving

- **Direct execution**
- **Read before edit**
- **Minimal diff mindset**
- **Plan before multi-file work**
- **Typed validation at boundaries**
- **Root-cause debugging**
- **Environment-specific stack rules**

### 2. Hook Layer

#### Dynamic Hook Dispatcher

- **Source:** `~/.claude/hooks/dispatcher-hook.sh`
- **Pattern:** register one hook once, load actual hooks from an `enabled/` directory
- **Why it matters:** removes restart friction and makes hook experimentation cheap
- **Promote:** yes

#### Test Gate Hook

- **Source:** `~/.claude/hooks/test-gate-hook.sh`
- **Pattern:**
  - block `git commit` when tests fail
  - run async checks after source edits
  - gracefully no-op when no test runner exists
- **Why it matters:** highest-value automation in the whole scan
- **Promote:** yes
- **Caveat:** depends on `jq`, `git`, `npm`, `pytest`, local project shape

#### Checkpoint / Resume Hook

- **Source:** `~/.claude/hooks/cc-hook.sh`
- **Pattern:** session checkpoint save, list, and resume commands
- **Why it matters:** strong long-context recovery mechanism
- **Promote:** yes, but as workflow infrastructure rather than core coding rule

### 3. Skill Layer

#### Coding Rules Skill

- **Source:** `~/.codex/skills/coding-rules/SKILL.md`
- **Why it matters:** the cleanest short-form stack and code-style pack found
- **Promote:** yes
- **Best companion file:** `~/.codex/skills/coding-rules/references/detailed-rules.md`

#### Systematic Debugging Skill

- **Source:** `~/.claude/skills/systematic-debugging/SKILL.md`
- **Why it matters:** dense, actionable, not bloated
- **Promote:** yes
- **Best concepts:** reproduce, isolate, test hypothesis, regression test, verify root cause

#### API Design Patterns Skill

- **Source:** `~/.claude/skills/api-design-patterns/SKILL.md`
- **Why it matters:** concrete resource naming, status codes, pagination, validation, rate limiting
- **Promote:** yes

#### Security Checklist Skill

- **Source:** `~/.claude/skills/security-checklist/SKILL.md`
- **Why it matters:** practical launch and review checklist with concrete headers and auth rules
- **Promote:** yes

#### Broad Senior Skills

- **Sources:** `senior-fullstack`, `code-reviewer`
- **Why they rank lower:** broad coverage but too much generic boilerplate relative to the stronger focused assets above
- **Promote:** partially, mostly as category references rather than core source text

### 4. Workflow Layer

#### ATLAS Workflow

- **Source:** `~/.windsurf/workflows/build-app.md`
- **Why it matters:** strongest execution workflow found
- **Promote:** yes
- **Best parts:** Architect, Trace, Link, Assemble, Stress-test, plus Validate and Monitor for production

#### Goals Manifest Pattern

- **Source:** `~/.windsurf/goals/manifest.md`
- **Why it matters:** simple registry that maps goals to workflow or prompt assets
- **Promote:** yes

### 5. Context Layer

#### Tech Stack Context

- **Source:** `~/.windsurf/context/tech-stack.md`
- **Why it matters:** keeps stack preferences outside the main rule file and avoids bloating core instructions
- **Promote:** yes

#### Context README Pattern

- **Source:** `~/.windsurf/context/README.md`
- **Why it matters:** clearly defines what belongs in context versus rules or workflows
- **Promote:** yes

### 6. Hard Prompt Layer

#### Highest-Value Prompt Assets

- **Code Review:** `~/.windsurf/hardprompts/code-review.md`
- **Security Audit:** `~/.windsurf/hardprompts/security-audit.md`
- **Refactor Plan:** `~/.windsurf/hardprompts/refactor-plan.md`

#### Why they matter

- Small
- Composable
- Easy to inject into specific subtasks
- Better than embedding these checklists directly into giant global rules

## Normalized Patterns to Reuse

### Editor Alignment Pattern

Use one canonical rule source with editor-specific adapters:

- `agents-md/src/gotcha.md` as canonical body
- Claude wrapper for Claude-specific hooks/context notes
- Codex wrapper for Codex skill routing
- Windsurf wrapper for workflows/goals/hardprompt integration

### Hook Pattern

Use a dispatcher architecture:

- one installed hook entrypoint
- multiple enabled scripts in a directory
- feature hooks remain independently toggleable

### Recovery Pattern

Use explicit checkpoint/resume commands for long sessions:

- save progress snapshot
- list snapshots
- inject summary or recent transcript on resume

### Validation Pattern

Use layered safeguards:

- static rules define expectations
- hard prompts structure audits
- hooks enforce tests and prevent sloppy commits
- workflows force phase discipline

## What to Promote, Merge, or Retire

- GOTCHA + CLAUDE + Codex AGENTS — **merge around one source** — too much duplication
- Codex coding-rules — **promote** — best compact conventions pack
- Claude dispatcher hook — **promote** — strong extensibility pattern
- Claude test-gate hook — **promote** — strongest quality automation found
- Claude checkpoint hook — **promote** — valuable context recovery
- Windsurf ATLAS workflow — **promote** — best execution scaffold
- Windsurf hardprompts — **promote** — lightweight and reusable
- Broad senior skills — **trim/extract** — useful, but verbose and generic

## Gaps Found

- No project-local database currently tracks these assets together.
- Hook strategy exists in Claude but is not documented inside `agents-md`.
- The current project explains the canonical rule file, but not the surrounding ecosystem.
- No normalized matrix exists for deciding what belongs in rules vs context vs workflow vs hardprompt vs hook.

## Recommended Canonical Database Layout

- **Inventory:** this file
- **Patterns:** `docs/agent-patterns.md`
- **Upgrade roadmap:** `docs/agent-upgrade-roadmap.md`
- **Canonical rules:** `src/gotcha.md`
- **Templates:** `templates/`

## Source Paths

- `~/.windsurf/rules/gotcha.md`
- `~/.claude/CLAUDE.md`
- `~/.codex/AGENTS.md`
- `~/.codex/skills/coding-rules/SKILL.md`
- `~/.codex/skills/coding-rules/references/detailed-rules.md`
- `~/.claude/hooks/dispatcher-hook.sh`
- `~/.claude/hooks/test-gate-hook.sh`
- `~/.claude/hooks/cc-hook.sh`
- `~/.claude/skills/systematic-debugging/SKILL.md`
- `~/.claude/skills/api-design-patterns/SKILL.md`
- `~/.claude/skills/security-checklist/SKILL.md`
- `~/.windsurf/context/README.md`
- `~/.windsurf/context/tech-stack.md`
- `~/.windsurf/goals/manifest.md`
- `~/.windsurf/workflows/build-app.md`
- `~/.windsurf/hardprompts/code-review.md`
- `~/.windsurf/hardprompts/security-audit.md`
- `~/.windsurf/hardprompts/refactor-plan.md`
