Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$Validate = Join-Path $Root "tools\validate-project.ps1"

function Assert-True {
  param(
    [bool]$Condition,
    [string]$Message
  )
  if (-not $Condition) {
    throw $Message
  }
}

Assert-True (Test-Path -LiteralPath $Validate) "Missing tools\validate-project.ps1"

$output = & $Validate -Root $Root 2>&1
$exit = $LASTEXITCODE
if ($output) {
  $output | ForEach-Object { Write-Host $_ }
}

Assert-True ($exit -eq 0) "validate-project.ps1 exited with $exit"

$Package = Join-Path $Root "tools\package-release.ps1"
Assert-True (Test-Path -LiteralPath $Package) "Missing tools\package-release.ps1"

$packageOut = Join-Path $Root "artifacts\test-package"
$packageOutput = & $Package -Root $Root -OutDir $packageOut 2>&1
$packageExit = $LASTEXITCODE
if ($packageOutput) {
  $packageOutput | ForEach-Object { Write-Host $_ }
}

Assert-True ($packageExit -eq 0) "package-release.ps1 exited with $packageExit"
Assert-True ((Get-ChildItem -LiteralPath $packageOut -Filter "*.zip" -ErrorAction SilentlyContinue | Select-Object -First 1) -ne $null) "package-release.ps1 did not produce a zip"

Write-Host "All project tests passed."
