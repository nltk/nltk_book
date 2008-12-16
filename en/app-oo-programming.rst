.. -*- mode: rst -*-
.. include:: ../definitions.rst

.. _app-oo-programming:

=======================================================
Appendix: Object-Oriented Programming in Python (DRAFT)
=======================================================

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

Duck Typing
-----------

[to be written]


.. include:: footer.rst
