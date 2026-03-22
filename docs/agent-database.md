# Agent Database

Curated reference database of the highest-value rules, hooks, skills, workflows, and prompt assets tracked inside this repository.

## Purpose

This file is the working inventory for improving agent quality inside `agents-md`.
It records what exists, why it matters, what should be promoted, and where the source of truth currently lives.

## Source Map

- `src/gotcha.md` — active rule — primary — canonical operating behavior
- `docs/agent-patterns.md` — pattern reference — high value — normalized execution and design patterns
- `docs/hook-reference.md` — hook reference — high value — routing/quality/recovery hook patterns
- `docs/hook-portability-spec.md` — portability contract — high value — editor-agnostic hook interface
- `docs/editor-alignment-strategy.md` — packaging strategy — high value — canonical to artifact flow
- `docs/goals-manifest.md` — routing matrix — high value — maps work classes to project assets
- `templates/project-agents.md` — template — high value — project-level rule override template
- `skills/` — skill pack — high value — curated crypto/web3/Solana development and trading-analysis playbooks
- `skills/registry.tsv` — registry metadata — medium — lifecycle and trigger inventory

## Best Assets by Category

### 1. Core Rule Layer

#### Primary Rule Set

- **Promote:** `src/gotcha.md`
- **Generated artifacts:** `dist/rules/windsurf.md`, `dist/rules/claude.md`, `dist/rules/codex.md`
- **Reason:** Keep one canonical rule body and generate thin packaging artifacts for portability.

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

- **Source:** `docs/hook-reference.md`
- **Pattern:** register one hook once, load actual hooks from an `enabled/` directory
- **Why it matters:** removes restart friction and makes hook experimentation cheap
- **Promote:** yes

#### Test Gate Hook

- **Source:** `docs/hook-reference.md`
- **Pattern:**
  - block `git commit` when tests fail
  - run async checks after source edits
  - gracefully no-op when no test runner exists
- **Why it matters:** highest-value automation in the whole scan
- **Promote:** yes
- **Caveat:** depends on `jq`, `git`, `npm`, `pytest`, local project shape

#### Checkpoint / Resume Hook

- **Source:** `docs/hook-reference.md`
- **Pattern:** session checkpoint save, list, and resume commands
- **Why it matters:** strong long-context recovery mechanism
- **Promote:** yes, but as workflow infrastructure rather than core coding rule

### 3. Skill Layer

#### Coding Rules Skill

- **Source:** `skills/README.md`
- **Why it matters:** the cleanest short-form stack and code-style pack found
- **Promote:** yes
- **Best companion file:** `skills/registry.tsv`

#### Systematic Debugging Skill

- **Source:** `docs/agent-patterns.md`
- **Why it matters:** dense, actionable, not bloated
- **Promote:** yes
- **Best concepts:** reproduce, isolate, test hypothesis, regression test, verify root cause

#### API Design Patterns Skill

- **Source:** `docs/agent-patterns.md`
- **Why it matters:** concrete resource naming, status codes, pagination, validation, rate limiting
- **Promote:** yes

#### Security Checklist Skill

- **Source:** `docs/agent-patterns.md`
- **Why it matters:** practical launch and review checklist with concrete headers and auth rules
- **Promote:** yes

#### Crypto/Web3/Solana Skill Pack

- **Source:** `skills/README.md` and `skills/*.md`
- **Why it matters:** adds domain-specific execution patterns missing from generic engineering skills
- **Promote:** yes
- **Coverage:** Solana Anchor program design, Solana wallet/client integration, web3 dApp architecture, EVM contract engineering, DeFi protocol engineering, memecoin launch ops, pump.fun launch automation, on-chain flow analysis, Axiom/Padre/Nova terminal workflows, sniper bot scripts/automation, memecoin trading risk controls, Solana security audit

#### Broad Senior Skills

- **Sources:** `senior-fullstack`, `code-reviewer`
- **Why they rank lower:** broad coverage but too much generic boilerplate relative to the stronger focused assets above
- **Promote:** partially, mostly as category references rather than core source text

### 4. Workflow Layer

#### ATLAS Workflow

- **Source:** `docs/agent-patterns.md`
- **Why it matters:** strongest execution workflow found
- **Promote:** yes
- **Best parts:** Architect, Trace, Link, Assemble, Stress-test, plus Validate and Monitor for production

#### Goals Manifest Pattern

- **Source:** `docs/goals-manifest.md`
- **Why it matters:** simple registry that maps goals to workflow or prompt assets
- **Promote:** yes

### 5. Context Layer

#### Tech Stack Context

- **Source:** `docs/agent-patterns.md`
- **Why it matters:** keeps stack preferences outside the main rule file and avoids bloating core instructions
- **Promote:** yes

#### Context README Pattern

- **Source:** `README.md`
- **Why it matters:** clearly defines what belongs in context versus rules or workflows
- **Promote:** yes

### 6. Hard Prompt Layer

#### Highest-Value Prompt Assets

- **Code Review:** `docs/agent-patterns.md`
- **Security Audit:** `docs/security-scan-spec.md`
- **Refactor Plan:** `docs/agent-upgrade-roadmap.md`

#### Why they matter

- Small
- Composable
- Easy to inject into specific subtasks
- Better than embedding these checklists directly into giant global rules

## Normalized Patterns to Reuse

### Editor Alignment Pattern

Use one canonical rule source with editor-specific packaging artifacts:

- `agents-md/src/gotcha.md` as canonical body
- `dist/rules/claude.md` for Claude packaging
- `dist/rules/codex.md` for Codex packaging
- `dist/rules/windsurf.md` for Windsurf packaging

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

- `src/gotcha.md`
- `dist/rules/windsurf.md`
- `dist/rules/claude.md`
- `dist/rules/codex.md`
- `docs/agent-patterns.md`
- `docs/hook-reference.md`
- `docs/hook-portability-spec.md`
- `docs/goals-manifest.md`
- `docs/editor-alignment-strategy.md`
- `docs/security-scan-spec.md`
- `skills/README.md`
- `skills/registry.tsv`
