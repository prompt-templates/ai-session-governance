# Design: dev/CODEBASE_CONTEXT.md

Date: 2026-03-16
Status: Approved, pending implementation
Session: Claude_20260316

---

## Problem

The current session startup sequence reads only governance state files (`SESSION_HANDOFF.md`, `SESSION_LOG.md`). For vibe coding workflows, the AI lacks:

- **A) Codebase spatial awareness** — tech stack, directory map, entry points, build commands
- **B) Non-obvious architectural decisions** — choices that cannot be inferred from reading code

This forces the AI to re-explore the codebase every session, increasing startup friction and reducing coding quality.

---

## Decision

Add `dev/CODEBASE_CONTEXT.md` as a lightweight, AI-maintained project context file.

**Scope:**
- Part A (full): Stack, Directory Map, Key Entry Points, Build & Run, External Services
- Part B (trimmed): Single `Key Decisions` section only — non-obvious architectural choices and explicitly prohibited patterns with reasons

**Excluded from Part B:** Naming conventions, file structure rules, testing approach — these are inferable from reading existing code and carry high maintenance cost if documented separately.

---

## File Template

```markdown
# Codebase Context

## Stack
- Language:
- Framework:
- Key libs:
- Package manager:
- Runtime version:

## Directory Map
- （fill per actual project）

## Key Entry Points
- Main:
- Config:
- Tests:

## Build & Run
- Install:
- Dev start:
- Test:
- Build / deploy:

## External Services
- APIs:
- Database:
- Auth / third-party:

## Key Decisions
（Non-obvious architectural choices + explicitly prohibited items with reasons; leave blank if none）

## AI Maintenance Log
- Created: （session ID）
- Last updated: （session ID）
- Change summary:
```

---

## Universality

The template is language-agnostic. Same structure works for:
- Any programming language (Python, Go, TypeScript, Rust, etc.)
- Multi-language projects
- AI prompt engineering projects (Stack = model/SDK, Entry Points = prompt files)
- Infrastructure / DevOps projects

---

## Compatibility with Existing System

### No conflicts
- Distinct from `SESSION_HANDOFF.md` (state) — CODEBASE_CONTEXT covers stable project facts
- Distinct from `PROJECT_MASTER_SPEC.md` — CODEBASE_CONTEXT is a lightweight quick-read; MASTER_SPEC is comprehensive authority

### Layer clarification required
- CODEBASE_CONTEXT contains **Product/System Layer** content
- Stored in `dev/` for governance tooling predictability (not because it belongs to Governance Layer)
- §0a in AGENTS.md needs one clarifying line

### Strengthens existing rules
| Rule | Enhancement |
|---|---|
| §1 Single Entry | Fills project context gap in startup sequence |
| §2c Read Coverage Before Change | AI has architecture context before modifying code |
| §3 READ phase | No need to re-explore directory structure each session |
| §0a Layer Separation | Product Layer now has a dedicated quick-reference doc |

---

## Generation Rules

**On first session (file does not exist):**
1. AI scans existing files: `README.md`, `docs/ARCHITECTURE.md`, `package.json` / `pyproject.toml` / `go.mod`, etc.
2. Extracts relevant info into CODEBASE_CONTEXT sections
3. Records source files in AI Maintenance Log
4. Original files are never modified

**On subsequent sessions (file exists):**
- Read and use as-is
- Update at session close if Stack / Architecture / Key Decisions changed

**If existing `dev/CODEBASE_CONTEXT.md` found during INIT:**
- Back up to `dev/init_backup/<timestamp>/`
- Merge (preserve existing content, update outdated sections)

---

## Required Changes

### AGENTS.md (4 changes)

1. **§0a Layer Separation** — Add clarification: CODEBASE_CONTEXT is Product/System Layer content stored in dev/ for governance tooling access
2. **§1 Single Entry** — Add to startup read sequence after SESSION_LOG.md; add generation rule for missing file
3. **§4 Session Close Rules** — Add: update CODEBASE_CONTEXT if Stack / Key Decisions changed this session
4. **§5a Root Scope Guard** — Add `dev/CODEBASE_CONTEXT.md` to backup list

### INIT.md (2 changes)

1. **Step 9 backup list** — Add `dev/CODEBASE_CONTEXT.md` (if present)
2. **Post-install confirmation** — Add note: first session will auto-generate CODEBASE_CONTEXT by scanning existing project files

---

## Out of Scope

- No changes to `CLAUDE.md`, `GEMINI.md`, `README*` files in this implementation
- `PROJECT_MASTER_SPEC.md` behavior unchanged
- No new CLI commands or tooling

---

## Acceptance Criteria

1. `dev/CODEBASE_CONTEXT.md` template present in INIT.md backup list
2. §1 startup sequence includes CODEBASE_CONTEXT with correct read order
3. §1 includes generation rule (scan on first session)
4. §4 closeout rule includes CODEBASE_CONTEXT update condition
5. §5a backup list includes CODEBASE_CONTEXT
6. §0a has layer clarification for CODEBASE_CONTEXT
7. INIT.md step 9 includes CODEBASE_CONTEXT in backup list
8. INIT.md post-install note mentions first-session auto-generation
9. AGENTS.md / INIT.md parity maintained for all new rules
