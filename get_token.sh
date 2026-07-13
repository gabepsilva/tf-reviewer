#!/usr/bin/env bash
# export GH_TOKEN=$(./get_token.sh)
# gh pr comment 1 --repo owner/repo --body "hello from the app"

cd "$(dirname "$0")"
set -a
source .env
set +a

APP_ID=$GITHUB_APP_ID
KEY=$GITHUB_PRIVATE_KEY_PATH

b64url() { openssl base64 -e -A | tr '+/' '-_' | tr -d '='; }

now=$(date +%s)
header=$(printf '{"alg":"RS256","typ":"JWT"}' | b64url)
payload=$(printf '{"iat":%d,"exp":%d,"iss":"%s"}' "$((now - 60))" "$((now + 540))" "$APP_ID" | b64url)
sig=$(printf '%s' "$header.$payload" | openssl dgst -sha256 -sign "$KEY" | b64url)
jwt="$header.$payload.$sig"

installation_id=$(curl -s \
  -H "Authorization: Bearer $jwt" \
  -H "Accept: application/vnd.github+json" \
  https://api.github.com/app/installations | jq '.[0].id')

curl -s -X POST \
  -H "Authorization: Bearer $jwt" \
  -H "Accept: application/vnd.github+json" \
  "https://api.github.com/app/installations/$installation_id/access_tokens" \
  | jq -r .token
