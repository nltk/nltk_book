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
REPORT = probability

##############################################
##  You shouldn't have to change anything below here.

DOCBOOK = $(REPORT).xml
HTML = html
INDEX = $(HTML)/index.html

all: html
html: $(INDEX)

$(INDEX): $(DOCBOOK)
	db2html -multipage $(DOCBOOK) $(HTML)


