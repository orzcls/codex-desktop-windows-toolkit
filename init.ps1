Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$FeatureList = Join-Path $Root "feature_list.json"
$Progress = Join-Path $Root "progress.txt"

Write-Host "Codex Desktop Windows Toolkit"
Write-Host "Root: $Root"

if (Test-Path -LiteralPath $FeatureList) {
  $data = Get-Content -Raw -LiteralPath $FeatureList | ConvertFrom-Json
  $total = @($data.features).Count
  $done = @($data.features | Where-Object { $_.passes -eq $true }).Count
  Write-Host "Features: $done / $total complete"
  $next = $data.features | Where-Object { $_.passes -ne $true } | Sort-Object priority | Select-Object -First 1
  if ($next) {
    Write-Host "Next: $($next.id) - $($next.description)"
  }
}

if (Test-Path -LiteralPath $Progress) {
  Write-Host ""
  Write-Host "Recent progress:"
  Get-Content -LiteralPath $Progress -Tail 12
}

