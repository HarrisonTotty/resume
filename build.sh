#!/bin/bash
# Script for building my resume.

set -e

export TMPL_BLOCK_END_STR=']$'
export TMPL_BLOCK_START_STR='$['
export TMPL_COMMENT_END_STR="#]"
export TMPL_COMMENT_START_STR="[#"
export TMPL_LOG_FILE="tmpl.log"
export TMPL_LOG_LEVEL="info"
export TMPL_LOG_MODE="overwrite"
export TMPL_VAR_END_STR="]]"
export TMPL_VAR_START_STR="[["

compiler="xelatex -halt-on-error"
cv_srcs=$(find src/cv -name '*.tex')
resume_srcs=$(find src/resume -name '*.tex')
tmpl_cmd="tmpl src/tmpl.yaml --delete -o build"

function all {
    coverletter
    cv
    resume
}

function clean {
    rm -rf build
}

function clean-all {
    clean
    rm -rf release
}

function coverletter {
    echo "  --> Compiling cover letter..."
    cd build
    $compiler coverletter.tex >/dev/null || (echo "      Unable to compile cover letter!" && exit 1)
    cd ..
    mv build/coverletter.pdf release/
}

function cv {
    echo "  --> Compiling CV..."
    cd build
    $compiler cv.tex $cv_srcs >/dev/null || (echo "      Unable to compile CV!" && exit 1)
    cd ..
    mv build/cv.pdf release/
}

function resume {
    echo "  --> Compiling resume..."
    cd build
    $compiler resume.tex $resume_srcs >/dev/null || (echo "      Unable to compile resume!" && exit 1)
    cd ..
    mv build/resume.pdf release/
}

function templates {
    echo -n ""
}

if [ "$#" -ne 1 ]; then
    echo "USAGE: ./build.sh [all|clean|clean-all|coverletter|cv|resume|templates]"
    exit 1
fi

$tmpl_cmd
$1
rm -rf build/*.{aux,log,out}
