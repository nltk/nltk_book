.. -*- mode: rst -*-
.. include:: ../definitions.rst

.. _app-issue:

=====================================
Appendix: Known Issues with this Book
=====================================

--------------
General Issues
--------------

* use NLTK version 0.9.7

* The further reading sections of each chapter are patchy; some are comprehensive while
  some are minimal.  We intend to make these consistent, providing a representative
  set of pointers to other materials.

* It is difficult for readers to know which exercises at the end of the chapter
  correspond to which sections of the chapter.

* NLTK provides a sophisticated framework for working with corpora; perhaps there
  should be an appendix which explains how this works and how to write new
  corpus readers.

* The phrase that appears as the book's subtitle is actually
  intended to appear as the by-line on the top of the front cover,
  following the pattern of other books in the Animal Series.

-------------------------------------
Chapter-Specific Issues and Questions
-------------------------------------

* Chapter 2: the learning curve of Chapter 1 was quite shallow, but it gets much
  steeper in this chapter; is there a way to make it easier for new programmers?

* Chapter 6: the structure of this chapter is still in flux; suggestions for
  improving the structure and prioritizing the content welcomed

* Chapter 7: we are hoping to get some English named-entity data so that we
  can illustrate how to train a named entity classifier

* Chapter 8: the final section on scaling up grammars is incomplete

* Chapter 9: the opening has not been updated to follow the model of the
  other chapters, identifying questions that are answered in this chapter 

* Chapter 10: we don't have permission to use the photograph

* Chapter 12: the last two sections planned for this chapter (NLTK Roadmap,
  NLP-Complete Problems) have not been written yet

* References: we haven't worked out how to convert the references from BibTeX into Docbook.
  The HTML version is at ``http://nltk.googlecode.com/svn/trunk/doc/en/bibliography.html`` and
  the BibTeX source is at ``http://nltk.googlecode.com/svn/trunk/nltk/doc/refs.bib``

-----------------------------
Formatting / Rendering Issues
-----------------------------

Urgent
------

* It would also be good to fix the `np`:gc: issue before going out
  for review.

Longer term
-----------

* The diagrams of the book need to be set in grayscale and high-resolution, for the
  hardcopy version.

* Definition lists
  (<http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#definition-lists>)
  are coming out with the definition term being treated as a variable
  term in Docbook, and therefore being rendered in fixed-width font.

 
