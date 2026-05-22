# Windows Codex Desktop Toolkit Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a GitHub-ready Windows Codex Desktop compatibility toolkit for Browser, Computer Use, and durable `/goal` workflows.

**Architecture:** The repo is documentation-first with a small PowerShell tool layer. Local Codex state is never committed; it is exported into gitignored artifacts through redaction scripts.

**Tech Stack:** PowerShell, Markdown, JSON, TOML templates, Harness Engineering, Superpowers process docs.

---

### Task 1: Validation Harness

**Files:**
- Create: `tests/run-tests.ps1`
- Create: `tools/validate-project.ps1`

- [x] **Step 1: Write failing validation test**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tests/run-tests.ps1
```

Expected first failure: `Missing tools\validate-project.ps1`.

- [ ] **Step 2: Implement validator**

Create `tools/validate-project.ps1` to check required files, parse JSON, verify README images, and reject common secret patterns.

- [ ] **Step 3: Run verification**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tests/run-tests.ps1
```

Expected: exit code 0.

### Task 2: Documentation And Templates

**Files:**
- Create: `README.md`
- Create: `docs/browser-runtime.md`
- Create: `docs/computer-use.md`
- Create: `docs/goal-mode.md`
- Create: `docs/security.md`
- Create: `templates/config.codex.toml`
- Create: `templates/browser.config.toml`
- Create: `templates/computer-use.config.json`

- [ ] **Step 1: Document verified local facts**

Use local `.codex` config and bundled skill files as the primary source. Record inaccessible external references in `docs/research/local-sources.md`.

- [ ] **Step 2: Add safe templates**

Only include placeholders for secrets. Do not copy live `config.toml` values.

- [ ] **Step 3: Run validator**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tests/run-tests.ps1
```

Expected: all required docs and templates are present.

### Task 3: Visual Asset

**Files:**
- Create: `assets/readme/codex-windows-toolkit-hero-v2.png`

- [ ] **Step 1: Compile prompt**

Use the GPT-Image2 style-library `infographic-engine` template with Swiss-style constraints from `guizang-ppt-skill`.

- [ ] **Step 2: Generate or fallback-create image**

Use GPTGod when available. If the API is unavailable, generate a deterministic local PNG and document the fallback.

- [ ] **Step 3: Verify README image**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tests/run-tests.ps1
```

Expected: README image reference resolves to an existing file.
