# Natural Language Toolkit: Tutorial report Makefile
#
# Copyright (C) 2001 University of Pennsylvania
# Author: Edward Loper <edloper@gradient.cis.upenn.edu>
# URL: <http://nltk.sf.net>
# For license information, see LICENSE.TXT
#
# $Id$

##############################################
##  The name of the report
REPORT = writing_classes

##############################################
##  You shouldn't have to change anything below here.

DOCBOOK = $(REPORT).xml
HTMLDIR = $(REPORT)
INDEX = $(HTMLDIR)/t1.html
HTMLNOCHUNKS = $(HTMLDIR)/nochunks.html
PDF = $(REPORT).pdf

all: html pdf
html: $(INDEX) $(HTMLNOCHUNKS)
pdf: $(PDF)

$(HTMLDIR):
	mkdir $(HTMLDIR) 2>/dev/null || true

$(INDEX): $(DOCBOOK) $(HTMLDIR)
	jw -f docbook -b html -o $(HTMLDIR) $(DOCBOOK)

$(HTMLNOCHUNKS): $(DOCBOOK) $(HTMLDIR)
	jw -f docbook -b html -u $(DOCBOOK) >$(HTMLNOCHUNKS)

$(PDF): $(DOCBOOK)
	jw -f docbook -b pdf $(DOCBOOK)

clean:
	rm -rf $(HTMLDIR) $(PDF)
