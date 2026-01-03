
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
