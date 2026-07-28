# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="amuse"

autoload -U promptinit; promptinit
prompt typewritten
TYPEWRITTEN_PROMPT_LAYOUT="pure"

plugins=(
  git
  colored-man-pages
  nvm
  z
  pass
  vi-mode
)

source $ZSH/oh-my-zsh.sh
source $ZSH/plugins/zsh-interactive-cd/zsh-interactive-cd.plugin.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# VI_MODE plugin:
export VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true

export VI_MODE_CURSOR_NORMAL=3
export VI_MODE_CURSOR_VISUAL=4
export VI_MODE_SET_CURSOR=true

# Load local secrets (gitignored) — see .zsh_secrets.example
[ -f ~/.zsh_secrets ] && source ~/.zsh_secrets

alias vim=nvim 
alias l="eza -la"
alias ll="eza -la -T -L=2"


# Helper functions:

# Go to directory of provided binary
cdwhich() {
  cd $(dirname $(which "$1"));
}

