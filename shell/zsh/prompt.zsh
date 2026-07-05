if [[ -z "${HOMEBREW_PREFIX:-}" ]] && command -v brew >/dev/null 2>&1; then
  export HOMEBREW_PREFIX="$(brew --prefix)"
fi

if command -v oh-my-posh >/dev/null 2>&1 && [[ -r "$DOTFILES_THEME_PATH" ]]; then
  eval "$(oh-my-posh init zsh --config "$DOTFILES_THEME_PATH")"
fi

if [[ -n "${HOMEBREW_PREFIX:-}" ]] && [[ -r "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

fpath=($HOME/.docker/completions $fpath)
autoload -Uz compinit
compinit

