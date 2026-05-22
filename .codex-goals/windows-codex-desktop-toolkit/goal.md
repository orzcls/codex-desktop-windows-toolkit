# Windows Codex Desktop Toolkit Goal

## Objective

Package the Windows Codex Desktop compatibility work for Computer Use, bundled Browser/Chrome browser automation, and `/goal` fallback workflows into `C:\Users\admin\Desktop\test` as a GitHub-ready engineering project.

## Constraints

- Do not create redundant files under `C:\Users\admin\.codex`.
- Do not commit live credentials, auth state, Codex SQLite databases, browser state, or raw session exports.
- Keep local exports under `artifacts/`, which is gitignored.
- Preserve the distinction between verified local facts and inaccessible external references.

## Success Criteria

- README explains purpose, quick start, scope, verification, and references.
- Docs cover Browser, Computer Use, Goal Mode, security, and release.
- PowerShell tools can validate and package the repo.
- README visual asset exists and resolves.
- `tests/run-tests.ps1` exits 0.

## Verification Commands

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tests/run-tests.ps1
git status --short
```

