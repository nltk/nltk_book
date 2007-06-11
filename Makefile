# NLTK: Tutorial Makefile
#
# Copyright (C) 2001-2007 University of Pennsylvania
# Author: Steven Bird <sb@csse.unimelb.edu.au>
#         Edward Loper <edloper@gradient.cis.upenn.edu>
# URL: <http://nltk.sf.net>
# For license information, see LICENSE.TXT

WEB = stevenbird@shell.sourceforge.net:/home/groups/n/nl/nltk/htdocs

RST2HTML = rst2html.py

STYLESHEET_PATH = .

EPYDOC_OPTS = --name=nltk --navlink="nltk $(NLTK_VERSION)"\
              --url=$(NLTK_URL) --inheritance=listed
RSYNC_OPTS = -arvz -e ssh --relative --cvs-exclude

.SUFFIXES: .txt .html

.PHONY: en pt-br slides api rsync .api.done

all: en slides api

clean:	clean_up
	rm -rf api
	$(MAKE) -C en clean
	$(MAKE) -C pt-br clean
	$(MAKE) -C slides clean

clean_up:
	rm -f *.log *.aux *.tex *.out *.errs *~
	$(MAKE) -C en clean_up
	$(MAKE) -C pt-br clean_up
	$(MAKE) -C slides clean_up

.txt.html:
	$(RST2HTML) --stylesheet-path=$(STYLESHEET_PATH) $< > $@

en:
	$(MAKE) -C en all

pt-br:
	$(MAKE) -C pt-br all

slides:
	$(MAKE) -C slides

api:	.api.done
	epydoc $(EPYDOC_OPTS) -o api ../nltk
	touch .api.done

rsync:
	rsync $(RSYNC_OPTS) . $(WEB)/doc/

rsync-api:
	rsync $(RSYNC_OPTS) api $(WEB)/doc/
