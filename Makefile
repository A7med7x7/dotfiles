# Makefile — modular dotfiles installer
# Every target is idempotent: safe to run multiple times.

SHELL := /bin/bash
DOTFILES := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

# Detect Homebrew prefix (Apple Silicon vs Intel)
BREW := $(shell command -v brew 2>/dev/null)

.PHONY: all xcode brew uv pip npm ohmyzsh agents git dotfiles update clean

all: xcode brew uv pip npm ohmyzsh agents git dotfiles
	@printf "\033[0;32m✓ make all complete.\033[0m\n"

# --- Xcode Command Line Tools ---
xcode:
	@if ! xcode-select -p &>/dev/null; then \
		printf "→ Installing Xcode Command Line Tools...\n"; \
		xcode-select --install || true; \
	else \
		printf "✓ Xcode Command Line Tools present.\n"; \
	fi

# --- Homebrew + Brewfile ---
brew:
	@if ! command -v brew &>/dev/null; then \
		printf "→ Installing Homebrew...\n"; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	else \
		printf "✓ Homebrew present.\n"; \
	fi
	@if [ -x /opt/homebrew/bin/brew ]; then eval "$$(/opt/homebrew/bin/brew shellenv)"; \
	elif [ -x /usr/local/bin/brew ]; then eval "$$(/usr/local/bin/brew shellenv)"; fi; \
	printf "→ Running brew bundle...\n"; \
	brew bundle --file=$(DOTFILES)/brew/Brewfile

# --- uv (Astral Python package manager) ---
uv:
	@if ! command -v uv &>/dev/null && [ ! -x "$(HOME)/.local/bin/uv" ]; then \
		printf "→ Installing uv...\n"; \
		curl -LsSf https://astral.sh/uv/install.sh | sh; \
	else \
		printf "✓ uv present.\n"; \
	fi

# --- Python packages via uv ---
pip:
	@printf "→ Installing Python packages with uv...\n"; \
	export PATH="$(HOME)/.local/bin:$$PATH"; \
	uv pip install --system -r $(DOTFILES)/pip/requirements.txt 2>/dev/null \
		|| uv pip install -r $(DOTFILES)/pip/requirements.txt

# --- Global npm packages ---
npm:
	@if command -v npm &>/dev/null; then \
		printf "→ Installing global npm packages...\n"; \
		while IFS= read -r pkg; do \
			[ -z "$$pkg" ] && continue; \
			case "$$pkg" in \#*) continue;; esac; \
			printf "  → npm i -g %s\n" "$$pkg"; \
			npm list -g --depth=0 "$$pkg" &>/dev/null || npm install -g "$$pkg"; \
		done < $(DOTFILES)/npm/packages.txt; \
	else \
		printf "✗ npm not found — skipping (install node via brew first).\n"; \
	fi

# --- Oh My Zsh ---
ohmyzsh:
	@if [ ! -d "$(HOME)/.oh-my-zsh" ]; then \
		printf "→ Installing Oh My Zsh...\n"; \
		RUNZSH=no CHSH=no sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; \
	else \
		printf "✓ Oh My Zsh present.\n"; \
	fi

# --- Claude Code CLI ---
agents:
	@if ! command -v claude &>/dev/null; then \
		printf "→ Installing Claude Code CLI...\n"; \
		curl -fsSL https://claude.ai/install.sh | bash; \
	else \
		printf "✓ Claude Code CLI present.\n"; \
	fi

# --- Git config symlinks ---
git:
	@printf "→ Symlinking git config...\n"; \
	ln -sf $(DOTFILES)/git/.gitconfig $(HOME)/.gitconfig; \
	ln -sf $(DOTFILES)/git/.gitignore_global $(HOME)/.gitignore_global; \
	git config --global core.excludesfile $(HOME)/.gitignore_global; \
	printf "✓ Git config linked.\n"

# --- Shell, tmux, Python & SQLite dotfiles symlinks ---
dotfiles:
	@printf "→ Symlinking dotfiles...\n"; \
	ln -sf $(DOTFILES)/zsh/.zshrc $(HOME)/.zshrc; \
	ln -sf $(DOTFILES)/config/tmux.conf $(HOME)/.tmux.conf; \
	ln -sf $(DOTFILES)/config/.sqliterc $(HOME)/.sqliterc; \
	ln -sf $(DOTFILES)/config/.pythonrc $(HOME)/.pythonrc; \
	ln -sf $(DOTFILES)/config/.pdbrc $(HOME)/.pdbrc; \
	printf "✓ Dotfiles linked.\n"

# --- Update everything ---
update:
	@printf "→ Updating Homebrew packages...\n"; \
	brew update && brew upgrade && brew bundle --file=$(DOTFILES)/brew/Brewfile; \
	printf "✓ Update complete.\n"

# --- Remove broken symlinks from home ---
clean:
	@printf "→ Removing broken symlinks from $(HOME)...\n"; \
	find $(HOME) -maxdepth 1 -type l ! -exec test -e {} \; -print -delete; \
	printf "✓ Clean complete.\n"
