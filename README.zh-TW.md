[English](README.md) | 繁體中文 | [简体中文](README.zh-CN.md) | [日本語](README.ja.md)

# 別再每次開新 session 都重覆交代一遍

一個輕量級的 AI 輔助開發治理範本，讓專案在 Codex、Claude Code、Gemini CLI 等 agent 工作流中保持**可接續、可除錯、可追溯、更有條理**。

**[安裝](#安裝)** · **[快速開始](#安裝)**

![Overview](ref_doc/overview_infograph.png)

---

## 為什麼這很重要

如果 AI 正在協助寫程式、除錯、重構、發佈、或更新文件，真正的問題通常不是「模型太弱」。

真正的問題是專案**沒有持久的操作記憶**。

那就是團隊開始反覆遇到同樣失敗模式的時候：

### 痛點 1 — 每次新 session 都從零開始
Agent 不知道當前基線是什麼、哪些已修好、哪些還沒做、哪些絕不能再碰。

### 痛點 2 — 修復一直疊在舊修復上面
每次 session 多加一個 patch、一條備註、一個例外、一條規則——直到專案變得更難改而不是更容易。

### 痛點 3 — Bug 在局部修好了，治理卻在全局惡化
程式碼可能能編譯，但 repo 在漂移：
- README 說一套
- handoff 說另一套
- log 說第三套
- 沒人知道哪個版本才是真的

### 這個範本帶來什麼

#### 1) 接續性
每次新 session 都有強制入口路徑：
- 讀 handoff
- 讀 log
- 從最後一次驗證過的狀態繼續

#### 2) 控制力
Agent 必須按照以下流程工作：
**PLAN → READ → CHANGE → QC → PERSIST**

意味著更少衝動修改、更好的可追溯性、更安全的變更。

#### 3) 防混亂護欄
這個範本不只防止魯莽修改。
它還透過強制 agent 自我檢查來防止**治理膨脹**：

- 這真的是一條新規則嗎？
- 還是應該更新舊規則？
- 這是一個修復？
- 還是應該做一次整合 pass？

---

## 安裝

1. 開啟 **[INIT.md](INIT.md)** → 點擊 **Raw** → 全選 → 複製
2. 貼給你的 AI agent（Claude Code、Codex、Gemini CLI — 任一皆可）
3. AI 直接在你的專案中建立所有 5 個治理檔案

不需要下載、不需要 script、不需要指令列。AI 處理一切，包括若你已有 `AGENTS.md`、`CLAUDE.md` 或 `GEMINI.md` 時的智能合併。
對大多數公開使用者而言，直接使用 `INIT.md` 就足夠。
不要把整個 repo 手動複製到專案根目錄；請使用 `INIT.md` 讓 agent 安全合併。

然後每次 AI session 開頭使用：

```text
Follow AGENTS.md.
```

---

## 平台設定

`AGENTS.md` 是唯一的真實來源（SSOT）。本範本附帶薄型指標檔（`CLAUDE.md` 和 `GEMINI.md`），讓每個平台都能從同一來源自動發現治理規則。

| 平台 | 原生檔案 | 範本提供的內容 | 若你已有該檔案 |
|---|---|---|---|
| **Codex** | `AGENTS.md` | `AGENTS.md`（完整規則） | 將治理章節合併到既有檔案 |
| **Claude Code** | `CLAUDE.md` | 指標檔：`@AGENTS.md` | 在既有 `CLAUDE.md` **最上方**加入 `@AGENTS.md` |
| **Gemini CLI** | `GEMINI.md` | 指標檔：`@./AGENTS.md` | 在既有 `GEMINI.md` **最上方**加入 `@./AGENTS.md` |

一旦 agent 能讀取指令，治理規則、工作流和 dev/ 範本在所有平台上的運作完全一致。

---

## 這個範本有什麼不同

大多數 AI 編碼 prompt 著重於：
- 語氣
- 格式
- 編碼風格
- 工具使用

這個範本著重的是對長期工作更重要的事情：

### 1) Session 接續性
下一次 session 不應依賴使用者記憶。

### 2) 層級分離
Agent 不得混淆：
- 產品行為
- 開發治理
- 外部平台行為
- 環境 / 執行時期問題

### 3) 修改前先閱讀
不允許「看一個片段、改一個片段」的工作方式。

### 4) 新增前先整合
不允許無止盡地堆疊新規則和例外。

### 5) 正確地結束 session
Agent 必須在離開前更新 handoff / log。

---

## 3 種情境

### 情境 1 — 每天用 AI 出貨的獨立開發者
日常進度很快，但 session 之間的上下文會斷。
這個範本為每次 session 提供穩定的重新進入點，減少重覆解釋。
它還防止「小修復」演變成長期治理混亂。
適合產品開發者、獨立創業者和技術創辦人。

### 情境 2 — 一個 repo，多個 AI agent
Codex 處理程式碼、Claude 審查文件、Gemini 協助除錯基礎設施。
沒有共同的 handoff 和 session log，每個 agent 從不同的現實出發。
這個範本建立共享操作記憶和一致的 session ID 標準。
適合多 agent 工作流。

### 情境 3 — 既有專案已經感覺很亂
Repo 能運作，但每次修復都讓規則更長、文件更嘈雜、發佈更危險。
這個範本加入防堆積紀律：先搜尋、先整合、退役過時規則。
它的設計是減少治理漂移，而不只是增加更多治理。
適合需要清理但不需要全面重寫的長期 repo。

---

## 常見問題

### 1) 這只適合大型專案嗎？
不是。
小型專案立即受益於 session 接續性。
大型專案受益更多，因為漂移隨時間複合加速。

### 2) 第一天就需要 `PROJECT_MASTER_SPEC.md` 嗎？
不一定。
小型 repo 用 `AGENTS.md` + `SESSION_HANDOFF.md` + `SESSION_LOG.md` 就足夠。
當規則、發佈標準或工作流變得太大而無法非正式管理時，再加入 master spec。

### 3) 這是編碼標準嗎？
主要不是。
這是 AI 在 repo 內工作方式的**治理標準**：
- 如何閱讀
- 如何修改
- 如何驗證
- 如何交接

### 4) 為什麼不把所有東西放在一個大 prompt 裡？
因為大型 prompt 會衰退。
它們更難更新、更難信任、下一次 session 也更難一致地應用。
這個範本將穩定的治理規則與每次 session 的狀態分開。

### 5) 這會拖慢 agent 嗎？
每次 session 開頭會稍微慢一點。
通常遠少於因重覆解釋、誤診、重複修復和過時文件而浪費的時間。
重點是減少總返工量，而不是優化單次快但健忘的回合。

### 6) 「新增前先整合」解決什麼問題？
防止治理膨脹。
沒有這條規則，每個修復都變成額外備註、每個事件都變成額外 SOP、每次 session 都留下更多雜亂。
這個範本強制 agent 思考規則應該被合併，而不僅是新增。

### 7) 什麼時候一個問題應該變成永久規則？
只有當它是重複發生的、高影響的、阻斷發佈的、有風險的、或系統性的。
如果問題小且局部，修正根因、加入迴歸、更新 log，然後繼續。
不是每個錯誤都值得立一條新法。

### 8) 這對除錯有幫助，還是只對文件有用？
兩者都有。
它透過強制先做問題分類來改善除錯：
- 程式碼問題？
- 配置問題？
- 執行時期問題？
- 外部平台問題？
- 過時文件？
這減少了「修錯方向」的除錯。

### 9) 如果我的專案已經有 README、docs 和內部規則呢？
保留它們。
這個範本旨在與既有專案資料整合，而不是盲目取代有用的內容。
唯一的硬性要求是：可靠的入口路徑和持久的 session 紀錄。

### 10) 這個範本旨在防止的最大錯誤是什麼？
那個安靜的錯誤：
一個仍然「能運作」的專案，但在每次 AI session 之後變得更難理解、更難修改、更難信任。
這個範本的存在就是為了儘早阻止那種緩慢的退化。

---

## 此 repo 原始佈局

```text
<PROJECT_ROOT>/
├─ INIT.md                ← bootstrap prompt（公開入口）
├─ AGENTS.md              ← 治理規則（SSOT）
├─ CLAUDE.md              ← Claude Code 指標檔
├─ GEMINI.md              ← Gemini CLI 指標檔
└─ dev/
   ├─ SESSION_HANDOFF.md
   ├─ SESSION_LOG.md
   └─ PROJECT_MASTER_SPEC.md   # 可選
```

### 核心檔案

* `INIT.md` — 會在你的專案中建立/合併治理檔案的 bootstrap prompt（大多數使用者的主要入口）
* `AGENTS.md` — repo 中 AI 工作的常規操作規則（唯一真實來源）
* `CLAUDE.md` — 將 Claude Code 自動發現橋接到 `AGENTS.md` 的指標檔
* `GEMINI.md` — 將 Gemini CLI 自動發現橋接到 `AGENTS.md` 的指標檔
* `dev/SESSION_HANDOFF.md` — 當前基線、阻斷點、啟動檢查清單、最後驗證狀態
* `dev/SESSION_LOG.md` — 逐 session 的歷史、修復、驗證、下一步優先事項
* `dev/PROJECT_MASTER_SPEC.md` — 為較大型或更複雜專案提供的可選長期權威規格

---

## 本範本背後的治理原則

這個 repo 圍繞幾個不可妥協的原則建立：

1. **修改前先閱讀**
2. **除錯前先分類**
3. **新增前先整合**
4. **宣稱完成前先驗證**
5. **離開前先持久化**

在 session 收尾時，agent 必須輸出可直接複製貼上的交接指令，且內容必須依當前真實狀態動態生成（不可使用固定句）。

如果這五條成立，AI session 隨時間仍然可用。

---

## 驗證紀錄

發佈前，本 README 的每項聲明均已與實際的 AGENTS.md 規則和 dev/ 範本交叉核對，並依據各平台官方文件進行驗證（截至 2026 年 2 月）。

### 聲明與機制對照

| README 聲明 | 支撐依據 | 已驗證 |
|---|---|---|
| Session 接續性 | AGENTS.md §1 單一入口、§4 Session 收尾、SESSION_HANDOFF.md、SESSION_LOG.md | 是 |
| PLAN → READ → CHANGE → QC → PERSIST | AGENTS.md §3 標準工作流 | 是 |
| 防治理膨脹 | AGENTS.md §3b 整合紀律、§8b 規則升格門檻 | 是 |
| 層級分離 | AGENTS.md §0a — 4 條硬規則 | 是 |
| 修改前先閱讀 | AGENTS.md §2c — 4 項最低讀取、3 條硬規則 | 是 |
| 除錯前先分類 | AGENTS.md §2b — 6 種分類、3 條硬規則 | 是 |
| 多 Agent Session ID | AGENTS.md §12 — 格式標準與範例 | 是 |
| 檔案安全治理 | AGENTS.md §5 — 8 項禁令、§6 — 禁止提權 + 手動回退 | 是 |
| 與既有專案整合 | AGENTS.md 第 2 行 — 明確的合併/保留指示 | 是 |

### 平台相容性驗證

| 平台 | 讀取治理檔案 | Session 持久化 | 結構化工作流 | 來源 |
|---|---|---|---|---|
| Codex | `AGENTS.md` 原生 | 客戶端 session + resume | AGENTS.md 指令 + Agents SDK | [OpenAI Codex Docs](https://developers.openai.com/codex/) |
| Claude Code | `CLAUDE.md` 原生；`AGENTS.md` 透過 `@` 匯入 | 自動記憶 + session resume | Plan Mode + skills | [Claude Code Docs](https://code.claude.com/docs/en/overview) |
| Gemini CLI | `GEMINI.md` 原生；`AGENTS.md` 透過設定 | `/memory` + session save/resume | Skills + GEMINI.md 指令 | [Gemini CLI Docs](https://google-gemini.github.io/gemini-cli/) |

### 尚未驗證事項

- 跨 50+ session 的長期有效性（尚無縱向資料）
- 不同模型世代的遵循率（治理基於指令，非技術強制）
- 每次 session 開頭讀取 handoff + log 的效能影響（預期輕微但未做基準測試）

本驗證於 2026-02-27 依據各平台官方文件完成。

---

## 深度文件

如果本 repo 後續成長，建議的深度文件為：

* `dev/PROJECT_MASTER_SPEC.md` — 完整架構、工作流、發佈、runbook 權威
* `docs/OPERATIONS.md` — 面向操作者的使用與維護程序
* `docs/POSITIONING.md` — 本範本的用途、非用途、以及定位

如果這些檔案尚不存在，當前的最小需求仍為：

* `AGENTS.md`
* `dev/SESSION_HANDOFF.md`
* `dev/SESSION_LOG.md`

---

## 適用對象

這個範本最適合以下人群：

* 每週都用 AI 寫程式
* 在多個模型或 agent 工具之間切換
* 長期維護 repo，不只是一次性腳本
* 想減少重覆解釋
* 重視持久的、可追溯的進度

如果這聽起來很熟悉，這個範本旨在成為一個實用的起點。

---

## 授權

可自由使用、改編和擴展到你的工作流中。
如果你改進了它，歡迎回饋能減少漂移而不增加複雜度的模式。
