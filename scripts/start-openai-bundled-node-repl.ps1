$ErrorActionPreference = "Stop"

$chromeRoot = Join-Path $env:USERPROFILE ".codex\plugins\cache\openai-bundled\chrome\latest"
$runtime = Join-Path $chromeRoot "app-server-runtime"
$nodeRepl = Join-Path $runtime "node_repl"
$nodeReplExe = Join-Path $runtime "node_repl.exe"

if (-not (Test-Path -LiteralPath $nodeRepl)) {
  throw "OpenAI bundled Chrome node_repl was not found at $nodeRepl"
}

if (-not (Test-Path -LiteralPath $nodeReplExe)) {
  New-Item -ItemType HardLink -Path $nodeReplExe -Target $nodeRepl | Out-Null
}

if (-not $env:NODE_REPL_NODE_PATH) {
  $env:NODE_REPL_NODE_PATH = Join-Path $runtime "node"
}

& $nodeReplExe --disable-sandbox
exit $LASTEXITCODE
