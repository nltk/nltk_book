# Natural Language Toolkit: Tutorial Documentation Makefile
#
# Copyright (C) 2001 University of Pennsylvania
# Author: Edward Loper <edloper@gradient.cis.upenn.edu>
# URL: <http://nltk.sf.net>
# For license information, see LICENSE.TXT
#
# $Id$

##############################################
##  A list of all the technical reports
REPORTS = probability introduction advpython tagging \
	writing_classes parsing chunking classifying

##############################################
##  You shouldn't have to change anything below here.

DVI := $(REPORTS:=.dvi)
PS := $(REPORTS:=.ps)
PDF := $(REPORTS:=.pdf)
CLEAN := $(REPORTS:=.clean)
HTML := $(REPORTS:=.html)
ALL := $(REPORTS:=.all)

all: $(ALL)
dvi: $(DVI)
ps: $(PS)
pdf: $(PDF)
clean: $(CLEAN)
html: $(HTML)

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
