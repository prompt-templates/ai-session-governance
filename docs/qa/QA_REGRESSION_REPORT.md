# QA Regression Report

Date: 2026-03-02 (UTC)  
Scope: Governance-flow updates for startup seed context + closeout verbatim persistence + backup/install/readme consistency

## Summary

- Total checks: 29
- Pass: 29
- Fail: 0

## What was validated

1. Governance rule integrity (`AGENTS.md`, `INIT.md`)
- Startup must read latest `Next Session Handoff Prompt (Verbatim)` from `SESSION_LOG.md` as plan seed context.
- Closeout must persist Section 2 handoff block verbatim back into `SESSION_LOG.md`.
- Duplicate verbatim subsection behavior must replace existing block (no append duplication).
- Backup snapshot rule remains present and cross-platform (`dev/init_backup/<YYYYMMDD_HHMMSS_UTC>/`, no git required).

2. Bootstrap template integrity (`INIT.md`)
- Embedded `SESSION_LOG.md` template includes `### Next Session Handoff Prompt (Verbatim)` section.
- Post-install confirmation requirements include backup snapshot reporting.

3. Multilingual README consistency
- EN / zh-TW / zh-CN / JA all include:
  - install backup step (`init_backup`)
  - runtime screenshots (`launch.png`, `closesession.png`)
  - language-localized overview infographic (`overview_infograph_en/tw/cn/ja.png`)
- No stale `overview_infograph.png` reference remains in README files.

4. Asset and markdown structure checks
- All referenced image assets exist and are non-zero size.
- Markdown code-fence counts are even in `AGENTS.md` and `INIT.md`.

## Result matrix

| Area | Result |
|---|---|
| AGENTS startup seed rule present | PASS |
| INIT startup seed rule present | PASS |
| AGENTS closeout persistence rules (12-14) | PASS |
| INIT closeout persistence rules (12-14) | PASS |
| INIT template includes verbatim handoff subsection | PASS |
| Backup snapshot rule parity (AGENTS/INIT) | PASS |
| README EN overview localization | PASS |
| README zh-TW overview localization | PASS |
| README zh-CN overview localization | PASS |
| README JA overview localization | PASS |
| README install backup-step mention (all 4 languages) | PASS |
| README runtime snapshot links (all 4 languages) | PASS |
| No stale overview image reference in README | PASS |
| Referenced image assets exist and non-zero | PASS |
| Markdown fence sanity (`AGENTS.md`, `INIT.md`) | PASS |

## Notes

- This report validates document and governance consistency at repository level.
- It does not execute external platform runtime integration tests.
