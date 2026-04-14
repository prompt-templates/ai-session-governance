# Harness Optimization: Attention Restructure + Consolidation + Gap Fixes

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Improve AGENTS.md attention positioning for core rules, consolidate redundancies (-24 lines), and fill 4 behavioral gaps (+12 lines), achieving net -12 lines while adding functionality.

**Architecture:** Nine precision edits to AGENTS.md, each mirrored to INIT.md FILE 1. One README edit (×4 languages). No section renumbering. No new files. All QA checks are grep-based (position-independent) — reordering does not break them.

**Source of truth:** `AGENTS.md` is SSOT. `INIT.md` FILE 1 is the mirror. Always edit AGENTS.md first, then mirror.

**Fence count invariant:** AGENTS.md = 16, INIT.md = 28. No fenced code blocks added or removed in any task.

**INIT.md FILE 1 offset:** INIT.md FILE 1 starts at line 44 (`# AGENTS.md instructions for <PROJECT_ROOT>`). Add +43 to AGENTS.md line numbers to find the corresponding INIT.md location.

---

## Pre-flight Checks

```bash
git status --short
# Expected: untracked files only (no staged/modified tracked files)

grep -c "^## " AGENTS.md
# Expected: 22 (sections §0 through §12)

grep -c '^\`\`\`' AGENTS.md
# Expected: 16

grep -c '^\`\`\`' INIT.md
# Expected: 28

wc -l AGENTS.md
# Expected: 695
```

---

## Task 1: Add attention anchor (I)

**What:** Add 3-line critical-rules pointer block at the very top of AGENTS.md, immediately after the section markers (line 8) and before §0 (line 10).

**Files:**
- Modify: `AGENTS.md:8-10`
- Modify: `INIT.md` FILE 1 (same location, offset +43)

**Step 1: Edit AGENTS.md**

Insert between line 8 (`<!-- REFERENCE ... -->`) and line 10 (`## 0) Purpose`):

```
**CORE RULES — apply to every task without exception:**
§3 Standard Workflow: PLAN → READ → CHANGE → QC → PERSIST
§4 Session Close: update SESSION_HANDOFF.md + SESSION_LOG.md
§5 File Safety: no destructive operations without explicit user approval
```

**Step 2: Mirror to INIT.md FILE 1**

Same insertion at the corresponding location in INIT.md (after section markers, before §0).

**Step 3: Verify**

```bash
grep -c "CORE RULES" AGENTS.md
# Expected: 1

grep -c "CORE RULES" INIT.md
# Expected: 1
```

---

## Task 2: Move §0b after §2 (H)

**What:** Cut the entire §0b section (lines 38-96 in AGENTS.md, from `## 0b)` through the `---` separator before `## 1)`) and paste it after §2's closing `---` separator (currently line 188), before §2b. This moves §3 up by ~61 lines.

**Files:**
- Modify: `AGENTS.md` (cut lines 38-96, paste after current line 188)
- Modify: `INIT.md` FILE 1 (mirror same move)

**Step 1: Edit AGENTS.md**

1. Cut the block from `## 0b) External Platform Alignment` through (and including) its trailing `---` separator
2. Paste it between §2's `---` (end of supplementary rule 6) and `## 2b) Issue Triage`
3. The section markers at the top already classify §0b as CONDITIONAL — no change needed there

**Step 2: Mirror to INIT.md FILE 1**

Same block move at offset +43.

**Step 3: Verify**

```bash
# §0b should now appear AFTER §2 and BEFORE §2b
grep -n "^## 0b)" AGENTS.md
# Expected: line ~130 (was 38)

grep -n "^## 1)" AGENTS.md
# Expected: line ~38 (was 98)

grep -n "^## 3)" AGENTS.md
# Expected: line ~164 (was 225)

# All 22 section headings still present
grep -c "^## " AGENTS.md
# Expected: 22

# Fence counts unchanged
grep -c '^\`\`\`' AGENTS.md
# Expected: 16
```

---

## Task 3: Consolidate §2 — reference §1 list instead of repeating (F)

**What:** Replace §2's 4-file list (lines 173-176 in original, will be at new positions after Task 2) with a reference to §1's list, keeping only items 5-6 and the supplementary rules.

**Files:**
- Modify: `AGENTS.md` §2 section
- Modify: `INIT.md` FILE 1 (mirror)

**Step 1: Edit AGENTS.md**

Replace the §2 file list block:

BEFORE:
```
When documents conflict, the priority order is as follows:

1. `dev/SESSION_HANDOFF.md` (current baseline, execution thresholds, open items, current state)
2. `dev/SESSION_LOG.md` (latest changes, historical decisions, most recent fixes and verifications)
3. `dev/CODEBASE_CONTEXT.md` (if it exists; stable project facts — tech stack, External Services, Key Decisions)
4. `dev/PROJECT_MASTER_SPEC.md` (if it exists; long-term stable specifications, architecture, runbook, release rules)
5. Other README / docs / comments / tests
6. Verbal memory and speculation (must not be used as a basis for decisions)
```

AFTER:
```
When documents conflict, defer to the §1 read order as priority (first = highest). Additionally:
5. Other README / docs / comments / tests
6. Verbal memory and speculation (must not be used as a basis for decisions)
```

**Step 2: Mirror to INIT.md FILE 1**

**Step 3: Verify**

```bash
grep -c "defer to the §1 read order" AGENTS.md
# Expected: 1

grep -c "defer to the §1 read order" INIT.md
# Expected: 1

# Original 4-file list in §2 should be gone
grep -c "current baseline, execution thresholds" AGENTS.md
# Expected: 0
```

---

## Task 4: Merge §2c into §3 READ (E)

**What:** Absorb §2c's content into §3 READ phase (expanding the one-line bullet), then delete §2c as a standalone section. Update the cross-reference in §2b.

**Files:**
- Modify: `AGENTS.md` — §3 READ phase, §2c section, §2b note
- Modify: `INIT.md` FILE 1 (mirror)
- Modify: `AGENTS.md` section markers (remove §2c from CONDITIONAL list)

**Step 1: Expand §3 READ phase**

BEFORE (§3 item 2):
```
2. READ
   - Read necessary files, verify current state, classify sources, check for duplicates and confirm impact scope
```

AFTER:
```
2. READ — minimum coverage before entering CHANGE:
   - Read the full context of the section to be modified in the target file
   - Search for other occurrences of the same term / rule / feature across the repo
   - Check whether a single source of truth already exists (SSOT / master spec / runbook / baseline definition)
   - Review the most recent `SESSION_LOG.md` entry related to the topic
   - Hard rules: do not modify after reading only a single fragment; do not add new rules without first checking for duplicates; if content on the same topic exists in multiple locations, determine whether consolidation is needed first
```

**Step 2: Delete §2c section**

Remove the entire `## 2c) Read Coverage Before Change (Mandatory)` section and its trailing `---`.

**Step 3: Update §2b cross-reference**

BEFORE (in §2b Note):
```
Note: Targeted file reads for the purpose of determining issue source are permitted during triage. This does not substitute for the full §2c read coverage required before entering CHANGE.
```

AFTER:
```
Note: Targeted file reads for the purpose of determining issue source are permitted during triage. This does not substitute for the full §3 READ coverage required before entering CHANGE.
```

**Step 4: Update section markers**

BEFORE:
```
<!-- CONDITIONAL — apply when triggered: §0b §2b §2c §3b §3c §3d §4a §5 §6 §7 §8 §8b §9 -->
```

AFTER:
```
<!-- CONDITIONAL — apply when triggered: §0b §2b §3b §3c §3d §4a §5 §6 §7 §8 §8b §9 -->
```

**Step 5: Mirror all changes to INIT.md FILE 1**

**Step 6: Verify**

```bash
# §2c heading should be gone
grep -c "^## 2c)" AGENTS.md
# Expected: 0

grep -c "^## 2c)" INIT.md
# Expected: 0

# §3 READ now has expanded content
grep -c "full context of the section to be modified" AGENTS.md
# Expected: 1

# Cross-reference updated
grep -c "§3 READ coverage" AGENTS.md
# Expected: 1

# §2c removed from section markers
grep "CONDITIONAL" AGENTS.md | grep -c "§2c"
# Expected: 0

# Fence counts unchanged
grep -c '^\`\`\`' AGENTS.md
# Expected: 16
```

---

## Task 5: Streamline DOC_SYNC Matrix Scan block (G)

**What:** Replace the dense single-paragraph DOC_SYNC instruction with a structured bullet list.

**Files:**
- Modify: `AGENTS.md` §3 PERSIST DOC_SYNC block
- Modify: `INIT.md` FILE 1 (mirror)

**Step 1: Edit AGENTS.md**

BEFORE (the long paragraph in §3 PERSIST):
```
   - **DOC_SYNC Matrix Scan (mandatory visible output)**: Before completing PERSIST, output a `### DOC_SYNC Matrix Scan` block in the response. If no files were created or modified during CHANGE: output `### DOC_SYNC Matrix Scan — SKIP (no file changes this task)`. If `dev/DOC_SYNC_CHECKLIST.md` exists: query the registry and list every matched row with columns `Change Category | Required Doc Updates | Status` (Status = `✓ Done`, `N/A`, or `⚠ Skipped (reason)`); update all required docs. If no row matches the current change: add the missing row to the registry first (anti-pattern guard), then list it with Status `✓ Row added`. If the registry does not exist: output `### DOC_SYNC Matrix Scan — SKIP (registry not present)`. Absence of this block in the response = scan was skipped; user may immediately request the agent to complete it.
```

AFTER:
```
   - **DOC_SYNC Matrix Scan (mandatory visible output):**
     - No file changes this task → `### DOC_SYNC Matrix Scan — SKIP (no file changes this task)`
     - Registry exists → list matched rows: `Change Category | Required Doc Updates | Status` (`✓ Done` / `N/A` / `⚠ Skipped (reason)`); update all required docs; no matching row → add it first (`✓ Row added`)
     - Registry absent → `### DOC_SYNC Matrix Scan — SKIP (registry not present)`
     - Absence of this block in the response = scan was skipped; user may immediately request the agent to complete it.
```

**Step 2: Mirror to INIT.md FILE 1**

**Step 3: Verify**

```bash
grep -c "DOC_SYNC Matrix Scan.*mandatory" AGENTS.md
# Expected: 1

grep -c "scan was skipped" AGENTS.md
# Expected: 1

grep -c "no file changes this task" AGENTS.md
# Expected: 1
```

---

## Task 6: Add QC fail-path (A)

**What:** Add 3 lines to §3 QC phase specifying what to do when tests/build fail.

**Files:**
- Modify: `AGENTS.md` §3 QC phase (after existing bullet 3)
- Modify: `INIT.md` FILE 1 (mirror)

**Step 1: Edit AGENTS.md**

After the existing QC bullet about batch deletion dry-run, add:

```
   - If QC reveals test failures or build errors: (a) report to user — what was attempted, what failed, and preliminary diagnosis; (b) do not return to CHANGE or retry without user direction; (c) provide failure summary, likely root cause, and proposed fix approach
```

**Step 2: Mirror to INIT.md FILE 1**

**Step 3: Verify**

```bash
grep -c "QC reveals test failures" AGENTS.md
# Expected: 1

grep -c "QC reveals test failures" INIT.md
# Expected: 1
```

---

## Task 7: Add CHANGE deviation resume guidance (B)

**What:** Add 3 lines after the existing A5 deviation-stop rule, specifying how to resume after user direction.

**Files:**
- Modify: `AGENTS.md` §3 CHANGE phase
- Modify: `INIT.md` FILE 1 (mirror)

**Step 1: Edit AGENTS.md**

After the existing deviation-stop line:
```
   - If execution diverges from PLAN (unexpected state, wrong assumptions, scope change needed): stop, report the divergence to the user, and wait for direction rather than attempting self-correction
```

Add:
```
   - After receiving user direction following a deviation stop: if scope or objective changed, restart from PLAN; if only approach changed, restart from CHANGE with updated context; in either case, state which phase is being re-entered and why
```

**Step 2: Mirror to INIT.md FILE 1**

**Step 3: Verify**

```bash
grep -c "deviation stop" AGENTS.md
# Expected: 2 (original rule + resume guidance)

grep -c "deviation stop" INIT.md
# Expected: 2
```

---

## Task 8: Add closeout ambiguity protection (D)

**What:** Add 1 line to §4 Session Close Rules, after the trigger list, to protect against false-positive closeout triggers.

**Files:**
- Modify: `AGENTS.md` §4
- Modify: `INIT.md` FILE 1 (mirror)

**Step 1: Edit AGENTS.md**

After:
```
- Any expression that can reasonably be interpreted as ending the current session
```

Add:
```
- If the expression is ambiguous (could refer to ending the current task rather than the session), confirm session-end intent before performing closeout
```

**Step 2: Mirror to INIT.md FILE 1**

**Step 3: Verify**

```bash
grep -c "confirm session-end intent" AGENTS.md
# Expected: 1

grep -c "confirm session-end intent" INIT.md
# Expected: 1
```

---

## Task 9: Add Codex 32 KiB note to README ×4 (C)

**What:** Add a note in each README's "Platform setup" section about Codex's 32 KiB default limit.

**Files:**
- Modify: `README.md` (EN)
- Modify: `README.zh-TW.md`
- Modify: `README.zh-CN.md`
- Modify: `README.ja.md`

**Step 1: Add note after Platform setup table in each README**

EN (`README.md`):
After the platform setup table, add:
```
> **Codex users:** AGENTS.md exceeds the default 32 KiB context limit. Add `project_doc_max_bytes = 49152` to `~/.codex/config.toml` to load the full file.
```

zh-TW (`README.zh-TW.md`):
```
> **Codex 用戶：** AGENTS.md 超過預設 32 KiB context 上限。請在 `~/.codex/config.toml` 中加入 `project_doc_max_bytes = 49152` 以載入完整檔案。
```

zh-CN (`README.zh-CN.md`):
```
> **Codex 用户：** AGENTS.md 超过默认 32 KiB context 上限。请在 `~/.codex/config.toml` 中添加 `project_doc_max_bytes = 49152` 以加载完整文件。
```

ja (`README.ja.md`):
```
> **Codexユーザー：** AGENTS.mdはデフォルトの32 KiBコンテキスト上限を超えています。完全なファイルを読み込むには、`~/.codex/config.toml`に`project_doc_max_bytes = 49152`を追加してください。
```

**Step 2: Verify**

```bash
grep -c "project_doc_max_bytes" README.md README.zh-TW.md README.zh-CN.md README.ja.md
# Expected: 1 per file (4 total)
```

---

## Post-flight Checks

```bash
# All section headings present (§2c removed = 21 instead of 22)
grep -c "^## " AGENTS.md
# Expected: 21

# Fence counts unchanged
grep -c '^\`\`\`' AGENTS.md
# Expected: 16

grep -c '^\`\`\`' INIT.md
# Expected: 28

# Attention anchor present
grep -c "CORE RULES" AGENTS.md
# Expected: 1

# §0b moved after §2
# Verify §1 appears BEFORE §0b
grep -n "^## 1)" AGENTS.md  # Should be ~line 38
grep -n "^## 0b)" AGENTS.md  # Should be ~line 130

# §3 position improved
grep -n "^## 3)" AGENTS.md  # Should be ~line 149 (was 225)

# New features present
grep -c "QC reveals test failures" AGENTS.md
# Expected: 1

grep -c "deviation stop" AGENTS.md
# Expected: 2

grep -c "confirm session-end intent" AGENTS.md
# Expected: 1

# Codex note in all READMEs
grep -c "project_doc_max_bytes" README.md README.zh-TW.md README.zh-CN.md README.ja.md
# Expected: 1 per file

# Parity: key phrases match between AGENTS.md and INIT.md
for phrase in "CORE RULES" "QC reveals test failures" "deviation stop" "confirm session-end intent" "defer to the §1 read order"; do
  a=$(grep -c "$phrase" AGENTS.md)
  i=$(grep -c "$phrase" INIT.md)
  echo "$phrase: AGENTS=$a INIT=$i $([ $a -eq $i ] && echo PASS || echo FAIL)"
done

# Existing QA regression checks (sample)
grep -c "My understanding.*1-sentence restatement" AGENTS.md  # Expected: 1
grep -c "Risk level.*HIGH or LOW" AGENTS.md                   # Expected: 1
grep -c "wait for user confirmation" AGENTS.md                 # Expected: 1
grep -c "lean key-value style" AGENTS.md                       # Expected: 1
grep -c "exceeds 400 lines" AGENTS.md                          # Expected: 1
grep -c "Never delete session entries" AGENTS.md               # Expected: 1
```

---

## Change Summary

| Task | Type | Lines Δ | Key metric |
|---|---|---|---|
| 1. Attention anchor (I) | Add | +4 | Core rules in highest attention position |
| 2. Move §0b (H) | Restructure | ±0 | §3 moves from line 225 → ~149 |
| 3. §2 consolidate (F) | Merge | -6 | Eliminate §1/§2 list duplication |
| 4. §2c → §3 READ (E) | Merge | -15 | Eliminate redundant section |
| 5. DOC_SYNC streamline (G) | Rewrite | -3 | Improved readability |
| 6. QC fail-path (A) | Add | +1 | Fill undefined workflow path |
| 7. Deviation resume (B) | Add | +1 | Complete A5 stop→resume flow |
| 8. Closeout protection (D) | Add | +1 | Prevent false-positive closeout |
| 9. Codex 32K note (C) | Add | +4 (READMEs) | Codex compatibility note |
| **Net AGENTS.md** | | **-18** | |
| **Net README ×4** | | **+4** | |
