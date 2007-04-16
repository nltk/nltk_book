from pylab import *
from nltk_lite.probability import ConditionalFreqDist
from nltk_lite.corpora import brown

def count_words_by_tag(t, genres):
    cfdist = ConditionalFreqDist()
    for genre in genres:                       # each genre
        for sent in brown.tagged(genre):       # each sentence
            for (word,tag) in sent:            # each tagged token
                if tag == t:                   # found a word tagged t
                     cfdist[genre].inc(word.lower())
    return cfdist

def bar_chart(cfdist, genres, words):
    ind = arange(len(words))
    colors = 'rgbcmyk' * 3
    width = 1.0 / (len(genres)+1)
    bar_groups = []
    for g in range(len(genres)):
        counts = [cfdist[genres[g]].count(w) for w in words]
        bars = bar(ind+g*width, counts, width, color=colors[g])
        bar_groups.append(bars)
    xticks(ind+width, words)
    legend([b[0] for b in bar_groups], [brown.item_name[g][:18] for g in genres], loc='upper left')
    ylabel('Frequency')
    title('Frequency of Six Modal Verbs by Genre')
    show()
        
genres = ['a', 'd', 'e', 'h', 'n']
cfdist = count_words_by_tag('md', genres)
bar_chart(cfdist, genres, ['can', 'could', 'may', 'might', 'must', 'will'])
