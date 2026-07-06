#!/usr/bin/env pwsh
param()

$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'

function Copy-WithBackup {
    param(
        [Parameter(Mandatory = $true)][string]$Source,
        [Parameter(Mandatory = $true)][string]$Destination
    )

    $destinationDir = Split-Path -Parent $Destination
    New-Item -ItemType Directory -Force -Path $destinationDir | Out-Null

    if (Test-Path -LiteralPath $Destination) {
        $backupPath = "$Destination.bak.$timestamp"
        Copy-Item -LiteralPath $Destination -Destination $backupPath -Force
        Write-Host "Backed up $Destination -> $backupPath"
    }

    Copy-Item -LiteralPath $Source -Destination $Destination -Force
    Write-Host "Installed $Destination"
}

function New-LinkOrCopy {
    param(
        [Parameter(Mandatory = $true)][string]$Source,
        [Parameter(Mandatory = $true)][string]$Destination
    )

    $destinationDir = Split-Path -Parent $Destination
    New-Item -ItemType Directory -Force -Path $destinationDir | Out-Null

    if (Test-Path -LiteralPath $Destination) {
        if ((Get-Item -LiteralPath $Destination).LinkType -eq 'SymbolicLink') {
            Remove-Item -LiteralPath $Destination -Force
        } else {
            $backupPath = "$Destination.bak.$timestamp"
            Copy-Item -LiteralPath $Destination -Destination $backupPath -Force
            Write-Host "Backed up $Destination -> $backupPath"
            Remove-Item -LiteralPath $Destination -Force
        }
    }

    try {
        New-Item -ItemType SymbolicLink -Path $Destination -Target $Source | Out-Null
        Write-Host "Linked $Destination -> $Source"
    } catch {
        Copy-Item -LiteralPath $Source -Destination $Destination -Force
        Write-Host "Copied $Source -> $Destination"
    }
}

function New-HardLinkOrCopy {
    param(
        [Parameter(Mandatory = $true)][string]$Source,
        [Parameter(Mandatory = $true)][string]$Destination
    )

    $destinationDir = Split-Path -Parent $Destination
    New-Item -ItemType Directory -Force -Path $destinationDir | Out-Null

    if (Test-Path -LiteralPath $Destination) {
        if ((Get-Item -LiteralPath $Destination).LinkType -eq 'HardLink') {
            return
        }

        $backupPath = "$Destination.bak.$timestamp"
        Copy-Item -LiteralPath $Destination -Destination $backupPath -Force
        Write-Host "Backed up $Destination -> $backupPath"
        Remove-Item -LiteralPath $Destination -Force
    }

    try {
        New-Item -ItemType HardLink -Path $Destination -Value $Source | Out-Null
        Write-Host "Hard-linked $Destination -> $Source"
    } catch {
        Copy-Item -LiteralPath $Source -Destination $Destination -Force
        Write-Host "Copied $Source -> $Destination"
    }
}

function Get-PowerShellProfilePath {
    $oneDriveProfile = Join-Path $HOME 'OneDrive\Documents\PowerShell\Microsoft.PowerShell_profile.ps1'
    if (Test-Path (Join-Path $HOME 'OneDrive\Documents')) {
        return $oneDriveProfile
    }

    return Join-Path $HOME 'Documents\PowerShell\Microsoft.PowerShell_profile.ps1'
}

function Get-WindowsTerminalSettingsPath {
    $stable = Join-Path $env:LOCALAPPDATA 'Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json'
    $preview = Join-Path $env:LOCALAPPDATA 'Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json'

    if (Test-Path (Split-Path -Parent $stable)) {
        return $stable
    }

    if (Test-Path (Split-Path -Parent $preview)) {
        return $preview
    }

    return $stable
}

$agentSource = Join-Path $repoRoot 'AGENTS.md'
$profileSource = Join-Path $repoRoot 'windows\powershell\Microsoft.PowerShell_profile.ps1'
$terminalSource = Join-Path $repoRoot 'windows\terminal\settings.json'
$sshConfigSource = Join-Path $repoRoot 'ssh\config'
$sshConfigLocalExampleSource = Join-Path $repoRoot 'examples\ssh-config.local.example'

$agentDestination = Join-Path $HOME 'AGENTS.md'
$profileDestination = Get-PowerShellProfilePath
$terminalDestination = Get-WindowsTerminalSettingsPath
$sshConfigDestination = Join-Path $HOME '.ssh\config'
$sshConfigLocalExampleDestination = Join-Path $HOME '.ssh\config.local.example'
$sshConfigLocalDestination = Join-Path $HOME '.ssh\config.local'

New-LinkOrCopy -Source $agentSource -Destination $agentDestination
New-HardLinkOrCopy -Source $profileSource -Destination $profileDestination
Copy-WithBackup -Source $terminalSource -Destination $terminalDestination
Copy-WithBackup -Source $sshConfigSource -Destination $sshConfigDestination
Copy-WithBackup -Source $sshConfigLocalExampleSource -Destination $sshConfigLocalExampleDestination

if (-not (Test-Path -LiteralPath $sshConfigLocalDestination)) {
    New-Item -ItemType File -Force -Path $sshConfigLocalDestination | Out-Null
}

Write-Host ''
Write-Host 'Windows dotfiles installed.'
Write-Host 'Restart Windows Terminal to pick up the updated profile and settings.'
