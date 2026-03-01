English | [繁體中文](README.zh-TW.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md)

# Stop repeating yourself to your AI — every single session

A lightweight governance template for AI-assisted coding that helps projects stay **continuable, debuggable, auditable, and less chaotic** across Codex, Claude Code, Gemini CLI, and similar agent workflows.

**[Install](#install)** · **[Quick Start](#install)**

![Overview](ref_doc/overview_infograph.png)

---

## Why this matters

If AI is helping with coding, debugging, refactoring, release work, or documentation updates, the real problem usually is not "the model is weak".

The real problem is that the project has **no durable operating memory**.

That is when teams start seeing the same failure pattern:

### Pain point 1 — Every new session starts from scratch
The agent does not know the current baseline, what was already fixed, what remains open, or what should never be touched again.

### Pain point 2 — Fixes keep getting layered on top of old fixes
Each session adds one more patch, one more note, one more exception, one more rule — until the project becomes harder to change, not easier.

### Pain point 3 — Bugs get fixed locally, but governance gets worse globally
The code may compile, but the repo drifts:
- README says one thing
- handoff says another
- logs say a third
- nobody knows which version is the real one

### What this template gives back

#### 1) Continuity
Every new session has a mandatory entry path:
- read the handoff
- read the log
- continue from the latest verified state

#### 2) Control
The agent must work through:
**PLAN → READ → CHANGE → QC → PERSIST**

That means fewer impulsive edits, better traceability, and safer changes.

#### 3) Anti-chaos guardrails
This template does not only prevent reckless changes.
It also prevents **governance bloat** by forcing the agent to check:

- Is this really a new rule?
- Or should an old rule be updated instead?
- Is this a fix?
- Or should this be a consolidation pass?

---

## Install

1. Open **[INIT.md](INIT.md)** → click **Raw** → select all → copy
2. Paste into your AI agent (Claude Code, Codex, Gemini CLI — any will work)
3. The AI automatically runs a root safety preflight first and prints paths in this order: `pwd`, then `git root`
4. If `pwd` and `git root` are different, the AI must stop and ask you to choose one root (1: use `pwd`, 2: use `git root`); it must not auto-select
5. The AI then shows risk checks + dry-run (`create` / `merge` / `skip`) for the selected root, with no file writes yet
6. When prompted, confirm the selected path by replying with:
   - `INSTALL_ROOT_OK: <absolute_path>`
   - `INSTALL_WRITE_OK`
7. The AI then creates all 5 governance files in your confirmed project root

You do not need manual setup. The AI handles the process automatically, including smart merge of existing `AGENTS.md`, `CLAUDE.md`, or `GEMINI.md` content.
For most public users, `INIT.md` is the only file you need to use directly.
Do not manually copy this entire repository into your project root; use `INIT.md` so the agent can merge safely.

Then start every AI session with:

```text
Follow AGENTS.md
```

`Follow AGENTS.md` is the standard short form. Equivalent meaning in other wording/languages also works.

## Quick operations

Use natural language. The lines below are reliable shortcuts you can copy/paste.

### 1) Start a session

```text
Follow AGENTS.md
```

### 2) Continue active work in the same session

```text
Continue from the current state and proceed with PLAN → READ → CHANGE → QC → PERSIST.
```

### 3) Close the session with full handoff

```text
Wrap up this session with full closeout and handover.
```

Expected closeout output includes:
- `SESSION CLOSEOUT SUMMARY`
- `NEXT SESSION HANDOFF PROMPT (COPY/PASTE)`
- `CLOSEOUT VISUAL CUE`

### 4) Start the next session quickly

```text
<Paste the previous "NEXT SESSION HANDOFF PROMPT (COPY/PASTE)" block here, unchanged.>
```

---

## Platform setup

`AGENTS.md` is the single source of truth. This template ships thin pointer files (`CLAUDE.md` and `GEMINI.md`) so every platform auto-discovers governance rules from one source.

| Platform | Native file | What the template ships | If you already have the file |
|---|---|---|---|
| **Codex** | `AGENTS.md` | `AGENTS.md` (full rules) | Merge governance sections into your existing file |
| **Claude Code** | `CLAUDE.md` | Pointer file: `@AGENTS.md` | Add `@AGENTS.md` to the **top** of your existing `CLAUDE.md` |
| **Gemini CLI** | `GEMINI.md` | Pointer file: `@./AGENTS.md` | Add `@./AGENTS.md` to the **top** of your existing `GEMINI.md` |

The governance rules, workflow, and dev/ templates work identically across all platforms once the agent can read the instructions.

---

## What makes this template different

Most AI coding prompts focus on:
- tone
- formatting
- coding style
- tool usage

This template focuses on something more important for long-running work:

### 1) Session continuity
The next session should not depend on user memory.

### 2) Layer separation
The agent must not confuse:
- product behavior
- developer governance
- external platform behavior
- environment/runtime issues

### 3) Read before change
No "see one fragment, patch one fragment" workflow.

### 4) Consolidate before adding
No endless stacking of new rules and exceptions.

### 5) Close the session properly
The agent must update handoff/log before leaving.

---

## 3 scenarios

### Scenario 1 — Solo founder shipping with AI every day
Daily progress is fast, but context drops between sessions.
This template gives each session a stable re-entry point and reduces repeated explanation.
It also stops "small fixes" from turning into long-term governance mess.
Good for product builders, indie hackers, and technical founders.

### Scenario 2 — One repo, multiple AI agents
Codex handles code, Claude reviews docs, Gemini helps debug infra.
Without a common handoff and session log, each agent works from a different reality.
This template creates a shared operational memory and a consistent session ID standard.
Good for multi-agent workflows.

### Scenario 3 — Existing project already feels messy
The repo works, but every fix makes the rules longer, docs noisier, and releases riskier.
This template adds anti-accretion discipline: search first, consolidate first, retire stale rules.
It is designed to reduce governance drift, not just add more governance.
Good for long-lived repos that need cleanup without a total rewrite.

---

## FAQ

### 1) Is this only for large projects?
No.
Small projects benefit from session continuity immediately.
Larger projects benefit even more because drift compounds faster over time.

### 2) Do I need `PROJECT_MASTER_SPEC.md` on day one?
Not necessarily.
For small repos, `AGENTS.md` + `SESSION_HANDOFF.md` + `SESSION_LOG.md` are enough.
Add a master spec when rules, release criteria, or workflows become too large to manage informally.

### 3) Is this a coding standard?
Not primarily.
This is a **governance standard** for how AI works inside a repo:
- how it reads
- how it changes
- how it verifies
- how it hands over

### 4) Why not just keep everything inside one giant prompt?
Because large prompts decay.
They become harder to update, harder to trust, and harder for the next session to apply consistently.
This template separates stable governance from per-session state.

### 5) Will this slow the agent down?
A little at the start of each session.
Usually much less than the time lost to repeated explanations, misdiagnosis, duplicate fixes, and stale docs.
The point is to reduce total rework, not optimize for one fast but forgetful turn.

### 6) What problem does "consolidation before adding" solve?
It prevents governance bloat.
Without this rule, every fix becomes an extra note, every incident becomes an extra SOP, and every session leaves more clutter behind.
This template forces the agent to ask whether a rule should be merged, not merely added.

### 7) When should a problem become a permanent rule?
Only when it is repeated, high impact, release-blocking, risky, or systemic.
If a problem is small and local, fix the root cause, add regression, update the log, and move on.
Not every mistake deserves a new law.

### 8) Does this help with debugging, or only with documentation?
Both.
It improves debugging by forcing issue triage first:
- code issue?
- config issue?
- runtime issue?
- external platform issue?
- stale documentation?
This reduces "wrong-fix" debugging.

### 9) What if my project already has README, docs, and internal rules?
Keep them.
This template is meant to integrate with existing project materials, not replace useful context blindly.
The only hard requirement is: a reliable entry path and a persistent session record.

### 10) What is the biggest mistake this template is designed to prevent?
The quiet one:
a project that still "works", but gets harder to understand, harder to modify, and harder to trust after every AI session.
This template exists to stop that slow degradation early.

---

## Repository source layout

```text
<PROJECT_ROOT>/
├─ INIT.md                ← bootstrap prompt (public entry point)
├─ AGENTS.md              ← governance rules (SSOT)
├─ CLAUDE.md              ← pointer for Claude Code
├─ GEMINI.md              ← pointer for Gemini CLI
└─ dev/
   ├─ SESSION_HANDOFF.md
   ├─ SESSION_LOG.md
   └─ PROJECT_MASTER_SPEC.md   # optional
```

### Core files

* `INIT.md` — bootstrap prompt that creates/merges governance files into your project (the primary entry for most users)
* `AGENTS.md` — the standing operating rules for AI work in the repo (single source of truth)
* `CLAUDE.md` — pointer file that bridges Claude Code auto-discovery to `AGENTS.md`
* `GEMINI.md` — pointer file that bridges Gemini CLI auto-discovery to `AGENTS.md`
* `dev/SESSION_HANDOFF.md` — current baseline, blockers, start checklist, last verified state
* `dev/SESSION_LOG.md` — session-by-session history, fixes, validation, next priorities
* `dev/PROJECT_MASTER_SPEC.md` — optional long-term authority for larger or more complex projects

---

## Governance principles behind this template

This repo is built around a few non-negotiables:

1. **Read before change**
2. **Triage before debug**
3. **Consolidate before adding**
4. **Verify before claiming done**
5. **Persist before leaving**

At session close, the agent must output a copy-paste-ready handoff prompt generated from the real current state (not a fixed sentence).

If those five hold, AI sessions remain usable over time.

---

## Verification record

Before publishing, each claim in this README was cross-checked against the actual AGENTS.md rules and dev/ templates, and validated against official platform documentation (as of February 2026).

### Claim-to-mechanism mapping

| README claim | Backed by | Verified |
|---|---|---|
| Session continuity | AGENTS.md §1 Single Entry, §4 Session Close, SESSION_HANDOFF.md, SESSION_LOG.md | Yes |
| PLAN → READ → CHANGE → QC → PERSIST | AGENTS.md §3 Standard Workflow | Yes |
| Anti-governance-bloat | AGENTS.md §3b Consolidation Discipline, §8b Rule Promotion Threshold | Yes |
| Layer separation | AGENTS.md §0a — 4 hard rules | Yes |
| Read before change | AGENTS.md §2c — 4 minimum reads, 3 hard rules | Yes |
| Issue triage before debug | AGENTS.md §2b — 6 categories, 3 hard rules | Yes |
| Multi-agent session ID | AGENTS.md §12 — format standard with examples | Yes |
| File safety governance | AGENTS.md §5 — 8 prohibitions, §6 — escalation block with manual fallback | Yes |
| Integrates with existing projects | AGENTS.md line 2 — explicit merge/preserve instruction | Yes |

### Platform compatibility verified

| Platform | Reads governance file | Session persistence | Structured workflows | Source |
|---|---|---|---|---|
| Codex | `AGENTS.md` native | Client-side sessions + resume | AGENTS.md directives + Agents SDK | [OpenAI Codex Docs](https://developers.openai.com/codex/) |
| Claude Code | `CLAUDE.md` native; `AGENTS.md` via `@` import | Auto memory + session resume | Plan Mode + skills | [Claude Code Docs](https://code.claude.com/docs/en/overview) |
| Gemini CLI | `GEMINI.md` native; `AGENTS.md` via config | `/memory` + session save/resume | Skills + GEMINI.md directives | [Gemini CLI Docs](https://google-gemini.github.io/gemini-cli/) |

### What was not verified

- Long-term effectiveness across 50+ sessions (no longitudinal data yet)
- Compliance rate across different model generations (governance is instruction-based, not technically enforced)
- Performance impact of reading handoff + log at session start (expected to be minor but not benchmarked)

This verification was conducted on 2026-02-27 using official platform documentation.

---

## Deep docs

If this repo later grows, the recommended deep docs are:

* `dev/PROJECT_MASTER_SPEC.md` — full architecture, workflow, release, runbook authority
* `docs/OPERATIONS.md` — operator-facing usage and maintenance procedures
* `docs/POSITIONING.md` — what this template is for, what it is not for, and where it fits

If those files do not exist yet, the current minimum remains:

* `AGENTS.md`
* `dev/SESSION_HANDOFF.md`
* `dev/SESSION_LOG.md`

---

## Who this is for

This template is most useful for people who:

* code with AI every week
* switch between multiple models or agent tools
* maintain repos over time, not just one-off scripts
* want fewer repeated explanations
* care about durable, auditable progress

If that sounds familiar, this template is meant to be a practical starting point.

---

## License

Use, adapt, and extend for your own workflows.
If you improve it, consider contributing back patterns that reduce drift without increasing complexity.
