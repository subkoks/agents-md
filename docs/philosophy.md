# Philosophy

Why the GOTCHA framework exists and how it works.

## The Problem

LLMs are unreliable over multi-step tasks:

- 90% accuracy per step = ~59% accuracy over 5 steps
- Each step compounds uncertainty
- Complex tasks degrade exponentially

## The Solution

Separate concerns into layers:

### GOT (The Engine) — Reliability

- **Goals** — What needs to happen (process definitions, workflows)
- **Orchestration** — AI coordinating execution (you)
- **Tools** — Deterministic scripts/MCP servers that do actual work

### CHA (The Context) — Flexibility

- **Context** — Reference material, domain knowledge, project docs
- **Hard prompts** — Reusable instruction templates for sub-tasks
- **Args** — Behavior settings (config files, env vars, feature flags)

## The Insight

```
Push reliability into deterministic code (tools, scripts, MCP)
Push flexibility/reasoning into the LLM (you)
Push process clarity into goals (markdown workflows)
Push behavior settings into args (yaml/json configs)
Push domain knowledge into context (docs, examples, references)
```

You make smart decisions. Tools execute perfectly.

## Why This Works

1. **Deterministic tools don't hallucinate** — A script that copies a file always copies it correctly
2. **Workflows provide structure** — Clear steps reduce decision fatigue
3. **Context grounds reasoning** — Reference docs prevent invention
4. **Args control behavior** — Config changes don't require prompt changes

## The Alternative

Without this structure:
- AI improvises every step → inconsistency
- No reusable components → repetition
- Process knowledge lost → relearning each session
- No separation of concerns → mixing strategy with execution

## Origin

From the video "I Made Claude Code and Codex Build the Same App" — the structured GOTCHA framework was the difference between success and failure in complex multi-step tasks.
