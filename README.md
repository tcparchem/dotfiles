# Dotfiles

Terminal setup kept consistent across machines: zsh, Ghostty, and cmux on macOS, and PowerShell 7 and Windows Terminal on Windows, all sharing one Starship prompt theme.

## Layout

| Path | What it is |
|---|---|
| `themes/starship.toml` | Starship prompt theme, shared by macOS and Windows |
| `shell/zsh/` | zsh config: `.zshrc`, prompt, aliases, tool init (zoxide, fzf), cmux helpers |
| `ghostty/`, `cmux/` | Ghostty and cmux config (macOS) |
| `windows/powershell/` | Tracked PowerShell 7 profile |
| `windows/terminal/` | Windows Terminal settings export |
| `bin/doctor` | macOS health check for the tools and PATH |
| `scripts/` | Installers and sync scripts, one per platform ([details](scripts/README.md)) |
| `examples/` | Templates for untracked local overrides |
| `Brewfile` | macOS packages, casks, and the Nerd Font |

## Install

### macOS

```sh
brew bundle --file Brewfile
bash scripts/install-macos.sh
source ~/.zshrc
```

Run `doctor` afterwards to check the setup.

### Windows

For any Windows machine:

```powershell
powershell -ExecutionPolicy RemoteSigned -File .\scripts\bootstrap-windows.ps1
```

That one command installs the Windows tools and modules and applies the tracked PowerShell profile and Windows Terminal settings.
If `winget` is missing, install App Installer once and rerun the same command.

### Windows, prompt only (keep your own profile and aliases)

The bootstrap above replaces your PowerShell profile (with a backup). To keep your own profile, for example on a work machine, install only the Starship prompt, theme, and font:

```powershell
powershell -ExecutionPolicy RemoteSigned -File .\scripts\install-prompt-windows.ps1 -AddToProfile
```

- Your profile only gets a small marked Starship init block appended. Windows Terminal settings are untouched.
- Omit `-AddToProfile` to print the block instead. Add `-SkipInstall` if `winget` is unavailable.
- Then set your terminal font face to `JetBrainsMono NFM`.

## Font

The Starship theme uses Nerd Font glyphs, so a Nerd Font is required. Both platforms use JetBrainsMono Nerd Font:

- macOS: installed by the Brewfile and used by Ghostty.
- Windows: installed by the bootstrap (`DEVCOM.JetBrainsMonoNerdFont`) and used by Windows Terminal as font face `JetBrainsMono NFM`.

## Shared commands

Both shells provide `lg` (lazygit), `croot` (go to your code folder), and `dotfiles` (go to this repo), plus zoxide (`z`) and fzf key bindings.

## Local overrides

Machine-specific zsh settings go in `~/.zshrc.local`, which is not tracked. See [examples/zshrc.local.example](examples/zshrc.local.example).

## Maintenance

- `scripts/sync-from-home.sh` copies your live macOS config from `$HOME` back into the repo.
- Installers back up anything they replace as `*.bak.<timestamp>`, which is git-ignored.
- The PowerShell profile contains a block managed by the coreutils installer (marked `DO NOT MODIFY`). Leave it as is; it does nothing when coreutils is not installed.
- `zsh`, Ghostty, and cmux are not meant for native Windows.
