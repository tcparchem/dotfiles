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

backup_and_symlink() {
  local target="$1"
  local link_path="$2"

  mkdir -p "$(dirname "$link_path")"

  if [[ -L "$link_path" ]]; then
    local current_target
    current_target="$(readlink "$link_path")"
    if [[ "$current_target" == "$target" ]]; then
      return
    fi
    mv "$link_path" "${link_path}.bak.${timestamp}"
    printf 'Backed up %s -> %s.bak.%s\n' "$link_path" "$link_path" "$timestamp"
  elif [[ -e "$link_path" ]]; then
    cp "$link_path" "${link_path}.bak.${timestamp}"
    printf 'Backed up %s -> %s.bak.%s\n' "$link_path" "$link_path" "$timestamp"
    rm -f "$link_path"
  fi

  ln -s "$target" "$link_path"
}

backup_and_copy "$repo_root/shell/zsh/.zshrc" "$HOME/.zshrc"
backup_and_copy "$repo_root/shell/zsh/prompt.zsh" "$HOME/.config/dotfiles/zsh/prompt.zsh"
backup_and_copy "$repo_root/shell/zsh/aliases.zsh" "$HOME/.config/dotfiles/zsh/aliases.zsh"
backup_and_copy "$repo_root/shell/zsh/cmux.zsh" "$HOME/.config/dotfiles/zsh/cmux.zsh"
backup_and_copy "$repo_root/shell/zsh/machines.zsh" "$HOME/.config/dotfiles/zsh/machines.zsh"
backup_and_copy "$repo_root/bin/mini" "$HOME/.config/dotfiles/bin/mini"
backup_and_copy "$repo_root/bin/mmini" "$HOME/.config/dotfiles/bin/mmini"
backup_and_copy "$repo_root/bin/mmon" "$HOME/.config/dotfiles/bin/mmon"
backup_and_copy "$repo_root/bin/mmlan" "$HOME/.config/dotfiles/bin/mmlan"
backup_and_copy "$repo_root/bin/doctor" "$HOME/.config/dotfiles/bin/doctor"
backup_and_copy "$repo_root/themes/starship.toml" "$HOME/.config/starship.toml"
backup_and_copy "$repo_root/ssh/config" "$HOME/.ssh/config"
backup_and_copy "$repo_root/ghostty/config" "$HOME/.config/ghostty/config"
backup_and_copy "$repo_root/cmux/cmux.json" "$HOME/.config/cmux/cmux.json"
backup_and_symlink "$repo_root/AGENTS.md" "$HOME/AGENTS.md"
backup_and_copy "$repo_root/examples/zshrc.local.example" "$HOME/.zshrc.local.example"
backup_and_copy "$repo_root/examples/ssh-config.local.example" "$HOME/.ssh/config.local.example"

if [[ ! -e "$HOME/.ssh/config.local" ]]; then
  : > "$HOME/.ssh/config.local"
fi

chmod 700 "$HOME/.ssh"
chmod 600 "$HOME/.ssh/config"
chmod 600 "$HOME/.ssh/config.local"
chmod 755 "$HOME/.config/dotfiles/bin/mini"
chmod 755 "$HOME/.config/dotfiles/bin/mmini"
chmod 755 "$HOME/.config/dotfiles/bin/mmon"
chmod 755 "$HOME/.config/dotfiles/bin/mmlan"
chmod 755 "$HOME/.config/dotfiles/bin/doctor"

zsh -n "$HOME/.zshrc"
printf '\nDotfiles installed.\n'
