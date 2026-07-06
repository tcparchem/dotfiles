# Dotfiles

Private dotfiles for keeping terminal setup consistent across machines.

## What’s here

- macOS/Linux shell, SSH, Ghostty, cmux, and helper scripts
- Windows PowerShell 7, Windows Terminal, and install automation
- shared `AGENTS.md` plus small local override examples

## Install

### macOS

```sh
brew bundle --file Brewfile
bash scripts/install.sh
source ~/.zshrc
```

### Windows

For any Windows machine:

```powershell
powershell -ExecutionPolicy RemoteSigned -File .\scripts\bootstrap-windows.ps1
```

That one command installs the Windows tools and modules, installs the Nerd Font, then applies the tracked PowerShell profile, Windows Terminal settings, and `AGENTS.md`.
If `winget` is missing, install App Installer once and rerun the same command.

## Notes

- `windows/powershell/Microsoft.PowerShell_profile.ps1` is the tracked PowerShell 7 profile.
- `windows/terminal/settings.json` is the tracked Windows Terminal export.
- The profile includes `lg` for `lazygit` and `croot` for `C:\Code`.
- `zsh`, `Ghostty`, and `cmux` are not meant for native Windows.
- `AGENTS.md` is shared from the repo copy.

## Local Overrides

- `~/.zshrc.local`
- `~/.ssh/config.local`

Examples live in [examples](./examples).
