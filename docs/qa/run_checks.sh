#!/usr/bin/env bash
# QA Regression Check Runner for ai-session-governance
# Usage: bash docs/qa/run_checks.sh  (run from project root)
# Output: only failures + summary line

set -euo pipefail

PASS=0; FAIL=0; TOTAL=0; FAILURES=""

# --- Helpers ---
check() {
  local id="$1" desc="$2" expected="$3" actual="$4"
  TOTAL=$((TOTAL+1))
  if [ "$actual" = "$expected" ]; then
    PASS=$((PASS+1))
  else
    FAIL=$((FAIL+1))
    FAILURES="${FAILURES}\n  FAIL [${id}] ${desc} — expected: ${expected}, got: ${actual}"
  fi
}

check_gte() {
  local id="$1" desc="$2" min="$3" actual="$4"
  TOTAL=$((TOTAL+1))
  if [ "$actual" -ge "$min" ] 2>/dev/null; then
    PASS=$((PASS+1))
  else
    FAIL=$((FAIL+1))
    FAILURES="${FAILURES}\n  FAIL [${id}] ${desc} — expected: >=${min}, got: ${actual}"
  fi
}

A="AGENTS.md"
I="INIT.md"
PYTHON_BIN=""
if command -v python >/dev/null 2>&1; then
  PYTHON_BIN="python"
elif command -v python3 >/dev/null 2>&1; then
  PYTHON_BIN="python3"
fi

# ============================================================
# Category 1: Fence Counts & File Structure
# ============================================================
check "S01" "Fence count AGENTS.md = 16" "16" "$(grep -c '^```' $A)"
check "S02" "Fence count INIT.md = 28" "28" "$(grep -c '^```' $I)"
check "S03" "Section count AGENTS.md = 22" "22" "$(grep -c '^## ' $A)"
check "S04" "AGENTS.md fences even" "0" "$(( $(grep -c '^```' $A) % 2 ))"
check "S05" "INIT.md fences even" "0" "$(( $(grep -c '^```' $I) % 2 ))"

# ============================================================
# Category 2: Section Ordering & Position
# ============================================================
s0=$(grep -n "^## 0)" $A | head -1 | cut -d: -f1)
s0a=$(grep -n "^## 0a)" $A | head -1 | cut -d: -f1)
s1=$(grep -n "^## 1)" $A | head -1 | cut -d: -f1)
s2=$(grep -n "^## 2)" $A | head -1 | cut -d: -f1)
s2b=$(grep -n "^## 2b)" $A | head -1 | cut -d: -f1)
s3=$(grep -n "^## 3)" $A | head -1 | cut -d: -f1)
s4=$(grep -n "^## 4)" $A | head -1 | cut -d: -f1)
s4a=$(grep -n "^## 4a)" $A | head -1 | cut -d: -f1)
s0b=$(grep -n "^## 0b)" $A | head -1 | cut -d: -f1)
s5=$(grep -n "^## 5)" $A | head -1 | cut -d: -f1)

check "O01" "§0 before §0a" "1" "$([ $s0 -lt $s0a ] && echo 1 || echo 0)"
check "O02" "§0a before §1" "1" "$([ $s0a -lt $s1 ] && echo 1 || echo 0)"
check "O03" "§1 before §2" "1" "$([ $s1 -lt $s2 ] && echo 1 || echo 0)"
check "O04" "§2 before §2b" "1" "$([ $s2 -lt $s2b ] && echo 1 || echo 0)"
check "O05" "§2b before §3" "1" "$([ $s2b -lt $s3 ] && echo 1 || echo 0)"
check "O06" "§3 before §4" "1" "$([ $s3 -lt $s4 ] && echo 1 || echo 0)"
check "O07" "§4 before §4a" "1" "$([ $s4 -lt $s4a ] && echo 1 || echo 0)"
check "O08" "§0b after §4a (CONDITIONAL zone)" "1" "$([ $s0b -gt $s4a ] && echo 1 || echo 0)"
check "O09" "§0b before §5" "1" "$([ $s0b -lt $s5 ] && echo 1 || echo 0)"
check "O10" "All MANDATORY before §0b" "1" "$([ $s3 -lt $s0b ] && echo 1 || echo 0)"

# ============================================================
# Category 3: Cross-Reference Integrity
# ============================================================
check "X01" "No dead §2c references in AGENTS.md" "0" "$(grep -c '§2c' $A)"
check "X02" "No dead §2c references in INIT.md" "0" "$(grep -c '§2c' $I)"
check "X03" "§3d referenced and exists" "1" "$(grep -c '^## 3d)' $A)"
check "X04" "§4a referenced and exists" "1" "$(grep -c '^## 4a)' $A)"
check "X05" "§3b referenced and exists" "1" "$(grep -c '^## 3b)' $A)"
check "X06" "§8b referenced and exists" "1" "$(grep -c '^## 8b)' $A)"

# ============================================================
# Category 4: Attention Anchor & Core Rules (Round 11)
# ============================================================
check "R11-01" "Attention anchor AGENTS.md" "1" "$(grep -c 'CORE RULES' $A)"
check "R11-02" "Attention anchor INIT.md" "1" "$(grep -c 'CORE RULES' $I)"

# ============================================================
# Category 5: Startup & Entry (§0, §0a, §1)
# ============================================================
check "030" "External API Code Safety in AGENTS.md (heading + scope ref)" "2" "$(grep -c 'External API Code Safety' $A)"
check "031" "External API Code Safety in INIT.md (heading + scope ref)" "2" "$(grep -c 'External API Code Safety' $I)"
check "032" "Doc-reviewed field in AGENTS.md" "1" "$(grep -c '^- Doc-reviewed:' $A)"
check "033" "Test-verified field in AGENTS.md" "1" "$(grep -c 'Test-verified:' $A)"
check "036" "Cannot-fetch-docs rule in AGENTS.md" "1" "$(grep -c 'Do not write API-calling code' $A)"
check "037" "§0b parity: External Platform heading" "1" "$([ "$(grep -c 'External Platform Alignment' $A)" = "$(grep -c 'External Platform Alignment' $I)" ] && echo 1 || echo 0)"
check "038" "§1 startup sequence order" "1" "$(grep -c 'SESSION_HANDOFF.md.*SESSION_LOG.md.*CODEBASE_CONTEXT.md.*PROJECT_MASTER_SPEC' $A)"
check "039" "§10 intent-based trigger" "1" "$(grep -c 'architecture decisions.*tech stack\|tech stack choices.*core feature' $A)"
check "040a" "CODEBASE_CONTEXT in backup AGENTS" "1" "$(grep -c 'CODEBASE_CONTEXT.*if present' $A)"
check "040b" "CODEBASE_CONTEXT in backup INIT (in §5a)" "1" "$(grep -c 'CODEBASE_CONTEXT.*if present' $I)"
check "042" "No 'key architectural' residue" "0" "$(grep -c 'key architectural' $A)"

# ============================================================
# Category 6: §3d Test Plan Design
# ============================================================
check "043" "§3d heading in AGENTS.md" "1" "$(grep -c '^## 3d) Test Plan' $A)"
check "044" "§3d heading in INIT.md" "1" "$(grep -c '^## 3d) Test Plan' $I)"
check_gte "045" "test scenario matrix in AGENTS.md" "1" "$(grep -c 'test scenario matrix' $A)"
check_gte "046" "test scenario matrix in INIT.md" "1" "$(grep -c 'test scenario matrix' $I)"
check "047" "verify each scenario in AGENTS.md" "1" "$(grep -c 'verify each scenario' $A)"
check "048" "verify each scenario in INIT.md" "1" "$(grep -c 'verify each scenario' $I)"
check_gte "049" "Result values note in AGENTS.md" "1" "$(grep -c 'PASS, PASS with notes' $A)"
check "050" "Test Scenarios template in INIT.md FILE 5" "1" "$(grep -c 'Test Scenarios' $I)"

# ============================================================
# Category 7: Cross-LLM Handoff (§4 rule 5)
# ============================================================
check "052" "Opening line requirement AGENTS.md" "1" "$(grep -c 'Opening line.*verbatim template\|verbatim template' $A)"
check "053" "Opening line requirement INIT.md" "1" "$(grep -c 'Opening line.*verbatim template\|verbatim template' $I)"
check_gte "054" "§1 startup sequence referenced in AGENTS.md" "1" "$(grep -c '§1 startup sequence' $A)"
check "056" "cross-tool handoffs rationale AGENTS.md" "1" "$(grep -c 'cross-tool handoffs' $A)"
check "057" "cross-tool handoffs rationale INIT.md" "1" "$(grep -c 'cross-tool handoffs' $I)"

# ============================================================
# Category 8: §1 New-Session Definition & Governance Gaps (v1.9)
# ============================================================
check "058" "3-trigger block AGENTS.md" "1" "$(grep -c 'Definition of.*new session' $A)"
check "059" "3-trigger block INIT.md" "1" "$(grep -c 'Definition of.*new session' $I)"
check "062" "Agent handoff trigger AGENTS.md" "1" "$(grep -c 'Agent handoff' $A)"
check "063" "Agent handoff trigger INIT.md" "1" "$(grep -c 'Agent handoff' $I)"
check "064" "§3 PERSIST sync AGENTS.md" "1" "$(grep -c 'same cross-document sync conditions' $A)"
check "065" "§3 PERSIST sync INIT.md" "1" "$(grep -c 'same cross-document sync conditions' $I)"
check "068" "Open Priorities regeneration AGENTS.md" "1" "$(grep -c 'Open Priorities regeneration' $A)"
check "069" "Open Priorities regeneration INIT.md" "1" "$(grep -c 'Open Priorities regeneration' $I)"
check "070" "replace not append AGENTS.md" "1" "$(grep -c 'replace, not append' $A)"
check "071" "replace not append INIT.md" "1" "$(grep -c 'replace, not append' $I)"
check "072" "SESSION_LOG summary max-3 AGENTS.md" "1" "$(grep -c 'SESSION_LOG summary field only' $A)"
check "073" "SESSION_LOG summary max-3 INIT.md" "1" "$(grep -c 'SESSION_LOG summary field only' $I)"
check "074" "Known Risks not Open Priorities AGENTS.md" "1" "$(grep -c 'Known Risks.*not Open Priorities' $A)"
check "075" "Known Risks not Open Priorities INIT.md" "1" "$(grep -c 'Known Risks.*not Open Priorities' $I)"
check "078" "§5.7 modification ops AGENTS.md" "1" "$(grep -c 'modification operations (create, delete' $A)"
check "079" "§5.7 modification ops INIT.md" "1" "$(grep -c 'modification operations (create, delete' $I)"

# ============================================================
# Category 9: DOC_SYNC_CHECKLIST (v2.0)
# ============================================================
check "083" "MANDATORY STARTUP marker" "1" "$(grep -c 'MANDATORY STARTUP' $A)"
check "084" "MANDATORY STARTUP in INIT" "1" "$(grep -c 'MANDATORY STARTUP' $I)"
check "085" "MANDATORY WORKFLOW marker" "1" "$(grep -c 'MANDATORY WORKFLOW' $A)"
check "086" "CONDITIONAL marker (no §2c)" "1" "$(grep 'CONDITIONAL.*apply when triggered' $A | grep -cv '§2c')"
check_gte "088" "DOC_SYNC_CHECKLIST referenced AGENTS.md" "1" "$(grep -c 'DOC_SYNC_CHECKLIST.md.*if it exists' $A)"
check_gte "089" "DOC_SYNC_CHECKLIST referenced INIT.md" "1" "$(grep -c 'DOC_SYNC_CHECKLIST.md.*if it exists' $I)"
check "090" "Release gate doc sync AGENTS.md" "1" "$(grep -c 'DOC_SYNC_CHECKLIST.*entries affected' $A)"
check "091" "Release gate doc sync INIT.md" "1" "$(grep -c 'DOC_SYNC_CHECKLIST.*entries affected' $I)"
check "094" "DOC_SYNC in backup AGENTS.md" "1" "$(grep -c 'DOC_SYNC_CHECKLIST.md.*if present' $A)"
check "095" "DOC_SYNC in backup INIT.md (in §5a)" "1" "$(grep -c 'DOC_SYNC_CHECKLIST.md.*if present' $I)"
check "100" "New checklist query AGENTS.md" "1" "$(grep -c 'Query.*DOC_SYNC_CHECKLIST' $A)"
check "101" "New checklist query INIT.md" "1" "$(grep -c 'Query.*DOC_SYNC_CHECKLIST' $I)"
check "102" "FILE 6 heading in INIT.md" "1" "$(grep -c 'FILE 6.*DOC_SYNC_CHECKLIST' $I)"
check "104" "Change Category Registry in INIT" "1" "$(grep -c 'Change Category Registry' $I)"
check "105" "Anti-pattern No Matching Row in INIT" "1" "$(grep -c 'Anti-pattern.*No Matching Row' $I)"
check "106" "DOC_SYNC_CHECKLIST.md exists" "1" "$(test -f dev/DOC_SYNC_CHECKLIST.md && echo 1 || echo 0)"
check "107" "Change Category Registry in checklist" "1" "$(grep -c 'Change Category Registry' dev/DOC_SYNC_CHECKLIST.md)"
check "109" "Governance rule row in checklist" "1" "$(grep -c 'Governance rule change.*AGENTS.md' dev/DOC_SYNC_CHECKLIST.md)"

# ============================================================
# Category 10: Handoff Chain Integrity (v2.1)
# ============================================================
check "112" "§1 Verbatim most-recent-dated AGENTS.md" "1" "$(grep -c 'most recent UTC date' $A)"
check "113" "§1 Verbatim most-recent-dated INIT.md" "1" "$(grep -c 'most recent UTC date' $I)"
check "114" "does not substitute AGENTS.md" "2" "$(grep -c 'does not substitute' $A)"
check "115" "does not substitute INIT.md" "2" "$(grep -c 'does not substitute' $I)"
check "116" "DOC_SYNC Matrix Scan mandatory AGENTS" "1" "$(grep -c 'DOC_SYNC Matrix Scan.*mandatory' $A)"
check "117" "DOC_SYNC Matrix Scan mandatory INIT" "1" "$(grep -c 'DOC_SYNC Matrix Scan.*mandatory' $I)"
check "118" "scan was skipped AGENTS" "1" "$(grep -c 'scan was skipped' $A)"
check "119" "scan was skipped INIT" "1" "$(grep -c 'scan was skipped' $I)"
check "120" "no file changes AGENTS" "1" "$(grep -c 'no file changes this task' $A)"
check "121" "no file changes INIT" "1" "$(grep -c 'no file changes this task' $I)"
check "124" "Post-startup first action AGENTS" "1" "$(grep -c 'Post-startup first action' $A)"
check_gte "125" "Post-startup first action INIT" "1" "$(grep -c 'Post-startup first action' $I)"

# ============================================================
# Category 11: §4a Session Log Maintenance (v2.2)
# ============================================================
check "126" "§4a heading AGENTS" "1" "$(grep -c '4a) Session Log Maintenance' $A)"
check "127" "§4a heading INIT" "1" "$(grep -c '4a) Session Log Maintenance' $I)"
check "128" "400-line trigger AGENTS" "1" "$(grep -c 'exceeds 400 lines' $A)"
check "129" "400-line trigger INIT" "1" "$(grep -c 'exceeds 400 lines' $I)"
check "130" "30-day trigger AGENTS" "1" "$(grep -c 'dated more than 30 days ago' $A)"
check "131" "30-day trigger INIT" "1" "$(grep -c 'dated more than 30 days ago' $I)"
check "132" "200-line target AGENTS" "1" "$(grep -c '200 lines' $A)"
check "133" "200-line target INIT" "1" "$(grep -c '200 lines' $I)"
check "134" "Quarterly format AGENTS" "1" "$(grep -c 'SESSION_LOG_YYYY_QN' $A)"
check "135" "Quarterly format INIT" "1" "$(grep -c 'SESSION_LOG_YYYY_QN' $I)"
check "136" "Never delete AGENTS" "1" "$(grep -c 'Never delete session entries' $A)"
check "137" "Never delete INIT" "1" "$(grep -c 'Never delete session entries' $I)"
check "138" "§4a in CONDITIONAL AGENTS" "1" "$(grep 'CONDITIONAL' $A | grep -c '§4a')"
check "139" "§4a in CONDITIONAL INIT" "1" "$(grep 'CONDITIONAL' $I | grep -c '§4a')"

# ============================================================
# Category 12: Governance Audit Fixes (v2.3)
# ============================================================
check "140" "PLAN My understanding AGENTS" "1" "$(grep -c 'My understanding.*1-sentence restatement' $A)"
check "141" "PLAN My understanding INIT" "1" "$(grep -c 'My understanding.*1-sentence restatement' $I)"
check "142" "Conflict arbitration AGENTS" "1" "$(grep -c 'user instruction conflicts.*rule in this document' $A)"
check "143" "Conflict arbitration INIT" "1" "$(grep -c 'user instruction conflicts.*rule in this document' $I)"
check "144" "Triage read note AGENTS" "1" "$(grep -c 'Targeted file reads.*during triage' $A)"
check "145" "Triage read note INIT" "1" "$(grep -c 'Targeted file reads.*during triage' $I)"
check "146" "CHANGE deviation AGENTS" "1" "$(grep -c 'diverges from PLAN.*stop.*report' $A)"
check "147" "CHANGE deviation INIT" "1" "$(grep -c 'diverges from PLAN.*stop.*report' $I)"
check "148" "§8/§8b reconciliation AGENTS" "1" "$(grep -c 'monitoring.*promote to rule if recurrence' $A)"
check "149" "§8/§8b reconciliation INIT" "1" "$(grep -c 'monitoring.*promote to rule if recurrence' $I)"
check "150" "§11 CHANGE or PERSIST AGENTS" "1" "$(grep -c 'CHANGE or PERSIST phase' $A)"
check "151" "§11 CHANGE or PERSIST INIT" "1" "$(grep -c 'CHANGE or PERSIST phase' $I)"
check "152" "§11 exemption AGENTS" "1" "$(grep -c 'clarifying questions.*status updates' $A)"
check "153" "§11 exemption INIT" "1" "$(grep -c 'clarifying questions.*status updates' $I)"
check_gte "154" "CODEBASE_CONTEXT in FILE 4 template" "1" "$(grep -c 'Read.*CODEBASE_CONTEXT' $I)"

# ============================================================
# Category 13: PLAN Risk Grading & Lean Format (v2.4)
# ============================================================
check "156" "Risk level criteria AGENTS" "1" "$(grep -c 'Risk level.*HIGH or LOW' $A)"
check "157" "Risk level criteria INIT" "1" "$(grep -c 'Risk level.*HIGH or LOW' $I)"
check "158" "Lean format AGENTS" "1" "$(grep -c 'lean key-value style' $A)"
check "159" "Lean format INIT" "1" "$(grep -c 'lean key-value style' $I)"
check_gte "160" "FILE 5 bold key format" "1" "$(grep -c '\*\*ID:\*\*' $I)"
check "162" "Archive >400 AGENTS" "1" "$(grep -c '>400 lines' $A)"
check_gte "163" "Archive >400 INIT" "1" "$(grep -c '>400 lines' $I)"
check "164" "HIGH wait AGENTS" "1" "$(grep -c 'wait for user confirmation' $A)"
check "165" "HIGH wait INIT" "1" "$(grep -c 'wait for user confirmation' $I)"
check "166" "Assumptions and risks AGENTS" "1" "$(grep -c 'Assumptions and risks' $A)"
check "167" "Assumptions and risks INIT" "1" "$(grep -c 'Assumptions and risks' $I)"
check "168" "Self-challenge removed AGENTS" "0" "$(grep -c 'Challenge own assumptions' $A)"
check "169" "Self-challenge removed INIT" "0" "$(grep -c 'Challenge own assumptions' $I)"

# ============================================================
# Category 14: Harness Optimization (Round 11 — v2.5)
# ============================================================
# --- §2 consolidated ---
check "R11-03" "§2 refs §1 AGENTS" "1" "$(grep -c 'defer to the §1 read order' $A)"
check "R11-04" "§2 refs §1 INIT" "1" "$(grep -c 'defer to the §1 read order' $I)"
check "R11-05" "Old §2 file list gone" "0" "$(grep -c 'current baseline, execution thresholds' $A)"

# --- §2c merged into §3 ---
check "R11-06" "§2c heading absent AGENTS" "0" "$(grep -c '^## 2c)' $A)"
check "R11-07" "§2c heading absent INIT" "0" "$(grep -c '^## 2c)' $I)"
check "R11-08" "§3 READ expanded AGENTS" "1" "$(grep -c 'full context of the section to be modified' $A)"
check "R11-09" "§3 READ expanded INIT" "1" "$(grep -c 'full context of the section to be modified' $I)"
check "R11-10" "§2b cross-ref updated AGENTS" "1" "$(grep -c '§3 READ coverage' $A)"
check "R11-11" "§2b cross-ref updated INIT" "1" "$(grep -c '§3 READ coverage' $I)"

# --- QC fail-path ---
check "R11-12" "QC fail-path AGENTS" "1" "$(grep -c 'QC reveals test failures' $A)"
check "R11-13" "QC fail-path INIT" "1" "$(grep -c 'QC reveals test failures' $I)"

# --- Deviation resume ---
check "R11-14" "Deviation resume AGENTS" "1" "$(grep -c 'receiving user direction following' $A)"
check "R11-15" "Deviation resume INIT" "1" "$(grep -c 'receiving user direction following' $I)"

# --- Closeout protection ---
check "R11-16" "Closeout protection AGENTS" "1" "$(grep -c 'confirm session-end intent' $A)"
check "R11-17" "Closeout protection INIT" "1" "$(grep -c 'confirm session-end intent' $I)"

# --- Codex README note ---
check "R11-18" "Codex note README.md" "1" "$(grep -c 'project_doc_max_bytes' README.md)"
check "R11-19" "Codex note README.zh-TW.md" "1" "$(grep -c 'project_doc_max_bytes' README.zh-TW.md)"
check "R11-20" "Codex note README.zh-CN.md" "1" "$(grep -c 'project_doc_max_bytes' README.zh-CN.md)"
check "R11-21" "Codex note README.ja.md" "1" "$(grep -c 'project_doc_max_bytes' README.ja.md)"

# --- §0b position ---
check "R11-22" "§0b after §4a AGENTS" "1" "$(awk '/^## 4a\)/{a=NR} /^## 0b\)/{b=NR} END{print (b>a)?1:0}' $A)"
check "R11-23" "§0b after §4a INIT" "1" "$(awk '/^## 4a\)/{a=NR} /^## 0b\)/{b=NR} END{print (b>a)?1:0}' $I)"

# --- Section marker updated ---
check "R11-24" "§2c not in CONDITIONAL marker" "0" "$(grep 'CONDITIONAL.*apply when triggered' $A | grep -c '§2c')"
check "R11-25" "§5a in CONDITIONAL marker AGENTS" "1" "$(grep 'CONDITIONAL.*apply when triggered' $A | grep -c '§5a')"
check "R11-26" "§5a in CONDITIONAL marker INIT" "1" "$(grep 'CONDITIONAL.*apply when triggered' $I | grep -c '§5a')"

# ============================================================
# Category 16: Re-Audit Fixes (v2.6)
# ============================================================
# --- N5+N7: §1 Verbatim most-recent-dated + §2 cross-ref ---
check "R26-01" "§1 no 'last occurring' residue AGENTS" "0" "$(grep -c 'last occurring such heading' $A)"
check "R26-02" "§1 no 'last occurring' residue INIT" "0" "$(grep -c 'last occurring such heading' $I)"
check "R26-03" "§1 regardless of physical position AGENTS" "1" "$(grep -c 'regardless of the entry' $A)"
check "R26-04" "§1 regardless of physical position INIT" "1" "$(grep -c 'regardless of the entry' $I)"
check "R26-05" "§1→§2 cross-ref AGENTS" "1" "$(grep -c 'subject to the precedence rules in §2 rule 5' $A)"
check "R26-06" "§1→§2 cross-ref INIT" "1" "$(grep -c 'subject to the precedence rules in §2 rule 5' $I)"
check "R26-05b" "§1 same-date tiebreaker AGENTS" "1" "$(grep -c 'physically topmost entry wins' $A)"
check "R26-06b" "§1 same-date tiebreaker INIT" "1" "$(grep -c 'physically topmost entry wins' $I)"

# --- N1: INIT.md root-safety collapsed to §5a pointer ---
check "R26-07" "INIT top-block delegates to §5a" "1" "$(grep -c 'single source of truth for bootstrap root safety' $I)"
# INSTALL_ROOT_OK presence (rule in §5a + pointer reference + QUICK START confirmation)
check "R26-08" "INSTALL_ROOT_OK present in INIT" "1" "$(grep -c 'INSTALL_ROOT_OK' $I | awk '{print ($1>=1)?1:0}')"
check "R26-09" "INSTALL_WRITE_OK present in INIT" "1" "$(grep -c 'INSTALL_WRITE_OK' $I | awk '{print ($1>=1)?1:0}')"

# --- N2: cue randomization narrowed ---
check "R26-10" "Boot cue uniform AGENTS" "1" "$(grep -c 'randomize across styles uniformly' $A)"
check "R26-11" "Boot cue uniform INIT" "1" "$(grep -c 'randomize across styles uniformly' $I)"
check "R26-12" "Closeout cue within-session AGENTS" "1" "$(grep -c 'within a single session, the Closeout Visual Cue must differ' $A)"
check "R26-13" "Closeout cue within-session INIT" "1" "$(grep -c 'within a single session, the Closeout Visual Cue must differ' $I)"
check "R26-14" "Boot cue no 'if the previous style is known' AGENTS" "0" "$(grep -c 'if the previous style is known' $A)"
check "R26-15" "Boot cue no 'if the previous style is known' INIT" "0" "$(grep -c 'if the previous style is known' $I)"

# --- N4: §0b scope clarification ---
check "R26-16" "§0b scope clarification AGENTS" "1" "$(grep -c 'Editing documentation, governance rules, or templates' $A)"
check "R26-17" "§0b scope clarification INIT" "1" "$(grep -c 'Editing documentation, governance rules, or templates' $I)"

# --- §12 grandfather clause ---
check "R26-18" "§12 grandfather clause AGENTS" "1" "$(grep -c 'not retroactively rewritten' $A)"
check "R26-19" "§12 grandfather clause INIT" "1" "$(grep -c 'not retroactively rewritten' $I)"

# --- N3: §12 HHMM format enforced-presence check (was coverage gap) ---
check "R26-20" "§12 HHMM format present AGENTS" "1" "$(grep -c 'YYYYMMDD.*HHMM' $A | awk '{print ($1>=1)?1:0}')"
check "R26-21" "§12 HHMM format present INIT" "1" "$(grep -c 'YYYYMMDD.*HHMM' $I | awk '{print ($1>=1)?1:0}')"

# --- N3: §10 filename enforcement (was coverage gap) ---
check "R26-22" "§10 filename enforcement heading AGENTS" "1" "$(grep -c 'Filename enforcement' $A)"
check "R26-23" "§10 filename enforcement heading INIT" "1" "$(grep -c 'Filename enforcement' $I)"
check "R26-24" "§10 forbidden alt-names list AGENTS" "1" "$(grep -c 'alternative names such as' $A)"
check "R26-25" "§10 forbidden alt-names list INIT" "1" "$(grep -c 'alternative names such as' $I)"
check "R26-26" "§10 forbids ARCHITECTURE alt AGENTS" "1" "$(grep -c 'ARCHITECTURE.md' $A)"
check "R26-27" "§10 forbids ARCHITECTURE alt INIT" "1" "$(grep -c 'ARCHITECTURE.md' $I)"

# --- N3: §5 forbidden ops list (was coverage gap) ---
check "R26-28" "§5 forbids Remove-Item AGENTS" "1" "$(grep -c 'Remove-Item -Recurse -Force' $A)"
check "R26-29" "§5 forbids Remove-Item INIT" "1" "$(grep -c 'Remove-Item -Recurse -Force' $I)"
check "R26-30" "§5 forbids git reset --hard AGENTS" "1" "$(grep -c 'git reset --hard' $A)"
check "R26-31" "§5 forbids git reset --hard INIT" "1" "$(grep -c 'git reset --hard' $I)"
check "R26-32" "§5 forbids git clean -fdx AGENTS" "1" "$(grep -c 'git clean -fdx' $A)"
check "R26-33" "§5 forbids git clean -fdx INIT" "1" "$(grep -c 'git clean -fdx' $I)"

# --- N3: §5a step 10 presence (was coverage gap) ---
check "R26-34" "§5a step 10 abort rule AGENTS" "1" "$(grep -c 'If high-risk markers are detected' $A)"
check "R26-35" "§5a step 10 abort rule INIT" "1" "$(grep -c 'If high-risk markers are detected' $I)"

# --- N3: §4 closeout layout separators (was coverage gap) ---
check "R26-36" "§4 major separator rule AGENTS" "1" "$(grep -c 'Major separator:' $A)"
check "R26-37" "§4 major separator rule INIT" "1" "$(grep -c 'Major separator:' $I)"
check "R26-38" "§4 minor separator rule AGENTS" "1" "$(grep -c 'Minor separator:' $A)"
check "R26-39" "§4 minor separator rule INIT" "1" "$(grep -c 'Minor separator:' $I)"

# ============================================================
# Category 15: README Asset & Localization
# ============================================================
for img in ref_doc/overview_infograph_en.png ref_doc/overview_infograph_tw.png ref_doc/overview_infograph_cn.png ref_doc/overview_infograph_ja.png ref_doc/launch.png ref_doc/closesession.png ref_doc/install_step_1.png ref_doc/install_step_2.png ref_doc/install_step_3.png ref_doc/install_step_4.png; do
  check "IMG" "$img exists" "1" "$(test -f "$img" && echo 1 || echo 0)"
done

# ============================================================
# Category 17: P3 Root-Fix (Executable Maintenance + Handoff Compactness)
# ============================================================
check "R27-01" "Handoff compactness budget AGENTS" "1" "$(grep -c 'Session handoff compactness budget' $A)"
check "R27-02" "Handoff compactness budget INIT" "1" "$(grep -c 'Session handoff compactness budget' $I)"
check "R27-03" "Maintenance trigger evaluation AGENTS" "1" "$(grep -c 'evaluate triggers directly from `dev/SESSION_LOG.md`' $A)"
check "R27-04" "Maintenance trigger evaluation INIT" "1" "$(grep -c 'evaluate triggers directly from `dev/SESSION_LOG.md`' $I)"
check "R27-05" "No Python requirement in AGENTS §4a" "0" "$(grep -c 'python docs/qa/session_log_maintenance.py' $A)"
check "R27-06" "No Python requirement in INIT §4a" "0" "$(grep -c 'python docs/qa/session_log_maintenance.py' $I)"
check "R27-07" "FILE 7 heading removed from INIT.md" "0" "$(grep -c 'FILE 7: docs/qa/session_log_maintenance.py' $I)"
check "R27-08" "session_log_maintenance.py exists" "1" "$(test -f docs/qa/session_log_maintenance.py && echo 1 || echo 0)"
check "R27-08b" "Doc sync row in INIT checklist template" "1" "$(grep -c 'Session-log maintenance policy changed' $I)"
check "R27-08c" "Doc sync row in dev checklist" "1" "$(grep -c 'Session-log maintenance policy changed' dev/DOC_SYNC_CHECKLIST.md)"

if [ -n "$PYTHON_BIN" ] && [ -f docs/qa/session_log_maintenance.py ] && $PYTHON_BIN docs/qa/session_log_maintenance.py --self-test >/dev/null 2>&1; then
  selftest_rc=0
elif [ -z "$PYTHON_BIN" ]; then
  selftest_rc=0
else
  selftest_rc=1
fi
check "R27-09" "session_log_maintenance self-test matrix (skip if python unavailable)" "0" "$selftest_rc"

if [ -n "$PYTHON_BIN" ] && [ -f docs/qa/session_log_maintenance.py ] && $PYTHON_BIN docs/qa/session_log_maintenance.py --check --session-log dev/SESSION_LOG.md >/dev/null 2>&1; then
  check_exec_rc=0
elif [ -z "$PYTHON_BIN" ]; then
  check_exec_rc=0
else
  check_exec_rc=$?
fi
check "R27-10" "session_log_maintenance check command executable (0 or 2, skip if python unavailable)" "1" "$([ $check_exec_rc -eq 0 -o $check_exec_rc -eq 2 ] && echo 1 || echo 0)"
check "R27-11" "README EN hides internal maintenance script" "0" "$(grep -c 'session_log_maintenance.py' README.md)"
check "R27-12" "README zh-TW hides internal maintenance script" "0" "$(grep -c 'session_log_maintenance.py' README.zh-TW.md)"
check "R27-13" "README zh-CN hides internal maintenance script" "0" "$(grep -c 'session_log_maintenance.py' README.zh-CN.md)"
check "R27-14" "README ja hides internal maintenance script" "0" "$(grep -c 'session_log_maintenance.py' README.ja.md)"
check "R27-15" "README EN hides Python maintenance commands" "0" "$(grep -c 'python docs/qa/session_log_maintenance.py' README.md)"
check "R27-16" "README zh-TW hides Python maintenance commands" "0" "$(grep -c 'python docs/qa/session_log_maintenance.py' README.zh-TW.md)"
check "R27-17" "README zh-CN hides Python maintenance commands" "0" "$(grep -c 'python docs/qa/session_log_maintenance.py' README.zh-CN.md)"
check "R27-18" "README ja hides Python maintenance commands" "0" "$(grep -c 'python docs/qa/session_log_maintenance.py' README.ja.md)"
check "R27-19" "INIT package self-containment: no docs/qa/run_checks.sh reference" "0" "$(grep -c 'docs/qa/run_checks.sh' $I)"
check "R27-20" "INIT package self-containment: no docs/qa/session_log_maintenance.py reference" "0" "$(grep -c 'docs/qa/session_log_maintenance.py' $I)"

# ============================================================
# Summary
# ============================================================
echo ""
echo "=========================================="
echo "  QA Regression: ${PASS}/${TOTAL} passed, ${FAIL} failed"
echo "=========================================="
if [ $FAIL -gt 0 ]; then
  echo -e "\nFailures:${FAILURES}"
  exit 1
else
  echo "  All checks passed."
  exit 0
fi
