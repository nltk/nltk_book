# Natural Language Toolkit: Tutorial report Makefile
#
# Copyright (C) 2001 University of Pennsylvania
# Author: Edward Loper <edloper@gradient.cis.upenn.edu>
# URL: <http://nltk.sf.net>
# For license information, see LICENSE.TXT
#
# $Id$

##############################################
##  The name of the report (without the .xml extension)
REPORT = probability

##############################################
##  The name of the html index file.  If the main element
##  has an id, then it's based on that; otherwise, it's t1.html
##  for articles, and book1.html for books.
HTMLINDEX = t1.html

##############################################
##  Programs and DSSSLs; change these if necessary.

JADE = jade
PDFJADETEX = pdfjadetex
PERL = perl

# We keep these in the repository, so you shouldn't need to change
# them.
COLLATEINDEX = ../../docbook/collateindex.pl
XML_DECL = ../../docbook/xml.dcl
HTML_DSSSL = ../../docbook/docbook-utils.dsl\#html
PRINT_DSSSL = ../../docbook/docbook-utils.dsl\#print
DOCBOOK_CATALOG = ../../docbook/catalog

##############################################
##  You shouldn't have to change anything below here.

# Input file
DOCBOOK = $(REPORT).xml

# Output directory
HTMLDIR = $(REPORT)

# Output files.
HTMLNOCHUNKS = $(HTMLDIR)/nochunks.html
HTMLCHUNKS = $(HTMLDIR)/$(HTMLINDEX)
PDF = $(REPORT).pdf
TEX = $(REPORT).tex

# Intermediate files.
LOG = $(REPORT).log
AUX = $(REPORT).aux
TEMP = $(REPORT).temp
OUT = $(REPORT).out

# Keep track of whether we've created the HTML directory.
HTMLDIR_EXISTS = $(HTMLDIR)/.exists

# Notes on the makefile:
#
# Unfortunately, (open)jade doesn't let us specify an output directory
# for the html stylesheets; so we have to do some acrobatics: change
# directory into the desired directory; then use ../ to fix up the
# relative paths.
#
# I also use '||' do clean up in some places.  "A||B" means "do A; and
# if that fails, then do B.  This is important, e.g., to keep
# index.xml from thinking that it succeeded if only the first call to
# collateindex succeeded.
#
# I use $(HTMLDIR_EXISTS) to make sure that the html directory gets
# built at the appopriate times.  Before, I had things just depend on
# $(HTMLDIR), and $(HTMLDIR) would run mkdir; but apparently writing
# files changes the mod-time on $(HTMLDIR), so make thinks that it needs
# to re-make $(HTMLDIR) (and therefore needs to remake everything that
# depends on it)


all: index.xml html pdf
html: $(HTMLCHUNKS) $(HTMLNOCHUNKS)
pdf: $(PDF)

index.xml: $(DOCBOOK) $(HTMLDIR_EXISTS)
	$(PERL) $(COLLATEINDEX) -o index.xml -N
	(cd $(HTMLDIR) && \
	 $(JADE) -t sgml -i html -d ../$(HTML_DSSSL) -V html-index \
	      -c ../$(DOCBOOK_CATALOG) \
	      ../$(XML_DECL) ../$(DOCBOOK)) || (rm index.xml;false)
	$(PERL) $(COLLATEINDEX) -o index.xml $(HTMLDIR)/HTML.index
	rm $(HTMLDIR)/HTML.index

$(HTMLDIR_EXISTS):
	mkdir $(HTMLDIR) 2>/dev/null || true
	touch $(HTMLDIR_EXISTS)

$(HTMLCHUNKS): index.xml $(HTMLDIR_EXISTS)
	(cd $(HTMLDIR) && \
	 $(JADE) -t sgml -i html -d ../$(HTML_DSSSL) \
	      -c ../$(DOCBOOK_CATALOG) \
	      ../$(XML_DECL) ../$(DOCBOOK))

$(HTMLNOCHUNKS): $(DOCBOOK) index.xml
	$(JADE) -t sgml -i html -d $(HTML_DSSSL) -V nochunks \
	     -c $(DOCBOOK_CATALOG) \
	     $(XML_DECL) $(DOCBOOK) \
	     > $(HTMLNOCHUNKS)

$(PDF): $(DOCBOOK) index.xml
	$(JADE) -t tex -o $(TEX) -i print -d $(PRINT_DSSSL) \
	     -c $(DOCBOOK_CATALOG) \
	     $(XML_DECL) $(DOCBOOK)
	$(PDFJADETEX) $(TEX) > $(TEMP) || \
	        (cat $(TEMP); rm $(TEMP); false)
	rm $(TEMP)
	$(PDFJADETEX) $(TEX) >/dev/null
	$(PDFJADETEX) $(TEX) >/dev/null
	rm $(LOG) $(AUX) $(TEX) $(OUT)

clean:
	rm -rf $(HTMLDIR)
	rm -f $(PDF) index.xml $(LOG) $(TEX) $(AUX) $(TEMP) $(OUT)

usage: help
help:
	@echo "Usage:"
	@echo "     make [all | html | pdf | clean]"

