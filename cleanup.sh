#!/usr/bin/env bash
set -o xtrace

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd "$ROOT_DIR"

rm static/js/song_parser_peg.es6 2>/dev/null
find static -name '*.css' -exec rm {} \;
find static -name '*.js' \
  -not -path static/define_libs.js \
  -not -path 'static/soundfonts/*' \
  -not -path static/pre_libs.js \
  -exec rm {} \;
