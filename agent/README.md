# Agent wrapper (bots / agents track)

Thin narrative layer around the official kit’s `perp-starter` (and optionally
`perp-guard`). The “agent” does **not** hold withdraw authority:

| Role | Key | Can do | Cannot do |
| --- | --- | --- | --- |
| DreamDEX account (`OWNER_ADDRESS`) | cold / app wallet | margin, leverage, withdraw | — |
| Bot / session key (`PRIVATE_KEY`) | hot EOA linked in app | place / cancel / reduce perps | withdraw or send funds |

## Flow

1. Human creates a fresh bot EOA and links it in [app.testnet.dreamdex.io](https://app.testnet.dreamdex.io) (**Link a bot** → Perps).
2. Human funds: STT/gas on the bot key; USDso moved Spot → Perps on the account (Perps Arena paper USDso is fine).
3. This folder’s `run.sh` starts `perp-starter` in dry-run, then (after you flip `DRY_RUN=false`) places a real Hideki testnet order.

Optional second process: `./run.sh guard` runs `perp-guard` to trim positions if margin health falls.

## Commands

```bash
# from repo root
./agent/run.sh doctor          # read-only markets + (if keyed) margin/link check
./agent/run.sh starter         # DRY_RUN=true by default via bot-kit/.env
./agent/run.sh guard           # optional health watcher
```

No private keys live in this directory — only env loading into `bot-kit/.env`.
