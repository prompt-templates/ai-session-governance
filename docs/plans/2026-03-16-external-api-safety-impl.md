# External API Code Safety Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add External API Code Safety subsection to §0b in AGENTS.md and INIT.md, with full regression coverage across new-user, existing-user, and API-writing scenarios.

**Architecture:** Single §0b subsection addition defines verification ritual + block format + staleness rules. CODEBASE_CONTEXT External Services section becomes the project-level API SSOT. No new files created.

**Tech Stack:** Markdown governance documents. Verification via grep content checks.

---

## Task 1: Add External API Code Safety subsection to AGENTS.md §0b

**Files:**
- Modify: `AGENTS.md` (§0b section, after "Must clearly label which items have been verified")

**Step 1: Locate the end of existing §0b**

Find this exact text (end of §0b):
```
If alignment is not completed:
1. Do not treat guesses as conclusions
2. Do not directly output high-risk operation commands
3. Must clearly label which items have been verified and which are pending verification
```

**Step 2: Insert new subsection immediately after**

Append after rule 3, before the `---` separator:

```
### External API Code Safety (Mandatory when writing API-calling code)

Before writing any code that calls an external API endpoint, the AI must:
1. Fetch current official documentation for the specific endpoint
2. Record the following in `dev/CODEBASE_CONTEXT.md` External Services before writing code:
   - Base URL and endpoint path (do not assume from memory)
   - Current API version in use
   - Authentication method and header format
   - Required parameters
   - Forbidden / deprecated parameters
   - Response schema and the exact parsing path for needed data
   - Official documentation URL
   - `Doc-reviewed: <date> (<session ID>)`
3. If official documentation cannot be fetched:
   - Do not write API-calling code
   - State what is blocked and why
   - Ask the user to provide the relevant documentation
4. Training-data knowledge of any API must never be the sole source for endpoint paths, parameter names, or response structure. Always treat prior knowledge as "possibly outdated — verify first".

External Services block format in `dev/CODEBASE_CONTEXT.md`:

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

When reading an existing External Services block before writing code:
1. `Test-verified` present → reliable; re-verify the specific endpoint and params in use if entry is from a prior session
2. Only `Doc-reviewed` present → use with caution; annotate generated code with `# awaiting test-verification`
3. Both empty or missing → full verification ritual required before writing code
4. After any re-verification: update the relevant date and session ID in the block
5. If re-verification reveals API changes: update affected fields, record before/after in Notes, flag affected existing code for review
```

**Step 3: Verify insertion**
```
grep -n "External API Code Safety\|Doc-reviewed\|Test-verified\|awaiting test-verification" AGENTS.md
```
Expected: all 4 terms found in §0b area.

**Step 4: Verify §0b original content untouched**
```
grep -n "Do not treat guesses\|Do not directly output high-risk\|Must clearly label" AGENTS.md
```
Expected: all 3 original rules still present.

**Step 5: Fence count check**
```
grep -c "^\`\`\`" AGENTS.md
```
Expected: even number.

---

## Task 2: Mirror §0b addition to INIT.md FILE 1 embedded copy

**Files:**
- Modify: `INIT.md` (§0b section inside FILE 1 fenced block)

**Step 1: Locate §0b end in INIT.md FILE 1**

Find (inside the FILE 1 block, will appear once):
```
If alignment is not completed:
1. Do not treat guesses as conclusions
2. Do not directly output high-risk operation commands
3. Must clearly label which items have been verified and which are pending verification
```

**Step 2: Insert identical subsection as Task 1**

Apply the exact same text block as Task 1 Step 2.

**Step 3: Verify INIT.md matches AGENTS.md**
```
grep -c "External API Code Safety\|Doc-reviewed\|Test-verified\|awaiting test-verification" AGENTS.md
grep -c "External API Code Safety\|Doc-reviewed\|Test-verified\|awaiting test-verification" INIT.md
```
Expected: INIT.md count ≥ AGENTS.md count.

**Step 4: Fence count check**
```
grep -c "^\`\`\`" INIT.md
```
Expected: even number.

---

## Task 3: Full regression check

This task verifies no existing rules were broken. Run ALL checks and report pass/fail per item.

### 3A — New feature present

```
grep -c "External API Code Safety" AGENTS.md INIT.md
```
Expected: 1 in AGENTS.md, 1 in INIT.md

```
grep -c "Doc-reviewed" AGENTS.md INIT.md
```
Expected: ≥ 1 each

```
grep -c "Test-verified" AGENTS.md INIT.md
```
Expected: ≥ 1 each

### 3B — §0a rules untouched

```
grep -n "Product / System Layer\|Development Governance Layer\|by path convention" AGENTS.md
```
Expected: all 3 present in §0a area.

### 3C — §1 startup sequence intact

```
grep -A 6 "the AI must read the following files" AGENTS.md
```
Expected: SESSION_HANDOFF → SESSION_LOG → CODEBASE_CONTEXT → PROJECT_MASTER_SPEC in order.

```
grep -c "generate it during the first session" AGENTS.md INIT.md
```
Expected: 1 in each.

### 3D — §4 CODEBASE_CONTEXT closeout condition intact

```
grep -c "new entry appended to the.*AI Maintenance Log" AGENTS.md INIT.md
```
Expected: 1 in each.

### 3E — §5a backup list intact

```
grep -c "CODEBASE_CONTEXT.md.*if present\|if present.*CODEBASE_CONTEXT" AGENTS.md INIT.md
```
Expected: 1 in AGENTS.md, 2 in INIT.md (main flow + FILE 1).

### 3F — §10 active trigger uses intent-based logic

```
grep -c "explicitly requested" AGENTS.md INIT.md
```
Expected: 1 in each.

```
grep -c "2 or more completed session entries" AGENTS.md INIT.md
```
Expected: 0 in each (old mechanical trigger must be gone).

### 3G — §10 filename enforcement intact

```
grep -c "Filename enforcement" AGENTS.md INIT.md
```
Expected: 1 in each.

### 3H — INIT.md installation flow: CODEBASE_CONTEXT NOT created at install

```
grep -n "is not created during install\|auto-generated.*first session" INIT.md
```
Expected: present in post-install confirmation area.

### 3I — INIT.md backup list covers CODEBASE_CONTEXT (both occurrences)

```
grep -c "CODEBASE_CONTEXT.md.*if present" INIT.md
```
Expected: 2 (main ROOT SAFETY CHECK + FILE 1 §5a).

### 3J — Fence counts both even

```
grep -c "^\`\`\`" AGENTS.md
grep -c "^\`\`\`" INIT.md
```
Expected: both even numbers.

### 3K — No "key architectural" terminology residue

```
grep -c "key architectural" AGENTS.md INIT.md
```
Expected: 0 in each.

### 3L — Installation scenario: new user

Verify INIT.md ROOT SAFETY CHECK flow still intact:
```
grep -n "INSTALL_ROOT_OK\|INSTALL_WRITE_OK" INIT.md
```
Expected: both confirmation tokens present.

### 3M — Installation scenario: existing user backup

```
grep -n "init_backup" INIT.md
```
Expected: present with UTC timestamp format reference.

---

## Task 4: Update QA regression report

**Files:**
- Modify: `docs/qa/QA_REGRESSION_REPORT.md`
- Modify: `docs/qa/LATEST.md`

**Step 1: Add new checks to QA_REGRESSION_REPORT.md**

Add a new section for this feature's checks (items 30-42 extending from current 29):
- External API Code Safety subsection present in AGENTS.md §0b
- External API Code Safety subsection present in INIT.md FILE 1 §0b
- Doc-reviewed field defined in block format
- Test-verified field defined in block format
- Verification ritual (4 steps) present
- Staleness/re-verification rules (5 items) present
- "Cannot fetch docs → stop" rule present
- AGENTS.md/INIT.md parity for §0b (count match)
- §1 startup sequence order unchanged
- §10 intent-based trigger present (not mechanical count)
- §5a + INIT.md backup lists include CODEBASE_CONTEXT
- Fence counts even
- No "key architectural" residue

Update summary totals.

**Step 2: Update LATEST.md**

Update date and check counts.

---

## Task 5: Commit

```bash
cd D:/_Adam_Projects/KnowledgeDB/_Prompt_Template/ai-session-governance
git add AGENTS.md INIT.md docs/qa/QA_REGRESSION_REPORT.md docs/qa/LATEST.md docs/plans/2026-03-16-external-api-safety-design.md docs/plans/2026-03-16-external-api-safety-impl.md
git commit -m "feat: add External API Code Safety rules to §0b with Doc-reviewed/Test-verified tracking

- Mandatory verification ritual before writing any API-calling code
- Two-status tracking: Doc-reviewed (docs read) vs Test-verified (call confirmed)
- External Services block format defined as project SSOT in CODEBASE_CONTEXT
- Staleness and re-verification rules for existing blocks
- Cannot-fetch-docs → stop rule (no guessing fallback)
- Applies to ALL external APIs, not anchored to any specific platform
- Mirror all changes to INIT.md embedded copy
- Full regression: 13 existing rules verified intact, 13 new checks added

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
```

---

## Acceptance Criteria

- [ ] `External API Code Safety` heading present in AGENTS.md §0b
- [ ] `External API Code Safety` heading present in INIT.md FILE 1 §0b
- [ ] Block format includes `Doc-reviewed` and `Test-verified` fields
- [ ] 4-step verification ritual present
- [ ] 5-item staleness rule present
- [ ] "cannot be fetched → do not write code" rule present
- [ ] INIT.md count of key terms ≥ AGENTS.md count
- [ ] All 13 regression checks (3B–3M) PASS
- [ ] Fence counts even in both files
- [ ] QA report updated with new check count
