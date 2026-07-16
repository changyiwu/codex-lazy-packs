# AGENTS.md — codex-lazy-packs

## 這個資料夾是什麼

這是公開發布到 GitHub 的 **Codex 懶人包**倉庫，對應 repo：
**changyiwu/codex-lazy-packs**

本資料夾與 `claude-code-lazy-packs/` 是**平行版本**：同樣的教學流程，分別給 Claude Code 與 OpenAI Codex（**Desktop / IDE / CLI 三者通用**）使用。

## 專案入口與主要檔案

- 使用者入口：`README.md`
- Skill 安裝入口：`SKILL.md`
- 教學章節：根目錄的編號 Markdown 檔案
- 可安裝技能：`skills/`
- 發布前驗證：`scripts/validate-lazy-pack.ps1`
- GitHub：<https://github.com/changyiwu/codex-lazy-packs>
- 部署：目前不在初始化流程中啟用 GitHub Pages 或其他部署

## 主要敘事視角

懶人包以 **Codex Desktop app**（macOS / Windows）為主軸寫作，因為這是大多數老師的入口。但因為 Desktop / IDE 擴充 / CLI 三者**共用 `~/.codex/config.toml` 與 `AGENTS.md`**，每個 MCP 章節都同時提供三條路：
1. Desktop GUI（Integrations & MCP 面板）
2. 手動編輯 `~/.codex/config.toml`
3. CLI 指令

## 第二大腦 Vault

- Vault 路徑：`C:\Users\chang\我的雲端硬碟\2ndbrain`
- 結構：`每日筆記/` → `創作庫/` → `知識庫/`
- 本專案駕駛艙：`codex-lazy-packs-專案駕駛艙.md`

## 雙倉同步原則

- **不要**把 Codex 版直接 copy 過來；MCP 指令、設定檔格式、Skill 機制都不同
- 修改主流程（例如某 MCP 換新版指令）時，兩個資料夾都要更新
- 改完 push 到各自的 GitHub repo

## 提醒 Codex

- 使用者說「更新 Codex 懶人包」時 → 只動本資料夾
- 使用者說「兩邊都更新」時 → 兩個資料夾都改，commit 訊息分別寫

## 安全邊界

- 不提交 `.env`、API Key、token、密碼、憑證或個人本機代理設定
- 未經使用者明確要求，不建立或連接 GitHub 遠端、不提交、不推送、不啟用 Pages、不部署
- 不修改 Firebase 安全規則；本專案目前沒有連結 Firebase 專案
- 修改教學章節或 Skill 後，先執行 `scripts/validate-lazy-pack.ps1`
