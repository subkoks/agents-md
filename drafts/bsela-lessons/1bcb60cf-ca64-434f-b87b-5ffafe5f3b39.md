# Lesson 1bcb60cf-ca64-434f-b87b-5ffafe5f3b39

**Rule**: Maintain a dedicated overlay file (e.g., `ProjectAgentRules.md`) for project‑specific agent rules so that global rules remain untouched and easily reviewable.

**Why**: The transcript references a project‑specific rules file (`# BSELA — Project Agent Rules`) that overlays global rules, yet this separation was not enforced consistently. Keeping a dedicated overlay prevents accidental deviations from global policies.

**How to apply**: Create and document a `ProjectAgentRules.md` (or similar) file that imports or references the global `AGENTS.md`. Ensure all project‑specific rules are added there and that PRs referencing them must update this file.

**Scope**: `project`

**Confidence**: 0.74

**Source error**: `9e2724b0-7099-47da-9d82-6a417ebfe54d`

**Created at**: 2026-04-28T19:57:40.818406
