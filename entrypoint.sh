#!/bin/sh

set -v

cd $HOME
rm -f package-lock.json
yarn --network-concurrency 2 --network-timeout 600000
