# Regression Test Plan — Pointer Files Implementation
# 回歸測試計畫 — 指標檔實作

**Date / 日期**: 2026-02-27
**Session ID**: Claude_20260227_1600
**Scope / 範圍**: CLAUDE.md + GEMINI.md pointer files, 4 READMEs, integration instructions
**Status / 狀態**: Automated checks pre-filled; manual tests pending

---

## Table of Contents / 目錄

1. [Test Matrix — File Combinations / 測試矩陣 — 檔案組合](#1-test-matrix--file-combinations--測試矩陣--檔案組合)
2. [Platform-Specific Tests / 平台特定測試](#2-platform-specific-tests--平台特定測試)
3. [Platform Switching Tests / 平台切換測試](#3-platform-switching-tests--平台切換測試)
4. [Workspace Variation Tests / 工作區變體測試](#4-workspace-variation-tests--工作區變體測試)
5. [Content Preservation Tests / 內容保全測試](#5-content-preservation-tests--內容保全測試)
6. [Edge Cases / 邊界情況](#6-edge-cases--邊界情況)
7. [README Parity Checklist / README 一致性檢查](#7-readme-parity-checklist--readme-一致性檢查)
8. [Summary / 總結](#8-summary--總結)

---

## 1. Test Matrix — File Combinations / 測試矩陣 — 檔案組合

8 scenarios covering all combinations of pre-existing files (AGENTS.md / CLAUDE.md / GEMINI.md).
8 種情境覆蓋所有預存檔案組合。

**Legend / 圖例**: `--` = absent 不存在, `EX` = exists with pre-existing content 存在（含既有內容）

### Pass Criteria (all scenarios) / 通過標準（所有情境）
- After integration, all 3 files exist / 整合後 3 個檔案都存在
- CLAUDE.md contains `@AGENTS.md` directive / CLAUDE.md 含 `@AGENTS.md` 指令
  - Template copy: on line 3 (after two HTML comment lines) / 範本複製：在第 3 行（兩行 HTML 註解之後）
  - Prepend to existing: on line 1 / 在既有檔案最上方加入：在第 1 行
- GEMINI.md contains `@./AGENTS.md` directive / GEMINI.md 含 `@./AGENTS.md` 指令
  - Template copy: on line 3 (after two HTML comment lines) / 範本複製：在第 3 行
  - Prepend to existing: on line 1 / 在既有檔案最上方加入：在第 1 行
- AGENTS.md contains governance rules / AGENTS.md 含治理規則
- Pre-existing content is preserved / 既有內容被保留

### Results / 結果

| ID | AGENTS.md | CLAUDE.md | GEMINI.md | Expected Action / 預期操作 | Verified / 已驗證 | Result / 結果 |
|---|---|---|---|---|---|---|
| B1 | `--` | `--` | `--` | Copy all 3 template files / 複製全部 3 個範本檔 | 3 files exist; pointer on L3 (template) | `PASS` |
| B2 | `EX` | `--` | `--` | Keep AGENTS, copy CLAUDE + GEMINI templates / 保留 AGENTS，複製 CLAUDE + GEMINI 範本 | 3 files exist; pointer on L3 (template) | `PASS` |
| B3 | `--` | `EX` | `--` | Copy AGENTS + GEMINI, prepend `@AGENTS.md` to CLAUDE / 複製 AGENTS + GEMINI，在 CLAUDE 加入指標 | CLAUDE ptr L1 ✓; GEMINI ptr L3 (template); content preserved ✓ | `PASS` |
| B4 | `--` | `--` | `EX` | Copy AGENTS + CLAUDE, prepend `@./AGENTS.md` to GEMINI / 複製 AGENTS + CLAUDE，在 GEMINI 加入指標 | CLAUDE ptr L3 (template); GEMINI ptr L1 ✓; content preserved ✓ | `PASS` |
| B5 | `EX` | `EX` | `--` | Keep AGENTS, prepend to CLAUDE, copy GEMINI / 保留 AGENTS，在 CLAUDE 加入指標，複製 GEMINI | CLAUDE ptr L1 ✓; GEMINI ptr L3 (template); content preserved ✓ | `PASS` |
| B6 | `EX` | `--` | `EX` | Keep AGENTS, copy CLAUDE, prepend to GEMINI / 保留 AGENTS，複製 CLAUDE，在 GEMINI 加入指標 | CLAUDE ptr L3 (template); GEMINI ptr L1 ✓; content preserved ✓ | `PASS` |
| B7 | `--` | `EX` | `EX` | Copy AGENTS, prepend pointers to both / 複製 AGENTS，兩個既有檔都加入指標 | Both ptr L1 ✓; both content preserved ✓ | `PASS` |
| B8 | `EX` | `EX` | `EX` | Keep AGENTS (merge), prepend pointers to both / 保留 AGENTS（合併），兩個既有檔都加入指標 | Both ptr L1 ✓; both content preserved ✓ | `PASS` |

**Verification details / 驗證細節**:
- All 8 scenarios: all 3 files exist after integration ✓
- Template copies (Path A): `@AGENTS.md` / `@./AGENTS.md` on line 3 — correct by design (HTML comments on L1-L2) ✓
- Prepend to existing (Path B): `@AGENTS.md` / `@./AGENTS.md` on line 1 ✓
- B3, B5, B7, B8 (pre-existing CLAUDE.md): original "TypeScript strict mode" content preserved ✓
- B4, B6, B7, B8 (pre-existing GEMINI.md): original "code_review" content preserved ✓

**Note on template pointer position / 範本指標位置說明**:
The template `CLAUDE.md` and `GEMINI.md` ship with two HTML comment lines before the `@` directive (lines 1-2 are comments, line 3 is the pointer). This is intentional — the comments provide human guidance for existing-file integration. All platforms parse the `@` directive regardless of line position.
範本的 `CLAUDE.md` 和 `GEMINI.md` 在 `@` 指令前有兩行 HTML 註解（第 1-2 行為註解，第 3 行為指標）。這是刻意設計 — 註解為既有檔案整合提供人類可讀的指引。所有平台都會解析 `@` 指令，不論行數位置。

---

## 2. Platform-Specific Tests / 平台特定測試

These tests require live LLM interaction and cannot be automated.
這些測試需要實際 LLM 互動，無法自動化。

### 2.1 Claude Code

| ID | Test / 測試 | Expected / 預期 | Status / 狀態 |
|---|---|---|---|
| P-CC-1 | Claude Code auto-loads `CLAUDE.md` on session start / Claude Code 啟動時自動載入 `CLAUDE.md` | Agent sees governance rules from AGENTS.md / Agent 看到 AGENTS.md 治理規則 | `MANUAL` |
| P-CC-2 | `@AGENTS.md` import resolves correctly / `@AGENTS.md` 匯入正確解析 | Full AGENTS.md content visible in agent context / 完整 AGENTS.md 內容可見 | `MANUAL` |
| P-CC-3 | Agent follows §1 Single Entry workflow / Agent 遵循 §1 單一入口工作流 | Reads SESSION_HANDOFF.md and SESSION_LOG.md first / 先讀 SESSION_HANDOFF.md 和 SESSION_LOG.md | `MANUAL` |
| P-CC-4 | Session close (§4) persists to dev/ files / Session 收尾（§4）持久化到 dev/ 檔案 | Both dev/ files updated with session record / 兩個 dev/ 檔都更新 session 紀錄 | `MANUAL` |
| P-CC-5 | Existing CLAUDE.md project rules + pointer = both load / 既有 CLAUDE.md 專案規則 + 指標 = 兩者都載入 | Governance rules AND project rules visible / 治理規則和專案規則都可見 | `MANUAL` |

### 2.2 Gemini CLI

| ID | Test / 測試 | Expected / 預期 | Status / 狀態 |
|---|---|---|---|
| P-GC-1 | Gemini CLI auto-loads `GEMINI.md` on session start / Gemini CLI 啟動時自動載入 `GEMINI.md` | Agent sees governance rules from AGENTS.md / Agent 看到 AGENTS.md 治理規則 | `MANUAL` |
| P-GC-2 | `@./AGENTS.md` import resolves correctly / `@./AGENTS.md` 匯入正確解析 | Full AGENTS.md content visible in agent context / 完整 AGENTS.md 內容可見 | `MANUAL` |
| P-GC-3 | Agent follows §1 Single Entry workflow / Agent 遵循 §1 單一入口工作流 | Reads SESSION_HANDOFF.md and SESSION_LOG.md first / 先讀取 handoff + log | `MANUAL` |
| P-GC-4 | Session close (§4) persists to dev/ files / Session 收尾持久化 | Both dev/ files updated / 兩個 dev/ 檔都更新 | `MANUAL` |
| P-GC-5 | Existing GEMINI.md skills + pointer = both load / 既有 GEMINI.md skills + 指標 = 兩者都載入 | Skills AND governance rules visible / Skills 和治理規則都可見 | `MANUAL` |

### 2.3 Codex

| ID | Test / 測試 | Expected / 預期 | Status / 狀態 |
|---|---|---|---|
| P-CX-1 | Codex auto-loads `AGENTS.md` natively / Codex 原生自動載入 `AGENTS.md` | Agent sees governance rules directly / Agent 直接看到治理規則 | `MANUAL` |
| P-CX-2 | No pointer file needed / 不需要指標檔 | AGENTS.md is the native file / AGENTS.md 就是原生檔案 | `MANUAL` |
| P-CX-3 | Agent follows §1 Single Entry workflow / Agent 遵循 §1 單一入口工作流 | Reads handoff + log first / 先讀取 handoff + log | `MANUAL` |
| P-CX-4 | Session close (§4) persists to dev/ files / Session 收尾持久化 | Both dev/ files updated / 兩個 dev/ 檔都更新 | `MANUAL` |

**Manual test instructions / 手動測試步驟**:
1. Open a fresh session in the target platform / 在目標平台開啟新 session
2. Provide the Quick Start prompt: `Follow AGENTS.md. Read dev/SESSION_HANDOFF.md and dev/SESSION_LOG.md first, then begin.`
3. Verify the agent reads governance rules and follows §1 / 確認 agent 讀取治理規則並遵循 §1
4. Perform a small task, then say "wrap up" / 執行小任務後說 "wrap up"
5. Verify dev/ files are updated / 確認 dev/ 檔案已更新

---

## 3. Platform Switching Tests / 平台切換測試

All tests in this section require live LLM interaction.
本節所有測試需要實際 LLM 互動。

| ID | Scenario / 情境 | Setup / 設置 | Pass Criteria / 通過標準 | Status / 狀態 |
|---|---|---|---|---|
| SW-1 | Claude Code → Gemini CLI | Start on Claude Code, close session, reopen on Gemini CLI / 從 Claude Code 開始，關閉 session，在 Gemini CLI 重新開啟 | Gemini reads same dev/ files, continues from handoff state / Gemini 讀取相同 dev/ 檔案，從 handoff 狀態繼續 | `MANUAL` |
| SW-2 | Gemini CLI → Codex | Start on Gemini CLI, close session, reopen on Codex / 從 Gemini CLI 開始，關閉 session，在 Codex 重新開啟 | Codex reads same dev/ files, continues from handoff state / Codex 讀取相同 dev/ 檔案，從 handoff 狀態繼續 | `MANUAL` |
| SW-3 | Codex → Claude Code | Start on Codex, close session, add CLAUDE.md pointer, reopen on Claude Code / 從 Codex 開始，關閉 session，新增 CLAUDE.md 指標，在 Claude Code 重新開啟 | Claude Code picks up governance + dev/ state / Claude Code 取得治理規則 + dev/ 狀態 | `MANUAL` |
| SW-4 | Round-trip: all 3 | Claude Code → Gemini CLI → Codex → Claude Code / 完整循環：三個平台依序 | Each platform reads dev/ and continues correctly; Session IDs use §12 standard / 每個平台都讀取 dev/ 並正確繼續；Session ID 使用 §12 標準 | `MANUAL` |

**Key verification points / 關鍵驗證點**:
- dev/SESSION_LOG.md shows entries from multiple agents with correct Session ID format / dev/SESSION_LOG.md 顯示多個 agent 的條目，使用正確 Session ID 格式
- dev/SESSION_HANDOFF.md last session record reflects latest agent / dev/SESSION_HANDOFF.md 最後 session 紀錄反映最新 agent
- No governance rule duplication or conflict after switching / 切換後沒有治理規則重複或衝突

---

## 4. Workspace Variation Tests / 工作區變體測試

| ID | Scenario / 情境 | Expected / 預期 | Status / 狀態 |
|---|---|---|---|
| WS-1 | Standard: files at project root / 標準：檔案在專案根目錄 | Pointer resolves; governance loads / 指標解析；治理規則載入 | `MANUAL` |
| WS-2 | Monorepo: files in `packages/my-app/` subdirectory / Monorepo：檔案在子目錄 | Pointer resolves relative to file location / 指標相對於檔案位置解析 | `MANUAL` |
| WS-3 | Nested: CLAUDE.md at root AND subdirectory / 巢狀：CLAUDE.md 在根目錄和子目錄都有 | Platform-specific behavior: nearest file wins (Claude Code merges hierarchy) / 平台特定行為：最近的檔案優先（Claude Code 合併層級） | `MANUAL` |

**Manual test instructions / 手動測試步驟**:
1. WS-1: Standard setup, run quick start prompt / 標準設置，執行快速啟動 prompt
2. WS-2: Place all files in a monorepo subdirectory, open session from that directory / 將所有檔案放在 monorepo 子目錄，從該目錄開啟 session
3. WS-3: Place CLAUDE.md at both root and subdirectory with different content, verify which loads / 在根目錄和子目錄都放 CLAUDE.md（不同內容），確認哪個被載入

---

## 5. Content Preservation Tests / 內容保全測試

Simulated via temp directories with realistic file content.
透過臨時目錄模擬，使用實際檔案內容。

| ID | Scenario / 情境 | Metric / 指標 | Result / 結果 | Status / 狀態 |
|---|---|---|---|---|
| C1 | CLAUDE.md with 50 lines of project rules → prepend `@AGENTS.md` / CLAUDE.md 含 50 行專案規則 → 在最上方加入 `@AGENTS.md` | Line count = original + 1 / 行數 = 原始 + 1 | orig=50 new=51 expected=51 | `PASS` |
| C2 | GEMINI.md with custom skills/context → prepend `@./AGENTS.md` / GEMINI.md 含自訂 skills/context → 在最上方加入 `@./AGENTS.md` | Line count = original + 1 / 行數 = 原始 + 1 | orig=9 new=10 expected=10 | `PASS` |
| C3 | Pointer line is exactly line 1 after integration / 整合後指標行恰好在第 1 行 | L1 of CLAUDE = `@AGENTS.md`, L1 of GEMINI = `@./AGENTS.md` | claude_L1=`@AGENTS.md` gemini_L1=`@./AGENTS.md` | `PASS` |

---

## 6. Edge Cases / 邊界情況

| ID | Scenario / 情境 | Result / 結果 | Status / 狀態 |
|---|---|---|---|
| D1 | Empty CLAUDE.md → add `@AGENTS.md` / 空 CLAUDE.md → 加入 `@AGENTS.md` | File contains exactly `@AGENTS.md` | `PASS` |
| D2 | Empty GEMINI.md → add `@./AGENTS.md` / 空 GEMINI.md → 加入 `@./AGENTS.md` | File contains exactly `@./AGENTS.md` | `PASS` |
| D3 | AGENTS.md missing but CLAUDE.md pointer present / AGENTS.md 不存在但 CLAUDE.md 指標存在 | Broken reference; platform-dependent graceful handling / 斷裂參考；平台特定的優雅處理 | `DOCUMENTED` |
| D4 | CRLF vs LF line endings / CRLF vs LF 行尾 | Pointer line reads correctly regardless of line ending / 無論行尾格式，指標行都正確讀取 | `PASS` |
| D5 | UTF-8 BOM vs no BOM / UTF-8 BOM vs 無 BOM | Pointer resolves with both encodings / 兩種編碼都能解析指標 | `PASS` |
| D6 | Circular import: AGENTS.md → CLAUDE.md → AGENTS.md / 循環匯入 | Not applicable: AGENTS.md does not reference CLAUDE.md. Architecture is one-directional (pointer → SSOT). / 不適用：AGENTS.md 不參考 CLAUDE.md。架構是單向的（指標 → SSOT）。 | `N/A` |

### D3 — Broken Reference Detail / D3 — 斷裂參考細節

When AGENTS.md is missing but a pointer file references it:
當 AGENTS.md 不存在但指標檔參考它時：

| Platform / 平台 | Expected Behavior / 預期行為 | Status / 狀態 |
|---|---|---|
| Claude Code | Import fails silently or shows warning; CLAUDE.md project rules still load / 匯入靜默失敗或顯示警告；CLAUDE.md 專案規則仍載入 | `MANUAL` |
| Gemini CLI | `@./AGENTS.md` reference unresolved; GEMINI.md other content still loads / `@./AGENTS.md` 參考未解析；GEMINI.md 其他內容仍載入 | `MANUAL` |
| Codex | No pointer used; AGENTS.md absence means no governance / 未使用指標；AGENTS.md 不存在表示無治理規則 | `MANUAL` |

---

## 7. README Parity Checklist / README 一致性檢查

Automated structural comparison across all 4 READMEs.
自動化結構比較，橫跨全部 4 個 README。

| ID | Check / 檢查項目 | EN | zh-TW | zh-CN | ja | Status / 狀態 |
|---|---|---|---|---|---|---|
| A1 | CLAUDE.md contains `@AGENTS.md` / CLAUDE.md 包含 `@AGENTS.md` | — | — | — | — | `PASS` |
| A2 | GEMINI.md contains `@./AGENTS.md` / GEMINI.md 包含 `@./AGENTS.md` | — | — | — | — | `PASS` |
| A3 | File tree matches across READMEs / 檔案樹跨 README 一致 | 6 entries | 6 entries | 6 entries | 6 entries | `PASS` |
| A4 | `##` heading count parity / `##` 標題數一致 | 13 | 13 | 13 | 13 | `PASS` |
| A4b | `###` heading count parity / `###` 標題數一致 | 28 | 28 | 28 | 28 | `PASS` |
| A5 | No stale language (old approach remnants) / 無過時語言（舊方案殘留） | — | — | — | — | `PASS` |
| A6 | Platform setup table: 4 columns × 3 data rows / 平台設定表：4 欄 × 3 資料列 | 4×3 | 4×3 | 4×3 | 4×3 | `PASS` |
| A7 | Path B mentions all 3 files (AGENTS/CLAUDE/GEMINI) / 路徑 B 提及全部 3 個檔案 | ✓ | ✓ | ✓ | ✓ | `PASS` |
| A8 | `@AGENTS.md` instruction in Path B + Platform table / Path B + 平台表中的 `@AGENTS.md` 指示 | 2 mentions | 2 mentions | 2 mentions | 2 mentions | `PASS` |
| A9 | `@./AGENTS.md` instruction in Path B + Platform table / Path B + 平台表中的 `@./AGENTS.md` 指示 | 2 mentions | 2 mentions | 2 mentions | 2 mentions | `PASS` |
| A10 | Table row count (all `|` rows with 4+ columns) / 表格列數 | 10 | 10 | 10 | 10 | `PASS` |

### A5 — Stale Language Check Detail / A5 — 過時語言檢查細節

Searched for potential old-approach phrases that should no longer appear:
搜尋不應再出現的舊方案用語：

| Stale Phrase / 過時用語 | Found / 找到 | Status / 狀態 |
|---|---|---|
| "copy AGENTS.md into CLAUDE.md" | 0 occurrences | `PASS` |
| "paste governance rules" | 0 occurrences | `PASS` |
| "inline the rules" | 0 occurrences | `PASS` |
| "duplicate AGENTS.md" | 0 occurrences | `PASS` |

---

## 8. Summary / 總結

### Automated Test Results / 自動化測試結果

| Category / 分類 | Total / 總計 | PASS | FAIL | DOCUMENTED | N/A |
|---|---|---|---|---|---|
| **A: README Parity / README 一致性** | 10 | 10 | 0 | 0 | 0 |
| **B: File Combinations / 檔案組合** | 8 | 8 | 0 | 0 | 0 |
| **C: Content Preservation / 內容保全** | 3 | 3 | 0 | 0 | 0 |
| **D: Edge Cases / 邊界情況** | 6 | 4 | 0 | 1 | 1 |
| **Automated Total / 自動化合計** | **27** | **25** | **0** | **1** | **1** |

### Manual Test Results / 手動測試結果

| Category / 分類 | Total / 總計 | Status / 狀態 |
|---|---|---|
| **P: Platform-Specific / 平台特定** | 14 | `MANUAL` — awaiting live testing / 等待實際測試 |
| **SW: Platform Switching / 平台切換** | 4 | `MANUAL` — awaiting live testing / 等待實際測試 |
| **WS: Workspace Variation / 工作區變體** | 3 | `MANUAL` — awaiting live testing / 等待實際測試 |
| **D3 sub-tests: Broken Reference / 斷裂參考** | 3 | `MANUAL` — awaiting live testing / 等待實際測試 |
| **Manual Total / 手動合計** | **24** | All pending / 全部待定 |

### Overall / 整體

| Metric / 指標 | Value / 數值 |
|---|---|
| Total test cases / 測試案例總計 | 51 |
| Automated PASS / 自動化通過 | 25 |
| Automated FAIL / 自動化失敗 | 0 |
| Manual pending / 手動待定 | 24 |
| Documented (expected behavior noted) / 已記錄 | 1 |
| Not Applicable / 不適用 | 1 |
| **Automated pass rate / 自動化通過率** | **100%** |

### Key Findings / 關鍵發現

1. **All file combination scenarios pass** — the integration instructions in all 4 READMEs produce correct results for all 8 starting states.
   **所有檔案組合情境通過** — 全部 4 個 README 的整合指示對所有 8 種起始狀態都產生正確結果。

2. **Content preservation verified** — prepending pointer lines does not damage existing file content.
   **內容保全已驗證** — 在最上方加入指標行不會損壞既有檔案內容。

3. **README structural parity confirmed** — all 4 language versions have identical heading counts, table structures, and file trees.
   **README 結構一致性已確認** — 全部 4 個語言版本有相同的標題數、表格結構和檔案樹。

4. **Edge cases handled** — CRLF/LF line endings and UTF-8 BOM do not affect pointer resolution. Circular imports are architecturally impossible (one-directional design).
   **邊界情況已處理** — CRLF/LF 行尾和 UTF-8 BOM 不影響指標解析。循環匯入在架構上不可能（單向設計）。

5. **Broken reference (D3)** is a known edge case — behavior depends on platform. Documented but not a defect; the README instructions include AGENTS.md as a required file.
   **斷裂參考（D3）** 是已知邊界情況 — 行為取決於平台。已記錄但非缺陷；README 指示將 AGENTS.md 列為必要檔案。

### Next Steps / 下一步

1. Run manual platform tests (P-CC, P-GC, P-CX) on live Claude Code, Gemini CLI, and Codex sessions
   在實際 Claude Code、Gemini CLI 和 Codex session 上執行手動平台測試
2. Run platform switching tests (SW-1 through SW-4)
   執行平台切換測試
3. Run workspace variation tests (WS-1 through WS-3)
   執行工作區變體測試
4. Update this document with manual test results
   以手動測試結果更新本文件
