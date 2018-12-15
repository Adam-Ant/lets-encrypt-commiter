#!/bin/bash
set -euxo pipefail

source vars.sh


#GIT_HOST=$(echo "$GIT_REPO" |  grep -oP "(?<=\@).*?(?=\:)")
# Yes this is really ugly. Shhhhhh
#ssh-keygen -F "${GIT_HOST}"  > /dev/null || ssh-keyscan "${GIT_HOST}" >>~/.ssh/known_hosts

#ssh-agent sh -c "ssh-add ~/deploy-key; git clone ${GIT_REPO}"

export GIT_SSH_COMMAND="/usr/bin/ssh -i ~/deploy-key -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

git clone ${GIT_REPO} /tmp/puppet

cd /tmp/puppet

# TODO: Iterate through domains, only touch the one we're dealing with
rm -r /tmp/puppet/${GIT_CERTS_DEST}

cp -rL ${CERTPATH}/live/ /tmp/puppet/${GIT_CERTS_DEST}

git add ${GIT_CERTS_DEST}

git config user.name "${GIT_USER}"
git config user.email "${CERT_EMAIL}"
git config commit.gpgsign false

git commit -m "${GIT_COMMITMSG}"

git push

rm -rf /tmp/puppet
