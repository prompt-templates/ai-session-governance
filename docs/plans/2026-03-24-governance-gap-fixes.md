# Governance Gap Fixes Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Apply 6 targeted governance improvements to AGENTS.md and mirror each change to INIT.md FILE 1, fixing real AI behavioral gaps identified from field usage without anchoring to any specific project type.

**Architecture:** All changes are precision edits to existing sections — no new sections added. GAP 6 is a consolidation (net line reduction). GAP 2 adds a named block. GAPs 1, 3, 4, 5 are wording-only changes. Every change in AGENTS.md must be identically mirrored in INIT.md FILE 1 (the fenced block starting at line 43).

**Source of truth:** `AGENTS.md` is SSOT. `INIT.md` FILE 1 is the mirror. Always edit AGENTS.md first, then mirror.

**Fence count invariant:** AGENTS.md = 16 (even), INIT.md = 26 (even). None of these changes add or remove fenced code blocks, so counts must remain identical after all edits.

---

## Pre-flight Checks

Before touching any file, verify:

```bash
# Confirm working tree is clean
git status --short
# Expected: empty output (no modifications)

# Confirm fence counts are at baseline
grep -c '^\`\`\`' AGENTS.md
# Expected: 16

grep -c '^\`\`\`' INIT.md
# Expected: 26
```

If either count is wrong or tree is dirty — **stop and investigate before proceeding**.

---

## Task 1: GAP 6 — §1 Structured "New Session" Definition (Consolidation)

**Files:**
- Modify: `AGENTS.md` lines 94–102
- Mirror: `INIT.md` lines 137–145

**What this fixes:** The compaction recovery rule (v1.8.0) was added as an afterthought paragraph after the file-reading list. AI reading §1 encounters "At the start of every new session" and may not realize compaction and agent-handoff are also §1 triggers. Restructuring into an explicit definition at the top makes all 3 triggers immediately visible.

**Step 1: Edit AGENTS.md — replace opening + delete compaction paragraph**

Current block (lines 94–102):
```
## 1) Single Entry (Mandatory)
At the start of every new session, the AI must read the following files in this order:

1. `dev/SESSION_HANDOFF.md`
...

Context compaction recovery (additional §1 trigger): If the AI detects that its current session context has been compacted — that is, the conversation history has been compressed into a summary by the platform — it must re-execute the §1 startup sequence before resuming any pending tasks listed in the summary. The compaction summary is not an authoritative source for project state, pending tasks, risks, or open items. The actual governance files (`dev/SESSION_HANDOFF.md`, `dev/SESSION_LOG.md`) always take priority per §2.
```

Replace with:
```
## 1) Single Entry (Mandatory)
**Definition of "new session"** — any of the following triggers the full §1 startup sequence below:
1. A fresh conversation / thread
2. Context compaction / context recovery — the conversation history has been compressed into a summary by the platform; the compaction summary is not an authoritative source for project state, pending tasks, risks, or open items; actual governance files always take priority per §2
3. Agent handoff — a different AI agent takes over

At the start of every new session, the AI must read the following files in this order:
```

The standalone compaction paragraph (line 102 in AGENTS.md / line 145 in INIT.md) is **deleted** — its content is now folded into item 2 of the definition above.

**Step 2: Mirror the same change to INIT.md FILE 1** (lines 137–145, same pattern)

**Step 3: Verify**
```bash
grep -c "Definition of.*new session" AGENTS.md     # Expected: 1
grep -c "Definition of.*new session" INIT.md        # Expected: 1
grep -c "Context compaction recovery (additional" AGENTS.md  # Expected: 0
grep -c "Context compaction recovery (additional" INIT.md    # Expected: 0
grep -c "Agent handoff" AGENTS.md                   # Expected: 1
grep -c "Agent handoff" INIT.md                     # Expected: 1
```

**Step 4: Verify fence counts unchanged**
```bash
grep -c '^\`\`\`' AGENTS.md   # Expected: 16
grep -c '^\`\`\`' INIT.md     # Expected: 26
```

---

## Task 2: GAP 1 — §3 PERSIST Explicit Cross-Doc Sync

**Files:**
- Modify: `AGENTS.md` line 234 (§3 item 5)
- Mirror: `INIT.md` line 277

**What this fixes:** §3 PERSIST item 5 says "relevant specifications" — "relevant" is a self-assessed filter AI consistently reads as "nothing extra needed." When a session has multiple tasks without a full closeout, CODEBASE_CONTEXT never gets updated even when it should. The fix makes the trigger conditions explicit by referencing the same conditions already defined in §4.

**Step 1: Edit AGENTS.md §3 PERSIST**

Current (line 233–235):
```
5. PERSIST
   - Update handoff / log / relevant specifications to ensure the next session can continue
```

Replace with:
```
5. PERSIST
   - Update `dev/SESSION_HANDOFF.md` and `dev/SESSION_LOG.md`
   - Apply the same cross-document sync conditions as §4 closeout: if tech stack, directory structure, build commands, external services, or Key Decisions changed in this task — update `dev/CODEBASE_CONTEXT.md` now, do not defer to closeout
   - If `dev/PROJECT_MASTER_SPEC.md` exists and carries status for the completed work — update it in the same pass
```

**Step 2: Mirror to INIT.md FILE 1** (line 276–278, same pattern)

**Step 3: Verify**
```bash
grep -c "same cross-document sync conditions as §4" AGENTS.md   # Expected: 1
grep -c "same cross-document sync conditions as §4" INIT.md     # Expected: 1
grep -c "relevant specifications to ensure" AGENTS.md           # Expected: 0
grep -c "relevant specifications to ensure" INIT.md             # Expected: 0
```

---

## Task 3: GAP 2 — §4 Open Priorities Regeneration Rule

**Files:**
- Modify: `AGENTS.md` — insert new block between line 348 and "Supplementary rules:" line
- Mirror: `INIT.md` — same insertion point (between line 391 and "Supplementary rules:")

**What this fixes:** AI consistently copy-pastes Open Priorities forward and appends new items, never removing completed ones. After 10+ sessions the list is entirely stale. No existing rule says "replace" instead of "append."

**Step 1: Edit AGENTS.md — insert block after "6. Risks or blockers" and before "Supplementary rules:"**

Insert after the "6. Risks or blockers" line:
```

**Open Priorities regeneration** (mandatory at every closeout):
The `Open Priorities` section of `dev/SESSION_HANDOFF.md` must be regenerated at every closeout — not copy-pasted forward:
1. Remove any item completed this session
2. Scan `dev/SESSION_LOG.md` recent entries for newly surfaced pending items — add those
3. Re-rank and overwrite the previous list (replace, not append)
Hard rule: do not copy-paste old priorities without re-checking against current project state.
```

**Step 2: Mirror to INIT.md FILE 1** (same insertion point)

**Step 3: Verify**
```bash
grep -c "Open Priorities regeneration" AGENTS.md    # Expected: 1
grep -c "Open Priorities regeneration" INIT.md      # Expected: 1
grep -c "replace, not append" AGENTS.md             # Expected: 1
grep -c "replace, not append" INIT.md               # Expected: 1
```

---

## Task 4: GAP 5 — §4 Item 5 "max 3" Clarification

**Files:**
- Modify: `AGENTS.md` line 347
- Mirror: `INIT.md` line 390

**What this fixes:** AI occasionally treats "max 3" as the capacity of HANDOFF Open Priorities, dropping important items. It is a SESSION_LOG summary field limit only.

**Step 1: Edit AGENTS.md line 347**

Current:
```
5. Next priorities (max 3)
```

Replace with:
```
5. Next priorities (max 3 — SESSION_LOG summary field only; full prioritized list lives in `dev/SESSION_HANDOFF.md` Open Priorities)
```

**Step 2: Mirror to INIT.md FILE 1** (line 390)

**Step 3: Verify**
```bash
grep -c "SESSION_LOG summary field only" AGENTS.md   # Expected: 1
grep -c "SESSION_LOG summary field only" INIT.md     # Expected: 1
```

---

## Task 5: GAP 4 — §10 Recording Location "Known Risks only"

**Files:**
- Modify: `AGENTS.md` line 592
- Mirror: `INIT.md` line 635

**What this fixes:** §10 says to record PROJECT_MASTER_SPEC suggestion in "Open Priorities or Known Risks." Since Open Priorities is now regenerated (Task 3), an entry there would be lost on next closeout. The suggestion is a persistent advisory note, not a task — it belongs in Known Risks only.

**Step 1: Edit AGENTS.md line 592**

Current:
```
When the suggestion is made, record a line in `dev/SESSION_HANDOFF.md` under Open Priorities or Known Risks: `PROJECT_MASTER_SPEC suggestion issued: [session ID] [date].`
```

Replace with:
```
When the suggestion is made, record a line in `dev/SESSION_HANDOFF.md` under **Known Risks** (not Open Priorities — that section is regenerated and would lose the entry): `PROJECT_MASTER_SPEC suggestion issued: [session ID] [date].`
```

**Step 2: Mirror to INIT.md FILE 1** (line 635)

**Step 3: Verify**
```bash
grep -c "Known Risks.*not Open Priorities" AGENTS.md   # Expected: 1
grep -c "Known Risks.*not Open Priorities" INIT.md     # Expected: 1
grep -c "Open Priorities or Known Risks" AGENTS.md     # Expected: 0
grep -c "Open Priorities or Known Risks" INIT.md       # Expected: 0
```

---

## Task 6: GAP 3 — §5.7 Precision Wording

**Files:**
- Modify: `AGENTS.md` line 436
- Mirror: `INIT.md` line 479

**What this fixes:** "file system operations" is ambiguous — git push can be read as a file system operation (it modifies .git/). The prohibition intent is destructive modifications (create, delete, overwrite, move, rename), not network/VCS operations. Tightening the wording eliminates the ambiguity without creating any exemption loophole.

**Step 1: Edit AGENTS.md line 436**

Current:
```
7. Strictly prohibited from invoking external shells (e.g. `cmd /c`, `sh -c`, `bash -c`, `powershell -Command`) to perform file system operations; must use the current environment's native commands with direct arguments
```

Replace with:
```
7. Strictly prohibited from invoking external shells (e.g. `cmd /c`, `sh -c`, `bash -c`, `powershell -Command`) to perform file system modification operations (create, delete, overwrite, move, rename); must use the current environment's native commands with direct arguments
```

**Step 2: Mirror to INIT.md FILE 1** (line 479)

**Step 3: Verify**
```bash
grep -c "modification operations (create, delete" AGENTS.md   # Expected: 1
grep -c "modification operations (create, delete" INIT.md     # Expected: 1
grep -c "to perform file system operations;" AGENTS.md        # Expected: 0
grep -c "to perform file system operations;" INIT.md          # Expected: 0
```

---

## Final QC — All Changes

Run all verification checks together:

```bash
# Task 1 — GAP 6
grep -c "Definition of.*new session" AGENTS.md
grep -c "Context compaction recovery (additional" AGENTS.md

# Task 2 — GAP 1
grep -c "same cross-document sync conditions as §4" AGENTS.md
grep -c "relevant specifications to ensure" AGENTS.md

# Task 3 — GAP 2
grep -c "Open Priorities regeneration" AGENTS.md
grep -c "replace, not append" AGENTS.md

# Task 4 — GAP 5
grep -c "SESSION_LOG summary field only" AGENTS.md

# Task 5 — GAP 4
grep -c "Known Risks.*not Open Priorities" AGENTS.md
grep -c "Open Priorities or Known Risks" AGENTS.md

# Task 6 — GAP 3
grep -c "modification operations (create, delete" AGENTS.md
grep -c "to perform file system operations;" AGENTS.md

# Fence count invariant
grep -c '^\`\`\`' AGENTS.md   # Expected: 16
grep -c '^\`\`\`' INIT.md     # Expected: 26
```

**Expected pattern:** All presence checks → 1, all absence checks → 0, fence counts unchanged.

Repeat every grep check against INIT.md — all results must be identical.

---

## PERSIST

After all tasks pass QC:

1. Update `dev/SESSION_HANDOFF.md` — record completed changes, update baseline to reflect new governance version (v1.9.0 candidate)
2. Update `dev/SESSION_LOG.md` — new session entry with Problem→Root Cause→Fix→Verification for each gap
3. Commit: `git add AGENTS.md INIT.md && git commit -m "fix: apply 6 governance gap fixes (GAP 1/2/3/4/5/6)"`
