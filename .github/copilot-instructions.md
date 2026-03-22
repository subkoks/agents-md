# Copilot Instructions for agents-md Repository

## Repository Context

This repository is the canonical source for GOTCHA framework rules with local artifact packaging under `dist/rules`.

## Code Review Focus Areas

- Rule structure and markdown formatting consistency
- Script validation and error handling
- Cross-platform compatibility (bash scripts)
- Security best practices (no exposed secrets)
- Documentation accuracy

## Quality Standards

- All scripts must have proper error handling
- Validation scripts should provide clear diagnostic output
- Sync operations must handle dry-run mode correctly
- Follow existing code style and patterns

## Testing Requirements

- All scripts must be executable and pass syntax checks
- Validation scripts should work in CI/CD environments
- Dry-run operations must not cause failures

## Security Considerations

- No hardcoded API keys or secrets
- Validate external file paths and permissions
- Handle user input safely

## Documentation

- Update README.md when adding new capabilities
- Maintain clear commit messages with conventional format
- Document any breaking changes
