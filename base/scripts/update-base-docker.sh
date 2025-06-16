#!/bin/bash
git subtree pull --prefix=${1} git@github.com:dpldpc/base-docker-vazio.git main --squash
if [ $? -ne 0 ]; then
    echo "Failed to update ${1} subtree."
    exit 1
fi
echo "Successfully updated ${1} subtree."