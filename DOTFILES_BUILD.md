# Build My Dotfiles Repo — Claude Code Instructions

## Context

This is a personal macOS developer environment setup repo for a CS student / ML engineer.
The goal: run **one command** on a fresh MacBook and have the entire dev environment restored.

Target machine: **macOS (Apple Silicon + Intel compatible)**
GitHub handle: `A7med7x7`
Repo name: `dotfiles`

---

## Repo Structure to Create

```
dotfiles/
├── install.sh              # Entry point — the one curl | bash command
├── Makefile                # Modular targets: make all, make brew, make pip, etc.
├── brew/
│   └── Brewfile            # Declarative brew installs (idempotent via brew bundle)
├── pip/
│   └── requirements.txt    # Python packages
├── npm/
│   └── packages.txt        # Global npm packages (one per line)
├── zsh/
│   └── .zshrc              # Zsh config with Oh My Zsh setup
├── git/
│   └── .gitconfig          # Global git config
│   └── .gitignore_global   # Global gitignore
├── config/
│   └── tmux.conf           # Tmux config
└── README.md               # Usage instructions
```

---

## File Specifications

### `install.sh`

This is the **single entry point**. Someone on a fresh Mac runs:

```bash
curl -fsSL https://raw.githubusercontent.com/A7med7x7/dotfiles/main/install.sh | bash
```

It should:
1. Check if Xcode Command Line Tools are installed, install if not
2. Clone the repo to `~/dotfiles` (skip if already exists)
3. Run `make all` from within the repo
4. Print a friendly completion message

Requirements:
- Use `set -e` so it exits on any error
- Color-coded output: green for success steps, yellow for info, red for errors
- Each step should be clearly labeled with an emoji prefix (→, ✓, ✗)

---

### `Makefile`

Targets:

| Target | What it does |
|--------|-------------|
| `make all` | Runs all targets in order: xcode → brew → uv → pip → npm → ohmyzsh → agents → git → dotfiles |
| `make xcode` | Installs Xcode Command Line Tools if missing |
| `make brew` | Installs Homebrew if missing, then runs `brew bundle` |
| `make uv` | Installs uv (Astral's Python package manager) |
| `make pip` | Installs packages from `pip/requirements.txt` using `uv pip install` |
| `make npm` | Installs global npm packages from `npm/packages.txt` |
| `make ohmyzsh` | Installs Oh My Zsh if not already installed (non-interactive) |
| `make agents` | Installs Claude Code CLI |
| `make git` | Symlinks `.gitconfig` and `.gitignore_global`, sets global excludesfile |
| `make dotfiles` | Symlinks `.zshrc` and `tmux.conf` to home directory |
| `make update` | Runs `brew update && brew upgrade && brew bundle` |
| `make clean` | Removes broken symlinks from home directory |

Requirements:
- Every target must be **idempotent** — safe to run multiple times
- Use `@` prefix on commands to suppress echoing
- Use `$(shell which X)` to check if tools exist before installing
- Print what each step is doing with emoji-prefixed messages

---

### `brew/Brewfile`

Include exactly these packages:

```
# Core
brew "python"
brew "wget"
brew "pipx"
brew "hugo"
brew "node"
brew "nload"
brew "nvtop"
brew "vim"
brew "tmux"
brew "git"
brew "curl"

# uv is installed separately via its own installer (not brew)
```

No casks needed unless naturally obvious for a dev setup.

---

### `pip/requirements.txt`

```
dvc
```

Note in a comment at the top:
```
# Managed via uv — run: uv pip install -r requirements.txt
# Add ML packages here as needed (torch, sklearn, etc.)
```

---

### `npm/packages.txt`

```
badge-maker
```

One package per line. Comment at top explaining the install loop used in the Makefile.

---

### `zsh/.zshrc`

A clean `.zshrc` that:
- Sources Oh My Zsh
- Sets `ZSH_THEME="robbyrussell"` (default, easy to change)
- Adds Homebrew to PATH for both Apple Silicon (`/opt/homebrew/bin`) and Intel (`/usr/local/bin`) — detect at runtime
- Adds `~/.local/bin` to PATH (for uv-installed tools)
- Has a clearly marked section `# === Custom Aliases ===` with a few useful ones:
  - `alias ll='ls -la'`
  - `alias gs='git status'`
  - `alias gc='git commit'`
  - `alias gp='git push'`
  - `alias dotfiles='cd ~/dotfiles'`
- Has a clearly marked section `# === Machine Learning ===` (empty, for future use)
- Leaves a comment: `# Add project-specific env vars below this line`

---

### `git/.gitconfig`

```ini
[user]
    name = Ahmed
    email = # placeholder — user fills this in

[core]
    excludesfile = ~/.gitignore_global
    editor = vim

[pull]
    rebase = false

[init]
    defaultBranch = main

[alias]
    st = status
    lg = log --oneline --graph --decorate --all
    undo = reset HEAD~1 --mixed
```

---

### `git/.gitignore_global`

```
# macOS
.DS_Store
.AppleDouble
.LSOverride
._*

# Python
__pycache__/
*.py[cod]
*.egg-info/
.venv/
.env

# IDEs
.vscode/
.idea/
*.swp
*.swo

# uv
.python-version

# DVC
/tmp
```

---

### `config/tmux.conf`

A minimal but usable tmux config:
- Set prefix to `Ctrl+a` (instead of default `Ctrl+b`)
- Enable mouse mode
- Set history limit to 10000
- Use vim keybindings in copy mode
- Number windows starting from 1
- Status bar: show session name, window list, date/time
- Leave a comment block at the top explaining each section

---

### `README.md`

Structure:

```
# dotfiles

One-command macOS dev environment setup.

## Quick Start
[the curl command]

## What Gets Installed
[table: tool | purpose]

## Manual Steps After Install
[git email config, etc.]

## Make Targets
[table of all make targets]

## Adding New Packages
[how to add to Brewfile, requirements.txt, etc.]

## Structure
[repo tree]
```

Keep it direct and practical. No fluff.

---

## Implementation Notes for Claude Code

1. **Idempotency first** — every install step must check before acting. Pattern:
   ```bash
   if ! command -v brew &>/dev/null; then
     # install
   fi
   ```

2. **Apple Silicon path awareness** — Homebrew installs to `/opt/homebrew` on M1/M2/M3, `/usr/local` on Intel. The `.zshrc` and `install.sh` must handle both.

3. **Symlink strategy** — `make dotfiles` should symlink, not copy. Pattern:
   ```bash
   ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
   ```
   Use `-f` to force overwrite existing files.

4. **uv over pip** — All Python package installs use `uv pip install`, not `pip install` directly.

5. **Oh My Zsh non-interactive** — Pass `--unattended` flag and `RUNZSH=no` env var to prevent it from hijacking the shell mid-install.

6. **Claude Code install** — Use the official one-liner:
   ```bash
   curl -fsSL https://claude.ai/install.sh | bash
   ```

7. **Test the Makefile locally** — After generating, verify `make --dry-run all` runs without syntax errors.

---

## Out of Scope (Do Not Include)

- GUI apps / casks (Notion, Chrome, etc.) — user installs those manually
- SSH key generation — security-sensitive, user does manually  
- Any credentials, tokens, or API keys
- antigravity (Google CLI) — unstable install URL, skip for now
- Any cloud sync or backup configuration
