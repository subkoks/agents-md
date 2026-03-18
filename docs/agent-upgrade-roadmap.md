# Agent Upgrade Roadmap

Concrete upgrade backlog for turning the scanned Claude, Codex, and Windsurf assets into a tighter agent system around `agents-md`.

## Priority 1

## Unify the canonical rule stack

- **Goal:** keep one real rule source and reduce drift across editors.
- **Actions:**
  - keep `src/gotcha.md` as the canonical body
  - create editor wrapper files that only contain editor-specific notes
  - remove duplicated rule text where possible
- **Why:** the current Claude/Codex/Windsurf rule bodies are nearly identical
- **Impact:** high
- **Risk:** low

## Document the full agent ecosystem in the project README

- **Goal:** make `agents-md` explain rules, hooks, workflows, prompts, and context as one system
- **Actions:**
  - add links to the new docs
  - describe how rules connect to hooks and workflows
- **Impact:** high
- **Risk:** low

## Add a hook strategy document

- **Goal:** preserve the Claude hook architecture inside the project
- **Actions:**
  - document dispatcher pattern
  - document test-gate pattern
  - document checkpoint/resume pattern
  - record dependencies like `jq`, `git`, `pytest`, `npm`
- **Impact:** high
- **Risk:** low

## Priority 2

## Port the test-gate concept into a reusable editor-agnostic spec

- **Goal:** convert the best current automation into a portable standard
- **Actions:**
  - define pre-commit gate behavior
  - define post-edit validation behavior
  - define fallback behavior when no test runner exists
- **Impact:** very high
- **Risk:** medium

## Create a goals registry for `agents-md`

- **Goal:** route large classes of work through explicit assets instead of ad-hoc prompting
- **Actions:**
  - add a goals manifest to the project
  - map build, review, audit, refactor, debug to workflows or prompts
- **Impact:** medium
- **Risk:** low

## Split reference material by layer

- **Goal:** keep GOTCHA layers clean in the repo itself
- **Actions:**
  - rules in `src/`
  - context references in `docs/` or `context/`
  - prompts in `templates/` or dedicated prompt docs
  - workflows in a dedicated project workflow area if needed
- **Impact:** medium
- **Risk:** low

## Priority 3

## Build a curated skill shortlist

- **Goal:** reduce noise from huge skill directories
- **Actions:**
  - keep a shortlist of high-signal skills only
  - rank by density, reusability, and actionability
  - mark broad generic skills as secondary references
- **Recommended shortlist:**
  - coding-rules
  - systematic-debugging
  - api-design-patterns
  - security-checklist
  - build-app workflow
- **Impact:** medium
- **Risk:** low

## Create upgrade candidates for `src/gotcha.md`

- **Add:**
  - explicit rule/context/workflow/hardprompt separation note
  - hook integration note referencing dispatcher and test-gate concepts
  - session recovery guidance referencing checkpoint/resume workflow
- **Avoid adding:**
  - giant skill dumps
  - example-heavy tutorials
  - long security or review checklists better suited for prompts

## Priority 4

## Add project-local workflow assets

- **Goal:** stop relying only on global Windsurf workflow files
- **Actions:**
  - copy or adapt ATLAS into a project-owned workflow reference
  - add a debug workflow based on systematic-debugging
  - add a review workflow based on code-review and security-audit prompts
- **Impact:** medium
- **Risk:** medium

## Introduce hook runtime control profiles

- **Goal:** reduce hook overhead while preserving safety by profile-based execution.
- **Actions:**
  - define `minimal`, `standard`, and `strict` profile semantics
  - route selected hooks by profile at runtime
  - support env override for profile switching per task/session
- **Impact:** high
- **Risk:** low

## Add controlled hook disable-list mechanism

- **Goal:** allow temporary suppression of noisy hooks without deleting configuration.
- **Actions:**
  - define `DISABLED_HOOKS` convention
  - require suppression reason in logs
  - make disable-list visible in quality reports
- **Impact:** medium
- **Risk:** low

## Add security scanner workflow for agent configs

- **Goal:** audit rules/hooks/MCP/tool permissions for unsafe defaults.
- **Actions:**
  - define severity taxonomy (`critical/high/medium/low/info`)
  - emit machine-readable report plus markdown summary
  - wire optional CI fail thresholds
- **Impact:** very high
- **Risk:** medium

## Add orchestration graph + quality gate patterns

- **Goal:** make multi-agent execution deterministic and reviewable.
- **Actions:**
  - define DAG/wave-based task scheduling model
  - add cost/runtime budget guardrails
  - add final high-reasoning quality-gate pass over combined outputs
  - add session event recording and replay support
- **Impact:** very high
- **Risk:** medium

## Add a maintenance loop

- **Goal:** prevent drift between live agent configs and this project database
- **Actions:**
  - define a scan cadence
  - compare source paths for changes
  - update the database when hooks, skills, or rule files change materially
- **Impact:** medium
- **Risk:** low

## Promote / Keep / Reject Matrix

- canonical GOTCHA body — **promote** — best place for shared agent behavior
- Claude dispatcher hook — **promote** — flexible architecture
- Claude test-gate hook — **promote** — highest-value automation
- Claude checkpoint hook — **promote** — context recovery
- Codex coding-rules skill — **promote** — strongest concise conventions pack
- Windsurf ATLAS workflow — **promote** — best build discipline
- Windsurf hardprompts — **promote** — lean and reusable
- broad senior-generalist skills — **keep secondary** — too verbose for the core database
- duplicated editor rule files — **reduce** — high drift risk

## Immediate next implementation candidates

1. Update `README.md` to expose the new database docs
2. Add a dedicated hook reference document
3. Add a project goals manifest
4. Add an editor-alignment wrapper strategy doc
5. Refine `src/gotcha.md` so it references layers instead of absorbing them
