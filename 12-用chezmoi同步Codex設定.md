# Codex 懶人包 #12：用 chezmoi 同步 Codex 設定與收工技能

> 版本：v0.1（Codex 版）
> 更新日期：2026-04-26
> 適用：多台電腦都要使用同一套 Codex 全域規則與 skills

---

## 這個懶人包會幫你做什麼？

讓你把 Codex 的安全設定同步到多台電腦：

- `~/.codex/AGENTS.md`
- `~/.codex/skills/shutdown-sync/`

完成後，另一台電腦只要執行 `chezmoi update`，就能取得同一套「收工」流程。

> [!important]
> 不要整份同步 `~/.codex/`。
> `auth.json`、logs、state、cache、tmp 都是本機狀態或登入資訊，不應放進 GitHub。

---

## 先備條件

- [ ] 已有 GitHub 帳號
- [ ] 已有 chezmoi dotfiles repo，或準備建立一個
- [ ] 兩台電腦都已安裝 Codex
- [ ] 已完成想同步的 skill，例如 `shutdown-sync`

本範例使用：

```text
GitHub repo: mathruffian-dot/claude-config
chezmoi source: C:\Users\mathr\.local\share\chezmoi
```

其他使用者請改成自己的 repo 與路徑。

---

## 階段一：安裝 chezmoi

### Windows PowerShell

如果有 winget：

```powershell
winget install twpayne.chezmoi
```

如果沒有 winget，可以用官方安裝腳本，裝到使用者目錄：

```powershell
$script = Invoke-RestMethod -Uri 'https://get.chezmoi.io/ps1'
Invoke-Expression "& { $script } -b '$env:USERPROFILE\.local\bin'"
```

確認：

```powershell
& "$env:USERPROFILE\.local\bin\chezmoi.exe" --version
```

> [!tip]
> 如果 `chezmoi` 不在 PATH，可以先用完整路徑：
> `C:\Users\<使用者>\.local\bin\chezmoi.exe`

---

## 階段二：確認 chezmoi source repo

```powershell
& "$env:USERPROFILE\.local\bin\chezmoi.exe" source-path
```

檢查 GitHub 遠端：

```powershell
git -C "$env:USERPROFILE\.local\share\chezmoi" remote -v
```

如果還沒有初始化 chezmoi：

```powershell
& "$env:USERPROFILE\.local\bin\chezmoi.exe" init <你的 GitHub repo URL>
```

例如：

```powershell
& "$env:USERPROFILE\.local\bin\chezmoi.exe" init https://github.com/<帳號>/<repo>.git
```

---

## 階段三：納管 Codex 安全設定

建議納管：

| 檔案 / 資料夾 | 是否納管 | 原因 |
|---------------|----------|------|
| `~/.codex/AGENTS.md` | 是 | 全域偏好、觸發詞、固定規則 |
| `~/.codex/skills/shutdown-sync/` | 是 | 收工同步 skill |
| `~/.codex/config.toml` | 謹慎 | 含本機路徑、MCP、信任專案；建議做模板，不直接硬同步 |
| `~/.codex/auth.json` | 否 | 登入憑證 |
| `~/.codex/logs_*.sqlite` | 否 | 本機紀錄 |
| `~/.codex/state_*.sqlite` | 否 | 本機狀態 |
| `~/.codex/cache/`、`tmp/` | 否 | 快取與暫存 |

納管指令：

```powershell
& "$env:USERPROFILE\.local\bin\chezmoi.exe" add "$env:USERPROFILE\.codex\AGENTS.md"
& "$env:USERPROFILE\.local\bin\chezmoi.exe" add "$env:USERPROFILE\.codex\skills\shutdown-sync"
```

確認：

```powershell
& "$env:USERPROFILE\.local\bin\chezmoi.exe" status
git -C "$env:USERPROFILE\.local\share\chezmoi" status --short
```

chezmoi source 會出現：

```text
dot_codex/
├── AGENTS.md
└── skills/
    └── shutdown-sync/
        ├── SKILL.md
        └── agents/
            └── openai.yaml
```

---

## 階段四：提交並推送 dotfiles repo

```powershell
git -C "$env:USERPROFILE\.local\share\chezmoi" add dot_codex
git -C "$env:USERPROFILE\.local\share\chezmoi" commit -m "同步 Codex 收工技能"
git -C "$env:USERPROFILE\.local\share\chezmoi" push origin main
```

---

## 階段五：另一台電腦同步

另一台電腦先安裝 chezmoi，然後執行：

```powershell
& "$env:USERPROFILE\.local\bin\chezmoi.exe" init https://github.com/<帳號>/<repo>.git
& "$env:USERPROFILE\.local\bin\chezmoi.exe" apply
```

之後更新只要：

```powershell
& "$env:USERPROFILE\.local\bin\chezmoi.exe" update
```

完成後重啟 Codex，確認：

```text
C:\Users\<使用者>\.codex\AGENTS.md
C:\Users\<使用者>\.codex\skills\shutdown-sync\SKILL.md
```

---

## 階段六：另一台電腦還要補什麼？

chezmoi 只同步「安全設定」。另一台電腦仍需要自己設定：

1. Codex 登入
2. Obsidian vault 實際路徑
3. #03 的 Obsidian MCP 或資料夾授權
4. GitHub 登入 / SSH / token

尤其是 `~/.codex/config.toml`：

- 可以做模板
- 不建議直接整份硬同步
- 因為每台電腦的路徑、MCP command、trusted projects 可能不同

---

## 本次三師爸實測

已完成：

- 安裝 chezmoi `v2.70.2` 到 `C:\Users\mathr\.local\bin\chezmoi.exe`
- source repo：`C:\Users\mathr\.local\share\chezmoi`
- GitHub repo：`mathruffian-dot/claude-config`
- 納管：
  - `dot_codex/AGENTS.md`
  - `dot_codex/skills/shutdown-sync/SKILL.md`
  - `dot_codex/skills/shutdown-sync/agents/openai.yaml`
- commit：`a9e401f 同步 Codex 收工技能`
- 已推送到 GitHub

---

## 踩坑筆記

### 踩坑 1：PowerShell 找不到 `chezmoi`

症狀：

```text
chezmoi : 無法辨識 'chezmoi' 詞彙
```

解法：

- 先找是否已安裝：`where.exe chezmoi`
- 若沒有，使用官方 PowerShell 安裝腳本
- 安裝到 `~/.local/bin` 後，用完整路徑執行

### 踩坑 2：chezmoi 設定資料夾在 sandbox 外

症狀：

```text
chezmoi: open C:/Users/<使用者>/.config/chezmoi: Access is denied.
```

原因：

Codex sandbox 沒有直接讀寫 `~/.config/chezmoi` 的權限。

解法：

在 Codex 中授權執行 chezmoi 指令，或在本機終端機執行。

### 踩坑 3：不要同步整個 `~/.codex`

整個 `~/.codex` 內含登入、快取、資料庫、session。同步整包很容易造成：

- 另一台電腦登入狀態混亂
- 本機路徑不一致
- 敏感資訊外洩

解法：

只同步明確安全的檔案：`AGENTS.md` 與特定 skill。

---

## 相關連結

- [chezmoi 官方安裝文件](https://www.chezmoi.io/install/)
- [chezmoi Windows 文件](https://www.chezmoi.io/user-guide/machines/windows/)
- [Codex AGENTS.md 官方文件](https://developers.openai.com/codex/guides/agents-md)
