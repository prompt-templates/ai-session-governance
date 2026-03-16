# QA Regression Report

Date: 2026-03-16 (UTC)
Scope: CODEBASE_CONTEXT + External API Code Safety + PROJECT_MASTER_SPEC active trigger + §3d Test Plan Design additions; full regression of all prior checks

## Summary

- Total checks: 51
- Pass: 51
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

## Feature round 2 (2026-03-16): CODEBASE_CONTEXT + External API Code Safety + §10 active trigger

| Check | Result |
|---|---|
| (30) External API Code Safety subsection present in AGENTS.md §0b | PASS |
| (31) External API Code Safety subsection present in INIT.md FILE 1 §0b | PASS |
| (32) Doc-reviewed field defined in block format (both files) | PASS |
| (33) Test-verified field defined in block format (both files) | PASS |
| (34) Verification ritual (4 steps) present | PASS |
| (35) Staleness / re-verification rules (5 items) present | PASS |
| (36) "Cannot fetch docs → do not write code" rule present | PASS |
| (37) AGENTS.md / INIT.md parity for §0b key term count | PASS |
| (38) §1 startup sequence order unchanged (HANDOFF → LOG → CODEBASE_CONTEXT → MASTER_SPEC) | PASS |
| (39) §10 intent-based trigger present (not mechanical session count) | PASS |
| (40) §5a + INIT.md backup lists include CODEBASE_CONTEXT (AGENTS: 1, INIT: 2) | PASS |
| (41) Fence counts even (AGENTS.md: 16, INIT.md: 26) | PASS |
| (42) No "key architectural" terminology residue | PASS |

## Feature round 3 (2026-03-16): §3d Test Plan Design governance

| Check | Result |
|---|---|
| (43) §3d Test Plan Design heading present in AGENTS.md | PASS |
| (44) §3d Test Plan Design heading present in INIT.md FILE 1 | PASS |
| (45) §3 PLAN bullet references `test scenario matrix` in AGENTS.md (≥1) | PASS |
| (46) §3 PLAN bullet references `test scenario matrix` in INIT.md (≥1) | PASS |
| (47) §3 QC bullet: `verify each scenario` present in AGENTS.md | PASS |
| (48) §3 QC bullet: `verify each scenario` present in INIT.md | PASS |
| (49) §3d `Result values: PASS, PASS with notes` note present in AGENTS.md + INIT.md (1 each) | PASS |
| (50) `### Test Scenarios (if §3d applies)` template present in INIT.md | PASS |
| (51) `### Test Scenarios (if §3d applies)` template present in `dev/SESSION_LOG.md` | PASS |

## Notes

- This report validates document and governance consistency at repository level.
- It does not execute external platform runtime integration tests.
- Feature round 2 adds: CODEBASE_CONTEXT governance integration, External API Code Safety §0b subsection, PROJECT_MASTER_SPEC §10 intent-based active trigger with filename enforcement.
- Feature round 3 adds: §3d Test Plan Design conditional subsection (4 trigger conditions, 4 scenario categories, project-type adaptations, table format, recording location rules).

## Manual governance checks (cannot be automated with grep)

These require human or live-session verification:

| Check | Type | Notes |
|---|---|---|
| §10 suppression: if SESSION_HANDOFF contains "PROJECT_MASTER_SPEC suggestion issued: [session ID] [date]", AI must NOT re-suggest in subsequent sessions unless new arch decisions were made | Behavioral | Verify in live session after §10 suggestion is issued |
| §0b step 0: if CODEBASE_CONTEXT does not exist, AI generates it before recording External Services | Behavioral | Verify in first-session scenario with API-calling code |
| §1 generation scan: AI scans README → docs/ARCHITECTURE → package manifests without modifying source files | Behavioral | Verify in first-session scenario |
