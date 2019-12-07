#!/bin/sh

TARGET_GIT_REV="${1}"

if [ "${TARGET_GIT_REV}" = "" ]; then
    echo "Supply a git revision to build for"
    exit 1
fi

echo "begin build for git revision ${TARGET_GIT_REV}"
echo "running 'npm run ${NPM_BUILD_CMD}'"
echo "expecting file output at ${DIST_DIR_NAME}"
echo "using ssh key ${SSH_KEY}"

eval "$(ssh-agent -s)"
ssh-add /root/.ssh/${SSH_KEY}

cd /app/repo
git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done

set -e

git fetch --all \
    && git checkout master \
    && git pull --all \
    && git checkout ${TARGET_GIT_REV}

npm run ${NPM_BUILD_CMD}

tar -czvf /app/output/${DIST_DIR_NAME}.${TARGET_GIT_REV}.tar.gz ${DIST_DIR_NAME}

git reset --hard
