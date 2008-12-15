.. -*- mode: rst -*-
.. include:: ../definitions.rst

.. _app-issue:

=====================================
Appendix: Known Issues with this Book
=====================================

--------------
General Issues
--------------

* The further reading sections of each chapter are patchy; some are comprehensive while
  some are minimal.  We intend to make these consistent, providing a representative
  set of pointers to other materials.  The pointers to NLTK's "guides" are stale; we're
  in the process of updating these to create a suite of HOWTOs.

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

* ch02: the learning curve of ch01 was quite shallow, but it gets much
  steeper in ch02; is there a way to make it easier for new programmers?

* ch06: the structure of this chapter is still in flux; suggestions for
  improving the structure and prioritizing the content welcomed

* ch07: we are hoping to get some English named-entity data so that we
  can illustrate how to train a named entity classifier

* ch10: we don't have permission to use this photograph

* ch12: the final chapter is incomplete; it will consist of free-standing
  sections on further topics, giving readers a sense of the breadth of
  the field and the interesting challenges still faced

* References: we don't know how to convert these to docbook.
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

 
