---
name: codex-github
description: Codex 連接 GitHub CLI。說「連接 GitHub」時載入。
---

# 連接 GitHub（Codex 版）

1. 依序檢查 `git --version`、`gh --version`；缺少工具時先詢問再安裝。
2. 執行 `gh auth status`；尚未登入時，詢問後使用 `gh auth login --web --git-protocol https`。
3. 顯示 Git 全域 `user.name`、`user.email`；需要修改時先取得使用者提供的值與同意。
4. 說明 GitHub CLI 與 GitHub App 是不同連線；只有需要在對話中查 repo、issue、PR 時才引導連接 App。
5. 優先用使用者指定的 repo 驗證 commit / push；若要建立測試 repo，先確認名稱與公開／私人設定。
6. 測試完成後詢問保留或刪除；未經明確確認不得刪除遠端 repo 或本機資料夾。

回報：Git 與 gh 版本、登入帳號、Git 使用者資訊、push 結果、GitHub App 狀態、測試資源處理結果。
