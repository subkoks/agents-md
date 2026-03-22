# Hook Reference

Curated reference for portable hook patterns tracked in this repository.

## Active High-Value Hooks

### Dispatcher Hook

- **Source:** `docs/hook-portability-spec.md`
- **Role:** single registered entrypoint that dynamically loads enabled hooks
- **Pattern:** run every executable shell script in `hooks/enabled/` in alphabetical order and stop on first output

#### Why It Is Good

- no restart needed when hook set changes
- easy enable/disable through symlink or file move
- keeps the registration surface tiny

### Test-Gate Hook

- **Source:** `docs/hook-portability-spec.md`
- **Role:** quality gate before commit and after edits

#### Behavior

- deny `git commit` if tests fail
- skip cleanly when there is no supported test runner
- run async validation after file changes for source files
- support both Node and Python projects

#### Dependencies

- `jq`
- `git`
- `npm` for Node test scripts
- `pytest` or `.venv/bin/pytest` for Python

#### Portability Notes

- the logic is useful outside Claude too
- the exact hook event schema is editor-specific
- convert this into an editor-agnostic spec before reusing broadly

#### Useful Hook Inputs

- `project_dir` — current project directory
- `file_paths` — files being modified
- `tool_input` — tool parameters in JSON form

#### Structured Response Pattern

- hooks can return structured JSON for richer control
- useful fields include `continue`, `feedback`, and `modify_prompt`
- this is a strong pattern for future editor-agnostic hook contracts

### Checkpoint Hook

- **Source:** `docs/hook-portability-spec.md`
- **Role:** save, list, and resume checkpoints

#### Commands

- `$cc <name>`
- `$cc-list`
- `$cc-resume <name>`

#### Why Checkpoints Matter

- makes long tasks resumable
- provides an operational answer to context loss
- pairs well with `_progress.md` or compact project logs

## Recommended Future Standard

### Hook Categories

- **routing hooks**
- **quality hooks**
- **recovery hooks**
- **audit hooks**

### Hook Rules

- each hook must have one job
- each hook must degrade safely
- each hook must cap output size
- each hook must document external dependencies
- each hook must say whether it blocks, annotates, or routes

### Suggested Project Follow-Up

- preserve these patterns in `agents-md`
- document hook portability boundaries clearly
- define a generic hook contract for future editor integrations
