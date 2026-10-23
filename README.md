# dreamDEX Perps Agent (MVP)

**Track:** DoraHacks [dreamDEX Perps Builder Bounty](https://dorahacks.io/hackathon/dreamdex-perps-bounty/detail) — **bots and agents**  
**Network:** Somnia **Hideki / Tokyo testnet** (chain `50383`) — **no mainnet funds**  
**Upstream kit:** [somnia-chain/dreamdex-bot-kit](https://github.com/somnia-chain/dreamdex-bot-kit) (`strategies/perp-starter`, optional `perp-guard`)

## What this is

A small **agent** that places and manages DreamDEX perpetual orders through a **limited bot key**:

- Your DreamDEX account holds margin and can withdraw.
- The bot key (linked in the app) can **place / cancel / reduce** perps only — **never withdraw**.
- Primary strategy: official **`perp-starter`** (one position + take-profit / stop-loss watch).
- Optional: **`perp-guard`** trims positions when margin health falls.

Built for competent operators who want a clear, auditable path from kit → linked session key → real **testnet** fills.

## Who it’s for

Builders and agents who need a reproducible Hideki perps bot with session-key hygiene, not a black-box trading product.

## How to run

```bash
# 1) Ensure bot-kit is present (this workspace already clones it)
git clone --depth 1 https://github.com/somnia-chain/dreamdex-bot-kit.git bot-kit   # if missing
cd bot-kit && npm install && cd ..

# 2) Env (placeholders only in git)
cp .env.example bot-kit/.env
# Edit bot-kit/.env: PRIVATE_KEY=bot key, OWNER_ADDRESS=your DreamDEX account, NETWORK=hideki, DRY_RUN=true

# 3) Doctor (read-only markets; with key → margin + link)
./agent/run.sh doctor

# 4) Dry-run starter
./agent/run.sh starter

# 5) After funding + link: set DRY_RUN=false in bot-kit/.env, re-run starter
```

App: [https://app.testnet.dreamdex.io](https://app.testnet.dreamdex.io) — Link a bot → Perps; move USDso via **Perps ⇆ Spot**.  
See [STATUS.md](./STATUS.md) for faucet notes and [bot-kit/docs/perps.md](./bot-kit/docs/perps.md) for protocol details.

## Proof of testnet trading (fill after live run)

| Item | Value |
| --- | --- |
| Network | Hideki (50383) |
| Market | _e.g. ETH-PERP_ |
| Tx hash(es) | `_TODO_` |
| Explorer | `_TODO_` |
| Timestamp (Asia/Shanghai) | `_TODO_` |

## X posts (placeholders — post only after user confirms channel)

Drafts tagging **@DreamDEXSomnia** (2–3 posts for bounty README):

1. `_TODO: MVP demo — linked bot key opens a Hideki perps position via dreamdex-bot-kit perp-starter. tx: … @DreamDEXSomnia_`
2. `_TODO: Session-key agent: place/cancel only, no withdraw. Repo: … @DreamDEXSomnia_`
3. `_TODO: optional third post with short clip / doctor output @DreamDEXSomnia_`

## Layout

```
.
├── README.md          ← you are here
├── STATUS.md          ← install/run log + blockers
├── PLAN.md            ← bounty checklist
├── .env.example       ← copy → bot-kit/.env (never commit secrets)
├── agent/             ← thin runner (doctor | starter | guard)
└── bot-kit/           ← upstream dreamdex-bot-kit (keep origin → somnia-chain)
```

## Safety

- Testnet only for this MVP. Do not set mainnet keys or spend real money without explicit confirmation.
- Never commit `.env`, seed phrases, or funded private keys.
- Prefer a dedicated bot EOA linked in the app over your primary wallet key.

## License / attribution

Trading strategies and client code under `bot-kit/` are from DreamDEX’s MIT-licensed [dreamdex-bot-kit](https://github.com/somnia-chain/dreamdex-bot-kit). This wrapper is scaffolding for the bounty submission.
