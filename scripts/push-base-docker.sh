#!/bin/bash
git subtree push --prefix=base-docker git@github.com:dpldpc/base-docker.git main
if [ $? -ne 0 ]; then
    echo "Failed to push base-docker subtree."
    exit 1
fi
echo "Successfully pushed base-docker subtree."