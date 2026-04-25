# Codebase Context

## Stack
- Language: Markdown, Bash, Python
- Framework: N/A (governance template repository)
- Key libs/tools: `bash`, `python`, `ripgrep`, `git`
- Package manager: N/A (no project package manifest detected)
- Runtime/version notes: CLI-oriented governance for Codex / Claude Code / Gemini CLI

## Directory Map
- Root governance/install files: `AGENTS.md`, `INIT.md`, `CLAUDE.md`, `GEMINI.md`
- Runtime session state: `dev/SESSION_HANDOFF.md`, `dev/SESSION_LOG.md`, `dev/archive/`
- Doc sync registry: `dev/DOC_SYNC_CHECKLIST.md`
- QA tooling: `docs/qa/run_checks.sh`, `docs/qa/session_log_maintenance.py`, `docs/qa/*.md`
- Design/implementation plans: `docs/plans/*.md`
- Reference assets: `ref_doc/*.png` and related media

## Key Entry Points
- Primary SSOT for governance behavior: `AGENTS.md`
- Bootstrap/install orchestration: `INIT.md`
- Regression harness: `docs/qa/run_checks.sh`
- Session-log archive maintenance gate: `docs/qa/session_log_maintenance.py`
- Operator-facing overview: `README.md` + localized README variants

## Build & Run
- Session startup command (operator): `Follow AGENTS.md`
- Full QA regression: `bash docs/qa/run_checks.sh`
- Session log trigger check: `python docs/qa/session_log_maintenance.py --check --session-log dev/SESSION_LOG.md`
- Session log archive apply: `python docs/qa/session_log_maintenance.py --apply --session-log dev/SESSION_LOG.md --archive-dir dev/archive`
- Session log matrix self-test: `python docs/qa/session_log_maintenance.py --self-test`

## External Services
### GitHub Repository / Release Hosting
- Base URL: `https://github.com/prompt-templates/ai-session-governance`
- Versioning/release channel: Git tags + GitHub Releases
- Auth: Repository-dependent (public read assumed for current URLs)
- Required params: N/A (documentation/release hosting usage only in this repo)
- Forbidden params: N/A
- Response path: N/A
- Official docs: `https://docs.github.com/`
- Doc-reviewed: 2026-04-19 (Codex_20260419_1533)
- Test-verified: 2026-04-18 release URL recorded in SESSION_LOG
- Notes: README and SESSION_LOG reference GitHub release links.

### GitHub Pages (Interactive Introduction)
- Base URL: `https://prompt-templates.github.io/ai-session-governance/`
- Version: N/A
- Auth: Public
- Required params: optional `lang` query in localized links
- Forbidden params: N/A
- Response path: N/A
- Official docs: `https://docs.github.com/en/pages`
- Doc-reviewed: 2026-04-19 (Codex_20260419_1533)
- Test-verified: not executed in this session (network restricted)
- Notes: Linked from all README variants as onboarding page.

## Key Decisions
- `AGENTS.md` is governance SSOT; `CLAUDE.md` / `GEMINI.md` are pointers.
- Startup sequence is mandatory and includes `SESSION_HANDOFF -> SESSION_LOG -> CODEBASE_CONTEXT -> PROJECT_MASTER_SPEC`.
- `SESSION_LOG` long-term growth is controlled by executable maintenance gate (`session_log_maintenance.py`) instead of reminder-only policy.
- Handoff compactness is governed by explicit budget caps in `AGENTS.md` §4.

## AI Maintenance Log
- Created: 2026-04-19 (Codex_20260419_1533)
- Last updated: 2026-04-19 (Codex_20260419_1533)
- Change summary: First-time generation because `dev/CODEBASE_CONTEXT.md` was missing at startup.
- Source files scanned (present):
  - `README.md`
  - `README.zh-TW.md`
  - `README.zh-CN.md`
  - `README.ja.md`
  - `docs/VERIFICATION.md`
  - `docs/qa/LATEST.md`
  - `docs/qa/QA_REGRESSION_REPORT.md`
  - `docs/plans/2026-04-14-harness-optimization.md`
  - `docs/plans/2026-04-08-governance-audit-fixes.md`
  - `docs/plans/2026-03-26-doc-sync-checklist.md`
  - `docs/plans/2026-03-24-governance-gap-fixes.md`
  - `docs/plans/2026-03-16-test-plan-governance-impl.md`
  - `docs/plans/2026-03-16-external-api-safety-impl.md`
  - `docs/plans/2026-03-16-external-api-safety-design.md`
  - `docs/plans/2026-03-16-codebase-context-impl.md`
  - `docs/plans/2026-03-16-codebase-context-design.md`
- Scan patterns with no matching files:
  - `CONTRIBUTING.md`, `DEVELOPMENT.md`
  - `package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`, `Gemfile`, `requirements.txt`, `composer.json`
  - `.env.example`, `docker-compose*.yml`, `docker-compose*.yaml`, root/config `*.yml`/`*.yaml`
