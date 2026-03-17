English | [繁體中文](README.zh-TW.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md)

# :rocket: Governance Template for Cross-AI Handoff Workflows

When your Codex / Claude / Gemini quota runs out, paste the handoff block into the next AI and it picks up where you left off.

- Handoff works across different AI CLIs
- Standard workflow: `PLAN -> READ -> CHANGE -> QC -> PERSIST`
- Keeps governance from drifting, instead of just adding more rules

**[30-second Quick Start](#quickstart)** · **[Install](#install)** · **[Quick Operations](#quick-operations)**

![Overview](ref_doc/overview_infograph_en.png)

---

## :bookmark_tabs: Why this exists

With multiple AI tools, handoff is usually what breaks first — not output quality.

Common failure pattern:
- Context resets every time you switch tools
- Fixes pile on top of fixes, rules get messier
- README, handoff docs, and logs stop matching

This template requires:
1. One re-entry path every session
2. One workflow for every task
3. One persistent record before closing

---

## :bookmark_tabs: Built-in safeguards

It also catches a few common AI mistakes:

| Safeguard | What it prevents |
|---|---|
| **External API Code Safety** | Writing API-calling code from hallucinated endpoint / schema memory; requires doc-verified baseline before coding |
| **Codebase context snapshot** | Relearning tech stack, external services, and key decisions from scratch every session |
| **Test plan governance** | Merging changes without a scenario matrix — expected vs. actual outcomes untracked |
| **Consolidation discipline** | Rule accumulation without checking whether existing rules should be updated first |

---

## :bookmark_tabs: Recent releases

| Version | What changed | Why it matters |
|---|---|---|
| **v1.7.0** | Handoff prompt now opens with an explicit instruction to read `AGENTS.md` first, then follow the §1 startup sequence | Handoffs work even if the receiving tool doesn't auto-load governance files |
| **v1.6.0** | Post-install Quick Start printed after setup; `CODEBASE_CONTEXT.md` generation backs up and scans more sources (docs/, yaml, .env) | Commands are ready to copy right after install; first-session context is more complete |
| **v1.5.0** | External API Code Safety (§0b) — AI must read live docs before writing API calls; Test Plan Design (§3d) — scenario matrix before merging | Stops AI from guessing at API schemas; catches missing tests before merge |

---

<a id="quickstart"></a>

## :bookmark_tabs: 30-second Quick Start

1. Open **[INIT.md](INIT.md)** and paste it into your AI CLI.
2. Confirm root and write prompts exactly:
   - `INSTALL_ROOT_OK: <absolute_path>`
   - `INSTALL_WRITE_OK`
3. Start each new session with:

```text
Follow AGENTS.md
```

---

<a id="install"></a>

## :bookmark_tabs: Install

1. Open **[INIT.md](INIT.md)** -> click **Raw** -> copy all
2. Paste into Codex, Claude Code, or Gemini CLI
3. AI runs root safety preflight and prints in order: `pwd`, then `git root`
4. If `pwd` and `git root` differ, AI must stop and let you choose root (no auto-select)
5. AI prints risk checks and dry-run plan (`create` / `merge` / `skip`) before writing
6. You confirm:
   - `INSTALL_ROOT_OK: <absolute_path>`
   - `INSTALL_WRITE_OK`
7. Before first write, AI creates a lightweight backup snapshot at `<PROJECT_ROOT>/dev/init_backup/<UTC_TIMESTAMP>/` for existing target governance files
8. AI creates/merges 5 governance files in the confirmed project root
9. AI prints a **Quick Start** block with copy-paste commands — no need to memorize session commands

### :small_blue_diamond: Install UI walkthrough

<table>
  <tr>
    <td align="center" width="50%">
      <img src="ref_doc/install_step_1.png" alt="Install step 1" width="92%" />
      <br />
      <sub>Step 1: Paste `INIT.md` into your AI CLI</sub>
    </td>
    <td align="center" width="50%">
      <img src="ref_doc/install_step_2.png" alt="Install step 2" width="92%" />
      <br />
      <sub>Step 2: Review detected roots</sub>
    </td>
  </tr>
  <tr>
    <td align="center" width="50%">
      <img src="ref_doc/install_step_3.png" alt="Install step 3" width="92%" />
      <br />
      <sub>Step 3: Confirm `INSTALL_ROOT_OK`</sub>
    </td>
    <td align="center" width="50%">
      <img src="ref_doc/install_step_4.png" alt="Install step 4" width="92%" />
      <br />
      <sub>Step 4: Confirm `INSTALL_WRITE_OK`</sub>
    </td>
  </tr>
</table>

After step 4, AI creates a backup before writing anything.

### :small_blue_diamond: Real run snapshots

<table>
  <tr>
    <td align="center" width="50%">
      <img src="ref_doc/launch.png" alt="Launch screen" width="92%" />
      <br />
      <sub>Launch: session boot and context loading</sub>
    </td>
    <td align="center" width="50%">
      <img src="ref_doc/closesession.png" alt="Close session screen" width="92%" />
      <br />
      <sub>Closeout: session summary and handoff output</sub>
    </td>
  </tr>
</table>

Don't copy the repo manually. Use `INIT.md` — it handles merging safely into your existing files.

---

## :bookmark_tabs: Quick Operations

### :small_blue_diamond: 1) Start a session

```text
Follow AGENTS.md
```

### :small_blue_diamond: 2) Close with full handoff

```text
Wrap up this session with full closeout and handover.
```

### :small_blue_diamond: 3) Resume in another AI CLI

```text
<Paste the previous "NEXT SESSION HANDOFF PROMPT (COPY/PASTE)" block here, unchanged.>
```

---

## :bookmark_tabs: Quota-switch handoff flow

1. Work in CLI-A until quota is near limit
2. Ask for closeout and copy the generated handoff block
3. Open CLI-B and paste the block unchanged
4. CLI-B continues from the same baseline using `SESSION_HANDOFF.md` + `SESSION_LOG.md`

This is the primary design target of this repo.

---

## :bookmark_tabs: Platform setup

`AGENTS.md` is the SSOT. `CLAUDE.md` and `GEMINI.md` are thin pointers.

| Platform | Native file | What ships | Existing file action |
|---|---|---|---|
| **Codex** | `AGENTS.md` | full governance rules | merge governance sections |
| **Claude Code** | `CLAUDE.md` | pointer: `@AGENTS.md` | prepend `@AGENTS.md` |
| **Gemini CLI** | `GEMINI.md` | pointer: `@./AGENTS.md` | prepend `@./AGENTS.md` |

---

## :bookmark_tabs: 3 scenarios

### :small_blue_diamond: Scenario 1 — Quota exhausted, switch AI and continue
You hit quota in one CLI and must switch immediately.  
This template preserves baseline, pending tasks, risks, and validation state so work continues without re-explaining context.

### :small_blue_diamond: Scenario 2 — One repo, multiple AI agents
Different agents handle code, docs, and infra.  
Shared handoff/log discipline prevents parallel reality drift.

### :small_blue_diamond: Scenario 3 — Long-lived repo with governance drift
Fixes keep accumulating and docs diverge.  
Consolidation-before-adding rules reduce SOP sprawl and maintenance cost.

---

## :bookmark_tabs: FAQ

### :small_blue_diamond: 1) Is this only for large projects?
No. Small repos get the benefit right away; larger ones see more gain over time.

### :small_blue_diamond: 2) Do I need `PROJECT_MASTER_SPEC.md` on day one?
No. Start with `AGENTS.md` + `SESSION_HANDOFF.md` + `SESSION_LOG.md`.

### :small_blue_diamond: 3) Is this a coding style guide?
No. It governs how AI reads, changes, verifies, and hands over work — not how you write code.

### :small_blue_diamond: 4) Will this slow sessions down?
There's a short read at startup. Usually less overhead than re-explaining context and redoing mistakes.

### :small_blue_diamond: 5) Can I keep my existing docs and internal rules?
Yes. It merges with what you already have — it doesn't overwrite things.

---

## :bookmark_tabs: Repository source layout

```text
<PROJECT_ROOT>/
├─ INIT.md
├─ AGENTS.md
├─ CLAUDE.md
├─ GEMINI.md
└─ dev/
   ├─ SESSION_HANDOFF.md
   ├─ SESSION_LOG.md
   ├─ CODEBASE_CONTEXT.md      # auto-generated first session
   └─ PROJECT_MASTER_SPEC.md   # optional
```

### :small_blue_diamond: Core files

- `INIT.md` - bootstrap prompt (public entry point)
- `AGENTS.md` - governance SSOT
- `CLAUDE.md` - Claude pointer to SSOT
- `GEMINI.md` - Gemini pointer to SSOT
- `dev/SESSION_HANDOFF.md` - current baseline and next priorities
- `dev/SESSION_LOG.md` - session-by-session history and validation
- `dev/CODEBASE_CONTEXT.md` - tech stack, external services, key decisions (auto-generated first session)
- `dev/PROJECT_MASTER_SPEC.md` - optional long-term authority

---

## :bookmark_tabs: Governance principles

1. Read before change
2. Triage before debug
3. Consolidate before adding
4. Verify before claiming done
5. Persist before leaving

---

## :bookmark_tabs: Verification

Full verification details:
- [docs/VERIFICATION.md](docs/VERIFICATION.md)
- Latest QA regression report: [docs/qa/LATEST.md](docs/qa/LATEST.md)

Snapshot status (as of 2026-03-17):
- AGENTS/INIT rule parity: verified (57-check regression suite)
- Multi-platform pointer behavior: verified
- Longitudinal 50+ session durability: not yet verified

---

## :bookmark_tabs: Deep docs

If this repo grows, recommended companion docs:
- `dev/PROJECT_MASTER_SPEC.md`
- `docs/OPERATIONS.md`
- `docs/POSITIONING.md`

Current minimum:
- `AGENTS.md`
- `dev/SESSION_HANDOFF.md`
- `dev/SESSION_LOG.md`

---

## :bookmark_tabs: Designer

> Designed by **[Adam Chan](https://www.facebook.com/chan.adam)** · [i.adamchan@gmail.com](mailto:i.adamchan@gmail.com)

---

## :bookmark_tabs: License

Use, adapt, and extend for your workflows.
