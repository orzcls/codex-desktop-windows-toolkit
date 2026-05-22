# Security And Redaction

## Do Not Commit

- API keys, OAuth tokens, browser auth state, cookies, or saved sessions
- `auth.json`, `.credentials.json`, `history.jsonl`
- Codex SQLite databases and WAL/SHM files
- Raw `config.toml` files containing real environment values
- Screenshots containing private desktop content

## Safe Pattern

Use tracked templates with placeholders:

```toml
env = { API_KEY = "<YOUR_API_KEY>" }
```

Keep real values in environment variables or the user's private Codex config.

## Export Policy

`tools/export-codex-assets.ps1` writes to `artifacts/local-codex-export/`. That directory is gitignored. Review exports manually before publishing any subset.

## Validation

`tools/validate-project.ps1` scans tracked text files for common secret patterns. It is a guardrail, not a guarantee. Manual review is still required before pushing to GitHub.

