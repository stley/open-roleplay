#!/usr/bin/env bash
set -euo pipefail

export PAT=
# Config (override via env)
OWNER="${OWNER:-stley}"
REPO="${REPO:-open-roleplay}"
TOKEN="${GITHUB_TOKEN:-${PAT:-}}"
ARTIFACT="${ARTIFACT_NAME:-nightly-main}"

if [[ -z "${TOKEN}" ]]; then
  echo "Error: set GITHUB_TOKEN (or PAT) with 'repo' scope." >&2
  exit 2
fi

WORKDIR="$(cd -- "$(dirname "$0")" && pwd)"
cd "$WORKDIR"

# Fetch latest nightly artifact ZIP
TMPDIR="$(mktemp -d)"
cleanup() { rm -rf "$TMPDIR"; }
trap cleanup EXIT

API="https://api.github.com/repos/${OWNER}/${REPO}/actions/artifacts?per_page=100"
ZIP="${TMPDIR}/artifact.zip"
URL="$(curl -fsSL -H "Authorization: Bearer ${TOKEN}" "$API" \
  | jq -r --arg n "$ARTIFACT" '.artifacts[] | select(.name==$n and .expired==false) | .archive_download_url' \
  | head -n1)"
if [[ -z "${URL}" || "${URL}" == "null" ]]; then
  echo "Error: no artifact named '${ARTIFACT}' found." >&2
  exit 1
fi
curl -fsSL -H "Authorization: Bearer ${TOKEN}" -L "$URL" -o "$ZIP"

# Unpack and install main.amx into gamemodes/
UNZIP_DIR="${TMPDIR}/unz"
mkdir -p "$UNZIP_DIR"
unzip -q "$ZIP" -d "$UNZIP_DIR"

AMX_SRC="$(find "$UNZIP_DIR" -type f \( -name 'main.amx' -o -path '*/dist/main.amx' \) | head -n1 || true)"
if [[ -z "${AMX_SRC}" ]]; then
  echo "Error: main.amx not found inside artifact." >&2
  exit 1
fi

mkdir -p "${WORKDIR}/gamemodes"
rm -f "${WORKDIR}/gamemodes/"*.amx
cp -f "$AMX_SRC" "${WORKDIR}/gamemodes/main.amx"
echo "Installed gamemodes/main.amx from '${ARTIFACT}'."

# Deploy components/, plugins/, libs/ if present
for d in components plugins libs models; do
  src="$UNZIP_DIR/$d"
  if [[ -d "$src" ]]; then
    dst="$WORKDIR/$d"
    mkdir -p "$dst"
    # Copy everything
    cp -r -f "$src/"* "$dst/" 2>/dev/null || true
    # On Linux we don't need .dll, drop them
    find "$dst" -type f -name '*.dll' -delete
    echo "Copied $d/"
  fi
done

# Move run-offline.sh from misc/ if present
if [[ -f "$UNZIP_DIR/misc/run-offline.sh" ]]; then
  cp -f "$UNZIP_DIR/misc/run-offline.sh" "$WORKDIR/run-offline.sh"
  echo "Placed run-offline.sh at root"
fi

# ---- Run server (wrapper) ----
#!/bin/sh
set -eu

DIR="$(cd -- "$(dirname "$0")" && pwd)"
# Prepend both libs/ and lib32/ to the library search path
export LD_LIBRARY_PATH="$DIR/libs:$DIR/lib32:${LD_LIBRARY_PATH-}"

echo "Esperando 5 segundos antes de lanzar el servidor..."
sleep 5

exec "$DIR/omp-server" "$@"
