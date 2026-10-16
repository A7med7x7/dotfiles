# dotfiles: my macOS dev setup

One-command macOS dev environment setup (all the brews and pips I actually use).

## Why this exists

I've been a MacBook user since I was fifteen, and I keep jumping between
machines every now and then, one malfunctioned, I dropped water on another,
and so on. Every time, there's the same friction of reinstalling my software,
rebuilding my coding environment, hunting down the commands I always forget.
Going through that process is hectic.

This started as a draft I wrote in 2024 and have kept in my notes ever since.
Its purpose is: give me a checklist of what to set up and an easy way
to retrieve the commands to run on a fresh machine. decided to make this public, It's the bare minimum for
someone into coding and machine learning (plus the occasional not-so-normal
usage), enough to quickly restore the dependencies and tools I work with
day to day.

That checklist has now grown into the one-command setup in this repo. The
automated path is below; the manual walkthrough, it stays as a
reference for when I want to do things by hand or cherry-pick a specific step.

> [!NOTE]
> You might want to double-check whether any of the software needs an update,
> but overall this page is maintained because I actively use it. For now it's
> a way to shortlist everything in one place, and a script to run it all.

## Start

On a fresh Mac, 

```bash
curl -fsSL https://raw.githubusercontent.com/A7med7x7/dotfiles/main/install.sh | bash
```

It installs the Xcode Command Line Tools, clones this repo to `~/dotfiles`,
and runs `make all` to set everything up.

## Manual walkthrough

If you would prefer to go step by step (or just want the commands handy), here's the
same setup done by hand.

### Step 1: Install package managers

#### Homebrew

The macOS package manager:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

On Apple Silicon, Homebrew lives in `/opt/homebrew`; on Intel, in
`/usr/local`. Load it into your current shell:

```bash
# Apple Silicon
eval "$(/opt/homebrew/bin/brew shellenv)"
# Intel
eval "$(/usr/local/bin/brew shellenv)"
```

#### uv

[uv](https://github.com/astral-sh/uv), sometimes I use it instead of plain `pip` :

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### Step 2: Install the brews

All declared in [`brew/Brewfile`](brew/Brewfile), so one command installs the
lot:

```bash
brew bundle --file=brew/Brewfile
```

What that installs:

| Brew | Purpose |
| --- | --- |
| `python` | Python interpreter |
| `node` | JavaScript runtime + npm |
| `pipx` | Isolated installs of Python CLI apps |
| `hugo` | Static site generator |
| `wget` / `curl` | File downloads |
| `nload` | Live network traffic monitor |
| `nvtop` | GPU usage monitor |
| `vim` | Terminal editor |
| `tmux` | Terminal multiplexer |
| `git` | Version control |
| `git-lfs` | Git extension for versioning large files |

### Step 3: Install the Python packages

Managed with uv, listed in
[`pip/requirements.txt`](pip/requirements.txt):

```bash
uv pip install -r pip/requirements.txt
```

| Package | Purpose |
| --- | --- |
| `dvc` | Data version control for ML projects |

Add ML packages here as I need them (`torch`, `scikit-learn`, etc.).

### Step 4: Install the global npm packages

Listed one per line in [`npm/packages.txt`](npm/packages.txt):

```bash
npm install -g badge-maker
```

### Step 5: Shell, git, tmux, Python, and SQLite config

Oh My Zsh for the shell framework:

```bash
RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
```

Then symlink the configs into place (this is what `make git` and
`make dotfiles` do):

```bash
ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
ln -sf ~/dotfiles/config/tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/config/.sqliterc ~/.sqliterc
ln -sf ~/dotfiles/config/.pythonrc ~/.pythonrc
ln -sf ~/dotfiles/config/.pdbrc ~/.pdbrc
ln -sf ~/dotfiles/git/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/git/.gitignore_global ~/.gitignore_global
```

### Step 6: Claude Code

My CLI agent of choice:

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

## Manual steps after install

- Set your git email (the `.gitconfig` ships a placeholder):

  ```bash
  git config --global user.email "you@example.com"
  ```

- Restart your shell to pick up the new config:

  ```bash
  exec zsh
  ```

## Personal preferences

Everything in this repo is set up the way I work. If you fork it, go through this list before running `make all`.

Git (`git/.gitconfig`, `git/.gitignore_global`):

- The name is "Ahmed" and the email is blank. Put your own in.
- vim is the editor, `pull.rebase` is off and new repos start on `main`.
- Aliases: `st`, `lg` (graph log) and `undo` (soft reset of the last commit).
- The global ignore file covers macOS junk, Python caches and virtualenvs, editor folders, `.env` and `.python-version`.

Shell (`zsh/.zshrc`):

- Oh My Zsh with the `robbyrussell` theme and the `git` plugin.
- Aliases: `ll`, `gs`, `gc`, `gp` and `dotfiles` (cd into this repo).

Terminal tools (`config/`):

- tmux uses `Ctrl+a` as the prefix, has the mouse on, uses vi keys in copy mode, numbers windows from 1 and keeps 10000 lines of history.
- sqlite shows headers, prints results as box tables and shows NULL explicitly.
- The Python REPL gets tab completion, history and a few auto-imports. pdb gets one-letter aliases (`c`, `n`, `s`, `l`, `r`, `u`, `d`) and `pp`.

Packages (`brew/Brewfile`, `pip/requirements.txt`, `npm/packages.txt`):

- These reflect my work: hugo, nvtop and nload from brew, dvc from pip, badge-maker from npm. Trim or replace them.

Claude Code (`claude/`, `skills/list.txt`):

- `claude/settings.json` turns off the Co-Authored-By trailer on commits and the generated-with footer on pull requests.
- `claude/CLAUDE.global.md` becomes your `~/.claude/CLAUDE.md`. Mine says to work directly on `main`, commit after every change in small commits, never push unless asked, write commit messages by the [seven rules](https://cbea.ms/git-commit), run them through the humanizer plugin and leave out any attribution lines. It also asks for GitHub alerts (`> [!NOTE]`) in READMEs, GitHub Actions for whatever checks a repo needs, a CI badge at the top of the README once the workflow passes, and a one-sentence description on every repo. Rewrite it for your own habits. An existing different `~/.claude/CLAUDE.md` is kept as `CLAUDE.md.bak`.
- `claude/plugins.txt` installs the humanizer plugin, which that file refers to. Drop the plugin if you drop the rule.
- `skills/list.txt` installs five skills I use: teach, grill-me, grill-with-docs, frontend-design and agent-browser.
- `make antigravity` installs Google's Antigravity CLI. Remove the target from `make all` if you don't want it.

## Make targets

If you cloned the repo, every step above also has a make target:

| Target | What it does |
| --- | --- |
| `make all` | Runs every target in order |
| `make xcode` | Installs Xcode Command Line Tools if missing |
| `make brew` | Installs Homebrew if missing, then runs `brew bundle` |
| `make uv` | Installs uv (Astral's Python package manager) |
| `make pip` | Installs `pip/requirements.txt` via `uv pip install` |
| `make npm` | Installs global npm packages from `npm/packages.txt` |
| `make ohmyzsh` | Installs Oh My Zsh (non-interactive) |
| `make agents` | Installs the Claude Code CLI |
| `make claude-settings` | Disables Claude's commit/PR attribution trailer in `~/.claude/settings.json` |
| `make claude-md` | Symlinks `claude/CLAUDE.global.md` to `~/.claude/CLAUDE.md` (an existing different file is kept as `CLAUDE.md.bak`) |
| `make plugins` | Installs the Claude Code plugins listed in `claude/plugins.txt` (humanizer) |
| `make antigravity` | Installs the Google Antigravity CLI |
| `make skills` | Installs Claude Code skills listed in `skills/list.txt` (non-interactive) |
| `make git` | Symlinks git config + sets global excludesfile, registers git-lfs |
| `make dotfiles` | Symlinks `.zshrc`, `tmux.conf`, `.sqliterc`, `.pythonrc`, `.pdbrc` |
| `make update` | `brew update && brew upgrade && brew bundle` |
| `make clean` | Removes broken symlinks from home directory |

## Adding new packages

- Homebrew: add a `brew "name"` line to `brew/Brewfile`, then `make brew`.
- Python: add the package to `pip/requirements.txt`, then `make pip`.
- npm: add the package name to `npm/packages.txt`, then `make npm`.
- Claude Code skills: add a `<repo-url> <skill-name>` line to `skills/list.txt`, then `make skills`.
- Claude Code plugins: add a `<plugin-name> <marketplace-source>` line to `claude/plugins.txt`, then `make plugins`.