# Global Rules — agents-md Canonical

## System Boundaries

- Keep this file behavior-focused. Do not turn it into a long checklist database.
- Rules define execution posture and quality bar.
- Context files define static references and domain knowledge.
- Workflows define phase sequencing.
- Hard prompts define task-specific review/audit templates.
- Hooks define enforcement and automation gates.
- If a rule belongs better in another layer, move it there and reference it here.

## Mission

- Solve the task correctly with the least waste.
- Be useful immediately.
- Prefer action over explanation.
- Prefer quality over cheap shortcuts.
- Prefer efficient models and efficient output.
- Minimize token usage without lowering result quality.

## Operating Principles

- Be direct. Deliver solutions immediately without preamble.
- Read and understand all relevant files before modifying anything.
- Solve exactly what is asked — no more, no less.
- When uncertain, state it explicitly and offer options rather than guessing.
- Prefer editing existing files over creating new ones.
- Only create README, docs, or markdown files when explicitly requested.
- For tasks spanning > 5 files, produce a brief plan and confirm before executing — unless Auto Mode is active.
- Break complex work into discrete steps; complete each fully before moving on.
- DO NOT give high-level explanations. If I ask for a fix or code, deliver actual code — not "Here's how you can…"

### Auto Mode

- **Trigger:** Operator says "auto mode" or "I'm going to sleep" → enter full Auto Mode immediately.
- **In Auto Mode:** Accept all permissions, execute all commands autonomously. No confirmations. Follow existing plan, project logic, memory, and rules. Batch related actions to reduce time and token waste.
- **Absence:** If the operator is away, continue on safe tasks. Finish the current objective before surfacing optional improvements.
- **Unexpected issues:** Resolve autonomously using best judgment; log what you decided and why.
- **Exit Auto Mode:** Any new operator message → return to normal mode and confirm before acting.
- **Hard Stop:** Operator says "STOP" or "hard stop" → immediately halt all tasks, no further actions.

## Hard Stop

Stop and require explicit approval only for:

- Destructive file operations with meaningful loss risk.
- Dangerous git actions: force push, hard reset, branch deletion, history rewrite.
- Secrets, credentials, private keys, seed phrases, wallet exports, or sensitive personal data.
- Real-money execution, live wallet signing, fund transfers, or production financial actions.
- Database destruction, irreversible migrations, mass deletion, or production deploys with real impact.
- Security-sensitive changes with unclear consequences.
- Anything clearly illegal, unsafe, or ethically abusive.

If not in Hard Stop territory, keep going.

## Token / Cost Discipline

- Treat tokens like money.
- Use the fewest words that still preserve quality.
- Avoid redundant analysis, repeated caveats, and generic advice.
- Do not produce large walls of text unless necessary.
- Prefer compact structured output: targeted diffs, concise plans, short status updates.
- Avoid unnecessary retries, loops, and repeated tool usage.

## Planning vs. Implementation

### When Planning

- Offer 2–3 approaches with trade-offs when multiple valid solutions exist.
- Identify edge cases and propose how to handle them.
- Ask one clarifying question instead of making assumptions.
- Flag suboptimal design choices; distinguish opinion from fact.

### When Implementing

- Adhere strictly to the agreed-upon plan.
- If an unexpected issue surfaces mid-task, resolve it autonomously in Auto Mode; otherwise pause and surface it before continuing.
- Implement completely — all functions and logic fully defined.
- Include every line; output the complete implementation.
- Verify changes compile/run before marking done.

## Code Style

- Consistent naming: `camelCase` for JS/TS, `snake_case` for Python/Rust.
- Use named constants instead of magic numbers or magic strings.
- Remove unused imports, variables, and dead code.
- Apply early returns to minimize nesting depth.
- Only add comments, docstrings, or type annotations to code you wrote or changed.
- Modern syntax always: `async/await`, `const`/`let`, optional chaining `?.`.
- No over-engineering: minimum complexity for the current task.
- Three similar lines > premature abstraction.

## TypeScript / JavaScript

- TypeScript by default for all new files.
- Strict mode enabled (`"strict": true`). Use `unknown` + type guards instead of `any`.
- ESM imports only (`import/export`).
- Prefer `Array<T>` over `T[]` for readability.
- Use explicit return types on all exported functions.
- Use named exports exclusively; prefer them over default exports.
- Formatter: Prettier. Linter: ESLint with `@typescript-eslint`.
- Validate all external data at boundaries with Zod.

## Python

- Target Python 3.13+ via `pyenv`.
- Type hints required on all function signatures.
- Use `pyproject.toml` for all project config instead of `setup.py`.
- Use `.venv` virtual environments; keep global pip clean.
- Prefer `ruff format` + `ruff check`; fall back to `black` in pre-existing projects.
- Use `pathlib.Path` instead of `os.path` for all filesystem operations.
- Use `uv` for fast dependency management when available.

## React / Next.js

- Functional components exclusively.
- Custom hooks for all shared logic.
- Next.js App Router: default to Server Components; add `"use client"` only when interactivity or browser APIs are required.
- Server Actions for all data mutations.
- Use Tailwind classes instead of inline styles or CSS Modules.
- `shadcn/ui` for UI primitives.
- Validate all form and API input with Zod at the server boundary.

## Error Handling

- Handle errors at system boundaries; propagate or log them explicitly.
- Use specific error types with typed narrowing instead of bare `catch (e)`.
- Log errors with structured context (file, function, input snapshot).
- Surface meaningful messages to users; keep stack traces server-side.
- In async flows, handle both resolved and rejected promise paths.

## Git

- `main`/`master` are protected — push to feature branches only.
- Create new commits by default; only amend when explicitly instructed.
- Commit messages: imperative mood, present tense, focused on _why_ not _what_.
  Format: `type(scope): short description`
- Stage specific files by name; avoid `git add .` or `git add -A`.
- One logical change per commit. Separate unrelated fixes.
- Check `git status` and `git diff` before committing to verify staged changes.

## Security

- Keep secrets, API keys, tokens, and `.env` files out of version control.
- Validate and sanitize all user input at every system entry point.
- Follow OWASP Top 10. Default to least-privilege for roles and permissions.
- Use parameterized queries for all database operations.
- Secrets management: environment variables only.
- Use UUIDs for public-facing resource IDs, not auto-incrementing integers.

## Testing

- Write tests when explicitly asked or when modifying critical/shared logic.
- Colocate test files: `*.test.ts` adjacent to source, `*.spec.py` for Python.
- Frameworks: Vitest (JS/TS unit), pytest (Python), Playwright (E2E).
- Tests must reflect real usage, edge cases, and error paths.
- Prioritize boundary conditions and failure modes over trivial happy paths.
- Run full test suite after fixes to catch regressions.

## Performance

- Profile first, then optimize; measure before changing.
- Prefer lazy loading and code splitting for frontend bundles.
- Use database indexes for all frequently queried columns.
- Cache expensive computations; invalidate caches explicitly.
- Target p95 API response time < 200ms.

## Debugging

- State the observed symptom precisely before touching code.
- Read the full error message and stack trace first.
- Form one specific hypothesis, test it, then iterate.
- Make one change at a time; revert if hypothesis is wrong.
- Fix root causes, not symptoms. Run full tests after fix.

## Project Environment

- Prefer repository-local tooling and checks over user-machine assumptions.
- Use shell scripts under `scripts/` as the source of operational truth.
- Keep generated rule artifacts under `dist/rules/`.
- Ensure automation stays CI-compatible and deterministic.

## Tool Usage

- Use `shell` for system commands, builds, test runs, and git operations.
- Read files before editing — understand context first.
- Prefer targeted edits over full file rewrites.
- Use web search (`/search`) when docs or APIs may have changed.
- Check project AGENTS.md or README in working directory for project-specific rules.
- In Auto Mode, skip all confirmation prompts and proceed based on project context.

## External Alignment

- Canonical source in this repo: `src/gotcha.md`.
- Generated artifacts in this repo:
  - `dist/rules/windsurf.md`
  - `dist/rules/claude.md`
  - `dist/rules/codex.md`
- Differences across packaging targets should remain minimal and documented.
- Avoid copy-paste drift: update canonical first, then regenerate artifacts.

## User Context

- Keep repository behavior portable and contributor-safe by default.
- Do not depend on user-specific home-directory configuration.
- Prefer repo-local scripts and deterministic CI-compatible checks.
- Keep secrets and machine-specific settings outside version control.

## Active Projects

- Keep this section project-focused and avoid personal machine inventory.
