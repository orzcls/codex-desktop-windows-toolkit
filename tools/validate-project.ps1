[CmdletBinding()]
param(
  [string]$Root = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ScriptRoot = if ($PSScriptRoot) { $PSScriptRoot } elseif ($PSCommandPath) { Split-Path -Parent $PSCommandPath } else { (Get-Location).Path }
if ([string]::IsNullOrWhiteSpace($Root)) {
  $Root = (Resolve-Path -LiteralPath (Join-Path $ScriptRoot "..")).Path
} else {
  $Root = (Resolve-Path -LiteralPath $Root).Path
}
$failures = [System.Collections.Generic.List[string]]::new()

function Add-Failure {
  param([string]$Message)
  $failures.Add($Message) | Out-Null
}

$required = @(
  "README.md",
  "README.en.md",
  "AGENTS.md",
  "LICENSE",
  "feature_list.json",
  "task.json",
  "progress.txt",
  "init.ps1",
  ".codex-goals/windows-codex-desktop-toolkit/goal.md",
  ".codex-goals/windows-codex-desktop-toolkit/feature_list.json",
  ".codex-goals/windows-codex-desktop-toolkit/progress.md",
  ".codex-goals/windows-codex-desktop-toolkit/runbook.md",
  "docs/browser-runtime.md",
  "docs/computer-use.md",
  "docs/goal-mode.md",
  "docs/security.md",
  "docs/release-checklist.md",
  "docs/research/local-sources.md",
  "docs/research/wechat-qoder-computer-use.md",
  "docs/research/image-generation.md",
  "templates/config.codex.toml",
  "templates/browser.config.toml",
  "templates/computer-use.config.json",
  "tools/export-codex-assets.ps1",
  "tools/install-codex-config.ps1",
  "tools/package-release.ps1"
)

foreach ($rel in $required) {
  $path = Join-Path $Root $rel
  if (-not (Test-Path -LiteralPath $path)) {
    Add-Failure "Missing required file: $rel"
  }
}

foreach ($rel in @("feature_list.json", "task.json", ".codex-goals/windows-codex-desktop-toolkit/feature_list.json", "templates/computer-use.config.json")) {
  $path = Join-Path $Root $rel
  if (Test-Path -LiteralPath $path) {
    try {
      Get-Content -Raw -LiteralPath $path | ConvertFrom-Json | Out-Null
    } catch {
      Add-Failure "Invalid JSON: $rel - $($_.Exception.Message)"
    }
  }
}

function Test-ReadmeImages {
  param(
    [string]$Path,
    [string]$Language,
    [string[]]$ForbiddenHeadings
  )

  if (-not (Test-Path -LiteralPath $Path)) {
    Add-Failure "Missing README file: $Language"
    return
  }

  $content = Get-Content -Raw -LiteralPath $Path
  foreach ($heading in $ForbiddenHeadings) {
    if ($content.Contains($heading)) {
      Add-Failure "$Language README still contains mixed-language heading: $heading"
    }
  }

  $targets = New-Object System.Collections.Generic.List[string]
  foreach ($match in [regex]::Matches($content, '!\[[^\]]*\]\(([^)]+)\)')) {
    $targets.Add($match.Groups[1].Value) | Out-Null
  }
  foreach ($match in [regex]::Matches($content, '<img[^>]+src=["'']([^"''>]+)["'']', 'IgnoreCase')) {
    $targets.Add($match.Groups[1].Value) | Out-Null
  }

  $localTargets = @($targets | Where-Object { $_ -notmatch '^(https?://|/|[A-Za-z]:\\)' })
  if ($localTargets.Count -lt 3) {
    Add-Failure "$Language README should reference at least 3 local images; found $($localTargets.Count)"
  }

  foreach ($target in $localTargets) {
    $imagePath = Join-Path $Root $target
    if (-not (Test-Path -LiteralPath $imagePath)) {
      Add-Failure "$Language README image does not exist: $target"
    }
  }
}

Test-ReadmeImages `
  -Path (Join-Path $Root "README.md") `
  -Language "Chinese" `
  -ForbiddenHeadings @(
    "## What It Contains",
    "## Quick Start",
    "## Scope",
    "## Verification",
    "## References"
  )

Test-ReadmeImages `
  -Path (Join-Path $Root "README.en.md") `
  -Language "English" `
  -ForbiddenHeadings @(
    "## 背景",
    "## 设计原则",
    "## 最新功能展示",
    "## 运行时分层",
    "## 长任务状态",
    "## 仓库内容",
    "## 快速开始",
    "## 与文章对应关系",
    "## 安全边界",
    "## 验证与发布",
    "## 适合谁",
    "## 资料来源"
  )

$secretPatterns = @(
  'sk-[A-Za-z0-9_\-]{20,}',
  'AIza[0-9A-Za-z_\-]{20,}',
  'ghp_[0-9A-Za-z_]{20,}',
  'xox[baprs]-[0-9A-Za-z\-]{20,}',
  '-----BEGIN [A-Z ]*PRIVATE KEY-----'
)

$textExtensions = @(".md", ".ps1", ".json", ".toml", ".txt", ".yml", ".yaml", ".sh")
$files = Get-ChildItem -LiteralPath $Root -Recurse -Force -File |
  Where-Object {
    $_.FullName -notmatch '\\\.git\\' -and
    $_.FullName -notmatch '\\artifacts\\' -and
    $_.FullName -notmatch '\\dist\\' -and
    $textExtensions -contains $_.Extension
  }

foreach ($file in $files) {
  $raw = Get-Content -Raw -LiteralPath $file.FullName
  foreach ($pattern in $secretPatterns) {
    if ($raw -match $pattern) {
      Add-Failure "Possible secret in $($file.FullName.Substring($Root.Length + 1)): $pattern"
    }
  }
}

if ($failures.Count -gt 0) {
  Write-Host "Validation failed:" -ForegroundColor Red
  foreach ($failure in $failures) {
    Write-Host " - $failure" -ForegroundColor Red
  }
  exit 1
}

Write-Host "Validation passed for $Root" -ForegroundColor Green
exit 0
