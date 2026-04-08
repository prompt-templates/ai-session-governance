[English](README.md) | 繁體中文 | [简体中文](README.zh-CN.md) | [日本語](README.ja.md)

# :rocket: 支援跨 AI 工具交接的開發治理範本

當 Codex、Claude 或 Gemini 的配額用盡，把交接區塊貼到下一個工具，它就能從同樣的狀態繼續，不用重新說明。

- 跨命令列工具交接
- 統一工作流程：`PLAN -> READ -> CHANGE -> QC -> PERSIST`
- 防止治理規則漂移，而不是一直疊加新規則

**[30 秒快速開始](#quickstart)** · **[安裝](#install)** · **[升級](#upgrade)** · **[快速操作](#quick-operations)**

![Overview](ref_doc/overview_infograph_tw.png)

> **初次接觸？** 請看 **[互動式介紹頁面](https://prompt-templates.github.io/ai-session-governance/?lang=tw)** — 以視覺化方式了解本範本的功能與設計理念。


---

## :bookmark_tabs: 為什麼要做這個

用多個 AI 工具開發時，最先壞掉的通常是交接，不是生成品質。

常見失敗模式：
- 每次切換工具都要重頭說明
- 修復疊在修復上，規則越來越亂
- 說明文件、交接文件、工作日誌慢慢對不上

本範本規定：
1. 每個工作階段只有一條重入路徑
2. 每項任務走同一套工作流程
3. 每次收尾前必須留下可追溯的記錄

---

## :bookmark_tabs: 內建防護機制

也涵蓋幾個常見的 AI 失誤：

| 防護機制 | 防止什麼 |
|---|---|
| **外部 API 代碼安全（§0b）** | 根據訓練記憶臆測端點 / 參數 / Schema 並直接寫入 API 呼叫代碼 |
| **代碼庫上下文快照** | 每次工作階段切換後 AI 重新從零摸索技術棧、外部服務與關鍵決策 |
| **測試計劃治理（§3d）** | 合併變更時未記錄情景矩陣 — 預期結果與實際結果未被追蹤 |
| **整合紀律（§3b）** | 持續疊加規則，卻未先確認既有規則是否已涵蓋或應更新 |
| **文件同步登錄表** | 變更後猜測要更新哪些文件 — `DOC_SYNC_CHECKLIST.md` 將變更類別對應到必要更新項，AI 查表而非自行判斷 |
| **工作日誌自動維護** | 工作日誌隨時間增長到數千行，佔用 AI 每次啟動的 context — 當 `SESSION_LOG.md` 超過 400 行或有超過 30 天的舊記錄時，自動歸檔到 `dev/archive/`；無需手動遷移 |

### :small_blue_diamond: SESSION_LOG.md 怎麼保持精簡

`dev/SESSION_LOG.md` 在每次工作階段啟動時都會被讀取。在活躍的專案中，這個檔案可能增長到數千行——把幾個月前已無關的歷史記錄全部載入 AI 的 context。

本範本在每次工作階段收尾時自動處理：

- 當日誌超過 **400 行**或含有超過 **30 天**的舊記錄時，舊 entries 會被移到 `dev/archive/`——不刪除，只搬移
- 主動日誌縮回最近 7–10 個工作階段（≤ 200 行）
- 歸檔文件按季度整理：`dev/archive/SESSION_LOG_YYYY_QN.md`
- AI 啟動時只讀 `SESSION_LOG.md`，歸檔文件不會被載入

若你已有一個龐大的工作日誌，在升級後第一次工作階段收尾時會自動整理，不需要手動操作。

---

## :bookmark_tabs: 近期版本

| 版本 | 變更內容 | 對你的意義 |
|---|---|---|
| **v2.4** | AI 在 PLAN 階段進行風險分級 — 高風險任務（≥3 檔案、範圍不明、破壞性操作、外部系統）暫停等用戶確認才繼續；工作日誌改用精簡格式（每筆記錄縮小約 60%）；歸檔門檻從 800 行降至 400 行（目標 ≤ 200），基於 "lost in the middle" 研究顯示中段內容準確率下降 30%+ | 誤解任務在改 code 之前被攔截；AI 啟動更快；相同空間容納更多歷史 |
| **v2.3** | 七項系統性審計修正：AI 在動手前先展示對任務的理解（PLAN 顯示）、用戶指令與治理規則衝突時明確指出、執行中發現假設錯誤時停下回報、簡單問題不再強制四段式輸出 | 減少任務誤解、覆蓋操作可追溯、錯誤假設造成的白做大幅減少 |
| **v2.2** | Session log 不再無限增長 — 當 `SESSION_LOG.md` 超過 400 行或有超過 30 天的舊記錄時，舊記錄會自動移至 `dev/archive/`；活躍日誌保留最近 5–6 個工作階段 | 長期專案保持精簡，無需手動清理；幾個月前的歷史記錄不再佔用 AI 的啟動情境 |
| **v2.1** | 兩項可靠性修正：(1) 收到交接時，新的 AI 工具現在有更明確的指示，要求在開始工作前先讀取治理規則；(2) 做完任何修改後，AI 必須在回覆中顯示它更新了哪些文件 — 看不到這個區塊就代表該步驟被跳過 | 切換 AI 工具時交接更穩定；文件更新是否有做，在 AI 的回覆中一目了然，不再靜默略過 |
| **v2.0** | `DOC_SYNC_CHECKLIST.md` — 確定性文件同步登錄表，將變更類別對應到必須更新的文件；`AGENTS.md` 加入章節標記（MANDATORY / CONDITIONAL / REFERENCE） | 消除文件同步猜測：AI 查表決定要更新什麼，而非自行判斷 |
| **v1.9.0** | 六項治理修正：§1 三觸發新工作階段定義、§3 PERSIST 顯式跨文件同步、§4 Open Priorities 再生機制（replace not append）、§4 max-3 說明、§10 Known Risks 記錄位置、§5.7 修改操作精確化 | 修正從實際應用中發現的 AI 行為缺口 — 過期清單、遺漏文件同步、範圍歧義 |
| **v1.8.0** | §1 新增 context compaction 恢復規則 — AI 在壓縮後必須重新執行啟動序列，不可信任 summary 的待辦清單 | 防止 Claude Code 自動壓縮情境後，AI 靜默沿用過時的 pending tasks |
| **v1.7.0** | 交接 Prompt 首段新增明確指示：先讀 `AGENTS.md`，再依 §1 序列執行 | 接收工具就算不自動載入治理檔案，交接也能正常銜接 |
| **v1.6.0** | 安裝後自動輸出 Quick Start 指令；`CODEBASE_CONTEXT.md` 生成前先備份，並擴大掃描來源 | 安裝完直接有指令可用；首次情境擷取更完整 |

---

<a id="quickstart"></a>

## :bookmark_tabs: 30 秒快速開始

1. 開啟 **[INIT.md](INIT.md)**，並貼到你的 AI 命令列工具中。
2. 依提示精確回覆：
   - `INSTALL_ROOT_OK: <absolute_path>`
   - `INSTALL_WRITE_OK`
3. 之後每次新工作階段開始時，輸入：

```text
請依 AGENTS.md 開始本次工作階段
```

---

<a id="install"></a>

## :bookmark_tabs: 安裝

1. 開啟 **[INIT.md](INIT.md)** -> 點擊 **Raw** -> 全選 -> 複製
2. 貼到你的 AI 命令列工具（Claude Code、Codex、Gemini CLI 皆可）
3. AI 會先執行根目錄安全預檢，並依序顯示路徑：`pwd`、`git root`
4. 若 `pwd` 與 `git root` 不一致，AI 必須先停止，並要求你選擇根目錄（1：使用 `pwd`，2：使用 `git root`）；AI 不可自行決定
5. AI 會針對你選擇的根目錄顯示風險檢查與演練規劃（`create` / `merge` / `skip`），此時仍不會寫入檔案
6. 出現提示後，請回覆以下確認句：
   - `INSTALL_ROOT_OK: <absolute_path>`
   - `INSTALL_WRITE_OK`
7. 在首次寫入前，AI 會於 `<PROJECT_ROOT>/dev/init_backup/<UTC_TIMESTAMP>/` 自動建立輕量備份快照，保存既有治理目標檔案
8. AI 會在你確認的專案根目錄中建立或合併治理檔案
9. AI 自動輸出 **Quick Start** 區塊，含可直接複製貼上的操作指令 — 無須另行記憶

### :small_blue_diamond: 安裝流程畫面

<table>
  <tr>
    <td align="center" width="50%">
      <img src="ref_doc/install_step_1.png" alt="安裝流程步驟 1" width="92%" />
      <br />
      <sub>步驟 1：將 `INIT.md` 貼到 AI 命令列工具</sub>
    </td>
    <td align="center" width="50%">
      <img src="ref_doc/install_step_2.png" alt="安裝流程步驟 2" width="92%" />
      <br />
      <sub>步驟 2：確認偵測到的根目錄</sub>
    </td>
  </tr>
  <tr>
    <td align="center" width="50%">
      <img src="ref_doc/install_step_3.png" alt="安裝流程步驟 3" width="92%" />
      <br />
      <sub>步驟 3：回覆 `INSTALL_ROOT_OK`</sub>
    </td>
    <td align="center" width="50%">
      <img src="ref_doc/install_step_4.png" alt="安裝流程步驟 4" width="92%" />
      <br />
      <sub>步驟 4：回覆 `INSTALL_WRITE_OK`</sub>
    </td>
  </tr>
</table>

完成步驟 4 確認後，AI 在寫入任何檔案前會先建立備份。

### :small_blue_diamond: 實際執行畫面

<table>
  <tr>
    <td align="center" width="50%">
      <img src="ref_doc/launch.png" alt="啟動畫面" width="92%" />
      <br />
      <sub>啟動：工作階段開機與上下文載入</sub>
    </td>
    <td align="center" width="50%">
      <img src="ref_doc/closesession.png" alt="完工收尾畫面" width="92%" />
      <br />
      <sub>收尾：工作階段摘要與交接輸出</sub>
    </td>
  </tr>
</table>

AI 自動處理並合併既有的 `AGENTS.md`、`CLAUDE.md`、`GEMINI.md`。
大多數情況下，直接使用 `INIT.md` 就夠了。
不要手動複製整個儲存庫，用 `INIT.md` 安裝才能安全合併。

**已安裝並想升級？** 同樣執行 `INIT.md` — 詳見下方[從舊版升級](#upgrade)。

---

<a id="upgrade"></a>

## :bookmark_tabs: 從舊版升級

重新執行最新版 `INIT.md`，步驟與初次安裝完全相同。

1. 開啟 **[INIT.md](INIT.md)** → 點擊 **Raw** → 全選 → 複製
2. 貼到你的 AI 命令列工具（Claude Code、Codex、Gemini CLI 皆可）
3. 依序確認：`INSTALL_ROOT_OK: <absolute_path>`，再回覆 `INSTALL_WRITE_OK`
4. AI 先備份既有文件，再將治理章節合併至最新版本

**升級時 AI 的動作：**
- 現有 `AGENTS.md`、`CLAUDE.md`、`GEMINI.md` → **merge**（治理章節更新至最新，你的自定內容保留）
- `dev/DOC_SYNC_CHECKLIST.md` → **merge**（專案自訂列保留，缺少的通用列自動補上）
- `dev/SESSION_HANDOFF.md`、`dev/SESSION_LOG.md` → **skip**（工作階段記錄絕對不動）
- 安裝步驟 5 顯示的 dry-run 計劃會在寫入前確認各文件為 `merge` / `skip`

適用任何已安裝版本。

---

<a id="quick-operations"></a>

## :bookmark_tabs: 快速操作

以下句子可直接複製貼上。

### :small_blue_diamond: 1) 開始新工作階段

```text
請依 AGENTS.md 開始本次工作階段
```

### :small_blue_diamond: 2) 收尾並完成完整交接

```text
請為本次工作階段完成收尾與完整交接。
```

### :small_blue_diamond: 3) 快速開始下一個工作階段

```text
<請貼上上一輪輸出的「NEXT SESSION HANDOFF PROMPT (COPY/PASTE)」區塊（原文不改）。>
```

---

## :bookmark_tabs: 配額切換交接流程

1. 在命令列工具 A 的配額即將耗盡前，先完成本次收尾
2. 複製 `NEXT SESSION HANDOFF PROMPT (COPY/PASTE)` 區塊
3. 在命令列工具 B 原文貼上，不要改動內容
4. 工具 B 會依 `SESSION_HANDOFF.md` 與 `SESSION_LOG.md` 接續執行

這是本儲存庫的核心設計目標。

---

## :bookmark_tabs: 平台設定

`AGENTS.md` 為單一真實來源（SSOT）；`CLAUDE.md` 與 `GEMINI.md` 為薄型指標檔。

| 平台 | 原生檔案 | 預設提供 | 若你已有該檔案 |
|---|---|---|---|
| **Codex** | `AGENTS.md` | `AGENTS.md`（完整規則） | 將治理章節合併到既有檔案 |
| **Claude Code** | `CLAUDE.md` | 指標檔：`@AGENTS.md` | 在既有 `CLAUDE.md` **最上方**加入 `@AGENTS.md` |
| **Gemini CLI** | `GEMINI.md` | 指標檔：`@./AGENTS.md` | 在既有 `GEMINI.md` **最上方**加入 `@./AGENTS.md` |

---

## :bookmark_tabs: 3 種情境

### :small_blue_diamond: 情境 1 — 一個 AI 工具用盡配額，切換另一個工具續做
當你在某個命令列工具用盡配額時，可能需要立即切換到另一個工具。  
本範本可保留基線、待辦、風險與驗證狀態，避免重述上下文。

### :small_blue_diamond: 情境 2 — 一個儲存庫，多個 AI 工具協作
例如由 Codex 撰寫程式碼、Claude 處理文件、Gemini 協助除錯基礎設施。  
透過共用交接文件與工作日誌，可避免各工具對專案狀態產生分歧。

### :small_blue_diamond: 情境 3 — 長期專案治理開始漂移
修復逐步累積、規則持續擴張、文件彼此矛盾。  
「先整合、後新增」可降低 SOP 膨脹與長期維護成本。

---

## :bookmark_tabs: 常見問題

視覺化常見問題解答請見 **[互動式介紹頁面](https://prompt-templates.github.io/ai-session-governance/?lang=tw)**。

### :small_blue_diamond: 1) 這只適合大型專案嗎？
不是。小型專案馬上就有效果；大型專案時間拉長效益更明顯。

### :small_blue_diamond: 2) 第一天就需要 `PROJECT_MASTER_SPEC.md` 嗎？
不用。先用 `AGENTS.md` + `SESSION_HANDOFF.md` + `SESSION_LOG.md` 就夠了。

### :small_blue_diamond: 3) 這是編碼標準嗎？
不是。它規範 AI 怎麼讀、改、驗證、交接——不管你怎麼寫程式。

### :small_blue_diamond: 4) 這會拖慢 AI 嗎？
開始時有一點讀取時間，通常比重複交代情況和修正錯誤省時。

### :small_blue_diamond: 5) 我已經有 README、既有文件與內部規則，仍然適用嗎？
可以。它會跟你現有的合併，不會覆蓋掉。

## :bookmark_tabs: 此儲存庫原始佈局

```text
<PROJECT_ROOT>/
├─ INIT.md
├─ AGENTS.md
├─ CLAUDE.md
├─ GEMINI.md
└─ dev/
   ├─ SESSION_HANDOFF.md
   ├─ SESSION_LOG.md
   ├─ archive/                 # 自動歸檔的舊記錄（按季度）
   ├─ DOC_SYNC_CHECKLIST.md    # 文件同步登錄表
   ├─ CODEBASE_CONTEXT.md      # 首次工作階段自動生成
   └─ PROJECT_MASTER_SPEC.md   # 可選
```

### :small_blue_diamond: 核心檔案

- `INIT.md` - 建立/合併治理檔案的啟動提示（公開入口）
- `AGENTS.md` - 治理單一真實來源（SSOT）
- `CLAUDE.md` - Claude 指標檔
- `GEMINI.md` - Gemini 指標檔
- `dev/SESSION_HANDOFF.md` - 當前基線與下一步優先事項
- `dev/SESSION_LOG.md` - 逐工作階段歷史與驗證結果（rolling window，自動整理）
- `dev/archive/` - 自動歸檔的舊工作日誌，按季度整理；啟動時不讀取
- `dev/DOC_SYNC_CHECKLIST.md` - 文件同步登錄表：將變更類別對應到必須更新的文件
- `dev/CODEBASE_CONTEXT.md` - 技術棧、外部服務、關鍵決策（首次工作階段自動生成）
- `dev/PROJECT_MASTER_SPEC.md` - 可選的長期權威規格

---

## :bookmark_tabs: 本範本背後的治理原則

1. 修改前先閱讀
2. 除錯前先分類
3. 新增前先整合
4. 宣稱完成前先驗證
5. 離開前先持久化

---

## :bookmark_tabs: 驗證紀錄

完整聲明對照與平台驗證請見：
- [docs/VERIFICATION.md](docs/VERIFICATION.md)
- 最新 QA 回歸驗收報告： [docs/qa/LATEST.md](docs/qa/LATEST.md)

截至 2026-04-08 的摘要如下：
- AGENTS/INIT 規則同步：已驗證（169 項回歸測試）
- 多平台指標檔行為：已驗證
- 50+ 工作階段的長期縱向效果：尚未驗證

---

## :bookmark_tabs: 深度文件

若本儲存庫後續擴大，建議補充以下文件：

- `dev/PROJECT_MASTER_SPEC.md` — 完整架構、工作流程、發佈、操作手冊權威
- `docs/OPERATIONS.md` — 面向操作者的使用與維護程序
- `docs/POSITIONING.md` — 本範本的用途、非用途與定位

若上述檔案尚不存在，當前最小需求仍為：

- `AGENTS.md`
- `dev/SESSION_HANDOFF.md`
- `dev/SESSION_LOG.md`

---

## :bookmark_tabs: 設計者

> 由 **[Adam Chan](https://www.facebook.com/chan.adam)** 設計 · [i.adamchan@gmail.com](mailto:i.adamchan@gmail.com)
>
> *Vibe Coding 的時代，人人都能打造屬於自己的 AI 世界。*

---

## :bookmark_tabs: 授權

可自由使用、改編與擴展至你的工作流程中。
若你有改進，歡迎回饋可降低漂移且不增加複雜度的做法。
