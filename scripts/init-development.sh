#!/bin/bash

LOCALDIR=$(dirname "$0")
cd $LOCALDIR

../setup_gitflow.sh
../docker/development/d_down.sh
../docker/development/d_gencerts.sh
../docker/development/d_build.sh





