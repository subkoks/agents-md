# bootstrap/editors.md

Cursor + Windsurf install + extension restore. Drives Milestone 8 in `install-order.md`.

## What's installed by the Brewfile

- `cursor` (cask) — primary code editor
- `windsurf` (cask) — secondary code editor
- `font-meslo-lg-nerd-font` (cask) — recommended terminal + editor font
- `font-hack-nerd-font` (cask) — alternate Nerd Font

After `brew bundle`, both editors are in `/Applications/` and their CLI launchers (`code`, `windsurf`) are on PATH at `/usr/local/bin/` (Intel) or `/opt/homebrew/bin/` (Apple Silicon).

## Cursor

### First launch

1. Open `/Applications/Cursor.app`.
2. Sign in with your Cursor account.
3. **Settings → Cursor Tab** → enable.
4. **Settings → Sync** → enable settings sync if you have an account that holds them; otherwise rely on this repo's allowlist for `~/.cursor/rules/`, `~/.cursor/skills/`, `~/.cursor/agents/`, `~/.cursor/hooks.json`.
5. **Settings → Theme/Font** → set Nerd Font ("MesloLGS NF" recommended). The statusline and gutter glyphs depend on this.

### CLI launcher verification

```bash
which code                        # /usr/local/bin/code (Intel) or /opt/homebrew/bin/code (ARM)
file "$(which code)"              # symlink into Cursor.app
code --version                    # Cursor's `code` rebrand version
```

If `code` is missing: open Cursor → Cmd+Shift+P → "Shell Command: Install 'code' command in PATH".

### Extension restore

Snapshot of extensions from the current machine (22 extensions):

```text
anthropic.claude-code@2.1.128
anysphere.cursorpyright@1.0.10
anysphere.remote-ssh@1.0.48
bradlc.vscode-tailwindcss@0.14.28
christian-kohler.npm-intellisense@1.4.5
christian-kohler.path-intellisense@2.8.0
davidanson.vscode-markdownlint@0.61.2
dbaeumer.vscode-eslint@3.0.24
eamodio.gitlens@17.12.2
esbenp.prettier-vscode@12.4.0
formulahendry.auto-rename-tag@0.1.10
github.vscode-github-actions@0.31.5
github.vscode-pull-request-github@0.120.2
mikestead.dotenv@1.0.1
ms-playwright.playwright@1.1.19
ms-python.debugpy@2026.6.0
ms-python.python@2025.6.1
pkief.material-icon-theme@5.34.0
prisma.prisma@31.10.0
yoavbls.pretty-ts-errors@0.8.7
zhuangtongfa.material-theme@3.19.0
```

Restore in one shot (versions allowed to drift to latest unless pinned):

```bash
for ext in \
  anthropic.claude-code \
  anysphere.cursorpyright \
  anysphere.remote-ssh \
  bradlc.vscode-tailwindcss \
  christian-kohler.npm-intellisense \
  christian-kohler.path-intellisense \
  davidanson.vscode-markdownlint \
  dbaeumer.vscode-eslint \
  eamodio.gitlens \
  esbenp.prettier-vscode \
  formulahendry.auto-rename-tag \
  github.vscode-github-actions \
  github.vscode-pull-request-github \
  mikestead.dotenv \
  ms-playwright.playwright \
  ms-python.debugpy \
  ms-python.python \
  pkief.material-icon-theme \
  prisma.prisma \
  yoavbls.pretty-ts-errors \
  zhuangtongfa.material-theme; do
  code --install-extension "$ext" --force
done
```

### Verify

```bash
code --list-extensions | wc -l               # 22 (or whatever you trimmed to)
code --list-extensions --show-versions | sort > /tmp/cursor-ext-new.txt
diff /tmp/cursor-ext-new.txt <(sort <<<"$(grep -E '^[a-z0-9].*@' bootstrap/editors.md | head -22)") || true
```

## Windsurf

### First launch

1. Open `/Applications/Windsurf.app`.
2. Sign in with your Codeium / Windsurf account.
3. **Settings → Font** → "MesloLGS NF" or "Hack Nerd Font Mono".
4. **Settings → Memories / Rules** → confirm `~/.codeium/windsurf/memories/global_rules.md` is loaded after Milestone 11 restores it.

### CLI launcher verification

```bash
which windsurf                    # /usr/local/bin/windsurf or /opt/homebrew/bin/windsurf
windsurf --version
```

### Extension restore

Snapshot from the current machine (28 extensions, includes Java pack):

```text
anthropic.claude-code@2.1.89
bradlc.vscode-tailwindcss@0.14.28
christian-kohler.npm-intellisense@1.4.5
christian-kohler.path-intellisense@2.8.0
codeium.windsurfpyright@1.29.5
davidanson.vscode-markdownlint@0.61.2
dbaeumer.vscode-eslint@3.0.24
eamodio.gitlens@17.12.2
esbenp.prettier-vscode@12.4.0
formulahendry.auto-rename-tag@0.1.10
github.vscode-github-actions@0.31.5
github.vscode-pull-request-github@0.140.0
mikestead.dotenv@1.0.1
ms-playwright.playwright@1.1.19
ms-python.debugpy@2026.6.0
ms-python.python@2026.4.0
openai.chatgpt@26.5422.30944
pkief.material-icon-theme@5.34.0
prisma.prisma@31.10.0
redhat.java@1.54.0
vscjava.vscode-gradle@3.17.3
vscjava.vscode-java-debug@0.59.0
vscjava.vscode-java-dependency@0.27.2
vscjava.vscode-java-pack@0.30.5
vscjava.vscode-java-test@0.45.0
vscjava.vscode-maven@0.45.3
```

Restore in one shot — **but skip the Java pack unless Q-pentest tier is on or a JVM project is active**:

```bash
WINDSURF_CORE=(
  anthropic.claude-code
  bradlc.vscode-tailwindcss
  christian-kohler.npm-intellisense
  christian-kohler.path-intellisense
  codeium.windsurfpyright
  davidanson.vscode-markdownlint
  dbaeumer.vscode-eslint
  eamodio.gitlens
  esbenp.prettier-vscode
  formulahendry.auto-rename-tag
  github.vscode-github-actions
  github.vscode-pull-request-github
  mikestead.dotenv
  ms-playwright.playwright
  ms-python.debugpy
  ms-python.python
  openai.chatgpt
  pkief.material-icon-theme
  prisma.prisma
)

# Java pack — opt-in only:
WINDSURF_JAVA=(
  redhat.java
  vscjava.vscode-gradle
  vscjava.vscode-java-debug
  vscjava.vscode-java-dependency
  vscjava.vscode-java-pack
  vscjava.vscode-java-test
  vscjava.vscode-maven
)

for ext in "${WINDSURF_CORE[@]}"; do
  windsurf --install-extension "$ext" --force
done

# Uncomment if you do JVM work:
# for ext in "${WINDSURF_JAVA[@]}"; do
#   windsurf --install-extension "$ext" --force
# done
```

### Verify

```bash
windsurf --list-extensions | wc -l           # ≥ 19 (core) or 26 (with Java)
```

## Settings, rules, hooks (the editor-config layer)

The Brewfile gets you the binaries. Editor *config* (rules, skills, agents, hooks) restores during **Milestone 11** via the dotfiles allowlist. See `bootstrap/ai_tooling.md` for the per-root migrate/regenerate detail.

Quick reference of what each editor reads:

| Editor | Path | Notes |
|---|---|---|
| Cursor | `~/.cursor/rules/`, `~/.cursor/skills/`, `~/.cursor/agents/`, `~/.cursor/hooks.json`, `~/.cursor/cli-config.json` | canonical AI tree |
| Windsurf | `~/.windsurf/rules/`, `~/.windsurf/skills/`, `~/.windsurf/workflows/`, `~/.windsurf/settings.json`, `~/.codeium/windsurf/memories/` | rules + memories layered |
| Both | `~/AGENTS.md` | global truth, imported by both |

## Pitfalls

1. **CLI launcher missing.** If `code` or `windsurf` isn't on PATH after install, the cask auto-symlink failed — re-run "Install 'code' command in PATH" from the editor's command palette.
2. **Two `code` binaries.** If VS Code stock is also installed, its `code` will collide with Cursor's. Per `DECISIONS.md`, VS Code stock is **not** in the Brewfile. If you see two, uninstall stock VS Code.
3. **Extensions installed but not loaded.** Quit and reopen the editor. Some extensions (eslint, prettier) need a workspace open to activate.
4. **Settings sync over-writing dotfiles.** Cursor/Windsurf's cloud sync can clobber `settings.json` on first launch. Disable sync first run, restore from dotfiles, then re-enable sync if desired.
5. **Migrating `~/.cursor/extensions/` directory.** Don't — it's a VSIX cache. Reinstall via the loop above; gives you up-to-date extensions on the new arch.
