# AGENTS.md

## Project Role

This repository packages a Windows-focused Codex Desktop compatibility toolkit. Treat it as a release-ready engineering project, not as a dump of a local `.codex` directory.

## Operating Rules

- Keep generated and exported runtime state under `artifacts/` only. It is gitignored by design.
- Do not copy live API keys, auth files, browser states, SQLite logs, or session databases into tracked files.
- Prefer PowerShell scripts for Windows checks and installers.
- When changing templates or scripts, run `powershell -NoProfile -ExecutionPolicy Bypass -File tests/run-tests.ps1`.
- For long-running work, update `.codex-goals/windows-codex-desktop-toolkit/progress.md` and `progress.txt`.
- Keep README images in `assets/readme/` and verify referenced files exist before claiming release readiness.

## Task Management System

1. Run `powershell -NoProfile -ExecutionPolicy Bypass -File init.ps1` at the start of a new session.
2. Read `feature_list.json`, `task.json`, and `progress.txt`.
3. Pick the highest-priority feature with `"passes": false`.
4. Implement and verify one feature at a time.
5. Only change a feature's `passes` field from `false` to `true` after verification.
6. Append a dated progress entry before ending the session.

## Safety

The repository may document local paths for reproducibility, but tracked files must not contain live secrets. Use placeholders such as `<YOUR_API_KEY>` and keep real credentials in user environment variables.

