# CODEBASE_CONTEXT Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add `dev/CODEBASE_CONTEXT.md` as a standard AI-maintained project context file, integrated into AGENTS.md startup/closeout/backup rules and INIT.md install flow.

**Architecture:** Two governance files updated (AGENTS.md + INIT.md), 6 precise surgical edits, no new files created by INIT (file is session-generated), full AGENTS/INIT parity maintained.

**Tech Stack:** Markdown only. Verification via grep checks and fence-count checks.

---

## Task 1: AGENTS.md §0a — Add layer clarification for CODEBASE_CONTEXT

**Files:**
- Modify: `AGENTS.md` (§0a Layer Separation section)

**Step 1: Locate current §0a Hard rules block**

Read `AGENTS.md` and find this exact text:
```
Hard rules:
1. Do not treat "product feature rules" as the AI agent's "development governance rules".
2. Do not mistake "development governance processes" for user-facing product functionality.
3. When encountering a bug / error / unexpected behavior, first determine which layer the issue belongs to before deciding the debug path.
4. Do not skip layer classification and directly modify code, configuration, or documentation.
```

**Step 2: Add clarifying note after Hard rules block**

Append after rule 4:
```
Note:
`dev/CODEBASE_CONTEXT.md` contains Product / System Layer content (tech stack, architecture, project conventions).
It is stored in `dev/` solely for governance tooling predictability, not because it belongs to the Development Governance Layer.
```

**Step 3: Verify**

Run grep check:
```
grep -n "CODEBASE_CONTEXT" AGENTS.md
```
Expected: at least 1 match in §0a area.

**Step 4: No commit yet** (continue to Task 2)

---

## Task 2: AGENTS.md §1 — Add CODEBASE_CONTEXT to startup read sequence

**Files:**
- Modify: `AGENTS.md` (§1 Single Entry section)

**Step 1: Locate current startup read list**

Find this exact text:
```
1. `dev/SESSION_HANDOFF.md`
2. `dev/SESSION_LOG.md`
3. `dev/PROJECT_MASTER_SPEC.md` (if it exists; serves as the advanced authoritative specification)

If any file is missing, the AI must create a minimal version before beginning development.
```

**Step 2: Replace with updated list**

```
1. `dev/SESSION_HANDOFF.md`
2. `dev/SESSION_LOG.md`
3. `dev/CODEBASE_CONTEXT.md` (if it exists; provides tech stack, directory map, build commands, and key architectural decisions)
4. `dev/PROJECT_MASTER_SPEC.md` (if it exists; serves as the advanced authoritative specification)

If `dev/SESSION_HANDOFF.md` or `dev/SESSION_LOG.md` is missing, the AI must create a minimal version before beginning development.

If `dev/CODEBASE_CONTEXT.md` does not exist, the AI must generate it during the first session:
1. Scan existing project files in this order: `README.md`, `docs/ARCHITECTURE.md`, `package.json` / `pyproject.toml` / `go.mod` / `Cargo.toml` (whichever apply), any other architecture or design docs found in `docs/`
2. Extract relevant information into the CODEBASE_CONTEXT template sections
3. Record source files scanned in the `AI Maintenance Log` section
4. Never modify the source files during this scan
```

**Step 3: Verify**

```
grep -n "CODEBASE_CONTEXT" AGENTS.md
```
Expected: matches in §1 area including the generation rule.

**Step 4: No commit yet**

---

## Task 3: AGENTS.md §4 — Add CODEBASE_CONTEXT to session close update rule

**Files:**
- Modify: `AGENTS.md` (§4 Session Close Rules section)

**Step 1: Locate the "must update at minimum" block**

Find this exact text:
```
At closeout, the following must be updated at minimum:
1. `dev/SESSION_HANDOFF.md`
2. `dev/SESSION_LOG.md`

If the session's changes involve specifications, acceptance criteria, runbooks, releases, baselines, regression thresholds, or external platform integrations, the corresponding documents must also be updated.
```

**Step 2: Replace with updated version**

```
At closeout, the following must be updated at minimum:
1. `dev/SESSION_HANDOFF.md`
2. `dev/SESSION_LOG.md`

If the session's changes involve specifications, acceptance criteria, runbooks, releases, baselines, regression thresholds, or external platform integrations, the corresponding documents must also be updated.

If the session's changes involve tech stack, directory structure, build commands, external services, or Key Decisions, `dev/CODEBASE_CONTEXT.md` must also be updated and the `AI Maintenance Log` section refreshed with the current session ID and a brief change summary.
```

**Step 3: Verify**

```
grep -n "CODEBASE_CONTEXT" AGENTS.md
```
Expected: matches in §4 area.

**Step 4: No commit yet**

---

## Task 4: AGENTS.md §5a — Add CODEBASE_CONTEXT to backup list

**Files:**
- Modify: `AGENTS.md` (§5a Root Scope Guard section)

**Step 1: Locate backup list**

Find this exact text:
```
   - Copy only existing target files (`AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `dev/SESSION_HANDOFF.md`, `dev/SESSION_LOG.md`, if present)
```

**Step 2: Replace with updated list**

```
   - Copy only existing target files (`AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `dev/SESSION_HANDOFF.md`, `dev/SESSION_LOG.md`, `dev/CODEBASE_CONTEXT.md`, if present)
```

**Step 3: Verify**

```
grep -n "CODEBASE_CONTEXT" AGENTS.md
```
Expected: match in §5a area.

**Step 4: No commit yet**

---

## Task 5: INIT.md — Mirror all changes (parity with AGENTS.md)

**Files:**
- Modify: `INIT.md` (2 locations)

**Step 1: Update backup list in INIT.md Step 9**

Find this exact text in INIT.md:
```
   - Copy only existing target files (`AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `dev/SESSION_HANDOFF.md`, `dev/SESSION_LOG.md`, if present)
```

Replace with:
```
   - Copy only existing target files (`AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `dev/SESSION_HANDOFF.md`, `dev/SESSION_LOG.md`, `dev/CODEBASE_CONTEXT.md`, if present)
```

**Step 2: Update INIT.md post-install confirmation block**

Find this exact text near the end of INIT.md:
```
Then say: "Governance setup complete. Start your next session with: Follow AGENTS.md"
```

Replace with:
```
Then say: "Governance setup complete. Start your next session with: Follow AGENTS.md

Note: `dev/CODEBASE_CONTEXT.md` is not created during install. It will be auto-generated by the AI in your first session by scanning existing project files (README.md, architecture docs, package manifests). No action needed."
```

**Step 3: Also mirror AGENTS.md embedded in INIT.md FILE 1 block**

INIT.md contains a full embedded copy of AGENTS.md content as FILE 1. The same §0a, §1, §4, §5a changes must be applied to the embedded copy inside INIT.md to maintain bootstrap parity.

Apply identical text changes as Tasks 1–4 but within the FILE 1 fenced block in INIT.md.

**Step 4: Verify INIT.md**

```
grep -n "CODEBASE_CONTEXT" INIT.md
```
Expected: multiple matches covering §0a, §1, §4, §5a embedded sections + Step 9 backup list + post-install note.

---

## Task 6: Full parity check

**Step 1: Count CODEBASE_CONTEXT mentions**

```
grep -c "CODEBASE_CONTEXT" AGENTS.md
grep -c "CODEBASE_CONTEXT" INIT.md
```

Expected: INIT.md count ≥ AGENTS.md count (INIT embeds AGENTS content + has its own additions).

**Step 2: Verify fence count sanity (AGENTS.md and INIT.md)**

Count opening and closing triple-backtick fences must be even in both files.

```
grep -c '^\`\`\`' AGENTS.md
grep -c '^\`\`\`' INIT.md
```

Both must return even numbers.

**Step 3: Verify §1 startup sequence order**

In both AGENTS.md and INIT.md embedded block, confirm order:
1. SESSION_HANDOFF.md
2. SESSION_LOG.md
3. CODEBASE_CONTEXT.md (new, conditional)
4. PROJECT_MASTER_SPEC.md (conditional)

---

## Task 7: Commit

**Step 1: Stage files**

```bash
git add AGENTS.md INIT.md docs/plans/2026-03-16-codebase-context-design.md docs/plans/2026-03-16-codebase-context-impl.md
```

**Step 2: Commit**

```bash
git commit -m "feat: add CODEBASE_CONTEXT to governance startup, closeout, and backup rules"
```

**Step 3: Verify**

```bash
git status
git log --oneline -3
```

Expected: clean working tree, new commit at HEAD.

---

## Acceptance Criteria Checklist

- [ ] §0a has CODEBASE_CONTEXT layer clarification note
- [ ] §1 startup list includes CODEBASE_CONTEXT at position 3 (after LOG, before MASTER_SPEC)
- [ ] §1 includes first-session generation rule with scan order
- [ ] §4 closeout rule includes CODEBASE_CONTEXT update condition
- [ ] §5a backup list includes `dev/CODEBASE_CONTEXT.md`
- [ ] INIT.md Step 9 backup list includes `dev/CODEBASE_CONTEXT.md`
- [ ] INIT.md post-install note mentions first-session auto-generation
- [ ] INIT.md FILE 1 embedded AGENTS content mirrors all §0a / §1 / §4 / §5a changes
- [ ] Fence counts even in both files
- [ ] `grep -c CODEBASE_CONTEXT INIT.md` ≥ `grep -c CODEBASE_CONTEXT AGENTS.md`
