# DOC_SYNC_CHECKLIST Implementation Plan

> **For Claude:** Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Eliminate doc drift in long-term iterative projects by replacing 4 vague "corresponding documents" references with a deterministic lookup registry (`dev/DOC_SYNC_CHECKLIST.md`). Net change: 1 new file created, 1 existing rule retired, 3 existing rules tightened with checklist reference, 1 new bullet added to §3 PERSIST.

**Architecture:**
- `AGENTS.md` is SSOT — edit first, then mirror each change to `INIT.md` FILE 1 immediately after
- `dev/DOC_SYNC_CHECKLIST.md` is the project-level doc registry (lookup table, not a governance rule)
- No new governance sections added to AGENTS.md — only existing sections tightened or retired

**Consolidation actions (replaces, not stacks):**

| Location | Current (vague) | Action |
|---|---|---|
| §4 Closeout line 343 | "corresponding documents must also be updated" | **RETIRE** (§3 PERSIST + checklist covers it) |
| §3c line 279 | "documentation sync" (undefined) | **TIGHTEN** — add checklist reference |
| §7 item 5 line 511 | "corresponding documentation" | **TIGHTEN** — add checklist reference |
| §8 item 2 line 520 | "acceptance docs / runbook / spec (depending on impact scope)" | **REPLACE** with checklist query |
| §3 PERSIST line 239 | (gap — no project-doc trigger) | **ADD** checklist bullet |

**Fence count invariant:**
- AGENTS.md: 16 (even) — all tasks are text-only changes, no fences added/removed → stays 16 ✅
- INIT.md: 26 (even) — FILE 1 mirrors add no fences; FILE 6 new fenced block +2 → 28 (even) ✅

---

## Pre-flight Checks

```bash
git status --short
# Expected: only .claude/ docs/plans/ ref_doc/ untracked (clean working tree for AGENTS.md + INIT.md)

grep -c '^\`\`\`' AGENTS.md
# Expected: 16

grep -c '^\`\`\`' INIT.md
# Expected: 26
```

If working tree is dirty for AGENTS.md or INIT.md — stop and investigate before proceeding.

---

## Task 1: Section Markers (anti-skip, AGENTS.md + INIT.md FILE 1)

**Purpose:** Let agents know at a glance which sections are mandatory-every-session vs conditional.
**Files:** AGENTS.md line 4; INIT.md FILE 1 (line 47, the `<INSTRUCTIONS>` line inside the fenced block)
**No fences added.**

**Step 1: Edit AGENTS.md — insert 4 lines after `<INSTRUCTIONS>` (line 4)**

Current (line 4):
```
<INSTRUCTIONS>
```

Insert immediately after line 4:
```
<!-- MANDATORY STARTUP — read every session: §0 §1 §2 -->
<!-- MANDATORY WORKFLOW — execute every task/closeout: §3 §4 -->
<!-- CONDITIONAL — apply when triggered: §0b §2b §2c §3b §3c §3d §5 §6 §7 §8 §8b §9 -->
<!-- REFERENCE — consult when needed: §10 §11 §12 -->
```

**Step 2: Mirror to INIT.md FILE 1 — insert same 4 lines after `<INSTRUCTIONS>` inside the FILE 1 fenced block (INIT.md line 47)**

**Step 3: Verify**
```bash
grep -c "MANDATORY STARTUP" AGENTS.md   # Expected: 1
grep -c "MANDATORY STARTUP" INIT.md     # Expected: 1
grep -c "MANDATORY WORKFLOW" AGENTS.md  # Expected: 1
grep -c "MANDATORY WORKFLOW" INIT.md    # Expected: 1
```

---

## Task 2: §3 PERSIST — Add checklist bullet (AGENTS.md + INIT.md FILE 1)

**Purpose:** Fill the genuine gap — no existing trigger for project-specific docs at PERSIST time.
**File:** AGENTS.md lines 236–239; INIT.md FILE 1 lines 279–281
**Trigger condition is binary (no agent judgment): "did any file change during CHANGE phase?"**

**Step 1: Edit AGENTS.md — append bullet after line 239**

Current block (lines 236–239):
```
5. PERSIST
   - Update `dev/SESSION_HANDOFF.md` and `dev/SESSION_LOG.md`
   - Apply the same cross-document sync conditions as §4 closeout: if tech stack, directory structure, build commands, external services, or Key Decisions changed in this task — update `dev/CODEBASE_CONTEXT.md` now, do not defer to closeout
   - If `dev/PROJECT_MASTER_SPEC.md` exists and carries status for the completed work — update it in the same pass
```

Add after the last bullet (after line 239):
```
   - If any file was created or modified during CHANGE, and `dev/DOC_SYNC_CHECKLIST.md` exists: query the registry for this change category and update all listed docs before completing PERSIST
```

**Step 2: Mirror to INIT.md FILE 1** — append the same bullet after line 281

**Step 3: Verify**
```bash
grep -c "DOC_SYNC_CHECKLIST.md.*exists.*query" AGENTS.md   # Expected: 1
grep -c "DOC_SYNC_CHECKLIST.md.*exists.*query" INIT.md     # Expected: 1
```

---

## Task 3: §3c Release Gate — Tighten "documentation sync" (AGENTS.md + INIT.md FILE 1)

**Purpose:** "documentation sync" was a checklist item with no definition. Now points to checklist.
**File:** AGENTS.md line 279; INIT.md FILE 1 line 322

**Step 1: Edit AGENTS.md line 279**

Current:
```
   - Must cover: correctness, consistency, regression risk, documentation sync, toolchain compatibility
```

Replace with:
```
   - Must cover: correctness, consistency, regression risk, documentation sync (verify all `dev/DOC_SYNC_CHECKLIST.md` entries affected by this release's changes are updated), toolchain compatibility
```

**Step 2: Mirror to INIT.md FILE 1 line 322**

**Step 3: Verify**
```bash
grep -c "DOC_SYNC_CHECKLIST.*entries affected" AGENTS.md   # Expected: 1
grep -c "DOC_SYNC_CHECKLIST.*entries affected" INIT.md     # Expected: 1
```

---

## Task 4: §4 Closeout — Retire vague sentence (AGENTS.md + INIT.md FILE 1)

**Purpose:** This sentence was the original source of "corresponding documents" ambiguity. §3 PERSIST + checklist now covers it — retire to avoid duplication.
**File:** AGENTS.md line 343 (+ blank line 342); INIT.md FILE 1 line 386 (+ blank line 385)

**Step 1: Edit AGENTS.md — delete lines 342–343**

Current (lines 342–343):
```
[blank line]
If the session's changes involve specifications, acceptance criteria, runbooks, releases, baselines, regression thresholds, or external platform integrations, the corresponding documents must also be updated.
```

Delete both lines entirely.

**Step 2: Mirror to INIT.md FILE 1 — delete lines 385–386**

**Step 3: Verify**
```bash
grep -c "corresponding documents must also be updated" AGENTS.md
# Expected: 0

grep -c "corresponding documents must also be updated" INIT.md
# Expected: 1 (FILE 4 SESSION_HANDOFF.md template line ~759 — different section, out of scope)
# Note: FILE 4 is the SESSION_HANDOFF.md template; it is skipped on re-install and contains
# advisory text only, not governance rules. Acceptable to leave unchanged in this pass.
```

---

## Task 5: §5a + ROOT SAFETY CHECK — Add DOC_SYNC_CHECKLIST.md to backup lists

**Purpose:** Protect the checklist from being lost during re-install.
**Three locations** (all must be updated together):

### Location A: AGENTS.md §5a line 480

Current:
```
   - Copy only existing target files (`AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `dev/SESSION_HANDOFF.md`, `dev/SESSION_LOG.md`, `dev/CODEBASE_CONTEXT.md`, if present)
```

Replace with:
```
   - Copy only existing target files (`AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `dev/SESSION_HANDOFF.md`, `dev/SESSION_LOG.md`, `dev/CODEBASE_CONTEXT.md`, `dev/DOC_SYNC_CHECKLIST.md`, if present)
```

### Location B: INIT.md ROOT SAFETY CHECK line 33 (outer INIT.md, not FILE 1)

Same replacement as Location A (identical text, same line content).

### Location C: INIT.md FILE 1 §5a line 522–523 (mirror of Location A)

Same replacement.

**Step: Verify**
```bash
grep -c "DOC_SYNC_CHECKLIST.md.*if present" AGENTS.md   # Expected: 1
grep -c "DOC_SYNC_CHECKLIST.md.*if present" INIT.md     # Expected: 2 (ROOT SAFETY CHECK + FILE 1)
```

---

## Task 6: §7 item 5 — Tighten with checklist reference (AGENTS.md + INIT.md FILE 1)

**Purpose:** "corresponding documentation" → points to checklist. Timing rule ("same changeset") preserved.
**File:** AGENTS.md line 511; INIT.md FILE 1 line 554

**Step 1: Edit AGENTS.md line 511**

Current:
```
5. If behavior, processes, interfaces, acceptance criteria, runbooks, release conditions, or related matters change, the corresponding documentation and regression must be updated in the same changeset
```

Replace with:
```
5. If behavior, processes, interfaces, acceptance criteria, runbooks, release conditions, or related matters change, the corresponding documentation (see `dev/DOC_SYNC_CHECKLIST.md` if it exists) and regression must be updated in the same changeset
```

**Step 2: Mirror to INIT.md FILE 1 line 554**

**Step 3: Verify**
```bash
grep -c "DOC_SYNC_CHECKLIST.*if it exists" AGENTS.md   # Expected: 1
grep -c "DOC_SYNC_CHECKLIST.*if it exists" INIT.md     # Expected: 1
```

---

## Task 7: §8 item 2 — Replace vague with checklist query (AGENTS.md + INIT.md FILE 1)

**Purpose:** "depending on impact scope" = agent self-assessed. Replace with deterministic table lookup.
**File:** AGENTS.md line 520; INIT.md FILE 1 line 563

**Step 1: Edit AGENTS.md line 520**

Current:
```
2. Update acceptance docs / runbook / spec (depending on impact scope)
```

Replace with:
```
2. Query `dev/DOC_SYNC_CHECKLIST.md` (if it exists) for doc impact scope; update all listed entries for this change category
```

**Step 2: Mirror to INIT.md FILE 1 line 563**

**Step 3: Verify**
```bash
grep -c "Update acceptance docs / runbook" AGENTS.md   # Expected: 0
grep -c "Update acceptance docs / runbook" INIT.md     # Expected: 0
grep -c "Query.*DOC_SYNC_CHECKLIST" AGENTS.md           # Expected: 1
grep -c "Query.*DOC_SYNC_CHECKLIST" INIT.md             # Expected: 1
```

---

## Task 8: Create dev/DOC_SYNC_CHECKLIST.md

**New file.** Not gitignored (project config, should be committed).

```markdown
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
| New project doc added | This file — add a row for the new doc's update triggers | row presence check |
| _[Add project-specific rows below this line]_ | | |

## Anti-pattern: No Matching Row

If your change has no matching row above:
- Do NOT skip silently — add the missing row first, then proceed
- Record the registry addition in SESSION_LOG under `Doc Sync: registry updated`
- Reason: a stale registry is worse than no registry (false safety net)
```

---

## Task 9: INIT.md — Add FILE 6

**Purpose:** Bootstrap `dev/DOC_SYNC_CHECKLIST.md` on fresh install; merge-safe on re-install.

After line 821 (end of FILE 5 content), append:

```markdown
---

## FILE 6: dev/DOC_SYNC_CHECKLIST.md
Rule if exists: preserve all existing rows; ensure the 5 universal rows in the template are present — add any that are missing without removing custom rows.

```[fenced block with full content from Task 8]```
```

This adds 2 fences to INIT.md: 26 → 28 (even) ✅

---

## Final QC — All Changes

### Presence checks (all must be 1)
```bash
grep -c "MANDATORY STARTUP" AGENTS.md
grep -c "MANDATORY STARTUP" INIT.md
grep -c "DOC_SYNC_CHECKLIST.md.*exists.*query" AGENTS.md
grep -c "DOC_SYNC_CHECKLIST.md.*exists.*query" INIT.md
grep -c "DOC_SYNC_CHECKLIST.*entries affected" AGENTS.md
grep -c "DOC_SYNC_CHECKLIST.*entries affected" INIT.md
grep -c "DOC_SYNC_CHECKLIST.*if it exists" AGENTS.md
grep -c "DOC_SYNC_CHECKLIST.*if it exists" INIT.md
grep -c "Query.*DOC_SYNC_CHECKLIST" AGENTS.md
grep -c "Query.*DOC_SYNC_CHECKLIST" INIT.md
grep -c "DOC_SYNC_CHECKLIST.md.*if present" AGENTS.md
```

### Count checks
```bash
grep -c "DOC_SYNC_CHECKLIST.md.*if present" INIT.md   # Expected: 2
```

### Absence checks (all must be 0)
```bash
grep -c "corresponding documents must also be updated" AGENTS.md
grep -c "Update acceptance docs / runbook" AGENTS.md
grep -c "Update acceptance docs / runbook" INIT.md
```

### Fence count invariant
```bash
grep -c '^\`\`\`' AGENTS.md   # Expected: 16 (unchanged)
grep -c '^\`\`\`' INIT.md     # Expected: 28 (was 26, +2 from FILE 6)
```

### Total DOC_SYNC_CHECKLIST occurrences
```bash
grep -c "DOC_SYNC_CHECKLIST" AGENTS.md   # Expected: 5
# §3 PERSIST, §3c, §5a, §7 item 5, §8 item 2

grep -c "DOC_SYNC_CHECKLIST" INIT.md     # Expected: 8
# ROOT SAFETY CHECK + FILE 1 (×5 mirrors) + FILE 6 header = 7 minimum; FILE 6 content adds more
```

---

## PERSIST

After all tasks pass QC:

1. Update `dev/SESSION_HANDOFF.md` — record completed changes, note v2.0 candidate
2. Update `dev/SESSION_LOG.md` — new session entry with Consolidation/Retirement Record
3. Query `dev/DOC_SYNC_CHECKLIST.md` (just created — verify governance rule change row applies)
4. Commit:
   ```
   git add AGENTS.md INIT.md dev/DOC_SYNC_CHECKLIST.md
   git commit -m "feat: add DOC_SYNC_CHECKLIST + tighten doc-sync rules (retire vague §4 sentence)"
   ```
