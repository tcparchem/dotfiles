# Dotfiles

Private dotfiles for keeping terminal setup consistent across machines.

## What's here

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

That one command installs the Windows tools and modules, applies the tracked PowerShell profile, Windows Terminal settings, the shared SSH config, and `AGENTS.md`.
If `winget` is missing, install App Installer once and rerun the same command.
The Windows prompt now uses built-in Cascadia Mono, so no Nerd Fonts module install is required.

## Windows SSH

After the Windows bootstrap finishes:

1. Create a key if you do not already have one.

```powershell
ssh-keygen -t ed25519 -f $HOME\.ssh\id_ed25519_macmini -C "windows@$env:COMPUTERNAME"
```

2. Copy the public key to the Mac so logins no longer ask for your account password.

```powershell
Get-Content $HOME\.ssh\id_ed25519_macmini.pub | ssh macmini 'umask 077; mkdir -p ~/.ssh; cat >> ~/.ssh/authorized_keys'
Get-Content $HOME\.ssh\id_ed25519_macmini.pub | ssh macmini-lan 'umask 077; mkdir -p ~/.ssh; cat >> ~/.ssh/authorized_keys'
```

3. Optional but recommended: start the local ssh-agent and load the key once.

```powershell
Set-Service ssh-agent -StartupType Automatic
Start-Service ssh-agent
ssh-add $HOME\.ssh\id_ed25519_macmini
```

If `Set-Service` says access is denied, run that one command in an elevated PowerShell once.

## How to use it

- `mmini` opens an SSH shell to `macmini`.
- `mmon` opens `btop` on `macmini` in a forced TTY.
- `mmlan` opens an SSH shell to `macmini-lan`.
- `ssh macmini` still works if you want raw SSH access.
- The first connection may ask you to trust the host key. Type `yes` once and it will be remembered.

## Notes

- `windows/powershell/Microsoft.PowerShell_profile.ps1` is the tracked PowerShell 7 profile.
- `windows/terminal/settings.json` is the tracked Windows Terminal export.
- The profile includes `lg` for `lazygit`, `croot` for `C:\Code`, and the `mmini`/`mmon`/`mmlan` SSH helpers.
- `zsh`, `Ghostty`, and `cmux` are not meant for native Windows.
- `AGENTS.md` is shared from the repo copy.

## Local Overrides

- `~/.zshrc.local`
- `~/.ssh/config.local`

Examples live in [examples](./examples).
