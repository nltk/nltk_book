#
# Script that updates test-list.txt
#

import os, os.path, re, sys

DOCTEST_SRC = '../../nltk/test'

HEAD = (".. ==========================================================\n"
        ".. AUTO-GENERATED LISTING -- DO NOT EDIT!:\n\n"
        ".. role:: passed\n"
        "    :class: doctest-passed\n\n"
        ".. role:: failed\n"
        "    :class: doctest-failed\n\n"
        ".. container:: doctest-list\n\n"
        " .. list-table::\n"
        "  :class: doctest-list \n"
        "  :widths: 70 30\n"
        "  :header-rows: 1\n\n"
        "  * - Topic\n    - Test Outcome\n")
FOOT = (".. END AUTO-GENERATED LISTING\n"
        ".. ==========================================================\n")

TITLE_REGEXPS = (
    '\s*----+[ ]*\n(.*)\n----+[ ]*\n',
    '\s*====+[ ]*\n(.*)\n====+[ ]*\n',
    '\s*(.*)\n====+[ ]*\n',
    '\s*(.*)\n----+[ ]*\n')

def find_title(basename):
    filename = os.path.join(DOCTEST_SRC, basename + '.doctest')
    head = open(filename).read(800)
    for regexp in TITLE_REGEXPS:
        regexp = '\A\s*(?:\.\..*\n)*'+regexp
        m = re.match(regexp, head)
        if m: return m.group(1).strip().replace('`', "'")
    print 'Warning: no title found for %s' % basename
    return basename

def doctest_listing():
    listing = ''
    
    files = [f for f in os.listdir(DOCTEST_SRC) if f.endswith('.doctest')]
    err_refs = []
    for filename in sorted(files):
        basename = filename.replace('.doctest', '')
        if basename == 'temp': continue

        result = '`Passed!`:passed:'
        if os.path.exists(basename+'.errs'):
            s = open(basename+'.errs').read()
            if not re.search(r'OK\s*\Z', s):
                num_failed = len(re.findall(r'(?m)^Failed [Ee]xample:', s))
                result = '|%s|_' % basename
                err_refs.append( (basename, num_failed) )
                print ('test %s failed (%d examples)' %
                       (basename, num_failed))

        title = find_title(basename)
        listing += ('  * - `%s <%s.html>`__\n' % (title,basename) +
                    '    - %s\n' % result)

    for (basename, num_failed) in err_refs:
         plural = (num_failed!=1 and 's' or '')
         listing += ('\n.. |%s| replace:: `%d test%s failed!`:failed:'
                     '\n.. _%s: %s.errs\n' %
                     (basename, num_failed, plural, basename, basename))
                    
    return listing

def main():
    out = open('test-list.txt', 'w')
    out.write('%s\n%s\n%s' % (HEAD, doctest_listing(), FOOT))
    out.close()

if __name__ == '__main__':
    main()
