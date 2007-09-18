
import sys, os, re
import nltk.test.coverage as coverage
import color_coverage

OUT_DIR = 'coverage'
MODULE_RE = re.compile(r'nltk.*')

INDEX_HEADER = """
<!DOCTYPE HTML PUBLIC"-//W3C//DTD HTML 4.01 Transitional//EN"
  "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>NLTK code coverage</title>
<link rel="stylesheet" href="../../nltkdoc.css" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body>
<h1 class="title"> NLTK Regression Test Coverage </h1>

<p>The following table lists each NLTK module, and indicates what percentage
of the module's statements are currently covered by the regression test set.
To see which statements are covered in a given module, click on that
module.</p>

<div class="doctest-list container">
<table border="1" class="doctest-list docutils">
<colgroup>
<col width="80%" />
<col width="20%" />
</colgroup>
<thead valign="bottom">
<tr><th>Module</th><th>Coverage</th></tr>
</thead>
<tbody>
"""

INDEX_FOOTER = """
</tbody>
</table>
</div>
</body>
</html>
"""

def report_coverage(module_regexps):
    output = []
    
    # filename, statements, excluded, missing, missing_formatted
    for module_name, module in sorted(sys.modules.items()):
        if module is None: continue
        for regexp in module_regexps:
            if re.match(regexp, module_name):
                print 'Finding coverage for %s' % module_name
                output.append(module_name)
                (fname, stmts, excluded, missing, fmt_missing) = (
                    coverage.analysis2(module))
                output.append('  Missing: %s' % fmt_missing)
                if excluded:
                    output.append('  Exclude: %s' %
                               coverage.format_lines(stmts, excluded))
                break

    return '\n'.join(output)

def report_coverage(module):
    sys.stdout.write('  %-40s ' % module.__name__)
    sys.stdout.flush()
    (fname, stmts, excluded, missing, fmt_missing) = (
        coverage.analysis2(module))
    out = open(os.path.join(OUT_DIR, module.__name__+'.html'), 'wb')
    color_coverage.colorize_file(fname, outstream=out,
                                 not_covered=fmt_missing)
    out.close()
    if not missing: c = 100
    elif stmts: c = 100.*(len(stmts)-len(missing)) / len(stmts)
    else: c = 100
    sys.stdout.write('%3d%%\n' % c)
    return c


def init_out_dir():
    # Create the dir if it doesn't exist.
    if not os.path.exists(OUT_DIR):
        os.mkdir(OUT_DIR)

    # Make sure it's actually a dir.
    if not os.path.isdir(OUT_DIR):
        raise ValueError('%s is in the way' % OUT_DIR)

    # Clear its contents.
    for filename in os.listdir(OUT_DIR):
        os.remove(os.path.join(OUT_DIR, filename))

def main(filenames):
    # Collect the coverage data from the given files.
    for filename in filenames:
        cexecuted = coverage.the_coverage.restore_file(filename)
        coverage.the_coverage.merge_data(cexecuted)

    try: init_out_dir()
    except Exception, e:
        print 'Unable to create output directory %r: %s' % (OUT_DIR, e)
        return

    out = open(os.path.join(OUT_DIR, 'index.html'), 'wb')
    out.write(INDEX_HEADER)

    # Construct a coverage file for each NLTK module.
    print '\n%-40s %s' % ('Module', 'Coverage')
    print '-'*50
    for module_name, module in sorted(sys.modules.items()):
        if module is None: continue
        if MODULE_RE.match(module_name):
            c = report_coverage(module)
            if c == 100: color = '#008000'
            elif c > 50: color = '#808000'
            else: color = '#800000'
            out.write('<tr><td><code><a href="%s.html">%s</a></code></td>'
                      '<td><font color="%s">%d%%</font></td></tr>\n' %
                      (module_name, module_name, color, c))
            out.flush()
            
    out.write(INDEX_FOOTER)
    out.close()

if __name__ == '__main__':
    main(sys.argv[1:])
