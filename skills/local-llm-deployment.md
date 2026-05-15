---
name: local-llm-deployment
description: Use when running local LLMs (Ollama, llama.cpp, vLLM) for dev, agents, or offline inference workflows.
---

# Local LLM Deployment

## When to Use

- Offline or privacy-sensitive inference
- Dev loops with local models before cloud APIs
- Agent tooling wired to OpenAI-compatible local endpoints

## Implementation Workflow

1. Pick runtime: Ollama (simple), llama.cpp (edge), vLLM (throughput).
2. Document model name, quant, context length, and RAM/VRAM needs.
3. Expose OpenAI-compatible base URL if integrating with existing clients.
4. Benchmark latency and tokens/sec for target prompt size.
5. Version-pin models; document pull/update commands.

## Hard Rules

- Do not expose unauthenticated inference APIs on public interfaces.
- No training data or prompts with secrets in shared logs.
- Set context and max tokens explicitly; handle OOM gracefully.
- Separate dev models from any production-adjacent paths.

## Done Criteria

- Health check or `curl` smoke test documented.
- Resource requirements listed (RAM, GPU).
- Fallback to cloud documented when local model insufficient.

## Related Skills

- `cursor-agent-workflow.md`
- `mcp-tools-and-servers.md`
