# Technical report Makefile
# Edward Loper
# 
# Created [05/24/01 09:54 PM]
#
# To add a new report, add its name to the "REPORTS" variable, and put
# any figure dependancies under the "Figure dependencies" section.

# A list of the technical reports
REPORTS = proposal reptypes

all: dvi

# Figure dependancies
reptypes.tex: tree.eps treetoken.eps badtree.eps
reptypes.tex: tree-impl.eps treetoken-impl.eps
reptypes.tex: containership.eps dependencies.eps

# Top-level rules.
DVI := $(REPORTS:=.dvi)
PS := $(REPORTS:=.ps)

dvi: $(DVI)
ps: $(PS)
clean:
	rm -f *.eps *.log *.aux *.dvi *.ps *.toc

# General rules
%.dvi: %.tex
	latex $<
	latex $<

%.ps: %.dvi
	dvips -t letter -o $@ $<

%.eps: %.dot
	dot -Tps -o $@ $<

%.eps: %.obj
	tgif -print -eps $<

