# NLTK-LITE: Presentation Slides Makefile
#
# Copyright (C) 2001-2006 University of Pennsylvania
# Author: Steven Bird <sb@csse.unimelb.edu.au>
#         Edward Loper <edloper@gradient.cis.upenn.edu>
# URL: <http://nltk.sf.net>
# For license information, see LICENSE.TXT

WEB = stevenbird@shell.sourceforge.net:/home/groups/n/nl/nltk/htdocs/lite

TEX = introduction.tex programming.tex tag.tex chunk.tex data.tex
PDF := $(TEX:.tex=.pdf)

RST2HTML = ../rst.py --html

RSYNC_OPTS = -arvz -e ssh --relative --cvs-exclude

.SUFFIXES: .txt .html .tex .pdf

.PHONY: all clean

all: $(PDF) index.html

clean:	clean_up
	rm -f $(PDF) index.html

clean_up:
	rm -f *.log *.aux *.snm *.vrb index*.html

index.html:	index.txt
	$(RST2HTML) index.txt > index.html

.tex.pdf:
	pdflatex $<
	pdflatex $<
	mkdir -p handouts
	sed 's/documentclass/documentclass[handout]/' < $< > handouts/$<
	pdflatex -output-directory handouts handouts/$<
	pdflatex -output-directory handouts handouts/$<

rsync:
	rsync $(RSYNC_OPTS) . $(WEB)/doc/slides/
