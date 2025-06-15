#!/bin/bash
git subtree pull --prefix=base-docker git@github.com:dpldpc/base-docker.git main --squash
if [ $? -ne 0 ]; then
    echo "Failed to update base-docker subtree."
    exit 1
fi
echo "Successfully updated base-docker subtree."