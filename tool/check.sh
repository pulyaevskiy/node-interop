#!/bin/sh

set -e

cd "$1"

echo '> pub get ==========================================================='
dart pub get

if [ -f "package.json" ]; then
    echo '> npm install ======================================================'
    npm install
fi

if [ "$2" = "node" ]; then
# ddc disabled as tests are failing with dart 2.5-dev
#   echo "> pub run build_runner test (dartdevc) ============================="
#   dart pub run build_runner test --output=build/ -- -r expanded

    echo "> pub run test (dart2js) ==========================================="
    dart pub run test -r expanded
else
    echo "> pub run test (vm) ==============================================="
    dart pub run test -r expanded
fi

# Remove built sources to prevent from analyzing with dartfmt
rm -rf build/

echo "> dartfmt -n --set-exit-if-changed . =============================="
dartfmt -n --set-exit-if-changed .

echo "> dartanalyzer --fatal-infos --fatal-warnings . ==================="
dartanalyzer --fatal-infos --fatal-warnings .
