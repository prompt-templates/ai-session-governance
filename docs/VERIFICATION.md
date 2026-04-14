# Verification Record

This document keeps the detailed claim mapping and platform compatibility checks referenced by README files.

Verification date baseline: 2026-03-26 (UTC)

## Claim-to-mechanism mapping

| Claim | Backed by | Verified |
|---|---|---|
| Session continuity | AGENTS.md section 1 Single Entry, section 4 Session Close, SESSION_HANDOFF.md, SESSION_LOG.md | Yes |
| PLAN -> READ -> CHANGE -> QC -> PERSIST | AGENTS.md section 3 Standard Workflow | Yes |
| Anti-governance-bloat discipline | AGENTS.md section 3b Consolidation Discipline, section 8b Rule Promotion Threshold | Yes |
| Layer separation | AGENTS.md section 0a | Yes |
| Read before change | AGENTS.md section 3 READ phase (consolidated from former section 2c) | Yes |
| Issue triage before debug | AGENTS.md section 2b | Yes |
| Multi-agent session ID standard | AGENTS.md section 12 | Yes |
| File safety governance | AGENTS.md section 5, section 6 | Yes |
| Integration with existing project docs | AGENTS.md line 2 merge/preserve instruction | Yes |
| External API code safety | AGENTS.md section 0b External API Code Safety | Yes |
| Test plan governance | AGENTS.md section 3d Test Plan Design | Yes |
| Doc-sync registry | dev/DOC_SYNC_CHECKLIST.md; AGENTS.md §3 PERSIST trigger, §7, §8 | Yes |
| QC fail-path guidance | AGENTS.md section 3 QC phase — report failures, no auto-retry | Yes |
| Deviation resume path | AGENTS.md section 3 CHANGE phase — restart from PLAN or CHANGE after deviation stop | Yes |
| Closeout ambiguity guard | AGENTS.md section 4 Session Close — confirm intent on ambiguous expressions | Yes |
| Core rules attention anchor | AGENTS.md top-level CORE RULES block — critical rules in highest attention position | Yes |

## Platform compatibility verified

| Platform | Reads governance file | Session persistence | Structured workflows | Reference |
|---|---|---|---|---|
| Codex | `AGENTS.md` native | Client-side sessions + resume | AGENTS.md directives + Agents SDK | OpenAI Codex docs |
| Claude Code | `CLAUDE.md` native; `AGENTS.md` via `@` import | Auto memory + session resume | Plan mode + skills | Claude Code docs |
| Gemini CLI | `GEMINI.md` native; `AGENTS.md` via config/import | `/memory` + session save/resume | Skills + GEMINI.md directives | Gemini CLI docs |

## Regression evidence

- Latest QA pointer: [docs/qa/LATEST.md](qa/LATEST.md)
- Current detailed report: [docs/qa/QA_REGRESSION_REPORT.md](qa/QA_REGRESSION_REPORT.md)
- Latest run snapshot (UTC): 2026-04-14, 169 automated checks, 169 pass, 0 fail; 15 behavioral checks
- **Run automated checks:** `bash docs/qa/run_checks.sh` (from project root)

## Not yet verified

- Longitudinal effectiveness across 50+ sessions
- Compliance rate across different model generations
- Performance impact of mandatory handoff/log reads at session start
