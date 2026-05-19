# bootstrap/node_toolchain.md

Node + JS package manager policy on the new machine. Drives Milestone 6 in `install-order.md`.

## Policy summary

| Concern | Choice | Why |
|---|---|---|
| Version manager | **nvm** (installed by Brewfile) | Aligns with current setup; per-project `.nvmrc` works |
| Default Node | **22 LTS** | Per `~/AGENTS.md` user setup |
| Package manager (preferred) | **pnpm** via brew | Per `~/AGENTS.md`; faster, deterministic, content-addressable |
| Package manager (fallback) | **npm** (ships with Node) | Used for global CLIs that ship as npm packages |
| Yarn | **not preinstalled** | KEEP_LATER in classification; install only if a project pins it |
| Bun | **not preinstalled** | Not in keep-now; install on demand if a project requires |
| Globals policy | **regenerate** | `~/.npm`, `~/.pnpm` are not migrated; reinstall on demand |

## Install steps

```bash
# 1. nvm is provided by Brewfile (`brew "nvm"`). Configure shell init.
mkdir -p ~/.nvm
cat <<'ZSH' >> ~/.zshrc
# === nvm ===
export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && . "$(brew --prefix)/opt/nvm/nvm.sh"
[ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && . "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm"
ZSH

exec zsh -l        # reload shell

# 2. Install Node 22 LTS and pin as default.
nvm install --lts        # currently 22.x
nvm alias default 22

# 3. pnpm — already installed by Brewfile. Verify and configure.
command pnpm setup       # creates PNPM_HOME, adds to PATH
exec zsh -l
command pnpm config set store-dir "$HOME/.pnpm-store"

# 4. corepack (optional; manages packageManager field in package.json)
corepack enable
```

## Verification

```bash
node --version                 # v22.x.x
which node                     # ~/.nvm/versions/node/v22.x/bin/node — NOT /opt/homebrew/bin/node
npm --version                  # ships with Node 22
command pnpm --version         # 9.x or later
echo "$PNPM_HOME"              # set
ls "$PNPM_HOME" 2>/dev/null    # exists
```

## Globals policy detail

**Do NOT preinstall globals.** Re-install per-project as workflows surface them. Track recurring ones below for documentation only.

### Currently in active rotation (per inventory):

- `@anthropic-ai/claude-code` — install via `npm i -g @anthropic-ai/claude-code` during Milestone 11 (AI tooling)
- `@continuedev/cli` — KEEP_LATER, install on demand
- `firecrawl-cli` — KEEP_LATER
- `iterm-mcp` — install if iTerm2 + MCP integration is in active use
- `repomix` — KEEP_LATER
- `opencode-ai` — KEEP_LATER
- `@withone/cli` — KEEP_LATER
- `pnpm` — already brew-installed, do not also install globally via npm

To re-install a recurring global:

```bash
npm install -g <package-name>
```

To audit what's globally installed (after some accumulate):

```bash
npm list -g --depth=0
command pnpm list -g --depth=0
```

## Common pitfalls

1. **Two `node` on PATH.** The Brewfile does **not** install `brew "node"` precisely to avoid this. If you ever see `which -a node` show two entries, the brew one wins early on PATH and breaks per-project `.nvmrc` switching. Fix: `brew uninstall --ignore-dependencies node`.
2. **`pnpm` shell wrapper recursion.** Per `~/AGENTS.md`: use `command pnpm` inside scripts to bypass any zsh wrapper aliases.
3. **`corepack` overriding pnpm.** If a project has `packageManager: pnpm@x` in `package.json`, corepack will install that exact version per project. Usually fine, but if you see two pnpm versions, that's why.
4. **Migrating `~/.npm` from old machine.** Don't. It pins old binaries to old Node versions and breaks after `nvm install`.
5. **Global TypeScript / eslint installs.** Resist the urge — pin per-project in `devDependencies` and use `npx tsc` / `pnpm tsc`. Avoids version skew across repos.

## Project bootstrap pattern

For a new TS/JS project:

```bash
mkdir my-project && cd $_
echo "22" > .nvmrc                          # auto-switch via nvm use
nvm use
command pnpm init
command pnpm add -D typescript @types/node tsx
command pnpm add -D vitest                  # tests per ~/AGENTS.md
command pnpm add -D eslint @typescript-eslint/eslint-plugin prettier
git init
echo "node_modules/\ndist/\n.env*\n" >> .gitignore
```
