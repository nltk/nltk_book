# Technical report Makefile
# Edward Loper
# 
# Created [05/24/01 09:54 PM]

##############################################
##  The name of the report
REPORT = reptypes

##############################################
##  Figure dependancies
reptypes.dvi: tree.eps treetoken.eps badtree.eps
reptypes.dvi: tree-impl.eps treetoken-impl.eps
reptypes.dvi: containership.eps dependencies.eps

##############################################
##  You shouldn't have to change anything below here.

# Find the name of the dvi and ps files.
DVI := $(REPORT).dvi
PS := $(REPORT).ps
PDF := $(REPORT).pdf

# Top-level rules.
dvi: $(DVI)
ps: $(PS)
pdf: $(PDF)
clean:
	rm -f *.eps *.log *.aux *.dvi *.ps *.toc *.pdf

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

%.pdf: %.ps
	ps2pdf $< $@
