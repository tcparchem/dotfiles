#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
timestamp="$(date +%Y%m%d-%H%M%S)"

backup_and_copy() {
  local src="$1"
  local dest="$2"

  mkdir -p "$(dirname "$dest")"

  if [[ -e "$dest" ]]; then
    cp "$dest" "${dest}.bak.${timestamp}"
    printf 'Backed up %s -> %s.bak.%s\n' "$dest" "$dest" "$timestamp"
  fi

  cp "$src" "$dest"
}

backup_and_copy "$repo_root/shell/zsh/.zshrc" "$HOME/.zshrc"
backup_and_copy "$repo_root/shell/zsh/prompt.zsh" "$HOME/.config/dotfiles/zsh/prompt.zsh"
backup_and_copy "$repo_root/shell/zsh/aliases.zsh" "$HOME/.config/dotfiles/zsh/aliases.zsh"
backup_and_copy "$repo_root/shell/zsh/tools.zsh" "$HOME/.config/dotfiles/zsh/tools.zsh"
backup_and_copy "$repo_root/shell/zsh/cmux.zsh" "$HOME/.config/dotfiles/zsh/cmux.zsh"
backup_and_copy "$repo_root/bin/doctor" "$HOME/.config/dotfiles/bin/doctor"
backup_and_copy "$repo_root/themes/starship.toml" "$HOME/.config/starship.toml"
backup_and_copy "$repo_root/ghostty/config" "$HOME/.config/ghostty/config"
backup_and_copy "$repo_root/cmux/cmux.json" "$HOME/.config/cmux/cmux.json"
backup_and_copy "$repo_root/examples/zshrc.local.example" "$HOME/.zshrc.local.example"

chmod 755 "$HOME/.config/dotfiles/bin/doctor"

zsh -n "$HOME/.zshrc"
printf '\nDotfiles installed.\n'
