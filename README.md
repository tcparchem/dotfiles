# Dotfiles

Private dotfiles for keeping terminal setup consistent across machines.

## Structure

- [Brewfile](./Brewfile)
- [AGENTS.md](./AGENTS.md)
- [shell/zsh/.zshrc](./shell/zsh/.zshrc)
- [shell/zsh/prompt.zsh](./shell/zsh/prompt.zsh)
- [shell/zsh/aliases.zsh](./shell/zsh/aliases.zsh)
- [shell/zsh/cmux.zsh](./shell/zsh/cmux.zsh)
- [shell/zsh/machines.zsh](./shell/zsh/machines.zsh)
- [ssh/config](./ssh/config)
- [ghostty/config](./ghostty/config)
- [cmux/cmux.json](./cmux/cmux.json)
- [themes/oh-my-posh.json](./themes/oh-my-posh.json)
- [examples/zshrc.local.example](./examples/zshrc.local.example)
- [examples/ssh-config.local.example](./examples/ssh-config.local.example)
- [scripts/install.sh](./scripts/install.sh)
- [scripts/sync-from-home.sh](./scripts/sync-from-home.sh)

## Layout

- Shared config lives in the repo.
- Machine-local overrides live outside the repo:
  - `~/.zshrc.local`
  - `~/.ssh/config.local`
- Installed shared helper files live under `~/.config/dotfiles/`.

## macOS

1. Install packages:

```sh
brew bundle --file Brewfile
```

2. Apply the dotfiles:

```sh
bash scripts/install.sh
source ~/.zshrc
```

Notes:

- `cmux` is macOS-only in this setup.
- `Ghostty` is installed via Homebrew cask here.
- `croot` jumps to `~/Code`.
- `code` stays available for the VS Code CLI.

## Linux

Only the portable subset applies:

- `zsh`
- `OpenSSH`
- `Oh My Posh`
- `zsh-autosuggestions`
- `btop`
- optionally `Ghostty`
- `AGENTS.md`

Use the same repo structure, but do not expect the `cmux` helpers to work unless `cmux` becomes available on Linux.

## Windows

Use WSL for the closest match.

For native Windows, the practical pieces are:

- `OpenSSH`
- `Oh My Posh`
- `AGENTS.md`

This repo's `zsh`, `Ghostty`, and `cmux` setup is not meant for native Windows.

## Local Overrides

Use these files for machine-specific tweaks:

- `~/.zshrc.local`
- `~/.ssh/config.local`

Examples are included in [examples](./examples).

## Syncing

Install onto the current machine:

```sh
bash scripts/install.sh
```

Refresh the repo from the current machine:

```sh
bash scripts/sync-from-home.sh
```

## Notes

- This repo tracks SSH config, but not private keys.
- `lg` aliases to `lazygit`.
- `croot` is the replacement for the old `code` alias.

