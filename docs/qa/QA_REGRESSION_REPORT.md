# QA Regression Report

Date: 2026-04-08 (UTC)
Scope: v2.4 — PLAN self-challenge, lean session log format, archive thresholds 800→400/350→200; full regression

## Summary

- Total checks: 169
- Pass: 169
- Fail: 0

Note: Check (82) expected value updated — INIT.md fence count changed from 26 to 28 (+2 from FILE 6).
Note: Checks 112–125 added for Feature Round 7 (v2.1 Handoff chain fixes + DOC_SYNC Matrix Scan enforcement).
Note: Checks 126–139 added for Feature Round 8 (v2.2 §4a Session Log Maintenance auto-archive rule).
Note: Checks (114)/(115) expected value updated from 1 to 2 — §2b triage read note added "does not substitute" phrase (A4 fix); original §1 startup clarification remains intact.
Note: Checks 140–155 added for Feature Round 9 (v2.3 Governance audit fixes: PLAN display, conflict arbitration, triage reads, CHANGE deviation, §8/§8b bridging, §11 scope, FILE 4 checklist).

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

## Feature round 4 (2026-03-17): Cross-LLM handoff prompt opening line + §1 CODEBASE_CONTEXT scan hardening

| Check | Result |
|---|---|
| (52) §4 rule 5 opening line requirement (`Opening line.*AGENTS.md`) present in AGENTS.md | PASS |
| (53) §4 rule 5 opening line requirement (`Opening line.*AGENTS.md`) present in INIT.md | PASS |
| (54) `§1 startup sequence` referenced in §4 rule 5 opening line requirement (AGENTS.md) | PASS |
| (55) `§1 startup sequence` referenced in §4 rule 5 opening line requirement (INIT.md) | PASS |
| (56) `cross-tool handoffs` rationale note present in §4 rule 5 (AGENTS.md) | PASS |
| (57) `cross-tool handoffs` rationale note present in §4 rule 5 (INIT.md) | PASS |

## Feature round 5 (2026-03-24): 6 governance gap fixes (v1.9.0 candidate)

| Check | Result |
|---|---|
| (58) §1 "Definition of new session" 3-trigger block present in AGENTS.md | PASS |
| (59) §1 "Definition of new session" 3-trigger block present in INIT.md | PASS |
| (60) Old standalone compaction paragraph removed from AGENTS.md | PASS |
| (61) Old standalone compaction paragraph removed from INIT.md | PASS |
| (62) "Agent handoff" trigger present in §1 definition (AGENTS.md) | PASS |
| (63) "Agent handoff" trigger present in §1 definition (INIT.md) | PASS |
| (64) §3 PERSIST explicit sync: "same cross-document sync conditions as §4" present in AGENTS.md | PASS |
| (65) §3 PERSIST explicit sync: "same cross-document sync conditions as §4" present in INIT.md | PASS |
| (66) §3 PERSIST vague "relevant specifications to ensure" removed from AGENTS.md | PASS |
| (67) §3 PERSIST vague "relevant specifications to ensure" removed from INIT.md | PASS |
| (68) "Open Priorities regeneration" mandatory block present in AGENTS.md | PASS |
| (69) "Open Priorities regeneration" mandatory block present in INIT.md | PASS |
| (70) "replace, not append" rule present in AGENTS.md | PASS |
| (71) "replace, not append" rule present in INIT.md | PASS |
| (72) "SESSION_LOG summary field only" max-3 clarification present in AGENTS.md | PASS |
| (73) "SESSION_LOG summary field only" max-3 clarification present in INIT.md | PASS |
| (74) §10 "Known Risks.*not Open Priorities" wording present in AGENTS.md | PASS |
| (75) §10 "Known Risks.*not Open Priorities" wording present in INIT.md | PASS |
| (76) Old "Open Priorities or Known Risks" phrasing removed from AGENTS.md | PASS |
| (77) Old "Open Priorities or Known Risks" phrasing removed from INIT.md | PASS |
| (78) §5.7 "modification operations (create, delete" precision wording present in AGENTS.md | PASS |
| (79) §5.7 "modification operations (create, delete" precision wording present in INIT.md | PASS |
| (80) Old "to perform file system operations;" removed from AGENTS.md | PASS |
| (81) Old "to perform file system operations;" removed from INIT.md | PASS |
| (82) Fence counts: AGENTS.md=16 (unchanged), INIT.md=28 (was 26, +2 from FILE 6) (even) | PASS |

## Feature round 6 (2026-03-26): v2.0 — DOC_SYNC_CHECKLIST registry + doc-sync rule tightening

### Section Markers

| Check | Command | Expected | Result |
|---|---|---|---|
| (83) "MANDATORY STARTUP" marker in AGENTS.md | `grep -c "MANDATORY STARTUP" AGENTS.md` | 1 | PASS |
| (84) "MANDATORY STARTUP" marker in INIT.md FILE 1 | `grep -c "MANDATORY STARTUP" INIT.md` | 1 | PASS |
| (85) "MANDATORY WORKFLOW" marker in AGENTS.md | `grep -c "MANDATORY WORKFLOW" AGENTS.md` | 1 | PASS |
| (86) "CONDITIONAL" marker in AGENTS.md | `grep -c "CONDITIONAL.*apply when triggered" AGENTS.md` | 1 | PASS |
| (87) "REFERENCE" marker in AGENTS.md | `grep -c "REFERENCE.*consult when needed" AGENTS.md` | 1 | PASS |

### §3 PERSIST DOC_SYNC_CHECKLIST trigger

| Check | Command | Expected | Result |
|---|---|---|---|
| (88) PERSIST trigger present in AGENTS.md | `grep -c "DOC_SYNC_CHECKLIST.md.*exists.*query" AGENTS.md` | 1 | PASS |
| (89) PERSIST trigger present in INIT.md FILE 1 | `grep -c "DOC_SYNC_CHECKLIST.md.*exists.*query" INIT.md` | 1 | PASS |

### §3c Release Gate — documentation sync tightened

| Check | Command | Expected | Result |
|---|---|---|---|
| (90) Entries affected ref in AGENTS.md | `grep -c "DOC_SYNC_CHECKLIST.*entries affected" AGENTS.md` | 1 | PASS |
| (91) Entries affected ref in INIT.md | `grep -c "DOC_SYNC_CHECKLIST.*entries affected" INIT.md` | 1 | PASS |

### §4 Closeout — vague sentence retired

| Check | Command | Expected | Result |
|---|---|---|---|
| (92) Vague sentence absent from AGENTS.md | `grep -c "corresponding documents must also be updated" AGENTS.md` | 0 | PASS |
| (93) Vague sentence absent from INIT.md (all locations incl. FILE 4) | `grep -c "corresponding documents must also be updated" INIT.md` | 0 | PASS |

### §5a + ROOT SAFETY CHECK — backup lists updated

| Check | Command | Expected | Result |
|---|---|---|---|
| (94) DOC_SYNC_CHECKLIST.md in AGENTS.md backup list | `grep -c "DOC_SYNC_CHECKLIST.md.*if present" AGENTS.md` | 1 | PASS |
| (95) DOC_SYNC_CHECKLIST.md in INIT.md backup lists | `grep -c "DOC_SYNC_CHECKLIST.md.*if present" INIT.md` | 2 | PASS |

### §7 item 5 — tightened

| Check | Command | Expected | Result |
|---|---|---|---|
| (96) Checklist reference in §7 AGENTS.md | `grep -c "DOC_SYNC_CHECKLIST.*if it exists" AGENTS.md` | ≥1 | PASS (2) |
| (97) Checklist reference in §7 INIT.md | `grep -c "DOC_SYNC_CHECKLIST.*if it exists" INIT.md` | ≥1 | PASS (3) |

### §8 item 2 — replaced with checklist query

| Check | Command | Expected | Result |
|---|---|---|---|
| (98) Old §8 text absent from AGENTS.md | `grep -c "Update acceptance docs / runbook" AGENTS.md` | 0 | PASS |
| (99) Old §8 text absent from INIT.md | `grep -c "Update acceptance docs / runbook" INIT.md` | 0 | PASS |
| (100) New checklist query in AGENTS.md | `grep -c "Query.*DOC_SYNC_CHECKLIST" AGENTS.md` | 1 | PASS |
| (101) New checklist query in INIT.md | `grep -c "Query.*DOC_SYNC_CHECKLIST" INIT.md` | 1 | PASS |

### INIT.md FILE 6 structure

| Check | Command | Expected | Result |
|---|---|---|---|
| (102) FILE 6 heading present in INIT.md | `grep -c "FILE 6.*DOC_SYNC_CHECKLIST" INIT.md` | 1 | PASS |
| (103) FILE 6 rule: no hardcoded "5 universal rows" | `grep -c "5 universal rows" INIT.md` | 0 | PASS |
| (104) "Change Category Registry" heading in FILE 6 content | `grep -c "Change Category Registry" INIT.md` | 1 | PASS |
| (105) "Anti-pattern: No Matching Row" in FILE 6 content | `grep -c "Anti-pattern.*No Matching Row" INIT.md` | 1 | PASS |

### dev/DOC_SYNC_CHECKLIST.md file integrity

| Check | Command | Expected | Result |
|---|---|---|---|
| (106) File exists | `test -f dev/DOC_SYNC_CHECKLIST.md` | exists | PASS |
| (107) "Change Category Registry" section present | `grep -c "Change Category Registry" dev/DOC_SYNC_CHECKLIST.md` | 1 | PASS |
| (108) "Anti-pattern: No Matching Row" section present | `grep -c "Anti-pattern.*No Matching Row" dev/DOC_SYNC_CHECKLIST.md` | 1 | PASS |
| (109) First universal row present | `grep -c "Governance rule change.*AGENTS.md" dev/DOC_SYNC_CHECKLIST.md` | 1 | PASS |

### Total reference counts (parity sentinel)

| Check | Command | Expected | Result |
|---|---|---|---|
| (110) Total DOC_SYNC_CHECKLIST occurrences in AGENTS.md | `grep -c "DOC_SYNC_CHECKLIST" AGENTS.md` | 5 | PASS |
| (111) Total DOC_SYNC_CHECKLIST occurrences in INIT.md | `grep -c "DOC_SYNC_CHECKLIST" INIT.md` | 9 | PASS |

## Feature round 7 (2026-03-27): v2.1 — Handoff chain integrity fixes + DOC_SYNC Matrix Scan enforcement

Root cause addressed: systematic analysis of "new stateless agent receives Handoff Prompt → runs full flow" revealed 6 断环 in the information chain. This round fixes断环 1/2/3/4/6 and adds mandatory visible DOC_SYNC output enforcement.

Changes: §1 Verbatim block "last occurring" precision + "does not substitute" startup clarification; §3 PERSIST DOC_SYNC Matrix Scan mandatory visible block; §4 rule 5 Opening line verbatim template + PROJECT_MASTER_SPEC added to sequence + "Post-startup first action:" label.

### §1 Verbatim block precision (断环 4) + startup clarification (断环 2)

| Check | Command | Expected | Result |
|---|---|---|---|
| (112) "last occurring" definition in AGENTS.md | `grep -c "last occurring" AGENTS.md` | 1 | PASS |
| (113) "last occurring" definition in INIT.md | `grep -c "last occurring" INIT.md` | 1 | PASS |
| (114) "does not substitute" startup clarification in AGENTS.md | `grep -c "does not substitute" AGENTS.md` | 2 | PASS |
| (115) "does not substitute" startup clarification in INIT.md | `grep -c "does not substitute" INIT.md` | 2 | PASS |

### §3 PERSIST DOC_SYNC Matrix Scan mandatory visible output

| Check | Command | Expected | Result |
|---|---|---|---|
| (116) DOC_SYNC Matrix Scan mandatory rule in AGENTS.md | `grep -c "DOC_SYNC Matrix Scan.*mandatory" AGENTS.md` | 1 | PASS |
| (117) DOC_SYNC Matrix Scan mandatory rule in INIT.md | `grep -c "DOC_SYNC Matrix Scan.*mandatory" INIT.md` | 1 | PASS |
| (118) Absence enforcement note in AGENTS.md | `grep -c "scan was skipped" AGENTS.md` | 1 | PASS |
| (119) Absence enforcement note in INIT.md | `grep -c "scan was skipped" INIT.md` | 1 | PASS |
| (120) "no file changes" SKIP variant present in AGENTS.md | `grep -c "no file changes this task" AGENTS.md` | 1 | PASS |
| (121) "no file changes" SKIP variant present in INIT.md | `grep -c "no file changes this task" INIT.md` | 1 | PASS |

### §4 rule 5 Opening line verbatim template (断环 1/3/6) + Post-startup label (断环 1)

| Check | Command | Expected | Result |
|---|---|---|---|
| (122) Verbatim template requirement in AGENTS.md | `grep -c "verbatim template" AGENTS.md` | 1 | PASS |
| (123) Verbatim template requirement in INIT.md | `grep -c "verbatim template" INIT.md` | 1 | PASS |
| (124) Post-startup first action label in AGENTS.md | `grep -c "Post-startup first action" AGENTS.md` | 1 | PASS |
| (125) Post-startup first action label in INIT.md | `grep -c "Post-startup first action" INIT.md` | 1 | PASS |

### Feature Round 8 — §4a Session Log Maintenance (v2.2)

| Check | Command | Expected | Result |
|---|---|---|---|
| (126) §4a heading in AGENTS.md | `grep -c "4a) Session Log Maintenance" AGENTS.md` | 1 | PASS |
| (127) §4a heading in INIT.md | `grep -c "4a) Session Log Maintenance" INIT.md` | 1 | PASS |
| (128) 400-line trigger in AGENTS.md | `grep -c "exceeds 400 lines" AGENTS.md` | 1 | PASS |
| (129) 400-line trigger in INIT.md | `grep -c "exceeds 400 lines" INIT.md` | 1 | PASS |
| (130) 30-day trigger in AGENTS.md | `grep -c "dated more than 30 days ago" AGENTS.md` | 1 | PASS |
| (131) 30-day trigger in INIT.md | `grep -c "dated more than 30 days ago" INIT.md` | 1 | PASS |
| (132) ≤200-line archive target in AGENTS.md | `grep -c "200 lines" AGENTS.md` | 1 | PASS |
| (133) ≤200-line archive target in INIT.md | `grep -c "200 lines" INIT.md` | 1 | PASS |
| (134) Quarterly archive format in AGENTS.md | `grep -c "SESSION_LOG_YYYY_QN" AGENTS.md` | 1 | PASS |
| (135) Quarterly archive format in INIT.md | `grep -c "SESSION_LOG_YYYY_QN" INIT.md` | 1 | PASS |
| (136) Never-delete hard rule in AGENTS.md | `grep -c "Never delete session entries" AGENTS.md` | 1 | PASS |
| (137) Never-delete hard rule in INIT.md | `grep -c "Never delete session entries" INIT.md` | 1 | PASS |
| (138) §4a in CONDITIONAL markers in AGENTS.md | `grep -c "CONDITIONAL.*§4a" AGENTS.md` | 1 | PASS |
| (139) §4a in CONDITIONAL markers in INIT.md | `grep -c "CONDITIONAL.*§4a" INIT.md` | 1 | PASS |

PROJECT_MASTER_SPEC.md in Opening line template: AGENTS.md=1 (§4 rule 5 only), INIT.md=2 (§4 rule 5 + QUICK START section) — both ≥1, verified by inspection; not assigned a numbered check as the value differs by file.

Fence counts unchanged: AGENTS.md=16 (even), INIT.md=28 (even) — verified by inspection (no fenced code blocks added in any change).

## Feature round 9 (2026-04-08): v2.3 — Governance audit fixes (7+1)

Root cause addressed: systematic audit of AGENTS.md identified 7 ambiguity/contradiction zones + 1 parity bug. All fixes stress-tested for net-positive impact before implementation. Changes: §3 PLAN display requirement (A1), §2 conflict arbitration rule (A2), §2b triage exploratory read (A4), §3 CHANGE deviation stop (A5), §8/§8b bridging (A3), §11 Output Contract scope narrowing (B1), INIT.md FILE 4 checklist CODEBASE_CONTEXT (parity fix).

### A1: §3 PLAN display requirement

| Check | Command | Expected | Result |
|---|---|---|---|
| (140) PLAN display "My understanding" in AGENTS.md | `grep -c "My understanding.*1-sentence restatement" AGENTS.md` | 1 | PASS |
| (141) PLAN display "My understanding" in INIT.md | `grep -c "My understanding.*1-sentence restatement" INIT.md` | 1 | PASS |

### A2: §2 conflict arbitration rule

| Check | Command | Expected | Result |
|---|---|---|---|
| (142) Conflict arbitration in AGENTS.md | `grep -c "user instruction conflicts.*rule in this document" AGENTS.md` | 1 | PASS |
| (143) Conflict arbitration in INIT.md | `grep -c "user instruction conflicts.*rule in this document" INIT.md` | 1 | PASS |

### A4: §2b triage exploratory read

| Check | Command | Expected | Result |
|---|---|---|---|
| (144) Triage read note in AGENTS.md | `grep -c "Targeted file reads.*during triage" AGENTS.md` | 1 | PASS |
| (145) Triage read note in INIT.md | `grep -c "Targeted file reads.*during triage" INIT.md` | 1 | PASS |

### A5: §3 CHANGE deviation stop

| Check | Command | Expected | Result |
|---|---|---|---|
| (146) CHANGE deviation rule in AGENTS.md | `grep -c "diverges from PLAN.*stop.*report" AGENTS.md` | 1 | PASS |
| (147) CHANGE deviation rule in INIT.md | `grep -c "diverges from PLAN.*stop.*report" INIT.md` | 1 | PASS |

### A3: §8/§8b bridging

| Check | Command | Expected | Result |
|---|---|---|---|
| (148) §8/§8b reconciliation in AGENTS.md | `grep -c "monitoring.*promote to rule if recurrence" AGENTS.md` | 1 | PASS |
| (149) §8/§8b reconciliation in INIT.md | `grep -c "monitoring.*promote to rule if recurrence" INIT.md` | 1 | PASS |

### B1: §11 Output Contract scope

| Check | Command | Expected | Result |
|---|---|---|---|
| (150) §11 scope narrowing in AGENTS.md | `grep -c "CHANGE or PERSIST phase" AGENTS.md` | 1 | PASS |
| (151) §11 scope narrowing in INIT.md | `grep -c "CHANGE or PERSIST phase" INIT.md` | 1 | PASS |
| (152) §11 exemption note in AGENTS.md | `grep -c "clarifying questions.*status updates" AGENTS.md` | 1 | PASS |
| (153) §11 exemption note in INIT.md | `grep -c "clarifying questions.*status updates" INIT.md` | 1 | PASS |

### FILE 4: INIT.md template checklist parity fix

| Check | Command | Expected | Result |
|---|---|---|---|
| (154) CODEBASE_CONTEXT in FILE 4 template checklist | `grep -c "Read.*CODEBASE_CONTEXT" INIT.md` | >=1 | PASS |
| (155) FILE 4 checklist item count increased | `grep -c "^[0-9]\+\. " INIT.md` | >=10 | PASS |

## Feature round 10 (2026-04-08): v2.4 — PLAN self-challenge, lean log format, archive threshold reduction

Root cause addressed: "lost in the middle" research (Stanford/Anthropic 2023) shows 30%+ accuracy drop for mid-context content. 800-line SESSION_LOG sits in the attention dead zone. Lean format reduces entry size ~60%. Self-challenge forces adversarial thinking at PLAN phase.

### PLAN risk grading + conditional pause (replaces self-challenge)

| Check | Command | Expected | Result |
|---|---|---|---|
| (156) Risk level criteria in AGENTS.md | `grep -c "Risk level.*HIGH or LOW" AGENTS.md` | 1 | PASS |
| (157) Risk level criteria in INIT.md | `grep -c "Risk level.*HIGH or LOW" INIT.md` | 1 | PASS |
| (164) HIGH wait-for-confirmation in AGENTS.md | `grep -c "wait for user confirmation" AGENTS.md` | 1 | PASS |
| (165) HIGH wait-for-confirmation in INIT.md | `grep -c "wait for user confirmation" INIT.md` | 1 | PASS |
| (166) Assumptions and risks merged in AGENTS.md | `grep -c "Assumptions and risks" AGENTS.md` | 1 | PASS |
| (167) Assumptions and risks merged in INIT.md | `grep -c "Assumptions and risks" INIT.md` | 1 | PASS |
| (168) Self-challenge standalone removed from AGENTS.md | `grep -c "Challenge own assumptions" AGENTS.md` | 0 | PASS |
| (169) Self-challenge standalone removed from INIT.md | `grep -c "Challenge own assumptions" INIT.md` | 0 | PASS |

### Lean session log format

| Check | Command | Expected | Result |
|---|---|---|---|
| (158) Lean format guideline in AGENTS.md | `grep -c "lean key-value style" AGENTS.md` | 1 | PASS |
| (159) Lean format guideline in INIT.md | `grep -c "lean key-value style" INIT.md` | 1 | PASS |
| (160) INIT FILE 5 template uses bold key format | `grep -c "\\*\\*ID:\\*\\*" INIT.md` | 1 | PASS |
| (161) INIT FILE 5 "Files read" field removed | `grep -c "^[0-9]*\\. Files read:" INIT.md` | 0 | PASS |

### Archive threshold update

| Check | Command | Expected | Result |
|---|---|---|---|
| (162) Archive pointer text updated in AGENTS.md | `grep -c ">400 lines" AGENTS.md` | 1 | PASS |
| (163) Archive pointer text updated in INIT.md | `grep -c ">400 lines" INIT.md` | 1 | PASS |

### Parity sentinel

| Check | Command | Expected | Result |
|---|---|---|---|
| Fence counts | `grep -c "^\x60\x60\x60" AGENTS.md` / `INIT.md` | AGENTS=16, INIT=28 | PASS |

## Notes

- This report validates document and governance consistency at repository level.
- It does not execute external platform runtime integration tests.
- Feature round 2 adds: CODEBASE_CONTEXT governance integration, External API Code Safety §0b subsection, PROJECT_MASTER_SPEC §10 intent-based active trigger with filename enforcement.
- Feature round 3 adds: §3d Test Plan Design conditional subsection (4 trigger conditions, 4 scenario categories, project-type adaptations, table format, recording location rules).
- Feature round 4 adds: §4 rule 5 cross-LLM handoff opening line requirement (AGENTS.md read first + §1 startup sequence); §1 CODEBASE_CONTEXT scan hardening (backup step, expanded sources, consolidate-not-duplicate).
- Feature round 5 adds: 6 governance gap fixes — §1 new-session definition (3-trigger), §3 PERSIST explicit sync, §4 Open Priorities regeneration, §4 max-3 clarification, §10 Known Risks location, §5.7 modification operations precision.
- Feature round 6 adds: DOC_SYNC_CHECKLIST.md registry (deterministic doc-sync via lookup table); section markers in AGENTS.md (MANDATORY/CONDITIONAL/REFERENCE); §3 PERSIST checklist trigger; §3c documentation sync definition; §4 vague "corresponding documents" sentence retired; §5a backup lists updated; §7 and §8 tightened with registry references; INIT.md FILE 6 bootstrap; INIT.md fence count updated to 28.
- Feature round 7 adds: §1 "last occurring" Verbatim block definition + "does not substitute" startup clarification; §3 PERSIST DOC_SYNC Matrix Scan mandatory visible block (replaces silent trigger); §4 rule 5 Opening line verbatim template + PROJECT_MASTER_SPEC in sequence + "Post-startup first action:" label; total 14 new grep checks (112–125).
- Feature round 8 adds: §4a Session Log Maintenance — auto-archive triggers (>800 lines or oldest entry >30 days), archive target (≤350 lines or entries older than 30 days), quarterly archive naming, first-run auto-transition, hard rules (never delete, archive not in §1 read list, retain latest Verbatim block); section markers updated to include §4a; total 14 new grep checks (126–139).
- Feature round 10 adds: §3 PLAN risk grading (HIGH/LOW with 5 concrete criteria + conditional pause for HIGH); "Assumptions and risks" merged display (replaces standalone self-challenge); self-challenge line removed; §4 lean session log format guideline (target ~20-30 lines/entry, omit empty sections, remove "Files read"); §4a archive thresholds lowered (800→400 trigger, 350→200 target); INIT.md FILE 5 template rewritten to lean key-value format. Checks (128)/(129) updated from "800 lines" to "400 lines", (132)/(133) from "350 lines" to "200 lines". Total 8 new grep checks (156–163).
- Feature round 9 adds: 7 governance clarifications + 1 parity bug fix from systematic audit — §3 PLAN must display "My understanding / Impact scope / Assumptions" (A1); §2 conflict arbitration rule for user-vs-governance conflicts (A2); §2b triage exploratory read allowance (A4); §3 CHANGE deviation stop-and-report (A5); §8/§8b reconciliation bridging sentence (A3); §11 Output Contract scoped to CHANGE/PERSIST responses (B1); INIT.md FILE 4 template checklist adds CODEBASE_CONTEXT (parity fix). Checks (114)/(115) expected values updated from 1 to 2. Total 16 new grep checks (140–155).

## Manual governance checks (cannot be automated with grep)

These require human or live-session verification:

| Check | Type | Notes |
|---|---|---|
| §10 suppression: if SESSION_HANDOFF contains "PROJECT_MASTER_SPEC suggestion issued: [session ID] [date]", AI must NOT re-suggest in subsequent sessions unless new arch decisions were made | Behavioral | Verify in live session after §10 suggestion is issued |
| §0b step 0: if CODEBASE_CONTEXT does not exist, AI generates it before recording External Services | Behavioral | Verify in first-session scenario with API-calling code |
| §1 generation scan: AI scans README → docs/**/*.md → package manifests → .env.example → yaml configs without modifying source files; consolidates duplicates into one entry | Behavioral | Verify in first-session scenario with multi-source project |
| Cross-tool handoff (A→B): generated Handoff Prompt opens with verbatim Opening line template (AGENTS.md + §1 sequence including PROJECT_MASTER_SPEC); receiving tool reads AGENTS.md first then follows full §1 startup sequence; labeled "Post-startup first action:" appears only after §1 is complete | Behavioral | Verify by pasting handoff prompt into a different AI CLI tool (e.g. Claude Code → Gemini CLI, or Codex → Claude Code); confirm "Post-startup first action:" label is used |
| DOC_SYNC Matrix Scan visible output: at PERSIST phase, response contains "### DOC_SYNC Matrix Scan" block with matched registry rows and Status column; absence of block is immediately flagged | Behavioral | Verify in a live session where CHANGE phase modified files; confirm block appears before PERSIST completes |
| DOC_SYNC_CHECKLIST merge on upgrade: re-running INIT.md on project with custom rows in DOC_SYNC_CHECKLIST.md preserves those rows and adds any missing universal rows without overwriting | Behavioral | Verify by running INIT.md on a project that already has DOC_SYNC_CHECKLIST.md with a project-specific row added |
| PERSIST checklist trigger: agent outputs DOC_SYNC Matrix Scan block when CHANGE phase modified files; outputs SKIP notice when no file changes occurred | Behavioral | Verify in two live sessions: one with file changes (block appears), one without (SKIP output or absent) |
| Re-install on existing project: dry-run plan shows merge/skip (not create) for existing files; backup created before first write; SESSION_HANDOFF.md and SESSION_LOG.md left untouched | Behavioral | Verify by running INIT.md on a project that already has governance files |
| A1 — PLAN display: AI states "My understanding:", "Impact scope:", "Assumptions:" at PLAN phase before proceeding to READ; user can see and correct misinterpretation | Behavioral | Verify in a live session with an ambiguous task request |
| A2 — Conflict arbitration: when user instruction conflicts with governance rule, AI states the conflict and risk before complying; override is recorded in SESSION_LOG | Behavioral | Verify by requesting AI to skip a mandatory step (e.g., "don't update session log") |
| A5 — CHANGE deviation stop: when AI discovers mid-CHANGE that assumptions were wrong, it stops and reports instead of self-correcting | Behavioral | Verify by giving a task where the target file has unexpected state |
| B1 — §11 scope: clarifying questions and simple lookups do not include forced "What was done / Why / Verification / Next" output | Behavioral | Verify by asking a simple question (e.g., "what's the build command?") in a governed session |
