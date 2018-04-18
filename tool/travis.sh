#!/bin/sh

set -e

cd "$1"

echo '> pub get ================================================================'
pub get

if [ -f "package.json" ]; then
    echo '> npm install ============================================================'
    npm install
fi

if [ "$2" == "node" ]; then
    echo "> pub run build_runner build (dartdevc) ============================="
    pub run build_runner build --output=build/

    echo "> pub run test -r expanded ==============================================="
    pub run test -r expanded --precompiled build/

    echo "> pub run build_runner build (dart2js) ============================="
    pub run build_runner build --define="build_node_compilers|entrypoint=compiler=dart2js" --output=build/

    echo "> pub run test -r expanded ==============================================="
    pub run test -r expanded --precompiled build/
else
    echo "> pub run test -r expanded ==============================================="
    pub run test -r expanded
fi


echo "> dartfmt -n --set-exit-if-changed . ====================================="
dartfmt -n --set-exit-if-changed .

echo "> dartanalyzer --fatal-infos --fatal-warnings . =========================="
dartanalyzer --fatal-infos --fatal-warnings .
