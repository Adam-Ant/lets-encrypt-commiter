#!/bin/bash

set -euo pipefail

source "${VARS_PATH:-./vars.sh}"

# TODO: Verify all needed variables are set

if [ ! -r $CLOUDFLARE_CRED ]; then
  echo "Cloudflare configs missing!"
  exit 1;
fi


for i in ${DOMAINS[@]}; do
  if [ ! -d "$CERTPATH/live/$i" ]; then
    echo "WARN: Certificates for $i are missing. Creating...."
    certbot certonly -d ${i} -d "*.${i}" --dns-cloudflare --dns-cloudflare-credentials "${CLOUDFLARE_CRED}" -m "${CERT_EMAIL}" --agree-tos -n --config-dir "${CERTPATH}" --logs-dir /tmp --work-dir /tmp -q
  fi
done

certbot renew --post-hook $(pwd)/post-hook.sh --config-dir ${CERTPATH} --logs-dir /tmp --work-dir /tmp --disable-hook-validation -q
