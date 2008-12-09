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

    >>> tokens = nltk.corpus.brown.words(categories='news')
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


naming variables

http://www.python.org/dev/peps/pep-0008/

Modules



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




----------
Miscellany
----------



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





.. include:: footer.rst
