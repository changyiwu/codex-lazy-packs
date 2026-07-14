---
name: codex-ollama
description: Codex 安裝本地 AI Ollama。說「安裝 Ollama」「本地 AI」時載入。
---

# 安裝本地 AI Ollama（Codex 版）

1. 下載：https://ollama.com/download
2. `ollama pull llama3.2:latest`
3. 測試：`ollama run llama3.2:latest "hello"`
4. 如需 Codex 調用：`codex mcp add ollama -- ...`

回報：版本、模型清單、GPU 狀態。
