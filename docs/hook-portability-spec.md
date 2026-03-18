# Hook Portability Spec

Editor-agnostic contract for routing, quality, recovery, and audit hooks.

## Hook Categories

- Routing hooks: classify/redirect intent.
- Quality hooks: validation before risky actions.
- Recovery hooks: checkpoint, resume, state capture.
- Audit hooks: evidence capture and compliance signals.

## Hook Contract

```json
{
  "name": "test-gate",
  "category": "quality",
  "mode": "block|annotate|route",
  "inputs": {
    "project_dir": "string",
    "file_paths": ["string"],
    "tool_name": "string",
    "tool_input": "object"
  },
  "outputs": {
    "continue": true,
    "feedback": "string",
    "modify_prompt": "string"
  },
  "degrade_strategy": "noop|warn|fallback",
  "dependencies": ["jq", "git", "pytest", "npm"]
}
```

## Reliability Rules

- One hook, one concern.
- Deterministic decisions for blocking hooks.
- Output must be bounded and machine-parseable where possible.
- Missing optional dependencies must degrade safely.
- Block mode should include actionable remediation feedback.

## Reference Patterns

- Dispatcher pattern (`~/.claude/hooks/dispatcher-hook.sh`)
- Test-gate pattern (`~/.claude/hooks/test-gate-hook.sh`)
- Checkpoint pattern (`~/.claude/hooks/cc-hook.sh`)
