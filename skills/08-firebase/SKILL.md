---
name: codex-firebase
description: Codex 連接 Firebase MCP。說「連接 Firebase」時載入。
---

# 連接 Firebase（Codex 版）

1. 檢查 Node.js 是否為仍受支援的 LTS，再安裝 Firebase CLI 並登入。
2. 讓使用者選擇 Firebase 專案與本機專案目錄。先保留既有 `firebase.json`、`.firebaserc` 與安全規則。
3. 若缺少本機情境，建立 `.firebaserc`、`firebase.json` 與預設拒絕所有讀寫的 `firestore.rules`。不要部署規則。
4. 設定 Firebase MCP：
   - GUI：在參數加入 `--dir` 與含 `firebase.json` 的絕對路徑。
   - `config.toml`：為 STDIO server 設定 `cwd`，並使用 `default_tools_approval_mode = "writes"`。
5. 重啟後先唯讀驗證專案目錄、登入帳號、Active Project ID、Firestore 資料庫與集合。
6. 只有在使用者明確同意後，才建立唯一 ID 的測試文件；讀回後只刪除該測試文件。

## 安全規則

- 不要在連線流程中自動部署 Firestore 規則。
- 公開讀寫白名單只能用於使用者明確同意的課堂 Demo，部署前顯示差異，結束後還原拒絕規則。
- Admin SDK 憑證不可公開；學生資料只存代號，不存姓名。
- 若只出現 Firebase 核心工具，先修正 `cwd` 或 `--dir`，再重啟 Codex。
