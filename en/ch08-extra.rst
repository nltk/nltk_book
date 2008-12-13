
The following doesn't really fit any more
Perhaps another kind of syntactic variation, word order, is easier to
understand.  We know that the two sentences `Kim likes Sandy`:lx: and
`Sandy likes Kim`:lx: have different meanings, and that `likes Sandy
Kim`:lx: is simply ungrammatical.  Similarly, we know that the
following two sentences are equivalent:

.. ex::
  .. ex:: The farmer *loaded* the cart with sand
  .. ex:: The farmer *loaded* sand into the cart

However, consider the semantically similar verbs `filled`:lx: and `dumped`:lx:.
Now the word order cannot be altered (ungrammatical sentences are
prefixed with an asterisk.)

.. ex::
  .. ex:: The farmer *filled* the cart with sand
  .. ex:: \*The farmer *filled* sand into the cart
  .. ex:: \*The farmer *dumped* the cart with sand
  .. ex:: The farmer *dumped* sand into the cart



Old School Grammar
------------------

Early experiences with the kind of grammar taught in school are sometimes perplexing,
if not downright frustrating.
Written work is graded by a teacher who red-lined all
the grammar errors they wouldn't put up with.
Like the plural pronoun or the dangling preposition in the last sentence,
or sentences like this one that lack a main verb.
If you learnt English as a second language, you might have found it difficult
to discover which of these errors actually need to be fixed (or should that be: *needs* to be fixed?).
As a consequence, many people are afraid of grammar.  However, as users of
language we depend on our knowledge of grammar in order to produce and
understand sentences.  To see why grammar matters, consider the following
two sentences, which have an important difference of meaning:

.. ex::
  .. _rest:
  .. ex:: The vice-presidential candidate, who was wearing a $10,000 outfit,
	  smiled broadly.
  .. _nonrest:
  .. ex:: The vice-presidential candidate who was wearing a $10,000 outfit smiled broadly.

In rest_, we assume there is just one candidate, and say
two things about her: that she was wearing an expensive outfit and that she smiled. In
nonrest_, on the other hand, we use the description `who was wearing a $10,000 outfit`:lx:
as a means of identifying which particular candidate we are referring to.
In the above examples, punctuation is a clue to grammatical structure.  In particular,
it tells us whether the relative clause is restrictive or non-restrictive. 

In contrast, other grammatical concerns are nothing more than
vestiges of antiquated style.  For example, consider the injunction that :lx:`however`
|mdash| when used to mean *nevertheless* |mdash|
must not appear at the start of a sentence.
Pullum argues that Strunk and White [StrunkWhite1999]_ were
merely insisting that English usage should conform to "an utterly
unimportant minor statistical detail of style concerning adverb
placement in the literature they knew" [Pullum2005However]_.
This is a case where, a `descriptive`:em: observation about language use became
a `prescriptive`:em: requirement.

In |NLP| we usually discard such prescriptions,
and use grammar to formalize observations about language as it is used,
particularly as it is used in corpora.
We create our own formal grammars and write programs to parse sentences.
This is a far cry from "old school" grammar.  It is a thoroughly objective
approach that makes grammatical structures explicit with the help of
corpora, formal grammars, and parsers.

.. _sec-whats-the-use-of-syntax:


.. 

-------------------------
What's the Use of Syntax?
-------------------------


Syntactic Ambiguity
-------------------

We have seen that sentences can be ambiguous.  If we overheard someone
say :lx:`I went to the bank`, we wouldn't know whether it was
a river bank or a financial institution.  This ambiguity concerns
the meaning of the word :lx:`bank`, and is a kind of :dt:`lexical
ambiguity`.

However, other kinds of ambiguity cannot be explained in terms of
ambiguity of specific words.  Consider a phrase involving
an adjective with a conjunction:
`big cats and dogs`:lx:.
Does `big`:lx: have wider scope than `and`:lx:, or is it the other way
round? In fact, both interpretations are possible, and we can
represent the different scopes using parentheses:

.. ex::
  .. ex::  big (cats and dogs)
  .. ex::  (big cats) and dogs

One convenient way of representing this scope difference at a structural
level is by means of a `tree diagram`:dt:, as shown in tree-diagram_.

.. _tree-diagram:
.. ex::
  .. ex::
    .. tree:: (NP (Adj big)
		  (NP
		     (N cats)
		     (Conj and)
		     (N dogs)))
  .. ex::
    .. tree:: (NP (NP
		     (Adj big)
		     (N cats))
		  (Conj and)
		  (NP
		     (N dogs)))

Note that linguistic trees grow upside down: the node labeled `s`:gc:
is the `root`:dt: of the tree, while the `leaves`:dt: of the tree are
labeled with the words.

In NLTK, you can easily produce trees like this yourself with the
following commands:

    >>> tree = nltk.Tree('(NP (Adj big) (NP (N cats) (Conj and) (N dogs)))')
    >>> tree.draw()             # doctest: +SKIP

We can construct other examples of syntactic ambiguity
involving the coordinating conjunctions `and`:lx: and `or`:lx:, e.g.
`Kim left or Dana arrived and everyone cheered`:lx:.
We can describe this ambiguity in terms of the relative
semantic `scope`:dt: of `or`:lx: and `and`:lx:.

For our third illustration of ambiguity, we look at
prepositional phrases.
Consider a sentence like: :lx:`I saw the man with a telescope`.  Who
has the telescope?  To clarify what is going on here, consider the
following pair of sentences:

.. ex::
  .. ex:: The policeman saw a burglar *with a gun*.
	 (not some other burglar)
  .. ex:: The policeman saw a burglar *with a telescope*.
	 (not with his naked eye)

In both cases, there is a prepositional phrase introduced by
:lx:`with`.  In the first case this phrase modifies the noun
:lx:`burglar`, and in the second case it modifies the verb :lx:`saw`.
We could again think of this in terms of scope: does the prepositional
phrase (`pp`:gc:) just have scope over the `np`:gc:
`a burglar`:lx:, or does it have scope over
the whole verb phrase? As before, we can represent the difference in terms
of tree structure:

.. _burglar:
.. ex::
  .. ex::
    .. tree:: (S <NP the policeman>
		 (VP (V saw)
		     (NP <NP the burglar>
			 <PP with a gun>)))
  .. ex::
    .. tree:: (S <NP the policeman>
		 (VP (V saw)
		     <NP the burglar>
		     <PP with a telescope>))

In burglar_\ a, the `pp`:gc: attaches to the `np`:gc:,
while in burglar_\ b, the `pp`:gc: attaches to the `vp`:gc:.

We can generate these trees in Python as follows:

    >>> s1 = '(S (NP the policeman) (VP (V saw) (NP (NP the burglar) (PP with a gun))))'
    >>> s2 = '(S (NP the policeman) (VP (V saw) (NP the burglar) (PP with a telescope)))'
    >>> tree1 = nltk.bracket_parse(s1)
    >>> tree2 = nltk.bracket_parse(s2)

We can discard the structure to get the list of `leaves`:dt:, and
we can confirm that both trees have the same leaves (except for the last word).
We can also see that the trees have different `heights`:dt: (given by the
number of nodes in the longest branch of the tree, starting at `s`:gc:
and descending to the words):

    >>> tree1.leaves()
    ['the', 'policeman', 'saw', 'the', 'burglar', 'with', 'a', 'gun']
    >>> tree1.leaves()[:-1] == tree2.leaves()[:-1]
    True
    >>> tree1.height() == tree2.height()
    False

In general, how can we determine whether a prepositional phrase
modifies the preceding noun or verb? This problem is known as
`prepositional phrase attachment ambiguity`:dt:.
The `Prepositional Phrase Attachment Corpus`:dt: makes it
possible for us to study this question systematically.  The corpus is
derived from the IBM-Lancaster Treebank of Computer Manuals and from
the Penn Treebank, and distills out only the essential information
about `pp`:gc: attachment. Consider the sentence from the WSJ
in ppattach-a_.  The corresponding line in the Prepositional Phrase
Attachment Corpus is shown in ppattach-b_.

.. ex::
  .. _ppattach-a:
  .. ex::
     Four of the five surviving workers have asbestos-related diseases,
     including three with recently diagnosed cancer.
  .. _ppattach-b:
  .. ex::
     ::

       16 including three with cancer N

That is, it includes an identifier for the original sentence, the
head of the relevant verb phrase (i.e., `including`:lx:), the head of
the verb's `np`:gc: object (`three`:lx:), the preposition
(`with`:lx:), and the head noun within the prepositional phrase
(`cancer`:lx:). Finally, it contains an "attachment" feature (``N`` or
``V``) to indicate whether the prepositional phrase attaches to
(modifies) the noun phrase or the verb phrase. 
Here are some further examples:

.. _ppattachments:
.. ex::
   :: 

     47830 allow visits between families N
     47830 allow visits on peninsula V
     42457 acquired interest in firm N
     42457 acquired interest in 1986 V

The PP attachments in ppattachments_ can also be made explicit by
using phrase groupings as in phrase-groupings_.

.. _phrase-groupings:
.. ex::
   :: 

     allow (NP visits (PP between families))
     allow (NP visits) (PP on peninsula)
     acquired (NP interest (PP in firm))
     acquired (NP interest) (PP in 1986)

Observe in each case that the argument of the verb is either a single
complex expression ``(visits (between families))`` or a pair of
simpler expressions ``(visits) (on peninsula)``.

We can access the Prepositional Phrase Attachment Corpus from NLTK as follows:

    >>> nltk.corpus.ppattach.tuples('training')[9]
    ('16', 'including', 'three', 'with', 'cancer', 'N')

If we go back to our first examples of `pp`:gc: attachment ambiguity,
it appears as though it is the `pp`:gc: itself (e.g., `with a gun`:lx:
versus `with a telescope`:lx:) that determines the attachment. However,
we can use this corpus to find examples where other factors come into play.
For example, it appears that the verb is the key factor in ppattach-verb_.

.. _ppattach-verb:
.. ex::
   :: 

     8582 received offer from group V
     19131 rejected offer from group N



We claimed earlier that one of the motivations for building syntactic
structure was to help make explicit how a sentence says "who did what
to whom". Let's just focus for a while on the "who" part of this
story: in other words, how can syntax tell us what the subject of a
sentence is? At first, you might think this task is rather simple
|mdash| so simple indeed that we don't need to bother with syntax. In
a sentence such as `The fierce dog bit the man`:lx:
we know that it is the dog that is doing the biting. So we could
say that the noun phrase immediately preceding the verb is the
subject of the sentence. And we might try to make this more explicit
in terms of sequences of part-of-speech tags.  Let's try to come up with a simple
definition of `noun phrase`:idx:; we might start off with something
like this, based on our knowledge of noun phrase chunking (Chapter chap-chunk_):

::

    DT JJ* NN

We're using regular expression notation here in the form of
``JJ*`` to indicate a sequence of zero or more ``JJ`` \s. So this
is intended to say that a noun phrase can consist of a
determiner, possibly followed by some adjectives, followed by a
noun. Then we can go on to say that if we can find a sequence of
tagged words like this that precedes a word tagged as a verb, then
we've identified the subject. But now think about this sentence:

.. ex:: The child with a fierce dog bit the man.

This time, it's the child that is doing the biting. But the tag
sequence preceding the verb is:

::

    DT NN IN DT JJ NN

Our previous attempt at identifying the subject would have
incorrectly come up with `the fierce dog`:lx: as the subject.
So our next hypothesis would have to be a bit more complex. For
example, we might say that the subject can be identified as any string
matching the following pattern before the verb:

::

     DT JJ* NN (IN DT JJ* NN)*

In other words, we need to find a noun phrase followed by zero or more
sequences consisting of a preposition followed by a noun phrase. Now
there are two unpleasant aspects to this proposed solution. The first
is esthetic: we are forced into repeating the sequence of tags (``DT
JJ* NN``) that constituted our initial notion of noun phrase, and
our initial notion was in any case a drastic simplification. More
worrying, this approach still doesn't work! For consider the following
example:

.. _seagull:
.. ex:: The seagull that attacked the child with the fierce dog bit the man.

This time the seagull is the culprit, but it won't be detected as subject by our
attempt to match sequences of tags. So it seems that we need a
richer account of how words are *grouped* together into patterns, and
a way of referring to these groupings at different points in the
sentence structure. This idea of grouping is often called
syntactic `constituency`:dt:.

As we have just seen, a well-formed sentence of a language is more
than an arbitrary sequence of words from the language.  Certain kinds
of words usually go together.  For instance, determiners like `the`:lx:
are typically followed by adjectives or nouns, but not by verbs.
Groups of words form intermediate structures called phrases or
:dt:`constituents`.  These constituents can be identified using
standard syntactic tests, such as substitution, movement and
coordination.  For example, if a sequence of words can be replaced
with a pronoun, then that sequence is likely to be a constituent.
According to this test, we can infer that the italicized string in the
following example is a constituent, since it can be replaced by
`they`:lx:\:

.. ex::
  .. ex:: *Ordinary daily multivitamin and mineral supplements* could 
	 help adults with diabetes fight off some minor infections.
  .. ex:: *They* could help adults with diabetes fight off some minor
	 infections.

In order to identify whether a phrase is the subject of a sentence, we
can use the construction called `Subject-Auxiliary Inversion`:dt: in
English. This construction allows us to form so-called Yes-No
Questions. That is, corresponding to the statement in have1_, we have
the question in have2_:

.. ex::
  .. _have1:
  .. ex:: All the cakes have been eaten.
  .. _have2:
  .. ex:: Have *all the cakes* been eaten?

Roughly speaking, if a sentence already contains an auxiliary verb,
such as `has`:lx: in have1_, then we can turn it into a Yes-No
Question by moving the auxiliary verb 'over' the subject noun phrase
to the front of the sentence. If there is no auxiliary in the
statement, then we insert the appropriate form of `do`:lx: as the
fronted auxiliary and replace the tensed main verb by its base form:

.. ex::
  .. ex:: The fierce dog bit the man.
  .. ex:: Did *the fierce dog* bite the man?

As we would hope, this test also confirms our earlier claim about the
subject constituent of seagull_:

.. ex:: Did *the seagull that attacked the child with the fierce dog* bite
       the man?

To sum up then, we have seen that the notion of constituent brings a
number of benefits. By having a constituent labeled `noun phrase`:gc:,
we can provide a unified statement of the classes of word that
constitute that phrase, and reuse this statement in describing noun
phrases wherever they occur in the sentence. Second, we can use the
notion of a noun phrase in defining the subject of sentence, which in
turn is a crucial ingredient in determining the "who does what to
whom" aspect of meaning.
