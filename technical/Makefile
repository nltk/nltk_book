# Natural Language Toolkit: Main technical report Makefile
#
# Copyright (C) 2001 University of Pennsylvania
# Author: Edward Loper <edloper@gradient.cis.upenn.edu>
# URL: <http://nltk.sf.net>
# For license information, see LICENSE.TXT
#
# $Id$

##############################################
##  Automatically find technical reports.
REPORTS = $(dir $(wildcard */*.info))

##############################################
##  You shouldn't have to change anything below here.

DVI := $(REPORTS:=.dvi)
PS := $(REPORTS:=.ps)
PDF := $(REPORTS:=.pdf)
CLEAN := $(REPORTS:=.clean)
HTML := $(REPORTS:=.html)

all: pdf
dvi: $(DVI)
ps: $(PS)
pdf: $(PDF)
clean: $(CLEAN)
html: $(HTML)

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
