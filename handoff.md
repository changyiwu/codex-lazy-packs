# 交接檔（handoff.md）

## ⏯️ 目前做到哪

已修正 Skill 安裝命名流程：repo 內仍保留 `skills/00-env-setup` 等編號資料夾；安裝到 `~/.agents/skills/` 時使用 frontmatter 的 `codex-env-setup` 等正式名稱。入口 Skill 已明定 `npx skills add --agent codex`，GitHub helper fallback 則必須逐項傳入 `--name`。

## 🚦 目前狀態

- `scripts/validate-lazy-pack.ps1` 與 `git diff --check` 已通過。
- 教學章節現為 10 章（#00–#09），可直接安裝的 Skills 現為 11 個。
- `npx skills add . --full-depth --list` 已確認顯示 11 個 `codex-*` Skills，加上根入口共 12 個。
- 本機專案安裝與 GitHub helper `--name` fallback 都已實測產生 `codex-env-setup`，不會產生 `00-env-setup`。
- 11 個 Skills 已通過 Skill Creator `quick_validate.py`。
- 這台電腦原有的 7 個編號全域 Skill 資料夾已原地改名為對應的 `codex-*` 名稱，並驗證資料夾名與 frontmatter `name` 一致。

## ➡️ 下一步

1. 從 GitHub repo 重跑一次全域安裝，確認遠端版本落在 `~/.agents/skills/codex-*`。

## ⚠️ 注意事項

- 不要恢復已移除的第二大腦或 chezmoi 章節與 Skill。
- repo 內的 Skill 資料夾必須保留編號前綴；只有全域安裝目的地使用 `codex-*`。
- 使用內建 GitHub skill-installer helper 時，不能批次省略 `--name`。
- 修改任何懶人包或 Skill 後必須重跑發布驗證。

## 🕐 最後更新

- 時間：2026-07-23 12:13
- 更新者：Codex @ PC-YI-FY
- Git push：✅ 已推（本次 Skill 安裝命名修正）
