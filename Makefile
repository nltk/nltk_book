# Natural Language Toolkit: Documentation Makefile
#
# Copyright (C) 2001 University of Pennsylvania
# Author: Edward Loper <edloper@gradient.cis.upenn.edu>
# URL: <http://nltk.sourceforge.net>
# For license information, see LICENSE.TXT
#
# $Id$

# What's the current version of NLTK?
NLTK_VERSION = 1.1a

# Where is the web page hosted on the web?
NLTK_URL = http://nltk.sourceforge.net
WEBHOST_NAME = shell.sourceforge.net
WEBHOST_DIR = /home/groups/n/nl/nltk/htdocs

# (Local) output directory for reference (API) documentation.  
REFDOC_DIR = reference
CONTRIB_REFDOC_DIR = contrib

# Options for epydoc.  Consider switching to --inheritance=included
# later.
EPYDOC_OPTS = -n nltk --navlink "nltk $(NLTK_VERSION)" -u $(NLTK_URL)

# The location of extra (static) html files to include in the
# webpage.
STATIC_HTML_DIR = webpage

# The output location for the constructed webpage.
WEBPAGE_DIR = built_webpage
WEBPAGE_REF_DIR = $(WEBPAGE_DIR)/ref
WEBPAGE_CONTRIB_REF_DIR = $(WEBPAGE_DIR)/contrib_ref
WEBPAGE_TECH_DIR = $(WEBPAGE_DIR)/tech
WEBPAGE_TUTORIAL_DIR = $(WEBPAGE_DIR)/tutorial
WEBPAGE_PSET_DIR = $(WEBPAGE_DIR)/psets

# Python script to generate webpage indices
INDEXGEN = ../src/webpage_index.py

# Python executable and Epydoc executables.
PYTHON = python
EPYDOC = epydoc

############################################################
##  You shouldn't have to change anything below here.
############################################################

# The Python source files for which reference documentation should
# be built.
SOURCES = $(shell find ../src/nltk -name '*.py')

# Find the tutorial documents & technical documents.
TUTORIAL_DOCS = $(basename $(notdir $(wildcard tutorial/*/*.info)))
TECHNICAL_DOCS = $(basename $(notdir $(wildcard technical/*/*.info)))

# Declare phony targets
.PHONY: all usage help clean tutorial misc technical reference
.PHONY: webpage html

all: tutorial misc technical reference

usage: help
help: 
	@echo
	@echo "Usage:"
	@echo "    make all       -- Build all documentation (does not"\
	                            "include the webpage)"
	@echo "    make clean     -- Remove all built files"
	@echo
	@echo "    make tutorial  -- Build tutorial documentation"
	@echo "    make misc      -- Build miscellaneous documentation"
	@echo "    make technical -- Build technical documentation"
	@echo "    make reference -- Build reference documentation"
	@echo
	@echo "    make webpage   -- Build the web page (in $(WEBPAGE_DIR))"
	@echo "    make xfer      -- Build the web page and upload it"\
	                            "to $(WEBHOST_NAME)"
	@echo

clean:
	$(MAKE) -C tutorial clean
	$(MAKE) -C misc clean
	$(MAKE) -C technical clean
	rm -rf $(REFDOC_DIR) $(CONTRIB_REFDOC_DIR)
	rm -rf $(WEBPAGE_DIR)

##//////////////////////////////////////////////////
##  Keep track of which directories exist.

WEBPAGE_DIR_EXISTS = $(WEBPAGE_DIR)/.exists
REFDOC_DIR_EXISTS = $(REFDOC_DIR)/.exists
CONTRIB_REFDOC_DIR_EXISTS = $(CONTRIB_REFDOC_DIR)/.exists
WEBPAGE_REF_DIR_EXISTS = $(WEBPAGE_REF_DIR)/.exists
WEBPAGE_CONTRIB_REF_DIR_EXISTS = $(WEBPAGE_CONTRIB_REF_DIR)/.exists
WEBPAGE_TECH_DIR_EXISTS = $(WEBPAGE_TECH_DIR)/.exists
WEBPAGE_TUTORIAL_DIR_EXISTS = $(WEBPAGE_TUTORIAL_DIR)/.exists
WEBPAGE_PSET_DIR_EXISTS = $(WEBPAGE_PSET_DIR)/.exists

# Keep track of whether the refdocs are up to date, so we don't
# have to rebuild them.
REFDOC_UPTODATE = $(REFDOC_DIR)/.uptodate
CONTRIB_REFDOC_UPTODATE = $(CONTRIB_REFDOC_DIR)/.uptodate

##//////////////////////////////////////////////////
##  Basic Documentation types.

tutorial:
	$(MAKE) -C tutorial all

misc:
	$(MAKE) -C misc all

technical:
	$(MAKE) -C technical all

reference: $(REFDOC_UPTODATE) $(CONTRIB_REFDOC_UPTODATE)
$(REFDOC_UPTODATE): $(REFDOC_DIR_EXISTS) $(SOURCES)
	rm -rf $(REFDOC_DIR)/*
	$(EPYDOC) $(EPYDOC_OPTS) -o $(REFDOC_DIR) ../src/nltk
	touch $(REFDOC_UPTODATE)
$(CONTRIB_REFDOC_UPTODATE): $(CONTRIB_REFDOC_DIR_EXISTS) $(CONTRIB_SOURCES)
	rm -rf $(CONTRIB_REFDOC_DIR)/*
	$(EPYDOC) $(EPYDOC_CONTRIB_OPTS) -o $(CONTRIB_REFDOC_DIR) \
	       ../src/nltk_contrib
	touch $(CONTRIB_REFDOC_UPTODATE)

##//////////////////////////////////////////////////
##  Web page generation

.PHONY: $(TUTORIAL_DOCS)
_copy_tutorial: $(TUTORIAL_DOCS)
	@echo "[Copying tutorial documentation]"
	@$(PYTHON) $(INDEXGEN) tutorial tutorial \
	       $(WEBPAGE_TUTORIAL_DIR)/index.html
	@cp tutorial/tutorial_index.html $(WEBPAGE_TUTORIAL_DIR)
$(TUTORIAL_DOCS): 
	@cp -R tutorial/$@/$@ $(WEBPAGE_TUTORIAL_DIR)
	@cp tutorial/$@/$@.pdf $(WEBPAGE_TUTORIAL_DIR)

.PHONY: $(TECHNICAL_DOCS)
_copy_technical: $(TECHNICAL_DOCS)
	@echo "[Copying technical documentation]"
	@$(PYTHON) $(INDEXGEN) technical technical \
	       $(WEBPAGE_TECH_DIR)/index.html
$(TECHNICAL_DOCS): 
	@cp -R technical/$@/$@.ps $(WEBPAGE_TECH_DIR)
	@cp technical/$@/$@.pdf $(WEBPAGE_TECH_DIR)

_copy_static:
	@echo "[Copying static html]"
	@cp -R $(STATIC_HTML_DIR)/* $(WEBPAGE_DIR)

_copy_reference:
	@echo "[Copying reference documentation]"
	@cp -R $(REFDOC_DIR)/* $(WEBPAGE_REF_DIR)
	@cp -R $(CONTRIB_REFDOC_DIR)/* $(WEBPAGE_CONTRIB_REF_DIR)

_copy_psets:
	@echo "[Copying problem sets]"
	@$(PYTHON) $(INDEXGEN) psets ../psets \
	       $(WEBPAGE_PSET_DIR)/index.html

# To be safe, erase the webpage dir before building it.
_erase_webpage_dir:
	rm -rf $(WEBPAGE_DIR)/*

_erase_cvs:
	rm -rf $(WEBPAGE_DIR)/CVS

_webpage: _erase_webpage_dir \
	  $(WEBPAGE_DIR_EXISTS) $(WEBPAGE_CONTRIB_REF_DIR_EXISTS) \
          $(WEBPAGE_TECH_DIR_EXISTS) $(WEBPAGE_PSET_DIR_EXISTS) \
          $(WEBPAGE_TUTORIAL_DIR_EXISTS) $(WEBPAGE_REF_DIR_EXISTS) \
          _copy_static _copy_technical _copy_tutorial _copy_reference \
	  _copy_psets _erase_cvs

web: webpage
html: webpage
#webpage: technical tutorial reference full_reference _webpage
webpage: technical tutorial reference _webpage

##//////////////////////////////////////////////////
##  Web page transfer

webpage.tar: webpage
	(cd $(WEBPAGE_DIR); tar -cf ../webpage.tar *)

webpage.tar.gz: webpage.tar
	rm -f webpage.tar.gz
	gzip webpage.tar

xfer: webpage
	rsync -arz -e ssh $(WEBPAGE_DIR)/* $(WEBHOST_NAME):$(WEBHOST_DIR)

old_xfer: webpage.tar.gz
	scp webpage.tar.gz $(WEBHOST_NAME):$(WEBHOST_DIR)
	ssh $(WEBHOST_NAME) "(cd $(WEBHOST_DIR);\
	                      gunzip webpage.tar.gz;\
	                      tar -xf webpage.tar;\
	                      rm -rf webpage.tar)"

##//////////////////////////////////////////////////
##  Build directories, if they don't exist.

%/.exists:
	mkdir -p $*
	touch $*/.exists
$(WEBPAGE_DIR)/%/.exists:
	mkdir -p $(WEBPAGE_DIR)/$*
	touch $(WEBPAGE_DIR)/$*/.exists

