from nltk_lite.parse import bracket_parse
sent = '(S (NP the policeman)(VP (V saw)(NP (NP the burglar)(PP with a gun))))'
tree =  bracket_parse(sent)
tree.draw()
