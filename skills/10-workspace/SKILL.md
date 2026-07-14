---
name: codex-workspace
description: 安裝並使用 Codex 專案工作模式，包括開工同步、收工同步與新專案初始化。當使用者說「初始化專案」、「老師建專案」、「安裝工作模式」或要補齊三個工作 Skill 時使用。
---

# 專案工作模式

## 安裝三個工作 Skill

1. 從 `assets/global-skills/` 讀取 `startup-sync`、`shutdown-sync`、`project-init-sync`。
2. 將缺少的 Skill 安裝到 `$HOME/.agents/skills/`。
3. 若目標已存在，先比較內容並詢問要保留、合併或備份後更新；不要直接覆蓋。
4. 確認每個目錄都有 `SKILL.md` 與 `agents/openai.yaml`，且預設提示包含正確的 `$skill-name`。
5. 安裝後提醒使用者重新啟動 Codex；若 Skill 已即時出現，可直接進行明確呼叫測試。

這三個 Skill 都是手動觸發，不建立排程或未經觸發自行動作。使用者說「收工」、「結束工作」或「整理並同步」時，視為授權 `shutdown-sync` 在安全檢查通過後自動 commit／push；使用者當次明確要求不要 push 時，優先服從。

## 初始化專案

1. 確認名稱、用途、資料夾、GitHub repo、公開或私人、部署需求、Obsidian vault 與 Firebase 使用狀態。
2. 將駕駛艙放在 Obsidian vault 根目錄，檔名固定為 `<專案名稱>-專案駕駛艙.md`；不要建立駕駛艙子資料夾。專案名稱優先採工作資料夾名稱或 repo slug。
3. 先盤點既有內容，再補齊 `AGENTS.md`、`README.md`、`.gitignore`、Git repo、選用的 GitHub repo 與 Obsidian 駕駛艙。若同名筆記已存在，先讀取並合併，不要覆寫。建立、補齊、移動或重新命名駕駛艙時，不要更新 Obsidian 的 `知識庫/log.md` 或其他全域操作紀錄。
4. 保留既有專案規則、歷史與無關變更。建立 GitHub、變更公開狀態、部署、一般初始化 commit／push 或刪除操作都要先取得使用者明確授權。
5. GitHub 帳號未另行指定時使用 `changyiwu`；可寫入的 `origin` 預設指向 `https://github.com/changyiwu/<repository>.git`，其他帳號的來源 repo 保留為 `upstream`。
6. 新 repo 與本機分支預設使用 `master`；使用者明確要求 commit 或 push 時直接同步 `origin/master`，不自行建立功能分支或 PR。
7. push 前抓取並確認遠端、工作區與提交範圍；遇到衝突、未預期遠端提交或分支保護時停止，不 force push。

## 開工與收工

- 開工：使用 `startup-sync`，讀 `AGENTS.md`、Obsidian 駕駛艙與 Git 狀態後回報；不要改動檔案或遠端。
- 收工：使用 `shutdown-sync`，檢查敏感資料、更新駕駛艙並提出提交範圍；「收工」本身就是安全檢查通過後 commit／push `origin/master` 的授權，不再重複詢問。推送成功後更新駕駛艙的 commit 與同步狀態。

回報安裝檔案、GitHub URL（若有）與 Obsidian 筆記路徑。
