# Technical report Makefile
# Edward Loper
# 
# Created [05/24/01 09:54 PM]
#
# To add a new report, add its name to the "REPORTS" variable.

##############################################
##  A list of all the reports.
REPORTS = proposal reptypes

##############################################
##  You shouldn't have to change anything below here.

DVI := $(REPORTS:=.dvi)
PS := $(REPORTS:=.ps)
PDF := $(REPORTS:=.pdf)
CLEAN := $(REPORTS:=.clean)

all: dvi
dvi: $(DVI)
ps: $(PS)
pdf: $(PDF)
clean: $(CLEAN)

%.pdf: %
	$(MAKE) -C $< pdf

%.ps: %
	$(MAKE) -C $< ps

%.dvi: %
	$(MAKE) -C $< dvi

%.clean: %
	echo $(CLEAN)
	$(MAKE) -C $< clean

