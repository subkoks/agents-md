# bootstrap/python_toolchain.md

Python policy on the new machine. Drives Milestone 6 in `install-order.md`.

## Policy summary

| Concern | Choice | Why |
|---|---|---|
| Version manager | **pyenv** (Brewfile) | Already in setup; per-project `.python-version` |
| Default Python | **3.13** (latest stable) | Per `~/AGENTS.md` user setup |
| Per-project envs | **`.venv`** in repo root | Per `~/AGENTS.md`; never installs into system Python |
| Project deps installer | **uv** (Brewfile) | Fast resolver; replaces `pip install` for projects |
| Isolated CLI apps | **pipx** (Brewfile) | Each CLI in its own venv |
| Linter / formatter | **ruff** (Brewfile) | Replaces `black` + `flake8` + `isort` |
| Test runner | **pytest** (per-project devDep) | Per `~/AGENTS.md` testing rules |
| Poetry | **not preinstalled** | KEEP_LATER; install on demand if a project requires |
| Conda | **not used** | DROP per classification; replaced by pyenv + uv |

## Install steps

```bash
# 1. pyenv installed by Brewfile. Configure shell init.
cat <<'ZSH' >> ~/.zshrc
# === pyenv ===
export PYENV_ROOT="$HOME/.pyenv"
[[ -d "$PYENV_ROOT/bin" ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
ZSH

exec zsh -l

# 2. Install Python 3.13 (replace x with latest patch).
pyenv install 3.13                 # uses CPython, builds locally
pyenv global 3.13

# (optional, if a project demands)
# pyenv install 3.12
# pyenv install 3.11

# 3. uv — Brewfile-installed. Verify.
uv --version

# 4. pipx — Brewfile-installed. Ensure path.
pipx ensurepath
exec zsh -l

# 5. ruff — Brewfile-installed; add to per-project devDeps too.
ruff --version
```

## Verification

```bash
python --version                  # Python 3.13.x
which python                      # ~/.pyenv/shims/python
python3 --version                 # same
pyenv versions                    # 3.13.x marked as global with *
uv --version
pipx --version
ruff --version
```

## Project bootstrap pattern

```bash
mkdir my-project && cd $_
echo "3.13" > .python-version              # pyenv auto-switch
pyenv local 3.13
uv init                                    # creates pyproject.toml
uv venv                                    # creates .venv
source .venv/bin/activate
uv add ruff pytest                         # devDeps
uv add httpx                               # runtime example
echo ".venv/\n__pycache__/\n.ruff_cache/\n.pytest_cache/\n.env*\n" >> .gitignore
```

## Isolated CLI apps via pipx

For Python CLI tools you want globally available without polluting projects:

```bash
pipx install <tool>          # e.g. pipx install poetry, pipx install httpie, pipx install yt-dlp
pipx list
pipx upgrade-all
```

## Common pitfalls

1. **System Python vs pyenv.** macOS ships `/usr/bin/python3` (currently 3.9-ish). Never install packages into it (`pip install --user` is also a trap). Always go through pyenv.
2. **`brew install python@3.13`.** The Brewfile **does not** install brew-Python because pyenv owns Python. If you ever do install it, brew's binary wins on PATH and breaks `.python-version` switching.
3. **Global pip installs.** Don't. Use `uv` per project, or `pipx` for CLI tools.
4. **`uv` vs `pip`.** Inside a `uv`-managed project, use `uv add` / `uv sync`. Falling back to `pip install` mid-project bypasses the lockfile.
5. **Migrating `~/.cache/pip`.** Don't. It's regenerated and just bloats the new disk.
6. **Mixing `requirements.txt` and `pyproject.toml`.** Pick one per project. New projects: `pyproject.toml` + `uv`.

## Migrating Python projects from the current machine

For each Python project in `~/Projects/Current/Active/`:

1. Clone the repo on the new machine (Milestone 10).
2. `cd <repo>`
3. Run `pyenv install $(cat .python-version)` if a non-default Python is needed.
4. `uv sync` (if `uv.lock` exists) or recreate via `uv venv && uv pip install -e .`.
5. Verify with the project's own test command.

Do **not** copy `.venv/` directories from the old machine — they're path-pinned and arch-pinned.
