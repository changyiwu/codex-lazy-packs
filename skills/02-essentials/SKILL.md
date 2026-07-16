---
name: codex-essentials
description: Codex 初學者必裝 Skills 與 Plugins。說「裝基本外掛」「新手設定」時載入。
---

# Codex 初學者必裝（Skills + Plugins）

先檢查，不要一開始大量安裝。缺少任何工具或外掛時，先說明用途並取得使用者同意。

## 步驟一：基礎工具快篩

檢查 `git --version`、`gh --version`、`node --version`、`uv --version`，整理各項狀態與用途。缺少工具時依作業系統提供安裝方式；Node.js 使用仍受支援的 LTS。

## 步驟二：檢查 Skills

檢查 `$HOME/.codex/skills/` 與 Codex 目前可用的 Skills，優先確認：

- `imagegen`：生成或修改圖片
- `openai-docs`：查詢 OpenAI／Codex 官方文件
- `skill-installer`：安裝 Skills
- `skill-creator`：建立 Skills

## 步驟三：檢查 Plugins

優先確認 Codex Desktop 的外掛程式清單是否已有：

- GitHub
- Browser
- Documents
- Presentations
- Spreadsheets

缺少時，引導使用者從 Codex Desktop 的 Plugins 介面安裝或啟用。不要在已有官方 GitHub Plugin 的情況下，改裝舊式或非必要的 GitHub MCP server。

GitHub CLI 與 GitHub Plugin 是兩種不同能力：`gh` 用於本機 Git／push／建立 repo；Plugin 用於對話中讀取 repo、issue 與 PR。

Gmail、Google Calendar、Obsidian 與其他 MCP 屬於有需要再連接的進階項目；涉及個人資料時要先取得使用者同意。

## 完成回報

以表格列出基礎工具、Skills、Plugins 的已安裝／缺少／未啟用狀態，以及本次實際做過的變更。逐項測試已新增的能力並回報成功或失敗；未經同意不得安裝額外工具。
