from pprint import pprint

from nltk_lite.parse import cfg
grammar = cfg.parse_grammar("""
S -> NP VP
PP -> P NP
NP -> Det N | NP PP 
VP -> V NP | VP PP
Det -> 'the'
N -> 'kids' | 'box' | 'floor'
V -> 'opened' 
P -> 'on' 
""")

sent = "the kids opened the box on the floor"
tokens = sent.split()

def init_wfst(tokens, grammar):
    numtokens = len(tokens)
    wfst = []
    for i in range(numtokens+1):
        wfst.append([''] * (numtokens+1))
    for i in range(numtokens):
        prod_rhs = grammar.productions(rhs=tokens[i])
        wfst[i][i+1] = prod_rhs[0].lhs()
    return wfst

def display(wfst, tokens):
    numfields = len(wfst)
    hline = "   " + "=" * 5 * len(tokens)
    print
    print '    ' + ' '.join([("%-4d" % i) for i in range(1, numfields)])
    print hline
    for i in range(numfields-1):
        rownum = i
        print "%d| " % rownum,
        for j in range(1, numfields):
            print "%-4s" % wfst[i][j],
        print "|"
    print hline
        
wfst0 = init_wfst(tokens, grammar)
display(wfst0, tokens)
    
index = {}
for prod in grammar.productions():
    index[prod.rhs()] = prod.lhs()

#pprint(index)

def complete_wfst(wfst, tokens, index, trace=True):
    numtokens = len(tokens)
    for span in range(2, numtokens+1):
        for start in range(numtokens+1-span):
            end = start + span
            for mid in range(start+1, end):
                nt1 = wfst[start][mid]
                nt2 = wfst[mid][end]
                if (nt1,nt2) in index:
                    nt3 = index[(nt1,nt2)]
                    if trace:
                        print "[%s] %3s [%s] %3s [%s] ==> [%s] %3s [%s]" % \
                        (start, nt1, mid, nt2, end, start, nt3, end)
                    wfst[start][end] = index[(nt1,nt2)]
    return wfst

wfst1 = complete_wfst(wfst0, tokens, index)

display(wfst1, tokens)
####pprint(wfst1)

