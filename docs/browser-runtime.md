# Browser Runtime Guide

## Verified Local Surfaces

The local Codex configuration enables both bundled browser surfaces:

- `browser@openai-bundled`: in-app browser for localhost, file-backed previews, screenshots, and frontend verification.
- `chrome@openai-bundled`: Chrome/profile-dependent workflows.

The Qoder-style reference surface is `agent-browser`, a CDP-backed CLI with persistent sessions, snapshots, refs, screenshots, auth state, and optional streaming dashboard. This project treats it as a design reference, not as a bundled dependency.

## Preferred Order

1. Use the bundled Browser plugin for local apps and file previews.
2. Use Chrome/CDP when login state or the user's real Chrome profile is required.
3. Use `agent-browser` style workflows when you need a standalone CLI abstraction with snapshot refs and batch execution.
4. Use Computer Use only when the web workflow requires native UI or visual desktop interactions.

## Windows Failure Modes

- Node runtime not on PATH or too old for browser helper scripts.
- Plugin cache exists but Codex cannot resolve the bundled script path.
- Chrome remote debugging port is running, but the authorization handshake times out.
- Shell quoting corrupts JavaScript passed to browser eval commands.
- The Chrome plugin updates, but the MCP entry still points at an older `node_repl.exe`.

## Practical Checks

```powershell
node --version
Get-ChildItem "$env:USERPROFILE\.codex\plugins\cache\openai-bundled\browser" -Recurse -Filter browser-client.mjs
Get-Content "$env:USERPROFILE\.codex\browser\config.toml"
```

For CDP/browser automation, prefer base64 or stdin for complex JavaScript snippets instead of deeply nested shell quoting.

## Chrome Plugin Node REPL Launcher

Recent Chrome plugin builds ship the runtime under:

```text
%USERPROFILE%\.codex\plugins\cache\openai-bundled\chrome\latest\app-server-runtime
```

The project template registers `mcp_servers.node_repl` through `scripts/start-openai-bundled-node-repl.ps1`. The launcher follows the `latest` plugin junction, checks whether `node_repl.exe` exists, creates a hardlink to the extensionless `node_repl` binary when needed, and starts the matching runtime with `--disable-sandbox`.

The matching template also sets:

- `NODE_REPL_NODE_PATH` to the bundled Chrome runtime node executable.
- `NODE_REPL_TRUSTED_CODE_PATHS` to the bundled Chrome and in-app Browser script directories.

That combination lets `browser-client.mjs` load with native pipe access after a plugin update. If the current Codex thread was already running before the config was changed, restart Codex Desktop and open a new thread so the MCP tool table can be rebuilt.
