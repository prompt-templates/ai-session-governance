# External API Code Safety Design

Date: 2026-03-16
Status: Approved, pending implementation
Session: Claude_20260316

---

## Problem

§0b already prohibits guessing external API behavior, but is too abstract.
AI routinely fabricates endpoint paths, parameter names, and response schemas
from training-data memory — leading to broken code when APIs have changed.

---

## Decision

Strengthen §0b with a concrete **External API Code Safety** subsection that:
1. Mandates a verification ritual before writing any API-calling code
2. Defines a two-status tracking system: `Doc-reviewed` vs `Test-verified`
3. Stores verified API facts in `dev/CODEBASE_CONTEXT.md` External Services as project SSOT
4. Defines staleness and re-verification rules

---

## External Services Block Format (in dev/CODEBASE_CONTEXT.md)

```markdown
### [API Name]
- Base URL:
- Version:
- Auth:
- Required params:
- Forbidden params:
- Response path:
- Official docs:
- Doc-reviewed:  （date + session ID — documentation read and fields recorded）
- Test-verified: （date + session ID — API call made and response confirmed correct）
- Notes:
```

---

## Verification Status Semantics

| Status | Meaning | When writing code |
|---|---|---|
| `Test-verified` present | API call succeeded, response confirmed | Re-verify endpoint/params if prior session |
| Only `Doc-reviewed` | Docs read, not yet tested | Use with caution; annotate `# awaiting test-verification` |
| Both empty | Never verified | Full ritual required before writing code |

---

## Files to Change

- `AGENTS.md` §0b: add External API Code Safety subsection
- `INIT.md`: mirror §0b addition in FILE 1 embedded copy
- `docs/qa/QA_REGRESSION_REPORT.md`: update with new regression checks

---

## No Changes Needed To

- §1 startup sequence (CODEBASE_CONTEXT already in reads)
- §4 session close rules (External Services update covered by existing tech stack change condition)
- §5a backup list (CODEBASE_CONTEXT already backed up)
- §10 (unchanged)
