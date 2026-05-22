[CmdletBinding(SupportsShouldProcess)]
param(
  [string]$CodexHome = (Join-Path $env:USERPROFILE ".codex"),
  [switch]$Apply
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$template = Join-Path $Root "templates/config.codex.toml"
$target = Join-Path $CodexHome "config.toml"

if (-not (Test-Path -LiteralPath $template)) {
  throw "Missing template: $template"
}

Write-Host "Template: $template"
Write-Host "Target:   $target"

if (-not $Apply) {
  Write-Host "Dry run only. Re-run with -Apply after manually reviewing the template."
  exit 0
}

if (-not (Test-Path -LiteralPath $CodexHome)) {
  New-Item -ItemType Directory -Force -Path $CodexHome | Out-Null
}

if (Test-Path -LiteralPath $target) {
  $backup = "$target.bak-windows-toolkit-$(Get-Date -Format yyyyMMddHHmmss)"
  Copy-Item -LiteralPath $target -Destination $backup
  Write-Host "Backup written: $backup"
}

Copy-Item -LiteralPath $template -Destination $target
Write-Host "Installed template config. Add private env values manually before relying on MCP servers."

