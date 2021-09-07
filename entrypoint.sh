#!/bin/bash
set -e

# Set up ssh known hosts and agent
ssh-keyscan -t rsa github.com >> /etc/ssh/ssh_known_hosts
eval `ssh-agent -s`
ssh-add - <<< "$SSH_PRIVATE_KEY"

git remote add upstream git@github.com:$TARGET_ORG/$TARGET_REPO.git
git fetch upstream
git replace PARENT_COMMIT_ONE PRE_MIGRATION_COMMIT
git replace PARENT_COMMIT_TWO PRE_MIGRATION_COMMIT

# split single parameter of this script into multiple params for the command
eval "set -- $1"
git-filter-repo "$@" --refs PRE_MIGRATION_COMMIT..HEAD
git rebase PRE_MIGRATION_COMMIT

git push "git@github.com:$TARGET_ORG/$TARGET_REPO.git" HEAD:"$TARGET_BRANCH"