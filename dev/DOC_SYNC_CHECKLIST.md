# Doc Sync Checklist
<!-- LOCAL PROJECT RECORD -->
<!--
  USAGE: At PERSIST phase, if any file was created or modified during CHANGE:
  1. Identify the change category in the registry below
  2. Execute all "Required Doc Updates" for matched rows
  3. Record triggered rows in SESSION_LOG under "Doc Sync"
  4. If your change type has no matching row: add the row first, then proceed
     (prevents this registry from going stale)
-->

## Change Category Registry

| Change Category | Required Doc Updates | Verification Method |
|---|---|---|
| Governance rule change (AGENTS.md) | INIT.md FILE 1 mirror; README if behavior is user-facing | grep parity check |
| Tech stack / build / dependency change | CODEBASE_CONTEXT.md Stack or Build section | manual review |
| External API / service change | CODEBASE_CONTEXT.md External Services block | block format check |
| New governance file added to install | §5a backup list in AGENTS.md; INIT.md ROOT SAFETY CHECK backup list; INIT.md FILE 1 §5a | grep check |
| Session-log maintenance policy changed | AGENTS.md §4a mechanism enforcement; INIT.md FILE 1 §4a + §5a backup list; README*.md safeguards section | grep + policy parity check |
| New project doc added | This file — add a row for the new doc's update triggers | row presence check |
| Workspace cleanup (delete untracked scratch / `_tmp_*` artifacts) | dev/SESSION_HANDOFF.md if Open Priorities, Current Baseline, or Known Risks referenced the deleted artifacts | manual review |
| Harness restructure (legacy quarantine / split / new harness layer) | docs/qa/MIGRATION_NOTES.md series table; AGENTS.md §3c Machine Verification clause; INIT.md FILE 1 mirror; run_checks.sh + legacy_checks.sh sync | bash docs/qa/run_checks.sh full chain |
| **Release published (tag + GitHub release + version bump)** | README.md + 3 localized variants (zh-TW/zh-CN/ja) version table; docs/releases/<version>.md (release notes); docs/qa/LATEST.md (date + check count + tag); docs/qa/QA_REGRESSION_REPORT.md (current run summary); docs/VERIFICATION.md (claim baseline, if changed); docs/site/index.html stat-counter (`data-target` for total checks); any other public-facing site/landing pages | grep regression (R29 series) + manual review |
| _[Add project-specific rows below this line]_ | | |

## Anti-pattern: No Matching Row

If your change has no matching row above:
- Do NOT skip silently — add the missing row first, then proceed
- Record the registry addition in SESSION_LOG under `Doc Sync: registry updated`
- Reason: a stale registry is worse than no registry (false safety net)
