Pyth.. -*- mode: rst -*-
.. include:: ../definitions.rst

.. _app-reference:

=========================
Python and NLTK Reference
=========================

.. note::
   This appendix is only 10% of its intended size.

----------------
Python Reference
----------------

Python Syntax
-------------

* Statements: appear on a single line; may be broken across multiple lines
  inside parentheses, brackets, or braces; otherwise end line with backslash
  if it is continued on next line; multiple statements may appear on a single
  line if separated with a semicolon
  
* Comments: begin with a ``#`` symbol and continue to the end of the line

* Keywords: and as assert break class continue def del elif else
  except exec finally for from global if import in is lambda not or pass print
  raise return try while with yield (from ``keyword.kwlist``).

* Variable names: a sequence of one or more letters, digits, or underscore; must
  not begin with a digit.

* String literals:
  ``"won't"``,
  ``'Monty said: "Python"'``,
  ``'''Multi-line string'''``,
  ``"""Another multi-line string"""``.

* String literal prefixes: ``u`` for unicode strings; ``r`` for "raw" strings (backslash
  escapes are not processed by interpreter).
 
* Common escape sequences: ``\n`` (linefeed), ``\t`` (tab), ``\uxxxx`` (16-bit unicode
  character, e.g. ``\u03bb`` Greek lambda)

* Operators: ...

* Comparisons: ...

Data Types
----------

* Numeric types |mdash| ``int``, ``float``, ``long`` |mdash| ``3``, ``0.5772``, ``86267571272L``

* Strings |mdash| types ``str``, ``unicode`` |mdash| character sequences delimited with
  quotes as described above.

* Lists |mdash| type ``list`` |mdash| ``[]`` (empty list), ``['Python']``, ``[31, 9]``.

* Tuples |mdash| type ``tuple`` |mdash| ``()`` (empty tuple), ``('Python',)``, ``('the', 9)``

String Operations
-----------------

   ====================   =====================================================
   Function               Meaning
   ====================   =====================================================
   ``s.startswith(t)``    ``s`` starts with ``t``
   ``s.endswith(t)``      ``s`` ends with ``t``
   ``t in s``             ``t`` is contained inside ``s``
   ``s.islower()``        all cased characters in ``s`` are lowercase
   ``s.isupper()``        all cased characters in ``s`` are uppercase
   ``s.isalpha()``        all characters in ``s`` are alphabetic
   ``s.isalnum()``        all characters in ``s`` are alphanumeric
   ``s.isdigit()``        all characters in ``s`` are digits
   ``s.istitle()``        ``s`` is titlecased (all words have initial capital)
   ====================   =====================================================

Sequence Operations (including strings)
---------------------------------------

indexing, slicing, type conversions, ...

   ======================================  ===============================================
   Python Expression                       Comment                                        
   ======================================  ===============================================
   ``for item in s``                       iterate over the items of ``s``
   ``for item in sorted(s)``               iterate over the items of ``s`` in order
   ``for item in set(s)``                  iterate over unique elements of ``s``
   ``for item in reversed(s)``             iterate over elements of ``s`` in reverse
   ``for item in set(s).difference(t)``    iterate over elements of ``s`` not in ``t``
   ``for item in random.shuffle(s)``       iterate over elements of ``s`` in random order
   ======================================  ===============================================


Sets and Dictionaries
---------------------


   ==================================  ==========================================================
   Example                             Description
   ==================================  ==========================================================
   ``d = {}``                          create an empty dictionary and assign it to ``d``
   ``d[key] = value``                  assign a value to a given dictionary key
   ``list(d)``, ``d.keys()``           the list of keys of the dictionary
   ``sorted(d)``                       the keys of the dictionary, sorted
   ``key in d``                        test whether a particular key is in the dictionary
   ``for key in d``                    iterate over the keys of the dictionary
   ``d.values()``                      the list of values in the dictionary
   ``dict([(k1,v1), (k2,v2), ...])``   create a dictionary from a list of key-value pairs
   ``d1.update(d2)``                   add all items from ``d2`` to ``d1``
   ``defaultdict(int)``                a dictionary whose default value is zero
   ==================================  ==========================================================



Regular Expressions
-------------------

``re`` methods: ``re.findall()``, ...

   ===============  =======================================================================================
   Operator         Behavior
   ===============  =======================================================================================
   ``.``            Wildcard, matches any character
   ``^abc``         Matches some pattern `abc`:math: at the start of a string
   ``abc$``         Matches some pattern `abc`:math: at the end of a string
   ``[abc]``        Matches a set of characters
   ``[A-Z0-9]``     Matches a range of characters
   ``ed|ing|s``     Matches one of the specified strings (disjunction)
   ``*``            Zero or more of previous item, e.g. ``a*``, ``[a-z]*`` (also known as *Kleene Closure*)
   ``+``            One or more of previous item, e.g. ``a+``, ``[a-z]+``
   ``?``            Zero or one of the previous item (i.e. optional), e.g. ``a?``, ``[a-z]?``
   ``{n}``          Exactly `n`:math: repeats where n is a non-negative integer
   ``{m,n}``        At least `m`:math: and no more than `n`:math: repeats (`m`:math:, `n`:math: optional)
   ``(ab|c)+``      Parentheses that indicate the scope of the operators
   ===============  =======================================================================================



--------------
NLTK Reference
--------------

Dictionary-Like Objects
-----------------------

Frequency Distributions

   ===============================  ==============================================================
   Example                          Description
   ===============================  ==============================================================
   ``fdist = FreqDist(samples)``    create a frequency distribution containing the given samples
   ``fdist.inc(sample)``            increment the count for this sample
   ``fdist['monstrous']``           count of the number of times a given sample occurred
   ``fdist.freq('monstrous')``      frequency of a given sample
   ``fdist.N()``                    total number of samples
   ``fdist.keys()``                 the samples sorted in order of decreasing frequency
   ``for sample in fdist:``         iterate over the samples, in order of decreasing frequency
   ``fdist.max()``                  sample with the greatest count
   ``fdist.tabulate()``             tabulate the frequency distribution
   ``fdist.plot()``                 graphical plot of the frequency distribution
   ``fdist.plot(cumulative=True)``  cumulative plot of the frequency distribution
   ``fdist1 < fdist2``              samples in ``fdist1`` occur less frequently than in ``fdist2``
   ===============================  ==============================================================

Conditional Frequency Distributions

   =======================================  ================================================================
   Example                                  Description
   =======================================  ================================================================
   ``cfdist = ConditionalFreqDist(pairs)``  create a conditional frequency distribution
   ``cfdist.conditions()``                  alphabetically sorted list of conditions
   ``cfdist[condition]``                    the frequency distribution for this condition
   ``cfdist[condition][sample]``            frequency for the given sample for this condition
   ``cfdist.tabulate()``                    tabulate the conditional frequency distribution
   ``cfdist.plot()``                        graphical plot of the conditional frequency distribution
   ``cfdist1 < cfdist2``                    samples in ``cfdist1`` occur less frequently than in ``cfdist2``
   =======================================  ================================================================

Indexing

A simple class ``Index`` can be initialized with a list of (key, value) pairs.  It creates a
dictionary mapping keys to list of values.

   
Corpora
-------

Corpus Readers

  =====================================  ===================================================
  Corpus Reader Name                     Corpus Type
  =====================================  ===================================================
  ``BracketParseCorpusReader``           Treebanks represented as nested bracketings
  ``CategorizedPlaintextCorpusReader``   Text collections with document-level categories
  ``CategorizedTaggedCorpusReader``      Categorized, tagged text collections
  ``ChunkedCorpusReader``                Treebank-style bracketed chunked corpora
  ``ConllChunkCorpusReader``             CoNLL-format chunked corpora
  ``NPSChatCorpusReader``                NPS format chat corpus
  ``PlaintextCorpusReader``              Text collections
  ``PPAttachmentCorpusReader``           Prepositional phrase attachment corpus
  ``PropbankCorpusReader``               Proposition Bank corpus
  ``RTECorpusReader``                    Textual entailment corpora
  ``StringCategoryCorpusReader``         Categorized strings (e.g. classified questions)
  ``SwadeshCorpusReader``                Comparative wordlist corpora
  ``SwitchboardCorpusReader``            Transcribed spoken dialogue corpora
  ``TaggedCorpusReader``                 Text collections with word-level tags
  ``ToolboxCorpusReader``                Toolbox and Shoebox data
  ``VerbnetCorpusReader``                Verbnet corpus
  ``WordListCorpusReader``               Wordlists with arbitrary delimiters
  ``WordNetCorpusReader``                WordNet corpus
  ``WordNetICCorpusReader``              Wordnet information content files
  ``XMLCorpusReader``                    Text collections with XML markup
  =====================================  ===================================================

Corpus Methods

  =========================  ==================================================
  Method Name                Function
  =========================  ==================================================
  ``abspath(file)``          Absolute path to locally installed file  
  ``abspaths([files])``      Absolute paths to files (default: all files)
  ``encoding(file)``         The encoding of the file (if known)          
  ``files([categories])``    Filenames in the corpus (default: all categories)
  ``open(file)``             Open a stream for reading the given corpus file
  ``root()``                 The path to the root of locally installed corpus
  =========================  ==================================================
  
Text Corpus Methods

Unless otherwise specified,
the following methods permit a file or list of files to be specified,
e.g. ``words('1789-Washington.txt')``, ``words(['ca01', 'ca02'])``.  Alternatively,
if the corpus is categorized, then
one or more categories can be specified, e.g. ``words(categories='news')``,
``words(categories=['platinum', 'zinc'])``.

  =========================  ============================================================
  Method Name                Function
  =========================  ============================================================
  ``categories([files])``    The categories for a given list of files
  ``raw()``                  A string containing the content of the files or categories
  ``words()``                A list of words and punctuation tokens
  ``sents()``                A list of the sentences of the corpus (not always available)
  ``paras()``                A list of the paragraphs of the corpus (not always available)
  =========================  ============================================================

Tagged Corpus Methods

The following methods all permit files (sometimes categories) to be specified.
Most tagged corpora have a simplified tagset, used if a named paramter
``simplify_tags=True`` is passed to the method.

  =========================  ============================================================
  Method Name                Function
  =========================  ============================================================
  ``tagged_words()``         A list of (token,tag) tuples
  ``tagged_sents()``         A list of the tagged sentences (not always available)
  ``tagged_paras()``         A list of the tagged paragraphs (not always available)
  =========================  ============================================================

Chunked Corpus Methods

Chunked corpora support the ``chunked_sents()`` method.

Parsed Corpus Methods

These support the ``words()``, ``sents()``, ``tagged_words()`` and
``tagged_sents()`` methods.  An additional method is
``parsed_sents()``, which permits the usual parameters.

Dialogue Corpus Methods

[Todo: chat and switchboard interfaces]

Lexical Corpus Methods

These all support the ``words()`` method.  Some have an additional ``entries()``
method which iterates over all entries.  Some have an additional ``dict()``
method which provides dictionary-style access.  For more specialized corpora,
such as PropBank, Senseval, Verbnet, consult the interactive help.

WordNet Corpus Methods

[table of methods]

Word-Level Processing
---------------------

Tokenizers

All tokenizers split a string into a list of strings.

  ===============================  ====================================================================
  Method Name                      Function
  ===============================  ====================================================================
  ``blankline_tokenize(s)``        Split at every blank line
  ``line_tokenize(s)``             Split on newline
  ``regexp_tokenize(s, pattern)``  Split into pieces matching pattern (use ``gaps=True`` to match gaps)
  ``word_tokenize(s)``             Split into alphanumeric sequences discarding everything else
  ``wordpunct_tokenize(s)``        Split into words and punctuation
  ===============================  ====================================================================

[sentence tokenization with Punkt]

Stemmers and Lemmatizers

[to do]

Taggers

[to do]


Phrase-Level Processing
-----------------------

[chunkers, grammars, parsers, trees, feature structures, semantic interpretation]

Statistical Modeling
--------------------

[smoothing and estimation, clustering, classification]

Interfaces to Third-Party Libraries
-----------------------------------

[weka, megam, prover9, maltparser, ...] 


.. include:: footer.rst

