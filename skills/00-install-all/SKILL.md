---
name: codex-install-all
description: 一次安裝所有 Codex 懶人包技能。說「全部安裝」「裝完所有 Codex 懶人包」時載入。
---

# 一次安裝全部（Codex 版）

> 本 Skill 會依序包含 GitHub 與 Obsidian，但兩者是完全分開的流程。若目前只要完成基礎環境、暫不處理 GitHub 帳號，請只安裝並執行 `codex-env-setup`，不要使用「全部安裝」。

依序載入：

1. codex-env-setup — 環境建置
2. codex-notebooklm — NotebookLM
3. codex-essentials — 必裝 Skills
4. codex-github — GitHub
5. codex-obsidian — Obsidian
6. codex-second-brain — 第二大腦
7. codex-supabase — Supabase
8. codex-firebase — Firebase
9. codex-ollama — Ollama
10. codex-gemini — Gemini
11. codex-workspace — 安裝三個工作 Skill，並提供專案初始化流程
12. startup-sync — 確認開工 Skill 已安裝；不要在安裝流程中執行開工
13. shutdown-sync — 確認收工 Skill 已安裝；不要在安裝流程中執行收工
14. project-init-sync — 確認初始化 Skill 已安裝；沒有專案資料時不要建立專案
15. codex-draw — 生圖
16. codex-chezmoi — 同步設定

每完成一個報告進度，最終總表：16 項各別狀態。三個工作 Skill 由 `codex-workspace` 安裝，後續項目只驗證存在與格式，不重複覆蓋。
