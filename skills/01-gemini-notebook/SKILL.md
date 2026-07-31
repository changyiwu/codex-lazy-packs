---
name: codex-gemini-notebook
description: Codex 連接 Gemini Notebook MCP。說「連接 Gemini Notebook」或舊稱「連接 NotebookLM」時載入。
---

# 連接 Gemini Notebook（Codex 版）

> Google 已將 NotebookLM 政名為 Gemini Notebook，MCP 專案 repo 也已改名為 `gemini-notebook-mcp-cli`；但目前 PyPI 套件、執行檔與 CLI 仍沿用 `notebooklm-mcp-cli`、`notebooklm-mcp`、`nlm`，不得自行改寫這些指令。

1. 檢查 `uv --version`，再執行 `uv tool install notebooklm-mcp-cli`；已安裝則用 `uv tool upgrade notebooklm-mcp-cli`
2. 驗證 `nlm --version` 與 `Get-Command nlm, notebooklm-mcp`
3. `nlm login`，再用 `nlm login --check` 驗證
4. 先用 `codex mcp list` 檢查是否已有舊的 `notebooklm` 或其他 Gemini Notebook server；同一時間只保留一個，避免工具名稱衝突
5. 以上游目前建議的 server 名稱註冊：`codex mcp add notebooklm-mcp -- notebooklm-mcp`
   或手動編輯 `~/.codex/config.toml`：
```toml
[mcp_servers.notebooklm-mcp]
command = "notebooklm-mcp"
startup_timeout_sec = 60.0
tool_timeout_sec = 120.0
```
6. 重啟 Codex 後驗證：列出筆記本
7. 建立一個明確標記為測試的 notebook，確認後立即刪除

注意：`nlm mcp` 已失效，不可再使用。若已有 `[mcp_servers.notebooklm]`，先確認它是舊的同一套服務，再改名或移除；不得讓新舊兩個 Gemini Notebook server 並存。這是非 Google 官方工具，使用內部 API；不要提交登入憑證。回報：nlm 版本、登入狀態、MCP 設定、建立/刪除測試結果。
