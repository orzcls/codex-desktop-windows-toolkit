# Goal Mode Fallback

## Purpose

Codex Desktop on Windows may expose `/goal` inconsistently across versions or rollouts. This repository uses a project-local fallback so long-running work remains resumable even when the native UI is unavailable.

## State Layout

```text
.codex-goals/windows-codex-desktop-toolkit/
  goal.md
  feature_list.json
  progress.md
  runbook.md
```

## Loop

1. Read `goal.md`, `feature_list.json`, and `progress.md`.
2. Pick the highest-priority unfinished item.
3. Execute a small verified step.
4. Mark only that item's `passes` field from `false` to `true`.
5. Append progress with commands run and remaining work.
6. Run `tests/run-tests.ps1` before claiming completion.

## Native Goal Compatibility

If native `/goal` is available, use it as the outer task container. Keep the project-local files anyway so progress survives session compaction, app restarts, or platform differences.

