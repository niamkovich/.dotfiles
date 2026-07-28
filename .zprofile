# general variables

export BROWSER="chrome" 
export COLORTERM="truecolor"
export TERM="tmux-256color"
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="ghostty"

# ENVIRONMENT

export XDG_CONFIG_HOME="$HOME/.config" export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# BREW 

eval "$(/opt/homebrew/bin/brew shellenv)"

# NVM

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# RBENV

export PATH="$HOME/.rbenv/shims:$PATH"

# JENV

export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

# PYENV

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# ANDROID

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
# export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home

# GPG

export GPG_TTY=$(tty)


# Added by Obsidian

export PATH="$PATH:/Users/listapad/Applications/Obsidian.app/Contents/MacOS"

# pnpm

export PNPM_HOME="/Users/listapad/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Sqlite

# sqlite is keg-only, which means it was not symlinked into /opt/homebrew,
# because macOS already provides this software and installing another version in
# parallel can cause all kinds of trouble.

# If you need to have sqlite first in your PATH, run:
export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"

# Masetro

export PATH=$PATH:$HOME/.maestro/bin

# uv
export PATH="/Users/listapad/.local/share/../bin:$PATH"
