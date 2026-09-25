# .dotfiles

My macOS configs: zsh, tmux, Neovim, Ghostty, git, and the Homebrew package list.

The repo is stored as a **bare repository** in `~/.dotfiles` with `$HOME` as its work tree.
Files live in their normal locations (`~/.zshrc`, `~/.config/nvim/...`), with no symlinks and no extra tools like stow.
Manage them with the `dotfiles` alias (or the short `d`), not plain `git`.

## Setting up a new machine

### 1. Command Line Tools and Homebrew

```zsh
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
```

> `.zshrc` calls `brew --prefix`, so `brew` must be on `PATH` before the shell starts.

### 2. Clone the repo

```zsh
git clone --bare https://github.com/niamkovich/.dotfiles.git "$HOME/.dotfiles"
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

### 3. Check out the files

```zsh
dotfiles checkout
```

### 4. Install packages from the Brewfile

> Mark taps as trusted if needed

Sign in to the App Store first, otherwise `mas` can't install Xcode.

```zsh
brew bundle install -g --verbose
```

### 5. tmux plugins

```zsh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Then start `tmux` and press `prefix` + `I` to install the plugins.

### 6. Neovim

Just open `nvim`: plugins install automatically on first launch. Then run `:checkhealth` to verify the environment.

And keep in mind, you have to install `node` and `npm` vim `nvm` in order Mason be able to fetch LSP servers and linters.
In other way it will print errors that some LSP server can't be fetch.

### 7. GPG for commit signing

`.gitconfig` enables signing for commits and tags, so `git commit` won't work without the key.

```zsh
# import the key exported from the old machine
gpg --import [your private keys].asc

# link pinenty
pinentry-touchid -fix

# restart gpg
gpgconf --kill gpg-agent

# test signing
echo "test" | gpg --clearsign
```

### 8. Secrets

```zsh
cp ~/.zsh_secrets.example ~/.zsh_secrets
```

Fill in the values in `~/.zsh_secrets`. The file won't end up in the repo because `.gitignore` excludes it. For the variables to be loaded, `.zshrc` needs this line:

```zsh
[[ -f ~/.zsh_secrets ]] && source ~/.zsh_secrets
```

## Day-to-day usage

Once set up, the `dotfiles` and `d` aliases come from `.zshrc`:

```zsh
dgs                        # status
dgd                        # diff
d add ~/.zshrc
d commit -m "..."
d push
dgl                        # pretty log
```

### Adding a new file to the repo

Since `.gitignore` ignores everything by default, a new file must either be allowed in `.gitignore` (`!.somefile`) or added with force:
Also, if you want to track all files in directory, you have to add in git ignore not only the directory statement, but also `!directory/*` statement.
Just `!/dit/` wont be enough

```zsh
d add -f ~/.somefile
```

