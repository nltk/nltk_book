.. -*- mode: rst -*-
.. include:: ../definitions.rst
.. include:: regexp-defns.rst

.. standard global imports

    >>> import nltk, re, pprint

.. TODO: transformation based learning?
.. TODO: indexing and space-time trade-offs (more efficient concordancing, fuzzy spelling)
.. TODO: persistent storage (shelve)
.. TODO: indexing and searching a corpus, cf VITTA talk, or Ingrid's lexicon spreadsheet inversion
.. TODO: SIPs exercise
.. TODO: explain the relationship between list comprehension argument and generator expression argument; say that we oversimplified in chapter 6
.. TODO: cover generator expressions, as promised in words chapter.
.. TODO: architectures: pipeline/cascade vs blackboard
.. TODO: lexical chaining for text segmentation, or WSD
.. TODO: multicomponent systems and APIs: spelling correction, web search
.. TODO: explain why a program should not usually import all of NLTK.

.. _chap-applied-programming:

================================
10. Applied Programming in Python
================================

This chapter introduces concepts in algorithms, data structures,
program design, and applied Python programming. It also contains
review of the basic mathematical notions of set, relation, and
function, and illustrates them in terms of Python data structures.
It contains many working program fragments that you should try yourself.


-------------------
Program Development
-------------------

Programming is a skill that is acquired over several years of
experience with a variety of programming languages and tasks.  Key
high-level abilities are *algorithm design* and its manifestation in
*structured programming*.  Key low-level abilities include familiarity
with the syntactic constructs of the language, and knowledge of a
variety of diagnostic methods for trouble-shooting a program which
does not exhibit the expected behavior.

.. note:: If you are new to programming, you will probably find
   writing a complete program from scratch quite daunting.  Instead,
   it is a good idea to begin by looking at many small example
   programs and understand why they work, then modifying them in small
   ways to change their behavior.

Programming Style
-----------------

We have just seen how the same task can be performed in different
ways, with implications for efficiency.  Another factor influencing
program development is *programming style*.  Consider the following
program to compute the average length of words in the Brown Corpus:

    >>> tokens = nltk.corpus.brown.words(categories='a')
    >>> count = 0
    >>> total = 0
    >>> for token in tokens:
    ...     count += 1
    ...     total += len(token)
    >>> print float(total) / count
    4.2765382469

In this program we use the variable ``count`` to keep track of the
number of tokens seen, and ``total`` to store the combined length of
all words.  This is a low-level style, not far removed from machine
code, the primitive operations performed by the computer's CPU.
The two variables are just like a CPU's registers, accumulating values
at many intermediate stages, values that are almost meaningless. 
We say that this program is written in a *procedural* style, dictating
the machine operations step by step.  Now consider the following
program that computes the same thing:

    >>> total = sum(map(len, tokens))
    >>> print float(total)/len(tokens)
    4.2765382469

The first line uses a list comprehension to construct the sequence of
tokens.  The second line *maps* the ``len`` function to this sequence,
to create a list of length values, which are summed.  The third line
computes the average as before.  Notice here that each line of code
performs a complete, meaningful action.  Moreover, they do not dictate
how the computer will perform the computations; we state high level
relationships like "``total`` is the sum of the lengths of the tokens"
and leave the details to the Python interpreter.  Accordingly, we say
that this program is written in a *declarative* style.

Here is another example to illustrate the procedural/declarative
distinction.  Notice again that the procedural version
involves low-level steps and a variable having meaningless
intermediate values:

    >>> word_list = []
    >>> for token in tokens:
    ...     if token not in word_list:
    ...         word_list.append(token)
    >>> word_list.sort()

The declarative version makes use of higher-level built-in functions:

    >>> word_list = list(set(tokens))
    >>> word_list.sort()

What do these programs compute?  Which version did you find easier to interpret?

Consider one further example, that sorts three-letter words by their
final letters.  The words come from the widely-used Unix word-list,
made available as an NLTK corpus called ``words``.  Two words ending
with the same letter will be sorted according to their second-last
letters.  The result of this sort method is that many rhyming words will be
contiguous.  Two programs are given; Which one is more declarative,
and which is more procedural?

As an aside, for readability we define a function for reversing
strings that will be used by both programs:

    >>> def reverse(word):
    ...     return word[::-1]

Here's the first program.  We define a helper function ``reverse_cmp``
that calls the built-in ``cmp`` comparison function on reversed
strings.  The ``cmp`` function returns ``-1``, ``0``, or ``1``,
depending on whether its first argument is less than, equal to, or
greater than its second argument.  We tell the list sort function to
use ``reverse_cmp`` instead of ``cmp`` (the default).

    >>> def reverse_cmp(x,y):
    ...     return cmp(reverse(x), reverse(y))
    >>> word_list = [w for w in nltk.corpus.words.words('en') if len(w) == 3]
    >>> word_list.sort(reverse_cmp)
    >>> print word_list[-12:]
    ['toy', 'spy', 'cry', 'dry', 'fry', 'pry', 'try', 'buy', 'guy', 'ivy',
    'Paz', 'Liz']

Here's the second program.  In the first loop it collects up all the
three-letter words in reversed form.  Next, it sorts the list of
reversed words.  Then, in the second loop, it iterates over each
position in the list using the variable ``i``, and replaces each item
with its reverse.  We have now re-reversed the words, and can print
them out.

    >>> word_list = []
    >>> for word in words:
    ...     if len(word) == 3:
    ...         word_list.append(reverse(word))
    >>> word_list.sort()
    >>> for i in range(len(word_list)):
    ...     word_list[i] = reverse(word_list[i])
    >>> print word_list[-12:]
    ['toy', 'spy', 'cry', 'dry', 'fry', 'pry', 'try', 'buy', 'guy', 'ivy',
    'Paz', 'Liz']

Choosing between procedural and declarative styles is just that, a
question of style.  There are no hard boundaries, and it is possible
to mix the two.  Readers new to programming are encouraged to
experiment with both styles, and to make the extra effort required to
master higher-level constructs, such as list comprehensions, and
built-in functions like ``map`` and ``filter``.



.. TODO: don't repeat yourself http://c2.com/cgi/wiki?DontRepeatYourself
.. TODO: duck typing
.. TODO: shared values between multiple dictionaries

Modularity
----------

Variable scope

* local and global variables
* scope rules
* global variables introduce dependency on context and limits the reusability of a function
* importance of avoiding side-effects
* functions hide implementation details

naming variables

http://www.python.org/dev/peps/pep-0008/

Modules


Documenting Code
----------------

NLTK's docstrings are (mostly) written using the "epytext" markup
language.  Using an explicit markup language allows us to generate
prettier online documentation, e.g. see:

   http://nltk.org/doc/api/nltk.tree.Tree-class.html

In short, anything of the form ``Z{...}`` where ``Z`` is a capital letter is
basically just telling epytext how to render the docstring.  In
particular, ``M{...}`` is for "math expression", ``C{...}`` is for "code
expression", and ``X{...}`` is for "indexed term."  The first two just
affect formatting (math=italics, code=monospace), and the last one
will add an entry to the automatically generated term index:

   http://nltk.org/doc/api/term-index.html

Examples of function-level docstrings with epytext markup...

Debugging
---------

.. doctest-ignore::

    >>> import pdb
    >>> import mymodule
    >>> pdb.run('mymodule.test()')


Commands:

list [first [,last]]: list sourcecode for the current file

next: continue execution until the next line in the current function is reached

cont: continue execution until a breakpoint is reached (or the end of the program)

break: list the breakpoints

break n: insert a breakpoint at this line number in the current file

break file.py:n: insert a breakpoint at this line in the specified file

break function: insert a breakpoint at the first executable line of the function

Profiling
---------

Scaling Up
----------

scalability tricks (e.g. replace each word with an integer).
Figure strings-to-ints_

.. pylisting:: strings-to-ints
   :caption: Preprocess tagged corpus data, converting all words and tags to integers

   def preprocess(tagged_corpus):
       words = set()
       tags = set()
       for sent in tagged_corpus:
           for word, tag in sent:
               words.add(word)
               tags.add(tag)
       wm = dict((w,i) for (i,w) in enumerate(words))
       tm = dict((t,i) for (i,t) in enumerate(tags))
       return [[(wm[w], tm[t]) for (w,t) in sent] for sent in tagged_corpus]


* when keeping track of vocabulary items, for the purpose of checking membership,
  use sets rather than lists, because sets index their elements.


Named Arguments
---------------

One of the difficulties in re-using functions is remembering the order of arguments.
Consider the following function, that finds the ``n`` most frequent words that are
at least ``min_len`` characters long:

    >>> def freq_words(file, min, num):
    ...     text = open(file).read()
    ...     tokens = nltk.wordpunct_tokenize(text)
    ...     freqdist = nltk.FreqDist(t for t in tokens if len(t) >= min)
    ...     return freqdist.sorted()[:num]
    >>> freq_words('programming.txt', 4, 10)
    ['string', 'word', 'that', 'this', 'phrase', 'Python', 'list', 'words',
    'very', 'using']

This function has three arguments.  It follows the convention of listing the most
basic and substantial argument first (the file).  However, it might be hard to remember
the order of the second and third arguments on subsequent use.  We can make this function
more readable by using `keyword arguments`:dt:.  These appear in the function's argument
list with an equals sign and a default value:

    >>> def freq_words(file, min=1, num=10):
    ...     text = open(file).read()
    ...     tokens = nltk.wordpunct_tokenize(text)
    ...     freqdist = nltk.FreqDist(t for t in tokens if len(t) >= min)
    ...     return freqdist.sorted()[:num]

|nopar|
Now there are several equivalent ways to call this function:

    >>> freq_words('programming.txt', 4, 10)
    ['string', 'word', 'that', 'this', 'phrase', 'Python', 'list', 'words', 'very', 'using']
    >>> freq_words('programming.txt', min=4, num=10)
    ['string', 'word', 'that', 'this', 'phrase', 'Python', 'list', 'words', 'very', 'using']
    >>> freq_words('programming.txt', num=10, min=4)
    ['string', 'word', 'that', 'this', 'phrase', 'Python', 'list', 'words', 'very', 'using']

|nopar|
When we use an integrated development environment such as IDLE,
simply typing the name of a function at the command prompt will
list the arguments.  Using named arguments helps someone to re-use the code...

A side-effect of having named arguments is that they permit optionality.  Thus we
can leave out any arguments where we are happy with the default value.

    >>> freq_words('programming.txt', min=4)
    ['string', 'word', 'that', 'this', 'phrase', 'Python', 'list', 'words', 'very', 'using']
    >>> freq_words('programming.txt', 4)
    ['string', 'word', 'that', 'this', 'phrase', 'Python', 'list', 'words', 'very', 'using']

Another common use of optional arguments is to permit a flag, e.g.:

    >>> def freq_words(file, min=1, num=10, trace=False):
    ...     freqdist = FreqDist()
    ...     if trace: print "Opening", file
    ...     text = open(file).read()
    ...     if trace: print "Read in %d characters" % len(file)
    ...     for word in nltk.wordpunct_tokenize(text):
    ...         if len(word) >= min:
    ...             freqdist.inc(word)
    ...             if trace and freqdist.N() % 100 == 0: print "."
    ...     if trace: print
    ...     return freqdist.sorted()[:num]

Accumulative Functions
----------------------

These functions start by initializing some storage, and iterate over
input to build it up, before returning some final object (a large structure
or aggregated result).  The standard way to do this is to initialize an
empty list, accumulate the material, then return the list, as shown
in function ``find_nouns1()`` in Listing find-nouns1_.

.. pylisting:: find-nouns1
   :caption: Accumulating Output into a List

   def find_nouns1(tagged_text):
       nouns = []
       for word, tag in tagged_text:
           if tag[:2] == 'NN':
               nouns.append(word)
       return nouns

   >>> tagged_text = [('the', 'DT'), ('cat', 'NN'), ('sat', 'VBD'),
   ...                ('on', 'IN'), ('the', 'DT'), ('mat', 'NN')]
   >>> find_nouns1(tagged_text)
   ['cat', 'mat']

A superior way to perform this operation is define the function to
be a `generator`:dt:, as shown in Listing find-nouns2_.
The first time this function is called, it gets as far as the ``yield``
statement and stops.  The calling program gets the first word and does
any necessary processing.  Once the calling program is ready for another
word, execution of the function is continued from where it stopped, until
the next time it encounters a ``yield`` statement.  This approach is
typically more efficient, as the function only generates the data as it is
required by the calling program, and does not need to allocate additional
memory to store the output.

.. pylisting:: find-nouns2
   :caption: Defining a Generator Function
   
   def find_nouns2(tagged_text):
       for word, tag in tagged_text:
           if tag[:2] == 'NN':
               yield word

   >>> tagged_text = [('the', 'DT'), ('cat', 'NN'), ('sat', 'VBD'),
   ...                ('on', 'IN'), ('the', 'DT'), ('mat', 'NN')]
   >>> find_nouns2(tagged_text)
   <generator object at 0x14b2f30>
   >>> for noun in find_nouns2(tagged_text):
   ...     print noun,
   cat mat
   >>> list(find_nouns2(tagged_text))
   ['cat', 'mat']

If we call the function directly we see that it returns a "generator object", which is
not very useful to us.  Instead, we can iterate over it directly, using ``for noun in find_nouns(tagged_text)``,
or convert it into a list, using ``list(find_nouns(tagged_text))``.


Case Study: T9
--------------


.. _T9:
.. figure:: ../images/T9.png
   :scale: 20

   T9: Text on 9 Keys


-------------------------------
Connecting to the Outside World
-------------------------------


Python's Standard Library
-------------------------

* accessing file system, network, maths, graphics


CSV
---

    >>> import csv
    >>> file = open("dict.csv", "rb")
    >>> for row in csv.reader(file):
    ...     print row
    ['sleep', 'sli:p', 'v.i', 'a condition of body and mind ...']
    ['walk', 'wo:k', 'v.intr', 'progress by lifting and setting down each foot ...']
    ['wake', 'weik', 'intrans', 'cease to sleep']


Database Connectivity
---------------------



HTML
----



Web Applications
----------------

``mod_python``

Jango


XML and ElementTree
-------------------

* inspecting and processing XML
* example: find nodes matching some criterion and add an attribute
* Shakespeare XML corpus example


Chinese and XML
---------------

Codecs for processing Chinese text have been incorporated into Python
(since version 2.4). 

    >>> path = nltk.data.find('samples/sinorama-gb.xml')
    >>> f = codecs.open(path, encoding='gb2312')
    >>> lines = f.readlines()
    >>> for l in lines:
    ...     l = l[:-1]
    ...     utf_enc = l.encode('utf8')
    ...     print repr(utf_enc)
    '<?xml version="1.0" encoding="gb2312" ?>'
    ''
    '<sent>'
    '\xe7\x94\x9a\xe8\x87\xb3\xe7\x8c\xab\xe4\xbb\xa5\xe4\xba\xba\xe8\xb4\xb5'
    ''
    'In some cases, cats were valued above humans.'
    '</sent>'

With appropriate support on your terminal, the escaped text string
inside the ``<SENT>`` element above
will be rendered as the following string of ideographs:
|CJK-751a|\ |CJK-81f3|\ |CJK-732b|\ |CJK-4ee5|\ |CJK-4eba|\ |CJK-8d35|.

We can also read in the contents of an XML file using the ``etree``
package (at least, if the file is encoded as UTF-8 |mdash| as of
writing, there seems to be a problem reading GB2312-encoded files in
``etree``).


    >>> path = nltk.data.find('samples/sinorama-utf8.xml')
    >>> from nltk.etree import ElementTree as ET
    >>> tree = ET.parse(path)
    >>> text = tree.findtext('sent')
    >>> uni_text = text.encode('utf8')
    >>> print repr(uni_text.splitlines()[1])
    '\xe7\x94\x9a\xe8\x87\xb3\xe7\x8c\xab\xe4\xbb\xa5\xe4\xba\xba\xe8\xb4\xb5'





.. _OO:

-------------------------------------
Object-Oriented Programming in Python
-------------------------------------

Object-Oriented Programming is a programming paradigm in which
complex structures and processes are decomposed into `classes`:dt:,
each encapsulating a single data type and the legal operations on
that type.  In this section we show you how to create simple data
classes and processing classes by example.  For a systematic
introduction to Object-Oriented design, please see the Further
Reading section at the end of this chapter.

Data Classes: Trees in NLTK
---------------------------

An important data type in language processing is the syntactic tree.
Here we will review the parts of the NLTK code that defines the ``Tree``
class.  

The first line of a class definition is the ``class`` keyword followed
by the class name, in this case ``Tree``.  This class is derived from
Python's built-in ``list`` class, permitting us to use standard list
operations to access the children of a tree node.

    >>> class Tree(list):

Next we define the `initializer`:dt: ``__init__()``;
Python knows to call this function when you ask for a new tree object
by writing ``t = Tree(node, children)``.  The constructor's first argument
is special, and is standardly called ``self``, giving us a way to
refer to the current object from within its definition.  This
particular constructor calls the list initializer (similar to calling ``self =
list(children)``), then defines the ``node`` property of a tree.

.. doctest-ignore::
    ...     def __init__(self, node, children):
    ...         list.__init__(self, children)
    ...         self.node = node

Next we define another special function that Python knows to call when
we index a Tree.  The first case is the simplest, when the index is an
integer, e.g. ``t[2]``, we just ask for the list item in the obvious
way.  The other cases are for handling slices, like ``t[1:2]``, or ``t[:]``.

.. doctest-ignore::
    ...     def __getitem__(self, index):
    ...         if isinstance(index, int):
    ...             return list.__getitem__(self, index)
    ...         else:
    ...             if len(index) == 0:
    ...                 return self
    ...             elif len(index) == 1:
    ...                 return self[int(index[0])]
    ...             else:
    ...                 return self[int(index[0])][index[1:]]
    ...     

.. SB: what is the len(index) == 0 case for???

This method was for accessing a child node.  Similar methods are
provided for setting and deleting a child (using ``__setitem__``)
and ``__delitem__``).

Two other special member functions are ``__repr__()`` and ``__str__()``.
The ``__repr__()`` function produces a string representation of the
object, one that can be executed to re-create the object, and is
accessed from the interpreter simply by typing the name of the object
and pressing 'enter'.  The ``__str__()`` function produces a human-readable
version of the object; here we call a pretty-printing function we have
defined called ``pp()``.

.. doctest-ignore::
    ...     def __repr__(self):
    ...         childstr = ' '.join([repr(c) for c in self])
    ...         return '(%s: %s)' % (self.node, childstr)
    ...     def __str__(self):
    ...         return self.pp()


Next we define some member functions that do other standard operations
on trees.  First, for accessing the leaves:

.. doctest-ignore::
    ...     def leaves(self):
    ...         leaves = []
    ...         for child in self:
    ...             if isinstance(child, Tree):
    ...                 leaves.extend(child.leaves())
    ...             else:
    ...                 leaves.append(child)
    ...         return leaves


Next, for computing the height:

.. doctest-ignore::
    ...     def height(self):
    ...         max_child_height = 0
    ...         for child in self:
    ...             if isinstance(child, Tree):
    ...                 max_child_height = max(max_child_height, child.height())
    ...             else:
    ...                 max_child_height = max(max_child_height, 1)
    ...         return 1 + max_child_height

And finally, for enumerating all the subtrees (optionally filtered):

.. doctest-ignore::
    ...     def subtrees(self, filter=None):
    ...         if not filter or filter(self):
    ...             yield self
    ...         for child in self:
    ...             if isinstance(child, Tree):
    ...                 for subtree in child.subtrees(filter):
    ...                     yield subtree


Processing Classes: N-gram Taggers in NLTK
------------------------------------------

This section will discuss the ``tag.ngram`` module.




----------------
Algorithm Design
----------------

An *algorithm* is a "recipe" for solving a problem.  For example,
to multiply 16 by 12 we might use any of the following methods:

1. Add 16 to itself 12 times over
#. Perform "long multiplication", starting with the least-significant
   digits of both numbers
#. Look up a multiplication table
#. Repeatedly halve the first number and double the second,
   16*12 = 8*24 = 4*48 = 2*96 = 192
#. Do 10*12 to get 120, then add 6*12
#. Rewrite 16*12 as (x+2)(x-2), remember that 14*14=196, and add (+2)(-2) = -4

Each of these methods is a different algorithm, and requires different
amounts of computation time and different amounts of intermediate
information to store.  A similar situation holds for many other
superficially simple tasks, such as sorting a list of words.

Sorting Algorithms
------------------

Now, as we saw above, Python provides a built-in function ``sort()`` that
performs this task efficiently.  However, NLTK also provides
several algorithms for sorting lists, to illustrate the variety of
possible methods.  To illustrate the difference in efficiency, we
will create a list of 1000 numbers, randomize the list, then sort it,
counting the number of list manipulations required.

  >>> from random import shuffle
  >>> a = range(1000)                     # [0,1,2,...999]
  >>> shuffle(a)                          # randomize

Now we can try a simple sort method called *bubble sort*, that
scans through the list many times, exchanging adjacent items if
they are out of order.  It sorts the list ``a`` in-place, and returns
the number of times it modified the list:

  >>> from nltk.misc import sort
  >>> sort.bubble(a)
  250918

We can try the same task using various sorting algorithms.  Evidently
*merge sort* is much better than bubble sort, and *quicksort* is better still.

  >>> shuffle(a); sort.merge(a)
  6175
  >>> shuffle(a); sort.quick(a)
  2378

Readers are encouraged to look at ``nltk.misc.sort`` to see how
these different methods work.  The collection of NLTK modules
exemplify a variety of algorithm design techniques, including
brute-force, divide-and-conquer, dynamic programming, and greedy search.
Readers who would like a systematic introduction to algorithm design
should consult the resources mentioned at the end of this tutorial.

Decorate-Sort-Undecorate
------------------------

In Chapter chap-structured-programming_ we saw how to sort a list of items
according to some property of the list.

    >>> words = 'I turned off the spectroroute'.split()
    >>> words.sort(cmp)
    >>> words
    ['I', 'off', 'spectroroute', 'the', 'turned']
    >>> words.sort(lambda x, y: cmp(len(y), len(x)))
    >>> words
    ['spectroroute', 'turned', 'off', 'the', 'I']

This is inefficient when the list of items gets long, as
we compute ``len()`` twice for every comparison (about 2nlog(n) times).
The following is more efficient:

    >>> [pair[1] for pair in sorted((len(w), w) for w in words)[::-1]]
    ['spectroroute', 'turned', 'the', 'off', 'I']

This technique is called `decorate-sort-undecorate`:dt:.
We can compare its performance by timing how long it takes to
execute it a million times.

    >>> from timeit import Timer
    >>> Timer("sorted(words, lambda x, y: cmp(len(y), len(x)))",
    ...       "words='I turned off the spectroroute'.split()").timeit()
    8.3548779487609863
    >>> Timer("[pair[1] for pair in sorted((len(w), w) for w in words)]",
    ...      "words='I turned off the spectroroute'.split()").timeit()
    9.9698889255523682
    
MORE: consider what happens as the lists get longer...

.. finding maximum value of list: sort() vs max()


Another example: sorting dates of the form "1 Jan 1970"


    >>> month_index = {
    ...     "Jan" : 1, "Feb" : 2,  "Mar" : 3,  "Apr" : 4,
    ...     "May" : 5, "Jun" : 6,  "Jul" : 7,  "Aug" : 8,
    ...     "Sep" : 9, "Oct" : 10, "Nov" : 11, "Dec" : 12
    ... }
    >>> def date_cmp(date_string1, date_string2):
    ...     (d1,m1,y1) = date_string1.split()
    ...     (d2,m2,y2) = date_string2.split()
    ...     conv1 = y1, month_index[m1], d1
    ...     conv2 = y2, month_index[m2], d2
    ...     return cmp(a2, b2)
    >>> sort(date_list, date_cmp)

The comparison function says that we compare two times of the
form ``('Mar', '2004')`` by reversing the order of the month and
year, and converting the month into a number to get ``('2004', '3')``,
then using Python's built-in ``cmp`` function to compare them.

Now do this using decorate-sort-undecorate, for large data size

Time comparison


Brute Force
-----------

Wordfinder Puzzle

Here we will generate a grid of letters, containing words found in the
dictionary.  First we remove any duplicates and disregard the order in
which the lexemes appeared in the dictionary.  We do this by converting
it to a set, then back to a list.  Then we select the first 200 words,
and then only keep those words having a reasonable length.

    >>> words = list(set(lexemes))
    >>> words = words[:200]
    >>> words = [w for w in words if 3 <= len(w) <= 12]

Now we generate the wordfinder grid, and print it out.

    >>> from nltk.misc.wordfinder import wordfinder
    >>> grid, used = wordfinder(words)
    >>> for i in range(len(grid)):
    ...     for j in range(len(grid[i])):
    ...         print grid[i][j],
    ...     print
    O G H K U U V U V K U O R O V A K U N C
    K Z O T O I S E K S N A I E R E P A K C
    I A R A A K I O Y O V R S K A W J K U Y
    L R N H N K R G V U K G I A U D J K V N
    I I Y E A U N O K O O U K T R K Z A E L
    A V U K O X V K E R V T I A A E R K R K
    A U I U G O K U T X U I K N V V L I E O
    R R K O K N U A J Z T K A K O O S U T R
    I A U A U A S P V F O R O O K I C A O U
    V K R R T U I V A O A U K V V S L P E K
    A I O A I A K R S V K U S A A I X I K O
    P S V I K R O E O A R E R S E T R O J X
    O I I S U A G K R O R E R I T A I Y O A
    R R R A T O O K O I K I W A K E A A R O
    O E A K I K V O P I K H V O K K G I K T
    K K L A K A A R M U G E P A U A V Q A I
    O O O U K N X O G K G A R E A A P O O R
    K V V P U J E T Z P K B E I E T K U R A
    N E O A V A E O R U K B V K S Q A V U E
    C E K K U K I K I R A E K O J I Q K K K

Finally we generate the words which need to be found.

    >>> for i in range(len(used)):
    ...     print "%-12s" % used[i],
    ...     if float(i+1)%5 == 0: print
    KOKOROPAVIRA KOROROVIVIRA KAEREASIVIRA KOTOKOTOARA  KOPUASIVIRA 
    KATAITOAREI  KAITUTUVIRA  KERIKERISI   KOKARAPATO   KOKOVURITO  
    KAUKAUVIRA   KOKOPUVIRA   KAEKAESOTO   KAVOVOVIRA   KOVAKOVARA  
    KAAREKOPIE   KAEPIEVIRA   KAPUUPIEPA   KOKORUUTO    KIKIRAEKO   
    KATAAVIRA    KOVOKOVOA    KARIVAITO    KARUVIRA     KAPOKARI    
    KUROVIRA     KITUKITU     KAKUPUTE     KAEREASI     KUKURIKO    
    KUPEROO      KAKAPUA      KIKISI       KAVORA       KIKIPI      
    KAPUA        KAARE        KOETO        KATAI        KUVA        
    KUSI         KOVO         KOAI       


Problem Transformation (aka Transform-and-Conquer)
--------------------------------------------------

Find words which, when reversed, make legal words.
Extremely wasteful brute force solution:

    >>> words = nltk.corpus.words.words('en')
    >>> for word1 in words:
    ...     for word2 in words:
    ...         if word1 == word2[::-1]:
    ...             print word1
    
More efficient:

    >>> wordlist = set(words)
    >>> rev_wordlist = set(word[::-1] for word in words)
    >>> sorted(wordlist.intersection(rev_wordlist))
    ['ah', 'are', 'bag', 'ban', 'bard', 'bat', 'bats', 'bib', 'bob', 'boob', 'brag',
    'bud', 'buns', 'bus', 'but', 'civic', 'dad', 'dam', 'decal', 'deed', 'deeps', 'deer',
    'deliver', 'denier', 'desserts', 'deus', 'devil', 'dial', 'diaper', 'did', 'dim',
    'dog', 'don', 'doom', 'drab', 'draw', 'drawer', 'dub', 'dud', 'edit', 'eel', 'eke',
    'em', 'emit', 'era', 'ere', 'evil', 'ewe', 'eye', 'fires', 'flog', 'flow', 'gab',
    'gag', 'garb', 'gas', 'gel', 'gig', 'gnat', 'god', 'golf', 'gulp', 'gum', 'gums',
    'guns', 'gut', 'ha', 'huh', 'keel', 'keels', 'keep', 'knits', 'laced', 'lager',
    'laid', 'lap', 'lee', 'leek', 'leer', 'leg', 'leper', 'level', 'lever', 'liar',
    'live', 'lived', 'loop', 'loops', 'loot', 'loots', 'mad', 'madam', 'me', 'meet', 
    'mets', 'mid', 'mood', 'mug', 'nab', 'nap', 'naps', 'net', 'nip', 'nips', 'no',
    'nod', 'non', 'noon', 'not', 'now', 'nun', 'nuts', 'on', 'pal', 'pals', 'pan',
    'pans', 'par', 'part', 'parts', 'pat', 'paws', 'peek', 'peels', 'peep', 'pep',
    'pets', 'pin', 'pins', 'pip', 'pit', 'plug', 'pool', 'pools', 'pop', 'pot', 'pots',
    'pup', 'radar', 'rail', 'rap', 'rat', 'rats', 'raw', 'redder', 'redraw', 'reed',
    'reel', 'refer', 'regal', 'reined', 'remit', 'repaid', 'repel', 'revel', 'reviled',
    'reviver', 'reward', 'rotator', 'rotor', 'sag', 'saw', 'sees', 'serif', 'sexes',
    'slap', 'sleek', 'sleep', 'sloop', 'smug', 'snap', 'snaps', 'snip', 'snoops',
    'snub', 'snug', 'solos', 'span', 'spans', 'spat', 'speed', 'spin', 'spit', 'spool',
    'spoons', 'spot', 'spots', 'stab', 'star', 'stem', 'step', 'stew', 'stink', 'stool',
    'stop', 'stops', 'strap', 'straw', 'stressed', 'stun', 'sub', 'sued', 'swap', 'tab',
    'tang', 'tap', 'taps', 'tar', 'teem', 'ten', 'tide', 'time', 'timer', 'tip', 'tips',
    'tit', 'ton', 'tool', 'top', 'tops', 'trap', 'tub', 'tug', 'war', 'ward', 'warder',
    'warts', 'was', 'wets', 'wolf', 'won']

Observe that this output contains redundant information; each word and its reverse is
included.  How could we remove this redundancy?

Presorting, sets:

Find words which have at least (or exactly) one instance of all vowels.
Instead of writing extremely complex regular expressions, some simple preprocessing
does the trick:

    >>> words = ["sequoia", "abacadabra", "yiieeaouuu!"]
    >>> vowels = "aeiou"
    >>> [w for w in words if set(w).issuperset(vowels)]
    ['sequoia', 'yiieeaouuu!']
    >>> [w for w in words if sorted(c for c in w if c in vowels) == list(vowels)]
    ['sequoia']


Space-Time Tradeoffs
--------------------

Indexing


Fuzzy Spelling

Confusible sets of segments: if two segments are confusible, map them
to the same integer.

    >>> group = {
    ...     ' ':0,                     # blank (for short words)
    ...     'p':1,  'b':1,  'v':1,     # labials
    ...     't':2,  'd':2,  's':2,     # alveolars
    ...     'l':3,  'r':3,             # sonorant consonants
    ...     'i':4,  'e':4,             # high front vowels
    ...     'u':5,  'o':5,             # high back vowels
    ...     'a':6                      # low vowels
    ... }

Soundex: idea of a signature.  Words with the same signature
considered confusible.  Consider first letter of a word to be so
cognitively salient that people will not get it wrong.

    >>> def soundex(word):
    ...     if len(word) == 0: return word  # sanity check
    ...     word += '    '                  # ensure word long enough
    ...     c0 = word[0].upper()
    ...     c1 = group[word[1]]
    ...     cons = filter(lambda x: x in 'pbvtdslr ', word[2:])
    ...     c2 = group[cons[0]]
    ...     c3 = group[cons[1]]
    ...     return "%s%d%d%d" % (c0, c1, c2, c3)
    >>> print soundex('kalosavi')
    K632
    >>> print soundex('ti')
    T400
  
Now we can build a soundex index of the lexicon:

    >>> soundex_idx = nltk.defaultdict(set)
    >>> for lex in lexemes:
    ...     code = soundex(lex)
    ...     soundex_idx[code].add(lex)

We should sort these candidates by proximity with the target word.

    >>> def fuzzy_spell(target):
    ...     scored_candidates = []
    ...     code = soundex(target)
    ...     for word in soundex_idx[code]:
    ...         dist = nltk.edit_dist(word, target)
    ...         scored_candidates.append((dist, word))
    ...     scored_candidates.sort()
    ...     return [w for (d,w) in scored_candidates[:10]]

Finally, we can look up a word to get approximate matches:

    >>> fuzzy_spell('kokopouto')
    ['kokopeoto', 'kokopuoto', 'kokepato', 'koovoto', 'koepato', 'koikoipato', 'kooupato', 'kopato', 'kopiito', 'kovoto']
    >>> fuzzy_spell('kogou')
    ['kogo', 'koou', 'kokeu', 'koko', 'kokoi', 'kokoo', 'koku', 'kooe', 'kooku', 'kou']




------
Search
------

Many NLP tasks can be construed as search problems.
For example, the task of a parser is to identify one or more
parse trees for a given sentence.  As we saw in Part II,
there are several algorithms for parsing.  A `recursive descent parser`:idx:
performs `backtracking search`:dt:, applying grammar productions in turn
until a match with the next input word is found, and backtracking when
there is no match.  We saw in Chapter chap-advanced-parsing_ that
the space of possible parse trees is very large; a parser can be thought
of as providing a relatively efficient way to find the right solution(s)
within a very large space of candidates.

As another example of search, suppose we want to find the most complex
sentence in a text corpus.  Before we can begin we have to be explicit
about how the complexity of a sentence is to be measured: word count,
verb count, character count, parse-tree depth, etc.  In the context
of learning this is known as the `objective function`:dt:, the property
of candidate solutions we want to optimize.

In this section we will explore some other search methods that are
useful in NLP.  For concreteness we will apply them to the problem
of learning word segmentations in text, following the work of [Brent1995]_.
Put simply, this is the problem faced by a language learner in dividing
a continuous speech stream into individual words.  We will consider this
problem from the perspective of a child hearing utterances from a parent, e.g.

.. _kitty:
.. ex::
  .. ex:: doyouseethekitty
  .. ex:: seethedoggy
  .. ex:: doyoulikethekitty
  .. ex:: likethedoggy

Our first challenge is simply to represent the problem: we need to find
a way to separate the text content from the segmentation.  We will borrow
an idea from IOB-tagging (Chapter chap-chunk_), by annotating each character
with a boolean value to indicate whether or not a word-break appears after
the character.  We will assume that the learner is given the utterance breaks,
since these often correspond to extended pauses.  Here is a possible representation,
including the initial and target segmentations:

    >>> text = "doyouseethekittyseethedoggydoyoulikethekittylikethedoggy"
    >>> seg1 = "0000000000000001000000000010000000000000000100000000000"
    >>> seg2 = "0100100100100001001001000010100100010010000100010010000"

Observe that the segmentation strings consist of zeros and ones.  They
are one character shorter than the source text, since a text of length
`n`:math: can only be broken up in `n-1`:math: places.

Now let's check that our chosen representation is effective.  We need to make
sure we can read segmented text from the representation.  The following function,
``segment()``, takes a text string and a segmentation string, and returns a list
of strings.

.. pylisting:: segment
   :caption: Program to Reconstruct Segmented Text from String Representation

   def segment(text, segs):
       words = []
       last = 0
       for i in range(len(segs)):
	       if segs[i] == '1':
	           words.append(text[last:i+1])
	           last = i+1
	   words.append(text[last:])
	   return words
    
   >>> segment(text, seg1)
   ['doyouseethekitty', 'seethedoggy', 'doyoulikethekitty', 'likethedoggy']
   >>> segment(text, seg2)
   ['do', 'you', 'see', 'the', 'kitty', 'see', 'the', 'doggy', 'do', 'you',
    'like', 'the', kitty', 'like', 'the', 'doggy']

Now the learning task becomes a search problem: find the bit string that causes
the text string to be correctly segmented into words.  Our first task is done: we have
represented the problem in a way that allows us to reconstruct the data, and to
focus on the information to be learned.

Now that we have effectively represented the problem we need to choose the objective
function.  We assume the learner is acquiring words and storing them in an internal lexicon.
Given a suitable lexicon, it is possible to reconstruct the source text as a sequence of
lexical items.  Following [Brent1995]_, we can use the size of the lexicon and the amount
of information needed to reconstruct the source text as the basis for an objective function, as shown
in Figure brent_.

.. _brent:
.. figure:: ../images/brent.png
   :scale: 30

   Calculation of Objective Function for Given Segmentation

It is a simple matter to implement this objective function, as shown in Listing
evaluate_.

.. pylisting:: evaluate
   :caption: Computing the Cost of Storing the Lexicon and Reconstructing the Source Text

   def evaluate(text, segs):
       import string
       words = segment(text, segs)
       text_size = len(words)
       lexicon_size = len(' '.join(list(set(words))))
       return text_size + lexicon_size

   >>> text = "doyouseethekittyseethedoggydoyoulikethekittylikethedoggy"
   >>> seg3 = "0000100100000011001000000110000100010000001100010000001"
   >>> segment(text, seg3)
   ['doyou', 'see', 'thekitt', 'y', 'see', 'thedogg', 'y', 'doyou', 'like',
    'thekitt', 'y', 'like', 'thedogg', 'y']
   >>> evaluate(text, seg3)
   47

Exhaustive Search
-----------------

* brute-force approach
* enumerate search space, evaluate at each point
* this example: search space size is 2\ `55`:superscript: = 36,028,797,018,963,968

For a computer that can do 100,000 evaluations per second, this
would take over 10,000 years!

Backtracking search -- saw this in the recursive descent parser.

Hill-Climbing Search
--------------------

Starting from a given location in the search space, evaluate nearby locations and move to
a new location only if it is an improvement on the current location.

.. pylisting:: hill-climb
   :caption: Hill-Climbing Search

   def flip(segs, pos):
       return segs[:pos] + `1-int(segs[pos])` + segs[pos+1:]
   def hill_climb(text, segs, iterations):
       for i in range(iterations):
           pos, best = 0, evaluate(text, segs)
	       for i in range(len(segs)):
	           score = evaluate(text, flip(segs, i))
	           if score < best:
	               pos, best = i, score
	       if pos != 0:
	           segs = flip(segs, pos)
	           print evaluate(text, segs), segment(text, segs)
	   return segs

   >>> print evaluate(text, seg1), segment(text, seg1)
   63 ['doyouseethekitty', 'seethedoggy', 'doyoulikethekitty', 'likethedoggy']
   >>> hill_climb(text, segs1, 20)
   61 ['doyouseethekittyseethedoggy', 'doyoulikethekitty', 'likethedoggy']
   59 ['doyouseethekittyseethedoggydoyoulikethekitty', 'likethedoggy']
   57 ['doyouseethekittyseethedoggydoyoulikethekittylikethedoggy']

Non-Deterministic Search
------------------------

* Simulated annealing

.. pylisting:: anneal
   :caption: Non-Deterministic Search Using Simulated Annealing

   def flip_n(segs, n):
	   for i in range(n):
	       segs = flip(segs, randint(0,len(segs)-1))
	   return segs
   def anneal(text, segs, iterations, rate):
	   distance = float(len(segs))
	   while distance > 0.5:
	       best_segs, best = segs, evaluate(text, segs)
	       for i in range(iterations):
	           guess = flip_n(segs, int(round(distance)))
	           score = evaluate(text, guess)
	           if score < best:
	               best = score
	               best_segs = guess
	       segs = best_segs
	       score = best
	       distance = distance/rate
	       print evaluate(text, segs),
	   print
	   return segs
    
   >>> anneal(text, segs, 5000, 1.2)
   60 ['doyouseetheki', 'tty', 'see', 'thedoggy', 'doyouliketh', 'ekittylike', 'thedoggy']
   58 ['doy', 'ouseetheki', 'ttysee', 'thedoggy', 'doy', 'o', 'ulikethekittylike', 'thedoggy']
   56 ['doyou', 'seetheki', 'ttysee', 'thedoggy', 'doyou', 'liketh', 'ekittylike', 'thedoggy']
   54 ['doyou', 'seethekit', 'tysee', 'thedoggy', 'doyou', 'likethekittylike', 'thedoggy']
   53 ['doyou', 'seethekit', 'tysee', 'thedoggy', 'doyou', 'like', 'thekitty', 'like', 'thedoggy']
   51 ['doyou', 'seethekittysee', 'thedoggy', 'doyou', 'like', 'thekitty', 'like', 'thedoggy']
   42 ['doyou', 'see', 'thekitty', 'see', 'thedoggy', 'doyou', 'like', 'thekitty', 'like', 'thedoggy']

----------
Miscellany
----------

.. _sec-sets:

-------------------------------
Sets and Mathematical Functions
-------------------------------

Sets
----

Knowing a bit about sets will come in useful when you look at 
Chapter chap-semantics_.
A set is a collection of entities, called the `members`:dt: of the
set. Sets can be finite or infinite, or even empty.
In Python, we can define a set just by listing its members; the
notation is similar to specifying a list:

    >>> set1 = set(['a', 'b', 1, 2, 3])
    >>> set1
    set(['a', 1, 2, 'b', 3])

|nopar|
In mathematical notation, we would specify this set as:

.. ex:: {'a', 'b', 1, 2, 3}

Set membership is a relation |mdash| we can ask whether some entity
`x`:math: belongs to a set `A`:math: (in mathematical notation,
written `x`:math: |element| `A`:math:).

    >>> 'a' in set1
    True
    >>> 'c' in set1
    False

|nopar|
However, sets differ from lists in that they are `unordered`:em: collections.
Two sets are equal if and only if they have exactly the same members:

    >>> set2 = set([3, 2, 1, 'b', 'a'])
    >>> set1 == set2
    True

The `cardinality`:dt: of a set `A`:math: (written |pipe|\ `A`:math:\
|pipe|) is the number of members in `A`:math:. We can get this value
using the ``len()`` function:

    >>> len(set1)
    5

The argument to the ``set()`` constructor can be any sequence, including
a string, and just calling the constructor with no argument creates
the empty set (written |empty|).

    >>> set('123')
    set(['1', '3', '2'])
    >>> a = set()
    >>> b = set()
    >>> a == b
    True


We can construct new sets out of old ones. The `union`:dt: of two sets
`A`:math: and `B`:math: (written `A`:math: |union| `B`:math:) is the set
of elements that belong to `A`:math: or `B`:math:. Union is
represented in Python with ``|``:

    >>> odds = set('13579')
    >>> evens = set('02468')
    >>> numbers = odds | evens
    >>> numbers
    set(['1', '0', '3', '2', '5', '4', '7', '6', '9', '8'])

The `intersection`:dt: of two sets `A`:math: and `B`:math: (written
`A`:math: |intersect| `B`:math:) is the set of elements that belong
to both `A`:math: and `B`:math:. Intersection is represented in Python
with ``&``. If the intersection of two sets is empty, they are said to
be `disjoint`:dt:.

    >>> ints
    set(['1', '0', '2', '-1', '-2'])
    >>> ints & nats
    set(['1', '0', '2'])
    >>> odds & evens
    set([])

The `(relative) complement`:dt: of two sets `A`:math: and `B`:math: (written 
`A`:math: |diff| `B`:math:)  is the set of
elements that belong to `A`:math: but not `B`:math:. Complement is represented
in Python with ``-``. 

    >>> nats - ints
    set(['3', '5', '4', '7', '6', '9', '8'])
    >>> odds == nats - evens
    True
    >>> odds == odds - set()
    True

So far, we have described how to define 'basic' sets and how to form
new sets out of those basic ones. All the basic sets have been
specified by listing all their members. Often we want to specify set
membership more succinctly:

.. _set1:
.. ex:: the set of positive integers less than 10

.. _set2:
.. ex:: the set of people in Melbourne with red hair

|nopar| 
We can informally write these sets using the
following `predicate notation`:dt:\ :

.. _set3:
.. ex:: {`x`:math: | `x`:math: is a positive integer less than 10}

.. _set4:
.. ex:: {`x`:math: | `x`:math: is a person in Melbourne with red hair}

In axiomatic set theory, the axiom schema of comprehension states that
given a one-place predicate `P`:math:, there is set `A`:math: such
that for all `x`:math:, `x`:math: belongs to `A`:math: if and only if
(written |iff|) `P(x)`:math: is true:

.. _compax:
.. ex:: |exists|\ `A`:math:\ |forall|\ `x`:math:.(`x`:math: |element|
        `A`:math: |iff| `P(x)`:math:\ )

|nopar| 
From a computational point of view, compax_ is
problematic: we have to treat sets as finite objects in the computer,
but there is nothing to stop us defining infinite sets using
comprehension. Now, there is a variant of compax_, called the axiom of
restricted comprehension, that allows us to specify a set `A`:math:
with a predicate `P`:math: so long as we only consider `x`:math:\ s
which belong to some `already defined set`:em: `B`:math:\:

.. _comprax:
.. ex:: |forall|\ `B`:math: |exists|\ `A`:math:\ |forall|\ `x`:math:.
        (`x`:math: |element| `A`:math: |iff| `x`:math: |element|
	`B`:math: |wedge|  `P(x)`:math:\ )

|nopar| (For all sets `B`:math: there is a set `A`:math: such that for all
`x`:math:, `x`:math: belongs to `A`:math: if and only if `x`:math:
belongs to `B`:math: and `P(x)`:math: is true.)
This is equivalent to the following set in predicate notation:

.. ex:: {`x`:math: | `x`:math: |element| `B`:math: |wedge| `P(x)`:math:\ )

|nopar|
comprax_ corresponds pretty much to what we get with list
comprehension in Python: if you already have a list, then you can
define a new list in terms of the old one, using an ``if``
condition. In other words, listcomp_ is the Python counterpart of
comprax_.

.. _listcomp:
.. ex:: ``set([x for x in B if P(x)])``

To illustrate this further, the following list comprehension relies on
the existence of the previously defined set ``nats`` (``n % 2`` is the
remainder when ``n`` is divided by ``2``):

   >>> nats = set(range(10))
   >>> evens1 = set([n for n in nats if n % 2 == 0])
   >>> evens1
   set([0, 8, 2, 4, 6])

|nopar| Now, when we defined ``evens`` before, what we actually had
was a set of `strings`:em:, rather than Python integers. But we can
use ``int`` to coerce the strings to be of the right type:

   >>> evens2 = set([int(n) for n in evens])
   >>> evens1 == evens2
   True

If every member of `A`:math: is also a member of `B`:math:, we say
that `A`:math: is a subset of `B`:math: (written `A`:math: |subset|
`B`:math:). The subset relation is represented
in Python with ``<=``. 

    >>> evens1 <= nats
    True
    >>> set() <= nats
    True
    >>> evens1 <= evens1
    True

As the above examples show, `B`:math: can contain more members than
`A`:math: for `A`:math: |subset|
`B`:math: to hold, but this need not be so. Every set is a subset of
itself. To exclude the case where a set is a subset of itself, we use
the relation `proper subset`:dt: (written `A`:math: |propsubset|
`B`:math:). In Python, this relation is represented as ``<``.

    >>> evens1 < nats
    True
    >>> evens1 < evens1
    False

Sets can contain other sets. For instance, the set `A`:math: =
{{`a`:math:}, {`b`:math:} } contains the two singleton sets
{`a`:math:} and {`b`:math:}. Note that {`a`:math:} |subset| `A`:math:
does not hold, since `a`:math: belongs to {`a`:math:} but not
to `A`:math:. In Python, it is a bit more awkward to specify sets
whose members are also sets; the latter have to be defined as
``frozenset``\ s, i.e., immutable objects.

    >>> a = frozenset('a')
    >>> aplus = set([a])
    >>> aplus
    set([frozenset(['a'])])

We also need to be careful to distinguish between the empty set |empty| and
the set whose only member is the empty set: {|empty|}.

Tuples
------

We write |langle|\ `x`:math:\ :sub:`1`, |dots|\ , `x`:math:\ :sub:`n`\
|rangle| for the `ordered n-tuple`:dt: of objects 
`x`:math:\ :sub:`1`, |dots|\ , `x`:math:\ :sub:`n`, where `n`:math:
|geq| 0. These are exactly the same as Python tuples. Two tuples are
equal only if they have the same lengths, and the same objects in the
same order.

    >>> tup1 = ('a', 'b', 'c')
    >>> tup2 = ('a', 'c', 'b')
    >>> tup1 == tup2
    False

|nopar| A tuple with just 2 elements is called an `ordered pair`:dt:, with
just three elements, an `ordered triple`:dt:, and so on.

Given two sets `A`:math: and `B`:math:, we can form a set of ordered
pairs by drawing the first member of the pair from `A`:math: and the
second from `B`:math:. The `Cartesian product` of  `A`:math: and
`B`:math:, written `A`:math: |times| `B`:math:, is the set of all such
pairs. More generally, we have for any sets 
`S`:math:\ :sub:`1`, |dots|\ , `S`:math:\ :sub:`n`,

.. ex:: `S`:math:\ :sub:`1` |times| |dots| |times| `S`:math:\ :sub:`n` 
        = {|langle|\ `x`:math:\ :sub:`1`, |dots|\ , `x`:math:\ :sub:`n`\
        |rangle| |pipe| `x`:math:\ :sub:`i` |element| `S`:math:\ :sub:`i`}

In Python, we can build Cartesian products using list
comprehension. As you can see, the sets in a Cartesian product don't
have to be distinct.

    >>> A = set([1, 2, 3])
    >>> B = set('ab')
    >>> AxB = set([(a, b) for a in A for b in B])
    >>> AxB
    set([(1, 'b'), (3, 'b'), (3, 'a'), (2, 'a'), (2, 'b'), (1, 'a')])
    >>> AxA = set([(a1, a2) for a1 in A for a2 in A])
    >>> AxA
    set([(1, 2), (3, 2), (1, 3), (3, 3), (3, 1), (2, 1),
    (2, 3), (2, 2), (1, 1)])


.. mention S |sup|`n` ?

Relations and Functions
-----------------------

In general, a `relation`:dt: `R`:math: is a set of tuples. For
example, in set-theoretic terms, the binary relation `kiss`:lx:
is the set of all ordered pairs |langle|\ `x`:math:, `y`:math:\
|rangle| such that `x kisses y`:lx:. More formally, an `n-ary
relation`:dt: over sets `S`:math:\ :sub:`1`, |dots|\ , `S`:math:\
:sub:`n` is any set `R`:math: |subset| `S`:math:\ :sub:`1` |times|
|dots| |times| `S`:math:\ :sub:`n`.

Given a binary relation `R`:math: over two sets `A`:math: and
`B`:math:, not everything in `A`:math: need stand in the `R`:math:
relation to something in `B`:math:. As an illustration, consider the
set ``evens`` and the relation ``mod`` defined as follows:

    >>> evens = set([2, 4, 6, 8, 10])
    >>> mod = set([(m,n) for m in evens for n in evens if n % m == 0 and m < n])
    >>> mod
    set([(4, 8), (2, 8), (2, 6), (2, 4), (2, 10)])

|nopar| Now, ``mod`` |subset| ``evens`` |times| ``evens``, but there
are elements of ``evens``, namely ``6``, ``8`` and ``10``, that do
not stand in the ``mod`` relation to anything else in ``evens``. In
this case, we say that only ``2`` and ``4`` are in the `domain`:dt: of
the ``mod`` relation. More formally, for a relation `R`:math: over
`A`:math: |times| `B`:math:, we define

.. ex::  `dom(R) = {x`:math: |pipe| |exists|\ `y.`:math:\
         |langle|\ `x`:math:, `y`:math:\ |rangle| |element|  
         `A`:math: |times| `B`:math:\ }
         
|nopar| Correspondingly, the set of entities in `B`:math: which are the second
member of a pair in `R`:math: is called the `range`:dt: of `R`:math:,
written `ran(R)`:math:.
 
We can visually represent the relation ``mod`` by drawing arrows to
indicate elements that stand in the relation, as shown in Figure modrel_.

.. _modrel:
.. figure:: ../images/mod_relation.png
   :scale: 30

   Visual Representation of a relation


|nopar| The domain and range of the relation are shown as shaded areas
in Figure modrel_.

.. 
   For sets `A`:math: and `B`:math:, a (set-theoretic) `function`:dt:
   from `A`:math: to `B`:math: is a relation `f`:math: |subset| `A`:math:
   |times| `B`:math: such that for every `a`:math: |element| `A`:math:
   there is at most one `b`:math: |element| `B`:math: such that |langle|\
   `a`:math:, `b`:math:\ |rangle|.
   Thus, the ``mod`` relation is not a function, since the element ``2``
   is paired with four items, not just one. By contrast, the relation
   ``addtwo`` defined as follows `is`:em: a function:

A relation `R`:math: |subset| `A`:math: |times| `B`:math: is a 
(set-theoretic) `function`:dt: just in case it meets the following
two conditions:

1. For every `a`:math: |element| `A`:math: there is at most one
   `b`:math: |element| `B`:math: such that |langle|\ `a`:math:,
   `b`:math:\ |rangle|.

2. The domain of  `R`:math: is equal to `A`:math:.


|nopar| Thus, the ``mod`` relation defined earlier is not a function, since
the element ``2`` is paired with four items, not just one. By
contrast, the relation ``doubles`` defined as follows `is`:em: a
function:

    >>> odds = set([1, 2, 3, 4, 5])
    >>> doubles = set([(m,n) for m in odds for n in evens if n == m * 2])
    >>> doubles
    set([(1, 2), (5, 10), (2, 4), (3, 6), (4, 8)])



If `f`:math: is a function |subset| `A`:math: |times| `B`:math:, then
we also say that `f`:math: is a function from `A`:math: to
`B`:math:. We also write this as `f`:math:\ : `A`:math: |mapsto|
`B`:math:. If |langle|\ `x`:math:, `y`:math:\ |rangle| |element|
`f`:math:, then we write `f(x) = y`:math:. Here, `x`:math: is called
an `argument`:dt: of `f`:math: and `y`:math: is a `value`:dt:. In such
a case, we may also say that `f`:math: maps `x`:math: to `y`:math:.

Given that functions always map a given argument to a single value, we
can also represent them in Python using dictionaries (which
incidentally are also known as `mapping`:dt: objects). The
``update()`` method on dictionaries can take as input any iterable of
key/value pairs, including sets of two-membered tuples:

    >>> d = {}
    >>> d.update(doubles)
    >>> d
    {1: 2, 2: 4, 3: 6, 4: 8, 5: 10}


A function `f`:math:\ : `S`:math:\ :sub:`1` |times| |dots| |times|
`S`:math:\ :sub:`n` |mapsto| `T`:math: is called an `n-ary`:dt:
function; we usually write `f`:math:\ (`s`:math:\ :sub:`1`, |dots|,
`s`:math:\ :sub:`n`) rather than `f`:math:\ (|langle|\ `s`:math:\
:sub:`1`, |dots|, `s`:math:\ :sub:`n`\ |rangle|\ ). For sets `A`:math:
and `B`:math:, we write `A`:math:\ :sup:`B` for the set of all
functions from `A`:math: to `B`:math:, that is {`f`:math: |pipe| `f:
A`:math: |mapsto| `B`:math:}.
If `S`:math: is a set, then we can define a corresponding function
`f`:math:\ :sub:`S` called the `characteristic function`:dt: of
`S`:math:, defined as follows:

.. ex:: | `f`:math:\ :sub:`S`\ `(x)`:math: = True if `x`:math: |element| `S`:math:
	| `f`:math:\ :sub:`S`\ `(x)`:math: = False if `x`:math: |nelement| `S`:math:

|nopar| `f`:math:\ :sub:`S` is a member of the set {\ *True*, *False*\
}\ :sup:`S`.

It can happen that a relation meets condition (1) above but fails
condition (2); such relations are called `partial functions`:dt:. For
instance, let's slightly modify the definition of ``doubles``:

    >>> doubles2 = set([(m,n) for m in evens for n in evens if n == m * 2])
    >>> doubles2
    set([(2, 4), (4, 8)])

|nopar| ``doubles2`` is a partial function since its domain is a proper subset of
``evens``. In such a case, we say that ``doubles2`` is `defined`:dt:
for ``2`` and ``4`` but  `undefined`:dt: for the other elements in
``evens``.


---------------
Further Reading
---------------

Object-Oriented programming


[Brent1995]

[Hunt1999PP]_

---------
Exercises
---------

1. |easy| Write a program to sort words by length.  Define a helper function
   ``cmp_len`` which uses the ``cmp`` comparison function on word
   lengths.

2. |soso| Consider the tokenized sentence
   ``['The', 'dog', 'gave', 'John', 'the', 'newspaper']``.
   Using the ``map()`` and ``len()`` functions, write a single line
   program to convert this list of tokens into a list of token
   lengths: ``[3, 3, 4, 4, 3, 9]``

#. |hard| **Statistically Improbable Phrases:**
   Design an algorithm to find the statistically improbable
   phrases of a document collection.
   http://www.amazon.com/gp/search-inside/sipshelp.html

#. |soso| Write a recursive function to produce an XML representation for a
   tree, with non-terminals represented as XML elements, and leaves represented
   as text content, e.g.:

|   <S>
|     <NP type="SBJ">
|       <NP>
|         <NNP>Pierre</NNP>
|         <NNP>Vinken</NNP>
|       </NP>
|       <COMMA>,</COMMA>

#. |soso| Consider again the problem of hyphenation across line-breaks.
   Suppose that you have successfully written a tokenizer that
   returns a list of strings, where some strings may contain
   a hyphen followed by a newline character, e.g. ``long-\nterm``.
   Write a function that iterates over the tokens in a list,
   removing the newline character from each, in each of the following
   ways:

   a) Use doubly-nested for loops.  The outer loop will iterate over
      each token in the list, while the inner loop will iterate over
      each character of a string.

   b) Replace the inner loop with a call to ``re.sub()``

   c) Finally, replace the outer loop with call to the ``map()``
      function, to apply this substitution to each token.

   d) Discuss the clarity (or otherwise) of each of these approaches.

#. |hard| Develop a simple extractive summarization tool, that prints the
   sentences of a document which contain the highest total word
   frequency.  Use ``FreqDist()`` to count word frequencies, and use
   ``sum`` to sum the frequencies of the words in each sentence.
   Rank the sentences according to their score.  Finally, print the *n*
   highest-scoring sentences in document order.  Carefully review the
   design of your program, especially your approach to this double
   sorting.  Make sure the program is written as clearly as possible.
   
#. |easy| For each of the following sets, write a specification by hand in
   predicate notation, and an implementation in Python using list
   comprehension.

   a. {2, 4, 8, 16, 32, 64}

   b. {2, 3, 5, 7, 11, 13, 17}

   c. {0, 2, -2, 4, -4, 6, -6, 8, -8}

   

#. |easy| The `powerset`:dt: of a set `A`:math: (written |power|\ `A`:math:\ ) is
   the set of all subsets of `A`:math:, including the empty set. List
   the members of the following sets:

   a.  |power|\ {`a`:math:, `b`:math:, `c`:math:\ }:

   b.  |power|\ {`a`:math:\ }

   c.  |power|\ {|empty|}

   d.  |power|\ |empty|

#. |soso| Write a Python function to compute the powerset of an arbitrary
   set. Remember that you will have to use ``frozenset`` for this.

#. |easy| Consider the relation ``doubles``, where ``evens`` is defined as in
   the text earlier:

     >>> doubles = set([(m,m*2) for m in evens])

   Is ``doubles`` a relation over ``evens``? Explain your answer.

#. |soso| What happens if you try to update a dictionary with a relation
   that is `not`:em: a function? 

#. |easy| Write a couple of Python functions that, for any set of pairs `R`:math:,
   return the domain and range of `R`:math:.

#. |soso| Let `S`:math: be a family of three children, {Bart, Lisa,
   Maggie}. Define relations  `R`:math: |subset| `S`:math: |times| `S`:math:
   such that:

   a. `dom(R)`:math: |propsubset| `S`:math:;

   #. `dom(R)`:math: = `S`:math:;

   #. `ran(R)`:math: = `S`:math:;

   #. `ran(R)`:math: = `S`:math:;

   #. `R`:math: is a total function on `S`:math:.

   #. `R`:math: is a partial function on `S`:math:. 

#. |soso| Write a Python function that, for any set of pairs `R`:math:,
   returns ``True`` if and only if `R`:math: is a function.




.. include:: footer.rst
