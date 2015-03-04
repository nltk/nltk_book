.. -*- mode: rst -*-
.. include:: ../definitions.rst

.. TODO: update cspy reference to more recent book
.. TODO: add some literature references (esp to other intro linguistics textbooks)
.. TODO: adopt simpler hacker example with only single character transpositions;
   move hacker example to later section (later chapter?)
.. TODO: get URL hyperlinks to be fixed width
.. TODO: websites with automatically generated language -- lobner prize... 

.. _chap-introduction:

=========================================
A1. Appendix: Enough Python for this Book
=========================================

It is easy to get our hands on millions of words of text.
What can we do with it, assuming we can write some simple programs?
In this chapter we'll address the following questions:

#. What can we achieve by combining simple programming techniques with large quantities of text?
#. How can we automatically extract key words and phrases that sum up the style and content of a text?
#. What tools and techniques does the Python programming language provide for such work?

.. _sec-computing-with-language-texts-and-words:

----------------------------------------
Computing with Language: Texts and Words
----------------------------------------

We're all very familiar with text, since we read and write it every day.
Here we will treat text as `raw data`:em: for the programs we write,
programs that manipulate and analyze it in a variety of interesting ways.
But before we can do this, we have to get started with the Python interpreter.

Getting Started with Python
---------------------------

One of the friendly things about Python is that it allows you
to type directly into the interactive `interpreter`:dt: |mdash|
the program that will be running your Python programs.
You can access the Python interpreter using a simple graphical interface
called the Interactive DeveLopment Environment (|IDLE|).
On a Mac you can find this under *Applications*\ |rarr|\ *MacPython*,
and on Windows under *All Programs*\ |rarr|\ *Python*.
Under Unix you can run Python from the shell by typing ``idle``
(if this is not installed, try typing ``python``).
The interpreter will print a blurb about your Python version;
simply check that you are running Python 3.2 or later
(here it is for 3.4.2):

.. doctest-ignore::
    Python 3.4.2 (default, Oct 15 2014, 22:01:37) 
    [GCC 4.2.1 Compatible Apple LLVM 5.1 (clang-503.0.40)] on darwin
    Type "help", "copyright", "credits" or "license" for more information.
    >>>

.. note::
   If you are unable to run the Python interpreter, you probably don't
   have Python installed correctly.  Please visit |PYTHON-URL| for
   detailed instructions. NLTK 3.0 works for Python 2.6 and
   2.7. If you are using one of these older versions, note that
   the ``/`` operator rounds
   fractional results downwards (so ``1/3`` will give you ``0``).
   In order to get the expected behavior of division
   you need to type: ``from __future__ import division``

The ``>>>`` prompt indicates that the Python interpreter is now waiting
for input.  When copying examples from this book, don't type
the "``>>>``" yourself.  Now, let's begin by using Python as a calculator:

    >>> 1 + 5 * 2 - 3
    8
    >>>

Once the interpreter has finished calculating the answer and displaying it, the
prompt reappears. This means the Python interpreter is waiting for another instruction.

.. note:: |TRY|
   Enter a few more expressions of your own. You can use asterisk (``*``)
   for multiplication and slash (``/``) for division, and parentheses for
   bracketing expressions.

.. XXX The following example currently wraps over a page boundary, which
   makes it difficult to read, esp since you can't see where the "^" is
   pointing.

The preceding examples demonstrate how you can work interactively with the
Python interpreter, experimenting with various expressions in the language
to see what they do.
Now let's try a nonsensical expression to see how the interpreter handles it:

    >>> 1 +
      File "<stdin>", line 1 
        1 +
          ^
    SyntaxError: invalid syntax
    >>>

This produced a `syntax error`:dt:.  In Python, it doesn't make sense
to end an instruction with a plus sign. The Python interpreter
indicates the line where the problem occurred (line 1 of ``<stdin>``,
which stands for "standard input").

Now that we can use the Python interpreter, we're ready to start working
with language data.

Getting Started with NLTK
-------------------------

Before going further you should install |NLTK3|\ , downloadable for free from |NLTK-URL|.
Follow the instructions there to download the version required for your platform.

Once you've installed |NLTK|, start up the Python interpreter as
before, and install the data required for the book by
typing the following two commands at the Python prompt, then selecting
the ``book`` collection as shown in fig-nltk-downloader_.
   
.. doctest-ignore::
    >>> import nltk
    >>> nltk.download()
   
.. _fig-nltk-downloader:
.. figure:: ../images/nltk-downloader.png
   :scale: 100:100:100

   Downloading the NLTK Book Collection: browse the available packages
   using ``nltk.download()``.  The **Collections** tab on the downloader
   shows how the packages are grouped into sets, and you should select the line labeled
   **book** to obtain all
   data required for the examples and exercises in this book.  It consists
   of about 30 compressed files requiring about 100Mb disk space.
   The full collection of data (i.e., **all** in the downloader) is
   nearly ten times this size (at the time of writing) and continues to expand.

Once the data is downloaded to your machine, you can load some of it
using the Python interpreter.
The first step is to type a special command at the
Python prompt which tells the interpreter to load some texts for us to
explore: ``from nltk.book import *``.
This says "from NLTK's ``book`` module, load
all items."  The ``book`` module contains all the data you will need
as you read this chapter.  After printing a welcome message, it loads
the text of several books (this will take a few seconds).  Here's the
command again, together with the output that
you will see.  Take care to get spelling and punctuation right, and
remember that you don't type the ``>>>``.

    >>> from nltk.book import *
    *** Introductory Examples for the NLTK Book ***
    Loading text1, ..., text9 and sent1, ..., sent9
    Type the name of the text or sentence to view it.
    Type: 'texts()' or 'sents()' to list the materials.
    text1: Moby Dick by Herman Melville 1851
    text2: Sense and Sensibility by Jane Austen 1811
    text3: The Book of Genesis
    text4: Inaugural Address Corpus
    text5: Chat Corpus
    text6: Monty Python and the Holy Grail
    text7: Wall Street Journal
    text8: Personals Corpus
    text9: The Man Who Was Thursday by G . K . Chesterton 1908
    >>>

Any time we want to find out about these texts, we just have
to enter their names at the Python prompt:

    >>> text1
    <Text: Moby Dick by Herman Melville 1851>
    >>> text2
    <Text: Sense and Sensibility by Jane Austen 1811>
    >>>

Now that we can use the Python interpreter, and have some data to work with,
we're ready to get started.

Searching Text
--------------

There are many ways to examine the context of a text apart from
simply reading it.  A concordance view shows us every occurrence of a given word, together
with some context.  Here we look up the word `monstrous`:lx: in *Moby
Dick* by entering ``text1`` followed by a period, then the term
``concordance``, and then placing ``"monstrous"`` in parentheses:

    >>> text1.concordance("monstrous")
    Displaying 11 of 11 matches:
    ong the former , one was of a most monstrous size . ... This came towards us ,
    ON OF THE PSALMS . " Touching that monstrous bulk of the whale or ork we have r
    ll over with a heathenish array of monstrous clubs and spears . Some were thick
    d as you gazed , and wondered what monstrous cannibal and savage could ever hav
    that has survived the flood ; most monstrous and most mountainous ! That Himmal
    they might scout at Moby Dick as a monstrous fable , or still worse and more de
    th of Radney .'" CHAPTER 55 Of the monstrous Pictures of Whales . I shall ere l
    ing Scenes . In connexion with the monstrous pictures of whales , I am strongly
    ere to enter upon those still more monstrous stories of them which are to be fo
    ght have been rummaged out of this monstrous cabinet there is no telling . But
    of Whale - Bones ; for Whales of a monstrous size are oftentimes cast up dead u
    >>>

The first time you use a concordance on a particular text, it takes a
few extra seconds to build an index so that subsequent searches are fast.

.. note:: |TRY|
   Try searching for other words; to save re-typing, you might be able to
   use up-arrow, Ctrl-up-arrow or Alt-p to access the previous command and modify the word being searched.
   You can also try searches on some of the other texts we have included.
   For example, search *Sense and Sensibility* for the word
   `affection`:lx:, using ``text2.concordance("affection")``.  Search the book of Genesis
   to find out how long some people lived, using
   ``text3.concordance("lived")``.  You could look at ``text4``, the
   *Inaugural Address Corpus*, to see examples of English going
   back to 1789, and search for words like `nation`:lx:, `terror`:lx:, `god`:lx:
   to see how these words have been used differently over time.
   We've also included ``text5``, the *NPS Chat Corpus*: search this for
   unconventional words like `im`:lx:, `ur`:lx:, `lol`:lx:.
   (Note that this corpus is uncensored!)

Once you've spent a little while examining these texts, we hope you have a new
sense of the richness and diversity of language.  In the next chapter
you will learn how to access a broader range of text, including text in
languages other than English.

A concordance permits us to see words in context.  For example, we saw that
`monstrous`:lx: occurred in contexts such as `the ___ pictures`:lx:
and `a ___ size`:lx: .  What other words appear in a similar range
of contexts?  We can find out
by appending the term ``similar`` to the name of the text in
question, then inserting the relevant word in parentheses:

    >>> text1.similar("monstrous")
    mean part maddens doleful gamesome subtly uncommon careful untoward
    exasperate loving passing mouldy christian few true mystifying
    imperial modifies contemptible
    >>> text2.similar("monstrous")
    very heartily so exceedingly remarkably as vast a great amazingly
    extremely good sweet
    >>>

Observe that we get different results for different texts.  
Austen uses this word quite differently from Melville; for her, `monstrous`:lx: has
positive connotations, and sometimes functions as an intensifier like the word
`very`:lx:.  

The term ``common_contexts`` allows us to examine just the
contexts that are shared by two or more words, such as `monstrous`:lx:
and `very`:lx:. We have to enclose these words by square brackets as
well as parentheses, and separate them with a comma:

    >>> text2.common_contexts(["monstrous", "very"])
    a_pretty is_pretty am_glad be_glad a_lucky
    >>>

.. note:: |TRY|
   Pick another pair of words and compare their usage in two different texts, using
   the ``similar()`` and ``common_contexts()`` functions.

It is one thing to automatically detect that a particular word occurs in a text,
and to display some words that appear in the same context.  However, we can also determine
the *location* of a word in the text: how many words from the beginning it appears.
This positional information can be displayed using a `dispersion plot`:dt:.
Each stripe represents an instance
of a word, and each row represents the entire text.  In fig-inaugural_ we
see some striking patterns of word usage over the last 220 years
(in an artificial text constructed by joining
the texts of the Inaugural Address Corpus end-to-end). 
You can produce this plot as shown below.
You might like to try more words (e.g., `liberty`:lx:, `constitution`:lx:),
and different texts.  Can you predict the
dispersion of a word before you view it?  As before, take
care to get the quotes, commas, brackets and parentheses exactly right.

.. doctest-ignore::
    >>> text4.dispersion_plot(["citizens", "democracy", "freedom", "duties", "America"])
    >>>

.. _fig-inaugural:
.. figure:: ../images/inaugural.png
   :scale: 90:90:90

   Lexical Dispersion Plot for Words in U.S. Presidential Inaugural Addresses:
   This can be used to investigate changes in language use over time.

.. note:: |IMPORTANT|
   You need to have Python's NumPy and Matplotlib packages installed
   in order to produce the graphical plots used in this book.
   Please see |NLTK-URL| for installation instructions.

.. note::
   You can also plot the frequency of word usage through time using
   |GOOGLE-NGRAM|

Now, just for fun, let's try generating some random text in the various
styles we have just seen.  To do this, we type the name of the text
followed by the term ``generate``. (We need to include the
parentheses, but there's nothing that goes between them.)

    >>> text3.generate()
    In the beginning of his brother is a hairy man , whose top may reach
    unto heaven ; and ye shall sow the land of Egypt there was no bread in
    all that he was taken out of the month , upon the earth . So shall thy
    wages be ? And they made their father ; and Isaac was old , and kissed
    him : and Laban with his cattle in the midst of the hands of Esau thy
    first born , and Phichol the chief butler unto his son Isaac , she
    >>>

.. note::
   The ``generate()`` method is not available in NLTK 3.0 but will be
   reinstated in a subsequent version.

..
   Note that the first time you run this command, it is slow because it gathers statistics
   about word sequences.  Each time you run it, you will get different output text.
   Now try generating random text in the style of an inaugural address or an
   Internet chat room.  Although the text is random, it re-uses common words and
   phrases from the source text and gives us a sense of its style and content.
   (What is lacking in this randomly generated text?)

.. note
   When ``generate`` produces its output, punctuation is split off
   from the preceding word.  While this is not correct formatting
   for English text, we do it to make clear that words and
   punctuation are independent of one another. You will learn
   more about this in chap-words_.

Counting Vocabulary
-------------------

The most obvious fact about texts that emerges from the preceding examples is that
they differ in the vocabulary they use.  In this section we will see how to use the
computer to count the words in a text in a variety of useful ways.
As before, you will jump right in and experiment with
the Python interpreter, even though you may not have studied Python systematically
yet.  Test your understanding by modifying the examples, and trying the
exercises at the end of the chapter.

Let's begin by finding out the length of a text from start to finish,
in terms of the words and punctuation symbols that appear.  We use the
term ``len`` to get the length of something, which we'll apply here to the
book of Genesis:

    >>> len(text3)
    44764
    >>>

So Genesis has 44,764 words and punctuation symbols, or "tokens."
A `token`:dt: is the technical name for a sequence of characters
|mdash| such as ``hairy``, ``his``, or ``:)`` |mdash| that we want to treat as a
group. When we count the number of tokens in a text, say, the phrase
`to be or not to be`:lx:, we are counting occurrences of these
sequences. Thus, in our example phrase there are two occurrences of `to`:lx:,
two of `be`:lx:, and one each of `or`:lx: and `not`:lx:. But there are
only four distinct vocabulary items in this phrase.
How many distinct words does the book of Genesis contain?
To work this out in Python, we have to pose the question slightly
differently.  The vocabulary of a text is just the *set* of tokens
that it uses, since in a set, all duplicates are collapsed
together. In Python we can obtain the vocabulary items of ``text3`` with the
command: ``set(text3)``.  When you do this, many screens of words will
fly past.  Now try the following: 

    >>> sorted(set(text3)) # [_sorted-set]
    ['!', "'", '(', ')', ',', ',)', '.', '.)', ':', ';', ';)', '?', '?)',
    'A', 'Abel', 'Abelmizraim', 'Abidah', 'Abide', 'Abimael', 'Abimelech',
    'Abr', 'Abrah', 'Abraham', 'Abram', 'Accad', 'Achbor', 'Adah', ...]
    >>> len(set(text3)) # [_len-set]
    2789
    >>>

By wrapping ``sorted()`` around the Python expression ``set(text3)``
sorted-set_,  we obtain a sorted list of vocabulary items, beginning
with various punctuation symbols and continuing with words starting with `A`:lx:.  All
capitalized words precede lowercase words.
We discover the size of the vocabulary indirectly, by asking
for the number of items in the set, and again we can use ``len`` to
obtain this number len-set_.  Although it has 44,764 tokens, this book
has only 2,789 distinct words, or "word types."
A `word type`:dt: is the form or spelling of the word independently of its
specific occurrences in a text |mdash| that is, the
word considered as a unique item of vocabulary.  Our count of 2,789 items
will include punctuation symbols, so we will generally call these
unique items `types`:dt: instead of word types. 

Now, let's calculate a measure of the lexical
richness of the text.  The next example shows us that the number of
distinct words is just 6% of the total number of words, or equivalently
that each word is used 16 times on average
(remember if you're using Python 2, to start with ``from __future__ import division``).

    >>> len(set(text3)) / len(text3)
    0.06230453042623537
    >>>

Next, let's focus on particular words.  We can count how often a word occurs
in a text, and compute what percentage of the text is taken up by a specific word:

    >>> text3.count("smote")
    5
    >>> 100 * text4.count('a') / len(text4)
    1.4643016433938312
    >>>

.. note:: |TRY|
   How many times does the word `lol`:lx: appear in ``text5``?
   How much is this as a percentage of the total number of words
   in this text? 

You may want to repeat such calculations on several texts,
but it is tedious to keep retyping the formula.  Instead,
you can come up with your own name for a task, like
"lexical_diversity" or "percentage", and associate it with a block of code.
Now you only have to type a short
name instead of one or more complete lines of Python code, and
you can re-use it as often as you like. The block of code that does a
task for us is called a `function`:dt:, and 
we define a short name for our function with the keyword ``def``. The
next example shows how to define two new functions,
``lexical_diversity()`` and   ``percentage()``:

    >>> def lexical_diversity(text): # [_fun-parameter1]
    ...     return len(set(text)) / len(text) # [_locvar]
    ...
    >>> def percentage(count, total): # [_fun-parameter2]
    ...     return 100 * count / total
    ...

.. caution::
   The Python interpreter changes the prompt from
   ``>>>`` to ``...`` after encountering the colon at the
   end of the first line.  The ``...`` prompt indicates
   that Python expects an `indented code block`:dt: to appear next.
   It is up to you to do the indentation, by typing four
   spaces or hitting the tab key.  To finish the indented block just
   enter a blank line.

In the definition of ``lexical_diversity()`` fun-parameter1_, we
specify a `parameter`:dt: named ``text`` . This parameter is
a "placeholder" for the actual text whose lexical diversity we want to
compute, and reoccurs in the block of code that will run when the
function is used locvar_. Similarly, ``percentage()`` is defined to
take two parameters, named ``count`` and ``total`` fun-parameter2_.

Once Python knows that ``lexical_diversity()`` and ``percentage()``
are the names for specific blocks
of code, we can go ahead and use these functions:

    >>> lexical_diversity(text3)
    0.06230453042623537
    >>> lexical_diversity(text5)
    0.13477005109975562
    >>> percentage(4, 5)
    80.0
    >>> percentage(text4.count('a'), len(text4))
    1.4643016433938312
    >>> 

To recap, we use or `call`:dt: a function such as ``lexical_diversity()`` by typing its name, followed
by an open parenthesis, the name of the text, and then a close
parenthesis. These parentheses will show up often; their role is to separate
the name of a task |mdash| such as ``lexical_diversity()`` |mdash| from the data
that the task is to be performed on |mdash| such as ``text3``.
The data value that we place in the parentheses when we call a
function is an `argument`:dt: to the function.

You have already encountered several functions in this chapter, such
as ``len()``, ``set()``, and ``sorted()``. By convention, we will
always add an empty pair of parentheses after a function name, as in
``len()``, just to make clear that what we are talking about is a
function rather than some other kind of Python expression.
Functions are an important concept in programming, and we only
mention them at the outset to give newcomers a sense of the
power and creativity of programming.  Don't worry if you find it a bit
confusing right now. 

Later we'll see how to use functions when tabulating data, as in tab-brown-types_.
Each row of the table will involve the same computation but
with different data, and we'll do this repetitive work using a function.

.. table:: tab-brown-types

   ==================  ======  =====  =================
   Genre               Tokens  Types  Lexical diversity
   ==================  ======  =====  =================
   skill and hobbies   82345   11935  0.145
   humor               21695   5017   0.231
   fiction: science    14470   3233   0.223
   press: reportage    100554  14394  0.143
   fiction: romance    70022   8452   0.121
   religion            39399   6373   0.162
   ==================  ======  =====  =================

   Lexical Diversity of Various Genres in the *Brown Corpus*

.. _sec-a-closer-look-at-python-texts-as-lists-of-words:

-----------------------
Texts as Lists of Words
-----------------------

.. reimport

    >>> from nltk.book import *
    >>> def lexical_diversity(text):
    ...     return len(text) / len(set(text))

You've seen some important elements of the Python programming language.
Let's take a few moments to review them systematically.

Lists
-----

.. XXX it's a little confusing that we assign a value to sent1 here,
   when it's already received on from the "from nltk.book import *"
   statement.  Granted it's the same value, but still...

What is a text?  At one level, it is a sequence of symbols on a page such
as this one.  At another level, it is a sequence of chapters, made up
of a sequence of sections, where each section is a sequence of paragraphs,
and so on.  However, for our purposes, we will think of a text as nothing
more than a sequence of words and punctuation.  Here's how we represent
text in Python, in this case the opening sentence of *Moby Dick*:

    >>> sent1 = ['Call', 'me', 'Ishmael', '.']
    >>>

After the prompt we've given a name we made up, ``sent1``, followed
by the equals sign, and then some quoted words, separated with
commas, and surrounded with brackets.  This bracketed material
is known as a `list`:dt: in Python: it is how we store a text.
We can inspect it by typing the name inspect-var_. We can ask for its length len-sent_.
We can even apply our own ``lexical_diversity()`` function to it apply-function_.

    >>> sent1 # [_inspect-var]
    ['Call', 'me', 'Ishmael', '.']
    >>> len(sent1) # [_len-sent]
    4
    >>> lexical_diversity(sent1) # [_apply-function]
    1.0
    >>>

Some more lists have been defined for you,
one for the opening sentence of each of our texts,
``sent2`` |dots| ``sent9``.  We inspect two of them
here; you can see the rest for yourself using the Python interpreter
(if you get an error which says that ``sent2`` is not defined, you
need to first type ``from nltk.book import *``).

    >>> sent2
    ['The', 'family', 'of', 'Dashwood', 'had', 'long',
    'been', 'settled', 'in', 'Sussex', '.']
    >>> sent3
    ['In', 'the', 'beginning', 'God', 'created', 'the',
    'heaven', 'and', 'the', 'earth', '.']
    >>>

.. note:: |TRY|
   Make up a few sentences of your own, by typing a name, equals
   sign, and a list of words, like this:
   ``ex1 = ['Monty', 'Python', 'and', 'the', 'Holy', 'Grail']``.
   Repeat some of the other Python operations we saw earlier in
   sec-computing-with-language-texts-and-words_,
   e.g., ``sorted(ex1)``, ``len(set(ex1))``, ``ex1.count('the')``.

A pleasant surprise is that we can use Python's addition operator on lists.
Adding two lists list-plus-list_ creates a new list
with everything from the first list, followed
by everything from the second list:

    >>> ['Monty', 'Python'] + ['and', 'the', 'Holy', 'Grail'] # [_list-plus-list]
    ['Monty', 'Python', 'and', 'the', 'Holy', 'Grail']
    >>>

.. note::
   This special use of the addition operation is called `concatenation`:dt:;
   it combines the lists together into a single list.  We can concatenate
   sentences to build up a text.

We don't have to literally type the lists either; we can use short
names that refer to pre-defined lists.

    >>> sent4 + sent1 
    ['Fellow', '-', 'Citizens', 'of', 'the', 'Senate', 'and', 'of', 'the',
    'House', 'of', 'Representatives', ':', 'Call', 'me', 'Ishmael', '.']
    >>>

What if we want to add a single item to a list? This is known as `appending`:dt:.
When we ``append()`` to a list, the list itself is updated as a result
of the operation. 

    >>> sent1.append("Some")
    >>> sent1
    ['Call', 'me', 'Ishmael', '.', 'Some']
    >>> 

Indexing Lists
--------------

.. XXX I think a picture would be very helpful for this section, namely
   one showing something like:
       | Call   | me     | Ishmael | .     |
       0        1        2         3       4
   This might obviate the need to use a contrived sentence "word1 
   word2 etc".  I find this picture especially useful for understanding
   slicing, but it also gives a reasonable motivation for zero-indexing.

.. XXX If we end up doing this, can we offset the integers slightly so
   that they (just) fall inside the corresponding cell?

       +--------+--------+--------+--------+
       | Call   | me     | Ishmael| .      |
       |0       |1       |2       |3       |4
       +--------+--------+--------+--------+

As we have seen, a text in Python is a list of words, represented
using a combination of brackets and quotes.  Just as with an ordinary
page of text, we can count up the total number of words in ``text1``
with ``len(text1)``, and count the occurrences in a text of a
particular word |mdash| say, ``'heaven'`` |mdash| using ``text1.count('heaven')``.

With some patience, we can pick out the 1st, 173rd, or even 14,278th
word in a printed text. Analogously, we can identify the elements of a
Python list by their order of occurrence in the list. The number that
represents this position is the item's `index`:dt:.  We instruct Python
to show us the item that occurs at an index such as ``173`` in a text
by writing the name of the text followed by the index inside square brackets:

    >>> text4[173]
    'awaken'
    >>>

We can do the converse; given a word, find the index of when it first
occurs:

    >>> text4.index('awaken')
    173
    >>>

Indexes are a common way to access the words of a text,
or, more generally, the elements of any list.
Python permits us to access sublists as well, extracting
manageable pieces of language from large texts, a technique
known as `slicing`:dt:.

    >>> text5[16715:16735]
    ['U86', 'thats', 'why', 'something', 'like', 'gamefly', 'is', 'so', 'good',
    'because', 'you', 'can', 'actually', 'play', 'a', 'full', 'game', 'without',
    'buying', 'it']
    >>> text6[1600:1625]
    ['We', "'", 're', 'an', 'anarcho', '-', 'syndicalist', 'commune', '.', 'We',
    'take', 'it', 'in', 'turns', 'to', 'act', 'as', 'a', 'sort', 'of', 'executive',
    'officer', 'for', 'the', 'week']
    >>>

Indexes have some subtleties, and we'll explore these with
the help of an artificial sentence:

    >>> sent = ['word1', 'word2', 'word3', 'word4', 'word5',
    ...         'word6', 'word7', 'word8', 'word9', 'word10']
    >>> sent[0]
    'word1'
    >>> sent[9]
    'word10'
    >>>

Notice that our indexes start from zero: ``sent`` element zero, written ``sent[0]``,
is the first word, ``'word1'``, whereas ``sent`` element 9 is ``'word10'``. 
The reason is simple: the moment Python accesses the content of a list from
the computer's memory, it is already at the first element;
we have to tell it how many elements forward to go.
Thus, zero steps forward leaves it at the first element.

.. note::
   This practice of counting from zero is initially confusing,
   but typical of modern programming languages.
   You'll quickly get the hang of it if
   you've mastered the system of counting centuries where 19XY is a year
   in the 20th century, or if you live in a country where the floors of
   a building are numbered from 1, and so walking up `n-1`:math: flights of
   stairs takes you to level `n`:math:. 

Now, if we accidentally use an index that is too large, we get an error:

    >>> sent[10]
    Traceback (most recent call last):
      File "<stdin>", line 1, in ?
    IndexError: list index out of range
    >>>

This time it is not a syntax error, because the program fragment is syntactically correct.
Instead, it is a `runtime error`:dt:, and it produces a ``Traceback`` message that
shows the context of the error, followed by the name of the error,
``IndexError``, and a brief explanation.

Let's take a closer look at slicing, using our artificial sentence again.
Here we verify that the slice ``5:8`` includes ``sent`` elements at
indexes 5, 6, and 7:

    >>> sent[5:8]
    ['word6', 'word7', 'word8']
    >>> sent[5]
    'word6'
    >>> sent[6]
    'word7'
    >>> sent[7]
    'word8'
    >>>

By convention, ``m:n`` means elements `m`:mathit:\ |dots|\ `n-1`:mathit:.
As the next example shows,
we can omit the first number if the slice begins at the start of the
list slice2_, and we can omit the second number if the slice goes to the end slice3_:

    >>> sent[:3] # [_slice2]
    ['word1', 'word2', 'word3']
    >>> text2[141525:] # [_slice3]
    ['among', 'the', 'merits', 'and', 'the', 'happiness', 'of', 'Elinor', 'and', 'Marianne',
    ',', 'let', 'it', 'not', 'be', 'ranked', 'as', 'the', 'least', 'considerable', ',',
    'that', 'though', 'sisters', ',', 'and', 'living', 'almost', 'within', 'sight', 'of',
    'each', 'other', ',', 'they', 'could', 'live', 'without', 'disagreement', 'between',
    'themselves', ',', 'or', 'producing', 'coolness', 'between', 'their', 'husbands', '.',
    'THE', 'END']
    >>>

We can modify an element of a list by assigning to one of its index values.
In the next example, we put ``sent[0]`` on the left of the equals sign list-assignment_.  We can also
replace an entire slice with new material slice-assignment_.  A consequence of this
last change is that the list only has four elements, and accessing a later value
generates an error list-error_.

    >>> sent[0] = 'First' # [_list-assignment]
    >>> sent[9] = 'Last'
    >>> len(sent)
    10
    >>> sent[1:9] = ['Second', 'Third'] # [_slice-assignment]
    >>> sent
    ['First', 'Second', 'Third', 'Last']
    >>> sent[9] # [_list-error]
    Traceback (most recent call last):
      File "<stdin>", line 1, in ?
    IndexError: list index out of range
    >>>    

.. note:: |TRY|
   Take a few minutes to define a sentence of your own and modify individual words and
   groups of words (slices) using the same methods used earlier.  Check your understanding
   by trying the exercises on lists at the end of this chapter.

Variables
---------

From the start of sec-computing-with-language-texts-and-words_, you have had
access to texts called ``text1``, ``text2``, and so on.  It saved a lot
of typing to be able to refer to a 250,000-word book with a short name
like this!  In general, we can make up names for anything we care
to calculate.  We did this ourselves in the previous sections, e.g.,
defining a `variable`:dt: ``sent1``, as follows:

    >>> sent1 = ['Call', 'me', 'Ishmael', '.']
    >>>

Such lines have the form: *variable = expression*.  Python will evaluate
the expression, and save its result to the variable.  This process is
called `assignment`:dt:.  It does not generate any output;
you have to type the variable on a line of its
own to inspect its contents.  The equals sign is slightly misleading,
since information is moving from the right side to the left.
It might help to think of it as a left-arrow.
The name of the variable can be anything you like, e.g., ``my_sent``, ``sentence``, ``xyzzy``.
It must start with a letter, and can include numbers and underscores.
Here are some examples of variables and assignments:
  
    >>> my_sent = ['Bravely', 'bold', 'Sir', 'Robin', ',', 'rode',
    ... 'forth', 'from', 'Camelot', '.']
    >>> noun_phrase = my_sent[1:4]
    >>> noun_phrase
    ['bold', 'Sir', 'Robin']
    >>> wOrDs = sorted(noun_phrase)
    >>> wOrDs
    ['Robin', 'Sir', 'bold']
    >>>

Remember that capitalized words appear before lowercase words in sorted lists.

.. note::
   Notice in the previous example that we split the definition
   of ``my_sent`` over two lines.  Python expressions can be split across
   multiple lines, so long as this happens within any kind of brackets.
   Python uses the "``...``" prompt to indicate that more input is
   expected.  It doesn't matter how much indentation is used in these
   continuation lines, but some indentation usually makes them easier to read.

It is good to choose meaningful variable names to remind you |mdash| and to help anyone
else who reads your Python code |mdash| what your code is meant to do.
Python does not try to make sense of the names; it blindly follows your instructions,
and does not object if you do something confusing, such as ``one = 'two'`` or ``two = 3``.
The only restriction is that
a variable name cannot be any of Python's reserved words, such as
``def``, ``if``, ``not``,
and ``import``.  If you use a reserved word, Python will produce a syntax error:

    >>> not = 'Camelot'           # doctest: +SKIP
    File "<stdin>", line 1
        not = 'Camelot'
            ^
    SyntaxError: invalid syntax
    >>>

We will often use variables to hold intermediate steps of a computation, especially
when this makes the code easier to follow.  Thus ``len(set(text1))`` could also be written:

    >>> vocab = set(text1)
    >>> vocab_size = len(vocab)
    >>> vocab_size
    19317
    >>>

.. caution::
   Take care with your choice of names (or `identifiers`:dt:) for Python
   variables.  First, you should start the name with a letter, optionally
   followed by digits (``0`` to ``9``) or letters. Thus, ``abc23`` is fine, but
   ``23abc`` will cause a syntax error. 
   Names are case-sensitive, which means that ``myVar`` and ``myvar``
   are distinct variables.  Variable names cannot contain whitespace,
   but you can separate words using an underscore, e.g.,
   ``my_var``. Be careful not to insert a hyphen instead of an
   underscore: ``my-var`` is wrong, since Python interprets the
   "``-``" as a minus sign. 

Strings
-------

Some of the methods we used to access the elements of a list also work with individual words,
or `strings`:dt:.  For example, we can assign a string to a variable assign-string_,
index a string index-string_, and slice a string slice-string_:

    >>> name = 'Monty' # [_assign-string]
    >>> name[0] # [_index-string]
    'M'
    >>> name[:4] # [_slice-string]
    'Mont'
    >>>

We can also perform multiplication and addition with strings:

    >>> name * 2
    'MontyMonty'
    >>> name + '!'
    'Monty!'
    >>>

We can join the words of a list to make a single string, or split a string into a list, as follows:

    >>> ' '.join(['Monty', 'Python'])
    'Monty Python'
    >>> 'Monty Python'.split()
    ['Monty', 'Python']
    >>>

We will come back to the topic of strings in chap-words_.
For the time being, we have two important building blocks
|mdash| lists and strings |mdash|
and are ready to get back to some language analysis.

.. _sec-computing-with-language-simple-statistics:


------------------------------------------
Computing with Language: Simple Statistics
------------------------------------------

.. reimport

   >>> from nltk.book import *

Let's return to our exploration of the ways we can bring our computational
resources to bear on large quantities of text.  We began this discussion in
sec-computing-with-language-texts-and-words_, and saw how to search for words
in context, how to compile the vocabulary of a text, how to generate random
text in the same style, and so on.

In this section we pick up the question of what makes a text distinct,
and use automatic methods to find characteristic words and expressions
of a text.  As in sec-computing-with-language-texts-and-words_, you can try
new features of the Python language by copying them into the interpreter,
and you'll learn about these features systematically in the following section.

Before continuing further, you might like to check your understanding of the
last section by predicting the output of the following code.  You can use
the interpreter to check whether you got it right.  If you're not sure how
to do this task, it would be a good idea to review the previous section
before continuing further.

    >>> saying = ['After', 'all', 'is', 'said', 'and', 'done',
    ...           'more', 'is', 'said', 'than', 'done']
    >>> tokens = set(saying)
    >>> tokens = sorted(tokens)
    >>> tokens[-2:]
    what output do you expect here?
    >>>



Frequency Distributions
-----------------------

How can we automatically identify the words of a text that are most
informative about the topic and genre of the text?  Imagine how you might
go about finding the 50 most frequent words of a book.  One method
would be to keep a tally for each vocabulary item, like that shown in fig-tally_.
The tally would need thousands of rows, and it would be an exceedingly
laborious process |mdash| so laborious that we would rather assign the task to a machine.

.. _fig-tally:
.. figure:: ../images/tally.png
   :scale: 20:100:25

   Counting Words Appearing in a Text (a frequency distribution)

The table in fig-tally_ is known as a `frequency distribution`:dt:,
and it tells us the frequency of each vocabulary item in the text.
(In general, it could count any kind of observable event.)
It is a "distribution"
because it tells us how the total number of word tokens in the text
are distributed across the vocabulary items.
Since we often need frequency distributions in language processing, NLTK
provides built-in support for them.  Let's use a ``FreqDist`` to find the
50 most frequent words of *Moby Dick*:

    >>> fdist1 = FreqDist(text1) # [_freq-dist-call]
    >>> print(fdist1) # [_freq-dist-inspect]
    <FreqDist with 19317 samples and 260819 outcomes>
    >>> fdist1.most_common(50) # [_freq-dist-most-common]
    [(',', 18713), ('the', 13721), ('.', 6862), ('of', 6536), ('and', 6024),
    ('a', 4569), ('to', 4542), (';', 4072), ('in', 3916), ('that', 2982),
    ("'", 2684), ('-', 2552), ('his', 2459), ('it', 2209), ('I', 2124),
    ('s', 1739), ('is', 1695), ('he', 1661), ('with', 1659), ('was', 1632),
    ('as', 1620), ('"', 1478), ('all', 1462), ('for', 1414), ('this', 1280),
    ('!', 1269), ('at', 1231), ('by', 1137), ('but', 1113), ('not', 1103),
    ('--', 1070), ('him', 1058), ('from', 1052), ('be', 1030), ('on', 1005),
    ('so', 918), ('whale', 906), ('one', 889), ('you', 841), ('had', 767),
    ('have', 760), ('there', 715), ('But', 705), ('or', 697), ('were', 680),
    ('now', 646), ('which', 640), ('?', 637), ('me', 627), ('like', 624)]
    >>> fdist1['whale']
    906
    >>>

When we first invoke ``FreqDist``, we pass the name of the text as an
argument freq-dist-call_. We can inspect the total number of words ("outcomes")
that have been counted up freq-dist-inspect_ |mdash| 260,819 in the
case of *Moby Dick*. The expression ``most_common(50)`` gives us a list of
the 50 most frequently occurring types in the text freq-dist-most-common_.

.. note:: |TRY|
   Try the preceding frequency distribution example for yourself, for
   ``text2``.  Be careful to use the correct parentheses and uppercase letters.
   If you get an error message ``NameError: name 'FreqDist' is not defined``,
   you need to start your work with ``from nltk.book import *``

.. SB: no period after the above import statement

Do any words produced in the last example help us grasp the topic or genre of this text?
Only one word, `whale`:lx:, is slightly informative!  It occurs over 900 times.
The rest of the words tell us nothing about the text; they're just English "plumbing."
What proportion of the text is taken up with such words?
We can generate a cumulative frequency plot for these words,
using ``fdist1.plot(50, cumulative=True)``, to produce the graph in fig-fdist-moby_.
These 50 words account for nearly half the book!

.. _fig-fdist-moby:
.. figure:: ../images/fdist-moby.png
   :scale: 20:25:25

   Cumulative Frequency Plot for 50 Most Frequently Words in *Moby Dick*:
   these account for nearly half of the tokens.

If the frequent words don't help us, how about the words that occur once
only, the so-called `hapaxes`:dt:?  View them by typing ``fdist1.hapaxes()``.
This list contains `lexicographer`:lx:, `cetological`:lx:,
`contraband`:lx:, `expostulations`:lx:, and about 9,000 others.
It seems that there are too many rare words, and without seeing the
context we probably can't guess what half of the hapaxes mean in any case!
Since neither frequent nor infrequent words help, we need to try
something else.

Fine-grained Selection of Words
-------------------------------

Next, let's look at the *long* words of a text; perhaps these will be
more characteristic and informative.  For this we adapt some notation
from set theory.  We would like to find the words from the vocabulary
of the text that are more than 15 characters long.  Let's call
this property `P`:math:, so that `P(w)`:math: is true
if and only if `w`:math: is more than 15 characters long.
Now we can express the words of interest using mathematical 
set notation as shown in ex-set-comprehension-math_.
This means "the set of all `w`:math: such that `w`:math: is an
element of `V`:math: (the vocabulary) and `w`:math: has property `P`:math:".

.. _ex-set-comprehension:
.. ex::
   .. _ex-set-comprehension-math:
   .. ex:: {`w`:math: | `w`:math: |element| `V`:math: & `P(w)`:math:\ }
   .. _ex-set-comprehension-python:
   .. ex:: ``[w for w in V if p(w)]``

The corresponding Python expression is given in ex-set-comprehension-python_.
(Note that it produces a list, not a set, which means that duplicates are possible.)
Observe how similar the two notations are.  Let's go one more step and
write executable Python code:

    >>> V = set(text1)
    >>> long_words = [w for w in V if len(w) > 15]
    >>> sorted(long_words)
    ['CIRCUMNAVIGATION', 'Physiognomically', 'apprehensiveness', 'cannibalistically',
    'characteristically', 'circumnavigating', 'circumnavigation', 'circumnavigations',
    'comprehensiveness', 'hermaphroditical', 'indiscriminately', 'indispensableness',
    'irresistibleness', 'physiognomically', 'preternaturalness', 'responsibilities',
    'simultaneousness', 'subterraneousness', 'supernaturalness', 'superstitiousness',
    'uncomfortableness', 'uncompromisedness', 'undiscriminating', 'uninterpenetratingly']
    >>>

For each word ``w`` in the vocabulary ``V``, we check whether
``len(w)`` is greater than 15; all other words will
be ignored.  We will discuss this syntax more carefully later.

.. note:: |TRY|
   Try out the previous statements in the Python interpreter,
   and experiment with changing the text and changing the length condition.
   Does it make a difference to your results if you change the
   variable names, e.g., using ``[word for word in vocab if ...]``? 

Let's return to our task of finding words that characterize a text.
Notice that the long words in ``text4`` reflect its national focus
|mdash| `constitutionally`:lx:, `transcontinental`:lx: |mdash|
whereas those in ``text5`` reflect its informal content:
`boooooooooooglyyyyyy`:lx: and `yuuuuuuuuuuuummmmmmmmmmmm`:lx:.
Have we succeeded in automatically extracting words that typify
a text?  Well, these very long words are often hapaxes (i.e., unique)
and perhaps it would be better to find *frequently occurring*
long words.  This seems promising since it eliminates
frequent short words (e.g., `the`:lx:) and infrequent long words
(e.g. `antiphilosophists`:lx:).
Here are all words from the chat corpus
that are longer than seven characters, that occur more than seven times:

    >>> fdist5 = FreqDist(text5)
    >>> sorted(w for w in set(text5) if len(w) > 7 and fdist5[w] > 7)
    ['#14-19teens', '#talkcity_adults', '((((((((((', '........', 'Question',
    'actually', 'anything', 'computer', 'cute.-ass', 'everyone', 'football',
    'innocent', 'listening', 'remember', 'seriously', 'something', 'together',
    'tomorrow', 'watching']
    >>>

Notice how we have used two conditions: ``len(w) > 7`` ensures that the
words are longer than seven letters, and ``fdist5[w] > 7`` ensures that
these words occur more than seven times.  At last we have managed to
automatically identify the frequently-occurring content-bearing
words of the text.  It is a modest but important milestone: a tiny piece of code,
processing tens of thousands of words, produces some informative output.

Collocations and Bigrams
------------------------

A `collocation`:dt: is a sequence of words that occur together
unusually often. Thus `red wine`:lx: is a collocation, whereas `the
wine`:lx: is not. A characteristic of collocations is that they are
resistant to substitution with words that have similar senses;
for example, `maroon wine`:lx: sounds definitely odd.  

To get a handle on collocations, we start off by extracting from a text
a list of word pairs, also known as `bigrams`:dt:. This is easily
accomplished with the function ``bigrams()``:

    >>> list(bigrams(['more', 'is', 'said', 'than', 'done']))
    [('more', 'is'), ('is', 'said'), ('said', 'than'), ('than', 'done')]
    >>>

.. note::
   If you omitted ``list()`` above, and just typed ``bigrams(['more', ...])``,
   you would have seen output of the form ``<generator object bigrams at 0x10fb8b3a8>``.
   This is Python's way of saying that it is ready to compute
   a sequence of items, in this case, bigrams. For now, you just need
   to know to tell Python to convert it into a list, using ``list()``.

Here we see that the pair of words `than-done`:lx: is a bigram, and we write
it in Python as ``('than', 'done')``.  Now, collocations are essentially
just frequent bigrams, except that we want to pay more attention to the
cases that involve rare words.  In particular, we want to find
bigrams that occur more often than we would expect based on
the frequency of the individual words.  The ``collocations()`` function
does this for us. We will see how it works later.

    >>> text4.collocations()
    United States; fellow citizens; four years; years ago; Federal
    Government; General Government; American people; Vice President; Old
    World; Almighty God; Fellow citizens; Chief Magistrate; Chief Justice;
    God bless; every citizen; Indian tribes; public debt; one another;
    foreign nations; political parties
    >>> text8.collocations()
    would like; medium build; social drinker; quiet nights; non smoker;
    long term; age open; Would like; easy going; financially secure; fun
    times; similar interests; Age open; weekends away; poss rship; well
    presented; never married; single mum; permanent relationship; slim
    build
    >>>

The collocations that emerge are very specific to the genre of the
texts. In order to find  `red wine`:lx: as a collocation, we would
need to process a much larger body of text.

Counting Other Things
---------------------

Counting words is useful, but we can count other things too.  For example, we can
look at the distribution of word lengths in a text, by creating a ``FreqDist``
out of a long list of numbers, where each number is the length of the corresponding
word in the text: 

    >>> [len(w) for w in text1] # [_word-lengths]
    [1, 4, 4, 2, 6, 8, 4, 1, 9, 1, 1, 8, 2, 1, 4, 11, 5, 2, 1, 7, 6, 1, 3, 4, 5, 2, ...]
    >>> fdist = FreqDist(len(w) for w in text1)  # [_freq-word-lengths]
    >>> print(fdist)  # [_freq-word-lengths-size]
    <FreqDist with 19 samples and 260819 outcomes>
    >>> fdist
    FreqDist({3: 50223, 1: 47933, 4: 42345, 2: 38513, 5: 26597, 6: 17111, 7: 14399,
      8: 9966, 9: 6428, 10: 3528, ...})
    >>>

We start by deriving a list of the lengths of words in ``text1``
word-lengths_,
and the ``FreqDist`` then counts the number of times each of these
occurs freq-word-lengths_. The result freq-word-lengths-size_ is a distribution containing
a quarter of a million items, each of which is a number corresponding to a
word token in the text.  But there are at most only 20 distinct
items being counted, the numbers 1 through 20, because there are only 20
different word lengths.  I.e., there are words consisting of just one character,
two characters, ..., twenty characters, but none with twenty one or more
characters.  One might wonder how frequent the different lengths of word are
(e.g., how many words of length four appear in the text, are there more words of length five
than length four, etc). We can do this as follows:

    >>> fdist.most_common()
    [(3, 50223), (1, 47933), (4, 42345), (2, 38513), (5, 26597), (6, 17111), (7, 14399),
    (8, 9966), (9, 6428), (10, 3528), (11, 1873), (12, 1053), (13, 567), (14, 177),
    (15, 70), (16, 22), (17, 12), (18, 1), (20, 1)]
    >>> fdist.max()
    3
    >>> fdist[3]
    50223
    >>> fdist.freq(3)
    0.19255882431878046
    >>>

From this we see that the most frequent word length is 3, and that
words of length 3 account for roughly 50,000 (or 20%) of the words making up the
book.  Although we will not pursue it here, further analysis of word
length might help us understand differences between authors, genres, or
languages.

tab-freqdist_ summarizes the functions defined in frequency distributions.

.. table:: tab-freqdist

   ===============================  ======================================================================
   Example                          Description
   ===============================  ======================================================================
   ``fdist = FreqDist(samples)``    create a frequency distribution containing the given samples
   ``fdist[sample] += 1``           increment the count for this sample
   ``fdist['monstrous']``           count of the number of times a given sample occurred
   ``fdist.freq('monstrous')``      frequency of a given sample
   ``fdist.N()``                    total number of samples
   ``fdist.most_common(n)``         the ``n`` most common samples and their frequencies
   ``for sample in fdist:``         iterate over the samples
   ``fdist.max()``                  sample with the greatest count
   ``fdist.tabulate()``             tabulate the frequency distribution
   ``fdist.plot()``                 graphical plot of the frequency distribution
   ``fdist.plot(cumulative=True)``  cumulative plot of the frequency distribution
   ``fdist1 |= fdist2``             update ``fdist1`` with counts from ``fdist2``
   ``fdist1 < fdist2``              test if samples in ``fdist1`` occur less frequently than in ``fdist2``
   ===============================  ======================================================================

   Functions Defined for |NLTK|\ 's Frequency Distributions

Our discussion of frequency distributions has introduced some important Python concepts,
and we will look at them systematically in sec-making-decisions_.

.. 
   We've also touched on the topic of normalization, and we'll explore this in
   depth in chap-words_.   

.. _sec-making-decisions:

-----------------------------------
Making Decisions and Taking Control
-----------------------------------

.. reimport

   >>> from nltk.book import *

So far, our little programs have had some interesting qualities:
the ability to work with language, and
the potential to save human effort through automation.
A key feature of programming is the ability of machines to
make decisions on our behalf, executing instructions when
certain conditions are met, or repeatedly looping through
text data until some condition is satisfied.  This feature
is known as `control`:dt:, and is the focus of this section.

Conditionals
------------

Python supports a wide range of operators, such as ``<`` and ``>=``, for
testing the relationship between values. The full set of these `relational
operators`:dt: is shown in tab-inequalities_.

.. table:: tab-inequalities

   ======== ==================================================
   Operator Relationship
   ======== ==================================================
   ``<``    less than
   ``<=``   less than or equal to
   ``==``   equal to (note this is two "``=``" signs, not one)
   ``!=``   not equal to
   ``>``    greater than
   ``>=``   greater than or equal to
   ======== ==================================================

   Numerical Comparison Operators

We can use these to select different words from a sentence of news text.
Here are some examples |mdash| only the operator is changed from one
line to the next.  They all use ``sent7``, the first sentence from ``text7``
(*Wall Street Journal*).  As before, if you get an error saying that ``sent7``
is undefined, you need to first type: ``from nltk.book import *``

    >>> sent7
    ['Pierre', 'Vinken', ',', '61', 'years', 'old', ',', 'will', 'join', 'the',
    'board', 'as', 'a', 'nonexecutive', 'director', 'Nov.', '29', '.']
    >>> [w for w in sent7 if len(w) < 4]
    [',', '61', 'old', ',', 'the', 'as', 'a', '29', '.']
    >>> [w for w in sent7 if len(w) <= 4]
    [',', '61', 'old', ',', 'will', 'join', 'the', 'as', 'a', 'Nov.', '29', '.']
    >>> [w for w in sent7 if len(w) == 4]
    ['will', 'join', 'Nov.']
    >>> [w for w in sent7 if len(w) != 4]
    ['Pierre', 'Vinken', ',', '61', 'years', 'old', ',', 'the', 'board',
    'as', 'a', 'nonexecutive', 'director', '29', '.']
    >>> 

There is a common pattern to all of these examples:
``[w for w in text if`` *condition* ``]``, where *condition* is a
Python "test" that yields either true or false.
In the cases shown in the previous code example, the condition is always a numerical comparison.
However, we can also test various properties of words,
using the functions listed in tab-word-tests_.

.. table:: tab-word-tests

   ====================   ===========================================================================
   Function               Meaning
   ====================   ===========================================================================
   ``s.startswith(t)``    test if ``s`` starts with ``t``
   ``s.endswith(t)``      test if ``s`` ends with ``t``
   ``t in s``             test if ``t`` is a substring of ``s``
   ``s.islower()``        test if ``s`` contains cased characters and all are lowercase
   ``s.isupper()``        test if ``s`` contains cased characters and all are uppercase
   ``s.isalpha()``        test if ``s`` is non-empty and all characters in ``s`` are alphabetic
   ``s.isalnum()``        test if ``s`` is non-empty and all characters in ``s`` are alphanumeric
   ``s.isdigit()``        test if ``s`` is non-empty and all characters in ``s`` are digits
   ``s.istitle()``        test if ``s`` contains cased characters and is titlecased
                          (i.e. all words in ``s`` have initial capitals)
   ====================   ===========================================================================

   Some Word Comparison Operators

Here are some examples of these operators being used to
select words from our texts:
words ending with `-ableness`:lx:;
words containing `gnt`:lx:;
words having an initial capital;
and words consisting entirely of digits.

    >>> sorted(w for w in set(text1) if w.endswith('ableness'))
    ['comfortableness', 'honourableness', 'immutableness', 'indispensableness', ...]
    >>> sorted(term for term in set(text4) if 'gnt' in term)
    ['Sovereignty', 'sovereignties', 'sovereignty']
    >>> sorted(item for item in set(text6) if item.istitle())
    ['A', 'Aaaaaaaaah', 'Aaaaaaaah', 'Aaaaaah', 'Aaaah', 'Aaaaugh', 'Aaagh', ...] 
    >>> sorted(item for item in set(sent7) if item.isdigit())
    ['29', '61']
    >>>

We can also create more complex conditions.  If `c`:math: is a
condition, then ``not`` `c`:math: is also a condition.
If we have two conditions `c`:math:\ `1`:subscript: and `c`:math:\ `2`:subscript:,
then we can combine them to form a new condition using conjunction and disjunction:
`c`:math:\ `1`:subscript: ``and`` `c`:math:\ `2`:subscript:,
`c`:math:\ `1`:subscript: ``or`` `c`:math:\ `2`:subscript:.

.. note:: |TRY|
   Run the following examples and try to explain what is going on in each one.
   Next, try to make up some conditions of your own.

.. doctest-ignore::
      >>> sorted(w for w in set(text7) if '-' in w and 'index' in w)
      >>> sorted(wd for wd in set(text3) if wd.istitle() and len(wd) > 10)
      >>> sorted(w for w in set(sent7) if not w.islower())
      >>> sorted(t for t in set(text2) if 'cie' in t or 'cei' in t)

Operating on Every Element
--------------------------

In sec-computing-with-language-simple-statistics_, we saw some examples of
counting items other than words.  Let's take a closer look at the notation we used:

    >>> [len(w) for w in text1]
    [1, 4, 4, 2, 6, 8, 4, 1, 9, 1, 1, 8, 2, 1, 4, 11, 5, 2, 1, 7, 6, 1, 3, 4, 5, 2, ...]
    >>> [w.upper() for w in text1]
    ['[', 'MOBY', 'DICK', 'BY', 'HERMAN', 'MELVILLE', '1851', ']', 'ETYMOLOGY', '.', ...]
    >>>

These expressions have the form ``[f(w) for ...]`` or ``[w.f() for ...]``, where
``f`` is a function that operates on a word to compute its length, or to
convert it to uppercase.
For now, you don't need to understand the difference between the notations ``f(w)`` and
``w.f()``.  Instead, simply learn this Python idiom which performs the
same operation on every element of a list.  In the preceding examples, it goes through
each word in ``text1``, assigning each one in turn to the variable ``w`` and
performing the specified operation on the variable.

.. note::
   The notation just described is called a "list comprehension."  This is our first example
   of a Python idiom, a fixed notation that we use habitually without bothering to
   analyze each time.  Mastering such idioms is an important part of becoming a
   fluent Python programmer.

Let's return to the question of vocabulary size, and apply the same idiom here:

    >>> len(text1)
    260819
    >>> len(set(text1))
    19317
    >>> len(set(word.lower() for word in text1))
    17231
    >>>

Now that we are not double-counting words like `This`:lx: and `this`:lx:, which differ only
in capitalization, we've wiped 2,000 off the vocabulary count!  We can go a step further
and eliminate numbers and punctuation from the vocabulary count by filtering out any
non-alphabetic items:

    >>> len(set(word.lower() for word in text1 if word.isalpha()))
    16948
    >>> 

This example is slightly complicated: it lowercases all the purely alphabetic items.
Perhaps it would have been simpler just to count the lowercase-only items, but this
gives the wrong answer (why?).

Don't worry if you don't feel confident with list comprehensions yet,
since you'll see many more examples along with explanations in the following chapters.

Nested Code Blocks
------------------

Most programming languages permit us to execute a block of code when a
`conditional expression`:dt:, or ``if`` statement, is satisfied.  We
already saw examples of conditional tests in code like ``[w for w in
sent7 if len(w) < 4]``. In the following program, we have created a
variable called ``word`` containing the string value ``'cat'``. The
``if`` statement checks whether the test ``len(word) < 5`` is true.
It is, so the body of the ``if`` statement is invoked and the
``print`` statement is executed, displaying a message to the user.
Remember to indent the ``print`` statement by typing four spaces.

    >>> word = 'cat'
    >>> if len(word) < 5:
    ...     print('word length is less than 5')
    ...   # [_blank-line]
    word length is less than 5
    >>>

When we use the Python interpreter we have to add an extra blank line blank-line_
in order for it to detect that the nested block is complete.

.. note::
   If you are using Python 2.6 or 2.7, you need to include the following
   line in order for the above ``print`` function to be recognized:

       >>> from __future__ import print_function

If we change the conditional test to ``len(word) >= 5``,
to check that the length of ``word`` is greater than or equal to ``5``,
then the test will no longer be true.
This time, the body of the ``if`` statement will not be executed,
and no message is shown to the user:

    >>> if len(word) >= 5:
    ...   print('word length is greater than or equal to 5')
    ... 
    >>>

An ``if`` statement is known as a `control structure`:dt:
because it controls whether the code in the indented block will be run.
Another control structure is the ``for`` loop.
Try the following, and remember to include the colon and the four spaces:

    >>> for word in ['Call', 'me', 'Ishmael', '.']:
    ...     print(word)
    ...
    Call
    me
    Ishmael
    .
    >>>

This is called a loop because Python executes the code in
circular fashion.  It starts by performing the
assignment ``word = 'Call'``,
effectively using the ``word`` variable to name the first
item of the list.  Then, it displays the value of ``word``
to the user.  Next, it goes back to the ``for`` statement,
and performs the assignment ``word = 'me'``, before displaying this new value
to the user, and so on.  It continues in this fashion until
every item of the list has been processed.

Looping with Conditions
-----------------------

Now we can combine the ``if`` and ``for`` statements.
We will loop over every item of the list, and print
the item only if it ends with the letter *l*.  We'll pick another
name for the variable to demonstrate that Python doesn't
try to make sense of variable names.

    >>> sent1 = ['Call', 'me', 'Ishmael', '.']
    >>> for xyzzy in sent1:
    ...     if xyzzy.endswith('l'):
    ...         print(xyzzy)
    ...
    Call
    Ishmael
    >>>

You will notice that ``if`` and ``for`` statements
have a colon at the end of the line,
before the indentation begins. In fact, all Python
control structures end with a colon.  The colon
indicates that the current statement relates to the
indented block that follows.

We can also specify an action to be taken if
the condition of the ``if`` statement is not met.
Here we see the ``elif`` (else if) statement, and
the ``else`` statement.  Notice that these also have
colons before the indented code.

    >>> for token in sent1:
    ...     if token.islower():
    ...         print(token, 'is a lowercase word')
    ...     elif token.istitle():
    ...         print(token, 'is a titlecase word')
    ...     else:
    ...         print(token, 'is punctuation')
    ...
    Call is a titlecase word
    me is a lowercase word
    Ishmael is a titlecase word
    . is punctuation
    >>>

As you can see, even with this small amount of Python knowledge,
you can start to build multiline Python programs.
It's important to develop such programs in pieces,
testing that each piece does what you expect before
combining them into a program.  This is why the Python
interactive interpreter is so invaluable, and why you should get
comfortable using it.

Finally, let's combine the idioms we've been exploring.
First, we create a list of `cie`:lx: and `cei`:lx: words,
then we loop over each item and print it.  Notice the
extra information given in the print statement: `end=' '`.
This tells Python to print a space (not the default newline) after each word.

    >>> tricky = sorted(w for w in set(text2) if 'cie' in w or 'cei' in w)
    >>> for word in tricky:
    ...     print(word, end=' ')
    ancient ceiling conceit conceited conceive conscience
    conscientious conscientiously deceitful deceive ...
    >>>


---------
Sequences
---------

.. XXX next sentence is confusing, since you don't in fact use parentheses
.. Although the point about ("foo") not being a tuple is a good one, I would be
.. inclined to advise students to use parentheses as well as comma. Cf your
.. example of the precedence problem in the debugging section later on:

.. For example, ``"%s.%s.%02d" % "ph.d.", "n", 1`` produces a run-time error
.. ``TypeError: not enough arguments for format string``.  This is because the
.. percent operator has higher precedence than
.. the comma operator.  The fix is to add parentheses in order to
.. force the required scope.  

.. Just checked the Python Tutorial:
.. As you see, on output tuples are always enclosed in parentheses, so that nested
.. tuples are interpreted correctly; they may be input with or without surrounding
.. parentheses, although often parentheses are necessary anyway (if the tuple is part
.. of a larger expression).

So far, we have seen two kinds of sequence object: strings and lists.  Another
kind of sequence is called a `tuple`:dt:.
Tuples are formed with the comma operator create-tuple_, and typically enclosed
using parentheses.  We've actually seen them in the
previous chapters, and sometimes referred to them as "pairs", since
there were always two members.  However, tuples can have any number
of members.  Like lists and strings, tuples can be indexed index-tuple_
and sliced slice-tuple_, and have a length length-tuple_.

   >>> t = 'walk', 'fem', 3 # [_create-tuple]
   >>> t
   ('walk', 'fem', 3)
   >>> t[0] # [_index-tuple]
   'walk'
   >>> t[1:] # [_slice-tuple]
   ('fem', 3)
   >>> len(t) # [_length-tuple]
   3

.. caution::
   Tuples are constructed using the comma operator.  Parentheses are a more
   general feature of Python syntax, designed for grouping.
   A tuple containing the single element ``'snark'`` is defined by adding a
   trailing comma, like this: "``'snark',``".  The empty tuple is a special
   case, and is defined using empty parentheses ``()``. 

.. XXX how about making the following contrast:
.. >>> type(('snark'))
.. <type 'str'>
.. >>> type(('snark',))
.. <type 'tuple'>

.. XXX this would be a good place to explain tuple assignment / sequence unpacking
.. (unless you did in a revision of ch03 -- it is mentioned only in an exercise to
.. this chapter AF

Let's compare strings, lists and tuples directly, and do the indexing, slice, and length
operation on each type:

    >>> raw = 'I turned off the spectroroute'
    >>> text = ['I', 'turned', 'off', 'the', 'spectroroute']
    >>> pair = (6, 'turned')
    >>> raw[2], text[3], pair[1]
    ('t', 'the', 'turned')
    >>> raw[-3:], text[-3:], pair[-3:]
    ('ute', ['off', 'the', 'spectroroute'], (6, 'turned'))
    >>> len(raw), len(text), len(pair)
    (29, 5, 2)

Notice in this code sample that we computed multiple values on a
single line, separated by commas.  These comma-separated expressions
are actually just tuples |mdash| Python allows us to omit the
parentheses around tuples if there is no ambiguity. When we print a
tuple, the parentheses are always displayed. By using tuples in this
way, we are implicitly aggregating items together.


Operating on Sequence Types
---------------------------

We can iterate over the items in a sequence ``s`` in a variety of useful ways,
as shown in tab-python-sequence_.

.. table:: tab-python-sequence

   ======================================  ===============================================
   Python Expression                       Comment                                        
   ======================================  ===============================================
   ``for item in s``                       iterate over the items of ``s``
   ``for item in sorted(s)``               iterate over the items of ``s`` in order
   ``for item in set(s)``                  iterate over unique elements of ``s``
   ``for item in reversed(s)``             iterate over elements of ``s`` in reverse
   ``for item in set(s).difference(t)``    iterate over elements of ``s`` not in ``t``
   ======================================  ===============================================

   Various ways to iterate over sequences


The sequence functions illustrated in tab-python-sequence_ can be combined
in various ways; for example, to get unique elements of ``s`` sorted
in reverse, use ``reversed(sorted(set(s)))``.
We can randomize the contents of a list ``s`` before iterating over
them, using ``random.shuffle(s)``.

We can convert between these sequence types.  For example,
``tuple(s)`` converts any kind of sequence into a tuple, and
``list(s)`` converts any kind of sequence into a list.
We can convert a list of strings to a single string using the
``join()`` function, e.g. ``':'.join(words)``.

Some other objects, such as a ``FreqDist``, can be converted into a
sequence (using ``list()`` or ``sorted()``) and support iteration, e.g. 

    >>> raw = 'Red lorry, yellow lorry, red lorry, yellow lorry.'
    >>> text = word_tokenize(raw)
    >>> fdist = nltk.FreqDist(text) 
    >>> sorted(fdist)
    [',', '.', 'Red', 'lorry', 'red', 'yellow']
    >>> for key in fdist:
    ...     print(key + ':', fdist[key], end='; ')
    ...
    lorry: 4; red: 1; .: 1; ,: 3; Red: 1; yellow: 2

In the next example, we use tuples to re-arrange the
contents of our list.  (We can omit the parentheses
because the comma has higher precedence than assignment.)

    >>> words = ['I', 'turned', 'off', 'the', 'spectroroute']
    >>> words[2], words[3], words[4] = words[3], words[4], words[2]
    >>> words    
    ['I', 'turned', 'the', 'spectroroute', 'off']

This is an idiomatic and readable way to move items inside a list.
It is equivalent to the following traditional way of doing such
tasks that does not use tuples (notice that this method needs a
temporary variable ``tmp``).

    >>> tmp = words[2]
    >>> words[2] = words[3]
    >>> words[3] = words[4]
    >>> words[4] = tmp

As we have seen, Python has sequence functions such as ``sorted()`` and ``reversed()``
that rearrange the items of a sequence.  There are also functions that
modify the `structure`:em: of a sequence and which can be handy for
language processing.  Thus, ``zip()`` takes
the items of two or more sequences and "zips" them together into a single list of tuples.
Given a sequence ``s``, ``enumerate(s)`` returns pairs consisting of
an index and the item at that index.

    >>> words = ['I', 'turned', 'off', 'the', 'spectroroute']
    >>> tags = ['noun', 'verb', 'prep', 'det', 'noun']
    >>> zip(words, tags)
    <zip object at ...>
    >>> list(zip(words, tags))
    [('I', 'noun'), ('turned', 'verb'), ('off', 'prep'),
    ('the', 'det'), ('spectroroute', 'noun')]
    >>> list(enumerate(words))
    [(0, 'I'), (1, 'turned'), (2, 'off'), (3, 'the'), (4, 'spectroroute')]

.. note::
   It is a widespread feature of Python 3 and NLTK 3 to only perform
   computation when required (a feature known as "lazy evaluation").
   If you ever see a result like ``<zip object at 0x10d005448>`` when
   you expect to see a sequence, you can force the object to be
   evaluated just by putting it in a context that expects a sequence,
   like ``list(``\ `x`:mathit:\ ``)``, or ``for item in`` `x`:mathit:.

For some |NLP| tasks it is necessary to cut up a sequence into two or more parts.
For instance, we might want to "train" a system on 90% of the data and test it
on the remaining 10%.  To do this we decide the location where we want to
cut the data cut-location_, then cut the sequence at that location cut-sequence_.  

    >>> text = nltk.corpus.nps_chat.words()
    >>> cut = int(0.9 * len(text)) # [_cut-location]
    >>> training_data, test_data = text[:cut], text[cut:] # [_cut-sequence]
    >>> text == training_data + test_data # [_cut-preserve]
    True
    >>> len(training_data) / len(test_data) # [_cut-ratio]
    9.0

We can verify that none of the original data is lost during this process, nor is it duplicated
cut-preserve_.  We can also verify that the ratio of the sizes of the two pieces is what
we intended cut-ratio_.

Combining Different Sequence Types
----------------------------------

Let's combine our knowledge of these three sequence types, together with list
comprehensions, to perform the task of sorting the words in a string by
their length.

    >>> words = 'I turned off the spectroroute'.split() # [_string-object]
    >>> wordlens = [(len(word), word) for word in words] # [_tuple-comprehension]
    >>> wordlens.sort() # [_sort-method]
    >>> ' '.join(w for (_, w) in wordlens) # [_discard-length]
    'I off the turned spectroroute'


.. XXX cf earlier remark about explaining what "in-place" means

Each of the above lines of code contains a significant feature.
A simple string is actually an object with methods defined on it such as ``split()`` string-object_.
We use a list comprehension to build a list of tuples tuple-comprehension_,
where each tuple consists of a number (the word length) and the
word, e.g. ``(3, 'the')``.  We use the ``sort()`` method sort-method_ 
to sort the list in-place.  Finally, we discard the length
information and join the words back into a single string discard-length_.
(The underscore discard-length_ is just a regular Python variable,
but we can use underscore by convention to indicate that we will
not use its value.)

We began by talking about the commonalities in these sequence types,
but the above code illustrates important differences in their
roles.  First, strings appear at the beginning and the end: this is
typical in the context where our program is reading in some text and
producing output for us to read.  Lists and tuples are used in the
middle, but for different purposes.  A list is typically a sequence of
objects all having the `same type`:em:, of `arbitrary length`:em:.  We often
use lists to hold sequences of words.  In contrast,
a tuple is typically a collection of objects of `different types`:em:, of
`fixed length`:em:.  We often use a tuple to hold a `record`:dt:,
a collection of different `fields`:dt: relating to some entity.
This distinction between the use of lists and tuples takes some
getting used to,
so here is another example:

    >>> lexicon = [
    ...     ('the', 'det', ['Di:', 'D@']),
    ...     ('off', 'prep', ['Qf', 'O:f'])
    ... ]

Here, a lexicon is represented as a list because it is a
collection of objects of a single type |mdash| lexical entries |mdash|
of no predetermined length.  An individual entry is represented as a
tuple because it is a collection of objects with different
interpretations, such as the orthographic form, the part of speech,
and the pronunciations (represented in the SAMPA computer-readable
phonetic alphabet ``http://www.phon.ucl.ac.uk/home/sampa/``).
Note that these pronunciations are stored using a list. (Why?)

.. note::
   A good way to decide when to use tuples vs lists is to ask whether
   the interpretation of an item depends on its position.  For example,
   a tagged token combines two strings having different interpretation,
   and we choose to interpret the first item as the token and the
   second item as the tag.  Thus we use tuples like this: ``('grail', 'noun')``;
   a tuple of the form ``('noun', 'grail')`` would be nonsensical since
   it would be a word ``noun`` tagged ``grail``.
   In contrast, the elements of a text are all tokens, and position is
   not significant.  Thus we use lists like this: ``['venetian', 'blind']``;
   a list of the form ``['blind', 'venetian']`` would be equally valid.
   The linguistic meaning of the words might be different, but the
   interpretation of list items as tokens is unchanged. 

The distinction between lists and tuples has been described in terms of
usage.  However, there is a more fundamental difference: in Python,
lists are `mutable`:dt:, while tuples are `immutable`:dt:.  In other
words, lists can be modified, while tuples cannot.  Here are some of
the operations on lists that do in-place modification of the list.

    >>> lexicon.sort()
    >>> lexicon[1] = ('turned', 'VBD', ['t3:nd', 't3`nd'])
    >>> del lexicon[0]

.. note:: |TRY|
   Convert ``lexicon`` to a tuple, using ``lexicon = tuple(lexicon)``,
   then try each of the above operations, to confirm that none of
   them is permitted on tuples.

Generator Expressions
---------------------

We've been making heavy use of list comprehensions, for compact and readable
processing of texts.  Here's an example where we tokenize and normalize a text:

    >>> text = '''"When I use a word," Humpty Dumpty said in rather a scornful tone,
    ... "it means just what I choose it to mean - neither more nor less."'''
    >>> [w.lower() for w in word_tokenize(text)]
    ['``', 'when', 'i', 'use', 'a', 'word', ',', "''", 'humpty', 'dumpty', 'said', ...]

Suppose we now want to process these words further.  We can do this by inserting the above
expression inside a call to some other function max-comprehension_,
but Python allows us to omit the brackets max-generator_.

    >>> max([w.lower() for w in word_tokenize(text)]) # [_max-comprehension]
    'word'
    >>> max(w.lower() for w in word_tokenize(text)) # [_max-generator]
    'word'

The second line uses a `generator expression`:dt:.  This is more than a notational convenience:
in many language processing situations, generator expressions will be more efficient.
In max-comprehension_, storage for the list object must be allocated
before the value of max() is computed.  If the text is
very large, this could be slow.  In max-generator_, the data is streamed to the calling
function.  Since the calling function simply has to find the maximum value |mdash| the
word which comes latest in lexicographic sort order |mdash| it can process the stream
of data without having to store anything more than the maximum value seen so far. 

.. _sec-reusing-code:

-------------------------
More Python: Reusing Code
-------------------------

By this time you've probably typed and retyped a lot of code in the Python
interactive interpreter.  If you mess up when retyping a complex example you have
to enter it again.  Using the arrow keys to access and modify previous commands is helpful but only goes so
far.  In this section we see two important ways to reuse code: text editors and Python functions.

Creating Programs with a Text Editor
------------------------------------

The Python interactive interpreter performs your instructions as soon as you type
them.  Often, it is better to compose a multi-line program using a text editor,
then ask Python to run the whole program at once.  Using |IDLE|, you can do
this by going to the ``File`` menu and opening a new window.  Try this now, and
enter the following one-line program:

::

     print('Monty Python')

Save this program in a file called ``monty.py``, then
go to the ``Run`` menu, and select the command ``Run Module``.
(We'll learn what modules are shortly.)
The result in the main |IDLE| window should look like this:

.. doctest-ignore::
    >>> ================================ RESTART ================================
    >>>
    Monty Python
    >>>

You can also type ``from monty import *`` and it will do the same thing.

From now on, you have a choice of using the interactive interpreter or a
text editor to create your programs.  It is often convenient to test your ideas
using the interpreter, revising a line of code until it does what you expect.
Once you're ready, you can paste the code
(minus any ``>>>`` or ``...`` prompts) into the text editor,
continue to expand it, and finally save the program
in a file so that you don't have to type it in again later.
Give the file a short but descriptive name, using all lowercase letters and separating
words with underscore, and using the ``.py`` filename extension, e.g., ``monty_python.py``.

.. note:: |IMPORTANT|
   Our inline code examples include the ``>>>`` and ``...`` prompts
   as if we are interacting directly with the interpreter.  As they get more complicated,
   you should instead type them into the editor, without the prompts, and run them
   from the editor as shown above.  When we provide longer programs in this book,
   we will leave out the prompts to remind you to type them into a file rather
   than using the interpreter.  You can see this already in code-random-text_ above.
   Note that it still includes a couple of lines with the Python prompt;
   this is the interactive part of the task where you inspect some data and invoke a function.
   Remember that all code samples like code-random-text_ are downloadable
   from |NLTK-URL|.

Functions
---------

Suppose that you work on analyzing text that involves different forms
of the same word, and that part of your program needs to work out
the plural form of a given singular noun.  Suppose it needs to do this
work in two places, once when it is processing some texts, and again
when it is processing user input.

Rather than repeating the same code several times over, it is more
efficient and reliable to localize this work inside a `function`:dt:.
A function is just a named block of code that performs some well-defined
task, as we saw in sec-computing-with-language-texts-and-words_.
A function is usually defined to take some inputs, using special variables known as `parameters`:dt:,
and it may produce a result, also known as a `return value`:dt:.
We define a function using the keyword ``def`` followed by the
function name and any input parameters, followed by the body of the
function.  Here's the function we saw in sec-computing-with-language-texts-and-words_
(including the ``import`` statement that is needed for Python 2, in order to make division behave as expected):

    >>> from __future__ import division
    >>> def lexical_diversity(text):
    ...     return len(text) / len(set(text))

We use the keyword ``return`` to indicate the value that is
produced as output by the function.  In the above example,
all the work of the function is done in the ``return`` statement.
Here's an equivalent definition which does the same work
using multiple lines of code.  We'll change the parameter name
from ``text`` to ``my_text_data`` to remind you that this is an arbitrary choice:

    >>> def lexical_diversity(my_text_data):
    ...     word_count = len(my_text_data)
    ...     vocab_size = len(set(my_text_data))
    ...     diversity_score = vocab_size / word_count
    ...     return diversity_score

Notice that we've created some new variables inside the body of the function.
These are `local variables`:dt: and are not accessible outside the function.
So now we have defined a function with the name ``lexical_diversity``. But just
defining it won't produce any output!
Functions do nothing until they are "called" (or "invoked"):

    >>> from nltk.corpus import genesis
    >>> kjv = genesis.words('english-kjv.txt')
    >>> lexical_diversity(kjv)
    0.06230453042623537

Let's return to our earlier scenario, and actually define a simple
function to work out English plurals.  The function ``plural()`` in code-plural_
takes a singular noun and generates a plural form, though it is not always
correct.  (We'll discuss functions at greater length in sec-functions_.)

.. pylisting:: code-plural
   :caption: A Python Function: this function tries to work out the
             plural form of any English noun; the keyword ``def`` (define)
             is followed by the function name, then a parameter inside
             parentheses, and a colon; the body of the function is the
             indented block of code; it tries to recognize patterns
             within the word and process the word accordingly; e.g., if the
             word ends with `y`:lx:, delete the `y`:lx: and add `ies`:lx:.

   def plural(word):
       if word.endswith('y'):
           return word[:-1] + 'ies'
       elif word[-1] in 'sx' or word[-2:] in ['sh', 'ch']:
           return word + 'es'
       elif word.endswith('an'):
           return word[:-2] + 'en'
       else:
           return word + 's'

   >>> plural('fairy')
   'fairies'
   >>> plural('woman')
   'women'

The ``endswith()`` function is always associated with a string object
(e.g., ``word`` in code-plural_).  To call such functions, we give
the name of the object, a period, and then the name of the function.
These functions are usually known as `methods`:dt:.   

Modules
-------

Over time you will find that you create a variety of useful little text processing functions,
and you end up copying them from old programs to new ones.  Which file contains the
latest version of the function you want to use?
It makes life a lot easier if you can collect your work into a single place, and
access previously defined functions without making copies.

To do this, save your function(s) in a file called (say) ``text_proc.py``.
Now, you can access your work simply by importing it from the file:

.. doctest-ignore::
    >>> from text_proc import plural
    >>> plural('wish')
    wishes
    >>> plural('fan')
    fen

Our plural function obviously has an error, since the plural of
`fan`:lx: is `fans`:lx:.
Instead of typing in a new version of the function, we can
simply edit the existing one.  Thus, at every
stage, there is only one version of our plural function, and no confusion about
which one is being used.

A collection of variable and function definitions in a file is called a Python
`module`:dt:.  A collection of related modules is called a `package`:dt:.
|NLTK|\ 's code for processing the Brown Corpus is an example of a module,
and its collection of code for processing all the different corpora is
an example of a package.  |NLTK| itself is a set of packages, sometimes
called a `library`:dt:.

.. caution:: If you are creating a file to contain some of your Python
   code, do *not* name your file ``nltk.py``: it may get imported in
   place of the "real" NLTK package.  When it imports modules, Python
   first looks in the current directory (folder).

.. _sec-functions:

---------------------------------------------------
Functions: The Foundation of Structured Programming
---------------------------------------------------

.. XXX excessive duplication of information that was already presented in ch02;
.. e.g. motivation for functions, terminology of 'parameter' and 'body', return
.. statement etc.  (some collapsing)

Functions provide an effective way to package and re-use program code,
as already explained in sec-reusing-code_.
For example, suppose we find that we often want to read text from an HTML file.
This involves several steps: opening the file, reading it in, normalizing
whitespace, and stripping HTML markup.  We can collect these steps into a
function, and give it a name such as ``get_text()``, as shown in code-get-text_.

.. pylisting:: code-get-text
   :caption: Read text from a file

   import re
   def get_text(file):
       """Read text from a file, normalizing whitespace and stripping HTML markup."""
       text = open(file).read()
       text = re.sub(r'<.*?>', ' ', text)
       text = re.sub('\s+', ' ', text)
       return text

Now, any time we want to get cleaned-up text from an HTML file, we can just call
``get_text()`` with the name of the file as its only argument.  It will return
a string, and we can assign this to a variable, e.g.:
``contents = get_text("test.html")``.  Each time we want to use this series of
steps we only have to call the function.

Using functions has the benefit of saving space in our program.  More
importantly, our choice of name for the function helps make the program *readable*.
In the case of the above example, whenever our program needs to read cleaned-up
text from a file we don't have to clutter the program with four lines of code, we
simply need to call ``get_text()``.  This naming helps to provide some "semantic
interpretation" |mdash| it helps a reader of our program to see what the program "means".

Notice that the above function definition contains a string.  The first string inside
a function definition is called a `docstring`:dt:.  Not only does it document the
purpose of the function to someone reading the code, it is accessible to a programmer
who has loaded the code from a file::

|   >>> help(get_text)
|   Help on function get_text in module __main__:
|
|   get(text)
|       Read text from a file, normalizing whitespace and stripping HTML markup.

We have seen that functions help to make our work reusable and readable.  They
also help make it *reliable*.  When we re-use code that has already been developed
and tested, we can be more confident that it handles a variety of cases correctly.
We also remove the risk that we forget some important step, or introduce a bug.
The program that calls our function also has increased reliability.  The author
of that program is dealing with a shorter program, and its components behave
transparently.

To summarize, as its name suggests, a function captures functionality.
It is a segment of code that can be given a meaningful name and which performs
a well-defined task.  Functions allow us to abstract away from the details,
to see a bigger picture, and to program more effectively.

The rest of this section takes a closer look at functions, exploring the
mechanics and discussing ways to make your programs easier to read.

Function Inputs and Outputs
---------------------------

We pass information to functions using a function's parameters,
the parenthesized list of variables and constants following
the function's name in the function definition.  Here's a complete example:

    >>> def repeat(msg, num):  # [_fun-def]
    ...     return ' '.join([msg] * num)
    >>> monty = 'Monty Python'  
    >>> repeat(monty, 3) # [_fun-call]
    'Monty Python Monty Python Monty Python'

We first define the function to take two parameters, ``msg`` and ``num``
fun-def_. Then we call the function and pass it two arguments, ``monty`` and ``3``
fun-call_; these arguments fill the "placeholders" provided by the parameters and
provide values for the occurrences of ``msg`` and ``num`` in the function body.

It is not necessary to have any parameters, as we see in the following example:

    >>> def monty():
    ...     return "Monty Python"
    >>> monty()
    'Monty Python'

A function usually communicates its results back to the calling program via the ``return`` statement,
as we have just seen.  To the calling program, it looks as if the function call had been replaced
with the function's result, e.g.:

    >>> repeat(monty(), 3)
    'Monty Python Monty Python Monty Python'
    >>> repeat('Monty Python', 3)
    'Monty Python Monty Python Monty Python'

A Python function is not required to have a return statement.
Some functions do their work as a side effect, printing a result,
modifying a file, or updating the contents of a parameter to the function
(such functions are called "procedures" in some other programming languages).

.. XXX these examples would be easier for a novice to grasp if they knew more about
.. how functions are used in context. For example, they need to first know that you might
.. want to write ``foo = my_sort2(l)`` or have a function that only produces
.. side-effects before they see the significance of these.

Consider the following three sort functions.
The third one is dangerous because a programmer could
use it without realizing that it had modified its input.
In general, functions should modify the contents of a parameter
(``my_sort1()``), or return a value (``my_sort2()``),
not both (``my_sort3()``).

    >>> def my_sort1(mylist):      # good: modifies its argument, no return value
    ...     mylist.sort()
    >>> def my_sort2(mylist):      # good: doesn't touch its argument, returns value
    ...     return sorted(mylist)
    >>> def my_sort3(mylist):      # bad: modifies its argument and also returns it
    ...     mylist.sort()
    ...     return mylist

Parameter Passing
-----------------

Back in sec-back-to-the-basics_ you saw that assignment works on values,
but that the value of a structured object is a `reference`:em: to that object.  The same
is true for functions.  Python interprets function parameters as values (this is
known as `call-by-value`:dt:).  In the following code, ``set_up()`` has two parameters,
both of which are modified inside the function.  We begin by assigning an empty string
to ``w`` and an empty list to ``p``.  After calling the function, ``w`` is unchanged,
while ``p`` is changed:

    >>> def set_up(word, properties):
    ...     word = 'lolcat'
    ...     properties.append('noun')
    ...     properties = 5
    ...
    >>> w = ''
    >>> p = []
    >>> set_up(w, p)
    >>> w
    ''
    >>> p
    ['noun']

Notice that ``w`` was not changed by the function.
When we called ``set_up(w, p)``, the value of ``w`` (an empty string) was assigned to
a new variable ``word``.  Inside the function, the value of ``word`` was modified.
However, that change did not propagate to ``w``.  This parameter passing is
identical to the following sequence of assignments:

    >>> w = ''
    >>> word = w
    >>> word = 'lolcat'
    >>> w
    ''

Let's look at what happened with the list ``p``.
When we called ``set_up(w, p)``, the value of ``p`` (a reference to an empty
list) was assigned to a new local variable ``properties``,
so both variables now reference the same memory location.
The function modifies ``properties``, and this change is also
reflected in the value of ``p`` as we saw.  The function also
assigned a new value to properties (the number ``5``); this
did not modify the contents at that memory location, but
created a new local variable.
This behavior is just as if we had done the following sequence of assignments:

    >>> p = []
    >>> properties = p
    >>> properties.append('noun')
    >>> properties = 5
    >>> p
    ['noun']

Thus, to understand Python's call-by-value parameter passing,
it is enough to understand how assignment works.  Remember that you
can use the ``id()`` function and ``is`` operator to check your
understanding of object identity after each statement.  

Variable Scope
--------------

Function definitions create a new, local `scope`:dt: for variables.
When you assign to a new variable inside the body of a function,
the name is only defined within that function.  The name is not
visible outside the function, or in other functions.  This behavior
means you can choose variable names without being concerned about
collisions with names used in your other function definitions.
 
When you refer to an existing name from within the body
of a function, the Python interpreter first tries to resolve
the name with respect to the names that are local to the function.
If nothing is found, the interpreter checks if it is a global
name within the module.  Finally, if that does not succeed, the
interpreter checks if the name is a Python built-in.  This is
the so-called `LGB rule`:dt: of name resolution: local,
then global, then built-in.

.. caution::
   A function can enable access to a global variable using the
   ``global`` declaration.  However, this practice should be
   avoided as much as possible.  Defining global variables
   inside a function introduces dependencies on context
   and limits the portability (or reusability) of the function.
   In general you should use parameters for function inputs
   and return values for function outputs.

Checking Parameter Types
------------------------

Python does not allow us to declare the type of a variable when we write a program,
and this permits us to define functions that are flexible
about the type of their arguments.  For example, a tagger might expect
a sequence of words, but it wouldn't care whether this sequence is expressed
as a list or a tuple (or an iterator, another sequence type that is
outside the scope of the current discussion).

However, often we want to write programs for later use by others, and want
to program in a defensive style, providing useful warnings when functions
have not been invoked correctly.  The author of the following ``tag()``
function assumed that its argument would always be a string.

    >>> def tag(word):
    ...     if word in ['a', 'the', 'all']:
    ...         return 'det'
    ...     else:
    ...         return 'noun'
    ...
    >>> tag('the')
    'det'
    >>> tag('knight')
    'noun'
    >>> tag(["'Tis", 'but', 'a', 'scratch']) # [_list-arg]
    'noun'

The function returns sensible values for the arguments ``'the'`` and ``'knight'``,
but look what happens when it is passed a list list-arg_ |mdash| it fails to
complain, even though the result which it returns is clearly incorrect.
The author of this function could take some extra steps to
ensure that the ``word`` parameter of the ``tag()`` function is a string.
A naive approach would be to check the type of the argument using
``if not type(word) is str``, and if ``word`` is not a string, to simply
return Python's special empty value, ``None``. This is a slight improvement, because
the function is checking the type of the argument, and trying to return a "special", diagnostic
value for the wrong input.
However, it is also dangerous because the calling program
may not detect that ``None`` is intended as a "special" value, and this diagnostic
return value may then be
propagated to other parts of the program with unpredictable consequences.
This approach also fails if the word is a Unicode string, which has
type ``unicode``, not ``str``.
Here's a better solution, using an ``assert`` statement together with Python's ``basestring``
type that generalizes over both ``unicode`` and ``str``.

    >>> def tag(word):
    ...     assert isinstance(word, basestring), "argument to tag() must be a string"
    ...     if word in ['a', 'the', 'all']:
    ...         return 'det'
    ...     else:
    ...         return 'noun'

If the ``assert`` statement fails, it will produce an error that cannot be ignored,
since it halts program execution. 
Additionally, the error message is easy to interpret.  Adding assertions to
a program helps you find logical errors, and is a kind of `defensive programming`:dt:.
A more fundamental approach is to document the parameters to each function
using docstrings as described later in this section.

.. XXX should we mention try / except here?

Functional Decomposition
------------------------

Well-structured programs usually make extensive use of functions.
When a block of program code grows longer than 10-20 lines, it is a
great help to readability if the code is broken up into one or more
functions, each one having a clear purpose.  This is analogous to
the way a good essay is divided into paragraphs, each expressing one main idea.

.. XXX not clear here whether you are really talking about actions (in which case
.. :lx: role is maybe inappropriate / misleading) or about lexical semantics.

.. XXX the following code snippet could well occur earlier, e.g in section where you
.. talk about function inputs and outputs, so as to motivate different kinds of
.. return values, and then perhaps repeated here.

Functions provide an important kind of abstraction.
They allow us to group multiple actions into a single, complex action,
and associate a name with it.
(Compare this with the way we combine the actions of
`go`:lx: and `bring back`:lx: into a single more complex action `fetch`:lx:.)
When we use functions, the main program can be written at a higher level
of abstraction, making its structure transparent, e.g.

.. doctest-ignore::
    >>> data = load_corpus()
    >>> results = analyze(data)
    >>> present(results)

Appropriate use of functions makes programs more readable and maintainable.
Additionally, it becomes possible to reimplement a function
|mdash| replacing the function's body with more efficient code |mdash|
without having to be concerned with the rest of the program.

Consider the ``freq_words`` function in code-freq-words1_.
It updates the contents of a frequency distribution that is
passed in as a parameter, and it also prints a list of the
`n`:math: most frequent words.

.. pylisting:: code-freq-words1
   :caption: Poorly Designed Function to Compute Frequent Words

   from urllib import request
   from bs4 import BeautifulSoup

   def freq_words(url, freqdist, n):
       html = request.urlopen(url).read().decode('utf8')
       raw = BeautifulSoup(html).get_text()
       for word in word_tokenize(raw):
           freqdist[word.lower()] += 1
       result = []
       for word, count in freqdist.most_common(n):
           result = result + [word]
       print(result)

   >>> constitution = "http://www.archives.gov/exhibits/charters/constitution_transcript.html"
   >>> fd = nltk.FreqDist()
   >>> freq_words(constitution, fd, 30)
   ['the', ',', 'of', 'and', 'shall', '.', 'be', 'to', ';', 'in', 'states',
   'or', 'united', 'a', 'state', 'by', 'for', 'any', '=', 'which', 'president',
   'all', 'on', 'may', 'such', 'as', 'have', ')', '(', 'congress']

This function has a number of problems.
The function has two side-effects: it modifies the contents of its second
parameter, and it prints a selection of the results it has computed.
The function would be easier to understand and to reuse elsewhere if we
initialize the ``FreqDist()`` object inside the function (in the same place
it is populated), and if we moved the selection and display of results to the
calling program. Given that its task is to identify frequent words, it
should probably just return a list, not the whole frequency distribution.
In code-freq-words2_ we `refactor`:dt: this function,
and simplify its interface by dropping the ``freqdist`` parameter.

.. pylisting:: code-freq-words2
   :caption: Well-Designed Function to Compute Frequent Words

   from urllib import request
   from bs4 import BeautifulSoup

   def freq_words(url, n):
       html = request.urlopen(url).read().decode('utf8')
       text = BeautifulSoup(html).get_text()
       freqdist = nltk.FreqDist(word.lower() for word in word_tokenize(text))
       return [word for (word, _) in fd.most_common(n)]

   >>> freq_words(constitution, 30)
   ['the', ',', 'of', 'and', 'shall', '.', 'be', 'to', ';', 'in', 'states',
   'or', 'united', 'a', 'state', 'by', 'for', 'any', '=', 'which', 'president',
   'all', 'on', 'may', 'such', 'as', 'have', ')', '(', 'congress']

The readability and usability of the ``freq_words`` function is improved.

.. note::
   We have used ``_`` as a variable name. This is no different to any other
   variable except it signals to the reader that we don't have a use
   for the information it holds.

Documenting Functions
---------------------

If we have done a good job at decomposing our program into functions, then it should
be easy to describe the purpose of each function in plain language, and provide
this in the docstring at the top of the function definition.  This statement
should not explain how the functionality is implemented; in fact it should be possible
to re-implement the function using a different method without changing this
statement.

For the simplest functions, a one-line docstring is usually adequate (see code-get-text_).
You should provide a triple-quoted string containing a complete sentence on a single line.
For non-trivial functions, you should still provide a one sentence summary on the first line,
since many docstring processing tools index this string.  This should be followed by
a blank line, then a more detailed description of the functionality
(see ``http://www.python.org/dev/peps/pep-0257/`` for more information in docstring
conventions).

.. XXX it would be really nice to have a screen dump of the HTML output. 

Docstrings can include a `doctest block`:dt:, illustrating the use of
the function and the expected output.  These can be tested automatically
using Python's ``docutils`` module.
Docstrings should document the type of each parameter to the function, and the return
type.  At a minimum, that can be done in plain text.  However, note that |NLTK| uses
the Sphinx markup language to document parameters.  This format
can be automatically converted into richly structured
API documentation (see |NLTK-URL|), and includes special handling of certain
"fields" such as ``param`` which allow the inputs and outputs of functions to be
clearly documented.  code-sphinx_ illustrates
a complete docstring.

.. pylisting:: code-sphinx
   :caption: Illustration of a complete docstring, consisting of a one-line summary,
             a more detailed explanation, a doctest example, and Sphinx markup
             specifying the parameters, types, return type, and exceptions.

   def accuracy(reference, test):
       """
       Calculate the fraction of test items that equal the corresponding reference items.

       Given a list of reference values and a corresponding list of test values,
       return the fraction of corresponding values that are equal.
       In particular, return the fraction of indexes
       {0<i<=len(test)} such that C{test[i] == reference[i]}.

           >>> accuracy(['ADJ', 'N', 'V', 'N'], ['N', 'N', 'V', 'ADJ'])
           0.5

       :param reference: An ordered list of reference values
       :type reference: list
       :param test: A list of values to compare against the corresponding
           reference values
       :type test: list
       :return: the accuracy score
       :rtype: float
       :raises ValueError: If reference and length do not have the same length
       """

       if len(reference) != len(test):
           raise ValueError("Lists must have the same length.")
       num_correct = 0
       for x, y in zip(reference, test):
           if x == y:
               num_correct += 1
       return float(num_correct) / len(reference)


.. _sec-doing-more-with-functions:

-------------------------
Doing More with Functions
-------------------------

This section discusses more advanced features, which you may prefer to skip on the
first time through this chapter.

Functions as Arguments
----------------------

So far the arguments we have passed into functions have been simple objects like
strings, or structured objects like lists.  Python also lets us pass a function as
an argument to another function.  Now we can abstract out the operation, and apply
a `different operation`:em: on the `same data`:em:.  As the following examples show,
we can pass the built-in function ``len()`` or a user-defined function ``last_letter()``
as arguments to another function:

    >>> sent = ['Take', 'care', 'of', 'the', 'sense', ',', 'and', 'the',
    ...         'sounds', 'will', 'take', 'care', 'of', 'themselves', '.']
    >>> def extract_property(prop):
    ...     return [prop(word) for word in sent]
    ...
    >>> extract_property(len)
    [4, 4, 2, 3, 5, 1, 3, 3, 6, 4, 4, 4, 2, 10, 1]
    >>> def last_letter(word):
    ...     return word[-1]
    >>> extract_property(last_letter)
    ['e', 'e', 'f', 'e', 'e', ',', 'd', 'e', 's', 'l', 'e', 'e', 'f', 's', '.']    

The objects ``len`` and ``last_letter`` can be
passed around like lists and dictionaries.  Notice that parentheses
are only used after a function name if we are invoking the function;
when we are simply treating the function as an object these are omitted.

Python provides us with one more way to define functions as arguments
to other functions, so-called `lambda expressions`:dt:.  Supposing there
was no need to use the above ``last_letter()`` function in multiple places,
and thus no need to give it a name.  We can equivalently write the following:

    >>> extract_property(lambda w: w[-1])
    ['e', 'e', 'f', 'e', 'e', ',', 'd', 'e', 's', 'l', 'e', 'e', 'f', 's', '.']

Our next example illustrates passing a function to the ``sorted()`` function.
When we call the latter with a single argument (the list to be sorted),
it uses the built-in comparison function ``cmp()``.
However, we can supply our own sort function, e.g. to sort by decreasing
length.

    >>> sorted(sent)
    [',', '.', 'Take', 'and', 'care', 'care', 'of', 'of', 'sense', 'sounds',
    'take', 'the', 'the', 'themselves', 'will']
    >>> sorted(sent, cmp)
    [',', '.', 'Take', 'and', 'care', 'care', 'of', 'of', 'sense', 'sounds',
    'take', 'the', 'the', 'themselves', 'will']
    >>> sorted(sent, lambda x, y: cmp(len(y), len(x)))
    ['themselves', 'sounds', 'sense', 'Take', 'care', 'will', 'take', 'care',
    'the', 'and', 'the', 'of', 'of', ',', '.']

Accumulative Functions
----------------------

These functions start by initializing some storage, and iterate over
input to build it up, before returning some final object (a large structure
or aggregated result).  A standard way to do this is to initialize an
empty list, accumulate the material, then return the list, as shown
in function ``search1()`` in code-search-examples_.

.. pylisting:: code-search-examples
   :caption: Accumulating Output into a List
   
   def search1(substring, words):
       result = []
       for word in words:
           if substring in word:
               result.append(word)
       return result

   def search2(substring, words):
       for word in words:
           if substring in word:
               yield word

   >>> for item in search1('zz', nltk.corpus.brown.words()):
   ...     print(item, end=" ")
   Grizzlies' fizzled Rizzuto huzzahs dazzler jazz Pezza ...
   >>> for item in search2('zz', nltk.corpus.brown.words()):
   ...     print(item, end=" ")
   Grizzlies' fizzled Rizzuto huzzahs dazzler jazz Pezza ...
   
The function ``search2()`` is a generator.
The first time this function is called, it gets as far as the ``yield``
statement and pauses.  The calling program gets the first word and does
any necessary processing.  Once the calling program is ready for another
word, execution of the function is continued from where it stopped, until
the next time it encounters a ``yield`` statement.  This approach is
typically more efficient, as the function only generates the data as it is
required by the calling program, and does not need to allocate additional
memory to store the output (cf. our discussion of generator expressions above).

Here's a more sophisticated example of a generator which produces
all permutations of a list of words.  In order to force the ``permutations()``
function to generate all its output, we wrap it with a call to ``list()`` listperm_.

    >>> def permutations(seq):
    ...     if len(seq) <= 1:
    ...         yield seq
    ...     else:
    ...         for perm in permutations(seq[1:]):
    ...             for i in range(len(perm)+1):
    ...                 yield perm[:i] + seq[0:1] + perm[i:]
    ...
    >>> list(permutations(['police', 'fish', 'buffalo'])) # [_listperm]
    [['police', 'fish', 'buffalo'], ['fish', 'police', 'buffalo'],
     ['fish', 'buffalo', 'police'], ['police', 'buffalo', 'fish'],
     ['buffalo', 'police', 'fish'], ['buffalo', 'fish', 'police']]

.. note::
   The ``permutations`` function uses a technique called recursion,
   discussed below in sec-algorithm-design_.
   The ability to generate permutations of a set of words is
   useful for creating data to test a grammar (chap-parse_).

Higher-Order Functions
----------------------

Python provides some higher-order functions that are standard
features of functional programming languages such as Haskell.
We illustrate them here, alongside the equivalent expression
using list comprehensions.

Let's start by defining a function ``is_content_word()``
which checks whether a word is from the open class of content words.
We use this function as the first parameter of ``filter()``,
which applies the function to each item in the sequence contained
in its second parameter, and only retains the items for which
the function returns ``True``.

    >>> def is_content_word(word):
    ...     return word.lower() not in ['a', 'of', 'the', 'and', 'will', ',', '.']
    >>> sent = ['Take', 'care', 'of', 'the', 'sense', ',', 'and', 'the', 
    ...         'sounds', 'will', 'take', 'care', 'of', 'themselves', '.'] 
    >>> list(filter(is_content_word, sent))
    ['Take', 'care', 'sense', 'sounds', 'take', 'care', 'themselves']
    >>> [w for w in sent if is_content_word(w)]
    ['Take', 'care', 'sense', 'sounds', 'take', 'care', 'themselves']
    
Another higher-order function is ``map()``, which applies a function
to every item in a sequence.  It is a general version of the
``extract_property()`` function we saw in sec-doing-more-with-functions_.  
Here is a simple way to find the average length of a sentence in the news
section of the Brown Corpus, followed by an equivalent version with list comprehension
calculation:

    >>> lengths = map(len, nltk.corpus.brown.sents(categories='news'))
    >>> sum(lengths) / len(lengths)
    21.75081116158339
    >>> lengths = [len(sent) for sent in nltk.corpus.brown.sents(categories='news')]
    >>> sum(lengths) / len(lengths)
    21.75081116158339

In the above examples we specified a user-defined function ``is_content_word()``
and a built-in function ``len()``.  We can also provide a lambda expression.
Here's a pair of equivalent examples which count the number of vowels in each word.

    >>> list(map(lambda w: len(filter(lambda c: c.lower() in "aeiou", w)), sent))
    [2, 2, 1, 1, 2, 0, 1, 1, 2, 1, 2, 2, 1, 3, 0]
    >>> [len(c for c in w if c.lower() in "aeiou") for w in sent]
    [2, 2, 1, 1, 2, 0, 1, 1, 2, 1, 2, 2, 1, 3, 0]
    
The solutions based on list comprehensions are usually more readable than the
solutions based on higher-order functions, and we have favored the former
approach throughout this book.

Named Arguments
---------------

When there are a lot of parameters it is easy to get confused about the
correct order.  Instead we can refer to parameters by name, and even assign
them a default value just in case one was not provided by the calling
program.  Now the parameters can be specified in any order, and can be omitted.

    >>> def repeat(msg='<empty>', num=1):
    ...     return msg * num
    >>> repeat(num=3)
    '<empty><empty><empty>'
    >>> repeat(msg='Alice')
    'Alice'
    >>> repeat(num=5, msg='Alice')
    'AliceAliceAliceAliceAlice'

.. XXX this is going to be confusing for the novice. I suggest omitting the kwargs**
.. parameter for simplicity, and referring the reader to the Python Tutorial.

These are called `keyword arguments`:dt:.
If we mix these two kinds of parameters, then we must ensure that the unnamed parameters precede the named ones.
It has to be this way, since unnamed parameters are defined by position.  We can define a function that takes
an arbitrary number of unnamed and named parameters, and access them via an in-place list of arguments ``*args`` and
an "in-place dictionary" of keyword arguments ``**kwargs``.
(Dictionaries will be presented in sec-dictionaries_.)

    >>> def generic(*args, **kwargs):
    ...     print(args)
    ...     print(kwargs)
    ...
    >>> generic(1, "African swallow", monty="python")
    (1, 'African swallow')
    {'monty': 'python'}

When ``*args`` appears as a function parameter, it actually corresponds to all the unnamed parameters of
the function.  Here's another illustration of this aspect of Python syntax, for the ``zip()`` function which
operates on a variable number of arguments.  We'll use the variable name ``*song`` to demonstrate that
there's nothing special about the name ``*args``.

    >>> song = [['four', 'calling', 'birds'],
    ...         ['three', 'French', 'hens'],
    ...         ['two', 'turtle', 'doves']]
    >>> list(zip(song[0], song[1], song[2]))
    [('four', 'three', 'two'), ('calling', 'French', 'turtle'), ('birds', 'hens', 'doves')]
    >>> list(zip(*song))
    [('four', 'three', 'two'), ('calling', 'French', 'turtle'), ('birds', 'hens', 'doves')]

It should be clear from the above example that typing ``*song`` is just a convenient
shorthand, and equivalent to typing out ``song[0], song[1], song[2]``.

Here's another example of the use of keyword arguments in a function
definition, along with three equivalent ways to call the function:

    >>> def freq_words(file, min=1, num=10):
    ...     text = open(file).read()
    ...     tokens = word_tokenize(text)
    ...     freqdist = nltk.FreqDist(t for t in tokens if len(t) >= min)
    ...     return freqdist.most_common(num)
    >>> fw = freq_words('ch01.rst', 4, 10)
    >>> fw = freq_words('ch01.rst', min=4, num=10)
    >>> fw = freq_words('ch01.rst', num=10, min=4)

A side-effect of having named arguments is that they permit optionality.  Thus we
can leave out any arguments where we are happy with the default value:
``freq_words('ch01.rst', min=4)``, ``freq_words('ch01.rst', 4)``.
Another common use of optional arguments is to permit a flag.
Here's a revised version of the same function that reports its
progress if a ``verbose`` flag is set:

    >>> def freq_words(file, min=1, num=10, verbose=False):
    ...     freqdist = FreqDist()
    ...     if verbose: print("Opening", file)
    ...     text = open(file).read()
    ...     if verbose: print("Read in %d characters" % len(file))
    ...     for word in word_tokenize(text):
    ...         if len(word) >= min:
    ...             freqdist[word] += 1
    ...             if verbose and freqdist.N() % 100 == 0: print(".", sep="")
    ...     if verbose: print
    ...     return freqdist.most_common(num)

.. caution::
   Take care not to use a mutable object as the default value of
   a parameter.  A series of calls to the function will use the
   same object, sometimes with bizarre results as we will see in
   the discussion of debugging below.

.. caution::
   If your program will work with a lot of files, it is a good idea to
   close any open files once they are no longer required. Python will
   close open files automatically if you use the ``with`` statement:

   >>> with open("lexicon.txt") as f:
   ...     data = f.read()
   ...     # process the data


-------
Summary
-------

* Texts are represented in Python using lists:
  ``['Monty', 'Python']``.  We can use indexing, slicing,
  and the ``len()`` function on lists.
* A word "token" is a particular appearance of a given word in a text;
  a word "type" is the unique form of the word as a particular sequence
  of letters.  We count word tokens using ``len(text)`` and word types using
  ``len(set(text))``. 
* We obtain the vocabulary of a text ``t`` using ``sorted(set(t))``.
* We operate on each item of a text using ``[f(x) for x in text]``. 
* To derive the vocabulary, collapsing case distinctions and ignoring punctuation,
  we can write ``set(w.lower() for w in text if w.isalpha())``.
* We process each word in a text using a ``for`` statement, such
  as ``for w in t:`` or ``for word in text:``.  This must be followed by the colon character
  and an indented block of code, to be executed each time through the loop.
* We test a condition using an ``if`` statement: ``if len(word) < 5:``.
  This must be followed by the colon character and an indented block of
  code, to be executed only if the condition is true.
* A frequency distribution is a collection of items along with their frequency counts
  (e.g., the words of a text and their frequency of appearance).
* A function is a block of code that has been assigned a name and can
  be reused. Functions are defined using the ``def`` keyword, as in
  ``def mult(x, y)``; ``x`` and ``y`` are parameters of the function,
  and act as placeholders for actual data values.
* A function is called by specifying its name followed by zero or more
  arguments inside parentheses, like this: ``texts()``, ``mult(3, 4)``, ``len(text1)``.

* Strings, lists and tuples are different kinds of sequence object, supporting
  common operations such as indexing, slicing, ``len()``, ``sorted()``, and
  membership testing using ``in``.


* Functions are an essential programming abstraction: key concepts
  to understand are parameter passing, variable scope, and docstrings.

* A function serves as a namespace: names defined inside a function are not visible
  outside that function, unless those names are declared to be global.

* Modules permit logically-related material to be localized in a file.
  A module serves as a namespace: names defined in a module |mdash| such as variables
  and functions |mdash| are not visible to other modules, unless those names are imported.

* Python programs more than a few lines long should be entered using a text editor,
  saved to a file with a ``.py`` extension, and accessed using an ``import`` statement.
* Python functions permit you to associate a name with a particular block of code,
  and re-use that code as often as necessary.
* Some functions, known as "methods", are associated with an object and we give the object
  name followed by a period followed by the function, like this: ``x.funct(y)``,
  e.g., ``word.isalpha()``.
* To find out about some variable ``v``,
  type ``help(v)`` in the Python interactive interpreter to read the help entry for this kind of object.

---------------
Further Reading
---------------

This chapter has introduced new concepts in programming, natural language processing,
and linguistics, all mixed in together.
Many of them are consolidated in the following chapters.  However, you may also want to
consult the online materials provided with this chapter (at |NLTK-URL|), including links
to additional background materials, and links to online |NLP| systems.
You may also like to read up on
some linguistics and |NLP|\ -related concepts in Wikipedia (e.g., collocations,
the Turing Test, the type-token distinction).

You should acquaint yourself with the Python documentation available at |PYTHON-DOCS|,
including the many tutorials and comprehensive reference materials linked there.
A `Beginner's Guide to Python`:em: is available at ``http://wiki.python.org/moin/BeginnersGuide``.
Miscellaneous questions about Python might be answered in the FAQ at
``http://python.org/doc/faq/general/``.

As you delve into |NLTK|, you might want to subscribe to the mailing list where new
releases of the toolkit are announced.  There is also an NLTK-Users mailing list,
where users help each other as they learn how to use Python and |NLTK| for
language analysis work.  Details of these lists are available at |NLTK-URL|.

For more information on the topics covered in sec-automatic-natural-language-understanding_,
and on |NLP| more generally, you might like to consult one of the following excellent
books:

* Indurkhya, Nitin and Fred Damerau (eds, 2010) *Handbook of Natural Language Processing*
  (Second Edition) Chapman & Hall/CRC. 2010.  [IndurkhyaDamerau2010]_ [Dale00handbook]_

* Jurafsky, Daniel and James Martin (2008) *Speech and Language Processing* (Second Edition).  Prentice Hall.
  [JurafskyMartin2008]_

* Mitkov, Ruslan (ed, 2003) *The Oxford Handbook of Computational Linguistics*.  Oxford University Press.
  (second edition expected in 2010).  [Mitkov02handbook]_

The Association for Computational Linguistics is the international organization that
represents the field of |NLP|.  The ACL website (``http://www.aclweb.org/``) hosts many useful resources, including:
information about international and regional conferences and workshops;
the `ACL Wiki`:em: with links to hundreds of useful resources;
and the `ACL Anthology`:em:, which contains most of the |NLP| research literature
from the past 50+ years, fully indexed and freely downloadable.

Some excellent introductory Linguistics textbooks are:
[Finegan2007]_, [OGrady2004]_, [OSU2007]_.  You might like to consult
`LanguageLog`:em:, a popular linguistics blog with occasional posts that
use the techniques described in this book.

---------
Exercises
---------

.. TODO: add lots more exercises on lists!

#. |easy| Try using the Python interpreter as a calculator, and
   typing expressions like ``12 / (4 + 1)``.
   
#. |easy| Given an alphabet of 26 letters, there are 26 to the power
   10, or ``26 ** 10``, ten-letter strings we can form.  That works out
   to ``141167095653376L`` (the ``L`` at the end just indicates that
   this is Python's long-number format).  How many hundred-letter
   strings are possible?

#. |easy| The Python multiplication operation can be applied to lists.
   What happens when you type ``['Monty', 'Python'] * 20``,
   or ``3 * sent1``?

#. |easy| Review sec-computing-with-language-texts-and-words_ on
   computing with language.  How many words are there in ``text2``?
   How many distinct words are there?

#. |easy| Compare the lexical diversity scores for humor
   and romance fiction in tab-brown-types_.  Which genre is
   more lexically diverse?

#. |easy| Produce a dispersion plot of the four main protagonists in
   *Sense and Sensibility*: Elinor, Marianne, Edward, and Willoughby.
   What can you observe about the different roles played by the males
   and females in this novel?  Can you identify the couples?

#. |easy| Find the collocations in ``text5``.

#. |easy| Consider the following Python expression: ``len(set(text4))``.
   State the purpose of this expression.  Describe the two steps
   involved in performing this computation.

#. |easy| Review sec-a-closer-look-at-python-texts-as-lists-of-words_
   on lists and strings.
   
   a) Define a string and assign it to a variable, e.g.,
      ``my_string = 'My String'`` (but put something more interesting in the string).
      Print the contents of this variable in two ways, first
      by simply typing the variable name and pressing enter, then
      by using the ``print`` statement.
   
   b) Try adding the string to itself using ``my_string + my_string``, or multiplying
      it by a number, e.g., ``my_string * 3``.  Notice that the strings
      are joined together without any spaces.  How could you fix this?

#. |easy| Define a variable ``my_sent`` to be a list of words, using
   the syntax ``my_sent = ["My", "sent"]`` (but with your own words,
   or a favorite saying).
   
   a) Use ``' '.join(my_sent)`` to convert this into a string.
   b) Use ``split()`` to split the string back into the list form
      you had to start with.

#. |easy| Define several variables containing lists of words, e.g., ``phrase1``,
   ``phrase2``, and so on.  Join them together in various combinations (using the plus operator)
   to form whole sentences.  What is the relationship between
   ``len(phrase1 + phrase2)`` and ``len(phrase1) + len(phrase2)``?

#. |easy| Consider the following two expressions, which have the same
   value.  Which one will typically be more relevant in |NLP|?  Why?

   a) ``"Monty Python"[6:12]``
   b) ``["Monty", "Python"][1]``

#. |easy| We have seen how to represent a sentence as a list of words, where
   each word is a sequence of characters.  What does ``sent1[2][2]`` do?
   Why?  Experiment with other index values.

#. |easy| The first sentence of ``text3`` is provided to you in the
   variable ``sent3``.  The index of `the`:lx: in ``sent3`` is 1, because ``sent3[1]``
   gives us ``'the'``.  What are the indexes of the two other occurrences
   of this word in ``sent3``?

#. |easy| Review the discussion of conditionals in sec-making-decisions_.
   Find all words in the Chat Corpus (``text5``)
   starting with the letter `b`:lx:.  Show them in alphabetical order.

#. |easy| Type the expression ``list(range(10))`` at the interpreter prompt.
   Now try ``list(range(10, 20))``, ``list(range(10, 20, 2))``, and ``list(range(20, 10, -2))``.
   We will see a variety of uses for this built-in function in later chapters.

#. |soso| Use ``text9.index()`` to find the index of the word `sunset`:lx:.
   You'll need to insert this word as an argument between the parentheses.
   By a process of trial and error, find the slice for the complete sentence that
   contains this word.

#. |soso| Using list addition, and the ``set`` and ``sorted`` operations, compute the
   vocabulary of the sentences ``sent1`` ... ``sent8``.

#. |soso| What is the difference between the following two lines?
   Which one will give a larger value?  Will this be the case for other texts?
   
   .. doctest-ignore::
       >>> sorted(set(w.lower() for w in text1))
       >>> sorted(w.lower() for w in set(text1))

#. |soso| What is the difference between the following two tests:
   ``w.isupper()`` and ``not w.islower()``?

#. |soso| Write the slice expression that extracts the last two words of ``text2``.

#. |soso| Find all the four-letter words in the Chat Corpus (``text5``).
   With the help of a frequency distribution (``FreqDist``), show these
   words in decreasing order of frequency.

#. |soso| Review the discussion of looping with conditions in sec-making-decisions_.
   Use a combination of ``for`` and ``if`` statements to loop over the words of
   the movie script for *Monty Python and the Holy Grail* (``text6``)
   and ``print`` all the uppercase words, one per line.

#. |soso| Write expressions for finding all words in ``text6`` that
   meet the conditions listed below.  The result should be in the form of
   a list of words: ``['word1', 'word2', ...]``.
   
   a) Ending in `ize`:lx:
   b) Containing the letter `z`:lx:
   c) Containing the sequence of letters `pt`:lx:
   d) Having all lowercase letters except for an initial capital (i.e., ``titlecase``)

#. |soso| Define ``sent`` to be the list of words
   ``['she', 'sells', 'sea', 'shells', 'by', 'the', 'sea', 'shore']``.
   Now write code to perform the following tasks:

   a) Print all words beginning with `sh`:lx:
   b) Print all words longer than four characters

#. |soso| What does the following Python code do?  ``sum(len(w) for w in text1)``
   Can you use it to work out the average word length of a text?

#. |soso| Define a function called ``vocab_size(text)`` that has a single
   parameter for the text, and which returns the vocabulary size of the text.

#. |soso| Define a function ``percent(word, text)`` that calculates
   how often a given word occurs in a text, and expresses the result
   as a percentage.

#. |soso| We have been using sets to store vocabularies.  Try the following
   Python expression: ``set(sent3) < set(text1)``.  Experiment with this using
   different arguments to ``set()``.  What does it do?
   Can you think of a practical application for this?

.. include:: footer.rst
