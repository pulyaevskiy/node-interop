#!/bin/sh

set -e

pushd $1

echo 'pub get =============================================================='
pub get

if [ -f "package.json" ]; then
    echo 'npm install =============================================================='
    npm install
fi

echo 'pub run test -p node -r expanded -j 1 ===================================='
pub run test -p node -r expanded -j 1

echo 'dartfmt -n --set-exit-if-changed . ======================================='
dartfmt -n --set-exit-if-changed .

echo "dartanalyzer --fatal-infos --fatal-warnings . ============================"
dartanalyzer --fatal-infos --fatal-warnings .