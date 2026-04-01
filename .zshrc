###############################################################################
# VS Code–like word navigation (best-effort ZLE implementation)
# Approximates VS Code default `wordPattern`
###############################################################################

# Use emacs keymap
bindkey -e

# ---------------------------------------------------------------------------
# Key bindings
# ---------------------------------------------------------------------------

# macOS Option + Arrow
bindkey '^[[1;3C' vscode-forward-word
bindkey '^[[1;3D' vscode-backward-word

# Meta fallback (Option+f / Option+b)
bindkey '^[f' vscode-forward-word
bindkey '^[b' vscode-backward-word

# Optional: VS Code–like deletion
bindkey '^[^?' backward-kill-word   # Option + Backspace
bindkey '^[d' kill-word             # Option + d

###############################################################################
# End VS Code–like word navigation
###############################################################################
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8


[[ -f ~/.zsh/zsh-vscode-word-delimiter.zsh ]] && source ~/.zsh/zsh-vscode-word-delimiter.zsh

export BUN_INSTALL="$HOME/.bun" 

export HISTFILE="$HOME/.zsh_history"
export HISTFILESIZE=500000
export HISTSIZE=100000
export SAVEHIST=100000

if [ ! -d $(dirname $HISTFILE) ]; then
    echo "$(dirname $HISTFILE)/ directory does not exist. Creating it now..."
    mkdir -p $(dirname $HISTFILE)
fi

setopt INC_APPEND_HISTORY 
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

source $(brew --prefix)/opt/zsh-autosuggestions/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/opt/zsh-fast-syntax-highlighting/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $(brew --prefix)/opt/zsh-history-substring-search/share/zsh-history-substring-search/zsh-history-substring-search.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

autoload -Uz compinit;
compinit

zstyle ':completion:*' menu select

source $(brew --prefix)/opt/spaceship/spaceship.zsh
[[ -r "$HOME/.zsh/plugins/spaceship-react/spaceship-react.plugin.zsh" ]] && source "$HOME/.zsh/plugins/spaceship-react/spaceship-react.plugin.zsh"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f $HOME/.dart-cli-completion/zsh-config.zsh ]] && . $HOME/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

export PATH=$HOME/.elixir-install/installs/otp/27.2/bin:$PATH
export PATH=$HOME/.elixir-install/installs/elixir/1.18.4-otp-27/bin:$PATH
export PATH="$HOME/fvm/bin:$HOME/fvm/default/bin:$PATH"
export PATH="$BUN_INSTALL/bin:$PATH"
export ZSH_CUSTOM="$HOME/.zsh"
export ANDROID_HOME="$HOMEBREW_PREFIX/share/android-commandlinetools"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export ZSH_HISTORY_SYNC_SCRIPT_PATH=$HOME/.zsh/plugins/zsh-history-sync/sync-history.sh
export ZSH_HISTORY_SYNC_GIT_REPO_PATH=
export ZSH_HISTORY_SYNC_GPG_KEY_UID=
export PATH="$(brew --prefix)/opt/postgresql@18/bin:$PATH"
export PATH="$HOME/.jenv/bin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

eval "$(zoxide init zsh)"
eval "$(pyenv init -)"
eval "$(rbenv init - --no-rehash zsh)"
eval "$(direnv hook zsh)"
eval "$(jenv init -)"
eval "$(fnm env)"

if [[ "$INSIDE_IDE" != "1" && -z "$TMUX" && $- == *i* ]] && command -v tmux >/dev/null; then
  tmux
fi

alias emulator="$ANDROID_HOME/emulator/emulator -avd android-emu-35 -accel on -gpu host -memory 4096 -no-boot-anim"

# Added by Antigravity
export PATH="/Users/yazid/.antigravity/antigravity/bin:$PATH"

# Amp CLI
export PATH="/Users/yazid/.amp/bin:$PATH"

# Gastown
export PATH="$PATH:$HOME/go/bin"


source "$HOME/.local/bin/env"

alias claudepeers="claude --dangerously-skip-permissions --chrome --dangerously-load-development-channels server:claude-peers"
alias cc="claude --dangerously-skip-permissions --chrome"