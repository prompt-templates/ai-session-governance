# AGENTS.md instructions for <PROJECT_ROOT>
(If an AGENTS.md already exists in this project's directory, the original content must be preserved and integrated/merged — retaining the strengths of each while coordinating them to complement rather than conflict with one another)

<INSTRUCTIONS>

## 0) Purpose
This project adopts a "sustainable session governance" model. The AI must be able to resume work in a new session using documentation alone, without requiring the user to repeat context.

The goal is not to accumulate ever more rules, but to ensure that after every round of development, debugging, optimization, or upgrade, the project remains clear, verifiable, handover-ready, and sustainably maintainable.

---

## 0a) Layer Separation (Mandatory)
This project's rules are separated into at least two layers; the AI must not conflate them:

1. Product / System Layer
   - Refers to the project's own functionality, commands, configuration, execution flow, product logic, deployment logic, and external platform integrations.

2. Development Governance Layer
   - Refers to the AI agent's file-reading order, modification process, verification methods, handover procedures, safety rules, and maintenance discipline within this codebase.

Hard rules:
1. Do not treat "product feature rules" as the AI agent's "development governance rules".
2. Do not mistake "development governance processes" for user-facing product functionality.
3. When encountering a bug / error / unexpected behavior, first determine which layer the issue belongs to before deciding the debug path.
4. Do not skip layer classification and directly modify code, configuration, or documentation.

Note:
`dev/CODEBASE_CONTEXT.md` contains Product / System Layer content (tech stack, directory map, build commands, External Services, and Key Decisions).
It is stored in `dev/` by path convention (so session tooling can locate it predictably), not because it belongs to the Development Governance Layer.

---

## 0b) External Platform Alignment (Mandatory when applicable)
Whenever a task involves external platforms, frameworks, APIs, CLIs, deployment systems, cloud services, third-party SDKs, package managers, or official toolchains, the AI must not guess commands, parameters, limitations, version differences, or platform behavior from memory.

Before starting related work, alignment must be completed against:
1. Official documentation
2. Official release notes / changelog
3. Official repo / original specifications
4. Relevant SSOT / runbook / integration docs within this project

If alignment is not completed:
1. Do not treat guesses as conclusions
2. Do not directly output high-risk operation commands
3. Must clearly label which items have been verified and which are pending verification

### External API Code Safety (Mandatory when writing API-calling code)

Before writing any code that calls an external API endpoint, the AI must:
0. If `dev/CODEBASE_CONTEXT.md` does not yet exist, generate it first per §1 rules before proceeding — the External Services section is required to record API facts.
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

Each API uses one block:
```
### [API Name]
- Base URL:
- Version:
- Auth:
- Required params:
- Forbidden params:
- Response path:
- Official docs:
- Doc-reviewed:  (date + session ID — documentation read and fields recorded)
- Test-verified: (date + session ID — API call made and response confirmed correct)
- Notes:
```

When reading an existing External Services block before writing code:
1. `Test-verified` present → reliable; re-verify the specific endpoint and params in use if entry is from a prior session
2. Only `Doc-reviewed` present → use with caution; annotate generated code with a comment `awaiting test-verification` (using the target language's comment syntax) at the top of each function or method that calls the endpoint
3. Both empty or missing → full verification ritual required before writing code
4. After any re-verification: update the relevant date and session ID in the block
5. If re-verification reveals API changes: update affected fields, record before/after in Notes, flag affected existing code for review

---

## 1) Single Entry (Mandatory)
At the start of every new session, the AI must read the following files in this order:

1. `dev/SESSION_HANDOFF.md`
2. `dev/SESSION_LOG.md`
3. `dev/CODEBASE_CONTEXT.md` (if it exists; provides tech stack, directory map, build commands, External Services, and Key Decisions)
4. `dev/PROJECT_MASTER_SPEC.md` (if it exists; serves as the advanced authoritative specification)

Context compaction recovery (additional §1 trigger): If the AI detects that its current session context has been compacted — that is, the conversation history has been compressed into a summary by the platform — it must re-execute the §1 startup sequence before resuming any pending tasks listed in the summary. The compaction summary is not an authoritative source for project state, pending tasks, risks, or open items. The actual governance files (`dev/SESSION_HANDOFF.md`, `dev/SESSION_LOG.md`) always take priority per §2.

If `dev/SESSION_HANDOFF.md` or `dev/SESSION_LOG.md` is missing, the AI must create a minimal version before beginning development.

If `dev/CODEBASE_CONTEXT.md` does not exist, the AI must generate it during the first session:
0. If the file already exists for any reason, back it up to `dev/init_backup/<YYYYMMDD_HHMMSS_UTC>/` before making any changes
1. Scan existing project files — include all of the following that are present (do not limit to this list):
   - Documentation: `README*.md`, `CONTRIBUTING.md`, `DEVELOPMENT.md`, `docs/**/*.md` (architecture, design, API, integration docs)
   - Package manifests: `package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`, `Gemfile`, `requirements.txt`, `composer.json`
   - Service / environment clues: `.env.example`, `docker-compose*.yml`, `*.yaml` / `*.yml` config files in root or `config/` (for external service names and env vars)
2. Extract and integrate — if the same service, dependency, or decision appears in multiple files, consolidate into one entry; do not duplicate
3. Fill in sections: Stack, Directory Map, Key Entry Points, Build & Run, External Services, Key Decisions (leave blank if none), AI Maintenance Log
4. Record all source files scanned in the `AI Maintenance Log` section
5. Never modify the source files during this scan — read only

After reading `dev/SESSION_LOG.md`, the AI must locate the latest `### Next Session Handoff Prompt (Verbatim)` block (if present) and use that block as startup execution seed context for PLAN.

After completing the session file reads, display exactly one random "Boot Visual Cue" style from the set below.
Selection rule: randomize across styles; if the previous style is known, prefer a different style instead of repeating.

Boot Visual Cue - Style A
```text
    ) ) )
   ( ( (
  _______
 |       |
 |  ( )  |
 |_______|
   \___/

 ☕  booting up...
```

Boot Visual Cue - Style B
```text
      /^\
     /___\
    |=   =|
    |  ^  |
    |_____|
     / | \
    /  |  \

 🚀  launch checks complete...
```

Boot Visual Cue - Style C
```text
  _____________
 |  _________  |
 | |         | |
 | |  READY  | |
 | |_________| |
 |_____________|
    /_/   \_\

 🧠  context loaded.
```

---

## 2) Source of Truth Priority
When documents conflict, the priority order is as follows:

1. `dev/SESSION_HANDOFF.md` (current baseline, execution thresholds, open items, current state)
2. `dev/SESSION_LOG.md` (latest changes, historical decisions, most recent fixes and verifications)
3. `dev/CODEBASE_CONTEXT.md` (if it exists; stable project facts — tech stack, External Services, Key Decisions)
4. `dev/PROJECT_MASTER_SPEC.md` (if it exists; long-term stable specifications, architecture, runbook, release rules)
5. Other README / docs / comments / tests
6. Verbal memory and speculation (must not be used as a basis for decisions)

Supplementary rules:
1. `SESSION_HANDOFF.md` and `SESSION_LOG.md` represent the "current state".
2. `CODEBASE_CONTEXT.md` represents stable project facts that change only when the tech stack, External Services, or Key Decisions change.
3. `PROJECT_MASTER_SPEC.md` represents "long-term stable rules and the complete authoritative reference".
4. If the current state is inconsistent with an older specification, defer to the handoff/log first, and remediate specification drift during the PERSIST phase.
5. If `SESSION_LOG.md` contains a latest `Next Session Handoff Prompt (Verbatim)` block, treat it as operational seed context, but do not let it override higher-priority current-state facts in `SESSION_HANDOFF.md` / latest log facts.

---

## 2b) Issue Triage (Mandatory)
Whenever a bug / error / regression / unexpected behavior is encountered, source classification must be performed before reading files or making changes.

At minimum, first determine whether the issue falls into one of the following categories:
1. Code logic issue
2. Configuration issue
3. Environment / permissions / runtime issue
4. External dependency / platform behavior issue
5. Usage / operator error
6. Documentation drift / stale instruction issue

Before source classification is complete:
1. Do not make large-scale code changes
2. Do not arbitrarily revert files
3. Do not equate a single error message directly with the root cause

---

## 2c) Read Coverage Before Change (Mandatory)
Before any modification enters the `CHANGE` phase, the following minimum read coverage must be completed:

1. Read the full context of the section to be modified in the target file
2. Search for other occurrences of the same term / rule / feature across the repo
3. Check whether a single source of truth already exists (SSOT / master spec / runbook / baseline definition)
4. Review the most recent `SESSION_LOG.md` entry related to the topic

Hard rules:
1. Do not modify after reading only a single fragment
2. Do not add new rules without first checking for duplicates and performing integration assessment
3. If content on the same topic already exists in multiple locations, first determine whether consolidation is needed before deciding how to modify

---

## 3) Standard Workflow (Mandatory)
Every task must follow this workflow and clearly label each phase in the response:

1. PLAN
   - Objective, scope, risks, acceptance criteria
   - If task meets §3d trigger conditions: define test scenario matrix before proceeding to READ

2. READ
   - Read necessary files, verify current state, classify sources, check for duplicates and confirm impact scope

3. CHANGE
   - Minimal necessary modifications, no unrelated refactoring

4. QC
   - Run tests / checks, list results (test/check commands and key outcomes)
   - If a test scenario matrix was defined in PLAN (§3d): verify each scenario and record actual result; summarize overall as PASS / PASS with notes / FAIL
   - If the task involves batch deletion or batch modification, a dry-run (e.g. `ls` / `find` preview, PowerShell `-WhatIf`, etc.) with a "blast radius" list must be provided for confirmation first

5. PERSIST
   - Update handoff / log / relevant specifications to ensure the next session can continue

---

## 3b) Consolidation / Integration Discipline (Mandatory)
"Minimal necessary modification" does not mean "only stack, never integrate".

Before adding any new rule, explanation, exception, baseline, or runbook content, first check whether the correct action is to:
1. Modify the existing single definition
2. Merge duplicate content
3. Retire outdated wording
4. Converge the definition to a single source of truth
5. Keep only a reference in other locations, rather than copying the content again

Core principles:
1. Integrate first, add later
2. If an existing statement can be updated, do not add a parallel new statement
3. The same rule, threshold, enumeration, or operational standard must maintain one-rule-one-place
4. If new content supersedes old content, the old wording must be retired simultaneously; two competing standards must not coexist long-term

If any of the following conditions apply, a Consolidation Pass must be performed before entering CHANGE:
1. The same rule already appears in 2 or more files
2. The same issue has been patched more than 2 times
3. A new rule overlaps, duplicates, or creates exceptions against an old rule
4. README / handoff / spec / tests show inconsistent wording
5. Continuing to stack would clearly increase comprehension cost or maintenance cost

A Consolidation Pass includes at minimum:
1. Identifying the primary definition location
2. Merging duplicate content
3. Retiring or rewriting outdated wording
4. Recording the consolidation rationale and outcome in `SESSION_LOG.md`

---

## 3c) Release / Merge Gate (Mandatory when applicable)
Whenever a task involves a merge, release, deploy, publish, GA, or hotfix completion claim, the following gates must be cleared first; none may be skipped:

1. Independent Review Pass
   - Conduct an independent review (may be performed by a second agent, a review mode, or a structured self-check checklist)
   - Must cover: correctness, consistency, regression risk, documentation sync, toolchain compatibility

2. Machine Verification
   - Run the project's applicable build / type-check / lint / tests / regression / consistency checks

3. Evidence Check
   - To claim ready / merged / released / GA, corresponding verification evidence must exist

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

Result values: PASS, PASS with notes (minor gaps but does not block), or FAIL.

### Recording location
- ≤5 scenarios: inline in current SESSION_LOG entry under `### Test Scenarios`
- >5 scenarios or spanning multiple sessions: reference in SESSION_HANDOFF `Regression / Verification Notes`; full matrix in SESSION_LOG
- At QC phase: fill in Actual column; summarize overall result in SESSION_LOG

---

## 4) Session Close Rules (Mandatory)
When the user expresses any of the following (or similar) end-of-session intent, the AI must automatically perform closeout without requesting item-by-item confirmation:

- "wrap up"
- "handover"
- "close session"
- "that's it for today"
- Any expression that can reasonably be interpreted as ending the current session

At closeout, the following must be updated at minimum:
1. `dev/SESSION_HANDOFF.md`
2. `dev/SESSION_LOG.md`

If the session's changes involve specifications, acceptance criteria, runbooks, releases, baselines, regression thresholds, or external platform integrations, the corresponding documents must also be updated.

If the session's changes involve tech stack, directory structure, build commands, external services, or Key Decisions, `dev/CODEBASE_CONTEXT.md` must also be updated and a new entry appended to the `AI Maintenance Log` section with the current session ID and a brief change summary.

Each closeout must record at minimum:
1. Date (UTC)
2. Session Identifier
3. Completed items
4. Pending items
5. Next priorities (max 3)
6. Risks or blockers

Supplementary rules:
1. Even if the session involved no substantive code changes (research / analysis / discussion / decisions only), the session record must still be updated
2. After closeout is complete, the response must list: which files were updated, and what was updated in each
3. After closeout is complete, the response must include a copy-paste-ready "Next Session Handoff Prompt" for the next agent
4. The "Next Session Handoff Prompt" must be generated from the project's actual current state; fixed or hardcoded handoff sentences are prohibited
5. The "Next Session Handoff Prompt" must include at minimum:
   - Opening line: instruct the receiving AI to read `AGENTS.md` first (governance SSOT), then follow the §1 startup sequence (`dev/SESSION_HANDOFF.md` → `dev/SESSION_LOG.md` → `dev/CODEBASE_CONTEXT.md` if exists) — this ensures cross-tool handoffs work even when the receiving tool does not auto-load `AGENTS.md`
   - Current objective and progress state
   - Pending tasks in priority order
   - Key files changed in this session
   - Known risks / blockers / cautions
   - Validation status and the first concrete next action
6. After closeout is complete, the response must be formatted in exactly three sections in this order:
   - Section 1: `SESSION CLOSEOUT SUMMARY`
   - Section 2: `NEXT SESSION HANDOFF PROMPT (COPY/PASTE)`
   - Section 3: `CLOSEOUT VISUAL CUE`
7. Section 2 must be a single fenced `text` block so the user can copy/paste directly without cleanup.
8. Section 3 must display exactly one random closeout style from the set below.
9. Randomization rule: if the previous closeout style is known, prefer a different style instead of repeating.
10. Use separator lines between sections for visual alignment. Required separators:
    - Major separator: `========================================`
    - Minor separator: `----------------------------------------`
11. Closeout output skeleton must follow this layout:
```text
========================================
SESSION CLOSEOUT SUMMARY
========================================
<summary bullets>

----------------------------------------
NEXT SESSION HANDOFF PROMPT (COPY/PASTE)
----------------------------------------
<single fenced text block>

----------------------------------------
CLOSEOUT VISUAL CUE
----------------------------------------
<one random style from A/B/C>
```
12. After generating Section 2, write the exact same fenced `text` block verbatim into the current session entry in `dev/SESSION_LOG.md` under:
    - `### Next Session Handoff Prompt (Verbatim)`
13. If that subsection already exists in the current session entry, replace it with the latest block instead of appending duplicates.
14. The block persisted in `SESSION_LOG.md` must be the same content as Section 2 output (no paraphrase, no truncation, no reformatting).

Closeout Visual Cue - Style A
```text
  .  *    .   *
    .   🌅  .
  ~~~ ~~~ ~~~ ~~~

  shipped. chill time ✌️
```

Closeout Visual Cue - Style B
```text
      .      *
   *     .      .
       .-.
      (   )
       `-'
  ~~~~~~~~~~~~~~~~

   🌙  shipped. good night.
```

Closeout Visual Cue - Style C
```text
  \o/   \o/   \o/
   |     |     |
  / \   / \   / \
 ------------------

  🧭  shipped. next up.
```

---

## 5) File Safety Governance (Strict)
The AI is prohibited from executing high-risk destructive operations, including but not limited to:

1. `rm -rf` / `Remove-Item -Recurse -Force` (without explicit approval)
2. `git reset --hard`
3. `git clean -fdx`
4. Batch overwriting unknown files
5. Overwriting or deleting files unrelated to the current task
6. Any privilege escalation (sudo, system-level permission changes) unless explicitly approved by the user
7. Strictly prohibited from invoking external shells (e.g. `cmd /c`, `sh -c`, `bash -c`, `powershell -Command`) to perform file system operations; must use the current environment's native commands with direct arguments
8. When handling file paths, strictly prohibited from using raw string interpolation to construct paths; must use native path handling APIs / objects (e.g. `Join-Path`, `path.join`, `Path.Combine`, etc.)

## 5a) Root Scope Guard for Bootstrap / Multi-File Setup (Mandatory)
Before any bootstrap/setup task that creates or modifies multiple governance files (e.g. executing `INIT.md`), the AI must complete the following preflight and must not write any file before explicit user confirmation:

1. Detect and print paths in this exact order:
   - `pwd` absolute path
   - `git root` absolute path (or `none`)
2. If `pwd` and `git root` both exist and are different:
   - Hard stop before any write
   - Print exactly two root options in this order:
     1) Use `pwd`
     2) Use `git root`
   - Require user to explicitly choose one option
   - Strictly prohibited for AI to auto-select root in this mismatch case
3. After root is explicitly chosen, print chosen `<PROJECT_ROOT>` as absolute path
4. Run and print root risk checks at minimum:
   - Whether the path appears to be a shared workspace / runtime / tool-internal directory
   - Whether parent/sibling directories contain governance files suggesting the scope may be too high
   - Whether the target seems to be a framework/tool runtime repo instead of the user's intended project
5. Print a dry-run install plan:
   - `create`: files that will be newly created
   - `merge`: files that will be merged/prepended
   - `skip`: files that will be left unchanged
6. Require exact confirmation reply from user:
   - `INSTALL_ROOT_OK: <absolute_path>`
7. If the confirmation path does not exactly match the proposed absolute path, abort setup (no writes)
8. After step 6 passes, require second confirmation reply before first write:
   - `INSTALL_WRITE_OK`
9. After `INSTALL_WRITE_OK` and before first write, create a lightweight backup snapshot:
   - Directory: `<PROJECT_ROOT>/dev/init_backup/<YYYYMMDD_HHMMSS_UTC>/`
   - Copy only existing target files (`AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `dev/SESSION_HANDOFF.md`, `dev/SESSION_LOG.md`, `dev/CODEBASE_CONTEXT.md`, if present)
   - Preserve relative paths under `<PROJECT_ROOT>`
   - Use native filesystem copy operations (cross-platform), no git required
10. If high-risk markers are detected, default action is abort and ask user to specify a safer subdirectory explicitly

---

## 6) No Escalation Deletion Policy
When encountering "file is locked, insufficient permissions, cannot delete, cannot overwrite":

1. Do not escalate privileges
2. Do not use high-risk commands to bypass
3. Do not use OS low-level APIs, COM objects, WMI, AppleScript, unconventional syscall wrappers, or other opaque means to force-remove files
4. Output a "manual action list" to the user

The manual action list must include at minimum:
1. File / directory path
2. Failure reason
3. Safe methods already attempted
4. Recommended manual steps for the user

Note:
Normal external network service APIs / Web SDKs required for project feature development are exempt from this rule; this clause applies only to high-risk file system force-removal.

---

## 7) Change Scope Discipline
1. Only modify files directly related to the current task
2. Do not perform unrelated refactoring
3. Do not revert the user's existing modifications
4. If unexpected changes not caused by the AI are discovered, stop and confirm with the user first
5. If behavior, processes, interfaces, acceptance criteria, runbooks, release conditions, or related matters change, the corresponding documentation and regression must be updated in the same changeset
6. If the current fix would make the project's rules more complex, first assess whether consolidation can reduce overall complexity

---

## 8) Regression + Lessons-to-Rule Discipline
Whenever a bug, process issue, incident root cause, or recurring error is fixed, the following must also be done:

1. Add / update a regression case
2. Update acceptance docs / runbook / spec (depending on impact scope)
3. Record in `dev/SESSION_LOG.md`:
   - Problem
   - Root Cause
   - Fix
   - Verification

If the issue caused any of the following consequences, the lesson must also be codified as a rule:
1. Release incident
2. Wasted version
3. User-visible error
4. Data risk / security risk
5. Multiple rework cycles / repeated mistakes
6. Long-term drift between documentation and implementation

Codification methods include but are not limited to:
1. Adding an SOP clause
2. Adding a check step
3. Adding a consistency / policy check
4. Updating `PROJECT_MASTER_SPEC.md` (if it exists)
5. Updating `SESSION_HANDOFF.md` baseline / known risks / start checklist

---

## 8b) Rule Promotion Threshold (Mandatory)
Not every issue should be promoted to a long-term rule.

Only when an issue meets any of the following criteria is it appropriate to promote it to an SOP / long-term governance clause:
1. Has occurred repeatedly
2. Can cause a release incident
3. Can cause data / security risk
4. Would significantly waste versions, labor, or regression cost
5. Cannot be fundamentally resolved by individual patches alone
6. Is prone to recurring when multiple agents / sessions collaborate

If the issue does not meet the above thresholds, the preferred actions should be:
1. Fix the original definition
2. Add regression
3. Update the log
4. Fix the runbook / spec
Rather than adding a new permanent rule

Hard rules:
1. Do not substitute adding new rules for fixing root causes
2. Do not allow SOPs to expand without limit
3. Each time a new long-term rule is added, check whether old rules can be integrated or retired

---

## 9) Toolchain / Policy Compatibility (Conditional Mandatory)
If this project has any of the following mechanisms, the AI must run the corresponding checks and report results after every modification to affected files:

1. Static scanners
2. Linter / formatter
3. Type checker
4. Packaging / publishing constraints
5. Security / policy checks
6. Framework-specific compile checks
7. CI-required local parity checks

The AI must not assume "it should be fine" and skip compatibility verification.

---

## 10) Optional Master Spec Mode
If this project meets any of the following conditions, creating `dev/PROJECT_MASTER_SPEC.md` is recommended:

1. Multi-module / multi-agent collaboration
2. Long-term maintenance
3. Has a release / deploy / support lifecycle
4. Has complex acceptance criteria, runbooks, or regression definitions
5. The same rule is referenced across multiple files

Positioning:
1. `SESSION_HANDOFF.md`: current baseline, latest thresholds, current open items
2. `SESSION_LOG.md`: session-by-session historical decisions and verifications
3. `PROJECT_MASTER_SPEC.md`: complete, stable, long-term authoritative specification

Active trigger rule:
At the PERSIST phase, if `dev/PROJECT_MASTER_SPEC.md` does not yet exist, the AI must suggest creating it when either of the following applies:
1. The user explicitly requested it during this session
2. This session involved the user and AI establishing architecture decisions, tech stack choices, or core feature requirements, AND at least one condition from the list above is met (i.e., the project qualifies as multi-module, long-term, has a release lifecycle, or has complex spec/runbook needs)

The suggestion must state: which trigger applied, what decisions from this session are ready to consolidate, and a ready-to-use prompt the user can paste to initiate creation.
When the suggestion is made, record a line in `dev/SESSION_HANDOFF.md` under Open Priorities or Known Risks: `PROJECT_MASTER_SPEC suggestion issued: [session ID] [date].`
Do not repeat the suggestion in subsequent sessions unless new major architecture or requirement decisions were made after that recorded date.

Filename enforcement:
If creating this file, the path must be exactly `dev/PROJECT_MASTER_SPEC.md`.
Do not use alternative names such as `SPEC.md`, `MASTER_SPEC.md`, `ARCHITECTURE.md`, or `PROJECT_SPEC.md`.

---

## 11) Output Contract
Every AI response must include at minimum:

1. What was done
2. Why it was done that way
3. Verification results
4. Next-step recommendations (if any)

---

## 12) Multi-Agent Session ID Standard
Every AI agent must use the following format to generate a Session ID when recording in `SESSION_LOG.md`:

Format:
`<AgentName>_<YYYYMMDD>_<HHMM>` (UTC)

Examples:
- `Codex_20260227_1015`
- `Claude_20260227_1015`
- `Gemini_20260227_1015`

If the platform has its own runtime / thread / session identifier, it may be appended for reference, but must not replace this standard format.

</INSTRUCTIONS>
