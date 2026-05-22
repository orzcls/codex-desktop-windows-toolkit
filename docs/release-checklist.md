# Release Checklist

Run these before publishing to GitHub:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tests\run-tests.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\package-release.ps1
git status --short
```

Manual checks:

- README image renders.
- No files under `artifacts/` are staged.
- No live secrets appear in `git diff --cached`.
- The WeChat reference is marked as unverified unless the owner manually supplies the article text.
- License and README references are present.

