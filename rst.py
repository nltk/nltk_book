#!/usr/bin/env python
#
# Natural Language Toolkit: Documentation generation script
#
# Copyright (C) 2001-2006 University of Pennsylvania
# Author: Edward Loper <edloper@gradient.cis.upenn.edu>
# URL: <http://nltk.sf.net>
# For license information, see LICENSE.TXT

r"""
This is a customized driver for converting docutils reStructuredText
documents into HTML and LaTeX.  It customizes the standard writers in
the following way:
    
    - Source code highlighting is added to all doctest blocks.  In
      the HTML output, highlighting is performed using css classes:
      'pysrc-prompt', 'pysrc-keyword', 'pysrc-string', 'pysrc-comment',
      and 'pysrc-output'.  In the LaTeX output, highlighting uses five
      new latex commands: '\pysrcprompt', '\pysrckeyword',
      '\pysrcstring', '\pysrccomment', and '\pyrcoutput'.
      De

"""

import re, os.path, textwrap
from optparse import OptionParser

import docutils.core, docutils.nodes
from docutils.writers import Writer
from docutils.writers.html4css1 import HTMLTranslator, Writer as HTMLWriter
from docutils.writers.latex2e import LaTeXTranslator, Writer as LaTeXWriter

LATEX_DPI = 100
"""The scaling factor that should be used to display bitmapped images
   in latex/pdf output (specified in dots per inch).  E.g., if a
   bitmapped image is 100 pixels wide, it will be scaled to
   100/LATEX_DPI inches wide for the latex/pdf output."""

######################################################################
#{ HTML Output
######################################################################

HTML_SETTINGS = {
    'stylesheet': '../nltkdoc.css',
    'stylesheet_path': None,
    }

class CustomizedHTMLWriter(HTMLWriter):
    def __init__(self):
        HTMLWriter.__init__(self)
        self.translator_class = CustomizedHTMLTranslator

class CustomizedHTMLTranslator(HTMLTranslator):
    def visit_doctest_block(self, node):
        pysrc = colorize_doctestblock(str(node[0]), self._markup_pysrc)
        self.body.append(self.starttag(node, 'pre', CLASS='doctest-block'))
        self.body.append(pysrc)
        self.body.append('\n</pre>\n')
        raise docutils.nodes.SkipNode

    def depart_doctest_block(self, node):
        pass

    def visit_literal(self, node):
        """Process text to prevent tokens from wrapping."""
        pysrc = colorize_doctestblock(str(node[0]), self._markup_pysrc, True)
        self.body.append(
	    self.starttag(node, 'tt', '', CLASS='doctest'))
	self.body.append('<span class="pre">%s</span>' % pysrc)
        self.body.append('</tt>')
        # Content already processed:
        raise docutils.nodes.SkipNode
                          
    def _markup_pysrc(self, s, tag):
        return '<span class="pysrc-%s">%s</span>' % (tag, self.encode(s))

######################################################################
#{ LaTeX Output
######################################################################

LATEX_SETTINGS = {
    'output_encoding': 'utf-8',
    'output_encoding_error_handler': 'backslashreplace',
    'use_latex_docinfo': True,
    'font_encoding': 'C10,T1',
    'stylesheet': '../definitions.sty',
    }

class CustomizedLaTeXWriter(LaTeXWriter):
    def __init__(self):
        LaTeXWriter.__init__(self)
        self.translator_class = CustomizedLaTeXTranslator

class CustomizedLaTeXTranslator(LaTeXTranslator):
    
    # Not sure why we need this, but the old Makefile did it so I will too:
    encoding = '\\usepackage[%s,utf8x]{inputenc}\n'
    
    def __init__(self, document):
        LaTeXTranslator.__init__(self, document)
        # This needs to go before the \usepackage{inputenc}:
        self.head_prefix.insert(1, '\\usepackage[cjkgb]{ucs}\n')
        # Make sure we put these *before* the stylesheet include line.
        self.head_prefix.insert(-2, textwrap.dedent("""\
            % For Python source code:
            \\usepackage{alltt}
            % Python source code: Prompt
            \\newcommand{\\pysrcprompt}[1]{\\textbf{#1}}
            \\newcommand{\\pysrcmore}[1]{\\textbf{#1}}
            % Python source code: Source code
            \\newcommand{\\pysrckeyword}[1]{\\textbf{#1}}
            \\newcommand{\\pysrcbuiltin}[1]{\\textbf{#1}}
            \\newcommand{\\pysrcstring}[1]{\\textit{#1}}
            \\newcommand{\\pysrcother}[1]{\\textbf{#1}}
            % Python source code: Comments
            \\newcommand{\\pysrccomment}[1]{\\textrm{#1}}
	    % Python interpreter: Traceback message
            \\newcommand{\\pysrcexcept}[1]{\\textbf{#1}}
            % Python interpreter: Output
            \\newcommand{\\pysrcoutput}[1]{#1}\n"""))

    def visit_doctest_block(self, node):
        pysrc = colorize_doctestblock(str(node[0]), self._markup_pysrc)
        self.body.append('\\begin{alltt}\n')
        self.body.append(pysrc)
        self.body.append('\\end{alltt}\n')
        raise docutils.nodes.SkipNode

    def depart_doctest_block(self, node):
        pass

    def visit_literal(self, node):
        pysrc = colorize_doctestblock(str(node[0]), self._markup_pysrc, True)
        self.body.append('\\texttt{%s}' % pysrc)
        raise docutils.nodes.SkipNode

    def depart_literal(self, node):
	pass

    def visit_doctest_block(self, node):
        pysrc = colorize_doctestblock(str(node[0]), self._markup_pysrc)
        self.body.append('\\begin{alltt}\n')
        self.body.append(pysrc)
        self.body.append('\\end{alltt}\n')
        raise docutils.nodes.SkipNode

    def _markup_pysrc(self, s, tag):
        return '\\pysrc%s{%s}' % (tag, self.encode(s))

    def visit_image(self, node):
        """So image scaling manually"""
        # Images are rendered using \includegraphics from the graphicx
        # package.  By default, it assumes that bitmapped images
        # should be rendered at 72 DPI; but we'd rather use a
        # different scale.  So adjust the scale attribute & then
        # delegate to our parent class.
        node.attributes['scale'] = (node.attributes.get('scale', 1) *
                                    100 * 72.0/LATEX_DPI)
        print node.attributes['scale']
        return LaTeXTranslator.visit_image(self, node)
        
######################################################################
#{ Source Code Highlighting
######################################################################

# Regular expressions for colorize_doctestblock
# set of keywords as listed in the Python Language Reference 2.4.1
# added 'as' as well since IDLE already colorizes it as a keyword.
# The documentation states that 'None' will become a keyword
# eventually, but IDLE currently handles that as a builtin.
_KEYWORDS = """
and       del       for       is        raise    
assert    elif      from      lambda    return   
break     else      global    not       try      
class     except    if        or        while    
continue  exec      import    pass      yield    
def       finally   in        print
as
""".split()
_KEYWORD = '|'.join([r'\b%s\b' % _KW for _KW in _KEYWORDS])

_BUILTINS = [_BI for _BI in dir(__builtins__) if not _BI.startswith('__')]
_BUILTIN = '|'.join([r'\b%s\b' % _BI for _BI in _BUILTINS])

_STRING = '|'.join([r'("""("""|.*?((?!").)"""))', r'("("|.*?((?!").)"))',
                    r"('''('''|.*?[^\\']'''))", r"('('|.*?[^\\']'))"])
_COMMENT = '(#.*?$)'
_PROMPT1 = r'^\s*>>>(?:\s|$)'
_PROMPT2 = r'^\s*\.\.\.(?:\s|$)'

PROMPT_RE = re.compile('(%s|%s)' % (_PROMPT1, _PROMPT2),
		       re.MULTILINE | re.DOTALL)
PROMPT2_RE = re.compile('(%s)' % _PROMPT2, re.MULTILINE | re.DOTALL)
'''The regular expression used to find Python prompts (">>>" and
"...") in doctest blocks.'''

EXCEPT_RE = re.compile(r'(.*)(^Traceback \(most recent call last\):.*)',
                       re.DOTALL | re.MULTILINE)

DOCTEST_DIRECTIVE_RE = re.compile(r'#\s*doctest:.*')

DOCTEST_RE = re.compile(r"""(?P<STRING>%s)|(?P<COMMENT>%s)|"""
                        r"""(?P<KEYWORD>(%s))|(?P<BUILTIN>(%s))|"""
                        r"""(?P<PROMPT1>%s)|(?P<PROMPT2>%s)|.+?""" %
  (_STRING, _COMMENT, _KEYWORD, _BUILTIN, _PROMPT1, _PROMPT2),
  re.MULTILINE | re.DOTALL)
'''The regular expression used by L{_doctest_sub} to colorize doctest
blocks.'''

def colorize_doctestblock(s, markup_func, inline=False, strip_directives=True):
    """
    Colorize the given doctest string C{s} using C{markup_func()}.
    C{markup_func()} should be a function that takes a substring and a
    tag, and returns a colorized version of the substring.  E.g.:

        >>> def html_markup_func(s, tag):
        ...     return '<span class="%s">%s</span>' % (tag, s)

    The tags that will be passed to the markup function are: 
        - C{prompt} -- the Python PS1 prompt (>>>)
	- C{more} -- the Python PS2 prompt (...)
        - C{keyword} -- a Python keyword (for, if, etc.)
        - C{builtin} -- a Python builtin name (abs, dir, etc.)
        - C{string} -- a string literal
        - C{comment} -- a comment
	- C{except} -- an exception traceback (up to the next >>>)
        - C{output} -- the output from a doctest block.
        - C{other} -- anything else (does *not* include output.)
    """
    pysrc = [] # the source code part of a docstest block (lines)
    pyout = [] # the output part of a doctest block (lines)
    result = []
    out = result.append

    if strip_directives:
        s = DOCTEST_DIRECTIVE_RE.sub('', s)

    def subfunc(match):
        if match.group('PROMPT1'):
            return markup_func(match.group(), 'prompt')
	if match.group('PROMPT2'):
	    return markup_func(match.group(), 'more')
        if match.group('KEYWORD'):
            return markup_func(match.group(), 'keyword')
        if match.group('BUILTIN'):
            return markup_func(match.group(), 'builtin')
        if match.group('COMMENT'):
            return markup_func(match.group(), 'comment')
        if match.group('STRING') and '\n' not in match.group():
            return markup_func(match.group(), 'string')
        elif match.group('STRING'):
            # It's a multiline string; colorize the string & prompt
            # portion of each line.
            pieces = [markup_func(s, ['string','more'][i%2])
                      for i, s in enumerate(PROMPT2_RE.split(match.group()))]
            return ''.join(pieces)
        else:
            return markup_func(match.group(), 'other')

    if inline:
	pysrc = DOCTEST_RE.sub(subfunc, s)
	return pysrc.strip()

    # need to add a third state here for correctly formatting exceptions

    for line in s.split('\n')+['\n']:
        if PROMPT_RE.match(line):
            pysrc.append(line)
            if pyout:
                pyout = '\n'.join(pyout).strip()
                m = EXCEPT_RE.match(pyout)
                if m:
                    pyout, pyexc = m.group(1).strip(), m.group(2).strip()
                    if pyout:
                        print ('Warning: doctest does not allow for mixed '
                               'output and exceptions!')
                        result.append(markup_func(pyout, 'output'))
                    result.append(markup_func(pyexc, 'except'))
                else:
                    result.append(markup_func(pyout, 'output'))
                pyout = []
        else:
            pyout.append(line)
            if pysrc:
                pysrc = DOCTEST_RE.sub(subfunc, '\n'.join(pysrc))
                result.append(pysrc.strip())
                #result.append(markup_func(pysrc.strip(), 'python'))
                pysrc = []

    remainder = '\n'.join(pyout).strip()
    if remainder:
        result.append(markup_func(remainder, 'output'))
        
    return '\n'.join(result)

######################################################################
#{ Chapter numbering
######################################################################

# Add chapter numbers; docutils doesn't handle (multi-file) books
def chapter_numbers(out_file):
    f = open(out_file).read()
    # LaTeX
    c = re.search(r'pdftitle={(\d+)\. ([^}]+)}', f)
    if c:
        chnum = c.group(1)
        chtitle = c.group(2)
        f = re.sub(r'(pdfbookmark\[\d+\]{)', r'\g<1>'+chnum+'.', f)
        f = re.sub(r'(section\*{)', r'\g<1>'+chnum+'.', f)
        f = re.sub(r'(\\begin{document})',
                   r'\def\chnum{'+chnum+r'}\n' +
                   r'\def\chtitle{'+chtitle+r'}\n' +
                   r'\g<1>', f)
        open(out_file, 'w').write(f)
    # HTML
    c = re.search(r'<h1 class="title">(\d+)\.', f)
    if c:
        chapter = c.group(1)
        f = re.sub(r'(<h\d><a[^>]*>)', r'\g<1>'+chapter+'.', f)
        open(out_file, 'w').write(f)
    


######################################################################
#{ Main Script
######################################################################

__version__ = 0.1

def parse_args():
    optparser = OptionParser()

    optparser.add_option("--html", 
        action="store_const", dest="action", const="html",
        help="Write HTML output.")
    optparser.add_option("--latex", "--tex",
        action="store_const", dest="action", const="latex",
        help="Write LaTeX output.")

    optparser.set_defaults(action='html')

    options, filenames = optparser.parse_args()
    return options, filenames

def main():
    options, filenames = parse_args()

    if options.action == 'html':
        writer = CustomizedHTMLWriter()
        output_ext = '.html'
        settings = HTML_SETTINGS
    elif options.action == 'latex':
        writer = CustomizedLaTeXWriter()
        output_ext = '.tex'
        settings = LATEX_SETTINGS
    else:
        assert 0, 'bad action'

    for in_file in filenames:
        out_file = os.path.splitext(in_file)[0] + output_ext
        if in_file == out_file: out_file += output_ext
        docutils.core.publish_file(source_path=in_file,
                                   destination_path=out_file,
                                   writer=writer,
                                   settings_overrides=settings)
        chapter_numbers(out_file)

if __name__ == '__main__':
    main()
