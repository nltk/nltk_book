# Natural Language Toolkit: Documentation Makefile
#
# Copyright (C) 2001 University of Pennsylvania
# Author: Edward Loper <edloper@gradient.cis.upenn.edu>
# URL: <http://nltk.sf.net>
# For license information, see LICENSE.TXT
#
# $Id$

# What's the current version of NLTK?
NLTK_VERSION = 0.5

# Where is the web page hosted on the web?
WEBHOST_NAME = shell.sf.net
WEBHOST_DIR = /home/groups/n/nl/nltk/htdocs

# (Local) output directory for reference documentation.  REFDOC_DIR
# contains just public objects; FULLREFDOC_DIR contains private
# objects as well.
REFDOC_DIR = reference
FULLREFDOC_DIR = fullreference

# Options for epydoc.  Use -css to specify a CSS stylesheet (see
# epydoc for more info)
EPYDOC_OPTS = -vv -n 'nltk&nbsp;$(NLTK_VERSION)' -u http://nltk.sf.net
EPYDOC_FULLREF_OPTS = -vv -n 'nltk&nbsp;$(NLTK_VERSION)' \
                      -u http://nltk.sf.net -p -css2

# The location of extra (static) html files to include in the
# webpage.
STATIC_HTML_DIR = webpage

# The output location for the constructed webpage.
WEBPAGE_DIR = html/
WEBPAGE_REF_DIR = $(WEBPAGE_DIR)/ref
WEBPAGE_TECH_DIR = $(WEBPAGE_DIR)/tech
WEBPAGE_TUTORIAL_DIR = $(WEBPAGE_DIR)/tutorial
WEBPAGE_PSET_DIR = $(WEBPAGE_DIR)/psets
WEBPAGE_FULLREF_DIR = $(WEBPAGE_DIR)/fullref

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
SOURCES = $(wildcard ../src/nltk/*.py ../src/nltk/*/*.py)

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
	@echo "    make fullref   -- Build full reference documentation"
	@echo
	@echo "    make webpage   -- Build the web page (in $(WEBPAGE_DIR))"
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
FULLREFDOC_DIR_EXISTS = $(FULLREFDOC_DIR)/.exists
WEBPAGE_REF_DIR_EXISTS = $(WEBPAGE_REF_DIR)/.exists
WEBPAGE_TECH_DIR_EXISTS = $(WEBPAGE_TECH_DIR)/.exists
WEBPAGE_TUTORIAL_DIR_EXISTS = $(WEBPAGE_TUTORIAL_DIR)/.exists
WEBPAGE_PSET_DIR_EXISTS = $(WEBPAGE_PSET_DIR)/.exists
WEBPAGE_FULLREF_DIR_EXISTS = $(WEBPAGE_FULLREF_DIR)/.exists

# Keep track of whether the refdocs are up to date, so we don't
# have to rebuild them.
REFDOC_UPTODATE = $(REFDOC_DIR)/.uptodate
FULLREFDOC_UPTODATE = $(FULLREFDOC_DIR)/.uptodate

##//////////////////////////////////////////////////
##  Basic Documentation types.

tutorial:
	$(MAKE) -C tutorial all

misc:
	$(MAKE) -C misc all

technical:
	$(MAKE) -C technical all

reference: $(REFDOC_UPTODATE)
$(REFDOC_UPTODATE): $(REFDOC_DIR_EXISTS) $(SOURCES)
	$(EPYDOC) $(EPYDOC_OPTS) -o $(REFDOC_DIR) $(SOURCES)
	touch $(REFDOC_UPTODATE)

fullref: full_reference
full_reference: $(FULLREFDOC_UPTODATE)
$(FULLREFDOC_UPTODATE): $(FULLREFDOC_DIR_EXISTS) $(SOURCES)
	$(EPYDOC) $(EPYDOC_FULLREF_OPTS) -o $(FULLREFDOC_DIR) $(SOURCES)
	touch $(FULLREFDOC_UPTODATE)

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
	@ln -f -s ../../stylesheet-images $(WEBPAGE_TUTORIAL_DIR)/$@ 

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

_copy_full_reference:
	@echo "[Copying full reference documentation]"
	@cp -R $(FULLREFDOC_DIR)/* $(WEBPAGE_FULLREF_DIR)

_copy_psets:
	@echo "[Copying problem sets]"
	@$(PYTHON) $(INDEXGEN) psets ../psets \
	       $(WEBPAGE_PSET_DIR)/index.html

_webpage: $(WEBPAGE_DIR_EXISTS) $(WEBPAGE_REF_DIR_EXISTS) \
          $(WEBPAGE_TECH_DIR_EXISTS) $(WEBPAGE_PSET_DIR_EXISTS) \
          $(WEBPAGE_TUTORIAL_DIR_EXISTS) $(WEBPAGE_FULLREF_DIR_EXISTS) \
          _copy_static _copy_technical _copy_tutorial _copy_reference \
	  _copy_full_reference _copy_psets

web: webpage
html: webpage
webpage: technical tutorial reference full_reference _webpage

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
	mkdir -p $(WEBPAGE_DIR)
	touch $(WEBPAGE_DIR_EXISTS)

$(REFDOC_DIR_EXISTS):
	mkdir -p $(REFDOC_DIR)
	touch $(REFDOC_DIR_EXISTS)

$(WEBPAGE_REF_DIR_EXISTS):
	mkdir -p $(WEBPAGE_REF_DIR)
	touch $(WEBPAGE_REF_DIR_EXISTS)

$(WEBPAGE_TECH_DIR_EXISTS):
	mkdir -p $(WEBPAGE_TECH_DIR)
	touch $(WEBPAGE_TECH_DIR_EXISTS)

$(WEBPAGE_TUTORIAL_DIR_EXISTS):
	mkdir -p $(WEBPAGE_TUTORIAL_DIR)
	touch $(WEBPAGE_TUTORIAL_DIR_EXISTS)

$(WEBPAGE_PSET_DIR_EXISTS):
	mkdir -p $(WEBPAGE_PSET_DIR)
	touch $(WEBPAGE_PSET_DIR_EXISTS)

$(FULLREFDOC_DIR_EXISTS):
	mkdir -p $(FULLREFDOC_DIR)
	touch $(FULLREFDOC_DIR_EXISTS)

$(WEBPAGE_FULLREF_DIR_EXISTS):
	mkdir -p $(WEBPAGE_FULLREF_DIR)
	touch $(WEBPAGE_FULLREF_DIR_EXISTS)

