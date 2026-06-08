#!/usr/bin/env bash
#
# install.sh — single entry point for fresh-Mac dotfiles setup
#
#   curl -fsSL https://raw.githubusercontent.com/A7med7x7/dotfiles/main/install.sh | bash
#
set -e

# --- Colors ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

info()    { printf "${YELLOW}→ %s${NC}\n" "$1"; }
success() { printf "${GREEN}✓ %s${NC}\n" "$1"; }
error()   { printf "${RED}✗ %s${NC}\n" "$1" >&2; }

REPO_URL="https://github.com/A7med7x7/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"

# --- 1. Xcode Command Line Tools ---
info "Checking for Xcode Command Line Tools..."
if ! xcode-select -p &>/dev/null; then
  info "Installing Xcode Command Line Tools (a dialog may appear)..."
  xcode-select --install || true
  # Wait for the installation to finish
  until xcode-select -p &>/dev/null; do
    sleep 5
  done
  success "Xcode Command Line Tools installed."
else
  success "Xcode Command Line Tools already installed."
fi

# --- 2. Clone the repo ---
info "Setting up dotfiles repo at $DOTFILES_DIR..."
if [ -d "$DOTFILES_DIR/.git" ]; then
  success "Repo already exists — skipping clone."
else
  git clone "$REPO_URL" "$DOTFILES_DIR"
  success "Repo cloned."
fi

# --- 3. Run make all ---
info "Running 'make all'..."
cd "$DOTFILES_DIR"
make all

# --- 4. Done ---
success "Dotfiles installed!"
printf "${GREEN}"
cat <<'EOF'

  All set. A couple of manual steps remain:
    • Set your git email:  git config --global user.email "you@example.com"
    • Restart your shell:  exec zsh

EOF
printf "${NC}"
