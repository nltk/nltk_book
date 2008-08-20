.. -*- mode: rst -*-
.. include:: ../definitions.rst

.. standard global imports

    >>> import nltk, re, pprint
    
.. TODO: cover tf.idf

.. _chap-data-intensive:

=====================================
4. Data-Intensive Language Processing
=====================================

------------
Introduction
------------

Language is full of patterns.
In Chapter chap-words_ we saw that frequent use of the modal verb
`will`:lx: is characteristic of news text, and
more generally, that we can use the frequency of a small number of diagnostic
words in order to automatically guess the genre of a text (Table brown-types_).
In Chapter chap-tag_ we saw that words ending in `ed`:lx: tend to
be past tense verbs, and more generally, that the internal structure of words
tells us something about their part of speech. (Section sec-regular-expression-tagger_).
Detecting such patterns is central to many NLP tasks,
particularly those that try to access the meaning of a text.

In order to study and model these linguistic patterns we need to be able to write
programs to process large quantities of annotated text.
In this chapter we will focus on data-intensive language processing,
covering manual approaches to exploring linguistic data in Section sec-exploratory-data-analysis_
and automatic approaches in Section sec-data-modeling_.

.. more motivation and overview of this simple ontology (manual vs automatic)

------------------------------------------
Exploiting Patterns to Understand Language
------------------------------------------

For example, in `word sense disambiguation`:dt: we want to work out
which sense of a word was intended in a given context.  Consider the
ambiguous words `serve`:lx: and `dish`:lx:\ :

.. ex::
    .. ex:: `serve`:lx:\ : help with food or drink; hold an office; put ball into play
    .. ex:: `dish`:lx:\ : plate; course of a meal; communications device

|nopar|
Now, in a sentence containing the phrase: `he served the dish`:lx: we
can detect that both `serve`:lx: and `dish`:lx: are being used with
their food meanings.  Its unlikely that the topic of discussion
shifted from sports to communications between these words, since it
would result in bizarre interpretations like striking a satellite dish
with a tennis racquet:

.. ex::
    In a fit of fury, he tossed the portable satellite receiver in the air, and with
    a quick flick of his tennis racquet, he served the dish.

In other words, we automatically disambiguate words using context, exploiting
the simple fact that nearby words have closely related meanings.
As another example of this contextual effect, consider the word
`by`:lx:, which has three meanings: `the book by Chesterton`:lx: (agentive);
`the cup by the stove`:lx: (locative); and `submit by Friday`:lx: (temporal).
Observe in lost-children_ that the meaning of the italicized word helps us
interpret the meaning of `by`:lx:.

.. _lost-children:
.. ex::
   .. ex:: The lost children were found by the `searchers`:em:  (agentive)
   .. ex:: The lost children were found by the `mountain`:em:   (locative)
   .. ex:: The lost children were found by the `afternoon`:em:  (temporal)

A deeper kind of language understanding is to work out who did what to whom |mdash|
i.e. to detect the subjects and objects of verbs.
In the sentence `the thieves stole the paintings`:lx:
it is easy to tell who performed the stealing action.
Consider three possible following sentences in thieves_, and try to determine
what was sold, caught, and found (one case is ambiguous).
  
.. _thieves:
.. ex::
   .. ex:: The thieves stole the paintings.  They were subsequently `sold`:em:.
   .. ex:: The thieves stole the paintings.  They were subsequently `caught`:em:.
   .. ex:: The thieves stole the paintings.  They were subsequently `found`:em:.

|nopar|
Answering this question involves finding the `antecedent`:dt: of the pronoun `they`:lx:
(the theives or the paintings).  Computational techniques for solving this problem
fall under the heading of `semantic role labeling`:dt:.
If we can automatically solve such problems, we will have understood enough of the
text to perform some important language generation tasks, such as
`question answering`:idx: and `machine translation`:idx:.  In the first case,
a machine should be able to answer a user's questions relating to collection of texts:

.. _qa-application:
.. ex::
   .. ex:: *Text:* ... The thieves stole the paintings.  They were subsequently sold. ...
   .. ex:: *Human:* Who or what was sold?
   .. ex:: *Machine:* The paintings.

|nopar|
The machine's answer demonstrates that it has correctly worked out that `they`:lx:
refers to paintings and not to theives.  In the second case, the machine should
be able to produce a translation of the text into another language, accurately
conveying the meaning of the original text.  In translating the above text into French,
we are forced to choose the gender of the pronoun in the second sentence:
`ils`:lx: (masculine) if the thieves are sold, and `elles`:lx: (feminine) if
the paintings are sold.  Correct translation actually depends on correct understanding of
the pronoun.

.. _mt-application:
.. ex::
   .. ex:: The thieves stole the paintings.  They were subsequently sold.
   .. ex:: Les voleurs ont vol\ |eacute| les peintures. *Ils* ont |eacute|\ t\ |eacute| *vendus* plus tard.  (the thieves)
   .. ex:: Les voleurs ont vol\ |eacute| les peintures. *Elles* ont |eacute|\ t\ |eacute| *vendues* plus tard.  (the paintings)
    
In all of the above examples |mdash| working out the sense of a word, the subject of a verb, the 
antecedent of a pronoun |mdash| are steps in establishing the meaning of a sentence, things
we would expect a language understanding system to be able to do.  Interestingly, all of them
turn out to involve `classification`:dt:, tagging a word with a sense tag, a verb-argument tag, etc.

We have already seen the application of
classification in the case of part-of-speech tagging (Chapter chap-tag_).
Although this is a humble beginning, it actually holds the key for a range of more
difficult classification tasks, including those mentioned above.
Recall that adjectives (tagged ``JJ``) tend to precede nouns (tagged ``NN``),
and that we can use this information to predict that the word `deal`:lx: is
a noun in the context `good deal`:lx: (and not a verb, as in `to deal cards`:lx:).
Context is important more generally;
consider what happens when we try to classify words as possible geographic
locations with no reference to context, in Figure locations_.

.. _locations:

.. figure:: ../images/locations.png
   :scale: 25

   Location Detection by Simple Lookup

Once we have this categorized sequence, we can try to discover higher-level patterns.
For example, texts refer to entities, e.g. `audio books`:lx:, `the town of Springfield, Greene County, MO`:lx:,
`Gary Sanchez`:lx:, `the library's $2 million budget`:lx:.  As we will see later in Chapter
chap-chunk_, we can identify these "named entities" by classifying sequences of part-of-speech tags.
Texts go further to relate these entities, using verbs to link them into a series of events.
At this level too, we will be able to automatically analyze sequences of classified linguistic
items to extract meaning from the text.

Exercises
---------

#. |easy| Read up on one of the language technologies mentioned in this section, such as
   word sense disambiguation, semantic role labeling, question answering, machine translation,
   named entity detection.
   Find out what type and quantity of annotated data is required for developing such systems.
   Why do you think a large amount of data is required?


.. _sec-exploratory-data-analysis:

-------------------------
Exploratory Data Analysis
-------------------------

As language speakers, we all have intuitions about how language works,
and what patterns it contains.  Unfortunately, those intuitions are
notoriously unreliable.  We tend to notice unusual words and constructions,
and to be oblivious to high-frequency cases.  Many public commentators go
further to make pronouncements about statistics and usage which turn out to
be false.  Many examples are documented on *LanguageLog*, e.g.

* Strunk and White's injunction against using adjectives and adverbs
  http://itre.cis.upenn.edu/~myl/languagelog/archives/001905.html
* Brizenden's claim that women use 20,000 words a day while men use 7,000
  http://itre.cis.upenn.edu/~myl/languagelog/archives/003420.html
* Payack's claim that vocabulary size of English stood at 986,120 on 2006-01-26
  http://itre.cis.upenn.edu/~myl/languagelog/archives/002809.html
  
In order to get an accurate idea of how language works, and what
patterns it contains, we must study langauge |mdash| in a wide
variety of forms and contexts |mdash| as impartial observers.
To help facilitate this endevour, researchers and
organizations have created many large collections of real-world
language, or `corpora`:dt:.  These corpora are collected from a wide
variety of sources, including literature, journalism, telephone
conversations, instant messaging, and web pages.

Exploratory data analysis, the focus of this section, is a technique
for learning about a specific linguistic pattern, or
`construction`:dt:.  It consists of four steps, illustrated in Figure
exploration_.

.. _exploration:

.. figure:: ../images/exploration.png
   :scale: 25

   Exploratory Corpus Analysis
   
First, we must find the occurrences of the construction that we're
interested in, by searching the corpus.  Ideally, we would like to
find all occurrences of the construction, but sometimes that may not
be possible, and we have to be careful not to over-generalize our
findings.  In particular, we should be careful not to conclude that
something doesn't happen simply because we were unable to find any
examples; it's also possible that our corpus is deficient.

Once we've found the constructions of interest, we can then categorize
them, using two sources of information: content and context.  In some cases,
like identifying date and time expressions in text, we can simply write
a set of rules to cover the various cases.  In general, we can't just
enumerate the cases but we have to manually annotate a corpus of text
and then train systems to do the task automatically.

Having collected and categorized the constructions of interest, we can
proceed to look for patterns.  Typically, this involves describing
patterns as combinations of categories, and counting how often
different patterns occur.  We can check for both graded distinctions
and categorical distinctions...

* center-embedding suddenly gets bad after two levels
* examples from probabilistic syntax / gradient grammaticality

Finally, the information that we discovered about patterns in the
corpus can be used to refine our understanding of how constructions
work.  We can then continue to perform exploratory data analysis, both
by adjusting our characterizations of the constructions to better fit
the data, and by building on our better understanding of simple
constructions to investigate more complex constructions.

Although we have described exploratory data analysis as a cycle of
four steps, it should be noted that any of these steps may be skipped
or re-arranged, depending on the nature of the corpus and the
constructions that we're interested in understanding.  For example, we
can skip the search step if we already have a corpus of the relevant
constructions; and we can skip categorization if the constructions are
already labeled.
       
Selecting a Corpus
------------------

collections of real-world language, or `corpora`:dt:.  These corpora
are collected from a wide variety of sources, including literature,
journalism, telephone conversations, instant messaging, and web pages.

- The starting point for exploratory data analysis is a corpus.
- corpora vary widely, and it's important to understand the
  characteristics of the corpus, in order to understand how those
  characteristics affect the data analysis.

  - how specialized?  one genre vs multi-genre.  balanced?
  
    - analysis results do not necessarily generalize to other
      genres, other modalities, etc.

  - how large is it?  be careful about interpreting data from small
    corpora.  In particular, be careful about making any negative
    statements -- if you don't find something, that doesn't mean that
    it never happens.
    
.. SB: xref data chapter
  
Search
------
- Once we've selected a corpus, we can search it for relevant instances.
- Our search techniques will depend on the corpus type.

Searching Unannotated Data
++++++++++++++++++++++++++

  - corpus consists of raw text, with no extra information.

    - messy.
  
  - most common example: web search engine such as google
  - searches are typically formulated as word patterns

    - simple word patterns: "give the * to him"
    - http://itre.cis.upenn.edu/~myl/languagelog/archives/002733.html
    - complex word patterns: regexps

  - It's usually possible to find some examples of the phenomenon
    that we're interested in.

    - But it can be very difficult to find all examples -> so be
      very careful about drawing any negative conclusions.

  - Example: google.

    - Use quoted strings to tell google to search for a specific pattern.
    
      - Use "x and other ys" to look for hypernyms.
      
    - Use "*" for fill-in-the-blank patterns

      - Use "give * a ball" to search for nouns that can receive
        concrete objects.

      .. SB: use "as * as x" to look for properties
             http://acl.ldc.upenn.edu/P/P07/P07-1008.pdf

    - Google caveats:

      - If we can't find something, that doesn't mean it's not there.
      - Counts can be misleading

        - Some examples may contain the word string you searched for,
          but may use it in an unexpected way -- each example potentially
          needs to be verified!
        - Duplicates, images, etc, cause problems.  E.g., count("the of")
          is very high, even though we know it's not good english.

       .. SB: use of Google 5-gram corpus for some of these things?

Searching hand-annotated corpora
++++++++++++++++++++++++++++++++

  - Searching unannotated corpora is fairly easy; but it has several
    drawbacks: it can be very difficult to search for some types of
    patterns; and it can be hard to find all occurrences of a given
    phenomenon.
    
    - sb: examples searching for words in context, tag context, syn context, etc

  - Partially to help address these concerns, a large number of manually
    annotated corpora have been created.

    - Make it easier to find occurrences of specific types of phenomena

      - Often, this makes it possible to find all of the occurrences of
        a given phenomenon (if phenomenon & annotation info are closely
        related.)
        
      - But annotated corpora are usually small, so still be careful
        about negative conclusions.

  - Search techniques:

    - Use existing tools (tgrep, treesearch, etc)
    - Write short programs
    - Walk through several examples

  .. SB: NB a later discussion of XML will include XPath, another method for tree search

>>> grammar = r"""
...   CHUNK: {<V.*> <TO> <V.*>}
... """
>>> cp = nltk.RegexpChunker(grammar)
>>> brown = nltk.corpus.brown
>>> for sent in brown.tagged_sents()[:500]:
...     tree = cp.parse(sent)
...     for subtree in tree.subtrees():
...         if subtree.node == 'CHUNK': print subtree
(CHUNK combined/VBN to/TO achieve/VB)
(CHUNK continue/VB to/TO place/VB)
(CHUNK serve/VB to/TO protect/VB)
(CHUNK wanted/VBD to/TO wait/VB)
(CHUNK allowed/VBN to/TO place/VB)
(CHUNK expected/VBN to/TO become/VB)
(CHUNK expected/VBN to/TO approve/VB)
(CHUNK expected/VBN to/TO make/VB)
(CHUNK intends/VBZ to/TO make/VB)
        
.. pylisting:: sentential_complement

   def filter(tree):
       child_nodes = [child.node for child in tree
                      if isinstance(child, nltk.Tree)]
       return  (tree.node == 'VP') and ('S' in child_nodes)

   >>> treebank = nltk.corpus.treebank
   >>> for tree in treebank.parsed_sents()[:5]:
   ...     for subtree in tree.subtrees(filter):
   ...         print subtree
   (VP
     (VBN named)
     (S
       (NP-SBJ (-NONE- *-1))
       (NP-PRD
         (NP (DT a) (JJ nonexecutive) (NN director))
         (PP
           (IN of)
           (NP (DT this) (JJ British) (JJ industrial) (NN conglomerate))))))

Searching Automatically Annotated Data
++++++++++++++++++++++++++++++++++++++

- sometimes hand-annotated corpora are too small, but annotated corpora
  don't have enough info.
  
- solution: automatically annotated data

  - use hand-annotated corpora to train a system
  - automatically annotate more data
  - search the automatically annotated data
  - is this safe?

    - yes, sometimes.
    - look at the automatic system's accuracy, and think about how it
      might affect your search

      - could the automatic system make a systematic error that would
        prevent you from finding an important class of instances?
      - the more closely tied the annotation & the phenomenon are, the
        more likely you are to get into trouble.

Categorizing
------------

Once we've found the occurrences we're interested in, the next step is
to categorize them.  In general, we're interested in two things:

  - features of the phenomenon itself
  - features of the context that we think are relevant to the phenomenon.

Categorization can be automatic or manual

  - automatic: when the decision can be made deterministically.  e.g.,
    what is the previous word?
    
  - manual: when the decision needs human judgement.  example.. animacy?

Encoding this information -- features.  We need to encode this info in
a concrete way.  Use a feature dictionary for each occurrence, mapping
feature names (eg 'prevword') to concrete values (eg a string, int).
Features are typically simple-valued, but don't necessarily need to
be.  (Though they will need to be for automatic methods.. coming up)


.. pylisting: tagging

   def features(word):
       return dict( len = len(word),
                    last1 = word[-1:],
                    last2 = word[-2:],
                    last3 = word[-3:])

   >>> data = [(features(word), tag) for (word, tag) in nltk.corpus.brown.tagged_words('a')]
   >>> train = data[1000:]
   >>> test = data[:1000]
   >>> classifier = nltk.NaiveBayesClassifier.train(train)
   >>> nltk.classify.accuracy(classifier, test)
   0.8110




.. pylisting: segmentation

   def preprocess(sents):
       tokens = []
       boundaries = []
       for sent in sents:
           for token in sent:
               tokens.append(token)
           boundaries.append(False)
           boundaries[-1] = True
       return (tokens, boundaries)

   def get_instances(tokens, boundaries):
       instances = []
       for i in range(len(tokens)):
           if tokens[i] in ".?!":
               try:
                   instances.append(
                       (dict( upper = tokens[i+1][0].isupper(),
                              abbrev = len(tokens[i-1]) == 1 ),
                        boundaries[i]))
               except IndexError:
                   pass
       return instances		

   >>> tokens, boundaries = preprocess(nltk.corpus.abc.sents())
   >>> data = get_instances(tokens, boundaries)
   >>> train = data[1000:]
   >>> test = data[:1000]
   >>> classifier = nltk.NaiveBayesClassifier.train(train)
   >>> nltk.classify.accuracy(classifier, test)
   0.9960

  
Counting
--------

Now that we've got our occurrences coded up, we want to look at how
often different combinations occur.

- we can look for both graded and categorical distictions

  - for categorical distinctions, we don't necessarily require that
    the counts be zero; every rule has its exception.

Example: what makes a name sound male or female?  Walk through it,
explain some features, do some counts using python.  

Exercises
---------

#. |hard| Suppose you wanted to automatically generate a prose description of a scene,
   and already had a word to uniquely describe each entity, such as `the jar`:lx:,
   and simply wanted to decide whether to use `in`:lx: or `on`:lx: in relating
   various items, e.g. `the book is in the cupboard`:lx: vs `the book is on the shelf`:lx:.

.. _prepositions:
.. ex::
   .. ex:: in the car *vs* on the train
   .. ex:: in town *vs* on campus
   .. ex:: in the picture *vs* on the screen
   .. ex:: in Macbeth *vs* on Letterman

   Explore this issue by looking at corpus data; writing programs as needed.


.. _sec-data-modeling:

-------------
Data Modeling
-------------

Exploratory data analysis helps us to understand the linguistic
patterns that occur in natural language corpora.  Once we have a basic
understanding of those patterns, we can attempt to create `models`:dt:
that capture those patterns.  Typically, these models will be
constructed automatically, using algorithms that attempt to select a
model that accurately describes an existing corpus; but it is also
possible to build analytically motivated models.  Either way, these
explicit models serve two important purposes: they help us to
understand the linguistic patterns, and they can be used to make
predictions about new language data.

The extent to which explicit models can give us insight into
linguistic patterns depends largely on what kind of model is used.
Some models, such as decision trees, are relatively transparent, and
give us direct information about which factors are important in making
decisions, and about which factors are related to one another.  Other
models, such as multi-level neural networks, are much more opaque --
although it can be possible to gain insight by studying them, it
typically takes a lot more work.

But all explicit models can make predictions about new "`unseen`:dt:"
language data that was not included in the corpus used to build the
model.  These predictions can be evaluated to assess the accuracy of
the model.  Once a model is deemed sufficiently accurate, it can then
be used to automatically predict information about unseen language
data.  These predictive models can be combined into systems that
perform many useful language processing tasks, such as document
classification, automatic translation, and question answering.

What do models tell us?
-----------------------

Before we delve into the mechanics of different models, it's important
to spend some time looking at exactly what automatically constructed
models can tell us about language.

One important consideration when dealing with language models is the
distinction between descriptive models and explanatory models.
Descriptive models capture patterns in the data but they don't
provide any information about *why* the data contains those patterns.
For example, as we saw in Table absolutely_, the synonyms
`absolutely`:lx: and `definitely`:lx: are not interchangeable:
we say `absolutely adore`:lx: not `definitely adore`:lx:,
and `definitely prefer`:lx: not `absolutely prefer`:lx:.
In contrast, explanatory models attempt
to capture properties and relationships that underlie the linguistic patterns.
For example, we might introduce the abstract concept of "polar adjective",
as one that has an extreme meaning, and categorize some adjectives
like `adore`:lx: and `detest`:lx: as polar.  Our explanatory model
would contain the constraint that `absolutely`:lx: can only combine with
polar adjectives, and `definitely`:lx: can only combine with non-polar adjectives.
In summary, descriptive models provide information about correlations
in the data, while explanatory models go further to postulate causal relationships.

Most models that are automatically constructed from a corpus are
descriptive models; in other words, they can tell us what features are
relevant to a given patterns or construction, but they can't
necessarily tell us how those features and patterns relate to one
another.  If our goal is to understand the linguistic patterns, then
we can use this information about which features are related as a
starting point for further experiments designed to tease apart the
relationships between features and patterns.  On the other hand, if
we're just interested in using the model to make predictions (e.g., as
part of a language processing system), then we can use the model to
make predictions about new data, without worrying about the precise
nature of the underlying causal relationships.

Supervised Classification
-------------------------

One of the most basic tasks in data modeling is `classification`:dt:.
In classification tasks, we wish to choose the correct `class
label`:dt: for a given input.  Each input is considered in isolation
from all other inputs, and set of labels is defined in advanced. [#]_
Some examples of classification tasks are:

.. [#] The basic classification task has a number of interesting
  variants: for example, in multi-class classification, each instance
  may be assigned multiple labels; in open-class classification, the
  set of labels is not defined in advance; and in sequence
  classification, a list of inputs are jointly classified.

.. better examples here:?

  - Classify an email as "spam" or "not spam."
  - Classify a news document as "sports," "technology," "politics," or "other."
  - Classify a name as "male" or "female."
  - Classify an occurrence of the word "bank" as "Noun-seaside,"
    "Noun-financial," "Verb-tilt," or "Verb-financial."

Classification models are typically trained using a corpus that
contains the correct label for each input.  This `training corpus`:dt:
is typically constructed by manually annotating each input with the
correct label, but for some tasks it is possible to automatically
construct training corpora.  Classification models that are built
based on training corpora that contain the correct label for each
input are called `supervised`:dt: classification models.

Feature Extraction
------------------

.. (include diagram: relationship between label, input, feature
   extractor, features, ML system, for training vs prediction)

The first step in creating a model is deciding what information about
the input might be relevant to the classification task; and how to
encode that information.  In other words, we must decide which
`features`:dt: of the input are relevant, and how to `encode`:dt:
those features.  Most automatic learning methods restirct features to
have simple value types, such as booleans, numbers, and strings.  But
note that just because a feature has a simple type, does not
necessarily mean that the feature's value is simple to expres or
compute; indeed, it is even possible to use very complex and
informative values, such as the output of a second supervised
classifier, as features.

.. _supervised-classification:

.. figure:: ../images/supervised-classification.png
   :scale: 50

   Supervised Classification.  (a) During training, a feature
   extractor is used to convert each input value to a feature set.
   Pairs of feature sets and labels are fed into the machine learning
   algorithm to generate a model.  (b) During prediction, the same
   feature extractor is used to convert unseen inputs to feature sets.
   These feature sets are then fed into the model, which generates
   predicted labels.
   
For NLTK's classifiers, the features for each input are stored using a
dictionary that maps feature names to corresponding values.  Feature
names are case-sensitive strings that typically provide a short
human-readable description of the feature.  Feature values are
simple-typed values, such as booleans, numbers, and strings.  For
example, if we had built an ``animal_classifier`` model for
classifying animals, then we might provide it with the following
feature set:

>>> animal = {'fur': True, 'legs': 4, 
...           'size': 'large', 'spots': True}
>>> animal_classifier.classify(animal)
'leopard'

Generally, feature sets are constructed from inputs using a `feature
extraction`:dt: function.  This function takes an input, and possibly
its context, as parameters, and returns a corresponding feature set.
This feature set can then be passed to the machine learning algorithm
for training, or to the learned model for prediction.  For example, we
might use the following function to extract features for a document
classification task:

.. pylisting:: feature_extractor

   def extract_features(word):
       features = {} 
       features["firstletter"] = word[0]
       for letter in 'abcdefghijklmnopqrstuvwxyz':
           features["cout(%s)" % letter] = word.lower().count(letter)
       return features

   >>> extract_features('underneath')
   {'firstletter': 'u', 'count(u)': 1, 'count(b)': 0, 'count(w)': 0,
    'count(l)': 0, 'count(q)': 0, 'count(n)': 2, 'count(s)': 0, ...}

In addition to a feature extractor, we need to select or build a
training corpus, consisting of a list of examples and corresponding
class labels.  For many interesting tasks, appropriate corpora have
already been assembled.  Given a feature extractor and a training
corpus, we can train a classifier.  First, we run the feature
extractor on each instance in the training corpus, and building a list
of (featureset, label) tuples.  Then, we pass this list to the
classifier's constructor:

.. XX THIS IS CURRENTLY NOT USING THE CONSTRUCTOR

>>> train = [(extract_features(word), label)
...          for (word, label) in labeled_words]
>>> classifier = nltk.NaiveBayesClassifier.train(train)

The constructed model ``classifier`` can then be used to predict the
labels for unseen inputs:

>>> test_featuresets = [extract_features(word)
...                     for word in unseen_labeled_words]
>>> predicted = classifier.batch_classify(test)

Selecting relevant features, and deciding how to encode them for the
learning method, can have an enormous impact on its ability to extract
a good model.  Much of the interesting work in modeling a phenomenon
is deciding what features might be relevant, and how we can represent
them.  Although it's often possible to get decent performance by using
a fairly simple and obvious set of features, there are usually
significant gains to be had by using carefully constructed features
based on an understanding of the task at hand.  

Typically, feature extractors are built through a process of
trial-and-error, guided by intuitions about what information is
relevant to the problem at hand.  It's often useful to start with a
"kitchen sink" approach, including all the features that you can think of,
and then checking to see which features actually appear to be helpful.
However, there are usually limits to the number of features that you
should use with a given learning algorithm -- if you provide too many
features, then the algorithm will have a higher chance of relying on
idiosyncracies of your training data that don't generalize well to new
examples.  This problem is known as `overfitting`:dt:, and can
especially problematic when working with small training sets.

Once a basic system is in place, a very productive method for refining
the feature set is `error analysis`:dt:.  First, the training corpus
is split into two pieces: a training subcorpus, and a `development`:dt:
subcorpus.  The model is trained on the training subcorpus, and then
run on the development subcorpus.  We can then examine individual cases in
the development subcorpus where the model predicted the wrong label, and
try to determine what additional pieces of information would allow it
to make the right decision (or which existing pieces of information
are tricking it into making the wrong decision).  The feature set can
then be adjusted accordingly, and the error analysis procedure can be
repeated, ideally using a different development/training split.

Example: Predicting Name Genders
++++++++++++++++++++++++++++++++

In section `Exploratory Data Analysis`_, we looked at some of the
factors that might influence whether an English name sounds more like
a male name or a female name.  Now we can build a simple model for
this classification task.  We'll use the same ``names`` corpus that we
used for exploratory data analysis, divided into a training set and an
evaluation set:

    >>> from nltk.corpus import names
    >>> import random
    >>>
    >>> # Construct a list of classified names, using the names corpus.
    >>> namelist = ([(name, 'male') for name in names.words('male')] + 
    ...             [(name, 'female') for name in names.words('female')])
    >>>
    >>> # Randomly split the names into a test & train set.
    >>> random.shuffle(namelist)
    >>> train = namelist[500:]
    >>> test = namelist[:500]

.. SB: NB I simplified the slice for testing in above example; was 5000:5500

Next, we'll build a simple feature extractor, using some of the
features that appeared to be useful in the exploratory data analysis.
We'll also throw in a number of features that seem like they might be
useful:

.. pylisting:: gender_features

   def gender_features(name):
       features = {} 
       features["firstletter"] = name[0].lower()
       features["lastletter"] = name[0].lower()
       for letter in 'abcdefghijklmnopqrstuvwxyz':
           features["count(%s)" % letter] = name.lower().count(letter)
           features["has(%s)" % letter] = (letter in name.lower())
       return features

    >>> gender_features('John')
    {'count(j)': 1, 'has(d)': False, 'count(b)': 0, ...}

Now that we have a corpus and a feature extractor, we can train a
classifier.  We'll use a "Naive Bayes" classifier, which will be
described in more detail in section `Naive Bayes Classifiers`_.

.. XX THIS IS CURRENTLY NOT USING THE CONSTRUCTOR

    >>> train_featuresets = [(gender_features(n), g) for (n,g) in train]
    >>> classifier = nltk.NaiveBayesClassifier.train(train_featuresets)

Now we can use the classifier to predict the gender for unseen names:

    >>> classifier.classify(gender_features('Blorgy'))
    'male'
    >>> classifier.classify(gender_features('Alaphina'))
    'female'

And using the test corpus, we can check the overall accuracy of the
classifier across a collection of unseen names with known labels:

    >>> test_featuresets = [(gender_features(n),g) for (n,g) in test]
    >>> print nltk.classify.accuracy(classifier, test_featuresets)
    0.688

Example: Predicting Sentiment
+++++++++++++++++++++++++++++

Movie review domain; ACL 2004 paper by Lillian Lee and Bo Pang.
Movie review corpus included with NLTK.

.. pylisting:: movie-reviews

   import nltk, random

   TEST_SIZE = 500

   def word_features(doc):
       words = nltk.corpus.movie_reviews.words(doc)
       return nltk.FreqDist(words), doc[0]

   def get_data():
       featuresets = apply(word_features, nltk.corpus.movie_reviews.files())
       random.shuffle(featuresets)
       return featuresets[TEST_SIZE:], featuresets[:TEST_SIZE]

   >>> train_featuresets, test_featuresets = get_data()
   >>> c1 = nltk.NaiveBayesClassifier.train(train_featuresets)
   >>> print nltk.classify.accuracy(c1, test_featuresets)
   0.774
   >>> c2 = nltk.DecisionTreeClassifier.train(train_featuresets)
   >>> print nltk.classify.accuracy(c2, test_featuresets)
   0.576
    


Initial work on a classifier to use frequency of modal verbs to classify
documents by genre:

.. pylisting:: modals

   import nltk, math
   modals = ['can', 'could', 'may', 'might', 'must', 'will']

   def modal_counts(tokens):
       return nltk.FreqDist(word for word in tokens if word in modals)

   # just the most frequent modal verb
   def modal_features1(tokens):
       return dict(most_frequent_modal = model_counts(tokens).max())

   # one feature per verb, set to True if the verb occurs more than once
   def modal_features2(tokens):
       fd = modal_counts(tokens)
       return dict( (word,(fd[word]>1)) for word in modals)

   # one feature per verb, with a small number of scalar values
   def modal_features3(tokens):
       fd = modal_counts(tokens)
       features = {}
       for word in modals:
           try:
               features[word] = int(-math.log10(float(fd[word])/len(tokens)))
           except OverflowError:
               features[word] = 1000
       return features

   # 4 bins per verb based on frequency
   def modal_features4(tokens):
       fd = modal_counts(tokens)
       features = {}
       for word in modals:
           freq = float(fd[word])/len(tokens)
           for logfreq in range(3,7):
               features["%s(%d)" % (word, logfreq)] = (freq < 10**(-logfreq))
       return features

   >>> genres = 'ermapd'
   >>> train = [(modal_features4(nltk.corpus.brown.words(g)[:2000]), g) for g in genres]
   >>> test = [(modal_features4(nltk.corpus.brown.words(g)[2000:4000]), g) for g in genres]
   >>> classifier = nltk.NaiveBayesClassifier.train(train)
   >>> print 'Accuracy: %6.4f' % nltk.classify.accuracy(classifier, test)


Exercises
---------

#. |easy|
   Exercise: compare the performance of different machine learning
   methods.  (they're still black boxes at this point)
   
#. |easy|
   The synonyms `strong`:lx: and `powerful`:lx: pattern
   differently (try combining them with `chip`:lx: and `sales`:lx:).

#. |soso|
   Accessing extra features from WordNet to augment those that appear
   directly in the text (e.g. hyperym of any monosemous word)

#. |hard|
   Task involving PP Attachment data; predict choice of preposition
   from the nouns.


.. _feature-extraction:

.. figure:: ../images/feature-extraction.png
   :scale: 25

   Feature Extraction


.. _classification:

.. figure:: ../images/classification.png
   :scale: 25

   Document Classification


----------
Evaluation
----------

(*There's some material for this in eng.txt*)

Before we go into detail about how various classification models work,
we'll take a look at how we can decide whether they're doing what we
want.

There's several ways to measure how well a system does, and each has
its pluses and minuses.

Evaluation Set
--------------

Don't test on train!!!!   (Explain why, etc)  includes heldout(aka development)!

Which data should be used?  (eg random sampling vs single chunk)

.. SB: test vs train vs devtest

Accuracy
--------

- Simplest metric: accuracy.  Describe what it is, where it can be
  limited in usefulness.

.. SB: examples of meaningless accuracy scores, when irrelevant material
       is included; e.g. let X be the event that a document is on a particular
       topic; the presence of a large number of irrelevant documents can
       falsely exaggerate the accuracy score.  Even a majority class classifier
       that scores every document as irrelevant will get a high accuracy score.

Precision and Recall
--------------------

.. _precision-recall:

.. figure:: ../images/precision-recall.png
   :scale: 25

   True and False Positives and Negatives

Consider Figure precision-recall_.
The intersection of these sets defines four regions: the true
positives (TP), true negatives (TN), false positives (FP) or Type I errors, and false
negatives (FN) or Type II errors.  Two standard measures are
*precision*, the fraction of guessed chunks that were correct TP/(TP+FP),
and *recall*, the fraction of correct chunks that were identified
TP/(TP+FN).  A third measure, the *F measure*, is the harmonic mean
of precision and recall, i.e. 1/(0.5/Precision + 0.5/Recall).

Cross-Validation
----------------

To do evaluation, we need to keep some of the data back -- don't test
on train.  But that means we have less data available to train.  Also,
what if our training set has ideosyncracies?

Cross-validation: run training&testing multiple times, with different
training sets.

  - Lets us get away with smaller training sets
  - Lets us get a feel for how much the performance varies based on
    different training sets.

Error Analysis
--------------

The metrics above give us a general feel for how well a system does,
but doesn't tell us much about why it gets that performance .. are
there patterns in what it gets wrong?  If so, that can help us to
improve the system, or if we can't improve it, then at least make us
more aware of what the limitations of the system are, and what kind of
data it will produce more reliable or less reliable results for.

Talk some about how to do error analysis?

----------------------
Classification Methods
----------------------

In this section, we'll take a closer took at three machine learning
methods that can be used to automatically build classification models:
Decision Trees, Naive Bayes classifiers, and Maximum Entropy
classifiers.  As we've seen, it's possible treat these learning
methods as black boxes, simply training models and using them for
prediction without understanding how they work.  But there's a lot to be learned
from taking a closer look at how these learning methods select models
based on the data in a training corpus.  An understanding of these
methods can help guide our selection of appropriate features, and
especially our decisions about how those features should be encoded.
And an understanding of the generated models can allow us to extract
useful information about which features are most informative, and how
those features relate to one another.

Decision Trees
--------------

A `decision tree`:dt: is a tree-structured classification model whose
branches contain conditions on features, and whose leaves contain
labels.  Given an input value's feature set, the decision tree picks a
label by walking down the tree, starting from the root node, and
following the path selected by the feature conditions at each node.
Once a leaf is reached, that leaf's label is assigned to the input.
Figure decision-tree_ shows an example decision tree model for the
name gender task.

.. _decision-tree:

.. figure:: ../images/decision-tree.png
   :scale: 50

   Decision Tree model for the name gender task.

Before we look at the learning algorithm for decision trees, we'll
consider a simpler task: picking the best "decision stump" for a
corpus.  A `decision stump`:dt: is is a decision tree with a single
node, that decides how to classify inputs based on a single feature.
It contains one leaf for each possible feature value, specifying the
class label that should be assigned to inputs whose features have that
value.  The hardest part of selecting the best decision stump is
deciding which feature should be used.  The simplest method is to just
build a feature stump for each possible feature, and see which one
achieves the highest accuracy on the training data; but we'll discuss
some other alternatives below.  Once we've picked a feature, we can
build the decision stump by assigning a label to each leaf based on
the most frequent label for the selected examples in the training
corpus (i.e., the examples where the selected feature has that value).

Given the algorithm for choosing decision stumps, the algorithm for
growing larger decision trees is straightforward.  We
begin by selecting the overall best decision stump for the corpus.  We
then check the accuracy of each of the leaves on the training corpus.
Any leaves that do not achieve sufficiently good accuracy are then
replaced by new decision stumps, trained on the subset of the training
corpus that is selected by the path to the leaf.  For example, we
could grow the decision tree in Figure decision-tree_ by replacing the
leftmost leaf with a new decision stump, trained on the subset of the
training corpus names that do not start with a "k" or end with a vowel
or an "l."

As we mentioned before, there are a number of methods that can be used
to select the most informative feature for a decision stump.  One
popular alternative is entropy.  <<talk about entropy>>.

Another consideration for decision trees is efficiency.  The simple
algorithm for selecting decision stumps described above must construct
a candidate decision stump for every possible feature; and this
process must be repeated for every node in the constructed decision
tree.  A number of algorithms have been developed to cut down on the
training time by storing and reusing information about previously
evaluated examples.  <<references>>.

Decision trees have a number of useful qualities.  To begin with,
they're simple to understand, and easy to interpret.  This is
especially true near the top of the decision tree, where it is usually
possible for the learning algorithm to find very useful features.
Decision trees are especially well suited to cases where many
hierarchical categorical distinctions can be made.  For example,
decision trees can be very effective at modelling phylogeny trees.

However, decision trees also have a few disadvantages.  One problem is
that decision trees tend to encode ..

Perhaps one of
the most important is that decision trees ...

- ends with o vs ends with a: trees get duplicated, data gets split.
- document classification: lots of features that are individually not
  very informative.  (combining)  can't combine -- given an input, we
  check a few features, and then ignore all the rest.

Naive Bayes Classifiers
-----------------------

- segway: one limitation of DTs is that they can't combine info from
  multiple features.  the next learning method we'll look at, naive
  bayes, is able to combine info.
  
- Each feature has a say.
- Features can "combine" their effect
- What a feature has to say:
  "How likely am I, given a label?"
- Pick whichever label has the most support.

Classifying an input: E.g., the word "line"

1. Draw a bar graph showing how often each sense occurs in the
   training corpus.
2. Look at each input feature, and decide how likely it is given each
   label. Decrease each label's bar by a corresponding amount.  

Alternative visualization:
- Start with a point that's "between" the labels.
- Each feature "pushes" the point
- Which label does it end up closest to?

Math -- give the equations.

- Every feature has an effect.

  - At the same time!
  
- A feature's effect is calculated by looking at the likelihood of a
  feature, given a label.  (Just count how often a feature occurs in
  the training data with each label.)

Smoothing: zero counts can be a problem.

  - Do we really want to say that something has 0 probability, just
    because we haven't seen it in the training corpus?
  - If not, then what prob should it have?
  - Explain basic smoothing, but don't necessarily go into great
    detail.
  
Why is Naive Bayes "naive"?

- It assumes that each feature is "independent"
- Which is almost never true!
- Why is this a problem?

  - If we include two features that are tightly correlated, then the
    same piece of information gets counted twice!

Maximum Entropy Classifiers
---------------------------
- Why do we get "double counting"?
- When we decide what effect a feature should have, we only look at
  that one feature.
- During training, features are computed separately.
- During prediction, features are combined.
- What can we do about it?
  - Consider feature interactions during training.
  
  .. SB: explain maximum entropy principle: least biased pdist consistent with knowledge


- MaxEnt Model is almost identical to Naive Bayes
  (though it might not be immediately clear why if you look at the math.)
- Main difference is in training.
- When deciding what effect features should have, consider all features.

- A feature's effects are determined by that feature's parameters (or
  weights).

- Training:

  - Choose the feature parameters that would give us the highest score
    if we were testing on our training set.
  - I.e., maximize the likelihood of the training data.

Math.

-------------------------------------------
Sequence Classification & Language Modeling
-------------------------------------------

would go here.  This includes HMMs.

* smoothing, unseen data

(*There's some material for this in eng.txt*)

---------------------
Information Retrieval
---------------------

---------------------
Unsupervised Learning
---------------------

- Even when there's no labeled training data, we can still use
  automatic methods to learn about the data.
- What patterns tend to occur?
- How do those patterns relate to one another?


Example: Punkt sentence tokenizer.

- Dividing a paragraph into sentences is hard. (western languages)
- Mainly because we can't tell if "." is used as part of an
  abbreviation or not.
- Punkt uses unsupervised methods to find common abbreviations.
- If "xyz" is almost always followed by "." then it's probably an
  abbreviation.
  
  .. SB: evaluating segmentations, and windowdiff (if deleted from this chapter should go back in data chapter)

It can be useful to know whether two words are "similar."

- Search: don't just find the exact terms you specify.
- Question Answering: handle synonyms.
- Parsing: what words act similarly to one another?

Different notions of "similarity":

- What words tend to co-occur?
- What words occur in similar contexts?

Document clustering:

- vocabulary (ignore words other than the n most frequent and m least frequent; or use tf.idf)
- document vectors
- WordNet
- news collection?  unsupervised topic detection?


----------------------------
Machine Learning in Python..
----------------------------

- For machine learning, it can be very convenient to do feature
  extraction in Python.
- Python has excellent text processing facilities
- NLTK should make your job easier.
- But when you actually build the model, you may want to use something
  written in C or Java.
- Python does not perform numerically intensive calculations very
  quickly.
- NLTK can interface w/ external ML systems.

.. SB: I think numpy and other numerical libraries do their work in C, and
       are probably quite efficient.  Not clear about support for sparse arrays.
       
.. SB: brief overview of machine learning methods that help cope with existence
       of small amounts of labeled data and larger amounts of unlabeled data.
       
------------
Data Sources
------------

Publishers: LDC, ELRA

Annual competitions: CoNLL, TREC, CLEF


-----------
Conclusions
-----------

how it all fits together..

-------
Summary
-------

---------------
Further Reading
---------------

  - choosing prepositions http://itre.cis.upenn.edu/~myl/languagelog/archives/002003.html

  - Jurafsky and Martin, Manning and Schutze chapters




.. include:: footer.rst


..   *** Old material ***
..   ------------
..   Introduction
..   ------------
..   
..   * grammar engineering, connection to Part II, test suites, regression testing
..   
..   ----------
..   Evaluation
..   ----------
..   
..   * basic tasks of segmentation and labeling
..   * accuracy: why it is not enough for a labeling task
..   
..   Precision and Recall
..   --------------------
..   
..   .. _precision-recall:
..   
..   .. figure:: ../images/precision-recall.png
..      :scale: 70
..   
..      True and False Positives and Negatives
..   
..   Consider Figure precision-recall_.
..   The intersection of these sets defines four regions: the true
..   positives (TP), true negatives (TN), false positives (FP), and false
..   negatives (FN).  Two standard measures are
..   *precision*, the fraction of guessed chunks that were correct TP/(TP+FP),
..   and *recall*, the fraction of correct chunks that were identified
..   TP/(TP+FN).  A third measure, the *F measure*, is the harmonic mean
..   of precision and recall, i.e. 1/(0.5/Precision + 0.5/Recall).
..   
..   Windowdiff: Evaluating Segmentations
..   ------------------------------------
..   
..   .. _windowdiff:
..   .. figure:: ../images/windowdiff.png
..      :scale: 30
..   
..      A Reference Segmentation and Two Hypothetical Segmentations
..   
..   A different method must be used for comparing segmentations.  In Figure windowdiff_ we see two
..   possible segmentations of a sequence of items (e.g. tokenization, chunking, sentence segmentation),
..   which might have been produced by two programs or annotators.  If we naively score S\ :subscript:`1` and
..   S\ :subscript:`2` for their alignment with the reference segmentation, both will score 0 as neither
..   got the correct alignment.  However, S\ :subscript:`1` is clearly better than S\ :subscript:`2`,
..   and so we need a corresponding measure, such as `Windowdiff`:dt:.  Windowdiff is a simple
..   algorithm for evaluating the quality of a segmentation, by running a sliding window over the
..   data and awarding partial credit for near misses.  The following code illustrates the algorithm
..   running on the segmentations from Figure windowdiff_ using a window size of 3:
..   
..       >>> ref = "00000001000000010000000"
..       >>> s1  = "00000010000000001000000"
..       >>> s2  = "00010000000000000001000"
..       >>> nltk.windowdiff(ref,ref,3)
..       0
..       >>> nltk.windowdiff(ref,s1,3)
..       4
..       >>> nltk.windowdiff(ref,s2,3)
..       16
..   
..   
..   -----------------
..   Language Modeling
..   -----------------
..   
..   * smoothing, estimation [EL]
..   
..   ----------------
..   Machine Learning
..   ----------------
..   
..   * feature selection, feature extraction
..   * text classification (question classification, language id, naive bayes etc)
..   * sequence classification (HMM, TBL)
..   * unsupervised learning (clusterers) 
..   
.. 
.. end of file
