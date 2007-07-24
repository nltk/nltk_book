import os, os.path, re, sys

DOCTEST_SRC = '../../nltk/test'

HEAD = (".. ==========================================================\n"
        ".. AUTO-GENERATED LISTING -- DO NOT EDIT!:\n")
FOOT = (".. END AUTO-GENERATED LISTING\n"
        ".. ==========================================================\n")
LISTING_RE = re.compile(re.escape(HEAD)+'.*'+re.escape(FOOT), re.DOTALL)

TITLE_REGEXPS = (
    '\A\s*----+[ ]*\n(.*)\n----+[ ]*\n',
    '\A\s*====+[ ]*\n(.*)\n====+[ ]*\n',
    '\A\s*(.*)\n====+[ ]*\n',
    '\A\s*(.*)\n----+[ ]*\n')

def find_title(basename):
    filename = os.path.join(DOCTEST_SRC, basename + '.doctest')
    head = open(filename).read(400)
    for regexp in TITLE_REGEXPS:
        m = re.match(regexp, head)
        if m: return m.group(1)
    print 'Warning: no title found for %s' % basename
    return basename

def doctest_listing():
    listing = ''
    
    files = [f for f in os.listdir(DOCTEST_SRC) if f.endswith('.doctest')]
    for filename in files:
        basename = filename.replace('.doctest', '')
        if basename == 'temp': continue
        
        if (os.path.exists(basename+'.errs') and 
            not re.search(r'OK\s*\Z', open(basename+'.errs').read())):
            errs = '[`Test(s) failed! <%s.errs>`__]' % basename
            print 'test %s failed' % basename
        else:
            errs = ''

        title = find_title(basename)
        listing += ('* `%s <%s.html>`__ -- %s %s\n' %
                    (basename, basename, title, errs))
    return listing

def splice_listing(filename, listing):
    # Read index:
    index = open(filename).read()
    
    # Sanity check:
    matches = len(LISTING_RE.findall(index))
    if matches == 0:
        print >>sys.stderr, "Splice location not found!"
        sys.exit(-1)
    if matches > 1:
        print >>sys.stderr, "Multiple splice locations found!"
        sys.exit(-1)

    # Write new index:
    out = open(filename, 'w')
    out.write(LISTING_RE.sub(HEAD+'\n'+listing+'\n'+FOOT, index))
    out.close()
        
def main():
    splice_listing('index.txt', doctest_listing())

if __name__ == '__main__':
    main()
