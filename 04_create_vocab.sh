#!/bin/bash
set -vex

# create a file containing all words with the respective word count
cat loquacious.txt | tr ' ' '\n' | sort | uniq -c > loquacious.counts.txt

# create a file containing all unique words only
cat loquacious.counts.txt | awk '{print $2}' | sort > loquacious.words.txt

# extract words that appear both in the training data and in cmudict
comm -12 loquacious.words.txt cmudict.words.txt > cmudict.loquacious-intersection-words.txt

# take only the words that appear at least 4 times in the Loquacious corpus
cat loquacious.counts.txt | awk '{if($1>=4){print $2}}' > loquacious.min-4-occurences-words.txt

# merge both the cmudict intersection words and the mininum 4 times appearing words and store this as sorted unique word vocab
cat cmudict.loquacious-intersection-words.txt loquacious.min-4-occurences-words.txt | sort | uniq > loquacious.vocab.txt

# extract all words of the final vocab that have no CMUDict pronunciation entry
comm -23 loquacious.vocab.txt cmudict.words.txt > nondict.words.txt

# run Sequitur G2P for those words
g2p.py -e utf-8 -V 1.0 --variants-number 2 -m g2p_model_5 -a nondict.words.txt > nondict.g2p.txt
