# Codex 懶人包 #01：連接 Google Gemini Notebook

> 版本：v0.3（Codex 版）
> 更新日期：2026-08-01

> 📣 Google 已在 2026-07-16 將 **NotebookLM** 正式改名為 **Gemini Notebook**。產品仍是同一個獨立服務；社群 MCP 專案 repo 也已改名為 `gemini-notebook-mcp-cli`，但目前 PyPI 套件、執行檔與 CLI 仍沿用 `notebooklm-mcp-cli`、`notebooklm-mcp`、`nlm`，本教學保留這些技術名稱以維持相容。

> 📌 **本懶人包可獨立執行**：會自動檢查並安裝所需工具。

---

## 這個懶人包會幫你做什麼？

讓 Codex Desktop app、IDE 擴充或 CLI 能直接操控 Gemini Notebook：建 notebook、上傳資料來源、產生簡報/資訊圖表/音訊/影片/心智圖/測驗等，成品可下載到本機資料夾。

---

## 原理

```
Codex ←(MCP 協定)→ notebooklm-mcp ←(Google 登入)→ Gemini Notebook
```

`notebooklm-mcp-cli` 安裝後會提供兩個程式：
- `nlm`：登入、診斷與直接操作 Gemini Notebook 的命令列工具
- `notebooklm-mcp`：提供給 Codex 連線的 stdio MCP server

> ⚠️ 這是非 Google 官方工具，使用 Gemini Notebook 的內部 API，介面可能在 Google 更新後改變。適合個人與實驗用途，請勿把帳號憑證提交到 GitHub。

> 💡 **跟 Claude Code 版的差別**：MCP server 本體（`notebooklm-mcp-cli`）一模一樣，只是註冊到 Codex 的方式不同（Codex 用 `~/.codex/config.toml`，Claude Code 用 `~/.claude/settings.json`）。

---

## 先備條件

- [ ] Codex Desktop app、IDE 擴充或 CLI 任一可正常使用
- [ ] Google 帳號
- [ ] 電腦有網路連線

---

## 請 Codex 幫我執行以下步驟

### 步驟零：環境檢查

1. 作業系統
2. `uv --version`，沒有則步驟一安裝
3. 網路連線
4. 若要走 CLI 註冊方式，再檢查 `codex --version`

---

### 步驟一：安裝 uv（如果沒裝）

**Windows（PowerShell）**：
```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

**macOS / Linux**：
```shell
curl -LsSf https://astral.sh/uv/install.sh | sh
```

---

### 步驟二：安裝 Gemini Notebook MCP CLI

```powershell
uv tool install notebooklm-mcp-cli
```

確認：
```powershell
nlm --version
Get-Command nlm, notebooklm-mcp
```

如果已安裝舊版，更新：
```powershell
uv tool upgrade notebooklm-mcp-cli
```

> 找不到 `nlm` 或 `notebooklm-mcp` → 執行 `uv tool update-shell` 後重開 PowerShell；仍失敗再檢查 `uv tool dir --bin` 的路徑是否已加入 PATH。

---

### 步驟三：登入 Google 帳號

```powershell
nlm login
```

> 🖐️ 瀏覽器會開 Google 登入頁，登入後 CLI 自動擷取認證。

確認：
```powershell
nlm login --check
nlm doctor
```

---

### 步驟四：把 Gemini Notebook 註冊為 Codex 的 MCP server

> ✅ 三種 Codex 共用 `~/.codex/config.toml`，做一次三邊都吃到。任選一條路：
>
> ⚠️ 上游目前建議 server 名稱使用 `notebooklm-mcp`。先檢查是否已有舊的 `notebooklm` 或其他 Gemini Notebook server；同一時間只保留一個，避免重複工具互相衝突。

**方法 A：Codex Desktop GUI（最推薦）**

1. 開 Codex Desktop → 設定 → **Integrations & MCP**
2. 點 **Add server**（或類似的「新增」按鈕）
3. 填：
   - Name：`notebooklm-mcp`
   - Command：`notebooklm-mcp`
   - Args：留空
4. 儲存

**方法 B：手動編輯 `~/.codex/config.toml`**

> Desktop：設定 → Integrations & MCP → 「Open config.toml」也能直接打開這檔；IDE：齒輪 → MCP settings → Open config.toml；用記事本/編輯器開亦可。

```toml
[mcp_servers.notebooklm-mcp]
command = "notebooklm-mcp"
startup_timeout_sec = 60.0
tool_timeout_sec = 120.0
```

> 💡 路徑：Windows `C:\Users\<你>\.codex\config.toml`，macOS/Linux `~/.codex/config.toml`。檔案不存在就新建。
>
> ⚠️ **Section 名稱必須是 `mcp_servers`**（底線、複數）。寫成 `mcp-servers` 或 `mcpservers` Codex 會靜默忽略。

**方法 C：CLI（只給有裝 CLI 的人）**

```powershell
codex mcp list
codex mcp add notebooklm-mcp -- notebooklm-mcp
codex mcp get notebooklm-mcp
```

若 `codex mcp list` 已顯示舊的 `notebooklm`，先確認它也是指向 `notebooklm-mcp`。請將舊設定改名或執行 `codex mcp remove notebooklm` 後再新增；不要讓新舊兩個 server 同時存在。

---

### 步驟五：建立本地資料夾

在 Documents 下建：
```
Documents/
  └── Gemini Notebook/
      ├── slides/
      ├── infographics/
      ├── audio/
      ├── video/
      ├── docs/
      ├── sheets/
      ├── mindmaps/
      └── quizzes/
```

Windows PowerShell 可直接執行：
```powershell
$root = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'Gemini Notebook'
'slides','infographics','audio','video','docs','sheets','mindmaps','quizzes' |
    ForEach-Object { New-Item -ItemType Directory -Force -Path (Join-Path $root $_) | Out-Null }
```

---

### 步驟六：重啟 Codex 並驗證

> 🖐️ **Desktop**：完全結束 app（不只是關視窗），重新開啟。
> **IDE 擴充**：Reload Window（VSCode：`Cmd/Ctrl+Shift+P` → Reload Window）。
> **CLI**：`exit` 後重新 `codex`。

驗證：
1. 先在 PowerShell 執行 `nlm login --check`
2. 對 Codex 說「列出我的 Gemini Notebook 筆記本清單」
3. 能成功列出（即使空的）→ 連接成功
4. Desktop 用戶可在 Integrations & MCP 設定面板看 `notebooklm-mcp` 顯示為 ✅ 連線中

---

### 步驟七：功能測試

1. 建一個叫「測試筆記本」的 notebook
2. 確認建立成功
3. 刪除它
4. ✅ 「全部完成！Codex 已連接 Gemini Notebook。」

---

## 如果失敗

對 Codex 說：「Gemini Notebook 懶人包執行失敗，清除設定重跑。」

復原：
- **Desktop**：設定 → Integrations & MCP → 找到 `notebooklm-mcp` → 刪除/停用
- **手動**：編輯 `~/.codex/config.toml` 移除 `[mcp_servers.notebooklm-mcp]` 段
- **CLI**：`codex mcp remove notebooklm-mcp`

清掉 nlm 本體：
```powershell
uv tool uninstall notebooklm-mcp-cli
nlm login profile delete default --confirm
```

---

## 常見問題

| 問題 | 解法 |
|------|------|
| 找不到 `nlm` 或 `notebooklm-mcp` | 執行 `uv tool update-shell`、重開 PowerShell，再檢查 `uv tool dir --bin` |
| `nlm login --check` 顯示憑證過期 | 重跑 `nlm login` |
| Codex 看不到 Gemini Notebook 工具 | Desktop：設定 → Integrations & MCP 看 `notebooklm-mcp` 是否啟用 / 連線；CLI：`codex mcp list` |
| 同時看到兩組相似工具 | 檢查並移除舊的 `notebooklm` server，只保留 `notebooklm-mcp` |
| `codex mcp` 指令找不到 | 你沒裝 CLI，用 Desktop GUI 或手動編輯 config.toml |
| 設定改了沒生效 | section 名稱要 `mcp_servers`（底線、複數），寫錯會被靜默忽略 |
| 第一次啟動 MCP 超過 30 秒 | 在設定加入 `startup_timeout_sec = 60.0` 與 `tool_timeout_sec = 120.0` |
| Windows 上指令格式錯誤 | 用 PowerShell 或 Git Bash，別用 CMD |
| 舊教學使用 `nlm mcp` | 此命令在目前版本已不存在，MCP command 改用 `notebooklm-mcp` |

---

## 相關連結

- [Google 官方：NotebookLM 已改名為 Gemini Notebook](https://blog.google/innovation-and-ai/products/gemini-notebook/notebooklm-gemini-notebook/)
- [Gemini Notebook 官方說明](https://support.google.com/gemininotebook/)
- [gemini-notebook-mcp-cli GitHub](https://github.com/jacob-bd/gemini-notebook-mcp-cli)
- [Codex MCP 官方文件](https://developers.openai.com/codex/mcp)
