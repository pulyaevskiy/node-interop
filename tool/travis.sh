#!/bin/sh

set -e

cd "$1"

echo "> Entered package: $1"
echo '> pub get ==========================================================='
pub get

if [ -f "package.json" ]; then
    echo '> npm install ======================================================'
    npm install
fi

if [ "$2" = "node" ]; then
    echo "> pub run build_runner test (dartdevc) ============================="
    pub run build_runner test --output=build/ -- -r expanded

    echo "> pub run test (dart2js) ==========================================="
    if [ -f "test/all_test.dart" ]; then
        # Workaround for dart2js failing to compile multiple tests on Travis.
        pub run test -r expanded test/all_test.dart
    else
        pub run test -r expanded
    fi
else
    echo "> pub run test (vm) ==============================================="
    pub run test -r expanded
fi

# Remove built sources to prevent from analyzing with dartfmt
rm -rf build/

echo "> dartfmt -n --set-exit-if-changed . =============================="
dartfmt -n --set-exit-if-changed .

echo "> dartanalyzer --fatal-infos --fatal-warnings . ==================="
dartanalyzer --fatal-infos --fatal-warnings .
