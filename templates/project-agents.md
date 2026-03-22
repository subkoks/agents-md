# Project AGENTS.md Template

Copy this file to your project root as `AGENTS.md` for project-specific rules.

---

## Project Rules — [PROJECT_NAME]

> This file is an additive override layer.
> Do not copy global `gotcha.md` body here.
> Precedence: project overrides > canonical/artifact rules > tool defaults.

## Project Overview

Brief description of what this project does.

## Tech Stack

- Language: [e.g., TypeScript, Python, Rust]
- Framework: [e.g., Next.js, FastAPI, Anchor]
- Database: [e.g., PostgreSQL, SQLite, Supabase]
- Package Manager: [e.g., pnpm, uv, cargo]

## Project-Specific Rules

### Architecture

- [Rule about project structure]
- [Rule about module organization]
- [Rule about data flow]

### Naming Conventions

- Files: [e.g., kebab-case.ts]
- Components: [e.g., PascalCase]
- Functions: [e.g., camelCase]
- Constants: [e.g., SCREAMING_SNAKE_CASE]

### Code Patterns

- [Pattern 1]
- [Pattern 2]
- [Pattern 3]

### Testing

- Test framework: [e.g., Vitest, pytest]
- Coverage requirement: [e.g., 80%]
- Test location: [e.g., adjacent to source]

### Git Workflow

- Branch naming: [e.g., feature/description, fix/description]
- Commit format: [e.g., conventional commits]
- PR requirements: [e.g., tests pass, review required]

## Commands

```bash
# Install dependencies
[install command]

# Run development server
[dev command]

# Run tests
[test command]

# Build for production
[build command]

# Lint/format
[lint command]
```

## Environment Variables

| Variable   | Description  | Required |
| ---------- | ------------ | -------- |
| `VAR_NAME` | What it does | Yes/No   |

## Known Issues / Gotchas

- [Issue 1 and workaround]
- [Issue 2 and workaround]

## Integration Points

- [External service 1]
- [External service 2]

## Deployment

- Platform: [e.g., Vercel, Railway, Docker]
- CI/CD: [e.g., GitHub Actions workflow]

---

## Note

This file supplements the global `gotcha.md` rules. Keep only project-specific constraints, commands, and conventions.
