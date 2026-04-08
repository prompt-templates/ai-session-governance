# Governance Audit Fixes (7+1) Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Apply 7 governance clarifications + 1 parity bug fix identified through systematic audit of AGENTS.md, all stress-tested for net-positive impact. No new sections added. ~25 lines total across both files.

**Architecture:** All changes are precision edits to existing sections in AGENTS.md, each mirrored to INIT.md FILE 1 (offset +43). The FILE 4 fix is INIT.md only. No fenced code blocks added or removed — fence counts must remain AGENTS=16, INIT=28.

**Source of truth:** `AGENTS.md` is SSOT. `INIT.md` FILE 1 is the mirror. Always edit AGENTS.md first, then mirror.

**Fence count invariant:** AGENTS.md = 16, INIT.md = 28. All changes are text-only — no fences added/removed.

---

## Pre-flight Checks

```bash
git status --short
# Expected: only dev/copy_html.py untracked

grep -c "^\`\`\`" AGENTS.md
# Expected: 16

grep -c "^\`\`\`" INIT.md
# Expected: 28
```

---

## Task 1: A1 — §3 PLAN display requirement

**Files:**
- Modify: `AGENTS.md:225-227` (§3 item 1 PLAN)
- Mirror: `INIT.md:268-270` (same content, offset +43)

**What this fixes:** PLAN phase defines objective but doesn't require AI to make its understanding visible. User can't catch misinterpretation before CHANGE begins.

**Edit — append after "acceptance criteria" line:**

AGENTS.md line 226, after `- Objective, scope, risks, acceptance criteria` add:
```
   - State explicitly: "My understanding: [1-sentence restatement of user intent]", "Impact scope: [files/modules to be modified]", "Assumptions: [any inferences not explicitly stated by user]"
```

Mirror identical edit at INIT.md line 269.

---

## Task 2: A2 — §2 conflict arbitration rule

**Files:**
- Modify: `AGENTS.md:185` (after §2 supplementary rule 5)
- Mirror: `INIT.md:228` (same content, offset +43)

**What this fixes:** No rule for when user instructions conflict with AGENTS.md governance rules. AI either silently complies or silently refuses — both unpredictable.

**Edit — append as supplementary rule 6:**

After line 185 (`5. If SESSION_LOG.md contains...`), add:
```
6. When a user instruction conflicts with a rule in this document: (a) state which rule is in conflict, (b) explain the risk of overriding, (c) if user confirms override — comply and record the override in `SESSION_LOG.md`.
```

Mirror identical edit at INIT.md (after line 228).

---

## Task 3: A4 — §2b triage exploratory read allowance

**Files:**
- Modify: `AGENTS.md:203` (after §2b "Before source classification is complete" list)
- Mirror: `INIT.md:246` (same content, offset +43)

**What this fixes:** §2b says classification must happen "before reading files" but classification requires reading files. Chicken-and-egg problem.

**Edit — add after line 203 (`3. Do not equate a single error message directly with the root cause`):**

```

Note: Targeted file reads for the purpose of determining issue source are permitted during triage. This does not substitute for the full §2c read coverage required before entering CHANGE.
```

Mirror identical edit at INIT.md (after line 246).

---

## Task 4: A5 — §3 CHANGE deviation stop rule

**Files:**
- Modify: `AGENTS.md:233` (§3 item 3 CHANGE)
- Mirror: `INIT.md:276` (same content, offset +43)

**What this fixes:** No guidance for when AI discovers mid-CHANGE that execution is diverging from PLAN. AI may self-correct in wrong direction.

**Edit — append after "Minimal necessary modifications, no unrelated refactoring":**

```
   - If execution diverges from PLAN (unexpected state, wrong assumptions, scope change needed): stop, report the divergence to the user, and wait for direction rather than attempting self-correction
```

Mirror identical edit at INIT.md line 276.

---

## Task 5: A3 — §8/§8b bridging sentence

**Files:**
- Modify: `AGENTS.md:605` (after §8b hard rule 3)
- Mirror: `INIT.md:648` (same content, offset +43)

**What this fixes:** §8 says "MUST codify" on single user-visible error; §8b says "only if repeated." Intersection zone has no resolution path.

**Edit — add after line 605 (`3. Each time a new long-term rule is added, check whether old rules can be integrated or retired`):**

```

Reconciling §8 and §8b: §8 ensures lessons are captured; §8b prevents overreaction. When §8 triggers (e.g. first-time user-visible error) but §8b criteria suggest no promotion: record the full lesson in `SESSION_LOG.md` and mark as `monitoring — promote to rule if recurrence is observed`.
```

Mirror identical edit at INIT.md (after line 648).

---

## Task 6: B1 — §11 scope narrowing

**Files:**
- Modify: `AGENTS.md:653-659` (§11 Output Contract)
- Mirror: `INIT.md:696-702` (same content, offset +43)

**What this fixes:** "Every AI response" is overly broad — forces filler output on clarifying questions and simple answers.

**Edit — replace the opening sentence:**

Old: `Every AI response must include at minimum:`
New: `Every AI response that includes a CHANGE or PERSIST phase must include at minimum:`

Add after the list (after line 659 `4. Next-step recommendations (if any)`):
```

Responses that contain only clarifying questions, status updates, or simple information lookups are not bound by this contract but should remain clear and useful.
```

Mirror identical edits at INIT.md lines 696-702.

---

## Task 7: FILE 4 — INIT.md template checklist fix

**Files:**
- Modify: `INIT.md:766-770` only (FILE 4 template — not in AGENTS.md)

**What this fixes:** FILE 4 template's Mandatory Start Checklist skips `dev/CODEBASE_CONTEXT.md`, inconsistent with §1 startup sequence.

**Edit — insert new item 3 and renumber:**

Old:
```
1. Read `dev/SESSION_HANDOFF.md`
2. Read `dev/SESSION_LOG.md`
3. Read `dev/PROJECT_MASTER_SPEC.md` (if exists)
4. Confirm working tree / file status
```

New:
```
1. Read `dev/SESSION_HANDOFF.md`
2. Read `dev/SESSION_LOG.md`
3. Read `dev/CODEBASE_CONTEXT.md` (if exists)
4. Read `dev/PROJECT_MASTER_SPEC.md` (if exists)
5. Confirm working tree / file status
```

Renumber remaining items 5→6, 6→7, 7→8, 8→9, 9→10.

---

## Post-edit Verification

### Fence count check
```bash
grep -c "^\`\`\`" AGENTS.md   # Expected: 16
grep -c "^\`\`\`" INIT.md     # Expected: 28
```

### Parity spot-checks
```bash
# A1: PLAN display requirement
grep -c "My understanding.*1-sentence restatement" AGENTS.md   # Expected: 1
grep -c "My understanding.*1-sentence restatement" INIT.md     # Expected: 1

# A2: Conflict arbitration
grep -c "user instruction conflicts.*rule in this document" AGENTS.md   # Expected: 1
grep -c "user instruction conflicts.*rule in this document" INIT.md     # Expected: 1

# A3: §8/§8b bridging
grep -c "monitoring.*promote to rule if recurrence" AGENTS.md   # Expected: 1
grep -c "monitoring.*promote to rule if recurrence" INIT.md     # Expected: 1

# A4: Triage read allowance
grep -c "Targeted file reads.*during triage" AGENTS.md   # Expected: 1
grep -c "Targeted file reads.*during triage" INIT.md     # Expected: 1

# A5: CHANGE deviation
grep -c "diverges from PLAN.*stop.*report" AGENTS.md   # Expected: 1
grep -c "diverges from PLAN.*stop.*report" INIT.md     # Expected: 1

# B1: §11 scope
grep -c "CHANGE or PERSIST phase" AGENTS.md   # Expected: 1
grep -c "CHANGE or PERSIST phase" INIT.md     # Expected: 1

# B1: §11 exemption
grep -c "clarifying questions.*status updates" AGENTS.md   # Expected: 1
grep -c "clarifying questions.*status updates" INIT.md     # Expected: 1

# FILE 4: CODEBASE_CONTEXT in template checklist
grep -c "CODEBASE_CONTEXT" INIT.md   # Expected: previous count + 1
```

### Full QA regression (139 existing + new checks)
Run all existing checks from QA_REGRESSION_REPORT.md, then add new checks for each change.
