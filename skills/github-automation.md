---
name: github-automation
description: Use when automating GitHub with gh CLI, Actions, branch protection, releases, and PR/issue workflows.
---

# GitHub Automation

## When to Use

- CI/CD workflows, reusable Actions
- Bulk repo hygiene (branch protection, topics, Dependabot)
- PR creation, review loops, release tagging
- Org audits (permissions, secrets metadata — not values)

## Implementation Workflow

1. `gh auth status`; prefer `gh` over raw curl for GitHub tasks.
2. Search before create (issues, PRs) to avoid duplicates.
3. Feature branch → PR → checks green → merge (no direct push to default branch).
4. Use HEREDOC for PR bodies; conventional commits.
5. For Actions: pin action SHAs or versions; least-privilege `permissions`.

## Hard Rules

- Never print or commit tokens, `GITHUB_TOKEN` dumps, or PATs.
- No force-push to `main`/`master` without explicit approval.
- Destructive org/repo changes require human confirmation.
- Stage files by name; avoid `git add .`.

## Done Criteria

- Workflow runs on PR; required checks documented.
- PR URL and test plan provided for feature work.
- Secrets referenced by name only in docs and workflows.

## Related Skills

- `mcp-tools-and-servers.md`
- `cursor-agent-workflow.md`
