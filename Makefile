# Documenation Makefile
# Edward Loper
# 
# Created [05/24/01 09:54 PM]
#

all: tutorial ref tech


tutorial:
	$(MAKE) -C tutorial

ref:
	$(MAKE) -C ref

tech:
	$(MAKE) -C tech

clean:
	$(MAKE) -C tutorial clean
	$(MAKE) -C ref clean
	$(MAKE) -C tech clean

pdf:
	$(MAKE) -C tutorial pdf
	$(MAKE) -C ref pdf
	$(MAKE) -C tech pdf

ps:
	$(MAKE) -C tutorial ps
	$(MAKE) -C ref ps
	$(MAKE) -C tech ps

dvi:
	$(MAKE) -C tutorial dvi
	$(MAKE) -C ref dvi
	$(MAKE) -C tech dvi

