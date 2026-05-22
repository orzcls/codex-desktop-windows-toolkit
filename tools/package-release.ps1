[CmdletBinding()]
param(
  [string]$Root = "",
  [string]$OutDir = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ScriptRoot = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $PSCommandPath }
if ([string]::IsNullOrWhiteSpace($Root)) {
  $Root = (Resolve-Path (Join-Path $ScriptRoot "..")).Path
}
$Root = (Resolve-Path -LiteralPath $Root).Path
if ([string]::IsNullOrWhiteSpace($OutDir)) {
  $OutDir = Join-Path $Root "dist"
}
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

& (Join-Path $Root "tools/validate-project.ps1") -Root $Root
if ($LASTEXITCODE -ne 0) {
  throw "Validation failed."
}

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$zip = Join-Path $OutDir "codex-desktop-windows-toolkit-$stamp.zip"

$files = Get-ChildItem -LiteralPath $Root -Recurse -Force -File | Where-Object {
  $rel = $_.FullName.Substring($Root.Length + 1)
  -not (
    $rel -like ".git\*" -or
    $rel -like "artifacts\*" -or
    $rel -like "dist\*"
  )
}

$temp = Join-Path $env:TEMP "codex-windows-toolkit-$stamp"
if (Test-Path -LiteralPath $temp) {
  try {
    Remove-Item -LiteralPath $temp -Recurse -Force
  } catch {
    Write-Warning "Could not clear existing temp directory $temp; continuing with a fresh path."
  }
}
New-Item -ItemType Directory -Force -Path $temp | Out-Null

foreach ($file in $files) {
  $rel = $file.FullName.Substring($Root.Length + 1)
  $dest = Join-Path $temp $rel
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dest) | Out-Null
  Copy-Item -LiteralPath $file.FullName -Destination $dest
}

Compress-Archive -Path (Join-Path $temp "*") -DestinationPath $zip -Force
try {
  Remove-Item -LiteralPath $temp -Recurse -Force
} catch {
  Write-Warning "Could not remove temp directory $temp after packaging."
}
Write-Host "Package written: $zip"
exit 0
