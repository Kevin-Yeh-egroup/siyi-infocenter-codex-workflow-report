# Publication Checklist

## Artifact

- Artifact name: 思宜需求分析與 Codex 自動化任務規劃
- Local entry: `index.html`
- Source note: `siyi-requirements-analysis.md`
- Status: `publish-ready draft`

## Sensitivity

- Proposed profile: public-with-noindex review, pending Kevin approval
- External visibility risk: public GitHub repo and public Vercel URL are readable by anyone with access to the repo or URL
- Access control: none

## Noindex Controls

- [x] `index.html` includes `<meta name="robots" content="noindex,nofollow,noarchive">`
- [x] `robots.txt` disallows all crawlers
- [x] `vercel.json` sets `X-Robots-Tag: noindex, nofollow, noarchive`

## Approval Gates

- [ ] Kevin approves public GitHub repository creation
- [ ] Kevin approves pushing this content to GitHub
- [ ] Kevin approves Vercel deployment
- [ ] Kevin confirms whether URL may be shared with others

## Verification To Run After Deployment

- [ ] HTTP status returns `200 OK`
- [ ] Response headers include `X-Robots-Tag: noindex, nofollow, noarchive`
- [ ] Page source includes meta robots noindex
- [ ] `/robots.txt` returns `Disallow: /`
- [ ] Mobile and desktop layout checked
