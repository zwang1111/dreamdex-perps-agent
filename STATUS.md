# STATUS — dreamDEX Perps Builder Bounty MVP (bots/agents)

Last updated: 2026-10-23 Asia/Shanghai

## Local layout

| Path | Role |
| --- | --- |
| `/workspace/dreamdex-perps/PLAN.md` | Bounty plan / acceptance |
| `/workspace/dreamdex-perps/BOT_KIT_README.md` | Upstream README mirror |
| `/workspace/dreamdex-perps/bot-kit/` | Clone of `somnia-chain/dreamdex-bot-kit` (remote `origin` → upstream) |
| `/workspace/dreamdex-perps/agent/` | Thin wrapper: doctor / perp-starter / perp-guard |
| `/workspace/dreamdex-perps/.env.example` | Placeholders only — copy to `bot-kit/.env` |
| `/workspace/dreamdex-perps/README.md` | Public-repo skeleton |
| `/workspace/dreamdex-perps/STATUS.md` | This file |

Upstream HEAD at scaffold time: `2579866` — `fix(perp): point a linked bot's empty Perps balance at Perps ⇆ Spot`.

## What was installed

- `git clone --depth 1 https://github.com/somnia-chain/dreamdex-bot-kit.git` → `bot-kit/`
- `npm install` at kit root (workspaces: `packages/*`, `strategies/*`, …)
- postinstall built `@dreamdex-bot-kit/core` and `@dreamdex-bot-kit/backtest` via `tsc`
- Node `v22.23.3`, npm `10.9.9`
- **No** Python env required for perp-starter (TS + `@dreamdex-bot-kit/perp-core`)

## Dry config / run results (succeeded)

### `npm run perp:doctor` (`NETWORK=hideki`, no key)

- Chain **50383** (Hideki), indexer `https://hideki-dev.smk.somnia.host/v1/graphql`
- **21 live** markets (BTC-PERP, ETH-PERP, SOL-PERP, …)
- Exit 0

### `npm start -w perp-starter` (`DRY_RUN=true`, no key)

```
perp-starter on BTC-PERP … | dry-run true
read-only: no PRIVATE_KEY, so nothing will be sent.
[dry-run] would place open long …
[dry-run] would arm a long bracket …
```

Exit 0. Live trading blocked until `PRIVATE_KEY` + funding + `DRY_RUN=false`.

## How to run perp-starter

```bash
cd /workspace/dreamdex-perps
cp .env.example bot-kit/.env   # then edit placeholders — never commit .env
./agent/run.sh doctor          # markets + (once keyed) margin / link check
./agent/run.sh starter         # dry-run by default
# After link + faucet + margin: set DRY_RUN=false in bot-kit/.env, re-run starter
```

Or from kit:

```bash
cd bot-kit
npm run perp:doctor
npm start -w perp-starter
# optional: npm start -w perp-guard
```

## Env vars needed (never invent real keys)

| Var | Purpose |
| --- | --- |
| `PRIVATE_KEY` | **Bot / session** EOA only (linked in app). Not the funded withdraw wallet. |
| `OWNER_ADDRESS` | DreamDEX account the bot is linked to (trading-key mode). |
| `NETWORK` | `hideki` (default for perps; Tokyo / Perps Arena). |
| `DRY_RUN` | Keep `true` until ready; `false` sends real testnet orders. |
| `PERP_SYMBOL` | e.g. `ETH-PERP` / `BTC-PERP` (app-canonical name). |
| `PERP_SIDE` | `long` / `short` |
| `PERP_LEVERAGE` | Informational vs account setting in trading-key mode (app owns leverage). |
| `PERP_NOTIONAL_USDSO` | **Position value**, not margin (e.g. 20 at 2x ≈ 10 margin). |
| `PERP_TAKE_PROFIT_PCT` / `PERP_STOP_LOSS_PCT` | Bracket % (watched by bot when `OWNER_ADDRESS` set — cannot arm protocol stops for owner). |
| `PERP_TICK_MS` | Poll interval |

Hideki RPC default in kit: `https://api.hideki2.infra.testnet.somnia.network` (not Shannon’s `https://dream-rpc.somnia.network`).

## Faucet / testnet funding steps (human / browser)

1. Open **[https://app.testnet.dreamdex.io](https://app.testnet.dreamdex.io)** (Perps Arena / paper USDso).
2. Connect (or create) your DreamDEX account wallet — this becomes `OWNER_ADDRESS`.
3. Create a **separate** bot EOA (`cast wallet new` or wallet UI). Note address + private key **only** in local `bot-kit/.env`.
4. In the app: wallet → **Link a bot** → paste bot address → keep **Perps** ticked → **Add bot**. Optionally send the bot some STT for gas from that screen.
5. Fund **gas** on the bot key (STT / Hideki native as shown in app). Shannon faucet for other networks: [https://testnet.somnia.network](https://testnet.somnia.network) — confirm Hideki gas asset in the app if different.
6. Fund **margin**: get USDso (Perps Arena paper / testnet faucet paths in app) on Spot, then **Perps ⇆ Spot** → move USDso into **Perps account**. Orders use MarginBank, not spot auto-pull.
7. Set account **leverage** in the app (bot does not change it in trading-key mode).
8. `./agent/run.sh doctor` until link + free collateral look good.
9. Keep `DRY_RUN=true` one more pass, then `DRY_RUN=false` for a small `PERP_NOTIONAL_USDSO` (e.g. 20) on `ETH-PERP`.
10. Record **tx hashes** for README / bounty proof. Still **no mainnet**; no spending real money without user confirm.

## GitHub

- Outward account: **zwang1111**
- Public repo: https://github.com/zwang1111/dreamdex-perps-agent (`main` @ `45233f1`)
- `agenttab-push` PAT now includes this repo (Contents R/W). Create-repo still not on token; empty repo was created in UI then pushed.

## Blockers

1. **No bot key / owner address yet** — human must create + link in app.testnet.dreamdex.io.
2. **No testnet margin / gas yet** — faucet + Perps ⇆ Spot transfer required before live orders.
3. **GitHub create/push blocked** by token scope (403).
4. **DoraHacks / Discord whitelist** — handled by parent; not done here.
5. **X posts @DreamDEXSomnia** — placeholders in README; do not post until user confirms channel.
6. Live `DRY_RUN=false` run and tx-hash collection — waiting on (1)+(2).

## Next human/browser steps (ordered)

1. Create bot key; link at app.testnet.dreamdex.io; fund gas + Perps USDso.
2. Fill `bot-kit/.env` from `.env.example`; run `./agent/run.sh doctor` then dry `starter`.
3. Flip `DRY_RUN=false`; capture tx hash(es).
4. Create empty public repo `zwang1111/dreamdex-perps-agent` (UI or token with create scope); then push this tree (exclude secrets; decide whether to vendor `bot-kit` or submodule upstream).
5. Parent: Discord whitelist + DoraHacks Build when ready; X posts with user confirm.
