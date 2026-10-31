# Deploy and Host Lightpanda on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/lightpanda-server?referralCode=sLjDXb&utm_medium=integration&utm_source=button&utm_campaign=lightpanda-server)

[Lightpanda](https://github.com/lightpanda-io/browser) is an open-source headless browser built for AI agents and scraping. It is written in Zig and isn't a Chromium fork: it runs JavaScript with V8 on a real DOM, but never renders pixels, so it starts instantly and uses a fraction of Chrome's memory. It speaks the Chrome DevTools Protocol (CDP), so Playwright, Puppeteer, chromedp, browser-use and Stagehand drive it like Chrome. This template runs a pinned Lightpanda release behind a token gate.

## About Hosting Lightpanda

- **Token-protected from the first second.** Lightpanda has no login of its own, and an open CDP port is a free remote browser for anyone who finds it. The gate rejects every request without `LIGHTPANDA_TOKEN`, which is generated at deploy. Send the token as a bearer header or as `?token=` in the URL.
- **No access to your private network.** Lightpanda starts with `--block-private-networks`. Pages can't reach `*.railway.internal`, private IP ranges or the cloud metadata address. Tested on Railway.
- **Works with `connectOverCDP` out of the box.** Lightpanda tells clients to connect to `ws://127.0.0.1:9222`. The gate rewrites `/json/version` so clients get your public `wss://` address instead.

## Common Use Cases

- A remote browser for browser-use, Stagehand, LangChain or your own Playwright agents, without running Chrome on your laptop or paying per browser-minute
- Scraping JavaScript-heavy sites at a fraction of Chrome's memory and cost
- Link previews, page monitoring and content extraction for apps already hosted on Railway
- Running many browser sessions in parallel on a small plan

## Dependencies for Lightpanda Hosting

- A CDP client: Playwright, Puppeteer, chromedp, browser-use, Stagehand or plain WebSockets

### Deployment Dependencies

- [Lightpanda on GitHub](https://github.com/lightpanda-io/browser)
- [Lightpanda docs](https://lightpanda.io/docs)
- [Template source on GitHub](https://github.com/two-workspaces/lightpanda)

### Implementation Details

Copy `LIGHTPANDA_TOKEN` from the service's Variables tab. Replace `<your-domain>` with the service's Railway domain.

**Playwright (Node).** Use the header form:

```js
import { chromium } from "playwright";

const browser = await chromium.connectOverCDP("https://<your-domain>", {
  headers: { Authorization: `Bearer ${process.env.LIGHTPANDA_TOKEN}` },
});
const context = await browser.newContext();
const page = await context.newPage();
await page.goto("https://news.ycombinator.com");
console.log(await page.locator(".titleline > a").first().textContent());
await browser.close();
```

**Puppeteer.** Use the WebSocket form:

```js
const browser = await puppeteer.connect({
  browserWSEndpoint: `wss://<your-domain>/?token=${process.env.LIGHTPANDA_TOKEN}`,
});
```

**Playwright (Python), browser-use and other URL-only tools.** Use the query form:

```python
browser = await p.chromium.connect_over_cdp("https://<your-domain>/?token=<LIGHTPANDA_TOKEN>")
```

**Tuning.** `LIGHTPANDA_ARGS` is passed to `lightpanda serve`. Examples: `--http-proxy socks5://...` to send traffic through a proxy, `--user-agent "..."`, `--obey-robots`, or `--cdp-max-connections 32` for more parallel sessions.

**Health.** `/health` is the only path that works without the token. Railway uses it as the healthcheck.

**Resources.** On Railway, Lightpanda idles at about 25 MB of RAM and stayed under 30 MB while Playwright and Puppeteer loaded pages. That fits every Railway plan, including Free.

Notes and limits:

- Lightpanda doesn't render, so screenshots and PDFs aren't available. Use a Chrome-based browser for those.
- Lightpanda's Web API coverage is still growing, so some complex web apps may behave differently than in Chrome.
- Each template update pins a newer Lightpanda release.

## Why Deploy Lightpanda on Railway?

Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying Lightpanda on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
