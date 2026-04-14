[English](README.md) | [繁體中文](README.zh-TW.md) | [简体中文](README.zh-CN.md) | 日本語

# :rocket: AIツール間の引き継ぎを支える開発ガバナンステンプレート

Codex、Claude、Gemini のトークン配分を使い切ったら、引き継ぎブロックを次のツールに貼り付けるだけ。同じ状態から続けられます。

- 異なるAI CLIツール間で引き継ぎが機能する
- 統一ワークフロー：`PLAN -> READ -> CHANGE -> QC -> PERSIST`
- ルールを増やし続けるのではなく、ガバナンスのドリフトを防ぐ
- セッション継続性に特化した[Harness Engineering](https://martinfowler.com/articles/harness-engineering.html)コンポーネント

**[30秒クイックスタート](#quickstart)** · **[インストール](#install)** · **[アップグレード](#upgrade)** · **[クイック操作](#quick-operations)**

![Overview](ref_doc/overview_infograph_ja.png)

> **初めての方へ** **[インタラクティブな紹介ページ](https://prompt-templates.github.io/ai-session-governance/?lang=ja)** で、このテンプレートの機能と設計思想を視覚的にご覧ください。


---

## :bookmark_tabs: なぜこれが必要か

複数のAIツールを使う開発では、まず壊れるのは引き継ぎで、生成品質ではありません。

よくある失敗パターン：
- ツールを切り替えるたびに最初から説明し直す
- 修正が修正の上に積み重なってルールが煩雑になる
- README・引き継ぎ文書・ログが食い違ってくる

このテンプレートは次の3点を必須にします。
1. セッションごとに単一の再開経路を持つ
2. すべての作業を同じワークフローで進める
3. セッションを閉じる前に追跡可能な記録を残す

---

## :bookmark_tabs: 内蔵セーフガード

よくあるAIの失敗パターンもカバーしています。

| セーフガード | 防止する問題 |
|---|---|
| **PLANリスク評価** | 高リスクタスク（3ファイル以上、スコープ不明、破壊的操作、外部システム）をAIが正しく理解したか確認する前に実行すること — 高リスクプランはユーザー確認まで一時停止 |
| **外部 API コード安全** | 訓練データの記憶からエンドポイント / パラメータ / スキーマを推測して API 呼び出しコードを書くこと |
| **コードベースコンテキストスナップショット** | セッション切り替えのたびに技術スタック・外部サービス・主要決定を再学習すること |
| **テスト計画ガバナンス** | シナリオマトリックスなしで変更をマージすること — 期待結果と実績が未記録になること |
| **統合規律** | 既存ルールを更新すべきか確認せずに規則を積み上げ続けること |
| **文書同期レジストリ** | 変更後にどの文書を更新すべきか推測すること — `DOC_SYNC_CHECKLIST.md` が変更カテゴリと必要更新を対応付け、AIが自己判断せずに参照できる |
| **セッションログ自動メンテナンス** | セッション履歴が数千行に増えてAIの起動コンテキストを圧迫すること — `SESSION_LOG.md` が400行を超えるか、30日以上前のエントリがある場合に `dev/archive/` へ自動アーカイブ；手動移行不要 |
| **QC失敗パス** | AIがテスト失敗をサイレントリトライまたは放棄すること — テストやビルドが失敗した場合、AIは失敗内容を報告し原因を診断し、自動リトライせずユーザーの指示を待つ |
| **クローズアウト誤検知ガード** | 「ありがとう、これで大丈夫です」のような日常表現で完全なセッション終了が誤って発動すること — 表現が曖昧な場合、AIはセッション終了の意図を確認してから実行 |

### :small_blue_diamond: SESSION_LOG.md をコンパクトに保つ仕組み

`dev/SESSION_LOG.md` はセッション開始時に毎回読み込まれます。アクティブなプロジェクトでは、このファイルが数千行に膨らむことがあります——数か月前の今は関係ない履歴をすべてAIのコンテキストに読み込むことになります。

このテンプレートはセッション終了時に自動で処理します：

- ログが **400行を超える**か、**30日以上前**のエントリがある場合、古いエントリを `dev/archive/` へ移動——削除はせず、移動のみ
- アクティブなログは直近 7〜10 セッション（≤ 200 行）まで縮小
- アーカイブファイルは四半期ごとに整理：`dev/archive/SESSION_LOG_YYYY_QN.md`
- AIは起動時に `SESSION_LOG.md` のみ読み込み、アーカイブファイルは読み込まない

すでに大きなセッションログがある場合も、アップグレード後の最初のセッション終了時に自動で整理されます。手動操作は不要です。

---

## :bookmark_tabs: 最近のリリース

| バージョン | 変更内容 | あなたへのメリット |
|---|---|---|
| **v2.5** | コアワークフロールールをAI注意力の高優先ゾーンに再配置（注意力デッドゾーンから移動）；冗長セクションを統合（差引-3行）；3つのワークフローギャップを修正 — テスト失敗時にAIがサイレントリトライせず報告、deviation stop後に再開フェーズを明示、曖昧な表現でセッション終了を誤認しない | コアルールのAI遵守率が向上；メンテナンス負荷軽減；障害・引き継ぎ時のAI動作がより予測可能 |
| **v2.4** | AIがPLAN段階でタスクリスクを評価 — 高リスクタスク（3ファイル以上、スコープ不明、破壊的操作、外部システム）はユーザー確認まで一時停止；セッションログがリーン形式に変更（エントリあたり約60%縮小）；アーカイブ閾値を800行から400行に引き下げ、AI起動時の無関係な履歴読み込みを削減 | タスクの誤解をコード変更前にキャッチ；AI起動の高速化；少ないスペースでより多くの履歴を保持 |
| **v2.3** | 体系的監査による7つの改善：AIがタスク実行前に理解内容を明示（PLANディスプレイ）、ユーザー指示とガバナンスルールの衝突時に明示、実行中に前提が間違っていた場合は停止して報告、簡単な質問に4部構成の回答を強制しなくなった | タスク誤解の減少、オーバーライドの追跡可能化、誤った前提による無駄な作業を大幅削減 |
| **v2.2** | セッションログが無制限に増えなくなった — `SESSION_LOG.md` が 400 行を超えるか、30 日以上前のエントリがある場合、古いエントリは自動的に `dev/archive/` へ移動；アクティブなログは最新 7〜10 セッションを保持 | 長期プロジェクトでも手動クリーンアップ不要でスリムを保てる；古い履歴が AI の起動コンテキストを消費しなくなる |
| **v2.1** | 2つの信頼性改善：(1) 引き継ぎを受けた新しいAIツールが、作業開始前にガバナンスルールを読むよう、より明確に指示するように；(2) 変更後、AIは更新したドキュメントをレスポンスに必ず表示 — そのブロックが見当たらない場合はスキップされたことを意味する | AIツール切り替え時の引き継ぎが安定する；ドキュメント更新の有無がレスポンスから確認でき、サイレントスキップがなくなる |
| **v2.0** | `DOC_SYNC_CHECKLIST.md` — 変更カテゴリと必要な文書更新を対応付ける確定的ドキュメント同期レジストリ；`AGENTS.md` にセクションマーカー追加（MANDATORY / CONDITIONAL / REFERENCE） | 文書同期の推測をなくす：AIが自己判断せずレジストリを参照して更新対象を決定 |
| **v1.9.0** | 6つのガバナンス修正：新セッションの3つのトリガー条件、クローズ時の強制クロスドキュメント同期、優先事項リストの毎回再生成（累積ではなく置換）、変更操作の精確化 | 実際の運用で発見されたAIの行動ギャップを修正 — 古い優先リスト・文書同期漏れ・スコープの曖昧さ |
| **v1.8.0** | コンテキスト圧縮リカバリルールを追加 — 圧縮後はAIが起動シーケンスを再実行し、圧縮サマリーのpending tasksを信頼しない | Claude Codeがセッション途中で自動圧縮した後、AIが古いタスクをそのまま実行するのを防ぐ |
| **v1.7.0** | 引き継ぎPromptの冒頭に明示的な指示を追加：まず `AGENTS.md` を読み、起動シーケンスに従う | 受信ツールがガバナンスファイルを自動ロードしなくても引き継ぎが機能する |
| **v1.6.0** | インストール後にQuick Startブロックを自動出力；`CODEBASE_CONTEXT.md`生成前にバックアップ、スキャン対象を拡大 | インストール直後にコマンドが使える；初回コンテキスト取得がより完全になる |

---

<a id="quickstart"></a>

## :bookmark_tabs: 30秒クイックスタート

1. **[INIT.md](INIT.md)** を開き、AIコマンドラインツールへ貼り付けます。
2. 画面の指示に従い、次の確認文を正確に返します。
   - `INSTALL_ROOT_OK: <absolute_path>`
   - `INSTALL_WRITE_OK`
3. 以後の新規セッション開始時は、次を入力します。

```text
AGENTS.md に従ってこのセッションを開始してください
```

---

<a id="install"></a>

## :bookmark_tabs: インストール

1. **[INIT.md](INIT.md)** を開く -> **Raw** をクリック -> 全選択 -> コピー
2. AIコマンドラインツール（Claude Code、Codex、Gemini CLI のいずれか）へ貼り付ける
3. AIは最初にルート安全性の事前確認を実行し、`pwd` と `git root` をこの順で表示する
4. `pwd` と `git root` が一致しない場合、AIは必ず停止し、使用ルートの選択を求める（自動選択は禁止）
5. AIは書き込み前に、リスク確認と演習計画（`create` / `merge` / `skip`）を表示する
6. 次の確認文を返す
   - `INSTALL_ROOT_OK: <absolute_path>`
   - `INSTALL_WRITE_OK`
7. 初回書き込み前に、AIは `<PROJECT_ROOT>/dev/init_backup/<UTC_TIMESTAMP>/` に軽量バックアップスナップショットを自動作成し、既存の対象ガバナンスファイルを保存する
8. AIが確認済みプロジェクトルートにガバナンスファイルを作成または統合する
9. AIが**クイックスタート**ブロックを自動出力する — セッション操作コマンドをそのままコピーして使えます

### :small_blue_diamond: インストール手順画面

<table>
  <tr>
    <td align="center" width="50%">
      <img src="ref_doc/install_step_1.png" alt="インストール手順 1" width="92%" />
      <br />
      <sub>手順 1：`INIT.md` をAIコマンドラインツールへ貼り付ける</sub>
    </td>
    <td align="center" width="50%">
      <img src="ref_doc/install_step_2.png" alt="インストール手順 2" width="92%" />
      <br />
      <sub>手順 2：検出されたルートを確認する</sub>
    </td>
  </tr>
  <tr>
    <td align="center" width="50%">
      <img src="ref_doc/install_step_3.png" alt="インストール手順 3" width="92%" />
      <br />
      <sub>手順 3：`INSTALL_ROOT_OK` を返す</sub>
    </td>
    <td align="center" width="50%">
      <img src="ref_doc/install_step_4.png" alt="インストール手順 4" width="92%" />
      <br />
      <sub>手順 4：`INSTALL_WRITE_OK` を返す</sub>
    </td>
  </tr>
</table>

手順4の確認完了後、AIは最初の書き込み前にバックアップスナップショットを自動作成します。

### :small_blue_diamond: 実行時画面

<table>
  <tr>
    <td align="center" width="50%">
      <img src="ref_doc/launch.png" alt="起動画面" width="92%" />
      <br />
      <sub>起動：セッション開始とコンテキスト読み込み</sub>
    </td>
    <td align="center" width="50%">
      <img src="ref_doc/closesession.png" alt="セッション完了画面" width="92%" />
      <br />
      <sub>収束：セッション要約と引き継ぎ出力</sub>
    </td>
  </tr>
</table>

AIが自動処理し、既存の `AGENTS.md`、`CLAUDE.md`、`GEMINI.md` と合わせます。
ほとんどの場合、`INIT.md` だけで導入できます。
リポジトリを手動でコピーせず、`INIT.md` を使ってください。安全にマージされます。

**インストール済みでアップグレードしたい場合も** 同じ `INIT.md` を使います — 下の[アップグレード](#upgrade)を参照してください。

---

<a id="upgrade"></a>

## :bookmark_tabs: 旧バージョンからのアップグレード

最新版 `INIT.md` を再実行します。手順は初回インストールと同じです。

1. **[INIT.md](INIT.md)** を開く → **Raw** をクリック → 全選択 → コピー
2. AIコマンドラインツール（Claude Code、Codex、Gemini CLIのいずれか）へ貼り付ける
3. `INSTALL_ROOT_OK: <absolute_path>`、続いて `INSTALL_WRITE_OK` で確認
4. AIが既存ファイルをバックアップした後、ガバナンスセクションを最新版にマージ

**アップグレード時のAIの動作：**
- 既存の `AGENTS.md`、`CLAUDE.md`、`GEMINI.md` → **merge**（ガバナンスセクションを最新化、カスタム内容は保持）
- `dev/DOC_SYNC_CHECKLIST.md` → **merge**（プロジェクト固有の行は保持、不足している汎用行を追加）
- `dev/SESSION_HANDOFF.md`、`dev/SESSION_LOG.md` → **skip**（セッション履歴は一切変更なし）
- インストール手順5のドライランで、書き込み前に各ファイルの `merge` / `skip` を確認できます

インストール済みバージョンを問わず利用可能。

---

<a id="quick-operations"></a>

## :bookmark_tabs: クイック操作

以下をそのままコピーして使えます。

### :small_blue_diamond: 1) 新しいセッションを開始

```text
AGENTS.md に従ってこのセッションを開始してください
```

### :small_blue_diamond: 2) セッションを収束して完全引き継ぎを実施

```text
このセッションを収束し、完全な引き継ぎまで実行してください。
```

### :small_blue_diamond: 3) 次のセッションをすぐ開始

```text
<前回出力の「NEXT SESSION HANDOFF PROMPT (COPY/PASTE)」ブロックを原文のまま貼り付けてください。>
```

---

## :bookmark_tabs: 配分切り替え引き継ぎフロー

1. コマンドラインツールAの配分上限が近づいたら、先にセッション収束を実行する
2. `NEXT SESSION HANDOFF PROMPT (COPY/PASTE)` ブロックをコピーする
3. コマンドラインツールBへ原文のまま貼り付ける
4. ツールBは `SESSION_HANDOFF.md` と `SESSION_LOG.md` を基準に継続実行する

これは本リポジトリの主要設計目標です。

---

## :bookmark_tabs: プラットフォーム設定

`AGENTS.md` が単一の信頼できる情報源（SSOT）です。`CLAUDE.md` と `GEMINI.md` は薄いポインターファイルです。

| プラットフォーム | ネイティブファイル | 提供内容 | 既存ファイルがある場合 |
|---|---|---|---|
| **Codex** | `AGENTS.md` | 完全なガバナンス規則 | ガバナンス節を既存ファイルへ統合 |
| **Claude Code** | `CLAUDE.md` | ポインター：`@AGENTS.md` | `CLAUDE.md` 先頭へ `@AGENTS.md` を追加 |
| **Gemini CLI** | `GEMINI.md` | ポインター：`@./AGENTS.md` | `GEMINI.md` 先頭へ `@./AGENTS.md` を追加 |

> **Codexユーザー：** AGENTS.mdはデフォルトの32 KiBコンテキスト上限を超えています。完全なファイルを読み込むには、`~/.codex/config.toml`に`project_doc_max_bytes = 49152`を追加してください。

---

## :bookmark_tabs: 3つの利用シナリオ

### :small_blue_diamond: シナリオ 1 — 1つのAIツールが配分上限に達し、別ツールへ切り替える
あるツールの配分を使い切った時点で、別ツールへ即時移行する必要があります。  
このテンプレートは、基線・未完了項目・リスク・検証状態を保持し、再説明を最小化します。

### :small_blue_diamond: シナリオ 2 — 1つのリポジトリを複数AIツールで運用する
例：Codexはコード、Claudeは文書、Geminiは基盤調査を担当。  
引き継ぎ文書とログを共通化することで、状態認識の分岐を防ぎます。

### :small_blue_diamond: シナリオ 3 — 長期プロジェクトでガバナンスが漂流している
修正が積み上がり、規則が増え、文書の整合性が崩れていく状態。  
「追加前に統合」の規律により、SOP肥大化と保守コストを抑制します。

---

## :bookmark_tabs: よくある質問

ビジュアルなFAQは **[インタラクティブな紹介ページ](https://prompt-templates.github.io/ai-session-governance/?lang=ja)** をご覧ください。

### :small_blue_diamond: 1) 大規模プロジェクト向けですか？
違います。小規模でもすぐ効果があり、長期運用では規模が大きいほど差が出ます。

### :small_blue_diamond: 2) 初日から `PROJECT_MASTER_SPEC.md` は必要ですか？
不要です。まず `AGENTS.md` + `SESSION_HANDOFF.md` + `SESSION_LOG.md` だけで始められます。

### :small_blue_diamond: 3) これはコーディング規約ですか？
違います。AIがどう読み・変更し・検証し・引き継ぐかを決めるもので、コードの書き方は関係ありません。

### :small_blue_diamond: 4) セッションは遅くなりますか？
開始時に少し読み込みが増えます。再説明や修正のやり直しより通常は短いです。

### :small_blue_diamond: 5) 既存のREADMEや内部規則は残せますか？
残せます。既存のものに合わせてマージします。上書きはしません。

### :small_blue_diamond: 6) これが過剰になるケースは？
ちょっとした質問、一回きりのリサーチ、戻ってこないセッション — そういう場合はスキップしてください。起動時のファイル読み込みと終了時の書き込みは、同じプロジェクトに複数セッションにわたって戻ってくる場合にのみ元が取れます。

このテンプレートは継続的な開発作業向けに作られています。明日もまた触るコードベース、複数のAIツールが交代で作業するリポジトリ、「先週何を決めたっけ」が本当に重要なプロジェクト。時間とともに変わるファイルが存在しないなら、PLAN→READ→CHANGE→QC→PERSISTサイクルには包むものがありません。

## :bookmark_tabs: リポジトリ構成

```text
<PROJECT_ROOT>/
├─ INIT.md
├─ AGENTS.md
├─ CLAUDE.md
├─ GEMINI.md
└─ dev/
   ├─ SESSION_HANDOFF.md
   ├─ SESSION_LOG.md
   ├─ archive/                 # 自動アーカイブされた古いログ（四半期ごと）
   ├─ DOC_SYNC_CHECKLIST.md    # 文書同期レジストリ
   ├─ CODEBASE_CONTEXT.md      # 初回セッション自動生成
   └─ PROJECT_MASTER_SPEC.md   # optional
```

### :small_blue_diamond: コアファイル

- `INIT.md` - ガバナンスファイル作成/統合の起動プロンプト（公開入口）
- `AGENTS.md` - ガバナンスのSSOT
- `CLAUDE.md` - Claude用ポインター
- `GEMINI.md` - Gemini用ポインター
- `dev/SESSION_HANDOFF.md` - 現在基線と次優先事項
- `dev/SESSION_LOG.md` - セッション履歴と検証記録（ローリングウィンドウ、自動整理）
- `dev/archive/` - 自動アーカイブされた古いセッションログ、四半期ごとに整理；起動時は読み込まない
- `dev/DOC_SYNC_CHECKLIST.md` - 文書同期レジストリ：変更カテゴリと必要な文書更新の対応表
- `dev/CODEBASE_CONTEXT.md` - 技術スタック・外部サービス・主要決定（初回セッション自動生成）
- `dev/PROJECT_MASTER_SPEC.md` - 任意の長期権威仕様

---

## :bookmark_tabs: ガバナンス原則

1. 変更前に読む
2. デバッグ前に分類する
3. 追加前に統合する
4. 完了主張前に検証する
5. 終了前に永続化する

---

## :bookmark_tabs: 検証

詳細な主張対応表とプラットフォーム検証は次に集約しています。
- [docs/VERIFICATION.md](docs/VERIFICATION.md)
- 最新のQA回帰検証レポート: [docs/qa/LATEST.md](docs/qa/LATEST.md)

2026-04-14時点の要約：
- AGENTS/INIT 規則整合：検証済み（169 項自動回帰テスト + 15 項動作テスト）
- マルチプラットフォーム指針動作：検証済み

---

## :bookmark_tabs: 発展ドキュメント

リポジトリが拡張した場合の推奨補助文書：
- `dev/PROJECT_MASTER_SPEC.md`
- `docs/OPERATIONS.md`
- `docs/POSITIONING.md`

現時点の最小構成：
- `AGENTS.md`
- `dev/SESSION_HANDOFF.md`
- `dev/SESSION_LOG.md`

---

## :bookmark_tabs: デザイナー

> **[Adam Chan](https://www.facebook.com/chan.adam)** によりデザインされました · [i.adamchan@gmail.com](mailto:i.adamchan@gmail.com)
>
> *Vibe Coding の時代、誰もが自分だけの AI 世界をつくれる。*

---

## :bookmark_tabs: ライセンス

各自のワークフローに合わせて自由に利用・改変・拡張できます。
