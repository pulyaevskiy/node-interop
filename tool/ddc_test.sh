#!/bin/sh

set -e

cd "$1"

pub run build_runner build --output=build/

for filename in test/*_test.dart; do
    node "build/$filename.js"
done
