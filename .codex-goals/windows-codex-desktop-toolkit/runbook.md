# Runbook

## Resume

```powershell
cd C:\Users\admin\Desktop\test
powershell -NoProfile -ExecutionPolicy Bypass -File .\init.ps1
Get-Content .\.codex-goals\windows-codex-desktop-toolkit\progress.md -Tail 40
```

## Validate

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tests\run-tests.ps1
```

## Package

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\package-release.ps1
```

