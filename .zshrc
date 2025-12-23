###############################################################################
# VS Code–like word navigation (best-effort ZLE implementation)
# Approximates VS Code default `wordPattern`
###############################################################################

# Use emacs keymap
bindkey -e

# ---------------------------------------------------------------------------
# Character classification helpers (VS Code–ish)
# ---------------------------------------------------------------------------

_zle_is_space() {
  [[ "$1" == " " || "$1" == $'\t' ]]
}

_zle_is_word() {
  case "$1" in
    [A-Za-z0-9_]) return 0 ;;
    *) return 1 ;;
  esac
}

_zle_is_punct() {
  case "$1" in
    '`'|'~'|'!'|'@'|'#'|'%'|'^'|'&'|'*'|'('|')'|'-'|'='|'+'|'['|']'|'{'|'}'|'\'|'|'|';'|':'|','|'.'|'<'|'>'|'/'|'?')
      return 0 ;;
    *)
      return 1 ;;
  esac
}

# ---------------------------------------------------------------------------
# Forward word (VS Code–like)
# ---------------------------------------------------------------------------

zle_vscode_forward_word() {
  local buf="$BUFFER"
  local len=${#buf}
  local i=$CURSOR

  (( i >= len )) && return

  # Skip whitespace
  while (( i < len )) && _zle_is_space "${buf[i+1]}"; do
    (( i++ ))
  done

  (( i >= len )) && { CURSOR=$i; return }

  local ch="${buf[i+1]}"

  # ---- SPECIAL CASE: "--" group ----
  if [[ "$ch" == "-" && "${buf[i+2]}" == "-" ]]; then
    while (( i < len )) && [[ "${buf[i+1]}" == "-" ]]; do
      (( i++ ))
    done
    CURSOR=$i
    return
  fi

  # Number (keep decimals together)
  if [[ "$ch" == [0-9] ]]; then
    while (( i < len )) && [[ "${buf[i+1]}" == [0-9.] ]]; do
      (( i++ ))
    done
    CURSOR=$i
    return
  fi

  # Word
  if _zle_is_word "$ch"; then
    while (( i < len )) && _zle_is_word "${buf[i+1]}"; do
      (( i++ ))
    done
    CURSOR=$i
    return
  fi

  # Punctuation
  (( i++ ))
  CURSOR=$i
}


# ---------------------------------------------------------------------------
# Backward word (VS Code–like)
# ---------------------------------------------------------------------------

zle_vscode_backward_word() {
  local buf="$BUFFER"
  local i=$CURSOR

  (( i <= 0 )) && return

  # Skip whitespace
  while (( i > 0 )) && _zle_is_space "${buf[i]}"; do
    (( i-- ))
  done

  (( i <= 0 )) && { CURSOR=$i; return }

  local ch="${buf[i]}"

  # ---- SPECIAL CASE: "--" group ----
  if [[ "$ch" == "-" && "${buf[i-1]}" == "-" ]]; then
    while (( i > 0 )) && [[ "${buf[i]}" == "-" ]]; do
      (( i-- ))
    done
    CURSOR=$i
    return
  fi

  # Number
  if [[ "$ch" == [0-9] ]]; then
    while (( i > 0 )) && [[ "${buf[i]}" == [0-9.] ]]; do
      (( i-- ))
    done
    CURSOR=$i
    return
  fi

  # Word
  if _zle_is_word "$ch"; then
    while (( i > 0 )) && _zle_is_word "${buf[i]}"; do
      (( i-- ))
    done
    CURSOR=$i
    return
  fi

  # Punctuation
  (( i-- ))
  CURSOR=$i
}

# ---------------------------------------------------------------------------
# Register widgets
# ---------------------------------------------------------------------------

zle -N vscode-forward-word zle_vscode_forward_word
zle -N vscode-backward-word zle_vscode_backward_word

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

source $(brew --prefix)/opt/zsh-fast-syntax-highlighting/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
for plug in zsh-autosuggestion zsh-history-substring-search; do
  plugin_path="$(brew --prefix)/share/$plug/${plug#zsh-}.zsh"
  [[ -r $plugin_path ]] && source "$plugin_path"
done

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
autoload -Uz compinit;
compinit

zstyle ':completion:*' menu select

eval "$(fnm env --use-on-cd --shell zsh)"
eval "$(zoxide init zsh)"
# eval "$(pyenv init -)"

eval "$(direnv hook zsh)"
source $(brew --prefix)/opt/spaceship/spaceship.zsh
[[ -r "$HOME/.zsh/plugins/spaceship-react/spaceship-react.plugin.zsh" ]] && source "$HOME/.zsh/plugins/spaceship-react/spaceship-react.plugin.zsh"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

export PATH="$HOME/fvm/bin:$HOME/fvm/default/bin:$PATH"
export PATH="$BUN_INSTALL/bin:$PATH"
export ZSH_CUSTOM="$HOME/.zsh"

# if [ "$TMUX" = "" ]; then tmux; fi

if [[ "$INSIDE_IDE" != "1" && -z "$TMUX" && $- == *i* ]] && command -v tmux >/dev/null; then
  tmux
fi

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f $HOME/.dart-cli-completion/zsh-config.zsh ]] && . $HOME/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]


# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
export ZSH_HISTORY_SYNC_SCRIPT_PATH=$HOME/.zsh/plugins/zsh-history-sync/sync-history.sh
export ZSH_HISTORY_SYNC_GIT_REPO_PATH=
export ZSH_HISTORY_SYNC_GPG_KEY_UID=
export PATH="$(brew --prefix)/opt/postgresql@18/bin:$PATH"
