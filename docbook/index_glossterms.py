#
# index_glossterms.py
#
# Add an <indexterm> for each <glossterm> in a docbook document.
#

import sys, re

if len(sys.argv) != 3:
    print 'Usage: %s <input> <output>' % sys.argv[0]
    sys.exit(1)

# Open the output file for writing.
outfile = open(sys.argv[2], 'w')

PARA_END_RE = re.compile(r'(</para>)\s*')

# We will use re.sub to look for all the glossary terms on each
# line, using the following regexp and sub function:
GLOSSTERM_RE = re.compile('<glossterm>(.*?)</glossterm>')
glossterms = []
def glossterm_sub(match, glossterms=glossterms):
    glossterms.append(match.group(1))

for line in open(sys.argv[1]).readlines():
    # Find all the glossary terms on this line.
    GLOSSTERM_RE.sub(glossterm_sub, line)

    # If a paragraph ended, then add any accumulated glossary
    # terms right after it.
    if glossterms and PARA_END_RE.search(line):
        indexterms = '\n'
        for t in glossterms:
            indexterms += '<indexterm><primary>%s</primary></indexterm>\n' % t
        line = PARA_END_RE.sub(r'\1'+indexterms, line)
        glossterms[:] = []

    # Write the line to the output file.
    outfile.write(line)

