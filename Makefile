# Natural Language Toolkit: Documentation Makefile
#
# Copyright (C) 2001 University of Pennsylvania
# Author: Edward Loper <edloper@gradient.cis.upenn.edu>
# URL: <http://nltk.sf.net>
# For license information, see LICENSE.TXT
#
# $Id$

# Where is the web page hosted on the web?
WEBHOST_NAME = shell.sf.net
WEBHOST_DIR = /home/groups/n/nl/nltk/htdocs

# The Python source files for which reference documentation should be
# built.
SOURCES = ../src/nltk/*.py ../src/nltk/*/*.py 

# Output directory for reference documentation
REFDOC_DIR = reference

# The location of extra (static) html files to include in the
# webpage.
STATIC_HTML_DIR = webpage

# The output location for the constructed webpage.
WEBPAGE_DIR = html
WEBPAGE_REF_DIR = $(WEBPAGE_DIR)/ref
WEBPAGE_TECH_DIR = $(WEBPAGE_DIR)/tech
WEBPAGE_TUTORIAL_DIR = $(WEBPAGE_DIR)/tutorial
WEBPAGE_PSET_DIR = $(WEBPAGE_DIR)/psets

# Python script to generate webpage indices
INDEXGEN = ../src/webpage_index.py

# Python executable and Epydoc executable.
PYTHON = python
EPYDOC = epydoc

# Options for epydoc.  Add "-p" to include private objects.
EPYDOC_OPTS = -v -n nltk -u http://nltk.sf.net

# Find the tutorial documents & technical documents.
TUTORIAL_DOCS = $(shell cd tutorial;ls */*.info |sed 's/[/][^/]*\.info//')
TECHNICAL_DOCS = $(shell cd technical;ls */*.info |sed 's/[/][^/]*\.info//')

############################################################
##  You shouldn't have to change anything below here.
############################################################

# Declare phony targets
.PHONY: all usage help clean tutorial misc technical reference
.PHONY: webpage

all: tutorial misc technical reference

usage: help
help: 
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
	@echo "    make webpage   -- Build the web page"
	@echo "    make xfer      -- Build the web page and upload it"\
	                            "to $(WEBHOST_NAME)"
	@echo

clean:
	$(MAKE) -C tutorial clean
	$(MAKE) -C misc clean
	$(MAKE) -C technical clean
	rm -rf $(REFDOC_DIR)
	rm -rf $(WEBPAGE_DIR)

##//////////////////////////////////////////////////
##  Keep track of which directories exist.

WEBPAGE_DIR_EXISTS = $(WEBPAGE_DIR)/.exists
REFDOC_DIR_EXISTS = $(REFDOC_DIR)/.exists
WEBPAGE_REF_DIR_EXISTS = $(WEBPAGE_REF_DIR)/.exists
WEBPAGE_TECH_DIR_EXISTS = $(WEBPAGE_TECH_DIR)/.exists
WEBPAGE_TUTORIAL_DIR_EXISTS = $(WEBPAGE_TUTORIAL_DIR)/.exists
WEBPAGE_PSET_DIR_EXISTS = $(WEBPAGE_PSET_DIR)/.exists

##//////////////////////////////////////////////////
##  Basic Documentation types.

tutorial:
	$(MAKE) -C tutorial all

misc:
	$(MAKE) -C misc all

technical:
	$(MAKE) -C technical all

reference: $(REFDOC_DIR_EXISTS)
	$(EPYDOC) $(EPYDOC_OPTS) -o $(REFDOC_DIR) \
	       $(SOURCES)

##//////////////////////////////////////////////////
##  Web page generation

.PHONY: $(TUTORIAL_DOCS)
_copy_tutorial: $(TUTORIAL_DOCS)
	@echo "[Copying tutorial documentation]"
	@$(PYTHON) $(INDEXGEN) tutorial tutorial \
	       $(WEBPAGE_TUTORIAL_DIR)/index.html
$(TUTORIAL_DOCS): 
	@cp -R tutorial/$@/$@ $(WEBPAGE_TUTORIAL_DIR)
	@cp tutorial/$@/$@.pdf $(WEBPAGE_TUTORIAL_DIR)
	@ln -s ../../stylesheet-images $(WEBPAGE_TUTORIAL_DIR)/$@

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

_copy_psets:
	@echo "[Copying problem sets]"
	@$(PYTHON) $(INDEXGEN) psets ../psets \
	       $(WEBPAGE_PSET_DIR)/index.html

_webpage: $(WEBPAGE_DIR_EXISTS) $(WEBPAGE_REF_DIR_EXISTS) \
          $(WEBPAGE_TECH_DIR_EXISTS) $(WEBPAGE_PSET_DIR_EXISTS) \
          $(WEBPAGE_TUTORIAL_DIR_EXISTS) _copy_static \
	  _copy_technical _copy_tutorial _copy_reference \
	  _copy_psets

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

$(WEBPAGE_DIR_EXISTS):
	mkdir $(WEBPAGE_DIR) 2>/dev/null || true
	touch $(WEBPAGE_DIR_EXISTS)

$(REFDOC_DIR_EXISTS):
	mkdir $(REFDOC_DIR) 2>/dev/null || true
	touch $(REFDOC_DIR_EXISTS)

$(WEBPAGE_REF_DIR_EXISTS):
	mkdir $(WEBPAGE_REF_DIR) 2>/dev/null || true
	touch $(WEBPAGE_REF_DIR_EXISTS)

$(WEBPAGE_TECH_DIR_EXISTS):
	mkdir $(WEBPAGE_TECH_DIR) 2>/dev/null || true
	touch $(WEBPAGE_TECH_DIR_EXISTS)

$(WEBPAGE_TUTORIAL_DIR_EXISTS):
	mkdir $(WEBPAGE_TUTORIAL_DIR) 2>/dev/null || true
	touch $(WEBPAGE_TUTORIAL_DIR_EXISTS)

$(WEBPAGE_PSET_DIR_EXISTS):
	mkdir $(WEBPAGE_PSET_DIR) 2>/dev/null || true
	touch $(WEBPAGE_PSET_DIR_EXISTS)
