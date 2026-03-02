# Verification Record

This document keeps the detailed claim mapping and platform compatibility checks referenced by README files.

Verification date baseline: 2026-02-27 (UTC)

## Claim-to-mechanism mapping

| Claim | Backed by | Verified |
|---|---|---|
| Session continuity | AGENTS.md section 1 Single Entry, section 4 Session Close, SESSION_HANDOFF.md, SESSION_LOG.md | Yes |
| PLAN -> READ -> CHANGE -> QC -> PERSIST | AGENTS.md section 3 Standard Workflow | Yes |
| Anti-governance-bloat discipline | AGENTS.md section 3b Consolidation Discipline, section 8b Rule Promotion Threshold | Yes |
| Layer separation | AGENTS.md section 0a | Yes |
| Read before change | AGENTS.md section 2c | Yes |
| Issue triage before debug | AGENTS.md section 2b | Yes |
| Multi-agent session ID standard | AGENTS.md section 12 | Yes |
| File safety governance | AGENTS.md section 5, section 6 | Yes |
| Integration with existing project docs | AGENTS.md line 2 merge/preserve instruction | Yes |

## Platform compatibility verified

| Platform | Reads governance file | Session persistence | Structured workflows | Reference |
|---|---|---|---|---|
| Codex | `AGENTS.md` native | Client-side sessions + resume | AGENTS.md directives + Agents SDK | OpenAI Codex docs |
| Claude Code | `CLAUDE.md` native; `AGENTS.md` via `@` import | Auto memory + session resume | Plan mode + skills | Claude Code docs |
| Gemini CLI | `GEMINI.md` native; `AGENTS.md` via config/import | `/memory` + session save/resume | Skills + GEMINI.md directives | Gemini CLI docs |

## Not yet verified

- Longitudinal effectiveness across 50+ sessions
- Compliance rate across different model generations
- Performance impact of mandatory handoff/log reads at session start
