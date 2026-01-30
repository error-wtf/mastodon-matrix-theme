<#
.SYNOPSIS
    Mastodon Matrix Theme - Rebrand Script (PowerShell)
    Changes "Matrix" branding to your custom instance name

.DESCRIPTION
    This script replaces display text occurrences of "Matrix" with your custom 
    instance name throughout the theme files, while preserving CSS class names.

.PARAMETER NewName
    Your instance name (e.g., "CyberNode", "Errordon")

.EXAMPLE
    .\rebrand.ps1 -NewName "CyberNode"

.EXAMPLE
    .\rebrand.ps1 "Errordon"
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
Write-Host "Rebranding from 'Matrix' to '$NewName'"
Write-Host ""

# Function to replace in file
function Replace-InFile {
    param([string]$FilePath)
    
    if (Test-Path $FilePath) {
        $content = Get-Content $FilePath -Raw -Encoding UTF8
        
        # Replace display text (not CSS classes)
        $content = $content -replace "MATRIX TERMINAL", "$NewNameUpper TERMINAL"
        $content = $content -replace "MATRIX - ", "$NewNameUpper - "
        $content = $content -replace ">MATRIX<", ">$NewNameUpper<"
        $content = $content -replace "WELCOME TO MATRIX", "WELCOME TO $NewNameUpper"
        $content = $content -replace "@matrix:", "@${NewNameLower}:"
        $content = $content -replace "guest@matrix", "guest@$NewNameLower"
        $content = $content -replace "root@matrix", "root@$NewNameLower"
        
        # Replace namespace/module names
        $content = $content -replace "Matrix::", "${NewName}::"
        $content = $content -replace "MATRIX_THEME", "${NewNameUpper}_THEME"
        $content = $content -replace "MATRIX_MATRIX_THEME_ENABLED", "${NewNameUpper}_MATRIX_THEME_ENABLED"
        
        # Replace localStorage keys
        $content = $content -replace "matrix_matrix_theme", "${NewNameLower}_matrix_theme"
        $content = $content -replace "matrix_matrix_color", "${NewNameLower}_matrix_color"
        $content = $content -replace "matrix_matrix_intensity", "${NewNameLower}_matrix_intensity"
        
        # Replace meta tag names
        $content = $content -replace "matrix-matrix-color", "${NewNameLower}-matrix-color"
        
        # Replace console log prefix
        $content = $content -replace "\[Matrix\]", "[$NewName]"
        
        # Replace event names
        $content = $content -replace "matrix:theme-change", "${NewNameLower}:theme-change"
        $content = $content -replace "matrix:color-change", "${NewNameLower}:color-change"
        
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
Replace-InFile "$ScriptDir\rails\initializers\matrix_theme.rb"
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

Write-Host ""
Write-Host "📁 Renaming files..." -ForegroundColor Yellow

# Rename initializer
$OldInitializer = "$ScriptDir\rails\initializers\matrix_theme.rb"
$NewInitializer = "$ScriptDir\rails\initializers\${NewNameLower}_theme.rb"
if (Test-Path $OldInitializer) {
    Move-Item $OldInitializer $NewInitializer -Force
    Write-Host "  ✓ matrix_theme.rb → ${NewNameLower}_theme.rb" -ForegroundColor Cyan
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
