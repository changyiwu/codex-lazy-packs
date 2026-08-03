# codex-lazy-packs（專案藍圖）

> 本檔為跨 Agent 通用的專案藍圖（AGENTS.md 開放標準）。任何 Agent 的每個 session 都應先讀本檔＋`handoff.md`。

## 專案簡介

公開發布到 GitHub 的 **Codex 懶人包**倉庫。與 `claude-code-lazy-packs/`、`opencode-lazy-packs/`、`antigravity-lazy-pack/` 是平行版本：同樣的教學流程，分別給不同 AI 編碼代理使用。

懶人包以 **Codex Desktop app**（macOS / Windows）為主軸寫作，因為這是大多數老師的入口。但 Desktop / IDE 擴充 / CLI 三者**共用 `~/.codex/config.toml` 與 `AGENTS.md`**，所以每個 MCP 章節都同時提供三條路：

1. Desktop GUI（Integrations & MCP 面板）
2. 手動編輯 `~/.codex/config.toml`
3. CLI 指令

## 關鍵時程

<!-- 目前無固定時程 -->

## 目標與路線圖

- [x] 階段一：教學章節縮減並重編為 #00–#05（共 6 章）
- [x] 階段二：原有 11 個可安裝 Skills 通過 Skill Creator `quick_validate.py` 與發布驗證
- [x] 階段三：修正 Skill 安裝命名——repo 內保留 `skills/00-env-setup` 編號資料夾，安裝到 `~/.agents/skills/` 時用 frontmatter 的 `codex-env-setup` 正式名稱
- [x] 階段四：本機 7 個編號全域 Skill 資料夾原地改名為 `codex-*`，資料夾名與 frontmatter `name` 一致
- [x] 階段五：所有 Skill 統一從本地 repo 安裝，使用 `npx skills add .` 落在 `~/.agents/skills/codex-*`
- [x] 階段六：移除 Essentials、Supabase、Ollama、Gemini API 四個 Skill 及對應教學章節，其餘文章與 Skill 對齊重編為 #00–#05

## 資料夾結構

```
codex-lazy-packs/
├─ README.md                          # 使用者入口
├─ SKILL.md                           # 懶人包入口 Skill
├─ 00-環境建置.md
├─ 01-連接-Gemini-Notebook.md
├─ 02-連接-GitHub.md
├─ 03-連接-Obsidian.md
├─ 04-連接-Firebase-資料庫.md
├─ 05-用Image Gen Skill在Codex生圖.md
├─ skills/                            # 可安裝技能（保留編號前綴）
├─ scripts/validate-lazy-pack.ps1     # 發布前驗證
├─ agents.md                          # 本檔：專案藍圖
├─ handoff.md                         # 交接檔（每次收工必更新）
├─ .agents/  .github/  .gitignore
└─ LICENSE
```

## 同步層級（本專案初始化至第 3 層級）

| 層級 | 平台 | 位置 | 讀取時機 |
|------|------|------|---------|
| L1 | 本地（GDrive） | `agents.md`＋`handoff.md` | 每個 session |
| L2 | GitHub | https://github.com/changyiwu/codex-lazy-packs （公開） | 指定時 |
| L3 | Obsidian | `codex-lazy-packs/專案工作流程.md` | 有需要時 |

## 三個檔案的職責（依「時效性」分家，不是依「詳細程度」）

| 檔案 | 時效 | 寫入方式 | 放什麼 |
|------|------|---------|--------|
| `handoff.md` | **只對下一個 session 有效**，過期即丟 | 每次收工整份重寫 | 做到哪、下一步、**這次**的暫時 workaround |
| `agents.md`（本檔） | **長期有效**，每個 session 都適用 | 只有規則本身變了才改 | 目標、路線圖、常設規則、結構 |
| Obsidian／`git log` | **歷史**：發生過什麼、為什麼 | 只增不刪 | 決策紀錄、踩坑完整版、逐次進度 |

驗收標準：**`handoff.md` 整份刪掉，不應損失任何長期資訊**——會的話代表該升級進本檔卻沒升級。

**本檔不要出現的東西**：❌ `## 最近進度`／逐次工作紀錄、❌ 決策理由與踩坑完整版。2026-08-03 移除了 `## 最近進度`，內容逐條比對後已在 L3 筆記的〈🗓️ 最近更動紀錄〉——**是主動移除，不是遺漏，不要補回來**。踩過的坑只把**結論**收斂成一條祈使句寫進〈工作約定〉，原因留 L3。

## 工作約定

- 任何 Agent、任何電腦：**開工先讀 `handoff.md`，收工必更新 `handoff.md`**
- 修改共用檔案前先讀最新內容，避免覆蓋其他 Agent 的變更
- 所有回應與文件使用繁體中文
- 使用者說「更新 Codex 懶人包」→ 只動本資料夾；說「兩邊都更新」→ 兩個資料夾都改，commit 訊息分別寫
- **不要**把其他代理版本直接 copy 過來；MCP 指令、設定檔格式、Skill 機制都不同
- 修改主流程（例如某 MCP 換新版指令）時，平行的懶人包資料夾都要更新，改完 push 到各自的 GitHub repo
- 修改教學章節或 Skill 後，先執行 `scripts/validate-lazy-pack.ps1`
- repo 內的 Skill 資料夾**必須保留編號前綴**；只有全域安裝目的地使用 `codex-*`
- 所有 Skill 必須從本地 repo 根目錄安裝；使用 `npx skills add .`，不要改用 GitHub URL 或 GitHub helper
- 不要恢復已移除的第二大腦或 chezmoi 章節與 Skill

## 安全邊界

- 不提交 `.env`、API Key、token、密碼、憑證或個人本機代理設定
- 未經使用者明確要求，不建立或連接 GitHub 遠端、不提交、不推送、不啟用 Pages、不部署
- 不修改 Firebase 安全規則；本專案目前沒有連結 Firebase 專案
