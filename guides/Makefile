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
COVERAGE = $(DOCTESTS:$(DOCTEST_SRC)/%.doctest=%.coverage)

# Converting rst->html:
RST = ../rst.py
RST2HTML = $(RST) --html --css ../nltkdoc.css

# Testing:
PYTHON = python
DOCTEST = $(PYTHON) ../../nltk/test/doctest_driver.py
DOCTEST_FLAGS = --udiff

# Uploading to sourceforge:
WEB = $(USER)@shell.sourceforge.net:/home/groups/n/nl/nltk/htdocs
RSYNC_OPTS = -rltgoDvz -e ssh --relative --cvs-exclude

.PHONY: all html coverage

all: html errs coverage index.html
html: $(HTML)
errs: $(ERRS)
	@echo Failed doctests:
	@grep 'FAILED (failures' *.errs |sed 's/\(.*\)\.errs:.*/  - \1/'
coverage: coverage/index.html

coverage/index.html: coverage-list.txt coverage.txt
	$(RST2HTML) coverage.txt -o $@

coverage-list.txt: $(COVERAGE) ./show_coverage.py
	python ./show_coverage.py $(COVERAGE)

%.coverage: %.errs
	@true
%.errs: $(DOCTEST_SRC)/%.doctest $(PYSRC)
	$(DOCTEST) $(DOCTEST_FLAGS) $(DOCTEST_SRC)/$*.doctest \
		--coverage=$*.coverage > $*.errs 2>&1

%.html: $(DOCTEST_SRC)/%.doctest
	$(RST2HTML) $< -o $@

$(DOCTEST_SRC)/%.doctest: $(DOCTEST_SRC)/%.doctest_latin1
	iconv -f iso8859-1 -t utf8 $< > $@

index.html: index.txt test-list.txt
	$(RST2HTML) index.txt

test-list.txt: update_list.py $(ERRS)
	python update_list.py

rsync: html errs coverage index.html
	rsync $(RSYNC_OPTS) . $(WEB)/doc/guides/

clean:
	rm *.errs *.html

clean_up:
	true # nothing to do.
