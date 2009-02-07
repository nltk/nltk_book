.. -*- mode: rst -*-
.. include:: ../definitions.rst

.. _app-chart:

=======================
Appendix: Chart Parsing
=======================

Chart Parsing is a parsing algorithm that uses dynamic programming,
a technique described in Section sec-algorithm-design_.
It extends the method of well-formed substring tables from
Section sec-parsing_.

-------------
Active Charts
-------------

The content of a WFST can be represented in a directed acyclic graph,
as shown in chartinita_ for the initialized WFST and
chartinitb_ for the completed WFST.

.. ex::

  .. _chartinita:
  .. ex::
      .. image:: ../images/chart_wfst1.png
         :scale: 25:75:25

  .. _chartinitb:
  .. ex::
     .. image:: ../images/chart_wfst2.png
        :scale: 25:75:25

In general, a chart parser hypothesizes constituents (i.e. adds edges)
based on the grammar, the tokens, and the constituents already found.
Any constituent that is compatible with the current knowledge can be hypothesized;
even though many of these hypothetical constituents will never be used in
the final result.  A |WFST| just records these hypotheses.

All of the edges that we've seen so far represent complete
constituents.  However, it is helpful to record
*incomplete* constituents, to document the work
already done by the parser.  For example, when a
top-down parser processes *VP* |rarr| *V* *NP* *PP*,
it may find *V* and *NP* but not the *PP*.  This work
can be reused when processing *VP* |rarr| *V* *NP*.
Thus, we will record the
hypothesis that "the `v`:gc: constituent `likes`:lx: is the beginning of a `vp`:gc:."

We can do this by adding a `dot`:dt: to the edge's right hand side.
Material to the left of the dot records what has been found so far;
material to the right of the dot specifies what still needs to be found in order
to complete the constituent.  For example, the edge in
dottededge_ records the hypothesis that "a `vp`:gc: starts with the `v`:gc:
`likes`:lx:, but still needs an `np`:gc: to become complete":

.. _dottededge:
.. ex::
   .. image:: ../images/chart_intro_dottededge.png
      :scale: 30:75:75

These `dotted edges`:dt: are used to record all of the hypotheses that a
chart parser makes about constituents in a sentence.

-------------
Types of Edge
-------------

Let's take stock.
An edge [`VP`:gc: |rarr| |dot| `V`:gc: `NP`:gc: `PP`:gc:, (*i*, *i*)]
records the hypothesis that a `VP`:gc: begins at location *i*, and that we anticipate
finding a sequence `V NP PP`:gc: starting here.  This is known as a
`self-loop edge`:dt:; see chart-intro-selfloop_.
An edge [`VP`:gc: |rarr| `V`:gc: |dot| `NP`:gc: `PP`:gc:, (*i*, *j*)]
records the fact that we have discovered a `V`:gc: spanning (*i*, *j*),
and hypothesize a following `NP PP`:gc: sequence to complete a `VP`:gc:
beginning at *i*.  This is known as an `incomplete edge`:dt:;
see chart-intro-incomplete_.
An edge [`VP`:gc: |rarr| `V`:gc: `NP`:gc: `PP`:gc: |dot| , (*i*, *k*)]
records the discovery that a `VP`:gc: consisting of the sequence
`V NP PP`:gc: has been discovered for the span (*i*, *j*).  This is known
as a `complete edge`:dt:; see chart-intro-parseedge_.
If a complete edge spans the entire sentence, and has the grammar's
start symbol as its left-hand side, then the edge is called a `parse
edge`:dt:, and it encodes one or more parse trees for the sentence;
see chart-intro-parseedge_.

.. ex::

   .. _chart-intro-selfloop:
   .. ex::
      .. image:: ../images/chart_intro_selfloop.png
         :scale: 25

   .. _chart-intro-incomplete:
   .. ex::
      .. image:: ../images/chart_intro_incomplete.png
         :scale: 25:25:75

   .. _chart-intro-parseedge:
   .. ex::
      .. image:: ../images/chart_intro_parseedge.png
         :scale: 25

----------------
The Chart Parser
----------------

To parse a sentence, a chart parser first creates an empty chart
spanning the sentence.  It then finds edges that are licensed by its
knowledge about the sentence, and adds them to the chart one at a time
until one or more parse edges are found.  The edges that it adds can
be licensed in one of three ways:

i. The *input* can license an edge: each word `w`:sub:`i`
   in the input licenses the complete edge [`w`:sub:`i` |rarr|
   |dot|, (*i*, *i*\ +1)].

#. The *grammar* can license an edge: each grammar
   production A |rarr| |alpha| licenses the self-loop edge [*A* |rarr|
   |dot| |alpha|, (*i*, *i*)] for every *i*, 0 |leq| *i* < *n*.

#. The *current chart contents* can license an edge:
   a suitable pair of existing edges triggers the addition
   of a new edge. 

Chart parsers use a set of `rules`:dt: to heuristically decide
when an edge should be added to a chart.  This set of rules, along
with a specification of when they should be applied, forms a
`strategy`:dt:.

--------------------
The Fundamental Rule
--------------------

One rule is particularly important, since it is used by every chart
parser: the `Fundamental Rule`:dt:.  This rule is used to combine an
incomplete edge that's expecting a nonterminal *B* with a following, complete
edge whose left hand side is *B*.  The rule is defined and illustrated in fundamental-rule_.
We will use |alpha|, |beta|, and |gamma| to denote (possibly empty) sequences
of terminals or non-terminals.

.. _fundamental-rule:
.. ex:: `Fundamental Rule`:dt: If the chart contains the edges
   [*A* |rarr| |alpha|\ |dot|\ *B*\ |beta|\ , (*i*, *j*\ )] and
   [*B* |rarr| |gamma|\ |dot|\ , (*j*, *k*\ )] then add a new edge
   [*A* |rarr| |alpha|\ *B*\ |dot|\ |beta|\ , (*i*, *k*)].

   |chart_fundamental|

.. |chart_fundamental| image:: ../images/chart_fundamental.png
   :scale: 30:100:30

In the new edge, the dot has moved one place to the right.
Its span is the combined span of the original edges.
Note that in adding this new edge we do not remove the other two,
because they might be used again.

-----------------
Bottom-Up Parsing
-----------------

As we saw with the shift-reduce parser in sec-parsing_,
bottom-up parsing starts from the input string,
and tries to find sequences of words and phrases that
correspond to the *right hand* side of a grammar production. The
parser then replaces these with the left-hand side of the production,
until the whole sentence is reduced to an `S`:gc:.  Bottom-up chart
parsing is an extension of this approach in which hypotheses about
structure are recorded as edges on a chart. In terms of our earlier
terminology, bottom-up chart parsing can be seen as a parsing
strategy; in other words, bottom-up is a particular choice of
heuristics for adding new edges to a chart. 

The general procedure for chart parsing is
inductive: we start with a base case, and then show how we can move
from a given state of the chart to a new state. Since we are working
bottom-up, the base case for our induction will be determined by the
words in the input string, so we add new edges for each word.  Now,
for the induction step, suppose the chart contains an edge labeled
with constituent *A*. Since we are working bottom-up, we want to build
constituents that can have an *A* as a daughter. In other words, we
are going to look for productions of the form *B* |rarr| *A* |beta| and use
these to label new edges.

Let's look at the procedure a bit more formally.  To create a
bottom-up chart parser, we add to the Fundamental Rule two new rules:
the `Bottom-Up Initialization Rule`:dt:; and the `Bottom-Up Predict
Rule`:dt:.
The Bottom-Up Initialization Rule says to add all edges licensed by
the input.

.. _bottom-up-initialization-rule:
.. ex:: `Bottom-Up Initialization Rule`:dt: For every word w\ :subscript:`i` add the edge
   [`w`:subscript:`i` |rarr|  |dot| , (*i*, *i*\ +1)]

   |chart_bu_ex1|

.. |chart_bu_ex1| image:: ../images/chart_bu_ex1.png
   :scale: 30

Next, suppose the chart contains a complete edge *e* whose
left hand category is *A*. Then the Bottom-Up Predict Rule requires the
parser to add a self-loop edge at the left boundary of *e*
for each grammar production whose right hand side begins with category
*A*.

.. _bottom-up-predict-rule:
.. ex:: `Bottom-Up Predict Rule`:dt: For each complete edge
   [*A* |rarr| |alpha|\ |dot|\ , (*i*, *j*\ )] and each production
   *B* |rarr| *A*\ |beta|\ , add the self-loop edge
   [*B* |rarr|  |dot|\ *A*\ |beta|\ , (*i*, *i*\ )]

   |chart_bu_ex2|

.. |chart_bu_ex2| image:: ../images/chart_bu_ex2.png
   :scale: 30

The next step is to use the Fundamental Rule to add edges
like [`np`:gc: |rarr| Lee |dot| , (0, 1)],
where we have "moved the dot" one position to the right.
After this, we will now be able to add new self-loop edges such as 
[`s`:gc: |rarr|  |dot| `np`:gc: `vp`:gc:, (0, 0)] and
[`vp`:gc: |rarr|  |dot| `vp`:gc: `np`:gc:, (1, 1)], and use these to
build more complete edges.

Using these three rules, we can parse a sentence as shown in
bottom-up-strategy_.

.. _bottom-up-strategy:
.. ex::
   `Bottom-Up Strategy`:dt:

   .. parsed-literal::

    Create an empty chart spanning the sentence. 
    Apply the Bottom-Up Initialization Rule to each word. 
    Until no more edges are added: 
      Apply the Bottom-Up Predict Rule everywhere it applies. 
      Apply the Fundamental Rule everywhere it applies. 
    Return all of the parse trees corresponding to the parse edges in the chart. 

.. note:: |TRY|
   |NLTK| provides a useful interactive tool for visualizing the operation of a
   chart parser: ``nltk.app.chartparser()``.
   The tool comes with a pre-defined input string and grammar, but both
   of these can be readily modified with options inside the *Edit* menu.

----------------
Top-Down Parsing
----------------

Top-down chart parsing works in a similar way to the recursive descent
parser, in that it starts off with the top-level goal of finding an `s`:gc:.
This goal is broken down into the subgoals of trying to find constituents such as `np`:gc: and
`vp`:gc: predicted by the grammar.
To create a top-down chart parser, we use the Fundamental Rule as before plus
three other rules: the `Top-Down Initialization Rule`:dt:, the `Top-Down
Expand Rule`:dt:, and the `Top-Down Match Rule`:dt:.
The Top-Down Initialization Rule in td-init-rule_
captures the fact that the root of any
parse must be the start symbol `s`:gc:\.

.. _td-init-rule:
.. ex:: `Top-Down Initialization Rule`:dt: For each production `s`:gc: |rarr| |alpha|
   add the self-loop edge [`s`:gc: |rarr| |dot|\ |alpha|\ , (0, 0)]

   |chart_td_ex1|

.. |chart_td_ex1| image:: ../images/chart_td_ex1.png
   :scale: 30

In our running example, we are predicting that we will be able to find an `np`:gc: and a
`vp`:gc: starting at 0, but have not yet satisfied these subgoals.
In order to find an  `np`:gc: we need to
invoke a production that has `np`:gc: on its left hand side. This work
is done by the Top-Down Expand Rule td-expand-rule_.
This tells us that if our chart contains an incomplete
edge whose dot is followed by a nonterminal *B*, then the parser
should add any self-loop edges licensed by the grammar whose left-hand
side is *B*.

.. _td-expand-rule:
.. ex:: `Top-Down Expand Rule`:dt: For each incomplete edge
   [*A* |rarr| |alpha|\ |dot|\ *B*\ |beta|\ , (*i*, *j*)] and
   for each grammar production *B* |rarr| |gamma|, add the edge
   [*B* |rarr| |dot|\ |gamma|\ , (*j*, *j*\ )]

   |chart_td_ex2|

.. |chart_td_ex2| image:: ../images/chart_td_ex2.png
   :scale: 30

The Top-Down Match rule allows the predictions of the grammar to be
matched against the input string. Thus, if the chart contains an incomplete
edge whose dot is followed by a terminal *w*, then the parser should
add an edge if the terminal corresponds to the current input symbol.

.. _top-down-match-rule:
.. ex:: `Top-Down Match Rule`:dt: For each incomplete edge
   [*A* |rarr| |alpha|\ |dot|\ w\ :subscript:`j` |beta|\ , (*i*, *j*\ )], 
   where w\ :subscript:`j` is the *j* :sup:`th` word of the input,
   add a new complete edge [`w`:subscript:`j` |rarr| |dot|\ , (*j*, *j*\ +1)]

   |chart_td_ex3|
        
.. |chart_td_ex3| image:: ../images/chart_td_ex3.png
   :scale: 30

Here we see our example chart after applying the Top-Down Match rule.
After this, we can apply the fundamental rule to
add the edge [`np`:gc: |rarr| Lee |dot| , (0, 1)].

Using these four rules, we can parse a sentence top-down as shown in
top-down-strategy_.

.. _top-down-strategy:
.. ex::
   `Top-Down Strategy`:dt:

   .. parsed-literal::

    Create an empty chart spanning the sentence. 
    Apply the Top-Down Initialization Rule (at node 0) 
    Until no more edges are added: 
      Apply the Top-Down Expand Rule everywhere it applies. 
      Apply the Top-Down Match Rule everywhere it applies. 
      Apply the Fundamental Rule everywhere it applies. 
    Return all of the parse trees corresponding to the parse edges in
    the chart. 

.. note: |TRY|
   We encourage you to experiment with the |NLTK| chart parser demo,
   as before, in order to test out the top-down strategy yourself.

--------------------
The Earley Algorithm
--------------------

The Earley algorithm [Earley1970ECF]_ is a parsing strategy that
resembles the Top-Down Strategy, but deals more efficiently with
matching against the input string. Table earley-terminology_ shows the
correspondence between the parsing rules introduced above and the
rules used by the Earley algorithm.

.. table:: earley-terminology

    +-------------------------------+------------------------------+
    |**Top-Down**\ /**Bottom-Up**   |   **Earley**                 |
    +===============================+==============================+
    | Top-Down Initialization Rule  |  Predictor Rule              |
    | Top-Down Expand Rule          |                              |
    +-------------------------------+------------------------------+
    | Top-Down/Bottom-Up Match Rule |  Scanner Rule                |
    +-------------------------------+------------------------------+
    | Fundamental Rule              |  Completer Rule              |
    +-------------------------------+------------------------------+

    Terminology for rules in the Earley algorithm

Let's look in more detail at the Scanner Rule. Suppose the chart
contains an incomplete edge with a lexical category *P* immediately after
the dot,  the next word in the input is *w*, *P* is a part-of-speech
label for *w*. Then the Scanner Rule admits a new complete edge in
which *P* dominates *w*. More precisely:

.. _scanner-rule:
.. ex:: `Scanner Rule`:dt: For each incomplete edge of the form
   [*A* |rarr| |alpha| |dot|\ *P*\ |beta|\ , (*i*, *j*)] where
   *w*\ :subscript:`j` is the *j*\ :sup:`th` word of the input
   and *P* is a valid part of speech for *w*\ :subscript:`j`,
   add the new complete edges
   [*P* |rarr| *w*\ :subscript:`j`\ |dot|\ , (*j*, *j*\ +1)] and
   [*w*\ :subscript:`j` |rarr| |dot|\ , (*j*, *j*\ +1)]  

To illustrate, suppose the input is of the form 
`I saw ...`:lx:, and the chart already contains the edge 
[`vp`:gc: |rarr|  |dot| `v`:gc: ..., (1, 1)]. Then the Scanner Rule will add to 
the chart the edges [`v`:gc: |rarr| 'saw', (1, 2)]
and ['saw'|rarr| |dot|\ , (1, 2)]. So in effect the Scanner Rule packages up a
sequence of three rule applications: the Bottom-Up Initialization Rule for 
[*w* |rarr| |dot|\ , (*j*, *j*\ +1)],
the Top-Down Expand Rule for [*P* |rarr| |dot| *w*\ :subscript:`j`, (*j*, *j*)], and 
the Fundamental Rule for [*P* |rarr| *w*\ :subscript:`j` |dot|\ , (*j*,
*j*\ +1))]. This is considerably more efficient than the Top-Down Strategy, that
adds a new edge of the form [*P* |rarr| |dot| *w* , (*j*, *j*)] for
`every`:em: lexical rule *P* |rarr| *w*, regardless of whether *w* can
be found in the input.
By contrast with Bottom-Up Initialization, however, the
Earley algorithm proceeds strictly left-to-right through the input,
applying all applicable rules at that point in the chart, and never backtracking.

.. note:: |TRY|
   The |NLTK| chart parser demo, ``nltk.app.chartparser()``, allows the option of
   parsing according to the Earley algorithm.

---------------------
Chart Parsing in NLTK
---------------------

NLTK defines a simple yet flexible chart parser,
``ChartParser``.  A new chart parser is constructed from a
grammar and a strategy.  The strategy is applied until no new edges are added to the
chart.
|NLTK| defines two ready-made strategies:
``TD_STRATEGY``, a basic top-down strategy; and ``BU_STRATEGY``, a
basic bottom-up strategy.  When constructing a chart parser, you
can use either of these strategies, or create your own.  We've
already seen how to define a chart parser in section sec-dilemmas_.
This time we'll specify a strategy and turn on tracing:

.. doctest-ignore::
    >>> sent = ['I', 'shot', 'an', 'elephant', 'in', 'my', 'pajamas']
    >>> parser = nltk.ChartParser(groucho_grammar, nltk.parse.BU_STRATEGY)
    >>> trees = parser.nbest_parse(sent, trace=2)

.. note: |TRY|
   Try running the above example to view the operation of the chart
   parser in detail.  In the output, ``[-----]`` indicates a complete edge,
   ``>`` indicates a self-loop edge, ``[----->`` indicates an
   incomplete edge, and ``[======]`` indicates a parse edge.


.. include:: footer.rst

