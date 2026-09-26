# Path to your oh-my-zsh installation.
# export ZSH="$HOME/.oh-my-zsh"

# ZSH_THEME="amuse"

export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad


fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
fpath=("$HOME/zsh_tool/z" $fpath)

autoload -U promptinit; promptinit
autoload -U colors; colors

autoload -Uz compinit; compinit

#plugins=(
#  git
#  colored-man-pages
#  nvm
#  z
#  pass
#  vi-mode
#)

#source $ZSH/oh-my-zsh.sh
#source $ZSH/plugins/zsh-interactive-cd/zsh-interactive-cd.plugin.zsh

# VI_MODE plugin:
# export VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true

# export VI_MODE_CURSOR_NORMAL=3
# export VI_MODE_CURSOR_VISUAL=4
# export VI_MODE_SET_CURSOR=true

ZSH_AUTOSUGGEST_STRATEGY=(history completion)

source "$HOME/zsh_tool/git_shortcuts.zsh"
source "$HOME/zsh_tool/colored_man_pages.zsh"
source "$HOME/zsh_tool/z/z.zsh"
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh


#
# Aliases:
#

alias vim=nvim 
alias l="eza -la"
alias ll="eza -la -T -L=2"
alias pinentry='pinentry-mac'
alias grep="grep --color"
alias cat="bat"

alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias d=dotfiles
alias dgs="dotfiles status -sb"
alias dgd="dotfiles diff"
alias dgl="dotfiles log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %C(bold blue)<%an> %Cgreen(%cr)%Creset' --abbrev-commit"
alias dgll="dotfiles log --stat=80"

# Load local secrets (gitignored) — see .zsh_secrets.example
[ -f ~/.zsh_secrets ] && source ~/.zsh_secrets


eval "$(starship init zsh)"
