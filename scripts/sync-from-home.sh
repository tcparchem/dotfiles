#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

copy_from_home() {
  local src="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
}

copy_from_home "$HOME/.zshrc" "$repo_root/shell/zsh/.zshrc"
copy_from_home "$HOME/.config/dotfiles/zsh/prompt.zsh" "$repo_root/shell/zsh/prompt.zsh"
copy_from_home "$HOME/.config/dotfiles/zsh/aliases.zsh" "$repo_root/shell/zsh/aliases.zsh"
copy_from_home "$HOME/.config/dotfiles/zsh/cmux.zsh" "$repo_root/shell/zsh/cmux.zsh"
copy_from_home "$HOME/.config/dotfiles/bin/doctor" "$repo_root/bin/doctor"
copy_from_home "$HOME/.config/starship.toml" "$repo_root/themes/starship.toml"
copy_from_home "$HOME/.config/ghostty/config" "$repo_root/ghostty/config"
copy_from_home "$HOME/.config/cmux/cmux.json" "$repo_root/cmux/cmux.json"
printf 'Repo synced from %s\n' "$HOME"
