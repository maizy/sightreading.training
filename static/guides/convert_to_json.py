#!/usr/bin/env python3
# encoding: utf-8

import json
import sys

import markdown2

if __name__ == '__main__':
    if len(sys.argv) != 2:
        sys.stderr.write('Wrong arguments')
        sys.exit(1)

    fname = sys.argv[1]
    with open(fname, 'rb') as fp:
        result = {
            'contents': markdown2.markdown(fp.read().decode('utf-8'))
        }
    json.dump(result, sys.stdout)

