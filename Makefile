# Documenation Makefile
# Edward Loper
# 
# Created [05/24/01 09:54 PM]
#

all:
	$(MAKE) -C tutorial
	$(MAKE) -C misc
	$(MAKE) -C technical

clean:
	$(MAKE) -C tutorial clean
	$(MAKE) -C misc clean
	$(MAKE) -C technical clean

pdf:
	$(MAKE) -C tutorial pdf
	$(MAKE) -C misc pdf
	$(MAKE) -C technical pdf

ps:
	$(MAKE) -C tutorial ps
	$(MAKE) -C misc ps
	$(MAKE) -C technical ps

dvi:
	$(MAKE) -C tutorial dvi
	$(MAKE) -C misc dvi
	$(MAKE) -C technical dvi

html:
	$(MAKE) -C tutorial html
	$(MAKE) -C misc html
	$(MAKE) -C technical html

