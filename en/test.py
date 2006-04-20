from nltk_lite.corpora import cmudict
from string import join
for word, num, pron in cmudict.raw():
    if pron[-4:] == ('N', 'IH0', 'K', 'S'):
        print word, "/", ' '.join(pron)
