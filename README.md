# dotfiles

One-command macOS dev environment setup. Run a single command on a fresh
MacBook (Apple Silicon or Intel) and restore the entire dev environment.

## Quick Start

```bash
curl -fsSL https://raw.githubusercontent.com/A7med7x7/dotfiles/main/install.sh | bash
```

## What Gets Installed

| Tool | Purpose |
|------|---------|
| Xcode CLT | Compilers and core developer tooling |
| Homebrew | Package manager for macOS |
| python | Python interpreter |
| uv | Fast Python package/dependency manager (Astral) |
| node / npm | JavaScript runtime + global packages |
| pipx | Isolated installs of Python CLI apps |
| hugo | Static site generator |
| wget / curl | File downloads |
| nload / nvtop | Network and GPU monitoring |
| vim | Terminal editor |
| tmux | Terminal multiplexer |
| git | Version control |
| Oh My Zsh | Zsh framework + theme |
| Claude Code | Anthropic's CLI agent |
| dvc | Data version control (via uv) |
| badge-maker | Global npm package |

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

| Target | What it does |
|--------|--------------|
| `make all` | Runs every target in order |
| `make xcode` | Installs Xcode Command Line Tools if missing |
| `make brew` | Installs Homebrew if missing, then runs `brew bundle` |
| `make uv` | Installs uv (Astral's Python package manager) |
| `make pip` | Installs `pip/requirements.txt` via `uv pip install` |
| `make npm` | Installs global npm packages from `npm/packages.txt` |
| `make ohmyzsh` | Installs Oh My Zsh (non-interactive) |
| `make agents` | Installs the Claude Code CLI |
| `make git` | Symlinks git config + sets global excludesfile |
| `make dotfiles` | Symlinks `.zshrc` and `tmux.conf` to home |
| `make update` | `brew update && brew upgrade && brew bundle` |
| `make clean` | Removes broken symlinks from home directory |

## Adding New Packages

- **Homebrew:** add a `brew "name"` line to `brew/Brewfile`, then `make brew`.
- **Python:** add the package to `pip/requirements.txt`, then `make pip`.
- **npm:** add the package name to `npm/packages.txt`, then `make npm`.

## Structure

```
dotfiles/
├── install.sh              # Entry point — the one curl | bash command
├── Makefile                # Modular targets: make all, make brew, make pip, ...
├── brew/
│   └── Brewfile            # Declarative brew installs
├── pip/
│   └── requirements.txt    # Python packages (installed via uv)
├── npm/
│   └── packages.txt        # Global npm packages (one per line)
├── zsh/
│   └── .zshrc              # Zsh config with Oh My Zsh setup
├── git/
│   ├── .gitconfig          # Global git config
│   └── .gitignore_global   # Global gitignore
├── config/
│   └── tmux.conf           # Tmux config
└── README.md
```
