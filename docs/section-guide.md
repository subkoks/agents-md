# Section Guide

How to use each section of gotcha.md effectively.

## GOTCHA Framework

**Purpose:** Defines the 6-layer architecture.

**When to reference:** Understanding why rules exist, debugging AI behavior, explaining to others.

**Key insight:** You are the Orchestration layer — coordinate, don't execute directly.

---

## Operating Principles

**Purpose:** Core behavior rules.

**When to reference:** Every interaction.

**Key rules:**
- Be direct, no preamble
- Solve exactly what's asked
- Read before modifying

---

## Execution Autonomy & Auto Mode

**Purpose:** Permission boundaries.

**When to reference:** Before running commands, especially destructive ones.

**Key distinction:**
- Normal mode: Ask before destructive actions
- Auto mode: Full autonomy (triggered by "auto mode" or "I'm going to sleep")

---

## Operating Rules

**Purpose:** Workflow and tool usage patterns.

**When to reference:** Starting any task.

**Key rules:**
1. Check workflows first
2. Check tools first
3. Fix and document failures

---

## Planning vs. Implementation

**Purpose:** Dual-mode behavior.

**When to reference:** Switching between planning and doing.

**Planning mode:** Offer options, identify edge cases, ask clarifying questions.
**Implementation mode:** Execute the plan, verify changes, complete fully.

---

## Code Style

**Purpose:** Language-specific conventions.

**When to reference:** Writing or modifying code.

**Sections:**
- General (naming, constants, early returns)
- TypeScript/JavaScript (strict mode, ESM, Array<T>)
- Python (3.13+, type hints, pathlib)
- React/Next.js (functional components, Server Components, shadcn/ui)

---

## Error Handling

**Purpose:** How to handle failures.

**When to reference:** Writing error handling code, debugging.

**Key rules:**
- Handle at boundaries
- Use specific error types
- Log with context

---

## Git

**Purpose:** Version control conventions.

**When to reference:** Committing, branching, pushing.

**Key rules:**
- main/master protected
- Feature branches only
- One logical change per commit

---

## Security

**Purpose:** Security best practices.

**When to reference:** Handling user input, secrets, database queries.

**Key rules:**
- Secrets in env vars only
- Validate all input
- Parameterized queries

---

## Testing

**Purpose:** When and how to test.

**When to reference:** Writing tests, modifying shared logic.

**Key rules:**
- Test when asked or modifying critical code
- Colocate tests with source
- Focus on edge cases

---

## Performance

**Purpose:** Optimization rules.

**When to reference:** Performance issues, large data, slow queries.

**Key rules:**
- Profile first
- Index frequently queried columns
- Target p95 < 200ms

---

## Debugging

**Purpose:** Systematic debugging methodology.

**When to reference:** Any bug investigation.

**Key steps:**
1. State symptom precisely
2. Read full error/trace
3. One hypothesis at a time
4. One change at a time
5. Fix root cause

---

## Tool Usage

**Purpose:** How to use available tools.

**When to reference:** Running commands, editing files.

**Key rules:**
- Read before editing
- Prefer targeted edits
- Check project AGENTS.md for project-specific rules

---

## Project Structure Convention

**Purpose:** Standard layout for new projects.

**When to reference:** Creating new projects.

**Structure:**
```
project/
├── README.md
├── .env.example
├── goals/
├── tools/
├── context/
├── args/
├── data/
├── .tmp/
└── src/
```

---

## User Context & Environment

**Purpose:** Machine and environment details.

**When to reference:** Running system commands, understanding constraints.

**Key details:**
- MacBook Pro 2019, Intel i9, 32GB RAM
- iTerm2 + Zsh + Oh My Zsh
- Node.js v22, Python 3.13+
- pnpm v10, uv/pip

---

## Your Job

**Purpose:** Mission statement.

**When to reference:** Remembering what you're supposed to do.

**Summary:** Sit between goals and tools. Read, apply, delegate, handle failures, strengthen the system. Be direct. Be reliable. Get shit done.
