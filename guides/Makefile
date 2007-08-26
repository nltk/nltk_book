# NLTK: Doctest Makefile
#
# Copyright (C) 2001-2007 University of Pennsylvania
# Author: Edward Loper <edloper@gradient.cis.upenn.edu>
#         Steven Bird <sb@csse.unimelb.edu.au>
# URL: <http://nltk.sf.net>
# For license information, see LICENSE.TXT

# File locations:
DOCTEST_SRC = ../../nltk/test
DOCTESTS = $(wildcard $(DOCTEST_SRC)/*.doctest)
PYSRC = $(shell find ../../nltk -name '*.py')
HTML = $(DOCTESTS:$(DOCTEST_SRC)/%.doctest=%.html)
ERRS = $(DOCTESTS:$(DOCTEST_SRC)/%.doctest=%.errs)

# Converting rst->html:
RST = ../rst.py
RST2HTML = $(RST) --html --css ../nltkdoc.css

# Testing:
DOCTEST = python ../../nltk/test/doctest_driver.py
DOCTEST_FLAGS = --udiff

# Uploading to sourceforge:
WEB = $(USER)@shell.sourceforge.net:/home/groups/n/nl/nltk/htdocs
RSYNC_OPTS = -rltgoDvz -e ssh --relative --cvs-exclude

.PHONY: all html

all: html errs index.html
html: $(HTML)
errs: $(ERRS)
	@echo Failed doctests:
	@grep 'FAILED (failures' *.errs |sed 's/\(.*\)\.errs:.*/  - \1/'

%.errs: $(DOCTEST_SRC)/%.doctest $(PYSRC)
	$(DOCTEST) $(DOCTEST_FLAGS) $(DOCTEST_SRC)/$*.doctest > $*.errs 2>&1

%.html: $(DOCTEST_SRC)/%.doctest
	$(RST2HTML) $< -o $@

index.html: index.txt test-list.txt
	$(RST2HTML) index.txt

test-list.txt: update_list.py $(ERRS)
	python update_list.py

rsync: html errs index.html
	rsync $(RSYNC_OPTS) . $(WEB)/doc/guides/

clean:
	rm *.errs *.html

clean_up:
	true # nothing to do.
