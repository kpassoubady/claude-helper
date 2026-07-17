#!/usr/bin/env pwsh
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

param(
    [Alias('f')]
    [switch]$Force,

    [Alias('d')]
    [switch]$DryRun,

    [Alias('h')]
    [switch]$Help,

    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Modules
)

$CLAUDE_HOME = if ($env:CLAUDE_HOME) { $env:CLAUDE_HOME } else { Join-Path $HOME '.claude' }
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path

$ALL_MODULES = @('rules', 'commands', 'agents', 'hooks', 'plugins', 'docs', 'skills', 'templates', 'settings')

function Show-Usage {
    Write-Host 'Usage: .\install.ps1 [options] [modules...]'
    Write-Host ''
    Write-Host 'Modules: rules commands agents hooks plugins docs skills templates settings'
    Write-Host '  If no modules specified, all available modules are installed.'
    Write-Host ''
    Write-Host 'Options:'
    Write-Host '  -f, -Force     Overwrite existing files (default: skip)'
    Write-Host '  -d, -DryRun    Show what would be installed without copying'
    Write-Host '  -h, -Help      Show this help message'
    Write-Host ''
    Write-Host 'Examples:'
    Write-Host '  .\install.ps1                    # Install everything'
    Write-Host '  .\install.ps1 rules              # Install only rules'
    Write-Host '  .\install.ps1 rules commands     # Install rules and commands'
    Write-Host '  .\install.ps1 -Force rules       # Force overwrite rules'
    Write-Host '  .\install.ps1 -DryRun            # Dry run, show what would happen'
}

if ($Help) {
    Show-Usage
    exit 0
}

if (-not $Modules -or $Modules.Count -eq 0) {
    $Modules = @()
    foreach ($mod in $ALL_MODULES) {
        if ($mod -eq 'settings') {
            if (Test-Path -LiteralPath (Join-Path $SCRIPT_DIR '.claude') -PathType Container) {
                $Modules += $mod
            }
        }
        else {
            if (Test-Path -LiteralPath (Join-Path $SCRIPT_DIR $mod) -PathType Container) {
                $Modules += $mod
            }
        }
    }
}

foreach ($mod in $Modules) {
    if ($mod -eq 'settings') {
        if (-not (Test-Path -LiteralPath (Join-Path $SCRIPT_DIR '.claude') -PathType Container)) {
            Write-Host "Module 'settings' not found in repo. Skipping." -ForegroundColor Red
        }
    }
    elseif (-not (Test-Path -LiteralPath (Join-Path $SCRIPT_DIR $mod) -PathType Container)) {
        Write-Host "Module '$mod' not found in repo. Skipping." -ForegroundColor Red
    }
}

$copied = 0
$skipped = 0
$overwritten = 0

function Install-File {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Src,

        [Parameter(Mandatory = $true)]
        [string]$Dest
    )

    if ([System.IO.Path]::GetFileName($Src) -eq '.DS_Store') {
        return
    }

    $destDir = Split-Path -Parent $Dest

    if (Test-Path -LiteralPath $Dest -PathType Leaf) {
        if ($Force) {
            if ($DryRun) {
                Write-Host "  [overwrite] $Dest" -ForegroundColor Yellow
            }
            else {
                New-Item -ItemType Directory -Path $destDir -Force | Out-Null
                Copy-Item -LiteralPath $Src -Destination $Dest -Force
                Write-Host "  [overwrite] $Dest" -ForegroundColor Yellow
            }
            $script:overwritten++
        }
        else {
            Write-Host "  [skip] $Dest (already exists)" -ForegroundColor Cyan
            $script:skipped++
        }
    }
    else {
        if ($DryRun) {
            Write-Host "  [copy] $Dest" -ForegroundColor Green
        }
        else {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
            Copy-Item -LiteralPath $Src -Destination $Dest
            Write-Host "  [copy] $Dest" -ForegroundColor Green
        }
        $script:copied++
    }
}

Write-Host ''
Write-Host 'Claude Helper Installer' -ForegroundColor White
Write-Host "Target: $CLAUDE_HOME" -ForegroundColor Cyan
if ($DryRun) {
    Write-Host '(dry run - no files will be modified)' -ForegroundColor Yellow
}
Write-Host ''

foreach ($mod in $Modules) {
    if ($mod -eq 'settings') {
        $settingsDir = Join-Path $SCRIPT_DIR '.claude'
        if (-not (Test-Path -LiteralPath $settingsDir -PathType Container)) {
            continue
        }

        Write-Host '[settings]' -ForegroundColor White
        Get-ChildItem -LiteralPath $settingsDir -Recurse -File | ForEach-Object {
            $relPath = $_.FullName.Substring($settingsDir.Length + 1)
            $dest = Join-Path $CLAUDE_HOME $relPath
            Install-File -Src $_.FullName -Dest $dest
        }
        Write-Host ''
        continue
    }

    $moduleDir = Join-Path $SCRIPT_DIR $mod
    if (-not (Test-Path -LiteralPath $moduleDir -PathType Container)) {
        continue
    }

    Write-Host "[$mod]" -ForegroundColor White
    Get-ChildItem -LiteralPath $moduleDir -Recurse -File | ForEach-Object {
        $relPath = $_.FullName.Substring($moduleDir.Length + 1)
        $dest = Join-Path (Join-Path $CLAUDE_HOME $mod) $relPath
        Install-File -Src $_.FullName -Dest $dest
    }
    Write-Host ''
}

Write-Host "Done. $copied copied, $skipped skipped, $overwritten overwritten" -ForegroundColor Green
