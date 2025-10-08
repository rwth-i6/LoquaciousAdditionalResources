#!/bin/bash
set -vex

cat loquacious.txt | tr ' ' '\n' | sort | uniq -c > loquacious.counts.txt
cat loquacious.counts.txt | awk '{print $2}' | sort > loquacious.words.txt

# extract words that appear both in the training data and in cmudict
comm -12 loquacious.words.txt cmudict.words.txt > cmudict.loquacious-intersection-words.txt
cat loquacious.counts.txt | awk '{if($1>=4){print $2}}' > loquacious.min-4-occurences-words.txt
cat cmudict.loquacious-intersection-words.txt loquacious.min-4-occurences-words.txt | sort | uniq > loquacious.vocab.txt
comm -23 loquacious.vocab.txt cmudict.words.txt > nondict.words.txt

g2p.py -e utf-8 -V 1.0 --variants-number 2 -m g2p_model_5 -a nondict.words.txt > nondict.g2p.txt
