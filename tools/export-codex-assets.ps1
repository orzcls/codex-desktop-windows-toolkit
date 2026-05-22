[CmdletBinding()]
param(
  [string]$CodexHome = (Join-Path $env:USERPROFILE ".codex"),
  [string]$OutDir = (Join-Path (Split-Path -Parent $PSScriptRoot) "artifacts/local-codex-export")
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Redact-Content {
  param([string]$Content)
  $Content = $Content -replace 'sk-[A-Za-z0-9_\-]{20,}', '<REDACTED_OPENAI_KEY>'
  $Content = $Content -replace 'AIza[0-9A-Za-z_\-]{20,}', '<REDACTED_GOOGLE_KEY>'
  $Content = $Content -replace 'ghp_[0-9A-Za-z_]{20,}', '<REDACTED_GITHUB_TOKEN>'
  $Content = $Content -replace 'xox[baprs]-[0-9A-Za-z\-]{20,}', '<REDACTED_SLACK_TOKEN>'
  $Content = $Content -replace '(?i)(api[_-]?key\s*=\s*")[^"]+(")', '$1<REDACTED>$2'
  return $Content
}

function Copy-RedactedText {
  param(
    [string]$Source,
    [string]$Destination
  )
  if (-not (Test-Path -LiteralPath $Source)) {
    return $false
  }
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Destination) | Out-Null
  $content = Get-Content -Raw -LiteralPath $Source
  Set-Content -LiteralPath $Destination -Encoding UTF8 -Value (Redact-Content $content)
  return $true
}

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$manifest = [ordered]@{
  exportedAt = (Get-Date).ToString("o")
  codexHome = $CodexHome
  files = @()
  note = "Export is redacted and written to gitignored artifacts/. Review manually before publishing."
}

$targets = @(
  @{ Source = "config.toml"; Destination = "config.redacted.toml" },
  @{ Source = "browser/config.toml"; Destination = "browser/config.toml" },
  @{ Source = "computer-use/config.json"; Destination = "computer-use/config.json" },
  @{ Source = "AGENTS.md"; Destination = "AGENTS.md" }
)

foreach ($target in $targets) {
  $source = Join-Path $CodexHome $target.Source
  $dest = Join-Path $OutDir $target.Destination
  if (Copy-RedactedText -Source $source -Destination $dest) {
    $manifest.files += $target.Destination
  }
}

$manifestPath = Join-Path $OutDir "manifest.json"
$manifest | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $manifestPath -Encoding UTF8
Write-Host "Exported redacted Codex assets to $OutDir"

