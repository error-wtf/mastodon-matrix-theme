<#
.SYNOPSIS
    Mastodon Matrix Theme - Rebrand Script (PowerShell)
    Changes "Errordon" branding to your custom name

.DESCRIPTION
    This script replaces all occurrences of "Errordon", "errordon", and "ERRORDON"
    with your custom instance name throughout the theme files.

.PARAMETER NewName
    Your instance name (e.g., "CyberNode", "MatrixHub")

.EXAMPLE
    .\rebrand.ps1 -NewName "CyberNode"

.EXAMPLE
    .\rebrand.ps1 "MatrixHub"
#>

param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$NewName
)

$ErrorActionPreference = "Stop"

# Generate name variations
$NewNameLower = $NewName.ToLower()
$NewNameUpper = $NewName.ToUpper()

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "🎨 Mastodon Matrix Theme - Rebrand Script" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Rebranding from 'Errordon' to '$NewName'"
Write-Host ""

# Function to replace in file
function Replace-InFile {
    param([string]$FilePath)
    
    if (Test-Path $FilePath) {
        $content = Get-Content $FilePath -Raw -Encoding UTF8
        
        # Replace variations
        $content = $content -replace "ERRORDON", $NewNameUpper
        $content = $content -replace "Errordon", $NewName
        $content = $content -replace "errordon", $NewNameLower
        
        Set-Content -Path $FilePath -Value $content -Encoding UTF8 -NoNewline
        Write-Host "  ✓ $FilePath" -ForegroundColor Cyan
    }
}

Write-Host "📝 Updating files..." -ForegroundColor Yellow

# JavaScript files
Replace-InFile "$ScriptDir\js\matrix_rain.js"
Replace-InFile "$ScriptDir\js\matrix_theme.ts"
Replace-InFile "$ScriptDir\js\matrix_background.js"

# SCSS
Replace-InFile "$ScriptDir\styles\matrix_theme.scss"
Replace-InFile "$ScriptDir\styles\matrix_theme_standalone.scss"

# Terminal
Replace-InFile "$ScriptDir\terminal\index.html"
Replace-InFile "$ScriptDir\terminal\main.js"

# Rails
Replace-InFile "$ScriptDir\rails\initializers\errordon_theme.rb"
Replace-InFile "$ScriptDir\rails\views\application_layout_snippet.haml"
Replace-InFile "$ScriptDir\rails\entrypoints\common.ts"
Replace-InFile "$ScriptDir\rails\styles\common.scss.snippet"
Replace-InFile "$ScriptDir\rails\config\themes.yml.example"
Replace-InFile "$ScriptDir\rails\routes\matrix_routes.rb"

# Deploy
Replace-InFile "$ScriptDir\deploy\nginx.conf"
Replace-InFile "$ScriptDir\deploy\mastodon-matrix.service"

# Install script
Replace-InFile "$ScriptDir\install.sh"

# Documentation
Replace-InFile "$ScriptDir\README.md"
Replace-InFile "$ScriptDir\docs\FRONTEND_MAP_MATRIX_AND_STYLES.md"

Write-Host ""
Write-Host "📁 Renaming files..." -ForegroundColor Yellow

# Rename initializer
$OldInitializer = "$ScriptDir\rails\initializers\errordon_theme.rb"
$NewInitializer = "$ScriptDir\rails\initializers\${NewNameLower}_theme.rb"
if (Test-Path $OldInitializer) {
    Move-Item $OldInitializer $NewInitializer -Force
    Write-Host "  ✓ errordon_theme.rb → ${NewNameLower}_theme.rb" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "✅ Rebranding complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Review changes: Select-String -Path '.\*' -Pattern '$NewNameLower' -Recurse"
Write-Host "2. Update install.sh paths if needed"
Write-Host "3. Run: ./install.sh /path/to/mastodon"
Write-Host ""
Write-Host "Remember to update your .env.production:" -ForegroundColor Yellow
Write-Host "  ${NewNameUpper}_MATRIX_THEME_ENABLED=true"
Write-Host "  ${NewNameUpper}_THEME=matrix"
