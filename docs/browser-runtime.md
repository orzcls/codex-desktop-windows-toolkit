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

## Practical Checks

```powershell
node --version
Get-ChildItem "$env:USERPROFILE\.codex\plugins\cache\openai-bundled\browser" -Recurse -Filter browser-client.mjs
Get-Content "$env:USERPROFILE\.codex\browser\config.toml"
```

For CDP/browser automation, prefer base64 or stdin for complex JavaScript snippets instead of deeply nested shell quoting.

