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

On any Windows box:

1. Install PowerShell 7, Windows Terminal, Git, and a Nerd Font such as CaskaydiaCove.
2. Clone this repo to `C:\Code\dotfiles`.
3. Run:

```powershell
powershell -ExecutionPolicy RemoteSigned -File .\scripts\install-windows.ps1
```

4. Restart Windows Terminal.

That script backs up your existing profile and terminal settings, installs `AGENTS.md`, and links the PowerShell profile back to `windows/powershell/Microsoft.PowerShell_profile.ps1` when possible, so the repo stays the source of truth.

## Notes

- `windows/powershell/Microsoft.PowerShell_profile.ps1` is the tracked PowerShell 7 profile.
- `windows/terminal/settings.json` is the tracked Windows Terminal export for this machine.
- The PowerShell profile includes `lg` for `lazygit` and `croot` for `C:\Code`.
- `zsh`, `Ghostty`, and `cmux` are not meant for native Windows.
- `AGENTS.md` is shared from the repo copy so agent memory stays in one place.

## Local Overrides

Use these files for machine-specific tweaks:

- `~/.zshrc.local`
- `~/.ssh/config.local`

Examples are included in [examples](./examples).

## Syncing

```sh
bash scripts/sync-from-home.sh
```
