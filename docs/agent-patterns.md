# Agent Patterns

Normalized patterns extracted from Claude, Codex, and Windsurf assets for reuse in rule design, workflow design, and agent tuning.

## Rule Design Patterns

### Keep the Rule File Short and Behavioral

Use the core rule file for:

- execution posture
- decision boundaries
- quality bar
- editing and debugging discipline

Do not overload the rule file with:

- long checklists
- example-heavy tutorials
- domain references
- giant implementation catalogs

Move those into context, hard prompts, workflows, or skills.

### Canonical Rule Structure

Best structure found:

- Operating principles
- Planning vs implementation
- Language-specific code style
- Error handling
- Git
- Security
- Testing
- Performance
- Debugging
- Environment
- Hooks and context integration notes

## Skill Design Patterns

### Compact Skill Frontmatter

Best minimal agent descriptor found in Codex:

```yaml
name: coding-rules
description: Project-specific coding conventions, style rules, stack configuration, and workflow patterns.
```

### Dense Focused Skills Beat Broad Generic Skills

High-signal skills found in the scan:

- systematic debugging
- api design patterns
- security checklist
- coding rules

Lower-signal skills:

- broad senior-generalist packs that mostly restate common advice

#### Rule for Future Skills

- prefer one sharp skill per concern
- include examples or checklists only when they change behavior
- avoid generic filler sections

### Specialist Agent Pattern

Use narrow specialist agents for recurring deep work:

- database expert for schema, indexing, migrations, and performance
- security auditor for auth, input validation, secrets, and exposure review
- frontend reviewer for UI and interaction integrity

Best coordination pattern:

- run one specialist first for analysis
- hand its output to the next specialist for verification
- keep orchestration at the parent agent layer

## Hook Patterns

### Dispatcher Hook

Use one stable entrypoint and load enabled hooks dynamically.

#### Benefits

- add or remove hooks without restart
- isolated hook failures
- clear alphabetical execution order
- easy experimentation

#### Recommended Shape

```text
hooks/
├── dispatcher-hook.sh
├── enabled/
│   ├── checkpoint.sh
│   └── test-gate.sh
└── disabled/
```

### Test Gate Hook

Best enforcement pattern found:

- intercept commit attempts
- run available test suite
- deny commit if tests fail
- run post-edit async validation where possible
- no-op if no test runner is available

#### Use Cases

- `git commit` gate
- post-edit validation for `ts`, `tsx`, `js`, `jsx`, `py`
- automatic feedback loop during coding

#### Design Rules

- do not fail when the environment lacks test tooling
- limit output size
- support both Node and Python projects
- keep the hook deterministic

### Checkpoint and Resume Hook

Best recovery pattern found:

- `$cc <name>` to snapshot progress
- `$cc-list` to discover checkpoints
- `$cc-resume <name>` to restore context

#### Why It Matters

- long tasks survive context loss
- resumability becomes a first-class workflow
- reduces repeated repo re-analysis

## Workflow Patterns

### ATLAS Phase Discipline

Best workflow found:

- Architect
- Trace
- Link
- Assemble
- Stress-test

#### Why It Works

- forces design before edits
- validates integrations before build
- reduces UI-first drift
- preserves layered architecture

#### Recommended Reuse

- use ATLAS for builds and large migrations
- add Validate and Monitor for production-facing work

### Goals Manifest

Use a tiny registry that maps intent to assets.

#### Goals Manifest Example

```markdown
| Goal        | File                          | Description               |
| ----------- | ----------------------------- | ------------------------- |
| Build App   | ../workflows/build-app.md     | ATLAS 5-step app building |
| Code Review | ../hardprompts/code-review.md | Review for bugs and risk  |
```

#### Why Goals Manifests Matter

- simpler routing
- easier editor parity
- easier onboarding for future agents

## Context Patterns

### Context Is Static Reference, Not Behavior

Best rule from Windsurf context docs:

- context shapes quality and style
- it should not dictate process or control flow

#### Good Context Content

- tech stack
- domain notes
- examples
- voice or tone references
- negative examples

#### Bad Context Content

- execution rules
- task workflow logic
- tool permissions

### Context Hygiene

Load only the files relevant to the task at hand.

- prefer specific files over whole directories
- compact long sessions instead of dragging stale context forward
- clear context aggressively when the task changes shape

## Hard Prompt Patterns

### Small Task-Specific Prompt Blocks

Best assets are short and purpose-built.

#### Current Winning Prompt Types

- code review
- security audit
- refactor plan

#### Hard Prompt Design Rules

- keep under one screen when possible
- specify evaluation axes
- specify output format
- avoid mixing unrelated goals in one prompt

## Coding Patterns Worth Reusing

### TypeScript

```typescript
export function calculateTotal(items: Array<Item>): number {
  return items.reduce((sum, item) => sum + item.price, 0);
}

function handleError(error: unknown): string {
  if (error instanceof Error) return error.message;
  return "Unknown error";
}
```

### Python

```python
from pathlib import Path

def read_config(path: Path) -> dict | None:
    if not path.exists():
        return None
    return json.loads(path.read_text())
```

### Next.js App Router

```typescript
export default async function Page(): Promise<JSX.Element> {
  const data = await fetchData();
  return <Component data={data} />;
}
```

## Decision Matrix

| Concern                 | Best home                   |
| ----------------------- | --------------------------- |
| Core operating behavior | `src/gotcha.md`             |
| Stack references        | context docs                |
| Debugging method        | focused skill               |
| API guidance            | focused skill or hardprompt |
| Review checklist        | hardprompt                  |
| Build lifecycle         | workflow                    |
| Enforcement             | hook                        |
| Session recovery        | hook plus workflow          |

## Upgrade Direction

Use these extracted patterns to evolve `agents-md` toward:

- one canonical rule base
- editor-specific wrappers instead of duplicated bodies
- hook-driven quality controls
- stronger workflow routing
- a maintainable reference library instead of scattered memory
