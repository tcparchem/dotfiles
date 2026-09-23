if [[ -z "${HOMEBREW_PREFIX:-}" ]] && command -v brew >/dev/null 2>&1; then
  export HOMEBREW_PREFIX="$(brew --prefix)"
fi

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

if [[ -n "${HOMEBREW_PREFIX:-}" ]] && [[ -r "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

fpath=($HOME/.docker/completions $fpath)
autoload -Uz compinit
compinit

