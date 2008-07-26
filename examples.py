#!/usr/bin/env python
#
# Natural Language Toolkit: Example generation script
#
# Copyright (C) 2001-2008 NLTK Project
# Author: Steven Bird <sb@csse.unimelb.edu.au>
# URL: <http://nltk.org>
# For license information, see LICENSE.TXT

"""
Extract the code samples from a file in restructured text format
"""

import sys
from epydoc.markup.doctest import DoctestColorizer
PROMPT_RE = DoctestColorizer.PROMPT_RE        

for file in sys.argv:
    in_code = False
    for line in open(file).readlines():
        if PROMPT_RE.match(line):
            in_code = True
            print PROMPT_RE.sub('', line),
        elif in_code:
            in_code = False
            print




