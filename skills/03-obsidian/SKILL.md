---
name: codex-obsidian
description: Codex 連接 Obsidian。說「連接 Obsidian」時載入。
---

# 連接 Obsidian（Codex 版）

1. 詢問主要 Vault 路徑；不知道時搜尋 `.obsidian`，找到多個候選要讓使用者選擇。
2. 讀取既有全域 `~/.codex/AGENTS.md`，確認後合併 Vault 固定路徑，不覆蓋其他規則。
3. 讓使用者選擇連線方式：
   - 工作區／資料夾授權：不需額外安裝，但受目前可寫範圍限制。
   - MCPVault：跨專案使用，提供搜尋與筆記工具。
4. 使用 MCPVault 時，先檢查 Node.js，再詢問是否執行 `npm.cmd install -g @bitbonsai/mcpvault`。
5. 透過 Codex MCP 設定介面、`~/.codex/config.toml` 或 `codex mcp add` 加入 STDIO server；修改前先保留其他 MCP 設定。
6. 重啟後先做讀取測試；寫入測試前先詢問，完成後再次詢問是否刪除測試筆記。

回報：Vault 路徑、全域 AGENTS.md 狀態、連線方式、讀取／寫入結果、測試筆記處理結果。
