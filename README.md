# Dotfiles

Private dotfiles for keeping terminal setup consistent across machines.

## Structure

- [Brewfile](./Brewfile)
- [AGENTS.md](./AGENTS.md)
- [bin/mini](./bin/mini)
- [bin/mmini](./bin/mmini)
- [bin/mmon](./bin/mmon)
- [bin/mmlan](./bin/mmlan)
- [bin/doctor](./bin/doctor)
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
- `AGENTS.md` is the one file meant to stay as a symlink back to the repo copy.
- Installed shared helper files live under `~/.config/dotfiles/`.
- Terminal commands like `mini`, `mmini`, and `mmon` are installed as real executables under `~/.config/dotfiles/bin`.
- `doctor` is a small health check command for the terminal and Mac mini workflow.

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
- `~/AGENTS.md` is symlinked to the repo copy so agent memory stays shared and edits do not drift.
- `mini`, `mmini`, `mmon`, and `mmlan` work as commands, not just shell aliases.
- `doctor` checks `PATH`, `cmux`, SSH access to `macmini`, remote `btop`, and the `AGENTS.md` symlink.

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

If you want the same global agent memory on a Windows desktop, clone the repo there and point `%USERPROFILE%\\AGENTS.md` at the repo copy.

PowerShell:

```powershell
New-Item -ItemType SymbolicLink -Path "$HOME\\AGENTS.md" -Target "$HOME\\Code\\dotfiles\\AGENTS.md"
```

If symlinks are restricted on that machine, copy the file instead and re-copy it whenever you update the repo.

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

Note:

- `AGENTS.md` is not copied by the sync script because the repo file is the source of truth and the live home path is just a symlink.

## Doctor

Run:

```sh
doctor
```

It checks:

- `cmux`
- `ssh`
- local `btop`
- `mini`, `mmini`, and `mmon` command availability
- whether the dotfiles bin directory is on `PATH`
- whether `~/AGENTS.md` is a valid symlink
- whether `macmini` resolves in SSH config
- whether passwordless SSH to `macmini` works
- whether remote `btop` is available on `macmini`

## Notes

- This repo tracks SSH config, but not private keys.
- `lg` aliases to `lazygit`.
- `croot` is the replacement for the old `code` alias.
