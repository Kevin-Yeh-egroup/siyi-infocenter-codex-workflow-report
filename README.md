# 思宜需求分析與 Codex 自動化任務規劃

這是一個免建置的靜態報告網站，用於跨裝置檢視「思宜需求分析與 Codex 自動化任務規劃」。

## 本機檢視

直接開啟 `index.html` 即可檢視。若要部署到 Vercel，根目錄已包含：

- `index.html`
- `robots.txt`
- `vercel.json`
- `PUBLICATION_CHECKLIST.md`

## 發布狀態

目前狀態：`publish-ready draft`

搜尋索引控制已啟用：

- HTML meta robots: `noindex,nofollow,noarchive`
- `robots.txt`: `Disallow: /`
- Vercel header: `X-Robots-Tag: noindex, nofollow, noarchive`

注意：這些設定不是權限控管。若內容不能被非預期讀者看到，請改用 private-preview 或保留本機。
