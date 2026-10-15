# Scripts

One installer per platform, plus a prompt-only installer for Windows and a sync script for macOS.
Every installer backs up any file it replaces as `<file>.bak.<timestamp>`, which is git-ignored.

| Script | Platform | Purpose |
|---|---|---|
| [`install-macos.sh`](install-macos.sh) | macOS | Copy the repo's config into `$HOME` |
| [`sync-from-home.sh`](sync-from-home.sh) | macOS | Copy live config from `$HOME` back into the repo |
| [`bootstrap-windows.ps1`](bootstrap-windows.ps1) | Windows | Install tools, then apply the full config |
| [`install-windows.ps1`](install-windows.ps1) | Windows | Apply the full config without installing tools |
| [`install-prompt-windows.ps1`](install-prompt-windows.ps1) | Windows | Install only the Starship prompt, theme, and font |

## install-macos.sh

Copies the zsh files, `doctor`, the Starship theme, and the Ghostty and cmux config into place:

- `~/.zshrc` and `~/.config/dotfiles/zsh/`
- `~/.config/dotfiles/bin/doctor`
- `~/.config/starship.toml`, `~/.config/ghostty/config`, `~/.config/cmux/cmux.json`
- `~/.zshrc.local.example` (copy it to `~/.zshrc.local` for machine-specific overrides)

It does not install packages. Run `brew bundle --file Brewfile` first.

```sh
brew bundle --file Brewfile
bash scripts/install-macos.sh
source ~/.zshrc
```

## sync-from-home.sh

The reverse of `install-macos.sh`. Use it after tweaking your live config to pull the changes back into the repo.
It overwrites the tracked files without a backup, so review the result with `git diff` before committing.

```sh
bash scripts/sync-from-home.sh
git diff
```

## bootstrap-windows.ps1

The one command for a new Windows machine. Requires `winget`.

1. Installs Git, PowerShell 7, Windows Terminal, Starship, JetBrainsMono Nerd Font, lazygit, zoxide, and fzf with `winget`.
2. Installs the `Terminal-Icons` and `PSFzf` PowerShell modules for the current user.
3. Runs `install-windows.ps1`.

Already-installed packages are skipped, so it is safe to rerun.
This replaces your PowerShell profile (with a backup). To keep your own profile, use `install-prompt-windows.ps1` instead.

```powershell
powershell -ExecutionPolicy RemoteSigned -File .\scripts\bootstrap-windows.ps1
```

## install-windows.ps1

Applies the tracked config without installing anything. Called by `bootstrap-windows.ps1`, and useful on its own after editing the repo:

- Hard-links the PowerShell profile from `windows/powershell/` (falls back to a copy), so editing the installed profile edits the repo file.
- Copies `themes/starship.toml` to `~/.config/starship.toml`.
- Copies `windows/terminal/settings.json` to the Windows Terminal settings location (stable, or Preview if that is what is installed).

```powershell
powershell -ExecutionPolicy RemoteSigned -File .\scripts\install-windows.ps1
```

## install-prompt-windows.ps1

For machines where you keep your own profile and aliases, such as a work machine. It never replaces your profile or Windows Terminal settings.

1. Installs Starship and the JetBrainsMono Nerd Font with `winget`.
2. Copies `themes/starship.toml` to `~/.config/starship.toml`.
3. Prints the Starship init block, or appends it to your profile with `-AddToProfile`.

| Parameter | Effect |
|---|---|
| `-AddToProfile` | Append the init block to your profile. Safe to rerun; it will not add a duplicate. |
| `-SkipInstall` | Skip `winget` and only copy the theme. |
| `-StarshipConfigPath` | Install the theme somewhere other than `~/.config/starship.toml`. |
| `-ProfilePath` | Update a profile other than the current host's. |

After it runs, set your terminal font face to `JetBrainsMono NFM`.

```powershell
powershell -ExecutionPolicy RemoteSigned -File .\scripts\install-prompt-windows.ps1 -AddToProfile
```
