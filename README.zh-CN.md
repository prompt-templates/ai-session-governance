[English](README.md) | [繁體中文](README.zh-TW.md) | 简体中文 | [日本語](README.ja.md)

# 别再每次开新 session 都重复交代一遍

一个轻量级的 AI 辅助开发治理模板，让项目在 Codex、Claude Code、Gemini CLI 等 agent 工作流中保持**可接续、可调试、可追溯、更有条理**。

**[安装](#安装)** · **[快速开始](#安装)**

![Overview](ref_doc/overview_infograph.png)

---

## 为什么这很重要

如果 AI 正在协助写代码、调试、重构、发布、或更新文档，真正的问题通常不是"模型太弱"。

真正的问题是项目**没有持久的操作记忆**。

那就是团队开始反复遇到同样失败模式的时候：

### 痛点 1 — 每次新 session 都从零开始
Agent 不知道当前基线是什么、哪些已修好、哪些还没做、哪些绝不能再碰。

### 痛点 2 — 修复一直叠在旧修复上面
每次 session 多加一个 patch、一条备注、一个例外、一条规则——直到项目变得更难改而不是更容易。

### 痛点 3 — Bug 在局部修好了，治理却在全局恶化
代码可能能编译，但 repo 在漂移：
- README 说一套
- handoff 说另一套
- log 说第三套
- 没人知道哪个版本才是真的

### 这个模板带来什么

#### 1) 接续性
每次新 session 都有强制入口路径：
- 读 handoff
- 读 log
- 从最后一次验证过的状态继续

#### 2) 控制力
Agent 必须按照以下流程工作：
**PLAN → READ → CHANGE → QC → PERSIST**

意味着更少冲动修改、更好的可追溯性、更安全的变更。

#### 3) 防混乱护栏
这个模板不只防止鲁莽修改。
它还通过强制 agent 自我检查来防止**治理膨胀**：

- 这真的是一条新规则吗？
- 还是应该更新旧规则？
- 这是一个修复？
- 还是应该做一次整合 pass？

---

## 安装

1. 打开 **[INIT.md](INIT.md)** → 点击 **Raw** → 全选 → 复制
2. 粘贴给你的 AI agent（Claude Code、Codex、Gemini CLI — 任一皆可）
3. AI 直接在你的项目中创建所有 5 个治理文件

不需要下载、不需要脚本、不需要命令行。AI 处理一切，包括若你已有 `AGENTS.md`、`CLAUDE.md` 或 `GEMINI.md` 时的智能合并。

然后每次 AI session 开头使用：

```text
Follow AGENTS.md.
```

---

## 平台设置

`AGENTS.md` 是唯一的真实来源（SSOT）。本模板附带薄型指针文件（`CLAUDE.md` 和 `GEMINI.md`），让每个平台都能从同一来源自动发现治理规则。

| 平台 | 原生文件 | 模板提供的内容 | 若你已有该文件 |
|---|---|---|---|
| **Codex** | `AGENTS.md` | `AGENTS.md`（完整规则） | 将治理章节合并到已有文件 |
| **Claude Code** | `CLAUDE.md` | 指针文件：`@AGENTS.md` | 在已有 `CLAUDE.md` **最上方**加入 `@AGENTS.md` |
| **Gemini CLI** | `GEMINI.md` | 指针文件：`@./AGENTS.md` | 在已有 `GEMINI.md` **最上方**加入 `@./AGENTS.md` |

一旦 agent 能读取指令，治理规则、工作流和 dev/ 模板在所有平台上的运作完全一致。

---

## 这个模板有什么不同

大多数 AI 编码 prompt 着重于：
- 语气
- 格式
- 编码风格
- 工具使用

这个模板着重的是对长期工作更重要的事情：

### 1) Session 接续性
下一次 session 不应依赖用户记忆。

### 2) 层级分离
Agent 不得混淆：
- 产品行为
- 开发治理
- 外部平台行为
- 环境 / 运行时问题

### 3) 修改前先阅读
不允许"看一个片段、改一个片段"的工作方式。

### 4) 新增前先整合
不允许无止尽地堆叠新规则和例外。

### 5) 正确地结束 session
Agent 必须在离开前更新 handoff / log。

---

## 3 种场景

### 场景 1 — 每天用 AI 出货的独立开发者
日常进度很快，但 session 之间的上下文会断。
这个模板为每次 session 提供稳定的重新进入点，减少重复解释。
它还防止"小修复"演变成长期治理混乱。
适合产品开发者、独立创业者和技术创始人。

### 场景 2 — 一个 repo，多个 AI agent
Codex 处理代码、Claude 审查文档、Gemini 协助调试基础设施。
没有共同的 handoff 和 session log，每个 agent 从不同的现实出发。
这个模板建立共享操作记忆和一致的 session ID 标准。
适合多 agent 工作流。

### 场景 3 — 已有项目已经感觉很乱
Repo 能运行，但每次修复都让规则更长、文档更嘈杂、发布更危险。
这个模板加入防堆积纪律：先搜索、先整合、退役过时规则。
它的设计是减少治理漂移，而不只是增加更多治理。
适合需要清理但不需要全面重写的长期 repo。

---

## 常见问题

### 1) 这只适合大型项目吗？
不是。
小型项目立即受益于 session 接续性。
大型项目受益更多，因为漂移随时间复合加速。

### 2) 第一天就需要 `PROJECT_MASTER_SPEC.md` 吗？
不一定。
小型 repo 用 `AGENTS.md` + `SESSION_HANDOFF.md` + `SESSION_LOG.md` 就足够。
当规则、发布标准或工作流变得太大而无法非正式管理时，再加入 master spec。

### 3) 这是编码标准吗？
主要不是。
这是 AI 在 repo 内工作方式的**治理标准**：
- 如何阅读
- 如何修改
- 如何验证
- 如何交接

### 4) 为什么不把所有东西放在一个大 prompt 里？
因为大型 prompt 会衰退。
它们更难更新、更难信任、下一次 session 也更难一致地应用。
这个模板将稳定的治理规则与每次 session 的状态分开。

### 5) 这会拖慢 agent 吗？
每次 session 开头会稍微慢一点。
通常远少于因重复解释、误诊、重复修复和过时文档而浪费的时间。
重点是减少总返工量，而不是优化单次快但健忘的回合。

### 6) "新增前先整合"解决什么问题？
防止治理膨胀。
没有这条规则，每个修复都变成额外备注、每个事件都变成额外 SOP、每次 session 都留下更多杂乱。
这个模板强制 agent 思考规则应该被合并，而不仅是新增。

### 7) 什么时候一个问题应该变成永久规则？
只有当它是重复发生的、高影响的、阻断发布的、有风险的、或系统性的。
如果问题小且局部，修正根因、加入回归、更新 log，然后继续。
不是每个错误都值得立一条新法。

### 8) 这对调试有帮助，还是只对文档有用？
两者都有。
它通过强制先做问题分类来改善调试：
- 代码问题？
- 配置问题？
- 运行时问题？
- 外部平台问题？
- 过时文档？
这减少了"修错方向"的调试。

### 9) 如果我的项目已经有 README、docs 和内部规则呢？
保留它们。
这个模板旨在与已有项目资料整合，而不是盲目取代有用的内容。
唯一的硬性要求是：可靠的入口路径和持久的 session 记录。

### 10) 这个模板旨在防止的最大错误是什么？
那个安静的错误：
一个仍然"能运行"的项目，但在每次 AI session 之后变得更难理解、更难修改、更难信任。
这个模板的存在就是为了尽早阻止那种缓慢的退化。

---

## 文件概览

```text
<PROJECT_ROOT>/
├─ AGENTS.md              ← 治理规则（SSOT）
├─ CLAUDE.md              ← Claude Code 指针文件
├─ GEMINI.md              ← Gemini CLI 指针文件
└─ dev/
   ├─ SESSION_HANDOFF.md
   ├─ SESSION_LOG.md
   └─ PROJECT_MASTER_SPEC.md   # 可选
```

### 核心文件

* `AGENTS.md` — repo 中 AI 工作的常规操作规则（唯一真实来源）
* `CLAUDE.md` — 将 Claude Code 自动发现桥接到 `AGENTS.md` 的指针文件
* `GEMINI.md` — 将 Gemini CLI 自动发现桥接到 `AGENTS.md` 的指针文件
* `dev/SESSION_HANDOFF.md` — 当前基线、阻断点、启动检查清单、最后验证状态
* `dev/SESSION_LOG.md` — 逐 session 的历史、修复、验证、下一步优先事项
* `dev/PROJECT_MASTER_SPEC.md` — 为较大型或更复杂项目提供的可选长期权威规格

---

## 本模板背后的治理原则

这个 repo 围绕几个不可妥协的原则建立：

1. **修改前先阅读**
2. **调试前先分类**
3. **新增前先整合**
4. **宣称完成前先验证**
5. **离开前先持久化**

如果这五条成立，AI session 随时间仍然可用。

---

## 验证记录

发布前，本 README 的每项声明均已与实际的 AGENTS.md 规则和 dev/ 模板交叉核对，并依据各平台官方文档进行验证（截至 2026 年 2 月）。

### 声明与机制对照

| README 声明 | 支撑依据 | 已验证 |
|---|---|---|
| Session 接续性 | AGENTS.md §1 单一入口、§4 Session 收尾、SESSION_HANDOFF.md、SESSION_LOG.md | 是 |
| PLAN → READ → CHANGE → QC → PERSIST | AGENTS.md §3 标准工作流 | 是 |
| 防治理膨胀 | AGENTS.md §3b 整合纪律、§8b 规则升格门槛 | 是 |
| 层级分离 | AGENTS.md §0a — 4 条硬规则 | 是 |
| 修改前先阅读 | AGENTS.md §2c — 4 项最低读取、3 条硬规则 | 是 |
| 调试前先分类 | AGENTS.md §2b — 6 种分类、3 条硬规则 | 是 |
| 多 Agent Session ID | AGENTS.md §12 — 格式标准与示例 | 是 |
| 文件安全治理 | AGENTS.md §5 — 8 项禁令、§6 — 禁止提权 + 手动回退 | 是 |
| 与已有项目整合 | AGENTS.md 第 2 行 — 明确的合并/保留指示 | 是 |

### 平台兼容性验证

| 平台 | 读取治理文件 | Session 持久化 | 结构化工作流 | 来源 |
|---|---|---|---|---|
| Codex | `AGENTS.md` 原生 | 客户端 session + resume | AGENTS.md 指令 + Agents SDK | [OpenAI Codex Docs](https://developers.openai.com/codex/) |
| Claude Code | `CLAUDE.md` 原生；`AGENTS.md` 通过 `@` 导入 | 自动记忆 + session resume | Plan Mode + skills | [Claude Code Docs](https://code.claude.com/docs/en/overview) |
| Gemini CLI | `GEMINI.md` 原生；`AGENTS.md` 通过配置 | `/memory` + session save/resume | Skills + GEMINI.md 指令 | [Gemini CLI Docs](https://google-gemini.github.io/gemini-cli/) |

### 尚未验证事项

- 跨 50+ session 的长期有效性（尚无纵向数据）
- 不同模型世代的遵循率（治理基于指令，非技术强制）
- 每次 session 开头读取 handoff + log 的性能影响（预期轻微但未做基准测试）

本验证于 2026-02-27 依据各平台官方文档完成。

---

## 深度文档

如果本 repo 后续成长，建议的深度文档为：

* `dev/PROJECT_MASTER_SPEC.md` — 完整架构、工作流、发布、runbook 权威
* `docs/OPERATIONS.md` — 面向操作者的使用与维护程序
* `docs/POSITIONING.md` — 本模板的用途、非用途、以及定位

如果这些文件尚不存在，当前的最小需求仍为：

* `AGENTS.md`
* `dev/SESSION_HANDOFF.md`
* `dev/SESSION_LOG.md`

---

## 适用对象

这个模板最适合以下人群：

* 每周都用 AI 写代码
* 在多个模型或 agent 工具之间切换
* 长期维护 repo，不只是一次性脚本
* 想减少重复解释
* 重视持久的、可追溯的进度

如果这听起来很熟悉，这个模板旨在成为一个实用的起点。

---

## 许可

可自由使用、改编和扩展到你的工作流中。
如果你改进了它，欢迎回馈能减少漂移而不增加复杂度的模式。
