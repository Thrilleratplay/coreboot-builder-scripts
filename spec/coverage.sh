#!/bin/sh

cd ../

BUILD_PATH=$(find . -maxdepth 2 -type d | grep -F '/build' | sed 's/build/build\//' | paste -sd "," -)
COMPILE_FILES=$(find . -maxdepth 2 -type f -iname "compile.sh" | paste -sd "," -)

shellspec --kcov --kcov-options "--exclude-path=./spec,./coverage,$BUILD_PATH,$COMPILE_FILES"
