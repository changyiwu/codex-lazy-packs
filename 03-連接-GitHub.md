# Codex 懶人包 #03：連接 GitHub

> 版本：v1.0（Codex Desktop / IDE / CLI）
> 更新日期：2026-07-14

這一章只處理 GitHub。完成後，Codex 可以在本機專案中使用 Git 與 GitHub CLI 建立 repo、commit、push；若另外連接 GitHub App，也可以在對話中讀取 repo、issue 與 pull request。

> [!important]
> GitHub CLI 與 GitHub App 是兩條不同的連線：
>
> - GitHub CLI（`gh`）：負責本機 repo、commit、push 與 GitHub 操作。
> - GitHub App / connector：讓 Codex 在對話中讀取 GitHub 資料。
>
---

## 完成標準

- [ ] `git --version` 正常
- [ ] `gh --version` 正常
- [ ] `gh auth status` 顯示正確帳號
- [ ] Git 的 `user.name` 與 `user.email` 已確認
- [ ] 已用既有 repo 或測試 repo 驗證 push
- [ ] 若需要在對話中查 GitHub，GitHub App 已連接

---

## 執行原則

請 Codex 一次只做一個步驟，完成後再繼續。

- 安裝軟體前先詢問。
- 修改 Git 全域姓名或 email 前先顯示現值並詢問。
- 建立 GitHub repo 前先確認名稱與公開／私人設定。
- 刪除 repo 或本機測試資料夾前必須再次確認。
- 不把 token、密碼或一次性驗證碼寫進 repo。

---

## 步驟一：檢查 Git 與 GitHub CLI

```powershell
git --version
gh --version
```

如果 Git 尚未安裝，詢問後執行：

```powershell
winget install --id Git.Git --accept-source-agreements --accept-package-agreements
```

如果 GitHub CLI 尚未安裝，詢問後執行：

```powershell
winget install --id GitHub.cli --accept-source-agreements --accept-package-agreements
```

安裝後若仍找不到指令，請完全關閉並重開 Codex 或 PowerShell。

---

## 步驟二：登入 GitHub CLI

先檢查：

```powershell
gh auth status
```

若尚未登入，詢問後執行：

```powershell
gh auth login --web --git-protocol https
```

使用者必須在瀏覽器完成 GitHub 授權。完成後再次檢查：

```powershell
gh auth status
```

確認畫面中的帳號正確，且 Git operations protocol 為 `https`。

> [!note]
> 若 Codex 讀取 GitHub CLI 設定時出現 `Access is denied`，可能是目前權限範圍無法讀取 GitHub CLI 設定，而不一定是登入失敗。請在使用者允許後重新檢查。

---

## 步驟三：確認 Git 使用者資訊

```powershell
git config --global user.name
git config --global user.email
```

若資料為空或不正確，先請使用者提供內容，再執行：

```powershell
git config --global user.name "你的姓名"
git config --global user.email "你的email@example.com"
```

若不想公開私人 email，可使用 GitHub 提供的 no-reply email。

---

## 步驟四：連接 GitHub App（選用）

如果只需要在本機 commit 與 push，可以略過這一步。

如果希望 Codex 在對話中查詢 repo、issue 或 pull request：

1. 打開 Codex／ChatGPT 的設定。
2. 在 Apps、Connectors 或 Integrations 中找到 GitHub。
3. 登入 GitHub，選擇帳號與允許存取的 repo。
4. 回到對話，請 Codex 列出可存取的 GitHub repo。

> [!important]
> `gh auth status` 成功不代表 GitHub App 已連接；GitHub App 能讀取 repo，也不代表本機 Git 已具備 push 權限。

---

## 步驟五：驗證 commit 與 push

優先使用使用者指定的既有測試專案。若沒有合適專案，再詢問是否建立臨時測試 repo。

### 建立臨時測試 repo

先確認 repo 名稱與可見性。以下以私人 repo `codex-github-test` 為例：

```powershell
$testRoot = Join-Path $env:USERPROFILE "Documents\codex-github-test"
New-Item -ItemType Directory -Path $testRoot -Force
Set-Location $testRoot
git init -b main
```

建立 `README.md`，內容可寫：

```markdown
# Codex GitHub 測試

如果這份文件出現在 GitHub，代表 commit 與 push 已成功。
```

接著執行：

```powershell
git add README.md
git commit -m "建立 Codex GitHub 連線測試"
gh repo create codex-github-test --private --source=. --remote=origin --push
gh repo view codex-github-test
```

成功標準：

- commit 建立成功
- remote 指向正確 GitHub repo
- push 成功
- `gh repo view` 可讀到 repo 資訊

### GitHub Pages（選用）

如果要發布靜態網頁，可在 repo 的 **Settings → Pages** 選擇從 `main` 分支部署。Pages 第一次發布可能需要幾分鐘；這不是 GitHub 連線的必要驗證。

---

## 步驟六：處理測試資源

驗證後必須詢問：

> GitHub 測試成功。遠端 repo 與本機測試資料夾要保留，還是刪除？

只有使用者明確要求時才能刪除。

刪除遠端 repo：

```powershell
gh repo delete <owner>/codex-github-test --yes
```

刪除本機資料夾前，先確認解析後的完整路徑就是預期的測試資料夾，再使用 PowerShell 的 `Remove-Item -LiteralPath`。

---

## 常見問題

| 狀況 | 檢查方式 |
|---|---|
| `gh auth status` 未登入 | 執行網頁登入後再檢查 |
| 登入帳號不正確 | 先登出錯誤帳號，再重新登入 |
| commit 顯示作者資料缺失 | 檢查 `user.name` 與 `user.email` |
| push 被拒絕 | 檢查帳號、repo 權限與 remote |
| GitHub App 找不到 repo | 檢查 App 是否獲准存取該 repo |
| GitHub App 能讀但不能 push | 回頭檢查本機 Git 與 `gh` 權限 |

---

## 完成回報

```text
Git：已安裝 / 未安裝
GitHub CLI：已安裝 / 未安裝
GitHub 帳號：<帳號>
Git 使用者資訊：已確認 / 待設定
push 驗證：成功 / 未執行 / 失敗
GitHub App：已連接 / 未連接 / 不需要
測試資源：保留 / 已刪除 / 未建立
```
