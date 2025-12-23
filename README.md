# dotfiles

Opinionated macOS setup: zsh + tmux, Kitty, yabai/skhd, and Karabiner. This repo is whitelist-only via `.gitignore`, so add new files there when you want to track them.

## Contents
- zsh shell config with VS Code-like word navigation and tmux autostart
- tmux with TPM + tmux-oasis theme
- Kitty terminal config and theme
- yabai window manager rules and auto-float scripts
- skhd hotkeys for space focus/move
- Karabiner fn/space modifier layers

## Requirements
Core tools:
- Homebrew
- zsh plugins: `zsh-autosuggestions`, `zsh-fast-syntax-highlighting`, `zsh-history-substring-search`
- tmux + TPM (`~/.tmux/plugins/tpm`)
- Kitty terminal
- yabai + skhd
- Karabiner-Elements
- `jq`

Optional tools used by `.zshrc`:
- `fnm`, `zoxide`, `direnv`, `bun`, `rvm`, `postgresql@18`
- Nerd Font: RecMonoSmCasual Nerd Font Propo (for prompt/kitty glyphs)

## Install
1) Clone this repo anywhere you like.
2) Symlink files into `$HOME`:

```sh
ln -sf "$PWD/.zshrc" "$HOME/.zshrc"
ln -sf "$PWD/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$PWD/.skhdrc" "$HOME/.skhdrc"
ln -sf "$PWD/.spaceshiprc.zsh" "$HOME/.spaceshiprc.zsh"
ln -sf "$PWD/.yabairc" "$HOME/.yabairc"

mkdir -p "$HOME/.config/kitty" "$HOME/.config/karabiner" "$HOME/.yabai" "$HOME/.sh"
ln -sf "$PWD/.config/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"
ln -sf "$PWD/.config/kitty/current-theme.conf" "$HOME/.config/kitty/current-theme.conf"
ln -sf "$PWD/.config/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"
ln -sf "$PWD/.yabai/auto-float-by-space.sh" "$HOME/.yabai/auto-float-by-space.sh"
ln -sf "$PWD/.yabai/reapply-float-for-space.sh" "$HOME/.yabai/reapply-float-for-space.sh"
ln -sf "$PWD/.sh/ide_zsh.sh" "$HOME/.sh/ide_zsh.sh"
```

3) Install TPM: `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
4) Start tmux and press `prefix + I` to install plugins.

## Notes and behavior
- zsh auto-starts tmux for interactive shells. To skip it inside IDEs:
  - Run `~/.sh/ide_zsh.sh`, which sets `INSIDE_IDE=1`.
- skhd hotkeys:
  - `alt + 1..0` focus spaces 1..10
  - `shift + alt + 1..0` move window to space 1..10
  - `alt + space` toggle float
- yabai auto-floats spaces 5 and 10 via `.yabai/*` scripts.
- Karabiner:
  - remaps `spacebar` to a "space modifier" to trigger `alt + 1..0`
  - uses `fn` as a modifier layer for navigation
  - disable conflicting macOS Mission Control shortcuts for space switching

## macOS permissions
- yabai scripting addition requires special permissions and may need SIP adjustments.
- `.yabairc` runs `sudo yabai --load-sa`, so configure passwordless sudo for that command.

## Troubleshooting
- If tmux shows "unknown terminal: tmux-256color", install the terminfo entry.
- If zsh startup errors, ensure required plugins are installed or comment out missing ones.

## TODO
- [ ] Implement Raycast setup and shortcuts
- [ ] Add fzf shortcuts

