# Codex 懶人包 #04：連接 Obsidian

> 版本：v1.0（Codex Desktop / IDE / CLI）
> 更新日期：2026-07-14

這一章只處理 Codex 與 Obsidian Vault 的連線。完成後，Codex 能知道主要 Vault 的位置，並透過資料夾授權或 MCP 讀取、搜尋與修改筆記。

> [!important]
> `AGENTS.md` 只讓 Codex 知道 Vault 在哪裡，不會自動取得讀寫權限。真正的讀寫能力來自工作區／資料夾授權或 MCP。
>
> 本章聚焦連線；Vault 的資料夾、模板與索引請依既有筆記規則自行規劃。

---

## 完成標準

- [ ] 已確認主要 Vault 路徑
- [ ] Vault 中存在 `.obsidian` 資料夾
- [ ] 全域 `AGENTS.md` 已記錄固定路徑
- [ ] 已選擇資料夾授權或 MCP 連線
- [ ] 已完成讀取驗證
- [ ] 若需要寫入，已在確認後完成寫入驗證

---

## 執行原則

請 Codex 一次只做一個步驟，完成後再繼續。

- 找到多個 Vault 時，列出候選路徑讓使用者選擇，不自行猜測。
- 修改全域 `AGENTS.md` 或 `config.toml` 前先讀取原內容，不覆蓋其他設定。
- 安裝 Node.js 或 MCPVault 前先詢問。
- 建立測試筆記前先詢問；刪除測試筆記時再次確認。
- 不把 API Key、token 或密碼寫進筆記。

---

## 步驟一：確認 Obsidian Vault

先詢問使用者：

> 你的 Obsidian 筆記本放在哪裡？如果不知道，我可以幫你找。

常見位置：

| 同步方式 | 常見路徑 |
|---|---|
| OneDrive | `C:\Users\<你>\OneDrive\文件\<Vault名稱>` |
| Google Drive | `G:\我的雲端硬碟\<Vault名稱>` |
| Obsidian Sync | 使用者選擇的本機資料夾 |
| 本機文件 | `C:\Users\<你>\Documents\<Vault名稱>` |

Windows 可以在使用者指定的範圍內搜尋 `.obsidian`：

```powershell
$roots = @(
  "$env:USERPROFILE\OneDrive",
  "$env:USERPROFILE\Documents",
  "$env:USERPROFILE\Desktop",
  "G:\我的雲端硬碟",
  "G:\My Drive"
)

$roots |
  Where-Object { Test-Path -LiteralPath $_ } |
  ForEach-Object {
    Get-ChildItem -LiteralPath $_ -Recurse -Directory -Force -ErrorAction SilentlyContinue |
      Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName ".obsidian") } |
      Select-Object -ExpandProperty FullName
  }
```

確認條件：

- 資料夾存在
- 裡面有 `.obsidian`
- 使用者確認這是主要 Vault

若還沒有 Vault，請先安裝 Obsidian，用 Obsidian 建立並開啟一個新 Vault；本章不替使用者決定同步服務或資料夾結構。

---

## 步驟二：讓 Codex 記得 Vault 路徑

Codex 的全域指令檔預設位於：

```text
Windows：C:\Users\<你>\.codex\AGENTS.md
macOS / Linux：~/.codex/AGENTS.md
```

先讀取既有內容，再合併以下區塊：

```markdown
## Obsidian 筆記本固定路徑

主要 Obsidian Vault：

`<VAULT_PATH>`

當我說「Obsidian」、「Secondbrain」、「我的筆記本」或「第二大腦」時，預設指這個資料夾。

涉及筆記整理時，先讀取 Vault 根目錄的 `AGENTS.md`；實際讀寫透過已授權的資料夾或 Obsidian MCP。
```

如果 Vault 根目錄已有 `AGENTS.md`，先讀取並遵守。若沒有，可以在使用者確認後建立適合自己的筆記規則。

---

## 步驟三：選擇連線方式

| 方式 | 適合情況 | 特性 |
|---|---|---|
| A. 工作區／資料夾授權 | 主要在目前工作區直接改 Markdown | 不需額外安裝，但受目前可寫範圍限制 |
| B. MCPVault | 希望從不同專案穩定搜尋、讀寫 Vault | 需要 Node.js 與 MCP 設定，提供專門筆記工具 |

兩種方式可以並存。只要讀寫需求已由其中一種方式滿足，不必為了完成清單強迫安裝另一種。

---

## 方式 A：使用工作區或資料夾授權

在 Codex 中開啟 Vault 作為工作區，或把 Vault 加入允許讀寫的資料夾範圍。

先做唯讀驗證：

```powershell
Test-Path -LiteralPath "<VAULT_PATH>"
Get-ChildItem -LiteralPath "<VAULT_PATH>" -Force | Select-Object -First 10 Name
```

如需測試寫入，先取得使用者同意，再建立一篇清楚命名的測試筆記並讀回內容。完成後詢問要保留或刪除。

若從其他專案無法存取，代表目前資料夾授權範圍不足；可調整授權，或改用 MCPVault。

---

## 方式 B：使用 MCPVault

Codex Desktop、CLI 與 IDE 擴充可以共用同一份本機 MCP 設定。個人設定預設放在 `~/.codex/config.toml`；受信任的專案也可以使用 `.codex/config.toml`。

### B-1. 檢查 Node.js

```powershell
node --version
npm.cmd --version
```

若沒有 Node.js，詢問後安裝 LTS：

```powershell
winget install --id OpenJS.NodeJS.LTS --exact
```

### B-2. 安裝 MCPVault

詢問後執行：

```powershell
npm.cmd install -g @bitbonsai/mcpvault
```

找出執行檔：

```powershell
where.exe mcpvault
npm.cmd prefix -g
```

Windows 常見位置：

```text
C:\Users\<你>\AppData\Roaming\npm\mcpvault.cmd
```

### B-3. 加入 Codex MCP 設定

可使用任一方式：

1. Codex 設定中的 **MCP servers → Add server**，選擇 STDIO，填入執行檔與 Vault 參數。
2. 手動編輯 `~/.codex/config.toml`。
3. 使用 `codex mcp add`。

Windows TOML 範例：

```toml
[mcp_servers.obsidian]
command = "C:\\Users\\<你>\\AppData\\Roaming\\npm\\mcpvault.cmd"
args = ["<VAULT_PATH>"]
startup_timeout_sec = 20
tool_timeout_sec = 60
```

手動修改時只新增或更新 `[mcp_servers.obsidian]`，不要覆蓋其他 server。Windows TOML 路徑中的反斜線要寫成 `\\`。

CLI 形式：

```powershell
codex mcp add obsidian -- "C:\Users\<你>\AppData\Roaming\npm\mcpvault.cmd" "<VAULT_PATH>"
```

### B-4. 重啟並驗證

儲存設定後：

- Codex Desktop：在 MCP 設定中 Restart，或完全關閉後重開
- IDE 擴充：Restart extension 或 Reload Window
- CLI：結束目前 session，再重新啟動

可先檢查：

```powershell
codex mcp list
```

接著在 Codex 對話中測試：

1. 列出 Vault 根目錄。
2. 搜尋一個已知筆記標題。
3. 取得同意後建立測試筆記。
4. 讀回測試筆記。
5. 詢問要保留或刪除。

---

## 常見問題

| 狀況 | 檢查方式 |
|---|---|
| 找不到 Vault | 搜尋 `.obsidian`，並讓使用者選擇 |
| `AGENTS.md` 已寫路徑但仍不能讀寫 | 檢查工作區授權或 MCP 是否已連接 |
| `npm` 被 PowerShell 執行原則阻擋 | 改用 `npm.cmd` |
| `where.exe mcpvault` 找不到 | 用 `npm.cmd prefix -g` 找全域安裝位置 |
| MCP 工具沒有出現 | 檢查 TOML、執行檔路徑並重啟 Codex |
| 中文路徑顯示亂碼 | 用 UTF-8 重新讀取設定，並以實際工具測試為準 |
| 目前專案能讀、其他專案不能讀 | 檢查跨專案授權，或使用 MCPVault |

---

## 完成回報

```text
主要 Vault：<完整路徑>
全域 AGENTS.md：已設定 / 未設定
連線方式：資料夾授權 / MCPVault / 兩者
讀取驗證：成功 / 未執行 / 失敗
寫入驗證：成功 / 未執行 / 失敗
測試筆記：保留 / 已刪除 / 未建立
```

---

## 相關資源

- [Codex MCP 官方文件](https://developers.openai.com/codex/mcp)
