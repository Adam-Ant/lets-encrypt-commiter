#!/bin/bash
set -euo pipefail

source "${VARS_PATH:-./vars.sh}"

export GIT_SSH_COMMAND="/usr/bin/ssh -qi ${GIT_SSH_KEY} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

git clone -q ${GIT_REPO} /tmp/puppet

cd /tmp/puppet

# TODO: Iterate through domains, only touch the one we're dealing with
rm -r /tmp/puppet/${GIT_CERTS_DEST}

cp -rL ${CERTPATH}/live/ /tmp/puppet/${GIT_CERTS_DEST}

git add ${GIT_CERTS_DEST}

git config user.name "${GIT_USER}"
git config user.email "${CERT_EMAIL}"
git config commit.gpgsign false

git commit -qm "${GIT_COMMITMSG}"

git push -q

rm -rf /tmp/puppet
