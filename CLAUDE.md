# codex-desktop-windows-toolkit

> Harness Engineering Framework is enabled for this repository. Codex agents should also read `AGENTS.md` before changing files.

## Project Purpose

This repository packages Windows-side compatibility work for Codex Desktop:

- Computer Use setup and Windows GUI operation rules
- bundled Browser and Chrome/CDP runtime notes
- durable `/goal` fallback state for long-running work
- safe config templates and redaction/export tooling

It is a publishable toolkit, not a backup of `C:\Users\admin\.codex`.

## Commands

| Command | Purpose |
|---------|---------|
| `powershell -NoProfile -ExecutionPolicy Bypass -File init.ps1` | Restore project context |
| `powershell -NoProfile -ExecutionPolicy Bypass -File tests/run-tests.ps1` | Validate repo structure, secrets, README image, and package script |
| `powershell -NoProfile -ExecutionPolicy Bypass -File tools/export-codex-assets.ps1` | Export redacted local Codex evidence to gitignored `artifacts/` |
| `powershell -NoProfile -ExecutionPolicy Bypass -File tools/package-release.ps1` | Create a release zip under gitignored `dist/` |

## Project Structure

```text
AGENTS.md       Codex agent rules
README.md       public project entry point
docs/           operating manuals and release notes
templates/      safe Codex config snippets
tools/          PowerShell utilities
tests/          validation entry point
.codex-goals/   project-local durable goal state
.claude/        Harness Engineering agents, commands, and hooks
```

## Safety Rules

- Do not commit live API keys, auth state, cookies, or Codex SQLite databases.
- Keep local exports in `artifacts/`; it is ignored by Git.
- Keep generated release zips in `dist/`; it is ignored by Git.
- If changing scripts or templates, run `tests/run-tests.ps1` before reporting success.

## Harness Workflow

1. Plan changes in small verified units.
2. Update `feature_list.json` only by changing `passes` after verification.
3. Append progress to `progress.txt` and `.codex-goals/windows-codex-desktop-toolkit/progress.md`.
4. Use the `.claude/` framework only as an optional Plan-Build-Verify layer; Codex instructions in `AGENTS.md` are primary for this repo.

