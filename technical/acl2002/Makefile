# Natural Language Toolkit: Technical report Makefile
#
# Copyright (C) 2001 University of Pennsylvania
# Author: Edward Loper <edloper@gradient.cis.upenn.edu>
# URL: <http://nltk.sf.net>
# For license information, see LICENSE.TXT
#
# $Id$

##############################################
##  The name of the report
REPORT = acl02

# We're using bibtex:
$(REPORT).dvi: $(REPORT).bbl
BIBFILE = nltk.bib

##############################################
##  Figure dependancies


##############################################
##  You shouldn't have to change anything below here.

# Find the name of the dvi and ps files.
DVI := $(REPORT).dvi
PS := $(REPORT).ps
PDF := $(REPORT).pdf

# Top-level rules.
dvi: $(DVI)
ps: $(PS)
pdf: $(PDF)
clean:
	rm -f *.log *.aux *.dvi *.ps *.toc *.pdf *.bbl *.blg

%.bbl: %.tex $(BIBFILE)
	latex $*.tex || (rm -f $*.dvi && false)
	bibtex $* || (rm -f $*.dvi $@ && false)

%.dvi: %.tex
	latex $*.tex || (rm -f $@ && false)
	latex $*.tex || (rm -f $@ && false)

%.ps: %.dvi
	dvips -t letter -o $@ $<

%.eps: %.dot
	dot -Tps -o $@ $<

%.eps: %.obj
	tgif -print -eps $<

%.pdf: %.ps
	ps2pdf $< $@
