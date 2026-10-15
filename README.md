# Dotfiles

Dotfiles for keeping terminal setup consistent across machines.
Machine-specific zsh overrides are kept out of the repo in `~/.zshrc.local`.

## What's here

- macOS/Linux shell, Ghostty, cmux, and helper scripts
- Windows PowerShell 7, Windows Terminal, and install automation
- small local override examples

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

That one command installs the Windows tools and modules and applies the tracked PowerShell profile and Windows Terminal settings.
If `winget` is missing, install App Installer once and rerun the same command.
The Starship prompt uses Nerd Font glyphs, so a Nerd Font is required.
Both platforms use JetBrainsMono Nerd Font: the Brewfile installs it for Ghostty, and the Windows bootstrap installs `DEVCOM.JetBrainsMonoNerdFont` for Windows Terminal (font face `JetBrainsMono NFM`).

### Windows, prompt only (keep your own profile and aliases)

The bootstrap above replaces your PowerShell profile (with a backup). To keep your own profile, for example on a work machine, install only the Starship prompt, theme, and font:

```powershell
powershell -ExecutionPolicy RemoteSigned -File .\scripts\install-prompt-windows.ps1 -AddToProfile
```

- Your profile only gets a small marked Starship init block appended. Windows Terminal settings are untouched.
- Omit `-AddToProfile` to print the block instead. Add `-SkipInstall` if `winget` is unavailable.
- Then set your terminal font face to `JetBrainsMono NFM`.

## Notes

- `windows/powershell/Microsoft.PowerShell_profile.ps1` is the tracked PowerShell 7 profile.
- `themes/starship.toml` is the shared Starship prompt configuration.
- `windows/terminal/settings.json` is the tracked Windows Terminal export.
- The profile includes `lg` for `lazygit` and `croot` for `C:\Code`.
- `zsh`, `Ghostty`, and `cmux` are not meant for native Windows.

## Local Overrides

- `~/.zshrc.local`

An example lives in [examples](./examples).
