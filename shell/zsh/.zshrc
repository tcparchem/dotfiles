export TERM=xterm-256color
export DOTFILES_CONFIG_DIR="$HOME/.config/dotfiles"
export DOTFILES_ZSH_DIR="$DOTFILES_CONFIG_DIR/zsh"
export DOTFILES_THEME_PATH="$DOTFILES_CONFIG_DIR/themes/oh-my-posh.json"

for file in \
  "$DOTFILES_ZSH_DIR/prompt.zsh" \
  "$DOTFILES_ZSH_DIR/aliases.zsh" \
  "$DOTFILES_ZSH_DIR/cmux.zsh" \
  "$DOTFILES_ZSH_DIR/machines.zsh"
do
  if [[ -r "$file" ]]; then
    source "$file"
  fi
done

if [[ -r "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi

