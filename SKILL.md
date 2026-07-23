---
name: codex-lazy-packs
description: Codex 懶人包全集 — 環境建置、MCP 串接、技能安裝與生圖。說「Codex 懶人包」「安裝 Codex 懶人包」時載入。
---

# Codex 懶人包 — AI Agent 自動安裝入口

當使用者給你這個 repo 網址並說要安裝時：

## 步驟一：列出可用懶人包

| 編號 | repo 來源資料夾 | 安裝後 Skill 名稱 | 說明 |
|------|-----------------|-------------------|------|
| 00 | `skills/00-env-setup` | `codex-env-setup` | Codex Desktop、Node.js LTS、uv；CLI 選用，不處理 GitHub |
| 01 | `skills/01-notebooklm` | `codex-notebooklm` | 連接 NotebookLM MCP |
| 02 | `skills/02-essentials` | `codex-essentials` | 初學者必裝 Skills 與 Plugins |
| 03 | `skills/03-github` | `codex-github` | 連接 GitHub CLI |
| 04 | `skills/04-obsidian` | `codex-obsidian` | 連接 Obsidian（資料夾授權 / MCPVault） |
| 05 | `skills/05-supabase` | `codex-supabase` | 連接 Supabase |
| 06 | `skills/06-firebase` | `codex-firebase` | 連接 Firebase |
| 07 | `skills/07-ollama` | `codex-ollama` | 本地 AI Ollama |
| 08 | `skills/08-gemini` | `codex-gemini` | Gemini 免費 API |
| 09 | `skills/09-draw` | `codex-draw` | 生圖指引（內建 + API） |
| 10 | `skills/00-install-all` | `codex-install-all` | 一次安裝全部 |

## 步驟二：讓使用者選擇

問：「你要安裝哪些？輸入全部或編號組合（例如 00, 01, 03, 04）。」

將編號轉成上表的完整 Skill 名稱。若使用者只選 00，不得順便執行 GitHub 安裝或帳號檢查。

## 步驟三：依序安裝

```bash
npx skills add changyiwu/codex-lazy-packs --skill <完整 Skill 名稱> --full-depth --agent codex -g -y
```

例如只安裝環境建置：

```powershell
npx skills add changyiwu/codex-lazy-packs --skill codex-env-setup --full-depth --agent codex -g -y
```

`--full-depth` 不可省略；repo 根目錄已有入口 `SKILL.md`，省略時安裝器只會看到入口 Skill。

### 安裝資料夾命名規則

repo 內的編號資料夾只用來維持教學順序，不能當成全域安裝名稱。安裝完成後必須是：

```text
~/.agents/skills/codex-env-setup/SKILL.md
~/.agents/skills/codex-notebooklm/SKILL.md
~/.agents/skills/codex-essentials/SKILL.md
```

其餘項目依上表的「安裝後 Skill 名稱」類推。`npx skills add` 會依 `SKILL.md` frontmatter 的 `name` 建立正確資料夾。

如果目前環境要求使用內建 `skill-installer` 的 GitHub helper，不得把多個 `--path` 直接批次安裝，因為 helper 可能使用來源資料夾名稱。必須逐項安裝並明確傳入：

- `repo`: `changyiwu/codex-lazy-packs`
- `path`: 上表的 repo 來源資料夾
- `name`: 上表的安裝後 Skill 名稱
- `dest`: `~/.agents/skills`

例如安裝 #00 時，使用 `path=skills/00-env-setup`、`name=codex-env-setup`。手動安裝時也要把內容複製到 `~/.agents/skills/codex-env-setup/`，不可直接把 `00-env-setup` 整個資料夾複製到全域 Skills。

若無法安裝，才改為直接讀取 `skills/00-env-setup/SKILL.md` 等對應檔案執行，不要把「讀取並執行」誤報成已安裝。

## 步驟四：驗收並回報

逐項確認 `~/.agents/skills/<安裝後 Skill 名稱>/SKILL.md` 存在，而且 frontmatter `name` 與資料夾名稱一致。

如果只看到 `00-env-setup`、`01-notebooklm` 等編號資料夾，視為命名錯誤，不得回報成功：

- 正確的 `codex-*` 目的地不存在時，可將該編號資料夾精確改名為上表的 `codex-*` 名稱。
- 新舊兩個資料夾同時存在時，不得覆蓋或刪除；回報衝突並讓使用者決定保留哪一份。

每項回報 ✅/⚠️/❌，列出實際全域路徑，最後提供總表。
