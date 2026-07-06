#!/usr/bin/env pwsh
param()

$ErrorActionPreference = 'Stop'

function Assert-Command {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)][string]$Message
    )

    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw $Message
    }
}

function Test-WingetPackageInstalled {
    param(
        [Parameter(Mandatory = $true)][string]$Id
    )

    $output = & winget list --id $Id --exact 2>$null
    if ($LASTEXITCODE -ne 0) {
        return $false
    }

    return ($output | Select-String -SimpleMatch $Id) -ne $null
}

function Install-WingetPackage {
    param(
        [Parameter(Mandatory = $true)][string]$Id
    )

    if (Test-WingetPackageInstalled -Id $Id) {
        Write-Host "$Id already installed"
        return
    }

    Write-Host "Installing $Id..."
    & winget install --id $Id --exact --source winget --accept-package-agreements --accept-source-agreements --silent --disable-interactivity
    if ($LASTEXITCODE -ne 0) {
        throw "winget install failed for $Id"
    }
}

function Ensure-PackageManagement {
    if (-not (Get-PackageProvider -Name NuGet -ListAvailable -ErrorAction SilentlyContinue)) {
        Install-PackageProvider -Name NuGet -Force -Scope CurrentUser | Out-Null
    }

    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
}

function Install-ModuleIfMissing {
    param(
        [Parameter(Mandatory = $true)][string]$Name
    )

    if (-not (Get-Module -ListAvailable -Name $Name)) {
        Install-Module -Name $Name -Scope CurrentUser -Force -AllowClobber
    }
}

function Repair-And-Install-NerdFonts {
    param(
        [Parameter(Mandatory = $true)][string]$FontName
    )

    $moduleName = 'NerdFonts'
    $moduleRoots = @(
        Join-Path $HOME 'Documents\WindowsPowerShell\Modules'
        Join-Path $HOME 'Documents\PowerShell\Modules'
        Join-Path $HOME 'OneDrive\Documents\WindowsPowerShell\Modules'
        Join-Path $HOME 'OneDrive\Documents\PowerShell\Modules'
    ) | Select-Object -Unique

    foreach ($root in $moduleRoots) {
        $modulePath = Join-Path $root $moduleName
        if (Test-Path -LiteralPath $modulePath) {
            Remove-Item -LiteralPath $modulePath -Recurse -Force
        }
    }

    try {
        Install-Module -Name $moduleName -Scope CurrentUser -Force -AllowClobber -ErrorAction Stop
        Import-Module $moduleName -ErrorAction Stop
        Install-NerdFont -Name $FontName | Out-Null
        Write-Host "$FontName font installed"
    } catch {
        Write-Warning "Skipping NerdFonts install: $($_.Exception.Message)"
        Write-Warning 'The Windows profile, terminal settings, and SSH config will still be installed.'
    }
}

Assert-Command -Name winget -Message 'winget is required. Install App Installer, then rerun this script.'

Install-WingetPackage -Id 'Git.Git'
Install-WingetPackage -Id 'Microsoft.PowerShell'
Install-WingetPackage -Id 'Microsoft.WindowsTerminal'
Install-WingetPackage -Id 'JanDeDobbeleer.OhMyPosh'
Install-WingetPackage -Id 'JesseDuffield.lazygit'
Install-WingetPackage -Id 'ajeetdsouza.zoxide'

Ensure-PackageManagement
Install-ModuleIfMissing -Name 'Terminal-Icons'
Install-ModuleIfMissing -Name 'PSFzf'
Repair-And-Install-NerdFonts -FontName 'CaskaydiaCove'

& (Join-Path $PSScriptRoot 'install-windows.ps1')
