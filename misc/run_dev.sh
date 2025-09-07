#!/usr/bin/env bash
set -euo pipefail

export PAT=
# --- Config (override via env) ---
OWNER="${OWNER:-stley}"
REPO="${REPO:-open-roleplay}"
TOKEN="${GITHUB_TOKEN:-${PAT:-}}"

if [[ -z "${TOKEN}" ]]; then
  echo "Error: set GITHUB_TOKEN (or PAT) with 'repo' scope." >&2
  exit 2
fi

PR_NUMBER="${1:-}"

WORKDIR="$(cd -- "$(dirname "$0")" && pwd)"
cd "$WORKDIR"

TMPDIR="$(mktemp -d)"
cleanup() { rm -rf "$TMPDIR"; }
trap cleanup EXIT

API="https://api.github.com/repos/${OWNER}/${REPO}/actions/artifacts?per_page=100"

if [[ -n "${PR_NUMBER}" ]]; then
  ARTIFACT="dev-pr-${PR_NUMBER}"
  echo "Fetching artifact for PR #$PR_NUMBER..."
else
  echo "No PR specified. Looking for most recent PR artifact..."
  # fetch the most recent artifact whose name starts with dev-pr-
  ARTIFACT="$(curl -fsSL -H "Authorization: Bearer ${TOKEN}" "$API" \
    | jq -r '.artifacts[] | select(.name|startswith("dev-pr-")) | select(.expired==false) | .name' \
    | head -n1)"
  if [[ -z "${ARTIFACT}" || "${ARTIFACT}" == "null" ]]; then
    echo "Error: no dev-pr-* artifact found." >&2
    exit 1
  fi
  echo "Using artifact: $ARTIFACT"
fi

# get download URL
URL="$(curl -fsSL -H "Authorization: Bearer ${TOKEN}" "$API" \
  | jq -r --arg n "$ARTIFACT" '.artifacts[] | select(.name==$n and .expired==false) | .archive_download_url' \
  | head -n1)"
if [[ -z "${URL}" || "${URL}" == "null" ]]; then
  echo "Error: artifact $ARTIFACT not found or expired." >&2
  exit 1
fi

ZIP="${TMPDIR}/artifact.zip"
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

# ---- Run server (wrapper) ----
#!/bin/sh
set -eu

DIR="$(cd -- "$(dirname "$0")" && pwd)"
# Prepend both libs/ and lib32/ to the library search path
export LD_LIBRARY_PATH="$DIR/libs:$DIR/lib32:${LD_LIBRARY_PATH-}"

echo "Esperando 5 segundos antes de lanzar el servidor..."
sleep 5

exec "$DIR/omp-server" "$@"
