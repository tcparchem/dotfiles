#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Installs only the Starship prompt, theme, and Nerd Font on Windows.

.DESCRIPTION
    For machines where you keep your own PowerShell profile and aliases (for
    example a work machine). This script never replaces your profile, Windows
    Terminal settings, SSH config, or AGENTS.md. It only:

      1. Installs Starship and the JetBrainsMono Nerd Font with winget.
      2. Copies themes/starship.toml to ~/.config/starship.toml (with backup).
      3. Optionally appends the Starship init block to your profile.

    After it runs, set your terminal font face to "JetBrainsMono NFM".

.PARAMETER AddToProfile
    Append the Starship init block to the PowerShell profile. Idempotent.

.PARAMETER SkipInstall
    Do not run winget. Only copy the theme (and update the profile if asked).

.PARAMETER StarshipConfigPath
    Where to install the theme. Defaults to ~/.config/starship.toml.

.PARAMETER ProfilePath
    Profile to update with -AddToProfile. Defaults to the current host profile.
#>
param(
    [switch]$AddToProfile,
    [switch]$SkipInstall,
    [string]$StarshipConfigPath = (Join-Path $HOME '.config\starship.toml'),
    [string]$ProfilePath = $PROFILE
)

$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$themeSource = Join-Path $repoRoot 'themes\starship.toml'
$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$fontFace = 'JetBrainsMono NFM'
$beginMarker = '# >>> dotfiles starship >>>'
$endMarker = '# <<< dotfiles starship <<<'

function Test-WingetPackageInstalled {
    param([Parameter(Mandatory = $true)][string]$Id)

    $output = & winget list --id $Id --exact 2>$null
    if ($LASTEXITCODE -ne 0) {
        return $false
    }

    return $null -ne ($output | Select-String -SimpleMatch $Id)
}

function Install-WingetPackage {
    param([Parameter(Mandatory = $true)][string]$Id)

    if (Test-WingetPackageInstalled -Id $Id) {
        Write-Host "$Id already installed"
        return
    }

    Write-Host "Installing $Id..."
    & winget install --id $Id --exact --source winget --accept-package-agreements --accept-source-agreements --silent --disable-interactivity
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "winget install failed for $Id. Install it manually, then rerun this script."
    }
}

if (-not $SkipInstall) {
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Install-WingetPackage -Id 'Starship.Starship'
        Install-WingetPackage -Id 'DEVCOM.JetBrainsMonoNerdFont'
    } else {
        Write-Warning 'winget not found. Install Starship and the JetBrainsMono Nerd Font manually, or rerun after installing App Installer.'
    }
}

$configDir = Split-Path -Parent $StarshipConfigPath
New-Item -ItemType Directory -Force -Path $configDir | Out-Null

if (Test-Path -LiteralPath $StarshipConfigPath) {
    $backupPath = "$StarshipConfigPath.bak.$timestamp"
    Copy-Item -LiteralPath $StarshipConfigPath -Destination $backupPath -Force
    Write-Host "Backed up $StarshipConfigPath -> $backupPath"
}

Copy-Item -LiteralPath $themeSource -Destination $StarshipConfigPath -Force
Write-Host "Installed $StarshipConfigPath"

$initBlock = @(
    $beginMarker
    'if (Get-Command starship -ErrorAction SilentlyContinue) {'
    '    Invoke-Expression (&starship init powershell)'
    '}'
    $endMarker
) -join [Environment]::NewLine

if ($AddToProfile) {
    $profileDir = Split-Path -Parent $ProfilePath
    New-Item -ItemType Directory -Force -Path $profileDir | Out-Null

    $existing = ''
    if (Test-Path -LiteralPath $ProfilePath) {
        $existing = Get-Content -LiteralPath $ProfilePath -Raw
    }

    if ($existing -and $existing.Contains($beginMarker)) {
        Write-Host "Starship init block already present in $ProfilePath"
    } elseif ($existing -match 'starship\s+init\s+powershell') {
        Write-Host "$ProfilePath already initializes Starship; leaving it alone"
    } else {
        $separator = ''
        if ($existing -and -not $existing.EndsWith("`n")) {
            $separator = [Environment]::NewLine
        }
        Add-Content -LiteralPath $ProfilePath -Value ($separator + [Environment]::NewLine + $initBlock + [Environment]::NewLine) -NoNewline
        Write-Host "Added Starship init block to $ProfilePath"
    }
} else {
    Write-Host ''
    Write-Host "Add this to your PowerShell profile ($ProfilePath) to enable the prompt,"
    Write-Host 'or rerun with -AddToProfile:'
    Write-Host ''
    Write-Host $initBlock
}

Write-Host ''
Write-Host "Set your terminal font face to '$fontFace' (Windows Terminal: Settings > Profiles > Defaults > Appearance > Font face)."
Write-Host 'Restart the terminal to pick up the font and prompt.'
