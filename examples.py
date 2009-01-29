#!/usr/bin/env python
#
# Natural Language Toolkit: Example generation script
#
# Copyright (C) 2001-2009 NLTK Project
# Author: Steven Bird <sb@csse.unimelb.edu.au>
# URL: <http://www.nltk.org/>
# For license information, see LICENSE.TXT

"""
Extract the code samples from a file in restructured text format
"""

import sys
import warnings

from epydoc.markup.doctest import DoctestColorizer
PROMPT_RE = DoctestColorizer.PROMPT_RE        

for file in sys.argv[1:]:
    in_code = False
    for line in open(file).readlines():
        if PROMPT_RE.match(line):
            in_code = True
            print PROMPT_RE.sub('', line),

        elif in_code:
            in_code = False
            print
