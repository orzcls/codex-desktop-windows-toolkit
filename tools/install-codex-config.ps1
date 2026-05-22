[CmdletBinding(SupportsShouldProcess)]
param(
  [string]$CodexHome = (Join-Path $env:USERPROFILE ".codex"),
  [switch]$Apply
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$template = Join-Path $Root "templates/config.codex.toml"
$launcher = Join-Path $Root "scripts/start-openai-bundled-node-repl.ps1"
$target = Join-Path $CodexHome "config.toml"
$launcherTarget = Join-Path $CodexHome "scripts/start-openai-bundled-node-repl.ps1"

if (-not (Test-Path -LiteralPath $template)) {
  throw "Missing template: $template"
}
if (-not (Test-Path -LiteralPath $launcher)) {
  throw "Missing launcher: $launcher"
}

Write-Host "Template: $template"
Write-Host "Target:   $target"
Write-Host "Launcher: $launcherTarget"

if (-not $Apply) {
  Write-Host "Dry run only. Re-run with -Apply after reviewing the rendered template and launcher path."
  exit 0
}

if (-not (Test-Path -LiteralPath $CodexHome)) {
  New-Item -ItemType Directory -Force -Path $CodexHome | Out-Null
}
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $launcherTarget) | Out-Null

if (Test-Path -LiteralPath $target) {
  $backup = "$target.bak-windows-toolkit-$(Get-Date -Format yyyyMMddHHmmss)"
  Copy-Item -LiteralPath $target -Destination $backup
  Write-Host "Backup written: $backup"
}

$escapedProfile = $env:USERPROFILE.Replace("\", "\\")
$rendered = (Get-Content -Raw -LiteralPath $template).Replace("C:\\Users\\<YOU>", $escapedProfile)
Set-Content -LiteralPath $target -Value $rendered -Encoding UTF8
Copy-Item -LiteralPath $launcher -Destination $launcherTarget -Force
Write-Host "Installed rendered template config and bundled node_repl launcher."
