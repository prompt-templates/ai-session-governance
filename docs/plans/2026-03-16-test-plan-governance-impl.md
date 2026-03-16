# Test Plan Governance Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add lightweight, flexible test plan design discipline to §3 workflow (PLAN + QC phases) and a new §3d subsection, covering code, governance, and prompt-engineering projects without locking to any specific tool or language.

**Architecture:** Three surgical edits to §3 Standard Workflow (PLAN bullet + QC bullet) plus one new §3d subsection inserted between §3c and §4. All changes mirrored to INIT.md FILE 1 embedded copy. No new files created.

**Tech Stack:** Markdown governance documents. Verification via grep content checks and fence-count checks.

---

## Task 1: Strengthen §3 PLAN phase in AGENTS.md

**Files:**
- Modify: `AGENTS.md` (§3 PLAN bullet, around line 211–212)

**Step 1: Locate exact text**

```
1. PLAN
   - Objective, scope, risks, acceptance criteria
```

**Step 2: Replace with**

```
1. PLAN
   - Objective, scope, risks, acceptance criteria
   - If task meets §3d trigger conditions: define test scenario matrix before proceeding to READ
```

**Step 3: Verify**

```bash
grep -n "test scenario matrix" AGENTS.md
```
Expected: 1 match in §3 PLAN area.

---

## Task 2: Strengthen §3 QC phase in AGENTS.md

**Files:**
- Modify: `AGENTS.md` (§3 QC bullet, around line 220–222)

**Step 1: Locate exact text**

```
4. QC
   - Run tests / checks, list results (test/check commands and key outcomes)
   - If the task involves batch deletion or batch modification, a dry-run (e.g. `ls` / `find` preview, PowerShell `-WhatIf`, etc.) with a "blast radius" list must be provided for confirmation first
```

**Step 2: Replace with**

```
4. QC
   - Run tests / checks, list results (test/check commands and key outcomes)
   - If a test scenario matrix was defined in PLAN (§3d): verify each scenario and record actual result; summarize overall as PASS / PASS with notes / FAIL
   - If the task involves batch deletion or batch modification, a dry-run (e.g. `ls` / `find` preview, PowerShell `-WhatIf`, etc.) with a "blast radius" list must be provided for confirmation first
```

**Step 3: Verify**

```bash
grep -n "verify each scenario\|PASS with notes" AGENTS.md
```
Expected: 1 match.

---

## Task 3: Add §3d Test Plan Design subsection to AGENTS.md

**Files:**
- Modify: `AGENTS.md` (insert after `## 3c)` block, before `## 4)`)

**Step 1: Locate the exact separator before §4**

Find this exact text (the closing separator of §3c):
```
4. Failure Rule
   - If any critical check fails, do not claim ready / release / GA

---

## 4) Session Close Rules (Mandatory)
```

**Step 2: Insert §3d before that separator**

Replace with:
```
4. Failure Rule
   - If any critical check fails, do not claim ready / release / GA

---

## 3d) Test Plan Design (Mandatory when applicable)

### Trigger conditions
Apply §3d when the task involves any of the following:
1. New user-facing features, commands, or behaviors
2. Changes to existing behavior (including governance rule changes)
3. External API or service integrations
4. Multi-step user flows (install, onboarding, upgrade paths)

Not required for: session log updates, whitespace / formatting only, comment-only changes.

### Scenario categories
For every applicable task, identify at least one scenario per relevant category:
1. Normal flow — expected inputs, happy path
2. Boundary / edge conditions — limits, empty inputs, first-run vs. repeat-run
3. Error / failure path — what happens when something is unavailable or wrong
4. Regression — existing behavior that must remain unchanged

Adapt categories to project type:
- Code projects: unit, integration, or E2E as appropriate
- Governance / documentation projects: rule presence checks, parity checks, grep-verifiable assertions
- Prompt engineering projects: output format checks, behavioral assertions

### Scenario format (fill Actual column at QC phase)

| Scenario | Precondition | Action / input | Expected | Actual | Result |
|---|---|---|---|---|---|
| [name] | [starting state] | [what happens] | [expected outcome] | [fill at QC] | PASS/FAIL |

### Recording location
- ≤5 scenarios: inline in current SESSION_LOG entry under `### Test Scenarios`
- >5 scenarios or spanning multiple sessions: reference in SESSION_HANDOFF `Regression / Verification Notes`; full matrix in SESSION_LOG
- At QC phase: fill in Actual column; summarize overall result in SESSION_LOG

---

## 4) Session Close Rules (Mandatory)
```

**Step 3: Verify insertion**

```bash
grep -n "3d) Test Plan Design\|Scenario categories\|Adapt categories\|Recording location" AGENTS.md
```
Expected: all 4 terms present.

**Step 4: Fence count check**

```bash
grep -c "^\`\`\`" AGENTS.md
```
Expected: even number.

---

## Task 4: Mirror all §3 changes to INIT.md FILE 1

**Files:**
- Modify: `INIT.md` (§3 section inside FILE 1 fenced block, lines ~251–320)

**Step 1: Apply identical PLAN bullet change as Task 1**

Find (inside FILE 1 block — appears once):
```
1. PLAN
   - Objective, scope, risks, acceptance criteria
```

Replace with:
```
1. PLAN
   - Objective, scope, risks, acceptance criteria
   - If task meets §3d trigger conditions: define test scenario matrix before proceeding to READ
```

**Step 2: Apply identical QC bullet change as Task 2**

Find (inside FILE 1 block — appears once):
```
4. QC
   - Run tests / checks, list results (test/check commands and key outcomes)
   - If the task involves batch deletion or batch modification, a dry-run (e.g. `ls` / `find` preview, PowerShell `-WhatIf`, etc.) with a "blast radius" list must be provided for confirmation first
```

Replace with:
```
4. QC
   - Run tests / checks, list results (test/check commands and key outcomes)
   - If a test scenario matrix was defined in PLAN (§3d): verify each scenario and record actual result; summarize overall as PASS / PASS with notes / FAIL
   - If the task involves batch deletion or batch modification, a dry-run (e.g. `ls` / `find` preview, PowerShell `-WhatIf`, etc.) with a "blast radius" list must be provided for confirmation first
```

**Step 3: Apply identical §3d insertion as Task 3**

Find (inside FILE 1 block — appears once):
```
4. Failure Rule
   - If any critical check fails, do not claim ready / release / GA

---

## 4) Session Close Rules (Mandatory)
```

Replace with the full §3d block (identical text as Task 3 Step 2).

**Step 4: Verify INIT.md matches AGENTS.md**

```bash
grep -c "3d) Test Plan Design\|test scenario matrix\|verify each scenario\|Adapt categories\|Recording location" AGENTS.md
grep -c "3d) Test Plan Design\|test scenario matrix\|verify each scenario\|Adapt categories\|Recording location" INIT.md
```
Expected: INIT.md count ≥ AGENTS.md count.

**Step 5: Fence count check**

```bash
grep -c "^\`\`\`" INIT.md
```
Expected: even number.

---

## Task 5: Full regression check

Run ALL checks and report pass/fail per item.

### 5A — New feature present

```bash
grep -c "3d) Test Plan Design" AGENTS.md INIT.md
```
Expected: 1 in each.

```bash
grep -c "test scenario matrix" AGENTS.md INIT.md
```
Expected: ≥1 in each (PLAN bullet + possibly §3d text).

```bash
grep -c "Adapt categories to project type" AGENTS.md INIT.md
```
Expected: 1 in each.

### 5B — §3 original workflow phases intact

```bash
grep -n "1. PLAN\|2. READ\|3. CHANGE\|4. QC\|5. PERSIST" AGENTS.md
```
Expected: all 5 phases present in §3 area.

### 5C — §3b and §3c unchanged

```bash
grep -c "Consolidation Pass" AGENTS.md INIT.md
```
Expected: ≥1 in each.

```bash
grep -c "Independent Review Pass" AGENTS.md INIT.md
```
Expected: 1 in each.

### 5D — External API Code Safety intact

```bash
grep -c "External API Code Safety" AGENTS.md INIT.md
```
Expected: 1 in each.

### 5E — §1 startup sequence intact

```bash
grep -c "generate it during the first session" AGENTS.md INIT.md
```
Expected: 1 in each.

### 5F — Fence counts even

```bash
grep -c "^\`\`\`" AGENTS.md INIT.md
```
Expected: both even numbers.

### 5G — No "key architectural" residue

```bash
grep -c "key architectural" AGENTS.md INIT.md
```
Expected: 0 in each.

---

## Task 6: Commit

```bash
cd D:/_Adam_Projects/KnowledgeDB/_Prompt_Template/ai-session-governance
git add AGENTS.md INIT.md docs/plans/2026-03-16-test-plan-governance-impl.md
git commit -m "feat: add §3d Test Plan Design — scenario matrix, trigger conditions, recording rules

- §3 PLAN: require scenario matrix definition when §3d triggers apply
- §3 QC: verify each scenario; record PASS / PASS with notes / FAIL
- §3d: new conditional subsection with 4 trigger conditions, 4 scenario
  categories, language-agnostic table format, recording location rules
- Adapts to code / governance / docs / prompt-engineering project types
- Mirror all changes to INIT.md FILE 1 embedded copy

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
```

---

## Acceptance Criteria

- [ ] `§3d) Test Plan Design` heading present in AGENTS.md and INIT.md
- [ ] §3 PLAN bullet references §3d trigger conditions
- [ ] §3 QC bullet references scenario matrix verification and PASS/FAIL summary
- [ ] 4 trigger conditions defined
- [ ] 4 scenario categories defined (Normal / Boundary / Error / Regression)
- [ ] Project-type adaptation note present (Code / Governance / Prompt)
- [ ] Scenario table format present
- [ ] Recording location rules present (≤5 inline / >5 in HANDOFF reference)
- [ ] AGENTS.md / INIT.md parity for all new terms
- [ ] Fence counts even in both files
- [ ] §3b, §3c, §0b, §1 content untouched
