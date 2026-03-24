# UPGRADE.md — Upgrade Governance Behaviors to v1.9.0

You are an AI coding agent. Execute the upgrade steps below in the current project directory.

This prompt upgrades any installed version of the ai-session-governance template to v1.9.0 behaviors.
It works regardless of your current installed version and regardless of what custom content you
have added to AGENTS.md. All user custom content is preserved.

---

## Safety Contract (follow before any write)

1. Read `AGENTS.md` fully before making any change
2. Never modify `dev/SESSION_HANDOFF.md` or `dev/SESSION_LOG.md`
3. Every check is idempotent — if the target behavior is already present, skip it and report **SKIP**
4. Never remove user custom content — only add or replace governance text that originated from the standard template
5. After any change to AGENTS.md, mirror the identical change to `INIT.md` FILE 1 (the fenced block after `## FILE 1: AGENTS.md`)
6. Report each check result as: **SKIP** (already present) / **APPLIED** (change made) / **BLOCKED** (anchor not found — do not guess)

---

## Part 1 — Section Presence Checks

Verify that major sections from v1.5.0–v1.8.0 are present.
If any section is entirely absent, the gap is too large for surgical patching.

Run each grep against `AGENTS.md`:

1. `External API Code Safety` → must be present
2. `3d) Test Plan Design` → must be present
3. `read \`AGENTS.md\` first` → must be present
4. `compaction` → must be present

**If all 4 are present:** proceed to Part 2.

**If any is absent:** STOP. Report which check failed and tell the user:
"Section [name] is missing. This project is on a version older than v1.5.0–v1.8.0.
Re-run INIT.md with the current version to install the full v1.9.0 template."

---

## Part 2 — v1.9.0 Behavioral Updates

Apply each check in order. Skip if the detection grep already matches.

---

### BU-01 — §1 New Session Definition (3-trigger block)

**Detect:** grep `Definition of "new session"` in AGENTS.md
→ **Found:** SKIP

**→ Not found:**

1. In `AGENTS.md`, locate the line `## 1) Single Entry (Mandatory)`
2. Insert the following block between that heading and the `At the start of every new session` line:

```
**Definition of "new session"** — any of the following triggers the full §1 startup sequence below:
1. A fresh conversation / thread
2. Context compaction / context recovery — the conversation history has been compressed into a summary by the platform; the compaction summary is not an authoritative source for project state, pending tasks, risks, or open items; actual governance files always take priority per §2
3. Agent handoff — a different AI agent takes over

```

3. Locate any standalone paragraph in §1 that begins with:
   `Context compaction recovery (additional §1 trigger):`
   If present, remove that entire paragraph — its content has been consolidated into the definition block above.

**Verify:** grep `Definition of "new session"` → match required

---

### BU-02 — §3 PERSIST explicit cross-document sync

**Detect:** grep `Apply the same cross-document sync conditions` in AGENTS.md
→ **Found:** SKIP

**→ Not found:**

In `AGENTS.md`, locate the `5. PERSIST` item under `## 3) Standard Workflow (Mandatory)`.
The existing text is a single bullet similar to:
`Update handoff / log / relevant specifications to ensure the next session can continue`

Replace that single bullet with these three:

```
   - Update `dev/SESSION_HANDOFF.md` and `dev/SESSION_LOG.md`
   - Apply the same cross-document sync conditions as §4 closeout: if tech stack, directory structure, build commands, external services, or Key Decisions changed in this task — update `dev/CODEBASE_CONTEXT.md` now, do not defer to closeout
   - If `dev/PROJECT_MASTER_SPEC.md` exists and carries status for the completed work — update it in the same pass
```

**Verify:** grep `Apply the same cross-document sync conditions` → match required

---

### BU-03 — §4 Open Priorities regeneration block

**Detect:** grep `Open Priorities regeneration` in AGENTS.md
→ **Found:** SKIP

**→ Not found:**

In `AGENTS.md`, locate `## 4) Session Close Rules (Mandatory)`. Find the numbered list of minimum closeout items (the list that ends with `6. Risks or blockers`).
Insert the following block immediately after item 6, before `Supplementary rules:`:

```
**Open Priorities regeneration** (mandatory at every closeout):
The `Open Priorities` section of `dev/SESSION_HANDOFF.md` must be regenerated at every closeout — not copy-pasted forward:
1. Remove any item completed this session
2. Scan `dev/SESSION_LOG.md` recent entries for newly surfaced pending items — add those
3. Re-rank and overwrite the previous list (replace, not append)
Hard rule: do not copy-paste old priorities without re-checking against current project state.

```

**Verify:** grep `Open Priorities regeneration` → match required

---

### BU-04 — §4 "max 3" clarification

**Detect:** grep `SESSION_LOG summary field only` in AGENTS.md
→ **Found:** SKIP

**→ Not found:**

In `AGENTS.md`, locate the minimum closeout items list in `## 4) Session Close Rules (Mandatory)`.
Find item 5 which reads: `5. Next priorities (max 3)`
Extend it to read:

```
5. Next priorities (max 3 — SESSION_LOG summary field only; full prioritized list lives in `dev/SESSION_HANDOFF.md` Open Priorities)
```

**Verify:** grep `SESSION_LOG summary field only` → match required

---

### BU-05 — §10 PROJECT_MASTER_SPEC suggestion recording location

**Detect:** grep `not Open Priorities — that section is regenerated` in AGENTS.md
→ **Found:** SKIP

**→ Not found:**

In `AGENTS.md`, locate `## 10) Optional Master Spec Mode`. Find the active trigger rule paragraph that contains:
`record a line in \`dev/SESSION_HANDOFF.md\` under Open Priorities or Known Risks:`

Replace `under Open Priorities or Known Risks:` with:
`under **Known Risks** (not Open Priorities — that section is regenerated and would lose the entry):`

**Verify:** grep `not Open Priorities — that section is regenerated` → match required

---

### BU-06 — §5 file system modification operations precision

**Detect:** grep `file system modification operations` in AGENTS.md
→ **Found:** SKIP

**→ Not found:**

In `AGENTS.md`, locate `## 5) File Safety Governance (Strict)`. Find item 7 which contains the phrase:
`to perform file system operations`

Replace that phrase with:
`to perform file system modification operations (create, delete, overwrite, move, rename)`

**Verify:** grep `file system modification operations` → match required

---

## INIT.md Parity

For each BU check above:

- If **APPLIED** to AGENTS.md → open `INIT.md`, locate the FILE 1 block (the fenced block after `## FILE 1: AGENTS.md`), apply the identical change to the same governance section inside that block.
- If **SKIP** for AGENTS.md → verify the same behavior is also present inside INIT.md FILE 1. If it is absent from INIT.md FILE 1 but present in AGENTS.md: apply the same change to INIT.md FILE 1.

**Fence count check after all changes:**
Count the number of lines that are exactly three backticks (opening/closing code fences) in each file:
- AGENTS.md fence count must be **even** (v1.9.0 clean install baseline: 16)
- INIT.md fence count must be **even** (v1.9.0 clean install baseline: 26)

If either count is odd, review your edits and correct before reporting done.

---

## Final Verification

After all changes, run all 6 detection greps against both files and fill the table:

| Check | Grep pattern | AGENTS.md | INIT.md FILE 1 |
|---|---|---|---|
| BU-01 | `Definition of "new session"` | ? | ? |
| BU-02 | `Apply the same cross-document sync conditions` | ? | ? |
| BU-03 | `Open Priorities regeneration` | ? | ? |
| BU-04 | `SESSION_LOG summary field only` | ? | ? |
| BU-05 | `not Open Priorities — that section is regenerated` | ? | ? |
| BU-06 | `file system modification operations` | ? | ? |

Report the following:
- Checks APPLIED: [list BU numbers]
- Checks SKIP (already present): [list BU numbers]
- Checks BLOCKED (anchor not found — explain): [list BU numbers]
- Fence counts: AGENTS.md = [n] (even ✓/✗), INIT.md = [n] (even ✓/✗)
- **Upgrade complete: YES / NO**

---

*This prompt is version-agnostic and idempotent. It is safe to run more than once.*
