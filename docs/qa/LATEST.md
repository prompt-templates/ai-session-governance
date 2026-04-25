# Latest QA Regression

- Current report: [QA_REGRESSION_REPORT.md](QA_REGRESSION_REPORT.md)
- **Run automated checks:** `bash docs/qa/run_checks.sh` (from project root)
- Date (UTC): 2026-04-25
- Tag: **v3.0** (GA) + **v3.0.1** (release-doc sync root-fix)
- Result: 245 total automated checks (156 main + 89 legacy auto-chain), 245 pass, 0 fail
- Focus of latest run: Phase 1 legacy quarantine, Phase 2 AGENTS.md L4 reduction (734 → 487 lines, −33.7%), v3.0-rc.2 §5a backup-list hotfix, v3.0.1 release-doc sync governance + R29 series regression
- Sandbox install QC: 3 HIGH-risk scenarios verified (re-install with user overflow files / §5a pwd≠git-root mismatch / §4 closeout end-to-end)
- Matrix QC audit reference: 10-dimension audit on sandbox install — PASS (LOW finding from v3.0-rc.1 already resolved by v3.0-rc.2 hotfix)
