# Codex 懶人包（OpenAI Codex 版）

> Claude Code 懶人包的 OpenAI Codex 平行版本。
> 把每份 MD 檔丟給 Codex，它會自動執行。
>
> ✅ **適用三種 Codex**：**Codex Desktop app（macOS/Windows）**、**Codex IDE 擴充（VSCode / Cursor / JetBrains）**、**Codex CLI**。三者**共用同一份** `~/.codex/config.toml` 與 `AGENTS.md`，所以設定做一次就好。

---

## 我用的是哪一種？

| 你的工具 | 怎麼裝 / 怎麼開 |
|---|---|
| **Codex Desktop app** | 從 [OpenAI 官網](https://developers.openai.com/codex/app)下載 macOS / Windows 安裝檔（**本懶人包預設場景**） |
| Codex IDE 擴充 | VSCode / Cursor / Windsurf → Marketplace 搜尋「ChatGPT」（OpenAI 官方）；JetBrains 系列也有對應 |
| Codex CLI | `npm install -g @openai/codex` |

**MCP 與 AGENTS.md 設定的三條路（任選）**：
1. **Desktop**：`設定 → Integrations & MCP` 介面新增 server；`設定 → Personalization` 編輯 AGENTS.md
2. **IDE**：齒輪 → MCP settings → Open config.toml
3. **CLI**：`codex mcp add <name> -- <command>`

> 設定動了一邊，三邊都會吃到。本懶人包以 **Desktop app GUI** 為主寫，每個 MCP 章節都附「手動編輯 `~/.codex/config.toml`」的 TOML 範例供 IDE / CLI 用戶或 Desktop 進階使用者參考。

---

## 為什麼有這份？

原本的懶人包是給 Claude Code 用的，但很多老師也在用 OpenAI Codex CLI。
這份是把同樣的工作流程，**改寫成 Codex 看得懂的版本**：

| 差異 | Claude Code | OpenAI Codex |
|---|---|---|
| 全域指令檔 | `~/.claude/CLAUDE.md` | `~/.codex/AGENTS.md` |
| 專案指令檔 | `./CLAUDE.md` | `./AGENTS.md` |
| 設定檔 | `~/.claude/settings.json`（JSON） | `~/.codex/config.toml`（TOML） |
| MCP 安裝指令 | `claude mcp add ...` | `codex mcp add ...` |
| Skill 機制 | 原生支援 | ✅ Codex Desktop 支援 skills；CLI / 舊環境可用 prompt 模板或 shell 腳本備援 |
| Slash command | 原生支援 | ❌ 沒有 |
| 排程任務 | `mcp__scheduled-tasks__*` | ✅ Codex Desktop app / ChatGPT 網頁可建立與管理；CLI、IDE 沒有管理介面，可先用它們測試流程 |

---

## 使用方式

### 方式一：直接叫 AI 幫你裝（最簡單）

把這行貼給你的 AI agent：

```
這是 Codex 懶人包全集 https://github.com/changyiwu/codex-lazy-packs
請讀取 repo 內容，列出所有可用的懶人包，問我要裝哪些。
```

AI 會自動讀取 `SKILL.md`（安裝入口），列出 17 個可安裝技能，讓你選擇後自動安裝。使用 `--full-depth --list` 時，CLI 另外還會顯示根入口 `codex-lazy-packs`，因此畫面總數是 18。

也可以直接安裝「環境建置」Skill：

```powershell
npx skills add changyiwu/codex-lazy-packs --skill codex-env-setup --full-depth -g -y
```

> `--full-depth` 不可省略。只安裝 `codex-env-setup` 時，不會檢查 GitHub 帳號，也不會安裝 Git 或 GitHub CLI。

### 方式二：手動下載 MD 檔

1. 看影片了解原理（同 Claude 基本功系列）
2. 下載對應的懶人包（MD 檔）
3. 打開 OpenAI Codex CLI，把檔案內容貼進去
4. AI 自動執行，遇到需要手動操作的地方會暫停指示你

---

## 最低先備條件

- [ ] OpenAI 帳號（ChatGPT Plus / Pro / Business / Edu 訂閱，或 OpenAI API 額度）
- [ ] **Codex Desktop app** 已安裝且能登入（macOS / Windows）；或 IDE 擴充 / CLI 任一
- [ ] 電腦有網路連線

---

## 懶人包清單

| 編號 | 名稱 | 說明 |
|------|------|------|
| 00 | [環境建置](00-環境建置.md) | Codex Desktop、Node.js LTS、uv；Codex CLI 選用，不處理 GitHub |
| 01 | [連接 NotebookLM](01-連接-NotebookLM.md) | NotebookLM MCP（Codex 版） |
| 02 | [初學者必裝外掛程式與技能](02-Codex必裝Skills與Plugins.md) | 基礎工具快篩、GitHub、Browser Use、Office 文件、生圖、官方文件與技能工具檢查 |
| 03 | [連接 GitHub](03-連接-GitHub.md) | GitHub CLI、GitHub App 與 push 驗證 |
| 04 | [連接 Obsidian](04-連接-Obsidian.md) | 確認 vault、設定全域 AGENTS.md，並用資料夾授權或 MCPVault 讀寫 |
| 05 | [第二大腦設定指南](05-第二大腦設定指南.md) | 三層結構 + AGENTS.md + 模板 |
| 06 | [連接 Supabase 資料庫](06-連接-Supabase-資料庫.md) | Supabase MCP（Codex 版） |
| 07 | [連接 Firebase 資料庫](07-連接-Firebase-資料庫.md) | Firebase MCP（Codex 版） |
| 08 | [安裝本地 AI Ollama](08-安裝本地AI-Ollama.md) | 本地模型，網頁工具用 |
| 09 | [設定 Gemini 免費 API](09-設定Gemini免費API.md) | Gemini 免費 API，網頁工具用 |
| 10 | [開始你的專案](10-初始化班級工具工作模式.md) | 安裝開工／收工／新專案初始化 Skills；收工安全檢查後直推 `origin/main` |
| 11 | [用 Image Gen Skill 在 Codex 生圖](11-用Image Gen Skill在Codex生圖.md) | 新手用內建 Image Gen Skill；進階再用 API Key / CLI |
| 12 | [用 chezmoi 同步 Codex 設定](12-用chezmoi同步Codex設定.md) | 跨電腦同步 `~/.codex/AGENTS.md` 與全域 skills |

---

## 不通用、需特別注意的章節

- **08 / 09**：跟 Codex / Claude 都無關，是「讓你做的網頁工具有 AI 能力」，兩邊通用。
- **10 / 12 專案與設定同步**：說「收工」會在安全檢查通過後自動 commit／push `origin/main`；跨電腦同步設定時才使用 chezmoi。
- **11 生圖**：Codex Desktop 新手優先使用內建 Image Gen Skill；API Key / CLI 腳本只作為進階大量產圖與自動化路線。
- **05 第二大腦設定指南**：每週知識重整優先使用 Codex 自動化；CLI 排程只作為進階備援。

> Codex 自動化應先手動測試成功，再由使用者明確決定是否建立。需要讀寫本機專案的排程，必須保持電腦開機且 Desktop app 正在執行；CLI 與 IDE 擴充本身不提供排程管理介面。

---

## 發布前檢查

維護者修改章節或 Skill 後，請執行：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate-lazy-pack.ps1
```

此檢查會驗證章號沒有重複、相對 Markdown 連結有效、Skill frontmatter 完整、三個工作 Skill 資產齊全、沒有 Unicode 亂碼取代字元，以及 Windows Node.js 安裝指令都使用 LTS。GitHub Actions 也會在 push 與 pull request 自動執行同一份檢查。

---

## 授權

MIT License，與 Claude Code 懶人包相同。

---

## 相關技能 repo

- [agent-speak-skill](https://github.com/mathruffian-dot/agent-speak-skill) — 讓 AI Agent「用語音回答你」：免費 Edge-TTS 串流語音回覆，零金鑰、首聲約 1–2 秒、無視窗（Claude Code／Codex／OpenCode／AntiGravity 通用）
