---
name: electron-desktop-apps
description: Use when building Electron desktop apps with secure IPC, React UI, and packaging for macOS/Windows/Linux.
---

# Electron Desktop Apps

## When to Use

- Cross-platform desktop tools with web UI
- Native file/system access from a React renderer
- Auto-update and code signing workflows

## Implementation Workflow

1. Scaffold: Electron Forge or builder + React + TypeScript + Tailwind.
2. Main process: file I/O, native APIs; renderer: UI only.
3. Expose APIs via `contextBridge` in preload; `ipcMain.handle` / `invoke`.
4. Enforce `contextIsolation: true`, `nodeIntegration: false`.
5. Package, sign (macOS), and test auto-update in staging.

## Hard Rules

- Never `webSecurity: false` or `nodeIntegration: true` in renderer.
- Validate all IPC payloads in main process.
- No `sendSync`; use async invoke.
- Single-instance lock where appropriate.

## Done Criteria

- Security checklist passed (isolation, preload surface minimal).
- Build produces signed/notarized artifact for target OS (when shipping).
- IPC contract typed and documented.

## Related Skills

- `typescript-node-backend.md`
- `debugging-protocol.md`
