# Lesson 1abfec2c-36ef-45be-be21-6c49ccaf02e1

**Rule**: Ensure all invoked make targets exist before running make commands.

**Why**: The session terminated with `make: *** No rule to make target 'check'.  Stop.` (evidence line 334), indicating the Makefile lacked the expected `check` target before invocation.

**How to apply**: When a Makefile is executed (e.g., CI pipeline, pre‑commit hooks, or developer workflows), validate that every referenced target is defined and that the Makefile syntax is correct. Add missing targets or adjust the command to match existing ones.

**Scope**: `project`

**Confidence**: 0.68

**Source error**: `4d097072-26ae-4001-9f3c-233decad661e`

**Created at**: 2026-04-28T17:36:21.058483
