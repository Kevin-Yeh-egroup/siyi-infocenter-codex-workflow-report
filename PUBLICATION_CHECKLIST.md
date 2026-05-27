# Publication Checklist

## Artifact

- Artifact name: 思宜需求分析與 Codex 自動化任務規劃
- Local entry: `index.html`
- Source note: `siyi-requirements-analysis.md`
- Status: `published production`

## Sensitivity

- Profile: public production with noindex controls
- External visibility risk: public GitHub repo and public Vercel URL are readable by anyone with access to the repo or URL
- Access control: none

## Noindex Controls

- [x] `index.html` includes `<meta name="robots" content="noindex,nofollow,noarchive">`
- [x] `robots.txt` disallows all crawlers
- [x] `vercel.json` sets `X-Robots-Tag: noindex, nofollow, noarchive`

## Approval Gates

- [x] Kevin approves public GitHub repository creation
- [x] Kevin approves pushing this content to GitHub
- [x] Kevin approves Vercel deployment
- [x] Kevin confirms whether URL may be shared with others

## Verification To Run After Deployment

- [x] HTTP status returns `200 OK`
- [x] Response headers include `X-Robots-Tag: noindex, nofollow, noarchive`
- [x] Page source includes meta robots noindex
- [x] `/robots.txt` returns `Disallow: /`
- [ ] Mobile and desktop layout checked
