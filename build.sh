#!/usr/bin/env bash
# Script for building my resume.

set -e

export TMPL_BASE_DIR='src'
export TMPL_BLOCK_END_STR=']$'
export TMPL_BLOCK_START_STR='$['
export TMPL_COMMENT_END_STR="#]"
export TMPL_COMMENT_START_STR="[#"
export TMPL_LOG_FILE="build.log"
export TMPL_LOG_LEVEL="info"
export TMPL_LOG_MODE="overwrite"
export TMPL_VAR_END_STR="]]"
export TMPL_VAR_START_STR="[["

compiler="xelatex -halt-on-error"
file_name="tmpl/${1}.yaml"
output_dir="build/$1"

if [ "$#" -lt 1 ]; then
    echo 'USAGE: ./build.sh <conf basename>|clean [tmpl args ...]'
    echo 'EXAMPLE: ./build.sh cv -l debug'
    exit 0
fi

if [ "$1" == "clean" ]; then
    rm -rf build build.log
    exit 0
elif [ ! -f "tmpl/${1}.yaml" ]; then
    echo 'ERROR: Specified template configuration file does not exist!'
    exit 1
fi


if [ -f ./tmpl-binary ]; then
    tmpl='./tmpl-binary'
else
    tmpl='tmpl'
fi

cmd="$tmpl $file_name --delete --output"
if [ "$#" -gt 1 ]; then
    $cmd "$output_dir" "${@:2:$#}"
else
    $cmd "$output_dir"
fi

echo '  --> Compiling document...'
pushd "$output_dir" >/dev/null
if ! $compiler "${1}.tex" > compile.log 2>&1; then
    echo 'ERROR: Unable to compile document!'
    exit 2
fi
popd >/dev/null

if [ ! -d release ]; then
    mkdir release
fi

echo '  --> Copying release artifact...'
mv "$output_dir/${1}.pdf" release/
