# Natural Language Toolkit: Tutorial Documentation Makefile
#
# Copyright (C) 2001 University of Pennsylvania
# Author: Edward Loper <edloper@gradient.cis.upenn.edu>
# URL: <http://nltk.sf.net>
# For license information, see LICENSE.TXT
#
# $Id$

##############################################
##  Automatically find tutorial reports.
REPORTS = $(dir $(wildcard */*.info))

##############################################
##  Tutorial index creation

TUTORIAL_INDEX.xml = tutorial_index.xml
TUTORIAL_INDEX.html = tutorial_index.html

COMBINE_INDICES = ../docbook/combine_indices.py

PYTHON = python
JADE = jade
XML_DECL = ../docbook/xml.dcl
DOCBOOK_DSSSL = ../docbook/docbook-utils.dsl
HTML_DSSSL = $(DOCBOOK_DSSSL)\#html
DOCBOOK_CATALOG = ../docbook/catalog

##############################################
##  You shouldn't have to change anything below here.

DVI := $(REPORTS:/=.dvi)
PS := $(REPORTS:/=.ps)
PDF := $(REPORTS:/=.pdf)
CLEAN := $(REPORTS:/=.clean)
HTML := $(REPORTS:/=.html)
ALL := $(REPORTS:/=.all)
INDEX := $(REPORTS:=index.xml)

help: usage
usage:
	@echo "Usage:"
	@echo "    make all         -- Build HTML & PDF output"
	@echo "    make html        -- Build HTML output"
	@echo "    make pdf         -- Build PDF output"
	@echo "    make clean       -- Remove all built files"

all: $(ALL) $(TUTORIAL_INDEX.html)
dvi: $(DVI)
ps: $(PS)
pdf: $(PDF)
clean: $(CLEAN)
html: $(HTML) $(TUTORIAL_INDEX.html)
index: $(INDEX) $(TUTORIAL_INDEX.html)

%.all: %
	$(MAKE) -C $< all

%.pdf: %
	$(MAKE) -C $< pdf

%.ps: %
	$(MAKE) -C $< ps

%.dvi: %
	$(MAKE) -C $< dvi

%.clean: %
	$(MAKE) -C $< clean

%.html: %
	$(MAKE) -C $< html

%/index.xml: %
	$(MAKE) -C $< index.xml

# Build a docbook document containing a unified index 
$(TUTORIAL_INDEX.xml): $(COMBINE_INDICES)
	$(PYTHON) $(COMBINE_INDICES) $(INDEX) $(TUTORIAL_INDEX.xml)

# Compile the unified index to HTML
$(TUTORIAL_INDEX.html): $(TUTORIAL_INDEX.xml) $(DOCBOOK_DSSSL)
	$(JADE) -t sgml -i html -d $(HTML_DSSSL) -V nochunks \
	     -c $(DOCBOOK_CATALOG) \
	     $(XML_DECL) $(TUTORIAL_INDEX.xml) \
	     > $(TUTORIAL_INDEX.html)
