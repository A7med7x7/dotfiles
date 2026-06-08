# === Homebrew (Apple Silicon + Intel) ===
# Detect Homebrew location at runtime and load its environment.
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# === PATH ===
# uv-installed tools and other user-local binaries.
export PATH="$HOME/.local/bin:$PATH"

# === Oh My Zsh ===
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
[ -s "$ZSH/oh-my-zsh.sh" ] && source "$ZSH/oh-my-zsh.sh"

# === Custom Aliases ===
alias ll='ls -la'
alias gs='git status'
alias gc='git commit'
alias gp='git push'
alias dotfiles='cd ~/dotfiles'

# === Machine Learning ===
# (reserved for future ML-related env vars, aliases, and paths)

# Add project-specific env vars below this line
