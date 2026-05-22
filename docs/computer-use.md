# Computer Use Windows Guide

## Local State

The local Computer Use config is small and UI-oriented:

```json
{
  "accentColor": "#458588",
  "direction": "ltr",
  "locale": "zh-CN"
}
```

The bundled Computer Use skill emphasizes Windows GUI automation through screenshot-first operation, normalized coordinates, multi-display awareness, and action-wait-verify loops.

## Decision Rule

Use Computer Use only when a more structured surface is unavailable:

1. File, code, Git, and shell tools
2. MCP/API tools
3. Browser tools
4. Computer Use for native Windows UI and GUI-only flows

## Windows Recipes

- Launch GUI apps with `Start-Process` rather than foreground commands that block the shell.
- Take a screenshot before clicking.
- Use coordinates from the latest screenshot only.
- After each action, inspect the returned screenshot before continuing.
- For CJK text, verify input method before typing commands, URLs, or code.

## Release Boundary

This repo documents Computer Use setup and workflow choices. It does not include private screen captures or user desktop state.

