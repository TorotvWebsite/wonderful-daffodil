#!/usr/bin/env bash

set -e
set -o pipefail
set -v

initialGitHash=$(git rev-list --max-parents=0 HEAD)
node ./studio-build.js $initialGitHash &

curl -s -X POST https://api.stackbit.com/project/5f94bb4dcefacb001c010629/webhook/build/pull > /dev/null
npx @stackbit/stackbit-pull --stackbit-pull-api-url=https://api.stackbit.com/pull/5f94bb4dcefacb001c010629

curl -s -X POST https://api.stackbit.com/project/5f94bb4dcefacb001c010629/webhook/build/ssgbuild > /dev/null
jekyll build

# wait for studio-build.js
wait

curl -s -X POST https://api.stackbit.com/project/5f94bb4dcefacb001c010629/webhook/build/publish > /dev/null
echo "stackbit-build.sh: finished build"
