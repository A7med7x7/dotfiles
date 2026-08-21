# dotfiles — My macOS Dev Setup

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

## Manual Walkthrough

If you would prefer to go step by step (or just want the commands handy), here's the
same setup done by hand.

### Step 1: Install package managers

#### Homebrew

The macOS package manager that makes everything else easy:

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

What that pulls for you:

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

## Manual Steps After Install

- Set your git email (the `.gitconfig` ships a placeholder):

  ```bash
  git config --global user.email "you@example.com"
  ```

- Restart your shell to pick up the new config:

  ```bash
  exec zsh
  ```

## Make Targets

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
| `make git` | Symlinks git config + sets global excludesfile |
| `make dotfiles` | Symlinks `.zshrc`, `tmux.conf`, `.sqliterc`, `.pythonrc`, `.pdbrc` |
| `make update` | `brew update && brew upgrade && brew bundle` |
| `make clean` | Removes broken symlinks from home directory |

## Adding New Packages

- **Homebrew:** add a `brew "name"` line to `brew/Brewfile`, then `make brew`.
- **Python:** add the package to `pip/requirements.txt`, then `make pip`.
- **npm:** add the package name to `npm/packages.txt`, then `make npm`.