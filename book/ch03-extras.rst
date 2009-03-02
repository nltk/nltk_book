.. -*- mode: rst -*-
.. include:: ../definitions.rst
.. include:: regexp-defns.rst

.. standard global imports

    >>> import nltk, re, pprint

===============================
3. Processing Raw Text (Extras)
===============================


#. The above example of extracting (name, domain) pairs from
   text does not work when there is more than one email address
   on a line, because the ``+`` operator is "greedy" and consumes
   too much of the input.

   a) Experiment with input text containing more than one email address
      per line, such as that shown below.  What happens?
   #) Using ``re.findall()``, write another regular expression
      to extract email addresses, replacing the period character
      with a range or negated range, such as ``[a-z]+`` or ``[^ >]+``.
   #) Now try to match email addresses by changing the regular
      expression ``.+`` to its "non-greedy" counterpart, ``.+?``

   >>> s = """
   ... austen-emma.txt:hart@vmd.cso.uiuc.edu  (internet)  hart@uiucvmd (bitnet)
   ... austen-emma.txt:Internet (72600.2026@compuserve.com); TEL: (212-254-5093)
   ... austen-persuasion.txt:Editing by Martin Ward (Martin.Ward@uk.ac.durham)
   ... blake-songs.txt:Prepared by David Price, email ccx074@coventry.ac.uk
   ... """
