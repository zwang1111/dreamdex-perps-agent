#!/usr/bin/env bash
# Thin agent entrypoint → official dreamdex-bot-kit perp strategies.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
KIT="$ROOT/bot-kit"
CMD="${1:-starter}"

if [[ ! -d "$KIT" ]]; then
  echo "missing bot-kit at $KIT — clone https://github.com/somnia-chain/dreamdex-bot-kit" >&2
  exit 1
fi

if [[ ! -d "$KIT/node_modules" ]]; then
  echo "Installing bot-kit deps…"
  (cd "$KIT" && npm install)
fi

# Prefer repo-root .env.example guidance: real secrets go in bot-kit/.env (gitignored).
if [[ ! -f "$KIT/.env" && -f "$ROOT/.env.example" ]]; then
  echo "No bot-kit/.env yet. Copy placeholders:"
  echo "  cp $ROOT/.env.example $KIT/.env"
  echo "Then fill PRIVATE_KEY (bot key) + OWNER_ADDRESS (DreamDEX account). Keep DRY_RUN=true."
fi

cd "$KIT"
export NETWORK="${NETWORK:-hideki}"

case "$CMD" in
  doctor)
    exec npm run perp:doctor
    ;;
  starter|perp-starter|start)
    exec npm start -w perp-starter
    ;;
  guard|perp-guard)
    exec npm start -w perp-guard
    ;;
  *)
    echo "usage: $0 {doctor|starter|guard}" >&2
    exit 2
    ;;
esac
