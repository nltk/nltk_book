#
# index_glossterms.py
#
# Add an <indexterm> for each <glossterm> in a docbook document.
#

import sys, re

if len(sys.argv) != 3:
    print 'Usage: %s <input> <output>' % sys.argv[0]
    sys.exit(1)

# Define a regexp that finds glossterms.
GT_RE = re.compile('<glossterm>(.*?)</glossterm>', re.DOTALL)

# Add an indexterm after each glossterm.
str = GT_RE.sub(r'<glossterm>\1</glossterm>'+
                r'<indexterm><primary>\1</primary></indexterm>',
                open(sys.argv[1]).read())

# Write to the output file.
open(sys.argv[2], 'w').write(str)
