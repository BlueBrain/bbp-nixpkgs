#!/usr/bin/env python
"""This script generates a virtualenv script containing extra instructions
"""
from __future__ import print_function

import sys

import virtualenv


def generate(extra_file, output_file):
    with open(output_file, 'w') as ostr:
        with open(extra_file) as istr:
            extra_text = istr.read()
        print(virtualenv.create_bootstrap_script(extra_text), file=ostr)


if __name__ == '__main__':
    if len(sys.argv) != 3:
        print('script usage: generator extra_py_file output_file',
              file=sys.stderr)
        sys.exit(1)
    generate(*sys.argv[1:])
